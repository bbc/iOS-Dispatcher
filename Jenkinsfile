node('Xcode7 || iOS-VM-xcode7') {
	stage 'Checkout Source'
	checkout scm

	stage 'OS X Tests'
	xcodebuildWithArguments('-project Dispatcher.xcodeproj -scheme \'Dispatcher (OS X)\' clean test')

	stage 'iOS Tests'
	xcodebuildWithArguments('-project Dispatcher.xcodeproj -scheme \'Dispatcher (iOS)\' -destination \'platform=iOS Simulator,name=iPhone 6\' clean test')

	stage 'tvOS Tests'
	xcodebuildWithArguments('-project Dispatcher.xcodeproj -scheme \'Dispatcher (tvOS)\' -destination \'platform=tvOS Simulator,name=Apple TV 1080p\' clean test')
}

def xcodebuildWithArguments(args) {
	wrap([$class: 'AnsiColorBuildWrapper', colorMapName: "xterm"]) {
		sh 'xcodebuild ' + args
	}
}
