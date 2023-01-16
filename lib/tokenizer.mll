{
  open Parser
  let debug = true

  let token_debug t debug = match debug with
    | true -> Printf.printf "token: %s\n" t;
    | false -> ();;

}
let identifier_starter = ['a' - 'z' 'A' - 'Z' '_']
let digit = ['0'-'9']
rule token = parse
  | [' ' '\t' '\n']+ { token lexbuf (* This odd semantic construction is
                                       invoking the lexer recursively,
                                       starting with the spot in the input
                                       where we saw one of the matching
                                       characters. Essentially we are
                                       skipping the character we just
                                       matched.
                                     *) }
  | '{'		{ token_debug "OPEN_BRACE" debug; OPEN_BRACE }
  | '}'		{ token_debug "CLOSE_BRACE" debug; CLOSE_BRACE }
  | '('		{ token_debug "OPEN_PAREN" debug; OPEN_PAREN }
  | ')'		{ token_debug "CLOSE_PAREN" debug; CLOSE_PAREN }
  | '$'		{ token_debug "DOLLAR" debug; DOLLAR }
  | '='		{ token_debug "EQUAL" debug; EQUAL }
  | ':'   { token_debug "COLON" debug; COLON }
  | ','   { token_debug "COMMA" debug; COMMA }
  | ['0' - '9' 'a' - 'f' 'A' - 'F']+ as byte {token_debug (Printf.sprintf "BYTE: %s" byte) debug; BYTE byte}
  | '"' ([^'\n']*) '"' as strtok { token_debug (Printf.sprintf "STRING: %s" strtok) debug; STRING strtok }
  | "condition"		{ token_debug "CONDITION" debug; CONDITION }
  | "strings"		{ token_debug "STRINGS" debug; STRINGS }
  | "meta"		{ token_debug "META" debug; META }
  | "rule"		{ token_debug "RULE" debug; RULE }
  | "and"     { token_debug "AND" debug; AND }
  | "or"      { token_debug "OR" debug; OR }
  | "not"      { token_debug "NOT" debug; NOT }
  | "<-"      { token_debug "INHERIT" debug; INHERIT }
  | identifier_starter+ as identifier { token_debug (Printf.sprintf "IDENTIFIER: %s" identifier) debug; IDENTIFIER identifier }
  | eof		{ EOF }
