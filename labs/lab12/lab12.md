# Lab 12: Concurrent Programs

*CSci 2041: Advanced Programming Principles, Fall 2015*

**Due:** Wednesday, December 2 at 11:59pm.


## Ground rules

You must work with a partner on this lab.  Although labs are meant to
be an open and collaborative environment, it is the responsibility of
both partners to contribute to learning the materials in every lab.
In particular, both partners are responsible for ensuring that submissions are
received by the due date, and for letting us know if one teammate does
not participate in a given lab.

# Introduction: Goals for this lab

+ See and work through some examples using the `Lwt` concurrency library

+ Learn a little about internet protocol "servers."

## Answering the questions in this lab

Create a `lab12` directory in your team repository and copy the files
`threadBasics.ml` and `echoSrv.ml` to this directory; we'll work with
the contents of these files in the following sections.

## Fun with Threads

In this lab we'll be working with the `Lwt` concurrency library; in
order for the code examples to work in `utop`, you'll need to execute
the directive `#require "lwt.simple-top";;` and in order to build
executables using the library you'll need to tell ocamlbuild to use
the package with `ocamlbuild -pkgs lwt,lwt.unix`.

`Lwt` is a library for structuring programs to run in concurrent
threads; for more about the abstractions and functions we use in this
lab you can (and should) look at the [online documentation](https://ocsigen.org/lwt/2.5.0/api/Lwt).
The basic ideas behind `Lwt` are:
+ The type `'a Lwt.t`: this represents a thread of execution that when
  completed, will compute a value of type `'a`.  (So `Lwt.t` is a type
  constructor like `list` or `lazy_t`.) Some threads complete
  immediately, others may never complete, and some wait for external
  events or might take time to compute.

+ The `bind` function, which is usually replaced by the infix operator
  `>>=`: if `t1` is a `'a Lwt.t` (thread that will compute a value of
  type `'a`) and `t2` has type `'a -> 'b Lwt.t` (that is, it takes an
  input of type `'a` and results in a thread that will compute a value
  of type `'b`), then `t1 >>= t2` is a `'b Lwt.t`: a thread that will
  compute a value of type `'b` by running `t1` to get a value `v1` and
  then evaluating `t2` with input `v1`.  This might sound confusing,
  but here's an example:
```
open Lwt
let t1 = Lwt.return 42
let t2 = fun a -> Lwt.return (a+21)
let t3 = t1 >>= t2
```
  In this example, `t1 : int Lwt.t` is a thread that when executed,
  computes the integer value `42`; `t2 : int -> int Lwt.t` takes as input a value `a` and
  returns a thread that will compute `a+21`, and `t3 : int Lwt.t` is a
  thread that will compute the integer value `42+21` when run.

+ `Lwt` provides several ways to create threads; we've already seen
  `Lwt.return : 'a -> 'a Lwt.t`, which creates a thread that returns
  its argument.  `Lwt.pause ()` creates a thread which waits for the
  `Lwt` scheduler to run (on which, more below...) and then holds
  `unit`.  `Lwt.wrap f` turns a function `f : unit -> 'a` into a
  thread that will compute `f ()`. `Lwt_list` contains functions that
  turn higher-order list operations into threads. `Lwt_unix.sleep`
  creates a thread that will compute a value of type `unit` in a given
  number of seconds.

+ the `Lwt_io` module provides the type `channel` that represents a
  file or network connection that can be read from or written to.  The
  `Lwt_io.read_line` function creates a thread that will compute a
  string by reading a line of input from a channel, and the
  `Lwt_io.write` and `Lwt_io.print` functions create threads that will
  compute a value of type `unit` by writing to an output channel.

+ The `Lwt_main.run` function wakes up any sleeping threads, and runs
  a thread to completion, returning the result computed by the thread.
  (This function should *not* be called within a thread; it invokes
  the "thread scheduler" which repeatedly determines which threads have computed
  results, and chooses on of the threads bound to those threads to execute
  next, until that thread computes a result or "yields" to the
  scheduler by calling `Lwt.yield`, `Lwt.pause`, or some function that
  requires external events to complete like i/o or a timer).  The
  `Lwt.async` function starts the computation of a thread and does not
  wait for it to finish.  To combine threads, the `Lwt.choose`
  function starts a list of threads and finishes when one of them
  completes (whether the others complete or not), while the `Lwt.join`
  function starts a list of threads and waits for all of them to
  complete. The `Lwt.wait` function returns a pair of threads; the first
  waits forever unless it is woken by running the other.

+ By now you might be wondering *How do I get the value a thread has
  computed?* Although `Lwt_main.run` returns the result of a thread, this
  is usually not the answer: instead, the value computed in one thread
  is obtained by binding the thread to the next step, which receives
  the value as input.  Communication between threads *can* be achieved
  using mutable values, which we'll learn about in a few more
  lectures, but this can result in the reasoning difficulties
  explained in lectures 29 and 30.

### Time to write a bit of `Lwt` code

In `threadBasics.ml` let's create a program that has two threads of execution:

+ The first thread is created by a function `snooze : float -> unit ->
  unit Lwt.t`.  `(snooze s ())` should sleep for `s` seconds, print an
  alarm message of your choosing (e.g. "WAKE UP YOU NEED TO MAKE
  MONEY" or "wake up, buttercup!" or "rise and shine!") and then
  `(snooze s)` again.  (`Lwt_unix.sleep` and `Lwt_io.printl` will be
  useful here)

+ The second thread is created by a function `pick_out : (int*bool)
  list -> unit Lwt.t`.  This function creates a thread that iterates
  through a list of `(i,b)` pairs in order and prints out the integer values
  associated with `true`.  The function `Lwt_list.iter_s` will be
  useful here. 

`threadBasics.ml` includes some code that starts these threads and
waits for both to complete (although this never happens...)

You can test out the program by building with `ocamlbuild -pkgs
lwt,lwt.unix threadBasics.native` and running `./threadBasics.native`.

## Is there an echo in here?

One of the standard "hello world" examples for a concurrency library is
an *echo server*: a program that listens for network connections,
accepts any incoming connection, and then repeats back (or "echoes")
whatever input it receives.  The file `echoSrv.ml` contains a very
basic echo server example using `Lwt`.  Line 10 kicks things off by
asking `Lwt` to open a *socket*, an OS abstraction that allows a
program to treat a network connection as if it were a file, on the
network address (`Unix.inet_addr_any`) of the machine the program is
run on, listening to the *port* 16384.

> Ports are 16-bit addresses given to programs running on a particular
> computer by the Internet Protocol; a program may request any address
> at all from the operating system, but usually port numbers less than
> 1024 are reserved for OS services and won't be granted; and requests
> for a port that is already in use by another application will also
> fail.  If you run the echo server and get an exception it might be
> for this reason; go ahead and replace 16384 by another number
> between 1025 and 65535 in the code and the rest of this section.

When another program (either on the same computer or another
Internet-connected computer) requests a connection to port 16384, the
`Lwt.establish_server` function calls its second argument (in this
case `echo_handler`) with a pair of channels; the first channel is an
input channel and will read any data sent to the program over the
network, and the second is an output channel and any data written to
it will be sent over the network to the other program.

The `echo_handler` function starts an *asynchronous* (think
background) thread (by calling the local function `main_loop` with
`Lwt.async`) that just reads data one line at a time from the input
channel and writes ("echoes") that data back to the output channel.

This continues until the network connection is closed, which causes an
exception to be thrown when `main_loop` tries to read or write to the
channels.  Since `main_loop` is called by `catch`, the exception will
be handled by calling the second argument to `Lwt.catch` with the
exception as an argument (And being a minimal echo server, the handler
here just ignores the exception and returns with `Lwt.return ()`)

You can test out the echo server by opening two terminal windows:

+ In the first terminal window cd to your `lab12` directory, then build the server and start it up:
```
user1234@host (../lab12) % ocamlbuild -pkgs lwt,lwt.unix echoSrv.native
Warning: tag "package" does not expect a parameter, but is used with parameter "lwt.unix"
Warning: tag "package" does not expect a parameter, but is used with parameter "lwt"
Finished, 4 targets (0 cached) in 00:00:00.
user1234@host (../lab12) % ./echoSrv.native
```
+ In the second terminal window, after starting the echo server, you
  can connect to it using `telnet`, which is an application that reads
  line input from the terminal and sends it over a network connection,
  while also printing any data it receives from the network
  connection.  `telnet` takes a host name or IP address to connect to
  and a port number as command line arguments.  We'll use `localhost`
  which is always a valid host name for the computer a program is
  running on and 16384, the port the echo server listens on:
```
user1234@host (/home/user1234) % telnet localhost 16384
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
Some stuff I typed in just now.
Some stuff I typed in just now.
More stuff.
More stuff.
After this line, I'll type control-] and q to quit the telnet application
After this line, I'll type control-] and q to quit the telnet application
^]
telnet> q
Connection closed.
user1234@host (/home/user1234) %
```

Don't forget to kill the server in the first terminal window by typing
control-C.

### Modifying the server

While there's nothing _wrong_ with the design of the minimal echo
server, being minimal, typical network applications have a protocol
where the client and server agree that a connection has ended before
closing the connection.  Let's modify `echoSrv.ml` to allow the user
to indicate her intent to close the connection by entering a line that
starts with `/q`:

+ Add a new exception, `Quit`, to `echoSrv.ml`.

+ Add a new function to `echoSrv.ml`, `close_channels :
  Lwt_io.input_channel -> Lwt_io.output_channel -> 'a Lwt.t`.  This
  function will create a thread that closes its first argument (using `Lwt_io.close`), then
  closes its second argument, then exits the thread by raising
  the `Quit` exception using `Lwt.fail`.  (Due to the implementation
  of exception handling in `Lwt`, exceptions inside threads should be
  raised by calling `Lwt.fail E` and not `raise E`.)

+ Modify `echo_handler` to define another local function,
  `handle_input : string -> unit Lwt.t` that will check if a line of input starts with `/q`,
  and take appropriate action (either close the network connection or write
  the line to `outp`).  One way to handle this check is using the
  `Str.string_before` function; feel free to do so, but remember
  you'll need to include `-lib str` as an argument to `ocamlbuild`
  when building your program.

+ Modify `main_loop` to bind `handle_input` to the result of
  `Lwt_io.read_line` instead of the `write_line` thread.

You can test out your modified echo server as above.  (Feel free to
insert your own cheesy dialog with your workstation)

# Commit and push so that everything is up on GitHub

Now you need to just turn in your work. Commit your `threadBasics.ml`
and `echoSrv.ml` files and push them up to your central GitHub repository. 

Verify that this worked, by using your browser to see the changes on
https://github.umn.edu.

If you do not properly push your changes to the repository we
cannot give you credit for the lab, so please remember to do this
step!

__This concludes lab 12.__

**Due:** Wednesday, December 2 at 11:59pm.

Note that any required changes must exist in your repository on
github.umn.edu. Doing the work but failing to push those changes
to your central repository will mean that we cannot see your work
and hence can't grade it.
