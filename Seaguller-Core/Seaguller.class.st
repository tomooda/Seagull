Class {
	#name : 'Seaguller',
	#superclass : 'SpPresenter',
	#instVars : [
		'locationList'
	],
	#category : 'Seaguller-Core',
	#package : 'Seaguller-Core'
}

{ #category : 'menu' }
Seaguller >> loadSettings [

	FileLocator seaguller / 'settings.json' ifExists: [ :ref |
		ref readStreamDo: [ :stream |
			([ STONJSON fromStream: stream ]
				 on: Exception
				 do: [ :ex | ex return: nil ]) ifNotNil: [ :settings |
				settings at: 'location' ifPresent: [ :locations |
					locationList items: (locations collect: [ :location |
							 SeagullerLocation fromJSON: location ]) ] ] ] ]
]
