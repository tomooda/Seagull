Class {
	#name : 'SeagullerLocation',
	#superclass : 'Object',
	#instVars : [
		'name',
		'action',
		'interval',
		'lastFetchTime',
		'hasLatestCopy',
		'hasDeadUrl',
		'isUpdating',
		'client',
		'lock'
	],
	#category : 'Seaguller-Core',
	#package : 'Seaguller-Core'
}

{ #category : 'instance creation' }
SeagullerLocation class >> fromJSON: aDictionary [

	^ self new
		  setJSON: aDictionary;
		  yourself
]

{ #category : 'instance creation' }
SeagullerLocation class >> name: aString url: aZnUrl [

	^ self new
		  name: aString;
		  url: aZnUrl;
		  yourself
]

{ #category : 'accessing' }
SeagullerLocation >> action [

	^ action
]

{ #category : 'accessing' }
SeagullerLocation >> action: aSymbol [

	action := aSymbol asSymbol
]

{ #category : 'accessing' }
SeagullerLocation >> actionIcon [

	action = #download ifTrue: [ ^ self iconNamed: #down ].
	action = #downloadAndOpen ifTrue: [ ^ self iconNamed: #go ].
	^ self iconNamed: #empty
]

{ #category : 'converting' }
SeagullerLocation >> asJSON [

	^ Dictionary new
		  at: 'name' put: self name asString;
		  at: 'url' put: self url asString;
		  at: 'action' put: self action asString;
		  at: 'interval' put: self interval asString;
		  at: 'lastFetchTime' put: self lastFetchTime asString;
		  at: 'hasLatestCopy' put: self hasLatestCopy;
		  at: 'hasDeadUrl' put: self hasDeadUrl;
		  yourself
]

{ #category : 'accessing' }
SeagullerLocation >> availableActions [

	^ #( doNothing download downloadAndOpen )
]

{ #category : 'accessing' }
SeagullerLocation >> client [

	^ client ifNil: [ client := ZnClient new ]
]

{ #category : 'controlling' }
SeagullerLocation >> critical: aBlock [

	^ lock critical: aBlock
]

{ #category : 'accessing' }
SeagullerLocation >> defaultAction [

	^ #doNothing
]

{ #category : 'accessing' }
SeagullerLocation >> defaultInterval [

	^ 1 day
]

{ #category : 'operations' }
SeagullerLocation >> download [

	self critical: [
		self downloadFileReferenceDo: [ :ref |
			isUpdating := true.
			self withIfModifiedSince.
			client downloadTo: ref.
			hasLatestCopy := true.
			isUpdating := false.
			lastFetchTime := DateAndTime now ] ]
]

{ #category : 'accessing' }
SeagullerLocation >> downloadFileReferenceDo: aBlock [

	(name notNil and: [ name notEmpty ]) ifTrue: [
		| ref |
		ref := (FileLocator seaguller / 'downloads') ensureCreateDirectory
		       / name asFileName.
		self url lastPathSegment ifNotNil: [ :basename |
			ref := ref withExtension: basename asFileReference extension ].
		aBlock value: ref ]
]

{ #category : 'operations' }
SeagullerLocation >> fetch [

	self critical: [
		self withIfModifiedSince.
		client head.
		hasLatestCopy := client response code = 304.
		hasDeadUrl := client response code >= 400.
		lastFetchTime := DateAndTime now ]
]

{ #category : 'operations' }
SeagullerLocation >> forceDownload [

	self critical: [
		self downloadFileReferenceDo: [ :ref |
			isUpdating := true.
			self withoutIfModifiedSince.
			client downloadTo: ref.
			hasLatestCopy := true.
			isUpdating := false.
			lastFetchTime := DateAndTime now ] ]
]

{ #category : 'accessing' }
SeagullerLocation >> hasDeadUrl [

	^ hasDeadUrl = true
]

{ #category : 'accessing' }
SeagullerLocation >> hasDeadUrl: aBoolean [

	hasDeadUrl := aBoolean = true
]

{ #category : 'testing' }
SeagullerLocation >> hasDownload [

	self downloadFileReferenceDo: [ :ref | ^ ref exists ].
	^ false
]

{ #category : 'accessing' }
SeagullerLocation >> hasLatestCopy [

	^ hasLatestCopy = true
]

{ #category : 'accessing' }
SeagullerLocation >> hasLatestCopy: aBoolean [

	hasLatestCopy := aBoolean = true
]

{ #category : 'accessing' }
SeagullerLocation >> icon [

	self hasDeadUrl ifTrue: [ ^ self iconNamed: #trash ].
	self isUpdating ifTrue: [ ^ self iconNamed: #refreshCircling ].
	^ self hasDownload
		  ifTrue: [
			  self hasLatestCopy
				  ifTrue: [ self iconNamed: #box ]
				  ifFalse: [ self iconNamed: #exception ] ]
		  ifFalse: [ self iconNamed: #empty ]
]

{ #category : 'initialize' }
SeagullerLocation >> initialize [

	super initialize.
	name := String new.
	action := self defaultAction.
	hasLatestCopy := false.
	hasDeadUrl := false.
	isUpdating := false.
	lock := Semaphore forMutualExclusion
]

{ #category : 'accessing' }
SeagullerLocation >> interval [

	^ interval
]

{ #category : 'accessing' }
SeagullerLocation >> interval: aDuration [

	interval := aDuration asDuration
]

{ #category : 'testing' }
SeagullerLocation >> isUpdating [

	^ isUpdating = true
]

{ #category : 'accessing' }
SeagullerLocation >> lastDownloadTime [

	self downloadFileReferenceDo: [ :ref |
		ref exists ifTrue: [ ^ ref modificationTime ] ].
	^ nil
]

{ #category : 'accessing' }
SeagullerLocation >> lastFetchTime [

	^ lastFetchTime
]

{ #category : 'accessing' }
SeagullerLocation >> lastFetchTime: aDateAndTime [

	lastFetchTime := aDateAndTime ifNotNil: #asDateAndTime
]

{ #category : 'accessing' }
SeagullerLocation >> name [

	^ name
]

{ #category : 'accessing' }
SeagullerLocation >> name: aString [

	name := aString asString
]

{ #category : 'operations' }
SeagullerLocation >> open [

	self critical: [
		OSPlatform current isMacOSX ifTrue: [ self openMacOS ] ]
]

{ #category : 'private' }
SeagullerLocation >> openMacOS [

	self downloadFileReferenceDo: [ :ref |
		LibC system: ('open ' , (self shellEscape: ref pathString)) asUTF8Bytes ]
]

{ #category : 'private' }
SeagullerLocation >> setJSON: aDictionary [

	aDictionary
		at: 'name' ifPresent: [ :string | self name: string ];
		at: 'url' ifPresent: [ :string | self url: string ];
		at: 'action' ifPresent: [ :string | self action: string ];
		at: 'interval' ifPresent: [ :string | self interval: string ];
		at: 'lastFetchTime'
		ifPresent: [ :string | self lastFetchTime: string ];
		at: 'hasLatestCopy'
		ifPresent: [ :string | self hasLatestCopy: string ];
		at: 'hasDeadUrl' ifPresent: [ :string | self hasDeadUrl: string ]
]

{ #category : 'private' }
SeagullerLocation >> shellEscape: aString [

	^ '''' , (aString copyReplaceAll: '''' with: '''"''"''') , ''''
]

{ #category : 'accessing' }
SeagullerLocation >> timeToFetch [

	^ lastFetchTime
		  ifNotNil: [ interval - (DateAndTime now - lastFetchTime) ]
		  ifNil: [ -1 second ]
]

{ #category : 'accessing' }
SeagullerLocation >> url [

	^ self client request url asZnUrl
]

{ #category : 'accessing' }
SeagullerLocation >> url: aZnUrl [

	self client url: aZnUrl asZnUrl
]

{ #category : 'private' }
SeagullerLocation >> withIfModifiedSince [

	self lastDownloadTime ifNotNil: [ :mtime |
		| utc |
		utc := mtime asUTC.
		self client
			headerAt: 'If-Modified-Since'
			put:
				('{day-name}, {day} {month} {year} {hour}:{minute}:{second} GMT'
					 format: {
							 ('day-name' -> utc dayOfWeekName).
							 ('day' -> utc dayOfMonth).
							 ('month' -> utc monthName).
							 ('year' -> utc year).
							 ('hour' -> utc hour).
							 ('minute' -> utc minute).
							 ('second' -> utc second) } asDictionary) ]
]

{ #category : 'private' }
SeagullerLocation >> withoutIfModifiedSince [

	self client request headers
		removeKey: 'If-Modified-Since'
		ifAbsent: [  ]
]
