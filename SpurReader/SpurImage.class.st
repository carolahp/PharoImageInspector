"
""| version (4 bytes) | headerSize (4 bytes) | datasize (4 bytes) | old base address  (4 bytes) | special objects oop (4 bytes) | = 20 bytes
 | last hash (4 bytes)| saved window size (4 bytes) | headerFlags (4 bytes) | extraVMMemory (4bytes) | stack pages (2 bytes)   | = 18 bytes
 | native method zone size (2 bytes) | eden size (4 bytes) | semaphore table max size (2 bytes) | the2ndUnknownShort (2 bytes) | = 10 bytes
 | first segment size (4 bytes) | free old space (4 bytes) | = 8 bytes
 | The rest 8 bytes are empty""

(spur specialObjectsArray slotAt: 1) address = spur firstObject address.
"
Class {
	#name : #SpurImage,
	#superclass : #Object,
	#instVars : [
		'memory',
		'headerSize',
		'dataSize',
		'oldBaseAddress',
		'specialObjectsArrayOop'
	],
	#category : #SpurReader
}

{ #category : #'as yet unclassified' }
SpurImage class >> onFile: aFile [

	| memory |
	memory := aFile asFileReference binaryReadStream contents.
	^ self basicNew
		memory: memory;
		initialize;
		yourself
]

{ #category : #constants }
SpurImage >> arrayClassIndexPun [
	^ 16
]

{ #category : #constants }
SpurImage >> arrayFormat [
	^ 2
]

{ #category : #'special-classes' }
SpurImage >> byteArrayClass [
	^ self specialObjectsArray slotAt: 27
]

{ #category : #constants }
SpurImage >> classIndexFieldWidth [
	"22-bit class mask => ~ 4M classes"
	^22
]

{ #category : #'special-objects' }
SpurImage >> classTableFirstPage [
	^ self hiddenRootsObj classTableFirstPage
]

{ #category : #constants }
SpurImage >> classTableMajorIndexShift [
	"1024 entries per page (2^10); 22 bit classIndex implies 2^12 pages"
	^10
]

{ #category : #constants }
SpurImage >> classTableMinorIndexMask [
	"1024 entries per page (2^10); 22 bit classIndex implies 2^12 pages"
	"self basicNew classTableMinorIndexMask"
	^1 << self classTableMajorIndexShift - 1
]

{ #category : #constants }
SpurImage >> classTablePageSize [

	^1 << self classTableMajorIndexShift
]

{ #category : #constants }
SpurImage >> classTableRootSlots [
	"Answer the number of slots for class table pages in the hidden root object."
	^1 << (self classIndexFieldWidth - self classTableMajorIndexShift)
]

{ #category : #'special-objects' }
SpurImage >> falseObject [
	^ self nilObject nextObject
]

{ #category : #'special-objects' }
SpurImage >> firstObject [

	^ SpurObject on: headerSize + 1 image: self
]

{ #category : #'special-objects' }
SpurImage >> freeListObj [

	^ self trueObject 	nextObject
]

{ #category : #accessing }
SpurImage >> headerSize [

	^ headerSize
]

{ #category : #'special-objects' }
SpurImage >> hiddenRootsObj [

	^ SpurHiddenRoots 
		on: self freeListObj nextObject address
		image: self
]

{ #category : #constants }
SpurImage >> identityHashHalfWordMask [

	^16r3fffff
]

{ #category : #constants }
SpurImage >> indexInClassTable: objOop [
	" Returns the index in the classTable of the class stored in objOop"
	^ 1 + (self rawHashBitsOf: objOop)
]

{ #category : #accessing }
SpurImage >> initialize [

	super initialize.
	self readImageHeader.
]

{ #category : #accessing }
SpurImage >> memory [
	^ memory
]

{ #category : #accessing }
SpurImage >> memory: aCollection [ 
	memory := aCollection
]

{ #category : #'special-objects' }
SpurImage >> nilObject [
	^ self firstObject
]

{ #category : #accessing }
SpurImage >> oldBaseAddress [
	^ oldBaseAddress
]

{ #category : #constants }
SpurImage >> rawHashBitsOf: objOop [
	" Returns the index in the classTable of the class stored in objOop"
	self flag: #endianness.
	^((memory unsignedLongAt: objOop + 4 bigEndian: false) bitAnd: self identityHashHalfWordMask)
]

{ #category : #accessing }
SpurImage >> readImageHeader [

	| version lastHash savedWindowSize headerFlags |
	version := (memory copyFrom: 1 to: 4) unsignedLongAt: 1 bigEndian: false.
	headerSize := (memory copyFrom: 5 to: 8)
		unsignedLongAt: 1
		bigEndian: false.
	dataSize := (memory copyFrom: 9 to: 12)
		unsignedLongAt: 1
		bigEndian: false.
	self assert: headerSize + dataSize = memory size.

	oldBaseAddress := (memory copyFrom: 13 to: 16)
		unsignedLongAt: 1
		bigEndian: false.
	specialObjectsArrayOop := (memory copyFrom: 17 to: 20)
		unsignedLongAt: 1
		bigEndian: false.
	lastHash := (memory copyFrom: 21 to: 24)
		unsignedLongAt: 1
		bigEndian: false.
	savedWindowSize := (memory copyFrom: 25 to: 28)
		unsignedLongAt: 1
		bigEndian: false.
	headerFlags := (memory copyFrom: 29 to: 32)
		unsignedLongAt: 1
		bigEndian: false.
]

{ #category : #'special-classes' }
SpurImage >> smallIntegerClass [
	^ self specialObjectsArray slotAt: 6
]

{ #category : #accessing }
SpurImage >> specialObjectsArray [

	^ SpurObject on: specialObjectsArrayOop - oldBaseAddress + headerSize + 1 image: self
]

{ #category : #'special-objects' }
SpurImage >> trueObject [
	^ self falseObject nextObject
]
