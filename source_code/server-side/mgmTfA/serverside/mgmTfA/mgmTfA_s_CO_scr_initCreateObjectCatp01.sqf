//H
//H ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_s_CO_scr_initCreateObjectCATP01.sqf
//H $PURPOSE$	:	This server-side script creates a particular Object on server start.
//H ~~
//H
if (!isServer) exitWith {}; if (isNil("mgmTfA_Server_Init")) then {mgmTfA_Server_Init=0;}; waitUntil {mgmTfA_Server_Init==1}; private ["_thisFileVerbosityLevelNumber"]; _thisFileVerbosityLevelNumber = mgmTfA_configgv_serverVerbosityLevel;

// Spawn an AI character to act as a TaxiCorp dispatcher at a Call-a-Taxi Point
if (mgmTfA_configgv_serverVerbosityLevel>=5) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initCreateObjectCATP01.sqf]  [V5]          Spawning an AI character as the TaxiCorp dispatcher at this Call-a-Taxi Point"];};

private ["_mgmTfA_CATPagentUnit1", "_mgmTfA_CATPagentUnit1sGroup"];

_mgmTfA_CATPagentUnit1 = objNull;
_mgmTfA_CATPagentUnit1sGroup = objNull;

if (true) then {
	_mgmTfA_CATPagentUnit1sGroup = createGroup RESISTANCE;
	uiSleep 0.05;
	mgmTfA_configgv_CATPObject createUnit [mgmTfA_configgv_CATP01LocationPositionArray, _mgmTfA_CATPagentUnit1sGroup, "_mgmTfA_CATPagentUnit1=this; this setDir 0; this allowDammage false; this enableSimulation true; this enableSimulationGlobal true; this disableAI 'FSM'; this disableAI 'MOVE'; this disableAI 'ANIM'; this disableAI 'AUTOTARGET'; this disableAI 'TARGET'; this forceSpeed 0; this setVariable [""mgmTfA_Dispatcher"",true,true];",0.6,"Private"];
	uiSleep 0.05;
	_mgmTfA_CATPagentUnit1 setVariable ["BIS_fnc_animalBehaviour_disable", true];
	uiSleep 0.05;
	_mgmTfA_CATPagentUnit1 setDir mgmTfA_configgv_CATP01DirectionDegreesNumber;
	uiSleep 0.05;
	_mgmTfA_CATPagentUnit1 forceSpeed 0;
	uiSleep 0.05;
	// NOTE: setVehicleInit has been completely removed from Arma 3 and if this line is not commented out it will prevent the unit from spawning

	//TODO: add all the below to unit's setVehicleInit section
	//set AI unit's AI parameters
	_mgmTfA_CATPagentUnit1 disableAI "TARGET";
	uiSleep 0.05;
	_mgmTfA_CATPagentUnit1 disableAI "AUTOTARGET";
	uiSleep 0.05;
	_mgmTfA_CATPagentUnit1 allowDammage false;
	uiSleep 0.05;
	removeAllWeapons _mgmTfA_CATPagentUnit1;
	uiSleep 0.05;
	// any extras for this AI unit?
	_mgmTfA_CATPagentUnit1 setVariable ["mgmTfA_Dispatcher",true,true];
	// posture work
	if (mgmTfA_configgv_serverVerbosityLevel>=5) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initCreateObjectCATP01.sqf]  [V5]          uiSleep'ing 0.05 seconds before executing SetPosturePhase2"];};
	uiSleep 0.05;
	_mgmTfA_CATPagentUnit1 enableSimulationGlobal true;
	uiSleep 0.05;
	_mgmTfA_CATPagentUnit1 enableSimulation true;
	uiSleep 0.05;
	_mgmTfA_CATPagentUnit1 enableAI "ANIM";
	uiSleep 0.05;
	_mgmTfA_CATPagentUnit1 enableAI "FSM";
	uiSleep 0.05;
	_mgmTfA_CATPagentUnit1 disableAI "ANIM";
	uiSleep 0.05;
	_mgmTfA_CATPagentUnit1 setPosATL mgmTfA_configgv_CATP01LocationPositionArray;
	uiSleep 0.05;
	_mgmTfA_CATPagentUnit1 switchMove "AidlPercSnonWnonDnon_talk1";
	uiSleep 0.05;
};
// EOF