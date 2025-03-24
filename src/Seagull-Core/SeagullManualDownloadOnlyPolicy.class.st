Class {
	#name : 'SeagullManualDownloadOnlyPolicy',
	#superclass : 'SeagullLocationPolicy',
	#category : 'Seagull-Core-Locations',
	#package : 'Seagull-Core',
	#tag : 'Locations'
}

{ #category : 'accessing' }
SeagullManualDownloadOnlyPolicy class >> order [

	^ 2.1
]

{ #category : 'accessing' }
SeagullManualDownloadOnlyPolicy class >> policyName [

	^ 'download-only'
]

{ #category : 'accessing' }
SeagullManualDownloadOnlyPolicy class >> printName [

	^ 'download only'
]

{ #category : 'icons' }
SeagullManualDownloadOnlyPolicy >> actionButtonIcon [

	^ location downloadButtonIcon
]

{ #category : 'operations' }
SeagullManualDownloadOnlyPolicy >> doDownloadAction [

	location download
]

{ #category : 'operations' }
SeagullManualDownloadOnlyPolicy >> doOpenAction [

	
]

{ #category : 'operations' }
SeagullManualDownloadOnlyPolicy >> doPollingAction [

	location fetch
]

{ #category : 'operations' }
SeagullManualDownloadOnlyPolicy >> doUpdateAction [

	location fetch
]

{ #category : 'testing' }
SeagullManualDownloadOnlyPolicy >> readyToDownload [

	| remote local |
	remote := location lastModifiedTimeOnServer.
	local := location lastModifiedTimeOfDownloadFile.
	remote isNil ifTrue: [ ^ false ].
	local isNil ifTrue: [ ^ true ].
	^ local < remote
]

{ #category : 'testing' }
SeagullManualDownloadOnlyPolicy >> readyToOpen [

	^ false
]

{ #category : 'testing' }
SeagullManualDownloadOnlyPolicy >> readyToUpdate [

	^ self readyToDownload not
]
