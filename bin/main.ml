open Yarafront
let main () =
  try
    let lexbuf = Lexing.from_channel stdin in Yarafront.Parser.ruleset Yarafront.Tokenizer.token lexbuf
  with End_of_file -> exit 0
      
let _ = Printexc.print main ()
