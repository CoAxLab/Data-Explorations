#!/usr/bin/env python
# coding: utf-8

# # Tutorial: Repositories and version control
# 
# This lab introduces the concept of version control and goes through the process of setting up a GitHub repository and tracking changes with git.
# 
# ## Goals:
# * Set up git and GitHub
# * Learn how to use git for version control
# 
# 

# ---
# # Why version control?
# 
# Keeping with the "document everything you do" mentality, it's useful to have a plan for managing changes to your analysis and modelling projects early on. Imagine the following common situation: you have a working analysis script, but you decide to do additional analyses requested by your colleague (or advisor, or reviewer). You make the required changes, and while your new analysis works fine, suddenly you find that you can't replicate your previous results - they give you an error, or your results look different than before.
# 
# This type of thing happens surprisingly often. One way to deal with that is to always backup and then copy your script, and make changes to the copy. While this may work for simple cases, it becomes unwieldy quickly and you can end up with 10 versions of your analyses. At this point you are in a similarly confusing situation, because you have to figure out which file is the right one. If you work with other people on the same analyses, this becomes even more problematic.

# ---
# # What are git and GitHub?
# 
# This is where version control with [git](https://git-scm.com/) comes in handy! Git is a system that allows you to track the changes you or others make to your files, log the purpose of those changes, and go back and forth between different versions. 
# 
# The basic idea is that for each project that you manage, you establish what is called a *repository* for that project with git. That repository contains the files for your project, and using various commands you can instruct it to do certain things when you make changes to your files. 
# 
# Git is a command-line tool, which you control by typing commands in a console/terminal. If you are not comfortable doing that, you can use a GUI (graphical user interface) application. One is provided when you install git, but a much better one comes with GitHub (see next paragraph), which has a familiar user-interface that allows you to just point-and-click to the most common options. There is also [GitKraken](https://www.gitkraken.com/) which is independent of GitHub but a more comprehensive GUI. The command-line tool is more versatile, but if you prefer to use the app that is a-okay.
# 
# Now that we know what git is, what is GitHub? Well, git allows you to create repositories on your own computer. GitHub is a complementary service that allows you to host your repositories online via the [github.com](https://github.com) platform. That way you can share your work with collaborators, access it on different computers, and the changes you make are all synced to this central server.
# 
# For this tutorial, you will need to:
# 
# 1. Type ```git --version``` into your terminal to check whether you already have git installed. If it returns a version number, you're all set. If not...
# 
# 2. Install git. Go to https://git-scm.com/ and download the appropriate git version for your system
# 
# 3. Run the file and follow the steps to install. 
# 
# 4. Sign up for a GitHub account (use your academic .edu address - that will allow you to create private repositories) 
# 
# 5. Install the GitHub or GitKraken apps (optional)
# 

# ---
# # Use Git and GitHub

# *Note: This section has a lot of commands and concepts to keep track of, but you don't need to memorize them all. Come back to this tutorial for reference as you need it! Section 4 of this tutorial walks you through an example of how to use the tools discussed in Section 3, and you'll also get practice with git and GitHub by submitting work for this class.*

# ## Configuration
# 
# You need to configure some settings before you start. Run the following commands in your terminal, replacing them with your email and name. Use the email you used to set up your GitHub account:
# 
# ```bash
# git config --global user.email "you@andrew.cmu.edu"
# git config --global user.name "Your Name"
# ```

# ## Updated Authentication Process
# 
# In 2021, Github changed the way they authenticate users trying to push from the command line. Instead of using your GitHub username and password, you now have to use what is called a **personal access token**. If you are new to git and github, you'll need to set this up before proceeding.
# 
# Log into your GitHub account and go to **Settings** --> **Developer Settings** (bottom left) --> **Personal access tokens** --> **Tokens (classic)**. Then click **"Generate new token"** in the upper right corner (again choose "classic" if there are options). This will give you a long string of letters and numbers -- your personal access token. Copy this, and use it in lieu of your GitHub password when prompted for your login information. (You should get this prompt when you clone your first repo, or when running other commands that communicate with your GitHub account.) You can learn more about this process, including how to select permissions, [here](https://docs.github.com/en/enterprise-server@3.4/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)

