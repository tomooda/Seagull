Class {
	#name : 'SeagullOSUtilsMacOS',
	#superclass : 'SeagullOSUtils',
	#category : 'Seagull-Core-OSUtils',
	#package : 'Seagull-Core',
	#tag : 'OSUtils'
}

{ #category : 'platform dependents' }
SeagullOSUtilsMacOS class >> doOpenFile: aFileReference [

	LibC system:
		('open ' , (self shellEscape: aFileReference pathString))
			asUTF8Bytes
]

{ #category : 'platform dependents' }
SeagullOSUtilsMacOS class >> doOpenUrl: aZnUrl [

	LibC system:
		('open ' , (self shellEscape: aZnUrl asString)) asUTF8Bytes
]

{ #category : 'testing' }
SeagullOSUtilsMacOS class >> enabled [

	^ OSPlatform current isMacOSX
]

{ #category : 'utilities' }
SeagullOSUtilsMacOS class >> shellEscape: aString [

	^ '''' , (aString copyReplaceAll: '''' with: '''"''"''') , ''''
]
