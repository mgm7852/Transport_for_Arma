//H
//H ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase05_DropOffPointAndBeyond.sqf
//H $PURPOSE$	:	This function manage the SU during its approach to DropOffPoint, Awaiting Requestor to Get Off, ... phases. It will end when SU is about to begin travelling towards Termination Point.
//H ~~
//H
//HH
//HH ~~
//HH	Example usage	:	_null =	[_fixedDestinationRequestorProfileNameTextString, _fixedDestinationRequestorClientIDNumber, _iWantToTravelThisManyMetresNumber, _requestorPlayerObject, _myGUSUIDNumber, _SUAICharacterDriverObject, _SUTaxiAIVehicleObject, _SUTaxiAIVehicleObjectBirthTimeInSecondsNumber, _SUDriversFirstnameTextString, _doorsLockedBool, _SUTaxiAIVehicleWaypointMainArray, _SUTaxiAIVehicleWaypointMainArrayIndexNumber, _SUTaxiWaypointRadiusInMetersNumber, _SUAIGroup, _SUAIVehicleObjectAgeInSecondsNumber, _SUAIVehicleObjectCurrentPositionPosition3DArray, _SUTaxiAIVehicleVehicleDirectionInDegreesNumber, _SUAIVehicleVehicleDirectionInDegreesNumber, _SUAIVehicleSpeedOfVehicleInKMHNumber, _SUPickUpPositionPosition3DArray, _SUAIVehicleObject, _SUAIVehicleObjectBirthTimeInSecondsNumber, _SUDistanceToActiveWaypointInMetersNumber, _SUActiveWaypointPositionPosition3DArray, _SUTypeTextString, _SUMarkerShouldBeDestroyedAfterExpiryBool, _SURequestorPlayerUIDTextString, _SURequestorProfileNameTextString, _SUPickUpHasOccurredBool, _SUDropOffPositionHasBeenDeterminedBool, _SUDropOffHasOccurredBool, _SUDropOffPositionPosition3DArray, _SUDropOffPositionNameTextString, _SUTerminationPointPositionHasBeenDeterminedBool, _SUTerminationPointPosition3DArray, _SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray] spawn mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase05_DropOffPointAndBeyond;
//HH	Parameters	:	too many to list
//HH	Return Value	:	none	[this function spawns the next function in the workflow
//HH ~~
//HH	The server-side master configuration file read (and/or publicVariable publish) the following value(s) this function rely on:
//HH		mgmTfA_configgv_serverVerbosityLevel
//HH
if (!isServer) exitWith {}; if (isNil("mgmTfA_Server_Init")) then {mgmTfA_Server_Init=0;}; waitUntil {mgmTfA_Server_Init==1}; private ["_thisFileVerbosityLevelNumber"]; _thisFileVerbosityLevelNumber = mgmTfA_configgv_serverVerbosityLevel;
scopeName "mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase05_DropOffPointAndBeyondMainScope";
if (mgmTfA_configgv_serverVerbosityLevel>=4) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase05_DropOffPointAndBeyond.sqf]  [TV4] I have been SPAWN'd. I have the following arguments in (_this)=(%1).", (str _this)];};//dbg

