open Lwt

module Server = struct
    (* a list associating user nicknames to the output channels that write to their connections *)
    (* Once we fix the other functions this should change to []*)
    let sessions = ref [("",Lwt_io.null)]	     
    exception Quit
		
    (* replace Lwt.return below with code that uses Lwt_list.iter_p to 
       print sender: msg on each output channel (excluding the sender's)*)
    let rec broadcast sender msg = let iter (s,m) = 
        if s <> sender then Lwt_io.write_line m (sender ^ ": " ^ msg)
        else Lwt.return()
    in Lwt_list.iter_p iter !sessions

    (* remove a session from the list of sessions: important so we don't try to 
       write to a closed connection *)
    let remove_session nn = 
      sessions := List.remove_assoc nn !sessions;
      broadcast nn "<left chat>" >>= fun () ->
      Lwt.return ()

    let endThisSession nn = sessions := List.remove_assoc nn !sessions

    (* Modify to handle the "Quit" case separately, closing the channels before removing the session *)
    let handle_error e nn inp outp = sessions := List.remove_assoc nn !sessions ; Lwt.return()

    (* modify sessions to remove (nn,outp) association, add (new_nn,outp) association.
       also notify other participants of new nickname *)
    let change_nn nn outp new_nn = (
        endThisSession nn ;
        sessions := ((new_nn, outp)::!sessions) ;
        broadcast new_nn ("<" ^ nn ^ " change nick to " ^ new_nn ^ ">"))
    
    let chat_handler (inp,outp) =
      let nick = ref "" in
      (* replace () below with code to 
         + obtain initial nick(name), 
         + add (nick,outp) to !sessions, and 
         + announce join to other users *) 
      let initiate = Lwt_io.write_line outp "Enter initial nick:" >>=
          fun () -> Lwt_io.read_line inp >>= 
              fun l -> (nick := l ; broadcast l "<joined>") ;
                        sessions := ((l, outp)::!sessions) ; Lwt.return() in
      (* modify handle_input below to detect /q, /n, and /l commands *)
      let handle_input l = match (Str.string_before l 2) with
      | "/q" -> Lwt_io.close inp >>= fun () -> Lwt_io.close outp >>= fun () -> remove_session !nick
      | "/n" -> let new_nn = Str.string_after l 3 in change_nn !nick outp new_nn >>= fun () -> (nick := new_nn ; Lwt.return ())
      | "/l" -> let helper (n, o) = Lwt_io.write_line outp n in Lwt_list.iter_p helper !sessions
      | _ -> broadcast !nick l in

      let rec main_loop () = match (!nick) with
      | "" -> initiate >>= main_loop
      | _ -> Lwt_io.read_line inp >>= handle_input >>= main_loop in
      Lwt.async (fun () -> Lwt.catch main_loop (fun e -> handle_error e !nick inp outp))
  end

let port = if Array.length Sys.argv > 1 then int_of_string (Sys.argv.(1)) else 16384		  
let s = Lwt_io.establish_server (Unix.ADDR_INET(Unix.inet_addr_any, port)) Server.chat_handler	    
let _ = Lwt_main.run (fst (Lwt.wait ()))
let _ = Lwt_io.shutdown_server s (* never executes; you might want to use it in utop, though *)
