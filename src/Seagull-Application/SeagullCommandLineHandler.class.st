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

{ #category : 'accessing' }
SeagullCommandLineHandler class >> generateMacOS [

	<script: 'ViennaCommandLineHandler generateMacOS'>
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
					  / 'resources' / 'disk.icns')).
				(#CommandLineHandler -> self commandName).
				(#CompanyName -> 'Seagull project').
				(#DeployPharoExpression -> 'BaselineOfSeagull deploy') }
				asDictionary;
		generate
]

{ #category : 'activation' }
SeagullCommandLineHandler >> activate [

	self
		installQuitSession;
		installMenu.
	Seagull open
]

{ #category : 'activation' }
SeagullCommandLineHandler >> installMenu [

	<script: 'ViennaCommandLineHandler new installMenu'>
	OSWindowDriver current startUp: true.
	OSPlatform current isMacOSX ifTrue: [
		| main |
		main := CocoaMenu new.
		main
			title: 'MainMenu';
			addSubmenu: 'Seagull'
			with: [ :m | m addItemWithTitle: 'Settings' action: [  ] ];
			addSubmenu: 'File'
			with: [ :m | m addItemWithTitle: 'Open' action: [ Seagull open ] ].
		main setAsMainMenu ]
]

{ #category : 'activation' }
SeagullCommandLineHandler >> installQuitSession [

	Smalltalk at: #WorldState ifPresent: [ :class |
		class class compile:
			'quitSession Smalltalk snapshot: false andQuit: true' ]
]
