%{
#include <stdio.h>
int yylex();
void yyerror(char *s, ...);
extern int yylineno;
extern int yylex();
extern char *yytext;

%}

/*declare tokens*/

%token OPEN_PARENTHESES CLOSE_PARENTHESES
%token OPEN_CURLY_BRACES CLOSE_CURLY_BRACES
%token COMMA COLON
%token LAMBDA
%token ADD SUB MUL DIV MOD
%token ASSIGN
%token EQUAL NOT_EQUAL GREATER GREATER_EQUAL LESSER LESSER_EQUAL
%token IF_KEYWORD ELSE_KEYWORD FOR_KEYWORD IN_KEYWORD
%token TO_KEYWORD BY_KEYWORD 
%token INT_KEYWORD DOUBLE_KEYWORD VOID_KEYWORD
%token DEF_KEYWORD RETURN_KEYWORD EXTERN_KEYWORD
%token INT_DATATYPE DOUBLE_DATATYPE
%token ID
%token EOL

%left EQUAL 
%left NOT_EQUAL GREATER GREATER_EQUAL LESSER LESSER_EQUAL
%left ADD SUB 
%left MUL DIV MOD
%%

program: stmts {printf("Program runned successfully.\n");}
;

stmts: stmt
 | stmt stmts 
;

stmt: var_decl
 | func_decl
 | extern_decl
 | expr
 | IF_KEYWORD OPEN_PARENTHESES expr CLOSE_PARENTHESES block
 | IF_KEYWORD OPEN_PARENTHESES expr CLOSE_PARENTHESES block ELSE_KEYWORD block
 | FOR_KEYWORD OPEN_PARENTHESES ID COLON INT_KEYWORD IN_KEYWORD expr TO_KEYWORD expr CLOSE_PARENTHESES block
 | FOR_KEYWORD OPEN_PARENTHESES ID COLON INT_KEYWORD IN_KEYWORD expr TO_KEYWORD expr BY_KEYWORD expr CLOSE_PARENTHESES block  
 | RETURN_KEYWORD expr
; 

block: OPEN_CURLY_BRACES stmts CLOSE_CURLY_BRACES
 | OPEN_CURLY_BRACES CLOSE_CURLY_BRACES 
;

var_decl: ID COLON INT_KEYWORD
 | ID COLON DOUBLE_KEYWORD 
 | ID COLON INT_KEYWORD ASSIGN expr
 | ID COLON DOUBLE_KEYWORD ASSIGN expr
;

extern_decl: EXTERN_KEYWORD ID OPEN_PARENTHESES func_decl_args CLOSE_PARENTHESES COLON INT_KEYWORD
 | EXTERN_KEYWORD ID OPEN_PARENTHESES func_decl_args CLOSE_PARENTHESES COLON DOUBLE_KEYWORD
 | EXTERN_KEYWORD ID OPEN_PARENTHESES func_decl_args CLOSE_PARENTHESES COLON VOID_KEYWORD
;

func_decl: DEF_KEYWORD ID OPEN_PARENTHESES func_decl_args CLOSE_PARENTHESES COLON INT_KEYWORD LAMBDA block
 | DEF_KEYWORD ID OPEN_PARENTHESES func_decl_args CLOSE_PARENTHESES COLON DOUBLE_KEYWORD LAMBDA block
 | DEF_KEYWORD ID OPEN_PARENTHESES func_decl_args CLOSE_PARENTHESES COLON VOID_KEYWORD LAMBDA block
 | OPEN_PARENTHESES func_decl_args CLOSE_PARENTHESES COLON INT_KEYWORD LAMBDA block 
 | OPEN_PARENTHESES func_decl_args CLOSE_PARENTHESES COLON DOUBLE_KEYWORD LAMBDA block 
 | OPEN_PARENTHESES func_decl_args CLOSE_PARENTHESES COLON VOID_KEYWORD LAMBDA block
;

func_decl_args: 
 | var_decl
 | func_decl_args COMMA var_decl
;

call_args: expr
 | call_args COMMA expr
;

expr: EOL
 | ID ASSIGN expr
 | ID OPEN_PARENTHESES call_args CLOSE_PARENTHESES
 | OPEN_PARENTHESES expr CLOSE_PARENTHESES
 | OPEN_PARENTHESES call_args CLOSE_PARENTHESES
 | expr_arithmetic
;

expr_arithmetic: expr_arithmetic ADD term
 | expr_arithmetic SUB term
 | expr_arithmetic comparison term
 | term
;

term: term MOD factor
 | term MUL factor
 | term DIV factor
 | factor
;

factor: ID
 | numeric 
;

numeric: INT_DATATYPE
 | DOUBLE_DATATYPE
;

comparison: EQUAL 
 | NOT_EQUAL
 | LESSER
 | LESSER_EQUAL
 | GREATER
 | GREATER_EQUAL
;

%% 

int main(int argc, char **argv) {
    extern FILE *yyin;
    if(argc > 1) {
        yyin = fopen(argv[1], "r");
        if(yyin == 0)
            yyin = stdin;
    } else {
        yyin = stdin;
    }
    int flag = yyparse();
    fclose(yyin);
    return 0;
}

void yyerror(char *s, ...) {
    fprintf(stderr, "%d: error: ", yylineno);
    fprintf(stderr, "after %s\n", yytext-4);
}

// void yyerror(char *s) {
//     fprintf(stderr, "error: %s in line %d after:\n %s\n", s, yylineno, yytext-4);
// }