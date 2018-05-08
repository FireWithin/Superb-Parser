D                       [0-9]
E                       [DdEe][+-]?{D}+
L                       [a-zA-Z_]

%{
    #include "y.tab.h"
%}

%%
"load"        {return LOAD;}
"while"       {return WHILE;}
"for"         {return FOR;}
"end"         {return END;}
"if"          {return IF;}
"elseif"      {return ELSEIF;}
"return"      {return RETURN;}
"global"      {return GLOBAL;}
"function"    {return FUNCTION;}
"break"       {return BREAK;}
"clear"       {return CLEAR;}
\n            {return NL;}

"<="          {return LE_OP;}
">="          {return GE_OP;}
"=="          {return EQUAL;}
"~="          {return NOT_EQUAL;}
".*"          {return ARRAYDIV;}
".^"          {return ARRAYPOW;}
"./"          {return ARRAYDIV;}
".\\"         {return ARRAYRDIV;}
".'"         {return TRANSPOSE;}
"'"         {return TRANSPOSE;}

"hold on"     {return HOLDON;}
"hold off"     {return HOLDOFF;}
{D}+({E})?                {return CONSTANT;}
{D}*"."{D}+({E})?         {return CONSTANT;}
{D}+"."{D}*({E})?         {return CONSTANT;}
[a-zA-Z_]+[_a-zA-Z0-9]*   {return ID;}
['][^'\n]*[']             {return STRING_LITERAL;}

"~"           {return '~';}
";"           {return ';';}
","           {return ',';}
":"           {return ':';}
"="           {return '=';}
"("           {return '(';}
")"           {return ')';}
"["           {return '[';}
"]"           {return ']';}
"}"           {return '}';}
"{"           {return '{';}
"&"           {return '&';}
"-"           {return '-';}
"+"           {return '+';}
"*"           {return '*';}
"/"           {return '/';}
"%"           {return '%';}
"\\"          {return '\\';}
"<"           {return '<';}
">"           {return '>';}
"^"           {return '^';}
[ \t\v\f]     {;}
.             {return yytext[0];}


%%
