Class {
	#name : #SpurByteLayout,
	#superclass : #SpurLayout,
	#category : #SpurReader
}

{ #category : #accessing }
SpurByteLayout >> slotAt: anInteger [ 
	
	| bodyAddress pointerIndex |
	
	self assert: anInteger > 0 description: 'Index must be greater than 0'.
	self assert: self numberOfSlots * self wordSize >= anInteger description: 'Index Out of Bounds'.
	"the number of the slot that contains the pointer to the 32 bits "
	
	bodyAddress := self address + self headerSize + ((anInteger - 1)).
	
	^ (self memory at: bodyAddress) asCharacter.
	
]
