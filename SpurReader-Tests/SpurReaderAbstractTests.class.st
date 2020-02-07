Class {
	#name : #SpurReaderAbstractTests,
	#superclass : #TestCase,
	#instVars : [
		'image'
	],
	#category : #'SpurReader-Tests'
}

{ #category : #accessing }
SpurReaderAbstractTests class >> image [

	^ SpurFileImage onFile: '/Users/theo/Documents/Pharo/images/TestImage2/TestImage2.image'
	"^ SpurImage onFile: '/Users/theo/Documents/Pharo/images/CaroInsp/CaroInsp.image'"
]

{ #category : #assertions }
SpurReaderAbstractTests >> assertIsClass: aSpurObject [ 
	
	self assert: aSpurObject basicClass basicClass asSpurClass className equals: 'Metaclass'
]

{ #category : #asserting }
SpurReaderAbstractTests >> assertIsSymbol: aSpurObject [ 
	
	self assert: aSpurObject basicClass asSpurClass className equals: 'ByteSymbol'
]

{ #category : #running }
SpurReaderAbstractTests >> setUp [

	super setUp.
	image := self class image
]
