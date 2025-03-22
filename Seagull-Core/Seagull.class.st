Class {
	#name : 'Seagull',
	#superclass : 'SpPresenter',
	#instVars : [
		'locationList'
	],
	#category : 'Seagull-Core-UI',
	#package : 'Seagull-Core',
	#tag : 'UI'
}

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

	^ SpBoxLayout newVertical add: locationList
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
		                addColumn: ((SpImageTableColumn
				                  title: ''
				                  evaluated: [ :location | location icon ])
				                 width: 20;
				                 yourself);
		                addColumn: ((SpStringTableColumn
				                  title: 'name'
				                  evaluated: [ :location | location name ])
				                 width: 200;
				                 yourself);
		                addColumn: ((SpStringTableColumn
				                  title: 'url'
				                  evaluated: [ :location | location url ])
				                 beExpandable;
				                 yourself);
		                addColumn: ((SpStringTableColumn
				                  title: 'interval'
				                  evaluated: [ :location | location interval ])
				                 width: 100;
				                 yourself);
		                addColumn: ((SeagullButtonTableColumn
				                  title: ''
				                  evaluated: [ :item | item updateButtonIcon ])
				                 action: [ :item | item doUpdateAction ];
				                 width: 20;
				                 yourself);
		                addColumn: ((SeagullButtonTableColumn
				                  title: ''
				                  evaluated: [ :item | item downloadButtonIcon ])
				                 action: [ :item | item doDownloadAction ];
				                 width: 20;
				                 yourself);
		                addColumn: ((SeagullButtonTableColumn
				                  title: ''
				                  evaluated: [ :item | item openButtonIcon ])
				                 action: [ :item | item doOpenAction ];
				                 width: 20;
				                 yourself);
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

	FileLocator seaguller / 'settings.json' ifExists: [ :ref |
		ref readStreamDo: [ :stream |
			([ STONJSON fromStream: stream ]
				 on: Exception
				 do: [ :ex |
					 self alert: 'Failed to load settings.'.
					 ex return: nil ]) ifNotNil: [ :json | self setJSON: json ] ] ]
]

{ #category : 'operations-settings' }
Seagull >> saveSettings [

	[
	FileLocator seaguller / 'settings.json.tmp' writeStreamDo: [ :stream |
		stream truncate.
		STONJSON put: self asJSON onStreamPretty: stream ].
	FileLocator seaguller / 'settings.json' ifExists: [ :ref |
		ref renameTo: 'settings.json.old' ].
	FileLocator seaguller / 'settings.json.tmp' renameTo: 'settings.json'.
	(FileLocator seaguller / 'settings.json.old') ensureDelete ]
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
