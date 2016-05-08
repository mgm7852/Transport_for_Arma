//H
//H ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase06_ToTerminationAndTheEnd.sqf
//H $PURPOSE$	:	This function manages the SU on the way to TerminationPoint and once it reaches the TP - script will end with the termination of SU.
//H ~~
//H
//HH
//HH ~~
//HH	Example usage	:	
//_null = [_fixedDestinationRequestorProfileNameTextString, _fixedDestinationRequestorClientIDNumber, _iWantToTravelThisManyMetresNumber, _requestorPlayerObject, _myGUSUIDNumber, _SUAICharacterDriverObject, _SUTaxiAIVehicleObject, _SUTaxiAIVehicleObjectBirthTimeInSecondsNumber, _SUDriversFirstnameTextString, _doorsLockedBool, _SUTaxiAIVehicleWaypointMainArray, _SUTaxiAIVehicleWaypointMainArrayIndexNumber, _SUTaxiWaypointRadiusInMetersNumber, _SUAIGroup, _SUAIVehicleObjectAgeInSecondsNumber, _SUAIVehicleObjectCurrentPositionPosition3DArray, _SUTaxiAIVehicleVehicleDirectionInDegreesNumber, _SUAIVehicleVehicleDirectionInDegreesNumber, _SUAIVehicleSpeedOfVehicleInKMHNumber, _SUPickUpPositionPosition3DArray, _SUAIVehicleObject, _SUAIVehicleObjectBirthTimeInSecondsNumber, _SUDistanceToActiveWaypointInMetersNumber, _SUActiveWaypointPositionPosition3DArray, _SUTypeTextString, _SUMarkerShouldBeDestroyedAfterExpiryBool, _SURequestorPlayerUIDTextString, _SURequestorProfileNameTextString, _SUPickUpHasOccurredBool, _SUDropOffPositionHasBeenDeterminedBool, _SUDropOffHasOccurredBool, _SUDropOffPositionPosition3DArray, _SUDropOffPositionNameTextString, _SUTerminationPointPositionHasBeenDeterminedBool, _SUTerminationPointPosition3DArray, _SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray] spawn mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase06_ToTerminationAndTheEnd;
//HH	Parameters	:	
//HH			_fixedDestinationRequestorProfileNameTextString
//HH			_fixedDestinationRequestorClientIDNumber
//HH			_iWantToTravelThisManyMetresNumber
//HH			_requestorPlayerObject
//HH			_myGUSUIDNumber
//HH			_SUAICharacterDriverObject
//HH			_SUTaxiAIVehicleObject
//HH			_SUTaxiAIVehicleObjectBirthTimeInSecondsNumber
//HH			_SUDriversFirstnameTextString
//HH			_SUTaxiAIVehicleWaypointMainArray
//HH			_SUTaxiAIVehicleWaypointMainArrayIndexNumber
//HH			_SUTaxiWaypointRadiusInMetersNumber
//HH			_SUAIGroup
//HH
//HH	Return Value	:	none
//HH ~~
//HH	The server-side master configuration file read (and/or publicVariable publish) the following value(s) this function rely on:
//HH		mgmTfA_configgv_serverVerbosityLevel
//HH
if (!isServer) exitWith {}; if (isNil("mgmTfA_Server_Init")) then {mgmTfA_Server_Init=0;}; waitUntil {mgmTfA_Server_Init==1}; private ["_thisFileVerbosityLevelNumber"]; _thisFileVerbosityLevelNumber = mgmTfA_configgv_serverVerbosityLevel;
scopeName "mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase06_ToTerminationAndTheEndMainScope";

