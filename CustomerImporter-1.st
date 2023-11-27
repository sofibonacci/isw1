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
	instanceVariableNames: 'system'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!ImportTest methodsFor: 'tests' stamp: 'sg 11/26/2023 19:33:17'!
assertCustomersAddedToSupplierCorrectly
	| customer anotherCustomer importedSupplier|
	
	customer := system customerWithIdentificationType: 'D'	 number: '22333444	'.
	anotherCustomer := system customerWithIdentificationType: 'D'	 number: '5456774	'.
	
	
	importedSupplier := system supplierWithIdentificationType: 'D' number: 123.
	importedSupplier customers = {customer, anotherCustomer}
! !

!ImportTest methodsFor: 'tests' stamp: 'sg 11/26/2023 19:47:21'!
test01ImportSupplierToSupplierImporter
	
	Importer valueFrom: self validImportSupplierData into: system.
	self assertImportedRightNumberOfSuppliers.
	self assertSupplier1WasImportedCorrecty.
	self assertAddressesAddedToSupplierCorrectly.
	self assertCustomersAddedToSupplierCorrectly.
	! !

!ImportTest methodsFor: 'tests' stamp: 'HAW 5/22/2022 21:15:52'!
test01ValidDataIsImportedCorrectly

	CustomerImporter valueFrom: self validImportData into: system..

	self assertImportedRightNumberOfCustomers.
	self assertPepeSanchezWasImportedCorrecty.
	self assertJuanPerezWasImportedCorrectly ! !

!ImportTest methodsFor: 'tests' stamp: 'HAW 5/22/2022 21:15:52'!
test02CanNotImportAddressWithoutCustomer

	self
		should: [ CustomerImporter valueFrom: self addressWithoutCustomerData into: system. ]
		raise: Error - MessageNotUnderstood
		withMessageText: CustomerImporter canNotImportAddressWithoutCustomerErrorDescription

	! !

!ImportTest methodsFor: 'tests' stamp: 'HAW 5/22/2022 19:56:58'!
test03DoesNotImportRecordsStartingWithCButMoreCharacters

	self
		shouldFailImporting: self invalidCustomerRecordStartData
		messageText: CustomerImporter invalidRecordTypeErrorDescription
		asserting: [ self assertNoCustomerWasImported ]

	! !

!ImportTest methodsFor: 'tests' stamp: 'HAW 5/22/2022 19:49:03'!
test04DoesNotImportRecordsStartingWithAButMoreCharacters

	self
		shouldFailImporting: self invalidAddressRecordStartData
		messageText: CustomerImporter invalidRecordTypeErrorDescription
		asserting: [ self assertImportedOneCustomerWithoutAddress ]

	! !

!ImportTest methodsFor: 'tests' stamp: 'HAW 5/22/2022 19:49:36'!
test05CanNotImportAddressRecordWithLessThanSixFields

	self
		shouldFailImporting: self addressRecordWithLessThanSixFields
		messageText: CustomerImporter invalidAddressRecordErrorDescription
		asserting: [ self assertImportedOneCustomerWithoutAddress ]

	! !

!ImportTest methodsFor: 'tests' stamp: 'HAW 5/22/2022 19:51:14'!
test06CanNotImportAddressRecordWithMoreThanSixFields

	self
		shouldFailImporting: self addressRecordWithMoreThanSixFields
		messageText: CustomerImporter invalidAddressRecordErrorDescription
		asserting: [ self assertImportedOneCustomerWithoutAddress ]

	! !

!ImportTest methodsFor: 'tests' stamp: 'HAW 5/22/2022 19:56:58'!
test07CanNotImportCustomerRecordWithLessThanFiveFields

	self
		shouldFailImporting: self customerRecordWithLessThanFiveFields
		messageText: CustomerImporter invalidCustomerRecordErrorDescription
		asserting: [ self assertNoCustomerWasImported ]

	! !

!ImportTest methodsFor: 'tests' stamp: 'HAW 5/22/2022 19:56:58'!
test08CanNotImportCustomerRecordWithMoreThanFiveFields

	self
		shouldFailImporting: self customerRecordWithMoreThanFiveFields
		messageText: CustomerImporter invalidCustomerRecordErrorDescription
		asserting: [ self assertNoCustomerWasImported ]

	! !

