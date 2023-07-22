
%{
    #include<stdlib.h>
    /* Automata de pila */
    #include "calc.h" // Incluimos funciones para la tabla de simbolos
    #include "mfcalc.tab.h" // exportamos la declaraciones de bison
%}



digit [0-9]
ID [a-z][a-z0-9]*
%%

"println" { return(TOK_PRINTLN); }

{digit}+ { sscanf(yytext, "%d", &(yylval.data.int_value));
    return TOK_INT; 
}

{digit}+\.{digit}+  {
	sscanf(yytext, "%f", &(yylval.data.float_value));
	return TOK_FLOAT;
}


";" { return(TOK_SEMICOLON); }

"+" { return(TOK_ADD); }

"*" { return(TOK_MUL); }

"=" { return(TOK_EQL); }

"main()" { return(TOK_MAIN); }

"int" { return(TOK_INT); }

"float" { return(TOK_FLOAT); }

"{" {  return(TOK_OCB); }

"}" { return(TOK_CCB);}

"printvar" { return(TOK_PRINTLN); }

[a-z][a-z0-9]* 	{
		strcpy(yylval.data.name,yytext);
		return TOK_ID;
        }

\n {yylineno++;}

[ ]+ {}

[ \t] {}

. {printf("Invalid character '%c'\n", yytext[0]);}


%%

