%{
    /* tianjiaye created at 2022-10-13 18:37:05
     exprl.y
     */
#include<vector>
#include<cstring>
#include<cctype>
using namespace std;
struct UNIT{
    double value=0;
    int key=0;
};
    
#ifndef YYSTYPE
#define YYSTYPE UNIT
#endif
int yylex();
extern int yyparse();
extern YYSTYPE yylval;
FILE* yyin;

char buf[200];
int length=0;

struct symtable_unit{
    char* lexptr;
    double attributes;
};
    
    char idStr[50];
    
    
    vector<symtable_unit> symtable;
    
    void yyerror(const char* s);
%}

%token ID
%token ADD SUB MUL DIV EQ LB RB
%token NUM
%right EQ
%left ADD SUB
%left MUL DIV
%right UMINUS

%%
    
    lines : lines expr ';' {printf("%f\n", $2.value);}
    |lines ';'
    |
    ;
    expr:expr ADD expr {$$.value=$1.value+$3.value;}
    | expr SUB expr {$$.value=$1.value-$3.value;}
    | expr MUL expr {$$.value=$1.value*$3.value;}
    | expr DIV expr {$$.value=$1.value/$3.value;}
    | ID EQ expr{$$.value=$3.value;symtable[$1.key].attributes=$3.value;}
    | LB expr RB {$$.value=$2.value;}
    | SUB expr%prec UMINUS{$$.value=-$2.value;}
    | NUM{$$.value=$1.value;}
    | ID{$$.value=symtable[$1.key].attributes;}
    ;
    
    
%%
    

    void insert_into_symtable(char*s){
        
        symtable_unit tmp;
        tmp.lexptr=s;
        tmp.attributes=0;
        symtable.push_back(tmp);
        
    }
    
    int find(char*s){
        for(int i=0;i<symtable.size();i++){
            if(strcmp(symtable[i].lexptr,s)==0)
            {
                return i;
            }
        }
        return -1;
    }
    
    int yylex(){
        int t;
        
        while(1){
            t=getchar();
            if(isblank(t)||t=='\t'||t=='\n')
            {
                continue;
            }
            else if(isdigit(t)){
                ungetc(t,stdin);
                scanf("%lf",&yylval);
                return NUM;
            }
            else if((t>='a'&&t<='z')||(t>='A'&&t<='Z')||t=='_'){
                int ti=0;
                while( (t>='a'&&t<='z') || (t>='A'&&t<='Z') || (t=='_') ||
                      (t>='0' && t<='9')){
                    idStr[ti]=t;
                    ti++;
                    t=getchar();
                }
                      idStr[ti]='\0';
                      if(find(idStr)==-1){
                          strcpy(buf+length,idStr); 
                          char* s=buf+length;
                          length+=strlen(idStr)+1;
                          insert_into_symtable(s);
                      }
                      yylval.key=find(idStr);
                      ungetc(t,stdin);
                      return ID;
            }
            
            else{
                switch(t){
                    case '+':
                    return ADD;
                    case '-':
                    return SUB;
                    case '*':
                    return MUL;
                    case '/':
                    return DIV;
                    case '=':
                    return EQ;
                    case '(':
                    return LB;
                    case ')':
                    return RB;
                    default:
                    return t;
                }
            }
            
        }
        
    }
    
    int main(void){
        yyin=stdin;
        do{
            yyparse();
        }while(!feof(yyin));
        return 0;
    }
    
    void yyerror(const char* s){
        fprintf(stderr,"Parse error:%s\n",s);
        exit(1);
    }