private	[
		"_thisFileVerbosityLevelNumber",
		"_SUCurrentActionInProgressTextString",
		"_fixedDestinationRequestorProfileNameTextString",
		"_fixedDestinationRequestorClientIDNumber",
		"_iWantToTravelThisManyMetresNumber",
		"_requestorPlayerObject",
		"_requestorInsideVehicle",
		"_SUCurrentTaskThresholdInSecondsNumber",
		"_SUCurrentTaskAgeInSecondsNumber",
		"_SUCurrentTaskBirthTimeInSecondsNumber",
		"_emergencyEscapeNeeded",
		"_myGUSUIDNumber",
		"_SUAICharacterDriverObject",
		"_SUTaxiAIVehicleObject",
		"_counterForLogOnlyEveryNthPINGNumber",
		"_SUTaxiAIVehicleObjectAgeInSecondsNumber",
		"_SUTaxiAIVehicleObjectBirthTimeInSecondsNumber",
		"_SUDriversFirstnameTextString",
		"_doorsLockedBool",
		"_SUTaxiAIVehicleDistanceToWayPointMetersNumber",
		"_SUAIGroup",
		"_SUTaxiAIVehicleWaypointMainArray",
		"_SUTaxiAIVehicleWaypointMainArrayIndexNumber",
		"_SUTaxiWaypointRadiusInMetersNumber",
		"_broadcastSUInformationCounter",
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
		"_SUTypeTextString",
		"_SUMarkerShouldBeDestroyedAfterExpiryBool",
		"_SURequestorPlayerUIDTextString",
		"_SURequestorProfileNameTextString",
		"_SUPickUpHasOccurredBool",
		"_SUDropOffPositionHasBeenDeterminedBool",
		"_SUDropOffHasOccurredBool",
		"_SUDropOffPositionPosition3DArray",
		"_SUDropOffPositionNameTextString",
		"_SUTerminationPointPositionHasBeenDeterminedBool",
		"_SUTerminationPointPosition3DArray",
		"_SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray"			
		];
//// Prep Function Arguments	&	Assign Initial Values for Local Variables
_thisFileVerbosityLevelNumber = mgmTfA_configgv_serverVerbosityLevel;
_fixedDestinationRequestorProfileNameTextString = (_this select 0);
_fixedDestinationRequestorClientIDNumber  = (_this select 1);
_iWantToTravelThisManyMetresNumber = (_this select 2);
_requestorPlayerObject	 = (_this select 3);
_myGUSUIDNumber		 = (_this select 4);
_SUAICharacterDriverObject = (_this select 5);
_SUTaxiAIVehicleObject	 = (_this select 6);
_SUTaxiAIVehicleObjectBirthTimeInSecondsNumber = (_this select 7);
_SUDriversFirstnameTextString = (_this select 8);
_doorsLockedBool		 = (_this select 9);
///
// We do not need the following variables in this function however we will need to pass them to the next Phase (Termination) thus we need to parse them
_SUTaxiAIVehicleWaypointMainArray = (_this select 10);
_SUTaxiAIVehicleWaypointMainArrayIndexNumber = (_this select 11);
_SUTaxiWaypointRadiusInMetersNumber = (_this select 12);
_SUAIGroup			 = (_this select 13);
_SUAIVehicleObjectAgeInSecondsNumber = (_this select 14);
_SUAIVehicleObjectCurrentPositionPosition3DArray = (_this select 15);
_SUTaxiAIVehicleVehicleDirectionInDegreesNumber = (_this select 16);
_SUAIVehicleVehicleDirectionInDegreesNumber = (_this select 17);
_SUAIVehicleSpeedOfVehicleInKMHNumber = (_this select 18);
_SUPickUpPositionPosition3DArray = (_this select 19);
_SUAIVehicleObject		 = (_this select 20);
_SUAIVehicleObjectBirthTimeInSecondsNumber = (_this select 21);
_SUDistanceToActiveWaypointInMetersNumber = (_this select 22);
_SUActiveWaypointPositionPosition3DArray = (_this select 23);
_SUTypeTextString		 = (_this select 24);
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

///
// _SUTaxiAIVehicleDistanceToWayPointMetersNumber							<=	do not set this variable yet (it will be done while waiting for Requestor to get off the vehicle)
// _requestorInsideVehicle													<=	do not set this variable yet (it will be done later in this file)
// _SUCurrentTaskThresholdInSecondsNumber									<=	do not set this variable yet (it will be done later in this file)
// _SUCurrentTaskAgeInSecondsNumber											<=	do not set this variable yet (it will be done later in this file)
// _SUCurrentTaskBirthTimeInSecondsNumber									<=	do not set this variable yet (it will be done later in this file)
// _SUCurrentActionInProgressTextString										<=	do not set this variable yet (it will be done later in this file)
// _SUTaxiAIVehicleObjectAgeInSecondsNumber									<=	do not set this variable yet (it will be done in the first PING block)
_emergencyEscapeNeeded	 = false;
// All we know so far is that the requestor is still in the vehicle...
// no need to do this! we have already received this as function argument. it is already set to false.	_SUDropOffHasOccurredBool = false;
_counterForLogOnlyEveryNthPINGNumber = 0;
//_broadcastSUInformationCounter											<=	do not set this variable yet (it will be done in the first PING block)