# ## Basic Bash scripting
# 
# Before we do anything with git, let's walk through some basic Bash scripting in the terminal. Bash is a command language (sometimes called Unix Shell) to navigate the Unix system. We will mostly use it for navigating between folders in the terminal. For more on how to open and use the terminal (AKA command line, console) - check out [this](https://www.digitalcitizen.life/command-prompt-how-use-basic-commands) site for windows and [this](https://maker.pro/linux/projects/basic-unix-commands-to-work-on-mac-terminal) site for mac, unix, or linux.
# 
# When you open your terminal, you should see your home directory printed on the screen. To navigate to a
# different folder, we simply type
# 
# ```bash
# cd foldername
# ```
# 
# If we want to go back to the previous folder, use 
# 
# ```bash
# cd ..
# ```
# 
# In Mac/linux, you can directly go back to the home directory by simply typing 
# 
# ```bash
# cd
# ```
# 
# If you ever get confused about where you are, you can type
# 
# ```bash
# pwd
# ```
# to print the current working directory.
# 
# Once you are inside a folder, you can use 
# ```bash
# ls 
# ``` 
# for mac, or 
# ```bash
# dir 
# ```
# for Windows, to list all the files in the folder.
# 
# Bash can be very versatile. For example, you can list all the csv files in a folder 
# 
# ```bash
# ls *.csv
# ```
# 
# You can use bash to perform very complicated processing. If you are interested, read more about bash scripting [here](https://flaviocopes.com/bash/). Knowing bash scripting will save you so much hassle down the line!

# ## Set up a new repository
# You can clone a repository that exists on GitHub. This will download all files present in that repository to a folder with the name of the repository and will have the repository all set up and ready to go. The folder will be created in whatever folder your terminal is currently in! Then you can navigate to the repository folder by using the **`cd`** command.
# 
# ```bash
# git clone https://github.com/CoAxLab/DataSciencePsychNeuro_CMU85732.git
# cd DataSciencePsychNeuro_CMU85732
# ```
# 
# Alternatively, you can also initialize a repository for that project. Make a new empty folder for your project. You can do that either manually, or by typing **`mkdir pathname`** in the terminal, where pathname is the full path of your new folder. 
# 
# Copy the path of your new folder. Open a terminal window and navigate to the folder you just created with the **`cd`** command followed by your folder path. Then just type `git init` to initialize your local repository 
# 
# Windows:
# 
# ```bash
# mkdir "C:\data_science\my_awesome_project\"
# cd "C:\data_science\my_awesome_project\"
# git init
# ```
# (If the folder is not on your C: drive, first type the letter of the drive on which it is on followed by a colon)
# 
# Mac:
# 
# ```bash
# mkdir /Users/YourName/Documents/classes/data_science/my_awesome_project
# cd my_awesome_project
# git init
# ```
# 
# Equivalently, you can navigate to the desired directory before making the new folder:
# ```bash
# cd Documents/classes/data_science
# mkdir my_awesome_project
# cd my_awesome_project
# git init
# ```
# 
# Once you created your local repository using the `init` command above and/or have added and commited files to it, you can connect the repository with the remote one on GitHub using:
# 
# ```bash
# git remote add origin https://github.com/myusername/nameofrepository.git
# ```
# 
# You will need to create this remote repository on GitHub before doing so. Note: **don't** check the box that says "Add a README file" when making your remote repo on GitHub-- this will confuse git when you try to connect your local repo.

# ## Pulling changes
# Let's pretend that we are collaborating on this project together. You just cloned the repository. But after your download, I decided to make some changes to the repository by adding a file. How would this change be updated to the local version on your laptop? You "pull" the changes to your laptop by using:
# 
# ```bash
# git pull
# ```
# 
# You can also use this command when you switch to another laptop of yours and pull the most recent version of your code to the new laptop. 

# ## Adding files to be tracked
# 
# So now you have the most recent version of everything on your local computer, and you can start working. Let's say you create a new file in your local directory. Even if you save that file to your computer, at this point git doesn't know that, because it is not yet tracking that change. You need to explicitly tell git which files in the folder need to be tracked. 
# 
# To do so, you need to `git add` or "stage" your changes.
# 
# You can add all files in your folder by using a period `.` rather than a specific filename:
# 
# ```bash
# git add .
# ```
# 
# Or, you can add specific files with the following command:
# 
# ```bash
# git add script1.R script2.R
# ```
# 
# This allows you to store in the same folder both files that you need to keep a version control on, such as scripts and drafts, but also other files that you do not want to track, such as experimental stimuli, etc. You can also create a `.gitignore` file to make this easier ([more on this here](https://www.atlassian.com/git/tutorials/saving-changes/gitignore)).
# 
# If you want to double check which files were staged, you can run
# ```bash
# git status
# ```

