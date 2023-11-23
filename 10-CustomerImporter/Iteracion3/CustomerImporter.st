!classDefinition: #PersistentSet category: 'CustomerImporter'!
Set subclass: #PersistentSet
	instanceVariableNames: 'session'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!PersistentSet methodsFor: 'initialization' stamp: 'HAW 11/14/2023 08:25:31'!
initializeOn: aSession from: aNonPersistentSet

	session := aSession.
	self addAll: aNonPersistentSet ! !


!PersistentSet methodsFor: 'adding' stamp: 'HAW 11/14/2023 08:23:40'!
add: newObject

	super add: newObject.
	session persist: newObject.
	
	^newObject! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PersistentSet class' category: 'CustomerImporter'!
PersistentSet class
	instanceVariableNames: ''!

!PersistentSet class methodsFor: 'instance creation' stamp: 'HAW 11/14/2023 08:24:32'!
on: aSession

	^self on: aSession from: #()! !

!PersistentSet class methodsFor: 'instance creation' stamp: 'HAW 11/14/2023 08:25:00'!
on: aSession from: aNonPersistentSet

	^self new initializeOn: aSession from: aNonPersistentSet
! !


!classDefinition: #ImportTest category: 'CustomerImporter'!
TestCase subclass: #ImportTest
	instanceVariableNames: 'session'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!ImportTest methodsFor: 'tests' stamp: 'HAW 5/22/2022 18:17:51'!
test01Import

	CustomerImporter valueFrom: self validImportData into: session..

	self assertImportedRightNumberOfCustomers.
	self assertPepeSanchezWasImportedCorrecty.
	self assertJuanPerezWasImportedCorrectly ! !

!ImportTest methodsFor: 'tests' stamp: 'sg 11/20/2023 19:34:50'!
test02CanNotImportIncorrectData
	| invalidData |
	invalidData := ReadStream on: 'Nil'.
	

	self should:[CustomerImporter valueFrom: invalidData into: session.]
	raise:Error
	withExceptionDo:[:anError |self assert:  anError messageText = CustomerImporter canNotImportInvalidData].! !

!ImportTest methodsFor: 'tests' stamp: 'sg 11/20/2023 19:34:45'!
test03CanNotImportAddressWithoutCustomer
	| invalidData |
	invalidData := ReadStream on: 'A,San Martin,3322,Olivos,1636,BsAs'.
	

	self should:[CustomerImporter valueFrom: invalidData into: session.]
	raise:Error - MessageNotUnderstood 
	withExceptionDo:[:anError |self assert:  anError messageText = CustomerImporter doesNotExistCustomerToCorrespondingAddress].! !

!ImportTest methodsFor: 'tests' stamp: 'sg 11/20/2023 19:50:00'!
test04CanNotImportDataWithMissingInformationInCustomer
	| invalidData |
	invalidData := ReadStream on: 'C,Pepe,Sanchez,D
A,San Martin,3322,Olivos,1636,BsAs'.
	

	self should:[CustomerImporter valueFrom: invalidData into: session.]
	raise:Error - MessageNotUnderstood 
	withExceptionDo:[:anError | self assert: anError messageText = CustomerImporter canNotImportDataWrongSize ].! !

!ImportTest methodsFor: 'tests' stamp: 'VA 11/21/2023 19:32:57'!
test05CanNotImportDataWithMissingInformationInAddress
	| invalidData |
	invalidData := ReadStream on: 'C,Pepe,Sanchez,D,22333444
A,San Martin,3322,Olivos,1636,BsAs,12345'.
	
	self should:[CustomerImporter valueFrom: invalidData into: session.]
	raise:Error - MessageNotUnderstood 
	withExceptionDo:[:anError | self assert: anError messageText = CustomerImporter canNotImportDataWrongSize ].! !

!ImportTest methodsFor: 'tests' stamp: 'VA 11/21/2023 19:54:17'!
test06CanNotImportWrongTypeDataCustomer
	| invalidData |
	invalidData := ReadStream on: 'CA,Pepe,Sanchez,D,22333444
A,San Martin,3322,Olivos,1636,BsAs'.
	

	self should:[CustomerImporter valueFrom: invalidData into: session.]
	raise:Error - MessageNotUnderstood 
	withExceptionDo:[:anError | self assert: anError messageText = CustomerImporter wrongTypeToImportErrorDescription ].! !

