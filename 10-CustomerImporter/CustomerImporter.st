!classDefinition: #ImportTest category: 'CustomerImporter'!
TestCase subclass: #ImportTest
	instanceVariableNames: 'session firstAddress secondAddress thirdAddress'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!ImportTest methodsFor: 'as yet unclassified' stamp: 'VA 11/16/2023 16:50:43'!
assertCustomerIsInSession: aCustomerToCompare
	| customers |
	customers:= session select:[:aCustomer | true ]  ofType: Customer.
	^customers anySatisfy: [:aCustomer | 	aCustomer = aCustomerToCompare ]
	
	! !

!ImportTest methodsFor: 'as yet unclassified' stamp: 'VA 11/16/2023 16:49:13'!
setUp

	session := DataBaseSession for: (Array with: Address with: Customer).
	session beginTransaction.
	firstAddress := Address withStreetName: 'San Martin' streetNumber: 3322 town: 'Olivos' zipCode: 1636 andProvince: 'BsAs'.
	secondAddress := Address withStreetName: 'Maipu' streetNumber: 888 town: 'Florida' zipCode: 1122 andProvince: 'Buenos Aires'.
	thirdAddress := Address withStreetName: 'Alem' streetNumber: 1122 town: 'CABA' zipCode: 1001 andProvince: 'CABA'.! !

!ImportTest methodsFor: 'as yet unclassified' stamp: 'v 11/13/2023 20:55:01'!
tearDown

	session commit.
	session close! !

!ImportTest methodsFor: 'as yet unclassified' stamp: 'VA 11/16/2023 16:49:54'!
test01ImportsCustomersCorrectly
	|anotherExpectedCustomer expectedCustomer |
	(ImporterCustomers importFrom: (UniFileStream new open: 'input.txt' forWrite: false) using: session) import .
	
	expectedCustomer := Customer withFirstName: 'Pepe' lastName: 'Sanchez' identificationType: 'D' identificationNumber: '22333444' withAddresses: (OrderedCollection with: firstAddress with: secondAddress ).
	anotherExpectedCustomer:= Customer withFirstName: 'Juan' lastName: 'Perez' identificationType: 'C' identificationNumber: '23-25666777-9' withAddresses:( OrderedCollection with: thirdAddress ).
	
	self assertCustomerIsInSession: expectedCustomer.
	self assertCustomerIsInSession: anotherExpectedCustomer.	
	
	
	! !

!ImportTest methodsFor: 'as yet unclassified' stamp: 'VA 11/16/2023 16:48:49'!
test02ImportsCustomersAddressesCorrectly
	|customers addresses |
	(ImporterCustomers importFrom: (UniFileStream new open: 'input.txt' forWrite: false) using: session) import .

	customers:= session select:[:aCustomer | aCustomer identificationType= 'D' and:[aCustomer identificationNumber= '22333444']]  ofType: Customer.
	
	addresses :=customers anyOne addresses.
	self assert: addresses size equals: 2.
	self assertCustomer: customers anyOne hasThisAddress: firstAddress. 
	self assertCustomer: customers anyOne hasThisAddress: secondAddress.
	
	customers:= session select:[:aCustomer | aCustomer identificationType= 'C' and:[aCustomer identificationNumber= '23-25666777-9']]  ofType: Customer.
	
	addresses :=customers anyOne addresses.
	self assert: addresses size equals: 1.
	self assertCustomer: customers anyOne hasThisAddress: thirdAddress.

	! !


!ImportTest methodsFor: 'assertions' stamp: 'VA 11/16/2023 16:36:37'!
assertCustomer: aCustomer hasThisAddress: anAddressToCompare. 
	
	aCustomer addresses anySatisfy: [:anAddress | anAddress = anAddressToCompare ].
	! !


!classDefinition: #Address category: 'CustomerImporter'!
Object subclass: #Address
	instanceVariableNames: 'id streetName streetNumber town zipCode province'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Address methodsFor: 'province' stamp: 'VA 11/16/2023 16:38:47'!
= anAddress
	^(streetName = anAddress streetName) and:[streetNumber = anAddress streetNumber] and:[town = anAddress town] and:[zipCode = anAddress zipCode] and:[province = anAddress province].! !

!Address methodsFor: 'province' stamp: 'HAW 5/22/2022 00:19:29'!
province

	^province! !

!Address methodsFor: 'province' stamp: 'HAW 5/22/2022 00:19:29'!
province: aProvince

	province := aProvince
	! !


!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 00:19:29'!
streetName

	^streetName ! !

!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 00:19:29'!
streetName: aStreetName

	streetName := aStreetName ! !

!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 00:19:29'!
streetNumber

	^streetNumber ! !

!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 00:19:29'!
streetNumber: aStreetNumber

	streetNumber := aStreetNumber ! !