//// BEGIN
// We've arrived Drop Off Point!
// Change our status to:		5 AWAITING GET OFF			requestor must get off the vehicle so that we can go self destruct in peace
_SUCurrentActionInProgressTextString  = mgmTfA_configgv_currentFixedDestinationTaxiActionInProgressIs05TextString;

// Send a message to the Requestor's computer -- note that, the target computer will display this ONLY IF the Requestor is still in the original vehicle.	To do this, we will need to send the _myGUSUIDNumber so that client computer can compare it with its local player's current vehicle GUSUID and display the message only if they match (i.e.: if Requestor is still in the original vehicle).
//However do NOT message if we are still moving - that's how accidents happen!
waitUntil {speed _SUTaxiAIVehicleObject == 0};
// create the global variable that will be sent to the requestor's PC	// send the _myGUSUIDNumber here!
mgmTfA_gv_pvc_pos_yourFixedDestinationTaxiHaveArrivedThankYouForYourBusinessHaveANiceDayPacket = _myGUSUIDNumber;
_fixedDestinationRequestorClientIDNumber		publicVariableClient		"mgmTfA_gv_pvc_pos_yourFixedDestinationTaxiHaveArrivedThankYouForYourBusinessHaveANiceDayPacket";
if (_thisFileVerbosityLevelNumber>2) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase05_DropOffPointAndBeyond.sqf]  [TV2]  SIGNAL SENT to the Requestor (We have arrived. Thank you for your business. Have a nice day.). _fixedDestinationRequestorProfileNameTextString: (%1)  on computer (_fixedDestinationRequestorClientIDNumber)=(%2). The _myGUSUIDNumber is: (%3).", _fixedDestinationRequestorProfileNameTextString, _fixedDestinationRequestorClientIDNumber, _myGUSUIDNumber];};

//On arrival to waypoint (drop off point) add the travelled distance to the global counter and then reset our local counter
mgmTfA_dynamicgv_fixedDestinationTaxisTotalDistanceTravelledByTaxisNumber = mgmTfA_dynamicgv_fixedDestinationTaxisTotalDistanceTravelledByTaxisNumber + _iWantToTravelThisManyMetresNumber;
if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase05_DropOffPointAndBeyond.sqf] [TV3] mgmTfA_dynamicgv_fixedDestinationTaxisTotalDistanceTravelledByTaxisNumber is now (%1). It now reflects the distance I just travelled (%2).]", mgmTfA_dynamicgv_fixedDestinationTaxisTotalDistanceTravelledByTaxisNumber, _iWantToTravelThisManyMetresNumber];};//dbg
// We can now reset this SU's distance_travelled counter -- because we already added it to mgmTfA_dynamicgv_clickNGoTaxisTotalDistanceTravelledByTaxisNumber
_iWantToTravelThisManyMetresNumber = 0;

//Initial evaluation
if (_requestorPlayerObject in _SUTaxiAIVehicleObject) then {
	//He's in!
	_requestorInsideVehicle=true;
} else {
	//He's not in!
	_requestorInsideVehicle=false;
};

_SUCurrentTaskThresholdInSecondsNumber = mgmTfA_configgv_expiryTimeOutThresholdfixedDestinationTaxiRequestorInsideVehicleInSecondsNumber;
// Reset Current Task Age
_SUCurrentTaskAgeInSecondsNumber = 0;
//Start the Current Task Age Timer
_SUCurrentTaskBirthTimeInSecondsNumber = (time);

_counterForLogOnlyEveryNthPINGNumber = 0;

// Set distance to Current Waypoint to zero as we are at the DropOff Point and awaiting Requestor to get off the vehicle...
_SUTaxiAIVehicleDistanceToWayPointMetersNumber = 0;

