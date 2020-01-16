%{
  #include "y.tab.h"
  #include <stdlib.h>
  #include <string.h>
  void yyerror(char *);
  extern int namespace;
  extern char aux_id[];
  extern char aux_nombre[]; 
%}

%%

"INICIO_jmery"  {return INICIO_jmery; } /*inicio del programa*/
"FIN_jmery"    {return FIN_jmery; }  /*fin del programa*/

"intJmery"  {return intJmery;} /*variables enteras*/

"itera" {return itera;} /*ciclo while del lenguaje*/
"imprimir" {return imprimir;} /*imprimir por pantalla*/
"jmeryIF"  {return jmeryIF; } /*condicional "if"*/


[0-9]+					{	yylval = atoi(yytext);
							
						//printf("\tSe encontro un numero: %s\n",yytext);
						return digito;
						}
\"[a-zA-Z0-9_%]+\" 		{ 	yylval = yytext[1];
							strncpy(aux_nombre, yytext, 127);
						//printf("\tSe encontro un texto: %s\n",yytext);
						return letras;
						}
[A-Za-z][A-Za-z0-9]*	{ 	yylval = yytext[0];
							strncpy(aux_id, yytext, 31);
						//printf("\tSe encontro un texto: %s\n",yytext);
						return identificador;
						}
[-+*/,(){}=;]				{return *yytext;
						}

';'					{//printf("\tFin de Sentencia.\n"); 
						return ';';
						}
						

[ \t]					;
'\n'          { return ';'; }   /* Fin de la sentencia. el ; termina la linea de codigo*/

.					 // yyerror("Ingreso un caracter invalido"); 

%%

int yywrap(void) {
    return 1;
	}