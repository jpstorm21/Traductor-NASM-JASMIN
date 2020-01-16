#include <stdio.h>
#include <stdlib.h>
#include <string.h>


int topePila = 0;			// Indicador de datos agregados al stack, empieza en 0
char pilaInfo[1000][32];	// Pila Abstracta que contendrá las variables que se agregen al assembler
char pilaType[1000];		// Pila que acompaña a la de arriba, indica si es un string o un integer

int topeString = 0;		// Cantidad de String que existen en el fichero
char nomString[1000][32];	// Lista que almacena los nombres de variable de los strings del programa
char valString[1000][128];	// Almacena los strings
char retenedorS[128];		//contenedor de asignacion string.
int  retenedorI;			//contenedor de asignacion integer.

void RetenedorI(int i){
	retenedorI = i;
}
void RetenedorS(char s[]){
	strcpy(retenedorS,s);
}

int getRetenedorI(){
	return retenedorI;
}


void error(char msg[]) {
	fprintf(stderr, msg);
	fprintf(stderr, "\n");
	exit(1);
}
 
void pushPilaSymbol(char nomID[], char type){
	strcpy(pilaInfo[topePila], nomID);
	pilaType[topePila] = type;
	topePila++;
}

int buscarSymbol(char text[]){
	int i=0;
	while(i<topePila){
		int x = strncmp(text,pilaInfo[i],32);
		if (x == 0){
			return i;
		}
		i++;
	}
	return -1;
}

char buscarTipo(int pos){
	return pilaType[pos];
}

void addStringtoSymbol(char nomID[]){
	strcpy(nomString[topeString], nomID);
	topeString++;
}

void updateString(int pos){
	strcpy(valString[pos],retenedorS);
}
void addEntireString(char id[], char val[]){
	strcpy(valString[topeString], val);
	strcpy(nomString[topeString], id);
	topeString++;
}

int findString(char text[]){
	int i = 0;
	while(i<topeString){
		int x = strncmp(text,nomString[i],128);
		if (x == 0){
			return i;
		}
		i++;
	}
	return -1;
}

void printTable(){
	int i = 0;
	while(i<topeString){
		printf("\t%s: db %s,0Ah,0\n",nomString[i],valString[i]);
		i++;
	}
}
