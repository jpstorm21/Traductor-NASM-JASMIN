%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  #include "node.h"
  #include "symbolTable.h"
  #include "assembler.h"

  struct nodeType* newOpNode(int op);
  extern struct nodeType* ASTRoot;
  void yyerror(const char *str) {
    extern char *yytext;
    extern int line_no, chr_no;
    fprintf(stdout, "[ERROR] %s en la linea %d:%d symbol '%s'\n", str, line_no, chr_no, yytext);
    exit(0);
  }
%}
%union {
  struct nodeType *node;
}

%token <node>  ELSE FIN VARIABLE JMERY_IF INICIO ITERA ASIGNACION  COMA INICIO_JMERY FIN_JMERY DOBLEIGUAL MAYORIGUAL MAYOR CORCHETEI MENORIGUAL PARENTESISI MENOR MENOS SUMA CORCHETED PARENTESISD PUNTOCOMA DIVISION MULTIPLICACION DESIGUAL INTJMERY STRINGJMERY NUMEROS NUMBER CHARACTER_STRING END_OF_FILE
%type <node> principio programa lista_identificadores bloque declaracion_compuesta lista_declaraciones declaracion constante tipo lista_variables declaracion_variable tipo_estandar declaraciones_opcionales declaracion_else expresion declaracion_procedimiento variable cola termino expresion_simple factor reubicar asignacion_variable lista_expresiones negativo

