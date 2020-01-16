#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include "node.h"

struct nodeType* newNode(int type) {
  struct nodeType *node = (struct nodeType*)malloc(sizeof(struct nodeType));
  node->nodeType = type;
  node->valueValid = VALUE_INVALID;
  node->string = NULL;
  node->parent = NULL;
  node->child = NULL;
  node->lsibling = node;
  node->rsibling = node;
  node->defined = 0;

  return node;
}

void agregarSiguiente(struct nodeType *node, struct nodeType *child) {
  child->parent = node;

  if(node->child == NULL) {
    node->child = child;
  }
  else {
    child->lsibling = node->child->lsibling;
    child->rsibling = node->child;
    node->child->lsibling->rsibling = child;
    node->child->lsibling = child;
  }
}

void borrarNodo(struct nodeType *node) {
  if(node->string != NULL)
    free(node->string);
  free(node);
}




