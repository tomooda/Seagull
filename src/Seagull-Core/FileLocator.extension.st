Extension { #name : 'FileLocator' }

{ #category : '*Seagull-Core' }
FileLocator class >> seagullHome [

	^ (self documents / 'Seagull') ensureCreateDirectory
]
