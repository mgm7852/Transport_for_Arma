//H
//H
//H ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_c_CO_fnc_doLocalMarkerWork.sqf
//H $PURPOSE$	:	This function will be spawn'd with 2 arguments SU ID (GUSUIDNumber) and _trackerIsTotalOmniscienceGroupMember. It will track movements of a given SU until (a) SU is terminated OR (b) client is no longer authorized to map-track its movements
//H ~~
//H
//HH
//H ~~
//HH	Syntax		:	_null = [SU_ID] mgmTfA_c_CO_fnc_doLocalMarkerWork
//HH	Parameters	:	0:	GUSUIDNumber Globally Unique Service Unit ID number		Number		Examples: 1, 2, 5, 384, 384728473
//HH	Parameters	:	1:	trackerIsTotalOmniscienceGroupMember	Bool		Examples: true,false
//HH	Return Value	:	Nothing	[outputs to client's local map]
//H ~~
//HH	The shared configuration file has the following values this function rely on: none
//HH	This function does not create/update any global variables.
//HH	This function does rely on publicVariables containing the information about the Service Unit.
//HH		For example, for Service Unit 27, the publicVariables would be:
//HH		mgmTfA_gv_PV_SU27SUTypeTextString
//HH		mgmTfA_gv_PV_SU27SUDriversFirstnameTextString
//HH		mgmTfA_gv_PV_SU27SUCurrentActionInProgressTextString
//HH		mgmTfA_gv_PV_SU27SURequestorProfileNameTextString
//HH		mgmTfA_gv_PV_SU27SUVehicleDirectionOfVehicleInDegreesNumber
//HH		mgmTfA_gv_PV_SU27SUVehicleSpeedOfVehicleInKMHNumber
//HH		mgmTfA_gv_PV_SU27SUDistanceToActiveWaypointInMetersNumber
//HH		mgmTfA_gv_PV_SU27SUAgeInSecondsNumber
//HH		mgmTfA_gv_PV_SU27SUCurrentTaskAgeInSecondsNumber
//HH		mgmTfA_gv_PV_SU27SUCurrentTaskThresholdInSecondsNumber
//HH		mgmTfA_gv_PV_SU27SUPositionPosition3DArray
//HH		mgmTfA_gv_PV_SU27SUMarkerShouldBeDestroyedAfterExpiryBool
//HH			NOTE:  EXACT LIST MAY CHANGE, THE ABOVE IS JUST AN EXAMPLE. FOR DEFINITIVE UP-TO-DATE LIST, SEE mgmTfA_fnc_server_publicVariableBroadcastSUInformation.sqf
//HH
private ["_thisFileVerbosityLevelNumber"];
// DEV NOTE: _thisFileVerbosityLevelNumber set to zero
_thisFileVerbosityLevelNumber = 0;
scopeName "mgmTfA_c_CO_fnc_doLocalMarkerWorkMainScope";
if (isServer) exitWith {};
if (!isServer) then {
	waitUntil {!isnull (finddisplay 46)};
	if (isNil("mgmTfA_Client_Init")) then {
		mgmTfA_Client_Init=0;
	};
	waitUntil {mgmTfA_Client_Init==1};
};
// lame workaround to prevent the scenario where our SU's data has not been publicVariable broadcasted yet -- we will need a proper solution for this in a later version
uiSleep 5;

