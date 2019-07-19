Class {
	#name : #SpurImageTests,
	#superclass : #TestCase,
	#classInstVars : [
		'image'
	],
	#category : #'SpurReader-Tests'
}

{ #category : #accessing }
SpurImageTests class >> image [
	^ image ifNil: [image := SpurImage onFile: '/Users/carolina.hernandez/Documents/Pharo/pharo-development/testVince/Pharo.image']
]

{ #category : #accessing }
SpurImageTests class >> imageCandle [
	^ image ifNil: [image := SpurImage onFile: '/Users/carolina.hernandez/Documents/Pharo/pharo-development/20190624PharoBootstrapRefactor/pharo/bootstrap/scripts/pharo/bootstrap.image']
]

{ #category : #tests }
SpurImageTests >> testCandleClassIndex [
	| image |
	image := self class imageCandle.
	self 
		assert: (image  hiddenRootsObj classOrNilAtIndex: (image trueObject classIndex)) indexInClassTable
		equals: (image trueObject classIndex).

	self 
		assert: (image  hiddenRootsObj classOrNilAtIndex: (image falseObject classIndex)) indexInClassTable 
		equals: (image falseObject classIndex).
]

{ #category : #tests }
SpurImageTests >> testClassIndex [
	| image |
	image := self class image.
	self 
		assert: (image  hiddenRootsObj classOrNilAtIndex: (image trueObject classIndex)) indexInClassTable
		equals: (image trueObject classIndex).

	self 
		assert: (image  hiddenRootsObj classOrNilAtIndex: (image falseObject classIndex)) indexInClassTable 
		equals: (image falseObject classIndex).
]

{ #category : #tests }
SpurImageTests >> testSpecialObjectsArrayClass [
	| image |
	image := self class image.
	self 
		assert: (image specialObjectsArray classIndex)
		equals: (image arrayClass) indexInClassTable.


]
