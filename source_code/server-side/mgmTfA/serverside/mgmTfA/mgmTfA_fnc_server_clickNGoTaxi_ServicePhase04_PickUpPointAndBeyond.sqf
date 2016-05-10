//H
//H ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf
//H $PURPOSE$	:	This function manage the SU during its approach to PickUpPoint, Awaiting Requestor, Awaiting Get In, Payment phases. It will end when SU start travelling towards DropOff Point
//H ~~
//H
//HH
//HH ~~
//HH	NEED UPDATE			Example usage	:	_null	=	[_clickNGoRequestorClientIDNumber, _clickNGoRequestorPosition3DArray, _THISDOESNOTEXISTINTHISFILE__fixedDestinationRequestedTaxiFixedDestinationIDNumber, _THISDOESNOTEXISTINTHISFILE__fixedDestinationRequestedDestinationNameTextString, _clickNGoRequestorPlayerUIDTextString, _clickNGoRequestorProfileNameTextString, _myGUSUIDNumber, _iWantToTravelThisManyMetresNumber, _SUTaxiAIVehicleObject, _SUDriversFirstnameTextString, _clickNGoTaxiRequestedDestinationPosition3DArray, _doorsLockedBool, _SUAIGroup, _SUTaxiWaypointRadiusInMetersNumber, _SUTaxiAIVehicleObjectBirthTimeInSecondsNumber, _SUTaxiAIVehicleWaypointMainArray, _SUTaxiAIVehicleWaypointMainArrayIndexNumber, _SUAICharacterDriverObject, _SUTypeTextString, _SUDropOffPositionHasBeenDeterminedBool, _SUDropOffPositionNameTextString, _SUDropOffPositionPosition3DArray, _SUDropOffHasOccurredBool, _SUTerminationPointPositionHasBeenDeterminedBool, _SUTerminationPointPosition3DArray, _SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray] spawn mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond;
//HH	NEED UPDATE			Parameters	:	too many to list
//HH	NEED UPDATE			Return Value	:	none	[this function spawns the next function in the workflow
//HH ~~
//HH	The server-side master configuration file read (and/or publicVariable publish) the following value(s) this function rely on:
//HH		mgmTfA_configgv_serverVerbosityLevel
//HH
if (!isServer) exitWith {}; if (isNil("mgmTfA_Server_Init")) then {mgmTfA_Server_Init=0;}; waitUntil {mgmTfA_Server_Init==1}; private ["_thisFileVerbosityLevelNumber"]; _thisFileVerbosityLevelNumber = mgmTfA_configgv_serverVerbosityLevel;
scopeName "mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyondMainScope";
if (mgmTfA_configgv_serverVerbosityLevel>=4) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf]  [TV4] I have been SPAWN'd. I have the following arguments in (_this)=(%1).", (str _this)];};//dbg
private	[
		"_clickNGoRequestorClientIDNumber",
		"_clickNGoRequestorPosition3DArray",
		// keep these for now (so that we won't have to renumber all function arguments) // to be cleaned up one day
		"_THISDOESNOTEXISTINTHISFILE__fixedDestinationRequestedTaxiFixedDestinationIDNumber",
		"_THISDOESNOTEXISTINTHISFILE__fixedDestinationRequestedDestinationNameTextString",
		"_clickNGoRequestorPlayerUIDTextString",
		"_clickNGoRequestorProfileNameTextString",
		"_myGUSUIDNumber",
		"_iWantToTravelThisManyMetresNumber",
		"_SUTaxiAIVehicleObject",
		"_SUDriversFirstnameTextString",
		"_clickNGoTaxiRequestedDestinationPosition3DArray",
		"_doorsLockedBool",
		"_SUAIGroup",
		"_SUTaxiWaypointRadiusInMetersNumber",
		"_SUTaxiAIVehicleObjectBirthTimeInSecondsNumber",
		"_SUTaxiAIVehicleWaypointMainArray",
		"_SUTaxiAIVehicleWaypointMainArrayIndexNumber",
		"_SUAICharacterDriverObject",
		"_SUTypeTextString",
		"_SUDropOffPositionHasBeenDeterminedBool",
		"_SUDropOffPositionNameTextString",
		"_SUDropOffPositionPosition3DArray",
		"_SUDropOffHasOccurredBool",
		"_SUTerminationPointPositionHasBeenDeterminedBool",
		"_SUTerminationPointPosition3DArray",
		"_SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray",
		"_requestorIsNotHere",
		"_emergencyEscapeNeeded",
		"_SUMarkerShouldBeDestroyedAfterExpiryBool",
		"_playersAroundMeList",
		"_playersAroundMeListCount",
		"_playersAroundMeListIsNullLoopCounter",
		"_requestorPlayerObject",
		"_requestorOutsideVehicle",
		"_SUPickUpHasOccurredBool",
		"_requestorHasNotPaid",
		"_counterForLogOnlyEveryNthPINGNumber",
		"_SUActiveWaypointPositionPosition3DArray",
		"_SURequestorPlayerUIDTextString",
		"_SURequestorProfileNameTextString",
		"_SUCurrentActionInProgressTextString",
		"_SUCurrentTaskThresholdInSecondsNumber",
		"_SUCurrentTaskAgeInSecondsNumber",
		"_SUCurrentTaskBirthTimeInSecondsNumber",
		"_broadcastSUInformationCounter",
		"_SUTaxiAIVehicleDistanceToWayPointMetersNumber",
		"_SUTaxiAIVehicleObjectAgeInSecondsNumber",
		"_SUAIVehicleObjectAgeInSecondsNumber",
		"_SUAIVehicleObjectCurrentPositionPosition3DArray",
		"_SUTaxiAIVehicleVehicleDirectionInDegreesNumber",
		"_SUAIVehicleVehicleDirectionInDegreesNumber",
		"_SUAIVehicleSpeedOfVehicleInKMHNumber",
		"_SUPickUpPositionPosition3DArray",
		"_SUAIVehicleObject",
		"_SUAIVehicleObjectBirthTimeInSecondsNumber",
		"_SUDistanceToActiveWaypointInMetersNumber",
		"_SUclickNGoTaxiTickStepTimeInSecondsNumber",
		"_SUclickNGoTaxiTickCostInCryptoNumber",
		"_SUclickNGoTaxisDisplayTickChargeHintMessageBool",
		"_SUclickNGoTaxisDisplayTickChargeSystemChatMessageBool",
		"_SUclickNGoTaxiPrepaidPaymentTransactionTimeInSecondsNumber",
		"_SUclickNGoTaxiPrepaidAbsoluteMinimumJourneyTimeInSeconds",
		"_SUPrepaidCreditsStillCoveringBool",
		"_SUPAYGisActiveBool",
		"_paygIsItTimeYetCheckCounterNumber",
		"_paygCustomerCanAffordTheNextPaymentBool",
		"_paygLastCheckCounterNumber",
		"_TA1stMileFeeNeedToBePaidBool",
		"_currentTimeInSecondsNumber"
		];
_thisFileVerbosityLevelNumber = mgmTfA_configgv_serverVerbosityLevel;
_clickNGoRequestorClientIDNumber = (_this select 0);
_clickNGoRequestorPosition3DArray = (_this select 1);
_THISDOESNOTEXISTINTHISFILE__fixedDestinationRequestedTaxiFixedDestinationIDNumber	= (_this select 2);
_THISDOESNOTEXISTINTHISFILE__fixedDestinationRequestedDestinationNameTextString	= (_this select 3);
_clickNGoRequestorPlayerUIDTextString = (_this select 4);
_clickNGoRequestorProfileNameTextString = (_this select 5);
_myGUSUIDNumber = (_this select 6);
_iWantToTravelThisManyMetresNumber = (_this select 7);
_SUTaxiAIVehicleObject = (_this select 8);
_SUDriversFirstnameTextString = (_this select 9);
_clickNGoTaxiRequestedDestinationPosition3DArray = (_this select 10);
_doorsLockedBool = (_this select 11);
_SUAIGroup = (_this select 12);
_SUTaxiWaypointRadiusInMetersNumber = (_this select 13);
_SUTaxiAIVehicleObjectBirthTimeInSecondsNumber = (_this select 14);
_SUTaxiAIVehicleWaypointMainArray = (_this select 15);
_SUTaxiAIVehicleWaypointMainArrayIndexNumber = (_this select 16);
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
//	do not initialize this as we have been passed data by the CALL'ing function:			_SUDistanceToActiveWaypointInMetersNumber = -1;
// _SUDropOffPositionPosition3DArray			<=	do not set this variable yet (it will be done later in this file)
// These below are a duplicate variables - they are created just to keep function-calling-code consistent.
	_SUActiveWaypointPositionPosition3DArray = _clickNGoRequestorPosition3DArray;
	_SURequestorPlayerUIDTextString = _clickNGoRequestorPlayerUIDTextString;
	_SURequestorProfileNameTextString = _clickNGoRequestorProfileNameTextString;
