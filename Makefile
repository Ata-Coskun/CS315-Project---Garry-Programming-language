all:
	lex CS315f19_group15.lex
	yacc CS315f19_group15.yacc
	gcc -o CS315f19_group15 y.tab.c
	./CS315f19_group15 < CS315f19_group15.test