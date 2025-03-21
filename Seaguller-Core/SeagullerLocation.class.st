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

{ #category : 'testing' }
SeagullerLocation >> hasDeadUrl [

	^ hasDeadUrl = true
]

{ #category : 'testing' }
SeagullerLocation >> hasDownload [

	self downloadFileReferenceDo: [ :ref | ^ ref exists ].
	^ false
]

{ #category : 'testing' }
SeagullerLocation >> hasLatestCopy [

	^ hasLatestCopy = true and: [ self hasDownload ]
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
SeagullerLocation >> shellEscape: aString [

	^ '''' , (aString copyReplaceAll: '''' with: '''"''"''') , ''''
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
