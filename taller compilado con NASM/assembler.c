#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symbolTable.h"

extern int topePila;
extern int topeString;

int contador = 1;
char aux_nombre[128];
char aux_id[32];
char auxImprimir [128];

int asignarVariable = 0;
char nomID[32];

int posIDFOR[20];
int extraPushAmount[20];

int nivelAnidado = -1;
int contadorJmeryIf = 0;
int contadorItera = 0;

int cantArg =0;

void iniciar(){
	aux_nombre[127] = '\0';
	nomID[31] = '\0';
	aux_id[31] = '\0';
	printf("global _main\n");
	printf("extern _printf\n\n");
	printf("section .text\n");
	printf("_main:\n");
}


void CrearNumero(){
	strcpy(nomID, aux_id);
	int agregado = buscarSymbol(nomID);
	if (agregado >= 0){
		fprintf(stderr, "ERROR: variable int  %s ya fue declarada\n",aux_id);
		exit(1);
	} else {
		pushPilaSymbol(nomID, 'i');
		if (nivelAnidado>=0)
			extraPushAmount[nivelAnidado]++;
	}
}

void Retener(int valorInteger,int isString){
	if(isString==1){
		char retenedorS[128];
		strcpy(retenedorS,aux_nombre);
		RetenedorS(retenedorS);
	}
	else 
		RetenedorI(valorInteger);
}

void Asignar(int isString){
	if (isString==1){
		int pos = findString(nomID);
		updateString(pos);
		printf("\tpush %s\n",nomID);
	} else {
		printf("\tmov eax,%i\n",getRetenedorI());
		printf("\tpush eax\n");
	}
}

void IdentificarID(){
	int agregado = buscarSymbol(aux_id);
	if (agregado >= 0){
		asignarVariable = agregado;
	} else {
		fprintf(stderr, "ERROR: No se ha declarado la variable\n");
		exit(1);
	}
}

void empujarValor(int value){
	printf("\tmov eax, %i\n",value);
	printf("\tpush eax\n");
	pushPilaSymbol("0",'i');
}

void empujarIdentificador(){
	int pos = buscarSymbol(aux_id);
	if (pos >= 0){
		if (buscarTipo(pos) != 'i'){
			fprintf(stderr, "ERROR: operacion matematica con string\n");
			exit(1);
		} else {
			int posAsign = 4*(topePila-pos-1);
			printf("\tadd esp, %i\n",posAsign);
			printf("\tpop eax\n");
			printf("\tsub esp, %i\n",posAsign+4);
			printf("\tpush eax\n");
			pushPilaSymbol("value",'i');
		}
	} else {
		fprintf(stderr, "ERROR: La variable %s no se ha declarado",aux_id);
		exit(1);
	}
}

void Suma(){
	printf("\tpop ebx\n");
	printf("\tpop eax\n");
	printf("\tadd eax, ebx\n");
	printf("\tpush eax\n");
	topePila--;
}

void Resta(){
	printf("\tpop ebx\n");
	printf("\tpop eax\n");
	printf("\tsub eax, ebx\n");
	printf("\tpush eax\n");
	topePila--;
}

void Multiplica(){
	printf("\tpop ebx\n");
	printf("\tpop eax\n");
	printf("\tmul ebx\n");
	printf("\tpush eax\n");
	topePila--;
}

void Divide(){
	printf("\tpop ebx\n");
	printf("\tpop eax\n");
	printf("\tdiv ebx\n");
	printf("\tpush eax\n");
	topePila--;
}

void AsignarNuevoValor(){
	char valueSegment[128];
	strcpy(valueSegment,aux_nombre);
	if (buscarTipo(asignarVariable) != 'i'){
		fprintf(stderr, "ERROR: operacion matematica con string");
		exit(1);
	} else {
		topePila--;
		asignarVariable = topePila-asignarVariable-1;
		printf("\tpop eax\n");
		printf("\tadd esp,%i\n",asignarVariable*4);
		printf("\tpop ebx\n");
		printf("\tpush eax\n");
		printf("\tsub esp,%i\n",asignarVariable*4);
	}
}

void jmeryIfIdentificador(int verdad){
	contadorJmeryIf++; nivelAnidado++;
	if (nivelAnidado>20){
		exit(1);
	}
	int agregado = buscarSymbol(aux_id);
	if (agregado >= 0){
		if (buscarTipo(agregado) != 'i'){
			fprintf(stderr, "ERROR: operacion matematica con string");
			exit(1);
		} else {
			int posAsign = 4*(topePila-agregado-1);
			printf("\tadd esp, %i\n",posAsign);
			printf("\tpop eax\n");
			printf("\tsub esp, %i\n",posAsign+4);
			printf("\tmov ebx,0\n");
			printf("\tcmp eax,ebx\n");
			if (verdad==1)	printf("\tjz fincond%i\n",contadorJmeryIf);
			else			printf("\tjnz fincond%i\n",contadorJmeryIf);
		}
	} else {
		fprintf(stderr, "ERROR: No se ha declarado la variable");
		exit(1);
	}
}

