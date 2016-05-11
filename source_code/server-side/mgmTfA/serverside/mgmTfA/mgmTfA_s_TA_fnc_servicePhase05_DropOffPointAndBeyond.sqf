//H
//H ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_s_TA_fnc_servicePhase05_DropOffPointAndBeyond.sqf
//H $PURPOSE$	:	This function manage the SU during its approach to DropOffPoint, Awaiting Requestor to Get Off, ... phases. It will end when SU is about to begin travelling towards Termination Point.
//H ~~
//H
//HH
//HH ~~
//HH	Example usage	:	_null	=	[_clickNGoRequestorProfileNameTextString, _clickNGoRequestorClientIDNumber, _iWantToTravelThisManyMetresNumber, _requestorPlayerObject, _myGUSUIDNumber, _SUAICharacterDriverObject, _SUTaxiAIVehicleObject, _SUTaxiAIVehicleObjectBirthTimeInSecondsNumber, _SUDriversFirstnameTextString, _doorsLockedBool, _SUTaxiAIVehicleWaypointMainArray, _SUTaxiAIVehicleWaypointMainArrayIndexNumber, _SUTaxiWaypointRadiusInMetersNumber, _SUAIGroup, _SUAIVehicleObjectAgeInSecondsNumber, _SUAIVehicleObjectCurrentPositionPosition3DArray, _SUTaxiAIVehicleVehicleDirectionInDegreesNumber, _SUAIVehicleVehicleDirectionInDegreesNumber, _SUAIVehicleSpeedOfVehicleInKMHNumber, _SUPickUpPositionPosition3DArray, _SUAIVehicleObject, _SUAIVehicleObjectBirthTimeInSecondsNumber, _SUDistanceToActiveWaypointInMetersNumber, _SUActiveWaypointPositionPosition3DArray, _SUTypeTextString, _SUMarkerShouldBeDestroyedAfterExpiryBool, _SURequestorPlayerUIDTextString, _SURequestorProfileNameTextString, _SUPickUpHasOccurredBool, _SUDropOffPositionHasBeenDeterminedBool, _SUDropOffHasOccurredBool, _SUDropOffPositionPosition3DArray, _SUDropOffPositionNameTextString, _SUTerminationPointPositionHasBeenDeterminedBool, _SUTerminationPointPosition3DArray, _SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray] spawn mgmTfA_s_TA_fnc_servicePhase05_DropOffPointAndBeyond;
//HH	Parameters	:	too many to list
//HH	Return Value	:	none	[this function spawns the next function in the workflow
//HH ~~
//HH	The server-side master configuration file read (and/or publicVariable publish) the following value(s) this function rely on:
//HH		mgmTfA_configgv_serverVerbosityLevel
//HH
if (!isServer) exitWith {}; if (isNil("mgmTfA_Server_Init")) then {mgmTfA_Server_Init=0;}; waitUntil {mgmTfA_Server_Init==1}; private ["_thisFileVerbosityLevelNumber"]; _thisFileVerbosityLevelNumber = mgmTfA_configgv_serverVerbosityLevel;
scopeName "mgmTfA_s_TA_fnc_servicePhase05_DropOffPointAndBeyondMainScope";
if (mgmTfA_configgv_serverVerbosityLevel>=4) then {diag_log format ["[mgmTfA] [mgmTfA_s_TA_fnc_servicePhase05_DropOffPointAndBeyond.sqf]  [TV4] I have been SPAWN'd. I have the following arguments in (_this)=(%1).", (str _this)];};//dbg

private	[
		"_thisFileVerbosityLevelNumber",
		"_clickNGoRequestorProfileNameTextString",
		"_clickNGoRequestorClientIDNumber",
		"_iWantToTravelThisManyMetresNumber",
		"_requestorPlayerObject",
		"_myGUSUIDNumber",
		"_SUAICharacterDriverObject",
		"_SUTaxiAIVehicleObject",
		"_SUTaxiAIVehicleObjectBirthTimeInSecondsNumber",
		"_SUDriversFirstnameTextString",
		"_doorsLockedBool",
		"_SUTaxiAIVehicleWaypointMainArray",
		"_SUTaxiAIVehicleWaypointMainArrayIndexNumber",
		"_SUTaxiWaypointRadiusInMetersNumber",
		"_SUAIGroup",
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
		"_SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray",
		"_SUCurrentActionInProgressTextString",
		"_requestorInsideVehicle",
		"_SUCurrentTaskThresholdInSecondsNumber",
		"_SUCurrentTaskAgeInSecondsNumber",
		"_SUCurrentTaskBirthTimeInSecondsNumber",
		"_emergencyEscapeNeeded",
		"_counterForLogOnlyEveryNthPINGNumber",
		"_SUTaxiAIVehicleObjectAgeInSecondsNumber",
		"_SUTaxiAIVehicleDistanceToWayPointMetersNumber",
		"_broadcastSUInformationCounter"									
		];
