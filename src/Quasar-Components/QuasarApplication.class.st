Class {
	#name : #QuasarApplication,
	#superclass : #WAComponent,
	#instVars : [
		'quasarVersion',
		'colorTheme',
		'reactiveObjects',
		'quasarData',
		'vueRefs'
	],
	#category : #'Quasar-Components'
}

{ #category : #testing }
QuasarApplication class >> canBeRoot [
	^ true
]

{ #category : #'instance creation' }
QuasarApplication class >> mdqRegisterDeployment: aName [
	| app |

	self environment at: #WADevelopmentConfiguration ifPresent: [ :class |
		WAAdmin applicationDefaults removeParent: WADevelopmentConfiguration instance ].

	app := WAAdmin register: self asApplicationAt: aName.
	app addLibrary: JQGoogleLibrary.
	^ app
]

{ #category : #accessing }
QuasarApplication >> appId [

	^ 'qId'
]

{ #category : #accessing }
QuasarApplication >> applicationTitle [

	self subclassResponsibility
]

{ #category : #accessing }
QuasarApplication >> colorTheme [

	^ colorTheme
]

{ #category : #accessing }
QuasarApplication >> colorTheme: anObject [

	colorTheme := anObject
]

{ #category : #accessing }
QuasarApplication >> faviconUrl [
	"Subclasses should override"

	^ '/files/WAToolFiles/help.png'
]

{ #category : #initialization }
QuasarApplication >> initialize [

	super initialize.

	self vueRefsClear.
	self quasarDataClear.
	self reactiveObjectsClear
]

{ #category : #login }
QuasarApplication >> isLoggedIn [

	^ self loginComponent notNil and: [ self loginComponent isLoggedIn ]
]

{ #category : #accessing }
QuasarApplication >> jsdelivrUrlFragment [

	^ 'https://cdn.jsdelivr.net/npm/quasar@<1s>/dist/' expandMacrosWith: self quasarVersionLazy
]

{ #category : #logging }
QuasarApplication >> logFormat: aFormatString with: aValue [

	self logString: (aFormatString format: (Array with: aValue))
]

{ #category : #logging }
QuasarApplication >> logFormat: aFormatString with: aValue1 with: aValue2 [

	self logString: (aFormatString format: (Array with: aValue1 with: aValue2))
]

{ #category : #logging }
QuasarApplication >> logFormat: aFormatString with: aValue1 with: aValue2 with: aValue3 [

	self logString: (aFormatString format: (Array with: aValue1 with: aValue2 with: aValue3))
]

{ #category : #logging }
QuasarApplication >> logFormat: aFormatString with: aValue1 with: aValue2 with: aValue3 with: aValue4 [

	self logString: (aFormatString format: (Array with: aValue1 with: aValue2 with: aValue3 with: aValue4))
]

{ #category : #logging }
QuasarApplication >> logFormat: aFormatString with: aValue1 with: aValue2 with: aValue3 with: aValue4 with: aValue5 [

	self logString: (aFormatString format: (Array with: aValue1 with: aValue2 with: aValue3 with: aValue4 with: aValue5))
]

{ #category : #logging }
QuasarApplication >> logString: aString [

	Transcript crShow: aString
]

{ #category : #login }
QuasarApplication >> logout [

	self loginComponent
		ifNotNil: [ :component |
			component loggedOut ]
		ifNil: [
			self session ifNotNil: [ :value | value unregister ].
			self redirect ]
]

{ #category : #'rendering - quasar hooks' }
QuasarApplication >> quasarConfigContentOn: aJSStream with: html [
	"Subclasses may override"
]

{ #category : #'rendering - quasar' }
QuasarApplication >> quasarConfigOn: aJSStream with: html [

	aJSStream nextPutAll: 'config: {'.
	self quasarConfigContentOn: aJSStream with: html.
	aJSStream nextPutAll: '}'.
]

{ #category : #accessing }
QuasarApplication >> quasarCssUrl [

	^ self jsdelivrUrlFragment, 'quasar.rtl.prod.css'
]

{ #category : #accessing }
QuasarApplication >> quasarData [

	^ quasarData
]

{ #category : #accessing }
QuasarApplication >> quasarData: anObject [

	quasarData := anObject
]

{ #category : #accessing }
QuasarApplication >> quasarDataAdd: anObject [

	self quasarData addIfNotPresent: anObject
]

{ #category : #accessing }
QuasarApplication >> quasarDataClear [

	self quasarData: OrderedCollection new
]

{ #category : #accessing }
QuasarApplication >> quasarDataRemove: anObject [

	self quasarData remove: anObject ifAbsent: [ nil ]
]

{ #category : #accessing }
QuasarApplication >> quasarJsUrl [

	^ self jsdelivrUrlFragment, 'quasar.umd.prod.js'
]

{ #category : #'rendering - quasar' }
QuasarApplication >> quasarOnLoadOn: aJSStream with: html [

	aJSStream
		nextPutAll: 'const { useQuasar } = Quasar;';
		nextPutAll: 'const { ref } = Vue;';
		nextPutAll: 'const app = Vue.createApp({'.
	self quasarSetupOn: aJSStream with: html.
	aJSStream nextPutAll: '});'.
	aJSStream nextPutAll: 'app.use(Quasar, {'.
	self quasarConfigOn: aJSStream with: html.
	aJSStream nextPutAll: '});'.
	aJSStream nextPutAll: 'app.mount("#', self appId, '")'
]

{ #category : #'rendering - quasar hooks' }
QuasarApplication >> quasarSetupContentOn: aJSStream with: html [
	| exports vueRefsDefine list |

	exports := ',' join: (self quasarData, (self vueRefs keys)).

	list := OrderedCollection new.
	self vueRefs keysAndValuesDo: [ :key :value | list add: 'const ', key, ' = ref(', value asJson, ')' ].
	vueRefsDefine := ';' join: list.

	aJSStream
		nextPutAll: vueRefsDefine, ';';
		yourself
]

{ #category : #'rendering - quasar' }
QuasarApplication >> quasarSetupOn: aJSStream with: html [

	aJSStream nextPutAll: 'setup() {'.
	aJSStream nextPutAll: 'const $q = useQuasar();'.
	self quasarSetupReactiveObjectsOn: aJSStream.
	self quasarSetupContentOn: aJSStream with: html.
	self quasarSetupReturnOn: aJSStream with: html.
	aJSStream nextPutAll: '}'.
]

{ #category : #'rendering - quasar' }
QuasarApplication >> quasarSetupReactiveObjectsOn: aJSStream [

	self reactiveObjects do: [ :eachReactiveObject | eachReactiveObject quasarSetupOn: aJSStream ]
]

{ #category : #'rendering - quasar hooks' }
QuasarApplication >> quasarSetupReturnContentOn: aJSStream with: html [
	"Subclasses may override"
]

{ #category : #'rendering - quasar' }
QuasarApplication >> quasarSetupReturnOn: aJSStream with: html [
	| needsComma |

	needsComma := false.
	aJSStream nextPutAll: 'return {'.
	self reactiveObjects ifNotEmpty: [
		self quasarSetupReturnReactiveObjectsOn: aJSStream html: html.
		needsComma := true ].
	needsComma ifTrue: [ aJSStream nextPut: $, ].
	self quasarSetupReturnContentOn: aJSStream with: html.
	aJSStream nextPutAll: '}'
]

{ #category : #'rendering - quasar' }
QuasarApplication >> quasarSetupReturnReactiveObjectsOn: aJSStream html: html [

	self reactiveObjects
		do: [ :eachReactiveObject | eachReactiveObject quasarSetupReturnOn: aJSStream html: html ]
		separatedBy: [ aJSStream nextPut: $, ]
]

{ #category : #accessing }
QuasarApplication >> quasarVersion [

	^ quasarVersion
]

{ #category : #accessing }
QuasarApplication >> quasarVersion: anObject [

	quasarVersion := anObject
]

{ #category : #accessing }
QuasarApplication >> quasarVersionLazy [

	self quasarVersion ifNil: [ self quasarVersion: '2.6.0' ].

	^ self quasarVersion
]

{ #category : #accessing }
QuasarApplication >> reactiveObjects [

	^ reactiveObjects
]

{ #category : #accessing }
QuasarApplication >> reactiveObjects: anObject [

	reactiveObjects := anObject
]

{ #category : #accessing }
QuasarApplication >> reactiveObjectsAdd: anObject [

	self reactiveObjects at: anObject refName put: anObject
]

{ #category : #accessing }
QuasarApplication >> reactiveObjectsClear [

	self reactiveObjects: OrderedDictionary new
]

{ #category : #accessing }
QuasarApplication >> reactiveObjectsRemove: anObject [

	self reactiveObjects remove: anObject refName ifAbsent: [ nil ]
]

{ #category : #actions }
QuasarApplication >> redirect [
	"we need to build the url we redirect to because we just expired the session in this test"
	| url |
	url := self application url.
	url addAllToPath: self requestContext consumer upToEnd.
	^ self requestContext responseGenerator
		redirectTo: url;
		respond
]

{ #category : #rendering }
QuasarApplication >> renderContentOn: html [
	| jsStream |

	self renderLayoutOn: html.

	html script "async;" url: self vueJsUrl.
	html script "async;" url: self quasarJsUrl.

	jsStream := JSStream new.
	self quasarOnLoadOn: jsStream with: html.
	html document addLoadScript: jsStream.
]

{ #category : #rendering }
QuasarApplication >> renderLayoutOn: html [

	self subclassResponsibility
]

{ #category : #rendering }
QuasarApplication >> renderSetColorTheme: aColorTheme on: html [

	aColorTheme ifNil: [ ^ self ].

	aColorTheme colors ifNotNil: [ :colors | | stream |
		stream := WriteStream on: String new.
		stream nextPutAll: 'var bodyStyle = document.querySelector(":root").style;'.
		colors keysAndValuesDo: [ :eachKey :eachValue |
			stream
				nextPutAll: 'bodyStyle.setProperty("--q-', eachKey, '", "', eachValue "asHexString", '");';
				yourself ].

		html script: stream contents ]
]

{ #category : #updating }
QuasarApplication >> updateRoot: anHtmlRoot [

	super updateRoot: anHtmlRoot.

	self updateRootFonts: anHtmlRoot.
	self updateRootQuasarCss: anHtmlRoot.

	anHtmlRoot stylesheet url: (QuasarApplicationLibrary urlOf: #qAppCss).
	anHtmlRoot link beShortcutIcon; url: self faviconUrl.
	anHtmlRoot title: self applicationTitle.
	anHtmlRoot beHtml5

]

{ #category : #updating }
QuasarApplication >> updateRootFonts: anHtmlRoot [

	anHtmlRoot stylesheet
		url: 'https://fonts.googleapis.com/css?family=Roboto:100,300,400,500,700,900|Material+Icons|Material+Icons+Outlined'.

]

{ #category : #updating }
QuasarApplication >> updateRootQuasarCss: anHtmlRoot [

	anHtmlRoot stylesheet url: self quasarCssUrl
]

{ #category : #'accessing - view style' }
QuasarApplication >> viewStyleDense [

	^ false
]

{ #category : #'accessing - view style' }
QuasarApplication >> viewStyleFilled [

	^ false
]

{ #category : #'accessing - view style' }
QuasarApplication >> viewStyleOutlined [

	^ false
]

{ #category : #accessing }
QuasarApplication >> vueJsUrl [

	^ 'https://cdn.jsdelivr.net/npm/vue@3/dist/vue.global.prod.js'
]

{ #category : #accessing }
QuasarApplication >> vueRefs [

	^ vueRefs
]

{ #category : #accessing }
QuasarApplication >> vueRefs: anObject [

	vueRefs := anObject
]

{ #category : #accessing }
QuasarApplication >> vueRefsAdd: anObject [

	self vueRefs at: anObject key put: anObject value
]

{ #category : #accessing }
QuasarApplication >> vueRefsClear [

	self vueRefs: Dictionary new
]

{ #category : #accessing }
QuasarApplication >> vueRefsRemove: anObject [

	self vueRefs remove: anObject ifAbsent: [ nil ]
]
