%{ 
    #include <stdio.h>
    #include "assembler.h" 
    int yylex(void);
    void yyerror(char *);
 
%} 
 
%token INICIO_jmery FIN_jmery
%token jmeryIF 
%token itera 
%token imprimir
%token intJmery
%token letras identificador digito 

%%

/*gramatica*/

inicio:				INICIO_jmery {iniciar();} block FIN_jmery {fin();}
					;
block:				'{' sentencia '}'
					;
sentencia:			instruccion sentencia
					| instruccion
					;
instruccion:		condicional	| declaracion | impresion | asignacion
					;
declaracion:		digito {Retener($1,0);} intJmery identificador {CrearNumero();} {Asignar(0);} ';'
					;
asignacion:			identificador {IdentificarID();} '=' valor {AsignarNuevoValor();} ';'
					;
valor:				operacion
					| letras
					;
exp:				term '+' exp {Suma();}
					| term '-' exp {Resta();}
					| term
					;
term:				factor '*' term {Multiplica();}
					| factor '/' term {Divide();}
					| factor
					;
operacion:			'(' exp ')' operacion
					| exp
					;
factor:				digito {empujarValor($1);}
					| identificador {empujarIdentificador();}
					;
condicional:		ciclo
					| if
					;
if:				    jmeryIF '(' identificador ')' {jmeryIfIdentificador(1);} '{' sentencia '}' {endJmeryIf();}
					| jmeryIF '(' digito ')' {jmeryIf($3,1);} '{' sentencia '}' {endJmeryIf();}
					;
ciclo:				itera '(' digito ')' {iteraa($3);} '{' sentencia '}' {endItera($3);}
					| itera '(' identificador ')' {iteraIdentificador();} '{' sentencia '}' {endIteraIdentificador();}
					;
impresion:			imprimir '(' letras ')' {Imprimir();} ';'
					| imprimir '(' letras ',' param ')' {ImprimirConParametros();} ';'
					;
param:				identificador {contarArgumentos();}
					;

%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main(void) {
    yyparse();
	addDataSection();
    return 0;
}