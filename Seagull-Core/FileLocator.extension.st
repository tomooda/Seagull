Extension { #name : 'FileLocator' }

{ #category : '*Seagull-Core' }
FileLocator class >> seaguller [

	^ (self documents / 'Seaguller') ensureCreateDirectory
]
