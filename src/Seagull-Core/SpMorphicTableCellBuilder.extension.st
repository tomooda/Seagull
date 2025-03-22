Extension { #name : 'SpMorphicTableCellBuilder' }

{ #category : '*Seagull-Core' }
SpMorphicTableCellBuilder >> visitSeagullButtonColumn: aTableColumn [

	| presenter morph |
	presenter := SpButtonPresenter new
		             addStyle: 'compact';
		             icon: (aTableColumn readObject: self item);
		             yourself.
	aTableColumn action ifNotNil: [ :valuable |
		presenter action: [valuable value: self item] ].
	morph := presenter build.
	presenter adapter applyStyle: morph.
	self addCellMorph: morph column: aTableColumn
]