!Address methodsFor: 'twon' stamp: 'HAW 5/22/2022 00:19:29'!
town

	^town! !

!Address methodsFor: 'twon' stamp: 'HAW 5/22/2022 00:19:29'!
town: aTown

	town := aTown! !


!Address methodsFor: 'zip code' stamp: 'HAW 5/22/2022 00:19:29'!
zipCode

	^zipCode! !

!Address methodsFor: 'zip code' stamp: 'HAW 5/22/2022 00:19:29'!
zipCode: aZipCode

	zipCode := aZipCode! !


!Address methodsFor: 'initialization' stamp: 'VA 11/16/2023 16:04:04'!
initializeWithStreetName: aStreetName streetNumber: aStreetNumber town: aTown zipCode: aZipCode andProvince: aProvince 
	self streetName: aStreetName.
	self streetNumber:aStreetNumber.
	self town: aTown.
	self zipCode: aZipCode.
	self province: aProvince.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Address class' category: 'CustomerImporter'!
Address class
	instanceVariableNames: ''!

!Address class methodsFor: 'instance creation' stamp: 'VA 11/16/2023 16:02:07'!
withStreetName: aStreetName streetNumber: aStreetNumber town: aTown zipCode: aZipCode andProvince: aProvince 
	
	^self new initializeWithStreetName: aStreetName streetNumber: aStreetNumber town: aTown zipCode: aZipCode andProvince: aProvince ! !


!Address class methodsFor: 'class initialization' stamp: 'VA 11/16/2023 16:11:01'!
withStreetName: aRenameMe1 streetNumber: aRenameMe2 town: aRenameMe3 zipCode: aRenameMe4 province: aRenameMe5 
	self shouldBeImplemented.! !


!classDefinition: #Customer category: 'CustomerImporter'!
Object subclass: #Customer
	instanceVariableNames: 'id firstName lastName identificationType identificationNumber addresses addresses_CHANGE_ME addressesCollection_CHANGE_ME'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Customer methodsFor: 'addresses' stamp: 'HAW 5/22/2022 00:19:29'!
addAddress: anAddress

	addresses add: anAddress ! !

!Customer methodsFor: 'addresses' stamp: 'HAW 5/22/2022 00:19:29'!
addresses

	^ addresses! !


!Customer methodsFor: 'name' stamp: 'VA 11/16/2023 16:38:09'!
= aCustomer
	^(firstName = aCustomer firstName) and: [lastName = aCustomer lastName] and: [identificationType = aCustomer identificationType] and: [identificationNumber = aCustomer identificationNumber].! !

!Customer methodsFor: 'name' stamp: 'HAW 5/22/2022 00:19:29'!
firstName

	^firstName ! !

!Customer methodsFor: 'name' stamp: 'HAW 5/22/2022 00:19:29'!
firstName: aName

	firstName := aName! !

!Customer methodsFor: 'name' stamp: 'HAW 5/22/2022 00:19:29'!
lastName

	^lastName ! !

!Customer methodsFor: 'name' stamp: 'HAW 5/22/2022 00:19:29'!
lastName: aLastName

	lastName := aLastName
! !


!Customer methodsFor: 'identification' stamp: 'HAW 5/22/2022 00:19:29'!
identificationNumber

	^identificationNumber ! !

!Customer methodsFor: 'identification' stamp: 'HAW 5/22/2022 00:19:29'!
identificationNumber: anIdentificationNumber

	identificationNumber := anIdentificationNumber! !

!Customer methodsFor: 'identification' stamp: 'HAW 5/22/2022 00:19:29'!
identificationType

	^identificationType ! !

!Customer methodsFor: 'identification' stamp: 'HAW 5/22/2022 00:19:29'!
identificationType: anIdentificationType

	identificationType := anIdentificationType! !


!Customer methodsFor: 'initialization' stamp: 'HAW 5/22/2022 00:19:29'!
initialize

	super initialize.
	addresses := OrderedCollection new.! !

!Customer methodsFor: 'initialization' stamp: 'VA 11/16/2023 16:41:04'!
initializeWithFirstName: aFirstName lastName: aLastName identificationType: anIdentificationType identificationNumber: anIdentificationNumber withAddresses: addressesCollection 
	self firstName: aFirstName.
	self lastName: aLastName.
	self identificationType: anIdentificationType.
	self identificationNumber: anIdentificationNumber.
	addresses := addressesCollection .! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Customer class' category: 'CustomerImporter'!
Customer class
	instanceVariableNames: ''!

