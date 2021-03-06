//H
//H
//H ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_c_TA_fnc_keepRequesting1stMileFeePayment.sqf
//H $PURPOSE$	:	This function will be spawn'd with one argument only SU ID (GUSUIDNumber) and it will keep asking for 1st Mile Fee payment every second via systemChat (until commandingCustomer pays this via GUI button or via ActionMenu or alternatively until the phase timeouts) 
//H ~~
//H
//HH
//H ~~
//HH	Syntax		:	_null = [SU_ID] mgmTfA_c_TA_fnc_keepRequesting1stMileFeePayment
//HH	Parameters	:	GUSUIDNumber Globally Unique Service Unit ID number		Number		Examples: 1, 2, 5, 384, 384728473
//HH	Return Value	:	Nothing	[outputs to client's local map]
//H ~~
//HH	The shared configuration file has the following values this function rely on:
//HH		mgmTfA_configgv_clientVerbosityLevel
//HH		mgmTfA_configgv_taxiAnywhereTaxisAbsoluteMinimumJourneyFeeInCryptoNumber
//HH	This function does not create/update any global variables.
//HH	This function does rely on one publicVariable containing the information about the Service Unit:	mgmTfA_gv_PV_SU%1SUTA1stMileFeeNeedToBePaidBool
//HH		For example, for Service Unit 27, the publicVariables would be:
//HH		mgmTfA_gv_PV_SU27SUTA1stMileFeeNeedToBePaidBool
//HH
if (isServer) exitWith {}; if (isNil("mgmTfA_Client_Init")) then {mgmTfA_Client_Init=0;}; waitUntil {mgmTfA_Client_Init==1}; private ["_thisFileVerbosityLevelNumber"]; _thisFileVerbosityLevelNumber = mgmTfA_configgv_clientVerbosityLevel;
scopeName "mgmTfA_c_TA_fnc_keepRequesting1stMileFeePaymentMainScope";
if (!isServer) then { waitUntil {!isnull (finddisplay 46)}; };

// this script should be instant - thus the copied uiSleep is not appropriate. DELAYED DELETE THIS. 			// lame workaround to prevent the scenario where our SU's data has not been publicVariable broadcasted yet -- we will need a proper solution for this in a later version
// this script should be instant - thus the copied uiSleep is not appropriate. DELAYED DELETE THIS. 			uiSleep 5;
private	[
		"_continueRequesting1stMileFeePayment",
		"_originalVehiclesGUSUIDNumber",
		"_currentVehiclesGUSUIDNumber",
		"_counterTen",
		"_counterInfinite",
		"_msg2SyschatTextString",
		"_classnameOfTheCurrentVehicle"
		];
// if we have been signalled by mgmTfA_c_CO_scr_initRegisterClientEventHandlers, that means this is initially TRUE
_continueRequesting1stMileFeePayment = true;
// debug slow down counter
_counterTen = 0;
// this is not reminder count. it is seconds passed count. if customer gets out and back in the vehicle it will show seconds - not reminder ID!
_counterInfinite = 0;
_originalVehiclesGUSUIDNumber = _this select 0;
// log it		-- do not move this line any higher!
if (_thisFileVerbosityLevelNumber>=10) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_fnc_keepRequesting1stMileFeePayment.sqf]  [TV10]	BEGIN RUNNING FUNCTION		I will  keep requesting 1st Mile Fee Payment till it is paid or phase timeout, for SU: (%1).", (str _originalVehiclesGUSUIDNumber)];};

