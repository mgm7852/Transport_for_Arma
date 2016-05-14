//H
//H ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_s_CO_fnc_publicVariableBroadcastSUInformationInitialBroadcast.sqf
//H $PURPOSE$	:	This function process a Service Unit's information and then Broadcast it to all clients
//H ~~
//H
//HH
//HH ~~
//HH	Example usage	:	_null = [_myGUSUIDNumber, _SUTypeTextString, _SUActiveWaypointPositionPosition3DArray, _SUCurrentActionInProgressTextString, _SUCurrentTaskThresholdInSecondsNumber, _SUCurrentTaskBirthTimeInSecondsNumber, _SUDriversFirstnameTextString, _SUMarkerShouldBeDestroyedAfterExpiryBool, _SURequestorPlayerUIDTextString, _SURequestorProfileNameTextString, _SUAIVehicleObject, _SUAIVehicleObjectBirthTimeInSecondsNumber, _SUPickUpHasOccurredBool, _SUPickUpPositionPosition3DArray, _SUDropOffPositionHasBeenDeterminedBool, _SUDropOffHasOccurredBool, _SUDropOffPositionPosition3DArray, _SUDropOffPositionNameTextString, _SUTerminationPointPositionHasBeenDeterminedBool, _SUTerminationPointPosition3DArray, _SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray, _SUAIVehicleObjectCurrentPositionPosition3DArray, _SUAIVehicleVehicleDirectionInDegreesNumber, _SUAIVehicleObjectAgeInSecondsNumber, _SUCurrentTaskAgeInSecondsNumber, _SUAIVehicleSpeedOfVehicleInKMHNumber, _SUDistanceToActiveWaypointInMetersNumber] call mgmTfA_s_CO_fnc_publicVariableBroadcastSUInformationInitialBroadcast;
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
//	1. "get & set values"
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
_myGUSUIDNumber = (_this select 0);
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
_SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray	= (_this select 20);
_SUAIVehicleObjectCurrentPositionPosition3DArray = (_this select 21);
_SUAIVehicleVehicleDirectionInDegreesNumber = (_this select 22);
_SUAIVehicleObjectAgeInSecondsNumber = (_this select 23);
_SUCurrentTaskAgeInSecondsNumber = (_this select 24);
_SUAIVehicleSpeedOfVehicleInKMHNumber = (_this select 25);
_SUDistanceToActiveWaypointInMetersNumber = (_this select 26);

_thisFileVerbosityLevelNumber = mgmTfA_configgv_serverVerbosityLevel;
if (_thisFileVerbosityLevelNumber>=10) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_fnc_publicVariableBroadcastSUInformationInitialBroadcast.sqf]  [TV10] <ThisIs:%1> I have been CALL'd.	This is what I have received:	(%2).		(str mgmTfA_gvdb_PV_GUSUIDNumber) is: (%3)", (str _myGUSUIDNumber), (str _this), (str mgmTfA_gvdb_PV_GUSUIDNumber)];};//dbg

//// Step 2:		SET values
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUActiveWaypointPositionPosition3DArray", _myGUSUIDNumber], _SUActiveWaypointPositionPosition3DArray];
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUCurrentActionInProgressTextString", _myGUSUIDNumber], _SUCurrentActionInProgressTextString];
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUCurrentTaskThresholdInSecondsNumber", _myGUSUIDNumber], _SUCurrentTaskThresholdInSecondsNumber];
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUCurrentTaskBirthTimeInSecondsNumber", _myGUSUIDNumber], _SUCurrentTaskBirthTimeInSecondsNumber];
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUMarkerShouldBeDestroyedAfterExpiryBool", _myGUSUIDNumber], _SUMarkerShouldBeDestroyedAfterExpiryBool];
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray", _myGUSUIDNumber], _SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray];
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUAIVehicleObjectCurrentPositionPosition3DArray", _myGUSUIDNumber], _SUAIVehicleObjectCurrentPositionPosition3DArray];
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUAIVehicleVehicleDirectionInDegreesNumber", _myGUSUIDNumber], _SUAIVehicleVehicleDirectionInDegreesNumber];
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUAIVehicleObjectAgeInSecondsNumber", _myGUSUIDNumber], _SUAIVehicleObjectAgeInSecondsNumber];
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUCurrentTaskAgeInSecondsNumber", _myGUSUIDNumber], _SUCurrentTaskAgeInSecondsNumber];
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUAIVehicleSpeedOfVehicleInKMHNumber", _myGUSUIDNumber], _SUAIVehicleSpeedOfVehicleInKMHNumber];
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUDistanceToActiveWaypointInMetersNumber", _myGUSUIDNumber], _SUDistanceToActiveWaypointInMetersNumber];
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUPositionPosition3DArray", _myGUSUIDNumber], _SUAIVehicleObjectCurrentPositionPosition3DArray];

///
//// Step 3:		SEND values via publicVariable
///
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

///
// Optional Step:	SET & SEND 	EXTRAS (for First Run-only)		For each SU, only during the first execution, we will do some extra work as follows
///
// THE VALUES BELOW do not change after FirstExecution of BroadcastSUInformation function therefore we need to set & broadcast them only once...

