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

{ #category : 'as yet unclassified' }
SeagullLocationPolicy class >> classFor: aString [

	^ self allSubclasses
		  detect: [ :class |
		  class isAbstract not and: [ class policyName = aString ] ]
		  ifNone: [ self error: 'No class for ' , aString , ' found.' ]
]

{ #category : 'as yet unclassified' }
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
SeagullLocationPolicy class >> policyName [

	^ self subclassResponsibility
]

{ #category : 'instance creation' }
SeagullLocationPolicy class >> policyName: aString on: aSeagullLocation [

	^ (self classFor: aString) on: aSeagullLocation
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

{ #category : 'as yet unclassified' }
SeagullLocationPolicy >> location [

	^ location
]

{ #category : 'as yet unclassified' }
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
