Class {
	#name : 'Seagull',
	#superclass : 'SpPresenter',
	#instVars : [
		'locationList',
		'openDownloadsButton',
		'refreshLocationListButton'
	],
	#category : 'Seagull-Core-UI',
	#package : 'Seagull-Core',
	#tag : 'UI'
}

{ #category : 'examples' }
Seagull class >> example [

	^ self new
		  locations: {
				  (SeagullDownloadLocation
					   name: 'Example'
					   url: 'https://example.com/').
				  (SeagullDownloadLocation
					   name: 'ViennaTalk-dev'
					   url:
						   'https://viennatalk.org/builds/viennatalk/dev/ViennaTalk-Installer-Darwin-arm64.dmg') };
		  open
]

{ #category : 'instance creation' }
Seagull class >> open [

	<script>
	^ self new open
]

{ #category : 'converting' }
Seagull >> asJSON [

	^ Dictionary new
		  at: 'locations' put: (locationList items collect: #asJSON);
		  yourself
]

{ #category : 'layout' }
Seagull >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: locationList;
		  add: (SpBoxLayout newHorizontal
				   add: refreshLocationListButton expand: false;
				   add: openDownloadsButton expand: false;
				   yourself)
		  expand: false;
		  yourself
]

{ #category : 'accessing' }
Seagull >> downloadDirectory [

	^ FileLocator seagullHome / 'Downloads'
]

{ #category : 'initialization' }
Seagull >> initialize [

	super initialize.
	self loadSettings
]

{ #category : 'initialization' }
Seagull >> initializePresenters [

	super initializePresenters.
	locationList := self newTable
		                beResizable;
		                addColumn: ((SpImageTableColumn
				                  title: ''
				                  evaluated: [ :location | location statusIcon ])
				                 beNotExpandable;
				                 yourself);
		                addColumn: ((SpStringTableColumn
				                  title: 'name'
				                  evaluated: [ :location | location name ])
				                 beExpandable;
				                 yourself);
		                addColumn: ((SpStringTableColumn
				                  title: ''
				                  evaluated: [ :location | location interval ])
				                 width: 100;
				                 yourself);
		                addColumn: ((SeagullButtonTableColumn
				                  title: ''
				                  evaluated: [ :item | item updateButtonIcon ])
				                 action: [ :item | item doUpdateAction ];
				                 beNotExpandable;
				                 yourself);
		                addColumn: ((SeagullButtonTableColumn
				                  title: ''
				                  evaluated: [ :item | item downloadButtonIcon ])
				                 action: [ :item |
					                 [ item doDownloadAction ] forkAt:
							                 Processor userBackgroundPriority ];
				                 beNotExpandable;
				                 yourself);
		                addColumn: ((SeagullButtonTableColumn
				                  title: ''
				                  evaluated: [ :item | item openButtonIcon ])
				                 action: [ :item | item doOpenAction ];
				                 beNotExpandable;
				                 yourself);
		                whenModelChangedDo: [ :newLocatons :oldLocations |
			                oldLocations do: [ :location |
				                self unregister: location ].
			                newLocatons do: [ :location |
				                self register: location ] ];
		                yourself.
	refreshLocationListButton := self newButton
		                             icon:
			                             (self iconNamed: #refreshCircling);
		                             action: [ self refreshLocations ];
		                             yourself.
	openDownloadsButton := self newButton
		                       icon: (self iconNamed: #open);
		                       label: 'Downloads';
		                       action: [ self openDownloads ];
		                       yourself
]

{ #category : 'initialization' }
Seagull >> initializeWindow: aSpWindowPresenter [

	super initializeWindow: aSpWindowPresenter.
	aSpWindowPresenter
		title: 'Seaguller';
		initialExtent: 1024 @ 300
]

{ #category : 'operations-settings' }
Seagull >> loadSettings [

	FileLocator seagullHome / 'settings.json' ifExists: [ :ref |
		ref readStreamDo: [ :stream |
			([ STONJSON fromStream: stream ]
				 on: Exception
				 do: [ :ex |
					 self alert: 'Failed to load settings.'.
					 ex return: nil ]) ifNotNil: [ :json | self setJSON: json ] ] ]
]

{ #category : 'updating' }
Seagull >> locationEndedDownloading: aSeagullLocation [

	locationList refresh
]

{ #category : 'updating' }
Seagull >> locationSettingsChanged: aSeagullLocation [

	locationList refresh
]

{ #category : 'updating' }
Seagull >> locationStartedDownloading: aSeagullLocation [

	locationList refresh
]

{ #category : 'updating' }
Seagull >> locationStatusChanged: aSeagullLocation [

	locationList refresh
]

{ #category : 'accessing' }
Seagull >> locations [

	^ locationList items
]

{ #category : 'accessing' }
Seagull >> locations: aCollectionOfSeagullLocation [

	locationList items: aCollectionOfSeagullLocation asArray
]

{ #category : 'operations' }
Seagull >> openDownloads [

	SeagullOSUtils openFile: self downloadDirectory
]

{ #category : 'operations' }
Seagull >> refreshLocations [

	locationList refresh
]

{ #category : 'registration' }
Seagull >> register: aSeagullLocation [

	aSeagullLocation announcer
		when: SeagullLocationStatusChanged
		do: [ :announcement |
			self locationStatusChanged: announcement location ]
		for: self;
		when: SeagullLocationSettingsChanged
		do: [ :announcement |
			self locationSettingsChanged: announcement location ]
		for: self;
		when: SeagullLocationStartDownloading do: [ :announcement |
			self locationStartedDownloading: announcement location ]
		for: self;
		when: SeagullLocationEndDownloading do: [ :announcement |
			self locationEndedDownloading: announcement location ]
		for: self
]

{ #category : 'operations-settings' }
Seagull >> saveSettings [

	[
	FileLocator seagullHome / 'settings.json.tmp' writeStreamDo: [
		:stream |
		stream truncate.
		STONJSON put: self asJSON onStreamPretty: stream ].
	FileLocator seagullHome / 'settings.json' ifExists: [ :ref |
		ref renameTo: 'settings.json.old' ].
	FileLocator seagullHome / 'settings.json.tmp' renameTo:
		'settings.json'.
	(FileLocator seagullHome / 'settings.json.old') ensureDelete ]
		on: Exception
		do: [ :ex |
			self alert: 'Failed to save settings data.'.
			ex return: nil ]
]

{ #category : 'private' }
Seagull >> setJSON: aDictionary [

	aDictionary at: 'location' ifPresent: [ :locations |
		locationList items: (locations collect: [ :location |
				 SeagullLocation fromJSON: location ]) ]
]

{ #category : 'registration' }
Seagull >> unregister: aSeagullLocation [

	aSeagullLocation announcer unsubscribe: self
]
