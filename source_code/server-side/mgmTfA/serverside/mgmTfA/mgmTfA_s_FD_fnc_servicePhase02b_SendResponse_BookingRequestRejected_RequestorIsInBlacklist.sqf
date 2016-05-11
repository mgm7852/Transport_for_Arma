//H
//H ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase02b_SendResponse_BookingRequestRejected_RequestorIsInBlacklist.sqf
//H $PURPOSE$	:	This function process rejected Fixed Destination Taxi requests.
//H ~~
//H
//HH
//HH ~~
//HH	Example usage	:	_null	=	[_fixedDestinationRequestorClientIDNumber, _fixedDestinationRequestorPosition3DArray, _fixedDestinationRequestedTaxiFixedDestinationIDNumber, _fixedDestinationRequestedDestinationNameTextString, _fixedDestinationRequestorPlayerUIDTextString, _fixedDestinationRequestorProfileNameTextString] spawn mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase02b_SendResponse_BookingRequestRejected_RequestorIsInBlacklist;
//HH	Parameters	:	
//HH					// We will not need all these but pass everything for now as we might change the script in the future...
//HH					// Argument #0:		_fixedDestinationRequestorClientIDNumber
//HH					// Argument #1:		_fixedDestinationRequestorPosition3DArray
//HH					// Argument #2:		_fixedDestinationRequestedTaxiFixedDestinationIDNumber
//HH					// Argument #3:		_fixedDestinationRequestedDestinationNameTextString
//HH					// Argument #4:		_fixedDestinationRequestorPlayerUIDTextString
//HH					// Argument #5:		_fixedDestinationRequestorProfileNameTextString
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
		"_fixedDestinationRequestorProfileNameTextString"
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
if (_thisFileVerbosityLevel>=5) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase02b_SendResponse_BookingRequestRejected_RequestorIsInBlacklist.sqf]  [TV5] A REJECTED fixed destination taxi request was FORWARDED to me.			This is the raw full DUMP of what I received:		(str _this) is: (%1).", (str _this)];};//dbg
// this below is NOT a DEBUG msg!
if (_thisFileVerbosityLevel>=4) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase02b_SendResponse_BookingRequestRejected_RequestorIsInBlacklist.sqf]  [TV4] A REJECTED fixed destination taxi request was FORWARDED to me.			This is what I have received:		_fixedDestinationRequestorClientIDNumber: (%1).		_fixedDestinationRequestorPosition3DArray: (%2).		_fixedDestinationRequestedTaxiFixedDestinationIDNumber: (%3) / resolved to locationName: (%4).		_fixedDestinationRequestorPlayerUIDTextString: (%5) / resolved to _fixedDestinationRequestorProfileNameTextString: (%6)", _fixedDestinationRequestorClientIDNumber, _fixedDestinationRequestorPosition3DArray, _fixedDestinationRequestedTaxiFixedDestinationIDNumber, _fixedDestinationRequestedDestinationNameTextString, _fixedDestinationRequestorPlayerUIDTextString, _fixedDestinationRequestorProfileNameTextString];};

// Client Communications - Send the initial "we are processing your request - please wait" message to the Requestor
mgmTfA_gv_pvc_neg_yourFixedDestinationTaxiRequestHasBeenRejectedAsYouAreBlacklistedPacketSignalOnly = ".";
_fixedDestinationRequestorClientIDNumber publicVariableClient "mgmTfA_gv_pvc_neg_yourFixedDestinationTaxiRequestHasBeenRejectedAsYouAreBlacklistedPacketSignalOnly";

// Increment the global counter
mgmTfA_gvdb_PV_fixedDestinationTaxisTotalRequestsRejectedDueToBlacklistNumber = mgmTfA_gvdb_PV_fixedDestinationTaxisTotalRequestsRejectedDueToBlacklistNumber + 1;
// Broadcast the value to all computers
publicVariable "mgmTfA_gvdb_PV_fixedDestinationTaxisTotalRequestsRejectedDueToBlacklistNumber";
// this below is NOT a DEBUG msg!
if (mgmTfA_configgv_serverVerbosityLevel>=4) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase02b_SendResponse_BookingRequestRejected_RequestorIsInBlacklist.sqf]  [TV4] Just incremented & pV broadcasted (mgmTfA_gvdb_PV_fixedDestinationTaxisTotalRequestsRejectedDueToBlacklistNumber). After the increment, now it is: (%1)", (str mgmTfA_gvdb_PV_fixedDestinationTaxisTotalRequestsRejectedDueToBlacklistNumber)];};

// this below is NOT a DEBUG msg!
// Let the log know
if (mgmTfA_configgv_serverVerbosityLevel>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase02b_SendResponse_BookingRequestRejected_RequestorIsInBlacklist.sqf]  [TV3] A Blacklisted Requestor has just been rejected!	(%1) wanted to go to (%2) but we've refused to serve him of course!", _fixedDestinationRequestorProfileNameTextString, _fixedDestinationRequestedDestinationNameTextString];};
// EOF