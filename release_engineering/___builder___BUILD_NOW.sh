#!/bin/bash
#
#
#
#
#
#
#======================================##======================================#
#	NOTES
#
#	* I am executing this script on Windows in GNU bash and it is working perfectly.
#	I had some issues with other versions of Cygwin bash / Git bash earlier.
#	If you experience any issues, consider installing SmartGit.
#	The latest version on website as of today (20160513) version: 7.1.3
#	With it, you will have Git bash version GNU bash, version 4.3.42(4)-release.
#
#	* Add note-line-2 here
#
#	* Add note-line-2 here
#======================================##======================================#
#
#
#
#
#
#
#======================================##======================================#
#	TODO LIST
#
#	* Currently we are operating only in two main directories as listed below.
#	1) TfA main server-side scripts directory
#	2) TfA main client-side scripts directory
#	If we expand our minification operations to other file/directories more space can be saved.
#	TODO: process entirety of source_code directory but  leave 3rd party content untouched (such as Epoch files).
#	To do this, create a new config option:	list of protected files.
#	Before parsing modification_dir move protected files out.
#	After parsing modification_dir move protected files back in so that 
#	they won't be changed.
#
#	* Add new TODO item here
#
#	* Add new TODO item here
#
#	* Add new TODO item here
#======================================##======================================#
#
#
#
#
#
#
#======================================##======================================#
# *** CONFIGURATION SECTION ***
#
# NOTE ABOUT CLONE: 
# Script know source_code directory.
# It will create source_codeCLONE directory, run sed commands to modify CLONE's content.
# Script PBO binary will be generated from the CLONE.
# Clone will be destroyed at the end of the run.
#
# WORKDIR: We will be operating from within this directory (not that it matters, in this version of the script)
WORKDIR='/c/tmp'
STAGINGDIR='/c/git_repos.public/pub__Transport_for_Arma/release_engineering/__STAGING__'
#
# Full path to documentation directory   (inside DEVELOPMENT_DIR)
DOCUMENTATION_ROOT='/c/git_repos.public/pub__Transport_for_Arma/documentation'
#
# Full path to top level source-code directory   (inside DEVELOPMENT_DIR)
SOURCE_CODECLONE_TOP_ROOT='/c/git_repos.public/pub__Transport_for_Arma/source_codeCLONE'
SOURCE_CODE_TOP_ROOT='/c/git_repos.public/pub__Transport_for_Arma/source_code'
#
# Configuration file full filename (include extension)
CLEAN_CONFIGURATION_FILE_FULLPATH='/c/git_repos.public/pub__Transport_for_Arma/source_code/server-side/mgmTfA/serverside/mgmTfA/___CONFIGURATION___.hpp'
CLONE_CONFIGURATION_FILE_FULLPATH='/c/git_repos.public/pub__Transport_for_Arma/source_codeCLONE/server-side/mgmTfA/serverside/mgmTfA/___CONFIGURATION___.hpp'
#
# Full path to SERVER-side code CLONE directory   (inside DEVELOPMENT_DIR) (contains init)
SERVER_CODECLONE_ROOT='/c/git_repos.public/pub__Transport_for_Arma/source_codeCLONE/server-side/mgmTfA'
SERVER_CODE_ROOT='/c/git_repos.public/pub__Transport_for_Arma/source_code/server-side/mgmTfA'
#
# Full path to CLIENT-side code CLONE directory   (inside DEVELOPMENT_DIR)
CLIENT_CODECLONE_ROOT='/c/git_repos.public/pub__Transport_for_Arma/source_codeCLONE/client-side/epoch.Altis'
CLIENT_CODE_ROOT='/c/git_repos.public/pub__Transport_for_Arma/source_code/client-side/epoch.Altis'
#
# cpbo application full path to pack directories in a PBO file
CPBO_BINARY='/c/git_repos.public/pub__Transport_for_Arma/release_engineering/cpbo/cpbo.exe'
#
# Full path to save resulting SERVER-side code PBO file to   (under _GOLD_)
SERVER_SIDE_PBO_OUTPUT='/c/git_repos.public/pub__Transport_for_Arma/release_engineering/__STAGING__/mgmTfA.pbo'
#
# Full path to save resulting CLIENT-side code PBO file to   (under _GOLD_)
CLIENT_SIDE_PBO_OUTPUT='/c/git_repos.public/pub__Transport_for_Arma/release_engineering/__STAGING__/epoch.Altis.pbo'
#
# MODIFYPATH 1, 2, ...: We will modify matching files contained in these directories (won't recurse)
MODIFYPATH1='/c/git_repos.public/pub__Transport_for_Arma/source_codeCLONE/server-side/mgmTfA/serverside/mgmTfA'
MODIFYPATH2='/c/git_repos.public/pub__Transport_for_Arma/source_codeCLONE/client-side/epoch.Altis/custom/mgmTfA'
# LIGHT_MODIFYFILE(s): We will modify these files also (comments/deleteMes) but will not minify
LIGHT_MODIFYFILE1='/c/git_repos.public/pub__Transport_for_Arma/source_codeCLONE/client-side/epoch.Altis/epoch_config/sandbox_config.hpp'
#======================================##======================================#
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
# STEP:	Find all files under modification_dir which contain the string:			//__builder___DELETE_THIS
cd $WORKDIR
#
# clean up staging directory
rm -rf $STAGINGDIR/*
#
# clean up clone
rm -rf $SOURCE_CODECLONE_TOP_ROOT
#
# create clone
cp -r $SOURCE_CODE_TOP_ROOT $SOURCE_CODECLONE_TOP_ROOT
#
#
#
#======================================#
# STEP:	Find all files under modification_dir which contain the string:			//__builder___DELETE_THIS
#		then modify these matching files in place with the in-line sed expression
#			modification #1:	delete the whole line
grep --no-messages --files-with-matches --null "//__builder___DELETE_THIS" $MODIFYPATH1/* $MODIFYPATH2/* | xargs -0 sed --in-place -e '/\/\/__builder___DELETE_THIS/d'
#======================================#
# STEP:	Find all files under modification_dir which contain the string:			//__builder___UNCOMMENT_THIS
#		then modify these matching files in place with the in-line sed expression
#			modification #1:	delete the very first (most-left) two characters on each line
#			modification #2:	remove the string //__builder___UNCOMMENT_THIS
grep --no-messages --files-with-matches --null "//__builder___UNCOMMENT_THIS" $MODIFYPATH1/* $MODIFYPATH2/* | xargs -0 sed --in-place -e '/__builder___UNCOMMENT_THIS/{s/#//g;s/\/\/__builder___UNCOMMENT_THIS//g;s/\/\///g;}'
#======================================##======================================#
# STEP:	Find all files under modification_dir which contain the string:			//
#		then modify these matching files in place with the in-line sed expression
#			modification #1:	delete every matching line which contain //
grep --no-messages --files-with-matches --null "//" $MODIFYPATH1/* $MODIFYPATH2/* | xargs -0 sed --in-place -e '/\/\//d'
#======================================##======================================#
# STEP:	Find all files under modification_dir which contain the character:			TAB_CHARACTER
#		then modify these matching files in place with the in-line sed expression
#			modification #1:	replace all instances of 'tab' character with 'whitespace' character
grep --no-messages --files-with-matches --null --perl-regexp "\t" $MODIFYPATH1/* $MODIFYPATH2/* | xargs -0 sed --in-place -e 's/\t/ /g'
#======================================##======================================#
# STEP:	Find all files under modification_dir which contain the whitespace character:			WHITESPACE_CHARACTER
#		then modify these matching files in place with the in-line sed expression
#			modification #1:	replace all instances of 'multiple whitespace character' with a single 'whitespace character'
grep --no-messages --files-with-matches --null " " $MODIFYPATH1/* $MODIFYPATH2/* | xargs -0 sed --in-place -e 's/  */ /g'
#======================================##======================================#
# STEP:	Find all files under modification_dir which contain the 'newline' character:			NEWLINE_CHARACTER
#		then modify these matching files in place with the in-line sed expression
#			modification #1:	remove all 'newline' characters but the last one
grep --no-messages --files-with-matches --null " " $MODIFYPATH1/* $MODIFYPATH2/* | xargs -0 sed --in-place -e ':a;N;$!ba;s/\n/ /g'
#
#
#
#
#======================================##======================================#
# STEP:	Bring in a clean/human-readable/not-minified version of __CONFIGURATION__ file
cp $CLEAN_CONFIGURATION_FILE_FULLPATH $MODIFYPATH1/
#
#
# ### Now partially process the clean config file -- do the preprocessing work but do not do any minification
# STEP:	Find all files under modification_dir which contain the string:			//__builder___DELETE_THIS
#		then modify these matching files in place with the in-line sed expression
#			modification #1:	delete the whole line
#CLONE_CONFIGURATION_FILE_FULLPATH
sed --in-place -e '/\/\/__builder___DELETE_THIS/d' $CLONE_CONFIGURATION_FILE_FULLPATH $LIGHT_MODIFYFILE1
#======================================#
# STEP:	Find all files under modification_dir which contain the string:			//__builder___UNCOMMENT_THIS
#		then modify these matching files in place with the in-line sed expression
#			modification #1:	delete the very first (most-left) two characters on each line
#			modification #2:	remove the string //__builder___UNCOMMENT_THIS
sed --in-place -e '/__builder___UNCOMMENT_THIS/{s/#//g;s/\/\/__builder___UNCOMMENT_THIS//g;s/\/\///g;}' $CLONE_CONFIGURATION_FILE_FULLPATH $LIGHT_MODIFYFILE1
#
#
#
#======================================##======================================#
# STEP:	Create the server-side PBO
$CPBO_BINARY -y -p $SERVER_CODECLONE_ROOT $SERVER_SIDE_PBO_OUTPUT
#======================================##======================================#
# STEP:	Create the client-side PBO
$CPBO_BINARY -y -p $CLIENT_CODECLONE_ROOT $CLIENT_SIDE_PBO_OUTPUT
#======================================##======================================#
# STEP:	move server-side PBO into a clearly marked directory
mkdir -p $STAGINGDIR/'0__INSTALL_ON_YOUR_SERVER__[PBO_Files]/0__Epoch_AutoStart_PBO__[server-side]'
mv $SERVER_SIDE_PBO_OUTPUT $STAGINGDIR/'0__INSTALL_ON_YOUR_SERVER__[PBO_Files]/0__Epoch_AutoStart_PBO__[server-side]'
#======================================##======================================#
# STEP:	move client-side PBO into a clearly marked directory
mkdir -p $STAGINGDIR/'0__INSTALL_ON_YOUR_SERVER__[PBO_Files]/1__Epoch_Altis_Mission_PBO___[client-side]'
mv $CLIENT_SIDE_PBO_OUTPUT $STAGINGDIR/'0__INSTALL_ON_YOUR_SERVER__[PBO_Files]/1__Epoch_Altis_Mission_PBO___[client-side]'
#======================================##======================================#
# STEP:	Copy documentation
cp -r $DOCUMENTATION_ROOT $STAGINGDIR/
#======================================##======================================#
# STEP:	Copy human-readable source code
cp -r $SOURCE_CODE_TOP_ROOT $STAGINGDIR/
#======================================##======================================#
# STEP:	Copy __CONFIGURATION__ file (human-readable) into documentation for easy reference for users 
cp $CLEAN_CONFIGURATION_FILE_FULLPATH $STAGINGDIR/documentation/___CONFIGURATION___DEFAULT.hpp
#
#
#
# clean up clone directory
#rm -rf $SOURCE_CODECLONE_TOP_ROOT
#
#
#
#======================================#
# *** ALLOW THE DEV SEE OUTPUT ***
#read -p "Press ENTER to exit..."
#EOF