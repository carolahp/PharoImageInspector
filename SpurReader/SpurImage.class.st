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
	^ self onMemory: memory
]

{ #category : #'as yet unclassified' }
SpurImage class >> onMemory: aByteArray [

	^ self basicNew
		memory: aByteArray;
		initialize;
		yourself
]

{ #category : #'as yet unclassified' }
SpurImage class >> onSpurSimulator: aSpur32BitMMLESimulator [
	| memory nilOop |
	nilOop := aSpur32BitMMLESimulator nilObject. 
	memory := aSpur32BitMMLESimulator memory asByteArray.
	"memory := fullMemory  copyFrom: nilOop + 1 to: fullMemory size."
	  
	^ self basicNew
		memory: memory;
		headerSize: nilOop;
		specialObjectsArrayOop: aSpur32BitMMLESimulator specialObjectsOop;
		oldBaseAddress: nilOop;
		yourself
]

{ #category : #'special-classes' }
SpurImage >> arrayClass [
	"indexInClassTable 51"
	^ self specialObjectsArray slotAt: 8
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
	"indexInClassTable 50"
	^ self specialObjectsArray slotAt: 27
]

{ #category : #'special-classes' }
SpurImage >> byteStringClass [
	"indexInClassTable 52"
	^ self specialObjectsArray slotAt: 7
]

{ #category : #'special-classes' }
SpurImage >> characterClass [
	"indexInClassTable 2"
	^ self specialObjectsArray slotAt: 20
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

{ #category : #'gt-inspector-extension' }
SpurImage >> gtInspectorSpecialObjectsArrayIn: composite [
	<gtInspectorPresentationOrder: 1>
	
	^ (self specialObjectsArray gtInspectorLayoutIn: composite) title: 'SOArray' 
]

{ #category : #accessing }
SpurImage >> headerSize [

	^ headerSize
]

{ #category : #accessing }
SpurImage >> headerSize: anInteger [ 
	headerSize := anInteger
]

{ #category : #'special-objects' }
SpurImage >> hiddenRootsObj [

	^ SpurHiddenRoots 
		on: self freeListObj nextObject address
		image: self
]

{ #category : #accessing }
SpurImage >> initialize [

	super initialize.
	self readImageHeader.
]

{ #category : #'special-classes' }
SpurImage >> largeNegativeIntegerClass [
	"indexInClassTable 32"
	^ self specialObjectsArray slotAt: 43
]

{ #category : #'special-classes' }
SpurImage >> largePositiveIntegerClass [
	"indexInClassTable 33"
	^ self specialObjectsArray slotAt: 14
]

{ #category : #accessing }
SpurImage >> memory [
	^ memory
]

{ #category : #accessing }
SpurImage >> memory: aCollection [ 
	memory := aCollection
]

{ #category : #'special-classes' }
SpurImage >> messageClass [
	"indexInClassTable 35"
	^ self specialObjectsArray slotAt: 16
]

{ #category : #'special-objects' }
SpurImage >> nilObject [
	^ self firstObject
]

{ #category : #accessing }
SpurImage >> oldBaseAddress [
	^ oldBaseAddress
]

{ #category : #access }
SpurImage >> oldBaseAddress: anInteger [ 
	oldBaseAddress := anInteger
]

{ #category : #'special-classes' }
SpurImage >> pointClass [
	"indexInClassTable 54"
	^ self specialObjectsArray slotAt: 13
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
SpurImage >> semaphoreClass [
	"indexInClassTable 48"
	^ self specialObjectsArray slotAt: 19
]

{ #category : #'special-classes' }
SpurImage >> smallIntegerClass [
	"indexInClassTable 1"
	^ self specialObjectsArray slotAt: 6
]

{ #category : #accessing }
SpurImage >> specialObjectsArray [

	^ SpurObject on: specialObjectsArrayOop - oldBaseAddress + headerSize + 1 image: self
]

{ #category : #accessing }
SpurImage >> specialObjectsArrayOop: anInteger [ 
	specialObjectsArrayOop := anInteger
]

{ #category : #'special-objects' }
SpurImage >> trueObject [
	^ self falseObject nextObject
]