//// Prep Function Arguments	&	Assign Initial Values for Local Variables
_thisFileVerbosityLevelNumber = mgmTfA_configgv_serverVerbosityLevel;
_clickNGoRequestorProfileNameTextString = (_this select 0);
_clickNGoRequestorClientIDNumber = (_this select 1);
_iWantToTravelThisManyMetresNumber = (_this select 2);
_requestorPlayerObject = (_this select 3);
_myGUSUIDNumber = (_this select 4);
_SUAICharacterDriverObject = (_this select 5);
_SUTaxiAIVehicleObject = (_this select 6);
_SUTaxiAIVehicleObjectBirthTimeInSecondsNumber = (_this select 7);
_SUDriversFirstnameTextString = (_this select 8);
_doorsLockedBool = (_this select 9);
_SUTaxiAIVehicleWaypointMainArray = (_this select 10);
_SUTaxiAIVehicleWaypointMainArrayIndexNumber = (_this select 11);
_SUTaxiWaypointRadiusInMetersNumber = (_this select 12);
_SUAIGroup = (_this select 13);
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
_emergencyEscapeNeeded = (_this select 36);
///
// We do not need the following variables in this function however we will need to pass them to the next Phase (Termination) thus we need to parse them
///
// _SUTaxiAIVehicleDistanceToWayPointMetersNumber							<=	do not set this variable yet (it will be done while waiting for Requestor to get off the vehicle)
// _requestorInsideVehicle													<=	do not set this variable yet (it will be done later in this file)
// _SUCurrentTaskThresholdInSecondsNumber									<=	do not set this variable yet (it will be done later in this file)
// _SUCurrentTaskAgeInSecondsNumber											<=	do not set this variable yet (it will be done later in this file)
// _SUCurrentTaskBirthTimeInSecondsNumber									<=	do not set this variable yet (it will be done later in this file)
// _SUCurrentActionInProgressTextString										<=	do not set this variable yet (it will be done later in this file)
// _SUTaxiAIVehicleObjectAgeInSecondsNumber									<=	do not set this variable yet (it will be done in the first PING block)
// All we know so far is that the requestor is still in the vehicle...
// no need to do this! we have already received this as function argument. it is already set to false.	_SUDropOffHasOccurredBool = false;
_counterForLogOnlyEveryNthPINGNumber = 0;
//_broadcastSUInformationCounter											<=	do not set this variable yet (it will be done in the first PING block)

//// BEGIN
// We've arrived Drop Off Point!
// Change our status to:		5 AWAITING GET OFF			requestor must get off the vehicle so that we can go self destruct in peace
_SUCurrentActionInProgressTextString  = mgmTfA_configgv_currentclickNGoTaxiActionInProgressIs05TextString;

// Send a message to the Requestor's computer -- note that, the target computer will display this ONLY IF the Requestor is still in the original vehicle.	To do this, we will need to send the _myGUSUIDNumber so that client computer can compare it with its local player's current vehicle GUSUID and display the message only if they match (i.e.: if Requestor is still in the original vehicle).
//However do NOT message if we are still moving - that's how accidents happen!
waitUntil {speed _SUTaxiAIVehicleObject == 0};
// create the global variable that will be sent to the requestor's PC	// send the _myGUSUIDNumber here!
mgmTfA_gv_pvc_pos_yourclickNGoTaxiHaveArrivedThankYouForYourBusinessHaveANiceDayPacket = _myGUSUIDNumber;
_clickNGoRequestorClientIDNumber publicVariableClient "mgmTfA_gv_pvc_pos_yourclickNGoTaxiHaveArrivedThankYouForYourBusinessHaveANiceDayPacket";
if (_thisFileVerbosityLevelNumber>2) then {diag_log format ["[mgmTfA] [mgmTfA_s_TA_fnc_servicePhase05_DropOffPointAndBeyond.sqf]      SIGNAL SENT to the Requestor (We have arrived. Thank you for your business. Have a nice day.). _clickNGoRequestorProfileNameTextString: (%1)  on computer (_clickNGoRequestorClientIDNumber)=(%2). The _myGUSUIDNumber is: (%3).", _clickNGoRequestorProfileNameTextString, _clickNGoRequestorClientIDNumber, _myGUSUIDNumber];};

// Deactivate PAYG on this vehicle
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUcNGoTxPAYGIsCurrentlyActiveBool", _myGUSUIDNumber], false];
publicVariable format ["mgmTfA_gv_PV_SU%1SUcNGoTxPAYGIsCurrentlyActiveBool", _myGUSUIDNumber];

//On arrival to waypoint (drop off point) add the travelled distance to the global counter and then reset our local counter
mgmTfA_dynamicgv_clickNGoTaxisTotalDistanceTravelledByTaxisNumber = mgmTfA_dynamicgv_clickNGoTaxisTotalDistanceTravelledByTaxisNumber + _iWantToTravelThisManyMetresNumber;
if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_s_TA_fnc_servicePhase05_DropOffPointAndBeyond.sqf] [TV3] mgmTfA_dynamicgv_clickNGoTaxisTotalDistanceTravelledByTaxisNumber is now (%1). It now reflects the distance I just travelled (%2).]", mgmTfA_dynamicgv_clickNGoTaxisTotalDistanceTravelledByTaxisNumber, _iWantToTravelThisManyMetresNumber];};//dbg
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

