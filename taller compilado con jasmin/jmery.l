%{
#include <stdio.h>
#include <string.h>
#include "jmery.tab.h"
#include "node.h"

struct nodeType* nodoJmeryToken(int tokenType);

int line_no = 1;
int chr_no = 0;

#define YY_USER_ACTION chr_no+=yyleng;

%}


_ [_]
DIGIT [0-9]

%%

"INICIO_JMERY" {yylval.node = nodoJmeryToken(INICIO_JMERY); return(INICIO_JMERY);}
"STRINGJMERY" 	 {yylval.node = nodoJmeryToken(STRINGJMERY); return(STRINGJMERY);}
"INTJMERY"	         {yylval.node = nodoJmeryToken(INTJMERY); return(INTJMERY);}
"{"	                                 {yylval.node = nodoJmeryToken(INICIO); return(INICIO);}
"JMERY_IF"             {yylval.node = nodoJmeryToken(INICIO_JMERY); return(JMERY_IF);}
"ELSE"                        {yylval.node = nodoJmeryToken(ELSE); return(ELSE);}
"ITERA"                 {yylval.node = nodoJmeryToken(INICIO_JMERY); return(ITERA);}
"}"	                                 {yylval.node = nodoJmeryToken(FIN); return(FIN);}
"FIN_JMERY"         {yylval.node = nodoJmeryToken(FIN_JMERY); return(FIN_JMERY);}


[a-zA-Z]([a-zA-Z0-9])*       {yylval.node = nodoJmeryToken(VARIABLE); yylval.node->string = (char*) malloc(yyleng+1); strcpy(yylval.node->string, yytext); return(VARIABLE);}
{DIGIT}*[a-zA-Z]+            fprintf(stdout, "[ERROR] %s nombre de IDENTIFICADOR de variable incorrecto en %d:%d\n", yytext, line_no, chr_no-yyleng+1);
[a-zA-Z]+([@$?_])+           fprintf(stdout, "[ERROR] %s nombre de IDENTIFICADOR de variable incorrecto\n", yytext);
\n                           {line_no++; chr_no = 0;}
"="                          {yylval.node = nodoJmeryToken(ASIGNACION); return(ASIGNACION);}
","                          {yylval.node = nodoJmeryToken(COMA); return(COMA);}
{DIGIT}+                     {yylval.node = nodoJmeryToken(NUMEROS); yylval.node->valueValid = VALUE_I_VALID; yylval.node->iValue = atoi(yytext); return(NUMEROS);}
"=="                         {yylval.node = nodoJmeryToken(DOBLEIGUAL); yylval.node->op = OP_EQ; return(DOBLEIGUAL);}
"!="                         {yylval.node = nodoJmeryToken(DESIGUAL); yylval.node->op = OP_NE; return(DESIGUAL);}
">="                         {yylval.node = nodoJmeryToken(MAYORIGUAL); yylval.node->op = OP_GE; return(MAYORIGUAL);}
">"                          {yylval.node = nodoJmeryToken(MAYOR); yylval.node->op = OP_GT; return(MAYOR);}
"<="                         {yylval.node = nodoJmeryToken(MENORIGUAL); yylval.node->op = OP_LE; return(MENORIGUAL);}
"["                          {yylval.node = nodoJmeryToken(CORCHETEI); return(CORCHETEI);}
"<<"                         {yylval.node = nodoJmeryToken(PARENTESISI); return(PARENTESISI);}
"<"                          {yylval.node = nodoJmeryToken(MENOR); yylval.node->op = OP_LT; return(MENOR);}
"-"                          {yylval.node = nodoJmeryToken(MENOS); yylval.node->op = OPERACION_RESTA; return(MENOS);}
"+"                          {yylval.node = nodoJmeryToken(SUMA); yylval.node->op = OPERACION_SUMA; return(SUMA);}
"]"                          {yylval.node = nodoJmeryToken(CORCHETED); return(CORCHETED);}
">>"                         {yylval.node = nodoJmeryToken(PARENTESISD); return(PARENTESISD);}
";"                          {yylval.node = nodoJmeryToken(PUNTOCOMA); return(PUNTOCOMA);}
"/"                          {yylval.node = nodoJmeryToken(DIVISION); yylval.node->op = OPERACION_DIVISION; return(DIVISION);}
"*"                          {yylval.node = nodoJmeryToken(MULTIPLICACION); yylval.node->op = OPERACION_MULTIPLICACION; return(MULTIPLICACION);}

({DIGIT}+|{DIGIT}+"."{DIGIT}+)E(''|[+-])(''|{DIGIT}+|{DIGIT}+"."{DIGIT}+)     return(NUMBER);
{DIGIT}+"."{DIGIT}+          {yylval.node = nodoJmeryToken(NUMBER); yylval.node->valueValid = VALUE_R_VALID; yylval.node->rValue=atof(yytext); return(NUMBER);}

"//".*\n                     {fprintf (stdout, "%s", yytext); chr_no = 0; line_no++;}
\'([^\'\n]|\\\'|'')*\'       {yylval.node = nodoJmeryToken(CHARACTER_STRING); yylval.node->string = yytext; return(CHARACTER_STRING);}
\"([^\"\n]|\\\"|'')*\"       {yylval.node = nodoJmeryToken(CHARACTER_STRING); yylval.node->string = yytext; return(CHARACTER_STRING);}

\'([^\']|\\\'|\n)*\' {
fprintf(stdout, "linea %d:%d Cross-Line String %s\n", line_no, chr_no-yyleng+1, yytext);
register int registro;
for (registro = 0; registro < strlen(yytext); registro++)
       if (registro == '\n') line_no++;
}
\"([^\"]|\\\"|\n)*\" {
fprintf(stdout, "linea %d:%d Cross-Line String %s\n", line_no, chr_no, yytext);
register int registro;
for (registro = 0; registro < strlen(yytext); registro++)
       if (registro == '\n') line_no++;
}
\"([^\"\n])*$ fprintf(stdout, "[ERROR] String %s detectado en %d:%d\n", yytext, line_no, chr_no-yyleng+1);
\'([^\'\n])*$ fprintf(stdout, "[ERROR] String %s detectado en %d:%d\n", yytext, line_no, chr_no-yyleng+1);
"(*"   { register int registro;
     while ((registro = input()))
     {
      if (registro == '*')
      {
       if ((registro = input()) == ')')
        break;
       else
        unput (registro);
      }
      else if (registro == '\n')
       line_no++;
      else if (registro == 0)
        fprintf (stdout, "[ERROR] Unexpected EOF inside comment on line %d\n",line_no);
     }
    }

[ \t\f]    ;

\r         ;
.    {fprintf(stdout,"[ERROR] Analizador lexico en linea %d : %s\n",line_no,yytext);}
<<EOF>>    return END_OF_FILE;

%%
struct nodeType* nodoJmeryToken(int tokenType) {
  struct nodeType *node = newNode(NODO_TOKEN);
  node->tokenType = tokenType;
  return node;
}

yywrap() {
  fclose(yyin);
  exit(1);
}

