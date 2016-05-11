//H
//H ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyond.sqf
//H $PURPOSE$	:	This function manage the SU during its approach to PickUpPoint, Awaiting Requestor, Awaiting Get In, Payment phases. It will end when SU start travelling towards DropOff Point
//H ~~
//H
//HH
//HH ~~
//HH	Example usage	:	_null =	[_fixedDestinationRequestorClientIDNumber, _fixedDestinationRequestorPosition3DArray, _fixedDestinationRequestedTaxiFixedDestinationIDNumber, _fixedDestinationRequestedDestinationNameTextString, _fixedDestinationRequestorPlayerUIDTextString, _fixedDestinationRequestorProfileNameTextString, _myGUSUIDNumber, _iWantToTravelThisManyMetresNumber, _SUTaxiAIVehicleObject, _SUDriversFirstnameTextString, _fixedDestinationRequestedTaxiFixedDestinationPosition3DArray, _doorsLockedBool, _SUAIGroup, _SUTaxiWaypointRadiusInMetersNumber, _SUTaxiAIVehicleObjectBirthTimeInSecondsNumber, _SUTaxiAIVehicleWaypointMainArray, _SUTaxiAIVehicleWaypointMainArrayIndexNumber, _SUAICharacterDriverObject, _SUTypeTextString, _SUDropOffPositionHasBeenDeterminedBool, _SUDropOffPositionNameTextString, _SUDropOffPositionPosition3DArray, _SUDropOffHasOccurredBool, _SUTerminationPointPositionHasBeenDeterminedBool, _SUTerminationPointPosition3DArray, _SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray] spawn mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyond;
//HH	Parameters	:	too many to list
//HH	Return Value	:	none	[this function spawns the next function in the workflow
//HH ~~
//HH	The server-side master configuration file read (and/or publicVariable publish) the following value(s) this function rely on:
//HH		mgmTfA_configgv_serverVerbosityLevel
//HH
if (!isServer) exitWith {}; if (isNil("mgmTfA_Server_Init")) then {mgmTfA_Server_Init=0;}; waitUntil {mgmTfA_Server_Init==1}; private ["_thisFileVerbosityLevelNumber"]; _thisFileVerbosityLevelNumber = mgmTfA_configgv_serverVerbosityLevel;
scopeName "mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyondMainScope";
if (mgmTfA_configgv_serverVerbosityLevel>=4) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyond.sqf]  [TV4] I have been SPAWN'd. I have the following arguments in (_this)=(%1).", (str _this)];};//dbg

private	[
		"_fixedDestinationRequestorClientIDNumber",
		"_fixedDestinationRequestorPosition3DArray",
		"_fixedDestinationRequestedTaxiFixedDestinationIDNumber",
		"_fixedDestinationRequestedDestinationNameTextString",
		"_fixedDestinationRequestorPlayerUIDTextString",
		"_fixedDestinationRequestorProfileNameTextString",
		"_myGUSUIDNumber",
		"_thisFileVerbosityLevelNumber",
		"_requestorIsNotHere",
		"_emergencyEscapeNeeded",
		"_SUMarkerShouldBeDestroyedAfterExpiryBool",
		"_iWantToTravelThisManyMetresNumber",
		"_SUCurrentActionInProgressTextString",
		"_SUCurrentTaskThresholdInSecondsNumber",
		"_SUCurrentTaskAgeInSecondsNumber",
		"_SUCurrentTaskBirthTimeInSecondsNumber",
		"_playersAroundMeList",
		"_playersAroundMeListCount",
		"_SUTaxiAIVehicleObject",
		"_requestorPlayerObject",
		"_requestorOutsideVehicle",
		"_SUPickUpHasOccurredBool",
		"_SUDriversFirstnameTextString",
		"_requestorHasNotPaid",
		"_doorsLockedBool",
		"_SUTaxiAIVehicleWaypointMainArray",
		"_SUTaxiAIVehicleWaypointMainArrayIndexNumber",
		"_SUDropOffPositionHasBeenDeterminedBool",
		"_SUDropOffPositionNameTextString",
		"_SUDropOffPositionPosition3DArray",
		"_SUDropOffHasOccurredBool",
		"_fixedDestinationRequestedTaxiFixedDestinationPosition3DArray",
		"_SUAIGroup",
		"_SUTaxiWaypointRadiusInMetersNumber",
		"_counterForLogOnlyEveryNthPINGNumber",
		"_SUTaxiAIVehicleDistanceToWayPointMetersNumber",
		"_SUTaxiAIVehicleObjectAgeInSecondsNumber",
		"_SUTaxiAIVehicleObjectBirthTimeInSecondsNumber",
		"_SUAICharacterDriverObject",
		"_broadcastSUInformationCounter",
		"_SUAIVehicleObjectAgeInSecondsNumber",
		"_SUAIVehicleObjectCurrentPositionPosition3DArray",
		"_SUTaxiAIVehicleVehicleDirectionInDegreesNumber",
		"_SUAIVehicleVehicleDirectionInDegreesNumber",
		"_SUAIVehicleSpeedOfVehicleInKMHNumber",
		"_SUPickUpPositionPosition3DArray",
		"_SUAIVehicleObject",
		"_SUAIVehicleObjectBirthTimeInSecondsNumber",
		"_SUActiveWaypointPositionPosition3DArray",
		"_SURequestorPlayerUIDTextString",
		"_SUDistanceToActiveWaypointInMetersNumber",
		"_SURequestorProfileNameTextString",
		"_SUTypeTextString",
		"_SUTerminationPointPositionHasBeenDeterminedBool",
		"_SUTerminationPointPosition3DArray",
		"_SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray",
		"_SUFDServiceFeeNeedToBePaidBool"
		];
