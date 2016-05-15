//H
//H ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_s_CO_fnc_checkAndActionAnyStopVehicleRequestWeMightHaveReceived.sqf
//H $PURPOSE$	:	1. 'StopVehicle (&allow me to exit)' button on the GUI is processed by the client side.
//H					2. When a request is deemed eligible then it is sent to the server with a PVS packet:	mgmTfA_gv_pvs_req_taxiAnywhereTaxiPleaseAllowExitNoResponsePacket
//H					3. Server EH will then set to true:	missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUStopVehicleRequestedAndAuthorized", _myGUSUIDNumber], true];
//H					---
//H					4. This function is relevant, and therefore called by the PhaseN functions, from inside the following loops during the workflow:
//H						while {_TA1stMileFeeNeedToBePaidBool}
//H						while {_SUTaxiAIVehicleDistanceToWayPointMetersNumber>250}
//H						while {_SUTaxiAIVehicleDistanceToWayPointMetersNumber>25}
//H
//H
//H					Our job is to action the request. 
//H					We will hold the execution of calling script while we wait for the player(s) to get out/get back in. We will do the actions listed below.
//H
//H
//H						+n. call compile and obtain the variable status:	is there a waiting authorized stopVehicle request?
//H							+n. NO,	there is no pending authorized stopVeh requests at this time
//H								+n. return to callingFunction (_stopVehReqHandlerFncReturnValueBool = true).
//H							+n. YES,	there is a pending authorized stopVeh request
//H								+n. stop the vehicle - we will wait for 10 seconds to allow the requestor to get out.
//H								+n. send the packet to requestor (TODO: all passengers): 'pleaseBeginSysChatInformingAllPassengersStopVehRequested'. Client-side code => stop the sysChat messages (if counter hits 10 seconds) OR (if pleaseStopSysChatInformingAllPassengersStopVehRequested packet received)
//H											[DRIVER] Stop Vehicle requested - waiting for passengers get out [10]
//H											[DRIVER] Stop Vehicle requested - waiting for passengers get out [9] ... and so on
//H											+n. Set the vehicle phase status correctly
//H											+n. Keep checking for potential phase timeouts
//H											+n. Keep broadcasting service unit information from inside the loop
//H											+n. Keep looping & waiting n seconds
//H							 		n. NO, requestor did not get out. He has changed his mind! We will carry on with the normal taxi service phase. return to callingFunction (_stopVehReqHandlerFncReturnValueBool = true). (callingFunction will then carry an as per normal)
//H									n. YES, requestor got out. Now we will wait 90 seconds for him to get back in		(TODO: proceed according to the multi-passenger situation: are there any other passengers in vehicle?)
//H											n. Send the packet to requestor (TODO: all passengers): 'pleaseBeginSysChatInformingAllPassengersTaxiIsWaitingGetIn'. 
//H												NOTE: Client-side code => stop the sysChat messages (if counter hits 90 seconds) OR (if pleaseStopSysChatInformingAllPassengersStopVehRequested packet received)
//H											n. Set the vehicle phase status correctly
//H											n. Keep checking for potential phase timeouts
//H											n. Keep broadcasting service unit information from inside the loop
//H											n. Keep looping & waiting n seconds
//H											n. (TODO: YES there are other passengers left in vehicle - countDown another 5 seconds to allow any other friendly-to-requestor-passengers to get out as well, then carry on with NO code below)
//H											n. NO no other passengers left in vehicle - start the 'waitingForGetIn' countdown - wait 90 seconds, keep the doors unlocked, keep syschat-informing the commander every second
//H													[DRIVER] Waiting for commander to get back in [90]...
//H													[DRIVER] Waiting for commander to get back in [89]...
//H									n. NO, requestor did not get back in:
//H										n. Inform the commandingPlayer:		Your Taxi is now returning to base, thanks for choosing TaxiCorp.\n Have a nice day!
//H												[CLIENT-SIDE CODE HERE] to process the message above
//H										n. Signal the calling function by returning FALSE		(callingFunction will then directly skip to termination phase)
//H									n. YES, requestor got back in.
//H										n. return "true" to callingFunction (_stopVehReqHandlerFncReturnValueBool = true).		(callingFunction will then carry an as per normal)
//H										n. (TODO: wait another 4 seconds to allow any other friendly-to-requestor-passengers to get in as well.)
//H										n. (TODO: wait another 4 seconds to allow any other friendly-to-requestor-passengers to get in as well.)
//H										n. (TODO: inform the player we are leaving in 5 seconds)
//H					
//H					TODO:	Sections of the design above is NOT IMPLEMENTED yet and marked with in-line TODOs. Instead a simpler one-player (requestor only) version is implemented.
//H					ONE-DAY WHY-NOT TODO ITEM:	REVISIT THIS FUNCTION [AND CORRESPONDING PHASE FUNCTIONS] AND MAKE IT AWARE OF OTHER PASSENGERS AND BEHAVE CORRECTLY
//H
//H					TODO:	All the "n seconds" above should be settings in CONFIGURATION file.
//H
//H ~~
//H
//HH
//HH ~~
//HH	Syntax		:	_stopVehicleRequestedAndAuthorizedFncReturnBool = [_myGUSUIDNumber, _SUTypeNumber] call mgmTfA_s_CO_fnc_checkAndActionAnyStopVehicleRequestWeMightHaveReceived;
//HH	Parameters	:	Find below -- check out the (_this select n) entries
//HH	Return Value:	Bool
//HH						true	= signal the callingFunction to carry on as per normal
//HH						false	= signal the callingFunction to immediately terminate the workflow (requestor abandoned the SU & we don't think they're coming back!)
//HH ~~
//HH
//HH
//HH ~~
//HH	This function is dependant on the following files:	//if any, dependant files should be listed below
//HH	This function is dependant on the following global variables:	//if any, dependant global variables should be listed below
//HH ~~
//HH
if (!isServer) exitWith {}; if (isNil("mgmTfA_Server_Init")) then {mgmTfA_Server_Init=0;}; waitUntil {mgmTfA_Server_Init==1}; private ["_thisFileVerbosityLevelNumber"]; _thisFileVerbosityLevelNumber = mgmTfA_configgv_serverVerbosityLevel;
scopeName "mgmTfA_s_CO_fnc_checkAndActionAnyStopVehicleRequestWeMightHaveReceivedMainScope";
_thisFileVerbosityLevelNumber = mgmTfA_configgv_serverVerbosityLevel;


