Class {
	#name : 'Seagull',
	#superclass : 'SpPresenter',
	#instVars : [
		'locationList',
		'openDownloadsButton',
		'refreshLocationListButton',
		'moveUpLocationButton',
		'moveDownLocationButton',
		'addLocationButton',
		'stepProcess'
	],
	#category : 'Seagull-Core-UI',
	#package : 'Seagull-Core',
	#tag : 'UI'
}

{ #category : 'examples' }
Seagull class >> example [

	^ self new
		  locations: {
				  (SeagullLocation name: 'Example' url: 'https://example.com/').
				  (SeagullLocation
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

{ #category : 'operations' }
Seagull >> addLocation [

	| newLocation presenter |
	newLocation := SeagullLocation example.
	presenter := newLocation asPresenter.
	presenter nameValidationBlock: [ :name |
		name notEmpty and: [
			((locationList items collect: #name) includes: name) not ] ].
	presenter openDialog okAction: [
		presenter accept.
		self addLocation: newLocation ]
]

{ #category : 'operations' }
Seagull >> addLocation: aSeagullLocation [

	| items index |
	items := locationList items.
	((items collect: #name) includes: aSeagullLocation name) ifTrue: [
		^ self ].
	index := locationList selection selectedIndex.
	index = 0 ifTrue: [ index := items size + 1 ].
	locationList items:
		(items copyFrom: 1 to: index - 1) , { aSeagullLocation }
		, (items copyFrom: index to: items size)
]

{ #category : 'converting' }
Seagull >> asJSON [

	^ Dictionary new
		  at: 'locations' put: (locationList items collect: #asJSON);
		  yourself
]

{ #category : 'bugfix' }
Seagull >> confirm: queryString label: titleString [

	^ self application newConfirm
		  title: titleString;
		  label: queryString;
		  openModal
]

{ #category : 'layout' }
Seagull >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: locationList;
		  add: (SpBoxLayout newHorizontal
				   add: addLocationButton expand: false;
				   add: moveUpLocationButton expand: false;
				   add: moveDownLocationButton expand: false;
				   add: (SpBoxLayout newHorizontal hAlignEnd
						    add: refreshLocationListButton expand: false;
						    add: openDownloadsButton expand: false);
				   yourself)
		  expand: false;
		  yourself
]

{ #category : 'accessing' }
Seagull >> downloadDirectory [

	^ FileLocator seagullHome / 'Downloads'
]

{ #category : 'operations' }
Seagull >> editLocation: aSeagullLocation [

	| presenter |
	presenter := aSeagullLocation asPresenter.
	presenter nameValidationBlock: [ :name |
		name notEmpty and: [
			(((locationList items copyWithout: aSeagullLocation) collect: #name)
				 includes: name) not ] ].
	presenter openModal okAction: [ presenter accept ]
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
		                hideColumnHeaders;
		                addColumn: ((SpImageTableColumn
				                  title: ''
				                  evaluated: [ :location | location statusIcon ])
				                 beNotExpandable;
				                 width: 20;
				                 yourself);
		                addColumn:
			                ((SpStringTableColumn
				                  title: 'name'
				                  evaluated: [ :location |
					                  location name asText
						                  addAttribute: (TextFontReference toFont:
									                   (LogicalFont
										                    familyName: 'Source Sans Pro'
										                    pointSize: 12) realFont);
						                  yourself ])
				                 displayColor: [ :location | location color ];
				                 displayBackgroundColor: [ :location |
				                 location backgroundColor ];
				                 width: 400;
				                 yourself);
		                addColumn:
			                ((SpStringTableColumn
				                  title: ''
				                  evaluated: [ :location |
					                  (location timeToPoll truncateTo: 1 second)
						                  asString asText
						                  addAttribute: (TextFontReference toFont:
									                   (LogicalFont
										                    familyName: 'Source Sans Pro'
										                    pointSize: 12) realFont);
						                  yourself ])
				                 width: 100;
				                 yourself);
		                addColumn: ((SeagullButtonTableColumn
				                  title: ''
				                  evaluated: [ :item | item actionButtonIcon ])
				                 action: [ :item | item doAction ];
				                 width: 120;
				                 yourself);
		                addColumn: ((SeagullButtonTableColumn
				                  title: ''
				                  evaluated: [ :item | self iconNamed: #dropDown ])
				                 action: [ :item | self openLocationMenuFor: item ];
				                 width: 20;
				                 yourself);
		                whenModelChangedDo: [ :newLocatons :oldLocations |
			                oldLocations do: [ :location |
				                self unregister: location ].
			                newLocatons do: [ :location |
				                self register: location ].
			                self updateButtons.
			                self saveSettings ];
		                whenSelectedItemChangedDo: [ self updateButtons ];
		                yourself.
	addLocationButton := self newButton
		                     icon: (self iconNamed: #add);
		                     action: [ self addLocation ];
		                     yourself.
	moveUpLocationButton := self newButton
		                        icon: (self iconNamed: #up);
		                        action: [ self moveUpLocation ];
		                        yourself.
	moveDownLocationButton := self newButton
		                          icon: (self iconNamed: #down);
		                          action: [ self moveDownLocation ];
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
		                       yourself.
	locationList whenBuiltDo: [
		locationList withAdapterDo: [ :a |
			a widgetDo: [ :w | w intercellSpacing: 0 @ 0 ] ].
		self startStepping ]
]

{ #category : 'initialization' }
Seagull >> initializeWindow: aSpWindowPresenter [

	super initializeWindow: aSpWindowPresenter.
	aSpWindowPresenter
		title: 'Seagull';
		initialExtent: 700 @ 300
]

{ #category : 'testing' }
Seagull >> isDisplayed [

	self withAdapterDo: [ :a | a widgetDo: [ :w | ^ w world notNil ] ].
	^ false
]

{ #category : 'stepping' }
Seagull >> isStepping [

	^ stepProcess notNil and: [ stepProcess isRunning ]
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

{ #category : 'menus' }
Seagull >> locationMenuFor: aSeagullLocation [

	^ self newMenu
		  addGroup: [ :group |
			  group
				  addItem: [ :item |
					  item
						  icon: aSeagullLocation updateButtonIcon;
						  name: 'Check';
						  action: [ aSeagullLocation doUpdateAction ] ];
				  addItem: [ :item |
					  item
						  icon: aSeagullLocation downloadButtonIcon;
						  name: 'Download';
						  action: [ aSeagullLocation doDownloadAction ] ];
				  addItem: [ :item |
					  item
						  icon: aSeagullLocation openButtonIcon;
						  name: 'Open';
						  action: [ aSeagullLocation doOpenAction ] ] ];
		  addGroup: [ :group |
			  group
				  addItem: [ :item |
					  item
						  icon: (self iconNamed: #configuration);
						  name: 'Configure...';
						  action: [ self editLocation: aSeagullLocation ] ];
				  addItem: [ :item |
					  item
						  icon: (self iconNamed: #delete);
						  name: 'Clear';
						  action: [
							  (self
								   confirm: 'Clear all cache and download file?'
								   label: 'Seagull') ifTrue: [
									  aSeagullLocation clearTimestampAndFile ] ] ];
				  addItem: [ :item |
					  item
						  icon: (self iconNamed: #remove);
						  name: 'Remove';
						  action: [
							  (self
								   confirm: 'Remove ' , aSeagullLocation name , '?'
								   label: 'Seagull') ifTrue: [
									  self removeLocation: aSeagullLocation ] ] ] ];
		  yourself
]

{ #category : 'updating' }
Seagull >> locationSettingsChanged: aSeagullLocation [

	self saveSettings.
	locationList refresh
]

{ #category : 'updating' }
Seagull >> locationStartedDownloading: aSeagullLocation [

	locationList refresh
]

{ #category : 'updating' }
Seagull >> locationStatusChanged: aSeagullLocation [

	self saveSettings.
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
Seagull >> moveDownLocation [

	| index items item |
	index := locationList selection selectedIndex.
	index < 1 ifTrue: [ ^ self ].
	items := locationList items.
	index >= items size ifTrue: [ ^ self ].
	item := items at: index + 1.
	items at: index + 1 put: (items at: index).
	items at: index put: item.
	locationList items: items
]

{ #category : 'operations' }
Seagull >> moveUpLocation [

	| index items item |
	index := locationList selection selectedIndex.
	index < 2 ifTrue: [ ^ self ].
	items := locationList items.
	item := items at: index - 1.
	items at: index - 1 put: (items at: index).
	items at: index put: item.
	locationList items: items
]

{ #category : 'operations' }
Seagull >> openDownloads [

	SeagullOSUtils openFile: self downloadDirectory
]

{ #category : 'operations' }
Seagull >> openLocationMenuFor: aSeagullLocation [

	(self locationMenuFor: aSeagullLocation) openWithSpecAtPointer
]

{ #category : 'operations' }
Seagull >> refreshLocations [

	locationList items do: [ :location | location doUpdateAction ]
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

{ #category : 'operations' }
Seagull >> removeLocation: aSeagullLocation [

	locationList items:
		(locationList items copyWithout: aSeagullLocation)
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

	aDictionary at: 'locations' ifPresent: [ :locations |
		locationList items:
			(locations collect: [ :location |
				 SeagullLocation fromJSON: location ]) ]
]

{ #category : 'stepping' }
Seagull >> startStepping [

	(stepProcess notNil and: [ stepProcess isRunning ]) ifTrue: [
		stepProcess terminate ].
	stepProcess := [
	               [ self isDisplayed ] whileTrue: [
		               self step.
		               1 second wait ].
	               stepProcess := nil ] forkAt:
		               Processor userBackgroundPriority
]

{ #category : 'stepping' }
Seagull >> step [

	locationList items do: #poll.
	locationList refresh
]

{ #category : 'stepping' }
Seagull >> stopStepping [

	(stepProcess notNil and: [ stepProcess isRunning ]) ifFalse: [
		^ self ].
	stepProcess terminate.
	stepProcess := nil
]

{ #category : 'registration' }
Seagull >> unregister: aSeagullLocation [

	aSeagullLocation announcer unsubscribe: self
]

{ #category : 'updating' }
Seagull >> updateButtons [

	| selectedIndex |
	selectedIndex := locationList selection selectedIndex.
	moveUpLocationButton enabled: selectedIndex >= 2.
	moveDownLocationButton enabled:
		(selectedIndex > 0 and: [ selectedIndex < locationList items size ])
]