//// Prep Function Arguments	&	Assign Initial Values for Local Variables
_thisFileVerbosityLevelNumber = mgmTfA_configgv_serverVerbosityLevel;
_fixedDestinationRequestorClientIDNumber = (_this select 0);
_fixedDestinationRequestorPosition3DArray = (_this select 1);
_fixedDestinationRequestedTaxiFixedDestinationIDNumber = (_this select 2);
_fixedDestinationRequestedDestinationNameTextString = (_this select 3);
_fixedDestinationRequestorPlayerUIDTextString = (_this select 4);
_fixedDestinationRequestorProfileNameTextString = (_this select 5);
_myGUSUIDNumber = (_this select 6);
_iWantToTravelThisManyMetresNumber = (_this select 7);
_SUTaxiAIVehicleObject = (_this select 8);
_SUDriversFirstnameTextString = (_this select 9);
_fixedDestinationRequestedTaxiFixedDestinationPosition3DArray = (_this select 10);
_doorsLockedBool = (_this select 11);
_SUAIGroup = (_this select 12);
_SUTaxiWaypointRadiusInMetersNumber = (_this select 13);
_SUTaxiAIVehicleObjectBirthTimeInSecondsNumber = (_this select 14);
_SUTaxiAIVehicleWaypointMainArray = (_this select 15);
_SUTaxiAIVehicleWaypointMainArrayIndexNumber = (_this select 16);
// Need to pass along the Character to the next Phase(s) and finally to Termination Phase [so that it can be deleted then]
_SUAICharacterDriverObject = (_this select 17);
_SUTypeTextString = (_this select 18);
_SUDropOffPositionHasBeenDeterminedBool = (_this select 19);
_SUDropOffPositionNameTextString = (_this select 20);
_SUDropOffPositionPosition3DArray = (_this select 21);
_SUDropOffHasOccurredBool = (_this select 22);
_SUTerminationPointPositionHasBeenDeterminedBool = (_this select 23);
_SUTerminationPointPosition3DArray = (_this select 24);
_SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray = (_this select 25);
_requestorIsNotHere = true;
_emergencyEscapeNeeded = false;
_SUMarkerShouldBeDestroyedAfterExpiryBool = false;
_playersAroundMeList = objNull;
_playersAroundMeListCount = 0;
_requestorPlayerObject = objNull;
_requestorOutsideVehicle = true;
_SUPickUpHasOccurredBool = false;
_requestorHasNotPaid = true;
_counterForLogOnlyEveryNthPINGNumber = 0;
// do NOT initialize here - will be done later in this file:			_broadcastSUInformationCounter = 0;
//	do not initialize this as we have been passed data by the call'ing function:			_SUDistanceToActiveWaypointInMetersNumber = -1;
// _SUDropOffPositionPosition3DArray								<=	do not set this variable yet (it will be done later in this file)
// These below are a duplicate variables - they are created just to keep function-calling-code consistent.
	_SUActiveWaypointPositionPosition3DArray = _fixedDestinationRequestorPosition3DArray;
	_SURequestorPlayerUIDTextString = _fixedDestinationRequestorPlayerUIDTextString;
	_SURequestorProfileNameTextString = _fixedDestinationRequestorProfileNameTextString;

//// BEGIN
//On arrival to waypoint (pick up point) add the travelled distance to the global counter and then reset our local counter
mgmTfA_dynamicgv_fixedDestinationTaxisTotalDistanceTravelledByTaxisNumber = mgmTfA_dynamicgv_fixedDestinationTaxisTotalDistanceTravelledByTaxisNumber + _iWantToTravelThisManyMetresNumber;
if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyond.sqf] [TV3] mgmTfA_dynamicgv_fixedDestinationTaxisTotalDistanceTravelledByTaxisNumber is now (%1). It now reflects the distance I just travelled (%2).]", mgmTfA_dynamicgv_fixedDestinationTaxisTotalDistanceTravelledByTaxisNumber, _iWantToTravelThisManyMetresNumber];};//dbg
// We can now reset this SU's distance_travelled counter -- because we already added it to mgmTfA_dynamicgv_fixedDestinationTaxisTotalDistanceTravelledByTaxisNumber
_iWantToTravelThisManyMetresNumber = 0;

// We have arrived at PickUpPoint!					
//Change our status to:		2 AWAITING GET IN 								to proceed, first the requestor must get in...
_SUCurrentActionInProgressTextString = mgmTfA_configgv_currentFixedDestinationTaxiActionInProgressIs02TextString;
// Load new threshold
_SUCurrentTaskThresholdInSecondsNumber = mgmTfA_configgv_expiryTimeOutThresholdfixedDestinationTaxiRequestorIsNotHereInSecondsNumber;
// Reset Current Task Age
_SUCurrentTaskAgeInSecondsNumber = 0;
//Start the Current Task Age Timer
_SUCurrentTaskBirthTimeInSecondsNumber = (time);

//We are at the requestorPosition
_broadcastSUInformationCounter = 0;

while {_requestorIsNotHere} do {
	scopeName "IsTheRequestorAtPickUpPointChecksLoop";

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
		_SUPickUpPositionPosition3DArray = _fixedDestinationRequestorPosition3DArray;
		_SUAIVehicleObject = _SUTaxiAIVehicleObject;
		_SUAIVehicleObjectBirthTimeInSecondsNumber = _SUTaxiAIVehicleObjectBirthTimeInSecondsNumber;
		_SUDistanceToActiveWaypointInMetersNumber = (round (_SUAIVehicleObject distance _SUActiveWaypointPositionPosition3DArray));
		_null = [_myGUSUIDNumber, _SUTypeTextString, _SUActiveWaypointPositionPosition3DArray, _SUCurrentActionInProgressTextString, _SUCurrentTaskThresholdInSecondsNumber, _SUCurrentTaskBirthTimeInSecondsNumber, _SUDriversFirstnameTextString, _SUMarkerShouldBeDestroyedAfterExpiryBool, _SURequestorPlayerUIDTextString, _SURequestorProfileNameTextString, _SUAIVehicleObject, _SUAIVehicleObjectBirthTimeInSecondsNumber, _SUPickUpHasOccurredBool, _SUPickUpPositionPosition3DArray, _SUDropOffPositionHasBeenDeterminedBool, _SUDropOffHasOccurredBool, _SUDropOffPositionPosition3DArray, _SUDropOffPositionNameTextString, _SUTerminationPointPositionHasBeenDeterminedBool, _SUTerminationPointPosition3DArray, _SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray, _SUAIVehicleObjectCurrentPositionPosition3DArray, _SUAIVehicleVehicleDirectionInDegreesNumber, _SUAIVehicleObjectAgeInSecondsNumber, _SUCurrentTaskAgeInSecondsNumber, _SUAIVehicleSpeedOfVehicleInKMHNumber, _SUDistanceToActiveWaypointInMetersNumber] call mgmTfA_fnc_server_PublicVariableBroadcastSUInformationPhaseB;
		_broadcastSUInformationCounter = 0;
	};
	///

	// Calculate Current Task Age and Initiate Abnormal SU Termination (logged) if necessary
	_SUCurrentTaskAgeInSecondsNumber = (round ((time) - _SUCurrentTaskBirthTimeInSecondsNumber));
	if (_SUCurrentTaskAgeInSecondsNumber > _SUCurrentTaskThresholdInSecondsNumber) then {
		// Expiry Timeout Threshold Exceeded. Initiating Abnormal Termination of SU.			// We are being abnormally destroyed!
		_emergencyEscapeNeeded = true;
	};
	 // Let emergency escapees pass
	if(_emergencyEscapeNeeded) then {	breakTo "mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyondMainScope";	};
	
	// 	I'm here - is the requestor here too?
	//	get a list of all nearby players within 20 metres range, save it in an array
	//	traverse the array, check one by one the owner	     "On server machine, returns the ID of the client where the object is local. Otherwise returns 0. " we already have the requestor's clientID -- compare the values.
	//	when a match is found, direct comms message him!
	 _playersAroundMeList	 =_SUTaxiAIVehicleObject		nearEntities ["Man", 15];
	 _playersAroundMeListCount = (count _playersAroundMeList);
	if (_playersAroundMeListCount==0) then {
		//We're at the requestorLocation but there's no one here :(
		if (_thisFileVerbosityLevelNumber>=5) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyond.sqf] [TV5] _playersAroundMeList is null! I'll sleep a bit and re-check..."];};//dbg
	} else {
		//There are people here!
		if (_thisFileVerbosityLevelNumber>=5) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyond.sqf]  [TV5] BEGINNING traversing _playersAroundMeList array. I need to determine whether the requestor is one of the players in the 15 meter range. _playersAroundMeList has the following: (%1)", (str _playersAroundMeList)];};//dbg
		private["_counter22", "_curPUID"];
		_counter22 = 0;
		_curPUID = objNull;
		{
			// traverse the array - report contents to LOG
			_curPUID = (getPlayerUID _x);
			if (_thisFileVerbosityLevelNumber>=5) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyond.sqf]  [TV5] TRAVERSING _playersAroundMeList array. Current array position is: (%1)   Array element content is: (%2)   _fixedDestinationRequestorPlayerUIDTextString is: (%3)   _curPUID is: (%4) <== I'll now compare these and exit if they match!", _counter22, _x, _fixedDestinationRequestorPlayerUIDTextString, _curPUID];};//dbg
			//Requestor is here! BreakOut
			if (_curPUID == _fixedDestinationRequestorPlayerUIDTextString) exitWith {
				  _requestorPlayerObject = _x;
				  _requestorIsNotHere = false;
				if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyond.sqf]  [TV3] Found him! Found him! He's here! _fixedDestinationRequestorProfileNameTextString is: (%1)", _fixedDestinationRequestorProfileNameTextString];};//dbg
				  
				//So we are at requestorLocation and he is here too, let's unlock the doors & let him in!	//Unlock the vehicle doors
				_SUTaxiAIVehicleObject lockCargo false;
				if (_thisFileVerbosityLevelNumber>=2) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyond.sqf] [TV3] DOORS now unlocked"];};//dbg

				 //So we are at requestorLocation and he is here too, signal the requestor that his Taxi is here
				mgmTfA_gv_pvc_pos_yourFixedDestinationTaxiHasArrivedPleaseGetInPacketSignalOnly = ".";
				_fixedDestinationRequestorClientIDNumber 	publicVariableClient 		"mgmTfA_gv_pvc_pos_yourFixedDestinationTaxiHasArrivedPleaseGetInPacketSignalOnly";

				//Use the horn to greet the requestor
				driver _SUTaxiAIVehicleObject forceWeaponFire [currentWeapon _SUTaxiAIVehicleObject, currentWeapon _SUTaxiAIVehicleObject];
				if (_thisFileVerbosityLevelNumber>=2) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyond.sqf]      SIGNAL SENT to the requestor (that his Taxi is here). _fixedDestinationRequestorProfileNameTextString: (%1)   on computer (_fixedDestinationRequestorClientIDNumber): (%2)", _fixedDestinationRequestorProfileNameTextString, _fixedDestinationRequestorClientIDNumber];};//dbg
			};
			_counter22 = _counter22 + 1;
		} forEach _playersAroundMeList;
		if (isNil "_playersAroundMeList") then {
			//We couldn't find the requestor nearby
			if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyond.sqf]  [TV3] REQUESTOR is not at the requested location... I will wait some more... looping"];};//dbg
		};
	};
	uiSleep 0.05;
 };
