Class {
	#name : #SpurVariableLayout,
	#superclass : #SpurLayout,
	#category : #SpurReader
}

{ #category : #'gt-inspector-extension' }
SpurVariableLayout >> allSlots [ 
	^ (1 to: self object numberOfSlots) collect: [ :index | self object slotAt: index ]
]

{ #category : #'gt-inspector-extension' }
SpurVariableLayout >> gtInspectorLayoutIn: composite [
	^ composite table
		title: 'Items';
		display: [ 
			self allSlots collectWithIndex: [ :slot :index | index -> slot  ] ];
		column: 'Index' evaluated: [:each |  each key ];
		column: 'Ialue' evaluated: [ :each | each value ];
		send: #value
]