//// Begin looping the main loop -- we will keep looping as long as ""mgmTfA_gv_PV_SU%1SUTA1stMileFeeNeedToBePaidBool" is true		-- it can be false only if (a) paid, or (b) phase time out
while {_continueRequesting1stMileFeePayment} do
{
	// DEBUG SLOW DOWN
	_counterTen = _counterTen + 1;
	_counterInfinite = _counterInfinite + 1;
	if (_counterTen >= 10) then {
		if (_thisFileVerbosityLevelNumber>=10) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_fnc_keepRequesting1stMileFeePayment.sqf]  [TV10] Reached checkpoint: Running main loop. Now executing the very top, just above sleep."];};
		_counterTen = 0;
	};
	// sleep a sec
	uiSleep 1;
	// STEP1:	Obtain Latest Information and Update Local Variables Accordingly
	// inside loop evaluation -- Are we supposed to terminate now?
	_continueRequesting1stMileFeePayment = call compile format ["mgmTfA_gv_PV_SU%1SUTA1stMileFeeNeedToBePaidBool", _originalVehiclesGUSUIDNumber];
	// log the result
	if(_continueRequesting1stMileFeePayment) then {
		// YES continue requesting payment
		if (_thisFileVerbosityLevelNumber>=10) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_fnc_keepRequesting1stMileFeePayment.sqf] [TV10] This is _originalVehiclesGUSUIDNumber: (%1)		INSIDE LOOP EVALUATION 		(_continueRequesting1stMileFeePayment) is: (%2)		I WILL CONTINUE LOOPING	", (str _originalVehiclesGUSUIDNumber), (str _continueRequesting1stMileFeePayment)];};
		// REQUEST PAYMENT ONLY if customer currently in a TaxiAnywhere Taxi
		// Get current vehicle's Classname
		_classnameOfTheCurrentVehicle = typeOf (vehicle player);
		// STEP2:	Compare current vehicle's Classname with the pre-defined Taxi Classname, if it matches, proceed down the work flow. Otherwise do nothing.
		if (mgmTfA_configgv_taxiAnywhereTaxisTaxiVehicleClassnameTextString == _classnameOfTheCurrentVehicle) then {
			// STEP3: Is the player in this particular TaxiAnywhere vehicle now? (he might have hopped out and got in a friend's Taxi!)
			// NOTE that this is currently impossible to happen as doors are autolocked and requestor can never get back in anyway -- adding the checks to future proof the code
			_currentVehiclesGUSUIDNumber = ((vehicle player) getVariable "GUSUIDNumber");
			//Compare current vehicle's GUSUID with the supplied-as-parameter GUSUID; if they match, message the player. Otherwise do nothing.
			if (_originalVehiclesGUSUIDNumber == _currentVehiclesGUSUIDNumber) then {
				_msg2SyschatTextString = parsetext format ["[DRIVER]  PLEASE PAY THE 1ST MILE FEE %1 CRYPTO, THANKS!  [%2]", (str mgmTfA_configgv_taxiAnywhereTaxisAbsoluteMinimumJourneyFeeInCryptoNumber), (str _counterInfinite)];
				systemChat (str _msg2SyschatTextString);
				if (mgmTfA_configgv_clientVerbosityLevel>=10) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_fnc_keepRequesting1stMileFeePayment.sqf]  [TV10]          VEHICLE COMPARISON MATCHED:		the (str _originalVehiclesGUSUIDNumber) is: (%1) == (str _currentVehiclesGUSUIDNumber) is: (%2)					-- 'please pay the 1st Mile Fee' reminder sent to requestor	", (str _originalVehiclesGUSUIDNumber), (str _currentVehiclesGUSUIDNumber)];};
			} else {
				//Player is not in a Taxi vehicle at the moment
				//Do not display anything about Taxi's doors being locked/unlocked
				if (mgmTfA_configgv_clientVerbosityLevel>=10) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_fnc_keepRequesting1stMileFeePayment.sqf]  [TV10]          VEHICLE COMPARISON DID NOT MATCH:		the (str _originalVehiclesGUSUIDNumber) is: (%1) != (str _currentVehiclesGUSUIDNumber) is: (%2)		.", (str _originalVehiclesGUSUIDNumber), (str _currentVehiclesGUSUIDNumber)];};
			};
		} else {
			//Player is not in a TaxiAnywhere vehicle at the moment		-- DO NOT remind that he must pay 1st Mile Fee
		};
	} else {
		// NO DO NOT request payment any more - we are terminating!
		if (_thisFileVerbosityLevelNumber>=10) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_fnc_keepRequesting1stMileFeePayment.sqf] [TV10] This is _originalVehiclesGUSUIDNumber: (%1)		INSIDE LOOP EVALUATION 		(_continueRequesting1stMileFeePayment) is: (%2)		I WILL TERMINATE NOW	", (str _originalVehiclesGUSUIDNumber), (str _continueRequesting1stMileFeePayment)];};
		// Exit the loops, go back to main, from where we will terminate AFTER writing to log.
		breakTo "mgmTfA_c_TA_fnc_keepRequesting1stMileFeePaymentMainScope";
	};
};
if (_thisFileVerbosityLevelNumber>=10) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_fnc_keepRequesting1stMileFeePayment.sqf] [TV10] This is _originalVehiclesGUSUIDNumber: (%1)		THIS IS THE LAST LINE. TERMINATING.", (str _originalVehiclesGUSUIDNumber)];};
// EOF