"
""| version (4 bytes) | headerSize (4 bytes) | datasize (4 bytes) | old base address  (4 bytes) | special objects oop (4 bytes) | = 20 bytes
 | last hash (4 bytes)| saved window size (4 bytes) | headerFlags (4 bytes) | extraVMMemory (4bytes) | stack pages (2 bytes)   | = 18 bytes
 | native method zone size (2 bytes) | eden size (4 bytes) | semaphore table max size (2 bytes) | the2ndUnknownShort (2 bytes) | = 10 bytes
 | first segment size (4 bytes) | free old space (4 bytes) | = 8 bytes
 | The rest 8 bytes are empty""

asd := Smalltalk imagePath asFileReference binaryReadStream contents.

version := (asd copyFrom: 1 to: 4) unsignedLongAt: 1 bigEndian: false.
headerStart := 1.

headerSize := (asd copyFrom: 5 to: 8) unsignedLongAt: 1 bigEndian: false.
dataSize := (asd copyFrom: 9 to: 12) unsignedLongAt: 1 bigEndian: false.
self assert: (headerSize + dataSize) = asd size.

oldBaseAddress := (asd copyFrom: 13 to: 16) unsignedLongAt: 1 bigEndian: false.
specialObjectsArrayOop := (asd copyFrom: 17 to: 20) unsignedLongAt: 1 bigEndian: false.

lastHash := (asd copyFrom: 21 to: 24) unsignedLongAt: 1 bigEndian: false.
savedWindowSize := (asd copyFrom: 25 to: 28) unsignedLongAt: 1 bigEndian: false.
headerFlags := (asd copyFrom: 29 to: 32) unsignedLongAt: 1 bigEndian: false.

specialObjectsArrayFixedOop := specialObjectsArrayOop - oldBaseAddress + headerSize + 1.
(asd copyFrom: specialObjectsArrayFixedOop + 4 to: specialObjectsArrayFixedOop + 7) longAt: 1 bigEndian: false.

""----------------------------------""

firstObject endAddress.

firstObject := SpurObjectReader on: headerSize + 1 memory: asd.
secondObject := firstObject nextObject.
thirdObject := secondObject nextObject.
fourthObject := thirdObject nextObject.
fifthObject := fourthObject nextObject.

firstObject basicNumberOfSlots.
secondObject basicNumberOfSlots.
thirdObject basicNumberOfSlots.
fourthObject classIndex.

fifthObject classIndex.
fifthObject format.
fifthObject numberOfSlots.

fifthObject nextObject numberOfSlots.

secondObjectOop := (asd at: firstObjectEnd + 4 + 7) = 16rFF
	ifTrue: [ firstObjectEnd + 4 ]
	ifFalse: [ firstObjectEnd ].
secondObjectSlots := asd at: secondObjectOop +7.
secondObjectSize := secondObjectSlots = 0
	ifTrue: [ 1 * 4 ]
	ifFalse: [ secondObjectSlots = 16rFF
			ifTrue: [ self halt ]
			ifFalse: [ secondObjectSlots * 4 ] ].
secondObjectEnd := secondObjectOop + secondObjectSize.

nilObject := (asd copyFrom: 65 to: 65 + 3) asInteger.
nilObject asInteger >> (64 - 8).
(nilObject asInteger >> 24) bitAnd: 2r11111.

trueObject := (asd copyFrom: 69 to: 69 + 3) asInteger.
trueObject asInteger >> (64 - 8).
(trueObject asInteger >> 24) bitAnd: 2r11111.

falseObject := (asd copyFrom: 73 to: 77) asInteger.
trueObject asInteger >> (64 - 8).
(trueObject asInteger >> 24) bitAnd: 2r11111.
"
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
