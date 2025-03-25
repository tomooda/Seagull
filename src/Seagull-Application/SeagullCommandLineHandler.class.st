Class {
	#name : 'SeagullCommandLineHandler',
	#superclass : 'CommandLineHandler',
	#category : 'Seagull-Application',
	#package : 'Seagull-Application'
}

{ #category : 'accessing' }
SeagullCommandLineHandler class >> codename [

	^ 'Hamanako'
]

{ #category : 'accessing' }
SeagullCommandLineHandler class >> commandName [

	^ 'Seagull'
]

{ #category : 'scripts' }
SeagullCommandLineHandler class >> deploy [

	<script>
	MCRepositoryGroup allSubInstancesDo: [ :group |
		group repositories do: [ :repo | group removeRepository: repo ] ].
	IceRepository registry removeAll.
	IceCredentialStore current in: [ :store |
		store allCredentials do: [ :each | each removeFrom: store ] ].
	self currentWorld closeAllWindowsDiscardingChanges.
	Deprecation
		raiseWarning: false;
		showWarning: false.
	NoChangesLog install.
	"NoPharoFilesOpener install."
	FFICompilerPlugin install.
	Stdio useNullStreams.
	MCCacheRepository uniqueInstance disable.
	EpMonitor reset.
	SessionManager default registerSystemClassNamed: #FreeTypeFileInfo.
	5 timesRepeat: [ "PharoCommandLineHandler forcePreferencesOmission: true"
		Smalltalk garbageCollect ]
]

{ #category : 'scripts' }
SeagullCommandLineHandler class >> generate [

	<script: 'SeagullCommandLineHandler generate'>
	PhleeterOnOSX new
		properties: {
				(#AppName -> 'Seagull').
				(#InfoString -> 'Web update watcher').
				(#BundleIdentifier -> 'com.github.Seagull').
				(#ShortVersion -> self codename).
				(#DisplayName -> ('Seagull ' , self codename)).
				(#CodesignName -> 'Seagull').
				(#IconSetFile
				 ->
					 ((IceRepository repositoryNamed: 'Seagull') location
					  / 'resources' / 'Seagull.icns')).
				(#DiskIconSetFile
				 ->
					 ((IceRepository repositoryNamed: 'Seagull') location
					  / 'resources' / 'Seagull-disk.icns')).
				(#CommandLineHandler -> self commandName).
				(#CompanyName -> 'Seagull project').
				(#DeployPharoExpression -> 'SeagullCommandLineHandler deploy') }
				asDictionary;
		addExternalDirectory:
			(IceRepository repositoryNamed: 'Seagull') location / 'resources'
		destination: 'pharo-local/Seagull';
		outputDirectory: FileLocator home / 'src' / 'Seagull' / 'build';
		generate
]

{ #category : 'activation' }
SeagullCommandLineHandler >> activate [

	self
		installQuitSession;
		installNativeWindow;
		installMenu;
		setupWindow.
	self currentWorld
		layoutPolicy: ProportionalLayout new;
		addMorph: Seagull new build fullFrame: (0 @ 0 extent: 1 @ 1)
]

{ #category : 'activation' }
SeagullCommandLineHandler >> installMenu [

	OSWindowDriver current startUp: true.
	OSPlatform current isMacOSX ifTrue: [
		| main |
		main := CocoaMenu new.
		main
			title: 'MainMenu';
			addSubmenu: 'Seagull' with: [ :m |
				m
					addItemWithTitle: 'Quit'
					action: [ Smalltalk snapshot: false andQuit: true ] ];
			addSubmenu: 'File'
			with: [ :m | m addItemWithTitle: 'Open' action: [ Seagull open ] ].
		main setAsMainMenu ]
]

{ #category : 'activation' }
SeagullCommandLineHandler >> installNativeWindow [

	Smalltalk at: #SpPresenter ifPresent: [ :class |
		class class compile:
			'open self build openInExternalWindow; layoutFrame: (0@0 corner: 1@1)' ]
]

{ #category : 'activation' }
SeagullCommandLineHandler >> installQuitSession [

	Smalltalk at: #WorldState ifPresent: [ :class |
		class class compile:
			'quitSession Smalltalk snapshot: false andQuit: true' ]
]

{ #category : 'activation' }
SeagullCommandLineHandler >> setupWindow [

	self currentWorld submorphs copy do: [ :e | e delete ].
	self currentWorld worldState worldRenderer ifNotNil: [ :renderer |
		renderer windowTitle: 'Seagull'.
		renderer osWindow extent: 700 @ 300.
		OSWindowRenderThread createdWindow: renderer osWindow ]
]
