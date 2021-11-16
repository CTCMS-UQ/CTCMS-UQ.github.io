---
layout: page
title: "Advanced Linux command-line usage"
author: "Emily Kahl"
categories: linux command-line 
---

This guide is for those who have some level of familiarity with bash (or some other Mac or Linux shell),
either because you've read our [introductory guide](link_goes_here) or because you've used the command
line for a while and want to know more. In either case, welcome. This guide will be a little bit less
structured than the introductory one, as it will serve as a grab-bag of useful tips and tricks to make
you more efficient when using the shell.

# Table of Contents
{:.no_toc}

* TOC
{:toc}



# Return values and exit statuses
If you've ever written a C program, you may have noticed that you need to end the main function with a
`return()` or `exit()` statement, which should return an integer value. In the context of 
shell-scripting, the return value of a program's main function is called its *exit status*, which can be
used in conditionals to check whether a program finished successfully or not.

The main Unix convention is that an exit status of `0` indicates that a program completed successfully,
while any other value indicates that an error occurred. You can always assume that a "standard" Linux
utility will follow this convention and you should follow it in your own programs whenever possible
(this is not just limited to C, bash scripts can have exit statuses as well).
Unfortunately, there are no conventions as to the meaning of nonzero statuses: often an exit status of
`1` is used as a catch-all error status, but individual programs assign their own meanings. If you need
to check for a specific error condition, you'll need to consult the program's documentation or man page 
beforehand. If you're writing a C program, it's a good idea to use the preprocessor defined constants
`EXIT_SUCCESS` and `EXIT_FAILURE` (defined in `stdlib.h`) when exiting the program, since the compiler
should set them to a sensible value for your target platform.

# Loops
Bash allows you to loop over sequences, which could be elements of an array, ranges of numbers or
sub-units of a string. The general syntax is:
```
for <index_var> in <sequence>
do
    # Do work and access $index_var here
done
```
where `index_var` can have any name, and should only be accessed inside the body of the loop. As bash 
steps through the loop, `index_var` will take on the value of each successive element of the sequence.

For example, we can make a for loop over indices by writing:
```
for i in {1..10}
do
    echo $i
done
```
Since each line is its own separate command, we can squash a loop into one line by using semicolons (";")
to delimit commands:
```
for i in {1..10}; do echo $i; done
```

Also note that integer ranges in bash can start and stop at any value and can have non-unit step sizes
via the syntax `{start..end..increment}`, so to loop from 0 to 10 in increments of 5 you would write
`{0..10..5}`.

# Conditionals
Conditionals (if-then-else statements) in bash are implemented with the somewhat unusual syntax:
```
if <COND1>
then
  # Do work here
elif <COND2>
then
  # Do something else
else
  # Do yet something else
fi
```
The `fi` statement is equivalent to `endif` in other languages, and the `elif` and `else` branches are
optional.

The actual comparison operation must be encased in one of the following brackets:

- `[[ COND ]]` is for string comparisons
- `(( COND ))` is for numerical (arithmetic) comparisons
Note that the spaces between the conditional and the brackets is important.

