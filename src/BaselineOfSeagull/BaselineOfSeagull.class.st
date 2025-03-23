Class {
	#name : 'BaselineOfSeagull',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfSeagull',
	#package : 'BaselineOfSeagull'
}

{ #category : 'baselines' }
BaselineOfSeagull >> baseline: spec [

	<baseline>
	spec for: #common do: [
		spec
			baseline: 'Phleeter'
			with: [ spec repository: 'github://tomooda/Phleeter:main/src' ].
		spec
			package: 'Seagull-Core';
			package: 'Seagull-Application' with: [ spec requires: 'Phleeter' ].
		spec
			group: 'default'
			with: #( 'Seagull-Core' 'Seagull-Application' ) ]
]
