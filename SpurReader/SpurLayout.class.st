Class {
	#name : #SpurLayout,
	#superclass : #Object,
	#instVars : [
		'object'
	],
	#category : #SpurReader
}

{ #category : #'as yet unclassified' }
SpurLayout class >> layoutClassFromFormat: objFormat [
	"(objFormat = 1)
		ifTrue: [ ^ SpurFixedLayout ]."
	
	(objFormat < 24 and: [ objFormat > 15 ])
		ifTrue: [ ^ SpurByteLayout ].
		
	^ SpurFixedLayout 
	
]

{ #category : #'as yet unclassified' }
SpurLayout class >> on: aSpurObject image: aSpurImage [
	| layoutClass |
	 
	layoutClass := self layoutClassFromFormat: aSpurObject format.
	
	^ layoutClass new 
		object: aSpurObject.
]

{ #category : #accessing }
SpurLayout >> address [
	^ self object address
]

{ #category : #accessing }
SpurLayout >> asLocalByteArray [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SpurLayout >> basicNumberOfSlots [
	^ self headerInteger >> (self headerSize * 8 "bits" - 8 "number of slots mask size")
]

{ #category : #accessing }
SpurLayout >> byteSize [
	^ self object byteSize .
]

{ #category : #accessing }
SpurLayout >> headerInteger [
	^ self object headerInteger 
]

{ #category : #accessing }
SpurLayout >> headerSize [
	^ self object headerSize
]

{ #category : #accessing }
SpurLayout >> image [
	^ self object image
]

{ #category : #accessing }
SpurLayout >> memory [
	^ self object memory
]

{ #category : #accessing }
SpurLayout >> numberOfSlots [

	| slotsInHeader |
	slotsInHeader := self basicNumberOfSlots.
	slotsInHeader == 16rFF
		ifTrue: [ ^ self previousHeaderInteger ].
	^ slotsInHeader
]

{ #category : #accessing }
SpurLayout >> object [
	^ object
]

{ #category : #accessing }
SpurLayout >> object: anObject [
	object := anObject
]

{ #category : #accessing }
SpurLayout >> previousHeaderInteger [ 
	^ self object previousHeaderInteger
]

{ #category : #accessing }
SpurLayout >> wordSize [
	^ self object wordSize
]
