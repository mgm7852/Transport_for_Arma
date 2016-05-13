#!/bin/bash


#======================================##======================================#
#
#	TODO LIST
#
#	Create a new config option:	list of protected files.
#	Before parsing modification_dir move protected files out.
#	After parsing modification_dir move protected files back in so that 
#	they won't be changed.
#
#======================================##======================================#

#======================================##======================================#
# *** BUILDER SCRIPT BREAK DOWN ***		i.e.: How does this work?
#======================================##======================================#
#		'/c/git_repos.private/priv__DEV_DOCS/Release_Engineering.PUB_[MOVE_THIS_TO_PUB_REPO]/BUILDER_SCRIPT_BREAK_DOWN.sh'
#
#
#
#
#
#
#======================================##======================================#
# *** CONFIGURATION SECTION ***
#
# PATH_WORKDIR_ROOT: We will be operating from within this directory (not that it matters here)
PATH_WORKDIR_ROOT='/c/tmp'
#
# PATH_MODIFICATION_ROOT: This is the top level directory - we will modify anything under this
PATH_MODIFICATION_ROOT='/c/git_repos.public/pub__Transport_for_Arma/source_code/'
#======================================##======================================#
#
#
#
#
#
#
#
#
#
#
#======================================##======================================#
# *** MAIN ***
#
# TASK:	Find all files under modification_dir which contain the string:		//__builder___DELETE_THIS
cd $PATH_WORKDIR_ROOT
#
#======================================#
# TASK:	Find all files under modification_dir which contain the string:		//__builder___DELETE_THIS
#		then modify these matching files in place with the in-line sed expression
#			modification #1:	delete the whole line
grep --recursive --files-with-matches --null "//__builder___DELETE_THIS" $PATH_MODIFICATION_ROOT | xargs -0 sed --in-place "/\/\/__builder___DELETE_THIS/d"
#
#======================================#
# TASK:	Find all files under modification_dir which contain the string:		//__builder___UNCOMMENT_THIS
#		then modify these matching files in place with the in-line sed expression
#			modification #1:	delete the very first (most-left) two characters on each line
#			modification #2:	remove the string //__builder___UNCOMMENT_THIS
grep --recursive --files-with-matches --null "//__builder___UNCOMMENT_THIS" $PATH_MODIFICATION_ROOT | xargs -0 sed --in-place -e '/__builder___UNCOMMENT_THIS/{s/#//g;s/\/\/__builder___UNCOMMENT_THIS//g;s/\/\///g;}'
#======================================##======================================#
#
#
#
#
#
#======================================#
# *** LET THE DEV SEE ***
#sleep 5s # Waits 5 seconds.
read -p "Press ENTER to exit..."
#======================================#
#
#EOF