(* this line makes the lwt bind infix operator available in scope *)
open Lwt

(* the code to handle connection ending goes here: *)
exception Quit

let close_channels inp outp = 
	Lwt_io.close inp >>= fun () -> (* Close first argument *)
	Lwt_io.close outp >> = fun () -> (* Close second argument *)
	Lwt.fail  Quit (* raise exception *)

let echo_handler (inp,outp) =
  (* Here, before main_loop, is where we'll add the input line handler: *)
  let handle_input str = if ( (Str.string_before str) = "/q" ) then Lwt.fail Quit else  
  let rec main_loop () =
    Lwt_io.read_line inp >>= fun l ->
    Lwt_io.handle_input l >>= main_loop in
  Lwt.async (fun () -> Lwt.catch main_loop (fun e -> Lwt.return ()))
								 	    
let s = Lwt_io.establish_server (Unix.ADDR_INET(Unix.inet_addr_any, 16384)) echo_handler
let _ = Lwt_main.run (fst (Lwt.wait ()))
