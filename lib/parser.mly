%{
open Printf
%}

%token <string> IDENTIFIER
%token <string> BYTE
%token <string> STRING
%token AND OR NOT
%token INHERIT
%token OPEN_BRACE CLOSE_BRACE
%token OPEN_PAREN CLOSE_PAREN
%token DOLLAR CONDITION META RULE EOF EQUAL COLON STRINGS COMMA

%start ruleset
%type <unit> ruleset

%%

ruleset: list(rule) EOF { printf "Reduced a ruleset!\n"; () }

assignment_value: OPEN_BRACE BYTE+ CLOSE_BRACE  { printf "Byte list assignment value!\n" }
        | STRING { printf "String assignment value\n" }
        | IDENTIFIER { printf "Identifier assignment value\n" }
assignment: DOLLAR IDENTIFIER EQUAL assignment_value { printf "Assignment\n" }

logical: logical OR and_logical_value { printf "Or logical value\n" } 
        | and_logical_value { }
and_logical_value: and_logical_value AND not_logical_value { printf "And logical value\n" }
        | not_logical_value {}
not_logical_value: NOT OPEN_PAREN logical CLOSE_PAREN { printf "Not logical value\n" }
        | assignment_value {}

meta:     META COLON assignment+ { printf "Meta!\n" }
strings:  STRINGS COLON assignment+ { printf "Strings!\n" }
condition:  CONDITION COLON logical { printf "Condition!\n" }
inhrt: INHERIT separated_nonempty_list(COMMA, IDENTIFIER) { printf "Inheritance list.\n" }
rule:     RULE IDENTIFIER inhrt? OPEN_BRACE meta? strings? condition CLOSE_BRACE { printf "Rule!\n" }
%%