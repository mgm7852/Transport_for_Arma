private	[
		"_thisFileVerbosityLevelNumber"										
		];
_thisFileVerbosityLevelNumber= 9;
if (_thisFileVerbosityLevelNumber>=9) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_client_fixedDestinationTaxiPayNow.sqf]  [TV9] 		DEVDEBUG		I have been SPAWN'd.	This is what I have received:	(%1).", (str _this)];};//dbg

private	[
		"_playerCanAffordRequestedJourneyServiceFeeBool"						
		];

// Now that we know the cost, let's see if player can afford it?
if (EPOCH_playerCrypto >= mgmTfA_dynamicgv_journeyServiceFeeCostInCryptoNumber) then {
	_playerCanAffordRequestedJourneyServiceFeeBool = true;
} else {
	_playerCanAffordRequestedJourneyServiceFeeBool = false;
};

if (_playerCanAffordRequestedJourneyServiceFeeBool) then {
	// can afford
	
	// Charge the player for the service fee
	EPOCH_playerCrypto = (EPOCH_playerCrypto - mgmTfA_dynamicgv_journeyServiceFeeCostInCryptoNumber);
	
	// Inform the player that he just paid the Service Fee
	private	[
			"_msg2HintTextString",
			"_msg2SyschatTextString",
			"_actionRemovedMessageText"
			];
	_msg2HintTextString = parsetext format ["<img size='6' image='custom\mgmTfA\img_comms\mgmTfA_img_client_taxiPaymentReceivedManyThanks.jpg'/><br/><br/><t size='1.40' color='#FF0037'>%1<br/><br/>THANKS FOR PAYING<br/>THE SERVICE FEE:<br/>%2 CRYPTO<br/><br/>PLEASE WAIT<br/>", (profileName), (str mgmTfA_dynamicgv_journeyServiceFeeCostInCryptoNumber)];
	_msg2SyschatTextString = parsetext format ["%1 THANKS FOR PAYING THE SERVICE FEE: %2 CRYPTO. PLEASE WAIT", (profileName), (str mgmTfA_dynamicgv_journeyServiceFeeCostInCryptoNumber)];
	// Print the message
	hint _msg2HintTextString;
	systemChat str _msg2SyschatTextString;

	// Player won't need the Pay Now button any more
	_veh = (vehicle player);
	_veh removeAction mgmTfA_EHIDfdTxGetInAddActionPayNow;
	mgmTfA_EHIDfdTxGetInAddActionPayNow = nil;
	_actionRemovedMessageText = parsetext format ["%1 since you just paid the Service Fee, 'PayNow' addAction option has been removed from your vehicle", (profileName)];
	systemChat (str _actionRemovedMessageText);

	// Future GetIn's should not lead to a 'Pay Now' addAction menu. Let's mark this vehicle as 'serviceFeeHasBeenPaid'
	_veh setVariable ["serviceFeeHasBeenPaid", true, true];
	
	// signal the server-side that fixedDestination Taxi Service Fee has just been paid!
	if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_scr_client_fixedDestinationTaxiPayNow.sqf] [TV8] 		DEVDEBUG		Here we should signal the server that player has just paid the Service Fee."];};//dbg
} else {
	// cannot afford
	// Player's current cash is NOT adequate to pay for the service fee		// Let the player know
	private	[
			"_msg2HintTextString",
			"_msg2SyschatTextString"
			];
	_msg2HintTextString = parsetext format ["<img size='6' image='custom\mgmTfA\img_comms\mgmTfA_img_client_taxiCannotAfford.jpg'/><br/><br/><t size='1.40' color='#FF0037'>SORRY %1<br/><br/>YOU CANNOT AFFORD<br/>THE SERVICE FEE:<br/>%2 CRYPTO<br/><br/>PLEASE TRY AGAIN<br/>WHEN YOU HAVE ENOUGH CASH", (profileName), (str mgmTfA_dynamicgv_journeyServiceFeeCostInCryptoNumber)];
	_msg2SyschatTextString = parsetext format ["SORRY %1 YOU CANNOT AFFORD THE SERVICE FEE: %2 CRYPTO.   PLEASE TRY AGAIN WHEN YOU HAVE ENOUGH CASH", (profileName), (str mgmTfA_dynamicgv_journeyServiceFeeCostInCryptoNumber)];
	// Print the message
	hint _msg2HintTextString;
	systemChat str _msg2SyschatTextString;
};
// EOF