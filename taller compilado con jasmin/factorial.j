.class public factorial
.super java/lang/Object
.field public static impresion Ljava/lang/String;
.field public static aux I
.field public static factorial I
.field public static numero I
.field public static i I
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
	ldc "El factorial de 10 es:"
	putstatic factorial.impresion Ljava/lang/String;
	ldc 0
	putstatic factorial.i I
	ldc 10
	putstatic factorial.numero I
	ldc 1
	putstatic factorial.factorial I
	ldc 10
	putstatic factorial.aux I
L0:
	getstatic factorial.i I
	getstatic factorial.numero I
	if_icmpge L1
	getstatic factorial.factorial I
	getstatic factorial.aux I
	imul
	putstatic factorial.factorial I
	getstatic factorial.aux I
	ldc 1
	isub
	putstatic factorial.aux I
	getstatic factorial.i I
	ldc 1
	iadd
	putstatic factorial.i I
	goto L0
L1:
	getstatic factorial.impresion Ljava/lang/String;
	invokestatic factorial.imprimeString(Ljava/lang/String;)V
	getstatic factorial.factorial I
	invokestatic factorial.imprimeInt(I)V
	return
.end method