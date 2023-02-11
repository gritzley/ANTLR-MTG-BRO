grammar MTG;

import Types, Words;

// High level building blocks
card
    : title castingCost? spellTypeline (imperative|ability)+ EOF #spellCard
    | title castingCost? permanentTypeline ability* powerToughness? EOF #permanentCard
    ;
title: (( ID
    // matching some words that are rule words but can also appear in titles
    | 'Desert'
    ) | ',' )+;
castingCost: PIP+ ;
spellTypeline: spellType ;
permanentTypeline: permanentType+ (DASH subType+)? ;

//  Abilities are permanent, triggered or activated effects and usually end in an imperrative
//  Example: "{T}: Draw a Card"
ability
    : KEYWORD
	| 'Enchant' permanentType
    | etbAbility
    | activatedAbility
	| gameEffect '.'
	| triggeredAbility
    ;
etbAbility: 'When' SELF 'enters the battlefield,' imperative+ ;
triggeredAbility: 'Whenever' trigger ',' imperative+;
activatedAbility: PIP+ (',' pureImperative)? ':' imperative+ ('Activate' activationRestriction ('and' activationRestriction)? '.')? ;

activationRestriction
    : 'only as a sorcery'
    | 'only once'
	| 'only during your turn'
    ;

// Imperatives are directions for actions to be taken that can change the gamestate
// Example: "Draw a card."
imperative
    : partialImperative ((', then' | 'and' ) partialImperative)? '.'
    | 'You may' partialImperative '.' ('If you don’t,' partialImperative '.')?
    | ifClause partialImperative
	| 'Choose' NUMBER DASH (BULLETPOINT imperative)+
    ;

// These are the bits that each instruction is made out of.
partialImperative
	: pureImperative #simpleImperative
    | gameEffect timeModifier? #applyGameEffect
    | YOU 'gain' INT 'life' #gainLife
	| targetingImperative ('. Its controller' playerImperative)? #targetGameObject
	| targetingImperative '.' targetClause ', instead' alternateTargetingImperative #targetGamObjectWithAlternateMode
	;

pureImperative
    : PUT (AN counterType | NUMBER counterTypes) 'on' (SELF | AN permanentObject) additionalModifier? #addCounters
    | EXILE zone #exileCardsInZone
    | EXILE SELF #exileSelf
    | CREATE (AN 'tapped'? tokenDescription 'token' forEach? | NUMBER 'tapped'? tokenDescription 'tokens') #makeTokens
    | MILL NUMBER 'cards' #millCards
    | PUT AN cardObject ('or' AN cardObject)? 'from' zone 'into your hand' #putCardInHand
    | REVEAL (AN cardObject|SELF) 'from your hand' #revealCard
	| SEARCH zone 'for a' cardObject ', reveal it,'? 'put it into' zone ', then shuffle'? #search
	| SCRY INT #scry
	| LOOK 'at the top' NUMBER 'cards of your library.' selectCards #selectFromLibrary
	| DRAW ('a card' | NUMBER 'cards') #drawCards
	| RETURN TARGET cardObject 'from your graveyard to your hand' #recycle
	| ENCHANTED permanentType gainsModifier 'until end of turn'? #modifyEnchantedCreature
    ;

targetingImperative
	: EXILE targetPermanent ('until' condition)? #exileTarget
    | DESTROY 'up to one'? targetPermanent #destroyTarget
	| PUT (AN counterType | NUMBER counterTypes) 'on' targetPermanent additionalModifier? #addCountersOnTarget
	| YOU 'and' 'up to one'? targetOpponent 'each' pureImperative #selfAndOpponent
    | SELF 'deals' INT 'damage to' (targetCreature | targetPlayer | TARGET PLANESWALKER) #dealDamageToTarget
	| targetPermanent 'gains' KEYWORD ('and' KEYWORD)? 'until end of turn' #modifyTarget
	| RETURN TARGET permanentObject 'to its owner’s hand' #bounce
	;

alternateTargetingImperative
	: EXILE 'it'
	| EXILE 'it, then' alternateTargetingImperative
	| 'return that card to its owner’s hand'
	;

targetClause
	: IF 'it has' KEYWORD
	;

additionalModifier
	: '. It gains' KEYWORD timeModifier?
	;

playerImperative
	: 'gains' INT 'life' # gainsLife
	;

gainsModifier
	: 'gets +' INT '/+' INT ('and' gainsModifier)?
	| 'gains' KEYWORD ('and' KEYWORD)?
	;

trigger
	: SELF ('or' ANOTHER? permanentObject)? 'enters the battlefield' 'under your control'? #etb
	;

gameEffect
	: permanentObjects 'get' statModifier #globalModifier
    | PLAYERS 'can’t cast' spellObjects #castRestriction
    ;

timeModifier
	: ('until end of turn' | 'this turn') #thisTurn
	| 'until' condition #untilCondition
	;

statModifier: ('+' | '-') INT ('/+' | '/-') INT ;

selectCards: 'Put up to' (NUMBER | 'X') cardObjects 'from among them' targetZone '. Put the rest' targetZone ;

// Clauses are used to add conditions to imperatives
ifClause
    : IF valueExpression 'is equal to or less than' valueExpression ',' #idLEQ
    ;

condition
	: SELF 'leaves the battlefield' #untilSelfLeaves
	;

// Objects
cardObjects: cardSelector ('and/or' cardSelector)? 'cards' targetingRule* ;
cardObject: cardSelector ('or' cardSelector)? 'card' targetingRule* ;

spellObjects: cardSelector 'spells' targetingRule* ;
spellObject: cardSelector 'spell' targetingRule*;

permanentObject: 'tapped'? permanentSelector? (permanentIdentifier | 'permanent') targetingRule* ;
permanentObjects: 'tapped'? permanentSelector? (permanentIdentifiers | 'permanents') targetingRule* ;

cardSelector: (permanentSelector*|spellType*);

permanentSelector
    : ((nonPermanentIdentifier ',')* nonPermanentIdentifier)? permanentIdentifier+
    | (nonPermanentIdentifier ',')* nonPermanentIdentifier
    ;

nonPermanentIdentifier: nonPermanentType | NONCOLOR ;
permanentIdentifiers: creatureTypes | landTypes  | permanentTypes ;
permanentIdentifier: creatureType | landType | permanentType ;

zone
    : YOUR ZONE
    | TARGET PLAYERS ZONE
    | TARGET ZONE
    | ALL ZONES
    | PSEUDOZONE
    ;
targetZone
	: 'into' zone
	| 'onto the battlefield'
	| 'on the bottom of your library in a random order'
	;

// Targeting
targetPermanent: ANOTHER? TARGET permanentObject ('or' permanentObject)? targetingRule*;
targetCreature: ANOTHER? TARGET 'tapped'? permanentSelector? CREATURE;

targetPlayer: ANOTHER? TARGET 'player';
targetOpponent: TARGET 'opponent';

targetingRule
    : 'with mana value' INT 'or less' #mvLEQInt
	| 'with mana value less than or equal to' valueExpression #mvLEQValue
    | 'you own' #youOwn
    | 'you control' #youControl
	| 'you don’t control' #youDontControl
    ;

// Odd Bits
forEach
    : 'for each' 'other'? permanentObject
    ;
valueExpression
    : 'the result' #dieResult
    | 'the number of' (creatureTypes | landType) 'you control' #numberYouControl
    ;

tokenDescription
    : powerToughness COLORNAME ('and' COLORNAME)? creatureType* permanentType+ #creatureToken
    | tokenType #specialToken
    ;
powerToughness: INT '/' INT ;

