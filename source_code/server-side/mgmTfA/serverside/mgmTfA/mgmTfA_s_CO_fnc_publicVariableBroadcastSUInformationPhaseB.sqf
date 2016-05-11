//H
//H ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_s_CO_fnc_publicVariableBroadcastSUInformationPhaseB.sqf
//H $PURPOSE$	:	This function process a Service Unit's information and then Broadcast it to all clients
//H ~~
//H
//HH
//HH ~~
//HH	Example usage	:	_null = [_myGUSUIDNumber, _SUTypeTextString, _SUActiveWaypointPositionPosition3DArray, _SUCurrentActionInProgressTextString, _SUCurrentTaskThresholdInSecondsNumber, _SUCurrentTaskBirthTimeInSecondsNumber, _SUDriversFirstnameTextString, _SUMarkerShouldBeDestroyedAfterExpiryBool, _SURequestorPlayerUIDTextString, _SURequestorProfileNameTextString, _SUAIVehicleObject, _SUAIVehicleObjectBirthTimeInSecondsNumber, _SUPickUpHasOccurredBool, _SUPickUpPositionPosition3DArray, _SUDropOffPositionHasBeenDeterminedBool, _SUDropOffHasOccurredBool, _SUDropOffPositionPosition3DArray, _SUDropOffPositionNameTextString, _SUTerminationPointPositionHasBeenDeterminedBool, _SUTerminationPointPosition3DArray, _SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray, _SUAIVehicleObjectCurrentPositionPosition3DArray, _SUAIVehicleVehicleDirectionInDegreesNumber, _SUAIVehicleObjectAgeInSecondsNumber, _SUCurrentTaskAgeInSecondsNumber, _SUAIVehicleSpeedOfVehicleInKMHNumber] call mgmTfA_s_CO_fnc_publicVariableBroadcastSUInformationPhaseB;
//HH	Parameters	:	see below, (_this select n) entries.
//HH	Return Value	:	none
//HH ~~
//HH	The server-side master configuration file read (and/or publicVariable publish) the following value(s) this function rely on:
//HH		mgmTfA_configgv_serverVerbosityLevel
//HH		
//HH	The client-side init file create the following value(s) this function rely on:
//HH		none documented yet
//HH

///
//// Step 1:	PARSE Function Arguments
///
// Basically we need to do the following every second or so:
//	1. "get, calculate, set values"
//	2. "publicVariable send values"
// This information will then be put together on the authorized client computers to create/update/delete localMarkers, tracking SU on their local map
private	[
		"_myGUSUIDNumber",
		"_SUTypeTextString",
		"_SUActiveWaypointPositionPosition3DArray",
		"_SUCurrentActionInProgressTextString",
		"_SUCurrentTaskThresholdInSecondsNumber",
		"_SUCurrentTaskBirthTimeInSecondsNumber",
		"_SUDriversFirstnameTextString",
		"_SUMarkerShouldBeDestroyedAfterExpiryBool",
		"_SURequestorPlayerUIDTextString",
		"_SURequestorProfileNameTextString",
		"_SUAIVehicleObject",
		"_SUAIVehicleObjectBirthTimeInSecondsNumber",
		"_SUPickUpHasOccurredBool",
		"_SUPickUpPositionPosition3DArray",
		"_SUDropOffPositionHasBeenDeterminedBool",
		"_SUDropOffHasOccurredBool",
		"_SUDropOffPositionPosition3DArray",
		"_SUDropOffPositionNameTextString",
		"_SUTerminationPointPositionHasBeenDeterminedBool",
		"_SUTerminationPointPosition3DArray",
		"_SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray",
		"_SUAIVehicleObjectCurrentPositionPosition3DArray",
		"_SUAIVehicleVehicleDirectionInDegreesNumber",
		"_SUAIVehicleObjectAgeInSecondsNumber",
		"_SUCurrentTaskAgeInSecondsNumber",
		"_SUAIVehicleSpeedOfVehicleInKMHNumber",
		"_SUDistanceToActiveWaypointInMetersNumber"
		];

//// Step 1:		PARSE Function Arguments
_thisFileVerbosityLevelNumber = mgmTfA_configgv_serverVerbosityLevel;

