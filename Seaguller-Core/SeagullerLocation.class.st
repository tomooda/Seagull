Class {
	#name : 'SeagullerLocation',
	#superclass : 'Object',
	#instVars : [
		'name',
		'url',
		'action',
		'lastDownloadTime'
	],
	#category : 'Seaguller-Core',
	#package : 'Seaguller-Core'
}

{ #category : 'accessing' }
SeagullerLocation >> action [

	^ action
]

{ #category : 'accessing' }
SeagullerLocation >> action: aSymbol [

	action := aSymbol asSymbol
]

{ #category : 'initialize' }
SeagullerLocation >> defaultAction [

	^ #download
]

{ #category : 'operations' }
SeagullerLocation >> getIfModifiedDo: aBlock [

	<script:
	'self new url: ''https://viennatalk.org/''; lastDownloadTime: (DateAndTime year: 2026 month: 1); getIfModifiedDo: [:response | self halt ]'>
	| client |
	client := ZnClient new
		          url: self url;
		          yourself.
	lastDownloadTime ifNotNil: [
		client
			headerAt: 'If-Modified-Since'
			put: (self ifModifiedSinceStringFrom: lastDownloadTime) ].
	client head.
	client response code = 200 ifTrue: [ aBlock cull: client ]
]

{ #category : 'utilities' }
SeagullerLocation >> ifModifiedSinceStringFrom: aDateAndTime [

	| utc |
	utc := aDateAndTime asUTC.
	^ '{day-name}, {day} {month} {year} {hour}:{minute}:{second} GMT'
		  format: {
				  ('day-name' -> utc dayOfWeekName).
				  ('day' -> utc dayOfMonth).
				  ('month' -> utc monthName).
				  ('year' -> utc year).
				  ('hour' -> utc hour).
				  ('minute' -> utc minute).
				  ('second' -> utc second) } asDictionary
]

{ #category : 'initialize' }
SeagullerLocation >> initialize [

	super initialize.
	name := String new.
	action := self defaultAction
]

{ #category : 'accessing' }
SeagullerLocation >> lastDownloadTime [

	^ lastDownloadTime
]

{ #category : 'accessing' }
SeagullerLocation >> lastDownloadTime: aDateAndTime [

	lastDownloadTime := aDateAndTime asDateAndTime
]

{ #category : 'accessing' }
SeagullerLocation >> name [

	^ name
]

{ #category : 'accessing' }
SeagullerLocation >> name: aString [

	name := aString asString
]

{ #category : 'accessing' }
SeagullerLocation >> url [

	^ url
]

{ #category : 'accessing' }
SeagullerLocation >> url: aZnUrl [

	url := aZnUrl asZnUrl
]
