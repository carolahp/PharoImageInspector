Class {
	#name : #SpurMethod,
	#superclass : #SpurObject,
	#category : #SpurReader
}

{ #category : #accessing }
SpurMethod >> lastLiteral [

	^ self literalAt: (self numberOfLiterals + 1)
]

{ #category : #accessing }
SpurMethod >> literalAt: anIndex [
	
	^ self slotAt: anIndex
]

{ #category : #accessing }
SpurMethod >> methodClass [
	
	| methodClassBinding |
	methodClassBinding := self lastLiteral.
	^ (methodClassBinding slotAt: 2) vmPrintOop
]

{ #category : #accessing }
SpurMethod >> methodHeader [	
	^ self slotAt: 1
]

{ #category : #accessing }
SpurMethod >> numberOfLiterals [
	"Mask to get the numberOfLietrals"
	^self methodHeader bitAnd: 16r7FFF
]

{ #category : #accessing }
SpurMethod >> penultimateLiteral [

	^ self literalAt: self numberOfLiterals
]

{ #category : #accessing }
SpurMethod >> selector [
	
	| selectorLiteral offset |
	selectorLiteral := self penultimateLiteral.
	offset := ((2 * (8 * selectorLiteral slots)) - 8) - selectorLiteral objectFormat.
	"Assume there is a ByteSymbol here; it can also be AdditionalMethodState"
	^ (selectorLiteral handle copyFrom: 9 to: 9 + offset) utf8Decoded
]