_playersAroundMeListIsNullLoopCounter = 0;

//// BEGIN
//On arrival to waypoint (pick up point) add the travelled distance to the global counter and then reset our local counter
mgmTfA_dynamicgv_clickNGoTaxisTotalDistanceTravelledByTaxisNumber = mgmTfA_dynamicgv_clickNGoTaxisTotalDistanceTravelledByTaxisNumber + _iWantToTravelThisManyMetresNumber;
	if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf] [TV3] mgmTfA_dynamicgv_clickNGoTaxisTotalDistanceTravelledByTaxisNumber is now (%1). It now reflects the distance I just travelled (%2).]", mgmTfA_dynamicgv_clickNGoTaxisTotalDistanceTravelledByTaxisNumber, _iWantToTravelThisManyMetresNumber];};
// We can now reset this SU's distance_travelled counter -- because we already added it to mgmTfA_dynamicgv_clickNGoTaxisTotalDistanceTravelledByTaxisNumber
_iWantToTravelThisManyMetresNumber = 0;

// We have arrived at PickUpPoint!					
//Change our status to:		2 AWAITING GET IN 								to proceed, first the requestor must get in...
_SUCurrentActionInProgressTextString  = mgmTfA_configgv_currentclickNGoTaxiActionInProgressIs02TextString;
// Load new threshold
_SUCurrentTaskThresholdInSecondsNumber = mgmTfA_configgv_expiryTimeOutThresholdclickNGoTaxiRequestorIsNotHereInSecondsNumber;
// Reset Current Task Age
_SUCurrentTaskAgeInSecondsNumber = 0;
//Start the Current Task Age Timer
_SUCurrentTaskBirthTimeInSecondsNumber = (time);
_SUclickNGoTaxiTickStepTimeInSecondsNumber = mgmTfA_configgv_clickNGoTaxisTickStepTimeInSecondsNumber;
_SUclickNGoTaxiTickCostInCryptoNumber = mgmTfA_configgv_clickNGoTaxisTickCostInCryptoNumber;
_SUclickNGoTaxisDisplayTickChargeHintMessageBool = mgmTfA_configgv_clickNGoTaxisDisplayTickChargeHintMessageBool;
_SUclickNGoTaxisDisplayTickChargeSystemChatMessageBool = mgmTfA_configgv_clickNGoTaxisDisplayTickChargeSystemChatMessageBool;
_SUclickNGoTaxiPrepaidPaymentTransactionTimeInSecondsNumber = -1;
_SUPrepaidCreditsStillCoveringBool = false;
_SUclickNGoTaxiPrepaidAbsoluteMinimumJourneyTimeInSeconds = mgmTfA_configgv_clickNGoTaxisPrepaidAbsoluteMinimumJourneyTimeInSeconds;
_SUPAYGisActiveBool = false;
_paygIsItTimeYetCheckCounterNumber = 0;
_paygCustomerCanAffordTheNextPaymentBool = false;
_TA1stMileFeeNeedToBePaidBool = true;
// do NOT set it yet:	_currentTimeInSecondsNumber

//We are at the requestorPosition
_broadcastSUInformationCounter = 0;

while {_requestorIsNotHere} do {
	scopeName "IsTheRequestorAtPickUpPointChecksLoop";

	_playersAroundMeListIsNullLoopCounter = _playersAroundMeListIsNullLoopCounter + 1;
	
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
		_SUPickUpPositionPosition3DArray = _clickNGoRequestorPosition3DArray;
		_SUAIVehicleObject = _SUTaxiAIVehicleObject;
		_SUAIVehicleObjectBirthTimeInSecondsNumber = _SUTaxiAIVehicleObjectBirthTimeInSecondsNumber;
		_SUDistanceToActiveWaypointInMetersNumber = (round (_SUAIVehicleObject distance _SUActiveWaypointPositionPosition3DArray));
		_null	= [_myGUSUIDNumber, _SUTypeTextString, _SUActiveWaypointPositionPosition3DArray, _SUCurrentActionInProgressTextString, _SUCurrentTaskThresholdInSecondsNumber, _SUCurrentTaskBirthTimeInSecondsNumber, _SUDriversFirstnameTextString, _SUMarkerShouldBeDestroyedAfterExpiryBool, _SURequestorPlayerUIDTextString, _SURequestorProfileNameTextString, _SUAIVehicleObject, _SUAIVehicleObjectBirthTimeInSecondsNumber, _SUPickUpHasOccurredBool, _SUPickUpPositionPosition3DArray, _SUDropOffPositionHasBeenDeterminedBool, _SUDropOffHasOccurredBool, _SUDropOffPositionPosition3DArray, _SUDropOffPositionNameTextString, _SUTerminationPointPositionHasBeenDeterminedBool, _SUTerminationPointPosition3DArray, _SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray, _SUAIVehicleObjectCurrentPositionPosition3DArray, _SUAIVehicleVehicleDirectionInDegreesNumber, _SUAIVehicleObjectAgeInSecondsNumber, _SUCurrentTaskAgeInSecondsNumber, _SUAIVehicleSpeedOfVehicleInKMHNumber, _SUDistanceToActiveWaypointInMetersNumber] call mgmTfA_fnc_server_PublicVariableBroadcastSUInformationPhaseB;
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
	if(_emergencyEscapeNeeded) then {	breakTo "mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyondMainScope";	};
	
	// 	I'm here - is the requestor here too?
	//	get a list of all nearby players within 20 metres range, save it in an array
	//	traverse the array, check one by one the owner	     "On server machine, returns the ID of the client where the object is local. Otherwise returns 0. " we already have the requestor's clientID -- compare the values.
	//	when a match is found, direct comms message him!
	 _playersAroundMeList		=_SUTaxiAIVehicleObject		nearEntities ["Man", 15];
	 _playersAroundMeListCount	= (count _playersAroundMeList);
	if (_playersAroundMeListCount==0) then {
		//We're at the requestorLocation but there's no one here :(
		// Log this only once, every 2 seconds [uiSleep 0.05 above x 40 iterations]
		if (_playersAroundMeListIsNullLoopCounter == 40) then {
			if (_thisFileVerbosityLevelNumber>=5) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf] [TV5] _playersAroundMeList is null! I'll sleep a bit and re-check...		Here is (str _playersAroundMeList): (%1)", (str _playersAroundMeList)];};//dbg
		};
	} else {
		//There are people here!
		if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf]  [TV4] BEGINNING traversing _playersAroundMeList array. I need to determine whether the requestor is one of the players in the 15 meter range. _playersAroundMeList has the following: (%1)", (str _playersAroundMeList)];};
		private["_counter22", "_curPUID"];
		_counter22 = 0;
		_curPUID = objNull;
		{
			if (_requestorIsNotHere) then {
				// we still haven't found the requestor - we will keep looking.		let's traverse the array and report contents to LOG
				// increment the counter
				_counter22 = _counter22 + 1;
				_curPUID = (getPlayerUID _x);
				if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf]  [TV3] TRAVERSING _playersAroundMeList array. Current array position is: (%1)   Array element content is: (%2)   _clickNGoRequestorPlayerUIDTextString is: (%3)   _curPUID is: (%4) <== I'll now compare these and exit if they match!", _counter22, _x, _clickNGoRequestorPlayerUIDTextString, _curPUID];};
				if (_curPUID == _clickNGoRequestorPlayerUIDTextString) then {
					//Requestor is here! BreakOut
					  _requestorPlayerObject = _x;
					  _requestorIsNotHere = false;
					if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf]  [TV3] Found him! Found him! He's here! _clickNGoRequestorProfileNameTextString is: (%1)", _clickNGoRequestorProfileNameTextString];};//dbg
					  
					//So we are at requestorLocation and he is here too, let's unlock the doors & let him in!	//Unlock the vehicle doors
					_SUTaxiAIVehicleObject lockCargo false;
					if (_thisFileVerbosityLevelNumber>=2) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf] [TV3] DOORS now unlocked"];};

					 //So we are at requestorLocation and he is here too, signal the requestor that his Taxi is here
					mgmTfA_gv_pvc_pos_yourclickNGoTaxiHasArrivedPleaseGetInPacketSignalOnly	= ".";
					_clickNGoRequestorClientIDNumber publicVariableClient "mgmTfA_gv_pvc_pos_yourclickNGoTaxiHasArrivedPleaseGetInPacketSignalOnly";

					//Use the horn to greet the requestor
					driver _SUTaxiAIVehicleObject forceWeaponFire [currentWeapon _SUTaxiAIVehicleObject, currentWeapon _SUTaxiAIVehicleObject];
					if (_thisFileVerbosityLevelNumber>=2) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf]      SIGNAL SENT to the requestor (that his Taxi is here). _clickNGoRequestorProfileNameTextString: (%1)   on computer (_clickNGoRequestorClientIDNumber): (%2)", _clickNGoRequestorProfileNameTextString, _clickNGoRequestorClientIDNumber];};
				};
			};
		} forEach _playersAroundMeList;
		if (isNil "_playersAroundMeList") then {
			//We couldn't find the requestor nearby
			if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf]  [TV3] REQUESTOR is not at the requested location... I will wait some more... looping"];};//dbg
		};
	};
	// just exited:	there are people around me

	uiSleep 0.05;
};
if (_thisFileVerbosityLevelNumber>=2) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf]  [TV2] EXITED LOOP: IsTheRequestorAtPickUpPointChecksLoop"];};//dbg
 
 // The code between previous while and the next one	split it to two;		emergency escape needed OR not?
