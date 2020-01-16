Class {
	#name : #SpurMethodInspectorTests,
	#superclass : #SpurReaderAbstractTests,
	#category : #'SpurReader-Tests'
}

{ #category : #tests }
SpurMethodInspectorTests >> someMethod [

	^ SpurMethod on: image arrayClass asSpurClass methodDictionary firstMethod address image: image
]

{ #category : #tests }
SpurMethodInspectorTests >> testCompiledMethodHasCompiledMethodFormat [

	self assert: self someMethod spurLayout isCompiledMethod
	
]

{ #category : #tests }
SpurMethodInspectorTests >> testCompiledMethodHasOwnerClass [

	self assertIsClass: self someMethod methodClass
]

{ #category : #tests }
SpurMethodInspectorTests >> testCompiledMethodSelectorIsByteSymbol [

	self assertIsSymbol: self someMethod selector
]
