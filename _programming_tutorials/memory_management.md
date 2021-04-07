---
layout: page
title: "Memory management in C, C++ and Fortran"
author: "Emily Kahl"
categories: C C++ Fortran Debugging
---

This document is intended to provide a high-level overview of the many different ways to manage memory
in the C, C++ and Fortran programming languages. These languages were chosen as they are the most
commonly used languages in scientific computing, but also because they were foundational to the
approaches taken by later languages.

Incorrect memory management is the source of many hard to triage bugs and can severely degrade program 
performance, so it's worth taking some time to familiarise yourself with how computer programs allocate 
memory. The specifics of this guide focus on Linux, since that's the most commonly used OS for computing
clusters.

## Overview --- processes and memory
A *process* is an abstraction provided by the operating system (or *OS* e.g. 
Windows, MacOS, Linux) which contains some instructions to execute (usually 
obtained from an *executable file* stored somewhere on the machine), plus its 
own memory space to hold variables (and a few other things that aren't 
important for the purposes of this guide). The key point is that a process maps
nicely to our intuitive notion of a running computer program: the OS spins up a 
process when you ask it to run a program, the instructions (compiled from code)
of the application runs and then the operating system cleans it up when its 
done.

Throughout the course of its lifetime, a program needs to ask the OS to provide
it with memory whenever it needs to store variables like parameters, arrays or
structures. The OS will always try to fulfill requests for memory (provided
there's enough memory available on the computer), and a process "holds on" to
its memory until it either releases it back to the OS or finishes its 
execution. Many programming languages such as Python and Matlab manage this
process automatically, but C, C++ and Fortran all require some degree of manual
memory management on the part of the programmer.

## How do computers store memory? The stack and the heap
A process's memory may be stored anywhere in the computer's physical RAM, but
it is logically represented to the programmer as being arranged into a
contiguous range of *virtual addresses*: the mapping between *physical* and
virtual addresses is automatically handled by the OS and is completely
transparent to the program. A process's memory addresses are further divided
into blocks or *regions* that share certain properties. The two which are
relevant for our purposes are:

1) The *stack* contains local variables and execution control data (e.g.
the current function being executed and where in the program to return to
after the current function finishes). The stack automatically grows and
shrinks throughout the process execution without any input from the
programmer. It is fast to access, but is limited in size. Variables
allocated on the stack during a function are no longer accessible once the
function returns/exits.

2) The data segment or *heap* contains dynamically allocated variables. The
heap is only limited in size by the amount of memory available on the
computer. Variables allocated on the heap stay "alive" until they are
explicitly de-allocated, so can be accessed even after the function which
allocated them has finished.

All three languages in this guide make the distinction between statically and
dynamically allocated variables. Statically allocated variables have sizes
which are known (or can be calculated) at compile-time --- they do not
depend on any value which is set when running the program, such as command-line
parameters or input files. Statically allocated variables are always placed on
the stack. Dynamically allocated variables (for which the size is only known at
run-time) can be stored on either the stack or the heap, depending on the type
of variable and allocation. 

There are important syntactical and semantic differences in how variables are
declared and allocated between languages, so let's go through the languages one
by one.

## C
C is the most involved and "low-level" language commonly used for scientific
programming, in that it requires programmers to do manual memory management,
and has no tools to make that easier. The tradeoff is that C provides much
greater control over a program's execution and a closer coupling to the
operating system and hardware. Generally, I recommend against starting new
projects in C because it's a lot more error-prone than C++: C has a lot of
so-called "footguns" (programming devices which seemingly exist only to let you
shoot yourself in the foot) and the kinds of memory bugs you get in C tend to
be difficult to debug. But, there's a lot of pre-existing code written in C, so
if you need to use or maintain a C program, read on.

