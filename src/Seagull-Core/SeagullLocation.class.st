Class {
	#name : 'SeagullLocation',
	#superclass : 'Object',
	#instVars : [
		'name',
		'policy',
		'interval',
		'downloadDirectory',
		'lastModifiedTimeOnServer',
		'lastAccessTime',
		'lastOpenTime',
		'etag',
		'hasDeadUrl',
		'isDownloading',
		'lock',
		'httpClient',
		'announcer'
	],
	#classVars : [
		'DownloadingIcon',
		'NotReadyToDownloadIcon',
		'NotReadyToOpenIcon',
		'NotReadyToUpdateIcon',
		'ReadyToDownloadIcon',
		'ReadyToOpenIcon',
		'ReadyToUpdateIcon'
	],
	#category : 'Seagull-Core-Locations',
	#package : 'Seagull-Core',
	#tag : 'Locations'
}

{ #category : 'icons' }
SeagullLocation class >> downloadingIcon [

	^ DownloadingIcon ifNil: [
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
		  DownloadingIcon := icon ]
]

{ #category : 'instance creation' }
SeagullLocation class >> example [

	^ self name: 'Example' url: 'https://example.com/'
]

{ #category : 'instance creation' }
SeagullLocation class >> fromJSON: aDictionary [

	^ self new
		  setJSON: aDictionary;
		  yourself
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

	^ NotReadyToDownloadIcon ifNil: [
		  NotReadyToDownloadIcon := (self readyToDownloadIcon
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

	^ NotReadyToOpenIcon ifNil: [
		  NotReadyToOpenIcon := (self readyToOpenIcon asFormOfDepth: 32)
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

	^ NotReadyToUpdateIcon ifNil: [
		  NotReadyToUpdateIcon := (self readyToUpdateIcon asFormOfDepth: 32)
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

	^ ReadyToDownloadIcon ifNil: [
		  ReadyToDownloadIcon := self iconNamed: #box ]
]

{ #category : 'icons' }
SeagullLocation class >> readyToOpenIcon [

	^ ReadyToOpenIcon ifNil: [ ReadyToOpenIcon := self iconNamed: #go ]
]

{ #category : 'icons' }
SeagullLocation class >> readyToUpdateIcon [

	^ ReadyToUpdateIcon ifNil: [
		  ReadyToUpdateIcon := self iconNamed: #refreshCircling ]
]

{ #category : 'icons' }
SeagullLocation >> actionButtonIcon [

	self readyToOpen ifTrue: [ ^ self openButtonIcon ].
	self readyToDownload ifTrue: [ ^ self downloadButtonIcon ].
	self readyToUpdate ifTrue: [ ^ self updateButtonIcon ].
	^ self iconNamed: #empty
]

{ #category : 'announcing' }
SeagullLocation >> announce: aSeagullAnnouncement [

	self announcer announce: aSeagullAnnouncement
]

{ #category : 'announcing' }
SeagullLocation >> announceEndDownloading [

	^ self announce: (SeagullLocationEndDownloading on: self)
]

{ #category : 'announcing' }
SeagullLocation >> announceModificationOnServer [

	^ self announce: (SeagullLocationModifiedOnServer on: self)
]

{ #category : 'announcing' }
SeagullLocation >> announceSettingsChanged [

	^ self announce: (SeagullLocationSettingsChanged on: self)
]

{ #category : 'announcing' }
SeagullLocation >> announceStartDownloading [

	^ self announce: (SeagullLocationStartDownloading on: self)
]

{ #category : 'announcing' }
SeagullLocation >> announceStatusChanged [

	^ self announce: (SeagullLocationStatusChanged on: self)
]

{ #category : 'announcing' }
SeagullLocation >> announcer [

	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : 'converting' }
SeagullLocation >> asJSON [

	^ OrderedDictionary new
		  at: 'name' put: (self name ifNotNil: #asString);
		  at: 'url' put: (self url ifNotNil: #asString);
		  at: 'policy' put: self policyName;
		  at: 'interval' put: (self interval ifNotNil: #asString);
		  at: 'lastModifiedTimeOnServer'
		  put: (self lastModifiedTimeOnServer ifNotNil: #asString);
		  at: 'lastAccessTime'
		  put: (self lastAccessTime ifNotNil: #asString);
		  at: 'lastOpenTime' put: (self lastOpenTime ifNotNil: #asString);
		  at: 'hasDeadUrl' put: (self ifNotNil: #hasDeadUrl);
		  yourself
]

{ #category : 'converting' }
SeagullLocation >> asPresenter [

	^ SeagullLocationPresenter on: self
]

{ #category : 'operations' }
SeagullLocation >> beManualDownload [

	policy := SeagullManualDownloadPolicy on: self.
	self announceSettingsChanged
]

{ #category : 'operations' }
SeagullLocation >> beNoDownload [

	policy := SeagullNoDownloadPolicy on: self.
	self announceSettingsChanged
]

{ #category : 'operations' }
SeagullLocation >> beSync [

	policy := SeagullSyncPolicy on: self.
	self announceSettingsChanged
]

{ #category : 'initialization' }
SeagullLocation >> defaultDownloadDirectory [

	^ (FileLocator seagullHome / 'downloads') ensureCreateDirectory
]

{ #category : 'initialization' }
SeagullLocation >> defaultInterval [

	^ 1 day
]

{ #category : 'initialization' }
SeagullLocation >> defaultPolicyClass [

	^ SeagullManualDownloadPolicy
]

{ #category : 'icons' }
SeagullLocation >> doAction [

	self readyToOpen ifTrue: [ ^ self doOpenAction ].
	self readyToDownload ifTrue: [ ^ self doDownloadAction ].
	self readyToUpdate ifTrue: [ ^ self doUpdateAction ]
]

{ #category : 'operations' }
SeagullLocation >> doDownloadAction [

	[ policy doDownloadAction ] forkAt: Processor userBackgroundPriority
]

{ #category : 'operations' }
SeagullLocation >> doOpenAction [

	[ policy doOpenAction ] forkAt: Processor userBackgroundPriority
]

{ #category : 'operations' }
SeagullLocation >> doPollingAction [

	policy doPollingAction
]

{ #category : 'operations' }
SeagullLocation >> doUpdateAction [

	[ policy doUpdateAction ] forkAt: Processor userBackgroundPriority
]

{ #category : 'operations' }
SeagullLocation >> download [

	[
	^ self downloadFileReferenceDo: [ :fileReference |
		  self
			  ifModifiedSince: self lastModifiedTimeOfDownloadFile
			  etag: etag
			  httpClientDo: [ :client |
				  client
					  streaming: true;
					  get.
				  lastAccessTime := DateAndTime now.
				  client response ifNotNil: [ :response |
					  response isNotModified ifTrue: [ ^ false ].
					  response isSuccess ifTrue: [
						  lastModifiedTimeOnServer := (response headers
							                               at: 'Last-Modified'
							                               ifAbsent: [ nil ])
							                              ifNotNil: [ :string |
							                              ZnUtils parseHttpDate: string ]
							                              ifNil: [ lastAccessTime ].
						  etag := response headers at: 'Etag' ifAbsent: [ nil ].
						  isDownloading := true.
						  self announceStartDownloading.
						  client downloadEntityTo: fileReference ensureDelete.
						  isDownloading := false.
						  self announceEndDownloading.
						  self announceModificationOnServer.
						  ^ true ] ].
				  SeagullDeadUrl signal ] ] ] ensure: [
		self announceStatusChanged ]
]

{ #category : 'icons' }
SeagullLocation >> downloadButtonIcon [

	^ self readyToDownload
		  ifTrue: [ self class readyToDownloadIcon ]
		  ifFalse: [ self class notReadyToDownloadIcon ]
]

{ #category : 'accessing' }
SeagullLocation >> downloadDirectory [

	^ downloadDirectory ifNil: [ self defaultDownloadDirectory ]
]

{ #category : 'accessing' }
SeagullLocation >> downloadDirectory: aFileReference [

	downloadDirectory := aFileReference
]

{ #category : 'accessing' }
SeagullLocation >> downloadFileReferenceDo: aBlock [

	| ref |
	(name notNil and: [ name notEmpty ]) ifFalse: [ ^ self ].
	ref := self downloadDirectory / name asFileName.
	self url lastPathSegment ifNotNil: [ :basename |
		basename isString ifTrue: [
			ref := ref withExtension: basename asFileReference extension ] ].
	aBlock value: ref
]

{ #category : 'icons' }
SeagullLocation >> downloadingIcon [

	^ self class downloadingIcon
]

{ #category : 'operations' }
SeagullLocation >> edit [

	| presenter |
	presenter := self asPresenter.
	presenter openDialog okAction: [
		presenter accept.
		self announceSettingsChanged ]
]

{ #category : 'operations' }
SeagullLocation >> fetch [

	[
	^ self
		  ifModifiedSince: (self lastModifiedTimeOfDownloadFile ifNil: [
				   self lastModifiedTimeOnServer ])
		  etag: etag
		  httpClientDo: [ :client |
			  client
				  streaming: false;
				  head.
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
			  SeagullDeadUrl signal ] ] ensure: [ self announceStatusChanged ]
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

	^ self ifModifiedSince: nil etag: nil httpClientDo: aBlock
]

{ #category : 'icons' }
SeagullLocation >> iconNamed: aSymbol [

	aSymbol = #downloading ifTrue: [ ^ self downloadingIcon ].
	^ super iconNamed: aSymbol
]

{ #category : 'http' }
SeagullLocation >> ifModifiedSince: aDateAndTimeOrNil etag: aString httpClientDo: aBlock [

	^ lock critical: [
		  aString
			  ifNotNil: [
				  httpClient request headers
					  at: 'If-None-Match'
					  put: aString asString.
				  httpClient request headers
					  removeKey: 'If-Modified-Since'
					  ifAbsent: [  ] ]
			  ifNil: [
				  httpClient request headers
					  removeKey: 'If-None-Match'
					  ifAbsent: [  ].
				  aDateAndTimeOrNil
					  ifNotNil: [ httpClient setIfModifiedSince: aDateAndTimeOrNil ]
					  ifNil: [
						  httpClient request headers
							  removeKey: 'If-Modified-Since'
							  ifAbsent: [  ] ] ].
		  [
		  hasDeadUrl := false.
		  aBlock value: httpClient ]
			  on: Error
			  do: [ :ex |
				  hasDeadUrl := true.
				  ex return: nil ] ]
]

{ #category : 'initialization' }
SeagullLocation >> initialize [

	super initialize.
	name := ''.
	policy := self defaultPolicyClass on: self.
	interval := self defaultInterval.
	downloadDirectory := self defaultDownloadDirectory.
	hasDeadUrl := false.
	isDownloading := false.
	lock := Semaphore forMutualExclusion.
	httpClient := ZnClient new.
	announcer := Announcer new
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
		self downloadFileReferenceDo: [ :ref |
			SeagullOSUtils openFile: ref.
			lastOpenTime := DateAndTime now.
			self announceStatusChanged ] ]
]

{ #category : 'operations' }
SeagullLocation >> openUrl [

	[
	self ifModifiedSince: nil etag: etag httpClientDo: [ :client |
		client
			streaming: false;
			head.
		lastAccessTime := DateAndTime now.
		lastModifiedTimeOnServer := (client response headers
			                             at: 'Last-Modified'
			                             ifAbsent: [ nil ])
			                            ifNotNil: [ :string |
			                            ZnUtils parseHttpDate: string ]
			                            ifNil: [ lastAccessTime ].
		etag := client response headers at: 'Etag' ifAbsent: [ nil ] ].
	SeagullOSUtils openUrl: self url.
	lastOpenTime := DateAndTime now ] ensure: [
		self announceStatusChanged ]
]

{ #category : 'accessing' }
SeagullLocation >> policyName [

	^ policy policyName
]

{ #category : 'accessing' }
SeagullLocation >> policyName: aString [

	(SeagullLocationPolicy policyName: aString on: self) ifNotNil: [ :p |
		policy := p ]
]

{ #category : 'operations' }
SeagullLocation >> poll [

	(interval notNil and: [
		 lastAccessTime isNil or: [ self timeToPoll negative ] ]) ifTrue: [
		self doPollingAction ]
]

{ #category : 'testing' }
SeagullLocation >> readyToDownload [

	^ self isDownloading not and: [ policy readyToDownload ]
]

{ #category : 'testing' }
SeagullLocation >> readyToOpen [

	^ self isDownloading not and: [ policy readyToOpen ]
]

{ #category : 'testing' }
SeagullLocation >> readyToUpdate [

	^ self isDownloading not and: [ policy readyToUpdate ]
]

{ #category : 'private' }
SeagullLocation >> setJSON: aDictionary [

	aDictionary
		at: 'name' ifPresent: [ :string | self name: string ];
		at: 'url' ifPresent: [ :string | self url: string asZnUrl ];
		at: 'policy' ifPresent: [ :string | self policyName: string ];
		at: 'interval'
		ifPresent: [ :stringOrNil |
			self interval: (stringOrNil ifNotNil: #asDuration) ];
		at: 'lastModifiedTimeOnServer' ifPresent: [ :string |
			self lastModifiedTimeOnServer: (string ifNotNil: #asDateAndTime) ];
		at: 'lastAccessTime'
		ifPresent: [ :string |
			self lastAccessTime: (string ifNotNil: #asDateAndTime) ];
		at: 'lastOpenTime'
		ifPresent: [ :string |
			self lastOpenTime: (string ifNotNil: #asDateAndTime) ];
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

{ #category : 'accessing' }
SeagullLocation >> timeToPoll [

	^ lastAccessTime
		  ifNotNil: [ interval - (DateAndTime now - lastAccessTime) ]
		  ifNil: [ -1 second ]
]

{ #category : 'icons' }
SeagullLocation >> updateButtonIcon [

	^ self readyToUpdate
		  ifTrue: [ self class readyToUpdateIcon ]
		  ifFalse: [ self class notReadyToUpdateIcon ]
]

{ #category : 'accessing' }
SeagullLocation >> url [

	^ httpClient request url
]

{ #category : 'accessing' }
SeagullLocation >> url: aZnUrl [

	httpClient url: aZnUrl
]