!ImportTest methodsFor: 'tests' stamp: 'HAW 5/22/2022 20:01:43'!
test09CannotImportEmptyLine

	self
		shouldFailImporting: self emptyLine
		messageText: CustomerImporter invalidRecordTypeErrorDescription
		asserting: [ self assertNoCustomerWasImported ]

	! !


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

!ImportTest methodsFor: 'assertions' stamp: 'sg 11/26/2023 19:17:31'!
assertAddressesAddedToSupplierCorrectly
	
	|importedSupplier|
	
	importedSupplier := self assertSupplierWithIdentificationType: 'D' number: '123' hasFirstName: 'Supplier1'.
	self assertAddressOf: importedSupplier at: 'San Martin' hasNumber: 3322 town: 'Olivos' zipCode: 1636 province: 'BsAs'.
	self assertAddressOf: importedSupplier at: 'Maipu' hasNumber: 888 town: 'Florida' zipCode: 1122 province: 'Buenos Aires'.! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 21:34:30'!
assertCustomerWithIdentificationType: anIdType number: anIdNumber hasFirstName: aFirstName lastName: aLastName

	| importedCustomer |

	importedCustomer := system customerWithIdentificationType: anIdType number: anIdNumber.

	self assert: aFirstName equals: importedCustomer firstName.
	self assert: aLastName equals: importedCustomer lastName.
	self assert: anIdType equals: importedCustomer identificationType.
	self assert: anIdNumber equals: importedCustomer identificationNumber.

	^importedCustomer

	! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 21:34:37'!
assertImportedOneCustomerWithoutAddress

	| importedCustomer |

	self assert: 1 equals: system numberOfCustomers.
	importedCustomer := system customerWithIdentificationType: 'D' number: '22333444'.
	self assert: importedCustomer isAddressesEmpty
	! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 21:33:18'!
assertImportedRightNumberOfCustomers

	^ self assert: 2 equals: system numberOfCustomers! !

!ImportTest methodsFor: 'assertions' stamp: 'sg 11/23/2023 19:02:35'!
assertImportedRightNumberOfSuppliers
	^ self assert: 1 equals: system numberOfSuppliers.! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:28:45'!
assertJuanPerezWasImportedCorrectly

	| importedCustomer |

	importedCustomer := self assertCustomerWithIdentificationType: 'C' number: '23-25666777-9' hasFirstName: 'Juan' lastName: 'Perez'.
	self assertAddressOf: importedCustomer at: 'Alem' hasNumber: 1122 town: 'CABA' zipCode: 1001 province: 'CABA'
	! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 21:33:24'!
assertNoCustomerWasImported

	^ self assert: 0 equals: system numberOfCustomers! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:28:05'!
assertPepeSanchezWasImportedCorrecty

	| importedCustomer |

	importedCustomer := self assertCustomerWithIdentificationType: 'D' number: '22333444' hasFirstName: 'Pepe' lastName: 'Sanchez'.
	self assertAddressOf: importedCustomer at: 'San Martin' hasNumber: 3322 town: 'Olivos' zipCode: 1636 province: 'BsAs'.
	self assertAddressOf: importedCustomer at: 'Maipu' hasNumber: 888 town: 'Florida' zipCode: 1122 province: 'Buenos Aires'.


	! !

!ImportTest methodsFor: 'assertions' stamp: 'sg 11/23/2023 20:06:36'!
assertSupplier1WasImportedCorrecty
	self assertSupplierHasFirstName: 'Supplier1' withIdentificationType: 'D' number: '123'.
	


	! !

!ImportTest methodsFor: 'assertions' stamp: 'sg 11/23/2023 20:09:15'!
assertSupplierHasFirstName: aName withIdentificationType: aType number: aNumber
	
	| importedSupplier |

	importedSupplier := system supplierWithIdentificationType: aType number: aNumber.
	
	self assert: aName equals: importedSupplier firstName.
	self assert: aType equals: importedSupplier identificationType.
	self assert: aNumber equals: importedSupplier identificationNumber.! !

