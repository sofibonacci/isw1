!classDefinition: #MarsRoverTest category: 'Mars Rover'!
TestCase subclass: #MarsRoverTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Mars Rover'!

!MarsRoverTest methodsFor: 'Zero' stamp: 'SG 10/9/2023 01:58:17'!
testZero
	
	| rover |
	
	rover := MarsRover new withPosition: 0@0 facing: North new.
	
	rover runCommands: ''.
	
	self assert: [rover isInPosition: (0@0) facing: North new].! !


!MarsRoverTest methodsFor: 'One' stamp: 'SG 10/9/2023 01:58:26'!
testOneBackNorth
	
	| rover |
	
	rover := MarsRover new withPosition: 0@0 facing: North new.
	
	rover runCommands: 'b'.
	
	self assert: [rover isInPosition: (0@-1) facing: North new].! !

!MarsRoverTest methodsFor: 'One' stamp: 'SG 10/9/2023 01:58:32'!
testOneEastLeft
	
	| rover |
	
	rover := MarsRover new withPosition: 0@0 facing: East new.
	
	rover runCommands: 'l'.
	
	self assert: [rover isInPosition: (0@0) facing: North new].! !

!MarsRoverTest methodsFor: 'One' stamp: 'SG 10/9/2023 01:58:39'!
testOneEastRight
	
	| rover |
	
	rover := MarsRover new withPosition: 0@0 facing: East new.
	
	rover runCommands: 'r'.
	
	self assert: [rover isInPosition: (0@0) facing: South new].! !

!MarsRoverTest methodsFor: 'One' stamp: 'SG 10/9/2023 01:58:44'!
testOneForwardNorth
	
	| rover |
	
	rover := MarsRover new withPosition: 0@0 facing: North new.
	
	rover runCommands: 'f'.
	
	self assert: [rover isInPosition: (0@1) facing: North new].! !

!MarsRoverTest methodsFor: 'One' stamp: 'SG 10/9/2023 01:58:50'!
testOneNorthLeft
	
	| rover |
	
	rover := MarsRover new withPosition: 0@0 facing: North new.
	
	rover runCommands: 'l'.
	
	self assert: [rover isInPosition: (0@0) facing: West new].! !

!MarsRoverTest methodsFor: 'One' stamp: 'SG 10/9/2023 01:58:57'!
testOneNorthRight
	
	| rover |
	
	rover := MarsRover new withPosition: 0@0 facing: North new.
	
	rover runCommands: 'r'.
	
	self assert: [rover isInPosition: (0@0) facing: East new].! !

!MarsRoverTest methodsFor: 'One' stamp: 'SG 10/9/2023 01:59:02'!
testOneSouthLeft
	
	| rover |
	
	rover := MarsRover new withPosition: 0@0 facing: South new.
	
	rover runCommands: 'l'.
	
	self assert: [rover isInPosition: (0@0) facing: East new].! !

!MarsRoverTest methodsFor: 'One' stamp: 'SG 10/9/2023 01:59:10'!
testOneSouthRight
	
	| rover |
	
	rover := MarsRover new withPosition: 0@0 facing: South new.
	
	rover runCommands: 'r'.
	
	self assert: [rover isInPosition: (0@0) facing: West new].! !

!MarsRoverTest methodsFor: 'One' stamp: 'SG 10/9/2023 01:59:16'!
testOneWestLeft
	
	| rover |
	
	rover := MarsRover new withPosition: 0@0 facing: West new.
	
	rover runCommands: 'l'.
	
	self assert: [rover isInPosition: (0@0) facing: South new].! !

!MarsRoverTest methodsFor: 'One' stamp: 'SG 10/9/2023 01:59:22'!
testOneWestRight
	
	| rover |
	
	rover := MarsRover new withPosition: 0@0 facing: West new.
	
	rover runCommands: 'r'.
	
	self assert: [rover isInPosition: (0@0) facing: North new].! !


!MarsRoverTest methodsFor: 'Many' stamp: 'SG 10/9/2023 01:59:47'!
test02ForwardNorth
	
	| rover |
	
	rover := MarsRover new withPosition: 0@0 facing: North new.
	
	rover runCommands: 'ff'.
	
	self assert: [rover isInPosition: (0@2) facing: North new].! !

!MarsRoverTest methodsFor: 'Many' stamp: 'SG 10/9/2023 01:59:57'!
test02LeftFromNorth

	| rover |

	rover := MarsRover new withPosition: 0@0 facing: North new.

	rover runCommands: 'll'.

	self assert: [rover isInPosition: (0@0) facing: South new].! !

!MarsRoverTest methodsFor: 'Many' stamp: 'SG 10/9/2023 02:00:08'!
testInvalidCommand
	
	| rover |
	
	rover := MarsRover new withPosition: 0@0 facing: North new.
	
	rover runCommands: 'fqf'.
	
	self assert: [rover isInPosition: (0@1) facing: North new].! !

!MarsRoverTest methodsFor: 'Many' stamp: 'SG 10/9/2023 02:00:14'!
testManyInstructions

	| rover |

	rover := MarsRover new withPosition: 0@0 facing: North new.

	rover runCommands: 'ffblfffblffblffblbbblr' .

	self assert: [rover isInPosition: -1@ -3 facing: North new].! !


