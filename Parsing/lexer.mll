(* @authors : Robin You - Achibane Hamza - Hamza Sahri - Khaled Bousrih - Khalid Majdoub *)

{
open Lexing
(*open Error*)
type lexeme =
    | EOF
    | AND
    | OR
    | TRUE
    | FALSE
    | IDENT of string
    | REAL of float
    | NZDIGIT of char
    | ZERO
    | NULL
    | ABSTRACT
    | ASSERT
    | BOOLEAN
    | BREAK
    | BYTE
    | CASE
    | CATCH
    | CHAR
    | CLASS
    | CONST
    | CONTINUE
    | DEFAULT
    | DO
    | DOUBLE
    | ELSE
    | ENUM
    | EXTENDS
    | FINAL
    | FINALLY
    | FLOAT
    | FOR
    | IF
    | GOTO
    | IMPLEMENTS
    | IMPORT
    | INSTANCEOF
    | INT
    | INTERFACE
    | LONG
    | NATIVE
    | NEW
    | PACKAGE
    | PRIVATE
    | PROTECTED
    | PUBLIC
    | RETURN
    | SHORT
    | STATIC
    | STRICTFP
    | SUPER
    | SWITCH
    | SYNCHRONIZED
    | THIS
    | THROW
    | THROWS
    | TRANSIENT
    | TRY
    | VOID
    | VOLATILE
    | WHILE
    | PLUS
    | MINUS
    | TIMES
    | DIV
    | XOR
    | MOD
    | EQUAL
    | INF
    | SUP
    | CONDOR
    | CONDAND
    | INCR
    | DECR
    | COND
    | EXCL
    | TILDE
    | ANNOT
    | ISEQUAL
    | ISNOTEQUAL
    | PLUSEQUAL
    | MINUSEQUAL
    | TIMESEQUAL
    | DIVEQUAL
    | ANDEQUAL
    | OREQUAL
    | XOREQUAL
    | MODEQUAL
    | INFOREQUAL
    | SUPOREQUAL
    | LSHIFT
    | RSHIFT
    | LSHIFTEQUAL
    | RSHIFTEQUAL
    | USHIFT
    | USHIFTEQUAL
    | POINT
    | SEMICOLON
    | COMMA
    | COLON
    | LBRACE
    | RBRACE
    | LPAREN
    | RPAREN
    | LBRACK
    | RBRACK

type error =
	| Illegal_character of char
	| Illegal_float of string

exception Error of error * position * position

let raise_error err lexbuf =
raise (Error(err, lexeme_start_p lexbuf, lexeme_end_p lexbuf))
(* Les erreurs. *)
let report_error = function
	| Illegal_character c ->
		print_string "Illegal character ’";
		print_char c;
		print_string "’ "
	| Illegal_float nb ->
		print_string "The float ";
		print_string nb;
		print_string " is illegal "
let print_position debut fin =
 if (debut.pos_lnum = fin.pos_lnum) then
  begin
   print_string "line ";
   print_int debut.pos_lnum;
   print_string " characters ";
   print_int (debut.pos_cnum - debut.pos_bol);
   print_string "-";
   print_int (fin.pos_cnum - fin.pos_bol)
  end
 else
  begin
   print_string "from line ";
   print_int debut.pos_lnum;
   print_string " character ";
   print_int (debut.pos_cnum - debut.pos_bol);
   print_string " to line ";
   print_int fin.pos_lnum;
   print_string " character ";
   print_int (fin.pos_cnum - fin.pos_bol)
  end
}

(* series of let declarations which precede the rules definition to define some
	 regular expressions. They will be used during the rules definition *)

(* General regular expressions *)

let letter    = ['a'-'z' 'A'-'Z']
let lowercase = ['a'-'z']
let uppercase = ['A'-'Z']
let digit     = ['0'-'9']
let nzdigit   = ['1'-'9']
let decimal   = '.' digit*
let real      = digit * (decimal)?

(* 3.4 Line Terminators *)

let line_feed       = '\010'
let carriage_return = '\013'
let line_terminator = (line_feed | carriage_return | carriage_return line_feed)

(* 3.5 Input and Tokens *)

let sub_character = '\026' 

(* 3.6 White Space *)

let horizontal_tab = '\010'
let space          = ' '
let white_space    = (space | horizontal_tab)

(* 3.7 Comments *)

let traditional_comment = "/*" (_)* "*/" line_terminator
let end_of_line_comment = "//" ([^'\010' '\013'])* line_terminator
let comment             = (traditional_comment | end_of_line_comment)

(* 3.8 Identifiers *)  

let ident = letter ( letter | digit | '_')*

(* Rules Definitions *)

(* TO COMPLETE *) 
(* principally completed using keywords page 21, operations page 36
   and pages 586 and 587 *)

