///////////////////////////////////////////////////////////////////////////////
// KEYS
///////////////////////////////////////////////////////////////////////////////

PrepareWorkspaceStage = 'Prepare Workspace'
UnitTestsStage = 'Unit Tests'
LintPodspecStage = 'Lint Podspec'

// Temporarily lock running builds on a node we know for sure has Swift 2.3
BuildNodeIdentifier = 'MCE-iOS-10.11 - 2'
GitNodeIdentifier = 'git'
CocoapodsNodeIdentifier = 'Cocoapods-1'


///////////////////////////////////////////////////////////////////////////////
// PIPELINE
///////////////////////////////////////////////////////////////////////////////

stage PrepareWorkspaceStage
node(GitNodeIdentifier) {
    prepareWorkspace()
}

stage UnitTestsStage
node(BuildNodeIdentifier) {
    runUnitTests()
}

stage LintPodspecStage
node(CocoapodsNodeIdentifier) {
    lintPodspec()
}


///////////////////////////////////////////////////////////////////////////////
// FUNCTIONS
///////////////////////////////////////////////////////////////////////////////

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
        git 'git@github.com:bbc/iOS-Dispatcher.git'
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
