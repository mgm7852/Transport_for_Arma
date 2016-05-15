//H
//H ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_s_CO_fnc_checkAndActionAnyStopVehicleRequestWeMightHaveReceived.sqf
//H $PURPOSE$	:	1. 'StopVehicle (and allow me to exit)' button on the GUI is processed by the client side.
//H					2. When a request is deemed eligible then it is sent to the server with a PVS packet:	mgmTfA_gv_pvs_req_taxiAnywhereTaxiPleaseAllowExitNoResponsePacket
//H					3. Server EH will then set to true:	missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUExitRequestedAndAuthorized", _myGUSUIDNumber], true];
//H					---
//H					4. This function is relevant, and therefore called by the Phase0n functions, from inside the following loops during the workflow:
//H						while {_TA1stMileFeeNeedToBePaidBool}
//H						while {_SUTaxiAIVehicleDistanceToWayPointMetersNumber>250}
//H						while {_SUTaxiAIVehicleDistanceToWayPointMetersNumber>25}
//H
//H
//H
//H					Our job is to action the request as follows:
//H
//H					TODO:	Sections of the design below is NOT IMPLEMENTED yet and marked with in-line TODOs.
//H							Instead a simpler one-player (requestor only) version is implemented.
//H					ONE-DAY WHY-NOT TODO ITEM:	REVISIT THIS FUNCTION [AND CORRESPONDING PHASE FUNCTIONS] AND MAKE IT AWARE OF OTHER PASSENGERS AND BEHAVE CORRECTLY
//H
//H						n. call compile and obtain the variable status:	is there a waiting authorized stopVehicle request?
//H							n. NO,	there is no pending authorized stopVeh requests at this time
//H								n. return to callingFunction with TRUE
//H							n. YES,	there is a pending authorized stopVeh request
//H								n. stop the vehicle, and wait for 10 seconds to allow the requestor to get out.
//H								n. send the packet to requestor (TODO: all passengers): 'pleaseBeginSysChatInformingAllPassengersStopVehRequested'. Client-side code => stop (if counter hits 10 seconds) OR (if pleaseStopSysChatInformingAllPassengersStopVehRequested packet received)
//H											[DRIVER] Stop Vehicle requested - waiting for passengers get out [10]
//H											[DRIVER] Stop Vehicle requested - waiting for passengers get out [9] ... and so on
//H									n. Start waiting n seconds but first set the vehicle status correctly
//H									n. keep waiting n seconds but keep broadcasting service unit information from inside the loop
//H							 		n. NO, requestor did not get out:	He might have changed his mind though, so we time out within 10 seconds and carry on with the phase.
//H									n. YES, requestor got out - proceed - wait for get back in		(TODO: proceed according to the multi-passenger situation: are there any other passengers in vehicle?)
//H											n. Start waiting n seconds but first set the vehicle status correctly
//H											n. keep waiting n seconds but keep broadcasting service unit information from inside the loop
//H											n. (TOOD: YES there other passengers left in vehicle - countDown another 5 seconds to allow any other friendly-to-requestor-passengers to get out as well, then carry on with NO code below)
//H											n. NO no other passengers left in vehicle - start the 'waitingForGetIn' countdown - wait 90 seconds, keep the doors unlocked, keep syschat-informing the commander every second
//H													[DRIVER] Waiting for commander to get back in [90]...
//H													[DRIVER] Waiting for commander to get back in [89]...
//H									n. NO, requestor did not get back in:
//H										n. inform the commandingPlayer:		Your Taxi is now returning to base, thanks for choosing TaxiCorp.\n Have a nice day!
//H										n. signal the calling function by returning FALSE		(callingFunction will then directly skip to termination phase)
//H									n. YES, requestor got back in.
//H										n. signal the calling function by returning TRUE		(callingFunction will then carry an as per normal)
//H										n. (TODO: wait another 4 seconds to allow any other friendly-to-requestor-passengers to get in as well.)
//H										n. (TODO: wait another 4 seconds to allow any other friendly-to-requestor-passengers to get in as well.)
//H										n. (TODO: inform the player we are leaving in 5 seconds)
//H ~~
//H
//HH
//HH ~~
//HH	Syntax		:	_stopVehProcessingResultBool = mgmTfA_s_CO_fnc_checkAndActionAnyStopVehicleRequestWeMightHaveReceived;
//HH	Parameters	:	none
//HH	Return Value:	Bool
//HH ~~
//HH
//HH
//HH ~~
//HH	This function is dependant on the following files:	//if any, dependant files should be listed below
//HH	This function is dependant on the following global variables:	//if any, dependant global variables should be listed below
//HH ~~
//HH




// COPIED CODE BELOW NOT REVIEWED YET
// COPIED CODE BELOW NOT REVIEWED YET
// COPIED CODE BELOW NOT REVIEWED YET
// COPIED CODE BELOW NOT REVIEWED YET
// COPIED CODE BELOW NOT REVIEWED YET
// COPIED CODE BELOW NOT REVIEWED YET
// COPIED CODE BELOW NOT REVIEWED YET
// COPIED CODE BELOW NOT REVIEWED YET
// COPIED CODE BELOW NOT REVIEWED YET
// COPIED CODE BELOW NOT REVIEWED YET
// COPIED CODE BELOW NOT REVIEWED YET
// COPIED CODE BELOW NOT REVIEWED YET
// COPIED CODE BELOW NOT REVIEWED YET
/*
if (!isServer) exitWith {}; if (isNil("mgmTfA_Server_Init")) then {mgmTfA_Server_Init=0;}; waitUntil {mgmTfA_Server_Init==1}; private ["_thisFileVerbosityLevelNumber"]; _thisFileVerbosityLevelNumber = mgmTfA_configgv_serverVerbosityLevel;
#include "mgmTfA_s_CO_dat_maleFirstnamesTextStringArray.hpp"

//Initialize local variables
private	[
		"_mgmTfA_s_CO_fnc_returnARandomFirstnameTextStringNameToReturn"
		];
//Undefine return container
_mgmTfA_s_CO_fnc_returnARandomFirstnameTextStringNameToReturn = objNull;
//Pick a random Firstname from requested gender array
_mgmTfA_s_CO_fnc_returnARandomFirstnameTextStringNameToReturn = mgmTfA_staticgv_firstnamesMaleTextStringArray select (floor (random (count mgmTfA_staticgv_firstnamesMaleTextStringArray)));
	if (_thisFileVerbosityLevelNumber>=5) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_fnc_returnARandomFirstnameTextString.sqf]  [TV5]   Reached checkpoint: Bottom of function. The next line will exit the function & return the value. _mgmTfA_s_CO_fnc_returnARandomFirstnameTextStringNameToReturn is set to: (%1).", _mgmTfA_s_CO_fnc_returnARandomFirstnameTextStringNameToReturn];};
//Return the randomly chosen name
_mgmTfA_s_CO_fnc_returnARandomFirstnameTextStringNameToReturn;
*/
// EOF