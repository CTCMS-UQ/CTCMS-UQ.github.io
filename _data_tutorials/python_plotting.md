---
layout: page
title: "Programming and visualising data with Python"
categories: visualisation data-analysis
---

# Introduction
This guide is a little different to the others on this site, in that it's more of a list of 
resources for getting started, as well as a set of "best practices" to follow. There are 
many, many tutorials purporting to teach python and data analysis so there's not much point in providing
another fully-fledged guide when we can leverage one that already exists. Unfortunately, some of the
resources on python are very good, while some basically useless and it can be overwhelming to try to sort 
through as a beginner. 

This guide therefore aims to point you towards the useful resources so you can learn at your own pace
and is split into three topics: "Introductory Python", "Plotting and Data Visualisation" and "Advanced
Python". All of the resources linked throughout this guide are freely (and legally) available online and
have been (mostly) vetted for accuracy. 

## Prerequisites
You'll need to know the basics of interacting with a computer and manipulating files and directories
before you can start learning python. Some basic familiarity with the command-line would also be
beneficial - CTCMS's [Introduction to the Linux command-line](/linux_tutorials/1_intro_linux.html) is a
good way to get up to speed. Finally, you'll need a working python installation on your computer before
you can do anything. The official python documentation has installation guides for
[Windows](https://docs.python.org/3/using/windows.html), [Mac](https://docs.python.org/3/using/mac.html)
and [Linux](https://docs.python.org/3/using/unix.html).

# Introductory Python
If you don't know how to program in python but would like to learn, this is the place to start. The
resources in this section assume no prior knowledge of python or programming in general and are designed
for you to follow along at your own pace.

## Software Carpentry - Programming with Python
- <https://swcarpentry.github.io/python-novice-inflammation/index.html>

Software Carpentry is a long-running initiative to teach researchers practical computational skills to
enable them to get more done. They operate as both a set of online resources and as a network of
accredited, volunteer teachers who run hands-on workshops aimed at scientists and engineers.
They have an excellent introduction to python (at the above link and
[here](https://swcarpentry.github.io/python-novice-inflammation/index.html)), which even includes an
introduction to data visualisation. This workshop is also regularly
hosted by QCIF (Queensland Cyber Infrastructure Fund) for Queensland-based researchers. Check [this
link](https://www.qcif.edu.au/trainingcourses/plotting-and-programming-with-python/) for details and
upcoming sessions. 

## Automate the Boring Stuff with Python - Al Sweigert
- <https://automatetheboringstuff.com/>

If the Software Carpentry workshop isn't your style, *Automate the Boring Stuff* is an excellent
introduction to python for beginners. It focuses on "learning by doing" through a series of small but
practical programs designed to automate common computer tasks. It's more focused on general purpose
programming than data science, but is a great introductory textbook nonetheless.

## Official Python Documentation
- Tutorial: <https://docs.python.org/3/tutorial/index.html>
- Library reference: <https://docs.python.org/3/library/index.html>

The python project has some excellent official documentation which is regularly updated as new features
are added to the language. The [official tutorial](https://docs.python.org/3/library/index.html) gives a
good, high-level introduction to a range of concepts, but doesn't aim for the same depth as the other
tutorials in this section. The [standard library reference](https://docs.python.org/3/library/index.html) 
is almost the opposite, as it provides extensive documentation for every part of the standard library of
functions and data types which ships with python. If you ever forget how something works or what kind of
options are available, this is the place to start.

## Guide to installing Python packages
- `pip`: <https://packaging.python.org/tutorials/installing-packages/>
- `conda`: <https://docs.conda.io/en/latest/>

The major data visualisation libraries covered in this guide are all distributed as optional addons,
*packages*, which must be installed separately to python. The default way to do this is via the `pip`
package manager, which is usually bundled with the python programming language. An increasingly popular
alternative is `conda`, which is developed by the [Anaconda project](https://www.anaconda.com/). Either
will do for our purposes, but whichever you choose, keep in mind that there are risks associated with
installing python packages. Neither PyPI (the repository used by `pip`) or Coda vet uploaded packages
for security or stability, so only install major packages you know and trust.

# Data visualisation and plotting

There are two main plotting/visualisation libraries in Python: Matplotlib and Seaborn. There are some
major differences between the two, but which one to use is ultimately dictated by personal preference
and what your collaborators are using. 

Matplotlib is directly inspired by Matlab and is closely integrated 
with python's numerical computing library [Numpy](https://numpy.org/). Matplotlib is widely used in scientific 
domains (partially due to its conceptual closeness to Matlab), but has a somewhat clunky and low-level
interface.

Seaborn, on the other hand, is newer and more inspired by the R programming language. Seaborn is closely 
integrated with the Pandas dataframe library and is aimed more towards data science and is thus less
widely used in scientific fields. It has a more modern interface and the default configuration options
for figures are easier to read (and prettier!) than Matplotlib.

## Matplotlib resources
- Installation: <https://matplotlib.org/stable/users/installing/index.html>
- Software Carpentries module (from the *Programming with Python* course):
  <https://swcarpentry.github.io/python-novice-inflammation/03-matplotlib/index.html>
- Official user guide: <https://matplotlib.org/stable/tutorials/index>

## Seaborn resources
- Installation: <https://seaborn.pydata.org/installing.html>
- Seaborn user guide: <https://seaborn.pydata.org/tutorial.html>
- Excerpt from the Python Data Science Handbook:
  <https://jakevdp.github.io/PythonDataScienceHandbook/04.14-visualization-with-seaborn.html>
- Introduction to the Pandas dataframe library (used by Seaborn):
  <https://pandas.pydata.org/docs/getting_started/index.html#getting-started>

# Further reading
This guide is intended to be a sort of "crash-course" introduction to python, so there are several
important topics in data visualisation which we haven't touched on. The topic of visualisation is 
vast and this guide is meant to be short, so here are
some useful resources you might like to familiarise yourself with in order to get the most out of your
plots and figures:

- Claus Wilke, *Fundamentals of Data Visualization*, (2019) O'Reilly Media. URL:
  <https://clauswilke.com/dataviz/>
    * This book does not focus on a single plotting program, instead aiming to be a general guide to
      making *good* plots which efficiently convey the desired information. It contains a number of real
      examples and covers a wide-range of visualisation techniques beyond those covered in this guide.
      It is freely available on the author's website under a [Creative Commons
      license](https://creativecommons.org/licenses/by-nc-nd/4.0/legalcode).
- National Institute of Standards and Technology (NIST), *eHandbook of Statistical Methods*, (2012).
  URL: <https://www.itl.nist.gov/div898/handbook/index.htm>
    * Handbook of methods and best-practices for statistics and data analysis in engineering. Of
      particular interest to this guide is ["Chapter 1: Exploratory Data 
      Analysis"](https://www.itl.nist.gov/div898/handbook/index.htm), which includes procedures and
      discussions of analysis techniques (both graphical and non-graphical) to uncover the underlying
      structure, distribution and important features of a data set. 
- Jake VanderPlas, *Python Data Science Handbook*, (2016) O'Reilly Media. URL:
  <https://jakevdp.github.io/PythonDataScienceHandbook/index.html>
    * Textbook which covers multiple aspects of data science with python: data analysis, data
      visualisation (an excerpt of which is linked above), and machine learning. It's quite a long 
      read, but worthwhile if you're at all interested in data science.
