//H
//H ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_SendResponse_ChargePAYGTickCostRequestActioned.sqf
//H $PURPOSE$	:	This function sends the response that we have just charged the requestor PAYG Tick Cost.
//H ~~
//H
//HH
//HH ~~
//HH	Example usage	:	UPDATE THIS					_null	=	[_clickNGoRequestorClientIDNumber, _clickNGoRequestorPosition3DArray, _clickNGoRequestorPlayerUIDTextString, _clickNGoRequestorProfileNameTextString] spawn mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_SendResponse_ChargePAYGTickCostRequestActioned;
//HH	Parameters	:	see the argument parser section below
//HH	Return Value	:	none
//HH ~~
//HH	The server-side master configuration file read (and/or publicVariable publish) the following value(s) this function rely on:
//HH		mgmTfA_configgv_serverVerbosityLevel
//HH		
//HH
//HH	The client-side init file create the following value(s) this function rely on:
//HH		none documented yet
//HH
//HH
if (!isServer) exitWith {}; if (isNil("mgmTfA_Server_Init")) then {mgmTfA_Server_Init=0;}; waitUntil {mgmTfA_Server_Init==1}; private ["_thisFileVerbosityLevelNumber"]; _thisFileVerbosityLevelNumber = mgmTfA_configgv_serverVerbosityLevel;

private	[
		"_clickNGoRequestorClientIDNumber",
		"_clickNGoRequestorPlayerUIDTextString",
		"_clickNGoRequestorProfileNameTextString",
		"_SUTaxiAIVehicleObject"
		];

_clickNGoRequestorClientIDNumber = (_this select 0);
_clickNGoRequestorPlayerUIDTextString = (_this select 1);
_clickNGoRequestorProfileNameTextString = (_this select 2);

if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_SendResponse_ChargePAYGTickCostRequestActioned.sqf]  [TV4] PAYG Charge request received. This is what I have received:		_clickNGoRequestorClientIDNumber: (%1).		_clickNGoRequestorPlayerUIDTextString: (%2).		_clickNGoRequestorProfileNameTextString: (%3)", _clickNGoRequestorClientIDNumber, _clickNGoRequestorPlayerUIDTextString, _clickNGoRequestorProfileNameTextString];};//dbg

// Client Communications - Send the message to the Requestor
mgmTfA_gv_pvc_pos_yourclickNGoPAYGTickCostChargeRequestActionedPacketSignalOnly = ".";
_clickNGoRequestorClientIDNumber publicVariableClient "mgmTfA_gv_pvc_pos_yourclickNGoPAYGTickCostChargeRequestActionedPacketSignalOnly";
if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_SendResponse_ChargePAYGTickCostRequestActioned.sqf]  [TV4] SENT RESPONSE    (mgmTfA_gv_pvc_pos_yourclickNGoPAYGTickCostChargeRequestActionedPacketSignalOnly) to Requestor:  (%1),		on computer (_clickNGoRequestorClientIDNumber)=(%2).", _clickNGoRequestorProfileNameTextString, _clickNGoRequestorClientIDNumber];};//dbg
if (_thisFileVerbosityLevelNumber>=5) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_SendResponse_ChargePAYGTickCostRequestActioned.sqf]  [TV5] EXITING SCRIPT NOW."];};//dbg
// EOF