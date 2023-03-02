---
layout: page
title: "Introduction to the Linux command-line"
author: "Emily Kahl"
categories: linux command-line introductory clusters
---
# Introduction - Why you should learn Linux
If you've never used Linux before, you might be asking "do I really need to learn this? Why can't I just
use Windows or Mac?". The short answer is "yes". The long answer is "yes, and that's a good thing."

Linux is overwhelmingly common on scientific servers and clusters, as well as cloud computing platforms,
for both historical and technical reasons. While it's technically possible to use a graphical 
interface to connect with clusters over the network, it takes a lot of network bandwidth and processing
power, so it's not feasible for clusters with more than a few users. Instead, we must use the command
line, which comes with the added bonus of allowing us to automate common, repetitive tasks (such as data
analysis pipelines or programs with complicated sets of parameters).

Even if you never use Linux on your personal computer or workstation, learning to efficiently
utilise the command line can still make your workflow much faster and easier in the long-run. If you're
a Windows user, a lot of the logic will transfer to Windows Powershell even though the individual
commands will differ. And if you're a Mac user, most of this guide will transfer to the Mac command line
basically as-is (macOS is secretly a Unix operating system).

Finally, Linux command line skills are highly valued in the private sector, should you choose to take
that route in the future. Almost all cloud computing and data analysis platforms use Linux "under the
hood", and many modern machine learning tools are made with Linux in mind. 

All of this means you're almost guaranteed to need to use the Linux command line at *some* point in the 
future. But don't despair! You don't need to learn very much to get started, and everything else can be
picked up as you go. Consequently, this guide is not intended to be complete or comprehensive; it's
more of a crash-course, covering just enough to get you up and running and producing results. I have
provided a list of further resources for more advanced topics not covered in this guide.

# Table of Contents
{:.no_toc}

* TOC
{:toc}


# Terminology
Below are some useful definitions and terminology which will appear throughout this guide:

- *Shell*: a program that lets us give commands to a computer and receive output. It is also 
  referred to as the terminal, terminal emulator or command line.
- *Bash*: the most commonly used shell program on Linux and Mac systems. *Bash* can also refer to the
  specific *language* used to issue commands to the bash *shell*.
- *Flag*: optional parameter which can be passed to a command-line program to change its behaviour.
  Flags usually take the form of one or two consecutive `-` characters, followed by a letter or a word:
  e.g. `--help` or `-i`. Multiple single-letter flags can be combined together into a single option to
  save on typing, e.g. `ls -l -a` can be shortened to `ls -la`.
- *SSH*: stands for *secure shell*. Program used to connect and login to a remote, network connected
  computer (such as a HPC cluster).
- *Operating system*: software such as Windows, macOS or Linux which underpins the operation of a
  computer. Manages software interfacing with the computer's hardware, and handles starting and
  scheduling user programs.
- *Unix*: a family of operating systems with similar design and functionality. Linux and macOS are both
  Unix systems.
- *File system*: program which manages the storage, retrieval and organisation of data (files) on disk.
- *Directory*: An abstraction which allows for multiple files to be grouped together in a single
  "location". Often also referred to as a *folder*.
- *Cluster*: a computer system consisting of multiple smaller, tightly interlinked computers, which are 
  capable coordinating to carry out large, computationally intensive calculations in parallel. Often 
  referred to as a supercomputer.
- *Node*: a singular, self-contained computer, many instances of which are interlinked to form a 
  cluster. A cluster may contain several different types of nodes, such as nodes with large amounts of
  RAM or attached GPUs.
- *Login node*: a special type of node which serves as the gateway of a cluster. Users SSH into the
  login node, which then provides (managed) access to the rest of the cluster.

Throughout this guide I will demonstrate the syntax of commands through the use of *dummy arguments* -
placeholder names which you will need to replace with the actual file, path or argument when running the
command. Dummy arguments are denoted by being enclosed in angle brackets ("<" and >"), so `get <file>`
doesn't mean you should literally type "get \<file\>", but rather that you would substitute the name of
the target file, to get something like `get output.txt`.

# Setup and required software
If you already use Mac or Linux (e.g. Ubuntu), then you're all set: everything you need to follow this
tutorial should already be installed on your computer. If something you need isn't installed, it will be
available on the App store (for Mac) or your Linux distribution's package manager (e.g the Software
Center in Ubuntu).

If you're using Windows, you'll need to install some programs before you can get started. First, you'll 
need a program which can execute Linux command-line programs. There are three main programs which can do
this on Windows:

