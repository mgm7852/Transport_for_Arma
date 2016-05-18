//H
//H ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_c_CO_scr_onPlayerRespawn.sqf
//H $PURPOSE$	:	This client-side script contains the tasks that need to be re-executed each time player spawn.
//H ~~
//H
if (!isServer) then {
	if (mgmTfA_configgv_clientVerbosityLevel>=7) then {diag_log format ["[mgmTfA] [mgmTfA_c_CO_scr_onPlayerRespawn.sqf]  [TV7]  Reached checkpoint: Found display 46! Proceeding with rest of file"];};//dbg
	// Compile and execute SQF Script: adds actionMenu when player is near a CATP (Call-a-Taxi Phonepoint).
	[] execVM "custom\mgmTfA\mgmTfA_c_FD_scr_presentCATPActionMenu.sqf";
	// spawn the clickNGo Taxi Request Hotkey-replacement function
	_null = [] spawn mgmTfA_c_CO_fnc_launchTfAGUIViaMapRapidToggle;
	// Since we are just spawning now, we cannot have a clickNGo taxi chosen destination
	deleteMarker "TATaxiChosenPosition";
	mgmTfA_dgv_thisPlayerCanOrderTATaxiViaHotkey = true;
};
// EOF