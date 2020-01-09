Class {
	#name : #SpurImageTests,
	#superclass : #TestCase,
	#category : #'SpurReader-Tests'
}

{ #category : #accessing }
SpurImageTests class >> image [

	^ SpurImage onFile: '/Users/theo/Documents/Pharo/images/TestImage/TestImage.image'
	"^ SpurImage onFile: '/Users/theo/Documents/Pharo/images/CaroInsp/CaroInsp.image'"
]

{ #category : #accessing }
SpurImageTests class >> imageCandle [
	^ SpurImage onFile: '/Users/theo/Documents/Pharo/images/CaroInsp/CaroInsp.image'
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
1halt.

]
