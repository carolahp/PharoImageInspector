Class {
	#name : #SpurClass,
	#superclass : #SpurObject,
	#category : #SpurReader
}

{ #category : #'accessing - instance variables' }
SpurClass >> allInstanceVariableNames [
	^ (1 to: self numberOfSlots) collect: [ :index | self slotAt: index ] .
]

{ #category : #'as yet unclassified' }
SpurClass >> classFormat [
	^ self slotAt: self slotIndexForClassFormat
]

{ #category : #accessing }
SpurClass >> className [ 
	^ [(self slotAt: self slotIndexForClassName) asLocalByteArray asString] on: Error 
		do: [ (self slotAt: self slotIndexForMetaclassSoleInstance ) asSpurClass className , ' class'] 
	
]

{ #category : #'gt-inspector-extension' }
SpurClass >> gtInspectorLayoutIn: composite [
	^ composite table
		title: 'asd';
		display: [ 
			{ 
			'self' -> self .
			'superclass' -> self spSuperclass  .    
			'format:' -> self classFormat .
			'instSpec' -> self instSpec .
			'instSize' -> self instSize} ];
		column: 'Key' evaluated: [:each |  each key ];
		column: 'Value' evaluated: [ :each | each value ];
		send: #value

]

{ #category : #'accessing-header' }
SpurClass >> instSize [
	"Answer the number of named instance variables
	(as opposed to indexed variables) of the receiver.
	 Above Cog Spur the class format is
		<5 bits inst spec><16 bits inst size>"
	^self classFormat bitAnd: 16rFFFF
]

{ #category : #'accessing-header' }
SpurClass >> instSpec [ 
	^ (self classFormat bitShift: -16) bitAnd: 16r1F
]

{ #category : #'accessing - instance variables' }
SpurClass >> printOn: aStream [
	aStream nextPutAll: self className
	"aStream nextPutAll: self className"
	
]

{ #category : #accessing }
SpurClass >> spSuperclass [
	| superclassOrNil |
	superclassOrNil := (self slotAt: self slotIndexForSuperclass).
	(superclassOrNil spIsNil)
		ifTrue: [ ^ superclassOrNil ]
		ifFalse: [ ^ superclassOrNil asSpurClass  ]
	 
]
