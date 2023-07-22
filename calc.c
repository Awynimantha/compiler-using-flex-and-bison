#include <stdlib.h> / * malloc. * /
#include <string.h> / * strlen. * /
#include "calc.h"

idtype * push_symrec (char *name,float float_value,int int_value, int type,int init){
    idtype * table= sym_table;
    idtype *ptr = (idtype *) malloc (sizeof (idtype));
    ptr->name = (char *) malloc (strlen (name) + 1);
    strcpy (ptr->name,name);
    ptr->type = type;
    ptr->initialized=init;
    if(type==0){
        ptr->value.int_value = int_value; /* Set value to 0 even if fctn.  */
    }
    else {
        ptr->value.float_value = float_value;
    }
    if(sym_table==NULL){
        ptr->next=NULL;
        sym_table=ptr;
    }
    else{
        ptr->next = sym_table;
        sym_table= ptr;

    }
    return ptr;
}


idtype * get_symrec (char *name){
    idtype *ptr= sym_table;
    if(ptr==NULL){

        return NULL;
    }
    for (ptr; ptr!=NULL; ptr = ptr->next){
        if (strcmp (ptr->name, name) == 0)
        return ptr;
    }
}

idtype * printsymtable(){
    idtype *ptr= sym_table;
    int count=1;
    if(ptr==NULL){

        return NULL;
    }
    for (ptr; ptr != NULL; ptr = ptr->next){
  		
        printf("%s-%d",ptr->name,ptr->type);
     
    }
}
