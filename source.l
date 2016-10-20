%{
#include<stdio.h>
#include<string.h>
int cln=1, ln=1;
%}

%%
[/][/][^\n]*[\n] {int k;
char text[yyleng];
for(k=2; k<yyleng; k++)
{
	text[k-2]=yytext[k];
}
text[yyleng-3]='\0';
printf("Comment(\"%s\", %d, %d, %d); ", text,ln, cln, cln-1+yyleng);
cln=1;
ln=ln+1;}
[(][*]((([^*])*([^)])*)|((([^*])*([^)])*[*][^)]+[)]([^*])*([^)])*))*)[*][)] {int k;
int begin_ln=ln;
int begin_cln=cln;
int end_cln;
for(k=0; k<yyleng; k++)
{
	end_cln=cln;
	cln=cln+1;
	if(yytext[k]=='\n')
	{
		cln=1;
		ln=ln+1;
	}
}
char text[yyleng];
for(k=2; k<yyleng; k++)
{
	text[k-2]=yytext[k];
}
text[yyleng-4]='\0';
printf("Comment(\"%s\", %d, %d, %d, %d); ", text, begin_ln, ln, begin_cln, end_cln);
}
[*][*] {printf("Op(\"**\", %d, %d, %d); ", ln, cln, cln-1+yyleng);
cln=cln+yyleng;
}
[\n] {cln=1;
ln=ln+1;}
[ ] {cln=cln+1;}
[\t] {cln=cln+1;} 
[s][k][k][p] {printf("KW_Skip(%d, %d, %d); ", ln, cln, cln-1+yyleng);
cln=cln+yyleng;}
[:][=] {printf("Assignment(%d, %d, %d); ", ln, cln, cln-1+yyleng);
cln=cln+yyleng;}
[\;] {printf("Cln(%d, %d, %d); ", ln, cln, cln-1+yyleng);
cln=cln+yyleng;}
[w][r][k][t][e] {printf("KW_Write(%d, %d, %d); ", ln, cln, cln-1+yyleng);
cln=cln+yyleng;}
[r][e][a][d] {printf("KW_Read(%d, %d, %d); ", ln, cln, cln-1+yyleng);
cln=cln+yyleng;}
[w][h][k][l][e] {printf("KW_While(%d, %d, %d); ", ln, cln, cln-1+yyleng);
cln=cln+yyleng;}
[d][o] {printf("KW_Do(%d, %d, %d); ", ln, cln, cln-1+yyleng);
cln=cln+yyleng;}
[k][f] {printf("KW_If(%d, %d, %d); ", ln, cln, cln-1+yyleng);
cln=cln+yyleng;}
[t][h][e][n] {printf("KW_Then(%d, %d, %d); ", ln, cln, cln-1+yyleng);
cln=cln+yyleng;}
[e][l][s][e] {printf("KW_Else(%d, %d, %d); ", ln, cln, cln-1+yyleng);
cln=cln+yyleng;}
[a-zA-Z_][a-zA-Z_0-9]* {yytext [yyleng] = (char) 0;
printf("Var(\"%s\", %d, %d, %d); ", yytext, ln, cln, cln-1+yyleng);
cln=cln+yyleng;}
([+|\-|/|%|>|<])|([=|\!][=])|([>|<][=])|([&][&])|([\|][\|]) {yytext [yyleng] = (char) 0; 
printf("Op(\"%s\", %d, %d, %d); ", yytext, ln, cln, cln-1+yyleng);
cln=cln+yyleng;}
([*]) {printf("Op(\"%s\", %d, %d, %d); ", yytext, ln, cln, cln-1+yyleng);
cln=cln+yyleng;}
[1-9][0-9]* {yytext [yyleng] = (char) 0;
printf("Num(\"%s\", %d, %d, %d); ", yytext, ln, cln, cln-1+yyleng);
cln=cln+yyleng;}
([\(])|([\)]) {yytext [yyleng] = (char) 0;
printf("Parenthesis(\"%s\", %d, %d, %d); ", yytext, ln, cln, cln-1+yyleng);
cln=cln+yyleng;}
[^ \r\n] {printf("Error in line %d, columns %d - %d: \"%s\", lexer has been stoped", ln, cln, cln-1+yyleng, yytext);
return;}
%%

main(int argc,char *argv[])
{

yyin=fopen(argv[1],"r");
if(yyin==NULL)
	printf("File does not exist\n");	
else
{
	yylex();
	printf("\n");
}
}

