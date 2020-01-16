.class public fibonacci
.super java/lang/Object
.field public static aux I
.field public static fib2 I
.field public static fib1 I
.field public static contador I
.field public static i I
.field public static veces I
.field public static fin Ljava/lang/String;
.field public static valores Ljava/lang/String;
.field public static fibo Ljava/lang/String;
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
	ldc 10
	putstatic fibonacci.veces I
	ldc 0
	putstatic fibonacci.i I
	ldc 1
	putstatic fibonacci.contador I
	ldc 1
	putstatic fibonacci.fib1 I
	ldc 0
	putstatic fibonacci.fib2 I
	ldc 0
	putstatic fibonacci.aux I
	ldc "fibonacci:"
	putstatic fibonacci.fibo Ljava/lang/String;
	ldc "valor:"
	putstatic fibonacci.valores Ljava/lang/String;
	ldc "Programa terminado"
	putstatic fibonacci.fin Ljava/lang/String;
L0:
	getstatic fibonacci.i I
	getstatic fibonacci.veces I
	if_icmpge L1
	getstatic fibonacci.fib1 I
	getstatic fibonacci.fib2 I
	iadd
	putstatic fibonacci.aux I
	getstatic fibonacci.fib1 I
	putstatic fibonacci.fib2 I
	getstatic fibonacci.aux I
	putstatic fibonacci.fib1 I
	getstatic fibonacci.fibo Ljava/lang/String;
	invokestatic fibonacci.imprimeString(Ljava/lang/String;)V
	getstatic fibonacci.contador I
	invokestatic fibonacci.imprimeInt(I)V
	getstatic fibonacci.valores Ljava/lang/String;
	invokestatic fibonacci.imprimeString(Ljava/lang/String;)V
	getstatic fibonacci.aux I
	invokestatic fibonacci.imprimeInt(I)V
	getstatic fibonacci.contador I
	ldc 1
	iadd
	putstatic fibonacci.contador I
	getstatic fibonacci.i I
	ldc 1
	iadd
	putstatic fibonacci.i I
	goto L0
L1:
	getstatic fibonacci.i I
	getstatic fibonacci.veces I
	if_icmpne L2
	getstatic fibonacci.fin Ljava/lang/String;
	invokestatic fibonacci.imprimeString(Ljava/lang/String;)V
	goto L3
L2:
L3:
	return
.end method