!ImportTest methodsFor: 'assertions' stamp: 'sg 11/26/2023 19:14:36'!
assertSupplierWithIdentificationType: anIdType number: anIdNumber hasFirstName: aFirstName

	| importedSupplier |

	importedSupplier := system supplierWithIdentificationType: anIdType number: anIdNumber.

	self assert: aFirstName equals: importedSupplier firstName.
	self assert: anIdType equals: importedSupplier identificationType.
	self assert: anIdNumber equals: importedSupplier identificationNumber.

	^importedSupplier

	! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 21:15:52'!
shouldFailImporting: aReadStream messageText: anErrorMessageText asserting: anAssertionBlock

	self
		should: [ CustomerImporter valueFrom: aReadStream into: system. ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anErrorMessageText equals: anError messageText.
			anAssertionBlock value ]

	! !


!ImportTest methodsFor: 'setUp/tearDown' stamp: 'sg 11/26/2023 19:42:43'!
setUp

	system := DevelopmentEnvironment new createCustomerSystem.
	system start.
	system beginTransaction.
! !

!ImportTest methodsFor: 'setUp/tearDown' stamp: 'HAW 5/22/2022 20:12:16'!
tearDown

	system commit.
	system stop
	! !


!ImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 19:41:20'!
addressRecordWithLessThanSixFields

	^ReadStream on: 'C,Pepe,Sanchez,D,22333444
A,San Martin,3322,Olivos,1636'! !

!ImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 19:51:35'!
addressRecordWithMoreThanSixFields

	^ReadStream on: 'C,Pepe,Sanchez,D,22333444
A,San Martin,3322,Olivos,1636,BsAs,x'! !

!ImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 19:14:13'!
addressWithoutCustomerData

	^ReadStream on: 'A,San Martin,3322,Olivos,1636,BsAs'! !

!ImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 19:53:41'!
customerRecordWithLessThanFiveFields

	^ReadStream on: 'C,Pepe,Sanchez,D'! !

!ImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 19:55:59'!
customerRecordWithMoreThanFiveFields

	^ReadStream on: 'C,Pepe,Sanchez,D,22333444,x'! !

!ImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 20:02:57'!
emptyLine

	^ReadStream on: '
'! !

!ImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 19:34:25'!
invalidAddressRecordStartData

	^ReadStream on: 'C,Pepe,Sanchez,D,22333444
AA,San Martin,3322,Olivos,1636,BsAs'! !

!ImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 19:22:55'!
invalidCustomerRecordStartData

	^ReadStream on: 'CC,Pepe,Sanchez,D,22333444'! !

!ImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 18:08:08'!
validImportData

	^ ReadStream on:
'C,Pepe,Sanchez,D,22333444
A,San Martin,3322,Olivos,1636,BsAs
A,Maipu,888,Florida,1122,Buenos Aires
C,Juan,Perez,C,23-25666777-9
A,Alem,1122,CABA,1001,CABA'! !

!ImportTest methodsFor: 'test data' stamp: 'sg 11/26/2023 19:26:52'!
validImportDataForSupplier

	^ ReadStream on:
'C,Nicolas,Sanchez,D,5456774		
'! !

!ImportTest methodsFor: 'test data' stamp: 'sg 11/26/2023 19:47:27'!
validImportSupplierData

	^ ReadStream on:
'C,Nicolas,Sanchez,D,5456774		
S,Supplier1,D,123
NC,Pepe,Sanchez,D,22333444
EC,D,5456774	
A,San Martin,3322,Olivos,1636,BsAs
A,Maipu,888,Florida,1122,Buenos Aires'! !


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


!classDefinition: #CustomerSystem category: 'CustomerImporter'!
Object subclass: #CustomerSystem
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!CustomerSystem methodsFor: 'customers' stamp: 'HAW 5/22/2022 21:17:57'!
add: aCustomer

	self subclassResponsibility ! !

!CustomerSystem methodsFor: 'customers' stamp: 'HAW 5/22/2022 21:18:16'!
commit

	self subclassResponsibility ! !

!CustomerSystem methodsFor: 'customers' stamp: 'HAW 5/22/2022 21:18:38'!
customerWithIdentificationType: anIdType number: anIdNumber

	self subclassResponsibility ! !

!CustomerSystem methodsFor: 'customers' stamp: 'HAW 5/22/2022 21:18:51'!
numberOfCustomers

	self subclassResponsibility ! !


