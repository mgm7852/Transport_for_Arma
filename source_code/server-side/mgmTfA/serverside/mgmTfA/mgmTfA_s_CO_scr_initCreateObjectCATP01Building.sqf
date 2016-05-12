//H
//H ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_s_CO_scr_initCreateObjectCATP01Building.sqf
//H $PURPOSE$	:	This server-side script creates a particular Object on server start.
//H ~~
//H
if (!isServer) exitWith {}; if (isNil("mgmTfA_Server_Init")) then {mgmTfA_Server_Init=0;}; waitUntil {mgmTfA_Server_Init==1}; private ["_thisFileVerbosityLevelNumber"]; _thisFileVerbosityLevelNumber = mgmTfA_configgv_serverVerbosityLevel;
_vehicleX = objNull;
_this = createVehicle [mgmTfA_configgv_CATP01BuildingObjectClassIDTextString, mgmTfA_configgv_CATP01BuildingLocationPositionArray, [], 0, "CAN_COLLIDE"];
_vehicleX = _this;
_this setDir mgmTfA_configgv_CATP01BuildingDirectionDegreesNumber;
_this setPos mgmTfA_configgv_CATP01BuildingLocationPositionArray;
_this allowDamage false;
_this setVectorUp [0,0,1];
// EOF