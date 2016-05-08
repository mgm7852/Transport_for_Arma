//H
//H ~~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_fnc_client_clickNGoContinuouslyRequestPayment.sqf
//H $PURPOSE$	:	Client side script continuously requesting payment from the requestor
//H ~~~
//H			relies on mgmTfA_scr_client_clickNGoTaxiPayNow.sqf
private ["_thisFileVerbosityLevelNumber"];
_thisFileVerbosityLevelNumber = mgmTfA_configgv_clientVerbosityLevel;
if (isServer) exitWith {};
if (!isServer) then {
	waitUntil {!isnull (finddisplay 46)};
	//--
	if (isNil("mgmTfA_Client_Init")) then {
		mgmTfA_Client_Init=0;
	};
	waitUntil {mgmTfA_Client_Init==1};
	//--
};
if (!(isNil "mgmTfA_fnc_client_clickNGoContinuouslyRequestPaymentIsRunningBool")) exitWith {};
scopeName "mgmTfA_fnc_client_clickNGoContinuouslyRequestPaymentMainScope";
mgmTfA_fnc_client_clickNGoContinuouslyRequestPaymentIsRunningBool = true;
private	[
		"_counterInSecondsNumber",
		"_SUcNGoTxServiceFeeHasBeenPaidBool",
		"_myGUSUIDNumber",
		"_msg2SyschatTextString",
		"_keepGoingNumber"
		];
_counterInSecondsNumber = 0;
_keepGoingNumber = 1;
_SUcNGoTxServiceFeeHasBeenPaidBool = false;

_myGUSUIDNumber = ((vehicle player) getVariable ["GUSUIDNumber", -1]);
if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA]  [mgmTfA_fnc_client_clickNGoContinuouslyRequestPayment.sqf] [TV4] _myGUSUIDNumber has been obtained as: (%1)", (str _myGUSUIDNumber)];};
_SUcNGoTxServiceFeeHasBeenPaidBool = call compile format ["mgmTfA_gv_PV_SU%1SUcNGoTxServiceFeeHasBeenPaidBool", _myGUSUIDNumber];
if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA]  [mgmTfA_fnc_client_clickNGoContinuouslyRequestPayment.sqf] [TV4] 1SUcNGoTxServiceFeeHasBeenPaidBool has been obtained as: (%1)", (str _SUcNGoTxServiceFeeHasBeenPaidBool)];};

