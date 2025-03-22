Class {
	#name : 'SeagullLocationTest',
	#superclass : 'TestCase',
	#instVars : [
		'location',
		'fileSystem',
		'downloadDirectory'
	],
	#category : 'Seagull-Core-Tests',
	#package : 'Seagull-Core',
	#tag : 'Tests'
}

{ #category : 'testing' }
SeagullLocationTest class >> isAbstract [

	^ self = SeagullLocationTest
]

{ #category : 'utilities' }
SeagullLocationTest >> future [

	^ DateAndTime year: 3000 month: 1
]

{ #category : 'class access' }
SeagullLocationTest >> locationClass [

	^ self subclassResponsibility
]

{ #category : 'utilities' }
SeagullLocationTest >> past [

	^ DateAndTime year: 1960 month: 1
]

{ #category : 'running' }
SeagullLocationTest >> setUp [

	fileSystem := FileSystem memory.
	downloadDirectory := fileSystem root.
	location := (self locationClass
		             name: 'Example'
		             url: 'https://example.com/')
		            downloadDirectory: downloadDirectory;
		            yourself
]

{ #category : 'tests' }
SeagullLocationTest >> testDownload [

	location lastModifiedTimeOnServer: self past.
	location lastAccessTime: self past.
	location download.
	self
		assert: (downloadDirectory / 'Example') contents
		equals: (ZnEasy get: 'https://example.com/') contents.
	self assert: self past < location lastModifiedTimeOnServer.
	self assert: self past < location lastAccessTime
]

{ #category : 'tests' }
SeagullLocationTest >> testDownloadDirectory [

	location downloadDirectory: nil.
	self deny: location downloadDirectory equals: downloadDirectory.
	location downloadDirectory: downloadDirectory.
	self assert: location downloadDirectory equals: downloadDirectory
]

{ #category : 'tests' }
SeagullLocationTest >> testFetch [

	location lastModifiedTimeOnServer: self past.
	location lastAccessTime: self past.
	location fetch.
	self assert: self past < location lastModifiedTimeOnServer.
	self assert: self past < location lastAccessTime
]
