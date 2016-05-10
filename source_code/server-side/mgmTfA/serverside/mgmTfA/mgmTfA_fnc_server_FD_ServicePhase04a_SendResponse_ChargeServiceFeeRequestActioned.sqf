//H
//H ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_fnc_server_FD_ServicePhase04a_SendResponse_ChargeServiceFeeRequestActioned.sqf
//H $PURPOSE$	:	This function sends the response that we have just charged the requestor FixedDestinationTaxi Service Fee
//H ~~
//H
//HH
//HH ~~
//HH	Example usage	:	UPDATE THIS					_null	=	[_FD_RequestorClientIDNumber, _FD_RequestorPosition3DArray, _FD_RequestorPlayerUIDTextString, _FD_RequestorProfileNameTextString] spawn mgmTfA_fnc_server_FD_ServicePhase04a_SendResponse_ChargeServiceFeeRequestActioned;
//HH	Parameters		:	UPDATE THIS					see the argument parser section below
//HH	Return Value	:	UPDATE THIS					none
//HH ~~
//HH	UPDATE THIS		The server-side master configuration file read (and/or publicVariable publish) the following value(s) this function rely on:
//HH	UPDATE THIS			mgmTfA_configgv_serverVerbosityLevel
//HH		
//HH
//HH	UPDATE THIS		The client-side init file create the following value(s) this function rely on:
//HH	UPDATE THIS		none documented yet
//HH
//HH
if (!isServer) exitWith {}; if (isNil("mgmTfA_Server_Init")) then {mgmTfA_Server_Init=0;}; waitUntil {mgmTfA_Server_Init==1}; private ["_thisFileVerbosityLevelNumber"]; _thisFileVerbosityLevelNumber = mgmTfA_configgv_serverVerbosityLevel;

private	[
		"_FD_RequestorClientIDNumber",
		"_FD_RequestorPlayerUIDTextString",
		"_FD_RequestorProfileNameTextString"
		];

_FD_RequestorClientIDNumber = (_this select 0);
_FD_RequestorPlayerUIDTextString = (_this select 1);
_FD_RequestorProfileNameTextString = (_this select 2);

if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_FD_ServicePhase04a_SendResponse_ChargeServiceFeeRequestActioned.sqf]  [TV4] FIXED DESTINATION TAXI SERVICE FEE CHARGE request received. This is what I have received:		_FD_RequestorClientIDNumber: (%1).		_FD_RequestorPlayerUIDTextString: (%2).		_FD_RequestorProfileNameTextString: (%3).	", (str _FD_RequestorClientIDNumber), _FD_RequestorPlayerUIDTextString, _FD_RequestorProfileNameTextString];};//dbg

// Client Communications - Send the message to the Requestor
mgmTfA_gv_pvc_pos_yourFDServiceFeeChargeRequestActionedPacketSignalOnly = ".";
_FD_RequestorClientIDNumber publicVariableClient "mgmTfA_gv_pvc_pos_yourFDServiceFeeChargeRequestActionedPacketSignalOnly";
if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_FD_ServicePhase04a_SendResponse_ChargeServiceFeeRequestActioned.sqf]  [TV4] SENT RESPONSE    (mgmTfA_gv_pvc_pos_yourFDServiceFeeChargeRequestActionedPacketSignalOnly) to Requestor:  (%1),		on computer (_FD_RequestorClientIDNumber)=(%2).", _FD_RequestorProfileNameTextString, (str _FD_RequestorClientIDNumber)];};//dbg
if (_thisFileVerbosityLevelNumber>=5) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_FD_ServicePhase04a_SendResponse_ChargeServiceFeeRequestActioned.sqf]  [TV5] EXITING SCRIPT NOW."];};//dbg
// EOF