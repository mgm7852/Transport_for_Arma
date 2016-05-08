//H
//H ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_fnc_client_doProcessclickNGoTaxiAddActionWork.sqf
//H $PURPOSE$	:	This function __________undocumented_________
//H ~~
//H
//HH
//HH ~~
//HH	Syntax		:	_null = [SU_ID] mgmTfA_fnc_client_doProcessclickNGoTaxiAddActionWork
//HH	Parameters	:	see below
//HH	Return Value	:	undocumented
//HH ~~
//HH	The shared configuration file has the following values this function rely on: none
//HH	This function does not create/update any global variables.
//HH	This function does rely on publicVariables containing the information about the Service Unit.
//HH		TODO: populate this list here
//HH
waitUntil {mgmTfA_Client_Init==1};
if (!isServer) then {
private		[
			"_thisFileVerbosityLevelNumber",
			"_VehEntered",
			"_myGUSUIDNumber",
			"_mgmTfAActionIDPayPAYGInitialFeeAction"
			];
_thisFileVerbosityLevelNumber = 0;
// passed vehicle player got in
_VehEntered = (_this select 0);
// passed argument
_myGUSUIDNumber = (_this select 1);
// add the Action to the vehicle, save the action ID in a local variable
_mgmTfAActionIDPayPAYGInitialFeeAction = _VehEntered addAction ["<img image='custom\mgmTfA\mgmTfA_ico_client_taxiPayment.paa' /><t color=""#FF0000""> Pay PAYG Initial Fee</t>", "custom\mgmTfA\mgmTfA_scr_client_clickNGoTaxiPayNow.sqf",[_VehEntered], -5, false, true,"", "(vehicle player) == _target"];
// save actionID
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%SUActionIDPointer", _myGUSUIDNumber], _mgmTfAActionIDPayPAYGInitialFeeAction];
publicVariable format ["mgmTfA_gv_PV_SU%SUActionIDPointer", _myGUSUIDNumber];
};
// EOF