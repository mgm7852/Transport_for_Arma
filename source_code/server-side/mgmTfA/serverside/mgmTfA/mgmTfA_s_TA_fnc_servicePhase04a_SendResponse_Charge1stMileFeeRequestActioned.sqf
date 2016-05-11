//H
//H ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_s_TA_fnc_servicePhase04a_SendResponse_Charge1stMileFeeRequestActioned.sqf
//H $PURPOSE$	:	This function sends the response that we have just charged the requestor TaxiAnywhere 1st Mile Fee
//H ~~
//H
//HH
//HH ~~
//HH	Example usage	:	UPDATE THIS					_null	=	[_taxiAnywhereRequestorClientIDNumber, _taxiAnywhereRequestorPosition3DArray, _taxiAnywhereRequestorPlayerUIDTextString, _taxiAnywhereRequestorProfileNameTextString] spawn mgmTfA_s_TA_fnc_servicePhase04a_SendResponse_Charge1stMileFeeRequestActioned;
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
		"_taxiAnywhereRequestorClientIDNumber",
		"_taxiAnywhereRequestorPlayerUIDTextString",
		"_taxiAnywhereRequestorProfileNameTextString"
		];

_taxiAnywhereRequestorClientIDNumber = (_this select 0);
_taxiAnywhereRequestorPlayerUIDTextString = (_this select 1);
_taxiAnywhereRequestorProfileNameTextString = (_this select 2);

if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA] [mgmTfA_s_TA_fnc_servicePhase04a_SendResponse_Charge1stMileFeeRequestActioned.sqf]  [TV4] TAXI ANYWHERE Charge request received. This is what I have received:		_taxiAnywhereRequestorClientIDNumber: (%1).		_taxiAnywhereRequestorPlayerUIDTextString: (%2).		_taxiAnywhereRequestorProfileNameTextString: (%3)", (str _taxiAnywhereRequestorClientIDNumber), _taxiAnywhereRequestorPlayerUIDTextString, _taxiAnywhereRequestorProfileNameTextString];};//dbg

// Client Communications - Send the message to the Requestor
mgmTfA_gv_pvc_pos_yourTaxiAnywhere1stMileFeeChargeRequestActionedPacketSignalOnly = ".";
_taxiAnywhereRequestorClientIDNumber publicVariableClient "mgmTfA_gv_pvc_pos_yourTaxiAnywhere1stMileFeeChargeRequestActionedPacketSignalOnly";
if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA] [mgmTfA_s_TA_fnc_servicePhase04a_SendResponse_Charge1stMileFeeRequestActioned.sqf]  [TV4] SENT RESPONSE    (mgmTfA_gv_pvc_pos_yourTaxiAnywhere1stMileFeeChargeRequestActionedPacketSignalOnly) to Requestor:  (%1),		on computer (_taxiAnywhereRequestorClientIDNumber)=(%2).", _taxiAnywhereRequestorProfileNameTextString, (str _taxiAnywhereRequestorClientIDNumber)];};//dbg
if (_thisFileVerbosityLevelNumber>=5) then {diag_log format ["[mgmTfA] [mgmTfA_s_TA_fnc_servicePhase04a_SendResponse_Charge1stMileFeeRequestActioned.sqf]  [TV5] EXITING SCRIPT NOW."];};//dbg
// EOF