!CustomerSystem methodsFor: 'transactions' stamp: 'HAW 5/22/2022 21:18:04'!
beginTransaction

	self subclassResponsibility ! !


!CustomerSystem methodsFor: 'system lifecycle' stamp: 'sg 11/24/2023 16:56:28'!
assertCustomerExistsWithIdType: idType andIdNumber: idNumber 
	self shouldBeImplemented.! !

!CustomerSystem methodsFor: 'system lifecycle' stamp: 'HAW 5/22/2022 21:18:10'!
start

	self subclassResponsibility ! !

!CustomerSystem methodsFor: 'system lifecycle' stamp: 'HAW 5/22/2022 21:18:13'!
stop

	self subclassResponsibility ! !


!CustomerSystem methodsFor: 'suppliers' stamp: 'sg 11/23/2023 19:04:53'!
numberOfSuppliers
	self subclassResponsibility.! !


!classDefinition: #PersistentCustomerSystem category: 'CustomerImporter'!
CustomerSystem subclass: #PersistentCustomerSystem
	instanceVariableNames: 'session'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!PersistentCustomerSystem methodsFor: 'customers' stamp: 'HAW 5/22/2022 21:14:14'!
add: aCustomer

	^session persist: aCustomer ! !

!PersistentCustomerSystem methodsFor: 'customers' stamp: 'HAW 5/22/2022 21:09:50'!
customerWithIdentificationType: anIdType number: anIdNumber

	^(session
		select: [ :aCustomer | aCustomer identificationType = anIdType and: [ aCustomer identificationNumber = anIdNumber ]]
		ofType: Customer) anyOne! !

!PersistentCustomerSystem methodsFor: 'customers' stamp: 'HAW 5/22/2022 21:08:47'!
numberOfCustomers

	^(session selectAllOfType: Customer) size! !

!PersistentCustomerSystem methodsFor: 'customers' stamp: 'sg 11/25/2023 17:26:05'!
numberOfSuppliers

	^(session selectAllOfType: Supplier) size! !


!PersistentCustomerSystem methodsFor: 'transactions' stamp: 'HAW 5/22/2022 20:12:39'!
beginTransaction

	session beginTransaction.
! !

!PersistentCustomerSystem methodsFor: 'transactions' stamp: 'HAW 5/22/2022 20:13:00'!
commit

	session commit ! !


!PersistentCustomerSystem methodsFor: 'system lifecycle' stamp: 'sg 11/25/2023 16:50:27'!
start

	session := DataBaseSession for: (Array with: Address with: Customer with: Supplier ).
	! !

!PersistentCustomerSystem methodsFor: 'system lifecycle' stamp: 'HAW 5/22/2022 20:13:10'!
stop

	session close! !


!PersistentCustomerSystem methodsFor: 'suppliers' stamp: 'sg 11/25/2023 17:14:20'!
addAddressToSupplier: aRecord 
	session persist: aRecord.! !

!PersistentCustomerSystem methodsFor: 'suppliers' stamp: 'sg 11/26/2023 19:11:36'!
supplierWithIdentificationType: aType number: aNumber 

	^(session
		select: [ :aSupplier | aSupplier identificationType = aType and: [ aSupplier identificationNumber = aNumber ]]
		ofType: Supplier) anyOne
	! !


!PersistentCustomerSystem methodsFor: 'error handling' stamp: 'sg 11/25/2023 17:29:26'!
error: aRenameMe1 
	self shouldBeImplemented.! !


!classDefinition: #TransientCustomerSystem category: 'CustomerImporter'!
CustomerSystem subclass: #TransientCustomerSystem
	instanceVariableNames: 'customers suppliers supplierAddresses'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!TransientCustomerSystem methodsFor: 'system lifecycle' stamp: 'sg 11/25/2023 16:47:20'!
start
	suppliers := OrderedCollection new.
	customers := OrderedCollection new.
	supplierAddresses := OrderedCollection new.! !

!TransientCustomerSystem methodsFor: 'system lifecycle' stamp: 'sg 11/23/2023 19:08:25'!
stop
	suppliers := nil.
	customers := nil! !


!TransientCustomerSystem methodsFor: 'transactions' stamp: 'HAW 5/22/2022 21:21:20'!
beginTransaction

	! !

