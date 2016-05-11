//H
//H ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_s_TA_fnc_servicePhase02aa_SendResponse_ChargeTaxiAnywhereInitialBookingFeeRequestActioned.sqf
//H $PURPOSE$		:	This function sends the response that we have just charged the requestor PAYG Tick Cost.
//H ~~
//H
//HH
//HH ~~
//HH	Example usage	:	UPDATE THIS					_null = [_taxiAnywhereRequestorClientIDNumber, _taxiAnywhereRequestorPosition3DArray, _taxiAnywhereRequestorPlayerUIDTextString, _taxiAnywhereRequestorProfileNameTextString] spawn mgmTfA_s_TA_fnc_servicePhase02aa_SendResponse_ChargeTaxiAnywhereInitialBookingFeeRequestActioned;
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
	"_taxiAnywhereRequestorClientIDNumber",
	"_taxiAnywhereRequestorPlayerUIDTextString",
	"_taxiAnywhereRequestorProfileNameTextString",
	"_SUTaxiAIVehicleObject"
	];
_taxiAnywhereRequestorClientIDNumber = (_this select 0);
_taxiAnywhereRequestorPlayerUIDTextString = (_this select 1);
_taxiAnywhereRequestorProfileNameTextString = (_this select 2);

if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA] [mgmTfA_s_TA_fnc_servicePhase02aa_SendResponse_ChargeTaxiAnywhereInitialBookingFeeRequestActioned.sqf]  [TV4] TaxiAnywhere Initial Booking Fee Charge request received. This is what I have received:		_taxiAnywhereRequestorClientIDNumber: (%1).		_taxiAnywhereRequestorPlayerUIDTextString: (%2).		_taxiAnywhereRequestorProfileNameTextString: (%3)", _taxiAnywhereRequestorClientIDNumber, _taxiAnywhereRequestorPlayerUIDTextString, _taxiAnywhereRequestorProfileNameTextString];};//dbg

// Client Communications - Send the message to the Requestor
mgmTfA_gv_pvc_pos_yourclickNGoPAYGInitialBookingFeeChargeRequestActionedPacketSignalOnly = ".";
_taxiAnywhereRequestorClientIDNumber publicVariableClient "mgmTfA_gv_pvc_pos_yourclickNGoPAYGInitialBookingFeeChargeRequestActionedPacketSignalOnly";
if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA] [mgmTfA_s_TA_fnc_servicePhase02aa_SendResponse_ChargeTaxiAnywhereInitialBookingFeeRequestActioned.sqf]  [TV4] SENT RESPONSE    (mgmTfA_gv_pvc_pos_yourclickNGoPAYGInitialBookingFeeChargeRequestActionedPacketSignalOnly) to Requestor:  (%1),		on computer (_taxiAnywhereRequestorClientIDNumber)=(%2).", _taxiAnywhereRequestorProfileNameTextString, _taxiAnywhereRequestorClientIDNumber];};//dbg
if (_thisFileVerbosityLevelNumber>=5) then {diag_log format ["[mgmTfA] [mgmTfA_s_TA_fnc_servicePhase02aa_SendResponse_ChargeTaxiAnywhereInitialBookingFeeRequestActioned.sqf]  [TV5] EXITING SCRIPT NOW."];};//dbg
// EOF