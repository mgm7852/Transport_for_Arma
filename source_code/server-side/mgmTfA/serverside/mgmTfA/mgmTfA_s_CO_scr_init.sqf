//H
//H ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_s_CO_scr_init.sqf
//H $PURPOSE$	:	// Transport for Arma server-side	--	our very own 'init.sqf' imitation			-- scheduled environment
//H ~~
//H
if (!isServer) exitWith {}; if (isNil("mgmTfA_Server_Init")) then {mgmTfA_Server_Init=0;}; waitUntil {mgmTfA_Server_Init==1}; private ["_thisFileVerbosityLevelNumber"]; _thisFileVerbosityLevelNumber = mgmTfA_configgv_serverVerbosityLevel;

////Register Server-side Event Handlers
[] execVM "\x\addons\custom\serverside\mgmTfA\mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf";

////HQ stuff
//Create Taxi Corp. HQ Building
[] execVM "\x\addons\custom\serverside\mgmTfA\mgmTfA_s_CO_scr_initCreateObjectHQBuilding.sqf";
// Create Taxi Corp. HQ Map Marker
[] execVM "\x\addons\custom\serverside\mgmTfA\mgmTfA_s_CO_scr_initCreateMapMarkerHQ.sqf";

////CATP Stuff
//Create CATP(Call-a-Taxi Point) Objects
[] execVM "\x\addons\custom\serverside\mgmTfA\mgmTfA_s_CO_scr_initCreateObjectCATP01.sqf";
[] execVM "\x\addons\custom\serverside\mgmTfA\mgmTfA_s_CO_scr_initCreateObjectCATP02.sqf";
[] execVM "\x\addons\custom\serverside\mgmTfA\mgmTfA_s_CO_scr_initCreateObjectCATP03.sqf";
//Create CATP(Call-a-Taxi Point) Map Markers
[] execVM "\x\addons\custom\serverside\mgmTfA\mgmTfA_s_FD_scr_initCreateMapMarkerCATP01.sqf";
[] execVM "\x\addons\custom\serverside\mgmTfA\mgmTfA_s_FD_scr_initCreateMapMarkerCATP02.sqf";
[] execVM "\x\addons\custom\serverside\mgmTfA\mgmTfA_s_FD_scr_initCreateMapMarkerCATP03.sqf";

////Taxi Fixed Destination Stuff - Create the Map Markers
//Create all FD Map Markers
[] execVM "\x\addons\custom\serverside\mgmTfA\mgmTfA_s_FD_scr_initCreateMapMarkerTaxiFixedDestination01.sqf";
[] execVM "\x\addons\custom\serverside\mgmTfA\mgmTfA_s_FD_scr_initCreateMapMarkerTaxiFixedDestination02.sqf";
[] execVM "\x\addons\custom\serverside\mgmTfA\mgmTfA_s_FD_scr_initCreateMapMarkerTaxiFixedDestination03.sqf";

if (mgmTfA_configgv_serverVerbosityLevel>=2) then {diag_log format ["[mgmTfA][mgmTfA_s_CO_scr_init.sqf] END reading file."];};//dbg
// EOF