# ## Committing changes
# 
# Adding files means telling git which files it should keep track of. However, in contrast to the "Track changes" options in Word, it does not do it continuously and automatically - you have to tell git when you want the changes you've made to be recorded! Git calls this "committing". There is a good reason for this - you want to record changes at specific identifiable moments which can allow you to go back to a specific version you need. Let's say that you have just spent some time revising your analysis script by changing the regression model you are using. You can commit your new changes with the `commit` command. You also want to briefly describe the changes you've made so that you can identify the version later. You do this by adding `-m "My description"` to the commit command:
# 
# ```bash
# git commit -m "Change regression model to logistic"
# ```
# 
# At this point, all of your changes are recorded in a single commit session. If you do this multiple times after each change, you will end up with multiple commits. You can see a log of your commits, when they happened, and your messages by typing:
# 
# ```bash
# git log
# ```
# 
# An important thing to keep in mind is that committing changes only updates your **local** repository. To merge these changes into a remote repository (e.g., GitHub), you need to `git push` the changes. More on that below.

# ## Working on a different branch
# 
# At this point you might be asking, what is the point of all of this? You have made changes and saved them, but this hasn't really affected any part of your workflow. Let's talk about branches.
# 
# If you imagine your project as a tree, you can think of each branch of a tree as an alternative version of your project. You can work on multiple versions/branches of your project at the same time. Your main branch is called **master**. It is automatically created when you initialize a repository and unless you create other branches, it will be the only one. At any point in time, you will always be in a certain branch, and any changes you make to your files at that time will only be made to files in that branch. When you create a new branch, you make a copy of the branch from which you created it. Importantly, this does not actually copy your files, and if you go into your project folder you will not see anything different at that point. Once you've made and commit any changes, you can switch between branches. Any time you switch to a branch, the files in your folder will be replaced with the files corresponding to the last changes in the branch. You can also merge branches together, implementing changes from one branch into another.
# 
# ![picture](https://drive.google.com/uc?export=view&id=12FwkUrkU3RMa7ed_tA9D-KZLwbZsJhsy)
# 
# [*image source*](https://www.atlassian.com/git/tutorials/using-branches)
# 
# How is this useful? A very common workflow that protects your files is one in which you have two branches, a **master** branch, and a **development** branch. In this setup, you never work in your master branch - you always make changes in the development branch and once you are satisfied with those changes, you merge them into your master branch. That allows you to easily switch between your current in-progress changes and your last working version of your script in your master branch.
# 
# To create a new branch and switch to it you can use the following command:
# 
# ```bash
# git checkout -b nameofnewbranch
# ```
# 
# At this point you can make any changes to your project that you like, and use the commands discussed before to add the files and commit your changes. When you do this, your new branch will contain your changes, but your **master** branch will contain a version of the repository prior to the creation of the new branch. 
# 
# The **`checkout`** command allows you not only to create new branches, when putting the **`-b branchname`** operator, but also to switch from one branch to another existing one. To do that, type the command without the **-b** operator, with the name of the branch you want to switch into. If you want to go back to your master branch:
# 
# ```bash
# git checkout master
# ```
# 
# If you now check your files, they should not contain the changes you made. You can easily go back to that working branch with:
# 
# ```bash
# git checkout nameofnewbranch
# ```
# 
# There are many different ways to use branches. If you are simultaneously testing several different versions of your analyses, you can create one branch for each, and easily switch back and forth between them, until you decide which version you want to keep. 

# ## Merging branches
# 
# You've finished making your changes on your development  branch (called **dev**), you have tested them, and you want to finalize them. You need to merge your **dev** branch with your **master**. Any time you merge two branches together, git compares their contents, checks for conflicts and combines any changes made in the different branches. In the simplest case, where you've only made changes to one of the branches, it will just replace the files in the other with the newer version. If, you've made changes to the same file under different branches, it will try to merge them. If the changes are about different parts of the file, it will combine them with no problem most of the time. If the changes are to the same lines in a file, it will create a conflict error that you will have to resolve manually before merging can occur. For now, just avoid doing that, and let's assume you've made changes only to one branch. When you merge branches, you implement the changes in whatever branch you are currently in. So, to update our master branch with the contents of **dev**, we first switch to **master**, and then invoke the merge command like this:
# 
# ```bash
# git checkout master
# git merge dev
# ```
# 
# At this point, if you want to continue working on dev, you should switch back to it first. If you were working on a branch devoted to a specific version, let's say called **weirdtestbranch**, that you no longer need because you have merged it, you can delete the experimental branch with the following command:
# 
# ```bash
# git branch -d weirdtestbranch
# ```
# 
# This command will not let you delete a branch that has not been merged yet. If you decide that your experimental version did not pan out, and you no longer need it and do not wish to merge it, you can delete it with the **`-D`** option instead:
# 
# ```bash
# git branch -D weirdtestbranch
# ```

