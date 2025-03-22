"
A column that display a boolean value in the form of a checkbox.

The user need to set the evaluation block (by sending `SpTableColumn>>#evaluated:`) to answer a boolean value that will define if the checkbox is selected or unselected.

## Example
```
SpCheckBoxTableColumn 
	title: 'My CheckBox' 
	evaluated: [ :anObject | anObject = someValue ]
```
"
Class {
	#name : 'SeagullButtonTableColumn',
	#superclass : 'SpTableColumn',
	#instVars : [
		'action'
	],
	#category : 'Seagull-Core-Widgets-Table',
	#package : 'Seagull-Core',
	#tag : 'Widgets-Table'
}

{ #category : 'visiting' }
SeagullButtonTableColumn >> acceptColumnVisitor: aBuilder [

	^ aBuilder visitSeagullButtonColumn: self
]

{ #category : 'accessing' }
SeagullButtonTableColumn >> action [

	^ action
]

{ #category : 'accessing' }
SeagullButtonTableColumn >> action: aBlock [

	action := aBlock
]
