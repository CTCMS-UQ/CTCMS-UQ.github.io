---
layout: page
title: "Quick-start guide"
author: "Emily Kahl"
categories: linux command-line introductory clusters
---

Whether you're developing or running simulation software, it can be challenging to figure out where to
start when joining a new group. This is especially true if you've never programmed or used
high-performance computing resources (HPC, often colloquially called *supercomputing*), as the sheer
amount of things you need to learn can feel overwhelming. This guide aims to help smooth out this
process by providing a one-stop list of useful skills, programs and resources you'll need while working
at CTCMS. A lot of your work will likely be done on HPC clusters (supercomputers) which are accessed via
a remote terminal (command-line) connection, so this guide will briefly cover how to connect to and use
HPC clusters as well.

# Terminology
Below are some useful definitions and terminology which will appear throughout this guide:

- *Operating system*: software such as Windows, macOS or Linux which underpins the operation of a
  computer. Manages software interfacing with the computer's hardware, and handles starting and
  scheduling user programs.
- *Unix*: a family of operating systems with similar design and functionality. Linux and macOS are both
  Unix systems.
- *Shell*: a program that lets us give commands to a computer and receive output. It is also 
  referred to as the terminal, terminal emulator or command line.
- *SSH*: stands for *secure shell*. Program used to connect and login to a remote, network connected
  computer (such as a HPC cluster).
- *File system*: program which manages the storage, retrieval and organisation of data (files) on disk.
- *File manager*: a program which lets us browse files stored on a computer (either a local workstation
  or a remote file server) using a convenient graphical interface. Examples include *Explorer* in
  Windows, *Finder* in macOS and *Nautilus* in Ubuntu Linux (other Linux distributions may have
  different file managers).
- *Directory*: An abstraction which allows for multiple files to be grouped together in a single
  "location". Often also referred to as a *folder*.
- *Cluster*: a computer system consisting of multiple smaller, tightly interlinked computers (called
  nodes), which are capable coordinating to carry out large, computationally intensive calculations 
  in parallel. Often referred to as a supercomputer.

# Setting up your computer
Unsurprisingly, you'll need a computer to do computational science. An important choice to think about
before you start is which operating system to use. The operating system (OS) is the layer of software
which interacts directly with the computer hardware and serves as an interface layer whenever you need
the computer to *do* something like run a program, write to a file or connect to a network. There are
multiple operating systems in common use, including Microsoft Windows, Apple macOS and Linux; which one
you choose will affect the software and tools available to you, as well as *how* you interface with the 
computer. 

This guide will focus on the "Big Three" operating systems which are most commonly used in scientific
computing: Windows, Mac and Linux. You can get by with any of these, but Linux will provide you with the
best and most complete environment to work in (even if it has a steeper learning curve if you're used to
Windows). It is also the most complete "out-of-the-box" experience and will include (almost) all the
software you'll need by default, with no additional work required beyond installing the operating
system.

What follows are some quick-start guides to get you up and running, whichever operating system you
decide to use. These guides assume you are using either your own computer (such as a laptop you bring to
work), or a university computer on which you have local administrator access (your local IT department 
will be able to tell you if you have local admin). If you're using a shared computer at UQ then most of
the required programs should already be installed (contact UQ ITS if there's anything in this guide
which you need but isn't installed on the shared computers - you won't be able to do it yourself).

## Windows
Windows users can get by with relatively little setup, as long as you're willing to do most of your work
on remote HPC clusters. You'll also need to get comfortable with using the command-line to do things,
which has a learning-curve but is well worth the effort.

In order to connect to a remote server like a cluster you'll need two programs: an *SSH client*
and an *SFTP* client. Windows 10 has both of these built in, but they must be accessed from the command
line. To use them, launch either `cmd.exe` or `Powershell` and run the commands `ssh.exe` or `sftp.exe`,
following the instructions in the [CTCMS introduction to 
Linux](/linux_tutorials/1_intro_linux.html).

