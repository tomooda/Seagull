Class {
	#name : 'SeagullNoDownloadLocation',
	#superclass : 'SeagullLocation',
	#category : 'Seagull-Core-Locations',
	#package : 'Seagull-Core',
	#tag : 'Locations'
}

{ #category : 'accessing' }
SeagullNoDownloadLocation class >> type [

	^ 'no download'
]

{ #category : 'operations' }
SeagullNoDownloadLocation >> doDownloadAction [

	
]

{ #category : 'operations' }
SeagullNoDownloadLocation >> doOpenAction [

	^ self openUrl
]

{ #category : 'testing' }
SeagullNoDownloadLocation >> readyToDownload [

	^ false
]
