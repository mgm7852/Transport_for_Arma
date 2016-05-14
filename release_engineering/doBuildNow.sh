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
# Full path to root of the project		-- Git top level directory
PROJECT_PATH='/c/git_repos.public/pub__Transport_for_Arma'
# Full path to tmp directory		-- Git top level directory
TMP_PATH='/c/tmp/x9'
# Full path to tmp/source_codeCLONE directory
TMP_SOURCE_CODECLONE_PATH='/c/tmp/x9/scc'
#
# Expected to be directly under PROJECT_ROOT_PATH
STAGING_DIRNAME='__STAGING__'
STAGING_PATH='/c/git_repos.public/pub__Transport_for_Arma/release_engineering/__STAGING__'
#
# Expected to be directly under PROJECT_ROOT_PATH
DOCUMENTATION_DIRNAME='documentation'
DOCUMENTATION_PATH='/c/git_repos.public/pub__Transport_for_Arma/documentation'
#
# Full path to CLEAN source code top level directory		-- under PROJECT_PATH & contains "server-side" & "client-side"
SOURCE_CODE_DIRNAME='source_code'
SOURCE_CODE_ROOT='/c/git_repos.public/pub__Transport_for_Arma/source_code'
SOURCE_CODE_PACKEDARCHIVEFILENAME='source_code.7z'
#
#
#
# Full path to SERVER-side CLEAN source code directory		-- under ROOT_PATH & contains init
SERVER_CODE_ROOT='/c/git_repos.public/pub__Transport_for_Arma/source_code/server-side/mgmTfA'
# Full path to SERVER-side CLONE source code directory		-- underTMP_PATH. will be created by the script by copying the clean one. will contain init
SERVER_CODECLONE_ROOT='/c/tmp/x9/scc/server-side/mgmTfA'
# Full path to SERVER-side CLEAN source code SQF directory		-- under PROJECT_PATH\SERVER_CODE_ROOT\.	contains project .SQF files.	we will read the contents and take a copy (then, will modify the copy)
SERVER_CODE_SQFDIR='/c/git_repos.public/pub__Transport_for_Arma/source_code/server-side/mgmTfA/serverside/mgmTfA'
# Full path to SERVER-side CLONE source code SQF directory		-- under TMP_PATH\SERVER_CODECLONE_ROOT\.	contains project .SQF files.	we will modify contents with sed before packing into the .PBO file
SERVER_CODECLONE_SQFDIR='/c/tmp/x9/scc/server-side/mgmTfA/serverside/mgmTfA'
#
#
# Full path to CLIENT-side CLEAN code directory		-- under ROOT_PATH & contains description.ext
CLIENT_MPMISSION_DIR='/c/git_repos.public/pub__Transport_for_Arma/source_code/client-side/epoch.Altis'
# Full path to CLIENT-side CLONE source code directory		-- underTMP_PATH. will be created by the script by copying the clean one. will contain description.ext
CLIENT_MPMISSIONCLONE_DIR='/c/tmp/x9/scc/client-side/epoch.Altis'
# Full path to CLIENT-side CLEAN source code SQF directory (not root directory!)		-- under TMP_PATH.	contains project .SQF files.	we will modify contents with sed
CLIENT_CODE_SQF='/c/git_repos.public/pub__Transport_for_Arma/source_code/client-side/epoch.Altis/custom/mgmTfA'
# Full path to CLIENT-side CLONE source code SQF directory (not root directory!)		-- under TMP_PATH\CLIENT_CODECLONE_ROOT\.	contains project .SQF files.	we will modify contents with sed before packing into the .PBO file
CLIENT_CODECLONE_SQF='/c/tmp/x9/scc/client-side/epoch.Altis/custom/mgmTfA'
#
#
# Aliases
MODIFYPATH1=$SERVER_CODECLONE_SQFDIR
MODIFYPATH2=$CLIENT_CODECLONE_SQF
#
#
# Configuration file filename		-- include the file extension
CONFIGURATION_FILENAME='___CONFIGURATION___.hpp'
# CLEAN Configuration file full path including filename		-- include the file extension
CONFIGURATION_FILECLEAN_FULLPATH='/c/git_repos.public/pub__Transport_for_Arma/source_code/server-side/mgmTfA/serverside/mgmTfA/___CONFIGURATION___.hpp'
# CLONE Configuration file full path including filename		-- include the file extension
CONFIGURATION_FILECLONE_FULLPATH='/c/tmp/x9/scc/server-side/mgmTfA/serverside/mgmTfA/___CONFIGURATION___.hpp'
#
#
# Full path to save resulting SERVER-side code PBO file to		-- under STAGING
SERVER_SIDE_PBO_OUT_FULLPATH='/c/git_repos.public/pub__Transport_for_Arma/release_engineering/__STAGING__/mgmTfA.pbo'
# Full path to save resulting CLIENT-side code PBO file to		-- under STAGING
CLIENT_SIDE_PBO_OUT_FULLPATH='/c/git_repos.public/pub__Transport_for_Arma/release_engineering/__STAGING__/epoch.Altis.pbo'
#
#
# LIGHT_MODIFYFILE(s): We will modify these files also (comments/deleteMes) but will not minify
LIGHT_MODIFYCLONEFILE_FULLPATH='/c/tmp/x9/scc/client-side/epoch.Altis/epoch_config/sandbox_config.hpp'
#
# 
# DO_NOT_MODIFY_FILE: We will NOT modify these files in any way
DO_NOT_MODIFY_FILE1_CLEAN_FULLPATH='/c/git_repos.public/pub__Transport_for_Arma/source_code/server-side/mgmTfA/serverside/mgmTfA/EPOCH_exp_functions/EPOCH_exp_server_effectCrypto.sqf'
DO_NOT_MODIFY_FILE1_CLONE_FULLPATH='/c/tmp/x9/scc/server-side/mgmTfA/serverside/mgmTfA/EPOCH_exp_functions/EPOCH_exp_server_effectCrypto.sqf'
#
DO_NOT_MODIFY_FILE2_CLEAN_FULLPATH='/c/git_repos.public/pub__Transport_for_Arma/source_code/server-side/mgmTfA/serverside/mgmTfA/mgmTfA_s_CO_dat_maleFirstnamesTextStringArray.hpp'
DO_NOT_MODIFY_FILE2_CLONE_FULLPATH='/c/tmp/x9/scc/server-side/mgmTfA/serverside/mgmTfA/mgmTfA_s_CO_dat_maleFirstnamesTextStringArray.hpp'
#
#
# cPBO Windows application to pack directories into ".PBO" format -- provide the full path
CPBO_BINARY_PATH='/c/git_repos.public/pub__Transport_for_Arma/release_engineering/cpbo/cpbo.exe'
# 7zip Windows application to pack source code into a single archive file in ".7z" format -- provide the full path
SEVENZ_BINARY_PATH='/c/git_repos.public/pub__Transport_for_Arma/release_engineering/7z/7z.exe'
#
# GNUPG md5sum.exe full path
#CHECKSUMMD5_BINARY_PATH='/c/git_repos.public/pub__Transport_for_Arma/release_engineering/gnupg_checksummers/md5sum.exe'
# GNUPG md5sum.exe full path
#CHECKSUMSHA1_BINARY_PATH='/c/git_repos.public/pub__Transport_for_Arma/release_engineering/gnupg_checksummers/sha1sum.exe'
# GNUPG md5sum.exe full path
CHECKSUMSHA256_BINARY_PATH='/c/git_repos.public/pub__Transport_for_Arma/release_engineering/gnupg_checksummers/sha256sum.exe'
CHECKSUMSHA256_BINARY_FILENAME='sha256sum.exe'
# VERIFY_INTEGRITY batch script
VERIFY_INTEGRITY_FULLPATH='/c/git_repos.public/pub__Transport_for_Arma/release_engineering/verify_integrity_batch_script/sha256sum.__RUN_TO_VERIFY_INTEGRITY__.bat'
#
# bc application to do maths in command line -- provide the full path
BC_BINARY_PATH='/c/git_repos.public/pub__Transport_for_Arma/release_engineering/bc/bc.exe'
#
VERSIONHPPFILEFULLPATH='/c/git_repos.public/pub__Transport_for_Arma/source_code/server-side/mgmTfA/serverside/mgmTfA/mgmTfA_s_CO_dat_TfAVersion.hpp'
#
VERSIONMAJORFILEFULLPATH='/c/git_repos.public/pub__Transport_for_Arma/source_code/server-side/mgmTfA/serverside/mgmTfA/vn/mgmTfAVersionAMajorNumber.txt'
VERSIONMINORFILEFULLPATH='/c/git_repos.public/pub__Transport_for_Arma/source_code/server-side/mgmTfA/serverside/mgmTfA/vn/mgmTfAVersionBMinorNumber.txt'
VERSIONPATCHFILEFULLPATH='/c/git_repos.public/pub__Transport_for_Arma/source_code/server-side/mgmTfA/serverside/mgmTfA/vn/mgmTfAVersionCPatchNumber.txt'
VERSIONBUILDFILEFULLPATH='/c/git_repos.public/pub__Transport_for_Arma/source_code/server-side/mgmTfA/serverside/mgmTfA/vn/mgmTfAVersionDBuildIDNumber.txt'
#
STORAGE_ROOTPATH='/c/git_repos.public/pub__Transport_for_Arma/release_packages/_autogenerated'
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
#
#
#
#
#======================================##======================================#
# *** MAIN ***
#
# clean up tmp dir & re-create it
mkdir -p $TMP_PATH
rm -rf $TMP_PATH/*
mkdir -p $TMP_SOURCE_CODECLONE_PATH
#
# clean up staging dir & re-create it
rm -rf $STAGING_PATH
mkdir -p $STAGING_PATH
cd $STAGING_PATH
#
#
cp -r $SOURCE_CODE_ROOT/* $TMP_SOURCE_CODECLONE_PATH
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
#
#
############################################################
#	BUILD ID AUTO-INCREMENT BY BUILDER -- HOW THIS WORKS
#
#	1. On each execution, doBuildNow.sh will read the BUILDID value from VERSIONBUILDFILEFULLPATH file:								BUILDID=$(<$VERSIONBUILDFILEFULLPATH)
#	2. doBuildNow.sh will then increment the BUILDID value by one and write it back into the same file:							BUILDID=$(<$VERSIONBUILDFILEFULLPATH) ; echo "$BUILDID+1" | $BC_BINARY_PATH > $VERSIONBUILDFILEFULLPATH
#	3. doBuildNow.sh will also update the document mgmTfA_s_CO_dat_TfAVersion.hpp with the just-incremented BUILDID number:		TODO
#		HOW TO DO THIS STEP
#			find the line beginning with:			mgmTfA_configgv_TfAScriptVersionbuildIDNumber=
#			replace the content with:				mgmTfA_configgv_TfAScriptVersionbuildIDNumber=	and append $BUILDID	and append the character ;
#			sed -i "s/$var1/ZZ/g" "$file"
#			sed -i "s/mgmTfA_configgv_TfAScriptVersionbuildIDNumber=/mgmTfA_configgv_TfAScriptVersionbuildIDNumber=$var1/g" "$VERSIONHPPFILEFULLPATH"
#			sed --in-place "s/^mgmTfA_configgv_TfAScriptVersionbuildIDNumber=.*$/mgmTfA_configgv_TfAScriptVersionbuildIDNumber=$BUILDID;/" "$VERSIONHPPFILEFULLPATH"
############################################################
#
# prefix tag
SEMANTIC_VERSIONED_FILENAME_PREFIX="mgmTfA_v"
SEMANTIC_VERSIONED_FILENAME_DOT="."
SEMANTIC_VERSIONED_FILENAME_WORDBUILD="build"
SEMANTIC_VERSIONED_FILENAME_EXTENSION="7z"
#
# Obtain the current MAJORVERSION from the .txt file
MAJORVERSION=$(<$VERSIONMAJORFILEFULLPATH)
#
# Obtain the current MINORVERSION from the .txt file
MINORVERSION=$(<$VERSIONMINORFILEFULLPATH)
#
# Obtain the current PATCHVERSION from the .txt file
PATCHVERSION=$(<$VERSIONPATCHFILEFULLPATH)
#
# Obtain the current BUILDID from the .txt file
BUILDID=$(<$VERSIONBUILDFILEFULLPATH) ; echo "$BUILDID+1" | $BC_BINARY_PATH > $VERSIONBUILDFILEFULLPATH
# we just bumped it, so re-read to obtain the actual number
BUILDID=$(<$VERSIONBUILDFILEFULLPATH)
#
# Increment the VERSION values in versionHPP file so that it can be displayed in-game
sed --in-place -e "s/^mgmTfA_configgv_TfAScriptVersionMajorNumber=.*$/mgmTfA_configgv_TfAScriptVersionMajorNumber=$MAJORVERSION;/" "$VERSIONHPPFILEFULLPATH"
sed --in-place -e "s/^mgmTfA_configgv_TfAScriptVersionMinorNumber=.*$/mgmTfA_configgv_TfAScriptVersionMinorNumber=$MINORVERSION;/" "$VERSIONHPPFILEFULLPATH"
sed --in-place -e "s/^mgmTfA_configgv_TfAScriptVersionPatchNumber=.*$/mgmTfA_configgv_TfAScriptVersionPatchNumber=$PATCHVERSION;/" "$VERSIONHPPFILEFULLPATH"
sed --in-place -e "s/^mgmTfA_configgv_TfAScriptVersionbuildIDNumber=.*$/mgmTfA_configgv_TfAScriptVersionbuildIDNumber=$BUILDID;/" "$VERSIONHPPFILEFULLPATH"
#======================================#
#
#
#
# Now let's construct the semantic version which we will need for the 7z archive file filename. 
# This should be something like:	mgmTfA_v.0.5.0.7z
#
#
# start empty
SEMANTIC_VERSIONED_FILENAME_FULLFINALFILENAME=""
# append prefix tag
SEMANTIC_VERSIONED_FILENAME_FULLFINALFILENAME+=$SEMANTIC_VERSIONED_FILENAME_PREFIX
#
# APPEND VERSION NUMBERS
# MAJOR
SEMANTIC_VERSIONED_FILENAME_FULLFINALFILENAME+=$SEMANTIC_VERSIONED_FILENAME_DOT
SEMANTIC_VERSIONED_FILENAME_FULLFINALFILENAME+=$MAJORVERSION
# MINOR
SEMANTIC_VERSIONED_FILENAME_FULLFINALFILENAME+=$SEMANTIC_VERSIONED_FILENAME_DOT
SEMANTIC_VERSIONED_FILENAME_FULLFINALFILENAME+=$MINORVERSION
# PATCH
SEMANTIC_VERSIONED_FILENAME_FULLFINALFILENAME+=$SEMANTIC_VERSIONED_FILENAME_DOT
SEMANTIC_VERSIONED_FILENAME_FULLFINALFILENAME+=$PATCHVERSION
# BUILDID
SEMANTIC_VERSIONED_FILENAME_FULLFINALFILENAME+=$SEMANTIC_VERSIONED_FILENAME_DOT
SEMANTIC_VERSIONED_FILENAME_FULLFINALFILENAME+=$SEMANTIC_VERSIONED_FILENAME_WORDBUILD
SEMANTIC_VERSIONED_FILENAME_FULLFINALFILENAME+=$BUILDID
# FILE EXTENSION
SEMANTIC_VERSIONED_FILENAME_FULLFINALFILENAME+=$SEMANTIC_VERSIONED_FILENAME_DOT
SEMANTIC_VERSIONED_FILENAME_FULLFINALFILENAME+=$SEMANTIC_VERSIONED_FILENAME_EXTENSION
#
#
#
#
#======================================#
# Find all files under modification_dir which contain the string:			//__builder___DELETE_THIS_LINE
#		then modify these matching files in place with the in-line sed expression
#			modification #1:	delete the whole line
grep --no-messages --files-with-matches --null "//__builder___DELETE_THIS_LINE" $MODIFYPATH1/* $MODIFYPATH2/* | xargs -0 sed --in-place -e '/\/\/__builder___DELETE_THIS_LINE/d'
#======================================#
# Find all files under modification_dir which contain the string:			//__builder___UNCOMMENT_THIS_LINE
#		then modify these matching files in place with the in-line sed expression
#			modification #1:	delete the very first (most-left) two characters on each matching line
#			modification #2:	remove the string //__builder___UNCOMMENT_THIS_LINE
grep --no-messages --files-with-matches --null "//__builder___UNCOMMENT_THIS_LINE" $MODIFYPATH1/* $MODIFYPATH2/* | xargs -0 sed --in-place -e '/__builder___UNCOMMENT_THIS_LINE/{s/#//g;s/\/\/__builder___UNCOMMENT_THIS_LINE//g;s/\/\///g;}'
#======================================##======================================#
# Find all files under modification_dir which contain the string:			//
#		then modify these matching files in place with the in-line sed expression
#			modification #1:	delete every matching line which contain //
grep --no-messages --files-with-matches --null "//" $MODIFYPATH1/* $MODIFYPATH2/* | xargs -0 sed --in-place -e '/\/\//d'
#======================================##======================================#
# Find all files under modification_dir which contain the character:			TAB_CHARACTER
#		then modify these matching files in place with the in-line sed expression
#			modification #1:	replace all instances of 'tab' character with 'whitespace' character
grep --no-messages --files-with-matches --null --perl-regexp "\t" $MODIFYPATH1/* $MODIFYPATH2/* | xargs -0 sed --in-place -e 's/\t/ /g'
#======================================##======================================#
# Find all files under modification_dir which contain the whitespace character:			WHITESPACE_CHARACTER
#		then modify these matching files in place with the in-line sed expression
#			modification #1:	replace all instances of 'multiple whitespace character' with a single 'whitespace character'
grep --no-messages --files-with-matches --null " " $MODIFYPATH1/* $MODIFYPATH2/* | xargs -0 sed --in-place -e 's/  */ /g'
#======================================##======================================#
# Find all files under modification_dir which contain the 'newline' character:			NEWLINE_CHARACTER
#		then modify these matching files in place with the in-line sed expression
#			modification #1:	remove all 'newline' characters but the last one
grep --no-messages --files-with-matches --null " " $MODIFYPATH1/* $MODIFYPATH2/* | xargs -0 sed --in-place -e ':a;N;$!ba;s/\n/ /g'
#
#
#
#
#======================================##======================================#
# Bring in a clean/human-readable/not-minified version of __CONFIGURATION__ file in to the TMP_PATH
cp $CONFIGURATION_FILECLEAN_FULLPATH $CONFIGURATION_FILECLONE_FULLPATH
#
#
# Now partially process the config clone file -- do the preprocessing work but do not do any minification
# Process the config clone file, find the string:			//__builder___DELETE_THIS_LINE
#		then modify the file in place with the in-line sed expression
#			modification #1:	delete the whole line
grep --no-messages --files-with-matches --null "//__builder___DELETE_THIS_LINE" $CONFIGURATION_FILECLONE_FULLPATH | xargs -0 sed --in-place -e '/\/\/__builder___DELETE_THIS_LINE/d'
#
# Process the config clone file, find the string:			//__builder___UNCOMMENT_THIS_LINE
#		then modify the file in place with the in-line sed expression
#			modification #1:	delete the very first (most-left) two characters on each matching line
#			modification #2:	remove the string //__builder___UNCOMMENT_THIS_LINE
grep --no-messages --files-with-matches --null "//__builder___UNCOMMENT_THIS_LINE" $CONFIGURATION_FILECLONE_FULLPATH | xargs -0 sed --in-place -e '/__builder___UNCOMMENT_THIS_LINE/{s/#//g;s/\/\/__builder___UNCOMMENT_THIS_LINE//g;s/\/\///g;}'
#
# do exactly the same with LIGHT_MODIFYCLONEFILE_FULLPATH
grep --no-messages --files-with-matches --null "//__builder___DELETE_THIS_LINE" $LIGHT_MODIFYCLONEFILE_FULLPATH | xargs -0 sed --in-place -e '/\/\/__builder___DELETE_THIS_LINE/d'
grep --no-messages --files-with-matches --null "//__builder___UNCOMMENT_THIS_LINE" $LIGHT_MODIFYCLONEFILE_FULLPATH | xargs -0 sed --in-place -e '/__builder___UNCOMMENT_THIS_LINE/{s/#//g;s/\/\/__builder___UNCOMMENT_THIS_LINE//g;s/\/\///g;}'
#
#
# Bring in any DO_NOT_MODIFY files
cp $DO_NOT_MODIFY_FILE1_CLEAN_FULLPATH $DO_NOT_MODIFY_FILE1_CLONE_FULLPATH
cp $DO_NOT_MODIFY_FILE2_CLEAN_FULLPATH $DO_NOT_MODIFY_FILE2_CLONE_FULLPATH
#
#
# Create the server-side PBO
$CPBO_BINARY_PATH -y -p $SERVER_CODECLONE_ROOT $SERVER_SIDE_PBO_OUT_FULLPATH
# Create the client-side PBO
$CPBO_BINARY_PATH -y -p $CLIENT_MPMISSION_DIR $CLIENT_SIDE_PBO_OUT_FULLPATH
#
#
# move server-side PBO into a clearly marked directory
mkdir -p $STAGING_PATH/'0__INSTALL_ON_YOUR_SERVER__PBO_Files/0__Epoch_AutoStart_PBO____server-side'
mv $SERVER_SIDE_PBO_OUT_FULLPATH $STAGING_PATH/'0__INSTALL_ON_YOUR_SERVER__PBO_Files/0__Epoch_AutoStart_PBO____server-side/'
#======================================##======================================#
# move client-side PBO into a clearly marked directory
mkdir -p $STAGING_PATH/'0__INSTALL_ON_YOUR_SERVER__PBO_Files/1__Epoch_Altis_Mission_PBO_____client-side'
mv $CLIENT_SIDE_PBO_OUT_FULLPATH $STAGING_PATH/'0__INSTALL_ON_YOUR_SERVER__PBO_Files/1__Epoch_Altis_Mission_PBO_____client-side/'
#======================================##======================================#
# Copy documentation
cp -r $DOCUMENTATION_PATH $STAGING_PATH/
#======================================##======================================#
# Copy human-readable source code
cp -r $SOURCE_CODE_ROOT $STAGING_PATH/
#======================================##======================================#
# Copy light processed __CONFIGURATION__ file (human-readable) into documentation for easy reference
cp $CONFIGURATION_FILECLONE_FULLPATH $STAGING_PATH/documentation/___CONFIGURATION___DEFAULT.hpp
#
# Now pack the cloned source code in staging directory into a single ultra compressed 7zip archive file
# ref:	https://sevenzip.osdn.jp/chm/cmdline/switches/method.htm
# ref:	http://stackoverflow.com/a/28474846
$SEVENZ_BINARY_PATH a -bd -bb0 -t7z $SOURCE_CODE_PACKEDARCHIVEFILENAME $STAGING_PATH/$SOURCE_CODE_DIRNAME/*
#
#
# delete everything from STAGING source code clone directory
rm -rf $STAGING_PATH/$SOURCE_CODE_DIRNAME/*
# move the source_code archive package into its own directory
mv $STAGING_PATH/$SOURCE_CODE_PACKEDARCHIVEFILENAME $STAGING_PATH/$SOURCE_CODE_DIRNAME/$SOURCE_CODE_PACKEDARCHIVEFILENAME
#
#
# Now pack the release-ready STAGING directory contents into a single compressed 7zip archive file
#	INPUT		C:\git_repos.public\pub__Transport_for_Arma\release_engineering\__STAGING__
#	OUTPUT		C:\git_repos.public\pub__Transport_for_Arma\release_engineering\__STAGING__\mgmTfA.7z
$SEVENZ_BINARY_PATH a -bd -bb0 -t7z $TMP_PATH/$SEMANTIC_VERSIONED_FILENAME_FULLFINALFILENAME $STAGING_PATH/*
# delete everything from STAGING
rm -rf $STAGING_PATH/*
# move the single compressed 7zip archive file into the staging directory
mv $TMP_PATH/$SEMANTIC_VERSIONED_FILENAME_FULLFINALFILENAME $STAGING_PATH/
# create checksums for the single compressed 7zip archive file
# GNUPG md5sum.exe full path
#$CHECKSUMMD5_BINARY_PATH $STAGING_PATH/$SEMANTIC_VERSIONED_FILENAME_FULLFINALFILENAME > $STAGING_PATH/md5sum.txt
# GNUPG md5sum.exe full path
#$CHECKSUMSHA1_BINARY_PATH $STAGING_PATH/$SEMANTIC_VERSIONED_FILENAME_FULLFINALFILENAME > $STAGING_PATH/sha1sum.txt
# GNUPG md5sum.exe full path
cd $STAGING_PATH
cp $CHECKSUMSHA256_BINARY_PATH $STAGING_PATH/
cp $VERIFY_INTEGRITY_FULLPATH $STAGING_PATH
$CHECKSUMSHA256_BINARY_FILENAME $SEMANTIC_VERSIONED_FILENAME_FULLFINALFILENAME > sha256sum.txt
#
#
# Move the build from STAGING to AUTOGENERATED
# first create a new directory for this major-minor-patch-build combination
STORAGE_DIRNAME="v."
STORAGE_DIRNAME+=$MAJORVERSION
STORAGE_DIRNAME+=$SEMANTIC_VERSIONED_FILENAME_DOT
STORAGE_DIRNAME+=$MINORVERSION
STORAGE_DIRNAME+=$SEMANTIC_VERSIONED_FILENAME_DOT
STORAGE_DIRNAME+=$PATCHVERSION
STORAGE_DIRNAME+=$SEMANTIC_VERSIONED_FILENAME_DOT
STORAGE_DIRNAME+=$SEMANTIC_VERSIONED_FILENAME_WORDBUILD
STORAGE_DIRNAME+=$BUILDID
#
mkdir $STORAGE_ROOTPATH/$STORAGE_DIRNAME
mv $STAGING_PATH/* $STORAGE_ROOTPATH/$STORAGE_DIRNAME
#
############
# all done
############
#
#
# clean up tmp_path
rm -rf $TMP_PATH/*
#
#
#======================================#
# *** ALLOW THE DEV SEE OUTPUT ***
#read -p "Press ENTER to exit..."
#EOF