//As long as he is inside, we will patiently wait for him to get out
//TODO: don't be so patient. add a timer here to kick him out after a short wait
_broadcastSUInformationCounter = 0;
while {_requestorInsideVehicle} do {
	scopeName "RequestorInsideVehicleLoop";
	
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
		_SUDistanceToActiveWaypointInMetersNumber = (round (_SUAIVehicleObject distance _SUActiveWaypointPositionPosition3DArray));
		_null = [_myGUSUIDNumber, _SUTypeTextString, _SUActiveWaypointPositionPosition3DArray, _SUCurrentActionInProgressTextString, _SUCurrentTaskThresholdInSecondsNumber, _SUCurrentTaskBirthTimeInSecondsNumber, _SUDriversFirstnameTextString, _SUMarkerShouldBeDestroyedAfterExpiryBool, _SURequestorPlayerUIDTextString, _SURequestorProfileNameTextString, _SUAIVehicleObject, _SUAIVehicleObjectBirthTimeInSecondsNumber, _SUPickUpHasOccurredBool, _SUPickUpPositionPosition3DArray, _SUDropOffPositionHasBeenDeterminedBool, _SUDropOffHasOccurredBool, _SUDropOffPositionPosition3DArray, _SUDropOffPositionNameTextString, _SUTerminationPointPositionHasBeenDeterminedBool, _SUTerminationPointPosition3DArray, _SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray, _SUAIVehicleObjectCurrentPositionPosition3DArray, _SUAIVehicleVehicleDirectionInDegreesNumber, _SUAIVehicleObjectAgeInSecondsNumber, _SUCurrentTaskAgeInSecondsNumber, _SUAIVehicleSpeedOfVehicleInKMHNumber, _SUDistanceToActiveWaypointInMetersNumber] call mgmTfA_fnc_server_PublicVariableBroadcastSUInformationPhaseB;
		_broadcastSUInformationCounter = 0;
	};
	///
	uiSleep 0.05;
	// Pit-stop checks: AutoRefuel
	if (fuel _SUTaxiAIVehicleObject < 0.2) then {
		_SUTaxiAIVehicleObject setFuel 1;
		if (_thisFileVerbosityLevelNumber>=2) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase05_DropOffPointAndBeyond.sqf]  [TV2] REFUELing SU Vehicle: (%1) | Driver: (%2) | ServerUpTime: (%3)", _myGUSUIDNumber, _SUDriversFirstnameTextString, (round (time))];};//dbg
	};
	// Pit-stop checks: AutoRepair
	if (damage _SUTaxiAIVehicleObject>0.2) then {
		_SUTaxiAIVehicleObject setDamage 0;
		if (_thisFileVerbosityLevelNumber>=2) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase05_DropOffPointAndBeyond.sqf]  [TV2] REPAIRing SU Vehicle: (%1) | Driver: (%2) | ServerUpTime: (%3)", _myGUSUIDNumber, _SUDriversFirstnameTextString, (round (time))];};//dbg
	};
	// Calculate Current Task Age and Initiate Abnormal SU Termination (logged) if necessary
	_SUCurrentTaskAgeInSecondsNumber = (round ((time) - _SUCurrentTaskBirthTimeInSecondsNumber));
	if (_SUCurrentTaskAgeInSecondsNumber > _SUCurrentTaskThresholdInSecondsNumber) then {
		_emergencyEscapeNeeded = true;
	};
	 // Let emergency escapees pass
	if(_emergencyEscapeNeeded) then { breakTo "mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase05_DropOffPointAndBeyondMainScope";	};

	// PING			log only every Nth package			(uiSleep=0.05)		(n=300)  => 	log every 15 seconds
	// Let emergency escapees pass
	_counterForLogOnlyEveryNthPINGNumber = _counterForLogOnlyEveryNthPINGNumber + 1;
	if (_counterForLogOnlyEveryNthPINGNumber==300) then {
		if (_thisFileVerbosityLevelNumber>=1) then {
			_SUTaxiAIVehicleObjectAgeInSecondsNumber = (round ((time)-_SUTaxiAIVehicleObjectBirthTimeInSecondsNumber));
			diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase05_DropOffPointAndBeyondMainScope.sqf] [TV1] PING from SU Vehicle: (%1) | Driver: (%2) | ServerUpTime: (%3) | MyAge: (%4) | Distance to WP: (%5) metres | Action In Progress: (%6)", _myGUSUIDNumber, _SUDriversFirstnameTextString, (round (time)), _SUTaxiAIVehicleObjectAgeInSecondsNumber, _SUTaxiAIVehicleDistanceToWayPointMetersNumber, _SUCurrentActionInProgressTextString];
		};
		_counterForLogOnlyEveryNthPINGNumber=0;
	};
	if (_requestorPlayerObject in _SUTaxiAIVehicleObject) then {
		_requestorInsideVehicle=true;
		//He is in
	} else {
		_requestorInsideVehicle=false;
		//He is not in - he got out!!		
		
		// Signal map-trackers that Drop Off has occurred
		_SUDropOffHasOccurredBool = true;
		missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUDropOffHasOccurredBool", _myGUSUIDNumber], _SUDropOffHasOccurredBool];
		publicVariable format ["mgmTfA_gv_PV_SU%1SUDropOffHasOccurredBool", _myGUSUIDNumber];
	};
};
if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase05_DropOffPointAndBeyond.sqf] [TV3] EXITed loop _requestorInsideVehicle"];};
uiSleep 0.05;