!Customer class methodsFor: 'class initialization' stamp: 'VA 11/16/2023 16:40:16'!
withFirstName: aFirstName lastName: aLastName identificationType: anIdentificationType identificationNumber: anIdentificationNumber withAddresses: addressesCollection 
	^self new initializeWithFirstName: aFirstName lastName: aLastName identificationType: anIdentificationType identificationNumber: anIdentificationNumber withAddresses: addressesCollection.
	! !


!classDefinition: #DataBaseSession category: 'CustomerImporter'!
Object subclass: #DataBaseSession
	instanceVariableNames: 'configuration tables id'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!DataBaseSession methodsFor: 'transaction management' stamp: 'HAW 5/22/2022 00:19:29'!
beginTransaction

	! !

!DataBaseSession methodsFor: 'transaction management' stamp: 'HAW 5/22/2022 19:17:36'!
commit

	(tables at: Customer ifAbsent: [#()]) do: [ :aCustomer | self persistAddressesOf: aCustomer ]
	! !


!DataBaseSession methodsFor: 'closing' stamp: 'HAW 5/22/2022 00:19:29'!
close

	! !


!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 5/22/2022 00:19:29'!
defineIdOf: anObject

	anObject instVarNamed: 'id' put: (self newIdFor: anObject).! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 5/22/2022 00:19:29'!
delay

	(Delay forMilliseconds: 100) wait! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 5/22/2022 19:29:06'!
objectsOfType: aType

	^ tables at: aType ifAbsent: [ #() ]! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 5/22/2022 00:19:29'!
persistAddressesOf: anObjectWithAddresses

	anObjectWithAddresses addresses do: [ :anAddress | self persist: anAddress ]
	! !


!DataBaseSession methodsFor: 'initialization' stamp: 'HAW 5/22/2022 00:19:29'!
initializeFor: aConfiguration

	configuration := aConfiguration.
	tables := Dictionary new.
	id := 0.! !


!DataBaseSession methodsFor: 'id' stamp: 'HAW 5/22/2022 00:19:29'!
newIdFor: anObject

	id := id + 1.
	^id! !


!DataBaseSession methodsFor: 'persistance' stamp: 'HAW 5/22/2022 00:19:29'!
persist: anObject

	| table |

	self delay.
	table := tables at: anObject class ifAbsentPut: [ Set new ].

	self defineIdOf: anObject.
	table add: anObject.

	(anObject isKindOf: Customer) ifTrue: [ self persistAddressesOf: anObject ].! !


!DataBaseSession methodsFor: 'selecting' stamp: 'HAW 5/22/2022 19:29:06'!
select: aCondition ofType: aType

	self delay.
	^(self objectsOfType: aType) select: aCondition ! !

!DataBaseSession methodsFor: 'selecting' stamp: 'HAW 5/22/2022 19:29:06'!
selectAllOfType: aType

	self delay.
	^(self objectsOfType: aType) copy ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'DataBaseSession class' category: 'CustomerImporter'!
DataBaseSession class
	instanceVariableNames: ''!

!DataBaseSession class methodsFor: 'instance creation' stamp: 'HAW 5/22/2022 00:19:29'!
for: aConfiguration

	^self new initializeFor: aConfiguration! !


!classDefinition: #ImporterCustomers category: 'CustomerImporter'!
Object subclass: #ImporterCustomers
	instanceVariableNames: 'session stream'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!ImporterCustomers methodsFor: 'initialization' stamp: 'v 11/13/2023 21:37:48'!
initializeImportFrom: anAStream using: aSession
	session := aSession.
	stream := anAStream.! !


!ImporterCustomers methodsFor: 'evaluating' stamp: 'v 11/13/2023 21:37:48'!
import
	| newCustomer line |

	line := stream nextLine.
	[ line notNil ] whileTrue: [
		(line beginsWith: 'C') ifTrue: [ | customerData |
			customerData := line findTokens: $,.
			newCustomer := Customer new.
			newCustomer firstName: customerData second.
			newCustomer lastName: customerData third.
			newCustomer identificationType: customerData fourth.
			newCustomer identificationNumber: customerData fifth .
			session persist: newCustomer ].

		(line beginsWith: 'A') ifTrue: [ | addressData newAddress |
			addressData := line findTokens: $,.
			newAddress := Address new.
			newCustomer addAddress: newAddress.
			newAddress streetName: addressData second.
			newAddress streetNumber: addressData third asNumber .
			newAddress town: addressData fourth.
			newAddress zipCode: addressData fifth asNumber .
			newAddress province: addressData sixth ].

		line := stream  nextLine. ].


	stream close.
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ImporterCustomers class' category: 'CustomerImporter'!
ImporterCustomers class
	instanceVariableNames: ''!

!ImporterCustomers class methodsFor: 'instance creation' stamp: 'v 11/13/2023 21:37:48'!
importFrom: anAStream using: aSession
	^self new initializeImportFrom: anAStream using: aSession! !