!TransientCustomerSystem methodsFor: 'transactions' stamp: 'HAW 5/22/2022 21:23:01'!
commit

	! !


!TransientCustomerSystem methodsFor: 'customers' stamp: 'sg 11/23/2023 19:57:54'!
add: aParty
	(aParty isKindOf: Customer)ifTrue:[	customers add: aParty ]ifFalse:[self addSupplier: aParty]! !

!TransientCustomerSystem methodsFor: 'customers' stamp: 'HAW 5/22/2022 21:22:52'!
customerWithIdentificationType: anIdType number: anIdNumber

	^customers detect: [ :aCustomer | aCustomer identificationType = anIdType and: [ aCustomer identificationNumber = anIdNumber ]]! !

!TransientCustomerSystem methodsFor: 'customers' stamp: 'HAW 5/22/2022 21:21:43'!
numberOfCustomers

	^customers size! !

!TransientCustomerSystem methodsFor: 'customers' stamp: 'sg 11/23/2023 20:15:42'!
supplierWithIdentificationType: aType number: aNumber 

	^suppliers detect: [ :aSupplier | aSupplier identificationType = aType and: [ aSupplier identificationNumber = aNumber ]]! !


!TransientCustomerSystem methodsFor: 'suppliers' stamp: 'sg 11/25/2023 16:46:52'!
addAddressToSupplier: aRecord 
	supplierAddresses add: aRecord! !

!TransientCustomerSystem methodsFor: 'suppliers' stamp: 'sg 11/23/2023 19:22:17'!
addSupplier: aSupplier

	suppliers add: aSupplier.! !

!TransientCustomerSystem methodsFor: 'suppliers' stamp: 'sg 11/23/2023 19:07:43'!
numberOfSuppliers
	^suppliers size.! !


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


!DataBaseSession methodsFor: 'closing' stamp: 'HAW 11/14/2023 08:52:30'!
close

	closed := true.! !


!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 08:49:30'!
assertCanUseDatabase

	self assertIsOpen.
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


!DataBaseSession methodsFor: 'initialization' stamp: 'HAW 11/14/2023 08:44:19'!
initializeFor: aConfiguration

	configuration := aConfiguration.
	tables := Dictionary new.
	id := 0.
	inTransaction := false.
	closed := false.! !


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


!classDefinition: #Environment category: 'CustomerImporter'!
Object subclass: #Environment
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Environment methodsFor: 'customer system' stamp: 'HAW 5/22/2022 21:41:06'!
createCustomerSystem

	self subclassResponsibility ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Environment class' category: 'CustomerImporter'!
Environment class
	instanceVariableNames: ''!

!Environment class methodsFor: 'current' stamp: 'HAW 5/22/2022 21:37:10'!
current

	^(self subclasses detect: [ :anEnvironmentClass | anEnvironmentClass isCurrent ]) new! !

!Environment class methodsFor: 'current' stamp: 'HAW 11/23/2023 16:44:46'!
environmentKey

	^ #ENV! !

!Environment class methodsFor: 'current' stamp: 'HAW 11/23/2023 16:44:46'!
environmentVariable

	^ Smalltalk at: self environmentKey! !

!Environment class methodsFor: 'current' stamp: 'HAW 11/23/2023 16:44:09'!
identifier

	self subclassResponsibility! !

!Environment class methodsFor: 'current' stamp: 'HAW 5/22/2022 21:41:36'!
isCurrent

	self subclassResponsibility ! !

!Environment class methodsFor: 'current' stamp: 'HAW 11/23/2023 16:46:01'!
makeCurrent

	"
	Tener en cuenta que en Smalltalk se podría poner directamente la clase de environment,
	esto es DevelopmentEnvironment o IntegrationEnvironmet o hasta una instancia de ellas,
	pero se está simulando el hecho de que esto esté definido por fuera del sistema, como una
	variable del sistema operativo - Hernan"
	
	Smalltalk at: self environmentKey put: self identifier! !


!classDefinition: #DevelopmentEnvironment category: 'CustomerImporter'!
Environment subclass: #DevelopmentEnvironment
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!DevelopmentEnvironment methodsFor: 'customer system' stamp: 'HAW 5/22/2022 21:38:39'!
createCustomerSystem

	^TransientCustomerSystem new! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'DevelopmentEnvironment class' category: 'CustomerImporter'!
