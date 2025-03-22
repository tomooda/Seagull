Class {
	#name : 'SeagullDownloadLocation',
	#superclass : 'SeagullLocation',
	#category : 'Seagull-Core-Locations',
	#package : 'Seagull-Core',
	#tag : 'Locations'
}

{ #category : 'converting' }
SeagullDownloadLocation >> asJSON [

	^ super asJSON
		  at: 'type' put: 'download';
		  yourself
]

{ #category : 'operations' }
SeagullDownloadLocation >> doDownloadAction [

	self download
]

{ #category : 'operations' }
SeagullDownloadLocation >> doOpenAction [

	self openFile
]

{ #category : 'operations' }
SeagullDownloadLocation >> doPollingAction [

	self fetch
]

{ #category : 'operations' }
SeagullDownloadLocation >> doUpdateAction [

	self fetch
]

{ #category : 'testing' }
SeagullDownloadLocation >> readyToDownload [

	| remote local |
	remote := self lastModifiedTimeOnServer.
	local := self lastModifiedTimeOfDownloadFile.
	remote isNil ifTrue: [ ^ false ].
	local isNil ifTrue: [ ^ true ].
	^ local < remote
]

{ #category : 'testing' }
SeagullDownloadLocation >> readyToOpen [

	| local view |
	local := self lastModifiedTimeOfDownloadFile.
	view := self lastOpenTime.
	local isNil ifTrue: [ ^ false ].
	view isNil ifTrue: [ ^ true ].
	^ view < local
]

{ #category : 'testing' }
SeagullDownloadLocation >> readyToUpdate [

	| remote local |
	remote := self lastModifiedTimeOnServer.
	local := self lastModifiedTimeOfDownloadFile.
	remote isNil ifTrue: [ ^ true ].
	local isNil ifTrue: [ ^ true ].
	^ self readyToDownload not
]