if (_thisFileVerbosityLevelNumber>=2) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyond.sqf]  [TV2] EXITED LOOP: IsTheRequestorAtPickUpPointChecksLoop"];};//dbg
 
 // The code between previous while and the next one	split it to two;		emergency escape needed OR not?
 if (!_emergencyEscapeNeeded) then { 
	uiSleep 0.05;
	//Initial evaluation
	if (_requestorPlayerObject in _SUTaxiAIVehicleObject) then {
		_requestorOutsideVehicle = false;
	} else {
		_requestorOutsideVehicle = true;
	};
	_SUCurrentTaskThresholdInSecondsNumber = mgmTfA_configgv_expiryTimeOutThresholdfixedDestinationTaxiRequestorOutsideVehicleInSecondsNumber;
	// Reset Current Task Age
	_SUCurrentTaskAgeInSecondsNumber = 0;
	//Start the Current Task Age Timer
	_SUCurrentTaskBirthTimeInSecondsNumber = (time);
	//Requestor called us but did not get in (yet). Keep looping & waiting...
	_broadcastSUInformationCounter = 0;
	while {_requestorOutsideVehicle} do {
		scopeName "TheRequestorIsOutsideVehicleLoop";
	
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
			_SUPickUpPositionPosition3DArray = _fixedDestinationRequestorPosition3DArray;
			_SUAIVehicleObject = _SUTaxiAIVehicleObject;
			_SUAIVehicleObjectBirthTimeInSecondsNumber = _SUTaxiAIVehicleObjectBirthTimeInSecondsNumber;
			_SUDistanceToActiveWaypointInMetersNumber = (round (_SUAIVehicleObject distance _SUActiveWaypointPositionPosition3DArray));
			_null = [_myGUSUIDNumber, _SUTypeTextString, _SUActiveWaypointPositionPosition3DArray, _SUCurrentActionInProgressTextString, _SUCurrentTaskThresholdInSecondsNumber, _SUCurrentTaskBirthTimeInSecondsNumber, _SUDriversFirstnameTextString, _SUMarkerShouldBeDestroyedAfterExpiryBool, _SURequestorPlayerUIDTextString, _SURequestorProfileNameTextString, _SUAIVehicleObject, _SUAIVehicleObjectBirthTimeInSecondsNumber, _SUPickUpHasOccurredBool, _SUPickUpPositionPosition3DArray, _SUDropOffPositionHasBeenDeterminedBool, _SUDropOffHasOccurredBool, _SUDropOffPositionPosition3DArray, _SUDropOffPositionNameTextString, _SUTerminationPointPositionHasBeenDeterminedBool, _SUTerminationPointPosition3DArray, _SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray, _SUAIVehicleObjectCurrentPositionPosition3DArray, _SUAIVehicleVehicleDirectionInDegreesNumber, _SUAIVehicleObjectAgeInSecondsNumber, _SUCurrentTaskAgeInSecondsNumber, _SUAIVehicleSpeedOfVehicleInKMHNumber, _SUDistanceToActiveWaypointInMetersNumber] call mgmTfA_fnc_server_PublicVariableBroadcastSUInformationPhaseB;
			_broadcastSUInformationCounter = 0;
		};
		///
		uiSleep 0.05;
		// Pit-stop checks: AutoRefuel
		if (fuel _SUTaxiAIVehicleObject < 0.2) then {
			_SUTaxiAIVehicleObject setFuel 1;
			if (_thisFileVerbosityLevelNumber>=2) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyondMainScope.sqf]  [TV2] REFUELing SU Vehicle: (%1) | Driver: (%2) | ServerUpTime: (%3)", _myGUSUIDNumber, _SUDriversFirstnameTextString, (round (time))];};//dbg
		};
		// Pit-stop checks: AutoRepair
		if (damage _SUTaxiAIVehicleObject>0.2) then {
			_SUTaxiAIVehicleObject setDamage 0;
			if (_thisFileVerbosityLevelNumber>=2) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyondMainScope.sqf]  [TV2] REPAIRing SU Vehicle: (%1) | Driver: (%2) | ServerUpTime: (%3)", _myGUSUIDNumber, _SUDriversFirstnameTextString, (round (time))];};//dbg
		};
		// Calculate Current Task Age and Initiate Abnormal SU Termination (logged) if necessary
		_SUCurrentTaskAgeInSecondsNumber = (round ((time) - _SUCurrentTaskBirthTimeInSecondsNumber));
		if (_SUCurrentTaskAgeInSecondsNumber > _SUCurrentTaskThresholdInSecondsNumber) then {
			_emergencyEscapeNeeded = true;
		};
		// Let emergency escapees pass
		if(_emergencyEscapeNeeded) then { breakTo "mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyondMainScope";	};
		if (_requestorPlayerObject in _SUTaxiAIVehicleObject) then {
			_requestorOutsideVehicle = false;
			//He is in
			if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyondMainScope.sqf] [TV3] Requestor IS IN!		%1 is now in %2. 		Locking doors & driving!", _fixedDestinationRequestorProfileNameTextString, _SUTaxiAIVehicleObject];};//dbg
			_requestorOutsideVehicle = false;
			
			// Signal all map-trackers that Pick Up has occurred
			_SUPickUpHasOccurredBool = true;
			missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUPickupHasOccurredNumber", _myGUSUIDNumber], _SUPickUpHasOccurredBool];
			publicVariable format ["mgmTfA_gv_PV_SU%1SUPickupHasOccurredNumber", _myGUSUIDNumber];
		} else {
			_requestorOutsideVehicle = true;
			//He is not in - keep looping
			//if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyondMainScope.sqf] [TV3] WAITING for %1 to get in %2...", _requestorPlayer, _SUTaxiAIVehicleObject];};
		};
	};
	if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyondMainScope.sqf] [TV3] EXITed loop _requestorOutsideVehicle"];};//dbg
	uiSleep 0.05;
	 //TAKE PAYMENT from player's cash amount
	//Change our status to:		3 AWAITING PAYMENT			to proceed, first the requestor must pay...
	_SUCurrentActionInProgressTextString = mgmTfA_configgv_currentFixedDestinationTaxiActionInProgressIs03TextString;
 };
 
 // The code between previous while and the next one	split it to two;		emergency escape needed OR not?
 if (!_emergencyEscapeNeeded) then { 
	_SUCurrentTaskThresholdInSecondsNumber = mgmTfA_configgv_expiryTimeOutThresholdfixedDestinationTaxiRequestorHasNotPaidInSecondsNumber;
	// Reset Current Task Age
	_SUCurrentTaskAgeInSecondsNumber = 0;
	//Start the Current Task Age Timer
	_SUCurrentTaskBirthTimeInSecondsNumber = (time);
	// For now temporary pseudo "take payment" code
	_broadcastSUInformationCounter = 0;
	
	
	//Customer Communications:	"%1 PLEASE PAY %2 CRYPTO  FOR %3 METRES TO: %4. THANKS!"
	// Signal the requestor that he needs to pay now
	mgmTfA_gv_pvc_req_fixedDestinationTaxiPleasePayTheServiceFeePacketSignalOnly = ".";
	_fixedDestinationRequestorClientIDNumber publicVariableClient "mgmTfA_gv_pvc_req_fixedDestinationTaxiPleasePayTheServiceFeePacketSignalOnly";
	if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyondMainScope.sqf] [TV3] SIGNAL SENT to the requestor (that he needs to pay now). _fixedDestinationRequestorProfileNameTextString: (%1)  on computer (_fixedDestinationRequestorClientIDNumber): (%2)", _fixedDestinationRequestorProfileNameTextString, _fixedDestinationRequestorClientIDNumber];};//dbg

	// DEVDEBUG	slowdown
	// WHY 10??
	//uiSleep 10;
	uiSleep 3;

	while {_requestorHasNotPaid} do {
		scopeName "TheRequestorHasNotPaidLoop";
	
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
			_SUPickUpPositionPosition3DArray = _fixedDestinationRequestorPosition3DArray;
			_SUAIVehicleObject = _SUTaxiAIVehicleObject;
			_SUAIVehicleObjectBirthTimeInSecondsNumber = _SUTaxiAIVehicleObjectBirthTimeInSecondsNumber;
			_SUDistanceToActiveWaypointInMetersNumber = (round (_SUAIVehicleObject distance _SUActiveWaypointPositionPosition3DArray));
			_null = [_myGUSUIDNumber, _SUTypeTextString, _SUActiveWaypointPositionPosition3DArray, _SUCurrentActionInProgressTextString, _SUCurrentTaskThresholdInSecondsNumber, _SUCurrentTaskBirthTimeInSecondsNumber, _SUDriversFirstnameTextString, _SUMarkerShouldBeDestroyedAfterExpiryBool, _SURequestorPlayerUIDTextString, _SURequestorProfileNameTextString, _SUAIVehicleObject, _SUAIVehicleObjectBirthTimeInSecondsNumber, _SUPickUpHasOccurredBool, _SUPickUpPositionPosition3DArray, _SUDropOffPositionHasBeenDeterminedBool, _SUDropOffHasOccurredBool, _SUDropOffPositionPosition3DArray, _SUDropOffPositionNameTextString, _SUTerminationPointPositionHasBeenDeterminedBool, _SUTerminationPointPosition3DArray, _SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray, _SUAIVehicleObjectCurrentPositionPosition3DArray, _SUAIVehicleVehicleDirectionInDegreesNumber, _SUAIVehicleObjectAgeInSecondsNumber, _SUCurrentTaskAgeInSecondsNumber, _SUAIVehicleSpeedOfVehicleInKMHNumber, _SUDistanceToActiveWaypointInMetersNumber] call mgmTfA_fnc_server_PublicVariableBroadcastSUInformationPhaseB;
			_broadcastSUInformationCounter = 0;
		};
		///
		// Pit-stop checks: AutoRefuel
		if (fuel _SUTaxiAIVehicleObject < 0.2) then {
			_SUTaxiAIVehicleObject setFuel 1;
			if (_thisFileVerbosityLevelNumber>=2) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyondMainScope.sqf] [TV2] REFUELing SU Vehicle: (%1) | Driver: (%2) | ServerUpTime: (%3)", _myGUSUIDNumber, _SUDriversFirstnameTextString, (round (time))];};//dbg
		};
		// Pit-stop checks: AutoRepair
		if (damage _SUTaxiAIVehicleObject>0.2) then {
			_SUTaxiAIVehicleObject setDamage 0;
			if (_thisFileVerbosityLevelNumber>=2) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyondMainScope.sqf] [TV2] REPAIRing SU Vehicle: (%1) | Driver: (%2) | ServerUpTime: (%3)", _myGUSUIDNumber, _SUDriversFirstnameTextString, (round (time))];};//dbg
		};
		// Calculate Current Task Age and Initiate Abnormal SU Termination (logged) if necessary
		_SUCurrentTaskAgeInSecondsNumber = (round ((time) - _SUCurrentTaskBirthTimeInSecondsNumber));
		if (_SUCurrentTaskAgeInSecondsNumber > _SUCurrentTaskThresholdInSecondsNumber) then {
			// Expiry Timeout Threshold Exceeded. Initiating Abnormal Termination of SU.
			// We are being abnormally destroyed!
			_emergencyEscapeNeeded = true;
			//if (_thisFileVerbosityLevelNumber>=1) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyond.sqf]  [TV1]          Expiry Timeout Threshold Exceeded for SU (%1). Initiating Abnormal SU Termination! _SUCurrentTaskAgeInSecondsNumber is: (%2). _SUCurrentTaskThresholdInSecondsNumber is: (%3).", _myGUSUIDNumber, _SUCurrentTaskAgeInSecondsNumber, _SUCurrentTaskThresholdInSecondsNumber];};
		};
		// Let emergency escapees pass
		if(_emergencyEscapeNeeded) then { breakTo "mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyondMainScope";	};

		// payment check code here
		_SUFDServiceFeeNeedToBePaidBool = call compile format ["mgmTfA_gv_PV_SU%1SUFDServiceFeeNeedToBePaidBool", _myGUSUIDNumber];
		if (_SUFDServiceFeeNeedToBePaidBool) then {
			// Service Fee has not been paid yet -- log it
			if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyondMainScope.sqf] [TV3] REQUESTOR STILL HASN'T PAID!	 	will keep looping till paid or phase timeout...		"];};//dbg
		} else {
			// Service Fee has been paid 	-- log it and allow break out of loop
			if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyondMainScope.sqf] [TV3] REQUESTOR HAS PAID!	 Breaking out of loop - will begin driving to the requested FixedTaxiDestination...		"];};//dbg
			_requestorHasNotPaid = false;
		};
		uiSleep 0.05;
	};
	if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyondMainScope.sqf] [TV3] EXITed loop _requestorHasNotPaid"];};//dbg
	// We got paid!
	//Change our status to:		4 DRIVING-TO-DESTINATION		driving requestor to requested location
	_SUCurrentActionInProgressTextString  = mgmTfA_configgv_currentFixedDestinationTaxiActionInProgressIs04TextString;

	//Customer has paid and we are about to start driving to our destination. 
	//On the way and even before we start moving (while we do waypoint calculations etc.) doors should be locked.
	//Lock the vehicle doors
	_SUTaxiAIVehicleObject lockCargo true;
	if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyondMainScope.sqf] [TV3] DOORS locked"];};
	uiSleep 0.05;
	//Doors Locked
	//Inform the requestor
	mgmTfA_gv_pvc_pos_fixedDestinationTaxiDoorsHaveBeenLockedPacketSignalOnly = ".";
	_fixedDestinationRequestorClientIDNumber		publicVariableClient		"mgmTfA_gv_pvc_pos_fixedDestinationTaxiDoorsHaveBeenLockedPacketSignalOnly";
	if (_thisFileVerbosityLevelNumber>=2) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyond.sqf]      SIGNAL SENT to the requestor (that doors have been locked). _fixedDestinationRequestorProfileNameTextString: (%1) on computer (_fixedDestinationRequestorClientIDNumber): (%2)", _fixedDestinationRequestorProfileNameTextString, _fixedDestinationRequestorClientIDNumber];};//dbg
};

