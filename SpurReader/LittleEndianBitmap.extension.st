Extension { #name : #LittleEndianBitmap }

{ #category : #'*SpurReader' }
LittleEndianBitmap >> asByteArrayFromLittleEndian [
	" Implemented to bypass problem with original LittleEndianBitmap >> asByteArray which depends on SmalltalkImage isLittleEndian unexistent message"
	
	"Faster way to make a byte array from me.
	copyFromByteArray: makes equal Bitmap."
	
	| f bytes hack |
	
	f := Form extent: 4@self size depth: 8 bits: self.
	bytes := ByteArray new: self size * 4.
	hack := Form new hackBits: bytes.
	hack swapEndianness.
	hack copyBits: f boundingBox
		from: f
		at: 0@0
		clippingBox: hack boundingBox
		rule: Form over
		fillColor: nil
		map: nil.
	"f displayOn: hack."
	^bytes
	"| v | v := LittleEndianBitmap withAll: (1 to: 4).
	 [v asByteArray] bench '19,700,000 per second. 50.8 nanoseconds per run.'"
	"| v | v := Bitmap withAll: (1 to: 4).
	[v asByteArray] bench '977,000 per second. 1.02 microseconds per run.'"
]