private	[
		"_SUTaxiAIVehicleDistanceToWayPointMetersNumber",
		"_SUCurrentTaskAgeInSecondsNumber",
		"_SUCurrentTaskBirthTimeInSecondsNumber",
		"_SUCurrentTaskThresholdInSecondsNumber",
		"_counterForLogOnlyEveryNthPINGNumber",
		"_iWantToTravelThisManyMetresNumber",
		"_SUMarkerShouldBeDestroyedAfterExpiryBool",
		"_SUCurrentActionInProgressTextString",
		"_SUTaxiAIVehicleObjectCurrentPositionPosition3DArray",
		"_SUTerminationPointPosition3DArray",
		"_SUTerminationPointPositionHasBeenDeterminedBool",
		"_SUTaxiAIVehicleWaypointMainArray",
		"_SUTaxiAIVehicleWaypointMainArrayIndexNumber",
		"_SUTaxiAIVehicleObjectAgeInSecondsNumber",
		"_SUTaxiAIVehicleObjectBirthTimeInSecondsNumber",
		"_SUTaxiWaypointRadiusInMetersNumber",
		"_SUAIGroup",
		"_SUAICharacterDriverObject",
		"_SUTaxiAIVehicleObject",
		"_myGUSUIDNumber",
		"_emergencyEscapeNeeded",
		"_SUDriversFirstnameTextString",
		// DO NOT REMOVE these two below -- they will be used when terminating with no players around...
		"_playersAroundMeList",
		"_playersAroundMeListCount",
		"_fixedDestinationRequestorProfileNameTextString",
		"_fixedDestinationRequestorClientIDNumber",
		"_requestorPlayerObject",
		"_thisFileVerbosityLevelNumber",
		"_SUAIVehicleObjectAgeInSecondsNumber",
		"_SUAIVehicleObjectCurrentPositionPosition3DArray",
		"_SUTaxiAIVehicleVehicleDirectionInDegreesNumber",
		"_SUAIVehicleVehicleDirectionInDegreesNumber",
		"_SUAIVehicleSpeedOfVehicleInKMHNumber",
		"_SUPickUpPositionPosition3DArray",
		"_SUAIVehicleObject",
		"_SUAIVehicleObjectBirthTimeInSecondsNumber",
		"_SUDistanceToActiveWaypointInMetersNumber",
		"_SUActiveWaypointPositionPosition3DArray",
		"_broadcastSUInformationCounter",
		"_doorsLockedBool",
		"_SUTypeTextString",
		"_SUMarkerShouldBeDestroyedAfterExpiryBool",
		"_SURequestorPlayerUIDTextString",
		"_SURequestorProfileNameTextString",
		"_SUPickUpHasOccurredBool",
		"_SUDropOffPositionHasBeenDeterminedBool",
		"_SUDropOffHasOccurredBool",
		"_SUDropOffPositionPosition3DArray",
		"_SUDropOffPositionNameTextString",
		"_SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray"
		];

//// Prep Function Arguments	&	Assign Initial Values for Local Variables
_thisFileVerbosityLevelNumber = mgmTfA_configgv_serverVerbosityLevel;
_fixedDestinationRequestorProfileNameTextString = (_this select 0);
_fixedDestinationRequestorClientIDNumber  = (_this select 1);
_iWantToTravelThisManyMetresNumber = (_this select 2);
_requestorPlayerObject = (_this select 3);
_myGUSUIDNumber = (_this select 4);
_SUAICharacterDriverObject = (_this select 5);
_SUTaxiAIVehicleObject = (_this select 6);
_SUTaxiAIVehicleObjectBirthTimeInSecondsNumber = (_this select 7);
_SUDriversFirstnameTextString = (_this select 8);
_doorsLockedBool = (_this select 9);
///
// We do not need some of the following variables in this function however we will need to pass them to the next Phase (Termination) thus we need to parse them
_SUTaxiAIVehicleWaypointMainArray = (_this select 10);
_SUTaxiAIVehicleWaypointMainArrayIndexNumber = (_this select 11);
_SUTaxiWaypointRadiusInMetersNumber = (_this select 12);
_SUAIGroup	 = (_this select 13);
_SUAIVehicleObjectAgeInSecondsNumber = (_this select 14);
_SUAIVehicleObjectCurrentPositionPosition3DArray = (_this select 15);
_SUTaxiAIVehicleVehicleDirectionInDegreesNumber = (_this select 16);
_SUAIVehicleVehicleDirectionInDegreesNumber = (_this select 17);
_SUAIVehicleSpeedOfVehicleInKMHNumber = (_this select 18);
_SUPickUpPositionPosition3DArray = (_this select 19);
_SUAIVehicleObject = (_this select 20);
_SUAIVehicleObjectBirthTimeInSecondsNumber = (_this select 21);
_SUDistanceToActiveWaypointInMetersNumber = (_this select 22);
_SUActiveWaypointPositionPosition3DArray = (_this select 23);
_SUTypeTextString = (_this select 24);
_SUMarkerShouldBeDestroyedAfterExpiryBool = (_this select 25);
_SURequestorPlayerUIDTextString = (_this select 26);
_SURequestorProfileNameTextString = (_this select 27);
_SUPickUpHasOccurredBool = (_this select 28);
_SUDropOffPositionHasBeenDeterminedBool = (_this select 29);
_SUDropOffHasOccurredBool = (_this select 30);
_SUDropOffPositionPosition3DArray = (_this select 31);
_SUDropOffPositionNameTextString = (_this select 32);
_SUTerminationPointPositionHasBeenDeterminedBool = (_this select 33);
_SUTerminationPointPosition3DArray = (_this select 34);
_SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray = (_this select 35);
// _counterForLogOnlyEveryNthPINGNumber											<=	do not set this variable yet (it will be done later in this file)
// _SUCurrentTaskAgeInSecondsNumber										<=	do not set this variable yet (it will be done later in this file)
// _SUCurrentTaskBirthTimeInSecondsNumber									<=	do not set this variable yet (it will be done later in this file)
// _SUCurrentTaskThresholdInSecondsNumber									<=	do not set this variable yet (it will be done later in this file)
// _SUTaxiAIVehicleDistanceToWayPointMetersNumber								<=	do not set this variable yet (it will be done later in this file)
_emergencyEscapeNeeded = false;
_playersAroundMeList = objNull;
_playersAroundMeListCount = 0;
//_broadcastSUInformationCounter											<=	do not set this variable yet (it will be done later in this file)
//_SUTaxiAIVehicleObjectAgeInSecondsNumber									<=	do not set this variable yet (it will be done later in this file)

