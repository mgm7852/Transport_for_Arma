//H
//H ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_scr_server_init.sqf
//H $PURPOSE$	:	// Transport for Arma server-side	--	our very own 'init.sqf' imitation			-- scheduled environment
//H ~~
//H
if (!isServer) exitWith {}; if (isNil("mgmTfA_Server_Init")) then {mgmTfA_Server_Init=0;}; waitUntil {mgmTfA_Server_Init==1}; private ["_thisFileVerbosityLevelNumber"]; _thisFileVerbosityLevelNumber = mgmTfA_configgv_serverVerbosityLevel;

////Register Server-side Event Handlers
[] execVM "\x\addons\custom\serverside\mgmTfA\mgmTfA_scr_server_initRegisterServerEventHandlers.sqf";

////HQ stuff
//Create Taxi Corp. HQ Building
[] execVM "\x\addons\custom\serverside\mgmTfA\mgmTfA_scr_server_initCreateObjectHQBuilding.sqf";
// Create Taxi Corp. HQ Map Marker
[] execVM "\x\addons\custom\serverside\mgmTfA\mgmTfA_scr_server_initCreateMapMarkerHQ.sqf";

////CATP Stuff
//Create CATP(Call-a-Taxi Point) Objects
[] execVM "\x\addons\custom\serverside\mgmTfA\mgmTfA_scr_server_initCreateObjectCatp01.sqf";
[] execVM "\x\addons\custom\serverside\mgmTfA\mgmTfA_scr_server_initCreateObjectCatp02.sqf";
[] execVM "\x\addons\custom\serverside\mgmTfA\mgmTfA_scr_server_initCreateObjectCatp03.sqf";
//Create CATP(Call-a-Taxi Point) Map Markers
[] execVM "\x\addons\custom\serverside\mgmTfA\mgmTfA_scr_server_initCreateMapMarkerCatp01.sqf";
[] execVM "\x\addons\custom\serverside\mgmTfA\mgmTfA_scr_server_initCreateMapMarkerCatp02.sqf";
[] execVM "\x\addons\custom\serverside\mgmTfA\mgmTfA_scr_server_initCreateMapMarkerCatp03.sqf";

////Taxi Fixed Destination Stuff - Create the Map Markers
//Create all FD Map Markers
[] execVM "\x\addons\custom\serverside\mgmTfA\mgmTfA_scr_server_initCreateMapMarkerTaxiFixedDestination01.sqf";
[] execVM "\x\addons\custom\serverside\mgmTfA\mgmTfA_scr_server_initCreateMapMarkerTaxiFixedDestination02.sqf";
[] execVM "\x\addons\custom\serverside\mgmTfA\mgmTfA_scr_server_initCreateMapMarkerTaxiFixedDestination03.sqf";

if (mgmTfA_configgv_serverVerbosityLevel>=2) then {diag_log format ["[mgmTfA][mgmTfA_scr_server_init.sqf] END reading file."];};//dbg
// EOF