### Preliminary knowledge
Before starting, we need to cover one very important concept in programming: *scope*. Every identifier
(i.e. names of variables, classes, etc) are only able to be accessed within certain blocks of code;
outside these regions the identifier is said to be *out of scope*. Scope is usually defined with respect
to regions of *source code*, and in C this usually refers to regions of code encased in curly braces
("{" and "}"). As a program executes and enters new functions, loops or blocks, different variables will
become valid, and once it leaves a particular block those variables may *fall out of scope* and be
replaced by new ones.

The rules determining scoping in C are quite complicated, but there are some general rules which should
help make sense of the following sections:

1) Variable scope is usually limited to the block (region within curly braces) in which it is defined.
2) Variables from block of code are not visible to functions called within that region.
3) Variables defined in a block of code are visible to loops within that same block.
4) Variables defined within a loop are *not* visible to the enclosing block.
5) Variables in different scope may have the same name, but refer to different underlying bits of
memory. The variable in the innermost scope is referred to as *shadowing* the variable in the outer
scope.

Scoping rules are intimately tied to the concept of an execution stack, and thus to stack-based memory.

### Stack memory

In C, most "singleton" variable are stored on the stack. If you declare a
variable like:

` int x = 5`

Then it goes on the stack. Arrays are also allocated on the stack and can be
either static or variable-length. Fixed-length/static arrays have a length 
which is known at compile time, so have to be declared with either an integer 
expression or a constant variable, like so:
```
int arr1[5]; // Ok, makes an array of length 5
int arr2[5*10]; // Also ok, 5*10 is an integer constant expression

const int n = 10+5;
int arr3[n]; // Also ok, n is integer constant (note the "const" type)
```

Fixed-length arrays have almost no performance overhead, since their storage
requirements are determined at compile time. If you know exactly (and I do mean
*exactly*) how much space you need for some array, use a fixed-length array. If
the number of non-zero elements in an array changes at run-time, it's best to
use one of the other array types (some old code uses fixed-length arrays to
store variable-length data by allocating space that's "always big enough". This
is extremely bad design and should be avoided.).

The *C99* standard introduced *variable-length arrays* (VLAs), which are 
allocated on the stack, but whose size is dynamically determined at run-time. 
As an example:
```
int n = some_function();
int vlarr[n]; // Length cannot be determined at compile time.
```

Variable-length arrays only persist while they are *in-scope*: VLAs are
automatically de-allocated once the code block which declared them exits. If a
VLA is declared inside a loop, for example, it will be de-allocated after every
iteration of the loop:
```
for(int n = 1; n < 10; n++)
{
    int arr_loop[n];
    // Do some stuff with the array
}
    // arr_loop is no longer accessible and has been de-allocated
```

Variable-length arrays are very useful for small, temporary arrays, since they
have less performance overhead than using manual memory allocation. They should
not be used for large amounts of data, however, since the stack has a fixed
size which is small compared to the heap. If a VLA requires more memory than
the available stack space, a *stack overflow* will occur, usually crashing the
program. 

As a rule of thumb, if you're likely to need more than 100 elements,
it's better to manually allocate the memory. Many modern codebases forbid them
entirely because of these potential issues, so check before you use them.

### Heap memory
The main way to manually allocate memory in the heap is via the `malloc(size_t
size)` function. Do not attempt to access memory before you allocate it, as
this will cause segmentation faults (crashes) and other undefined behaviour.

`malloc` takes one argument of type `size_t` (on many systems this is
equivalent to a long unsigned integer), which is the size of the allocation in
bytes. Rather than writing the size of the allocation directly, the convention
is to use C's `sizeof` function to calculate the required size. For example, if
you wanted to allocate enough space for 32 integers, the `malloc` call might
look like:

```
int *p; // This will hold a pointer to the start of the allocation
p = malloc(32 * sizeof(int));
```

A successful `malloc` call returns a pointer to the start of the new
allocation (the contents of which are undefined, **not** necessarily zero); on
failure, it returns a `NULL` pointer. Dereferencing (i.e. attempting to use) a
null pointer is undefined behaviour: if you're extremely lucky the program
will simply crash, if you're unlucky it will lead to subtle memory corruption
bugs which are extremely hard to track down. It is therefore to check that each
`malloc` call was successful before using it, such as in the following snippet:

```
int *p;
p = malloc(10 * sizeof(int));

if(!p)
{
    // Print and handle the error, e.g. by exiting the program
}
```

For convenience, it can be useful to define your own wrapper function for
`malloc` which automatically handles errors. By convention, this is usually
called `xmalloc`. An example implementation (taken from Robert Love's book
*Linux System Programming*) is below:

```
void * xmalloc(size_t size)
{
    void *p;
    p = malloc(size);
    if(!p)
    {
        perror("xmalloc"); // Calls the default Linux error alerting function
        exit(EXIT_FAILURE); // EXIT_FAILURE is defined in stdlib.h
    }

    return(p);
}
```

Memory allocated via `malloc` persists until it is manually deallocated or
until the program exits. If a program repeatedly allocates memory but does not
free it, then its memory usage will continue to grow until it either exits or
exhausts the available memory (usually resulting in a crash) --- this is 
referred to as a *memory leak*. 

As its name suggests, the function `free(void * ptr)` frees the heap 
allocation at `ptr` and returns the memory to the operating system. `Free` only
de-allocates whole blocks of memory, and the input pointer must refer to the
result of a previous call to `malloc`. You cannot use `free` to de-allocate
partial chunks of memory; attempting to pass a pointer to the middle of an
allocation will result in undefined behaviour (usually a crash). `Free` does 
not return anything, so it is not necessary to check for errors after calling 
it. 

In order to avoid memory leaks, you must make sure every call to `malloc`
is accompanied by a corresponding call to `free` once you are done with the
memory. The best way to achieve this is to figure out the intended lifetime of
an allocation and write the call to `free` as soon as you write a call to 
`malloc`, otherwise you risk forgetting to free the allocation if you leave it
until later.

Once a block of memory is freed, the program must not attempt to access it
again. Attempting to dereference a pointer after it has been freed is called a
*use-after-free* bug, and is undefined behaviour: again, if you're lucky the
program will crash immediately. Otherwise, use-after-free bugs can cause all
sorts of nasty memory bugs. Similarly, trying to free a memory region twice
(referred to as a *double-free*) is also undefined behaviour.

Unfortunately, C places all of the responsibility for managing memory and
avoiding memory bugs on the programmer, and has almost no inbuilt safety
features or guardrails. It is therefore very easy to write programs which are
subtly incorrect, and can be very hard to triage when they break. There are
some useful tools for catching these kinds of bugs, including:

