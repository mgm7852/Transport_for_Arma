//H
//H ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_fnc_client_doProcessFixedDestinationTaxiAddActionWork.sqf
//H $PURPOSE$	:	This function __________undocumented_________
//H ~~
//H
//HH
//HH ~~
//HH	Syntax		:	_null = [SU_ID] mgmTfA_fnc_client_doProcessFixedDestinationTaxiAddActionWork
//HH	Parameters	:	see below
//HH	Return Value	:	undocumented
//HH ~~
//HH	The shared configuration file has the following values this function rely on: none
//HH	This function does not create/update any global variables.
//HH	This function does rely on publicVariables containing the information about the Service Unit.
//HH		TODO: populate this list here
//HH
if (isServer) exitWith {}; if (isNil("mgmTfA_Client_Init")) then {mgmTfA_Client_Init=0;}; waitUntil {mgmTfA_Client_Init==1}; private ["_thisFileVerbosityLevelNumber"]; _thisFileVerbosityLevelNumber = mgmTfA_configgv_clientVerbosityLevel;

if (!isServer) then {
private		[
			"_VehEntered",
			"_myGUSUIDNumber",
			"_mgmTfAActionIDPayFDTServiceFeeAction"
			];
if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_client_doProcessFixedDestinationTaxiAddActionWork.sqf]  [TV8] 		DEVDEBUG		I have been SPAWN'd.	This is what I have received:	(%1).", (str _this)];};//dbg
// passed vehicle player got in
_VehEntered = (_this select 0);
// passed argument
_myGUSUIDNumber = (_this select 1);
// add the Action to the vehicle, save the action ID in a local variable
_mgmTfAActionIDPayFDTServiceFeeAction = _VehEntered addAction ["<img image='custom\mgmTfA\mgmTfA_ico_client_taxiPayment.paa' /><t color=""#FF0000""> Pay Now</t>", "custom\mgmTfA\mgmTfA_scr_client_fixedDestinationTaxiPayNow.sqf",[_VehEntered], -5, false, true,"", "(vehicle player) == _target"];
if (_thisFileVerbosityLevelNumber>=7) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_client_doProcessFixedDestinationTaxiAddActionWork.sqf] [TV7] 		DEVDEBUG		(str _mgmTfAActionIDPayFDTServiceFeeAction) is:	(%1).", (str _mgmTfAActionIDPayFDTServiceFeeAction)];};//dbg
// save actionID
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%SUActionIDPointer", _myGUSUIDNumber], _mgmTfAActionIDPayFDTServiceFeeAction];
publicVariable format ["mgmTfA_gv_PV_SU%SUActionIDPointer", _myGUSUIDNumber];
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUfdTxPayNowMenuIsCurrentlyNotAttachedBool", _myGUSUIDNumber], true];
publicVariable format ["mgmTfA_gv_PV_SU%1SUfdTxPayNowMenuIsCurrentlyNotAttachedBool", _myGUSUIDNumber];
if (_thisFileVerbosityLevelNumber>=7) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_client_doProcessFixedDestinationTaxiAddActionWork.sqf] [TV7]		DEVDEBUG		Just added the addAction now & publicVariable broadcasted the change		to (str _myGUSUIDNumber): (%1),		at: (%2) seconds uptime.", (str _myGUSUIDNumber), (str time)];};//dbg
mgmTfA_dynamicgv_listOfFixedDestinationTaxisThatWeHaveAddedActionMenuOptionTextStringArray pushBack _myGUSUIDNumber;
};
// EOF