private	[
		// obtained from callingFunction
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
		"_SUDistanceToActiveWaypointInMetersNumber",
		"_SUTypeNumber",
		"_SUTaxiAIVehicleObject",
		"_taxiAnywhereRequestorClientIDNumber",
		"_taxiAnywhereRequestorProfileNameTextString",
		"_requestorPlayerObject",
		"_SUTaxiAIVehicleObjectBirthTimeInSecondsNumber",
		"_taxiAnywhereTaxiRequestedDestinationPosition3DArray",
		"_SUAICharacterDriverObject",
		//
		/// created locally
		"_doorsLockedBool",
		"_SUVehicleSpeedOfVehicleInKMHNumber",
		"_stopVehReqHandlerFncReturnValueBool",
		"_broadcastSUInformationCounter",
		"_counterForLogOnlyEveryNthPINGNumber",
		"_SUTaxiAIVehicleDistanceToWayPointMetersNumber",
		"_SUTaxiAIVehicleObjectAgeInSecondsNumber",
		"_SUTaxiAIVehicleVehicleDirectionInDegreesNumber",
		"_emergencyEscapeNeeded",
		"_stopVehicleRequestedAndAuthorizedBool"
		];
/*
// LIST OF PARAMETERS being passed from TA_Phase04 to mgmTfA_s_CO_fnc_checkAndActionAnyStopVehicleRequestWeMightHaveReceived
0	_myGUSUIDNumber
1	_SUTypeTextString
2	_SUActiveWaypointPositionPosition3DArray
3	_SUCurrentActionInProgressTextString
4	_SUCurrentTaskThresholdInSecondsNumber
5	_SUCurrentTaskBirthTimeInSecondsNumber
6	_SUDriversFirstnameTextString
7	_SUMarkerShouldBeDestroyedAfterExpiryBool
8	_SURequestorPlayerUIDTextString
9	_SURequestorProfileNameTextString
10	_SUAIVehicleObject
11	_SUAIVehicleObjectBirthTimeInSecondsNumber
12	_SUPickUpHasOccurredBool
13	_SUPickUpPositionPosition3DArray
14	_SUDropOffPositionHasBeenDeterminedBool
15	_SUDropOffHasOccurredBool
16	_SUDropOffPositionPosition3DArray
17	_SUDropOffPositionNameTextString
18	_SUTerminationPointPositionHasBeenDeterminedBool
19	_SUTerminationPointPosition3DArray
20	_SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray
21	_SUAIVehicleObjectCurrentPositionPosition3DArray
22	_SUAIVehicleVehicleDirectionInDegreesNumber
23	_SUAIVehicleObjectAgeInSecondsNumber
24	_SUCurrentTaskAgeInSecondsNumber
25	_SUAIVehicleSpeedOfVehicleInKMHNumber
26	_SUDistanceToActiveWaypointInMetersNumber
27	_SUTypeNumber
28	_SUTaxiAIVehicleObject
29	_taxiAnywhereRequestorClientIDNumber
30	_taxiAnywhereRequestorProfileNameTextString
31	_requestorPlayerObject
32	_SUTaxiAIVehicleObjectBirthTimeInSecondsNumber
33	_taxiAnywhereTaxiRequestedDestinationPosition3DArray
34	_SUAICharacterDriverObject
*/
// LIST OF LOCAL VARIABLES WITH INITIAL VALUES PASSED ON FROM CALLINGFUNCTION
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
_SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray = (_this select 20);
_SUAIVehicleObjectCurrentPositionPosition3DArray = (_this select 21);
_SUAIVehicleVehicleDirectionInDegreesNumber = (_this select 22);
_SUAIVehicleObjectAgeInSecondsNumber = (_this select 23);
_SUCurrentTaskAgeInSecondsNumber = (_this select 24);
_SUAIVehicleSpeedOfVehicleInKMHNumber = (_this select 25);
_SUDistanceToActiveWaypointInMetersNumber = (_this select 26);
		// _SUTypeNumber OPTIONS
		// 0 = TA
		// 1 = FD
		// 2 = BU