// FNC
//// Declare Local Variables
private	[
		"_trackerIsTotalOmniscienceGroupMember",
		"_continueMapTracking",
		"_myGUSUIDNumber",
		"_SURequestorPlayerUIDTextString",
		"_SURequestorProfileNameTextString",

		// SU & SUAIVehicle
		"_SUTypeTextString",
		"_SUMarker",
		"_SUMarkerPointer",
		"_SUMarkerTextLabelString",
		"_SUMarkerServingOrServedTextWordTextString",
		"_SUAIVehicleObjectCurrentPositionPosition3DArray",
		"_SUAIVehicleObject",
		"_SUAIVehicleObjectBirthTimeInSecondsNumber",
		"_SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray",
		"_SUACLTextStringArray",
		"_SUCurrentTaskAgeInSecondsNumber",
		"_SUDistanceToActiveWaypointInMetersNumber",
		"_SUAIVehicleSpeedOfVehicleInKMHNumber",
		"_SUAIVehicleVehicleDirectionInDegreesNumber",
		"_SUAIVehicleObjectAgeInSecondsNumber",
		"_SUActiveWaypointPositionPosition3DArray",
		"_SUCurrentActionInProgressTextString",
		"_SUDriversFirstnameTextString",
		"_SUCurrentTaskBirthTimeInSecondsNumber",
		"_SUCurrentTaskThresholdInSecondsNumber",

		// Pick Up
		"_SUPickUpHasOccurredBool",
		"_SUPickUpPositionPosition3DArray",
		"_SUPickUpPointMarker",
		"_SUPickUpPointMarkerPointer",
		"_SUPickUpPointMarkerTextLabelString",
		"_mapHasNotBeenUpdatedToReflectThatPickUpHasOccurredBool",

		// Drop Off
		"_SUDropOffPositionHasBeenDeterminedBool",
		"_SUDropOffHasOccurredBool",
		"_SUDropOffPositionPosition3DArray",
		// This one below is not in use but keep for now (so that we won't have to renumber all function arguments) // to be cleaned up one day...
		"_SUDropOffPositionNameTextString",
		"_SUDropOffPointMarker",
		"_SUDropOffPointMarkerPointer",
		"_SUDropOffPointMarkerTextLabelString",
		"_mapHasNotBeenUpdatedToReflectThatDropOffHasOccurredBool",

		// Termination Point
		"_SUTerminationPointMarker",
		"_SUTerminationPointMarkerPointer",
		"_SUTerminationPointMarkerTextLabelString",
		"_SUTerminationPointPositionHasBeenDeterminedBool",
		"_SUTerminationPointPosition3DArray",

		"_SUMarkerShouldBeDestroyedAfterExpiryBool",
		"_counter55"
		];

// STEP1:	Prepare information
_myGUSUIDNumber = _this select 0;
_trackerIsTotalOmniscienceGroupMember = _this select 1;
_continueMapTracking = true;
_SURequestorPlayerUIDTextString = call compile format ["mgmTfA_gv_PV_SU%1SURequestorPlayerUIDTextString", _myGUSUIDNumber];
_SURequestorProfileNameTextString = call compile format ["mgmTfA_gv_PV_SU%1SURequestorProfileNameTextString", _myGUSUIDNumber];
_SUTypeTextString = call compile format ["mgmTfA_gv_PV_SU%1SUTypeTextString", _myGUSUIDNumber];
_SUAIVehicleObject = call compile format ["mgmTfA_gv_PV_SU%1SUAIVehicleObject", _myGUSUIDNumber];
_SUAIVehicleObjectBirthTimeInSecondsNumber = call compile format ["mgmTfA_gv_PV_SU%1SUAIVehicleObjectBirthTimeInSecondsNumber", _myGUSUIDNumber];
_SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray = call compile format ["mgmTfA_gv_PV_SU%1SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray", _myGUSUIDNumber];
_SUACLTextStringArray = call compile format ["mgmTfA_gv_PV_SU%1SUACLTextStringArray", _myGUSUIDNumber];
_SUCurrentTaskAgeInSecondsNumber = call compile format ["mgmTfA_gv_PV_SU%1SUCurrentTaskAgeInSecondsNumber", _myGUSUIDNumber];
_SUDistanceToActiveWaypointInMetersNumber = call compile format ["mgmTfA_gv_PV_SU%1SUDistanceToActiveWaypointInMetersNumber", _myGUSUIDNumber];
_SUAIVehicleSpeedOfVehicleInKMHNumber = call compile format ["mgmTfA_gv_PV_SU%1SUAIVehicleSpeedOfVehicleInKMHNumber", _myGUSUIDNumber];
_SUAIVehicleVehicleDirectionInDegreesNumber = call compile format ["mgmTfA_gv_PV_SU%1SUAIVehicleVehicleDirectionInDegreesNumber", _myGUSUIDNumber];
// this below, another dirty hack - to be cleaned up one day: ensure server-client-sides both use same name
_SUAIVehicleObjectAgeInSecondsNumber = call compile format ["mgmTfA_gv_PV_SU%1SUAIVehicleObjectAgeInSecondsNumber", _myGUSUIDNumber];
_SUActiveWaypointPositionPosition3DArray = call compile format ["mgmTfA_gv_PV_SU%1SUActiveWaypointPositionPosition3DArray", _myGUSUIDNumber];
_SUCurrentActionInProgressTextString = call compile format ["mgmTfA_gv_PV_SU%1SUCurrentActionInProgressTextString", _myGUSUIDNumber];
_SUDriversFirstnameTextString = call compile format ["mgmTfA_gv_PV_SU%1SUDriversFirstnameTextString", _myGUSUIDNumber];
_SUCurrentTaskBirthTimeInSecondsNumber = call compile format ["mgmTfA_gv_PV_SU%1SUCurrentTaskBirthTimeInSecondsNumber", _myGUSUIDNumber];
_SUCurrentTaskThresholdInSecondsNumber = call compile format ["mgmTfA_gv_PV_SU%1SUCurrentTaskThresholdInSecondsNumber", _myGUSUIDNumber];
_SUPickUpHasOccurredBool = call compile format ["mgmTfA_gv_PV_SU%1SUPickUpHasOccurredBool", _myGUSUIDNumber];
_SUPickUpPositionPosition3DArray = call compile format ["mgmTfA_gv_PV_SU%1SUPickUpPositionPosition3DArray", _myGUSUIDNumber];
_SUDropOffPositionHasBeenDeterminedBool = call compile format ["mgmTfA_gv_PV_SU%1SUDropOffPositionHasBeenDeterminedBool", _myGUSUIDNumber];
_SUDropOffHasOccurredBool = call compile format ["mgmTfA_gv_PV_SU%1SUDropOffHasOccurredBool", _myGUSUIDNumber];
// only if this position has been determined, it will be handled below =>	_SUDropOffPositionPosition3DArray							= call compile format ["mgmTfA_gv_PV_SU%1SUDropOffPositionPosition3DArray"							, _myGUSUIDNumber];
		// This one below is not in use but keep for now (so that we won't have to renumber all function arguments) // to be cleaned up before version 1.0 release
