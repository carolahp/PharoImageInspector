Class {
	#name : #SpurFixedLayout,
	#superclass : #SpurLayout,
	#category : #SpurReader
}

{ #category : #accessing }
SpurFixedLayout >> asLocalByteArray [
	^ self shouldNotImplement 
]

{ #category : #accessing }
SpurFixedLayout >> slotAt: anInteger [ 
	
	| bodyAddress first32Bits last2bits lastBit |
	self assert: anInteger > 0 description: 'Index must be greater than 0'.
	self assert: self numberOfSlots >= anInteger description: 'Index Out of Bounds'.

	bodyAddress := self address + self headerSize + ((anInteger - 1) * self wordSize).
	first32Bits := self memory longAt: bodyAddress bigEndian: false.
	last2bits := first32Bits bitAnd: 2r11.
	
	last2bits ~= 0 
		ifTrue: [ 
			"is inmediate" 
			lastBit := last2bits bitAnd: 2r01.
			lastBit = 1
				ifTrue: [ 
					"Smallinteger"
					 ^ (first32Bits >> 1) as31BitSmallInt ]
				ifFalse: [ 
					"Character"
					self halt: 'wrong layout' ]  ].
	^ SpurObject on: first32Bits - self image oldBaseAddress + self image headerSize + 1 image: self image
]
