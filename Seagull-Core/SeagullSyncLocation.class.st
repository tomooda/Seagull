Class {
	#name : 'SeagullSyncLocation',
	#superclass : 'SeagullLocation',
	#category : 'Seagull-Core-Locations',
	#package : 'Seagull-Core',
	#tag : 'Locations'
}

{ #category : 'converting' }
SeagullSyncLocation >> asJSON [

	^ super asJSON
		  at: 'type' put: 'sync';
		  yourself
]
