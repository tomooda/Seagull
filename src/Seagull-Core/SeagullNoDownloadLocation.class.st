Class {
	#name : 'SeagullNoDownloadLocation',
	#superclass : 'SeagullLocation',
	#category : 'Seagull-Core-Locations',
	#package : 'Seagull-Core',
	#tag : 'Locations'
}

{ #category : 'converting' }
SeagullNoDownloadLocation >> asJSON [

	^ super asJSON
		  at: 'type' put: 'no-download';
		  yourself
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