if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase06_ToTerminationAndTheEnd.sqf]  [TV3] I have been SPAWN'd.	This is what I have received:	(%1).", (str _this)];};//dbg

//// BEGIN
//On arrival to waypoint (pick up point) add the travelled distance to the global counter and then reset our local counter
mgmTfA_dynamicgv_fixedDestinationTaxisTotalDistanceTravelledByTaxisNumber = mgmTfA_dynamicgv_fixedDestinationTaxisTotalDistanceTravelledByTaxisNumber + _iWantToTravelThisManyMetresNumber;
	if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase06_ToTerminationAndTheEnd.sqf]  [TV4] mgmTfA_dynamicgv_fixedDestinationTaxisTotalDistanceTravelledByTaxisNumber is now (%1). It now reflects the distance I just travelled (%2).]", mgmTfA_dynamicgv_fixedDestinationTaxisTotalDistanceTravelledByTaxisNumber, _iWantToTravelThisManyMetresNumber];};//dbg
// We can now reset this SU's distance_travelled counter -- because we already added it to mgmTfA_dynamicgv_clickNGoTaxisTotalDistanceTravelledByTaxisNumber
_iWantToTravelThisManyMetresNumber = 0;

// NEW DESTINATION
//Change our status to:		6 DRIVING-TO-TERMINATION		driving requestor to requested location
_SUCurrentActionInProgressTextString  = mgmTfA_configgv_currentFixedDestinationTaxiActionInProgressIs06TextString;
//First, we need to know WHERE to self-terminate. Run the random spot chooser and get us a cosy AI suicide point
//Parameters should be minimum 700 metres away, maximum 1500 metres away, from our current position
//Run gen here
//Kill immediately if there are no available drivers.
_SUTerminationPointPosition3DArray = objNull;
//DEVDEBUG 	// RELEASE TODO -- INCREASE THIS 		SAY  1200, 800 GOOD?
//Redefine it now with output from random position generator function	[parameters: radius, min distance, origin]
_SUTaxiAIVehicleObjectCurrentPositionPosition3DArray = (getPosATL _SUTaxiAIVehicleObject);
_SUTerminationPointPosition3DArray = [mgmTfA_configgv_fixedDestinationTaxisTerminationDistanceRadiusInMetresNumber,mgmTfA_configgv_fixedDestinationTaxisTerminationDistanceRadiusMinDistanceInMetresNumber, _SUTaxiAIVehicleObjectCurrentPositionPosition3DArray] call mgmTfA_fnc_server_returnNearbyRandomOnRoadPosition3DArray;
// We have a new Termination Point.  
// Inform the authorized Clients so that they can create a local marker for Termination Point
_SUTerminationPointPositionHasBeenDeterminedBool = true;
missionNamespace setVariable 		[format ["mgmTfA_gv_PV_SU%1SUTerminationPointPositionHasBeenDeterminedBool", _myGUSUIDNumber], _SUTerminationPointPositionHasBeenDeterminedBool							];
publicVariable 					 format ["mgmTfA_gv_PV_SU%1SUTerminationPointPositionHasBeenDeterminedBool", _myGUSUIDNumber																	];
missionNamespace setVariable 		[format ["mgmTfA_gv_PV_SU%1SUTerminationPointPosition3DArray", _myGUSUIDNumber], _SUTerminationPointPosition3DArray										];
publicVariable 					 format ["mgmTfA_gv_PV_SU%1SUTerminationPointPosition3DArray", _myGUSUIDNumber																	];
_SUTaxiAIVehicleWaypointMainArrayIndexNumber = _SUTaxiAIVehicleWaypointMainArrayIndexNumber + 1;
_SUTaxiAIVehicleTerminationWaypointPosition3DArray  = _SUTerminationPointPosition3DArray;
_SUTaxiAIVehicleWaypointMainArray  = _SUAIGroup addWaypoint [_SUTaxiAIVehicleTerminationWaypointPosition3DArray, _SUTaxiWaypointRadiusInMetersNumber,_SUTaxiAIVehicleWaypointMainArrayIndexNumber];
// When setting the waypoint, make a note: How far are we going to go?
_iWantToTravelThisManyMetresNumber = (round(_SUTaxiAIVehicleObject distance _SUTaxiAIVehicleTerminationWaypointPosition3DArray));
// Active Waypoint has changed
_SUActiveWaypointPositionPosition3DArray = _SUTerminationPointPosition3DArray;
_SUTaxiAIVehicleWaypointMainArray		setWaypointType						"MOVE";
_SUTaxiAIVehicleWaypointMainArray		setWaypointSpeed						"FULL";
_SUTaxiAIVehicleWaypointMainArray		setWaypointTimeout						[1, 1, 1];
	if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase06_ToTerminationAndTheEnd.sqf]  [TV4] AFTER adding the WaypointType: _SUTaxiAIVehicleWaypointMainArrayIndexNumber contains: (%1).   _SUTaxiAIVehicleWaypointMainArray contains: (%2)", (str _SUTaxiAIVehicleWaypointMainArrayIndexNumber), (str _SUTaxiAIVehicleWaypointMainArray)];};//dbg

