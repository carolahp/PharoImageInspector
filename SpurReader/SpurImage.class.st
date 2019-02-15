"
""| version (4 bytes) | headerSize (4 bytes) | datasize (4 bytes) | old base address  (4 bytes) | special objects oop (4 bytes) | = 20 bytes
 | last hash (4 bytes)| saved window size (4 bytes) | headerFlags (4 bytes) | extraVMMemory (4bytes) | stack pages (2 bytes)   | = 18 bytes
 | native method zone size (2 bytes) | eden size (4 bytes) | semaphore table max size (2 bytes) | the2ndUnknownShort (2 bytes) | = 10 bytes
 | first segment size (4 bytes) | free old space (4 bytes) | = 8 bytes
 | The rest 8 bytes are empty""
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

{ #category : #accessing }
SpurImage >> firstObject [

	^ SpurObject on: headerSize + 1 image: self
]

{ #category : #accessing }
SpurImage >> headerSize [

	^ headerSize
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

{ #category : #accessing }
SpurImage >> oldBaseAddress [
	^ oldBaseAddress
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

{ #category : #accessing }
SpurImage >> specialObjectsArray [

	^ SpurObject on: specialObjectsArrayOop - oldBaseAddress + headerSize + 1 image: self
]