!ImportTest methodsFor: 'tests' stamp: 'VA 11/21/2023 19:54:35'!
test07CanNotImportWrongTypeDataAddress
	| invalidData |
	invalidData := ReadStream on: 'C,Pepe,Sanchez,D,22333444
AA,San Martin,3322,Olivos,1636,BsAs'.
	

	self should:[CustomerImporter valueFrom: invalidData into: session.]
	raise:Error - MessageNotUnderstood 
	withExceptionDo:[:anError | self assert: anError messageText = CustomerImporter wrongTypeToImportErrorDescription ].! !


!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:22:05'!
assertAddressOf: importedCustomer at: aStreetName hasNumber: aNumber town: aTown zipCode: aZipCode province: aProvince

	| importedAddress |

	importedAddress := importedCustomer addressAt: aStreetName ifNone: [ self fail ].
	self assert: aStreetName equals: importedAddress streetName.
	self assert: aNumber equals: importedAddress streetNumber.
	self assert: aTown equals: importedAddress town.
	self assert: aZipCode equals: importedAddress zipCode.
	self assert: aProvince equals: importedAddress province.

	! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:27:57'!
assertCustomerWithIdentificationType: anIdType number: anIdNumber hasFirstName: aFirstName lastName: aLastName

	| importedCustomer |

	importedCustomer := self customerWithIdentificationType: anIdType number: anIdNumber.

	self assert: aFirstName equals: importedCustomer firstName.
	self assert: aLastName equals: importedCustomer lastName.
	self assert: anIdType equals: importedCustomer identificationType.
	self assert: anIdNumber equals: importedCustomer identificationNumber.

	^importedCustomer

	! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:12:18'!
assertImportedRightNumberOfCustomers

	^ self assert: 2 equals: (session selectAllOfType: Customer) size! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:28:45'!
assertJuanPerezWasImportedCorrectly

	| importedCustomer |

	importedCustomer := self assertCustomerWithIdentificationType: 'C' number: '23-25666777-9' hasFirstName: 'Juan' lastName: 'Perez'.
	self assertAddressOf: importedCustomer at: 'Alem' hasNumber: 1122 town: 'CABA' zipCode: 1001 province: 'CABA'
	! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:28:05'!
assertPepeSanchezWasImportedCorrecty

	| importedCustomer |

	importedCustomer := self assertCustomerWithIdentificationType: 'D' number: '22333444' hasFirstName: 'Pepe' lastName: 'Sanchez'.
	self assertAddressOf: importedCustomer at: 'San Martin' hasNumber: 3322 town: 'Olivos' zipCode: 1636 province: 'BsAs'.
	self assertAddressOf: importedCustomer at: 'Maipu' hasNumber: 888 town: 'Florida' zipCode: 1122 province: 'Buenos Aires'.


	! !


!ImportTest methodsFor: 'setUp/tearDown' stamp: 'VA 11/21/2023 22:58:16'!
setUp

	session := PersistentSystem with: (DataBaseSession for: (Array with: Address with: Customer)).
	session beginTransaction.
! !

!ImportTest methodsFor: 'setUp/tearDown' stamp: 'HAW 5/22/2022 00:28:23'!
tearDown

	session commit.
	session close.
	! !


!ImportTest methodsFor: 'customer' stamp: 'HAW 5/22/2022 18:14:22'!
customerWithIdentificationType: anIdType number: anIdNumber

	^ (session
		select: [ :aCustomer | aCustomer identificationType = anIdType and: [ aCustomer identificationNumber = anIdNumber ]]
		ofType: Customer) anyOne! !


!ImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 18:08:08'!
validImportData

	^ ReadStream on:
'C,Pepe,Sanchez,D,22333444
A,San Martin,3322,Olivos,1636,BsAs
A,Maipu,888,Florida,1122,Buenos Aires
C,Juan,Perez,C,23-25666777-9
A,Alem,1122,CABA,1001,CABA'! !


!classDefinition: #Address category: 'CustomerImporter'!
Object subclass: #Address
	instanceVariableNames: 'id streetName streetNumber town zipCode province'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Address methodsFor: 'province' stamp: 'HAW 5/22/2022 00:19:29'!
province

	^province! !