//check distance to our Current Waypoint (_requestorPositionArray) and write to server RPT log
_SUTaxiAIVehicleDistanceToWayPointMetersNumber = (round (_SUTaxiAIVehicleObject distance _SUTerminationPointPosition3DArray));
	if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase06_ToTerminationAndTheEnd.sqf]  [TV3] Distance to Waypoint _SUTerminationPointPosition3DArray is: (%1). Going there now.", _SUTaxiAIVehicleDistanceToWayPointMetersNumber];};//dbg
// LOOP ON THE WAY TO PICKUP!
_counterForLogOnlyEveryNthPINGNumber = 0;
diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase06_ToTerminationAndTheEnd.sqf]  [TVEV-DEBUG]           NEXT, will enter drivingToTerminationPoint25."];
_SUCurrentTaskThresholdInSecondsNumber = mgmTfA_configgv_expiryTimeOutThresholdfixedDestinationTaxiOnTheWayToTerminationInSecondsNumber;
// Reset Current Task Age
_SUCurrentTaskAgeInSecondsNumber = 0;
// Start the Current Task Age Timer
_SUCurrentTaskBirthTimeInSecondsNumber = (time);
// We are on the way to termination... We will loop till we are very close to the termination point.
// TODO: if driver gets killed, this will never complete? add more checks here. a timetick maybe?
_broadcastSUInformationCounter = 0;
while {_SUTaxiAIVehicleDistanceToWayPointMetersNumber>25} do {
	scopeName "drivingToTerminationPoint25";
	
	///
	// Broadcast ServiceUnit Information
	///
	// Only if it has been at least 1 second!	currently uiSleep`ing 0.05 seconds, meaning at least 1 second = 1.00 / 0.05 = 20th package.
	_broadcastSUInformationCounter = _broadcastSUInformationCounter + 1;
	if (_broadcastSUInformationCounter >= 20) then {
		// Need to calculate these now as we will publish it in the next line!
		_SUCurrentTaskAgeInSecondsNumber = (round ((time) - _SUCurrentTaskBirthTimeInSecondsNumber));
		_SUTaxiAIVehicleObjectAgeInSecondsNumber = (round ((time) -_SUTaxiAIVehicleObjectBirthTimeInSecondsNumber));
		_SUAIVehicleObjectAgeInSecondsNumber = _SUTaxiAIVehicleObjectAgeInSecondsNumber;
		_SUAIVehicleObjectCurrentPositionPosition3DArray = (getPosATL _SUTaxiAIVehicleObject);
		_SUTaxiAIVehicleVehicleDirectionInDegreesNumber = (getDir _SUTaxiAIVehicleObject) + 45;
		_SUAIVehicleVehicleDirectionInDegreesNumber = _SUTaxiAIVehicleVehicleDirectionInDegreesNumber;
		_SUAIVehicleSpeedOfVehicleInKMHNumber = (round (speed _SUTaxiAIVehicleObject));
		_SUAIVehicleObject = _SUTaxiAIVehicleObject;
		_SUAIVehicleObjectBirthTimeInSecondsNumber = _SUTaxiAIVehicleObjectBirthTimeInSecondsNumber;
		_SUDistanceToActiveWaypointInMetersNumber = (round (_SUAIVehicleObject distance _SUActiveWaypointPositionPosition3DArray));
		_null = [_myGUSUIDNumber, _SUTypeTextString, _SUActiveWaypointPositionPosition3DArray, _SUCurrentActionInProgressTextString, _SUCurrentTaskThresholdInSecondsNumber, _SUCurrentTaskBirthTimeInSecondsNumber, _SUDriversFirstnameTextString, _SUMarkerShouldBeDestroyedAfterExpiryBool, _SURequestorPlayerUIDTextString, _SURequestorProfileNameTextString, _SUAIVehicleObject, _SUAIVehicleObjectBirthTimeInSecondsNumber, _SUPickUpHasOccurredBool, _SUPickUpPositionPosition3DArray, _SUDropOffPositionHasBeenDeterminedBool, _SUDropOffHasOccurredBool, _SUDropOffPositionPosition3DArray, _SUDropOffPositionNameTextString, _SUTerminationPointPositionHasBeenDeterminedBool, _SUTerminationPointPosition3DArray, _SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray, _SUAIVehicleObjectCurrentPositionPosition3DArray, _SUAIVehicleVehicleDirectionInDegreesNumber, _SUAIVehicleObjectAgeInSecondsNumber, _SUCurrentTaskAgeInSecondsNumber, _SUAIVehicleSpeedOfVehicleInKMHNumber, _SUDistanceToActiveWaypointInMetersNumber] call mgmTfA_fnc_server_PublicVariableBroadcastSUInformationPhaseB;
		_broadcastSUInformationCounter = 0;
	};
	///

	
	//First let's refresh the distance value
	//check distance to our Current Waypoint (_requestorPositionArray) and write to server RPT log
	_SUTaxiAIVehicleDistanceToWayPointMetersNumber = (round (_SUTaxiAIVehicleObject distance _SUTerminationPointPosition3DArray));
	uiSleep 0.05;

	// Calculate Current Task Age and Initiate Abnormal SU Termination (logged) if necessary
	_SUCurrentTaskAgeInSecondsNumber = round ((time) - _SUCurrentTaskBirthTimeInSecondsNumber);
	if (_SUCurrentTaskAgeInSecondsNumber > _SUCurrentTaskThresholdInSecondsNumber) then {
		// Expiry Timeout Threshold Exceeded. Initiating Abnormal Termination of SU.
		//if (_thisFileVerbosityLevelNumber>=1) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase06_ToTerminationAndTheEnd.sqf]  [TV1]          Expiry Timeout Threshold Exceeded for SU (%1). Initiating Abnormal SU Termination! _SUCurrentTaskAgeInSecondsNumber is: (%2). _SUCurrentTaskThresholdInSecondsNumber is: (%3).", _myGUSUIDNumber, _SUCurrentTaskAgeInSecondsNumber, _SUCurrentTaskThresholdInSecondsNumber];};//dbg
		// We are being abnormally destroyed!
		//	TODO	THIS IS NOT READY. FIRST FINISH BASIC WORKFLOW. THEN COME FIX THIS.	[] call mgmTfA_fnc_server_aTaskExceededThresholdInitiateServiceUnitAbnormalShutdownImmediately;
		_emergencyEscapeNeeded = true;
	};
	 // Let emergency escapees pass
	if(_emergencyEscapeNeeded) then {	breakTo "mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyondMainScope";	};

	// Broadcast Service Unit Status
//	TODO	THIS IS NOT READY. FIRST FINISH BASIC WORKFLOW. THEN COME FIX THIS.		[false] call PublicVariableBroadcastSUInformation;
//		//if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase06_ToTerminationAndTheEnd.sqf]  [TV3]          call PublicVariableBroadcastSUInformation executed 	at CheckPoint9!"];};
	 // Broadcast Service Unit Status

	// PING			log only every Nth package			(uiSleep=0.05)		(n=300)  => 	log every 15 seconds
	_counterForLogOnlyEveryNthPINGNumber=_counterForLogOnlyEveryNthPINGNumber+1;
	if (_counterForLogOnlyEveryNthPINGNumber==300) then {
		_SUTaxiAIVehicleObjectAgeInSecondsNumber = (round ((time) - _SUTaxiAIVehicleObjectBirthTimeInSecondsNumber));
		if (_thisFileVerbosityLevelNumber>=1) then {
			diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase06_ToTerminationAndTheEnd.sqf]  [TV1]          PING from vehicle GUSUID: (%1) | Driver: (%2) | ServerUpTime: (%3) | MyAge: (%4) | Distance to WP: (%5) metres | Action In Progress: (%6) (checking 25 m.)", _myGUSUIDNumber, _SUDriversFirstnameTextString, (round (time)), _SUTaxiAIVehicleObjectAgeInSecondsNumber, _SUTaxiAIVehicleDistanceToWayPointMetersNumber, _SUCurrentActionInProgressTextString];
		};
		_counterForLogOnlyEveryNthPINGNumber=0;
	};
	// Pit-stop checks: AutoRefuel
	if (fuel _SUTaxiAIVehicleObject < 0.2) then {
		_SUTaxiAIVehicleObject setFuel 1;
		if (_thisFileVerbosityLevelNumber>=2) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase06_ToTerminationAndTheEndMainScope.sqf]  [TV2] REFUELing SU Vehicle: (%1) | Driver: (%2) | ServerUpTime: (%3)", _myGUSUIDNumber, _SUDriversFirstnameTextString, (round (time))];};//dbg
	};
	// Pit-stop checks: AutoRepair
	if (damage _SUTaxiAIVehicleObject>0.2) then {
		_SUTaxiAIVehicleObject setDamage 0;
		if (_thisFileVerbosityLevelNumber>=2) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase06_ToTerminationAndTheEndMainScope.sqf]  [TV2] REPAIRing SU Vehicle: (%1) | Driver: (%2) | ServerUpTime: (%3)", _myGUSUIDNumber, _SUDriversFirstnameTextString, (round (time))];};//dbg
	};
};
if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase06_ToTerminationAndTheEnd.sqf] [TV4] EXITED LOOP: drivingToTerminationPoint25"];};//dbg

