.class public EJEMPLOPROFE
.super java/lang/Object
.field public static r I
.field public static c I
.field public static d I
.field public static n I
.method public <init>()V
	aload_0
	invokenonvirtual java/lang/Object/<init>()V
	return
.end method
.method public static imprimeInt(I)V
	.limit locals 1
	.limit stack 2
	getstatic java/lang/System/out Ljava/io/PrintStream;
	iload_0
	invokevirtual java/io/PrintStream/println(I)V
	return
.end method
.method public static imprimeReal(D)V
	.limit locals 2
	.limit stack 3
	getstatic java/lang/System/out Ljava/io/PrintStream;
	dload_0
	invokevirtual java/io/PrintStream/println(D)V
	return
.end method
.method public static imprimeString(Ljava/lang/String;)V
	.limit locals 1
	.limit stack 2
	getstatic java/lang/System/out Ljava/io/PrintStream;
	aload_0
	invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
	return
.end method
.method public static main([Ljava/lang/String;)V
	.limit stack 20
	.limit locals 10
	ldc 29
	putstatic EJEMPLOPROFE.n I
	ldc 5
	putstatic EJEMPLOPROFE.d I
	ldc 0
	putstatic EJEMPLOPROFE.c I
	getstatic EJEMPLOPROFE.n I
	getstatic EJEMPLOPROFE.d I
	isub
	putstatic EJEMPLOPROFE.r I
L0:
	getstatic EJEMPLOPROFE.r I
	ldc 0
	if_icmple L1
	getstatic EJEMPLOPROFE.c I
	ldc 1
	iadd
	putstatic EJEMPLOPROFE.c I
	getstatic EJEMPLOPROFE.n I
	getstatic EJEMPLOPROFE.d I
	isub
	putstatic EJEMPLOPROFE.n I
	getstatic EJEMPLOPROFE.n I
	getstatic EJEMPLOPROFE.d I
	isub
	putstatic EJEMPLOPROFE.r I
	goto L0
L1:
	getstatic EJEMPLOPROFE.c I
	invokestatic EJEMPLOPROFE.imprimeInt(I)V
	getstatic EJEMPLOPROFE.n I
	invokestatic EJEMPLOPROFE.imprimeInt(I)V
	return
.end method