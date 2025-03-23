Class {
	#name : 'SeagullLocationChanged',
	#superclass : 'Announcement',
	#instVars : [
		'location'
	],
	#category : 'Seagull-Core-Announcements',
	#package : 'Seagull-Core',
	#tag : 'Announcements'
}

{ #category : 'instance creation' }
SeagullLocationChanged class >> on: aSeagullLocation [

	^ self new location: aSeagullLocation
]

{ #category : 'accessing' }
SeagullLocationChanged >> location [

	^ location
]

{ #category : 'accessing' }
SeagullLocationChanged >> location: aSeagullLocation [

	location := aSeagullLocation
]
