!classDefinition: #CartTest category: 'TusLibros'!
TestCase subclass: #CartTest
	instanceVariableNames: 'testObjectsFactory'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:10'!
test01NewCartsAreCreatedEmpty

	self assert: testObjectsFactory createCart isEmpty! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:10'!
test02CanNotAddItemsThatDoNotBelongToStore

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self 
		should: [ cart add: testObjectsFactory itemNotSellByTheStore ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidItemErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:10'!
test03AfterAddingAnItemTheCartIsNotEmptyAnymore

	| cart |
	
	cart := testObjectsFactory createCart.
	
	cart add: testObjectsFactory itemSellByTheStore.
	self deny: cart isEmpty ! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:10'!
test04CanNotAddNonPositiveNumberOfItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self 
		should: [cart add: 0 of: testObjectsFactory itemSellByTheStore ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidQuantityErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:10'!
test05CanNotAddMoreThanOneItemNotSellByTheStore

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self 
		should: [cart add: 2 of: testObjectsFactory itemNotSellByTheStore  ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidItemErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:11'!
test06CartRemembersAddedItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	cart add: testObjectsFactory itemSellByTheStore.
	self assert: (cart includes: testObjectsFactory itemSellByTheStore)! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:11'!
test07CartDoesNotHoldNotAddedItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self deny: (cart includes: testObjectsFactory itemSellByTheStore)! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:11'!
test08CartRemembersTheNumberOfAddedItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	cart add: 2 of: testObjectsFactory itemSellByTheStore.
	self assert: (cart occurrencesOf: testObjectsFactory itemSellByTheStore) = 2! !


!CartTest methodsFor: 'setup' stamp: 'HernanWilkinson 6/17/2013 18:09'!
setUp 

	testObjectsFactory := StoreTestObjectsFactory new.! !


!classDefinition: #CashierTest category: 'TusLibros'!
TestCase subclass: #CashierTest
	instanceVariableNames: 'testObjectsFactory debitBehavior'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:50'!
test01CanNotCheckoutAnEmptyCart

	| salesBook |
	
	salesBook := OrderedCollection new.
	self 
		should: [ Cashier 
			toCheckout: testObjectsFactory createCart 
			charging: testObjectsFactory notExpiredCreditCard 
			throught: self
			on: testObjectsFactory today
			registeringOn:  salesBook ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = Cashier cartCanNotBeEmptyErrorMessage.
			self assert: salesBook isEmpty ]! !

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:51'!
test02CalculatedTotalIsCorrect

	| cart cashier |
	
	cart := testObjectsFactory createCart.
	cart add: 2 of: testObjectsFactory itemSellByTheStore.
	
	cashier :=  Cashier
		toCheckout: cart 
		charging: testObjectsFactory notExpiredCreditCard 
		throught: self
		on: testObjectsFactory today 
		registeringOn: OrderedCollection new.
		
	self assert: cashier checkOut = (testObjectsFactory itemSellByTheStorePrice * 2)! !

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:51'!
test03CanNotCheckoutWithAnExpiredCreditCart

	| cart salesBook |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSellByTheStore.
	salesBook := OrderedCollection new.
	
	self
		should: [ Cashier 
				toCheckout: cart 
				charging: testObjectsFactory expiredCreditCard 
				throught: self
				on: testObjectsFactory today
				registeringOn: salesBook ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self assert: anError messageText = Cashier canNotChargeAnExpiredCreditCardErrorMessage.
			self assert: salesBook isEmpty ]! !

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 19:04'!
test04CheckoutRegistersASale

	| cart cashier salesBook total |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSellByTheStore.
	salesBook := OrderedCollection new.
 
	cashier:= Cashier 
		toCheckout: cart 
		charging: testObjectsFactory notExpiredCreditCard
		throught: self
		on: testObjectsFactory today
		registeringOn: salesBook.
		
	total := cashier checkOut.
					
	self assert: salesBook size = 1.
	self assert: salesBook first total = total.! !

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 19:00'!
test05CashierChargesCreditCardUsingMerchantProcessor

	| cart cashier salesBook total creditCard debitedAmout debitedCreditCard  |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSellByTheStore.
	creditCard := testObjectsFactory notExpiredCreditCard.
	salesBook := OrderedCollection new.
 
	cashier:= Cashier 
		toCheckout: cart 
		charging: creditCard
		throught: self
		on: testObjectsFactory today
		registeringOn: salesBook.
		
	debitBehavior := [ :anAmount :aCreditCard | 
		debitedAmout := anAmount.
		debitedCreditCard := aCreditCard ].
	total := cashier checkOut.
					
	self assert: debitedCreditCard = creditCard.
	self assert: debitedAmout = total.! !

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:59'!
test06CashierDoesNotSaleWhenTheCreditCardHasNoCredit

	| cart cashier salesBook creditCard |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSellByTheStore.
	creditCard := testObjectsFactory notExpiredCreditCard.
	salesBook := OrderedCollection new.
 	debitBehavior := [ :anAmount :aCreditCard | self error: Cashier creditCardHasNoCreditErrorMessage].
	
	cashier:= Cashier 
		toCheckout: cart 
		charging: creditCard
		throught: self
		on: testObjectsFactory today
		registeringOn: salesBook.
		
	self 
		should: [cashier checkOut ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = Cashier creditCardHasNoCreditErrorMessage.
			self assert: salesBook isEmpty ]! !


!CashierTest methodsFor: 'setup' stamp: 'HernanWilkinson 6/17/2013 19:03'!
setUp 

	testObjectsFactory := StoreTestObjectsFactory new.
	debitBehavior := [ :anAmount :aCreditCard | ]! !


!CashierTest methodsFor: 'merchant processor protocol' stamp: 'HernanWilkinson 6/17/2013 19:02'!
debit: anAmount from: aCreditCard 

	^debitBehavior value: anAmount value: aCreditCard ! !


!classDefinition: #InterfaceTest category: 'TusLibros'!
TestCase subclass: #InterfaceTest
	instanceVariableNames: 'testObjectsFactory'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!InterfaceTest methodsFor: 'as yet unclassified' stamp: 'VA 11/9/2023 15:04:19'!
createInterface

	^ Interface withUserValidation: testObjectsFactory userValidator andCatalog: testObjectsFactory defaultCatalog debitingThrought: self.! !

!InterfaceTest methodsFor: 'as yet unclassified' stamp: 'VS 11/7/2023 18:59:56'!
setUp 

	testObjectsFactory := StoreTestObjectsFactory new.! !

!InterfaceTest methodsFor: 'as yet unclassified' stamp: 'VA 11/9/2023 16:34:21'!
test01CartIsCreatedWithCorrectUserAndPassword
	| interface cartID |
	
	interface := self createInterface.
	
	cartID := interface createCartWithUserId: '5' andPassword: 'password123'.
	self assert: (interface listCart: cartID) equals:  OrderedCollection new.
		
		! !

!InterfaceTest methodsFor: 'as yet unclassified' stamp: 'VS 11/7/2023 19:04:16'!
test02CartCannotBeCreatedWithInvalidUserID
	| interface userValidator|
	userValidator := testObjectsFactory userValidator.
	interface := Interface withUserValidation: userValidator.
	
	
	self should: [interface createCartWithUserId: '4' andPassword: 'password123'. ]
		raise: Error - MessageNotUnderstood
		withExceptionDo:[:anError | 
			self assert: anError messageText = Interface incorrectUserErrorMessage.
			] ! !

!InterfaceTest methodsFor: 'as yet unclassified' stamp: 'VS 11/7/2023 19:04:52'!
test03CartCannotBeCreatedWithInvalidPassword
	| interface userValidator|
	
	userValidator := testObjectsFactory userValidator.
	
	interface := Interface withUserValidation: userValidator.
	
	 
	
	self should: [interface createCartWithUserId: '5' andPassword: 'password1234'. ]
		raise: Error - MessageNotUnderstood
		withExceptionDo:[:anError | 
			self assert: anError messageText = Interface incorrectUserErrorMessage.
			] ! !

!InterfaceTest methodsFor: 'as yet unclassified' stamp: 'VS 11/7/2023 19:05:51'!
test04AddToCartFromCatalogCorrectly
	| interface userValidator indexCart catalog aBookToAdd |
	
	userValidator := testObjectsFactory userValidator.
	
	catalog := testObjectsFactory defaultCatalog .
	aBookToAdd := testObjectsFactory itemSellByTheStore .
	
	interface := Interface withUserValidation: userValidator andCatalog: catalog.
	indexCart := interface createCartWithUserId: '5' andPassword: 'password123'. 

	interface addToCart: indexCart theBook: aBookToAdd 	withThisOcurrences: 1.
	
	self assert: (interface listCart: indexCart) equals: (OrderedCollection with: aBookToAdd).
		! !

!InterfaceTest methodsFor: 'as yet unclassified' stamp: 'VS 11/7/2023 19:06:00'!
test05AddToCartABookOutOfCatalog
	| interface userValidator indexCart catalog aBookNotInCatalog aBookInCatalog |
	
	userValidator := testObjectsFactory userValidator.
	
	catalog := testObjectsFactory defaultCatalog .
	aBookInCatalog :=testObjectsFactory itemSellByTheStore .
	aBookNotInCatalog := testObjectsFactory itemNotSellByTheStore .
	
	interface := Interface withUserValidation: userValidator andCatalog: catalog.
	
	indexCart := interface createCartWithUserId: '5' andPassword: 'password123'. 
	interface addToCart: indexCart theBook: aBookInCatalog 	withThisOcurrences: 1.
	
	self should:[
	interface addToCart: indexCart theBook: aBookNotInCatalog 	withThisOcurrences: 1.
	]
	raise: Error
	withExceptionDo: [:anError | self assert: anError messageText = Interface cannotAddInvalidBook .].
	self assert: (interface listCart: indexCart) equals: (OrderedCollection with:aBookInCatalog ).

		! !

!InterfaceTest methodsFor: 'as yet unclassified' stamp: 'VA 11/9/2023 16:35:55'!
test06CannotListInvalidIdCart
	| interface indexCart |

	indexCart := 3.
	
	interface := self createInterface.
	
	 	self should:[
	interface listCart: indexCart
	]
	raise: Error
	withExceptionDo: [:anError | self assert: anError messageText = Interface invalidCartIdErrorMessage.].

		! !

!InterfaceTest methodsFor: 'as yet unclassified' stamp: 'VS 11/7/2023 19:10:36'!
test07CanListACart
	| interface userValidator indexCart catalog aBookInCatalog |
	userValidator := testObjectsFactory userValidator.
	catalog := testObjectsFactory defaultCatalog .
	aBookInCatalog :=testObjectsFactory itemSellByTheStore .
	
	interface := Interface withUserValidation: userValidator andCatalog: catalog.
	indexCart := interface createCartWithUserId: '5' andPassword: 'password123'.
	interface addToCart: indexCart theBook: aBookInCatalog 	withThisOcurrences: 1.
	
	 self assert: 	(interface listCart: indexCart) equals: (OrderedCollection with: aBookInCatalog )! !

!InterfaceTest methodsFor: 'as yet unclassified' stamp: 'VA 11/9/2023 13:17:19'!
test08CanCheckoutCart
	| interface cartID aBookInCatalog |
	aBookInCatalog :=testObjectsFactory itemSellByTheStore .
	interface := self createInterface.
	
	cartID := interface createCartWithUserId: '5' andPassword: 'password123'.
	interface addToCart: cartID theBook: aBookInCatalog 	withThisOcurrences: 1.

	self shouldnt:[ interface checkoutCart: cartID withCreditCardNumber: testObjectsFactory creditCardNumber withExpiration: testObjectsFactory notExpiredCreditCardMonthOfYear withOwnerName: testObjectsFactory creditCardOwner.]
	raise: Error - MessageNotUnderstood.
	
	"self assert: 	(interface listPurchasesWithClientId:'5' withPassword: 'password123') equals: (OrderedCollection with: aBookInCatalog )"
	! !

!InterfaceTest methodsFor: 'as yet unclassified' stamp: 'VA 11/9/2023 13:17:19'!
test09CannotCheckoutANonExistentCart
	| interface |
	
	interface := self createInterface.
	
	self should:[ interface checkoutCart: '2' withCreditCardNumber: testObjectsFactory creditCardNumber withExpiration: testObjectsFactory notExpiredCreditCardMonthOfYear withOwnerName: testObjectsFactory creditCardOwner.]
	raise: Error - MessageNotUnderstood
	withExceptionDo: [ :anError |
			self assert: anError messageText = Interface invalidCartIdErrorMessage ].! !

!InterfaceTest methodsFor: 'as yet unclassified' stamp: 'VA 11/9/2023 13:17:19'!
test10CannotCheckoutAnEmptyCart
	| interface cartID |
	
	interface := self createInterface.
	
	cartID := interface createCartWithUserId: '5' andPassword: 'password123'.
	
	self should:[ interface checkoutCart: cartID withCreditCardNumber: testObjectsFactory creditCardNumber withExpiration: testObjectsFactory notExpiredCreditCardMonthOfYear withOwnerName: testObjectsFactory creditCardOwner.]
	raise: Error - MessageNotUnderstood
	withExceptionDo: [ :anError |
			self assert: anError messageText = Interface cannotCheckoutEmptyCartErrorMessage ].! !

!InterfaceTest methodsFor: 'as yet unclassified' stamp: 'VA 11/9/2023 14:57:57'!
test11CannotCheckoutUsingAnExpiredCreditCard
	| interface cartID |
	
	interface := self createInterface.
	
	cartID := interface createCartWithUserId: '5' andPassword: 'password123'.
	interface addToCart: cartID theBook: testObjectsFactory itemSellByTheStore 	withThisOcurrences: 1.
	
	self should:[ interface checkoutCart: cartID withCreditCardNumber: testObjectsFactory creditCardNumber withExpiration: testObjectsFactory expiredCreditCardMonthOfYear withOwnerName: testObjectsFactory creditCardOwner.]
	raise: Error - MessageNotUnderstood
	withExceptionDo: [ :anError |
			self assert: anError messageText = Interface canNotChargeAnExpiredCreditCardErrorMessage ].! !

!InterfaceTest methodsFor: 'as yet unclassified' stamp: 'VA 11/9/2023 15:52:46'!
test12ListPurchasesCorrectly
	| interface cartID listPurchases expectedPurchases |
	
	interface := self createInterface.
	
	cartID := interface createCartWithUserId: '5' andPassword: 'password123'.
	interface addToCart: cartID theBook: testObjectsFactory itemSellByTheStore 	withThisOcurrences: 2.
	
	interface checkoutCart: cartID withCreditCardNumber: testObjectsFactory creditCardNumber withExpiration: testObjectsFactory notExpiredCreditCardMonthOfYear withOwnerName: testObjectsFactory creditCardOwner.
	
	listPurchases := interface listPurchasesWithClientId: '5'  withPassword: 'password123'.
	expectedPurchases := OrderedCollection with:  testObjectsFactory itemSellByTheStore with:  testObjectsFactory itemSellByTheStore  with:  testObjectsFactory itemSellByTheStorePrice * 2.
	
	self assert: listPurchases equals: expectedPurchases.
	
	
	! !

!InterfaceTest methodsFor: 'as yet unclassified' stamp: 'VA 11/9/2023 16:42:54'!
test13CannotListPurchasesWithInvalidUserId
	| interface cartID expectedPurchases |
	
	interface := self createInterface.
	
	cartID := interface createCartWithUserId: '5' andPassword: 'password123'.
	interface addToCart: cartID theBook: testObjectsFactory itemSellByTheStore 	withThisOcurrences: 2.
	
	interface checkoutCart: cartID withCreditCardNumber: testObjectsFactory creditCardNumber withExpiration: testObjectsFactory notExpiredCreditCardMonthOfYear withOwnerName: testObjectsFactory creditCardOwner.
	
	self should:[ interface listPurchasesWithClientId: '2'  withPassword: 'password123'.
	expectedPurchases := OrderedCollection with:  testObjectsFactory itemSellByTheStore with:  testObjectsFactory itemSellByTheStore  with:  testObjectsFactory itemSellByTheStorePrice * 2.]
	raise: Error
	withExceptionDo:[ :anError |
			self assert: anError messageText = Interface incorrectUserErrorMessage ].
	
	
	! !

!InterfaceTest methodsFor: 'as yet unclassified' stamp: 'VA 11/9/2023 16:44:12'!
test14CannotListPurchasesWithInvalidPassword
	| interface cartID expectedPurchases |
	
	interface := self createInterface.
	
	cartID := interface createCartWithUserId: '5' andPassword: 'password123'.
	interface addToCart: cartID theBook: testObjectsFactory itemSellByTheStore 	withThisOcurrences: 2.
	
	interface checkoutCart: cartID withCreditCardNumber: testObjectsFactory creditCardNumber withExpiration: testObjectsFactory notExpiredCreditCardMonthOfYear withOwnerName: testObjectsFactory creditCardOwner.
	
	self should:[ interface listPurchasesWithClientId: '5'  withPassword: 'password1234'.
	expectedPurchases := OrderedCollection with:  testObjectsFactory itemSellByTheStore with:  testObjectsFactory itemSellByTheStore  with:  testObjectsFactory itemSellByTheStorePrice * 2.]
	raise: Error
	withExceptionDo:[ :anError |
			self assert: anError messageText = Interface incorrectUserErrorMessage ].
	
	
	! !

!InterfaceTest methodsFor: 'as yet unclassified' stamp: 'VA 11/9/2023 16:48:40'!
test15CanNotAddItemsToCartWhenSessionExpired
	| interface cartID |
	
	interface := self createInterface.
	
	cartID := interface createCartWithUserId: '5' andPassword: 'password123'.
	interface addToCart: cartID theBook: testObjectsFactory itemSellByTheStore 	withThisOcurrences: 2.
	
	self should:[ interface addToCart: cartID theBook: testObjectsFactory itemSellByTheStore  	withThisOcurrences: 1.]
	raise: Error
	withExceptionDo:[ :anError |
			self assert: anError messageText = Interface sessionHasExpiredErrorMessage ].
	
	
	! !


!InterfaceTest methodsFor: 'debit' stamp: 'VA 11/9/2023 15:05:38'!
debit: aTotal from: aCreditCard 
	! !


!classDefinition: #Cart category: 'TusLibros'!
Object subclass: #Cart
	instanceVariableNames: 'catalog items'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cart methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 17:45'!
invalidItemErrorMessage
	
	^'Item is not in catalog'! !

!Cart methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 17:45'!
invalidQuantityErrorMessage
	
	^'Invalid number of items'! !


!Cart methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 18:06'!
assertIsValidItem: anItem

	(catalog includesKey: anItem) ifFalse: [ self error: self invalidItemErrorMessage ]! !

!Cart methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 17:51'!
assertIsValidQuantity: aQuantity

	aQuantity strictlyPositive ifFalse: [ self error: self invalidQuantityErrorMessage ]! !


!Cart methodsFor: 'initialization' stamp: 'VA 11/9/2023 16:28:19'!
catalog
	^catalog 
! !

!Cart methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 17:48'!
initializeAcceptingItemsOf: aCatalog

	catalog := aCatalog.
	items := OrderedCollection new.! !


!Cart methodsFor: 'queries' stamp: 'HernanWilkinson 6/17/2013 17:45'!
occurrencesOf: anItem

	^items occurrencesOf: anItem  ! !


!Cart methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 17:44'!
includes: anItem

	^items includes: anItem ! !

!Cart methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 17:44'!
isEmpty
	
	^items isEmpty ! !


!Cart methodsFor: 'total' stamp: 'SG 11/7/2023 18:15:41'!
list

	^ items copy! !

!Cart methodsFor: 'total' stamp: 'HernanWilkinson 6/17/2013 19:09'!
total

	^ items sum: [ :anItem | catalog at: anItem ]! !


!Cart methodsFor: 'adding' stamp: 'HernanWilkinson 6/17/2013 17:44'!
add: anItem

	^ self add: 1 of: anItem ! !

!Cart methodsFor: 'adding' stamp: 'HernanWilkinson 6/17/2013 17:51'!
add: aQuantity of: anItem

	self assertIsValidQuantity: aQuantity.
	self assertIsValidItem: anItem.

	1 to: aQuantity do: [ :aNumber | items add: anItem ]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: 'TusLibros'!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 17:48'!
acceptingItemsOf: aCatalog

	^self new initializeAcceptingItemsOf: aCatalog ! !


!classDefinition: #Cashier category: 'TusLibros'!
Object subclass: #Cashier
	instanceVariableNames: 'cart salesBook merchantProcessor creditCard total customer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/17/2013 19:08'!
calculateTotal

	total := cart total.
	! !

!Cashier methodsFor: 'checkout - private' stamp: 'VA 11/9/2023 16:28:22'!
createSale

	^ Sale of: cart list boughtBy: customer withCatalog: cart catalog
! !

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/17/2013 19:06'!
debitTotal

	merchantProcessor debit: total from: creditCard.
	! !

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/17/2013 19:06'!
registerSale

	salesBook add: self createSale! !


!Cashier methodsFor: 'checkout' stamp: 'HernanWilkinson 6/17/2013 19:06'!
checkOut

	self calculateTotal.
	self debitTotal.
	self registerSale.

	^ total! !


!Cashier methodsFor: 'initialization' stamp: 'VA 11/9/2023 16:08:59'!
initializeToCheckout: aCart boughtBy: aCustomer charging: aCreditCard throught: aMerchantProcessor registeringOn: aSalesBook
	
	cart := aCart.
	creditCard := aCreditCard.
	merchantProcessor := aMerchantProcessor.
	salesBook := aSalesBook.
	customer := aCustomer ! !

!Cashier methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 18:53'!
initializeToCheckout: aCart charging: aCreditCard throught: aMerchantProcessor registeringOn: aSalesBook
	
	cart := aCart.
	creditCard := aCreditCard.
	merchantProcessor := aMerchantProcessor.
	salesBook := aSalesBook! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cashier class' category: 'TusLibros'!
Cashier class
	instanceVariableNames: ''!

!Cashier class methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 18:22'!
assertIsNotEmpty: aCart 
	
	aCart isEmpty ifTrue: [self error: self cartCanNotBeEmptyErrorMessage ]! !

!Cashier class methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 18:23'!
assertIsNotExpired: aCreditCard on: aDate
	
	(aCreditCard isExpiredOn: aDate) ifTrue: [ self error: self canNotChargeAnExpiredCreditCardErrorMessage ]! !


!Cashier class methodsFor: 'instance creation' stamp: 'VA 11/9/2023 16:08:38'!
toCheckout: aCart  boughtBy: aCustomer charging: aCreditCard throught: aMerchantProcessor on: aDate registeringOn: aSalesBook
	
	self assertIsNotEmpty: aCart.
	self assertIsNotExpired: aCreditCard on: aDate.
	
	^self new initializeToCheckout: aCart boughtBy: aCustomer charging: aCreditCard throught: aMerchantProcessor registeringOn: aSalesBook! !

!Cashier class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 18:51'!
toCheckout: aCart charging: aCreditCard throught: aMerchantProcessor on: aDate registeringOn: aSalesBook
	
	self assertIsNotEmpty: aCart.
	self assertIsNotExpired: aCreditCard on: aDate.
	
	^self new initializeToCheckout: aCart charging: aCreditCard throught: aMerchantProcessor registeringOn: aSalesBook! !


!Cashier class methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 18:21'!
canNotChargeAnExpiredCreditCardErrorMessage
	
	^'Can not charge an expired credit card'! !

!Cashier class methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 17:56'!
cartCanNotBeEmptyErrorMessage
	
	^'Can not check out an empty cart'! !

!Cashier class methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 19:02'!
creditCardHasNoCreditErrorMessage
	
	^'Credit card has no credit'! !


!classDefinition: #CreditCard category: 'TusLibros'!
Object subclass: #CreditCard
	instanceVariableNames: 'expiration'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CreditCard methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 18:39'!
isExpiredOn: aDate 
	
	^expiration start < (Month month: aDate monthIndex year: aDate yearNumber) start ! !


!CreditCard methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 18:38'!
initializeExpiringOn: aMonth 
	
	expiration := aMonth ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CreditCard class' category: 'TusLibros'!
CreditCard class
	instanceVariableNames: ''!

!CreditCard class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 18:38'!
expiringOn: aMonth 
	
	^self new initializeExpiringOn: aMonth! !


!classDefinition: #Interface category: 'TusLibros'!
Object subclass: #Interface
	instanceVariableNames: 'userValidator cartIds totalCarts bookCatalog merchantProcessor sales'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Interface methodsFor: 'initialization' stamp: 'SG 11/7/2023 17:17:09'!
initializeWithUserValidation: aUserValidationStructure
	cartIds := Dictionary new.
	totalCarts := 0.
	userValidator := aUserValidationStructure.! !

!Interface methodsFor: 'initialization' stamp: 'SG 11/7/2023 18:03:18'!
initializeWithUserValidation: aUserValidation andCatalog: aCatalog 

	cartIds := Dictionary new.
	totalCarts := 0.
	userValidator:= aUserValidation.
	bookCatalog := aCatalog.! !

!Interface methodsFor: 'initialization' stamp: 'VA 11/9/2023 16:18:16'!
initializeWithUserValidation: aUserValidation andCatalog: aCatalog debitingThrought: aMerchantProcessor

	cartIds := Dictionary new.
	totalCarts := 0.
	userValidator:= aUserValidation.
	bookCatalog := aCatalog.
	merchantProcessor := aMerchantProcessor .
	sales := OrderedCollection new.! !


!Interface methodsFor: 'listing' stamp: 'VA 11/9/2023 12:45:54'!
assertCartIdExists: aCartId

	(cartIds includesKey: aCartId) ifFalse: [self error: self class invalidCartIdErrorMessage ]! !

!Interface methodsFor: 'listing' stamp: 'VA 11/9/2023 16:34:38'!
listCart: aCartId
	self assertCartIdExists: aCartId.
	^(cartIds at: aCartId ) cart list! !

!Interface methodsFor: 'listing' stamp: 'VA 11/9/2023 16:43:35'!
listPurchasesWithClientId: aClientId withPassword: aPassword 
	| purchases |
	userValidator assertValidUserID: aClientId withPassword: aPassword.
	purchases := OrderedCollection new.
	sales do:[:aSale | (aSale customer = aClientId ) ifTrue:[purchases := aSale items. purchases add: aSale total]].
	
	^purchases
	
	
	
	! !


!Interface methodsFor: 'adding' stamp: 'VA 11/9/2023 16:24:19'!
addToCart: aCartIndex theBook: aBookToAdd withThisOcurrences: aQuantity
	(bookCatalog includesKey: aBookToAdd) ifFalse: [self error: self class cannotAddInvalidBook ].
	((cartIds at: aCartIndex) cart) add: aQuantity of: aBookToAdd .! !


!Interface methodsFor: 'creating' stamp: 'VA 11/9/2023 15:34:51'!
createCartWithUserId: anUserID andPassword: aPassword
	userValidator assertValidUserID: anUserID withPassword: aPassword.
	totalCarts := totalCarts +1.
	cartIds at: totalCarts put: (Purchase of:(Cart acceptingItemsOf: bookCatalog) by:anUserID ).
	^totalCarts ! !


!Interface methodsFor: 'checkingout' stamp: 'VA 11/9/2023 12:55:58'!
assertCartIsNotEmpty: aCartId

	^ (cartIds at:aCartId) isEmpty ifTrue:[self error: self class cannotCheckoutEmptyCartErrorMessage]! !

!Interface methodsFor: 'checkingout' stamp: 'VA 11/9/2023 16:24:48'!
checkoutCart: aCartId withCreditCardNumber: aCardNumber withExpiration: anExpirationDate withOwnerName: aName 
	
	| creditCard  |
	creditCard:=CreditCard expiringOn: anExpirationDate .
	
	self assertCartIdExists: aCartId.
	"self assertCartIsNotEmpty: aCartId."
	
	(Cashier toCheckout: (cartIds at:aCartId ) cart boughtBy: (cartIds at:aCartId ) customer  charging: creditCard throught: merchantProcessor on: DateAndTime today  registeringOn: sales) checkOut ! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Interface class' category: 'TusLibros'!
Interface class
	instanceVariableNames: ''!

!Interface class methodsFor: 'as yet unclassified' stamp: 'SG 11/7/2023 18:22:30'!
cannotAddInvalidBook
	^'cant add invalid book'! !

!Interface class methodsFor: 'as yet unclassified' stamp: 'VA 11/9/2023 12:40:14'!
invalidCartIdErrorMessage
	^'Invalid cart Id'
	! !


!Interface class methodsFor: 'instance creation' stamp: 'sg 11/6/2023 21:09:26'!
incorrectUserErrorMessage
	^'incorrect userID or password'! !

!Interface class methodsFor: 'instance creation' stamp: 'SG 11/7/2023 17:11:42'!
withUserValidation: aUserValidator 
	^self new initializeWithUserValidation: aUserValidator! !

!Interface class methodsFor: 'instance creation' stamp: 'SG 11/7/2023 17:54:10'!
withUserValidation: aUserValidation andCatalog: aDictionary 
	^self new initializeWithUserValidation: aUserValidation andCatalog: aDictionary ! !

!Interface class methodsFor: 'instance creation' stamp: 'VA 11/9/2023 15:04:57'!
withUserValidation: aUserValidation andCatalog: aDictionary debitingThrought: aMerchantProcessor 
	^self new initializeWithUserValidation: aUserValidation andCatalog: aDictionary debitingThrought: aMerchantProcessor! !


!Interface class methodsFor: 'errorMessages' stamp: 'VA 11/9/2023 14:53:58'!
canNotChargeAnExpiredCreditCardErrorMessage
	^Cashier canNotChargeAnExpiredCreditCardErrorMessage 
	! !

!Interface class methodsFor: 'errorMessages' stamp: 'VA 11/9/2023 14:53:28'!
cannotCheckoutEmptyCartErrorMessage
	^Cashier cartCanNotBeEmptyErrorMessage ! !


!classDefinition: #Purchase category: 'TusLibros'!
Object subclass: #Purchase
	instanceVariableNames: 'cart client customer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Purchase methodsFor: 'as yet unclassified' stamp: 'VA 11/9/2023 16:24:15'!
cart
	^cart! !

!Purchase methodsFor: 'as yet unclassified' stamp: 'VA 11/9/2023 16:03:56'!
customer
	^customer ! !

!Purchase methodsFor: 'as yet unclassified' stamp: 'VA 11/9/2023 16:03:36'!
initializeOf: aCart by: aCustomer
	cart := aCart .
	customer := aCustomer .! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Purchase class' category: 'TusLibros'!
Purchase class
	instanceVariableNames: ''!

!Purchase class methodsFor: 'as yet unclassified' stamp: 'VA 11/9/2023 15:59:41'!
of: aCart by:anUserID
	^self new initializeOf: aCart by: anUserID ! !


!classDefinition: #Sale category: 'TusLibros'!
Object subclass: #Sale
	instanceVariableNames: 'total items customer catalog'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Sale methodsFor: 'total' stamp: 'VA 11/9/2023 16:29:06'!
total
	
	^ items sum: [ :anItem | catalog at: anItem ]
	
	! !


!Sale methodsFor: 'initialization' stamp: 'VA 11/9/2023 16:20:29'!
customer
	^customer
	! !

!Sale methodsFor: 'initialization' stamp: 'VA 11/9/2023 16:16:21'!
initializeOf: aListOfItems boughtBy: aCustomer
	items:= aListOfItems .
	customer:= aCustomer .
	
	total:=0! !

!Sale methodsFor: 'initialization' stamp: 'VA 11/9/2023 16:26:59'!
initializeOf: aListOfItems boughtBy: aCustomer withCatalog: aCatalog
	items:= aListOfItems .
	customer:= aCustomer .
	catalog := aCatalog .
	total:=0! !

!Sale methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 18:47'!
initializeTotal: aTotal

	total := aTotal ! !

!Sale methodsFor: 'initialization' stamp: 'VA 11/9/2023 16:20:41'!
items
	^items copy
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Sale class' category: 'TusLibros'!
Sale class
	instanceVariableNames: ''!

!Sale class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 18:47'!
of: aTotal

	"should assert total is not negative or 0!!"
	^self new initializeTotal: aTotal ! !

!Sale class methodsFor: 'instance creation' stamp: 'VA 11/9/2023 16:14:47'!
of: aListOfItems boughtBy: aCustomer 

	"should assert total is not negative or 0!!"
	^self new initializeOf: aListOfItems boughtBy: aCustomer 
! !

!Sale class methodsFor: 'instance creation' stamp: 'VA 11/9/2023 16:27:15'!
of: aListOfItems boughtBy: aCustomer withCatalog: aCatalog
	"should assert total is not negative or 0!!"
	^self new initializeOf: aListOfItems boughtBy: aCustomer withCatalog: aCatalog
! !


!classDefinition: #StoreTestObjectsFactory category: 'TusLibros'!
Object subclass: #StoreTestObjectsFactory
	instanceVariableNames: 'today'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!StoreTestObjectsFactory methodsFor: 'items' stamp: 'HernanWilkinson 6/17/2013 18:08'!
itemNotSellByTheStore
	
	^'invalidBook'! !

!StoreTestObjectsFactory methodsFor: 'items' stamp: 'HernanWilkinson 6/17/2013 18:08'!
itemSellByTheStore
	
	^ 'validBook'! !

!StoreTestObjectsFactory methodsFor: 'items' stamp: 'HernanWilkinson 6/17/2013 18:08'!
itemSellByTheStorePrice
	
	^10! !


!StoreTestObjectsFactory methodsFor: 'cart' stamp: 'HernanWilkinson 6/17/2013 18:08'!
createCart
	
	^Cart acceptingItemsOf: self defaultCatalog! !

!StoreTestObjectsFactory methodsFor: 'cart' stamp: 'HernanWilkinson 6/17/2013 18:08'!
defaultCatalog
	
	^ Dictionary new
		at: self itemSellByTheStore put: self itemSellByTheStorePrice;
		yourself ! !

!StoreTestObjectsFactory methodsFor: 'cart' stamp: 'VS 11/7/2023 19:04:12'!
userValidator 
	^UserValidator withUserId: '5' andPassword: 'password123'.! !


!StoreTestObjectsFactory methodsFor: 'credit card' stamp: 'VA 11/9/2023 13:00:19'!
creditCardNumber
	^'123456789'! !

!StoreTestObjectsFactory methodsFor: 'credit card' stamp: 'HernanWilkinson 6/17/2013 18:37'!
expiredCreditCard
	
	^CreditCard expiringOn: (Month month: today monthIndex year: today yearNumber - 1)! !

!StoreTestObjectsFactory methodsFor: 'credit card' stamp: 'VA 11/9/2023 13:04:17'!
expiredCreditCardMonthOfYear
	^Month month: today monthIndex year: today yearNumber -1! !

!StoreTestObjectsFactory methodsFor: 'credit card' stamp: 'HernanWilkinson 6/17/2013 18:36'!
notExpiredCreditCard
	
	^CreditCard expiringOn: (Month month: today monthIndex year: today yearNumber + 1)! !

!StoreTestObjectsFactory methodsFor: 'credit card' stamp: 'VA 11/9/2023 13:03:47'!
notExpiredCreditCardMonthOfYear
	^Month month: today monthIndex year: today yearNumber +1! !


!StoreTestObjectsFactory methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 18:37'!
initialize

	today := DateAndTime now! !


!StoreTestObjectsFactory methodsFor: 'date' stamp: 'HernanWilkinson 6/17/2013 18:37'!
today
	
	^ today! !


!StoreTestObjectsFactory methodsFor: 'as yet unclassified' stamp: 'VA 11/9/2023 13:17:19'!
creditCardOwner
	^'Sofia Queso'! !


!classDefinition: #UserValidator category: 'TusLibros'!
Object subclass: #UserValidator
	instanceVariableNames: 'userValidator'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!UserValidator methodsFor: 'as yet unclassified' stamp: 'sg 11/6/2023 21:44:53'!
assertValidUserID: anUserID withPassword: aPassword
	((userValidator includesKey: anUserID) and:[(userValidator at: anUserID)= aPassword ])ifFalse: [	self error: Interface incorrectUserErrorMessage.].
	! !

!UserValidator methodsFor: 'as yet unclassified' stamp: 'sg 11/6/2023 21:44:42'!
initializeWithUserId: anUserId andPassword: aPassword 
	userValidator := Dictionary new at: anUserId put: aPassword;yourself .! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'UserValidator class' category: 'TusLibros'!
UserValidator class
	instanceVariableNames: ''!

!UserValidator class methodsFor: 'class initialization' stamp: 'sg 11/6/2023 21:00:16'!
withUserId: anUserId andPassword: aPassword 
	^self new initializeWithUserId: anUserId andPassword: aPassword ! !