// main loop
while {_keepGoingNumber > 0} do {
	// top level uiSleep is at the bottom -- keep it there!
	
	// we will continue looping for the next 60 seconds unless loop issues breaktTo and escapes
	// looping won't necessarily mean we will keep printing a new message every second -- we will re-issue the "display message" command only if conditions are met
	if (_counterInSecondsNumber <=60) then {
		uiSleep 1;

		_counterInSecondsNumber  = _counterInSecondsNumber + 1;
		
		// is the player in a clickNGoTaxi at the moment?
		if ((vehicle player) getVariable ["mgmTfAisclickNGoTaxi", false]) then {
			// YES, player IS IN a clickNGo taxi vehicle -- log it
			if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA]  [mgmTfA_fnc_client_clickNGoContinuouslyRequestPayment.sqf] [TV4] Player IS in a clickNGo vehicle.		(_counterInSecondsNumber) is: (%1).", (str _counterInSecondsNumber)];};
			// get the GUSUIDNumber
			_myGUSUIDNumber = ((vehicle player) getVariable ["GUSUIDNumber", -1]);
			if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA]  [mgmTfA_fnc_client_clickNGoContinuouslyRequestPayment.sqf] [TV4] _myGUSUIDNumber has been obtained as: (%1)", (str _myGUSUIDNumber)];};
			// Is this vehicle's Initial Fee been paid yet?
			// if we can't read it for some reason, assume a "NO"
			_SUcNGoTxServiceFeeHasBeenPaidBool = false;
			_SUcNGoTxServiceFeeHasBeenPaidBool = call compile format ["mgmTfA_gv_PV_SU%1SUcNGoTxServiceFeeHasBeenPaidBool"						, _myGUSUIDNumber];
			if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA]  [mgmTfA_fnc_client_clickNGoContinuouslyRequestPayment.sqf] [TV4] 1SUcNGoTxServiceFeeHasBeenPaidBool has been obtained as: (%1)", (str _SUcNGoTxServiceFeeHasBeenPaidBool)];};

			// paid or not? action accordingly...
			if (_SUcNGoTxServiceFeeHasBeenPaidBool) then {
				// YES, Initial Fee has already been paid, there is nothing to be done.
				// HOWEVER do not terminate. 
				// If, by the off chance, there are more than clickNGo vehicles around, and if the player has got into another requestor's vehicle first, then, if we shut down now, he won't be able to pay his after getting out of the other one and gets in to his Taxi. 
				// Just keep looping and waiting till 60 seconds threshold is over -- allowing him some time window to manoeuvre
				// log & keep looping
				if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA]  [mgmTfA_fnc_client_clickNGoContinuouslyRequestPayment.sqf] [TV4] Player IS in a clickNGo vehicle	and	Initial Fee		has already been paid. I will just keep looping till time threshold is exceeded...		(_counterInSecondsNumber) is: (%1).", (str _counterInSecondsNumber)];};
			} else {
				// NO, Initial Fee has NOT been paid yet -- log it
				if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA]  [mgmTfA_fnc_client_clickNGoContinuouslyRequestPayment.sqf] [TV4] Player IS in a clickNGo vehicle	and	Initial Fee		has NOT been paid. if enabled in Settings, I will present a reminder now and keep looping.		(_counterInSecondsNumber) is: (%1).", (str _counterInSecondsNumber)];};
				// if settings require us to display a reminder, let's do it
				if (mgmTfA_configgv_clickNGoTaxisDriverWillKeepRemindingThatTheInitialFeeMustBePaidBool) then {
					_msg2SyschatTextString 								= parsetext format ["%1 PLEASE PAY THE INITIAL FEE TO PROCEED... [reminderID %2]", (profileName), (str _counterInSecondsNumber)];
					systemChat										(str _msg2SyschatTextString);
					if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA]  [mgmTfA_fnc_client_clickNGoContinuouslyRequestPayment.sqf] [TV4] As configured in settings (mgmTfA_configgv_clickNGoTaxisDriverWillKeepRemindingThatTheInitialFeeMustBePaidBool), I have systemChat messaged the Player, reminding that the Initial Fee Must be Paid to proceed. now, I will keep looping.		(_counterInSecondsNumber) is: (%1).", (str _counterInSecondsNumber)];};
				} else {
					if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA]  [mgmTfA_fnc_client_clickNGoContinuouslyRequestPayment.sqf] [TV4] As configured in settings (mgmTfA_configgv_clickNGoTaxisDriverWillKeepRemindingThatTheInitialFeeMustBePaidBool), I have NOT systemChat messaged the Player.		(_counterInSecondsNumber) is: (%1).", (str _counterInSecondsNumber)];};
				};
			};
		} else {
			// NO, player is NOT in a clickNGo taxi vehicle at the moment. log it & keep looping
			if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA]  [mgmTfA_fnc_client_clickNGoContinuouslyRequestPayment.sqf] [TV4] Player IS NOT in a clickNGo vehicle.		(_counterInSecondsNumber) is: (%1).", (str _counterInSecondsNumber)];};
		};
	};
	_keepGoingNumber = 0;
	uiSleep 1;
};
mgmTfA_fnc_client_clickNGoContinuouslyRequestPaymentIsRunningBool = nil;
if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA]  [mgmTfA_fnc_client_clickNGoContinuouslyRequestPayment.sqf] [TV4] Exiting function.		(_counterInSecondsNumber) is: (%1).", (str _counterInSecondsNumber)];};
// EOF