_SUTypeNumber = (_this select 27);
_SUTaxiAIVehicleObject = (_this select 28);
_taxiAnywhereRequestorClientIDNumber = (_this select 29);
_taxiAnywhereRequestorProfileNameTextString = (_this select 30);
_requestorPlayerObject = (_this select 31);
_SUTaxiAIVehicleObjectBirthTimeInSecondsNumber = (_this select 32);
_taxiAnywhereTaxiRequestedDestinationPosition3DArray = (_this select 33);
_SUAICharacterDriverObject = (_this select 34);

//	LIST OF LOCAL VARIABLES WITH INITIAL VALUES GENERATED LOCALLY
		//	note that, the return value of this function is handled upstream as follows:
		//		true	= everything is fine, carry on with the phase workflow as per normal
		//		false	= there's a problem (i.e.: requestor got out & didn't return). do emergency termination
		//	initially there is no reason to cause an emergency termination so we start with TRUE
_stopVehReqHandlerFncReturnValueBool = true;
// do NOT initialize here - will be done later in this file:			_broadcastSUInformationCounter = 0;
// we will assign values to these below - DO NOT initialize here
//	_counterForLogOnlyEveryNthPINGNumber
//	_SUTaxiAIVehicleDistanceToWayPointMetersNumber
//	_SUTaxiAIVehicleObjectAgeInSecondsNumber
//	_SUTaxiAIVehicleObjectBirthTimeInSecondsNumber
//	_SUTaxiAIVehicleVehicleDirectionInDegreesNumber
_emergencyEscapeNeeded = false;
// unless otherwise proven below, by default, no such request was authorized
_stopVehicleRequestedAndAuthorizedBool = false;

// TODO CHANGE THIS TO 10
if (_thisFileVerbosityLevelNumber>=0) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_fnc_checkAndActionAnyStopVehicleRequestWeMightHaveReceived.sqf]  [TV0] 	<ThisIs:%1> 	I have been CALL'd.	(_this) is: (%2)		(_SUTypeNumber) is: (%3)	.", (str _myGUSUIDNumber), (str _this), (str _SUTypeNumber)];};//dbg