//On arrival to waypoint (termination point) add the travelled distance to the global counter and then reset our local counter
mgmTfA_dynamicgv_fixedDestinationTaxisTotalDistanceTravelledByTaxisNumber = mgmTfA_dynamicgv_fixedDestinationTaxisTotalDistanceTravelledByTaxisNumber + _iWantToTravelThisManyMetresNumber;
	if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase06_ToTerminationAndTheEnd.sqf] [TV4] mgmTfA_dynamicgv_fixedDestinationTaxisTotalDistanceTravelledByTaxisNumber is now (%1). It now reflects the distance I just travelled (%2).]", mgmTfA_dynamicgv_fixedDestinationTaxisTotalDistanceTravelledByTaxisNumber, _iWantToTravelThisManyMetresNumber];};//dbg
// We can now reset this SU's distance_travelled counter -- because we already added it to mgmTfA_dynamicgv_clickNGoTaxisTotalDistanceTravelledByTaxisNumber
_iWantToTravelThisManyMetresNumber = 0;

///
// TERMINATION SEQUENCE
///
//Change our status to:		7 AT-TERMINATION				we are doing bits and bobs before we self-destruct	[e.g. update HQ etc]
_SUCurrentActionInProgressTextString  = mgmTfA_configgv_currentFixedDestinationTaxiActionInProgressIs07TextString;
_SUTaxiAIVehicleObjectAgeInSecondsNumber = (round ((time) - _SUTaxiAIVehicleObjectBirthTimeInSecondsNumber));
	//Inform the LOG that we have arrived self-termination point
	if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase06_ToTerminationAndTheEnd.sqf]  [TV4]          I have arrived at SELF-TERMINATION POINT."];};//dbg
	if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase06_ToTerminationAndTheEnd.sqf]  [TV4]          TERMINATION Sequence in Progress for Service Unit:          Driver:(%1)   |   in Vehicle: (%2)   |   ServerUpTime: (%3)   |   MyAge: (%4).",  _SUDriversFirstnameTextString, _myGUSUIDNumber, (round (time)), _SUTaxiAIVehicleObjectAgeInSecondsNumber];};//dbg