rule nexttoken = parse
	| line_terminator    { Lexing.new_line lexbuf; nexttoken lexbuf }
	| comment            { Lexing.new_line lexbuf; nexttoken lexbuf }
	| white_space+       { nexttoken lexbuf }
	| eof                { EOF }
	| ident as str       { IDENT str }
	| real as nb         { REAL(float_of_string nb) } (*not sure*)
	| nzdigit as nz      { NZDIGIT(nz) }
	| "0"                { ZERO }
	| "null"             { NULL }
	| "true"             { TRUE }
	| "false"            { FALSE }
	| "abstract"         { ABSTRACT }   
	| "assert"           { ASSERT }
	| "boolean"          { BOOLEAN }
	| "break"            { BREAK }
	| "byte"             { BYTE }
	| "case"             { CASE }
	| "catch"            { CATCH }
	| "char"             { CHAR }
	| "class"            { CLASS }
	| "const"            { CONST }
	| "continue"         { CONTINUE }
	| "default"          { DEFAULT }
	| "do"               { DO }
	| "double"           { DOUBLE }
	| "else"             { ELSE }
	| "enum"             { ENUM }
	| "extends"          { EXTENDS }
	| "final"            { FINAL }
	| "finally"          { FINALLY }
	| "float"            { FLOAT }
	| "for"              { FOR }
	| "if"               { IF }
	| "goto"             { GOTO }
	| "implements"       { IMPLEMENTS }
	| "import"           { IMPORT }
	| "instanceof"       { INSTANCEOF }
	| "int"              { INT }
	| "interface"        { INTERFACE }
	| "long"             { LONG }
	| "native"           { NATIVE }
	| "new"              { NEW }
	| "package"          { PACKAGE }
	| "private"          { PRIVATE }
	| "protected"        { PROTECTED }
	| "public"           { PUBLIC }
	| "return"           { RETURN }
	| "short"            { SHORT }
	| "static"           { STATIC }
	| "strictfp"         { STRICTFP }
	| "super"            { SUPER }
	| "switch"           { SWITCH }
	| "synchronized"     { SYNCHRONIZED }
	| "this"             { THIS }
	| "throw"            { THROW }
	| "throws"           { THROWS }
	| "transient"        { TRANSIENT }
	| "try"              { TRY }
	| "void"             { VOID }
	| "volatile"         { VOLATILE }
	| "while"            { WHILE }
	| "+"                { PLUS }
	| "-"                { MINUS }
	| "*"                { TIMES }
	| "/"                { DIV }
	| "&"                { AND }
	| "|"                { OR }
	| "^"                { XOR }
	| "%"                { MOD }
	| "="                { EQUAL }
	| "<"                { INF }
	| ">"                { SUP }
	| "||"               { CONDOR }
	| "&&"               { CONDAND }
	| "++"               { INCR }
	| "--"               { DECR }
	| "?"                { COND }
	| "!"                { EXCL }
	| "~"                { TILDE }
	| "@"                { ANNOT }
	| "=="               { ISEQUAL }
	| "!="               { ISNOTEQUAL }
	| "+="               { PLUSEQUAL }
	| "-="               { MINUSEQUAL }
	| "*="               { TIMESEQUAL }
	| "/="               { DIVEQUAL }
	| "&="               { ANDEQUAL }
	| "|="               { OREQUAL }
	| "^="               { XOREQUAL }
	| "%="               { MODEQUAL }
	| "<="               { INFOREQUAL }
	| ">="               { SUPOREQUAL }
	| "<<"               { LSHIFT }
	| ">>"               { RSHIFT }
	| "<<="              { LSHIFTEQUAL }
	| ">>="              { RSHIFTEQUAL }
	| ">>>"              { USHIFT }
	| ">>>="             { USHIFTEQUAL }
  | "."                { POINT }
  | ";"                { SEMICOLON }
  | ","                { COMMA }
  | ":"                { COLON }
  | "{"                { LBRACE }
  | "}"                { RBRACE }
  | "("                { LPAREN }
  | ")"                { RPAREN }
  | "["                { LBRACK }
  | "]"                { RBRACK }
  | _ as c             { raise_error (Illegal_character(c)) lexbuf }