%%
//--------------------------------
principio: programa {
  fprintf(stdout, "\n");
  ASTRoot = $1; YYACCEPT;
};
//--------------------------------
programa : INICIO_JMERY bloque declaracion_compuesta FIN_JMERY {
  $$ = newNode(NODO_PROGRAMA); 
  agregarSiguiente($$, $2);
  agregarSiguiente($$, $3);
  borrarNodo($1); borrarNodo($4);
}| error END_OF_FILE {
  fprintf(stdout, "[ERROR]\n");
  yyerrok;
}; 
//--------------------------------
lista_identificadores : VARIABLE {
  $$ = newNode(NODE_LIST);
  agregarSiguiente($$, $1);
}| lista_identificadores COMA VARIABLE {
  $$ = $1;
  agregarSiguiente($$, $3);
  borrarNodo($2);
};
//--------------------------------
negativo: MENOS NUMEROS {
  $$ = newNode(NODE_INT); $$->iValue = -($2->iValue);
  borrarNodo($1);
} | MENOS NUMBER {
  $$ = newNode(NODE_REAL); $$->rValue = -($2->rValue);
  borrarNodo($1);
};
//--------------------------------
tipo_estandar: INTJMERY {
  $$ = newNode(NODO_TIPO_ENTERO);
}| STRINGJMERY {
  $$ = newNode(NODO_TIPO_CHAR);
};
//--------------------------------
tipo : tipo_estandar {
  $$ = $1;
} | VARIABLE {
   $$ = $1;
};
//--------------------------------
asignacion_variable : tipo lista_identificadores {
  $$ = newNode(NODO_DECLARACION_VAR);
  agregarSiguiente($$, $2); agregarSiguiente($$, $1);
};
//--------------------------------
lista_variables : asignacion_variable {
  $$ = newNode(NODE_LIST);
  agregarSiguiente($$, $1);
}| lista_variables asignacion_variable {
  $$ = $1;
  agregarSiguiente($$, $2);
};
//--------------------------------
bloque : declaracion_variable {
  $$ = newNode(NODE_BLOCK);
  agregarSiguiente($$, $1);
};
//--------------------------------
declaracion_variable : declaracion_variable lista_variables PUNTOCOMA {
  $$ = $1;
  agregarSiguiente($$, $2);
}| {
  $$ = newNode(NODE_LIST);
}| error PUNTOCOMA {
  fprintf(stdout, "[ERROR] declaracion de variable incorrecta\n");
  yyerrok;
};
//--------------------------------
declaracion_compuesta : INICIO declaraciones_opcionales FIN {
  $$ = $2;;
  borrarNodo($1); borrarNodo($3);
}| error FIN {
  fprintf(stdout, "[ERROR] declaracion compuesta incorrecta.\n");
  yyerrok;
};
//--------------------------------
declaraciones_opcionales : lista_declaraciones {
  $$ = $1;
};
//--------------------------------
lista_declaraciones : declaracion {
  $$ = newNode(NODE_LIST);
  agregarSiguiente($$, $1);
}| lista_declaraciones declaracion {
  $$ = $1;
  agregarSiguiente($$, $2);
};
//--------------------------------
declaracion_else : ELSE declaracion {
  $$ = newNode(NODE_ELSE);
  agregarSiguiente($$, $2); borrarNodo($1);
}| {
  $$ = newNode(NODE_EMPTY);
};
//--------------------------------
declaracion : variable ASIGNACION expresion PUNTOCOMA{
  $$ = newNode(NODE_ASSIGN_STMT);
  agregarSiguiente($$, $1);
  agregarSiguiente($$, $3);
  $1->nodeType = NODO_REF_SIMBOL;
  borrarNodo($2);
}| declaracion_procedimiento {
  $$ = $1;
}| declaracion_compuesta {
  $$ = $1;
}| JMERY_IF expresion declaracion declaracion_else {
  $$ = newNode(NODE_IF);
  agregarSiguiente($$, $2); agregarSiguiente($$, $3); agregarSiguiente($$, $4);
  borrarNodo($1);
}| ITERA expresion declaracion {
  $$ = newNode(NODE_WHILE);
  agregarSiguiente($$, $2); agregarSiguiente($$, $3);
  borrarNodo($1);
}| {
  $$ = newNode(NODE_EMPTY);
};
//--------------------------------
variable : VARIABLE cola {
  $$ = newNode(NODE_VAR);
  $$->string = $1->string;
  agregarSiguiente($$, $1); agregarSiguiente($$, $2);
 } | VARIABLE {
   $$ = newNode(NODE_VAR);
   $$->string = $1->string;
   agregarSiguiente($$, $1);
};
//--------------------------------
cola : CORCHETEI expresion CORCHETED cola {
  $$ = $4;
  agregarSiguiente($$, $2);
  borrarNodo($1); borrarNodo($3);
}| CORCHETEI expresion CORCHETED {
  $$ = newNode(NODE_LIST);
  agregarSiguiente($$, $2);
  borrarNodo($1); borrarNodo($3);
};
//--------------------------------
declaracion_procedimiento : VARIABLE {
  $$ = $1;
  $$->nodeType = NODO_VAR_O_PROCEDIMIENTO;
}| VARIABLE PARENTESISI lista_expresiones PARENTESISD {
  $$ = newNode(NODE_PROC_STMT);
  agregarSiguiente($$, $1); agregarSiguiente($$, $3);
  borrarNodo($2); borrarNodo($4);
};
//--------------------------------
lista_expresiones : expresion {
  $$ = newNode(NODE_LIST);
  agregarSiguiente($$, $1);
}| lista_expresiones COMA expresion {
  $$ = $1;
  agregarSiguiente($$, $3);
  borrarNodo($2);
};
//--------------------------------
expresion : expresion_simple {
  $$ = $1;
}| expresion_simple reubicar expresion_simple {
  $$ = newOpNode($2->op);
  agregarSiguiente($$, $1); agregarSiguiente($$, $3);
};
//--------------------------------
expresion_simple : termino {
  $$ = $1;
}| expresion_simple SUMA termino {
  $$ = newOpNode(OPERACION_SUMA);
  agregarSiguiente($$, $1); agregarSiguiente($$, $3);
  borrarNodo($2);
}| expresion_simple MENOS termino {
  $$ = newOpNode(OPERACION_RESTA);
  agregarSiguiente($$, $1); agregarSiguiente($$, $3);
  borrarNodo($2);
}| negativo {
  $$ = $1;
};
//--------------------------------
termino : factor {
  $$ = $1;
}| termino MULTIPLICACION factor {
  $$ = newOpNode(OPERACION_MULTIPLICACION);
  agregarSiguiente($$, $1);
  agregarSiguiente($$, $3);
  borrarNodo($2); 
} | termino DIVISION factor {
  $$ = newOpNode(OPERACION_DIVISION);
  agregarSiguiente($$, $1);
  agregarSiguiente($$, $3);
  borrarNodo($2);
};
//--------------------------------
constante : NUMBER {
  $$ = $1;
  $$->nodeType = NODE_REAL;
}| NUMEROS {
  $$ = $1;
  $$->nodeType = NODE_INT;
}| CHARACTER_STRING {
  $$ = newNode(NODE_CHAR);
  char *str = malloc(sizeof(char)*50);
  strcpy(str, $1->string);
  $$->string = str;
};
//--------------------------------
factor : VARIABLE {
  $$ = $1;
  $$->nodeType = NODO_VAR_O_PROCEDIMIENTO;
 }| VARIABLE cola {
  $$ = newNode(NODO_REF_SIMBOL);
  $$->string = $1->string;
  agregarSiguiente($$, $1); agregarSiguiente($$, $2);
 } | VARIABLE PARENTESISI lista_expresiones PARENTESISD {
  $$ = newNode(NODE_PROC_STMT);
  agregarSiguiente($$, $1); agregarSiguiente($$, $3);
  borrarNodo($2); borrarNodo($4);
}| constante {
  $$ = $1;
}| PARENTESISI expresion PARENTESISD {
  $$ = $2;
  borrarNodo($1); borrarNodo($3);
}| error PARENTESISD {
  fprintf(stdout, "[ERROR] factor equivocado.\n");
  yyerrok;
};
//--------------------------------
reubicar : MENOR { $$->op = OP_LT; }
| MAYOR { $$->op = OP_GT; }
| DOBLEIGUAL { $$->op = OP_EQ; }
| MENORIGUAL { $$->op = OP_LE; }
| MAYORIGUAL { $$->op = OP_GE; }
| DESIGUAL { $$->op = OP_NE; }
;
//--------------------------------
%%

struct nodeType *ASTRoot;

struct nodeType* newOpNode(int op) {
    struct nodeType *node = newNode(NODO_OPERACION);
    node->op = op;

    return node;
}

int main(int argc, char** argv) {  
  int res;
  if (argc != 3) { fprintf(stdout, "[ERROR] por favor ingrese [INPUT].jmery y [OUTPUT].j!\n"); exit(1); }
  if (NULL == freopen(argv[1], "r", stdin)) { fprintf(stdout, "[ERROR] No se puede abrir el archivo. %s\n", argv[1]); exit(1); }
  yyparse();
  semanticCheck(ASTRoot);
  printf("Programa compilado y listo para ejecutar! :D\n"); 
  char *outFile = (char *)malloc(sizeof(char)*(strlen(argv[2])+3));
  strcpy(outFile, argv[2]); strcat(outFile, ".j");
  if (NULL == freopen(outFile, "w", stdout)) { fprintf(stderr, "[ERROR] No se puede escirbir en el archivo. %s\n", outFile); exit(1);}
  assembler(ASTRoot, argv[2]);   
  return 0;
}