- [Cygwin](https://www.cygwin.com/): a standalone programming environment which includes a terminal
  emulator and lots of Linux command-line utilities. Cygwin is very easy to install and will include
  most utilities you'll need.
- [Git for Windows](https://gitforwindows.org/): similar to Cygwin, but focused on source code
  management. Software Carpentry has a [video
  tutorial](https://carpentries.github.io/workshop-template/#shell) detailing how to install and setup
  Git for Windows.
- [Windows subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10)(WSL): a 
  full Linux emulator, which is bundled with all new Windows 10 installations. WSL is more powerful 
  and fully-featured than Cygwin or Git for Windows and even lets you run programs compiled for Linux
  from the Windows command-line, but it's a bit trickier to install than the other two tools. 

You'll also need to use SSH to connect and login to the cluster. Fortunately, Windows 10 includes its
own SSH program by default. It can be accessed by running `ssh.exe` in any of the programs listed
above, or in the Windows command line. More detailed instructions for using SSH can be found in the
*Logging in* section of this guide. 

# Where to get help
If you get stuck, there are several places you can check for help. Unfortunately there is not much
standardisation of documentation between programs, but there are a few "safe bets" to check first.

The first port of call should always
be the manuals, referred to as *man pages*, which come bundled with Linux. These are accessed by the
terminal command `man`, followed by the name of the program you want to read about. For example, you can
access the manual page for the `less` command by typing `man less` at the command prompt. If you don't
remember the specific name of the command, you can search the man pages with `apropos`. For example,
running `apropos editor` will search for any man pages which include the word `editor` in their name or
description (in this case, it returns the names of lots of different text editor programs). Bash also 
has a command called `info` which will read "information documents" about a given file. It is
similar to `man`, but some programs may have an `info` page but not a `man` page. 

Sometimes a program won't come with a man page, but the developers might still provide documentation.
Almost all programs follow a similar convention here: adding `--help` or `-h` after the program's 
command will almost always make it print a help message (usually including a short description and a
list of arguments/parameters it accepts). For example, running the command `less --help` will show a
summary of commands that the program `less` accepts, as well as general advice on how to use it. 
Unfortunately, different programs may use either `--help` or `-h` or both, so you'll have to try them to
find out. These optional parameters which modify commands' behaviour are referred to as *flags*.

Finally, managed HPC clusters usually have very good online documentation. The big three you're likely
to use at UQ are [UQ's Research Computing
Centre](https://github.com/UQ-RCC/hpc-docs) (for Bunya and 
Wiener), [NCI](https://opus.nci.org.au/display/Help/Gadi+User+Guide) (for Gadi), and 
[the Pawsey Centre](https://support.pawsey.org.au/documentation/display/US/User+Support+Documentation) 
(for Setonix). These online resource contain both general information (e.g. compiling and using 
software), and information specific to using those clusters (e.g. running and checking the status of
computational jobs).

# Logging in
Before you can use the clusters, you'll need to apply for an account with the organisation that manages
them - your supervisor will be able to tell you which ones you'll be using and will need to approve your
application. The relevant signup forms are:
- RCC (Bunya and Wiener): <https://rcc.uq.edu.au/high-performance-computing>
- NCI (Gadi): <https://my.nci.org.au/mancini/signup/0>
- Pawsey (Setonix): <https://pawsey.org.au/support/>

Once your account is established, the next step is to log on to the cluster over the internet via a
program called *SSH*. This will establish a connection between your computer's terminal and the
cluster's login node, so that any commands you type into SSH will be set across the network and executed
on the cluster, with the results sent back across the network to be displayed on your computer. Take
note that the SSH connection is bound to the terminal window in which you ran the SSH command (either
`ssh` on Mac or Linux, or `ssh.exe` on Windows), so any commands you type in other terminal windows 
(including ones you start after you launch SSH) will be executed on your computer and not on the cluster.

If you're using Mac or Linux, open a terminal window and run the command `ssh 
<username@cluster.address>` where you replace `username` with your username on the cluster (which would 
have been sent in an email when you signed up) and `cluster.address` is the network address of the 
cluster - this can be found in the online documentation of the cluster you're logging in to. The SSH 
commands for the big-three clusters you're likely to use are:

|Bunya (RCC)     |`ssh username@bunya.rcc.uq.edu.au`   |
|Wiener(RCC)      |`ssh username@wiener.hpc.dc.uq.edu.au` |
|Gadi (NCI)       |`ssh username@gadi.nci.org.au`         |
|Setonix (Pawsey)  | `ssh username@setonix.pawsey.org.au`   |

Your terminal may print a warning about "unknown server", type "yes" to continue. The process is almost
the same on Windows, except you need to open a command line window (either `cmd.exe` or Powershell) and
run `ssh.exe <username@cluster.address>`.

If there are no errors, you should now see a new *prompt* (the words and characters just to the left of
where commands appear when you type) that looks something like `username@setonix-1:~>` (it will be
different for different clusters), which means that any commands you type in this window will be
executed on the cluster. Congrats! You're now using a supercomputer. 

Many clusters (including Setonix, Gadi and Bunya) will print a welcome notice when you first SSH in. 
This notice usually includes information on upcoming maintenance, information about recent changes to 
the system and a reminder of where to get help. These are usually worth paying attention to, as it's one
of the main way that the cluster's maintainers get information to you.

Finally, when you're finished with the remote session, type `exit` to close the SSH connection and
logout. Most of the time, the SSH connection will automatically close if you leave it unattended for too
long (where "too long" could be anywhere from an hour to a day), but that can be messy so it's always
best to explicitly log out when you're finished.

# Getting around - navigating the file system
It's important to understand how to navigate and use the *file system* on the cluster. Broadly speaking,
data on the computer is stored in files, which are grouped together into a hierarchy of *directories*
(also called *folders*). This holds true on Windows, Mac and Linux. You may be used to navigating the
file system and manipulating files (e.g. copying, renaming or deleting) through a graphical program
called a *file manager* such as *Finder* on Mac or *File Explorer* on Windows. Since the clusters you'll
be using do not have a graphical interface, you'll need to use the command line to manipulate files on
the cluster.

There is an extra degree of complexity on HPC clusters, compared to a personal workstation, as files 
need to be accessible to all
nodes on the cluster (not just the one physically attached to the disk). The exact details will vary
from machine to machine, but you can usually count on there being two main "locations" to store files:

  * Your home directory: this directory is usually *persistent* storage, so files stored in the home
    directory (or its sub-folders) are backed up and last until you delete them or your account no 
    longer exists. It usually has small storage capacity, so only essential files that you don't want to
    lose should be stored here. Equivalent to "My Documents, My Pictures, etc" on Windows or "Home" on
    Mac, it is labeled with your username on the cluster.
  * Scratch space: this directory usually has a lot of storage capacity, but is usually not backed up,
    so it's a good idea to transfer files to home (or off the cluster entirely) if you'll need them
    later. What's more, some systems (including RCC and Pawsey) regularly purge unused files, which is
    even more reason to transfer them off when you're done.

All directories have certain *permissions*, which determine who can access files stored in them. You
will always have permission to read from and write to files in your home directory and in your folder
in scratch space (which is labeled with your username on the cluster), while you may have read-only
permission for files in directories belonging to other members of your group. You will not be permitted
to access files belonging to other users not in your group.

On Linux, all directories and files are identified, or "located", with a *file path*, in which
directories and sub-directories are separated by `/` characters (this is different to Windows which uses
the `\` character). For example, your home directory might have the path `/home/username/`, which
indicates that the `username` folder is a sub-folder of the `/home` folder (which holds the home
directories of every user on the system). The paths to home and scratch space on clusters could be
quite long, so you'll need to look it up in the cluster's online documentation. Since the exact location
will differ between systems, Linux provides the shortcut `~/` which will always refer to your home
directory, whatever its actual path.

Directories are like "places", analogous to drawers in a filing cabinet, and you will be "in" exactly
one "place" whenever you're logged in with the shell. This is called the "working directory"
Commands you type will execute "in" this place,
for example by reading and writing files, so it's important to make sure you're in the right directory
before you do anything. Linux provides the shortcut `./` which refers to the current directory, as well
as the shortcut `../` which refers to the current *parent* directory (i.e. the directory "above" the
current working directory, so if you're in `/home/username/data/run` then `../` will refer to
`/home/username/data`). Any other filenames which start with a '.' character are "hidden files", which
are not included in file listings unless requested with specific flags (more on that in a moment).

There are a couple of bash commands which are important to know when navigating
the file system:

- `pwd` (stands for "print working directory"): prints the path of the current working directory.
- `cd <dir>` (stands for "change directory"): moves you to the specified directory. For example `cd ~/` 
  will change the working directory (or "move" you) to your home directory.
- `ls` (short for "list"): prints a list of files in the current directory. You can also type a
  directory path after `ls` and it will print the names of files in the target directory (instead of the
  current one). For example, `ls ~/data` will print all files in the `data` directory, a sub-directory
  of your home directory (assuming it exists). 
  
  Three import flags to remember are `-l` ("long output"), `-h` ("human-friendly") and `-a` ("all"). 

- `cp <src> <dest>` (short for "copy"): copies a file from one location (the source, abbreviated to 
  `src`) to another (the destination, `dest`). For example, to transfer the file `output.txt` from the
  current directory to the home directory, you would run `cp output.txt ~/output.txt`. If you do
  not provide a filename in the destination then the new file will have the same name as the old one, so
  the previous command could be shortened to `cp output.txt ~/`. Be careful when copying files: if you
  give a destination filename which already exists, then `cp` will overwrite it **without warning you**.
  You can give the `-i` flag to `cp` to tell it to ask for confirmation before overwriting any files
  (e.g. `cp -i <src> <dest>`). This command is conceptually equivalent to copying and pasting with 
  *File Explorer* (Windows) or *Finder* (Mac).
- `mv <src> <dest>` (short for "move"): similar to `cp` except it moves the source file, rather than 
  copying it. This means that after `mv` has completed, the original file will no longer be present -
  it will have moved completely to the new destination. Like with `cp`, `mv` will not warn you if you're
  about to overwrite a file, unless you pass it the `-i` flag. This command is conceptually equivalent 
  to cutting and pasting with *File Explorer* (Windows) or *Finder* (Mac).
- `rm <file1> <file2> ...` (short for "remove"): delete the specified file(s) from the system. Be aware
  that there is no equivalent to the "Recycle Bin" on HPC clusters, so make doubly sure you want a file
  gone before you delete anything with `rm`. `rm` will also not remove directories without the `-r`
  flag, so you must do `rm -r <dir>` to delete a directory.
- `mkdir <dir>` (stands for "make directory"): create the specified directory, which can be either a
  relative or absolute path. `mkdir` will fail and print an error if the specified directory already
  exists. 
- `tree`: similar in concept to `ls`, but used for visualising the entire directory structure in a 
  convenient "tree"-like representation. Unlike `ls`, `tree` is *recursive, which means it will not only
  display the contents of the target directory (or current directory if not given any arguments), but
  also the contents of each sub-directory, and so on until there are no more files to display. The
  output is formatted like a tree (the abstract structure from graph-theory, not a biological tree),
  with the current directory at the root node and with each node's children representing the files and
  folders it contains. 
  
  For example, say we have a directory called data, which contains some files and two sub-folders
  `Aggregator` and `Interface`. Running `ls` while in `data` would show:
```
Aggregator  Interface  timing.dat  SSGK.in template_SSGK.in
```
  Which tells us what's in the current directory, but we'd need to run `ls` on all of the sub-folders
  (`Aggregator` and `Interface`) to find out what's in *them*.

  On the other hand, running `tree` in the same directory would show us:
```
$ tree
.
├── Aggregator
│   ├── aggregate.awk
│   ├── Parallel
│   │   ├── INTCF1_3
│   │   ├── PROPS
│   │   ├── PROPS_2
│   │   ├── TCF1_2
│   │   └── TCF_3
│   └── Serial
│       ├── INTCF1_3
│       ├── PROPS
│       ├── PROPS_2
│       ├── TCF1_2
│       └── TCF_3
├── Interface
│   └── F77
│       ├── base.in
│       └── VELOCITY_TEMP
├── timing.dat
├── SSGK.in
└── template_SSGK.in
```
  This view provides much more information: we can see that `Aggregator` has two-subdirectories, while
  `Interface` has one, as well as what files are in those sub-directories. While this is a somewhat
  simplified example, `tree` can be very useful when navigating an unfamiliar directory structure, such
  as a large, unfamiliar codebase (maybe you need to learn how to use some open-source simulation
  software) or a complex data-set.

Typing out a long filename and path can be tedious and error-prone, so bash provides a shortcut called
*tab-completion*. Pressing tab while part-way through typing a command will automatically fill-in the
rest of the command: if you type `cd /home/username/da` and hit the "tab" key, the shell will complete
the rest of the command to `cd /home/username/data` (it will only fill in the command, but not execute
it. You still need to hit "enter" to execute the complete command). If there are multiple possible
results which a partial command could complete to, then the shell will only fill in part they have in
common. As an example, there are multiple command line programs which start with the letters "tr", so if
you type `tr` and hit "tab" then bash will not be able to decide which one to complete to so it will do
nothing. Pressing "tab" a second time will print a list of all the possible matches, which might look
like:
```
$ tr
tr           traceroute   trap         troff        trust        
tracepath    traceroute6  tred         true         
tracepath6   tracker      tree         truncate
```
You can then continue typing the command you want, and if you press "tab" again after typing a few more
letters then bash will fill in as much as it can again. You can do this as many times as you like when
typing out a command, which has the dual benefit of cutting down on the amount of typing you need to do,
while also providing reminders of the available directories or commands.

Sidebar for Mac users: tab-completion *does* work natively on the macOS terminal, but may require some
extra configuration to achieve the above behaviour. By default, tab-completion will not list possible
matches for an ambiguous completion; it will make an alert sound instead (unless you have disabled
system sounds). In order
to change this, you will need to edit the file `~/.inputrc` (the easiest way to do this is via the
`TextEdit` program), and add the following two lines:
```
set show-all-if-ambiguous on
TAB: menu-complete
```

Finally, even though Linux imposes very few technical restrictions on what name a file or directory can
have, there are still some "best practices" which will make your life much easier. First, spaces in
filenames can be extremely annoying to deal with on the command line: since bash uses spaces to
determine when a new command or flag has started, spaces in filenames need special treatment to work
properly. Let's say you have a file called `calculation results.txt`. If you were to type `rm
calculation results.txt`, bash would interpret the space to mean that you're actually referring to *two*
filess called `calculation` and `results.txt`, neither of which are the original file. Instead, you need
to *escape* the "space" in the name by prefixing it with a backslash ("\\"): `rm calculation\
results.txt`. You'll need to do this for every space in a filename, as well as other *special
characters*, like asterisks ("*"), brackets ("(" and ")") and ampersands ("&") (a complete list of all
special characters in bash can be found here: <http://mywiki.wooledge.org/BashGuide/SpecialCharacters>).

It's best to avoid using spaces and other special characters entirely, since constantly escaping
characters in a filename is tedious and error-prone. So what should you do if you want to make a
filename that contains multiple words? The best option is to use either a hyphen ("-") or underscore
("_") where you would usually use a space to separate words, so our example file would become
either `calculation-results.txt` or `calculation_results.txt`. Either option is fine, but it's best to
pick one and stick with it, since using a consistent naming scheme makes it easier to remember and
search through files.

## Where to store your files on the cluster
So now that you know how to navigate the file-system, you may be wondering "where and how should I store
all my files?". Like we saw before, HPC clusters tend to have very specifically structured file-systems,
so it's important to make sure that you're using them as intended to get the most out of the system. 

As with everything in this guide, different clusters will have different guidelines for file-system
access, so it's a good idea to at least skim the manual pages. For RCC, the relevant page is
<http://www2.rcc.uq.edu.au/hpc/guides/index.html?secure/Storage_userguide.html> (must log in with your
UQ credentials to access it), for NCI it is
<https://opus.nci.org.au/display/Help/3.+Storage+and+Data+Management>, while for Pawsey it is
<https://support.pawsey.org.au/documentation/display/US/File+Systems%2C+File+Transfers+and+File+Management>
(which even comes with a nice video tutorial!). All systems use the same general principles, however.

Generally speaking, it's best not to run calculations inside your home directory: if your calculation
generates lots of temporary files then it could overwhelm the filesystem and make it unresponsive for
all users. Not only is this bad for your code's performance, you'll probably get a cranky email from the
system administrator telling you to knock it off (which is never fun). Instead, you should run jobs in a
temporary directory on the scratch space. Scratch filesystems are usually designed to handle lots of
activity without slowing under the load, while also having much more storage available for use than your
home directory will. On *Gadi* and *Setonix*, the scratch directory has the path
`/scratch/<PROJECT>/username` (where you replace `PROJECT` with the project code your research group is
using. Ask your supervisor for this if you're unsure. Replace `username` with the username you use to
login to Setonix or Gadi), while the RCC systems have `/30days/<username>`
and `/90days/<username>` (where `username` is your UQ username). As the name might suggest, `/30days` is
cleared out every 30 days, while `/90days` is cleared out every 90 days.

Once you've generated your data, you should move the important files to your home directory in one go. 
Remember that scratch space is usually not backed-up and is regularly cleared out on Pawsey and RCC 
systems, so it's crucial that you move any important results or data to your home directory for safe 
keeping. 

# Reading and editing text
Reading and editing documents via the Linux command line is not too dissimilar to doing so via a
graphical interface. The biggest difference is that almost everything you'll use to run calculations and
analyse the output will be plain text documents (which universally have the `.txt` filename suffix), so
you won't be able to use a word processor like MS Word or Mac Pages to edit them (they do too
much automatic formatting, spell-checking, save in the wrong file format, etc). But even on the command
line, there are a range of powerful, easy-to-use programs for editing text available on almost clusters.

First, let's talk about viewing the contents of text files. Sometimes you don't necessarily want to edit
a file, but need to know what's in it, and often you'll need to see the contents at a specific line or
lines. There are four main command line tools to do this:

- `less`: a type of program known as a *pager*, which allows you to display and scroll back and forth
  through the contents of a file. `less` only reads the parts of the file that it currently needs, so it
  can be much faster than a text editor when you need to view the contents of extremely large text files
  (i.e. > 100,000 lines, not unusual for simulation output).
- `cat` (short for "concatenate"): prints the entire contents of a file or files to the terminal window,
  without the ability to scroll back and forth. If multiple file names are passed to `cat`, then it will
  print their contents one after the other, essentially joining, or concatenating, the output (note that
  this does not change the contents of any of the input files). For example, if the file `file1.txt`
  contains the line `foo` and `file2.txt` contains the line `bar`, then running `cat` would give:
```
$ cat file1.txt file2.txt
foo
bar
```
  which is useful for tasks like combining multiple data files into a single text file. 

- `head` and `tail`: these are mentioned together, as they perform very similar roles. `head` prints the
  first 10 lines of a file to the terminal, while `tail` prints the last 10 lines. These default values
  can be overridden via the `-n <num>` command-line flag, so to print the first 20 lines of `data.txt`
  you would run `head -n 20 data.txt`.

Now, for actually editing text files, there are three major text editors available on almost every Linux
system:

- [nano](https://www.nano-editor.org/docs.php): a simple, no-frills text editor. It has no special
  features - it just opens, writes and saves text files. Nano is very easy to use, and is the closest
  equivalent to a "notepad" type application on the Linux command-line. Setonix requires you to load the
  `nano` module before you can use it (via `module load nano`).
- [vim](https://www.linux.com/training-tutorials/vim-101-beginners-guide-vim/): a more
  fully-featured and customisable text editor with loads of special features like syntax-highlighting
  and the ability to define custom macros. The flip-side of this
  extra flexibility is that it has a somewhat steep learning curve. Vim is available on every Linux
  system you are likely to encounter, with no special effort required (just run `vim` in the
  command-line).
- [emacs](https://www.gnu.org/software/emacs/tour/): a text editor with is similarly full-featured and
  customisable as vim, albeit with a completely different user-interface. Emacs also has a steep
  learning curve, but can be very powerful once you learn it. Again, emacs will be available on every
  Linux system you are likely to encounter.

If you want to edit text files on your personal computer before transferring them to the cluster, some
useful open-source graphical applications are:

- [Atom](https://atom.io/) (Windows, Mac, Linux)
- [Geany](https://geany.org/) (Windows, Mac, Linux)
- [notepad++](https://notepad-plus-plus.org/) (Windows only)
- [Kate](https://kate-editor.org/) (Windows, Mac, Linux)

All of the above applications are free and open-source and support "advanced" features like 
syntax-highlighting for programming languages, autosaving and tabbed editing. The default text editors
on Windows and Mac (notepad and TextEdit, respectively) can also be used, but are extremely barebones
and lack nice usability features. If you're going to be writing code, then it may be worthwhile using a
full integrated development environment (IDE) as well. An IDE will do syntax highlighting, automatic
code correctness checks and most have integrated debugging and source code management tools which makes
the development process much easier. Microsoft [Visual Studio Code](https://code.visualstudio.com/) (or
the full [Visual Studio](https://visualstudio.microsoft.com/) on Windows) is a free IDE for Windows, Mac
and Linux which will be sufficient for most code development you're likely to do.

# Output redirection and pipes
There are two very important, Unix-specific ways of manipulating text that has no clear analogue in
graphical applications: *output rediction* and *pipes*. These concepts are key to using the command line
effectively, and are best explained with specific examples. 

When you run a command in the shell, it will usually print its output to the active terminal window;
referred to as printing to *standard output*, or `stdout` for short. Sometimes a program will
need to print error messages, which is referred to as printing to *standard error*, or `stderr`.
Although both `stdout` and `stderr` both print to the terminal window by default, it is possible to
save one or both to a file or use the output of one program as the input for another program - referred
to as *output redirection*. In bash, output redirection is represented by the syntax `prog > file`,
which says that the standard output from `prog` will be saved to `file` instead of printed to the
terminal. A command's standard error can be redirected with a similar syntax: `prog 2> file`. Finally,
an important warning: redirecting output to an existing file with `>` will completely overwrite its
contents, which may not be what you intended to do. If you want to *append* the output of a command to
a file (i.e. preserving the original contents) such as when keeping a log of some simulation run, you
must instead use `>>` (e.g. `prog >> file`).

Output redirection is wonderful for saving the results of programs for later use (it saves you manually
copy-pasting the output of a simulation once it's done), but is limited to saving output to a file. If
we want to do something fancier, we can use a related concept called *pipelines*. Bash (and other
shells) use the `|` character to indicate that the output of the preceding program should be redirected,
or *piped*, into the input of the next. For example, if we want to pipe the output of `prog1` into
`prog2` we would type `prog1 | prog2`. Multiple pipes can be used in a single command, and programs in a
pipeline are run *concurrently* - `prog1` and `prog2` are started at the same time, and `prog2`
processes data from `prog1` as soon as it becomes available. This means that combining programs in a 
pipeline is both more flexible than writing a single large program to do everything, and also faster, 
since it automatically exploits some of the available parallelism in the overall task.

This has all been very abstract, so let's look at some concrete examples. A very common use for pipes 
(probably the one that I use most in terms of sheer frequency) is piping very large output streams to 
`less`, to make it easier to read and scroll through. As we saw in *Getting around - navigating the file
system*, the command `tree` can produce a *lot* of output if run in a deeply nested directory. It's much
easier to read the output if we pipe it through `less` by doing `tree | less`. Similarly, if we only
wanted to see the first few lines of output, we could do `tree | head`.

There's more to pipes than just making output easier to read, though. Linux has a wide range of little
utilities which do one task, and are designed to be slotted into pipelines. To borrow a metaphor from
the early days of Unix [^1], pipelines are a way "of coupling programs like garden hose - screw in 
another segment when it becomes when it becomes necessary to massage data in another way". Essentially,
pipelines allow us to do ad-hoc data analysis in the shell, without having to write our own tools from
scratch in Python Fortran.

For example,
the `grep` command searches through a stream of text (either the contents of a file or the output of a
command) and prints all lines containing a specific pattern (e.g. a string). Let's say we want to search
through the output of some program for the string "CH4" - we can either save the output to a file and
search that file:

```
$ ./prog > output.txt
$ grep "CH4" output.txt
```

or we can compress these two steps into one command by piping the output into `grep`:
```
$ ./prog | grep "CH4" 
```
which is easier to read, and will be much faster since `grep` will print the lines as the are produced,
rather than having to wait for the program to finish. Furthermore, if we wanted to then save the first
15 matching lines to a file, we could extend our pipeline with `head` and output redirection into:
```
$ ./prog | grep "CH4" | head -n 15 > output.txt
```

[^1]: From the memo by Douglas McIllroy proposing the addition of pipes to (original) Unix: http://doc.cat-v.org/unix/pipes/.

Pipes are one of the most important concepts covered in this document, and using them effectively is
key to getting the most out of the Linux command-line.

# Automate common tasks - command-line scripting
In addition to typing in commands and receiving the responses one at a time (so-called *interactive
use*), bash supports the ability to write short programs called *shell scripts* which contain a sequence
of commands to be executed automatically. Since this provides the ability to group a number of commands
together and execute in a "batch", they are also often called *batch scripts* (which is the most common
terminology in Windows).

A shell script is just a plain text file which contains some commands for bash to execute, and has
functionally the same syntax as typing directly into the command line. Before it can be executed,
though, the operating system (Linux) needs to know what type of script is contained in a text file. This
is achieved with a construct known as a "shebang": the characters `#!` followed immediately by the path
to the shell program. On most systems, this will be `/bin/bash`, so your shell-scripts must start with
the line: `#!/bin/bash`. The shebang must be the first line in the script, otherwise it will not work.
Additionally, the convention is to use the `.sh` suffix for shell script files (e.g. `script.sh`), but
this is only to make it easier to remember what different files do - the Linux operating system does not
care what you call the file as long as it has the shebang in the right place. 

Any other lines starting 
with a "#" are ignored by the shell and do not affect execution of the script; they are *comments* which
serve to document and explain what the script is doing. As with all programming, it is a good idea to
write a comment whenever you're doing something which may not be immediately obvious to somebody
unfamiliar with the script (this could be one of your co-workers, or it could be you in six months
time).

The rest of the script can contain any number of commands, which will be executed in sequence (i.e. in
the same order as they appear in the file) and will have the same results as if you had entered the
commands yourself: they will print output, modify files and, for certain commands, ask for confirmation
before proceeding. 

Once you've written your script, you need to tell the operating system that it's a program to be run,
rather than just a static text file. This is referred to as "marking it as executable" or "giving it
executable permissions", and is achieved by the command `chmod +x <script>` (`chmod` stands for "change
mode" and the `+x` stands for "e**x**ecute"). Once the script is executable, you can run it by typing out
the name and path of the script. If you're in the same directory as the script (the most common case),
this can be shortened by using the "./" shortcut, so if we have a script called `script.sh` then we can
execute it by typing `./script.sh`.

Shell-scripting has some very advanced features on top of just running commands (far too many
to fit in this introduction), but the most important use-case for scripts when you're starting out is to
automate common work-flows and pipelines. Typing the same command (or set of commands) out multiple
times in a row is tedious and error-prone (typos, accidentally using the wrong flag, etc), so if you
find you find yourself using the same commands or pipelines more than three times then it's a good idea
to transform it into a script. Saving complicated pipelines or sequences of commands in a script also
makes it easier to remember them later on - rather than needing to memorise the exact sequence of
commands used to generate a file you just need to look at the contents of the script.

Shell scripting is also important because it is the way we submit and run computational jobs on HPC
clusters.

# HPC clusters - the basics of submitting jobs
HPC clusters can have hundreds or thousands of users sharing the same set of resources, so they use
software called a *job scheduler* to ensure everyone gets has fair access to the cluster. In order to
run simulations on the cluster, you need to create a *job script*, which is a program (written in the
*bash scripting language*) that tells the
scheduler what sort of job you'd like to run: how many CPUs you need, how much memory you think you'll
need, how long you think it'll take, and what programs to run. The job scheduler then uses all of your
requests to calculate a *priority* and places your job in a queue (which could contain dozens or
hundreds of jobs from other users). When it's your job's turn, and there are enough free resources, then
the job scheduler will run your script. You can submit multiple jobs to the queue at the same time,
potentially requiring different sets of resources for each job, and the scheduler will handle the
queueing and running automatically. 

Making a job script from scratch can be a little bit fiddly, and each cluster has its own way of
handling jobs, with RCC and NCI using software called *PBS Pro*, while Pawsey uses *SLURM* as its job
scheduler.
Fortunately the major clusters have online documentation with example job scripts you
can modify to suit your needs:

- RCC: [Documentation + example script](http://www2.rcc.uq.edu.au/hpc/guides/index.html?secure/Batch_PBSPro.html)
- NCI: [Gadi Jobs](https://opus.nci.org.au/display/Help/0.+Welcome+to+Gadi#id-0.WelcometoGadi-GadiJobs)
- Pawsey: [Job scheduling](https://support.pawsey.org.au/documentation/display/US/Job+Scheduling),
  [example scripts](https://support.pawsey.org.au/documentation/display/US/Example+Job+Scripts)

The above documentation also covers the special commands you'll need to use to submit, cancel or check
the status of compute jobs, which will again be different between clusters. 

RCC systems allow you to run as many jobs as you like (as long as you don't overwhelm the cluster), but
computational jobs on the NCI or Pawsey systems are billed against your project's *allocation*. Each
project is given a budget of a certain number of *service units* (SUs), which represent the amount of
resources and time a project is allowed to use in a quarter (i.e. three months), and are shared between
all members of a project. Whenever anyone in the project runs a job, an amount of service units are
deducted from the project's budget, which can be checked by running `nci_account` on Gadi or
`pawseyAccountBalance` on Setonix.

Regardless of the underlying job scheduler, you should *never* run large computational jobs such as
simulations or compiling large codebases on the login nodes. Anything which may take more than a few
minutes or use more than a few GB of RAM should be run as a compute job via the scheduler. The login 
nodes are shared between all users and do not have very much computational power, so running a large job
on the login node will slow down or even crash other users' sessions. This is a surefire way to get a 
cranky email from the system administrators, and may even result in your account being suspended. Don't
run on the login node; use the scheduler.

# Software module system
Users of an HPC system often require specific versions of software for their workflows, while some
software packages clash and cannot be used at the same time (for example, a particular program might
compile with version *X* of a compiler, but not version *X+1*).

Instead of making every version of every program available to all users at all times, clusters instead 
use *modules* to allow you to pick and choose which software to use at a given time. Typically, a
cluster will make a very limited set of essential programs available by default, with more specialised
software such as compilers or simulation software available as optional modules.

To load a module (and thus make the program it contains available to use), run the command 
`module load <module_name>` where `module_name` is the name of the *module file* to load. 
A module's name usually has the form `<program>/<version>`, so to load version
2.14 of the program NAMD, you would do `module load namd/2.14`. To unload a module file, run `module
unload <module_name>`, while `module swap <module1> <module2>` will unload `module1` and load `module2`
in its place.

To list the modules available on the
system, run `module avail`, while running `module avail <module>` will list all available versions of a
specific module. If you're not sure which module contains the program you're interested in (or if the
program is even installed), you can run `module search <query>`, which will search
for any modules whose name or description matches a given query. Alternatively, you may want to only 
list the modules which you have loaded, which can be achieved by running `module list`.

Sometimes it's not obvious what a module actually *does* or what software it provides. The command
`module show <module_name>` displays information about a given module, including programs and libraries
it provides.

# Transferring files to and from remote servers
At some point, you'll want to transfer files between the cluster and your computer. The easiest way to
do this is through an *SFTP* (*Secure File Transfer Protocol*) program running on your computer (not on
the cluster), which starts a connection between your computer and the cluster and allows you to
interactively select files to transfer back and forth.

There are both command-line and graphical SFTP programs; both are fine and it's up to you which you
prefer to use. For Mac, the easiest to use graphical SFTP program is [Cyberduck](https://cyberduck.io/),
while for Windows the easiest is [WinSCP](https://winscp.net/eng/index.php). There is no graphical SFTP
program which is available on all Linux distributions, but if you're using Ubuntu then a good option is
[gFTP](https://github.com/masneyb/gftp), which should be available in the Software Centre.

For all of the above programs, you'll
need to make a new connection to the cluster before you can start using them: in Cyberduck this is
achieved by clicking the "New Connection" button in the main window, while WinSCP will automatically
launch a wizard to do this when you start it. Make sure to select "SFTP" as the "File Protocol", then
enter the cluster's address under "Host Name", then enter your username and password. For example, if
your username is `jsmith` and you want to transfer files to or from Setonix, you would enter
`setonix.pawsey.org.au` as the Host Name and `jsmith` as the username.

The command-line program `sftp` is almost universally available, and only slightly-less user-friendly
than the graphical programs. Mac and Windows both have command-line clients which function the same way;
on Mac the command is `sftp`, while on Windows it is invoked as `sftp.exe`. Connecting to a server is
very similar to SSH - run the command `sftp <username@cluster.address>` in a new terminal window (or
`sftp.exe <username@cluster.address>` if using Windows) and enter your password when prompted. You can
move around and explore the cluster's file system with the same commands you'd use in an SSH session
(`cd`, `ls`, etc), and can navigate your personal (or *local*) computer's file system by using the same
commands prefaced with an "l" (`lcd`, `lls`, etc). To transfer files from the cluster to your computer, 
run `get <file>`. To transfer files from your computer to the cluster, run `put <file>`. In both cases,
`<file>` can either be a bare filename, in which case `sftp` will transfer from the current working
directory (on either the cluster or your computer, depending on whether you are using `put` or `get`),
or you can specify the full path to the file. `sftp` also supports tab-completion for both commands and
file names/paths. 

# Some useful commands
Finally, here are some useful commands, tips and tricks that didn't quite fit elsewhere in this guide:

- Wildcards: Wildcards are a useful shell construct which allows you to access or manipulate multiple
  files at once through *pattern matching*. Wildcards are represented by certain special characters, the
  most common of which are "\*", which matches zero or more of any character, and "?" which matches
  exactly one character. This is best demonstrated through examples.

  Let's say we wanted to remove all *log files* in the current directory, which are created by programs
  to keep details of their execution; they're useful for debugging, but we may not need them once we've
  generated the data. Log files generally end with the suffix `.log`, examples might be `CH4.log`, 
  `C2H6.log` and so on. Instead of manually typing in all file names like `rm CH4.log C2H6.log C3H8.log`,
  we can use a wildcard `*.log`, which will match all files whose name ends in the characters `.log`. So
  the command `rm *.log` tells the shell to enumerate all files which end in `.log` and pass them to the
  command `rm`. We aren't aren't just limited to whole words, either. If we had a set of log files whose
  names have the form "<YEAR>-<MONTH>-<DAY>.log" (for example, the date on which they were generated), 
  we could list all files from 2020 by doing `ls 2020-??-??.log` (remember that `?` matches exactly
  one character, so files like "2020-full.log" won't be affected by this).

  Wildcards can be used for any command which requires a filename or path, and can greatly reduce the
  amount of typing needed to select large numbers of files for a particular operation. The only caveat
  is that the shell won't warn you if you write a wildcard which catches files you didn't intend it to,
  so there is always a danger of accidentally deleting important files. Consequently, if you're using
  wildcards for a destructive operation (like `rm`-ing files), it's a good idea to test which files the
  wildcard matches with `ls` and check that it's what you expected (i.e. before you do `rm *.out*`, run
  `ls *.out*` and check that you haven't caught anything you don't want to delete). 

- `find`: as its name might suggest, `find` finds files in the filesystem (try saying that five times
  fast). The syntax of `find` is somewhat intricate, but the basic usage requires you to specify a
  starting directory and the criteria to search for; `find` then searches recursively "down" from the
  starting point and prints any files which match the search criteria. The recursive searching is what
  separates it from a tool like `ls`, which only lists files in a single directory.

  For example, to find all files in the current directory *and* its children with the suffix `.log` you
  would type `find . -name "*.log"`: `.` is the target directory, `-name` tells `find` to match
  filenames, and `*.log` is a wildcard pattern which matches any file name ending in ".log". 

- `grep`: searches the contents of a file (or files) and prints all lines containing a particular 
  pattern. Think of it like a command-line version of using `ctrl+f` to search a document in a word
  processor. In its most basic usage, `grep` accepts a pattern to search for, and a list of files to
  search through (which could also be a wildcard), so to search for the string "Temperature" in the file
  "output.txt" you would do `grep Temperature output.txt`. By default, `grep` only searches for *exact*
  matches to the specified pattern and is case-sensitive, so `grep Temperature <file>` will not match 
  the string "temperature".

  `grep` supports a plethora of command-line options, so be sure to check out the man page if you need
  to do something complicated (do `man grep`), but some useful ones are:
  * `-n`: print the line in the file in which a match occurs, as well as the match.
  * `-i`: ignore case when matching strings, so "Temperature" and "temperature" would match, for
    example.
  * `-v`: invert match, so only lines *not* containing the specified pattern will be printed.
  * `-A <num>`, `-B <num>`: print `<num>` lines *A*fter or *B*efore matching lines. By default, `grep`
    will only print the contents of lines containing matches; with these options it prints the
    surrounding lines (before or after) each match to give context for the matches.
  * `-o`: only print the matches, not the lines containing them.
  * `-w`: only print matches which are a whole word, rather than matching all substrings. For example,
    this would mean that `grep -w bash` only matches the the complete word "bash" and would not match
    "bashrc", for example.
  * `-x` (or `--line-regexp`): like `-w`, but only print matches which are a whole line.

  In addition to plain text, `grep` also supports matching against *regular expressions* (often
  shortened to *regex*), which are like wildcards, but with much richer functionality. There is not 
  enough space in this guide to explain regular expressions in any level of depth; check out [this 
  guide](https://www.grymoire.com/Unix/Regular.html) if you're interested.

- `tee <file>`: prints its input to both standard output *and* a specified file. `tee` is almost always
  used as part of a pipeline where you want to see the output of a command and also save it to a file
  for later: e.g. `./prog | tee output.txt`.

- `echo <string>`: prints a string to the terminal. For example, `echo "Hello, World!"` prints "Hello,
  World!" to the terminal. This is mostly useful for printing status updates from a script (e.g. `echo
  "Removing log files..."`).

- `wc <file>` (short for "word count"): counts the lines, words and characters in a file (or group of
  files) and prints the counts to the terminal. By default, `wc` outputs one line per file of the form:
`<num_lines> <num_words> <num_characters> <filename>`, 
  with an extra line for the total counts if more than one file is processed. The output format can be
  changed by passing the `-l` (only count the number of lines), `-w` (only count the words), `-m` (only
  count the characters). If no files are specified, `wc` will operate on standard input (i.e. typing in
  words manually) and can be used in pipelines.

- `sort`: sorts a stream of text data supplied either from standard input or a file. `sort` can handle 
  alphabetical, numerical (via the `-n` flag) or general floating point (`-g`) data, and it is possible
  to select which column to sort by via the `-k` flag. The column separator can be set via the
  `--field-separator=<sep>` option, in the case of multiple-column input like a CSV file (where `sep`
  would be ",").

- Bash variables: it's possible to declare a variable in bash via the syntax `<variable>=<value>`, where
  `<value>` is any arbitrary string. Variables can be used to store and manipulate values to be used
  later in a script or interactive session. Their names can contain letters, underscores and numbers
  (importantly, not hyphens or asterisks), but cannot start with a number.

  There are two important notes on the syntax of variable assignment. First the lack of space between
  the variable name and the "=" is significant, since bash will interpret the variable name as a command
  (and probably fail, since it does not exist yet) if there is a space (i.e. `variable = value`).
  Second, even though you can enter anything you like, bash will treat everything that's not a command 
  as a string, so numerical values have no special significance to bash (they may have significance when
  passed to certain commands like `sort` which *do* handle numerical values). By convention, shell
  variable names are written in UPPER CASE, although this is not a technical requirement.

  Variables are referenced by prepending their name with a "$", e.g. `$variable`, which will cause bash
  to substitute the variable's value in place of its reference. For example, if we have a variable
  `OUTPUT_FILE=output.txt` we can redirect a program's output to it by `./prog > $OUTPUT_FILE`. You can
  also use the value of a variable inside a string, such as a filename, by encasing the variable in
  curly-braces "${" and "}" (you still need the "$" in front), so if you wanted to make a filename based
  on the value of the variable `RUN_NUMBER` you could type something like `./prog > ${RUN_NUMBER}.txt`.

  Additionally, many programs read from shell variables to determine their run-time behaviour. For
  example, programs using the OpenMP parallel programming framework (including LAMMPS and VASP) check
  the value of the variable `OMP_NUM_THREADS` to determine how many CPU cores to use in the calculation.
  In order for the value of a variable to be visible to any programs you run, it needs to be *exported*,
  which is most easily achieved by putting the keyword "export" in front of its declaration; instead of
  writing `OMP_NUM_THREADS=8` you would write `export OMP_NUM_THREADS=8`.

- `~/.bashrc` and aliases: you can configure bash and have it store variables and settings across
  sessions by modifying a file named `~/.bashrc`. Bash will execute all commands in `~/.bashrc` 
  (including setting and exporting variables) at the start of each new shell session (e.g. logging in 
  via SSH). There will be a specially-tuned default `~/.bashrc` file on the clusters, so it's best to 
  add new commands and configuration options *after* any pre-existing lines.

  There are a few general-purpose things you can add to your `~/.bashrc` to tailor the shell to your 
  needs. The biggest
  of these are *aliases*, which allow you to create your own shortcuts for complicated shell commands.
  Aliases take the form `alias <new>="<old>"`, where `new` is the shortcut you wish to create and `old` 
  is the original command (`old` must be encased in quotes). For example, if you regularly use `grep` 
  with the `-n` option, you could add `alias grepn="grep -n"` to your `~/.bashrc`, so whenever you run
  `grepn` the shell will automatically execute `grep -n` instead. Aliases must be stored in `~/.bashrc`
  if you want to keep them active for all bash sessions; it's possible to interactively define aliases
  while using bash, but they will disappear when you exit the shell and won't be available in other
  terminal windows if you don't save them.

  Finally, once you've made changes to your `.bashrc`, you'll need to either reload bash (by starting a
  new terminal window, for example) or run `source ~/.bashrc` for the changes to take effect.

- Easier SSH and SFTP logins for Mac and Linux: to save having to memorise and type out the 
  username+address combination for every cluster you use, it's useful to save the various addresses in 
  the `.bashrc` on your personal computer. The best way to do this is by adding a line exporting the 
  username+address as an environment variable, such as `export bunya="username@bunya.rcc.uq.edu.au"`
  (note the quotation marks). This would then allow you to log in to Bunya by doing `ssh $bunya` and
  to get files by doing `sftp $bunya`. It's a good idea to do this for all clusters you have access
  to, with each cluster getting its own variable on its own line in the `.bashrc` file.

# Finding executables in non-standard directories
In order to execute programs, bash needs to know the directory in which their executable file is stored.
One way to do this by supplying the path (full or relative) when executing the command, such as
`~/Code/lammps/bin/lmp args`, but what if you don't want to type out the full path every time you run
the command?

Whenever you run a command without providing the full path, bash searches through a list of pre-defined
directories for an executable with that name and executes the first match it finds. This list is stored
in the environment variable `PATH`, and takes the form of a list of directories (which must be absolute
paths) separated by colons (":"). The best way to add new directories for bash to search when executing
commands is to add a line to your `.bashrc` prepending the new directories to the existing list:
```
export PATH=/new/path/to/exe:$PATH
```
This command says to set the new value of `PATH` to the new directory *plus* the rest of the existing
`PATH` list. We can't just set `PATH=/new/path/to/exe`, since that will override the default set of
directories, so bash will no longer be able to find important system commands like `ls`, making your
shell unusable.

Returning to our original example, if we wanted to be able to run LAMMPS by just typing `lmp`, we can
add its installation directory to the list of directories bash will automatically search through by
adding the following line to `.bashrc`:
```
export PATH=/home/user/Code/lammps/bin/lmp:$PATH
```

This can be repeated as many times as needed for as many programs as you like.

# Test your knowledge
One of the greatest demonstrations of the power of the UNIX shell came in the form of [dueling magazine 
columns between two prominent computer scientists in the 
1980s](https://leancrew.com/all-this/2011/12/more-shell-less-egg/). A problem was posed to Don Knuth (a
founder of the field of academic computer science) and Doug McIlroy (one of the original developers of 
the UNIX operating system): Read a file of text, determine the n most frequently used words, and print
out a sorted list of those words along with their frequencies. Knuth developed an incredibly intricate,
10+ page long program from scratch, while McIlroy did the same in a six-command shell pipeline. The
solution, and McIlroy's explanation are reproduced below:
```
tr -cs A-Za-z '\n' | tr A-Z a-z | sort | uniq -c | sort -rn | sed ${1}q
```

>If you are not a UNIX adept, you may need a little explanation, but not much, to understand this pipeline of processes. The plan is easy:
>
>1) Make one-word lines by transliterating the complement (-c) of the alphabet into newlines (note the quoted newline), and squeezing out (-s) multiple newlines.
>
>2) Transliterate upper case to lower case.
>
>3) Sort to bring identical words together.
>
>4) Replace each run of duplicate words with a single representative and include a count (-c).
>
>5) Sort in reverse (-r) numeric (-n) order.
>
>6) Pass through a stream editor; quit (q) after printing the number of lines designated by the script’s first parameter (${1}).

Playing with this pipeline is a great way to internalise the essential logic of the command line. What
follows is a small set of guided problems based on the above pipeline that will help you cement your
understanding of the Linux command line.

## Generating the input text
Before we can use our pipeline, we need to generate a set of input text to test it on. Let's use the
manual/information page for bash. First, try running `info bash` in the command line. 

**Q)** Why will this output not work in our pipeline?

**A)** Because it is piping the output through a pager (on my computer it uses the antiquated `more`, which
is like `less` but with fewer features), not `stdout`. Since the output is already being consumed by a
program, putting `info bash` in a pipeline as is will not do us any good, since there will be nothing
for the next program to consume.

We will therefore need to tell `info` to print to standard output, without piping through `more`. We
also need to tell it to print every "bash" info page at once, rather than paging through them. This
is achieved by passing the `-a` and `-o -` options to info. Try running `info bash -a -o -` on your 
command line and observe the difference.

## Transliterating 
The next command in our pipeline is `tr`, which stands for "translate" or "transliterate". It's used to
essentially swap certain characters, or sets of characters, with another set of characters, such as when
translating some file to all upper- or lower-case. In this case, we want to use `tr` twice.

The first instance removes all instances of non-alphabetical characters and replaces them with a
*newline* - a special character which inserts a line-break into the output (equivalent to pressing the
"enter" key in a text editor or word-processor). This has the effect of separating out words and
printing them on separate lines (since whitespace is non-alphabetical), as well as removing any 
numbers or special characters (like "-" or ":").
The second invocation of `tr` replaces all upper-case characters (`A-Z`) with their lower-case
equivalents (`a-z`), to ensure that words are not double-counted due to capitalisation (e.g.
"Interpreted" and "interpreted" should be counted as a single word).

## Putting it all in a script
Now we're ready to put our pipeline into a shell script to make it easier to use.

**Q)** Use the information in the "Automate common tasks" section to make an executable shell script to
hold your modified pipeline. Give it a descriptive name like `word_historgram.sh`.

Now, you may notice that there's one part of the pipeline that we haven't discussed: `sed ${1}q`. First,
`sed <num>q` prints the first `<num>` lines of its text input. It's functionally the same as `head`, but
McIlroy used it in his solution because `head` hadn't been written yet! You can replace `sed ${1}q`
with `head -n ${1}` if you like [^2].

[^2]: `sed` (stands for "stream editor") is a utility to programmatically manipulate and edit streams of
    text (either text files for `stdin`) and is one of the most powerful shell tools in Linux. The keen
    reader may appreciate going over [this unofficial documentation](https://www.grymoire.com/Unix/Sed.html).

Now let's talk about `${1}`. Numbered shell variables store the arguments which were passed to the shell 
script when launched. The first argument is stored in `$1`, the second is stored in `$2` and so on, so
if we call our script with `word_histogram.sh 10`, then `${1}` will have the value of `10`, and `sed`
will print the first 10 lines of the sorted list.

**Q)** What are the 12 most frequently used words in the bash information page?

## Find the frequency of a specific word
Finally, it might be useful to be able to specify a particular word and find its frequency in the info
pages. We can do this using `grep`, with the `-o` flag to print just the matching word (as opposed to
the whole line, which is the default behaviour). It may also be useful to invoke `grep` with the `-i`
flag, which tells it to ignore case when finding matches.

**Q)** Modify your script so that it can take a word as input and count the number of times this word
appears in the text. Compare the results to the original histogram pipeline for the word "shell". What
are some reasons it might give different answers? Is there a shorter way to achieve this than a simple
substitution into the original pipeline?

**A)** As we have invoked it, `grep` will match *sub-strings*, as well as whole words; `grep -i "shell"`
will match both "shell" and "subshell". This is not the case for the `tr`-pipeline, which *does* only
count whole words. We can fix this by passing `-w` to `grep`, which tells it to only match whole words.

# Resources and further reading
Once you're up and running on the clusters, you may want to check out the *Software Carpentry* workshops
on the Unix shell: there's a tutorial on [the basics](https://swcarpentry.github.io/shell-novice/) and 
a follow-up [advanced course](https://carpentries-incubator.github.io/shell-extras/) (which is currently
only partially finished). You can either skim over the tutorials and work through specific sections as 
you need them, or do the course all in one go (Software Carpentry estimates that both workshops can be
completed in a few hours). 

In particular, it's worth looking over the module on 
[pipes](https://swcarpentry.github.io/shell-novice/04-pipefilter/index.html) and taking time to do the
example problems.

Some other resources you may find useful:

- [Learn bash in Y minutes](https://learnxinyminutes.com/docs/bash/): covers similar material to the
  Software Carpentry workshops, but is structured more like a reference manual than a tutorial. It's
  quite terse, so it's faster to work through than Software Carpentry, but requires more "reading
  between the lines" to get the most out of it.
- *Mastering Linux Shell Scripting: A practical guide to Linux command-line, Bash scripting, and Shell
  programming*. This is a more long-form introduction to Linux shell scripting. It's useful as a 
  learning resource with worked examples, and is available as an eBook through many university libraries.
- [devhints bash cheat sheet](https://devhints.io/bash): concise, comprehensive reference guide to bash
  syntax and concepts. Extremely useful for when you need to look up something you've forgotten how to
  do.
- [Bruce Barnett's UNIX tutorials](https://www.grymoire.com/Unix/): somewhat old but still useful
  tutorials dealing with "UNIX shell programming and various other arcane subjects of interest to
  wizards". Covers many useful utilities and lesser known bash tricks.