_SUDropOffPositionNameTextString = call compile format ["mgmTfA_gv_PV_SU%1SUDropOffPositionNameTextString", _myGUSUIDNumber];
_SUTerminationPointPositionHasBeenDeterminedBool = call compile format ["mgmTfA_gv_PV_SU%1SUTerminationPointPositionHasBeenDeterminedBool", _myGUSUIDNumber];
_SUTerminationPointPosition3DArray = call compile format ["mgmTfA_gv_PV_SU%1SUTerminationPointPosition3DArray", _myGUSUIDNumber];
_SUMarkerShouldBeDestroyedAfterExpiryBool = call compile format ["mgmTfA_gv_PV_SU%1SUMarkerShouldBeDestroyedAfterExpiryBool", _myGUSUIDNumber];
_SUDriversFirstnameTextString = call compile format ["mgmTfA_gv_PV_SU%1SUDriversFirstnameTextString", _myGUSUIDNumber];
// This two should start with true. They will be switched when the map is updated
_mapHasNotBeenUpdatedToReflectThatPickUpHasOccurredBool = true;
_mapHasNotBeenUpdatedToReflectThatDropOffHasOccurredBool = true;
_SUMarkerServingOrServedTextWordTextString = " serving ";
//_SUPickUpPointMarker <= Will be declared later in this file.
//_SUPickUpPointMarkerPointer <= Will be declared later in this file.
//_SUPickUpPointMarkerTextLabelString <= Will be declared later in this file.
//_SUDropOffPointMarkerTextLabelString <= Will be declared later in this file.
//_SUDropOffPointMarker <= Will be declared later in this file.
//_SUDropOffPointMarkerPointer <= Will be declared later in this file.
//_SUMarker <= Will be declared later in this file.
//_SUMarkerPointer <= Will be declared later in this file.

//_SUMarkerTextLabelString <= Will be declared later in this file.
//_SUAIVehicleObjectCurrentPositionPosition3DArray <= Will be declared later in this file.
//_SUTerminationPointMarker <= Will be declared later in this file.
//_SUTerminationPointMarkerPointer <= Will be declared later in this file.
//_SUTerminationPointMarkerTextLabelString <= Will be declared later in this file.
// debug slow down counter
_counter55 = 0;

// Before we begin the loop, CREATE a PICK UP MARKER -- we will want to do this only once
_SUPickUpPointMarkerTextLabelString = " IN PROGRESS: " + _SUDriversFirstnameTextString + "@" + _SUTypeTextString + (str _myGUSUIDNumber) +  " pick up point for: " + _SURequestorProfileNameTextString;
if (_thisFileVerbosityLevelNumber>=6) then {diag_log format ["[mgmTfA] [mgmTfA_c_CO_fnc_doLocalMarkerWork.sqf]  [TV6] I have set _SUPickUpPointMarkerTextLabelString to: (%1).", _SUPickUpPointMarkerTextLabelString];};
_SUPickUpPointMarker = format["SU%1PickUpMarker", _myGUSUIDNumber];
_SUPickUpPointMarkerPointer = createMarkerLocal [_SUPickUpPointMarker,[0,0]];
_SUPickUpPointMarker setMarkerShapeLocal "ICON";
_SUPickUpPointMarker setMarkerTypeLocal "mil_pickup";
_SUPickUpPointMarker setMarkerColorLocal "ColorRed";
_SUPickUpPointMarker setMarkerDirLocal 0;
_SUPickUpPointMarker setMarkerPosLocal _SUPickUpPositionPosition3DArray;
_SUPickUpPointMarker setMarkerTextLocal _SUPickUpPointMarkerTextLabelString;
if (_thisFileVerbosityLevelNumber>=6) then {diag_log format ["[mgmTfA] [mgmTfA_c_CO_fnc_doLocalMarkerWork.sqf]  [TV6] Reached checkpoint: Pickup Marker code completed."];};

