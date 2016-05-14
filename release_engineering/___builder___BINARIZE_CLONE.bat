@ECHO OFF
SET PBOCOMMAND="C:\git_repos.public\pub__Transport_for_Arma\release_engineering\cpbo\cpbo.exe"
SET CODE__SERVER_SIDE_FULLPATH="C:\git_repos.public\pub__Transport_for_Arma\source_codeCLONE\server-side\mgmTfA"
SET PBOFILE_FULLPATH_FOR_SERVER_SIDE="C:\git_repos.public\pub__Transport_for_Arma\release_engineering\__STAGING__\0__INSTALL_ON_YOUR_SERVER__[PBO_Files]\0__Epoch_AutoStart_PBO__[server-side]\mgmTfA.pbo"
SET CODE__CLIENT_SIDE_FULLPATH="C:\git_repos.public\pub__Transport_for_Arma\source_codeCLONE\client-side\epoch.Altis"
SET PBOFILE_FULLPATH_FOR_CLIENT_SIDE="C:\git_repos.public\pub__Transport_for_Arma\release_engineering\__STAGING__\0__INSTALL_ON_YOUR_SERVER__[PBO_Files]\1__Epoch_Altis_Mission_PBO___[client-side]\epoch.Altis.pbo"
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: END:	MAIN WORKFLOW ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


:::::::::::::::::::: If it exists:		DELETE the packed "Epoch Autostart Addon" FILE the mod 
IF EXIST %PBOFILE_FULLPATH_FOR_SERVER_SIDE% (
	ECHO The file %PBOFILE_FULLPATH_FOR_SERVER_SIDE% does exist -- I will  delete it now.
	DEL %PBOFILE_FULLPATH_FOR_SERVER_SIDE%
) ELSE (
	ECHO The file %PBOFILE_FULLPATH_FOR_SERVER_SIDE% does not exist -- nothing to be do at this time.
)
::TIMEOUT 1
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::



::::::::::::::::::::BEGIN:	If it exists:		DELETE the packed "Epoch MPmissions client-side mission" FILE of the mod
IF EXIST %PBOFILE_FULLPATH_FOR_CLIENT_SIDE% (
	ECHO The file %PBOFILE_FULLPATH_FOR_CLIENT_SIDE% does exist -- I will  delete it now.
	DEL %PBOFILE_FULLPATH_FOR_CLIENT_SIDE%
) ELSE (
	ECHO The file %PBOFILE_FULLPATH_FOR_CLIENT_SIDE% does not exist -- nothing to be do at this time.
)
::TIMEOUT 1
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::



:::::::::::::::::::: Repack the SERVER code in DEVELOPMENT_DIR 			and place the resulting PBO file under Epoch's @epochhive\addons directory
::cd /D "L:\Software\arma_stuff\cPBO_[PBO_pack_unpack_tool]"
%PBOCOMMAND%	-y -p %CODE__SERVER_SIDE_FULLPATH%			%PBOFILE_FULLPATH_FOR_SERVER_SIDE%
ECHO Server-side file packed as:				%PBOFILE_FULLPATH_FOR_SERVER_SIDE%
::TIMEOUT 1
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::



:::::::::::::::::::: Repack the CLIENT code in DEVELOPMENT_DIR 			and place the resulting PBO file under Epoch's MPmissions directory
%PBOCOMMAND%	-y -p %CODE__CLIENT_SIDE_FULLPATH%		%PBOFILE_FULLPATH_FOR_CLIENT_SIDE%
ECHO Client-side MPmission file packed as:			%PBOFILE_FULLPATH_FOR_CLIENT_SIDE%
::TIMEOUT 1
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: we are done here. return to the caller
GOTO CONTINUE_MAIN_WORKFLOW_FROM___SUB__DELETE_EXISTING_PBOS__REPACK_CODE_AS_PBO__COPY_PBOS_TO_PATHS
:::::::::::::::::::: SUBROUTINE: END ::::::::::::::::::::


:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: END:	SUBROUTINE DEFINITIONS ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
TIMEOUT 15
EXIT
:: EOF