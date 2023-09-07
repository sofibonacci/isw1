!classDefinition: #CantSuspend category: 'CodigoRepetido-Ejercicio'!
Error subclass: #CantSuspend
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!


!classDefinition: #NotFound category: 'CodigoRepetido-Ejercicio'!
Error subclass: #NotFound
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!


!classDefinition: #CustomerBookTest category: 'CodigoRepetido-Ejercicio'!
TestCase subclass: #CustomerBookTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!

!CustomerBookTest methodsFor: 'testing' stamp: 'SG 9/6/2023 22:33:35'!
test01AddingCustomerShouldNotTakeMoreThan50Milliseconds

	| customerBook timeTakenToAddCustomer |
	
	customerBook := CustomerBook new.

	timeTakenToAddCustomer := self timeTakenWhen: [customerBook addCustomerNamed: 'John Lennon'].
	
	self assertThat: timeTakenToAddCustomer isLessThan: (50 * millisecond).
	
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'SG 9/6/2023 22:34:34'!
test02RemovingCustomerShouldNotTakeMoreThan100Milliseconds

	| customerBook timeTakenToRemoveCustomer |
	
	customerBook := CustomerBook new.
	
	customerBook addCustomerNamed: 'Paul McCartney'.
	 
	timeTakenToRemoveCustomer := self timeTakenWhen: [customerBook removeCustomerNamed: 'Paul McCartney'.].
	
	self assertThat: timeTakenToRemoveCustomer isLessThan: (100 * millisecond).
	
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'SG 9/6/2023 22:04:43'!
test03CanNotAddACustomerWithEmptyName 

	| customerBook |
			
	customerBook := CustomerBook new.
	
	self assertThat: 	[ customerBook addCustomerNamed: ''	.]
	 	failsOn: Error 
		andDoes: [ :anError | 
			self assert: anError messageText = CustomerBook customerCanNotBeEmptyErrorMessage.
			self assert: customerBook isEmpty ].

! !

!CustomerBookTest methodsFor: 'testing' stamp: 'SG 9/6/2023 22:05:44'!
test04CanNotRemoveAnInvalidCustomer
	
	| customerBook |
			
	customerBook := CustomerBook new.
	customerBook addCustomerNamed: 'John Lennon'.
	
	self assertThat:  [ customerBook removeCustomerNamed: 'Paul McCartney'.] 
		failsOn: NotFound 
		andDoes: [ :anError | self assertThatTheBook: customerBook hasOnlyThisCustomer: 'John Lennon'.]

! !

!CustomerBookTest methodsFor: 'testing' stamp: 'SG 9/6/2023 21:18:58'!
test05SuspendingACustomerShouldNotRemoveItFromCustomerBook

	| customerBook |
	
	customerBook := CustomerBook new.
	
	self addThenSuspendTheCustomer: 'Paul McCartney' FromTheBook: customerBook.
	
	self assertThatTheBook: customerBook hasActiveValue: 0 SuspendedValue: 1 TotalValue: 1.
	self assert: (customerBook includesCustomerNamed: 'Paul McCartney').
	

	
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'SG 9/6/2023 21:18:59'!
test06RemovingASuspendedCustomerShouldRemoveItFromCustomerBook

	| customerBook |
	
	customerBook := CustomerBook new.
	self addThenSuspendTheCustomer: 'Paul McCartney' FromTheBook: customerBook.
	
	customerBook removeCustomerNamed: 'Paul McCartney'.
	
	self assertThatTheBook: customerBook hasActiveValue: 0 SuspendedValue: 0 TotalValue: 0.
	self deny: (customerBook includesCustomerNamed: 'Paul McCartney').


	
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'SG 9/6/2023 22:11:49'!
test07CanNotSuspendAnInvalidCustomer
	
	| customerBook |
			
	customerBook := CustomerBook new.
	customerBook addCustomerNamed: 'John Lennon'.
	
	self assertThat:  	[ customerBook suspendCustomerNamed: 'George Harrison'.] 
		failsOn: CantSuspend  
		andDoes: [ :anError | self assertThatTheBook: customerBook hasOnlyThisCustomer: 'John Lennon'.]

! !

!CustomerBookTest methodsFor: 'testing' stamp: 'SG 9/6/2023 22:12:13'!
test08CanNotSuspendAnAlreadySuspendedCustomer
	
	| customerBook |
			
	customerBook := CustomerBook new.
	self addThenSuspendTheCustomer: 'John Lennon' FromTheBook: customerBook.

	self assertThat:	[ customerBook suspendCustomerNamed: 'John Lennon'.] 
		failsOn: CantSuspend 
		andDoes: [ :anError | self assertThatTheBook: customerBook hasOnlyThisCustomer: 'John Lennon'.]
! !


!CustomerBookTest methodsFor: 'assertions' stamp: 'SG 9/6/2023 22:37:05'!
assertThat: aCustomerBookAction failsOn: anErrorType andDoes: aBookAssertion
	
	[aCustomerBookAction value.
		self fail]
		on: anErrorType 
		do: aBookAssertion. 
		

! !

!CustomerBookTest methodsFor: 'assertions' stamp: 'SG 9/6/2023 22:37:25'!
assertThat: aValue isLessThan: anotherValue

	self assert: (aValue < anotherValue	).
	
! !

!CustomerBookTest methodsFor: 'assertions' stamp: 'SG 9/6/2023 22:37:39'!
assertThatTheBook: aCustomerBook hasActiveValue: anActiveValue SuspendedValue: aSuspendedValue TotalValue: aTotalValue.

	    self assert: anActiveValue equals: aCustomerBook numberOfActiveCustomers.
	    self assert: aSuspendedValue equals: aCustomerBook numberOfSuspendedCustomers.
	    self assert: aTotalValue equals: aCustomerBook numberOfCustomers.
	

	