// Before we begin the loop, CREATE a DROP OFF MARKER -- we will want to do this only once
// ONLY IF it has been determined:	Work on the DropOff Position
if (_SUDropOffPositionHasBeenDeterminedBool) then {
	_SUDropOffPositionPosition3DArray = call compile format ["mgmTfA_gv_PV_SU%1SUDropOffPositionPosition3DArray", _myGUSUIDNumber];
	_SUDropOffPointMarkerTextLabelString = " IN PROGRESS: " + _SUDriversFirstnameTextString + "@" + _SUTypeTextString + (str _myGUSUIDNumber) +  " drop off point for: " + _SURequestorProfileNameTextString;
	if (_thisFileVerbosityLevelNumber>=6) then {diag_log format ["[mgmTfA] [mgmTfA_c_CO_fnc_doLocalMarkerWork.sqf]  [TV6] I have set _SUDropOffPointMarkerTextLabelString to: (%1).", _SUDropOffPointMarkerTextLabelString];};
	_SUDropOffPointMarker = format["SU%1DropOffMarker", _myGUSUIDNumber];
	_SUDropOffPointMarkerPointer = createMarkerLocal [_SUDropOffPointMarker,[0,0]];
	_SUDropOffPointMarker setMarkerShapeLocal "ICON";
	_SUDropOffPointMarker setMarkerTypeLocal "mil_end";
	_SUDropOffPointMarker setMarkerColorLocal "ColorRed";
	_SUDropOffPointMarker setMarkerPosLocal _SUDropOffPositionPosition3DArray;
	_SUDropOffPointMarker setMarkerTextLocal _SUDropOffPointMarkerTextLabelString;
	if (_thisFileVerbosityLevelNumber>=6) then {diag_log format ["[mgmTfA] [mgmTfA_c_CO_fnc_doLocalMarkerWork.sqf]  [TV6] Reached checkpoint: DropOff Marker code completed."];};
};