if (_emergencyEscapeNeeded) then {
	// emergency escape needed = requestor did NOT pay the Fixed Destination Taxi Fee within the threshold time
	//
	// EJECT ALL			force eject all passengers - we are going to termination and we're not giving any free rides!
	if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyond.sqf]		[TV3]		Fixed Destination Taxi Fee was not paid within threshold time - ejecting all passengers and terminating."];};
	// TODO: ENHANCEMENT:	SPLIT THIS TO A SEPARATE FUNCTION FILE (it will be repeated multiple times, by different FixedDestinationTaxi modules!)
	private	[
			"_SUVehicleSpeedOfVehicleInKMHNumber",
			"_vel",
			"_dir",
			"_speedStep"									
			];
	//Use the horn to signal upcoming forced eject action
	driver _SUTaxiAIVehicleObject forceWeaponFire [currentWeapon _SUTaxiAIVehicleObject, currentWeapon _SUTaxiAIVehicleObject];
	// we should be at full stop by now but double checking never hurts
	// First, let's bring the vehicle to a full stop, in 5 kmh steps, a new step every 0.25 seconds, until its speed is 0
	_SUVehicleSpeedOfVehicleInKMHNumber = (speed _SUTaxiAIVehicleObject);
	while {_SUVehicleSpeedOfVehicleInKMHNumber > 0} do {
		uiSleep 0.05;
		// Slow down by 5 kmh
		_vel = (velocity	_SUTaxiAIVehicleObject);
		_dir = (direction	_SUTaxiAIVehicleObject);
		_speedStep			= -5;
		_SUTaxiAIVehicleObject	setVelocity	[
											(_vel select 0) + (sin _dir * _speedStep),
											(_vel select 1) + (cos _dir * _speedStep),
											(_vel select 2)
											];
	_SUVehicleSpeedOfVehicleInKMHNumber = (speed _SUTaxiAIVehicleObject);
	};
	if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyond.sqf] 	[TV3]	TERMINATION SEQUENCE IN PROGRESS:	Stopped vehicle before ejecting all passengers."];};
	uiSleep 0.05;
	// prep for forced eject -- once we eject them, we will want the passengers to stay out!
	_SUTaxiAIVehicleObject lockCargo true;
	_doorsLockedBool = true;
	uiSleep 0.05;
	// Now we can Eject All Passengers (keep the driver in!) and Delete the Vehicle	//Traverse all crew with forEach
	{
		//If the crewMember is NOT our dear _SUAICharacterDriverObject, then eject them!
		if (_x != _SUAICharacterDriverObject) then {
		_x action ["Eject", _SUTaxiAIVehicleObject];
		};
	} forEach crew _SUTaxiAIVehicleObject;
	if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyond.sqf] [TV3] TERMINATION SEQUENCE IN PROGRESS:		eject all passengers completed."];};
	uiSleep 0.05;
};





























