! !

!CustomerBookTest methodsFor: 'assertions' stamp: 'SG 9/6/2023 22:37:58'!
assertThatTheBook: aCustomerBook hasOnlyThisCustomer: aCostumer

	self assert: aCustomerBook numberOfCustomers = 1.
	self assert: (aCustomerBook includesCustomerNamed: aCostumer).
! !


!CustomerBookTest methodsFor: 'accessing' stamp: 'SG 9/6/2023 22:26:15'!
addThenSuspendTheCustomer: aCustomer FromTheBook: aCustomerBook
	aCustomerBook addCustomerNamed: aCustomer.
	aCustomerBook suspendCustomerNamed: aCustomer.
	
	! !

!CustomerBookTest methodsFor: 'accessing' stamp: 'SG 9/6/2023 22:35:50'!
timeTakenWhen: aCustomerBookAction
	| timeBeforeAction timeAfterAction |
	
	timeBeforeAction := Time millisecondClockValue * millisecond.
	aCustomerBookAction value.
	timeAfterAction := Time millisecondClockValue * millisecond.
	
	^ (timeAfterAction-timeBeforeAction).
	
! !


!classDefinition: #CustomerBook category: 'CodigoRepetido-Ejercicio'!
Object subclass: #CustomerBook
	instanceVariableNames: 'suspended active'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!

!CustomerBook methodsFor: 'testing' stamp: 'NR 4/3/2019 10:14:26'!
includesCustomerNamed: aName

	^(active includes: aName) or: [ suspended includes: aName ]! !

!CustomerBook methodsFor: 'testing' stamp: 'NR 4/3/2019 10:14:26'!
isEmpty
	
	^active isEmpty and: [ suspended isEmpty ]! !


!CustomerBook methodsFor: 'initialization' stamp: 'NR 9/17/2020 07:23:04'!
initialize

	active := OrderedCollection new.
	suspended:= OrderedCollection new.! !


!CustomerBook methodsFor: 'customer management' stamp: 'SG 9/6/2023 22:44:47'!
addCustomerNamed: aName

	self signalCustomerNameEmptyOrAlreadyExists: aName.

	active add: aName ! !

!CustomerBook methodsFor: 'customer management' stamp: 'NR 4/3/2019 10:14:26'!
numberOfActiveCustomers
	
	^active size! !

!CustomerBook methodsFor: 'customer management' stamp: 'NR 4/3/2019 10:14:26'!
numberOfCustomers
	
	^active size + suspended size! !

!CustomerBook methodsFor: 'customer management' stamp: 'NR 9/19/2018 17:36:09'!
numberOfSuspendedCustomers
	
	^suspended size! !

!CustomerBook methodsFor: 'customer management' stamp: 'SG 9/6/2023 22:50:10'!
removeCustomerNamed: aName 

	(self customerNameInBook: aName) ifFalse:[^ NotFound signal.].
	
	self remove: aName from: active.
	
	self remove: aName from: suspended.
	
	^aName.
! !

!CustomerBook methodsFor: 'customer management' stamp: 'HernanWilkinson 7/6/2011 17:52'!
signalCustomerAlreadyExists 

	self error: self class customerAlreadyExistsErrorMessage! !

!CustomerBook methodsFor: 'customer management' stamp: 'HernanWilkinson 7/6/2011 17:51'!
signalCustomerNameCannotBeEmpty 

	self error: self class customerCanNotBeEmptyErrorMessage ! !

!CustomerBook methodsFor: 'customer management' stamp: 'SG 9/6/2023 22:41:58'!
suspendCustomerNamed: aName 

	self signalIfCustomerNameInCustomerBook: aName.

	self suspendActiveCustomerName: aName.
! !


!CustomerBook methodsFor: 'news' stamp: 'SG 9/6/2023 22:50:09'!
customerNameInBook: aName

	^(active includes: aName) or: [suspended includes: aName].! !

!CustomerBook methodsFor: 'news' stamp: 'SG 9/6/2023 22:51:39'!
remove: aName from: aCustomerCollection

	1 to: aCustomerCollection size do: [ :index |
		aName = (aCustomerCollection at: index)
			ifTrue: [
				aCustomerCollection removeAt: index.
			] 
	].
! !

!CustomerBook methodsFor: 'news' stamp: 'SG 9/6/2023 22:50:10'!
signalCustomerNameEmptyOrAlreadyExists: aName.
	aName isEmpty ifTrue: [ self signalCustomerNameCannotBeEmpty ].
	(self customerNameInBook: aName) ifTrue: [ self signalCustomerAlreadyExists ].! !

!CustomerBook methodsFor: 'news' stamp: 'v 9/6/2023 20:07:41'!
signalIfCustomerNameInCustomerBook: aName
	(active includes: aName) ifFalse: [^CantSuspend signal].
! !

!CustomerBook methodsFor: 'news' stamp: 'v 9/6/2023 20:07:51'!
suspendActiveCustomerName: aName
	active remove: aName.
	suspended add: aName.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CustomerBook class' category: 'CodigoRepetido-Ejercicio'!
CustomerBook class
	instanceVariableNames: ''!

!CustomerBook class methodsFor: 'error messages' stamp: 'NR 9/4/2023 17:02:48'!
customerAlreadyExistsErrorMessage

	^'Customer already exists!!!!!!'! !

!CustomerBook class methodsFor: 'error messages' stamp: 'NR 9/4/2023 17:02:52'!
customerCanNotBeEmptyErrorMessage

	^'Customer name cannot be empty!!!!!!'! !