!Address methodsFor: 'province' stamp: 'HAW 5/22/2022 00:19:29'!
province: aProvince

	province := aProvince
	! !


!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 17:55:46'!
isAt: aStreetName

	^streetName = aStreetName ! !

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


!Address methodsFor: 'initialization' stamp: 'sg 11/20/2023 18:05:37'!
initializeWithStreetName: aStreetName streetNumber: aStreetNumber town: aTown zipCode: aZipCode province: aProvince 
	
	streetName := aStreetName.
	streetNumber := aStreetNumber.
	town := aTown.
	zipCode := aZipCode.
	province := aProvince.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Address class' category: 'CustomerImporter'!
Address class
	instanceVariableNames: ''!

!Address class methodsFor: 'instance creation' stamp: 'sg 11/20/2023 18:02:58'!
withStreetName: aStreetName streetNumber: aStreetNumber town: aTown zipCode: aZipCode province: aProvince 
	
	^self new initializeWithStreetName: aStreetName streetNumber: aStreetNumber town: aTown zipCode: aZipCode province: aProvince ! !


!classDefinition: #Customer category: 'CustomerImporter'!
Object subclass: #Customer
	instanceVariableNames: 'id firstName lastName identificationType identificationNumber addresses type number'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Customer methodsFor: 'addresses' stamp: 'HAW 5/22/2022 00:19:29'!
addAddress: anAddress

	addresses add: anAddress ! !

!Customer methodsFor: 'addresses' stamp: 'HAW 5/22/2022 17:55:17'!
addressAt: aStreetName ifNone: aNoneBlock

	^addresses detect: [ :address | address isAt: aStreetName ] ifNone: aNoneBlock ! !

!Customer methodsFor: 'addresses' stamp: 'HAW 5/22/2022 00:19:29'!
addresses

	^ addresses! !


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

!Customer methodsFor: 'initialization' stamp: 'sg 11/20/2023 18:01:10'!
initializeWithFirstName: aFirstName lastName: aLastName identificationType: aType anIdentificationNumber: aNumber 
	
	firstName := aFirstName.
	lastName := aLastName.
	identificationType := aType.
	identificationNumber := aNumber.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Customer class' category: 'CustomerImporter'!
Customer class
	instanceVariableNames: ''!

!Customer class methodsFor: 'instance creation' stamp: 'sg 11/20/2023 17:58:46'!
withFirstName: aFirstName lastName: aLastName identificationType: aType identificationNumber: aNumber 
	
	^self new initializeWithFirstName: aFirstName lastName: aLastName identificationType: aType anIdentificationNumber: aNumber! !


!classDefinition: #CustomerImporter category: 'CustomerImporter'!
Object subclass: #CustomerImporter
	instanceVariableNames: 'session readStream'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!CustomerImporter methodsFor: 'initialization' stamp: 'HAW 5/22/2022 18:06:47'!
initializeFrom: aReadStream into: aSession
	session := aSession.
	readStream := aReadStream.! !


!CustomerImporter methodsFor: 'evaluating' stamp: 'sg 11/20/2023 19:43:25'!
assertInputIsValid: aLine

	((aLine beginsWith: 'C') or: (aLine beginsWith: 'A') ) ifFalse: [self error: self class canNotImportInvalidData].
	
! !

!CustomerImporter methodsFor: 'evaluating' stamp: 'VA 11/21/2023 19:49:08'!
assertItIsACorrectType: data

	^ (data first size = 1) ifFalse:[self error:self class wrongTypeToImportErrorDescription ]! !

!CustomerImporter methodsFor: 'evaluating' stamp: 'VA 11/21/2023 23:02:01'!
asssertThat: data hasFieldsNoMoreThan: aQuantity 

	^ (data size = aQuantity) ifFalse:[self error: self class canNotImportDataWrongSize]! !

!CustomerImporter methodsFor: 'evaluating' stamp: 'sg 11/20/2023 17:31:52'!
createAddressWith: addressData

	^Address withStreetName: addressData second streetNumber: addressData third asNumber town: addressData fourth zipCode: addressData fifth asNumber province: addressData sixth! !

!CustomerImporter methodsFor: 'evaluating' stamp: 'sg 11/20/2023 17:30:52'!
createCustomerWith: customerData

	^Customer withFirstName: customerData second lastName: customerData third identificationType: customerData fourth identificationNumber: customerData fifth! !