// If emergency escape is NOT needed, proceed with the next batch of workflow tasks			which is DRIVING-TO-DESTINATION
if (!_emergencyEscapeNeeded) then {

	if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyond.sqf] [TV8] INSIDE  if (!_emergencyEscapeNeeded) then            now..."];};

	//Change our status to:		4 DRIVING-TO-DESTINATION		driving requestor to requested location
	_SUCurrentActionInProgressTextString  = mgmTfA_configgv_currentFixedDestinationTaxiActionInProgressIs04TextString;
	//Customer has paid and we are about to start driving to our destination. 
	//On the way and even before we start moving (while we do waypoint calculations etc.) doors should be locked.

	//TODO: add code ==>>  Add a button "Stop the car!"		("get out" option is always visible in offroad pickups - all we need to do is stop the car so that passengers won't get hurt!)
	// NEW DESTINATION		// Add new Waypoint data
	_SUTaxiAIVehicleWaypointMainArrayIndexNumber = _SUTaxiAIVehicleWaypointMainArrayIndexNumber + 1;
	_SUDropOffPositionPosition3DArray = _fixedDestinationRequestedTaxiFixedDestinationPosition3DArray;
	_SUTaxiAIVehicleWaypointMainArray = _SUAIGroup addWaypoint [_SUDropOffPositionPosition3DArray, _SUTaxiWaypointRadiusInMetersNumber,_SUTaxiAIVehicleWaypointMainArrayIndexNumber];
	_SUActiveWaypointPositionPosition3DArray = _SUDropOffPositionPosition3DArray;
	//When setting the waypoint, make a note: How far are we going to go?
	_iWantToTravelThisManyMetresNumber = (round (_SUTaxiAIVehicleObject distance _SUDropOffPositionPosition3DArray));
	_SUTaxiAIVehicleWaypointMainArray setWaypointType "MOVE";
	_SUTaxiAIVehicleWaypointMainArray setWaypointSpeed "FULL";
	_SUTaxiAIVehicleWaypointMainArray setWaypointTimeout [1, 1, 1];
	if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyond.sqf] [TV3]          Waypoint Added: %2 at %1", _fixedDestinationRequestedTaxiFixedDestinationPosition3DArray, _SUTaxiAIVehicleWaypointMainArray];};
	if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyond.sqf] [TV3]          Waypoint Added: _SUTaxiAIVehicleWaypointMainArray is: (%1). _SUTaxiAIVehicleWaypointMainArrayIndexNumber is: (%2)",_SUTaxiAIVehicleWaypointMainArray, _SUTaxiAIVehicleWaypointMainArrayIndexNumber];};
	//check distance to our Current Waypoint (_fixedDestinationRequestorPosition3DArray) and write to server RPT log
	_SUTaxiAIVehicleDistanceToWayPointMetersNumber = (round(_SUTaxiAIVehicleObject distance _fixedDestinationRequestedTaxiFixedDestinationPosition3DArray));
	if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyond.sqf] [TV3]          Distance to Waypoint _fixedDestinationRequestorPosition3DArray is: (%1) metres. Going there now.", _SUTaxiAIVehicleDistanceToWayPointMetersNumber];};
	// LOOP ON THE WAY TO PICKUP!
	_counterForLogOnlyEveryNthPINGNumber = 0;
	if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyondMainScope.sqf] [TV3] NEXT, will enter drivingToDropOffPoint250."];};

	_SUCurrentTaskThresholdInSecondsNumber = mgmTfA_configgv_expiryTimeOutThresholdfixedDestinationTaxiOnTheWayToDropOffInSecondsNumber;
	// Reset Current Task Age
	_SUCurrentTaskAgeInSecondsNumber = 0;
	//Start the Current Task Age Timer
	_SUCurrentTaskBirthTimeInSecondsNumber = (time);
	// We are on the way to Drop Off point
	// This while loop checks whether we are at 250 metres distance to DropOffPoint
	// When it detects that we are closer than 250 metres to distance, it quits the loop [next code bit will unlocks the doors & inform the passanger]
	_broadcastSUInformationCounter = 0;
	while {_SUTaxiAIVehicleDistanceToWayPointMetersNumber>250} do {
		scopeName "drivingToDropOffPoint250";
		// Broadcast ServiceUnit Information
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
			_SUPickUpPositionPosition3DArray = _fixedDestinationRequestorPosition3DArray;
			_SUAIVehicleObject = _SUTaxiAIVehicleObject;
			_SUAIVehicleObjectBirthTimeInSecondsNumber = _SUTaxiAIVehicleObjectBirthTimeInSecondsNumber;
			_SUDistanceToActiveWaypointInMetersNumber = (round (_SUAIVehicleObject distance _SUActiveWaypointPositionPosition3DArray));
			_null = [_myGUSUIDNumber, _SUTypeTextString, _SUActiveWaypointPositionPosition3DArray, _SUCurrentActionInProgressTextString, _SUCurrentTaskThresholdInSecondsNumber, _SUCurrentTaskBirthTimeInSecondsNumber, _SUDriversFirstnameTextString, _SUMarkerShouldBeDestroyedAfterExpiryBool, _SURequestorPlayerUIDTextString, _SURequestorProfileNameTextString, _SUAIVehicleObject, _SUAIVehicleObjectBirthTimeInSecondsNumber, _SUPickUpHasOccurredBool, _SUPickUpPositionPosition3DArray, _SUDropOffPositionHasBeenDeterminedBool, _SUDropOffHasOccurredBool, _SUDropOffPositionPosition3DArray, _SUDropOffPositionNameTextString, _SUTerminationPointPositionHasBeenDeterminedBool, _SUTerminationPointPosition3DArray, _SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray, _SUAIVehicleObjectCurrentPositionPosition3DArray, _SUAIVehicleVehicleDirectionInDegreesNumber, _SUAIVehicleObjectAgeInSecondsNumber, _SUCurrentTaskAgeInSecondsNumber, _SUAIVehicleSpeedOfVehicleInKMHNumber, _SUDistanceToActiveWaypointInMetersNumber] call mgmTfA_fnc_server_PublicVariableBroadcastSUInformationPhaseB;
			_broadcastSUInformationCounter = 0;
		};

		//First let's refresh the distance value
		//check distance to our Current Waypoint (_fixedDestinationRequestorPosition3DArray) and write to server RPT log
		_SUTaxiAIVehicleDistanceToWayPointMetersNumber = (round (_SUTaxiAIVehicleObject distance _fixedDestinationRequestedTaxiFixedDestinationPosition3DArray));
		uiSleep 0.05;
		// Calculate Current Task Age and Initiate Abnormal SU Termination (logged) if necessary
		_SUCurrentTaskAgeInSecondsNumber = (round ((time) - _SUCurrentTaskBirthTimeInSecondsNumber));
		if (_SUCurrentTaskAgeInSecondsNumber > _SUCurrentTaskThresholdInSecondsNumber) then {
			// Expiry Timeout Threshold Exceeded. Initiating Abnormal Termination of SU.
			// We are being abnormally destroyed!
			_emergencyEscapeNeeded = true;
		};

		// PING			log only every Nth package			(uiSleep=0.05)		(n=300)  => 	log every 15 seconds
		// Let emergency escapees pass
		if(_emergencyEscapeNeeded) then {	breakTo "mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyondMainScope";	};
		_counterForLogOnlyEveryNthPINGNumber = _counterForLogOnlyEveryNthPINGNumber + 1;
		if (_counterForLogOnlyEveryNthPINGNumber==300) then {
			if (_thisFileVerbosityLevelNumber>=1) then {
				_SUTaxiAIVehicleObjectAgeInSecondsNumber = (round ((time)-_SUTaxiAIVehicleObjectBirthTimeInSecondsNumber));
				diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyondMainScope.sqf] [TV2] PING from SU Vehicle: (%1) | Driver: (%2) | ServerUpTime: (%3) | MyAge: (%4) | Distance to WP: (%5) metres | Action In Progress: (%6)", _myGUSUIDNumber, _SUDriversFirstnameTextString, round time, _SUTaxiAIVehicleObjectAgeInSecondsNumber, _SUTaxiAIVehicleDistanceToWayPointMetersNumber, _SUCurrentActionInProgressTextString];
			};
			_counterForLogOnlyEveryNthPINGNumber = 0;
		};

		// Pit-stop checks: AutoRefuel
		if (fuel _SUTaxiAIVehicleObject < 0.2) then {
			_SUTaxiAIVehicleObject setFuel 1;
			if (_thisFileVerbosityLevelNumber>=2) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyondMainScope.sqf]  [TV2] REFUELing SU Vehicle: (%1) | Driver: (%2) | ServerUpTime: (%3)", _myGUSUIDNumber, _SUDriversFirstnameTextString, (round (time))];};//dbg
		};
		// Pit-stop checks: AutoRepair
		if (damage _SUTaxiAIVehicleObject>0.2) then {
			_SUTaxiAIVehicleObject setDamage 0;
			if (_thisFileVerbosityLevelNumber>=2) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyondMainScope.sqf]  [TV2] REPAIRing SU Vehicle: (%1) | Driver: (%2) | ServerUpTime: (%3)", _myGUSUIDNumber, _SUDriversFirstnameTextString, (round (time))];};//dbg
		};
	};
	if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyondMainScope.sqf] [TV3] EXITED LOOP: drivingToDropOffPoint250"];};
};