Bash accepts the common comparison operators: `>`, `<`, `==`, `!=`. There are also some shell-specific
conditionals such as checking whether a file exists `[[ -e filename ]]`, a full list of which can be 
found in the [GNU bash online
manual](https://www.gnu.org/software/bash/manual/html_node/Bash-Conditional-Expressions.html). [^1]

[^1]: Note that the `[` and `[[` brackets are *not* simply syntax for if-statements. `[` is a 
    full-fledged bash *command*, which takes a logical statement to evaluate and returns either `true` 
    or `false`. It is perfectly possible to construct an if-statement without using square-brackets, 
    such as when making conditionals based on the exit status of a program (confusingly, in bash `0` 
    evaluates to `true` since an exit status of zero indicates success). The fact that `[` is a command,
    coupled with bash's syntax separating command-line arguments by spaces, also explains why there must
    be spaces after the `[[`, the values and the comparison operator.

To give a concrete examples, we can compare the string values of variables by doing:

```
if [[ VAR1 == VAR2 ]]
then
  echo "Variables are equal"
else
  echo "Variables are not equal"
fi
```

whereas to compare the numerical values of two variables we would instead write:

```
if (( N > 0 ))
then
  echo "N greater than zero"
fi
```

Finally, an important and common gotcha to avoid: we didn't put "$" in front of variables in 
comparisons, which is different to the usual way to access variables. You technically *can* use `$VAR`,
but the conditional will still work as expected without it, and using a "$" in the conditional will 
break if the variable is uninitialised or non-existent.

# Arrays
Bash has arrays, which have the syntax `things=(thing1 thing2 thing3)` and can be looped through by
doing 

```
for thing in ${things[@]}
do
  echo $thing
done
```
Looping over arrays will work even if the individual elements contain whitespace or special characters 
in their names, which is safer than looping over plain text (which is split on whitespace when used in a
loop). Unfortunately, it is not possible to return arrays from a function or program, so they're only
really useful for local variables.

# Advanced use of find
The `find` utility is very useful for searching through the file system, but it has many more uses than those outlined in our [introductory tutorial](/intro-linux/). For starters, `find` has multiple types of
tests you can use to further refine the search:

- `-name`: search for files whose name matches a given pattern. The pattern can contain wildcard
  characters (using [regular expression 
  syntax](http://web.mit.edu/hackl/www/lab/turkshop/slides/regex-cheatsheet.pdf)) and must be contained
  in quotation marks to prevent bash from attempting to expand it. 
- `-type`: search based on file type, which is represented by a single character. The three most common
  types you're likely to need are `f` for regular file, `d` for directory and `l` for symbolic link
  (discussed later in this guide).
- `-mtime n`: search for files based on the time (in 24 hour blocks) they were last modified. The
  parameter `n` (which must be an integer) can be
  prefixed with a "+" or "-" which modifies the time period searched for: `+n` will search for files 
  accessed *more* than `n` days ago, `-n` will search for files accessed *less* than `n` days ago and
  `n` will search for files accessed *exactly* `n` days ago. Note that this is not the same as searching
  for when a file was created, modifying an old file will update its `mtime` but not its creation time
  (there isn't really a way to test file creation time which works across all systems).
- `-mmin n`: similar to `mtime`, but the modification time is measured in minutes rather than days.

Multiple tests can be specified in a single `find` command to further narrow the search, with each test
requiring its own flag (even if multiple tests of the same type are used, such as `find -name "*foo*"
-name "*bar*"`). By default, specifying multiple tests will search for files which match *all* tests,
but this behaviour can be modified through the use of the logical operators `-o` (OR) and `-a`. For
example, if we wanted to list all files with the extension `.txt` or `.dat`, then we can combine the
two queries with `-o` to get:

```
find . \( -name '*.txt' -o -name '*.dat' \)
```

Note the backslash ("\\") preceding the brackets. Brackets have a special meaning in bash, so we must 
quote them to prevent bash from trying to interpret them as an arithmetic conditional. Furthermore, the 
quotations around the
wildcards are to ensure that they are passed directly to `find`: unquoted, bash would expand them to
provide a list of files matching the pattern *in the current directory*, which would then be passed to
`find` (which is not what we want to do). Multiple logical operators can be chained together, with the
resulting query following de Morgan's laws of Boolean algebra (e.g. expanding bracketed expressions). 
For example, if we wanted to list all files ending with `.txt` or `.dat` *and* were accessed less than 
30 days ago, we would run:

```
find . \( -name '*.txt' -o -name '*.dat' \) -a -mtime -30
```

These examples should give an idea of the kind of fine-grained searching you can do with `find`, but
it's capable of doing more than just printing filenames. `find` also accepts an *action* to perform on
each matching file, which is provided as a set of flags *after* the set of tests to perform. The default
action is to print the filenames (which is also specified by the`-print` flag), but two other useful 
actions are:

- `-delete`: delete all files which match the search criteria. This action can be extremely destructive
  (as in, "wipe out your file system"-level destructive)
  if you make a mistake in the search criteria, so make sure to do a test-run with `-print` first to
  make sure you're deleting the right set of files.
- `-print0`: print the names of the files, separated by `NUL` characters rather than whitespace. The
  `NUL` character (`\0`) is the only character which is not legal in Unix filenames, or in shell
  commands, so is much safer than the whitespace-separated `-print` when piping `find`'s output into 
  other shell commands (it doesn't run into the issue of bash interpreting filenames with spaces as
  multiple separate files). It does, however, require the next utility in the pipeline to support 
  `NUL`-separated input, so is somewhat more restrictive than the default.

This last action `-print0` is particularly useful when combined in a pipeline with the `xargs` command,
which combines the powerful search capabilities of `find` with the ability to perform essentially 
arbitrarily complex manipulations and shell commands.

# xargs
`xargs` is a somewhat lesser known Unix command that is nonethless one of the most useful programs in a
shell programmer's toolkit. To quote from the man page: *xargs reads items from the standard input, 
delimited by blanks (which can be protected with double or single quotes or a backslash) or newlines,
and executes the command (default is /bin/echo) one or more times with any initial-arguments followed by
items read from standard input*. Basically, `xargs` behaves like a safer for-loop, which takes a set
of arguments to execute, and runs through them one by one. You'd almost never use `xargs` by itself, but
rather as part of a pipeline where its arguments are piped in from the output of another command. 

As mentioned above, one common pattern is to pipe the output of `find` into `xargs` to execute some
command on every file which matches the given criteria. The possibility of whitespace or newlines in 
filenames means that you cannot safely use `find` and `xargs` together using only whitepsace-separated 
lists of files, as any unusual filenames will break the pipeline. Fortunately,
`xargs` provides the `-0` flag, which tells `xargs` to separate the input elements by a `NUL` character,
so files containing whitespace will be treated as a single argument. 

As a concrete example, suppose we wanted to use grep to search for a particular string, but we only want
to search files in the `./data` directory ending with `.inp`, accessed within the last 30 days. We can
combine `find` (with the `-print0` flag) and `xargs` as follows:

```
find ./data -name "*.inp" -mtime -30 -print0 | xargs -0 grep "some_string"
```

This pipeline will safely handle filenames containing whitespace, as well as filenames starting with a
hyphen, since the filenames will all start with `./data/...` (so there is no chance of them being
interpreted as a command-line flag). Using `find` as the first command in the pipeline allows for much
finer granularity in selecting files when compared to just using shell wildcards.

Another extremely important use of `xargs` is efficiently deleting large numbers of files from 
HPC file systems. Parallel HPC clusters typically use a file system which is shared across 
multiple nodes and accessible everywhere on the cluster (and sometimes shared between clusters managed 
by the same facility), called a distributed file system. It is usually inefficient to run `rm` on huge 
numbers of files stored on a distributed file system, and some HPC centres such as the Pawsey centre 
discourage its use for this reason. Instead, *Lustre* (a common distributed file system) provides the 
`munlink` command, which stresses the file system less than a standard deletion. When deleting large 
numbers of files, it's therefore best to use `find` to select the files for deletion, then pipe through 
`xargs -0 munlink` to remove the files. More information can be found in the [Magnus 
userguide](https://support.pawsey.org.au/documentation/display/US/Deleting+large+numbers+of+files+on+scratch+and+group), 
and you should strongly consider using this pattern to avoid slowing down the filesystem for other users
(and potentially getting a cranky email from the Pawsey system administrators).

Although there are other methods for repeatedly executing commands on groups of files (e.g. using an
explicit for-loop), `find` + `xargs` is the safest way of implementing this pattern. You should prefer
using `xargs` to explicit loops over files unless you encounter a problem which absolutely cannot be
solved with `xargs`.

## GNU parallel
A similar tool to `xargs` is GNU `parallel`, which also executes commands with arguments read from
standard input, but attempts to execute commands using multiple cores (i.e. in parallel) whenever 
possible. GNU `parallel` is extremely powerful and allows you to very easily utilise modern multicore
processors in simple shell-scripts, but it's also full of subtle pitfalls. If you think `parallel` would
be a good fit for your workload (e.g. running many instances of single-core, compute intensive jobs), I
would highly recommend reading the man page (`man parallel`) in full before venturing forth.

# Running commands in the background

Linux has the ability to keep commands running in the background, only returning control to them when
they're finished or when specifically requested. This is particularly useful in a remote SSH session, as
it means you can start some I/O intensive command running in the background and continue to use your
shell session while it completes. In bash, this is achieved by adding an ampersand ("&") after the
command, e.g. `./prog arg1 &`. This works best for non-interactive jobs, since if the command needs user
input (such as confirmation before removing a file) then it will block indefinitely until brought to the
foreground. Commands can be brought to the foreground with the `fg` command.

It's easiest to stick to one background job at a time, but if there are multiple suspended jobs then
Bash will assign each a numeric *jobspec*, which must be provided to `fg` to select which job to bring
forward.

It is possible to suspend interactive command-line programs like `vim` or `less` by pressing `ctrl+z`.
This is not always useful, as a text editor won't actually *do* anything until you bring it back
to the foreground with `fg`, but it can be handy if you want to "pause" an editing session to run some 
other command before returning to the session where you left off.

# Processes and signals

Separate to bash's idea of *jobspec*, the Linux kernel assigns each running process with a *process ID*
(PID), which can be used to refer to and modify that process while its running. Each PID is guaranteed
to be associated with exactly one process at any given time, but PIDs can be (but are not guaranteed to 
be) reused after a process has finished executing.

PIDs are commonly used for *inter-process communication* (IPC): sending messages between
processes as a form of coordination. The simplest way to do this on Linux (and other Unices like macOS)
is by sending a *signal* to a process. The process must then handle the signal, which can be done
through custom *signal handler* subroutines or delegated to the kernel (the part of the operating system
which manages resources and schedules processes to run on the hardware). Signals are assigned a positive
integer identifier, and are given a of the form `SIG<NAME>` where `<NAME>` is usually a mnemonic for the
signal's function. For example, `SIGTERM` signals that a process should terminate while `SIGSEGV` (short
for "segmentation violation") is sent by the OS to indicate that a program has tried to access memory it
is not permitted to (commonly referred to as a "segmentation fault" or "segfault").

The kernel will automatically send signals to processes for a number of reasons, but it is also possible
to send your own signals at will. In bash, this is achieved via the `kill` command, with `kill -l`
providing a list of all signals supported on your system. `kill` is invoked with the syntax `kill
-<SIGNAL> <PID>`, where `SIGNAL` is the last component of the signal's name (i.e. `kill -TERM PID`). If 
no signal is specified then it defaults to sending `TERM`, which will terminate the process. For
security reasons, you are only permitted to send signals to processes you own.
Finally, the related command `killall` will send a signal to all processes sharing a given 
name (e.g. `killall -TERM firefox` will terminate all running instances of `firefox`), but this command 
should be used with caution.

Before you can send a signal to a process, you'll need to find its PID. There are two main ways of doing
this. Your system may have a *system monitor* installed (the Linux equivalent of Windows *Task
Manager*), in which case each process's PID will be supplied next to its name, owner and resource
consumption. Even though most clusters will not have a graphical system monitor, they will usually have
a command-line program called `top`, which provides similar functionality and will list active PIDs. The
second, programmatic, way to get a process's PID is to use the command `pidof <name>` or 
`pgrep <pattern>` to search for processes by name. `pidof` searching for processes which exactly match 
the supplied string, while `pgrep` will search for partial matches (with similar syntax to regular 
`grep`) and can be used with other criteria like user ID.

Finally, many debugging and profiling programs can attach to a running process via its PID. For example,
it's possible to use `GDB` (the GNU debugger) to start debugging an already running process via the
command-line option `-p <PID>`. So if you start a simulation `./prog` and suspect it is misbehaving
(e.g. it appears to hang and not produce output), you would first get its PID with `pidof prog` and then
run GDB with `gdb -p PID` [^2]. You can either copy-paste the PID between commands, or merge them into
one command by `gdb -p $(pgrep prog)` (the `$(...)` syntax tells bash to make an environment variable
which has its value set to the output of the command in brackets).

[^2]: This process is somewhat complicated for MPI calculations, since `mpirun` will spawn multiple
    processes with the same name, thus causing `pidof` and `pgrep` to return multiple PIDs. Debugging 
    MPI programs turns out to be somewhat involved (for this and many other reasons), but [the OpenMPI
    FAQ](https://www.open-mpi.org/faq/?category=debugging#serial-debuggers) has a good walkthrough
    explaining how to use GDB to debug MPI programs.

# Hard links and symbolic links
Unix filesystems allow files to be referenced by multiple filenames and paths without duplicating the
underlying contents; this is called a *link* and is analogous to shortcuts in Windows File Explorer or
aliases in Mac's Finder. Linux has two kinds of links, called *hard links* and *symbolic links* (often
shortened to *symlinks*); the latter is more useful on HPC clusters. 

A symlink is a high-level pointer which refers to some file located anywhere on the filesystem 
(potentially including on remote file servers or directories), which could be a regular file, a 
directory or something more exotic. Symlinks can be opened or `cd`'d into as if they were a regular
file, and the kernel will automatically resolve the action to point to the underlying, "real" file. The
exception is that deleting a symlink with `rm` will only remove the symbolic link while leaving the
underlying file untouched. 

Symbolic links are created with the `ln` command, which has the syntax:

```
ln --symbolic <target> <link_name>
```

where `target` is the original file (or directory), and `link_name` is self-explanatory and can be
either a relative or absolute filename. Hard links (which can only point to files on the current
flesystem) are created with the same syntax, but without the `--symbolic` flag. Symlinks appear
differently to other files in the output of tools like `ls`, and the path they resolve to is given by
running `ls -l`.

Symlinks are particularly useful as a way to make your own memorable shortcuts for the (often complex)
directory structures on HPC clusters, which you can standardise between multiple machines. For example,
Magnus, Gadi and the RCC clusters all have different names and paths for their scratch directories, so
it can be useful to make a symlink in your home directory on each system pointing to its scratch
directory, but with the same name on each system. For example, you might make a symlink on Magnus with
`ln --symbolic /scratch/project/pawsey_username ~/scratch`, and another on Gadi with `ln --symbolic
/scratch/project/nci_username ~/scratch`. Both of these can be traversed by the usual `cd ~/scratch`,
which is much more convenient than typing the full path each time.

Finally, symbolic links will remain even after the underlying file is deleted (or may not have existed
in the first place), which is referred to as a *dangling symlink*. Trying to access a dangling symlink
will fail, but this can be useful in some cases, 
such as making a symbolic link to an executable: you don't want to have to make a new symlink every time
you do a clean build (i.e. deleting and recompiling the binary), so you can make a symlink, which will
dangle and then become valid when the file exists again.

# Programming in bash
In addition to its interactive use, bash is also a fully-capable programming language (albeit one with
plenty of quirks and idiosyncrasies). But even though you *can* write complex programs in bash, it's
worth stopping to consider whether you *should*. 

Bash (the language) is powerful, yes, but it's also chock full of gotchas and footguns [^3] that can and
will break your program if you're not extremely careful. Thankfully, these gotchas are documented, but 
bash will not warn you before doing something destructive, so it's extremely easy to accidentally do 
something terrible like blow away all your files. That last part is not hyperbole, by the way: the
Steam video game store had [a nasty bug](https://github.com/ValveSoftware/steam-for-linux/issues/3671)
in a shell script caused by calling `rm -r ${STEAMROOT}/*` without checking whether the `STEAMROOT`
variable was actually set. Unlike many other programming languages, bash lets you use variables without
declaring them first, and will just expand uninitialised variables to NULL, which in this
case caused the script to execute `rm -r /*` (the root directory) and deleted everything on the user's
computer.

[^3]: i.e. a language feature which seemingly only exists to allow you to shoot yourself in the foot.

This is an extremely bad bug, but it's actually surprisingly common in shell scripts (even those written
by experienced programmers). And this is just one gotcha among many. There's also the alphabet soup of
special variables (e.g. `$?` which stores the status of the last run process, `$!` which stores the
process ID of the last process; you don't want to get these confused), the difficulty of safely handling
whitespace in variables or file-names (let alone newlines) and the fact that running commands in a pipe 
executes them in a subshell (so any variables you assign in a pipeline will be inaccessible to the 
calling process). Note that I didn't call bash a *bad* programming language, merely an idiosyncratic 
one. Bash can be incredibly useful if you get it right, but even the best-written bash scripts tend to 
be very fragile and liable to blow up in the user's face.

So should you use complex bash scripts? It depends. For relatively short tasks like wrapping a pipeline
(gluing several programs together) 
or setting up the execution environment for an HPC job then a bash script is the right tool for
the job. But if you find yourself writing complicated branching logic and fancy arithmetic, especially 
for a task you're likely to re-use or adapt multiple times, it might be safest to avoid bash entirely. 

Consider using Python instead: there are modules
which allow you to access command-line utilities, manipulate files and processes and access remote
resources. Python also has the benefit of a more consistent syntax and robust unit testing frameworks,
making it safer and more reliable than the equivalent bash scripts. These two 
tutorials give a good overview: 
<https://medium.com/capital-one-tech/bashing-the-bash-replacing-shell-scripts-with-python-d8d201bc0989>,
<https://stackabuse.com/executing-shell-commands-with-python/>. You can't do everything in Python, but 
for many complex tasks it's a better choice of tool than hacking together a huge shell script. If Python
doesn't work for you, it's also worth considering using [Perl](https://www.perl.org/), which is
extremely flexible and safer than bash.

For the times when you *do* need to use bash, here are some important concepts and guidelines to keep in
mind.

## Common footguns to avoid
There are many lists of bash [gotchas](https://tldp.org/LDP/abs/html/gotchas.html),
[anti-patterns](https://brbsix.github.io/2015/11/29/bash-scripting-dos-and-donts/) and
[pitfalls](https://mywiki.wooledge.org/BashPitfalls) on the internet. What follows are some of the more
risky ones to look out for:

- Consider using `set -ue` to prevent the use of uninitialised variables.
- Check that the system you're running a script on *actually* has bash. It might only have the older 
  `sh`, or forcibly re-direct `/bin/bash` to something weird like `ash` or `dash`. Some systems only 
  have ancient versions of bash, which will not work with scripts using newer features. This is far more
  common than you might expect (you're likely to encounter weird shells on really old servers, or in 
  containers using lightweight Linux distributions as the base OS).
- Command-line utilities like `awk`, `grep` or `rsync` can have subtly different options or usage on
  different Unix systems. For example, most (but not all) Linux distributions use "GNU Awk" (`gawk`),
  while macOS uses "New Awk" (`nawk`). Despite its name, "New Awk" is older than "GNU Awk", so there are
  several features which exist on Linux but are not available in on Mac. This can cause scripts to break
  in unexpected ways.
- All variables are global unless specified otherwise. They are not inherited by sub-processes
  (including subshells) unless `export`ed however.
- Bash treats all data as strings of text unless you specifically request otherwise, meaning that
  even if a variable *looks* like a numerical value, such as `x=10`, it's still a string. This can cause
  particular confusion in comparisons and conditionals, where `[[ var1 = var2 ]]` will perform a
  *string comparison* which will *usually* do what you expect, but not always. For example, if `var1=10`
  and `var2=10.0`, then `[[ var1 = var2 ]]` will evaluate to false, since `10` and `10.0` are different
  *strings*, even if they have the same numeric value.

  If you need to compare numeric variables, you instead need to use `[[ var1 -eq var2 ]]` (there are 
  similar operators `-ne`,`-lt`, `-le`, `-gt`, `-ge`) or replace the square brackets with `((...))` to 
  force bash to do a numerical comparison.
- Bash does not allow [^4] certain special characters in variable names: 
  
  * dots ("."),
  * hyphens ("-"), 
  * asterisks ("\*"), 
  * ampersand ("&"),
  * brackets and braces ("\(", "\[", "\{").
  
  Variable names can contain numbers, but can't start with them (these are
  reserved by the shell), and cannot be [reserved
  words](https://www.gnu.org/software/bash/manual/html_node/Reserved-Word-Index.html) or [special
  characters](http://mywiki.wooledge.org/BashGuide/SpecialCharacters).

[^4]: More accurately, bash will not prevent you from using some of these in your variable names, but 
    your script might blow up without warning.

- Bash is extremely particular about whitespace, to the point where the presence or absence of a "space"
  can cause radically different behaviour. One common pitfall is that whitespace is not allowed on 
  either side of the "=" in variable assignment: `x=10` is allowed, but `x = 10` will likely fail (bash
  will treat `x` as if it were a program, and try to execute it with the arguments `=` and `10`).
  Another common error is that the whitespace inside a comparison is significant: `[[ var1 = var2 ]]` is
  allowed, but `[[var1 = var2]]` will (probably) fail (bash will look for a variable named
  `[[var1`). 
  
  Finally, as previously mentioned, whitespace in filenames is a huge headache to deal with,
  so it's best to avoid entirely (I tend to use underscores instead, in the form 
  `multiple_word_name.txt`). Unfortunately, there's no guarantee that other programs (or other users)
  will respect the "no-whitespace" rule, so you must be very careful every time you write a script which
  deals with files - treat every file you don't personally write out as if it was written by a
  hostile adversary determined to break your computer.

- Quotation marks are significant: enclosing something single- vs double-quotes (`'` and `"`) has 
  different meanings in bash. Text enclosed in single-quotes will strip all special-characters within 
  them of meaning, so variables will not be substituted, wildcards will not be expanded and escape 
  sequences will not be handled. This is referred to as a *string literal*. Single-quoted 
  strings can include any special-character (e.g. '$', '&', '\\') and bash will not attempt to parse
  them.
  
  Text enclosed in double-quotes will do variable substitution (so `"$var"` will resolve to a string
  representation of the value of `var`), but will not expand wildcards. Most of the time this is not
  important, but if you're using variables as arguments to file-system commands like `cp` or `rm` it
  is crucial to use double-quotes to prevent files with wildcards like "\*" and "?" from being expanded
  and potentially blowing up your filesystem. You may need to literally type `rm "file with spaces and 
  *"`, in which case you'll know to take the correct precautions, but more common is accidentally
  running into this through variable substitution.
  
  For example, consider the common pattern `rm $filename`, where `$filename` might be the output of
  another command or the result of some text manipulation. If `$filename` happens to have the literal
  value "data \*.dat" (terrible but nonetheless legal Linux filename), the `rm $filename` will expand to
  `rm data *.dat` which will remove the file `data` and all files ending with `.dat`. This is probably 
  not what you intended. Double-quotes will prevent this from happening. Such strange filenames are 
  uncommon, and you definitely shouldn't use them yourself, but these edge cases are extremely 
  destructive if you do happen to run into one. You never know when some program will produce a file 
  with a dangerous name, so it's best not to take any chances.
  
- If you need to pass quoted variables to `cp`, `mv` or `rm`, you
  may need to preface them with `--` to tell the program that there are no more command-line arguments 
  (e.g. `cp -- "$var1" "$var2"), otherwise any files which start with a hyphen will be interpreted as
  flags, leading to unexpected behaviour.

## Command line arguments
Shell scripts can take command line arguments, which function the same as for any other program. Command
line arguments are accessed through numbered variables `${1}`, `${2}`, etc (`${0}` contains the name of
the script), which can be used like any other variable in bash. For example, if we had a script called
`prog.sh` and invoked it with the arguments `./prog.sh CH4 something 100.5`, then the values of the
numeric variables will be:

- `${0}`: `./prog.sh`
- `${1}`: `CH4`
- `${2}`: `something`
- `${2}`: `100.5`

GNU bash (i.e. the bash available on Linux systems) provides the `getopts` utility for more 
sophisticated methods of handling and parsing input options, allowing for things like required vs 
optional flags at the cost of greatly increased complexity. A good rundown of `getopts` can be found
[here](http://mywiki.wooledge.org/BashFAQ/035), while a (somewhat colourful) rundown of alternatives can
be found [here](http://mywiki.wooledge.org/ComplexOptionParsing). 

Broadly speaking though, if you find yourself needing to do complex argument parsing, you're probably
better off using Python instead - it will be easier, more reliable and give you less heartburn
than hacking something together in bash.

## Functions
You can define functions in bash, which work more or less the same as in other languages. Functions take
arguments with the same syntax as regular bash scripts (i.e. ${1}, ${2}, etc) and are defined with the
syntax:
```
func() {
  # Do work here
}
```

and are called by doing:

```
$ func arg1 arg2 arg3 ...
```

where you would replace `func` with a descriptive name of your choosing, and `arg1` can be any string or
variable. It's important to note that if you define a function inside a script, then the function's
arguments will be different than the arguments to the script. That is to say, `$1` will have a different
value *inside* the function (the arguments passed to the function) than if you reference `$1` in the
rest of the script (the argument passed to the whole script from the command line), even though they
have the same name.

Functions can access and modify the variables in the rest of the script (or interactive shell) in which
they are defined, since all variables default to being globally available within a given shell. If you
want to make a local variable inside a function, the syntax is:
```
func() {
  local var=10
  echo $var # This will print "10"
}
echo $var # "var" is no longer defined, this will print nothing
```
