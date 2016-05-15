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
//H						n. call compile and obtain the variable status:	is there a waiting authorized stopVehicle request?
//H							n. NO,	there is no pending authorized stopVeh requests at this time
//H								n. return to callingFunction (_stopVehReqResultEverythingIsFineBool = true).
//H							n. YES,	there is a pending authorized stopVeh request
//H								n. stop the vehicle - we will wait for 10 seconds to allow the requestor to get out.
//H								n. send the packet to requestor (TODO: all passengers): 'pleaseBeginSysChatInformingAllPassengersStopVehRequested'. Client-side code => stop the sysChat messages (if counter hits 10 seconds) OR (if pleaseStopSysChatInformingAllPassengersStopVehRequested packet received)
//H											[DRIVER] Stop Vehicle requested - waiting for passengers get out [10]
//H											[DRIVER] Stop Vehicle requested - waiting for passengers get out [9] ... and so on
//H											n. Set the vehicle phase status correctly
//H											n. Keep checking for potential phase timeouts
//HH										n. Keep broadcasting service unit information from inside the loop
//HH										n. Keep looping & waiting n seconds
//H							 		n. NO, requestor did not get out. He has changed his mind! We will carry on with the normal taxi service phase. return to callingFunction (_stopVehReqResultEverythingIsFineBool = true). (callingFunction will then carry an as per normal)
//H									n. YES, requestor got out. Now we will wait 90 seconds for him to get back in		(TODO: proceed according to the multi-passenger situation: are there any other passengers in vehicle?)
//H											n. Send the packet to requestor (TODO: all passengers): 'pleaseBeginSysChatInformingAllPassengersTaxiIsWaitingGetIn'. 
//H												NOTE: Client-side code => stop the sysChat messages (if counter hits 90 seconds) OR (if pleaseStopSysChatInformingAllPassengersStopVehRequested packet received)
//H											n. Set the vehicle phase status correctly
//H											n. Keep checking for potential phase timeouts
//HH										n. Keep broadcasting service unit information from inside the loop
//HH										n. Keep looping & waiting n seconds
//H											n. (TODO: YES there are other passengers left in vehicle - countDown another 5 seconds to allow any other friendly-to-requestor-passengers to get out as well, then carry on with NO code below)
//H											n. NO no other passengers left in vehicle - start the 'waitingForGetIn' countdown - wait 90 seconds, keep the doors unlocked, keep syschat-informing the commander every second
//H													[DRIVER] Waiting for commander to get back in [90]...
//H													[DRIVER] Waiting for commander to get back in [89]...
//H									n. NO, requestor did not get back in:
//H										n. Inform the commandingPlayer:		Your Taxi is now returning to base, thanks for choosing TaxiCorp.\n Have a nice day!
//H												[CLIENT-SIDE CODE HERE] to process the message above
//H										n. Signal the calling function by returning FALSE		(callingFunction will then directly skip to termination phase)
//H									n. YES, requestor got back in.
//H										n. return "true" to callingFunction (_stopVehReqResultEverythingIsFineBool = true).		(callingFunction will then carry an as per normal)
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
_thisFileVerbosityLevelNumber = mgmTfA_configgv_serverVerbosityLevel;

private	[
		"_myGUSUIDNumber",
		"_SUTypeNumber",
		"_stopVehReqResultEverythingIsFineBool"
		];

_myGUSUIDNumber = (_this select 0);
// _SUTypeNumber OPTIONS
// 0 = TA
// 1 = FD
// 2 = BU
_SUTypeNumber = (_this select 1);
// initially there is no authorized stopVeh request - unless otherwise proven below
_stopVehReqResultEverythingIsFineBool = false;

// TODO CHANGE THIS TO 10
if (_thisFileVerbosityLevelNumber>=0) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_fnc_checkAndActionAnyStopVehicleRequestWeMightHaveReceived.sqf]  [TV0] 	<ThisIs:%1> 	I have been CALL'd.	(_this) is: (%2)		(_SUTypeNumber) is: (%3)	.", (str _myGUSUIDNumber), (str _this), (str _SUTypeNumber)];};//dbg



// MAIN
// stopVehicle requested and authorized?
_stopVehReqResultEverythingIsFineBool = call compile format ["mgmTfA_gv_PV_SU%1SUStopVehicleRequestedAndAuthorized", _myGUSUIDNumber];
if (_stopVehReqResultEverythingIsFineBool) then {
	// YES, we have an authorized exitRequest
	// TODO CHANGE THIS TO 10
	if (_thisFileVerbosityLevelNumber>=0) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_fnc_checkAndActionAnyStopVehicleRequestWeMightHaveReceived.sqf]  [TV0] 	YES, WE HAVE an authorized exitRequest for SU:(%1)		.", (str _myGUSUIDNumber)];};//dbg


	// DELETE THIS IN THE NEXT HOUR -- RESET IT FOR QUICK TESTING PURPOSES
	// DELETE THIS IN THE NEXT HOUR -- RESET IT FOR QUICK TESTING PURPOSES
	// DELETE THIS IN THE NEXT HOUR -- RESET IT FOR QUICK TESTING PURPOSES
	missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUStopVehicleRequestedAndAuthorized", _myGUSUIDNumber], false];
	publicVariable format ["mgmTfA_gv_PV_SU%1SUStopVehicleRequestedAndAuthorized", _myGUSUIDNumber];
	if (_thisFileVerbosityLevelNumber>=0) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_fnc_checkAndActionAnyStopVehicleRequestWeMightHaveReceived.sqf]  [TV0] 	for test purposes I have now set (1SUStopVehicleRequestedAndAuthorized) to FALSE 		for SU:(%1)		.", (str _myGUSUIDNumber)];};//dbg
	// DELETE THIS IN THE NEXT HOUR -- RESET IT FOR QUICK TESTING PURPOSES
	// DELETE THIS IN THE NEXT HOUR -- RESET IT FOR QUICK TESTING PURPOSES
	// DELETE THIS IN THE NEXT HOUR -- RESET IT FOR QUICK TESTING PURPOSES


} else {
	// NO, we do NOT have any authorized exitRequests
	// TODO CHANGE THIS TO 10
	if (_thisFileVerbosityLevelNumber>=0) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_fnc_checkAndActionAnyStopVehicleRequestWeMightHaveReceived.sqf]  [TV0] 	NO, we DO NOT have an authorized exitRequest for SU:(%1)		.", (str _myGUSUIDNumber)];};//dbg
};




// TODO CHANGE THIS TO 10
if (_thisFileVerbosityLevelNumber>=0) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_fnc_checkAndActionAnyStopVehicleRequestWeMightHaveReceived.sqf]  [TV0]   Reached checkpoint: Bottom of function. The next line will exit the function.		(_stopVehReqResultEverythingIsFineBool) is: (%1).", _stopVehReqResultEverythingIsFineBool];};

_stopVehReqResultEverythingIsFineBool
// EOF