Class {
	#name : #SpurObjectReader,
	#superclass : #Object,
	#instVars : [
		'address',
		'memory'
	],
	#category : #SpurReader
}

{ #category : #'as yet unclassified' }
SpurObjectReader class >> on: address memory: aMemory [

	^ self new
		address: address;
		memory: aMemory;
		yourself
]

{ #category : #accessing }
SpurObjectReader >> address: anInteger [ 
	address := anInteger
]

{ #category : #accessing }
SpurObjectReader >> basicNumberOfSlots [

	^ self headerInteger >> (self headerSize * 8 "bits" - 8 "number of slots mask size")
]

{ #category : #'as yet unclassified' }
SpurObjectReader >> byteSize [
	
	| numberOfSlots |
	numberOfSlots := self numberOfSlots.
	^ (numberOfSlots = 0
		ifTrue: [ 1 ]
		ifFalse: [ numberOfSlots ]) * self wordSize.
]

{ #category : #accessing }
SpurObjectReader >> classIndex [
	
	| first32Bytes |
	first32Bytes := memory unsignedLongAt: address bigEndian: false.
	^ first32Bytes bitAnd: (2 raisedTo: 22) -1
]

{ #category : #'as yet unclassified' }
SpurObjectReader >> endAddress [

	| basicSize padding |
	"All objects start aligned to 64 bits.
	This means all objects FINISH aligned to 64 bits too"
	basicSize := self headerSize + self byteSize.
	padding := basicSize % 8.
	^ address + basicSize + padding
]

{ #category : #accessing }
SpurObjectReader >> format [
	
	| first32Bytes |
	first32Bytes := memory unsignedLongAt: address bigEndian: false.
	^ (first32Bytes >> 24) bitAnd: 2r11111
]

{ #category : #accessing }
SpurObjectReader >> headerInteger [

	^ memory integerAt: address size: 8 signed: false
]

{ #category : #'as yet unclassified' }
SpurObjectReader >> headerSize [

	^ 8 "always 64 bits"
]

{ #category : #accessing }
SpurObjectReader >> memory: aCollection [ 
	memory := aCollection
]

{ #category : #'as yet unclassified' }
SpurObjectReader >> nextObject [

	| maybeObject |
	maybeObject := SpurObjectReader on: self endAddress + self headerSize memory: memory.
	^ maybeObject basicNumberOfSlots = 16rFF
		ifTrue: [ maybeObject ]
		ifFalse: [ SpurObjectReader on: self endAddress memory: memory ].
]

{ #category : #'as yet unclassified' }
SpurObjectReader >> numberOfSlots [

	| slotsInHeader |
	slotsInHeader := self basicNumberOfSlots.
	slotsInHeader == 16rFF
		ifTrue: [ ^ self previousHeaderInteger ].
	^ slotsInHeader
]

{ #category : #'as yet unclassified' }
SpurObjectReader >> oop [

	^ address
]

{ #category : #accessing }
SpurObjectReader >> previousHeaderInteger [

	^ memory integerAt: address - self headerSize size: 4 signed: false
]

{ #category : #'as yet unclassified' }
SpurObjectReader >> wordSize [

	^ 4
]
