#ifndef __TABLA_H__
#define __TABLA_H__


/* Data type for links in the chain of symbols.  */
struct idtype{
        char *name;
        int type;
        union
{
  float float_value;
  int int_value;      /* value of a VAR */
 /* value of a FNCT */
} value;
        int initialized;
        struct idtype * next;
};

typedef struct idtype idtype;
extern int yylineno;

/* The symbol table: a chain of 'struct symrec'.  */
extern idtype* sym_table;
idtype *push_symrec(char *,float ,int ,int ,int );
idtype *get_symrec(char *);
idtype * printsymtable();



#endif