# ## Merge only a specific file from a branch
# 
# Sometimes you made a lot of changes to your project in a development branch, and you decide that while most of them are to be discarded, you want to keep the changes to a specific file. You can use the **`checkout`** command while in your target branch like this:
# 
# ```bash
# git checkout dev -- filetokeep.R
# ```
# 
# This will extract the filetokeep.R file from the dev branch and merge it into your current branch.
# 
# If you are unsure what files you have added, what changes you have committed, what branch you are on, etc, you can find all this information out by:
# 
# ```bash
# git status
# ```

# ---
# # Putting it all together - example workflow

# You are starting a new project. Here's an example workflow with everything we have discussed.
# 
# &nbsp; 1. Install git, make a github account
# 
# &nbsp; 2. Setup git:
# 
# ```bash
# git config --global user.email "you@andrew.cmu.edu"
# git config --global user.name "Your Name"
# ```
# 
# &nbsp; 3A: Clone an existing repository
# ```bash
# git clone https://github.com/username/myproject.git
# cd myproject
# ```
# 
# **Or**
# 
# &nbsp; 3B. Start from scratch
# 
# &nbsp; &nbsp; Create a new project folder, navigate to it, and initialize a new local repository
# 
# ```bash
# mkdir c:\projects\myproject\
# cd c:\projects\myproject\
# git init
# ```
# 
# &nbsp; &nbsp; Make a remote repository on GitHub, and copy the repository link. (Remember, **don't** create the readme file at this stage via GitHub, it will confuse git when you try to connect your local repo)
# 
# &nbsp; &nbsp; Connect the local repository to the remote
# 
# ```bash
# git remote add origin https://github.com/username/myproject.git
# ```
# 
# &nbsp; &nbsp; Create a basic project folder structure, a readme file, briefly describing the project and possibly the folder structure
# 
# &nbsp; &nbsp; Add all current files to git
# 
# ```bash
# git add .
# ```
# 
# &nbsp; &nbsp; Commit your first commit with an initialization message
# 
# ```bash
# git commit -m "Initial commit"
# ```
# 
# &nbsp; &nbsp; Push your changes to your remote github repository
# 
# ```bash
# git push
# ```
# 
# &nbsp; 4. Create a new branch called **dev** on which to develop your project
# 
# ```bash
# git checkout -b dev
# git push --set-upstream origin dev
# ```
# 
# &nbsp; 5. Develop your scripts/analyses, files, etc.
# 
# &nbsp; 6. Whenever you make changes you are happy with, add the files, commit the changes and push them:
# 
# ```bash
# git add . # possibly specify specific files
# git commit -m "Explain what you have changed briefly"
# git push --set-upstream origin dev
# ```
# 
# &nbsp; 7. When you have reached a stage in which you want to save the version to be the main one, merge your dev branch with master:
# 
# ```bash
# git checkout master
# git merge dev
# git push # in order to sync the master branches
# ```
# 
# &nbsp; 8. Go back to dev or a new branch, if you want to test an alternative version of the script or add new things:
# 
# ```bash
# git checkout -b specialbranchfornewfeature
# git push --set-upstream origin specialbranchfornewfeature
# ```
# 
# &nbsp; 9. At any point: check status of added files, commits, branches:
# 
# ```bash
# git status
# ```
# 
# &nbsp; 10. At any point: pull most recent changes from online repository:
# 
# ```bash
# git pull
# ```
# 
# &nbsp; 11. Rinse and repeat :)
# 

# Git can be pretty confusing at first, but fortunately there are tons of resources available online. If you want a more comprehensive introduction, I recommend Jenny Bryan's [Happy Git](https://happygitwithr.com/) bookdown, which is specifically designed for people familiar with R. You can also keep an eye out for Carpentries workshops on git and the command line, which are offered regularly through the [CMU library](https://www.library.cmu.edu/services/carpentries).

# *Notebook authored by Ven Popov and edited by Krista Bond, Charles Wu, Patience Stevens, Amy Sentis, and Fiona Horner.*
