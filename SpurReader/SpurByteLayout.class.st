Class {
	#name : #SpurByteLayout,
	#superclass : #SpurLayout,
	#category : #SpurReader
}

{ #category : #accessing }
SpurByteLayout >> slotAt: anInteger [ 
	
	| bodyAddress isLastSlot length |
	self assert: anInteger > 0 description: 'Index must be greater than 0'.
	self assert: self numberOfSlots >= anInteger description: 'Index Out of Bounds'.

	isLastSlot := anInteger = self numberOfSlots .
	 
	length := isLastSlot 
						ifTrue: [ (self object format % 16 ) // self wordSize  ]
						ifFalse: [ self wordSize - 1 ].	
	bodyAddress := self address + self headerSize + ((anInteger - 1) * self wordSize).
	^ (self memory copyFrom: bodyAddress to: bodyAddress + length).
	
]
