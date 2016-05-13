//H
//H ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_s_FD_fnc_servicePhase02a_SendResponse_BookingRequestAccepted.sqf
//H $PURPOSE$	:	This function process accepted Fixed Destination Taxi requests. It does the prep work and pass the request down in the workflow.
//H ~~
//H
//HH
//HH ~~
//HH	Example usage	:	_null	=	[_fixedDestinationRequestorClientIDNumber, _fixedDestinationRequestorPosition3DArray, _fixedDestinationRequestedTaxiFixedDestinationIDNumber, _fixedDestinationRequestedDestinationNameTextString, _fixedDestinationRequestorPlayerUIDTextString, _fixedDestinationRequestorProfileNameTextString] spawn mgmTfA_s_FD_fnc_servicePhase02a_SendResponse_BookingRequestAccepted;
//HH	Parameters	:	see the argument parser section below
//HH	Return Value	:	none	[this function spawns the next function in "Fixed Destination Taxi - Service Request - Workflow"
//HH ~~
//HH	The server-side master configuration file read (and/or publicVariable publish) the following value(s) this function rely on:
//HH		mgmTfA_configgv_serverVerbosityLevel
//HH		
//HH
//HH	The client-side init file create the following value(s) this function rely on:
//HH		none documented yet
//HH
//HH	Note: we will send an initial "we are processing your request - please wait" message to the Requestor
//HH	Note: we will send the FINAL confirmation to the Requestor ONLY AFTER successfully creating the SU (vehicle+driver).
//HH
if (!isServer) exitWith {}; if (isNil("mgmTfA_Server_Init")) then {mgmTfA_Server_Init=0;}; waitUntil {mgmTfA_Server_Init==1}; private ["_thisFileVerbosityLevelNumber"]; _thisFileVerbosityLevelNumber = mgmTfA_configgv_serverVerbosityLevel;
private	[
		"_fixedDestinationRequestorClientIDNumber",
		"_fixedDestinationRequestorPosition3DArray",
		"_fixedDestinationRequestedTaxiFixedDestinationIDNumber",
		"_fixedDestinationRequestedDestinationNameTextString",
		"_fixedDestinationRequestorPlayerUIDTextString",
		"_fixedDestinationRequestorProfileNameTextString",
		"_positionToSpawnSUVehiclePosition3DArray"
		];

//Debug level for this file
_thisFileVerbosityLevelNumber = mgmTfA_configgv_serverVerbosityLevel;
//// Prep Function Arguments
_fixedDestinationRequestorClientIDNumber = (_this select 0);
_fixedDestinationRequestorPosition3DArray = (_this select 1);
_fixedDestinationRequestedTaxiFixedDestinationIDNumber = (_this select 2);
_fixedDestinationRequestedDestinationNameTextString = (_this select 3);
_fixedDestinationRequestorPlayerUIDTextString = (_this select 4);
_fixedDestinationRequestorProfileNameTextString = (_this select 5);
if (_thisFileVerbosityLevelNumber>=2) then {diag_log format ["[mgmTfA] [mgmTfA_s_FD_fnc_servicePhase02a_SendResponse_BookingRequestAccepted.sqf]  [TV2] An ACCEPTED fixed destination taxi request was FORWARDED to me.			This is what I have received:		_fixedDestinationRequestorClientIDNumber: (%1).		_fixedDestinationRequestorPosition3DArray: (%2).		_fixedDestinationRequestedTaxiFixedDestinationIDNumber: (%3) / resolved to locationName: (%4).		_fixedDestinationRequestorPlayerUIDTextString: (%5) / resolved to profileName: (%6)", _fixedDestinationRequestorClientIDNumber, _fixedDestinationRequestorPosition3DArray, _fixedDestinationRequestedTaxiFixedDestinationIDNumber, _fixedDestinationRequestedDestinationNameTextString, _fixedDestinationRequestorPlayerUIDTextString, _fixedDestinationRequestorProfileNameTextString];};//dbg

// Find random coordinates to spawn the new SU -- we will NOT spawn a vehicle here however we will pass this to the next function in workflow
_positionToSpawnSUVehiclePosition3DArray=objNull;
_positionToSpawnSUVehiclePosition3DArray=[mgmTfA_configgv_fixedDestinationTaxisSpawnDistanceRadiusInMetresNumber,mgmTfA_configgv_fixedDestinationTaxisSpawnDistanceRadiusMinDistanceInMetresNumber, _fixedDestinationRequestorPosition3DArray] call mgmTfA_s_CO_fnc_returnNearbyRandomOnRoadPosition3DArray;
//TODO: Add a check here:		if _ranPos encountered an issue it will return	"[-1,-1,-1]". 	Check, and if that's the case, kill the process. 	Inform the Requestor (We are having technical issues please try again later and if you encounter this issue again, notify the server admin.)
if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_s_FD_fnc_servicePhase02a_SendResponse_BookingRequestAccepted.sqf]  [TV3] _positionToSpawnSUVehiclePosition3DArray random position is randomly chosen as (%1)", _positionToSpawnSUVehiclePosition3DArray];};

