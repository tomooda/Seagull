Class {
	#name : 'SeagullSyncOnlyPolicy',
	#superclass : 'SeagullLocationPolicy',
	#category : 'Seagull-Core-Locations',
	#package : 'Seagull-Core',
	#tag : 'Locations'
}

{ #category : 'accessing' }
SeagullSyncOnlyPolicy class >> order [

	^ 3.1
]

{ #category : 'accessing' }
SeagullSyncOnlyPolicy class >> policyName [

	^ 'sync-only'
]

{ #category : 'accessing' }
SeagullSyncOnlyPolicy class >> printName [

	^ 'sync only'
]

{ #category : 'icons' }
SeagullSyncOnlyPolicy >> actionButtonIcon [

	^ location readyToOpen
		  ifTrue: [ self iconNamed: #accept ]
		  ifFalse: [ self iconNamed: #empty ]
]

{ #category : 'operations' }
SeagullSyncOnlyPolicy >> doDownloadAction [

	location download
]

{ #category : 'operations' }
SeagullSyncOnlyPolicy >> doOpenAction [

	location lastOpenTime: DateAndTime now.
	location announceStatusChanged
]

{ #category : 'operations' }
SeagullSyncOnlyPolicy >> doPollingAction [

	location download
]

{ #category : 'operations' }
SeagullSyncOnlyPolicy >> doUpdateAction [

	location download
]

{ #category : 'testing' }
SeagullSyncOnlyPolicy >> readyToDownload [

	^ true
]

{ #category : 'testing' }
SeagullSyncOnlyPolicy >> readyToOpen [

	| local view |
	local := location lastModifiedTimeOfDownloadFile.
	view := location lastOpenTime.
	local ifNil: [ ^ false ].
	view ifNil: [ ^ true ].
	^ view < local
]

{ #category : 'testing' }
SeagullSyncOnlyPolicy >> readyToUpdate [

	^ true
]
