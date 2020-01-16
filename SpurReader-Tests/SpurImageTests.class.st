Class {
	#name : #SpurImageTests,
	#superclass : #SpurReaderAbstractTests,
	#category : #'SpurReader-Tests'
}

{ #category : #accessing }
SpurImageTests class >> imageCandle [
	^ SpurFileImage onFile: '/Users/theo/Documents/Pharo/images/CaroInsp/CaroInsp.image'
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
SpurImageTests >> testClassHasMethodDictionary [

	self 
		assert: image arrayClass asSpurClass methodDictionary basicClass className
		equals: 'MethodDictionary'
]

{ #category : #tests }
SpurImageTests >> testClassIndex [
	self 
		assert: (image hiddenRootsObj classOrNilAtIndex: (image trueObject classIndex)) indexInClassTable
		equals: (image trueObject classIndex).

	self 
		assert: (image  hiddenRootsObj classOrNilAtIndex: (image falseObject classIndex)) indexInClassTable 
		equals: (image falseObject classIndex).
]

{ #category : #tests }
SpurImageTests >> testClassNameIsString [
	self 
		assert: image arrayClass asSpurClass className
		equals: 'Array'
]

{ #category : #tests }
SpurImageTests >> testFirstObjectIsNil [

	self 
		assert: image firstObject
		equals: image nilObject
]

{ #category : #tests }
SpurImageTests >> testNilHasAnInstanceVariableAndHeader [
	
	| start end |
	start := image nilObject address.
	end := image nilObject endAddress.
	self 
		assert: end - start
		equals: 2 * 8 "bytes"
]

{ #category : #tests }
SpurImageTests >> testSecondObjectIsFalse [
	self 
		assert: image firstObject nextObject
		equals: image falseObject
]

{ #category : #tests }
SpurImageTests >> testSpecialObjectsArrayClass [
	self 
		assert: (image specialObjectsArray slotAt: 1) address
		equals: image nilObject address
]
