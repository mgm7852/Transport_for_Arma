//H
//H ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_fnc_client_returnTrueIfThereIsACatpNearby.sqf
//H $PURPOSE$	:	This function will return "true" if player is near a Catp object.
//H ~~
//H
//HH
//H ~~
//HH	Syntax		:	Bool = mgmTfA_fnc_client_returnTrueIfThereIsACatpNearby
//HH	Parameters	:	none
//HH	Return Value	:	Bool
//HH	Example usage	:
//H ~~
//HH	The server-side master configuration file publicVariable publish the following values this function rely on:
//HH		mgmTfA_configgv_CatpObject
//HH		mgmTfA_configgv_CatpObjectDetectionRangeInMeters
//HH
if (isServer) exitWith {}; if (isNil("mgmTfA_Client_Init")) then {mgmTfA_Client_Init=0;}; waitUntil {mgmTfA_Client_Init==1}; private ["_thisFileVerbosityLevelNumber"]; _thisFileVerbosityLevelNumber = mgmTfA_configgv_clientVerbosityLevel;

private	[
		"_returnValue",
		"_CatpObjectsNearMeArray",
		"_numberOfCatpObjectsNearMe"
		];

scopeName "mgmTfA_fnc_client_returnTrueIfThereIsACatpNearbyMainScope";

// No Catp nearby unless otherwise proven
_returnValue = false;

//Check if we have a Catp near
_CatpObjectsNearMeArray = position player nearObjects [mgmTfA_configgv_CatpObject, mgmTfA_configgv_CatpObjectDetectionRangeInMeters];
_numberOfCatpObjectsNearMe = count _CatpObjectsNearMeArray;

// if player has at least 1 Catp nearby, return TRUE, otherwise return FALSE
if (_numberOfCatpObjectsNearMe>0) then {
	// there are matching objects but is it just same class object or really a Catp?	check now
	{
		if (_x	getVariable ["mgmTfA_Dispatcher",false]) then {
			// we found an mgmTfA_Dispatcher here
			_returnValue=true;
			breakTo "mgmTfA_fnc_client_returnTrueIfThereIsACatpNearbyMainScope";
		};
	} forEach _CatpObjectsNearMeArray;
} else {
	_returnValue=false;
};
if (_thisFileVerbosityLevelNumber>=10) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_client_returnTrueIfThereIsACatpNearby.sqf] [TV10] END reading file. The next line will return _returnValue and quit function. _returnValue is: (%1)", str _returnValue];};//dbg
_returnValue;
// EOF