//We will delete the vehicle & driver in a moment however first wait for vehicle to come to full stop.
//This is to protect any players that might somehow jumped in (if we delete while moving fast, they they a health hit and perhaps broken bones)
waitUntil {speed _SUTaxiAIVehicleObject == 0};
	if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase06_ToTerminationAndTheEnd.sqf]  [TV4]          TERMINATION SEQUENCE IN PROGRESS: Waiting for full-stop before deleting driver & vehicle."];};//dbg
//We are not moving - eject any players
{
	_x action ["Eject", _SUTaxiAIVehicleObject];
} forEach crew _SUTaxiAIVehicleObject;

//// Delete Map Markers
// We will sleep and delete, but first, let's update all mapMarkers to reflect that this marker is "In Deletion Queue".
// Broadcast Service Unit Status
//	TODO	THIS IS NOT READY. FIRST FINISH BASIC WORKFLOW. THEN COME FIX THIS.	[false] call PublicVariableBroadcastSUInformation;
// Now we will sleep but if we take a looong nap, markers won't get updated nicely so what we do is, start a timer (just to know when to quit for good) and then start taking short 1 sec naps
//
_counterForDelayedDeletionLoop = 0;
_delayedDeletionStartTimeInSecondsNumber = (time);
if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase06_ToTerminationAndTheEnd.sqf]  [TV4]          ENTERed TERMINATION SLEEP LOOP."];};//dbg
_broadcastSUInformationCounter = 0;
while {(((time) - _delayedDeletionStartTimeInSecondsNumber) < mgmTfA_configgv_mapMarkerExpiryTimeForTerminatedServiceUnitsInSecondsNumber)} do {
	scopeName "atTerminationPoint";
	
	///
	// Broadcast ServiceUnit Information
	///
	// Only if it has been at least 1 second!	currently uiSleep`ing 0.05 seconds, meaning at least 1 second = 1.00 / 0.05 = 20th package.
	_broadcastSUInformationCounter = _broadcastSUInformationCounter + 1;
	if (_broadcastSUInformationCounter >= 20) then {
		// Need to calculate these now as we will publish it in the next line!
		_SUCurrentTaskAgeInSecondsNumber = (round ((time) - _SUCurrentTaskBirthTimeInSecondsNumber));
		_SUTaxiAIVehicleObjectAgeInSecondsNumber = (round ((time) -_SUTaxiAIVehicleObjectBirthTimeInSecondsNumber));
		_SUAIVehicleObjectAgeInSecondsNumber = _SUTaxiAIVehicleObjectAgeInSecondsNumber;
		_SUAIVehicleObjectCurrentPositionPosition3DArray = (getPosATL _SUTaxiAIVehicleObject);
		_SUTaxiAIVehicleVehicleDirectionInDegreesNumber = (getDir _SUTaxiAIVehicleObject) + 45;
		_SUAIVehicleVehicleDirectionInDegreesNumber = _SUTaxiAIVehicleVehicleDirectionInDegreesNumber;
		_SUAIVehicleSpeedOfVehicleInKMHNumber = (round (speed _SUTaxiAIVehicleObject));
		_SUAIVehicleObject = _SUTaxiAIVehicleObject;
		_SUAIVehicleObjectBirthTimeInSecondsNumber = _SUTaxiAIVehicleObjectBirthTimeInSecondsNumber;
		_SUDistanceToActiveWaypointInMetersNumber = (round (_SUAIVehicleObject distance _SUActiveWaypointPositionPosition3DArray));
		_null = [_myGUSUIDNumber, _SUTypeTextString, _SUActiveWaypointPositionPosition3DArray, _SUCurrentActionInProgressTextString, _SUCurrentTaskThresholdInSecondsNumber, _SUCurrentTaskBirthTimeInSecondsNumber, _SUDriversFirstnameTextString, _SUMarkerShouldBeDestroyedAfterExpiryBool, _SURequestorPlayerUIDTextString, _SURequestorProfileNameTextString, _SUAIVehicleObject, _SUAIVehicleObjectBirthTimeInSecondsNumber, _SUPickUpHasOccurredBool, _SUPickUpPositionPosition3DArray, _SUDropOffPositionHasBeenDeterminedBool, _SUDropOffHasOccurredBool, _SUDropOffPositionPosition3DArray, _SUDropOffPositionNameTextString, _SUTerminationPointPositionHasBeenDeterminedBool, _SUTerminationPointPosition3DArray, _SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray, _SUAIVehicleObjectCurrentPositionPosition3DArray, _SUAIVehicleVehicleDirectionInDegreesNumber, _SUAIVehicleObjectAgeInSecondsNumber, _SUCurrentTaskAgeInSecondsNumber, _SUAIVehicleSpeedOfVehicleInKMHNumber, _SUDistanceToActiveWaypointInMetersNumber] call mgmTfA_fnc_server_PublicVariableBroadcastSUInformationPhaseB;
		_broadcastSUInformationCounter = 0;
	};
	///

	
	 // Let emergency escapees pass
	if(_emergencyEscapeNeeded) then {	breakTo "mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase06_ToTerminationAndTheEndMainScope";	};

	uiSleep 0.05;
	// Sleep a variable amount:		min=1.1 seconds	max=1.7 seconds
	//uiSleep (1.10 + (random 0.60));

	_counterForDelayedDeletionLoop = _counterForDelayedDeletionLoop + 1;
	if (_counterForDelayedDeletionLoop == 5) then {
//	TODO	THIS IS NOT READY. FIRST FINISH BASIC WORKFLOW. THEN COME FIX THIS.			[false] call PublicVariableBroadcastSUInformation;
	};
	if (_thisFileVerbosityLevelNumber>=5) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase06_ToTerminationAndTheEnd.sqf]  [TV5]          TICK in TERMINATION point, _delayedDeletion SLEEP LOOP."];};//dbg
};
if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase06_ToTerminationAndTheEnd.sqf]  [TV4]          EXITed TERMINATION point, _delayedDeletion SLEEP LOOP."];};//dbg