// We are about to create a new SU, time to increment the global counter:	GUSUID		Globally Unique Service Unit ID Number 
mgmTfA_gvdb_PV_GUSUIDNumber = mgmTfA_gvdb_PV_GUSUIDNumber + 1;
// Broadcast the value to all computers: this is done ONLY (during  startup, in server-side init) && (after the server startup, it is done only in: mgmTfA_s_CO_fnc_publicVariableBroadcastSUInformationInitialBroadcast.sqf)
// Note that "mgmTfA_s_FD_fnc_servicePhase03_CreateServiceUnitAndGoToRequestor.sqf"	will call "mgmTfA_s_CO_fnc_publicVariableBroadcastSUInformationInitialBroadcast"
//We will work with the current index number. It might change any time therefore let's save it to a local variable immediately.
_myGUSUIDNumber= mgmTfA_gvdb_PV_GUSUIDNumber;
if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_s_FD_fnc_servicePhase02a_SendResponse_BookingRequestAccepted.sqf]  [TV3] <ThisIs:%1> mgmTfA_gvdb_PV_GUSUIDNumber has been incremented; new value is: (%2)", _myGUSUIDNumber, mgmTfA_gvdb_PV_GUSUIDNumber];};//dbg


// Client Communications - Send the initial "we are processing your request - please wait" message to the Requestor
mgmTfA_gv_pvc_pos_processingYourFixedDestinationTaxiRequestPleaseWaitPacketSignalOnly = ".";
_fixedDestinationRequestorClientIDNumber publicVariableClient "mgmTfA_gv_pvc_pos_processingYourFixedDestinationTaxiRequestPleaseWaitPacketSignalOnly";
if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_s_FD_fnc_servicePhase02a_SendResponse_BookingRequestAccepted.sqf]  [TV3] <ThisIs:%1> SENT RESPONSE    (mgmTfA_gv_pvc_pos_processingYourFixedDestinationTaxiRequestPleaseWaitPacketSignalOnly) to Requestor:  (%2),		on computer (_fixedDestinationRequestorClientIDNumber)=(%3).", _myGUSUIDNumber, _fixedDestinationRequestorProfileNameTextString, _fixedDestinationRequestorClientIDNumber];};//dbg

//// ACL work
// TODO: we have a TEMP OVERRIDE here with 1>0 :)
if (1>0) then {

	//Define a new most-inner scope local variable
	private ["_requestorAndBuddiesCombinedSUACLTextStringArray"];

	// Initialize as empty array
	_requestorAndBuddiesCombinedSUACLTextStringArray = [];

	// DO NOT EMBED totalOmniscience group here. Right after Drop Off occur, we will want to know whether map-tracker is map-track authorized due to being requestor (or his buddy) OR because of totalOmniscience group membership.
	// Add PUIDs from "totalOmniscience group" array
	//_requestorAndBuddiesCombinedSUACLTextStringArray = mgmTfA_staticgv_totalOmniscienceGroupTextStringArray;

	// Add requestor PUID to the end of the array
	_requestorAndBuddiesCombinedSUACLTextStringArray pushBack _fixedDestinationRequestorPlayerUIDTextString;
	if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_s_FD_fnc_servicePhase02a_SendResponse_BookingRequestAccepted.sqf]  [TV3] <ThisIs:%1> I have created a new _requestorAndBuddiesCombinedSUACLTextStringArray by adding _fixedDestinationRequestorPlayerUIDTextString. The contents of _requestorAndBuddiesCombinedSUACLTextStringArray is: (%2).", _myGUSUIDNumber, _requestorAndBuddiesCombinedSUACLTextStringArray];};

	// setVariable it
	missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUACLTextStringArray", mgmTfA_gvdb_PV_GUSUIDNumber], _requestorAndBuddiesCombinedSUACLTextStringArray]; 

	// destroy the temporarily needed local variable _requestorAndBuddiesCombinedSUACLTextStringArray as we are done with it
};

// Proceed to next Phase:		Service Unit Creation		"mgmTfA_s_FD_fnc_servicePhase03_CreateServiceUnit"
_null = [_fixedDestinationRequestorClientIDNumber, _fixedDestinationRequestorPosition3DArray, _fixedDestinationRequestedTaxiFixedDestinationIDNumber, _fixedDestinationRequestedDestinationNameTextString, _fixedDestinationRequestorPlayerUIDTextString, _fixedDestinationRequestorProfileNameTextString, _positionToSpawnSUVehiclePosition3DArray, _myGUSUIDNumber] spawn mgmTfA_s_FD_fnc_servicePhase03_CreateServiceUnitAndGoToRequestor;
if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_s_FD_fnc_servicePhase02a_SendResponse_BookingRequestAccepted.sqf]  [TV3] <ThisIs:%1> I have spawn'd `mgmTfA_s_FD_fnc_servicePhase03_CreateServiceUnit`. I'm quitting now.", _myGUSUIDNumber];};
// EOF