_SUCurrentTaskThresholdInSecondsNumber = mgmTfA_configgv_expiryTimeOutThresholdclickNGoTaxiRequestorInsideVehicleInSecondsNumber;
// Reset Current Task Age
_SUCurrentTaskAgeInSecondsNumber = 0;
//Start the Current Task Age Timer
_SUCurrentTaskBirthTimeInSecondsNumber = (time);

_counterForLogOnlyEveryNthPINGNumber = 0;

// Set distance to Current Waypoint to zero as we are at the DropOff Point and awaiting Requestor to get off the vehicle...
_SUTaxiAIVehicleDistanceToWayPointMetersNumber = 0;

///
// CODE TO AUTO EJECT ALL PASSENGERS AT DROP OFF POINT!
///
					// WE ARE AT DROP OFF POIND, AUTO-EJECTING AND SHUTTING DOWN!!!
					if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_s_TA_fnc_servicePhase05_DropOffPointAndBeyond.sqf] [TV3] bankrupt customer detected. ejecting all passengers and terminating."];};
					// TODO: ENHANCEMENT:	SPLIT THIS TO A SEPARATE FUNCTION FILE (it will be repeated multiple times, by different clickNGo modules!)
					/// begin: shutdown code \\\
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
						_speedStep			= -5;
						_SUTaxiAIVehicleObject	setVelocity	[
															(_vel select 0) + (sin _dir * _speedStep),
															(_vel select 1) + (cos _dir * _speedStep),
															(_vel select 2)
															];
					_SUVehicleSpeedOfVehicleInKMHNumber = (speed _SUTaxiAIVehicleObject);
					};
					if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_s_TA_fnc_servicePhase05_DropOffPointAndBeyond.sqf] [TV3] TERMINATION SEQUENCE IN PROGRESS: Reached drop off point.	Slowing down, bringing the vehicle to a full-stop before ejecting all passengers."];};
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
					if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_s_TA_fnc_servicePhase05_DropOffPointAndBeyond.sqf] [TV3] TERMINATION SEQUENCE at drop off point reached && eject all passengers completed."];};
					uiSleep 0.05;
					/// end: shutdown code \\\
					_emergencyEscapeNeeded				= true;
					// Signal map-trackers that Drop Off has occurred
					_SUDropOffHasOccurredBool = true;
					missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUDropOffHasOccurredBool", _myGUSUIDNumber], _SUDropOffHasOccurredBool];
					publicVariable format ["mgmTfA_gv_PV_SU%1SUDropOffHasOccurredBool", _myGUSUIDNumber];

//Customer has gotten out and we are about to start driving to our destination. 
//On the way and even before we start moving (while we do waypoint calculations etc.) doors should be locked.
//Lock the vehicle doors
_SUTaxiAIVehicleObject lockCargo true;
// Not that we need ...
_doorsLockedBool	= true;
if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_s_TA_fnc_servicePhase05_DropOffPointAndBeyond.sqf] [TV3] DOORS locked"];};
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
_null	=	[_clickNGoRequestorProfileNameTextString, _clickNGoRequestorClientIDNumber, _iWantToTravelThisManyMetresNumber, _requestorPlayerObject, _myGUSUIDNumber, _SUAICharacterDriverObject, _SUTaxiAIVehicleObject, _SUTaxiAIVehicleObjectBirthTimeInSecondsNumber, _SUDriversFirstnameTextString, _doorsLockedBool, _SUTaxiAIVehicleWaypointMainArray, _SUTaxiAIVehicleWaypointMainArrayIndexNumber, _SUTaxiWaypointRadiusInMetersNumber, _SUAIGroup, _SUAIVehicleObjectAgeInSecondsNumber, _SUAIVehicleObjectCurrentPositionPosition3DArray, _SUTaxiAIVehicleVehicleDirectionInDegreesNumber, _SUAIVehicleVehicleDirectionInDegreesNumber, _SUAIVehicleSpeedOfVehicleInKMHNumber, _SUPickUpPositionPosition3DArray, _SUAIVehicleObject, _SUAIVehicleObjectBirthTimeInSecondsNumber, _SUDistanceToActiveWaypointInMetersNumber, _SUActiveWaypointPositionPosition3DArray, _SUTypeTextString, _SUMarkerShouldBeDestroyedAfterExpiryBool, _SURequestorPlayerUIDTextString, _SURequestorProfileNameTextString, _SUPickUpHasOccurredBool, _SUDropOffPositionHasBeenDeterminedBool, _SUDropOffHasOccurredBool, _SUDropOffPositionPosition3DArray, _SUDropOffPositionNameTextString, _SUTerminationPointPositionHasBeenDeterminedBool, _SUTerminationPointPosition3DArray, _SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray, _emergencyEscapeNeeded] spawn mgmTfA_s_TA_fnc_servicePhase06_ToTerminationAndTheEnd;
// EOF