if (!_emergencyEscapeNeeded) then {
	uiSleep 0.05;
	//Initial evaluation
	if (_requestorPlayerObject in _SUTaxiAIVehicleObject) then {
		_requestorOutsideVehicle = false;
	} else {
		_requestorOutsideVehicle = true;
	};
	_SUCurrentTaskThresholdInSecondsNumber = mgmTfA_configgv_expiryTimeOutThresholdclickNGoTaxiRequestorOutsideVehicleInSecondsNumber;
	// Reset Current Task Age
	_SUCurrentTaskAgeInSecondsNumber = 0;
	//Start the Current Task Age Timer
	_SUCurrentTaskBirthTimeInSecondsNumber = (time);
	//Requestor called us but did not get in (yet). Keep looping & waiting...
	_broadcastSUInformationCounter = 0;
	while {_requestorOutsideVehicle} do {
		scopeName "TheRequestorIsOutsideVehicleLoop";
		uiSleep 0.05;
	
		///
		// Broadcast ServiceUnit Information
		///
		// Only if it has been at least 1 second!	currently uiSleep`ing 0.05 seconds, meaning at least 1 second = 1.00 / 0.05 = 20th package.

		_broadcastSUInformationCounter = _broadcastSUInformationCounter + 1;
		if (_broadcastSUInformationCounter >= 20) then {
			_broadcastSUInformationCounter = 0;
			// Need to calculate these now as we will publish it in the next line!
			_SUCurrentTaskAgeInSecondsNumber = (round ((time) - _SUCurrentTaskBirthTimeInSecondsNumber));
			_SUTaxiAIVehicleObjectAgeInSecondsNumber = (round ((time) -_SUTaxiAIVehicleObjectBirthTimeInSecondsNumber));
			_SUAIVehicleObjectAgeInSecondsNumber = _SUTaxiAIVehicleObjectAgeInSecondsNumber;
			_SUAIVehicleObjectCurrentPositionPosition3DArray		= (getPosATL _SUTaxiAIVehicleObject);
			_SUTaxiAIVehicleVehicleDirectionInDegreesNumber = (getDir _SUTaxiAIVehicleObject) + 45;
			_SUAIVehicleVehicleDirectionInDegreesNumber = _SUTaxiAIVehicleVehicleDirectionInDegreesNumber;
			_SUAIVehicleSpeedOfVehicleInKMHNumber = (round (speed _SUTaxiAIVehicleObject));
			_SUPickUpPositionPosition3DArray = _clickNGoRequestorPosition3DArray;
			_SUAIVehicleObject = _SUTaxiAIVehicleObject;
			_SUAIVehicleObjectBirthTimeInSecondsNumber = _SUTaxiAIVehicleObjectBirthTimeInSecondsNumber;
			_SUDistanceToActiveWaypointInMetersNumber = (round (_SUAIVehicleObject distance _SUActiveWaypointPositionPosition3DArray));
			[_myGUSUIDNumber, _SUTypeTextString, _SUActiveWaypointPositionPosition3DArray, _SUCurrentActionInProgressTextString, _SUCurrentTaskThresholdInSecondsNumber, _SUCurrentTaskBirthTimeInSecondsNumber, _SUDriversFirstnameTextString, _SUMarkerShouldBeDestroyedAfterExpiryBool, _SURequestorPlayerUIDTextString, _SURequestorProfileNameTextString, _SUAIVehicleObject, _SUAIVehicleObjectBirthTimeInSecondsNumber, _SUPickUpHasOccurredBool, _SUPickUpPositionPosition3DArray, _SUDropOffPositionHasBeenDeterminedBool, _SUDropOffHasOccurredBool, _SUDropOffPositionPosition3DArray, _SUDropOffPositionNameTextString, _SUTerminationPointPositionHasBeenDeterminedBool, _SUTerminationPointPosition3DArray, _SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray, _SUAIVehicleObjectCurrentPositionPosition3DArray, _SUAIVehicleVehicleDirectionInDegreesNumber, _SUAIVehicleObjectAgeInSecondsNumber, _SUCurrentTaskAgeInSecondsNumber, _SUAIVehicleSpeedOfVehicleInKMHNumber, _SUDistanceToActiveWaypointInMetersNumber] call mgmTfA_fnc_server_PublicVariableBroadcastSUInformationPhaseB;
		};
		///
		// Pit-stop checks: AutoRefuel
		if (fuel _SUTaxiAIVehicleObject < 0.2) then {
			_SUTaxiAIVehicleObject setFuel 1;
			if (_thisFileVerbosityLevelNumber>=2) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf]  [TV2] REFUELing SU Vehicle: (%1) | Driver: (%2) | ServerUpTime: (%3)", _myGUSUIDNumber, _SUDriversFirstnameTextString, (round (time))];};//dbg
		};
		// Pit-stop checks: AutoRepair
		if (damage _SUTaxiAIVehicleObject>0.2) then {
			_SUTaxiAIVehicleObject setDamage 0;
			if (_thisFileVerbosityLevelNumber>=2) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf]  [TV2] REPAIRing SU Vehicle: (%1) | Driver: (%2) | ServerUpTime: (%3)", _myGUSUIDNumber, _SUDriversFirstnameTextString, (round (time))];};//dbg
		};
		// Calculate Current Task Age and Initiate Abnormal SU Termination (logged) if necessary
		_SUCurrentTaskAgeInSecondsNumber = (round ((time) - _SUCurrentTaskBirthTimeInSecondsNumber));
		if (_SUCurrentTaskAgeInSecondsNumber > _SUCurrentTaskThresholdInSecondsNumber) then {
			_emergencyEscapeNeeded = true;
		};
		// Let emergency escapees pass
		if(_emergencyEscapeNeeded) then {	breakTo "mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyondMainScope";	};
		if (_requestorPlayerObject in _SUTaxiAIVehicleObject) then {
			//He is in
			if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf] [TV3] Requestor IS IN!		%1 is now in %2. 		Locking doors & driving!", _clickNGoRequestorProfileNameTextString, _SUTaxiAIVehicleObject];};
			
			// Signal all map-trackers that Pick Up has occurred
			_SUPickUpHasOccurredBool = true;
			missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUPickupHasOccurredNumber", _myGUSUIDNumber], _SUPickUpHasOccurredBool];
			publicVariable format ["mgmTfA_gv_PV_SU%1SUPickupHasOccurredNumber", _myGUSUIDNumber];

			// END THE LOOP
			// IMPORTANT: DO NOT MOVE THIS LINE ANY HIGHER OR IT WILL ABRUPTLY STOP EXECUTION!
			_requestorOutsideVehicle = false;
		} else {
			//He is not in - keep looping
			if (_thisFileVerbosityLevelNumber>=7) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf] [TV7] WAITING for %1 to get in %2...", _requestorPlayerObject, _SUTaxiAIVehicleObject];};
		};
	};
	if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf] [TV3] EXITed loop _requestorOutsideVehicle"];};
	uiSleep 0.05;
};

// Requestor is in vehicle

