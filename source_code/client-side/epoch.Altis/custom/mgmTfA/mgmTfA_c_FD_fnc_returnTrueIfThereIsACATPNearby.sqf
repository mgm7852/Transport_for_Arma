//H
//H ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_c_FD_fnc_returnTrueIfThereIsACATPNearby.sqf
//H $PURPOSE$	:	This function will return "true" if player is near a CATP object.
//H ~~
//H
//HH
//H ~~
//HH	Syntax		:	Bool = mgmTfA_c_FD_fnc_returnTrueIfThereIsACATPNearby
//HH	Parameters	:	none
//HH	Return Value	:	Bool
//HH	Example usage	:
//H ~~
//HH	The server-side master configuration file publicVariable publish the following values this function rely on:
//HH		mgmTfA_configgv_CATPObject
//HH		mgmTfA_configgv_CATPObjectDetectionRangeInMeters
//HH
if (isServer) exitWith {}; if (isNil("mgmTfA_Client_Init")) then {mgmTfA_Client_Init=0;}; waitUntil {mgmTfA_Client_Init==1}; private ["_thisFileVerbosityLevelNumber"]; _thisFileVerbosityLevelNumber = mgmTfA_configgv_clientVerbosityLevel;

private	[
		"_returnValue",
		"_CATPObjectsNearMeArray",
		"_numberOfCATPObjectsNearMe"
		];

scopeName "mgmTfA_c_FD_fnc_returnTrueIfThereIsACATPNearbyMainScope";

// No CATP nearby unless otherwise proven
_returnValue = false;

//Check if we have a CATP near
_CATPObjectsNearMeArray = position player nearObjects [mgmTfA_configgv_CATPObject, mgmTfA_configgv_CATPObjectDetectionRangeInMeters];
_numberOfCATPObjectsNearMe = count _CATPObjectsNearMeArray;

// if player has at least 1 CATP nearby, return TRUE, otherwise return FALSE
if (_numberOfCATPObjectsNearMe>0) then {
	// there are matching objects but is it just same class object or really a CATP?	check now
	{
		if (_x	getVariable ["mgmTfA_Dispatcher",false]) then {
			// we found a mgmTfA_Dispatcher here
			_returnValue=true;
			breakTo "mgmTfA_c_FD_fnc_returnTrueIfThereIsACATPNearbyMainScope";
		};
	} forEach _CATPObjectsNearMeArray;
} else {
	_returnValue=false;
};
if (_thisFileVerbosityLevelNumber>=10) then {diag_log format ["[mgmTfA] [mgmTfA_c_FD_fnc_returnTrueIfThereIsACATPNearby.sqf] [TV10] END reading file. The next line will return _returnValue and quit function. _returnValue is: (%1)", str _returnValue];};//dbg
_returnValue;
// EOF