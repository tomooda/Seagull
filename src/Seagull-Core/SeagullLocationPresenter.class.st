Class {
	#name : 'SeagullLocationPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'nameField',
		'urlField',
		'policyDropList',
		'intervalDropList',
		'location',
		'nameValidationBlock'
	],
	#category : 'Seagull-Core-UI',
	#package : 'Seagull-Core',
	#tag : 'UI'
}

{ #category : 'instance creation' }
SeagullLocationPresenter class >> on: aSeagullLocation [

	^ self new
		  location: aSeagullLocation;
		  yourself
]

{ #category : 'operations' }
SeagullLocationPresenter >> accept [

	location
		name: nameField text trim;
		url: urlField text trim asZnUrl;
		interval: intervalDropList selectedItem value;
		policyName: policyDropList selectedItem value;
		announceSettingsChanged
]

{ #category : 'accessing' }
SeagullLocationPresenter >> availableIntervals [

	^ {
		  ('every min' -> 1 minute).
		  ('every hour' -> 1 hour).
		  ('everyday' -> 1 day).
		  ('every week' -> 1 week) }
]

{ #category : 'accessing' }
SeagullLocationPresenter >> availablePolicies [

	^ {
		  ('browse' -> 'no-download').
		  ('download' -> 'manual-download').
		  ('sync' -> 'sync') }
]

{ #category : 'layout' }
SeagullLocationPresenter >> defaultLayout [

	<script: '(self on: SeagullLocation example) open'>
	^ SpGridLayout new
		  beColumnNotHomogeneous;
		  column: 2 expand: true;
		  add: 'name ' at: 1 @ 1;
		  add: nameField at: 2 @ 1;
		  add: 'url  ' at: 1 @ 2;
		  add: urlField at: 2 @ 2;
		  add: 'interval' at: 1 @ 3;
		  add: intervalDropList at: 2 @ 3;
		  add: 'type' at: 1 @ 4;
		  add: policyDropList at: 2 @ 4;
		  yourself
]

{ #category : 'updating' }
SeagullLocationPresenter >> errorField: aTextInputFieldPresenter [

	aTextInputFieldPresenter withAdapterDo: [ :a |
		a widgetDo: [ :w |
			w color: (Color red mixed: 0.3 with: Color white) ] ]
]

{ #category : 'accessing' }
SeagullLocationPresenter >> iconForInterval: assoc [

	^ self iconNamed: (location interval = assoc value
			   ifTrue: [ #accept ]
			   ifFalse: [ #empty ])
]

{ #category : 'accessing' }
SeagullLocationPresenter >> iconForPolicy: assoc [

	^ self iconNamed: (location policyName = assoc value
			   ifTrue: [ #accept ]
			   ifFalse: [ #empty ])
]

{ #category : 'initialization' }
SeagullLocationPresenter >> initialize [

	super initialize.
	nameValidationBlock := [ :string | string trim notEmpty ]
]

{ #category : 'initialization' }
SeagullLocationPresenter >> initializePresenters [

	super initializePresenters.
	nameField := self newTextInput
		             help: 'Name';
		             whenTextChangedDo: [ self validateNameField ];
		             yourself.
	urlField := self newTextInput
		            help: 'URL';
		            whenTextChangedDo: [ self validateUrlField ];
		            whenSubmitDo: [ :text | self testUrlField ];
		            yourself.
	intervalDropList := self newDropList
		                    items: self availableIntervals;
		                    displayIcon: [ :assoc |
			                    self iconForInterval: assoc ];
		                    display: [ :assoc | assoc key ];
		                    help: 'Polling interval';
		                    yourself.
	policyDropList := self newDropList
		                  items: self availablePolicies;
		                  displayIcon: [ :assoc | self iconForPolicy: assoc ];
		                  display: [ :assoc | assoc key ];
		                  help: 'Polling type';
		                  yourself
]

{ #category : 'initialization' }
SeagullLocationPresenter >> initializeWindow: aSpWindowPresenter [

	super initializeWindow: aSpWindowPresenter.
	aSpWindowPresenter
		title: 'Location Editor';
		initialExtent:
			400 @ (self class buttonHeight * 4 + (aSpWindowPresenter isDialog
						  ifTrue: [ 100 ]
						  ifFalse: [ 60 ]))
]

{ #category : 'accessing' }
SeagullLocationPresenter >> location [

	^ location
]

{ #category : 'accessing' }
SeagullLocationPresenter >> location: aSeagullLocation [

	location := aSeagullLocation.
	self reset
]

{ #category : 'accessing' }
SeagullLocationPresenter >> nameValidationBlock [

	^ nameValidationBlock
]

{ #category : 'accessing' }
SeagullLocationPresenter >> nameValidationBlock: aBlock [

	nameValidationBlock := aBlock
]

{ #category : 'updating' }
SeagullLocationPresenter >> okField: aTextInputFieldPresenter [

	aTextInputFieldPresenter withAdapterDo: [ :a |
		a widgetDo: [ :w | w color: Color white ] ]
]

{ #category : 'operations' }
SeagullLocationPresenter >> reset [

	self
		resetNameField;
		resetUrlField;
		resetIntervalDropList;
		resetPolicyDropList
]

{ #category : 'updating' }
SeagullLocationPresenter >> resetIntervalDropList [

	intervalDropList selectItem: (self availableIntervals
			 detect: [ :assoc | assoc value = location interval ]
			 ifNone: [ self availableIntervals last ])
]

{ #category : 'updating' }
SeagullLocationPresenter >> resetNameField [

	nameField text: location name
]

{ #category : 'updating' }
SeagullLocationPresenter >> resetPolicyDropList [

	policyDropList selectItem: (self availablePolicies
			 detect: [ :assoc | assoc value = location policyName ]
			 ifNone: [ self availablePolicies last ])
]

{ #category : 'updating' }
SeagullLocationPresenter >> resetUrlField [

	urlField text: location url asString
]

{ #category : 'validating' }
SeagullLocationPresenter >> testUrlField [

	| url |
	url := urlField text trim asZnUrl.
	^ ([ (ZnEasy head: url) isSuccess ]
		   on: Exception
		   do: [ :ex | ex return: false ])
		  ifTrue: [
			  self okField: urlField.
			  true ]
		  ifFalse: [
			  self warnField: urlField.
			  false ]
]

{ #category : 'validating' }
SeagullLocationPresenter >> validateNameField [

	^ (nameValidationBlock value: nameField text trim)
		  ifTrue: [
			  self okField: nameField.
			  true ]
		  ifFalse: [
			  self errorField: nameField.
			  false ]
]

{ #category : 'validating' }
SeagullLocationPresenter >> validateUrlField [

	| url |
	url := urlField text trim asZnUrl.
	^ (url notNil and: [ url isHttps or: [ url isHttp ] ])
		  ifTrue: [
			  self okField: urlField.
			  true ]
		  ifFalse: [
			  self warnField: urlField.
			  false ]
]

{ #category : 'updating' }
SeagullLocationPresenter >> warnField: aTextInputFieldPresenter [

	aTextInputFieldPresenter withAdapterDo: [ :a |
		a widgetDo: [ :w |
			w color: (Color yellow mixed: 0.3 with: Color white) ] ]
]
