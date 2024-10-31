%{
    #include <stdio.h>  /* For printf, etc. */
    #include <math.h>   /* For pow, used in the grammar.  */
    #include <string.h>
    #include "calc.h"   /* Contains definition of 'symrec'.  */

    int yydebug = 0;
    int yylex (void);
    void yyerror (char const *);
    idtype *sym_table=NULL;
   
   
%}


%token TOK_SEMICOLON TOK_ADD TOK_MUL TOK_EQL TOK_NUM TOK_PRINTLN
/*TOK_OCB - open curly brackets, TOK_CCB - close curly bracket*/
/*TOK_DECP - decimal point*/
%token TOK_MAIN TOK_OCB TOK_CCB
%token TOK_INT TOK_FLOAT TOK_ID

%union{
        struct {
            int type;
            int int_value;
            float float_value;
            char name[100];
        }data;
}
%type <data> TOK_INT
%type <data> TOK_FLOAT
%type <data> TOK_ID
%type <data> expr
%left TOK_ADD
%left TOK_MUL

/*all possible types*/



%% /* The grammar follows.  */
program : TOK_MAIN TOK_OCB  stmts TOK_CCB
;

stmts:
        | stmt TOK_SEMICOLON stmts
        

stmt :
       TOK_INT TOK_ID
                {

                        struct idtype *id=get_symrec($2.name);
                        if(id)
                        {
                                fprintf(stderr,"Line %d: Redeclaration of identfier %s.\n",yylineno,id->name);
                                return -1;
                        }
                        else{
                                id=(struct idtype *)malloc(sizeof(struct idtype*));
                                push_symrec($2.name, -1,-1,0,0);
                                
                        }
                   
                    

                }
        |TOK_FLOAT TOK_ID
                {
                        struct idtype *id=get_symrec($2.name);
                        if(id)
                        {
                                fprintf(stderr,"Line %d: Redeclaration of identfier '%s'.\n",yylineno,id->name);
                                return -1;
                        }
                        else{
                                id=(struct idtype *)malloc(sizeof(struct idtype*));
                                push_symrec($2.name, -1,-1,1,0);
                                
                        }

                }
        |TOK_PRINTLN TOK_ID
                {
                        struct idtype *id = get_symrec($2.name);
                        if(!id){
                                fprintf(stderr,"Line %d: '%s' does not exists\n",yylineno,$2.name);
                                return -1;
                        }
                        else{
                                if(id->type==0)
                                        fprintf(stdout,"%d\n", id->value.int_value);
                                else if(id->type==1)
                                        fprintf(stdout,"%f\n",id->value.float_value);
                        }
                }
        |TOK_ID TOK_EQL expr
                {
                        struct idtype *id=get_symrec($1.name);
                        if(!id)
     			 {
                                fprintf(stderr,"Line %d: '%s' does not exists\n",yylineno,$1.name);
                                return -1;
                        }
                        if(id->type != $3.type)
                        {
                        	    if(id->type==0){
                        	         fprintf(stderr,"Line %d: Type mismatch, int expected\n",yylineno);
                        	    }
                                   else{
                        		 fprintf(stderr,"Line %d: Type mismatch, float expected\n",yylineno);
                        	    }
                                   return -1;
                        }
                        else if(id->type==1){
                       
                                  idtype * ptr = get_symrec($1.name);
                                  ptr->value.float_value=$3.float_value;
                                  ptr->type=1;
                                  ptr->initialized=1;
                                  

                       }
                       else{
                                  idtype * ptr = get_symrec($1.name);
                                  ptr->value.int_value=$3.int_value;
                                  ptr->type=0;
                                  ptr->initialized=1;

                       }
                     
                }

        

expr : 
        TOK_ID
                {
                        struct idtype *id=get_symrec($1.name);
                        
                        if(!id)
                        {
                                fprintf(stderr,"Line %d:%s not defined.\n",yylineno,$1.name);
                                return -1;
                        }
                        strcpy($$.name,id->name);
                }
        |TOK_INT
                {
                        $$.int_value=$1.int_value;
                        $$.type=0;
                      
                }
        |TOK_FLOAT
                {
                       $$.float_value=$1.float_value;
                       $$.type=1;
                       
                }
        | expr TOK_ADD expr
                {
                	int ltype=get_symrec($1.name)->type;
                	int rtype=get_symrec($3.name)->type;
                	
                       if(ltype != rtype){
                                if(rtype==0){
                        	         fprintf(stderr,"Line %d: Type mismatch, float+int\n",yylineno);
                        	         return -1;
                        	  }
                                else{
                        		 fprintf(stderr,"Line %d: Type mismatch, int+float\n",yylineno);
                        		 return -1;
                        	 }
                                
                         }
                        else
                           {     if($1.type==0){
                           		 int lvalue=get_symrec($1.name)->value.int_value;
                			 int rvalue=get_symrec($3.name)->value.int_value;
                                        $$.int_value = lvalue + rvalue;
                                        $$.type = 0;
                                }
                                else{
                                        int lvalue=get_symrec($1.name)->value.float_value;
                			 int rvalue=get_symrec($3.name)->value.float_value;
                                        $$.int_value = lvalue + rvalue;
                                        $$.type = 1;
                                }
                           }
                }
        | expr TOK_MUL expr
                {
                       int ltype=get_symrec($1.name)->type;
                	int rtype=get_symrec($3.name)->type;
                       if(ltype != rtype){
                                if(rtype==0){
                        	         fprintf(stderr,"Line %d: Type mismatch, float*int\n",yylineno);
                        	         return -1;
                        	  }
                                else{
                        		 fprintf(stderr,"Line %d: Type mismatch, int*float\n",yylineno);
                        		 return -1;
                        	 }
                                
                        }
                        else
                                if($1.type==0){
                           		 int lvalue=get_symrec($1.name)->value.int_value;
                			 int rvalue=get_symrec($3.name)->value.int_value;
                                        $$.int_value = lvalue * rvalue;
                                        $$.type = 0;
                                }
                                else{
                                        int lvalue=get_symrec($1.name)->value.float_value;
                			 int rvalue=get_symrec($3.name)->value.float_value;
                                        $$.int_value = lvalue * rvalue;
                                        $$.type = 1;
                                }
                }


        
%%


void yyerror(char const *s)
{
  fprintf (stderr, "%s on line-%d", s,yylineno);
}

int main (int argc, char const* argv[])
{
  
    yyparse();
    return 0;
}
