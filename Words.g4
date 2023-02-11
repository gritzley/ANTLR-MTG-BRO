lexer grammar Words;

import LetterFragments;

// Generic words that can appear at the beginning or in the middle of a sentence so we need to match them in upper and lowercase.
ALL: A 'll';
ANOTHER: A 'nother';
BLACK: B 'lack';
BLUE: B 'lue';
CREATE: C 'reate';
CHOOSE: C 'hoose';
DESTROY: D 'estroy';
DRAW: D 'raw';
ENCHANTED: E 'nchanted';
EXILE: E 'xile';
GREEN: G 'reen';
IF: I 'f';
LOOK: L 'ook';
MILL: M 'ill';
PLAYER: P 'layer';
PLAYERS: P 'layers';
PUT: P 'ut';
RED: R 'ed';
RETURN: R 'eturn';
REVEAL: R 'eveal';
SCRY: S 'cry';
SEARCH: S 'earch';
TARGET: T 'arget';
YOUR: YOU 'r';
YOU: Y 'ou';
WHITE: W 'hite';

// Zone
ZONE
    : 'hand'
    | 'library'
    | 'graveyard'
    ;
ZONES 
	: 'hands'
	| 'libraries'
	| 'graveyards'
	;
PSEUDOZONE
    : 'among the cards milled this way'
	| 'among those cards'
	| 'among them'
    ;

// -------------------
// The following collections of things don't have implicit rules so they don't need to have seperate tokens.

// Some names of things
NONCOLOR: N 'on' COLORNAME ;
COLORNAME
    : W 'hite' 
    | B 'lue' 
    | B 'lack' 
    | R 'ed' 
    | G 'reen' 
    | C 'olorless'
    ;
// Keywords
KEYWORD
	: D 'ouble strike'
    | F 'lash'
    | F 'lying'
	| V 'igilance'
	| H 'exproof'
	| I 'ndestructible'
	| U 'nearth'
	| F 'irst strike'
    ;

NUMBER
    : O 'ne'
    | T 'wo'
    | T 'hree'
    | F 'our'
    | F 'ive'
    | S 'ix'
    | S 'even'
    | E 'ight'
    | N 'ine'
    | T 'en'
    ;

// Mana Pips
PIP
    : '{' [WUBRGC] '}'
    | '{' [WUBRG] '/' [WUBRG] '}'
    | '{' INT '}'
    | '{2/' [WUBRG] '}'
    | '{' [WUBRG] '/' P '}'
    | '{' X '}'
	| '{' T '}'
    ;

// Matching "a" and "an" because we don't care about the distinction
AN: ('a'|'an') ;

// special characters
DASH: '—' ;
BULLETPOINT: '•';

// References to self should be written like this
SELF: '~' ;

// general stuff
INT: [0-9]+ ;
ID: [a-zA-Z’']+ ;
WS: [ \t] -> skip ;
NL: [\r\n]+ -> skip ;
