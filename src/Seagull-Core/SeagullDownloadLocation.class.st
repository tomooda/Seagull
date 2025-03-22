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

	| remote local |
	remote := self lastModifiedTimeOnServer.
	local := self lastOpenTime.
	remote isNil ifTrue: [ ^ false ].
	local isNil ifTrue: [ ^ true ].
	^ local < remote
]

{ #category : 'testing' }
SeagullDownloadLocation >> readyToUpdate [

	^ self readyToDownload not
]