// Is 1st Mile Fee enabled? (NOTE: Phase03 already did the check & marked the vehicle but we can still read the globalVar probably faster)
if (mgmTfA_configgv_clickNGoTaxisAbsoluteMinimumJourneyFeeInCryptoNumber > 0) then {
	// YES 1st Mile Fee is enabled -- log the 1st Mile Fee setting
	if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf] [TV3] 		DETECTED		1st Mile Fee is ENABLED			(mgmTfA_configgv_clickNGoTaxisAbsoluteMinimumJourneyFeeInCryptoNumber > 0)"];};
	// We will inform the requestor now:		"You must now pay the 1st-Mile-Fee"
	mgmTfA_gv_pvc_req_TAPleasePay1stMileFeePacketSignalOnly = ".";
	_clickNGoRequestorClientIDNumber publicVariableClient "mgmTfA_gv_pvc_req_TAPleasePay1stMileFeePacketSignalOnly";
			if (_thisFileVerbosityLevelNumber>2) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf]  [TV2] 	  SIGNAL SENT to the requestor	(mgmTfA_gv_pvc_req_TAPleasePay1stMileFeePacketSignalOnly)	 (that he MUST pay 1st-Mile-Fee now).	_clickNGoRequestorProfileNameTextString: (%1)   _clickNGoRequestorClientIDNumber: (%2)	", _clickNGoRequestorProfileNameTextString, _clickNGoRequestorClientIDNumber];};
	// Next, we will have to wait for the requestor to pay the 1st Mile Fee (via GUI button OR via ActionMenu) - this is handled in a loop below
	// NOTE: "_TA1stMileFeeNeedToBePaidBool" is already set to TRUE at the top of file.
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
} else {
	// NO 1st Mile Fee is not enabled -- log the 1st Mile Fee setting
	if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf] [TV3] DETECTED		1st Mile Fee IS NOT ENABLED			!(mgmTfA_configgv_clickNGoTaxisAbsoluteMinimumJourneyFeeInCryptoNumber > 0)"];};
	// nothing else to do here. allow loop escape & carry on
	_TA1stMileFeeNeedToBePaidBool = false;
};



/*
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUTA1stMileFeeNeedToBePaidBool", _myGUSUIDNumber], true];
publicVariable format ["mgmTfA_gv_PV_SU%1SUTA1stMileFeeNeedToBePaidBool", _myGUSUIDNumber];
_myGUSUIDNumber = ((vehicle player) getVariable ["GUSUIDNumber", -1]);
if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA]  [mgmTfA_fnc_client_clickNGoContinuouslyRequestPayment.sqf] [TV4] _myGUSUIDNumber has been obtained as: (%1)", (str _myGUSUIDNumber)];};
*/



// CHARGE the player (take moeny from 's wallet	-- 1st Mile Fee/Initial Fee ==> take this much => mgmTfA_configgv_clickNGoTaxisAbsoluteMinimumJourneyFeeInCryptoNumber