!classDefinition: #CardinalPoint category: 'Mars Rover'!
Object subclass: #CardinalPoint
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Mars Rover'!

!CardinalPoint methodsFor: 'moving' stamp: 'SG 10/7/2023 18:45:27'!
backward
	self subclassResponsibility.! !

!CardinalPoint methodsFor: 'moving' stamp: 'SG 10/7/2023 18:45:11'!
forward
	self subclassResponsibility.! !


!CardinalPoint methodsFor: 'turning' stamp: 'SG 10/7/2023 17:29:22'!
left
	self subclassResponsibility.! !

!CardinalPoint methodsFor: 'turning' stamp: 'SG 10/7/2023 17:29:26'!
right
	self subclassResponsibility.! !


!CardinalPoint methodsFor: 'comparing' stamp: 'SG 10/7/2023 19:25:21'!
= anObject
	^ self class = anObject class.! !


!classDefinition: #East category: 'Mars Rover'!
CardinalPoint subclass: #East
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Mars Rover'!

!East methodsFor: 'moving' stamp: 'SG 10/7/2023 19:29:08'!
backward
	^ -1@0! !

!East methodsFor: 'moving' stamp: 'SG 10/7/2023 19:29:12'!
forward
	^ 1@0! !


!East methodsFor: 'turning' stamp: 'SG 10/9/2023 01:54:31'!
left
	^ North new.
! !

!East methodsFor: 'turning' stamp: 'SG 10/7/2023 19:29:23'!
right
	^ South new.! !


!classDefinition: #North category: 'Mars Rover'!
CardinalPoint subclass: #North
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Mars Rover'!

!North methodsFor: 'moving' stamp: 'SG 10/7/2023 19:29:29'!
backward
	^ 0@-1! !

!North methodsFor: 'moving' stamp: 'SG 10/7/2023 19:29:33'!
forward
	^ 0@1! !


!North methodsFor: 'turning' stamp: 'SG 10/7/2023 19:29:37'!
left
	^ West new.! !

!North methodsFor: 'turning' stamp: 'SG 10/7/2023 19:29:41'!
right
	^ East new.! !


!classDefinition: #South category: 'Mars Rover'!
CardinalPoint subclass: #South
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Mars Rover'!

!South methodsFor: 'moving' stamp: 'SG 10/7/2023 19:29:46'!
backward
	^ 0@1! !

!South methodsFor: 'moving' stamp: 'SG 10/7/2023 19:29:49'!
forward
	^ 0@-1! !


!South methodsFor: 'turning' stamp: 'SG 10/7/2023 19:29:53'!
left
	^ East new.! !

!South methodsFor: 'turning' stamp: 'SG 10/7/2023 19:29:57'!
right
	^ West new.! !


!classDefinition: #West category: 'Mars Rover'!
CardinalPoint subclass: #West
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Mars Rover'!

!West methodsFor: 'moving' stamp: 'SG 10/7/2023 19:03:32'!
backward
	^1@0! !

!West methodsFor: 'moving' stamp: 'SG 10/7/2023 19:03:39'!
forward	
	^-1@0! !


!West methodsFor: 'turning' stamp: 'SG 10/7/2023 19:30:03'!
left
	^ South new.! !

!West methodsFor: 'turning' stamp: 'SG 10/7/2023 19:30:07'!
right
	^ North new.! !


!classDefinition: #MarsRover category: 'Mars Rover'!
Object subclass: #MarsRover
	instanceVariableNames: 'position facing'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Mars Rover'!

!MarsRover methodsFor: 'initialization' stamp: 'SG 10/7/2023 15:51:36'!
withPosition: aPosition facing: aCardinalPoint 
	position := aPosition.
	facing := aCardinalPoint.! !


!MarsRover methodsFor: 'running' stamp: 'SG 10/7/2023 19:31:13'!
moveBackwards
	^ position := position + (facing backward)! !

!MarsRover methodsFor: 'running' stamp: 'SG 10/7/2023 19:31:17'!
moveForward
	^ position := position + (facing forward)! !

!MarsRover methodsFor: 'running' stamp: 'SG 10/9/2023 01:53:46'!
runCommands: aListOfCommands
	aListOfCommands do: [:aCommand |
		(aCommand = $f) ifTrue: [self moveForward] ifFalse: [
			(aCommand = $b) ifTrue: [self moveBackwards] ifFalse:
						[(aCommand = $l) ifTrue: [self turnLeft] ifFalse: [
							(aCommand = $r) ifTrue: [	self turnRight] ifFalse: [^self].
					]
				]
			]
		]
! !

!MarsRover methodsFor: 'running' stamp: 'SG 10/7/2023 19:31:20'!
turnLeft
	^ facing := facing left! !

!MarsRover methodsFor: 'running' stamp: 'SG 10/7/2023 19:31:23'!
turnRight
	^ facing := facing right! !


!MarsRover methodsFor: 'accessing' stamp: 'SG 10/7/2023 19:30:12'!
isInPosition: aPosition facing: aCardinalPoint
	^ (position = aPosition) and: (facing = aCardinalPoint).! !
