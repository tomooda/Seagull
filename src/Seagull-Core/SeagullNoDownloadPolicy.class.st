Class {
	#name : 'SeagullNoDownloadPolicy',
	#superclass : 'SeagullLocationPolicy',
	#category : 'Seagull-Core-Locations',
	#package : 'Seagull-Core',
	#tag : 'Locations'
}

{ #category : 'accessing' }
SeagullNoDownloadPolicy class >> policyName [

	^ 'no-download'
]

{ #category : 'operations' }
SeagullNoDownloadPolicy >> doDownloadAction [

	
]

{ #category : 'operations' }
SeagullNoDownloadPolicy >> doOpenAction [

	location openUrl
]

{ #category : 'operations' }
SeagullNoDownloadPolicy >> doPollingAction [

	location fetch
]

{ #category : 'operations' }
SeagullNoDownloadPolicy >> doUpdateAction [

	location fetch
]

{ #category : 'testing' }
SeagullNoDownloadPolicy >> readyToDownload [

	^ false
]

{ #category : 'testing' }
SeagullNoDownloadPolicy >> readyToOpen [

	| remote view |
	remote := location lastModifiedTimeOnServer.
	view := location lastOpenTime.
	remote ifNil: [ ^ false ].
	view ifNil: [ ^ true ].
	^ view < remote
]

{ #category : 'testing' }
SeagullNoDownloadPolicy >> readyToUpdate [

	^ self readyToOpen not
]
