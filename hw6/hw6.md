# Homework 6: Concurrent programming, modules, and side effects
*CSci 2041: Advanced Programming Principles, Fall 2015*

**Due:** Friday, December 11 at 11:59pm

##1.  Bloom Filters

A _Bloom Filter_ is a probabilistic data structure that stores a set
of elements `e1, e2, ..., en` (which may be quite large) by hashing
each element `ei` to a set of k short integers `s1,...,sk` and storing
the set of short integers `S`.  To test whether an arbitrary element `x` is
in the bloom filter, we hash `x` to get short integers `t1,...,tk` and
then test whether all k of the values is present in `S`.  (So an
element that was added to the filter will always succeed in testing,
but some elements not added to the filter might also appear to be
present)  Bloom filters are used to improve cache performance in
[several widely deployed systems](https://en.wikipedia.org/wiki/Bloom_filter#Examples).

Here's a toy example: let `k=2` and let the hash functions be `h1(x) = x mod
29` and `h2(x) = x mod 31`.  Then to represent the 10 elements
`[22768; 56096; 22635; 49167; 62014; 633; 7033; 42149; 34900; 53486]`
we compute the 20 hashes `[3; 10; 15; 12; 12; 24; 15; 12; 13; 10]` and
`[14; 17; 5; 1; 14; 13; 27; 20; 25; 11]` to get the set
`S = [1; 3; 5; 10; 11; 12; 13; 14; 15; 17; 20; 24; 25; 27]`.  To test
whether some arbitrary element - for example, 6558 - is in the filter,
we compute `h1(6558) = 5` and `h2(6558) = 16`; we see that `S`
includes 5 but not 16, so 6558 is not in the filter.  On the other
hand, `h1(22898) = 17` and `h2(22898)=20` and since both 17 and 20 are
in `S`, 22898  is a "false positive," an element that appears
as present even though it was not added to the filter initially.

In this problem, we will write a functor that implements bloom
filters, parameterized by a set representation and a list of hash
functions.  Your solution should go in the file `bloom.ml`, which
contains a skeleton, with several helper functions already
implemented.

#### `hashparam` signature

The `bloom.ml` file contains a module signature,  `memset`, for
modules that define a set type and operations.  Add a signature
immediately below this named `hashparam` for modules that provide an
element type `t` and a function `hashes : t -> int list`.  (We'll
provide modules that implement this signature later)

####	`SparseSet` module

The `Set` module in the OCaml standard library provides the functor
`Set.Make` which, given a module providing an element type `t` and a
comparison function `compare` (such as the built-in
`Pervasives.compare`) creates a module that implements all of the
functionality of the `memset` signature *except* the function
`from_list`.  Define a module, `SparseSet`, which uses inclusion and
Set.Make to implement the `memset` interface with elements of type
`int`.  (The entire definition should use approximately four lines of
code: you can implement from_list quite succinctly with a fold)

#### `BitSet` module

When a bloom filter has only a few elements, explicitly representing
the elements with a `SparseSet` will be time- and space-efficient, but
a bloom filter with many elements typically represents a set as a bit
sequence using a random access data structure like an array,
or string.   For this problem, since we haven't studied OCaml's
implementation of arrays, we'll define a module, `BitSet` that
represents sets of small integers using strings as bit sequences:  to
decide if a string `s` contains the bit `i`, we access the character
`s.[i/8]` (since each char has 8 bits) and extract the `i mod 8`-th
bit of that character; if the bit is on, `i` is in the set, and
otherwise it is not.

This representation is space-efficient when the sets are large and
also allows for efficient logical operations on sets (e.g. the union
of two sets is the character-wise logical or (`lor`) of their strings;
the intersection is the character-wise logical and (`land`)).
`bloom.ml` has an incomplete implementation of some of the helper
functions needed to create the `BitSet` module.  You'll need to complete the
definition so that a BitSet implements the `memset` signature with
exposed `elt` type:

+ Change the module declaration to impose the `memset` signature and
correctly expose the type of `elt`.

+ Add a (local) helper function to `BitSet` implementing `(&@)` (the
characterwise logical and of strings).

+ Add a (local) helper function `make_str_t : int -> string -> string`
  to `BitSet` so that `make_str_t i ""` returns a string
  representing the singleton set `{ i }`.  

+ Provide definitions for the `memset` signature, e.g. `empty,
  is_empty, mem, add, union, inter, from_list`.

#### `BloomFilter` functor

At this point we're ready to fill in the definition of the
`BloomFilter` functor: `bloom.ml` already provides the basic syntax
for the functor definition.  However, you'll need to:

+ modify the declaration slightly with sharing constaints in order to
  make the code compile and allow creation of `BloomFilter`s with
  accessible (non-abstract) elements.

+ provide definitions for the functions in the memset signature, by
  storing an element `e` as the list of hashes output by `(H.hashes
  e)` in a set implemented by the module `S`, and checking for
  membership of `x` by checking that elements of `(H.hashes x)` are
  all present in the underlying set.  These should all be fairly
  simple calls to functions provided by the module S or H, possibly in
  combination with folds and maps as needed.

#### `IntHash`

The `bloom.ml` file already contains one definition of a module
satisfying the `hashparam` interface, the `StringHash` module.  Below
this, add a definition for a second module satisfying `hashparam`, the
`IntHash` module.  The type `t` in `IntHash` will be `int`, and
`hashes n` should evaluate to the list `[(h1 n) ; (h2 n); (h3 n)]`,
where `h1(n) = (795*n + 962) mod 1031`,  `h2(n) = (386*n + 517) mod
1031`, and `h3(n) = (937*n + 693) mod 1031`.

#### Testing driver

Now let's write a "driver" program to test out our BloomFilter
implementations.  Add a separate file named `bloomtest.ml` to the
`hw6` directory in your repo.  This file should contain a complete
OCaml program that does the following:

+ Instantiate a `BloomFilter` module, `BloomSparseInt`, using `SparseSet`
and `IntHash`
+ Instantiate a `BloomFilter` module, `BloomBitInt`, using `BitSet`
  and `IntHash`.
+ Create a list `insert_list` of 200 random integers between 0 and 2<sup>30</sup>-1
 using the function `Random.int`.
+ Create a `BloomSparseInt.t` from `insert_list`; time how long this
  creation takes using `Sys.time ()` (Hickey has an example using this
  function in Section 7.4)
+ Create a `BloomBitInt.t` from `insert_list`; time how long this
creation takes using `Sys.time ()`
+ Create a list `test_list` of 1 million random integers between 0 and
2<sup>30</sup>-1.
+ Time how long it takes to test for each of these integers using
  `BloomSparseInt.mem` and count the number of false positives
  (you don't need to check whether a member of `test_list` was actually
  in `insert_list`; we'll just assume all elements that test out as
  true are false positives)
+ Time how long it takes to test for each element of `test_list` using
`BloomBitInt.mem`, while also counting false positives.  (The false
positive count should be the same regardless of the underlying set
implementation.)
+ Instantiate another BloomFilter module, `BloomSparseString`, using
`SparseSet` and `StringHash`.
+ Instantiate another BloomFilter module, `BloomBitString`, using
`BitSet` and `StringHash`.
+ Read the list of the 2048 most-visited websites from the file
`top-2k.txt` into a list of strings, `insert_list`.  (See homework 1
or homework 3 for examples of functions that can return a list of the
strings in a file given the file name)
+ Read the list of the top 1 million - 2048 most-visited websites from
the file `top-1m.txt` into a list of strings, `test_list`.
+ Time how long it takes to create at `BloomSparseString.t` from
`insert_list`.
+ Time how long it takes to create a `BloomBitString.t` from
`insert_list`.
+ Time how long it takes to test for each string in `test_list` using
`BloomSparseString.mem`, counting the number of false positives.
+ Time how long it takes to test for each string in `test_list` using
`BloomBitString.mem`, counting the number of false positives.
(If you've noticed a pattern and would like to save yourself some
typing, feel free to encapsulate the core of this routine in a Functor)
+ Finally, print out a formatted report as follows:
```
% ./ocamlbuild -lib str bloomtest.native
Finished, 7 targets (7 cached) in 00:00:00.
%./bloomtest.native
SparseInt      : build time =   0.0002s test time =   0.6476s false positives = 200350
BitInt         : build time =   0.0065s test time =   0.1254s false positives = 200350
SparseString   : build time =   0.0158s test time =   1.1379s false positives = 13658
BitString      : build time =  76.9395s test time =   0.1439s false positives = 13658
```

##2.  The one with the chat server

In this problem we'll use the `Lwt` concurrency library; you can find
the documentation [here](https://ocsigen.org/lwt/2.5.0/api/).  To
interact with `Lwt` in `utop`, you'll need to `#require
"lwt.simple-top" ;;` (or add this line to your ocamlinit file) and to
build binaries using `Lwt`, you'll need to pass `ocamlbuild` the
command-line option `-pkgs lwt,lwt.unix`.

We're going to build a _server_ that allows people to (text) chat with
each other over the internet.  The protocol will be similar to
[Internet Relay Chat (IRC)](https://en.wikipedia.org/wiki/Internet_Relay_Chat)
with a little less functionality.  Since this is a class homework,
we'll use the command-line program `telnet` for a _client_ instead of
developing a fancier interface.  The file `chatSrv.ml` contains a
skeleton for the server we'll develop.  (Right now, it's pretty
boring: if you build and run `chatSrv.native` it will listen for and
accept network connections, but won't do anything with the user's
input, or write anything at all.)

Ultimately we want to be able to support interactions like the
following:

On the server:
```
hoppernj@apollo (/home/hoppernj) % ocamlbuild -lib str -pkgs lwt,lwt.unix chatSrv.native
Warning: tag "package" does not expect a parameter, but is used with parameter "lwt.unix"
Warning: tag "package" does not expect a parameter, but is used with parameter "lwt"
Finished, 4 targets (0 cached) in 00:00:08.
hoppernj@apollo (/home/hoppernj) % ./chatSrv.native 
```

On Alice's machine:
```
alice@remote06 (/home/alice) % telnet apollo.cselabs.umn.edu 16384
Trying 128.101.38.191...
Connected to apollo.cselabs.umn.edu.
Escape character is '^]'.
Enter initial nick:
alice
bob: <joined>
carol: <joined>
hi everyone!
bob: hi alice.
/n whiterabbit
/l
whiterabbit
carol
bob
bob: ooh nice.
carol: i'm outta here.
carol: <left chat>
bob: rude.
well it's only an example.
/q
Connection closed by foreign host.
```

On Bob's machine:
```
bob@remote08 (/home/bob) % telnet apollo.cselabs.umn.edu 16384
Trying 128.101.38.191...
Connected to apollo.cselabs.umn.edu.
Escape character is '^]'.
Enter initial nick:
bob
carol: <joined>
alice: hi everyone!
hi alice.
alice: <changed nick to whiterabbit>
ooh nice.
carol: i'm outta here.
carol: <left chat>
rude.
whiterabbit: well it's only an example.
whiterabbit: <left chat>
/q 
Connection closed by foreign host.
```
On Carol's machine:
```
carol@atlas (/home/carol) % telnet apollo.cselabs.umn.edu 16384
Trying 128.101.38.191...
Connected to apollo.cselabs.umn.edu.
Escape character is '^]'.
Enter initial nick:
carol
alice: hi everyone!
bob: hi alice.
/l
carol
bob
alice
alice: <changed nick to whiterabbit>
bob: ooh nice.
i'm outta here.
/q
Connection closed by foreign host.
```

### Welcome message, and getting the user's nickname

When a user connects to the chat server, chatSrv.ml calls the function
`Server.chat_handler` with a pair of `channel` values: the first (`inp`) is
an `input_channel` and the second (`outp`) is an `output_channel`.
The `main_loop` helper function inside the module uses the `Lwt`
*bind* operator `>>=` to read a line of input from `inp` (the user's
network connection) and call `handle_input` with this line when it is
available; whenever the actions initiated by `handle_input` complete,
`>>=` is used to call `main_loop` again.  However, before
`chat_handler` invokes `main_loop`, a few set-up operations should
take place.  Find the line `let _ = ()` in `chat_handler` and add code
that does the following:

+ Print a welcome message to `outp` (using one of the `Lwt_io.print`
  functions) asking the user for a "nick"(name) they will use in the chat
  session. (It's a technical term, honest!)
+ Read the user's nickname from `inp` using `Lwt_io.read_line`. Assign
  the new value to the name `nick`.
+ The `Server` module maintains a reference to an associative list, `sessions`
  mapping each user's nicknames to her output channel (so that when a
  message is sent to other users, she doesn't see her input twice)
  Once we know the user's nickname, update `sessions` to include the
  new user and output channel pair.
+ Finally, announce that the user has joined the chat (to any other
  users) by calling `broadcast` with the user's nickname and the
  message `"<joined>"`. (We'll fill in the `broadcast` function next.)

### `broadcast`
Whenever a user enters a message, joins the chat, or leaves the chat,
we'll want to tell the other participants in the chat using the
`broadcast` function.  We could step through the `sessions` list in
order, sending the message to each user once the previous message has
been sent, but this might take a considerable amount of time -- imagine
if one or more users is overseas or using dial-up internet.
Fortunately, `Lwt` provides the useful function `Lwt_list.iter_p`,
which takes a function, applies this function to every time in the
list in parallel "threads", and then waits for all of the threads to
finish before passing `()` to the next thread.  Change `broadcast` to
use `Lwt_list.iter_p` to write a line of the form `sender: message` to
every user but the sender in the `!sessions` associative list.  (The
function passed to `iter_p` should execute `Lwt.return ()` when the
session associated with the `sender` nick is encountered)

At this point we're starting to get a useful server: try building and
running `chatServ.native`, and in separate terminals (but the same
machine) try `telnet localhost 16384`, entering distinct nicks.  You
should be able to carry out a lively conversation with yourself.
(Recruit a friend if this feels too eccentric) One more tip: you can
end a telnet session on the client side by typing ctrl-] and then
entering q at the telnet prompt.

### Modify `handle_input` and associated helpers
The actual IRC protocol allows a wide variety of actions by users;
we'll support three: q(uit), n(ew nickname), and l(ist users).  Modify
`handle_input` so that it checks to see if the input starts with one
of the following commands:

+ The `quit` command, `/q`: quitting should cause the user's thread to
  close the input and output channels, then remove the user from the
  `sessions` list. Note that `main_loop` is bound to the
  `handle_input` thread, so you'll need to use a nonlocal control flow
  mechanism here.  (Hint: the main body of `chat_handler` calls the
  `handle_error` function with any exceptions that are thrown in the
  `main_loop` thread.)
  
+ The `newnick` command, `/n`: allows a user to change her `nick` to
  the string following ``/n ``.  You should add code that calls
  `change_nn` with the correct inputs and modify `change_nn` to update
  the session list, notify the other users, and update the `nick`
  reference from `chat_handler`.

+ The list users command, `/l`: lists all users connected to the
  server. Hint: the `Lwt_list.iter_s` function provides a convenient way to
  iterate over the `!sessions` list and perform some action for each
  `(nickname,channel)` pair.

(You might find the library functions `Str.string_after` and
`Str.string_before` useful for this portion of the assignment.)

### Do something fun!
You're almost done with your last 2041 homework, it's time to do
something for fun.  Copy your completed `chatSrv.ml` to another file:
`funSrv.ml`.  Add an interesting/fun/useful piece of functionality to
`funSrv.ml`, and include a comment at the top explaining what
libraries your code needs (so we can build and test it out) and what
it does.  (A few ideas: add timestamps to messages and color-code
different users' messages; add support for private messages from one
user to another; add connection logging on the server; support
multiple chat rooms; support registered nicknames...)

## All done!

Don't forget to commit all of your changes to the various files edited
for this homework, and push them to (the `hw6` directory in) your individual class repository
on UMN github:

+ `bloom.ml`
+ `bloomtest.ml`
+ `chatSrv.ml`
+ `funSrv.ml`

You can always check that your changes haved pushed
correctly by visiting the repository page on github.umn.edu.
