Class {
	#name : 'Seaguller',
	#superclass : 'SpPresenter',
	#instVars : [
		'locationList'
	],
	#category : 'Seaguller-Core',
	#package : 'Seaguller-Core'
}

{ #category : 'instance creation' }
Seaguller class >> open [

	<script>
	^ self new open
]

{ #category : 'converting' }
Seaguller >> asJSON [

	^ Dictionary new
		  at: 'locations' put: (locationList items collect: #asJSON);
		  yourself
]

{ #category : 'layout' }
Seaguller >> defaultLayout [

	^ SpBoxLayout newVertical add: locationList
]

{ #category : 'initialization' }
Seaguller >> initialize [

	super initialize.
	self loadSettings
]

{ #category : 'initialization' }
Seaguller >> initializePresenters [

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
		                addColumn: ((SpImageTableColumn
				                  title: ''
				                  evaluated: [ :location | location actionIcon ])
				                 width: 20;
				                 yourself);
		                yourself
]

{ #category : 'initialization' }
Seaguller >> initializeWindow: aSpWindowPresenter [

	super initializeWindow: aSpWindowPresenter.
	aSpWindowPresenter
		title: 'Seaguller';
		initialExtent: 1024 @ 300
]

{ #category : 'operations-settings' }
Seaguller >> loadSettings [

	FileLocator seaguller / 'settings.json' ifExists: [ :ref |
		ref readStreamDo: [ :stream |
			([ STONJSON fromStream: stream ]
				 on: Exception
				 do: [ :ex |
					 self alert: 'Failed to load settings.'.
					 ex return: nil ]) ifNotNil: [ :json | self setJSON: json ] ] ]
]

{ #category : 'operations-settings' }
Seaguller >> saveSettings [

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
Seaguller >> setJSON: aDictionary [

	aDictionary at: 'location' ifPresent: [ :locations |
		locationList items: (locations collect: [ :location |
				 SeagullerLocation fromJSON: location ]) ]
]
