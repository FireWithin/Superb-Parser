%{
#include <stdio.h>
#include <stdlib.h>
int yylex(void);
void yyerror(char *mess);
int line = 1;
%}

%token HOLDOFF HOLDON LOAD WHILE FOR ID FUNCTION END TRANSPOSE CONSTANT STRING_LITERAL EQUAL NOT_EQUAL LE_OP GE_OP ARRAYMUL ARRAYDIV ARRAYRDIV ARRAYPOW NL GLOBAL CLEAR BREAK RETURN IF ELSE ELSEIF

%%

start: statement_list start
| FUNCTION function_declare eostmt statement_list END eostmt start
| LOAD '(' STRING_LITERAL ')' eostmt start
| LOAD STRING_LITERAL eostmt start
| LOAD ID eostmt start
|
;

function_declare: function_return '=' function_id
| function_id
;

function_id: ID
| ID '(' ')'
| ID '(' function_parameters ')'
;

function_parameters: ID
| function_parameters ',' ID
;

function_return: ID
| '[' function_parameters ']'
;

statement_list: statement
| statement_list statement
;

statement: assignment_command
| expr_command
| global_command
| iteration_command
| jump_command
| if_command
| clear_command
| holdon
| holdoff
;

holdon: HOLDON eostmt
;

holdoff: HOLDOFF eostmt
;

assignment_command: assignment_expression eostmt
;

expr_command: eostmt
| expression eostmt
;

global_command: GLOBAL identifier_list
;

iteration_command: WHILE expression statement_list END eostmt
| FOR ID '=' expression statement_list END eostmt
| FOR '(' ID '=' expression ')' statement_list END eostmt
;

jump_command: BREAK eostmt
| RETURN eostmt
;

if_command: IF expression statement_list END eostmt
| IF expression statement_list ELSE statement_list END eostmt
| IF expression statement_list elseif_clause END eostmt
| IF expression statement_list elseif_clause ELSE statement_list END eostmt
;

clear_command: CLEAR identifier_list eostmt
;

elseif_clause: ELSEIF expression statement_list
| elseif_clause ELSEIF expression statement_list
;

identifier_list: ID
| identifier_list ID
;

assignment_expression: postfix_expression '=' expression
;

expression_statement
        : eostmt
        | expression eostmt
        ;

postfix_expression: primary_expression
| array_expression
| postfix_expression TRANSPOSE
;

primary_expression: ID
| CONSTANT
| STRING_LITERAL
| '(' expression ')'
| '[' ']'
| '[' array_list ']'
| '{' array_list '}'
;

array_list: array_element
| array_list array_element
;

array_element: expression
| expression_statement
;

array_expression: ID '(' index_expression_list ')'
;

index_expression: ':'
| expression
;

index_expression_list: index_expression
| index_expression_list ',' index_expression
;

expression: or_expression
| expression ':' or_expression
;

or_expression: and_expression
| or_expression '|' and_expression
;

and_expression: equality_expression
| and_expression '&' equality_expression
;

equality_expression: relational_expression
| equality_expression EQUAL relational_expression
| equality_expression NOT_EQUAL relational_expression
;

relational_expression: additive_expression
| relational_expression '<' additive_expression
| relational_expression '>' additive_expression
| relational_expression LE_OP additive_expression
| relational_expression GE_OP additive_expression
;

additive_expression: multiplicative_expression
| additive_expression '+' multiplicative_expression
| additive_expression '-' multiplicative_expression
;

multiplicative_expression: unary_expression
| multiplicative_expression '*' unary_expression
| multiplicative_expression '/' unary_expression
| multiplicative_expression '\\' unary_expression
| multiplicative_expression '^' unary_expression
| multiplicative_expression '%' unary_expression
| multiplicative_expression ARRAYMUL unary_expression
| multiplicative_expression ARRAYDIV unary_expression
| multiplicative_expression ARRAYRDIV unary_expression
| multiplicative_expression ARRAYPOW unary_expression
;

unary_expression: postfix_expression
| unary_operator postfix_expression
;

unary_operator: '+'
| '-'
| '~'
;

eostmt: ','
| ';'
| NL  {line++;}
;

%%

void yyerror(char *mess){
	printf("%s on line: %d\n", mess, line);
}

int main(){
	yyparse();
	return 0;
}
