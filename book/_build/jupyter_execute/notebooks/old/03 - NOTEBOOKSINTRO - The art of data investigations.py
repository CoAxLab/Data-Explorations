#!/usr/bin/env python
# coding: utf-8

# Welcome to you first tutorial for Data Science for Psychology and Neuroscience! This first tutorial will get help you get set up using R and Jupyter notebooks. All coding for this class will be done in R, and you will submit all homeworks as Jupyter notebooks. 
# 
# 

# # Installing R and RStudio

# R is an excellent tool for statistical computing, and it's free! To download **the latest version of R (currently, 4.0.3)** on your computer, go to http://lib.stat.cmu.edu/R/CRAN/ and get the right one for your operating system (Mac, Windows, etc). If you run into problems, you can check out [this tutorial](https://www.datacamp.com/community/tutorials/installing-R-windows-mac-ubuntu) and [this FAQ page](http://lib.stat.cmu.edu/R/CRAN/faqs.html). If that doesn't help, you can email one of the instructors. 
# R is great on its own, but RStudio is software that will make it a little nicer to view your code, see documentation about functions, and look at plots. Go [here](https://rstudio.com/products/rstudio/download/) to download RStudio.
# The tutorial linked above also has instructions for installing RStudio, if you need them. 
# 
# ## Trying it out
# 
# Once you've got both of these set up, test it out! Open RStudio and type the following: 
# 
# ```bash
# ?hist
# ```
# 
# A window to the right will tell you about the function that plots histograms. 
# 
# Now make a new vector, some thing like this: 
# 
# ```bash
# x <- c(9,9,9,9,3,2,1,5,6,6,6,3,2,5)
# ```
# 
# Then make a histogram of it: 
# 
# ```bash
# hist(x)
# ```
# 
# A window to the right will display your histogram. 
# 
# To learn more about things you can do with RStudio, you can check out [this video](https://www.youtube.com/watch?v=lVKMsaWju8w).

# # Jupyter [Julia, Python, and R] Notebooks 

# ## 1. Why use Jupyter notebooks? 

# * They are an effective form of scientific communication for a variety of audiences
#     * You can weave together computational and narrative aspects of your project, adjusting the relative proportions of each for your audience. 
# * They are a testing ground for developing new analyses and visualizations 
#     * The modular nature of the cells in jupyter notebooks is convenient for testing snippets of code
# * Because of the first two points, jupyter notebooks are also useful for teaching purposes
#     * People have even written [books](https://jupyter4edu.github.io/jupyter-edu-book/why-we-use-jupyter-notebooks.html) in jupyter 
# * Finally, they are an open source platform, which means that you can share your science without limiting your audience based on whether they have a given software license
#     *Tthis makes it easy for anyone to reproduce (and learn from) your data, analyses, or visualizations 
#     * Here are some clean examples of using notebooks for [reproducible neuroscience](https://nbviewer.jupyter.org/github/wtadler/cue-combination-with-neurons/blob/master/neural_cue_combination.ipynb) and [teaching statistics](https://nbviewer.jupyter.org/github/CamDavidsonPilon/Probabilistic-Programming-and-Bayesian-Methods-for-Hackers/blob/master/Chapter1_Introduction/Ch1_Introduction_PyMC3.ipynb), and this is a [novel proposal to revamp the way we write academic papers](https://www.authorea.com/users/23/articles/8762-the-paper-of-the-future?commit=d4033594de841d252b3220927b39de4314d26409)

# ## 2. Installation

# First, download and install [anaconda](https://www.anaconda.com/download/#macosx), choosing the version associated with the latest version of Python. Anaconda is a distribution of scientific computing packages that makes it easy to install jupyter along with all of its prerequisites in a single step. 
# 
# Note that if you're using Windows, you should check the option presented during installation to "add Anaconda to your PATH environment variable". This will allow you to launch notebooks from the terminal (heads up: the terminal is also referred to as the console or the command line - we'll try to stick with "terminal" in these tutorials, though). 
# 
# Now you should be able to run 
# ```bash
# jupyter notebook 
# ```
# 
# from the terminal. 
# 
# See [this page](https://towardsdatascience.com/a-quick-guide-to-using-command-line-terminal-96815b97b955#:~:text=MacOS%3A%20Open%20spotlight%20search%20(default,app%20with%20a%20black%20background.)) for how to open the terminal. 
# 
# 
# After you execute that command, a browser should open to show your current file directory, like this: 

# ![picture](https://drive.google.com/uc?id=1yUh0c3RHkoBMwL4uPJSWjZlUwB_A5IEf)

# If you're having installation issues, look [here](https://jupyter.org/install) for help. 
# For more about jupyter notebooks, including lots of ways to customize them, see the [documentation](https://jupyter.org/documentation).     
#     

# # Installing the R kernel for Jupyter notebooks
# 
# First, you must have Jupyter notebooks and a native R installation installed. Then you can install the R kernel for jupyter notebooks.
# 
# **If you are using OS X**, you must execute these lines from the terminal. First, invoke R: 
# ```bash
# R
# ```
# Then you install the R kernel using the install.packages command (still within the terminal): 
# ```bash
# install.packages('IRkernel')
# IRkernel::installspec()  # to register the kernel in the current R installation
# ```
# 
# **If you are using Windows**, then simply execute these two lines in your installation of RStudio:
# ```R
# install.packages('IRkernel')
# IRkernel::installspec()  # to register the kernel in the current R installation
# ```
# **If you are using Linux**, then the OS X instructions should work -- if not, you'll need to install from the source code. See instructions for how to do this [here](https://irkernel.github.io/installation/#source-panel). Alternatively, you can install jupyter notebook and the R kernel on the desktops in the computer lab (Windows computers with rStudio 3.5 installed).

# Now when you execute 
# ```bash
# 
# jupyter notebook 
# 
# ```
# You should now be able to select the R kernel when you create a new notebook:  
# ![picture](https://drive.google.com/uc?id=1_XX0Gaa5ESMPhsl5M8IuqCTh70zMxV5w)
# 

# *notebook authored by Ven Popov and edited by Krista Bond, Charles Wu, and Patience Stevens*
