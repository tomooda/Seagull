Class {
	#name : 'SeagullLocation',
	#superclass : 'Object',
	#instVars : [
		'name',
		'interval',
		'lastModifiedTimeOnServer',
		'lastAccessTime',
		'lastOpenTime',
		'hasDeadUrl',
		'isDownloading',
		'lock',
		'httpClient'
	],
	#classInstVars : [
		'downloadingIcon',
		'readyToOpenIcon',
		'readyToUpdateIcon',
		'notReadyToOpenIcon',
		'notReadyToUpdateIcon',
		'readyToDownloadIcon',
		'notReadyToDownloadIcon'
	],
	#category : 'Seagull-Core-Locations',
	#package : 'Seagull-Core',
	#tag : 'Locations'
}

{ #category : 'icons' }
SeagullLocation class >> downloadingIcon [

	^ downloadingIcon ifNil: [
		  | reload box icon |
		  reload := ((Smalltalk ui iconNamed: #refreshCircling) magnifyBy:
			             0.8) darker: 0.3.
		  box := (Smalltalk ui iconNamed: #box) lighter: 0.2.
		  icon := Form extent: 16 @ 16 depth: 32.
		  icon getCanvas
			  fillColor: Color transparent;
			  drawImage: box at: 0 @ 0;
			  translucentImage: reload at: box extent - reload extent;
			  flush.
		  downloadingIcon := icon ]
]

{ #category : 'instance creation' }
SeagullLocation class >> fromJSON: aDictionary [

	^ self new
		  setJSON: aDictionary;
		  yourself
]

{ #category : 'testing' }
SeagullLocation class >> isAbstract [

	^ self = SeagullLocation
]

{ #category : 'instance creation' }
SeagullLocation class >> name: aString url: aZnUrl [

	^ self new
		  name: aString;
		  url: aZnUrl;
		  yourself
]

{ #category : 'icons' }
SeagullLocation class >> notReadyToDownloadIcon [

	^ notReadyToDownloadIcon ifNil: [
		  notReadyToDownloadIcon := (self readyToDownloadIcon
			                             asFormOfDepth: 32) collectColors: [ :c |
			                            | v |
			                            v := c red + c green + c blue / 3.0.
			                            Color
				                            r: v
				                            g: v
				                            b: v
				                            alpha: (c alpha min: 0.3) ] ]
]

{ #category : 'icons' }
SeagullLocation class >> notReadyToOpenIcon [

	^ notReadyToOpenIcon ifNil: [
		  notReadyToOpenIcon := (self readyToOpenIcon asFormOfDepth: 32)
			                        collectColors: [ :c |
				                        | v |
				                        v := c red + c green + c blue / 3.0.
				                        Color
					                        r: v
					                        g: v
					                        b: v
					                        alpha: (c alpha min: 0.3) ] ]
]

{ #category : 'icons' }
SeagullLocation class >> notReadyToUpdateIcon [

	^ notReadyToUpdateIcon ifNil: [
		  notReadyToUpdateIcon := (self readyToUpdateIcon asFormOfDepth: 32)
			                          collectColors: [ :c |
				                          | v |
				                          v := c red + c green + c blue / 3.0.
				                          Color
					                          r: v
					                          g: v
					                          b: v
					                          alpha: (c alpha min: 0.3) ] ]
]

{ #category : 'icons' }
SeagullLocation class >> readyToDownloadIcon [

	^ readyToDownloadIcon ifNil: [
		  readyToDownloadIcon := self iconNamed: #box ]
]

{ #category : 'icons' }
SeagullLocation class >> readyToOpenIcon [

	^ readyToOpenIcon ifNil: [ readyToOpenIcon := self iconNamed: #go ]
]

{ #category : 'icons' }
SeagullLocation class >> readyToUpdateIcon [

	^ readyToUpdateIcon ifNil: [
		  readyToOpenIcon := self iconNamed: #refreshCircling ]
]

{ #category : 'converting' }
SeagullLocation >> asJSON [

	^ Dictionary new
		  at: 'name' put: self name asString;
		  at: 'url' put: self url asString;
		  at: 'interval' put: self interval asString;
		  at: 'lastModifiedTimeOnServer'
		  put: self lastModifiedTimeOnServer asString;
		  at: 'lastAccessTime' put: self lastAccessTime asString;
		  at: 'hasDeadUrl' put: self hasDeadUrl;
		  yourself
]

{ #category : 'operations' }
SeagullLocation >> doDownloadAction [

	^ self subclassResponsibility
]

{ #category : 'operations' }
SeagullLocation >> doOpenAction [

	^ self subclassResponsibility
]

{ #category : 'operations' }
SeagullLocation >> doPollingAction [

	^ self subclassResponsibility
]

{ #category : 'operations' }
SeagullLocation >> doUpdateAction [

	^ self subclassResponsibility
]

{ #category : 'operations' }
SeagullLocation >> download [

	^ self downloadFileReferenceDo: [ :fileReference |
		  self httpClientDo: [ :client |
			  client get.
			  lastAccessTime := DateAndTime now.
			  client response ifNotNil: [ :response |
				  response isSuccess ifTrue: [
					  lastModifiedTimeOnServer := (response headers
						                               at: 'Last-Modified'
						                               ifAbsent: [ nil ])
						                              ifNotNil: [ :string |
						                              ZnUtils parseHttpDate: string ]
						                              ifNil: [ lastAccessTime ].
					  client downloadEntityTo: fileReference.
					  ^ true ].
				  response isNotModified ifTrue: [ ^ false ] ].
			  SeagullDeadUrl signal ] ]
]

{ #category : 'icons' }
SeagullLocation >> downloadButtonIcon [

	^ self readyToDownload
		  ifTrue: [ self class readyToDownloadIcon ]
		  ifFalse: [ self class notReadyToDownloadIcon ]
]

{ #category : 'accessing' }
SeagullLocation >> downloadFileReferenceDo: aBlock [

	| ref |
	(name notNil and: [ name notEmpty ]) ifFalse: [ ^ self ].
	ref := (FileLocator seaguller / 'downloads') ensureCreateDirectory
	       / name asFileName.
	self url lastPathSegment ifNotNil: [ :basename |
		ref := ref withExtension: basename asFileReference extension ].
	aBlock value: ref
]

{ #category : 'icons' }
SeagullLocation >> downloadingIcon [

	^ self class downloadingIcon
]

{ #category : 'operations' }
SeagullLocation >> fetch [

	^ self httpClientDo: [ :client |
		  client head.
		  lastAccessTime := DateAndTime now.
		  client response ifNotNil: [ :response |
			  response isSuccess ifTrue: [
				  lastModifiedTimeOnServer := (response headers
					                               at: 'Last-Modified'
					                               ifAbsent: [ nil ])
					                              ifNotNil: [ :string |
					                              ZnUtils parseHttpDate: string ]
					                              ifNil: [ lastAccessTime ].
				  ^ true ].
			  response isNotModified ifTrue: [ ^ false ] ].
		  SeagullDeadUrl signal ]
]

{ #category : 'accessing' }
SeagullLocation >> hasDeadUrl [

	^ hasDeadUrl = true
]

{ #category : 'accessing' }
SeagullLocation >> hasDeadUrl: aBoolean [

	hasDeadUrl := aBoolean = true
]

{ #category : 'testing' }
SeagullLocation >> hasDownloadFile [

	self downloadFileReferenceDo: [ :ref | ^ ref exists ].
	^ false
]

{ #category : 'testing' }
SeagullLocation >> hasLatestDownloadFile [

	| serverTimestamp localTimestamp |
	serverTimestamp := self lastModifiedTimeOnServer.
	localTimestamp := self lastModifiedTimeOfDownloadFile.
	localTimestamp ifNil: [ ^ false ].
	serverTimestamp ifNil: [ ^ true ].
	^ serverTimestamp <= localTimestamp
]

{ #category : 'testing' }
SeagullLocation >> hasOutdatedDownloadFile [

	| serverTimestamp localTimestamp |
	serverTimestamp := self lastModifiedTimeOnServer.
	localTimestamp := self lastModifiedTimeOfDownloadFile.
	localTimestamp ifNil: [ ^ false ].
	serverTimestamp ifNil: [ ^ false ].
	^ localTimestamp < serverTimestamp
]

{ #category : 'testing' }
SeagullLocation >> hasUpdatesOnServerToOpen [

	| serverTimestamp localTimestamp |
	serverTimestamp := self lastModifiedTimeOnServer.
	localTimestamp := self lastOpenTime.
	localTimestamp ifNil: [ ^ true ].
	serverTimestamp ifNil: [ ^ true ].
	^ localTimestamp <= serverTimestamp
]

{ #category : 'http' }
SeagullLocation >> httpClientDo: aBlock [

	^ lock critical: [
		  lastModifiedTimeOnServer
			  ifNotNil: [
			  httpClient setIfModifiedSince: lastModifiedTimeOnServer ]
			  ifNil: [
				  httpClient request headers
					  removeKey: 'If-Modified-Since'
					  ifAbsent: [  ] ].
		  [ aBlock value: httpClient ]
			  on: Exception
			  do: [ :ex |
				  hasDeadUrl := true.
				  ex return: nil ] ]
]

{ #category : 'icons' }
SeagullLocation >> iconNamed: aSymbol [

	aSymbol = #downloading ifTrue: [ ^ self downloadingIcon ].
	^ super iconNamed: aSymbol
]

{ #category : 'initialization' }
SeagullLocation >> initialize [

	super initialize.
	name := String new.
	hasDeadUrl := false.
	isDownloading := false.
	lock := Semaphore forMutualExclusion.
	httpClient := ZnClient new
]

{ #category : 'accessing' }
SeagullLocation >> interval [

	^ interval
]

{ #category : 'accessing' }
SeagullLocation >> interval: aDuration [

	interval := aDuration
]

{ #category : 'testing' }
SeagullLocation >> isDownloading [

	^ isDownloading = true
]

{ #category : 'accessing' }
SeagullLocation >> lastAccessTime [

	^ lastAccessTime
]

{ #category : 'accessing' }
SeagullLocation >> lastAccessTime: aDateAndTime [

	lastAccessTime := aDateAndTime
]

{ #category : 'accessing' }
SeagullLocation >> lastModifiedTimeOfDownloadFile [

	self downloadFileReferenceDo: [ :ref |
		ref ifExists: [ ^ ref modificationTime ] ].
	^ nil
]

{ #category : 'accessing' }
SeagullLocation >> lastModifiedTimeOnServer [

	^ lastModifiedTimeOnServer
]

{ #category : 'accessing' }
SeagullLocation >> lastModifiedTimeOnServer: aDateAndTime [

	lastModifiedTimeOnServer := aDateAndTime
]

{ #category : 'accessing' }
SeagullLocation >> lastOpenTime [

	^ lastOpenTime
]

{ #category : 'accessing' }
SeagullLocation >> lastOpenTime: aDateAndTime [

	lastOpenTime := aDateAndTime
]

{ #category : 'accessing' }
SeagullLocation >> name [

	^ name
]

{ #category : 'accessing' }
SeagullLocation >> name: aString [

	name := aString asString
]

{ #category : 'icons' }
SeagullLocation >> openButtonIcon [

	^ self readyToOpen
		  ifTrue: [ self class readyToOpenIcon ]
		  ifFalse: [ self class notReadyToOpenIcon ]
]

{ #category : 'operations' }
SeagullLocation >> openFile [

	self isDownloading ifFalse: [
		OSPlatform current isMacOSX ifTrue: [ self openFileMacOS ] ]
]

{ #category : 'platform dependents' }
SeagullLocation >> openFileMacOS [

	self downloadFileReferenceDo: [ :ref |
		LibC system:
			('open ' , (self shellEscape: ref pathString)) asUTF8Bytes ]
]

{ #category : 'operations' }
SeagullLocation >> openUrl [

	OSPlatform current isMacOSX ifTrue: [ self openUrlMacOS ]
]

{ #category : 'platform dependents' }
SeagullLocation >> openUrlMacOS [

	LibC system:
		('open ' , (self shellEscape: self url asString)) asUTF8Bytes
]

{ #category : 'operations' }
SeagullLocation >> poll [

	(interval notNil and: [
		 lastAccessTime isNil or: [
			 interval < (DateAndTime now - lastAccessTime) ] ]) ifTrue: [
		self doPollingAction ]
]

{ #category : 'testing' }
SeagullLocation >> readyToDownload [

	^ self subclassResponsibility
]

{ #category : 'testing' }
SeagullLocation >> readyToOpen [

	^ self subclassResponsibility
]

{ #category : 'testing' }
SeagullLocation >> readyToUpdate [

	^ self subclassResponsibility
]

{ #category : 'private' }
SeagullLocation >> setJSON: aDictionary [

	aDictionary
		at: 'name' ifPresent: [ :string | self name: string ];
		at: 'url' ifPresent: [ :string | self url: string asZnUrl ];
		at: 'interval'
		ifPresent: [ :stringOrNil |
			self interval: (stringOrNil ifNotNil: #asDuration) ];
		at: 'lastModifiedTimeOnServer' ifPresent: [ :string |
			self lastModifiedTimeOnServer: (string ifNotNil: #asDateAndTime) ];
		at: 'lastAccessTime'
		ifPresent: [ :string |
			self lastAccessTime: (string ifNotNil: #asDateAndTime) ];
		at: 'hasDeadUrl'
		ifPresent: [ :bool | self hasDeadUrl: bool = true ]
]

{ #category : 'private' }
SeagullLocation >> shellEscape: aString [

	^ '''' , (aString copyReplaceAll: '''' with: '''"''"''') , ''''
]

{ #category : 'icons' }
SeagullLocation >> statusIcon [

	self hasDeadUrl ifTrue: [ ^ self iconNamed: #trash ].
	self isDownloading ifTrue: [ ^ self iconNamed: #downloading ].
	self hasDownloadFile ifTrue: [ ^ self iconNamed: #box ].
	^ self iconNamed: #empty
]

{ #category : 'icons' }
SeagullLocation >> updateButtonIcon [

	^ self readyToUpdate
		  ifTrue: [ self class readyToUpdateIcon ]
		  ifFalse: [ self class notReadyToUpdateIcon ]
]

{ #category : 'accessing' }
SeagullLocation >> url [

	^ httpClient url
]

{ #category : 'accessing' }
SeagullLocation >> url: aZnUrl [

	httpClient url: aZnUrl
]