//	let's try once more: 	spinning whilst driver is in vehicle  		//Delete the driver now - otherwise kicks him out during the spin!
//	let's try once more: 	spinning whilst driver is in vehicle  		deleteVehicle _SUAICharacterDriverObject;
if (mgmTfA_configgv_fixedDestinationTaxisSpinBeforeDeletionBool) then {
	// Spin Before Deletion -- Give a Visual Indicator to any players that might have an eye on this vehicle (this rotation is to indicate that this vehicle is being 'TfA-deleted')
	private ["_i"];
	_vehDir = (getDir _SUTaxiAIVehicleObject) + 45;
	
	for [{_i=1}, {_i<=8}, {_i=_i+1}] do
	{
		uiSleep 0.08;
		// Killzone Kid say To setDir for AI unit, setFormDir first	https://community.bistudio.com/wiki/setDir
		_SUTaxiAIVehicleObject 	setFormDir				_vehDir;
		_SUTaxiAIVehicleObject 	setDir					_vehDir;
		_SUTaxiAIVehicleObject 	setPos 	getPos 			_SUTaxiAIVehicleObject;
		_vehDir = _vehDir + 45;
	};
	if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase06_ToTerminationAndTheEnd.sqf]  [TV4] <ThisIs:%1> TERMINATION SEQUENCE IN PROGRESS: Just completed DeletionRotation on the vehicle.", _myGUSUIDNumber];};//dbg
};
// Delete the driver now
deleteVehicle _SUAICharacterDriverObject;
// Delete the vehicle now
deleteVehicle _SUTaxiAIVehicleObject;
if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase06_ToTerminationAndTheEnd.sqf]  [TV4] <ThisIs:%1> TERMINATION SEQUENCE IN PROGRESS: Deleted driver & vehicle.", _myGUSUIDNumber];};//dbg
// The first thing we need to do is ensure variable security during our  expected long runtime so let's go ahead and create our own copies:
_SUCurrentActionInProgressTextString  = mgmTfA_configgv_currentFixedDestinationTaxiActionInProgressIs08TextString;
// We did everything (except map marker clean up). No need to occupy a global tax driver slot any more. Let's free it up.
if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase06_ToTerminationAndTheEnd.sqf]  [TV4]          TERMINATION SEQUENCE IN PROGRESS: mgmTfA_gvdb_PV_fixedDestinationTaxisNumberOfCurrentlyAvailableTaxiDriversNumber is (%1) BEFORE the change.", mgmTfA_gvdb_PV_fixedDestinationTaxisNumberOfCurrentlyAvailableTaxiDriversNumber];};//dbg
mgmTfA_gvdb_PV_fixedDestinationTaxisNumberOfCurrentlyAvailableTaxiDriversNumber=mgmTfA_gvdb_PV_fixedDestinationTaxisNumberOfCurrentlyAvailableTaxiDriversNumber+1;
if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase06_ToTerminationAndTheEnd.sqf]  [TV4]          TERMINATION SEQUENCE IN PROGRESS: mgmTfA_gvdb_PV_fixedDestinationTaxisNumberOfCurrentlyAvailableTaxiDriversNumber is (%1) AFTER the change.", mgmTfA_gvdb_PV_fixedDestinationTaxisNumberOfCurrentlyAvailableTaxiDriversNumber];};//dbg