// MAIN CHECK
// stopVehicle requested and authorized on the client-side?
_stopVehicleRequestedAndAuthorizedBool = call compile format ["mgmTfA_gv_PV_SU%1SUStopVehicleRequestedAndAuthorized", _myGUSUIDNumber];
if (_stopVehicleRequestedAndAuthorizedBool) then {
	// YES, we have an authorized exitRequest		-- log it	
	// TODO CHANGE THIS TO 10
	if (_thisFileVerbosityLevelNumber>=0) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_fnc_checkAndActionAnyStopVehicleRequestWeMightHaveReceived.sqf]  [TV0] 	YES, WE HAVE an authorized exitRequest for SU: (%1)		.", (str _myGUSUIDNumber)];};//dbg

	// STOP VEHICLE:	Use the horn to signal upcoming STOP action
	driver _SUTaxiAIVehicleObject forceWeaponFire [currentWeapon _SUTaxiAIVehicleObject, currentWeapon _SUTaxiAIVehicleObject];

	// disable Taxi driver & vehicle movement
	_SUAICharacterDriverObject disableAI "MOVE";
	uiSleep 0.05;
	// prep: we'll be allowing player(s) to get off - unlock doors first
	_SUTaxiAIVehicleObject lockCargo false;
	_doorsLockedBool = true;
	uiSleep 0.05;
	if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_fnc_checkAndActionAnyStopVehicleRequestWeMightHaveReceived.sqf] 	[TV3]	STOPPED VEHICLE		to allow requestor to get out and DOORS UNLOCKED"];};
	// update door status on all clients
	missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUVehDoorsLockedBool", _myGUSUIDNumber], _doorsLockedBool];
	publicVariable format ["mgmTfA_gv_PV_SU%1SUVehDoorsLockedBool", _myGUSUIDNumber];
	uiSleep 0.05;

	// n. Keep looping & waiting n seconds
		// inside the loop
		//	n. Keep broadcasting service unit information from inside the loop
		//	n. Keep checking for potential phase timeouts

	//// BEGIN
	//Change our status to:		5b AWAITING GET OFF (STOP REQUESTED) 						to proceed, first the commandingPlayer must get off...
	_SUCurrentActionInProgressTextString  = mgmTfA_configgv_currentTATaxiActionInProgressIs05bTextString;

	//	SEND SIGNAL to commandingPlayer's PC		-- we do NOT message if we are still moving - that's how accidents happen!
	waitUntil {speed _SUTaxiAIVehicleObject == 0};
	// Create the global variable that will be sent to the requestor's PC		-- send the _myGUSUIDNumber here
	mgmTfA_gv_pvc_req_pleaseBeginSysChatInformingCommandingPlayerWaitingForGetOutPacket = _myGUSUIDNumber;
	_taxiAnywhereRequestorClientIDNumber publicVariableClient "mgmTfA_gv_pvc_req_pleaseBeginSysChatInformingCommandingPlayerWaitingForGetOutPacket";
	if (_thisFileVerbosityLevelNumber>8) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_fnc_checkAndActionAnyStopVehicleRequestWeMightHaveReceived.sqf]  [TV8]  SIGNAL SENT to the commandingPlayer's PC (mgmTfA_gv_pvc_req_pleaseBeginSysChatInformingCommandingPlayerWaitingForGetOutPacket). _taxiAnywhereRequestorProfileNameTextString: (%1) 		 on computer (_taxiAnywhereRequestorClientIDNumber):(%2)		_myGUSUIDNumber is: (%3).", _taxiAnywhereRequestorProfileNameTextString, _taxiAnywhereRequestorClientIDNumber, _myGUSUIDNumber];};

	//	Initial evaluation
	//	don't add this var to the top of page var list because this will never be needed if it's a NO answer in the first/main IF condition
	private	[
			"_requestorInsideVehicle",
			"_waitStartTimeForRequestorGetOutInSecondsNumber",
			"_beenWaitingForRequestorToGetOutInSecondsNumber"
			];
	_beenWaitingForRequestorToGetOutInSecondsNumber = 0;
	if (_requestorPlayerObject in _SUTaxiAIVehicleObject) then {
		//He's in!
		_requestorInsideVehicle = true;
	} else {
		//He's not in!
		_requestorInsideVehicle = false;
	};

	/* DONE IN THE CALLING FUNCTION - DO NOT REPEAT HERE
	_SUCurrentTaskThresholdInSecondsNumber = mgmTfA_configgv_expiryTimeOutThresholdfixedDestinationTaxiRequestorInsideVehicleInSecondsNumber;
	// Reset Current Task Age
	_SUCurrentTaskAgeInSecondsNumber = 0;
	//Start the Current Task Age Timer
	_SUCurrentTaskBirthTimeInSecondsNumber = (time);
	*/
	/* DONE IN THE CALLING FUNCTION - DO NOT REPEAT HERE
	// Set distance to Current Waypoint to zero as we are at the DropOff Point and awaiting Requestor to get off the vehicle...
	_SUTaxiAIVehicleDistanceToWayPointMetersNumber = 0;
	*/


	////////////////////////////////////////////////////////////////////////////
	// MAIN LOOP
	////////////////////////////////////////////////////////////////////////////
	//As long as he is inside, we will patiently wait for him to get out UNTIL PhaseTask timelimit is exceeded OR our own timelimit is exceeded
	_counterForLogOnlyEveryNthPINGNumber = 0;
	_broadcastSUInformationCounter = 0;
	_waitStartTimeForRequestorGetOutInSecondsNumber = (time);
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
			_null = [_myGUSUIDNumber, _SUTypeTextString, _SUActiveWaypointPositionPosition3DArray, _SUCurrentActionInProgressTextString, _SUCurrentTaskThresholdInSecondsNumber, _SUCurrentTaskBirthTimeInSecondsNumber, _SUDriversFirstnameTextString, _SUMarkerShouldBeDestroyedAfterExpiryBool, _SURequestorPlayerUIDTextString, _SURequestorProfileNameTextString, _SUAIVehicleObject, _SUAIVehicleObjectBirthTimeInSecondsNumber, _SUPickUpHasOccurredBool, _SUPickUpPositionPosition3DArray, _SUDropOffPositionHasBeenDeterminedBool, _SUDropOffHasOccurredBool, _SUDropOffPositionPosition3DArray, _SUDropOffPositionNameTextString, _SUTerminationPointPositionHasBeenDeterminedBool, _SUTerminationPointPosition3DArray, _SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray, _SUAIVehicleObjectCurrentPositionPosition3DArray, _SUAIVehicleVehicleDirectionInDegreesNumber, _SUAIVehicleObjectAgeInSecondsNumber, _SUCurrentTaskAgeInSecondsNumber, _SUAIVehicleSpeedOfVehicleInKMHNumber, _SUDistanceToActiveWaypointInMetersNumber] call mgmTfA_s_CO_fnc_publicVariableBroadcastSUInformationPhaseB;
			_broadcastSUInformationCounter = 0;
		};
		///
		uiSleep 0.05;
		// Pit-stop checks: AutoRefuel
		if (fuel _SUTaxiAIVehicleObject < 0.2) then {
			_SUTaxiAIVehicleObject setFuel 1;
			if (_thisFileVerbosityLevelNumber>=2) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_fnc_checkAndActionAnyStopVehicleRequestWeMightHaveReceived.sqf]  [TV2] REFUELing SU Vehicle: (%1) | Driver: (%2) | ServerUpTime: (%3)", _myGUSUIDNumber, _SUDriversFirstnameTextString, (round (time))];};//dbg
		};
		// Pit-stop checks: AutoRepair
		if (damage _SUTaxiAIVehicleObject>0.2) then {
			_SUTaxiAIVehicleObject setDamage 0;
			if (_thisFileVerbosityLevelNumber>=2) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_fnc_checkAndActionAnyStopVehicleRequestWeMightHaveReceived.sqf]  [TV2] REPAIRing SU Vehicle: (%1) | Driver: (%2) | ServerUpTime: (%3)", _myGUSUIDNumber, _SUDriversFirstnameTextString, (round (time))];};//dbg
		};
		// Calculate Current Task Age and Initiate Abnormal SU Termination (logged) if necessary
		_SUCurrentTaskAgeInSecondsNumber = (round ((time) - _SUCurrentTaskBirthTimeInSecondsNumber));
		if (_SUCurrentTaskAgeInSecondsNumber > _SUCurrentTaskThresholdInSecondsNumber) then {
			_emergencyEscapeNeeded = true;
		};
		 // Let emergency escapees pass
		if(_emergencyEscapeNeeded) then {
			// we will breakTo, to terminate -- but first reenable Taxi driver & vehicle's movement
			_SUAICharacterDriverObject enableAI "MOVE";
			breakTo "mgmTfA_s_CO_fnc_checkAndActionAnyStopVehicleRequestWeMightHaveReceivedMainScope";
		};

		// PING			log only every Nth package			(uiSleep=0.05)		(n=300)  => 	log every 15 seconds
		// Let emergency escapees pass
		_counterForLogOnlyEveryNthPINGNumber = _counterForLogOnlyEveryNthPINGNumber + 1;
		if (_counterForLogOnlyEveryNthPINGNumber==300) then {

			//check distance to our Current Waypoint (_taxiAnywhereRequestorPosition3DArray) and write to server RPT log
			_SUTaxiAIVehicleDistanceToWayPointMetersNumber = (round (_SUTaxiAIVehicleObject distance _taxiAnywhereTaxiRequestedDestinationPosition3DArray));

			if (_thisFileVerbosityLevelNumber>=1) then {
				_SUTaxiAIVehicleObjectAgeInSecondsNumber = (round ((time)-_SUTaxiAIVehicleObjectBirthTimeInSecondsNumber));
				diag_log format ["[mgmTfA] [mgmTfA_s_CO_fnc_checkAndActionAnyStopVehicleRequestWeMightHaveReceivedMainScope.sqf] [TV1] PING from SU Vehicle: (%1) | Driver: (%2) | ServerUpTime: (%3) | MyAge: (%4) | Distance to WP: (%5) metres | Action In Progress: (%6)", _myGUSUIDNumber, _SUDriversFirstnameTextString, (round (time)), _SUTaxiAIVehicleObjectAgeInSecondsNumber, _SUTaxiAIVehicleDistanceToWayPointMetersNumber, _SUCurrentActionInProgressTextString];
			};
			_counterForLogOnlyEveryNthPINGNumber=0;
		};
		if (_requestorPlayerObject in _SUTaxiAIVehicleObject) then {
			_requestorInsideVehicle=true;
			//He is still in

			// we won't wait forever!
			_beenWaitingForRequestorToGetOutInSecondsNumber = ((time) - _waitStartTimeForRequestorGetOutInSecondsNumber);
			if (_beenWaitingForRequestorToGetOutInSecondsNumber >= 10) then {
				// hit the timeout max value - terminate!
				//NO, requestor did not get out. He has changed his mind! We will carry on with the normal taxi service phase. return to callingFunction (_stopVehReqHandlerFncReturnValueBool = true). (callingFunction will then carry an as per normal)
				// log it
				if (_thisFileVerbosityLevelNumber>=5) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_fnc_checkAndActionAnyStopVehicleRequestWeMightHaveReceived.sqf] [TV5] WAIT FOR REQUESTOR GET OUT TIMEOUT VALUE REACHED!		we won't wait anymore for him to get out. proceeding as if no stopVehicle requested.  (_beenWaitingForRequestorToGetOutInSecondsNumber) is: (%1).", _beenWaitingForRequestorToGetOutInSecondsNumber];};
				// stopVehRequestor is not getting out -- reenable Taxi driver & vehicle's movement
				_SUAICharacterDriverObject enableAI "MOVE";
				breakTo "mgmTfA_s_CO_fnc_checkAndActionAnyStopVehicleRequestWeMightHaveReceivedMainScope";
			} else {
				// still good to wait some more
				// log it
				if (_thisFileVerbosityLevelNumber>=5) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_fnc_checkAndActionAnyStopVehicleRequestWeMightHaveReceived.sqf] [TV5] WAIT FOR REQUESTOR GET OUT TIMEOUT VALUE IS STILL GOOD		will wait some more...			(_beenWaitingForRequestorToGetOutInSecondsNumber) is: (%1).", _beenWaitingForRequestorToGetOutInSecondsNumber];};
			};
		} else {
			//He is out!
			_requestorInsideVehicle=false;
		};
	};
	if (_thisFileVerbosityLevelNumber>=5) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_fnc_checkAndActionAnyStopVehicleRequestWeMightHaveReceived.sqf] [TV5] EXITed loop _requestorInsideVehicle.		The value for (_requestorInsideVehicle) is: (%1).", _requestorInsideVehicle];};
	uiSleep 0.05;






	//	THE REQUESTOR is OUTSIDE -- handle situation here -- do not immediately terminate the SU, perhaps requestor is using ATM or looting just for a second! give him some time and let's see if he's getting back in. say in about 90 seconds...

	// n. Keep looping & waiting n seconds
		// inside the loop
		//	n. Keep broadcasting service unit information from inside the loop
		//	n. Keep checking for potential phase timeouts

	//// BEGIN
	//Change our status to:		2b AWAITING GET IN (STOP REQUESTED) 						to proceed, first the commandingPlayer must get in...
	_SUCurrentActionInProgressTextString  = mgmTfA_configgv_currentTATaxiActionInProgressIs02bTextString;

	//	SEND SIGNAL to commandingPlayer's PC		-- we do NOT message if we are still moving - that's how accidents happen!
	waitUntil {speed _SUTaxiAIVehicleObject == 0};
	// Create the global variable that will be sent to the requestor's PC		-- send the _myGUSUIDNumber here
	mgmTfA_gv_pvc_req_pleaseBeginSysChatInformingCommandingPlayerWaitingForGetInPacket = _myGUSUIDNumber;
	_taxiAnywhereRequestorClientIDNumber publicVariableClient "mgmTfA_gv_pvc_req_pleaseBeginSysChatInformingCommandingPlayerWaitingForGetInPacket";
	if (_thisFileVerbosityLevelNumber>8) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_fnc_checkAndActionAnyStopVehicleRequestWeMightHaveReceived.sqf]  [TV8]  SIGNAL SENT to the commandingPlayer's PC (mgmTfA_gv_pvc_req_pleaseBeginSysChatInformingCommandingPlayerWaitingForGetInPacket). _taxiAnywhereRequestorProfileNameTextString: (%1) 		 on computer (_taxiAnywhereRequestorClientIDNumber):(%2)		_myGUSUIDNumber is: (%3).", _taxiAnywhereRequestorProfileNameTextString, _taxiAnywhereRequestorClientIDNumber, _myGUSUIDNumber];};

	//	Initial evaluation
	//	don't add this var to the top of page var list because this will never be needed if it's a NO answer in the first/main IF condition
	private	[
			"_requestorOutsideVehicle",
			"_waitStartTimeForRequestorGetInInSecondsNumber",
			"_beenWaitingForRequestorToGetInInSecondsNumber"
			];	
	if (_requestorPlayerObject in _SUTaxiAIVehicleObject) then {
		_requestorOutsideVehicle = false;
	} else {
		_requestorOutsideVehicle = true;
	};
	/* DONE IN THE CALLING FUNCTION - DO NOT REPEAT HERE
	_SUCurrentTaskThresholdInSecondsNumber = mgmTfA_configgv_expiryTimeOutThresholdTATaxiRequestorOutsideVehicleInSecondsNumber;
	// Reset Current Task Age
	_SUCurrentTaskAgeInSecondsNumber = 0;
	//Start the Current Task Age Timer
	_SUCurrentTaskBirthTimeInSecondsNumber = (time);
	*/
	//	might have popped out for a sec - keep looping & waiting...
	////////////////////////////////////////////////////////////////////////////
	// MAIN LOOP
	////////////////////////////////////////////////////////////////////////////
	//As long as he is outside, we will patiently wait for him to get in UNTIL PhaseTask timelimit is exceeded OR our own timelimit is exceeded
	_counterForLogOnlyEveryNthPINGNumber = 0;
	_broadcastSUInformationCounter = 0;
	_waitStartTimeForRequestorGetInInSecondsNumber = (time);
	while {_requestorOutsideVehicle} do {
		scopeName "TheRequestorOutsideVehicleLoop";
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
			_SUPickUpPositionPosition3DArray = _taxiAnywhereRequestorPosition3DArray;
			_SUAIVehicleObject = _SUTaxiAIVehicleObject;
			_SUAIVehicleObjectBirthTimeInSecondsNumber = _SUTaxiAIVehicleObjectBirthTimeInSecondsNumber;
			_SUDistanceToActiveWaypointInMetersNumber = (round (_SUAIVehicleObject distance _SUActiveWaypointPositionPosition3DArray));
			_null = [_myGUSUIDNumber, _SUTypeTextString, _SUActiveWaypointPositionPosition3DArray, _SUCurrentActionInProgressTextString, _SUCurrentTaskThresholdInSecondsNumber, _SUCurrentTaskBirthTimeInSecondsNumber, _SUDriversFirstnameTextString, _SUMarkerShouldBeDestroyedAfterExpiryBool, _SURequestorPlayerUIDTextString, _SURequestorProfileNameTextString, _SUAIVehicleObject, _SUAIVehicleObjectBirthTimeInSecondsNumber, _SUPickUpHasOccurredBool, _SUPickUpPositionPosition3DArray, _SUDropOffPositionHasBeenDeterminedBool, _SUDropOffHasOccurredBool, _SUDropOffPositionPosition3DArray, _SUDropOffPositionNameTextString, _SUTerminationPointPositionHasBeenDeterminedBool, _SUTerminationPointPosition3DArray, _SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray, _SUAIVehicleObjectCurrentPositionPosition3DArray, _SUAIVehicleVehicleDirectionInDegreesNumber, _SUAIVehicleObjectAgeInSecondsNumber, _SUCurrentTaskAgeInSecondsNumber, _SUAIVehicleSpeedOfVehicleInKMHNumber, _SUDistanceToActiveWaypointInMetersNumber] call mgmTfA_s_CO_fnc_publicVariableBroadcastSUInformationPhaseB;
		};
		///
		// Pit-stop checks: AutoRefuel
		if (fuel _SUTaxiAIVehicleObject < 0.2) then {
			_SUTaxiAIVehicleObject setFuel 1;
			if (_thisFileVerbosityLevelNumber>=2) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_fnc_checkAndActionAnyStopVehicleRequestWeMightHaveReceived.sqf]  [TV2] REFUELing SU Vehicle: (%1) | Driver: (%2) | ServerUpTime: (%3)", _myGUSUIDNumber, _SUDriversFirstnameTextString, (round (time))];};//dbg
		};
		// Pit-stop checks: AutoRepair
		if (damage _SUTaxiAIVehicleObject>0.2) then {
			_SUTaxiAIVehicleObject setDamage 0;
			if (_thisFileVerbosityLevelNumber>=2) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_fnc_checkAndActionAnyStopVehicleRequestWeMightHaveReceived.sqf]  [TV2] REPAIRing SU Vehicle: (%1) | Driver: (%2) | ServerUpTime: (%3)", _myGUSUIDNumber, _SUDriversFirstnameTextString, (round (time))];};//dbg
		};
		// Calculate Current Task Age and Initiate Abnormal SU Termination (logged) if necessary
		_SUCurrentTaskAgeInSecondsNumber = (round ((time) - _SUCurrentTaskBirthTimeInSecondsNumber));
		if (_SUCurrentTaskAgeInSecondsNumber > _SUCurrentTaskThresholdInSecondsNumber) then {
			_emergencyEscapeNeeded = true;
		};
		// Let emergency escapees pass
		if(_emergencyEscapeNeeded) then {	breakTo "mgmTfA_s_CO_fnc_checkAndActionAnyStopVehicleRequestWeMightHaveReceivedMainScope";	};
		_counterForLogOnlyEveryNthPINGNumber = _counterForLogOnlyEveryNthPINGNumber + 1;
		if (_counterForLogOnlyEveryNthPINGNumber==300) then {

			//check distance to our Current Waypoint (_taxiAnywhereRequestorPosition3DArray) and write to server RPT log
			_SUTaxiAIVehicleDistanceToWayPointMetersNumber = (round (_SUTaxiAIVehicleObject distance _taxiAnywhereTaxiRequestedDestinationPosition3DArray));

			if (_thisFileVerbosityLevelNumber>=1) then {
				_SUTaxiAIVehicleObjectAgeInSecondsNumber = (round ((time)-_SUTaxiAIVehicleObjectBirthTimeInSecondsNumber));
				diag_log format ["[mgmTfA] [mgmTfA_s_CO_fnc_checkAndActionAnyStopVehicleRequestWeMightHaveReceivedMainScope.sqf] [TV1] PING from SU Vehicle: (%1) | Driver: (%2) | ServerUpTime: (%3) | MyAge: (%4) | Distance to WP: (%5) metres | Action In Progress: (%6)", _myGUSUIDNumber, _SUDriversFirstnameTextString, (round (time)), _SUTaxiAIVehicleObjectAgeInSecondsNumber, _SUTaxiAIVehicleDistanceToWayPointMetersNumber, _SUCurrentActionInProgressTextString];
			};
			_counterForLogOnlyEveryNthPINGNumber=0;
		};
		if (_requestorPlayerObject in _SUTaxiAIVehicleObject) then {
			//	He got in!
			if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_fnc_checkAndActionAnyStopVehicleRequestWeMightHaveReceived.sqf] [TV3] Requestor IS IN!		%1 is now in %2. 		Locking doors & driving!", _taxiAnywhereRequestorProfileNameTextString, _SUTaxiAIVehicleObject];};
			// END THE LOOP
			// IMPORTANT: DO NOT MOVE THIS LINE ANY HIGHER OR IT WILL ABRUPTLY STOP EXECUTION!
			_requestorOutsideVehicle = false;
		} else {
			//	He is still not in - keep looping

			//	log it
			if (_thisFileVerbosityLevelNumber>=7) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_fnc_checkAndActionAnyStopVehicleRequestWeMightHaveReceived.sqf] [TV7] WAITING for %1 to get in %2...", _requestorPlayerObject, _SUTaxiAIVehicleObject];};

			// we won't wait forever!
			_beenWaitingForRequestorToGetInInSecondsNumber = ((time) - _waitStartTimeForRequestorGetInInSecondsNumber);
			// TODO: Change this test value to 90 seconds 
			// TODO: make this a CONFIGURATION file setting
			if (_beenWaitingForRequestorToGetInInSecondsNumber >= 15) then {

				// hit the timeout max value - we'll terminate!
				
				// log it
				if (_thisFileVerbosityLevelNumber>=5) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_fnc_checkAndActionAnyStopVehicleRequestWeMightHaveReceived.sqf] [TV5] WAIT FOR REQUESTOR GET IN TIMEOUT VALUE REACHED!		we won't wait anymore for him to get in. proceeding as if no stopVehicle requested.  (_beenWaitingForRequestorToGetInInSecondsNumber) is: (%1).", _beenWaitingForRequestorToGetInInSecondsNumber];};

				//NO, requestor did not get back in. He dont't need us! We will terminate this taxi service phase and the whole workflow. return to callingFunction (_stopVehReqHandlerFncReturnValueBool = false). (callingFunction will then instantly terminate)
				// enable driver movement
				_SUAICharacterDriverObject enableAI "MOVE";

				// we signal the callingFunction that it should terminate via setting "_emergencyEscapeNeeded = true;" (last lines of this function will then return false which the callingFunction will process)
				_emergencyEscapeNeeded = true;
				breakTo "mgmTfA_s_CO_fnc_checkAndActionAnyStopVehicleRequestWeMightHaveReceivedMainScope";
			} else {
				// still good to wait some more
				// log it
				if (_thisFileVerbosityLevelNumber>=5) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_fnc_checkAndActionAnyStopVehicleRequestWeMightHaveReceived.sqf] [TV5] WAIT FOR REQUESTOR GET IN TIMEOUT VALUE IS STILL GOOD		will wait some more...			(_beenWaitingForRequestorToGetInInSecondsNumber) is: (%1).", _beenWaitingForRequestorToGetInInSecondsNumber];};
			};
		};
	};
	if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_fnc_checkAndActionAnyStopVehicleRequestWeMightHaveReceived.sqf] [TV3] EXITed loop _requestorOutsideVehicle"];};
	uiSleep 0.05;





































} else {
	// NO, we do NOT have any authorized exitRequests
	// TODO CHANGE THIS TO 10
	if (_thisFileVerbosityLevelNumber>=0) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_fnc_checkAndActionAnyStopVehicleRequestWeMightHaveReceived.sqf]  [TV0] 	NO, we DO NOT have an authorized exitRequest for SU:(%1)		.", (str _myGUSUIDNumber)];};//dbg
};


