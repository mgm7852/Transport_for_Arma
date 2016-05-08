//H
//H
//H ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_scr_client_clickNGoTaxiPayNow.sqf
//H $PURPOSE$	:	undocumented
//H ~~
//H
//HH
//H ~~
//HH	Syntax		:	_null = [] mgmTfA_scr_client_clickNGoTaxiPayNow
//HH	Parameters	:	none
//HH	Return Value	:	none
//H ~~
//HH	The shared configuration file has the following values this function rely on: none
//HH	This function updates the following global variable(s):	undocumented
//HH
private	[
		"_thisFileVerbosityLevelNumber",
		"_playerCanAffordAbsoluteMinimumJourneyServiceFeeBool"
		];
_thisFileVerbosityLevelNumber = mgmTfA_configgv_clientVerbosityLevel;
if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_scr_client_clickNGoTaxiPayNow.sqf]  [TV8] 		DEVDEBUG		I have been SPAWN'd.	This is what I have received:	(%1).", (str _this)];};//dbg

// Now that we know the cost, let's see if player can afford it?
if (EPOCH_playerCrypto >= mgmTfA_configgv_clickNGoTaxisAbsoluteMinimumJourneyFeeInCryptoNumber) then {
	_playerCanAffordAbsoluteMinimumJourneyServiceFeeBool = true;
} else {
	_playerCanAffordAbsoluteMinimumJourneyServiceFeeBool = false;
};

if (_playerCanAffordAbsoluteMinimumJourneyServiceFeeBool) then {
	// can afford
	// Charge the player for the service fee
	EPOCH_playerCrypto = (EPOCH_playerCrypto - mgmTfA_configgv_clickNGoTaxisAbsoluteMinimumJourneyFeeInCryptoNumber);
	// Inform the player that he just paid the Service Fee
	private	[
			"_msg2HintTextString",
			"_msg2SyschatTextString",
			"_myGUSUIDNumber",
			"_lePointer",
			"_actionRemovedMessageText"
			];
	_msg2HintTextString = parsetext format ["<img size='6' image='custom\mgmTfA\mgmTfA_img_client_taxiPaymentReceivedManyThanks.jpg'/><br/><br/><t size='1.40' color='#00FF00'>%1<br/><br/>THANKS FOR PAYING<br/>MINIMUM JOURNEY SERVICE FEE:<br/>%2 CRYPTO<br/><br/>PLEASE WAIT<br/>", (profileName), (str mgmTfA_configgv_clickNGoTaxisAbsoluteMinimumJourneyFeeInCryptoNumber)];
	_msg2SyschatTextString = parsetext format ["%1 THANKS FOR PAYING MINIMUM JOURNEY SERVICE FEE: %2 CRYPTO.  PLEASE WAIT", (profileName), (str mgmTfA_configgv_clickNGoTaxisAbsoluteMinimumJourneyFeeInCryptoNumber)];
	// Print the message
	hint _msg2HintTextString;
	systemChat str _msg2SyschatTextString;

	// signal the server-side that clickNGo Taxi Service Fee has just been paid!
	_myGUSUIDNumber = ((vehicle player) getVariable "GUSUIDNumber");
	missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUcNGoTxServiceFeeHasBeenPaidBool", _myGUSUIDNumber], true];
	publicVariable format ["mgmTfA_gv_PV_SU%1SUcNGoTxServiceFeeHasBeenPaidBool", _myGUSUIDNumber];
	if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_scr_client_clickNGoTaxiPayNow.sqf] [TV8] 		DEVDEBUG		publicVariable (mgmTfA_gv_PV_SU%1SUcNGoTxServiceFeeHasBeenPaidBool) 		<== signal sent to the server (that player has paid Minimum Service Fee)."];};//dbg
	
	// parse arguments
	_VehEntered				= (_this select 0);
	_lePointer = call compile format ["mgmTfA_gv_PV_SU%SUActionIDPointer", _myGUSUIDNumber];
	if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_scr_client_clickNGoTaxiPayNow.sqf] [TV8] 		DEVDEBUG		About to removeAction by issuing: (_VehEntered removeAction _lePointer).		(_lePointer) is: (%1).", _lePointer];};//dbg
	_VehEntered removeAction _lePointer;
	if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_scr_client_clickNGoTaxiPayNow.sqf] [TV8] 		DEVDEBUG		Action removed by issuing: (_VehEntered removeAction _lePointer)."];};//dbg
	
	// Inform the player that action has been removed
	private	[
			"_actionRemovedMessageText"						
			];
	_actionRemovedMessageText = parsetext format ["'PAYNOW' ACTION HAS BEEN REMOVED"];
	systemChat " ";
	// Print the message
	systemChat 		str _actionRemovedMessageText;
} else {
	// cannot afford
	// Player's current cash is NOT adequate to pay for the service fee		// Let the player know
	private	[
			"_msg2HintTextString",
			"_msg2SyschatTextString"
			];
	_msg2HintTextString = parsetext format ["<img size='6' image='custom\mgmTfA\mgmTfA_img_client_taxiCannotAfford.jpg'/><br/><br/><t size='1.40' color='#FF0037'>SORRY %1<br/><br/>YOU CANNOT AFFORD<br/>THE MINIMUM SERVICE FEE:<br/>%2 CRYPTO<br/><br/>PLEASE TRY AGAIN<br/>WHEN YOU HAVE ENOUGH CASH<br/><br/>THANK YOU<br/>", (profileName), (str (round mgmTfA_configgv_clickNGoTaxisAbsoluteMinimumJourneyFeeInCryptoNumber))];
	_msg2SyschatTextString = parsetext format ["SORRY %1 YOU CANNOT AFFORD THE MINIMUM SERVICE FEE: %2 CRYPTO.   PLEASE TRY AGAIN WHEN YOU HAVE ENOUGH CASH.   THANK YOU", (profileName), (str mgmTfA_configgv_clickNGoTaxisAbsoluteMinimumJourneyFeeInCryptoNumber)];
	// Print the message
	hint _msg2HintTextString;
	systemChat str _msg2SyschatTextString;
};
// EOF