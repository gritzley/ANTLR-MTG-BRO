grammar Types;

import LetterFragments;

//// SUPERYTPES
superType: spellType | permanentType ;
superTypes: spellTypes | permanentTypes ;

// Spells
INSTANT: I 'nstant';
INSTANTS: I 'nstants';

SORCERY: S 'orcery';
SORCERIES: S 'orceries';

spellType
    : INSTANT
    | SORCERY
    ;
spellTypes
	: INSTANTS
	| SORCERIES
	;

// Permanents
BASIC: B 'asic';
LEGENDARY: L 'egendary';

ARTIFACT: A 'rtifact' ;
CREATURE: C 'reature' ;
ENCHANTMENT: E 'nchantment' ;
PLANESWALKER: P 'laneswalker' ;
LAND: L 'and' ;
TOKEN: T 'oken' ;

ARTIFACTS: A 'rtifacts' ;
CREATURES: C 'reatures' ;
ENCHANTMENTS: E 'nchantments' ;
PLANESWALKERS: P 'laneswalkers' ;
LANDS: L 'ands' ;
TOKENS: T 'okens' ;

NONARTIFACT: N 'onartifact';
NONCREATURE: N 'oncreature';
NONENCHANTMENT: N 'onenchantment';
NONLAND: N 'onland';
NONPLANESWALKER: N 'onplaneswalker';
NONTOKEN: N 'ontoken';

NONBASIC: N 'onbasic';
NONLEGENDARY: N 'onlegendary';

nonPermanentType
	: NONARTIFACT
	| NONCREATURE
    | NONENCHANTMENT
    | NONLAND
    | NONPLANESWALKER
    | NONTOKEN
	| NONBASIC
	| NONLEGENDARY
    ;
permanentType
    : ARTIFACT
    | CREATURE
    | ENCHANTMENT
    | LAND
    | PLANESWALKER
    | TOKEN
	| BASIC
	| LEGENDARY
    ;
permanentTypes
	: ARTIFACTS
    | CREATURES
    | ENCHANTMENTS
    | LANDS
    | PLANESWALKERS
    | TOKENS
    ;

//// SUBTYPES
subType: landType | creatureType | enchantmentType | tokenType;
subTypes: landTypes | creatureTypes | enchantmentTypes | tokenTypes;

//Lands
landType
	: 'Plains'
	| 'Island'
	| 'Swamp'
	| 'Mountain'
	| 'Forest'
	;
landTypes
	: 'Plains'
	| 'Islands'
	| 'Swamps'
	| 'Mountains'
	| 'Forests'
	;

// Creatures
creatureType
    : 'Artificer'
    | 'Cleric'
    | 'Human'
    | 'Soldier'
	| 'Construct'
    ;
creatureTypes
	: 'Artificers'
    | 'Clerics'
    | 'Humans'
    | 'Soldiers'
	| 'Constructs'
    ;

// Enchantment
enchantmentTypes: enchantmentType 's';
enchantmentType
    : 'Aura'
    | 'Saga'
    ;

tokenTypes: tokenType 's' ;
tokenType
    : 'Powerstone'
    ;

// COUNTERS
counterTypes: counterType 's' ;
counterType
    : '+1/+1 counter'
    ;