////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// old code below commented out
	/*
	// TAKE PAYMENT from player's wallet	-- 1st Mile Fee/Initial Fee ==> take this much => mgmTfA_configgv_clickNGoTaxisAbsoluteMinimumJourneyFeeInCryptoNumber
	_null = [_requestorPlayerObject, mgmTfA_configgv_clickNGoTaxisAbsoluteMinimumJourneyFeeInCryptoNegativeNumber] call EPOCH_server_effectCrypto;

	// log the fee charge
	diag_log format ["[mgmTfA] [mgmTfA_scr_server_initRegisterServerEventHandlers.sqf]		CHARGED PLAYER		just called EPOCH_server_effectCrypto and processed player's wallet by (mgmTfA_configgv_clickNGoTaxisAbsoluteMinimumJourneyFeeInCryptoNegativeNumber)=(%1)", (str mgmTfA_configgv_clickNGoTaxisAbsoluteMinimumJourneyFeeInCryptoNegativeNumber)];//dbg

	// inform the customer THANK YOU FOR PAYING THE 1ST MILE FEE		-- Client Communications - Send the message to the Requestor
	///// RENAMED: mgmTfA_gv_pvc_pos_youJustPaidclickNGo1stMileFeePacketSignalOnly = ".";
	//COMMENTED OUT NOW mgmTfA_gv_pvc_pos_TAYouJustPaid1stMileFeePacketSignalOnly = ".";
	//COMMENTED OUT NOW _clickNGoRequestorClientIDNumber publicVariableClient "mgmTfA_gv_pvc_pos_TAYouJustPaid1stMileFeePacketSignalOnly";
	*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////








//Lock the vehicle doors
_SUTaxiAIVehicleObject lockCargo true;
if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf] [TV3] DOORS locked"];};
uiSleep 0.05;
//Doors Locked -- Inform the requestor (noHint version!)
mgmTfA_gv_pvc_pos_clickNGoTaxiDoorsHaveBeenLockedNoHintPacketSignalOnly = ".";
_clickNGoRequestorClientIDNumber publicVariableClient "mgmTfA_gv_pvc_pos_clickNGoTaxiDoorsHaveBeenLockedNoHintPacketSignalOnly";
if (_thisFileVerbosityLevelNumber>=2) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf]      SIGNAL SENT to the requestor (that doors have been locked). _clickNGoRequestorProfileNameTextString: (%1) on computer (_clickNGoRequestorClientIDNumber): (%2)", _clickNGoRequestorProfileNameTextString, _clickNGoRequestorClientIDNumber];};




// to wait or not to wait...
if (_TA1stMileFeeNeedToBePaidBool) then {
	// We will now wait for the requestor to pay the 1st Mile Fee (via GUI button OR via ActionMenu)
	if (_thisFileVerbosityLevelNumber>=5) then {diag_log format ["[mgmTfA]  [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf] [TV5] This is _myGUSUIDNumber: (%1)	Entered 		if (_TA1stMileFeeNeedToBePaidBool) then			", (str _myGUSUIDNumber)];};

	// Change our status to:		3 AWAITING PAYMENT			to proceed, first the requestor must pay...
	_SUCurrentActionInProgressTextString  = mgmTfA_configgv_currentclickNGoTaxiActionInProgressIs03TextString;
	_SUCurrentTaskThresholdInSecondsNumber = mgmTfA_configgv_expiryTimeOutThresholdclickNGoTaxiRequestorHasNotPaidInSecondsNumber;
	// Reset Current Task Age
	_SUCurrentTaskAgeInSecondsNumber = 0;
	// Start the Current Task Age Timer
	_SUCurrentTaskBirthTimeInSecondsNumber = (time);
	// 1st Mile Fee is enabled but the requestor has not paid it yet. Keep looping & waiting...
	_broadcastSUInformationCounter = 0;

	while {_TA1stMileFeeNeedToBePaidBool} do {
		// WAIT FOR PLAYER TO PAY - keep looping till either(player accept the charge) or (phase timeout & SU auto self destruction)
		// if player pays, we will break out at next iteration
		// if player does not pay, we will time out and break out via emergency routine
		scopeName "TheRequestorHasNotPaidThe1stMileFeeLoop";
		uiSleep 0.05;

		// inside loop evaluation -- can we escape the loop yet?
		_TA1stMileFeeNeedToBePaidBool = call compile format ["mgmTfA_gv_PV_SU%1SUTA1stMileFeeNeedToBePaidBool", _myGUSUIDNumber];
		if (_thisFileVerbosityLevelNumber>=5) then {diag_log format ["[mgmTfA]  [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf] [TV4] This is _myGUSUIDNumber: (%1)		INSIDE LOOP EVALUATION 		(_TA1stMileFeeNeedToBePaidBool) is: (%2)			", (str _myGUSUIDNumber), (str _TA1stMileFeeNeedToBePaidBool)];};

		///
		// Broadcast ServiceUnit Information
		///
		// Only if it has been at least 1 second!	currently uiSleep`ing 0.05 seconds, meaning at least 1 second = 1.00 / 0.05 = 20th package.
		_broadcastSUInformationCounter = _broadcastSUInformationCounter + 1;
		if (_broadcastSUInformationCounter >= 20) then {
			_broadcastSUInformationCounter = 0;
			// Need to calculate these now as we will publish it in the next line!
			_SUCurrentTaskAgeInSecondsNumber = (round ((time) - _SUCurrentTaskBirthTimeInSecondsNumber));
			_SUTaxiAIVehicleObjectAgeInSecondsNumber = (round ((time) -_SUTaxiAIVehicleObjectBirthTimeInSecondsNumber));
			_SUAIVehicleObjectAgeInSecondsNumber = _SUTaxiAIVehicleObjectAgeInSecondsNumber;
			_SUAIVehicleObjectCurrentPositionPosition3DArray		= (getPosATL _SUTaxiAIVehicleObject);
			_SUTaxiAIVehicleVehicleDirectionInDegreesNumber = (getDir _SUTaxiAIVehicleObject) + 45;
			_SUAIVehicleVehicleDirectionInDegreesNumber = _SUTaxiAIVehicleVehicleDirectionInDegreesNumber;
			_SUAIVehicleSpeedOfVehicleInKMHNumber = (round (speed _SUTaxiAIVehicleObject));
			_SUPickUpPositionPosition3DArray = _clickNGoRequestorPosition3DArray;
			_SUAIVehicleObject = _SUTaxiAIVehicleObject;
			_SUAIVehicleObjectBirthTimeInSecondsNumber = _SUTaxiAIVehicleObjectBirthTimeInSecondsNumber;
			_SUDistanceToActiveWaypointInMetersNumber = (round (_SUAIVehicleObject distance _SUActiveWaypointPositionPosition3DArray));
			[_myGUSUIDNumber, _SUTypeTextString, _SUActiveWaypointPositionPosition3DArray, _SUCurrentActionInProgressTextString, _SUCurrentTaskThresholdInSecondsNumber, _SUCurrentTaskBirthTimeInSecondsNumber, _SUDriversFirstnameTextString, _SUMarkerShouldBeDestroyedAfterExpiryBool, _SURequestorPlayerUIDTextString, _SURequestorProfileNameTextString, _SUAIVehicleObject, _SUAIVehicleObjectBirthTimeInSecondsNumber, _SUPickUpHasOccurredBool, _SUPickUpPositionPosition3DArray, _SUDropOffPositionHasBeenDeterminedBool, _SUDropOffHasOccurredBool, _SUDropOffPositionPosition3DArray, _SUDropOffPositionNameTextString, _SUTerminationPointPositionHasBeenDeterminedBool, _SUTerminationPointPosition3DArray, _SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray, _SUAIVehicleObjectCurrentPositionPosition3DArray, _SUAIVehicleVehicleDirectionInDegreesNumber, _SUAIVehicleObjectAgeInSecondsNumber, _SUCurrentTaskAgeInSecondsNumber, _SUAIVehicleSpeedOfVehicleInKMHNumber, _SUDistanceToActiveWaypointInMetersNumber] call mgmTfA_fnc_server_PublicVariableBroadcastSUInformationPhaseB;
		};
		///
		// Pit-stop checks: AutoRefuel
		if (fuel _SUTaxiAIVehicleObject < 0.2) then {
			_SUTaxiAIVehicleObject setFuel 1;
			if (_thisFileVerbosityLevelNumber>=2) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf]  [TV2] REFUELing SU Vehicle: (%1) | Driver: (%2) | ServerUpTime: (%3)", _myGUSUIDNumber, _SUDriversFirstnameTextString, (round (time))];};//dbg
		};
		// Pit-stop checks: AutoRepair
		if (damage _SUTaxiAIVehicleObject>0.2) then {
			_SUTaxiAIVehicleObject setDamage 0;
			if (_thisFileVerbosityLevelNumber>=2) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf]  [TV2] REPAIRing SU Vehicle: (%1) | Driver: (%2) | ServerUpTime: (%3)", _myGUSUIDNumber, _SUDriversFirstnameTextString, (round (time))];};//dbg
		};
		// Calculate Current Task Age and Initiate Abnormal SU Termination (logged) if necessary
		_SUCurrentTaskAgeInSecondsNumber = (round ((time) - _SUCurrentTaskBirthTimeInSecondsNumber));
		if (_SUCurrentTaskAgeInSecondsNumber > _SUCurrentTaskThresholdInSecondsNumber) then {
			// Expiry Timeout Threshold Exceeded. Initiating Abnormal Termination of SU.
			// We are being abnormally destroyed!
			_emergencyEscapeNeeded = true;
		};
		// Let emergency escapees pass
		//if(_emergencyEscapeNeeded) then {	breakTo "mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyondMainScope"; };
		if(_emergencyEscapeNeeded) then { breakOut "TheRequestorHasNotPaidThe1stMileFeeLoop"; };
	};
	if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf] [TV3] EXITed loop _TA1stMileFeeNeedToBePaidBool"];};
	// why did we exit the loop?
	// Option #1:	because commandingCustomer paid the 1st mile fee
	// Option #2:	because commandingCustomer did not pay the 1st mile fee	and phase timed out and emergencyEspaced!
	// in either case we have got to stop asking the commandingCustomer for 1st Mile Fee payment (every second via systemChat)
	//
	// mark the vehicle accordingly on all MP clients
	missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUTA1stMileFeeNeedToBePaidBool", _myGUSUIDNumber], false];
	publicVariable format ["mgmTfA_gv_PV_SU%1SUTA1stMileFeeNeedToBePaidBool", _myGUSUIDNumber];	
	uiSleep 0.05;
};
if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf] [TV8] OUTSIDE  if (_TA1stMileFeeNeedToBePaidBool) then { now..."];};

if (_emergencyEscapeNeeded) then {
	// emergency escape needed = requestor did NOT pay the 1st Mile Fee within the threshold time
	//
	// EJECT ALL			force eject all passengers - we are going to termination and we're not giving any free rides!
	if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf]		[TV3]		1st Mile Fee was not paid within threshold time - ejecting all passengers and terminating."];};
	// TODO: ENHANCEMENT:	SPLIT THIS TO A SEPARATE FUNCTION FILE (it will be repeated multiple times, by different clickNGo modules!)
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
	if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf] 	[TV3]	TERMINATION SEQUENCE IN PROGRESS:	Stopped vehicle before ejecting all passengers."];};
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
	if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf] [TV3] TERMINATION SEQUENCE IN PROGRESS:		eject all passengers completed."];};
	uiSleep 0.05;
};

// If emergency escape is NOT needed, proceed with the next batch of workflow tasks
if (!_emergencyEscapeNeeded) then {

	if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf] [TV8] INSIDE  if (!_emergencyEscapeNeeded) then            now..."];};

	//Change our status to:		4 DRIVING-TO-DESTINATION		driving requestor to requested location
	_SUCurrentActionInProgressTextString  = mgmTfA_configgv_currentclickNGoTaxiActionInProgressIs04TextString;
	//Customer has paid and we are about to start driving to our destination. 
	//On the way and even before we start moving (while we do waypoint calculations etc.) doors should be locked.

	// if execution hit this point, it must be because 1st Mile Fee has been paid. Let's start the '1st Mile Fee covered time period' now:
	_currentTimeInSecondsNumber = (time);
	_SUclickNGoTaxiPrepaidPaymentTransactionTimeInSecondsNumber = _currentTimeInSecondsNumber;

	// initial check to eliminate any extremely low values (e.g.: 2 second PrepaidAbsoluteMinimum setting in config file)
	if (_currentTimeInSecondsNumber - (_SUclickNGoTaxiPrepaidPaymentTransactionTimeInSecondsNumber+_SUclickNGoTaxiPrepaidAbsoluteMinimumJourneyTimeInSeconds)>=0) then {
		_SUPrepaidCreditsStillCoveringBool = true;
	};

	// NEW DESTINATION		// Add new Waypoint data
	//TODO: add code ==>>  Add a button "Stop the car!"		("get out" option is always visible in offroad pickups - all we need to do is stop the car so that passengers won't get hurt!)
	_SUTaxiAIVehicleWaypointMainArrayIndexNumber = _SUTaxiAIVehicleWaypointMainArrayIndexNumber + 1;
	_SUDropOffPositionPosition3DArray = _clickNGoTaxiRequestedDestinationPosition3DArray;
	_SUTaxiAIVehicleWaypointMainArray = _SUAIGroup addWaypoint [_SUDropOffPositionPosition3DArray, _SUTaxiWaypointRadiusInMetersNumber,_SUTaxiAIVehicleWaypointMainArrayIndexNumber];
	_SUActiveWaypointPositionPosition3DArray = _SUDropOffPositionPosition3DArray;
	//When setting the waypoint, make a note: How far are we going to go?
	_iWantToTravelThisManyMetresNumber = (round (_SUTaxiAIVehicleObject distance _SUDropOffPositionPosition3DArray));
	_SUTaxiAIVehicleWaypointMainArray setWaypointType "MOVE";
	_SUTaxiAIVehicleWaypointMainArray setWaypointSpeed "FULL";
	_SUTaxiAIVehicleWaypointMainArray setWaypointTimeout [1, 1, 1];
	if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf] [TV3]          Waypoint Added: %2 at %1", _clickNGoTaxiRequestedDestinationPosition3DArray, _SUTaxiAIVehicleWaypointMainArray];};
	if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf] [TV3]          Waypoint Added: _SUTaxiAIVehicleWaypointMainArray is: (%1). _SUTaxiAIVehicleWaypointMainArrayIndexNumber is: (%2)",_SUTaxiAIVehicleWaypointMainArray, _SUTaxiAIVehicleWaypointMainArrayIndexNumber];};
	//check distance to our Current Waypoint (_clickNGoRequestorPosition3DArray) and write to server RPT log
	_SUTaxiAIVehicleDistanceToWayPointMetersNumber = (round(_SUTaxiAIVehicleObject distance _clickNGoTaxiRequestedDestinationPosition3DArray));
	if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf] [TV3]          Distance to Waypoint _clickNGoTaxiRequestedDestinationPosition3DArray is: (%1) metres. Going there now.", _SUTaxiAIVehicleDistanceToWayPointMetersNumber];};
	// LOOP ON THE WAY TO PICKUP!
	_counterForLogOnlyEveryNthPINGNumber = 0;
	if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf] [TV3] NEXT, will enter drivingToDropOffPoint250."];};
	_SUCurrentTaskThresholdInSecondsNumber = mgmTfA_configgv_expiryTimeOutThresholdclickNGoTaxiOnTheWayToDropOffInSecondsNumber;
	// Reset Current Task Age
	_SUCurrentTaskAgeInSecondsNumber = 0;
	//Start the Current Task Age Timer
	_SUCurrentTaskBirthTimeInSecondsNumber = (time);
	// We are on the way to Drop Off point
	// This while loop checks whether we are at 250 metres distance to DropOffPoint
	// When it detects that we are closer than 250 metres to distance, it quits the loop [next code bit will unlocks the doors & inform the passanger]
	// Expiry Timeout Threshold: mgmTfA_configgv_expiryTimeOutThresholdclickNGoTaxiOnTheWayToDropOffInSecondsNumber
	_broadcastSUInformationCounter = 0;
	_paygLastCheckCounterNumber = 0;
	while {_SUTaxiAIVehicleDistanceToWayPointMetersNumber>250} do {
		scopeName "drivingToDropOffPoint250";
		uiSleep 0.05;
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
			_SUPickUpPositionPosition3DArray = _clickNGoRequestorPosition3DArray;
			_SUAIVehicleObject = _SUTaxiAIVehicleObject;
			_SUAIVehicleObjectBirthTimeInSecondsNumber = _SUTaxiAIVehicleObjectBirthTimeInSecondsNumber;
			_SUDistanceToActiveWaypointInMetersNumber = (round (_SUAIVehicleObject distance _SUActiveWaypointPositionPosition3DArray));
			_null = [_myGUSUIDNumber, _SUTypeTextString, _SUActiveWaypointPositionPosition3DArray, _SUCurrentActionInProgressTextString, _SUCurrentTaskThresholdInSecondsNumber, _SUCurrentTaskBirthTimeInSecondsNumber, _SUDriversFirstnameTextString, _SUMarkerShouldBeDestroyedAfterExpiryBool, _SURequestorPlayerUIDTextString, _SURequestorProfileNameTextString, _SUAIVehicleObject, _SUAIVehicleObjectBirthTimeInSecondsNumber, _SUPickUpHasOccurredBool, _SUPickUpPositionPosition3DArray, _SUDropOffPositionHasBeenDeterminedBool, _SUDropOffHasOccurredBool, _SUDropOffPositionPosition3DArray, _SUDropOffPositionNameTextString, _SUTerminationPointPositionHasBeenDeterminedBool, _SUTerminationPointPosition3DArray, _SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray, _SUAIVehicleObjectCurrentPositionPosition3DArray, _SUAIVehicleVehicleDirectionInDegreesNumber, _SUAIVehicleObjectAgeInSecondsNumber, _SUCurrentTaskAgeInSecondsNumber, _SUAIVehicleSpeedOfVehicleInKMHNumber, _SUDistanceToActiveWaypointInMetersNumber] call mgmTfA_fnc_server_PublicVariableBroadcastSUInformationPhaseB;
			_broadcastSUInformationCounter = 0;
		};
		///
		//First let's refresh the distance value
		//check distance to our Current Waypoint (_clickNGoRequestorPosition3DArray) and write to server RPT log
		_SUTaxiAIVehicleDistanceToWayPointMetersNumber = (round (_SUTaxiAIVehicleObject distance _clickNGoTaxiRequestedDestinationPosition3DArray));
		// Calculate Current Task Age and Initiate Abnormal SU Termination (logged) if necessary
		_SUCurrentTaskAgeInSecondsNumber = (round ((time) - _SUCurrentTaskBirthTimeInSecondsNumber));
		if (_SUCurrentTaskAgeInSecondsNumber > _SUCurrentTaskThresholdInSecondsNumber) then {
			// Expiry Timeout Threshold Exceeded. Initiating Abnormal Termination of SU.
			// We are being abnormally destroyed!
			_emergencyEscapeNeeded = true;
		};
		// PING			log only every Nth package			(uiSleep=0.05)		(n=300) 	=> 	log every 15 seconds
		// Let emergency escapees pass
		if (_emergencyEscapeNeeded) then {	breakTo "mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyondMainScope";	};
		_counterForLogOnlyEveryNthPINGNumber = _counterForLogOnlyEveryNthPINGNumber + 1;
		if (_counterForLogOnlyEveryNthPINGNumber==300) then {
			if (_thisFileVerbosityLevelNumber>=1) then {
				_SUTaxiAIVehicleObjectAgeInSecondsNumber	= (round ((time)-_SUTaxiAIVehicleObjectBirthTimeInSecondsNumber));
				diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf] [TV2] PING from SU Vehicle: (%1) | Driver: (%2) | ServerUpTime: (%3) | MyAge: (%4) | Distance to WP: (%5) metres | Action In Progress: (%6)", _myGUSUIDNumber, _SUDriversFirstnameTextString, round time, _SUTaxiAIVehicleObjectAgeInSecondsNumber, _SUTaxiAIVehicleDistanceToWayPointMetersNumber, _SUCurrentActionInProgressTextString];
			};
			_counterForLogOnlyEveryNthPINGNumber = 0;
		};
		// Pit-stop checks: AutoRefuel
		if (fuel _SUTaxiAIVehicleObject < 0.2) then {
			_SUTaxiAIVehicleObject setFuel 1;
			if (_thisFileVerbosityLevelNumber>=2) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf]  [TV2] REFUELing SU Vehicle: (%1) | Driver: (%2) | ServerUpTime: (%3)", _myGUSUIDNumber, _SUDriversFirstnameTextString, (round (time))];};//dbg
		};
		// Pit-stop checks: AutoRepair
		if (damage _SUTaxiAIVehicleObject>0.2) then {
			_SUTaxiAIVehicleObject setDamage 0;
			if (_thisFileVerbosityLevelNumber>=2) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf]  [TV2] REPAIRing SU Vehicle: (%1) | Driver: (%2) | ServerUpTime: (%3)", _myGUSUIDNumber, _SUDriversFirstnameTextString, (round (time))];};//dbg
		};
///
// BEGIN:	TaxiAnywhere Pay as you Go Payment System
///
		// increment the counter
		_paygLastCheckCounterNumber = _paygLastCheckCounterNumber + 1;
		// proceed with rest of PAYG code only if it's been 1 second since last PAYG check
		if (_paygLastCheckCounterNumber == 20) then {
			// reset the counter
			_paygLastCheckCounterNumber = 0;

							//	---
							//	CHEAT SHEET
							//	missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUcNGoTxPAYGIsCurrentlyActiveBool", _myGUSUIDNumber], false];
							//	publicVariable format ["mgmTfA_gv_PV_SU%1SUcNGoTxPAYGIsCurrentlyActiveBool", _myGUSUIDNumber];
							//	---
			// INSIDE LOOP CHECK
			// is PAYG active?				if it is not active, that means (a)1st Mile Fee has not been paid yet		OR		(b) TaxiAnywhere-prePaid-Initial-Journey-time is still active
			_SUPAYGisActiveBool = call compile format ["mgmTfA_gv_PV_SU%1SUcNGoTxPAYGIsCurrentlyActiveBool", _myGUSUIDNumber];
			if (_thisFileVerbosityLevelNumber>=5) then {diag_log format ["[mgmTfA]  [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf] [TV4] This is _myGUSUIDNumber: (%1)		INSIDE LOOP EVALUATION 		(_TA1stMileFeeNeedToBePaidBool) is: (%2)			", (str _myGUSUIDNumber), (str _TA1stMileFeeNeedToBePaidBool)];};

			if (_SUPAYGisActiveBool) then {
				// PAYG is active
				if (_thisFileVerbosityLevelNumber>=7) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf]  [TV7]	PAYG payment model is active on this vehicle"];};//dbg
				// TfA client-side handles the (purchasing power checks) and (PAYG charging).	if it determines that player is unable to pay the next tick, it sets the following variable to true.		let's check & action accordingly.
				if (_SUTaxiAIVehicleObject getVariable ["customerCannotAffordService", false]) then {
					// requestor and his friends in vehicle CANNOT AFFORD the service -- we will not serve them any more!
					// WE ARE SHUTTING DOWN!!!
					if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf] [TV3] bankrupt customer detected. ejecting all passengers and terminating."];};
					// TODO: ENHANCEMENT:	SPLIT THIS TO A SEPARATE FUNCTION FILE (it will be repeated multiple times, by different clickNGo modules!)
					/// begin: shutdown code\\\
					private	[
							"_SUVehicleSpeedOfVehicleInKMHNumber",
							"_vel",
							"_dir",
							"_speedStep"									
							];
					//Use the horn to signal upcoming forced eject action
					driver _SUTaxiAIVehicleObject forceWeaponFire [currentWeapon _SUTaxiAIVehicleObject, currentWeapon _SUTaxiAIVehicleObject];
					// First, let's bring the vehicle to a full stop, in 5 kmh steps, a new step every 0.25 seconds, until its speed is 0
					_SUVehicleSpeedOfVehicleInKMHNumber = (speed _SUTaxiAIVehicleObject);
					while {_SUVehicleSpeedOfVehicleInKMHNumber > 0} do {
						uiSleep 0.05;
						// Slow down by 5 kmh
						_vel = (velocity	_SUTaxiAIVehicleObject);
						_dir = (direction	_SUTaxiAIVehicleObject);
						_speedStep = -5;
						_SUTaxiAIVehicleObject	setVelocity	[
															(_vel select 0) + (sin _dir * _speedStep),
															(_vel select 1) + (cos _dir * _speedStep),
															(_vel select 2)
															];
					_SUVehicleSpeedOfVehicleInKMHNumber = (speed _SUTaxiAIVehicleObject);
					};
					if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf] [TV3] TERMINATION SEQUENCE IN PROGRESS: Slowing down, bringing the vehicle to a full-stop before ejecting all passengers."];};
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
					if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf] [TV3] TERMINATION SEQUENCE IN PROGRESS: Eject all passengers completed."];};
					uiSleep 0.05;
					/// end: shutdown code \\\
					_emergencyEscapeNeeded = true;
					/// TODO here:	enhancement:	add publicVariableClient code here ==> inform all OTHER passengers why are they being ejected (the customer is already informed via local code -- do not inform him a 2nd time!)
					breakTo "mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyondMainScope";
				} else {
					// requestor and his friends in vehicle CAN AFFORD the service.
					// 
					// New PAYG Tick Payment System:
					// 		we send a mgmTfA_gv_pvc_req_pleaseBeginPurchasingPowerCheckAndPAYGChargeForTimeTicksSignalOnly
					// 		it spawns mgmTfA_fnc_client_purchasingPowerCheckAndPAYGChargeForTimeTicks
					//		which does the checks and if player is eligible to pay then, signals the server-side to incur the charge with mgmTfA_gv_pvs_req_clickNGoTaxiChargeMePAYGTickCostPleaseConfirmPacket
				};
			} else {
				// PAYG is not active yet - process here => is time to activate PAYG payment model?
				if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf]  [TV4] _SUPAYGisActiveBool is not true.		PAYG payment model is not yet active, I will check:		Is it time to activate PAYG model?"];};//dbg
				private ["_currentTimeInSecondsNumber"];
				_currentTimeInSecondsNumber = (time);
				if (_currentTimeInSecondsNumber - (_SUclickNGoTaxiPrepaidPaymentTransactionTimeInSecondsNumber+_SUclickNGoTaxiPrepaidAbsoluteMinimumJourneyTimeInSeconds)>=0) then {
					// Yes it is time to activate PAYG now!
					if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf]  [TV4] Yes it is time to activate PAYG now!"];};//dbg
					missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUcNGoTxPAYGIsCurrentlyActiveBool", _myGUSUIDNumber], true];
					publicVariable format ["mgmTfA_gv_PV_SU%1SUcNGoTxPAYGIsCurrentlyActiveBool", _myGUSUIDNumber];
					// TODO:	CURRENTLY SENDING TO A SINGLE PLAYER ONLY. 		CHANGE THIS IN THE FUTURE, SEND TO ALL PASSENGERS IN VEHICLE!		// add publicVariableClient code here ==> let all passengers in clickNGo taxi now that from now on he will be charged according to PAYG payment model. display costs in hint box as reminder.		// note that only commandingCustomer will be charged but the mgmTfA_fnc_client_purchasingPowerCheckAndPAYGChargeForTimeTicks function will actively run on oll passengers computers [this is because in the future we will allow switch commandingCustomer on the fly]
					mgmTfA_gv_pvc_req_pleaseBeginPurchasingPowerCheckAndPAYGChargeForTimeTicksSignalOnly = ".";
					_clickNGoRequestorClientIDNumber publicVariableClient "mgmTfA_gv_pvc_req_pleaseBeginPurchasingPowerCheckAndPAYGChargeForTimeTicksSignalOnly";
					if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf]  [TV4] <ThisIs:%1> SENT SIGNAL    (mgmTfA_gv_pvc_req_pleaseBeginPurchasingPowerCheckAndPAYGChargeForTimeTicksSignalOnly) to Requestor:  (%2),		on computer (_clickNGoRequestorClientIDNumber)=(%3).", _myGUSUIDNumber, _clickNGoRequestorProfileNameTextString, _clickNGoRequestorClientIDNumber];};//dbg
				} else {
					// No not just yet. We should not activate PAYG payment model yet as prepaid fee still covers the current time!
					if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf]  [TV4]	No not just yet. We should not activate PAYG payment model yet as prepaid fee still covers the current time!"];};//dbg
				};
			};
		};
				///
				// END:	clickNGo Payment System
				///
	};
	if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf] [TV3] EXITED LOOP: drivingToDropOffPoint250"];};
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
	if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf] [TV3] DOORS unlocked"];};
	uiSleep 0.05;
	//Doors Unlocked
	//Inform the requestor if haven't done so yet
	mgmTfA_gv_pvc_pos_clickNGoTaxiDoorsHaveBeenUnlockedPacketSignalOnly = ".";
	_clickNGoRequestorClientIDNumber publicVariableClient "mgmTfA_gv_pvc_pos_clickNGoTaxiDoorsHaveBeenUnlockedPacketSignalOnly";
			if (_thisFileVerbosityLevelNumber>2) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf]      SIGNAL SENT to the requestor (that his Taxi is here). _clickNGoRequestorProfileNameTextString: (%1)   _clickNGoRequestorClientIDNumber: (%2)", _clickNGoRequestorProfileNameTextString, _clickNGoRequestorClientIDNumber];};

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
			_SUPickUpPositionPosition3DArray = _clickNGoRequestorPosition3DArray;
			_SUAIVehicleObject = _SUTaxiAIVehicleObject;
			_SUAIVehicleObjectBirthTimeInSecondsNumber = _SUTaxiAIVehicleObjectBirthTimeInSecondsNumber;
			_SUDistanceToActiveWaypointInMetersNumber = (round (_SUAIVehicleObject distance _SUActiveWaypointPositionPosition3DArray));
			_null	= [_myGUSUIDNumber, _SUTypeTextString, _SUActiveWaypointPositionPosition3DArray, _SUCurrentActionInProgressTextString, _SUCurrentTaskThresholdInSecondsNumber, _SUCurrentTaskBirthTimeInSecondsNumber, _SUDriversFirstnameTextString, _SUMarkerShouldBeDestroyedAfterExpiryBool, _SURequestorPlayerUIDTextString, _SURequestorProfileNameTextString, _SUAIVehicleObject, _SUAIVehicleObjectBirthTimeInSecondsNumber, _SUPickUpHasOccurredBool, _SUPickUpPositionPosition3DArray, _SUDropOffPositionHasBeenDeterminedBool, _SUDropOffHasOccurredBool, _SUDropOffPositionPosition3DArray, _SUDropOffPositionNameTextString, _SUTerminationPointPositionHasBeenDeterminedBool, _SUTerminationPointPosition3DArray, _SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray, _SUAIVehicleObjectCurrentPositionPosition3DArray, _SUAIVehicleVehicleDirectionInDegreesNumber, _SUAIVehicleObjectAgeInSecondsNumber, _SUCurrentTaskAgeInSecondsNumber, _SUAIVehicleSpeedOfVehicleInKMHNumber, _SUDistanceToActiveWaypointInMetersNumber] call mgmTfA_fnc_server_PublicVariableBroadcastSUInformationPhaseB;
			_broadcastSUInformationCounter = 0;
		};
		///

		//check distance to our Current Waypoint (_clickNGoRequestorPosition3DArray) and write to server RPT log
		_SUTaxiAIVehicleDistanceToWayPointMetersNumber	= (round(_SUTaxiAIVehicleObject distance _clickNGoTaxiRequestedDestinationPosition3DArray));

		uiSleep 0.05;
		
		// Calculate Current Task Age and Initiate Abnormal SU Termination (logged) if necessary
		_SUCurrentTaskAgeInSecondsNumber = (round ((time) - _SUCurrentTaskBirthTimeInSecondsNumber));
		if (_SUCurrentTaskAgeInSecondsNumber > _SUCurrentTaskThresholdInSecondsNumber) then {
			// Expiry Timeout Threshold Exceeded. Initiating Abnormal Termination of SU.
			// We are being abnormally destroyed!
			_emergencyEscapeNeeded = true;
		};
		 // Let emergency escapees pass
		if(_emergencyEscapeNeeded) then {	breakTo "mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyondMainScope";	};

		// PING			log only every Nth package			(uiSleep=0.05)		(n=300) 	=> 	log every 15 seconds
		_counterForLogOnlyEveryNthPINGNumber = _counterForLogOnlyEveryNthPINGNumber + 1;
		if (_counterForLogOnlyEveryNthPINGNumber==300) then {
			_SUTaxiAIVehicleObjectAgeInSecondsNumber	= (round ((time)-_SUTaxiAIVehicleObjectBirthTimeInSecondsNumber));
			if (_thisFileVerbosityLevelNumber>=1) then {
				diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf]  [TV1]          PING from vehicle GUSUID: (%1) | Driver: (%2) | ServerUpTime: (%3) | MyAge: (%4) | Distance to WP: (%5) metres | Action In Progress: (%6) (checking 25 m.)", _myGUSUIDNumber, _SUDriversFirstnameTextString, (round (time)), _SUTaxiAIVehicleObjectAgeInSecondsNumber, _SUTaxiAIVehicleDistanceToWayPointMetersNumber, _SUCurrentActionInProgressTextString];
			};
			_counterForLogOnlyEveryNthPINGNumber = 0;
		};
		// Pit-stop checks: AutoRefuel
		if (fuel _SUTaxiAIVehicleObject < 0.2) then {
			_SUTaxiAIVehicleObject setFuel 1;
			if (_thisFileVerbosityLevelNumber>=2) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf]  [TV2] REFUELing SU Vehicle: (%1) | Driver: (%2) | ServerUpTime: (%3)", _myGUSUIDNumber, _SUDriversFirstnameTextString, (round (time))];};//dbg
		};
		// Pit-stop checks: AutoRepair
		if (damage _SUTaxiAIVehicleObject>0.2) then {
			_SUTaxiAIVehicleObject setDamage 0;
			if (_thisFileVerbosityLevelNumber>=2) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf]  [TV2] REPAIRing SU Vehicle: (%1) | Driver: (%2) | ServerUpTime: (%3)", _myGUSUIDNumber, _SUDriversFirstnameTextString, (round (time))];};//dbg
		};
	};
};
if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf] [TV3] EXITED LOOP: drivingToDropOffPoint25.		(str _emergencyEscapeNeeded) is: (%1).", (str _emergencyEscapeNeeded)];};//dbg

// If emergency escape needed, skip Phase05 completely, and jump to Phase06
// If emergency escape is NOT needed, proceed with the next batch of workflow tasks
if (!_emergencyEscapeNeeded) then { 
	// normal workflow in progress. add the workflow next phase below this line
	if (_thisFileVerbosityLevelNumber>=2) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf]  [TV2] <<<reached end-of-file>>>.   no emergency. proceeding with normal next phase in the workflow.			SPAWN'ing (mgmTfA_fnc_server_clickNGoTaxi_ServicePhase05_DropOffPointAndBeyond)."];};//dbg
	_null = [_clickNGoRequestorProfileNameTextString, _clickNGoRequestorClientIDNumber, _iWantToTravelThisManyMetresNumber, _requestorPlayerObject, _myGUSUIDNumber, _SUAICharacterDriverObject, _SUTaxiAIVehicleObject, _SUTaxiAIVehicleObjectBirthTimeInSecondsNumber, _SUDriversFirstnameTextString, _doorsLockedBool, _SUTaxiAIVehicleWaypointMainArray, _SUTaxiAIVehicleWaypointMainArrayIndexNumber, _SUTaxiWaypointRadiusInMetersNumber, _SUAIGroup, _SUAIVehicleObjectAgeInSecondsNumber, _SUAIVehicleObjectCurrentPositionPosition3DArray, _SUTaxiAIVehicleVehicleDirectionInDegreesNumber, _SUAIVehicleVehicleDirectionInDegreesNumber, _SUAIVehicleSpeedOfVehicleInKMHNumber, _SUPickUpPositionPosition3DArray, _SUAIVehicleObject, _SUAIVehicleObjectBirthTimeInSecondsNumber, _SUDistanceToActiveWaypointInMetersNumber, _SUActiveWaypointPositionPosition3DArray, _SUTypeTextString, _SUMarkerShouldBeDestroyedAfterExpiryBool, _SURequestorPlayerUIDTextString, _SURequestorProfileNameTextString, _SUPickUpHasOccurredBool, _SUDropOffPositionHasBeenDeterminedBool, _SUDropOffHasOccurredBool, _SUDropOffPositionPosition3DArray, _SUDropOffPositionNameTextString, _SUTerminationPointPositionHasBeenDeterminedBool, _SUTerminationPointPosition3DArray, _SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray, _emergencyEscapeNeeded] spawn mgmTfA_fnc_server_clickNGoTaxi_ServicePhase05_DropOffPointAndBeyond;
 } else {
	// we have an emergency and we need to shutdown ASAP. forget about the normal workflow next phase and go directly to termination phase!
	if (_thisFileVerbosityLevelNumber>=2) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf]  [TV2] <<<reached end-of-file>>>.   there is an EMERGENCY therefore skipping Phase05 completely 	and SPAWN'ing Phase06 immediately now (mgmTfA_fnc_server_clickNGoTaxi_ServicePhase06_ToTerminationAndTheEnd)"];};//dbg
	// Deactivate PAYG on this vehicle
	missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUcNGoTxPAYGIsCurrentlyActiveBool", _myGUSUIDNumber], false];
	publicVariable format ["mgmTfA_gv_PV_SU%1SUcNGoTxPAYGIsCurrentlyActiveBool", _myGUSUIDNumber];
	_null = [_clickNGoRequestorProfileNameTextString, _clickNGoRequestorClientIDNumber, _iWantToTravelThisManyMetresNumber, _requestorPlayerObject, _myGUSUIDNumber, _SUAICharacterDriverObject, _SUTaxiAIVehicleObject, _SUTaxiAIVehicleObjectBirthTimeInSecondsNumber, _SUDriversFirstnameTextString, _doorsLockedBool, _SUTaxiAIVehicleWaypointMainArray, _SUTaxiAIVehicleWaypointMainArrayIndexNumber, _SUTaxiWaypointRadiusInMetersNumber, _SUAIGroup, _SUAIVehicleObjectAgeInSecondsNumber, _SUAIVehicleObjectCurrentPositionPosition3DArray, _SUTaxiAIVehicleVehicleDirectionInDegreesNumber, _SUAIVehicleVehicleDirectionInDegreesNumber, _SUAIVehicleSpeedOfVehicleInKMHNumber, _SUPickUpPositionPosition3DArray, _SUAIVehicleObject, _SUAIVehicleObjectBirthTimeInSecondsNumber, _SUDistanceToActiveWaypointInMetersNumber, _SUActiveWaypointPositionPosition3DArray, _SUTypeTextString, _SUMarkerShouldBeDestroyedAfterExpiryBool, _SURequestorPlayerUIDTextString, _SURequestorProfileNameTextString, _SUPickUpHasOccurredBool, _SUDropOffPositionHasBeenDeterminedBool, _SUDropOffHasOccurredBool, _SUDropOffPositionPosition3DArray, _SUDropOffPositionNameTextString, _SUTerminationPointPositionHasBeenDeterminedBool, _SUTerminationPointPosition3DArray, _SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray, _emergencyEscapeNeeded] spawn mgmTfA_fnc_server_clickNGoTaxi_ServicePhase06_ToTerminationAndTheEnd;
 };
// EOF