// Now send the signal to all map-trackers that this marker must be deleted after the expiry threshold
_SUMarkerShouldBeDestroyedAfterExpiryBool = true;
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUMarkerShouldBeDestroyedAfterExpiryBool", _myGUSUIDNumber], _SUMarkerShouldBeDestroyedAfterExpiryBool];
publicVariable format ["mgmTfA_gv_PV_SU%1SUMarkerShouldBeDestroyedAfterExpiryBool", _myGUSUIDNumber];
if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase06_ToTerminationAndTheEnd.sqf]  [TV3]          TERMINATION SEQUENCE IN PROGRESS: Issued: mgmTfA_gv_PV_SU%1SUMarkerShouldBeDestroyedAfterExpiryBool! for GUSUID: (%1)", _myGUSUIDNumber];};//dbg

// There are no map Markers on server-side anymore!
// THIS IS NOT ENABLED		deleteMarker _spawnMarker;
// Successfully completing a Taxi Request - increment the counter by one
mgmTfA_gvdb_PV_fixedDestinationTaxisTotalRequestsSuccessfulNumber = mgmTfA_gvdb_PV_fixedDestinationTaxisTotalRequestsSuccessfulNumber + 1;
if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase06_ToTerminationAndTheEnd.sqf]  [TV3]          I have SUCCESSFULLY FULFILLED a request therefore incremented mgmTfA_gvdb_PV_fixedDestinationTaxisTotalRequestsSuccessfulNumber by one. Current value, after the increment, is: (%1). The requestor for this successful job was: (%2).", mgmTfA_gvdb_PV_fixedDestinationTaxisTotalRequestsSuccessfulNumber, _fixedDestinationRequestorProfileNameTextString];};//dbg
if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase06_ToTerminationAndTheEnd.sqf]  [TV3]          TERMINATION SEQUENCE COMPLED. Have a nice day."];};//dbg
// EOF