!CustomerImporter methodsFor: 'evaluating' stamp: 'VA 11/21/2023 23:02:23'!
value

	"
	self importCustomers
	"
	| newCustomer data line |

	line := readStream nextLine.
	[ line notNil ] whileTrue: [
		 data := line findTokens: $,.
		self assertInputIsValid: line.
		self assertItIsACorrectType: data.
		(line beginsWith: 'C') ifTrue: [
			self asssertThat: data hasFieldsNoMoreThan: 5.
			newCustomer := self createCustomerWith:data.
			session persist: newCustomer].

		(line beginsWith: 'A') ifTrue: [ | newAddress |
			self asssertThat: data hasFieldsNoMoreThan: 6.
			newCustomer ifNil:[self error:self class doesNotExistCustomerToCorrespondingAddress ].
			newAddress := self createAddressWith: data.
			newCustomer addAddress: newAddress.
			 ].

		line := readStream nextLine. ].

	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CustomerImporter class' category: 'CustomerImporter'!
CustomerImporter class
	instanceVariableNames: ''!

!CustomerImporter class methodsFor: 'instance creation' stamp: 'HAW 5/22/2022 18:06:47'!
from: aReadStream into: aSession
	^self new initializeFrom: aReadStream into: aSession! !


!CustomerImporter class methodsFor: 'importing' stamp: 'HAW 5/22/2022 18:11:27'!
valueFrom: aReadStream into: aSession

	^(self from: aReadStream into: aSession) value! !


!CustomerImporter class methodsFor: 'error messages' stamp: 'sg 11/20/2023 19:41:58'!
canNotImportDataWrongSize
	^'Can not import data with wrong size'! !

!CustomerImporter class methodsFor: 'error messages' stamp: 'sg 11/20/2023 18:18:21'!
canNotImportInvalidData
	^'Can not import Invalid Data'! !

!CustomerImporter class methodsFor: 'error messages' stamp: 'sg 11/20/2023 18:49:54'!
doesNotExistCustomerToCorrespondingAddress
	^'Does not exist customer yet'! !

!CustomerImporter class methodsFor: 'error messages' stamp: 'VA 11/21/2023 19:52:29'!
wrongTypeToImportErrorDescription
	^'Cannot import a wrong type'! !


!classDefinition: #DataBaseSession category: 'CustomerImporter'!
Object subclass: #DataBaseSession
	instanceVariableNames: 'configuration tables id inTransaction closed'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!DataBaseSession methodsFor: 'transaction management' stamp: 'HAW 11/14/2023 08:52:25'!
beginTransaction

	inTransaction := true.! !

!DataBaseSession methodsFor: 'transaction management' stamp: 'HAW 11/14/2023 08:52:18'!
commit

	inTransaction := false.! !


!DataBaseSession methodsFor: 'closing' stamp: 'VA 11/21/2023 23:48:12'!
close
! !


!DataBaseSession methodsFor: 'persistence - private' stamp: 'VA 11/21/2023 23:48:37'!
assertCanUseDatabase

	"self assertIsOpen."
	self assertInTransaction ! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 08:48:43'!
assertInTransaction

	inTransaction ifFalse: [ self error: 'Not in transaction' ].! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 08:48:16'!
assertIsOpen

	closed ifTrue: [ self error: 'Connection with database closed' ].! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 09:09:07'!
assertTypeIsPersisted: aType

	(configuration includes: aType) ifFalse: [ self error: 'Object of type ', aType name, ' are not configured to be persisted' ].! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 5/22/2022 00:19:29'!
defineIdOf: anObject

	anObject instVarNamed: 'id' put: (self newIdFor: anObject).! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 5/22/2022 00:19:29'!
delay

	(Delay forMilliseconds: 100) wait! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 08:58:59'!
isRelationToPersist: possibleRelation

	^ possibleRelation class = Set! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 08:58:59'!
persistPossibleRelationOf: anObject at: anInstVarOffset

	| possibleRelation |
		
	possibleRelation := anObject instVarAt: anInstVarOffset.
	(self isRelationToPersist: possibleRelation) ifTrue: [ self persistRelationOf: anObject at: anInstVarOffset with: possibleRelation ]! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 08:58:03'!
