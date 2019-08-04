%{
#include <stdio.h>
#include "parser.tab.h"
int yylval;
double yyldval;
%}

%option noyywrap
%option yylineno

WHITESPACES        [ \t\r\v]+
NEWLINE            [\n]
DIGIT              [0-9]
CHAR               [A-Za-z_]
KEYWORD            (int|double|void|def|return|if|else|extern|for|in|to|by)
REL_OP             (==|!=|<|<=|>|>=)
ARITH_OP           [+*/%-]
ASSIGN_OP          =
PARENTHESES        [()]
CURLY_BRACE        [{}]
COLON              :
LAMBDA              =>
COMMENT             #
COMMA               ,

%%

{COMMENT}.* {

}
{COMMA}+ {
    return COMMA;
}
{LAMBDA} {
    return LAMBDA;
}
{DIGIT}+ {
    yylval = atoi(yytext);
	return INT_DATATYPE;
}
{DIGIT}+"."{DIGIT}+ {
    yyldval = atoi(yytext);
	return DOUBLE_DATATYPE;
}
{KEYWORD} {
	if(strcmp(yytext, "if") == 0) {
        return IF_KEYWORD;
    }
    if(strcmp(yytext, "def") == 0) {
        return DEF_KEYWORD;
    }
    if(strcmp(yytext, "return") == 0) {
        return RETURN_KEYWORD;
    }
    if(strcmp(yytext, "else") == 0) {
        return ELSE_KEYWORD;
    }
    if(strcmp(yytext, "extern") == 0) {
        return EXTERN_KEYWORD;
    }
    if(strcmp(yytext, "for") == 0) {
        return FOR_KEYWORD;
    }
    if(strcmp(yytext, "in") == 0) {
        return IN_KEYWORD;
    }
    if(strcmp(yytext, "to") == 0) {
        return TO_KEYWORD;
    }
    if(strcmp(yytext, "by") == 0) {
        return BY_KEYWORD;
    }
    if(strcmp(yytext, "int") == 0) {
        return INT_KEYWORD;
    }
    if(strcmp(yytext, "double") == 0) {
        return DOUBLE_KEYWORD;
    }
    if(strcmp(yytext, "void") == 0) {
        return VOID_KEYWORD;
    }
}
{CHAR}+{DIGIT}* {
	return ID;
}
{ARITH_OP} {
    if(strcmp(yytext, "+") == 0) {
        return ADD;
    }
    if(strcmp(yytext, "-") == 0) {
        return SUB;
    }
    if(strcmp(yytext, "*") == 0) {
        return MUL;
    }
    if(strcmp(yytext, "/") == 0) {
        return DIV;
    }
    if(strcmp(yytext, "%") == 0) {
        return MOD;
    }
}
{REL_OP} {
    if(strcmp(yytext, "==") == 0) {
        return EQUAL;
    }
    if(strcmp(yytext, "!=") == 0) {
        return NOT_EQUAL;
    }
    if(strcmp(yytext, ">") == 0) {
        return GREATER;
    }
    if(strcmp(yytext, ">=") == 0) {
        return GREATER_EQUAL;
    }
    if(strcmp(yytext, "<") == 0) {
        return LESSER;
    }
    if(strcmp(yytext, "<=") == 0) {
        return LESSER_EQUAL;
    }
}
{PARENTHESES} {
    if(strcmp(yytext, "(") == 0) {
        return OPEN_PARENTHESES;
    }
    if(strcmp(yytext, ")") == 0) {
        return CLOSE_PARENTHESES;
    }
}
{CURLY_BRACE} {
    if(strcmp(yytext, "{") == 0) {
        return OPEN_CURLY_BRACES;
    }
    if(strcmp(yytext, "}") == 0) {
        return CLOSE_CURLY_BRACES;
    }
}
{NEWLINE} {
    return EOL;
}
{ASSIGN_OP} {
    return ASSIGN;
}
{COLON} {
    return COLON;
}
{WHITESPACES} {

}
. {
    printf("%s is not Valid code.\n", yytext);
}

%%