It might also be useful to install the Python programming language on your computer, as this is a very
commonly-used tool in computational science. Follow the installation instructions on the 
[official Python website](https://docs.python.org/3/using/windows.html), or use the versions available
on the clusters.

Finally, if you need to do any development work (i.e. writing code), you'll need to install a
*development environment* (sort of like a word-processor for code). The easiest such program to install
and use on Windows is [Microsoft Visual Studio](https://visualstudio.microsoft.com/vs), which is freely
available under a community license. Visual Studio has support for the all programming languages you're
likely to use, such as C, C++, Fortran and Python.

## MacOS
MacOS already comes with SSH and SFTP clients, which you run by opening a terminal (by
opening `Finder` then typing `terminal` and opening the *Terminal* application) and running the command
`ssh` or `sftp` (respectively).

For additional software, it's a good idea to install the `Homebrew` software manager since this will
allow you to install almost everything you're likely to need. Follow the instructions on the [Homebrew
website](https://brew.sh/#install) and you should be able to install software by running the command
`brew install \<pkg\>` in the terminal (where `\<pkg\>` is the name of the package you want to
install).

MacOS comes bundled with an old version of Python (2.7), which may be enough for your needs if you're
not doing anything complicated. If you want a newer version (i.e. version 3 or greater), the easiest way
is to run `brew install python` in a terminal to install it via Homebrew.

For software development, I recommend using either the native MacOS `XCode` editor, or downloading
Microsoft `VS Code` via [this link](https://code.visualstudio.com/Download).

## Linux
Unlike the other operating systems in this guide, the software available to you on Linux will depend on
which *distribution* you use - each distribution has different versions of software available, along
with slightly different commands needed to install or update software. Many distributions will have a
*software center* (a graphical application, similar to an app store) to let you install software, but
some require you to use the command-line. Here is a short list of how to
install and update software for the most common distributions (all of these options require
*superuser*/*admin* permissions. Talk to ITS if you don't have this on your machine but think you need
it):

|*Distribution*  |*Install software*       |*Update software*  |*Search for software* |
|Ubuntu/Debian   |`sudo apt install <pkg>` |`sudo apt upgrade` |`apt search <query>`  |
|Fedora/CentOS   |`sudo dnf install <pkg>` |`sudo dnf update`  |`dnf search <query>`  |
|Arch/Manjaro    |`sudo pacman -S <pkg>`   |`sudo pacman -Syu` |`pacman -Ss <query>`  |

Almost every Linux distribution should come with the `ssh` and `sftp` utilities, which you
can run in a terminal via the respective commands. Almost every distribution also comes with a version
of Python installed, although some distributions have an old version (e.g. 2.7) while some have newer
versions. You can usually install newer versions via the software center or command-line. You can run
the installed Python interpreter by typing `python` at the command-line, although some distributions
like CentOS or Debian
may require you to manually specify the version of Python by running e.g. `python3` for the newer
versions.

There's a huge variety of software development tools available for Linux, but at the absolute minimum
you'll need a development environment, as well as compilers for C, C++ and Fortran. The easiest way to
do this is to install `gcc`, `g++` and `gfortran` via the command-line (the exact name of the packages to
install will differ between distributions) and to download Microsoft `VS Code` from [this 
link](https://code.visualstudio.com/Download).

# Getting access to the clusters
You'll spend a lot of time running simulations on the various HPC clusters the Bernhardt group has
access to. There are three organisations which run the clusters we use and you'll need an account with
all three, which you should create using your UQ email address. If you already have an account with one
of these organisations then you can still use it, but you'll need to make a request to be transferred to
the correct project groups. Ask your supervisor for the relevant project IDs.

Here's a table with the organisations, clusters, project ID and signup links for the major clusters
we use:

|*Organisation* |*Cluster names* |*Signup link* |
|UQ Research Computing Centre (RCC) |Bunya, Wiener |<https://rcc.uq.edu.au/high-performance-computing> |
|National Computational Infrastructure (NCI) |Gadi |<https://nci.org.au/users/how-access-nci> |
|Pawsey |Setonix |<https://support.pawsey.org.au/portal/servicedesk/customer/user/signup> |

(Note that when signing up for Pawsey clusters, you may need to ask your group leader to invite you to
the relevant project/s before you can log in to the clusters.)

Once you have an account, you can log in to the clusters via SSH using the following commands:

|Bunya (RCC)      |`ssh username@bunya.rcc.uq.edu.au`     |
|Wiener(RCC)      |`ssh username@wiener.hpc.dc.uq.edu.au` |
|Gadi (NCI)       |`ssh username@gadi.nci.org.au`         |
|Setonix (Pawsey)  |`ssh username@magnus.pawsey.org.au`    |

(Replace `username` with your username on the cluster, which would have been sent in an email when you 
signed up.)

# The next steps
If you already know how to use compute clusters (e.g. navigating, running jobs and important Linux
commands) then you're good to go! If not, CTCMS has guides on [introduction to the Linux 
command-line](/linux_tutorials/1_intro_linux.html) and [advanced Linux 
command-line usage](/linux_tutorials/2_advanced_linux.html)
which should be enough to get you up and running. If you prefer video tutorials, the Queensland Cyber
Infrastructure Fund (QCIF)'s Marlies Hankel has produced a series of short instruction videos on the
basics of Linux and HPC which are available on [the QCIF YouTube
page](https://www.youtube.com/channel/UCJVnaPvGqyupk9iVPF9A-Lg). CTCMS also has a guide on 
[visualising and plotting data
with gnuplot](/data_tutorials/gnuplot.html), which covers useful tools for
presenting your research results in an approachable manner.

Each of the clusters have extensive user support documentation which covers topics including compiling
and running code, submitting compute jobs and efficient use of available software. These guides are
excellent resources for if you get stuck, and should be your first port of call. If you need help with
something which is not covered in the guides, or need something installed or changed on the clusters,
then you'll need to lodge a ticket with the relevant helpdesk. The guides and helpdesks can be found
at the following URLs:

|*Organisation* |*Cluster names* |*User support guide URL* |*Helpdesk* |
|UQ Research Computing Centre (RCC) |Bunya, Wiener |<https://github.com/UQ-RCC/hpc-docs> |<https://rcc.uq.edu.au/support-desk> |
|National Computational Infrastructure (NCI) |Gadi |<https://opus.nci.org.au/display/Help/Gadi+User+Guide> | <https://help.nci.org.au>|
|Pawsey |Setonix |<https://support.pawsey.org.au/documentation/> | <https://support.pawsey.org.au/portal/servicedesk/customer/user/login?destination=portals> |

