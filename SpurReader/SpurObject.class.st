"
spur := SpurImage onFile: Smalltalk imagePath.
firstObject := spur firstObject.
secondObject := firstObject nextObject.
thirdObject := secondObject nextObject.
fourthObject := thirdObject nextObject.
fifthObject := fourthObject nextObject.

firstObject basicNumberOfSlots.
secondObject basicNumberOfSlots.
thirdObject basicNumberOfSlots.
fourthObject classIndex.

fifthObject classIndex.
fifthObject format.
fifthObject numberOfSlots.

fifthObject nextObject nextObject nextObject nextObject nextObject nextObject numberOfSlots.

(spur specialObjectsArray slotAt: 1) address = spur firstObject address.

1) Podemos encontrar a nil?
2) Podemos encontrar a true?
3) Podemos encontrar a false?

4) Podemos encontrar la tabla de clases?
  4.1) Como a partir de un class index (en el header del objeto) encontramos una clase en la tabla.
  4.2) Una vez que tenes la clase, recuperar el nombre de la clase (7ma variable es el nombre)
  4.3) Transformar un string en la imagen a un string normal.
  4.4) hacer un pretty print del objeto:
     - nombre de la clase
     - tipo de objeto / format
     - tamaño
"
Class {
	#name : #SpurObject,
	#superclass : #Object,
	#instVars : [
		'address',
		'image'
	],
	#category : #SpurReader
}

{ #category : #'as yet unclassified' }
SpurObject class >> on: address image: anImage [

	^ self new
		address: address;
		image: anImage;
		yourself
]

{ #category : #accessing }
SpurObject >> address [
	^ address
]

{ #category : #accessing }
SpurObject >> address: anInteger [ 
	address := anInteger
]

{ #category : #accessing }
SpurObject >> basicNumberOfSlots [

	^ self headerInteger >> (self headerSize * 8 "bits" - 8 "number of slots mask size")
]

{ #category : #'as yet unclassified' }
SpurObject >> byteSize [
	
	| numberOfSlots |
	numberOfSlots := self numberOfSlots.
	^ (numberOfSlots = 0
		ifTrue: [ 1 ]
		ifFalse: [ numberOfSlots ]) * self wordSize.
]

{ #category : #accessing }
SpurObject >> classIndex [
	
	| first32Bytes |
	first32Bytes := self memory unsignedLongAt: address bigEndian: false.
	^ first32Bytes bitAnd: (2 raisedTo: 22) -1
]

{ #category : #'as yet unclassified' }
SpurObject >> endAddress [

	| basicSize padding |
	"All objects start aligned to 64 bits.
	This means all objects FINISH aligned to 64 bits too"
	basicSize := self headerSize + self byteSize.
	padding := basicSize % 8.
	^ address + basicSize + padding
]

{ #category : #accessing }
SpurObject >> format [
	
	| first32Bytes |
	first32Bytes := self memory unsignedLongAt: address bigEndian: false.
	^ (first32Bytes >> 24) bitAnd: 2r11111
]

{ #category : #accessing }
SpurObject >> headerInteger [

	^ self memory integerAt: address size: 8 signed: false
]

{ #category : #'as yet unclassified' }
SpurObject >> headerSize [

	^ 8 "always 64 bits"
]

{ #category : #accessing }
SpurObject >> image: anImage [ 
	image := anImage
]

{ #category : #accessing }
SpurObject >> memory [

	^ image memory
]

{ #category : #'as yet unclassified' }
SpurObject >> nextObject [

	| maybeObject |
	maybeObject := SpurObject on: self endAddress + self headerSize image: image.
	^ maybeObject basicNumberOfSlots = 16rFF
		ifTrue: [ maybeObject ]
		ifFalse: [ SpurObject on: self endAddress image: image ].
]

{ #category : #'as yet unclassified' }
SpurObject >> numberOfSlots [

	| slotsInHeader |
	slotsInHeader := self basicNumberOfSlots.
	slotsInHeader == 16rFF
		ifTrue: [ ^ self previousHeaderInteger ].
	^ slotsInHeader
]

{ #category : #'as yet unclassified' }
SpurObject >> oop [

	^ address
]

{ #category : #accessing }
SpurObject >> previousHeaderInteger [

	^ self memory integerAt: address - self headerSize size: 4 signed: false
]

{ #category : #accessing }
SpurObject >> slotAt: anInteger [ 
	
	| bodyAddress |
	bodyAddress := address + self headerSize + ((anInteger - 1) * self wordSize).
	^ SpurObject on: (self memory longAt: bodyAddress bigEndian: false) - image oldBaseAddress + image headerSize + 1 image: image
]

{ #category : #'as yet unclassified' }
SpurObject >> wordSize [

	^ 4
]