// WARNING! THIS LINE MUST* BE above the next one or _myGUSUIDNumber will throw error: "Error Undefined variable in expression: _mygusuidnumber"
_myGUSUIDNumber = (_this select 0);
if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_fnc_publicVariableBroadcastSUInformationPhaseB.sqf]  [TV3] 	<ThisIs:%1> 	I have been CALL'd.	This is what I have received:	(%2).		(str mgmTfA_gvdb_PV_GUSUIDNumber) is: (%3)", (str _myGUSUIDNumber), (str _this), (str mgmTfA_gvdb_PV_GUSUIDNumber)];};//dbg
_SUTypeTextString = (_this select 1);
_SUActiveWaypointPositionPosition3DArray = (_this select 2);
_SUCurrentActionInProgressTextString = (_this select 3);
_SUCurrentTaskThresholdInSecondsNumber = (_this select 4);
_SUCurrentTaskBirthTimeInSecondsNumber = (_this select 5);
_SUDriversFirstnameTextString = (_this select 6);
_SUMarkerShouldBeDestroyedAfterExpiryBool = (_this select 7);
_SURequestorPlayerUIDTextString = (_this select 8);
_SURequestorProfileNameTextString = (_this select 9);
_SUAIVehicleObject = (_this select 10);
_SUAIVehicleObjectBirthTimeInSecondsNumber = (_this select 11);
_SUPickUpHasOccurredBool = (_this select 12);
_SUPickUpPositionPosition3DArray = (_this select 13);
_SUDropOffPositionHasBeenDeterminedBool = (_this select 14);
_SUDropOffHasOccurredBool = (_this select 15);
_SUDropOffPositionPosition3DArray = (_this select 16);
_SUDropOffPositionNameTextString = (_this select 17);
_SUTerminationPointPositionHasBeenDeterminedBool = (_this select 18);
_SUTerminationPointPosition3DArray = (_this select 19);
_SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray = (_this select 20);
_SUAIVehicleObjectCurrentPositionPosition3DArray = (_this select 21);
_SUAIVehicleVehicleDirectionInDegreesNumber = (_this select 22);
_SUAIVehicleObjectAgeInSecondsNumber = (_this select 23);
_SUCurrentTaskAgeInSecondsNumber = (_this select 24);
_SUAIVehicleSpeedOfVehicleInKMHNumber = (_this select 25);
_SUDistanceToActiveWaypointInMetersNumber = (_this select 26);

//// Step 2:		SET values
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUActiveWaypointPositionPosition3DArray", _myGUSUIDNumber], _SUActiveWaypointPositionPosition3DArray];
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUCurrentActionInProgressTextString", _myGUSUIDNumber], _SUCurrentActionInProgressTextString];
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUCurrentTaskThresholdInSecondsNumber", _myGUSUIDNumber], _SUCurrentTaskThresholdInSecondsNumber];
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUCurrentTaskBirthTimeInSecondsNumber", _myGUSUIDNumber], _SUCurrentTaskBirthTimeInSecondsNumber];
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUMarkerShouldBeDestroyedAfterExpiryBool", _myGUSUIDNumber], _SUMarkerShouldBeDestroyedAfterExpiryBool];
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray"	, _myGUSUIDNumber], _SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray];
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUAIVehicleObjectCurrentPositionPosition3DArray", _myGUSUIDNumber], _SUAIVehicleObjectCurrentPositionPosition3DArray];
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUAIVehicleVehicleDirectionInDegreesNumber", _myGUSUIDNumber], _SUAIVehicleVehicleDirectionInDegreesNumber];
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUAIVehicleObjectAgeInSecondsNumber", _myGUSUIDNumber], _SUAIVehicleObjectAgeInSecondsNumber];
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUCurrentTaskAgeInSecondsNumber", _myGUSUIDNumber], _SUCurrentTaskAgeInSecondsNumber];
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUAIVehicleSpeedOfVehicleInKMHNumber", _myGUSUIDNumber], _SUAIVehicleSpeedOfVehicleInKMHNumber];
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUDistanceToActiveWaypointInMetersNumber", _myGUSUIDNumber], _SUDistanceToActiveWaypointInMetersNumber];
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUPositionPosition3DArray", _myGUSUIDNumber], _SUAIVehicleObjectCurrentPositionPosition3DArray];

//// Step 3:		SEND values via publicVariable
publicVariable format ["mgmTfA_gv_PV_SU%1SUActiveWaypointPositionPosition3DArray", _myGUSUIDNumber];
publicVariable format ["mgmTfA_gv_PV_SU%1SUCurrentActionInProgressTextString", _myGUSUIDNumber];
publicVariable format ["mgmTfA_gv_PV_SU%1SUCurrentTaskThresholdInSecondsNumber", _myGUSUIDNumber];
publicVariable format ["mgmTfA_gv_PV_SU%1SUCurrentTaskBirthTimeInSecondsNumber", _myGUSUIDNumber];
publicVariable format ["mgmTfA_gv_PV_SU%1SUMarkerShouldBeDestroyedAfterExpiryBool", _myGUSUIDNumber];
publicVariable format ["mgmTfA_gv_PV_SU%1SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray", _myGUSUIDNumber];
publicVariable format ["mgmTfA_gv_PV_SU%1SUAIVehicleObjectCurrentPositionPosition3DArray", _myGUSUIDNumber];
publicVariable format ["mgmTfA_gv_PV_SU%1SUAIVehicleVehicleDirectionInDegreesNumber", _myGUSUIDNumber];
publicVariable format ["mgmTfA_gv_PV_SU%1SUAIVehicleObjectAgeInSecondsNumber", _myGUSUIDNumber];
publicVariable format ["mgmTfA_gv_PV_SU%1SUCurrentTaskAgeInSecondsNumber", _myGUSUIDNumber];
publicVariable format ["mgmTfA_gv_PV_SU%1SUAIVehicleSpeedOfVehicleInKMHNumber", _myGUSUIDNumber];
publicVariable format ["mgmTfA_gv_PV_SU%1SUDistanceToActiveWaypointInMetersNumber", _myGUSUIDNumber];
publicVariable format ["mgmTfA_gv_PV_SU%1SUPositionPosition3DArray", _myGUSUIDNumber];

if (_SUPickUpHasOccurredBool) then {
	missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUPickUpHasOccurredBool", _myGUSUIDNumber], _SUPickUpHasOccurredBool];
	publicVariable format ["mgmTfA_gv_PV_SU%1SUPickUpHasOccurredBool", _myGUSUIDNumber];
};
// EOF