// If emergency escape needed, do nothing.
// If emergency escape is NOT needed, proceed with the next batch of workflow tasks
if (!_emergencyEscapeNeeded) then {
	// workflow tasks below this line

	//We are about to reach passenger drop off point
	//Unlock the vehicle doors
	_SUTaxiAIVehicleObject lockCargo false;
	//Save the new status of vehicleDoorLock
	 _doorsLockedBool = false;
	if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyondMainScope.sqf] [TV3] DOORS unlocked"];};
	uiSleep 0.05;
	//Doors Unlocked
	//Inform the requestor if haven't done so yet
	mgmTfA_gv_pvc_pos_fixedDestinationTaxiDoorsHaveBeenUnlockedPacketSignalOnly = ".";
	_fixedDestinationRequestorClientIDNumber publicVariableClient "mgmTfA_gv_pvc_pos_fixedDestinationTaxiDoorsHaveBeenUnlockedPacketSignalOnly";
			if (_thisFileVerbosityLevelNumber>2) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyond.sqf]      SIGNAL SENT to the requestor (that his Taxi is here). _fixedDestinationRequestorProfileNameTextString: (%1)   _fixedDestinationRequestorClientIDNumber: (%2)", _fixedDestinationRequestorProfileNameTextString, _fixedDestinationRequestorClientIDNumber];};

	// THIS IS PHASE 2 - DO NOT RESET TIME HERE! 		// Reset Current Task Age

	//We are on the way to Drop Off Position. We will loop till we are very close to the target.
	 broadcastSUInformationCounter = 0;
	while {_SUTaxiAIVehicleDistanceToWayPointMetersNumber>25} do {
		scopeName "drivingToDropOffPoint25";
		
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
			_SUPickUpPositionPosition3DArray = _fixedDestinationRequestorPosition3DArray;
			_SUAIVehicleObject = _SUTaxiAIVehicleObject;
			_SUAIVehicleObjectBirthTimeInSecondsNumber = _SUTaxiAIVehicleObjectBirthTimeInSecondsNumber;
			_SUDistanceToActiveWaypointInMetersNumber = (round (_SUAIVehicleObject distance _SUActiveWaypointPositionPosition3DArray));
			_null = [_myGUSUIDNumber, _SUTypeTextString, _SUActiveWaypointPositionPosition3DArray, _SUCurrentActionInProgressTextString, _SUCurrentTaskThresholdInSecondsNumber, _SUCurrentTaskBirthTimeInSecondsNumber, _SUDriversFirstnameTextString, _SUMarkerShouldBeDestroyedAfterExpiryBool, _SURequestorPlayerUIDTextString, _SURequestorProfileNameTextString, _SUAIVehicleObject, _SUAIVehicleObjectBirthTimeInSecondsNumber, _SUPickUpHasOccurredBool, _SUPickUpPositionPosition3DArray, _SUDropOffPositionHasBeenDeterminedBool, _SUDropOffHasOccurredBool, _SUDropOffPositionPosition3DArray, _SUDropOffPositionNameTextString, _SUTerminationPointPositionHasBeenDeterminedBool, _SUTerminationPointPosition3DArray, _SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray, _SUAIVehicleObjectCurrentPositionPosition3DArray, _SUAIVehicleVehicleDirectionInDegreesNumber, _SUAIVehicleObjectAgeInSecondsNumber, _SUCurrentTaskAgeInSecondsNumber, _SUAIVehicleSpeedOfVehicleInKMHNumber, _SUDistanceToActiveWaypointInMetersNumber] call mgmTfA_fnc_server_PublicVariableBroadcastSUInformationPhaseB;
			_broadcastSUInformationCounter = 0;
		};
		///

		//check distance to our Current Waypoint (_fixedDestinationRequestorPosition3DArray) and write to server RPT log
		_SUTaxiAIVehicleDistanceToWayPointMetersNumber = (round(_SUTaxiAIVehicleObject distance _fixedDestinationRequestedTaxiFixedDestinationPosition3DArray));

		uiSleep 0.05;
		
		// Calculate Current Task Age and Initiate Abnormal SU Termination (logged) if necessary
		_SUCurrentTaskAgeInSecondsNumber = (round ((time) - _SUCurrentTaskBirthTimeInSecondsNumber));
		if (_SUCurrentTaskAgeInSecondsNumber > _SUCurrentTaskThresholdInSecondsNumber) then {
			// Expiry Timeout Threshold Exceeded. Initiating Abnormal Termination of SU.
			// We are being abnormally destroyed!
			_emergencyEscapeNeeded = true;
			//if (_thisFileVerbosityLevelNumber>=1) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyond.sqf]  [TV1]          Expiry Timeout Threshold Exceeded for SU (%1). Initiating Abnormal SU Termination! _SUCurrentTaskAgeInSecondsNumber is: (%2). _SUCurrentTaskThresholdInSecondsNumber is: (%3).", _mgmTfA_gvdb_PV_TfAGUJIDNumber, _SUCurrentTaskAgeInSecondsNumber, _SUCurrentTaskThresholdInSecondsNumber];};
		};
	 	 // Let emergency escapees pass
		if(_emergencyEscapeNeeded) then {	breakTo "mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyondMainScope";	};

		// PING			log only every Nth package			(uiSleep=0.05)		(n=300)  => 	log every 15 seconds
		_counterForLogOnlyEveryNthPINGNumber = _counterForLogOnlyEveryNthPINGNumber + 1;
		if (_counterForLogOnlyEveryNthPINGNumber==300) then {
			_SUTaxiAIVehicleObjectAgeInSecondsNumber = (round ((time)-_SUTaxiAIVehicleObjectBirthTimeInSecondsNumber));
			if (_thisFileVerbosityLevelNumber>=1) then {
				diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyond.sqf]  [TV1]          PING from vehicle GUSUID: (%1) | Driver: (%2) | ServerUpTime: (%3) | MyAge: (%4) | Distance to WP: (%5) metres | Action In Progress: (%6) (checking 25 m.)", _myGUSUIDNumber, _SUDriversFirstnameTextString, (round (time)), _SUTaxiAIVehicleObjectAgeInSecondsNumber, _SUTaxiAIVehicleDistanceToWayPointMetersNumber, _SUCurrentActionInProgressTextString];
			};
			_counterForLogOnlyEveryNthPINGNumber = 0;
		};
		// Pit-stop checks: AutoRefuel
		if (fuel _SUTaxiAIVehicleObject < 0.2) then {
			_SUTaxiAIVehicleObject setFuel 1;
			if (_thisFileVerbosityLevelNumber>=2) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyondMainScope.sqf]  [TV2] REFUELing SU Vehicle: (%1) | Driver: (%2) | ServerUpTime: (%3)", _myGUSUIDNumber, _SUDriversFirstnameTextString, (round (time))];};//dbg
		};
		// Pit-stop checks: AutoRepair
		if (damage _SUTaxiAIVehicleObject>0.2) then {
			_SUTaxiAIVehicleObject setDamage 0;
			if (_thisFileVerbosityLevelNumber>=2) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyondMainScope.sqf]  [TV2] REPAIRing SU Vehicle: (%1) | Driver: (%2) | ServerUpTime: (%3)", _myGUSUIDNumber, _SUDriversFirstnameTextString, (round (time))];};//dbg
		};
	};
	if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyondMainScope.sqf] [TV3] EXITED LOOP: drivingToDropOffPoint25.		(str _emergencyEscapeNeeded) is: (%1).", (str _emergencyEscapeNeeded)];};//dbg
};

