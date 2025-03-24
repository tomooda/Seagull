Class {
	#name : 'SeagullLocationPolicy',
	#superclass : 'Object',
	#instVars : [
		'location'
	],
	#category : 'Seagull-Core-Locations',
	#package : 'Seagull-Core',
	#tag : 'Locations'
}

{ #category : 'accessing' }
SeagullLocationPolicy class >> classFor: aString [

	^ self allSubclasses
		  detect: [ :class |
		  class isAbstract not and: [ class policyName = aString ] ]
		  ifNone: [ self error: 'No class for ' , aString , ' found.' ]
]

{ #category : 'testing' }
SeagullLocationPolicy class >> isAbstract [

	^ self = SeagullLocationPolicy
]

{ #category : 'instance creation' }
SeagullLocationPolicy class >> on: aSeagullLocation [

	^ self new
		  location: aSeagullLocation;
		  yourself
]

{ #category : 'accessing' }
SeagullLocationPolicy class >> order [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
SeagullLocationPolicy class >> policyName [

	^ self subclassResponsibility
]

{ #category : 'instance creation' }
SeagullLocationPolicy class >> policyName: aString on: aSeagullLocation [

	^ (self classFor: aString) on: aSeagullLocation
]

{ #category : 'accessing' }
SeagullLocationPolicy class >> printName [

	^ self subclassResponsibility
]

{ #category : 'icons' }
SeagullLocationPolicy >> actionButtonIcon [

	^ self subclassResponsibility
]

{ #category : 'operations' }
SeagullLocationPolicy >> doDownloadAction [

	^ self subclassResponsibility
]

{ #category : 'operations' }
SeagullLocationPolicy >> doOpenAction [

	^ self subclassResponsibility
]

{ #category : 'operations' }
SeagullLocationPolicy >> doPollingAction [

	^ self subclassResponsibility
]

{ #category : 'operations' }
SeagullLocationPolicy >> doUpdateAction [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
SeagullLocationPolicy >> location [

	^ location
]

{ #category : 'accessing' }
SeagullLocationPolicy >> location: aSeagullLocation [

	location := aSeagullLocation
]

{ #category : 'accessing' }
SeagullLocationPolicy >> policyName [

	^ self class policyName
]

{ #category : 'testing' }
SeagullLocationPolicy >> readyToDownload [

	^ self subclassResponsibility
]

{ #category : 'testing' }
SeagullLocationPolicy >> readyToOpen [

	^ self subclassResponsibility
]

{ #category : 'testing' }
SeagullLocationPolicy >> readyToUpdate [

	^ self subclassResponsibility
]