// TODO: code duplication here. 		better to:		call functions for each of these below (see the last example, termination, below)
// First Run means Pick Up has NOT occurred yet.		Note that the variable _pickUpHasOccurredNumber is set to zero in local variables initialization section.
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUPickUpHasOccurredBool", _myGUSUIDNumber], _SUPickUpHasOccurredBool];
publicVariable format ["mgmTfA_gv_PV_SU%1SUPickUpHasOccurredBool", _myGUSUIDNumber];
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUPickUpPositionPosition3DArray", _myGUSUIDNumber], _SUPickUpPositionPosition3DArray];
publicVariable format ["mgmTfA_gv_PV_SU%1SUPickUpPositionPosition3DArray", _myGUSUIDNumber];

// TODO: code duplication here. 		better to:		call functions for each of these below (see the last example, termination, below)
// First Run means Drop Off has NOT occurred yet.		Note that the variable _dropOffHasOccurredNumber is set to zero in local variables initialization section.
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUDropOffPositionHasBeenDeterminedBool", _myGUSUIDNumber], _SUDropOffPositionHasBeenDeterminedBool];
publicVariable format ["mgmTfA_gv_PV_SU%1SUDropOffPositionHasBeenDeterminedBool", _myGUSUIDNumber];
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUDropOffHasOccurredBool", _myGUSUIDNumber], _SUDropOffHasOccurredBool];
publicVariable format ["mgmTfA_gv_PV_SU%1SUDropOffHasOccurredBool", _myGUSUIDNumber];
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUDropOffPositionPosition3DArray", _myGUSUIDNumber], _SUDropOffPositionPosition3DArray];
publicVariable format ["mgmTfA_gv_PV_SU%1SUDropOffPositionPosition3DArray", _myGUSUIDNumber];
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUDropOffPositionNameTextString", _myGUSUIDNumber], _SUDropOffPositionNameTextString];
publicVariable format ["mgmTfA_gv_PV_SU%1SUDropOffPositionNameTextString", _myGUSUIDNumber];

// During First Run only, we should supply "RequestorPlayerUIDTextString" so that each client can compare this PUID to their own and shut down map-tracking right after Drop Off (if they are not a member of TO).
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SURequestorPlayerUIDTextString", _myGUSUIDNumber], _SURequestorPlayerUIDTextString];
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SURequestorProfileNameTextString", _myGUSUIDNumber], _SURequestorProfileNameTextString];
publicVariable format ["mgmTfA_gv_PV_SU%1SURequestorPlayerUIDTextString", _myGUSUIDNumber];
publicVariable format ["mgmTfA_gv_PV_SU%1SURequestorProfileNameTextString", _myGUSUIDNumber];

// During First Run only, we should supply "SU Type" information
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUTypeTextString", _myGUSUIDNumber], _SUTypeTextString];
publicVariable format ["mgmTfA_gv_PV_SU%1SUTypeTextString", _myGUSUIDNumber];

// During First Run only, we should supply "Driver's Firstname" information
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUDriversFirstnameTextString", _myGUSUIDNumber], _SUDriversFirstnameTextString];
publicVariable format ["mgmTfA_gv_PV_SU%1SUDriversFirstnameTextString", _myGUSUIDNumber];

// During First Run only, we should supply "AIVehicleObject" object information
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUAIVehicleObject", _myGUSUIDNumber], _SUAIVehicleObject];
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUAIVehicleObjectBirthTimeInSecondsNumber", _myGUSUIDNumber], _SUAIVehicleObjectBirthTimeInSecondsNumber];
publicVariable format ["mgmTfA_gv_PV_SU%1SUAIVehicleObject", _myGUSUIDNumber];
publicVariable format ["mgmTfA_gv_PV_SU%1SUAIVehicleObjectBirthTimeInSecondsNumber", _myGUSUIDNumber];

// During First Run only, we should supply information about TerminationMarkerStatus (that its position has not been determined yet)
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUTerminationPointPositionHasBeenDeterminedBool", _myGUSUIDNumber], _SUTerminationPointPositionHasBeenDeterminedBool];
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUTerminationPointPosition3DArray", _myGUSUIDNumber], _SUTerminationPointPosition3DArray];
publicVariable format ["mgmTfA_gv_PV_SU%1SUTerminationPointPositionHasBeenDeterminedBool", _myGUSUIDNumber];
publicVariable format ["mgmTfA_gv_PV_SU%1SUTerminationPointPosition3DArray", _myGUSUIDNumber];
//	TODO:	[] call PublicVariableBroadcastTerminationMarkerStatus;

// During First Run only, we should pV broadcast the ACL		Note:	This was 'set' previously, in file: "mgmTfA_s_FD_fnc_servicePhase02a_SendResponse_BookingRequestAccepted.sqf"
//														Here, we are only broadcasting the value.
publicVariable					format ["mgmTfA_gv_PV_SU%1SUACLTextStringArray", _myGUSUIDNumber];

// Let all clients know that there is a new SU in action so that they can start doing "mgmTfA_c_CO_fnc_doLocalMarkerWork"
publicVariable					"mgmTfA_gvdb_PV_GUSUIDNumber";
if (_thisFileVerbosityLevelNumber>=10) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_fnc_publicVariableBroadcastSUInformationInitialBroadcast.sqf]  [TV10] <ThisIs:%1> I have just publicVariable'd mgmTfA_gvdb_PV_GUSUIDNumber. It contains: (%2).", (str _myGUSUIDNumber), (str mgmTfA_gvdb_PV_GUSUIDNumber)];};//dbg
// EOF