//H
//H ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_s_CO_scr_initCreateObjectcatp03.sqf
//H $PURPOSE$	:	This server side script creates a particular Object on server start.
//H ~~
//H
if (!isServer) exitWith {}; if (isNil("mgmTfA_Server_Init")) then {mgmTfA_Server_Init=0;}; waitUntil {mgmTfA_Server_Init==1}; private ["_thisFileVerbosityLevelNumber"]; _thisFileVerbosityLevelNumber = mgmTfA_configgv_serverVerbosityLevel;

// Spawn an AI character to act as a TaxiCorp dispatcher at a Call-a-Taxi Point
if (mgmTfA_configgv_serverVerbosityLevel>=5) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initCreateObjectcatp03.sqf]  [V5]          Spawning an AI character as the TaxiCorp dispatcher at this Call-a-Taxi Point"];};

private ["_mgmTfA_CATPagentUnit3", "_mgmTfA_CATPagentUnit3sGroup"];

_mgmTfA_CATPagentUnit3 = objNull;
_mgmTfA_CATPagentUnit3sGroup = objNull;

if (true) then {
	_mgmTfA_CATPagentUnit3sGroup = createGroup RESISTANCE;
	uiSleep 0.05;
	mgmTfA_configgv_catpObject createUnit [mgmTfA_configgv_catp03LocationPositionArray, _mgmTfA_CATPagentUnit3sGroup, "_mgmTfA_CATPagentUnit3=this; this setDir 0; this allowDammage false; this enableSimulation true; this enableSimulationGlobal true; this disableAI 'FSM'; this disableAI 'MOVE'; this disableAI 'ANIM'; this disableAI 'AUTOTARGET'; this disableAI 'TARGET'; this forceSpeed 0; this setVariable [""mgmTfA_Dispatcher"",true,true];",0.6,"Private"];
	uiSleep 0.05;
	_mgmTfA_CATPagentUnit3 setVariable ["BIS_fnc_animalBehaviour_disable", true];
	uiSleep 0.05;
	_mgmTfA_CATPagentUnit3 setDir mgmTfA_configgv_catp03DirectionDegreesNumber;
	uiSleep 0.05;
	_mgmTfA_CATPagentUnit3 forceSpeed 0;
	uiSleep 0.05;
	// NOTE: setVehicleInit has been completely removed from Arma 3 and if this line is not commented out it will prevent the unit from spawning

	//TODO: add all the below to unit's setVehicleInit section
	//set AI unit's AI parameters
	_mgmTfA_CATPagentUnit3 disableAI "TARGET";
	uiSleep 0.05;
	_mgmTfA_CATPagentUnit3 disableAI "AUTOTARGET";
	uiSleep 0.05;
	_mgmTfA_CATPagentUnit3	allowDammage false;
	uiSleep 0.05;
	removeAllWeapons _mgmTfA_CATPagentUnit3;
	uiSleep 0.05;
	// any extras for this AI unit?
	_mgmTfA_CATPagentUnit3 setVariable ["mgmTfA_Dispatcher",true,true];
	// posture work
	if (mgmTfA_configgv_serverVerbosityLevel>=5) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initCreateObjectcatp03.sqf]  [V5]          uiSleep'ing 0.05 seconds before executing SetPosturePhase2"];};
	uiSleep 0.05;
	_mgmTfA_CATPagentUnit3 enableSimulationGlobal true;
	uiSleep 0.05;
	_mgmTfA_CATPagentUnit3 enableSimulation true;
	uiSleep 0.05;
	_mgmTfA_CATPagentUnit3 enableAI "ANIM";
	uiSleep 0.05;
	_mgmTfA_CATPagentUnit3 enableAI "FSM";
	uiSleep 0.05;
	_mgmTfA_CATPagentUnit3 disableAI "ANIM";
	uiSleep 0.05;
	_mgmTfA_CATPagentUnit3 setPosATL mgmTfA_configgv_catp03LocationPositionArray;
	uiSleep 0.05;
	_mgmTfA_CATPagentUnit3 switchMove "AidlPercSnonWnonDnon_talk1";
	uiSleep 0.05;
};
// EOF