//// Begin looping the main loop -- we will keep looping until server-side signal shut down (it can do this by setting "mgmTfA_gv_PV_SU%1SUMarkerShouldBeDestroyedAfterExpiryBool = true").
while {_continueMapTracking} do
{
	// DEBUG SLOW DOWN
	_counter55 = _counter55 +1;
	if (_counter55 >= 10) then {
		if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_CO_fnc_doLocalMarkerWork.sqf]  [TV8] Reached checkpoint: Running main loop. Now executing the very top, just above sleep."];};
		_counter55 = 0;
	};
	
	// sleep a sec
	uiSleep 1;
	 
	// STEP1:	Obtain Latest Information and Update Local Variables Accordingly
	// SUTypeTextString & DriverFirstnameTextString	MOVED UP to be executed before pick up marker creation code
	_SUCurrentActionInProgressTextString = call compile format ["mgmTfA_gv_PV_SU%1SUCurrentActionInProgressTextString", _myGUSUIDNumber];
	_SUAIVehicleVehicleDirectionInDegreesNumber = call compile format ["mgmTfA_gv_PV_SU%1SUAIVehicleVehicleDirectionInDegreesNumber", _myGUSUIDNumber];
	_SUAIVehicleSpeedOfVehicleInKMHNumber = call compile format ["mgmTfA_gv_PV_SU%1SUAIVehicleSpeedOfVehicleInKMHNumber", _myGUSUIDNumber];
	_SUDistanceToActiveWaypointInMetersNumber = call compile format ["mgmTfA_gv_PV_SU%1SUDistanceToActiveWaypointInMetersNumber", _myGUSUIDNumber];
	_SUAIVehicleObjectAgeInSecondsNumber = call compile format ["mgmTfA_gv_PV_SU%1SUAIVehicleObjectAgeInSecondsNumber", _myGUSUIDNumber];
	_SUCurrentTaskAgeInSecondsNumber = call compile format ["mgmTfA_gv_PV_SU%1SUCurrentTaskAgeInSecondsNumber", _myGUSUIDNumber];
	_SUCurrentTaskThresholdInSecondsNumber = call compile format ["mgmTfA_gv_PV_SU%1SUCurrentTaskThresholdInSecondsNumber", _myGUSUIDNumber];
	// UGLY QUICK FIX -- standardize this => 1SUAIVehicleObjectCurrentPositionPosition3DArray
	_SUAIVehicleObjectCurrentPositionPosition3DArray = call compile format ["mgmTfA_gv_PV_SU%1SUAIVehicleObjectCurrentPositionPosition3DArray", _myGUSUIDNumber];
	// TODO THIS BELOW WAS NUMBER. NOW BOOL! => 
	_SUMarkerShouldBeDestroyedAfterExpiryBool = call compile format ["mgmTfA_gv_PV_SU%1SUMarkerShouldBeDestroyedAfterExpiryBool", _myGUSUIDNumber];
	_SUPickUpHasOccurredBool = call compile format ["mgmTfA_gv_PV_SU%1SUPickupHasOccurredBool", _myGUSUIDNumber];
	_SUDropOffHasOccurredBool = call compile format ["mgmTfA_gv_PV_SU%1SUDropOffHasOccurredBool", _myGUSUIDNumber];
	_SUDropOffPositionHasBeenDeterminedBool = call compile format ["mgmTfA_gv_PV_SU%1SUDropOffPositionHasBeenDeterminedBool", _myGUSUIDNumber];
	_SUTerminationPointPositionHasBeenDeterminedBool = call compile format ["mgmTfA_gv_PV_SU%1SUTerminationPointPositionHasBeenDeterminedBool", _myGUSUIDNumber];

	// Are we supposed to terminate now?
	// TODO: THIS BELOW WAS NUMBER. NOW BOOL! => 
	if(_SUMarkerShouldBeDestroyedAfterExpiryBool) then {
		//// YES, WE ARE TERMINATING!
		// Log this -- but attempt logging only if both variables are already set
		if ((!isNil "_SUMarkerPointer")	&&	(!isNil "_SUMarker")) then {
			if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_CO_fnc_doLocalMarkerWork.sqf]  [TV8] _SUMarkerShouldBeDestroyedAfterExpiryBool is true.     _SUMarkerPointer is: (%1).   _SUMarker is: (%2).", (str _SUMarkerPointer), (str _SUMarker)];};
		};
		
		// Termination Step 1: do the Expiry Timeout as defined in masterConfig and publicVariable broadcasted by the server:	mgmTfA_configgv_mapMarkerExpiryTimeForTerminatedServiceUnitsInSecondsNumber
		private	[
				"_counterForDelayedDeletionLoop",
				"_delayedDeletionStartTimeInSecondsNumber"
				];
			
		// We will wait for a few seconds (as defined in masterConfig) before deleting all markers
		// However we can start cleaning up most map markers immediately.			// Get rid of 3 and keep only 1 behind...
		if (!isNil "_SUMarker") then {
			deleteMarker _SUMarker;
			if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_CO_fnc_doLocalMarkerWork.sqf]  [TV8] Termination Task: I have just deleted (_SUMarker)."];};
		};
		
		if (!isNil "_SUPickUpPointMarker") then {
			deleteMarker _SUPickUpPointMarker;
			if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_CO_fnc_doLocalMarkerWork.sqf]  [TV8] Termination Task: I have just deleted (_SUPickUpPointMarker)."];};
		};

		// ONLY IF it has been determined:	Work on the DropOff Marker
		if (_SUDropOffPositionHasBeenDeterminedBool) then {
			deleteMarker _SUDropOffPointMarker;
			if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_CO_fnc_doLocalMarkerWork.sqf]  [TV8] Termination Task: I have just deleted (_SUDropOffPointMarker)."];};
		};

		_counterForDelayedDeletionLoop= 0;
		_delayedDeletionStartTimeInSecondsNumber = (time);
		if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_CO_fnc_doLocalMarkerWork.sqf]  [TV8] ENTERed TERMINATION SLEEP LOOP. I will sleep as much as requested in (mgmTfA_configgv_mapMarkerExpiryTimeForTerminatedServiceUnitsInSecondsNumber) which is (%1).", (str mgmTfA_configgv_mapMarkerExpiryTimeForTerminatedServiceUnitsInSecondsNumber)];};
		while {(((time) - _delayedDeletionStartTimeInSecondsNumber) <= mgmTfA_configgv_mapMarkerExpiryTimeForTerminatedServiceUnitsInSecondsNumber)} do {
			_SUTerminationPointMarker = format["SU%1TerminationMarker", _myGUSUIDNumber];
			 uiSleep 1;
			_SUTerminationPointMarkerTextLabelString = " completed: " + _SUDriversFirstnameTextString + "@" + _SUTypeTextString + (str _myGUSUIDNumber) +  " Terminated here  (served: "  + _SURequestorProfileNameTextString + ")  (Delayed Deletion in: " + (str (round (mgmTfA_configgv_mapMarkerExpiryTimeForTerminatedServiceUnitsInSecondsNumber - ((time) - _delayedDeletionStartTimeInSecondsNumber)))) + " s.)";
			if (_thisFileVerbosityLevelNumber>=5) then {diag_log format ["[mgmTfA] [mgmTfA_c_CO_fnc_doLocalMarkerWork.sqf] I have set _SUTerminationPointMarkerTextLabelString to: (%1).", _SUTerminationPointMarkerTextLabelString];};
			// Possibly we do not need to re-create it every time! just update text!
			_SUTerminationPointMarker setMarkerTextLocal _SUTerminationPointMarkerTextLabelString;
		};
		if (_thisFileVerbosityLevelNumber>=7) then {diag_log format ["[mgmTfA] [mgmTfA_c_CO_fnc_doLocalMarkerWork.sqf]  [TV7] EXITed TERMINATION SLEEP LOOP."];};

		// Now get rid of the last marker
		_SUTerminationPointMarker setMarkerPosLocal [0,0];
		_SUTerminationPointMarker setMarkerAlphaLocal 0;

		// Update the log
		diag_log format ["[mgmTfA] [mgmTfA_c_CO_fnc_doLocalMarkerWork.sqf] I have been instructed to shut down. I have deleted the marker I have been tracking (SUID==%1).  I will now exit. Goodbye!", _myGUSUIDNumber];
		_continueMapTracking = false;
		// Exit all loops, go back to main, from where we will terminate AFTER writing to log.
		breakTo "mgmTfA_c_CO_fnc_doLocalMarkerWorkMainScope";
	} else {
		//// NO WE ARE NOT SUPPOSED TO TERMINATE. Carry on with create/update the marker and keep happily looping!
		
		// if 		Pick Up has occurred 	       && (we have not updated map to show that Pick Up has occurred) 		  then let's do it now
		if ((_SUPickUpHasOccurredBool) && (_mapHasNotBeenUpdatedToReflectThatPickUpHasOccurredBool)) then {
			// Pick Up has occurred and not processed yet!
			// Update the map now
			_SUPickUpPointMarkerTextLabelString							= " completed: " + _SUDriversFirstnameTextString + "@" + _SUTypeTextString + (str _myGUSUIDNumber) +  " picked up " + _SURequestorProfileNameTextString + " here";
			if (_thisFileVerbosityLevelNumber>=5) then {diag_log format ["[mgmTfA] [mgmTfA_c_CO_fnc_doLocalMarkerWork.sqf] Map has been updated to reflect that pick up has occurred. _SUPickUpPointMarkerTextLabelString is: (%1).", _SUPickUpPointMarkerTextLabelString];};
			_SUPickUpPointMarker setMarkerTypeLocal "mil_dot";
			_SUPickUpPointMarker setMarkerColorLocal "ColorBrown";
			_SUPickUpPointMarker setMarkerTextLocal _SUPickUpPointMarkerTextLabelString;
			
			// It's done now. Mark it so we won't try it again & again in every iteration!
			_mapHasNotBeenUpdatedToReflectThatPickUpHasOccurredBool = false;

		};
		
		// Drop Off has occurred and not processed yet!
		// if 		Drop Off has occurred 						   && (we have not updated map to show that Drop Off has occurred) then let's do it now
		if ((_SUDropOffHasOccurredBool) && (_mapHasNotBeenUpdatedToReflectThatDropOffHasOccurredBool)) then {
			
			// It's done now. Mark it so we won't try it again & again in every iteration!
			_mapHasNotBeenUpdatedToReflectThatDropOffHasOccurredBool = false;

			// If tracker is NOT a Total Omniscience Group Member, he will cease map-tracking this SU immediately
			if (!(_trackerIsTotalOmniscienceGroupMember)) then {
				// If tracker is NOT a member of TO, he is no longer authorized to map-track this SU.
				// Yes, we are terminating!
				_continueMapTracking = false;
				//// clean up
				if (!isNil "_SUMarker") then {
					deleteMarker _SUMarker;
					if (_thisFileVerbosityLevelNumber>=5) then {diag_log format ["[mgmTfA] [mgmTfA_c_CO_fnc_doLocalMarkerWork.sqf] Termination Task [terminating because not a member of _trackerIsTotalOmniscienceGroupMember and DropOff has occurred]: I have just deleted (_SUMarker)."];};
				};
				if (!isNil "_SUPickUpPointMarker") then {
					deleteMarker _SUPickUpPointMarker;
					if (_thisFileVerbosityLevelNumber>=5) then {diag_log format ["[mgmTfA] [mgmTfA_c_CO_fnc_doLocalMarkerWork.sqf] Termination Task [terminating because not a member of _trackerIsTotalOmniscienceGroupMember and DropOff has occurred]: I have just deleted (_SUPickUpPointMarker)."];};
				};
				if (!isNil "_SUDropOffPointMarker") then {
					deleteMarker _SUDropOffPointMarker;
					if (_thisFileVerbosityLevelNumber>=5) then {diag_log format ["[mgmTfA] [mgmTfA_c_CO_fnc_doLocalMarkerWork.sqf] Termination Task [terminating because not a member of _trackerIsTotalOmniscienceGroupMember and DropOff has occurred]: I have just deleted (_SUDropOffPointMarker)."];};
				};
				if (_thisFileVerbosityLevelNumber>=5) then {diag_log format ["[mgmTfA] [mgmTfA_c_CO_fnc_doLocalMarkerWork.sqf] Termination Task [terminating because not a member of _trackerIsTotalOmniscienceGroupMember and DropOff has occurred]: Next line will breakTo mgmTfA_c_CO_fnc_doLocalMarkerWorkMainScope"];};
				breakTo "mgmTfA_c_CO_fnc_doLocalMarkerWorkMainScope";
			};
			
			// If tracker is Total Omniscience Group Member, he will keep map-tracking but (set the color to Brown) && (change icon to smaller 'dot') && (change dropoff text wording).
			if (_trackerIsTotalOmniscienceGroupMember) then {
				// Update the map now
				_SUDropOffPointMarkerTextLabelString = " completed: " + _SUDriversFirstnameTextString + "@" + _SUTypeTextString + str _myGUSUIDNumber +  " was asked to drop off " + _SURequestorProfileNameTextString + " here";
				if (_thisFileVerbosityLevelNumber>=5) then {diag_log format ["[mgmTfA] [mgmTfA_c_CO_fnc_doLocalMarkerWork.sqf] Map has been updated to reflect that Drop Off has occurred. _SUDropOffPointMarkerTextLabelString is: (%1).", _SUDropOffPointMarkerTextLabelString];};
				_SUDropOffPointMarker setMarkerTypeLocal "mil_dot";
				_SUDropOffPointMarker setMarkerColorLocal "ColorBrown";
				_SUDropOffPointMarker setMarkerTextLocal _SUDropOffPointMarkerTextLabelString;
			};

		};
		
		// Now that "Pick Up and/or Drop Off first time processing" is out of the way, let's carry on with the rest of the loop
		
		//GOAL create/update a SUMarkerLocal that looks like this one below
		// First a quick question - what is the word: 'serving' or 'served'?		drofOff occurred or (drivingTo term) or (atTerm) or (Terminated) status means we will use the word 'served'
		if	(
				(_SUDropOffHasOccurredBool)																		|| 
				(_SUCurrentActionInProgressTextString == mgmTfA_configgv_currentFixedDestinationTaxiActionInProgressIs06TextString)	||
				(_SUCurrentActionInProgressTextString == mgmTfA_configgv_currentFixedDestinationTaxiActionInProgressIs07TextString)	||
				(_SUCurrentActionInProgressTextString == mgmTfA_configgv_currentFixedDestinationTaxiActionInProgressIs08TextString)
			) then {
			_SUMarkerServingOrServedTextWordTextString = " served ";
		};
		_SUMarkerTextLabelString									= _SUDriversFirstnameTextString + "@" + _SUTypeTextString + (str _myGUSUIDNumber) +  _SUMarkerServingOrServedTextWordTextString + _SURequestorProfileNameTextString + "   Speed: " + (str _SUAIVehicleSpeedOfVehicleInKMHNumber) + " kmh   " + _SUCurrentActionInProgressTextString + "   WP: " + (str _SUDistanceToActiveWaypointInMetersNumber) + " m.   SUage: " + (str _SUAIVehicleObjectAgeInSecondsNumber) + " s.   Task Age/Max: " + (str _SUCurrentTaskAgeInSecondsNumber) + "/" + (str _SUCurrentTaskThresholdInSecondsNumber);
		if (_thisFileVerbosityLevelNumber>=5) then {diag_log format ["[mgmTfA] [mgmTfA_c_CO_fnc_doLocalMarkerWork.sqf] I have set _SUMarkerTextLabelString to: (%1).", _SUMarkerTextLabelString];};

		// STEP2:	Create (or overwrite) map MarkerLocal for this Service Unit
		// ~~~~~~~~~~~~~~~~~~~~ Create the map marker to show Requested Pick up Point ~~~~~~~~~~~~~~~~~~~~
		_SUMarker = format["SU%1", _myGUSUIDNumber];
		_SUMarkerPointer = createMarkerLocal [_SUMarker,[0,0]];
		_SUMarker setMarkerShapeLocal "ICON";
		// if we are doing any kind of waiting, set marker to question mark (CfgMarker type name is: "mil_unknown") otherwise set it to mil_start which has a nice arrow to indicate  movement direction
		if 	(
				(_SUCurrentActionInProgressTextString == mgmTfA_configgv_currentFixedDestinationTaxiActionInProgressIs00TextString) || 
				(_SUCurrentActionInProgressTextString == mgmTfA_configgv_currentFixedDestinationTaxiActionInProgressIs02TextString) || 
				(_SUCurrentActionInProgressTextString == mgmTfA_configgv_currentFixedDestinationTaxiActionInProgressIs03TextString) || 
				(_SUCurrentActionInProgressTextString == mgmTfA_configgv_currentFixedDestinationTaxiActionInProgressIs05TextString)
			) then {
			_SUMarker setMarkerTypeLocal "mil_unknown";
			// When we draw a question mark, we draw it with no direction rotation
			_SUMarker setMarkerColorLocal "ColorBrown";
			_SUMarker setMarkerDirLocal 0;
		} else {
			// SU in movement. Use distinctive Blue color and mil_start marker Type which has a distinctive arrow, with nice direction indicator arrowhead.
			_SUMarker setMarkerTypeLocal "mil_arrow";
			_SUMarker setMarkerColorLocal "ColorBlue";
			_SUMarker setMarkerDirLocal (_SUAIVehicleVehicleDirectionInDegreesNumber - 45);
		};
		// if driving to Termination, (_SUMarker should not be blue) && (_SUDropOffPointMarker should no longer be red)
		if (_SUCurrentActionInProgressTextString == mgmTfA_configgv_currentFixedDestinationTaxiActionInProgressIs06TextString) then {
			_SUMarker setMarkerColorLocal "ColorBrown";
			_SUDropOffPointMarker setMarkerColorLocal "ColorBrown";
		};
		// if at TerminationPoint, marker should not be blue
		if (_SUCurrentActionInProgressTextString == mgmTfA_configgv_currentFixedDestinationTaxiActionInProgressIs07TextString) then {
			// We are driving to Termination -- paint it BROWN
			_SUMarker setMarkerColorLocal "ColorBrown";
		};
		_SUMarker setMarkerPosLocal _SUAIVehicleObjectCurrentPositionPosition3DArray;
		_SUMarker setMarkerTextLocal _SUMarkerTextLabelString;
		// ~~~~~~~~~~~~~~~~~~~~ Create the map marker to show Requested Pick up Point ~~~~~~~~~~~~~~~~~~~~

		if (_SUCurrentActionInProgressTextString == mgmTfA_configgv_currentFixedDestinationTaxiActionInProgressIs08TextString) then {
			_SUMarker setMarkerColorLocal "ColorBrown";
		};

		// Let's Update the Termination Marker ONLY IF its position has been determined and publicVariable broadcasted
		if (_SUTerminationPointPositionHasBeenDeterminedBool) then {
		
			// Prepare the Termination MarkerLocal Text String -- obtain the information from publicVariables
			_SUTerminationPointPosition3DArray = call compile format ["mgmTfA_gv_PV_SU%1SUTerminationPointPosition3DArray", _myGUSUIDNumber];

			//GOAL creating a MarkerLocal that looks like this one below
			//								<<example not up to date>>
			_SUTerminationPointMarkerTextLabelString = " IN PROGRESS: " + _SUDriversFirstnameTextString + "@" + _SUTypeTextString + (str _myGUSUIDNumber) +  " will Terminate here";
			if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_CO_fnc_doLocalMarkerWork.sqf]  [TV8]  I have set _SUTerminationPointMarkerTextLabelString to: (%1).", _SUTerminationPointMarkerTextLabelString];};
			_SUTerminationPointMarker = format["SU%1TerminationMarker", _myGUSUIDNumber];
			_SUTerminationPointMarkerPointer = createMarkerLocal [_SUTerminationPointMarker,[0,0]];
			_SUTerminationPointMarker setMarkerShapeLocal "ICON";
			_SUTerminationPointMarker setMarkerTypeLocal "mil_warning";
			_SUTerminationPointMarker setMarkerColorLocal "ColorCivilian";
			_SUTerminationPointMarker setMarkerPosLocal _SUTerminationPointPosition3DArray;
			_SUTerminationPointMarker setMarkerTextLocal _SUTerminationPointMarkerTextLabelString;
			if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_CO_fnc_doLocalMarkerWork.sqf]  [TV8]  Reached checkpoint: Termination Marker code completed."];};
		};
	};
};
// EOF