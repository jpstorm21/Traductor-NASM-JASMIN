#ifndef __NODE_H__
#define __NODE_H__

struct nodeType;

#define VALUE_INVALID   0
#define VALUE_I_VALID   1
#define VALUE_R_VALID   2

#define NODO_TOKEN          1
#define NODO_OPERACION             2
#define NODE_INT            3
#define NODE_REAL           4
#define NODO_PROGRAMA        5
#define NODO_SUBPROGRAMA        21
#define NODE_FUNCTION       22
#define NODE_PROCEDURE      23
#define NODE_BLOCK          20
#define NODO_DECLARACION_VAR       6
#define NODE_TYPE_DECL      17
#define NODO_TIPO_ENTERO       7
#define NODO_TIPO_REAL      8
#define NODO_TIPO_CHAR      14
#define NODE_TYPE_ID        15
#define NODE_TYPE_NUM       16
#define NODE_TYPE_ARRAY     18
#define NODE_ASSIGN_STMT    9
#define NODO_REF_SIMBOL        10
#define NODE_LABEL_DECL     24
#define NODE_LABEL          11
#define NODE_CHAR           12
#define NODE_CONST          13
#define NODE_RANGE          19
#define NODE_IF             25
#define NODE_ELSE           26
#define NODE_WHILE          27
#define NODE_FOR            28
#define NODE_REPEAT         29
#define NODE_WITH           30
#define NODE_GOTO           31
#define NODE_VAR            32
#define NODE_PROC_STMT      33

#define NODE_LIST           50

#define NODO_VAR_O_PROCEDIMIENTO    99
#define NODO_ERROR          100
#define NODE_EMPTY          101

#define OPERACION_SUMA  1
#define OPERACION_RESTA  2
#define OPERACION_MULTIPLICACION  3
#define OPERACION_DIVISION  4
#define OP_GT   5
#define OP_LT   6
#define OP_EQ   7
#define OP_GE   8
#define OP_LE   9

#define OP_NE   10
#define OP_NOT  11
#define OP_NO 12

#include "symbolTable.h"
struct nodeType {
  int nodeType;
  struct nodeType *parent;
  struct nodeType *child;
  struct nodeType *lsibling;
  struct nodeType *rsibling;


  int tokenType;

  int iValue;
  double rValue;
  char valueValid;

  char *string;

  char op;

  enum StdType valueType;
  struct SymTableEntry *entry;
  int defined;
};

struct nodeType* newNode(int type);
void borrarNodo(struct nodeType* node);
void agregarSiguiente(struct nodeType *node, struct nodeType *child);
#endif

