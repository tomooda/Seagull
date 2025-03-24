Class {
	#name : 'SeagullManualDownloadPolicy',
	#superclass : 'SeagullLocationPolicy',
	#category : 'Seagull-Core-Locations',
	#package : 'Seagull-Core',
	#tag : 'Locations'
}

{ #category : 'accessing' }
SeagullManualDownloadPolicy class >> order [

	^ 2.0
]

{ #category : 'accessing' }
SeagullManualDownloadPolicy class >> policyName [

	^ 'manual-download'
]

{ #category : 'accessing' }
SeagullManualDownloadPolicy class >> printName [

	^ 'download and open'
]

{ #category : 'icons' }
SeagullManualDownloadPolicy >> actionButtonIcon [

	^ location openButtonIcon
]

{ #category : 'operations' }
SeagullManualDownloadPolicy >> doDownloadAction [

	location download
]

{ #category : 'operations' }
SeagullManualDownloadPolicy >> doOpenAction [

	location downloadFileReferenceDo: [ :ref |
		ref exists ifFalse: [ location download ] ].
	location openFile
]

{ #category : 'operations' }
SeagullManualDownloadPolicy >> doPollingAction [

	location fetch
]

{ #category : 'operations' }
SeagullManualDownloadPolicy >> doUpdateAction [

	location fetch
]

{ #category : 'testing' }
SeagullManualDownloadPolicy >> readyToDownload [

	| remote local |
	remote := location lastModifiedTimeOnServer.
	local := location lastModifiedTimeOfDownloadFile.
	remote isNil ifTrue: [ ^ false ].
	local isNil ifTrue: [ ^ true ].
	^ local < remote
]

{ #category : 'testing' }
SeagullManualDownloadPolicy >> readyToOpen [

	| local view |
	local := location lastModifiedTimeOfDownloadFile.
	view := location lastOpenTime.
	local ifNil: [ ^ false ].
	view ifNil: [ ^ true ].
	^ view < local
]

{ #category : 'testing' }
SeagullManualDownloadPolicy >> readyToUpdate [

	^ self readyToDownload not
]
