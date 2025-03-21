Extension { #name : 'FileLocator' }

{ #category : '*Seaguller-Core' }
FileLocator class >> seaguller [

	^ (self documents / 'Seaguller') ensureCreateDirectory
]