DevelopmentEnvironment class
	instanceVariableNames: ''!

!DevelopmentEnvironment class methodsFor: 'current' stamp: 'HAW 11/23/2023 16:42:50'!
identifier

	^ #DEV! !

!DevelopmentEnvironment class methodsFor: 'current' stamp: 'HAW 11/23/2023 16:43:52'!
isCurrent

	"
	self makeCurrent
	"
	^self environmentVariable = self identifier! !


!classDefinition: #IntegrationEnvironment category: 'CustomerImporter'!
Environment subclass: #IntegrationEnvironment
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!IntegrationEnvironment methodsFor: 'customer system' stamp: 'HAW 5/22/2022 21:40:48'!
createCustomerSystem

	^PersistentCustomerSystem new! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IntegrationEnvironment class' category: 'CustomerImporter'!
IntegrationEnvironment class
	instanceVariableNames: ''!

!IntegrationEnvironment class methodsFor: 'current' stamp: 'HAW 11/23/2023 16:43:07'!
identifier

	^ #INT! !

!IntegrationEnvironment class methodsFor: 'current' stamp: 'HAW 11/23/2023 16:44:04'!
isCurrent

	"
	self makeCurrent
	"
	^self environmentVariable = self identifier! !


!classDefinition: #Importer category: 'CustomerImporter'!
Object subclass: #Importer
	instanceVariableNames: 'record line readStream system newSupplier newCustomer weAreInSupplierMode'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Importer methodsFor: 'importing' stamp: 'sg 11/26/2023 18:24:28'!
importRecord

	self subclassResponsibility! !


!Importer methodsFor: 'evaluating - private' stamp: 'sg 11/25/2023 16:22:25'!
assertRecordNotEmpty

	record isEmpty ifTrue: [ self error: self class invalidRecordTypeErrorDescription ]! !

!Importer methodsFor: 'evaluating - private' stamp: 'sg 11/25/2023 16:23:10'!
createRecord

	^ record := line findTokens: $,! !

!Importer methodsFor: 'evaluating - private' stamp: 'sg 11/25/2023 16:23:16'!
hasLineToImport

	line := readStream nextLine.
	^line notNil! !


!Importer methodsFor: 'address' stamp: 'sg 11/25/2023 16:35:07'!
assertCustomerWasImported

	^ newCustomer ifNil: [ self error: self class canNotImportAddressWithoutCustomerErrorDescription ]! !

!Importer methodsFor: 'address' stamp: 'sg 11/25/2023 16:23:02'!
assertValidAddressRecord

	^ record size ~= 6 ifTrue: [ self error: self class invalidAddressRecordErrorDescription ]! !

!Importer methodsFor: 'address' stamp: 'sg 11/26/2023 18:25:26'!
importAddress

	self subclassResponsibility! !

!Importer methodsFor: 'address' stamp: 'sg 11/25/2023 16:23:53'!
isAddressRecord

	^ record first = 'A'! !


!Importer methodsFor: 'initialization' stamp: 'sg 11/25/2023 16:23:46'!
initializeFrom: aReadStream into: aCustomerSystem

	readStream := aReadStream.
	system := aCustomerSystem ! !



!Importer methodsFor: 'evaluating' stamp: 'sg 11/26/2023 18:30:14'!
value

	[ self hasLineToImport ] whileTrue: [
		self createRecord.
		self importRecord ].

	! !


!Importer methodsFor: 'customer' stamp: 'sg 11/25/2023 16:25:17'!
assertValidCustomerRecord

	^ record size ~= 5 ifTrue: [ self error: self class invalidCustomerRecordErrorDescription ]! !

!Importer methodsFor: 'customer' stamp: 'sg 11/26/2023 18:49:12'!
importCustomer

	self subclassResponsibility! !


!Importer methodsFor: 'as yet unclassified' stamp: 'sg 11/25/2023 16:46:26'!
addAddressToSupplier
	system addAddressToSupplier: record.! !

!Importer methodsFor: 'as yet unclassified' stamp: 'sg 11/25/2023 16:25:25'!
assertValidSupplierRecord
	^ record size ~= 4 ifTrue: [ self error: self class invalidSupplierRecordErrorDescription ]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Importer class' category: 'CustomerImporter'!