// If emergency escape needed, skip Phase05 completely, and jump to Phase06
// If emergency escape is NOT needed, proceed with the next batch of workflow tasks
if (!_emergencyEscapeNeeded) then { 
	// normal workflow in progress. add the workflow next phase below this line
	if (_thisFileVerbosityLevelNumber>=2) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyondMainScope.sqf]  [TV2] <<<reached end-of-file>>>.   no emergency. proceeding with normal next phase in the workflow.			SPAWN'ing (mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase05_DropOffPointAndBeyond)."];};//dbg
	_null =	[_fixedDestinationRequestorProfileNameTextString, _fixedDestinationRequestorClientIDNumber, _iWantToTravelThisManyMetresNumber, _requestorPlayerObject, _myGUSUIDNumber, _SUAICharacterDriverObject, _SUTaxiAIVehicleObject, _SUTaxiAIVehicleObjectBirthTimeInSecondsNumber, _SUDriversFirstnameTextString, _doorsLockedBool, _SUTaxiAIVehicleWaypointMainArray, _SUTaxiAIVehicleWaypointMainArrayIndexNumber, _SUTaxiWaypointRadiusInMetersNumber, _SUAIGroup, _SUAIVehicleObjectAgeInSecondsNumber, _SUAIVehicleObjectCurrentPositionPosition3DArray, _SUTaxiAIVehicleVehicleDirectionInDegreesNumber, _SUAIVehicleVehicleDirectionInDegreesNumber, _SUAIVehicleSpeedOfVehicleInKMHNumber, _SUPickUpPositionPosition3DArray, _SUAIVehicleObject, _SUAIVehicleObjectBirthTimeInSecondsNumber, _SUDistanceToActiveWaypointInMetersNumber, _SUActiveWaypointPositionPosition3DArray, _SUTypeTextString, _SUMarkerShouldBeDestroyedAfterExpiryBool, _SURequestorPlayerUIDTextString, _SURequestorProfileNameTextString, _SUPickUpHasOccurredBool, _SUDropOffPositionHasBeenDeterminedBool, _SUDropOffHasOccurredBool, _SUDropOffPositionPosition3DArray, _SUDropOffPositionNameTextString, _SUTerminationPointPositionHasBeenDeterminedBool, _SUTerminationPointPosition3DArray, _SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray] spawn mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase05_DropOffPointAndBeyond;
 } else {
	// we have an emergency and we need to shutdown ASAP. forget about the normal workflow next phase and go directly to termination phase!
	if (_thisFileVerbosityLevelNumber>=2) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyondMainScope.sqf]  [TV2] <<<reached end-of-file>>>.   there is an EMERGENCY therefore skipping Phase05 completely 	and SPAWN'ing Phase06 immediately now (mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase06_ToTerminationAndTheEnd)"];};//dbg
	_null =	[_fixedDestinationRequestorProfileNameTextString, _fixedDestinationRequestorClientIDNumber, _iWantToTravelThisManyMetresNumber, _requestorPlayerObject, _myGUSUIDNumber, _SUAICharacterDriverObject, _SUTaxiAIVehicleObject, _SUTaxiAIVehicleObjectBirthTimeInSecondsNumber, _SUDriversFirstnameTextString, _doorsLockedBool, _SUTaxiAIVehicleWaypointMainArray, _SUTaxiAIVehicleWaypointMainArrayIndexNumber, _SUTaxiWaypointRadiusInMetersNumber, _SUAIGroup, _SUAIVehicleObjectAgeInSecondsNumber, _SUAIVehicleObjectCurrentPositionPosition3DArray, _SUTaxiAIVehicleVehicleDirectionInDegreesNumber, _SUAIVehicleVehicleDirectionInDegreesNumber, _SUAIVehicleSpeedOfVehicleInKMHNumber, _SUPickUpPositionPosition3DArray, _SUAIVehicleObject, _SUAIVehicleObjectBirthTimeInSecondsNumber, _SUDistanceToActiveWaypointInMetersNumber, _SUActiveWaypointPositionPosition3DArray, _SUTypeTextString, _SUMarkerShouldBeDestroyedAfterExpiryBool, _SURequestorPlayerUIDTextString, _SURequestorProfileNameTextString, _SUPickUpHasOccurredBool, _SUDropOffPositionHasBeenDeterminedBool, _SUDropOffHasOccurredBool, _SUDropOffPositionPosition3DArray, _SUDropOffPositionNameTextString, _SUTerminationPointPositionHasBeenDeterminedBool, _SUTerminationPointPosition3DArray, _SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray] spawn mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase06_ToTerminationAndTheEnd;
};
// EOF