* [Valgrind](valgrind.org),
* [AddressSanitizer](https://github.com/google/sanitizers/wiki/AddressSanitizer) 
  in the GCC and [Clang](https://clang.llvm.org/docs/AddressSanitizer.html)
  compilers,
* [Electric fence](https://elinux.org/Electric_Fence) in GCC

But as the saying goes, an ounce of prevention is worth a pound of cure. Avoid
using manual memory management as much as possible, and, if you can, avoid
using C unless you absolutely need to.

## C++
Many sources claim that C++ is just C with classes (which was in fact its
original name), but this is an outdated way of thinking about the language. The
*C++11* standard introduced sweeping changes to the structure of the language,
to the point that it's almost a different language to earlier C++ standards.
C++11 (and later standards) have excellent tools and constructs for dynamic
memory management, which can all but eliminate the pain-points in C's memory
model. 

Not all scientific codebases have migrated to modern C++ practices, so I have
included discussion of the old ways of managing memory in case you run into
them. If you're writing your own code, then I strongly recommend using the
modern approach as it significantly reduces the chance of introducing memory
bugs with almost no performance cost.

### Stack-allocated memory

C++ arrays are stored on the stack and are almost identical to arrays in C. The
big difference is that variable-length arrays are not permitted in C++, so
arrays must be declared with a length that is known at compile time. For
example:
```
int arr[10];
int arr2[5*10];
```
are both legal array declarations, but
```
int n;
int arr3[n];
```
is not (unless `n` is an integer constant expression). GCC allows C-style VLA
declarations as an extension, but this is not standard behaviour and you
shouldn't expect it to work on all compilers (or even future versions of GCC).

For C++11 and later, the standard library defines a `std::array` container,
which behaves like a C-style fixed-size array, but includes nice
helper-functions, similar to `std::vector`. The bounds of a `std::array` must
be known at compile time, and are specified after with the type of data it 
contains, using angle-brackets. For example:

```
std::array<int, 3> arr1; // Array of 3 integers
std::array<some_complex_type, 20> arr2; // Array of 20 elements of a custom type
```

`std::array` is generally easier to use than raw C-style arrays, but otherwise
has the same semantics and memory characteristics.

### Manual heap-allocated memory
While C++ includes C-style `malloc` and `free`, their use is generally
discouraged in favour of the C++ specific operators `new` and `delete`. 

`new`
functions similarly to `malloc` in that it allocates heap memory and returns a
pointer to the beginning of the allocated block, but has syntax which
differentiates between allocating for a single value vs allocating for an
array. For example, we can allocate space on the heap for a single integer by:

```
int *p;
p = new int;
```

Similarly, we can allocate space for an array of `n` integers (where `n` can be
determined at either compile time or run-time) by:

```
int *p;
int N = ...;
p = new int[N];
```

Unlike `malloc`, `new` generally does not return a null pointer if the
allocation fails. Instead, it throws the `std::bad_alloc` exception, which
causes the program to exit (possibly with a stack-trace) unless it is
explicitly handled. Consequently, you don't need to write any error-handling
codes unless you need to do something unusual. It is possible to disable 
exceptions, in which case `new` can return NULL on failure, but there are only
a few, narrow domains in which this is common practice (scientific computing is
not one of them).

Memory allocated by `new` lasts until it is manually de-allocated or until the
program finishes execution. C++ provides the `delete` operator to free heap
memory, which has also differentiates between freeing a single element vs
freeing an array of memory. For a single allocation, the syntax is:
```
delete(ptr);
```

whereas for an array, the syntax is:

```
delete[](ptr);
```

`ptr` must point to the start of an allocation: passing a pointer to the middle
of an array results in undefined behaviour, so you can't only free part of an
allocation.

Once a block of memory is freed by `delete`, the program must not attempt to 
access it again. Attempting to dereference a pointer after it has been freed is
called a *use-after-free* bug, and is undefined behaviour: if you're lucky, the
program will crash immediately. Otherwise, use-after-free bugs can 
cause all sorts of nasty memory bugs.

As with C, every `new` must have an accompanying `delete` later in the code.
The easiest way to achieve this is to write the `new` and `delete` calls at the
same time to ensure you don't forget about them.

### Modern C++ memory management: RAII
RAII (short for *Resource Acquisition is Initialisation*) is a powerful idiom
which underlies modern C++ memory management. In RAII, allocation and
de-allocation are handled by the compiler automatically and are tied to the
object's lifetime. Broadly speaking, the C++ compiler automatically inserts
code for memory allocation when an RAII managed object is initialised (i.e.
given its initial value after being declared), and inserts de-allocation code
when the object is no longer in scope. The programmer therefore does not need
to manually acquire and free resources, but, unlike languages such as Python
which use *garbage collection*, this allocation and de-allocation happens
deterministically and predictably so its impact on performance is negligible.

RAII significantly reduces the chances of memory bugs, as it completely
eliminates the need to keep track of `malloc()`s and `free()`s for RAII managed
objects. It is also much more robust to error conditions than manual memory
management --- RAII was originally conceived of to ensure that resources would
be cleanly and automatically de-allocated when a program encounters and 
exception. In contrast, it is necessary to write exception-handling code from
scratch when using manual memory allocations, which is much more error prone.

In modern C++, only certain objects are managed via RAII. The categories which
are important for scientific programming are:
    
* Standard library containers, such as `std::vector` or `std::map`,
* Most large third-party containers, such as those in *Boost*,
* Smart pointers, such as `std::shared_ptr` and `std::unique_ptr`.

Fortunately, these categories are sufficient for almost all use-cases in
scientific computing. There is a stubbornly persistent misconception that RAII
and standard containers are slower than manual memory
allocation, but this is not true --- it is possible (and desirable) to 
build a large, high-performance scientific code base with almost all memory
management handled by smart pointers and RAII containers (see, for example
[GROMACS2020](http://manual.gromacs.org/documentation/2020-beta1/dev-manual/language-features.html) 
or [AMBiT](https://github.com/drjuls/AMBiT)). The efficiency of RAII is
dependent on the compiler making sensible decisions about when to
allocate/de-allocate memory, but major C++ compilers are very smart these days
so it almost always Just Works without needing manual intervention.

### Standard (and not-so-standard) containers
C++ comes with a rich standard library, including implementations of several
commonly-used data structures. These implementations are referred to as
*containers*, and can be used to store any data type, including custom classes
(with one or two exceptions). As the name suggests, standard containers have
a consistent interface and syntax, and provide similar utility functions for 
manipulating the underlying data. This makes changing between different data 
structures relatively painless, even in large, complex codebases.

Standard containers all use RAII for memory management, so there's
no need to use `new` and `delete`. A full run-down of the available containers
can be found [at this link](https://en.cppreference.com/w/cpp/container), but
there's a few which are especially useful in scientific programs:

* `std::array` --- already covered in the section on stack-allocated
  memory.
* `std::vector` --- an array-like structure which automatically and 
  dynamically grows (or shrinks) in size as new elements are added (or 
  removed), meaning that it's not necessary to know how many elements the
  `vector` will contain before declaring it. Elements in a `vector` are 
  stored contiguously on the heap, so are very fast to iterate (loop) over. 
* `std::map` --- an associative array which allows for elements to be
  accessed by a key of (almost) arbitrary type (as opposed to an `array` or
  `vector` which are accessed by and integer index based on its position in
  the array). Elements in a `std::map` are stored in order, and are fast to
  access but slow to iterate over.
* `std::set` --- a collection of unique elements (i.e. a piece of data is
  either in a `set` or it is not, but cannot occur more than once), stored
  in sorted order.

Proper choice of data structure is extremely important for ensuring program
performance, and strongly depends on the characteristics of the program. If
you're unsure, feel free to ask me (Emily) and I'll be happy to help.

### Smart pointers
Smart pointers (properly introduced in C++11) allow for any type of data or
class to be managed using RAII. They act like regular pointers, but keep track
of the object's lifetime and automatically de-allocate it once it falls out of
scope. The two most commonly used types of smart pointers are `std::shared_ptr`
and `std::unique_ptr`, which have similar syntax but different use-cases.

A `shared_ptr` behaves just like a regular pointer, except it includes an extra
bit of data called a *reference counter* which keeps track of how many 
`shared_ptr` instances point to a particular underlying object at a given time
during program execution. Every time you create a new `shared_ptr`, the 
reference counter for the underlying object is incremented by 1; when the 
`shared_ptr` falls out of scope it is decremented by 1, to indicate that this 
particular pointer is no longer around. When the reference counter decreases 
to zero, there is nothing in the code which requires the underlying object 
anymore, so its associated memory (and other resources) is de-allocated. In 
this way, it is possible to pass as many pointers to the same object as 
required, without having to worry about when to free the underlying memory ---
the compiler will keep track of it and do it for you.

A `unique_ptr` keeps the automatic memory management of the `shared_ptr`, but
adds the constraint that only a single instance of the underlying object may
exist at one time. It is not possible to make a copy of a `unique_ptr`, you can
only move it around. This is less flexible than the `shared_ptr` but provides
extra safety guarantees when dealing with objects for which only a single copy
should exist. An example of this would be a pointer to the underlying grid of a
simulation: there is logically only one lattice, so if a program makes multiple
copies it risks them becoming out of sync with each other.

Smart pointers are a really useful addition to the language and significantly
reduce the chance of memory allocation bugs. They should be used whenever
possible, except in instances where strict compatibility with old C++ standards
is needed.

## Fortran
Fortran is a lot older than C, and so has its origins in a time before
computer engineers settled on a common "standard" for memory layout. As such,
the exact details of a Fortran program's memory model depend on both the choice
of Fortran standard, as well as which compiler is used to build it. There are a
few common features and guidelines which are worth knowing about regardless of
compiler, but it's worth clearing up some terminology relating to Fortran
standards first.

### Fortran standards - fixed-form vs free-form
Fortran source code was originally designed to fed to a computer via punched 
cards, which had a fixed number of columns per line (80 column limitations 
were very common). Space on the punched-cards was tight, so it made sense to 
try to encode as much information about a given line into the card as possible.
This led to the convention of *fixed-form* input: the layout of characters in a
line is significant and the presence or absence of a character in a specific 
column could change the meaning of a line. A full specification of common
fixed-form formats can be found in the [Oracle Fortran compiler
documentation](https://docs.oracle.com/cd/E19957-01/805-4939/6j4m0vn6l/index.html).

Fixed-form was the only supported syntax in Fortran until the Fortran 90
standard, which introduced so-called *free-form* input, where the format and
spacing of input lines was no longer significant (almost all modern programming
languages use free-form input, so this form is probably the most familiar to
new programmers). Since Fortran 77 was the last standard in which fixed-form
input was mandatory, the term "Fortran 77" is often used synonymously with
"fixed-form Fortran", but this is not strictly correct. Modern Fortran
standards still support fixed-form input, and all major Fortran compilers
include some flag to signify that a source-code file is in fixed-format (e.g.
gfortran has the `-ffixed-form` compiler flag).

The upshot of this is that fixed-form codebases are not restricted to Fortran
77 features --- it is possible to use modern Fortran features, including memory
management, without needing to convert fixed-form files to free form.

### Static arrays
Fortran makes a distinction between static and dynamic arrays, with static
arrays being any type of array whose size is known at compile time. This was
the only type of array provided by Fortran 77 and earlier (although many
implementations defined non-standard extensions allowing for other kinds of
memory allocation). Static arrays can be defined using either of two possible
forms:

```
integer arr(10) ! Array of 10 integers
```

or

```
integer, dimension(10,10) :: arr2D ! 2D array of 10x10 integers
```

The first syntax is the standard in Fortran 77 and earlier dialects, but is
still supported by newer standards, while the second form is used in newer
standards (either fixed- or free-form). 

The storage location of static arrays, whether they are stored on the stack of
the heap, is an implementation detail which varies between compilers: 
`gfortran` allocates static arrays on the heap, whereas the Intel Fortran 
compiler allocates them on the stack (although this can be changed using
compiler flags). Depending on the compiler, all static arrays may be allocated
and initialised at the start of a program's execution, even if they are never
used. 

Generally, it is best to avoid using large static arrays --- there are many
compiler-dependent problems which occur when the total amount of 
statically- allocated memory (from all static arrays and `COMMON` blocks in the
program) becomes too large. By default, both `gfortran` and the Intel compiler
use low-level optimisations which assume that the total amount of 
statically-allocated memory is less than 2GB, so they will not compile programs
with more memory than this threshold without special compilation flags (e.g.
`-mcmodel=medium` in `ifort`). These compilation flags result in reduced
program performance, so are a stop-gap solution at best. Furthermore, it is
impossible to use OpenMP-driven parallelism with large static arrays, as almost
all OpenMP runtimes allocate a separate copy of every static array for each 
thread --- if the arrays are too large then this will blow up the memory usage
and cause the program to immediately crash.

Even though statically-allocated arrays are very common in older codebases,
they cause enough problems that it's probably worth the programming effort to 
change to dynamically-allocated (heap) arrays for storing large amounts of 
data. As previously mentioned, it is possible to use memory management
techniques from newer Fortran standards while still maintaining fixed-form
style source code, meaning that the required changes to program structure are
relatively small.

### Dynamic allocation --- the ALLOCATABLE attribute
Fortran 90 introduced the concept of *allocatable* arrays, which are
dynamically allocated arrays stored on the heap. Allocatable arrays must be
declared with the `ALLOCATABLE` attribute, and are declared with special
*placeholder* dimensions:

```
integer, allocatable, dimension(:) :: arr1d ! 1D allocatable array of integers
real, allocatable, dimension(:,:) :: arr2d ! 2D allocatable array of reals
```

The ":" indicates to the compiler that the array will be dynamically allocated
at some point in the future, but is not itself an allocation. Before 
allocatable arrays can be used, memory must be manually allocated via the
`ALLOCATE` function (this is analogous to `malloc` in C and `new` in C++).
`ALLOCATE` takes as its argument an allocatable array which is not yet
associated with any heap memory, as well as the amount of memory to allocate.
For example, to allocate memory for the arrays `arr1d` and `arr2d` in the
example above, we would do:

```
allocate(arr1d(10))
allocate(arr2d(100, 1000))
```

The dimensions given to `ALLOCATE` must match the dimensions the target array
was declared with, but are only limited in size by the amount of available
system memory.

Fortran 90 also supplies the `DEALLOCATE` command to free the memory associated
with an array and release it back to the operating system. It takes an array
(which must be associated with an memory allocation resulting from a call to
`ALLOCATE`), and does not require dimensions to be specified. For example, to 
de-allocate `arr1d` and `arr2d`, we would use:

```
deallocate(arr1d)
deallocate(arr2d)
```

It is undefined behaviour to call `DEALLOCATE` on an array that has already
been freed, or on an array which has not been allocated.

Modern Fortran has some protection against memory leaks, as the compiler will
automatically insert calls to `DEALLOCATE` into the executable code once it
detects an array is no longer in scope. It is still sometimes necessary to
de-allocate memory, but it is not as critical as proper use of `free` in C.

## Detecting memory bugs
What about memory bugs? What do you do if a program crashes or produces junk output due to memory 
issues? Debugging memory bugs can be very difficult, but there are some useful Unix tools which can 
greatly simplify the process. These tools roughly fall into two categories: compiler tools, which
require you to recompile the code with particular flags or libraries, and runtime tools which do not
require the code to be recompiled.

### Compile-time instrumentation tools
All of the tools in this section require the code to be recompiled, which may not always be possible if
using pre-built binaries (particularly for proprietary software). They tend to give better performance
and more specific diagnostics than run-time tools, however, as they can leverage information from the
compiler to mark-up the resulting code (especially if the binary is compiled with the `-g` flag to 
insert debugging symbols). This section will focus on extensions to gcc and clang called
*Sanitizers*[sic],
which instrument the compiled code to catch and report various error conditions. The most useful
sanitizers for scientific programming are as follows:

- AddressSanitizer: also known as *ASan*, modifies memory management functions to print a warning or
  crash when encountering an invalid memory request (including operations which would not normally 
  raise a segmentation fault but are errors nonetheless). ASan has been implemented in clang and gcc
  and is enabled through the `-fsanitize=address` compiler flag (although the `libasan` library may not
  be installed by default on all systems). ASan has some cost in the form of higher memory consumption
  at run-time, so should only be used when debugging.
- UndefinedBehaviorSanitizer: also known as *UBSan*, instruments the target code to catch undefined
  behaviour such as NULL pointer dereferencing, integer overflow and division by zero. Although most
  features in UBSan are not strictly related to memory safety, it's still an extremely useful
  debugging tool. UBSan is enabled through the `-fsanitize=undefined` flag, and has very little
  overhead (so is usually fine for general use). 
- LeakSanitizer: similar to ASan (technically a part of ASan which can be run as a standalone tool),
  *LSan* detects memory leaks. Can be combined with ASan by compiling with the `fsanitize=address` flag
  and setting the environment variable `ASAN_OPTIONS=detect_leaks=1` before running the target
  executable. LSan can also be used as a standalone tool (with less overhead than the full
  AddressSanitizer) by compiling with `-fsanitize=leak`.
- Static analysis: static analysers are automated tools which analyse the source code of a program
  *without running it* to find programming bugs (including some memory bugs like double-free errors). 
  Static analysers use the same principles as regular compiler errors, but are much more thorough as 
  they are "allowed" to run for a much longer time than a compiler (where designers typically want to
  limit compilation times to improve usability). 
  
  One important tool for static analysis is the *Clang Static Analyzer*, which is developed as part of 
  the clang compiler project and leverages clang's architecture to search for programming bugs. It's
  usage is somewhat intricate, so it's a good idea to read [the 
  documentation](https://clang-analyzer.llvm.org/) before trying it out.

### Run-time tools
Dynamic instrumentation has the advantage of not requiring special compilation steps, but often comes
with a much larger performance and memory usage overhead than comparable static tools. The two most
important run-time tools are *debuggers* and *Valgrind*.

First, debuggers. Running code under a debugger like GDB is a good way to catch and inspect the state of
the program in the lead up to bugs, especially for obvious bugs like segmentation faults which halt the
program execution. Subtler bugs like silent memory corruption are more tricky to pin down, as it's often
not obvious *where* the problem is located in the code - without an obvious starting point, it can take 
a long time to move through the code execution. This makes it all the more important to brush up on 
[basic](https://www.cs.cmu.edu/~gilpin/tutorial/) and 
[advanced](https://interrupt.memfault.com/blog/advanced-gdb) GDB usage so you'll be prepared for the
kinds of gnarly bugs that come with manual memory management.

The other, major run-time memory analysis program it's important to know about is Valgrind. Valgrind is
a framework for dynamic instrumentation and analysis of code (running on Linux systems), which
virtualises the instructions making up the original program and runs them on a "synthetic CPU", where
the instructions can be instrumented by specialised tools before they are executed. The upshot of this
(somewhat technical) description is that Valgrind lets you observe and profile 100% of your code's
execution path (including any libraries you may have linked to) without needing to recompile the
executable (although if you have access to the source code you can get more detailed statistics by
compiling with the `-g` flag). Valgrind imposes a very large performance penalty, but will automatically
catch whole classes of memory bugs, so the tradeoff is well worth it when debugging code.

Valgrind includes many tools for memory and performance analysis, but the
most commonly-useful ones are [^1]:

[^1]: Valgrind also has a thread-safety analyser called `Hellgrind`, but it does not understand OpenMP
  constructs, so is not terribly useful for much scientific software in common use.

- Memcheck: checks for invalid memory accesses (e.g. out-of-bounds or use-after-free errors) and memory
  leaks. 
- Callgrind: generates call-graphs (tree-like graphical representation of a program's execution flow)
  and profiling information. Can be combined with the *kcachegrind* GUI tool for an easier-to-interpret
  overview of call-graph data.
- Massif: profiles heap memory usage over a program's lifetime. Can be combined with the GUI frontend
  *massif-visualizer* for a more easy-to-read profile.
- DHAT (Dynamic Heap Analysis Tool): analyses *how* a program uses its heap memory, including frequency
  of allocations, under-utilised allocations and inefficient access patterns. More of a niche tool than
  the other three in this list, but these kinds of bugs are extremely difficult to track down without
  DHAT.

Basic usage of Valgrind takes the following form:

```
valgrind --tool=<tool> ./your_program
```

where `<tool>` is the name of the tool you want to run (which must be all lower case). So to run a
program with the DHAT tool, you'd do something like:

```
valgrind --tool=dhat ./your_program
```

Valgrind produces a *lot* of output, so it's useful to either redirect the output to a file, or to use a
dedicated logging file through the command-line argument `--log-file=<filename>`.

As with all types of debugging, there is no "silver bullet" for catching memory bugs. However, judicious
use of these tools will help speed up the process of debugging and harden your code against memory
corruption errors.