persistRelationOf: anObject at: anInstVarOffset with: aRelation

	| persistentRelation |
	
	persistentRelation := PersistentSet on: self from: aRelation.
	anObject instVarAt: anInstVarOffset put: persistentRelation! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 08:58:34'!
persistRelationsOf: anObject

	anObject class instVarNamesAndOffsetsDo: [ :anInstVarName :anInstVarOffset | self persistPossibleRelationOf: anObject at: anInstVarOffset]! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 09:06:24'!
tableOfType: aType

	^ tables at: aType ifAbsentPut: [ Set new ]! !


!DataBaseSession methodsFor: 'initialization' stamp: 'VA 11/21/2023 23:48:58'!
initializeFor: aConfiguration

	configuration := aConfiguration.
	tables := Dictionary new.
	id := 0.
	inTransaction := false.
	"closed := false."! !


!DataBaseSession methodsFor: 'id' stamp: 'HAW 5/22/2022 00:19:29'!
newIdFor: anObject

	id := id + 1.
	^id! !


!DataBaseSession methodsFor: 'persistance' stamp: 'HAW 11/14/2023 09:06:24'!
persist: anObject

	| table |

	self assertCanUseDatabase.
	self assertTypeIsPersisted: anObject class.
	self delay.
	
	table := self tableOfType: anObject class.
	self defineIdOf: anObject.
	table add: anObject.
	self persistRelationsOf: anObject.
! !


!DataBaseSession methodsFor: 'selecting' stamp: 'HAW 11/14/2023 09:06:56'!
select: aCondition ofType: aType

	self assertCanUseDatabase.
	self assertTypeIsPersisted: aType.
	self delay.
	
	^(self tableOfType: aType) select: aCondition ! !

!DataBaseSession methodsFor: 'selecting' stamp: 'HAW 11/14/2023 09:07:12'!
selectAllOfType: aType

	self assertCanUseDatabase.
	self assertTypeIsPersisted: aType.
	self delay.
	
	^(self tableOfType: aType) copy ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'DataBaseSession class' category: 'CustomerImporter'!
DataBaseSession class
	instanceVariableNames: ''!

!DataBaseSession class methodsFor: 'instance creation' stamp: 'HAW 5/22/2022 00:19:29'!
for: aConfiguration

	^self new initializeFor: aConfiguration! !


!classDefinition: #PersistentSystem category: 'CustomerImporter'!
Object subclass: #PersistentSystem
	instanceVariableNames: 'sesion'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!PersistentSystem methodsFor: 'as yet unclassified' stamp: 'VA 11/21/2023 23:28:28'!
beginTransaction
	sesion beginTransaction ! !

!PersistentSystem methodsFor: 'as yet unclassified' stamp: 'VA 11/21/2023 23:21:34'!
close
	sesion close! !

!PersistentSystem methodsFor: 'as yet unclassified' stamp: 'VA 11/21/2023 23:31:46'!
commit
	sesion commit! !

!PersistentSystem methodsFor: 'as yet unclassified' stamp: 'VA 11/21/2023 23:16:31'!
initializeWith: aSession
	
	sesion := aSession ! !

!PersistentSystem methodsFor: 'as yet unclassified' stamp: 'VA 11/21/2023 23:29:57'!
persist: anObject
	sesion persist: anObject! !

!PersistentSystem methodsFor: 'as yet unclassified' stamp: 'VA 11/21/2023 23:27:31'!
select: aCondition ofType: aType
	^sesion select: aCondition ofType: aType! !

!PersistentSystem methodsFor: 'as yet unclassified' stamp: 'VA 11/21/2023 23:19:50'!
selectAllOfType: aType
	^sesion  selectAllOfType: aType ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PersistentSystem class' category: 'CustomerImporter'!
PersistentSystem class
	instanceVariableNames: ''!

!PersistentSystem class methodsFor: 'as yet unclassified' stamp: 'VA 11/21/2023 23:15:38'!
with: aSession
	^self new initializeWith: aSession
! !


!classDefinition: #TransientSystem category: 'CustomerImporter'!
Object subclass: #TransientSystem
	instanceVariableNames: 'sesion'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!TransientSystem methodsFor: 'as yet unclassified' stamp: 'VA 11/21/2023 23:55:49'!
beginTransaction! !
