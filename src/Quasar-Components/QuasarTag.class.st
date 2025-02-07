Class {
	#name : #QuasarTag,
	#superclass : #WATagBrush,
	#category : #'Quasar-Components'
}

{ #category : #'accessing - view style' }
QuasarTag >> dense [
	"Subclass would override, if supported"
]

{ #category : #'accessing - view style' }
QuasarTag >> denseIf: aBoolean [

	self viewStyle: #dense if: aBoolean
]

{ #category : #'accessing - view style' }
QuasarTag >> filledIf: aBoolean [

	self viewStyle: #filled if: aBoolean
]

{ #category : #'vue special attributes' }
QuasarTag >> key: anObject [
	
	self attributes at: ':key' put: anObject
]

{ #category : #'accessing - view style' }
QuasarTag >> outlineIf: aBoolean [

	self viewStyle: #outline if: aBoolean
]

{ #category : #'accessing - view style' }
QuasarTag >> outlinedIf: aBoolean [

	self viewStyle: #outlined if: aBoolean
]

{ #category : #'vue special attributes' }
QuasarTag >> ref: anObject [
	
	self attributes at: 'ref' put: anObject
]

{ #category : #'vue directives' }
QuasarTag >> vBind: key with: anObject [

	self attributes at: ':', key put: anObject
]

{ #category : #'vue directives' }
QuasarTag >> vCloak [

	self attributeAt: 'v-cloak' put: true
]

{ #category : #'vue directives' }
QuasarTag >> vClosePopUp [

	self attributeAt: 'v-close-popup' put: true
]

{ #category : #'vue directives' }
QuasarTag >> vClosePopUp: anObject [

	self attributeAt: 'v-close-popup' put: anObject
]

{ #category : #'vue directives' }
QuasarTag >> vElse: anObject [

	self attributes at: 'v-else' put: anObject
]

{ #category : #'vue directives' }
QuasarTag >> vElseIf: anObject [

	self attributes at: 'v-else-if' put: anObject
]

{ #category : #'vue directives' }
QuasarTag >> vFor: anObject [

	self attributes at: 'v-for' put: anObject
]

{ #category : #'vue directives' }
QuasarTag >> vIf: anObject [

	self attributes at: 'v-if' put: anObject
]

{ #category : #'vue directives' }
QuasarTag >> vModel: anObject [

	self attributes at: 'v-model' put: anObject
]

{ #category : #'vue directives' }
QuasarTag >> vOn: anEventName with: anObject [

	self attributes at: '@', anEventName put: anObject
]

{ #category : #'vue directives' }
QuasarTag >> vOnClick: aString [
	
	self attributes at: '@click' put: aString
]

{ #category : #'vue directives' }
QuasarTag >> vShow: anObject [

	self attributes at: 'v-show' put: anObject
]

{ #category : #'vue directives' }
QuasarTag >> vSlot: key with: anObject [

	self attributes at: 'v-slot:', key put: anObject
]

{ #category : #'accessing - view style' }
QuasarTag >> viewStyle: aStyle if: aBoolean [

	aBoolean ifTrue: [
		self perform: aStyle ]
]
