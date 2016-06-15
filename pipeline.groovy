///////////////////////////////////////////////////////////////////////////////
// KEYS
///////////////////////////////////////////////////////////////////////////////

PrepareWorkspaceStage = 'Prepare Workspace'
UnitTestsStage = 'Unit Tests'
LintPodspecStage = 'Lint Podspec'
PromoteVersionStage = 'Promote Version'
LibraryReleaseStage = 'Library Release'
PreparePromotionBadgeStage = 'Prepare Promotion Badge'

VersionNumberKey = 'majorVersionNumber'

// Temporarily lock running builds on a node we know for sure has Swift 2.3
BuildNodeIdentifier = 'MCE-iOS-10.11 - 2'
GitNodeIdentifier = 'git'
CocoapodsNodeIdentifier = 'Cocoapods-1'


///////////////////////////////////////////////////////////////////////////////
// PIPELINE
///////////////////////////////////////////////////////////////////////////////

initializeMajorReleaseNumber()

stage PrepareWorkspaceStage
node(GitNodeIdentifier) {
    prepareWorkspace()
}

stage UnitTestsStage
// performNonPromotionStageWithNode(BuildNodeIdentifier) {
//     runUnitTests()
// }

stage LintPodspecStage
// performNonPromotionStageWithNode(CocoapodsNodeIdentifier) {
//     lintPodspec()
// }

stage PromoteVersionStage
node(CocoapodsNodeIdentifier) {
    promoteVersionNumbers(mobileCiSupport.isPromotion())
}

stage LibraryReleaseStage
node(BuildNodeIdentifier) {
	performLibraryRelease(mobileCiSupport.isPromotion())
}

stage PreparePromotionBadgeStage
if(mobileCiSupport.isPromotion()) {
    manager.addShortText('RELEASED v' + getMajorReleaseNumber() + ".${env.BUILD_NUMBER}")
}
else {
    stagePromotion {
        message 'Promote?'
    }
}


///////////////////////////////////////////////////////////////////////////////
// FUNCTIONS
///////////////////////////////////////////////////////////////////////////////

def performNonPromotionStageWithNode(slaveTags, closure) {
    if(mobileCiSupport.isPromotion()) {
        echo 'Skipping stage as build is being promoted'
    }
    else {
        node(slaveTags) { closure() }
    }
}

def getMajorReleaseNumber() {
    def releaseNumber = mobileCiSupport.retrieve(VersionNumberKey)
    if(releaseNumber != null) {
        releaseNumber = releaseNumber.replaceAll("\\s", "")
    }

    return releaseNumber
}

def setMajorReleaseNumber(majorNumber) {
    mobileCiSupport.store(VersionNumberKey, majorNumber)
}

def setLastMajorReleaseHash(lastMajorReleaseHash) {
    mobileCiSupport.store(VersionHashKey, lastMajorReleaseHash)
}

def initializeMajorReleaseNumber() {
    def content = getMajorReleaseNumber()
    if(content == null || content == '') {
        content = '0'
        setMajorReleaseNumber(content)
    }

    return content
}

def withinSourcesDirectory(closure) {
    dir('sources') {
        closure()
    }
}

def stashSourcesDirectory() {
    stash includes: 'sources/**/*', name: 'sources', useDefaultExcludes: false
}

def obliterateWorkingDirectory() {
    echo 'Wiping out sources directory'
    sh 'rm -rf sources'
}

def unstashSourcesDirectory() {
    obliterateWorkingDirectory()
    unstash name: 'sources'
}

def prepareWorkspace() {
    obliterateWorkingDirectory()
    sh 'mkdir sources'

    withinSourcesDirectory {
        checkout scm
    }

    stashSourcesDirectory()
}

def runUnitTests() {
	unstashSourcesDirectory()

	echo 'Installing XCPretty'
	sh 'gem install xcpretty'

	withinSourcesDirectory {
		runUnitTests("Dispatcher (OS X)", "OS X")
		runUnitTests("Dispatcher (iOS)", "iOS Simulator,name=iPhone 6")
		runUnitTests("Dispatcher (tvOS)", "tvOS Simulator,name=Apple TV 1080p")

		// We can't run tests on watchOS, but lets at least make sure it builds...
		xcodebuild("Dispatcher (watchOS)", "watchOS Simulator,name=Apple Watch - 42mm", "clean build")
	}
}

def runUnitTests(scheme, platform) {
	try {
		xcodebuild(scheme, platform, "clean test")
    } catch (exc) {
        emailext attachLog: true,
                body: 'iOS-Dispatcher tests failed\n\nSee attached log for details',
                from: 'Androidplayer@bbc.co.uk',
                mimeType: 'text/plain',
                replyTo: 'thomas.sherwood@bbc.co.uk',
                subject: 'iOS-Dispatcher tests failed',
                to: 'thomas.sherwood@bbc.co.uk'

        throw exc
    }
}

def xcodebuild(scheme, platform, args)  {
	wrap([$class: 'AnsiColorBuildWrapper', colorMapName: "xterm"]) {
		echo "Building against scheme \"" + scheme + "\" on platform \"" + platform + "\", args: \"" + args + "\""
		sh 'xcodebuild -project Dispatcher.xcodeproj -scheme "' + scheme + '" -destination "platform=' + platform + '" ' + args + ' | tee build.log | xcpretty --color --report junit && exit ${PIPESTATUS[0]}'
	}
}

def lintPodspec() {
    withinSourcesDirectory {
        sh 'ls -al'
        sh 'pod lib lint --allow-warnings --verbose'
    }
}

def promoteVersionNumbers(isPromotion) {
    unstashSourcesDirectory()

    if(isPromotion) {
        setMajorReleaseNumber((getMajorReleaseNumber().toInteger() + 1).toString())
    }

    withinSourcesDirectory {
    	def hash = mobileCiSupport.getFromHash()
        def tag = version()
        sh 'git tag ' + tag
        sh 'git push --tags --verbose'

		if(isPromotion) {
			def releaseBranchName = 'release/' + tag
			sh 'git checkout -b ' + releaseBranchName
            sh 'git push origin ' + releaseBranchName
			sh 'git checkout ' + hash
		}
    } 

    stashSourcesDirectory()
}

def performLibraryRelease(stable) {
    unstashSourcesDirectory()

    def version = version()

    withinSourcesDirectory {
        echo 'Building Universal binary'
        sh 'xcodebuild -project Dispatcher.xcodeproj -scheme "Dispatcher (iOS) Release" clean build'

        dir('products') {
            sh 'zip -yr Dispatcher.zip Dispatcher'
        }

        def libraryPath = 'products/Dispatcher.zip'
        def prerelease = stable ? 'false' : 'true'
        
        withCredentials([[$class: 'StringBinding', credentialsId: 'd6cbe7e1-7321-4714-8bb3-b4523749bd9e', variable: 'accessToken']]) {
            def accessToken = '$accessToken'
            sh "./GithubRelease.sh " + version + " " + libraryPath + " " + accessToken + " " + prerelease
        }
    }
}

def version() {
    def buildNumber = "${env.BUILD_NUMBER}"
    return getMajorReleaseNumber() + '.' + buildNumber
}

def buildNumber() {
    def buildNumber = "${env.BUILD_NUMBER}"
    return buildNumber
}
