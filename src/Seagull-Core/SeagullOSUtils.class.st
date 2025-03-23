Class {
	#name : 'SeagullOSUtils',
	#superclass : 'Object',
	#category : 'Seagull-Core-OSUtils',
	#package : 'Seagull-Core',
	#tag : 'OSUtils'
}

{ #category : 'platforms' }
SeagullOSUtils class >> current [

	^ self allSubclassesDo: [ :class |
		  (class isAbstract not and: [ class enabled ]) ifTrue: [ ^ class ] ]
]

{ #category : 'platform dependents' }
SeagullOSUtils class >> doOpenFile: aFileReference [

	^ self subclassResponsibility
]

{ #category : 'platform dependents' }
SeagullOSUtils class >> doOpenUrl: aZnUrl [

	^ self subclassResponsibility
]

{ #category : 'testing' }
SeagullOSUtils class >> enabled [

	^ self subclassResponsibility
]

{ #category : 'testing' }
SeagullOSUtils class >> isAbstract [

	^ self = SeagullOSUtils
]

{ #category : 'operations' }
SeagullOSUtils class >> openFile: aFileReference [

	^ self current doOpenFile: aFileReference
]

{ #category : 'operations' }
SeagullOSUtils class >> openUrl: aZnUrl [

	^ self current doOpenUrl: aZnUrl
]
