%{
#include <stdio.h>
int yylex();
int yyerror();
%}
%start start
%token INTEGER STRING FLOAT LOGIC TYPE VARIABLE DOT LP RP SMALLERTHAN BIGGERTHAN BIGGEREQUAL SMALLEREQUAL EQUAL ASSIGN WHILE FOR IF ELSE THEN
%token END START NOT RETURN CONST AND OR COMMA COMMENT TIMESTAMP CONNECT DISCONNECT SWITCHES SENDDATATOSENSOR READDATAFROMSENSOR GETURL
%token SENDURL FUNC EOL GETTEMPERATURE GETHUMIDITY GETAIRPRESSURE GETLIGHT 
%token GETSOUNDLEVEL GETAIRQUALITY OPEN CLOSE CHOSENSWITCH FROM TO BY LINECOUNT PLUS MINUS DIVIDE MULT REMAINDER NOTEQUAL
%%
start:		program;
program:	stmts| empty;
stmts: 		stmts stmt
     	   | stmt ;
stmt:     if
        | nonif	; 
nonif: COMMENT | loopstmt |returnstmt | funccal | asgnmnt | declarations;
declarations: constdec | vardec | funcdec;
constdec:CONST TYPE asgnmnt;
vardec:TYPE VARIABLE EOL| TYPE asgnmnt;
funcdec: FUNC VARIABLE LP funcargs RP THEN funcstmt END;
funcargs: TYPE VARIABLE | funcargs COMMA TYPE VARIABLE | empty;
funcstmt: stmts | returnstmt  EOL;
asgnmnt: VARIABLE ASSIGN expression EOL;
if:  matched | unmatched;
unmatched: IF LP logicexp RP THEN  blockstmt| IF LP logicexp RP THEN matched ELSE unmatched END;
matched: IF LP logicexp RP THEN matched ELSE matched| blockstmt  ;
loopstmt: for 
        | while;
while: WHILE LP logicexp RP blockstmt;            
for:  FOR LP VARIABLE FROM term TO term BY term RP blockstmt; 
blockstmt:	START stmts END;	
returnstmt:	RETURN expression EOL;	
expression: nonlogicexp  | logicexp;
nonlogicexp: mathexp |funccal;
logicexp: logicexp logicop nonlogicexp | nonlogicexp logicop nonlogicexp;
logicop: EQUAL|NOTEQUAL|BIGGEREQUAL|SMALLEREQUAL|SMALLERTHAN|BIGGERTHAN|AND|OR;
funccal: readDataFromSensor|timestamp|connectionOfInternet|getURL|sendURL|getTemperature|getHumidity|getAirPressure|getLight|getSoundLevel|getAirQuality|openSwitch|closeSwitch|otherFunctionCalls;
readDataFromSensor: READDATAFROMSENSOR LP VARIABLE RP;   
timestamp:	TIMESTAMP LP RP;   
connectionOfInternet: CONNECT LP STRING RP | DISCONNECT LP RP;
getURL: GETURL LP VARIABLE RP;
sendURL:SENDURL LP VARIABLE COMMA mathexp RP;
getTemperature: GETTEMPERATURE LP RP; 
getHumidity:    GETHUMIDITY LP RP;
getAirPressure: GETAIRPRESSURE LP RP;
getLight:   	GETLIGHT LP RP;
getSoundLevel:  GETSOUNDLEVEL LP RP;
getAirQuality:  GETAIRQUALITY LP RP;
openSwitch:     OPEN LP sw RP;
closeSwitch:    CLOSE LP sw RP;
otherFunctionCalls: VARIABLE LP param RP;
param:			expression
            |	expression COMMA helper
			|	empty;
helper: 	    expression COMMA helper
			|   expression;
sw:	        CHOSENSWITCH;
mathexp:        term PLUS  mathexp 
            |   term  MINUS  mathexp
            |   term;
term: 		    havepar DIVIDE term
       		|   havepar MULT  term
       		|   havepar REMAINDER term
|   havepar;
havepar:        LP mathexp RP |factor;
factor: 	constant | VARIABLE  ;
constant:   STRING | INTEGER|FLOAT|LOGIC;
empty: ;
%%
#include "lex.yy.c"
int lineno=0;
int yyerror( char *s ) { 
							printf("Syntax error on line %d !!!", lineno);
						}
int main() {
	if(yyparse()==0)
		printf("Input program is valid.\n");
    return 0;
	  
}
