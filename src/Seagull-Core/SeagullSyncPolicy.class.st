Class {
	#name : 'SeagullSyncPolicy',
	#superclass : 'SeagullLocationPolicy',
	#category : 'Seagull-Core-Locations',
	#package : 'Seagull-Core',
	#tag : 'Locations'
}

{ #category : 'accessing' }
SeagullSyncPolicy class >> policyName [

	^ 'sync'
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

	^ false
]

{ #category : 'testing' }
SeagullSyncPolicy >> readyToOpen [

	^ true
]

{ #category : 'testing' }
SeagullSyncPolicy >> readyToUpdate [

	^ true
]