Importer class
	instanceVariableNames: ''!

!Importer class methodsFor: 'instance creation' stamp: 'sg 11/25/2023 16:29:20'!
from: aReadStream into: aCustomerSystem

	^self new initializeFrom: aReadStream into: aCustomerSystem! !


!Importer class methodsFor: 'error messages' stamp: 'sg 11/25/2023 16:35:11'!
canNotImportAddressWithoutCustomerErrorDescription

	^'Cannot import address without customer'! !

!Importer class methodsFor: 'error messages' stamp: 'sg 11/25/2023 16:29:28'!
invalidAddressRecordErrorDescription

	^'Address record has to have six fields'! !

!Importer class methodsFor: 'error messages' stamp: 'sg 11/25/2023 16:29:38'!
invalidCustomerRecordErrorDescription

	^'Invalid Customer record'! !

!Importer class methodsFor: 'error messages' stamp: 'sg 11/25/2023 16:29:44'!
invalidRecordTypeErrorDescription

	^'Invalid record type'! !


!Importer class methodsFor: 'importing' stamp: 'sg 11/25/2023 16:29:48'!
valueFrom: aReadStream into: aCustomerSystem

	^(self from: aReadStream into: aCustomerSystem) value! !


!classDefinition: #CustomerImporter category: 'CustomerImporter'!
Importer subclass: #CustomerImporter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!



!CustomerImporter methodsFor: 'customer' stamp: 'sg 11/26/2023 18:49:12'!
importCustomer

	self assertValidCustomerRecord.

	newCustomer := Customer new.
	newCustomer firstName: record second.
	newCustomer lastName: record third.
	newCustomer identificationType: record fourth.
	newCustomer identificationNumber: record fifth.
	system add: newCustomer! !

!CustomerImporter methodsFor: 'customer' stamp: 'sg 11/26/2023 18:42:15'!
isCustomerRecord

	^ record first = 'C'.! !


!CustomerImporter methodsFor: 'address' stamp: 'sg 11/26/2023 18:27:01'!
importAddress

	| newAddress |
	self assertCustomerWasImported.
	self assertValidAddressRecord.

	newAddress := Address new.
	
	newAddress streetName: record second.
	newAddress streetNumber: record third asNumber .
	newAddress town: record fourth.
	newAddress zipCode: record fifth asNumber .
	newAddress province: record sixth.
	
	newCustomer addAddress: newAddress.! !




!CustomerImporter methodsFor: 'importing' stamp: 'sg 11/26/2023 18:24:42'!
importRecord

	self assertRecordNotEmpty.

	self isCustomerRecord ifTrue: [ ^self importCustomer ].
	self isAddressRecord ifTrue: [ ^self importAddress ].
	
	self error: self class invalidRecordTypeErrorDescription! !


!classDefinition: #SupplierImporter category: 'CustomerImporter'!
Importer subclass: #SupplierImporter
	instanceVariableNames: 'customers'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!SupplierImporter methodsFor: 'evaluating - private' stamp: 'sg 11/26/2023 18:42:36'!
isExistingCustomerInSupplierRecord
	^ record first = 'EC'! !

!SupplierImporter methodsFor: 'evaluating - private' stamp: 'sg 11/26/2023 18:42:54'!
isSupplierRecord
	^ record first = 'S'! !


!SupplierImporter methodsFor: 'evaluating' stamp: 'sg 11/26/2023 18:42:44'!
isNewCustomerForSupplierRecord
	^ record first = 'NC'! !


!SupplierImporter methodsFor: 'importing' stamp: 'sg 11/26/2023 18:51:18'!
importRecord

	self assertRecordNotEmpty.

	self isAddressRecord ifTrue: [ ^self importAddress ].
	self isSupplierRecord ifTrue: [^self importSupplier].
	self isExistingCustomerInSupplierRecord ifTrue: [^self importExistingCustomer].
	self isNewCustomerForSupplierRecord ifTrue: [^self importCustomer].
		
	self error: self class invalidRecordTypeErrorDescription! !


