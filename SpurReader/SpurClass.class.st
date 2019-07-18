Class {
	#name : #SpurClass,
	#superclass : #SpurObject,
	#category : #SpurReader
}

{ #category : #'as yet unclassified' }
SpurClass >> classFormat [
	^ self slotAt: self slotIndexForClassFormat
]

{ #category : #accessing }
SpurClass >> className [ 
	^ (self slotAt: self slotIndexForClassName) asString
]

{ #category : #'gt-inspector-extension' }
SpurClass >> gtInspectorHeaderIn: composite [
	<gtInspectorPresentationOrder: 2>
	^ composite table
		title: 'SpurHeader';
		display: [ 
			{ 'format:' -> self classFormat .
			  'instSpec' -> self instSpec .
			  'instSize' -> self instSize} ];
		column: 'Key' evaluated: [:each |  each key ];
		column: 'Value' evaluated: [ :each | each value ]";
		send: #value"

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