void jmeryIf(int number, int verdad){
	contadorJmeryIf++; nivelAnidado++;
	if (nivelAnidado>20){
	
		exit(1);
	}
	printf("\tmov eax,%i\n",number);
	printf("\tmov ebx,0\n");
	printf("\tcmp eax,ebx\n");
	if (verdad==1) printf("\tjz fincond%i\n",contadorJmeryIf);
	else		printf("\tjnz fincond%i\n",contadorJmeryIf);
}

void endJmeryIf(){
	if (extraPushAmount[nivelAnidado]>0){
		printf("\tadd esp,%i\n",extraPushAmount[nivelAnidado]*4);
		topePila = topePila - extraPushAmount[nivelAnidado];
		extraPushAmount[nivelAnidado] = 0;
	}
	printf("\tfincond%i:\n",contadorJmeryIf);
	nivelAnidado--;
}


void iteraa(int valor){
	contadorItera++; nivelAnidado++;
	if (nivelAnidado>20){

		exit(1);
	}
	printf("\tpush %i\n",valor);
	printf("\tmov eax,0\n");
	printf("\tcmp eax,%i\n",valor);
	printf("\tjz finciclo%i\n",contadorItera);
	printf("\tciclo%i:\n",contadorItera);
	pushPilaSymbol("0",'i');
}

void endItera(){
	if (extraPushAmount[nivelAnidado]>0){
		printf("\tadd esp,%i\n",extraPushAmount[nivelAnidado]*4);
		topePila = topePila - extraPushAmount[nivelAnidado];
		extraPushAmount[nivelAnidado] = 0;
	}
	printf("\tpop eax\n");
	printf("\tdec eax\n");
	printf("\tpush eax\n");
	printf("\tjnz ciclo%i\n",contadorItera);
	printf("\tfinciclo%i:\n",contadorItera);
	printf("\tpop eax\n");
	
	topePila--;
	nivelAnidado--;
}

void iteraIdentificador(){
	contadorItera++;	nivelAnidado++;
	if (nivelAnidado>20){

		exit(1);
	}
	posIDFOR[nivelAnidado] = buscarSymbol(aux_id);
	if (posIDFOR[nivelAnidado] >= 0){
		if (buscarTipo(posIDFOR[nivelAnidado]) != 'i'){
			fprintf(stderr, "ERROR: operacion matematica con string");
			exit(1);
		} else {
			int posAsign = 4*(topePila-posIDFOR[nivelAnidado]-1);
			printf("\tadd esp, %i\n",posAsign);
			printf("\tpop eax\n");
			printf("\tsub esp, %i\n",posAsign+4);
			printf("\tmov ebx,0\n");
			printf("\tcmp eax,ebx\n");
			printf("\tjz finciclo%i\n",contadorItera);
			printf("\tciclo%i:\n",contadorItera);
		}
	} else {
		fprintf(stderr, "ERROR: No se ha declarado la variable");
		exit(1);
	}
}

void endIteraIdentificador(){
	if (extraPushAmount[nivelAnidado]>0){
		printf("\tadd esp,%i\n",extraPushAmount[nivelAnidado]*4);
		topePila = topePila - extraPushAmount[nivelAnidado];
		extraPushAmount[nivelAnidado] = 0;
	}
	int posAsign = 4*(topePila-posIDFOR[nivelAnidado]-1);
	printf("\tadd esp, %i\n",posAsign);
	printf("\tpop eax\n");
	printf("\tsub eax,1\n");
	printf("\tpush eax\n");
	printf("\tsub esp, %i\n",posAsign);
	printf("\tcmp eax,0\n");
	printf("\tjnz ciclo%i\n",contadorItera);
	printf("\tfinciclo%i:\n",contadorItera);
	
	nivelAnidado--;
}

void Imprimir(){
	char tempID[32];
	sprintf(tempID, "_msg%i",contador); contador++;
	addEntireString(tempID,aux_nombre);
	printf("\tpush\t%s\n",tempID);
	printf("\tcall\t_printf\n");
	printf("\tadd\tesp, 4\n");
}

void ImprimirConParametros(){
	char tempID[32];
	sprintf(tempID, "_msg%i",contador); contador++;
	addEntireString(tempID,aux_nombre);
	printf("\tpush\t%s\n",tempID);
	printf("\tcall\t_printf\n");
	printf("\tadd\tesp, %d\n", 4*(cantArg+1));
	cantArg = 0;
}


void contarArgumentos() {
  cantArg++;
  if (cantArg > 2) {
    fprintf(stderr, "ERROR: Solo se permiten 3 argumentos por funcion\n");
    exit(1);
  }
  int creado = buscarSymbol(aux_id);
  if (creado >= 0){
	int pos = (topePila-creado-1)*4;
	printf("\tadd esp, %i\n",pos);
	printf("\tpop eax\n");
	printf("\tsub esp, %i\n",pos+4);
	printf("\tpush eax\n");
  } else {
	fprintf(stderr, "ERROR: Parametros incorrectos\n");
    exit(1);
  }
}

void fin() {
  if (topePila!=0){
	printf("\tadd esp, %i\n",topePila*4);
  }
  printf("\tret\n");}

void addDataSection(){
	printf("\nsection .data\n");
	printTable();
}