// we are about to exit function and return no NormalPhase or EmergencyTermination Phase		-- in either case, we can toggle this back to false now
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUStopVehicleRequestedAndAuthorized", _myGUSUIDNumber], false];
publicVariable format ["mgmTfA_gv_PV_SU%1SUStopVehicleRequestedAndAuthorized", _myGUSUIDNumber];
if (_thisFileVerbosityLevelNumber>=0) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_fnc_checkAndActionAnyStopVehicleRequestWeMightHaveReceived.sqf]  [TV0] 	exiting function. I just set (1SUStopVehicleRequestedAndAuthorized) to FALSE 		for SU:(%1)		.", (str _myGUSUIDNumber)];};//dbg

// return appropriate response to the callingFunction
if (_emergencyEscapeNeeded) then {
	_stopVehReqHandlerFncReturnValueBool = false;
} else {
	_stopVehReqHandlerFncReturnValueBool = true;
};
// TODO CHANGE THIS TO 10
if (_thisFileVerbosityLevelNumber>=0) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_fnc_checkAndActionAnyStopVehicleRequestWeMightHaveReceived.sqf]  [TV0]   Reached checkpoint: Bottom of function. The next line will exit the function.		(_stopVehReqHandlerFncReturnValueBool) is: (%1).", _stopVehReqHandlerFncReturnValueBool];};
_stopVehReqHandlerFncReturnValueBool
// EOF