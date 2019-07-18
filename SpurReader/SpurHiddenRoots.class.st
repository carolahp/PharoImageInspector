Class {
	#name : #SpurHiddenRoots,
	#superclass : #SpurObject,
	#category : #SpurReader
}

{ #category : #'as yet unclassified' }
SpurHiddenRoots >> classOrNilAtIndex: classIndex [
	
	| classTablePage nilObj |

	"self assert: (classIndex <= self tagMask or: [classIndex >= image arrayClassIndexPun])."
	nilObj := image nilObject.
	classTablePage := self classTablePageNumber: (classIndex >> image classTableMajorIndexShift) + 1.
	classTablePage = nilObj ifTrue:
		[^nilObj].
	^ (classTablePage
		slotAt: (classIndex bitAnd: image classTableMinorIndexMask) + 1) asSpurClass
]

{ #category : #'as yet unclassified' }
SpurHiddenRoots >> classTableFirstPage [
	^ self classTablePageNumber: 1
]

{ #category : #'as yet unclassified' }
SpurHiddenRoots >> classTablePageNumber: anInteger [
	"anInteger is 1 based"
	| classTable |
	classTable := SpurObject
						on:(self slotAt:anInteger) address
						image: image.
	self assert: classTable format = image arrayFormat.
	self assert: classTable classIndex = image arrayClassIndexPun.
	^ classTable
]
