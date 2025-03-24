Class {
	#name : 'SeagullSyncPolicy',
	#superclass : 'SeagullLocationPolicy',
	#category : 'Seagull-Core-Locations',
	#package : 'Seagull-Core',
	#tag : 'Locations'
}

{ #category : 'accessing' }
SeagullSyncPolicy class >> order [

	^ 3.0
]

{ #category : 'accessing' }
SeagullSyncPolicy class >> policyName [

	^ 'sync'
]

{ #category : 'accessing' }
SeagullSyncPolicy class >> printName [

	^ 'sync and open'
]

{ #category : 'icons' }
SeagullSyncPolicy >> actionButtonIcon [

	^ location openButtonIcon
]

{ #category : 'operations' }
SeagullSyncPolicy >> doDownloadAction [

	location download
]

{ #category : 'operations' }
SeagullSyncPolicy >> doOpenAction [

	location downloadFileReferenceDo: [ :ref |
		ref exists ifFalse: [ location download ] ].
	location openFile
]

{ #category : 'operations' }
SeagullSyncPolicy >> doPollingAction [

	location download
]

{ #category : 'operations' }
SeagullSyncPolicy >> doUpdateAction [

	location download
]

{ #category : 'testing' }
SeagullSyncPolicy >> readyToDownload [

	^ true
]

{ #category : 'testing' }
SeagullSyncPolicy >> readyToOpen [

	^ true
]

{ #category : 'testing' }
SeagullSyncPolicy >> readyToUpdate [

	^ true
]