!SupplierImporter methodsFor: 'address' stamp: 'sg 11/26/2023 18:27:33'!
importAddress

	| newAddress |
	
	self assertValidAddressRecord.

	newAddress := Address new.
	
	newAddress streetName: record second.
	newAddress streetNumber: record third asNumber .
	newAddress town: record fourth.
	newAddress zipCode: record fifth asNumber .
	newAddress province: record sixth.
	
	 newSupplier addAddress: newAddress! !


!SupplierImporter methodsFor: 'supplier' stamp: 'sg 11/26/2023 18:29:33'!
importSupplier
	
	self assertValidSupplierRecord.
	
	newSupplier := Supplier new.
	newSupplier firstName: record second.
	newSupplier identificationType: record third.
	newSupplier identificationNumber: record fourth.
	system add: newSupplier.
	! !


!SupplierImporter methodsFor: 'as yet unclassified' stamp: 'sg 11/26/2023 18:36:39'!
importExistingCustomer
	"check if exists then add"! !


!SupplierImporter methodsFor: 'customer' stamp: 'sg 11/26/2023 19:06:20'!
importCustomer

	self assertValidCustomerRecord.

	newCustomer := Customer new.
	newCustomer firstName: record second.
	newCustomer lastName: record third.
	newCustomer identificationType: record fourth.
	newCustomer identificationNumber: record fifth.
	newSupplier addCustomer: newCustomer.
	system add: newCustomer.! !


!classDefinition: #Party category: 'CustomerImporter'!
Object subclass: #Party
	instanceVariableNames: 'addresses firstName identificationNumber identificationType'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Party methodsFor: 'name' stamp: 'sg 11/23/2023 20:23:09'!
firstName

	^firstName ! !

!Party methodsFor: 'name' stamp: 'sg 11/23/2023 20:23:14'!
firstName: aName

	firstName := aName! !


!Party methodsFor: 'identification' stamp: 'sg 11/23/2023 20:23:17'!
identificationNumber

	^identificationNumber ! !

!Party methodsFor: 'identification' stamp: 'sg 11/23/2023 20:23:21'!
identificationNumber: anIdentificationNumber

	identificationNumber := anIdentificationNumber! !

!Party methodsFor: 'identification' stamp: 'sg 11/23/2023 20:23:27'!
identificationType

	^identificationType ! !

!Party methodsFor: 'identification' stamp: 'sg 11/23/2023 20:23:24'!
identificationType: anIdentificationType

	identificationType := anIdentificationType! !


!Party methodsFor: 'addresses' stamp: 'sg 11/26/2023 18:59:37'!
addAddress: anAddress

	addresses add: anAddress ! !

!Party methodsFor: 'addresses' stamp: 'sg 11/24/2023 16:45:06'!
addressAt: aStreetName ifNone: aNoneBlock

	^addresses detect: [ :address | address isAt: aStreetName ] ifNone: aNoneBlock ! !

!Party methodsFor: 'addresses' stamp: 'sg 11/24/2023 16:45:10'!
addresses

	^ addresses! !

!Party methodsFor: 'addresses' stamp: 'sg 11/24/2023 16:45:15'!
isAddressesEmpty

	^addresses isEmpty ! !


!classDefinition: #Customer category: 'CustomerImporter'!
Party subclass: #Customer
	instanceVariableNames: 'id lastName'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!


!Customer methodsFor: 'name' stamp: 'HAW 5/22/2022 00:19:29'!
lastName

	^lastName ! !

!Customer methodsFor: 'name' stamp: 'HAW 5/22/2022 00:19:29'!
lastName: aLastName

	lastName := aLastName
! !


!Customer methodsFor: 'initialization' stamp: 'HAW 5/22/2022 00:19:29'!
initialize

	super initialize.
	addresses := OrderedCollection new.! !


!classDefinition: #Supplier category: 'CustomerImporter'!
Party subclass: #Supplier
	instanceVariableNames: 'customers'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Supplier methodsFor: 'as yet unclassified' stamp: 'sg 11/26/2023 18:57:12'!
addCustomer: aCustomer

	customers add: aCustomer .! !

!Supplier methodsFor: 'as yet unclassified' stamp: 'sg 11/24/2023 16:46:24'!
initialize

	super initialize.
	addresses := OrderedCollection new.
	customers := OrderedCollection new.! !

