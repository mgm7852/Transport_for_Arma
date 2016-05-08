//H
//H ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_scr_server_initCreateObjectHQBuilding.sqf
//H $PURPOSE$	:	This server side script creates a particular Object on server start.
//H ~~
//H
if (!isServer) exitWith {}; if (isNil("mgmTfA_Server_Init")) then {mgmTfA_Server_Init=0;}; waitUntil {mgmTfA_Server_Init==1}; private ["_thisFileVerbosityLevelNumber"]; _thisFileVerbosityLevelNumber = mgmTfA_configgv_serverVerbosityLevel;

// Taxi Corp HQ Building
_vehicle_10501 = objNull;
if (mgmTfA_configgv_establishTaxiCorpHqBool) then
{
	_this = createVehicle [mgmTfA_configgv_taxiCorpHqBuildingObjectClassIDTextString, mgmTfA_configgv_taxiCorpHqLocationPositionArray, [], 0, "CAN_COLLIDE"];
	_vehicle_10501 = _this;
	_this setDir 150;
	_this setPos mgmTfA_configgv_taxiCorpHqLocationPositionArray;
	_this allowDamage false;
	_this setVectorUp [0,0,1];
	_this setVariable ["BIS_Disabled_Door_1", 1, true];
};
//EOF