//Customer has gotten out and we are about to start driving to our destination. 
//On the way and even before we start moving (while we do waypoint calculations etc.) doors should be locked.
//Lock the vehicle doors
_SUTaxiAIVehicleObject lockCargo true;
// Not that we need ...
_doorsLockedBool = true;
if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase05_DropOffPointAndBeyond.sqf] [TV3] DOORS locked"];};
uiSleep 0.05;

//Use the horn to say bye to the requestor
driver _SUTaxiAIVehicleObject forceWeaponFire [currentWeapon _SUTaxiAIVehicleObject, currentWeapon _SUTaxiAIVehicleObject];
uiSleep 0.05;

//We are not moving - eject any players trying to stay in/get in
//Traverse all crew with forEach
{
	//If the crewMember is NOT our dear _SUAICharacterDriverObject, then eject them!
	if (_x != _SUAICharacterDriverObject) then {
	_x action ["Eject", _SUTaxiAIVehicleObject];
	};
} forEach crew _SUTaxiAIVehicleObject;
uiSleep 0.05;

_null =	[_fixedDestinationRequestorProfileNameTextString, _fixedDestinationRequestorClientIDNumber, _iWantToTravelThisManyMetresNumber, _requestorPlayerObject, _myGUSUIDNumber, _SUAICharacterDriverObject, _SUTaxiAIVehicleObject, _SUTaxiAIVehicleObjectBirthTimeInSecondsNumber, _SUDriversFirstnameTextString, _doorsLockedBool, _SUTaxiAIVehicleWaypointMainArray, _SUTaxiAIVehicleWaypointMainArrayIndexNumber, _SUTaxiWaypointRadiusInMetersNumber, _SUAIGroup, _SUAIVehicleObjectAgeInSecondsNumber, _SUAIVehicleObjectCurrentPositionPosition3DArray, _SUTaxiAIVehicleVehicleDirectionInDegreesNumber, _SUAIVehicleVehicleDirectionInDegreesNumber, _SUAIVehicleSpeedOfVehicleInKMHNumber, _SUPickUpPositionPosition3DArray, _SUAIVehicleObject, _SUAIVehicleObjectBirthTimeInSecondsNumber, _SUDistanceToActiveWaypointInMetersNumber, _SUActiveWaypointPositionPosition3DArray, _SUTypeTextString, _SUMarkerShouldBeDestroyedAfterExpiryBool, _SURequestorPlayerUIDTextString, _SURequestorProfileNameTextString, _SUPickUpHasOccurredBool, _SUDropOffPositionHasBeenDeterminedBool, _SUDropOffHasOccurredBool, _SUDropOffPositionPosition3DArray, _SUDropOffPositionNameTextString, _SUTerminationPointPositionHasBeenDeterminedBool, _SUTerminationPointPosition3DArray, _SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray] spawn mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase06_ToTerminationAndTheEnd;
// EOF