{

let print_token = function 
	| EOF                -> print_string "eof"
	| IDENT i            -> print_string "ident ("; print_string i; print_string ")"
	| REAL i              -> print_string "real"
	| NZDIGIT n          -> print_string (String.make 1 n)
	| ZERO               -> print_string "zero"
	| NULL               -> print_string "null"
	| TRUE               -> print_string "true"
	| FALSE              -> print_string "false"
	| ABSTRACT           -> print_string "abstract"
	| ASSERT             -> print_string "assert"
	| BOOLEAN            -> print_string "boolean"
	| BREAK              -> print_string "break"
	| BYTE               -> print_string "byte"
	| CASE               -> print_string "case"
	| CATCH              -> print_string "catch"
	| CHAR               -> print_string "char"
	| CLASS              -> print_string "class"
	| CONST              -> print_string "const"
	| CONTINUE           -> print_string "continue"
	| DEFAULT            -> print_string "default"
	| DO                 -> print_string "do"
	| DOUBLE             -> print_string "double"
	| ELSE               -> print_string "else"
	| ENUM               -> print_string "enum"
	| EXTENDS            -> print_string "extends"
	| FINAL              -> print_string "final"
	| FINALLY            -> print_string "finally"
	| FLOAT              -> print_string "float"
	| FOR                -> print_string "for"
	| IF                 -> print_string "if"
	| GOTO               -> print_string "goto"
	| IMPLEMENTS         -> print_string "implements"
	| IMPORT             -> print_string "import"
	| INSTANCEOF         -> print_string "instanceof"
	| INT                -> print_string "int"
	| INTERFACE          -> print_string "interface"
	| LONG               -> print_string "long"
	| NATIVE             -> print_string "native"
	| NEW                -> print_string "new"
	| PACKAGE            -> print_string "package"
	| PRIVATE            -> print_string "private"
	| PROTECTED          -> print_string "protected"
	| PUBLIC             -> print_string "public"
	| RETURN             -> print_string "return" 
	| SHORT              -> print_string "short"
	| STATIC             -> print_string "static"
	| STRICTFP           -> print_string "strictfp" 
	| SUPER              -> print_string "super"
	| SWITCH             -> print_string "switch"
	| SYNCHRONIZED       -> print_string "synchronized"
	| THIS               -> print_string "this"
	| THROW              -> print_string "throw"
	| THROWS             -> print_string "throws"
	| TRANSIENT          -> print_string "transient"
	| TRY                -> print_string "try"
	| VOID               -> print_string "void"
	| VOLATILE           -> print_string "volatile"
	| WHILE              -> print_string "while"
	| PLUS               -> print_string "plus"
	| MINUS              -> print_string "minus"
	| TIMES              -> print_string "times"
	| DIV                -> print_string "div"
	| AND                -> print_string "and"
	| OR                 -> print_string "or"
	| XOR                -> print_string "xor"
	| MOD                -> print_string "mod"
	| EQUAL              -> print_string "equal"
	| INF                -> print_string "inf"
	| SUP                -> print_string "sup"
	| CONDOR             -> print_string "condor"
	| CONDAND            -> print_string "condand"
	| INCR               -> print_string "incr"
	| DECR               -> print_string "decr"
	| COND               -> print_string "cond"
	| EXCL               -> print_string "excl"
	| TILDE              -> print_string "tilde"
	| ANNOT              -> print_string "annot"
	| ISEQUAL            -> print_string "isequal"
	| ISNOTEQUAL         -> print_string "isnotequal"
	| PLUSEQUAL          -> print_string "plusequal"
	| MINUSEQUAL         -> print_string "minusequal"
	| TIMESEQUAL         -> print_string "timesequal"
	| DIVEQUAL           -> print_string "divequal"
	| ANDEQUAL           -> print_string "andequal"
	| OREQUAL            -> print_string "orequal"
	| XOREQUAL           -> print_string "xorequal"
	| MODEQUAL           -> print_string "modequal"
	| INFOREQUAL         -> print_string "inforequal"
	| SUPOREQUAL         -> print_string "suporequal"
	| LSHIFT             -> print_string "lshift"
	| RSHIFT             -> print_string "rshift"
	| LSHIFTEQUAL        -> print_string "lshiftequal"
	| RSHIFTEQUAL        -> print_string "rshiftequal"
	| USHIFT             -> print_string "ushift"
	| USHIFTEQUAL        -> print_string "ushiftequal"
  | POINT              -> print_string "point"
  | SEMICOLON          -> print_string "semicolon"
  | COMMA              -> print_string "comma"
  | COLON              -> print_string "colon"
  | LBRACE             -> print_string "lbrace"
  | RBRACE             -> print_string "rbrace"
  | LPAREN             -> print_string "lparen"
  | RPAREN             -> print_string "rparen"
  | LBRACK             -> print_string "lbrack"
  | RBRACK             -> print_string "rbrack"
 

(* Function which read a buffer and print the recognized token *)

let rec read buffer = 
  let token = nexttoken buffer in
  print_string "Read line ";
  print_int buffer.lex_curr_p.pos_lnum;
  print_string " : ";
  print_token token;
  print_string "\n";
  token

}
>>>>>>> 640d5c3fba38716bc42823bf536e736a30b0ab04
