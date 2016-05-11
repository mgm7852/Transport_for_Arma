//H
//H ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_c_FD_fnc_sendBookingRequestForFDTaxi.sqf
//H $PURPOSE$	:	This function will send a variable value to the server
//H ~~
//H
//HH
//HH ~~
//HH	Example usage	:	_null = mgmTfA_c_FD_fnc_sendBookingRequestForFDTaxi
//HH	Parameters	:	requestorPosition		Array - format Position		e.g.: [2412.01, 6036.33, -0.839965]
//HH	Return Value	:	none
//HH ~~
//HH	The server-side master configuration file publicVariable publish the following value(s) this function rely on:
//HH		mgmTfA_configgv_minimumWaitingTimeBetweenFixedDestinationTaxiBookingsInSecondsNumber
//HH		mgmTfA_configgv_FixedDestinationTaxiBookingFirstTimersCanBookWithoutWaitingBool
//HH
//HH	The client-side init file create the following value(s) this function rely on:
//HH		mgmTfA_dynamicgv_lastFixedDestinationTaxiBookingPlacedAtTimestampInSecondsNumber
//HH
//HH	on start a zero counter on player :	mgmTfA_dynamicgv_lastTaxiBookingPlacedAtTimestampInSecondsNumber
//HH	The following information will be placed into the variable which is sent to the server:
//HH				_requestorPosition					Array - format Position							e.g.: [2412.01, 6036.33, -0.839965]
//HH				_requestedTaxiFixedDestinationID		Number										e.g.: 3
//HH				_requestorPlayerUID
//HH
//HH	We will create two new global variables:
//HH				mgmTfA_dynamicgv_journeyServiceFeeCostInCryptoNumber
//HH				mgmTfA_dynamicgv_journeyTotalDistanceInMetersNumber
//HH
if (isServer) exitWith {}; if (isNil("mgmTfA_Client_Init")) then {mgmTfA_Client_Init=0;}; waitUntil {mgmTfA_Client_Init==1}; private ["_thisFileVerbosityLevelNumber"]; _thisFileVerbosityLevelNumber = mgmTfA_configgv_clientVerbosityLevel;
private	[
		"_bookingPermitted",
		"_timeToWaitInSecondsNumber"
		];
// BEFORE WE send a booking request, let's first check - did this request arrive too soon?
// configuration value provided by the server => mgmTfA_configgv_minimumWaitingTimeBetweenFixedDestinationTaxiBookingsInSecondsNumber
// Before doing a time calculation, let's clarify one thing is this the first ever Booking Request? // And if so, does the player still need to wait or can he go ahead? (masterConfig configuration value determines this behaviour)
// he can book if he meets either of the options (FirstTimers can immediately book && this guy is a FirstTimer) OR (Cooldown time threshold has been honoured)
if	(
	((mgmTfA_dynamicgv_lastFixedDestinationTaxiBookingRecordKeeperThisIsTheFirstTimeBool) && (mgmTfA_configgv_FixedDestinationTaxiBookingFirstTimersCanBookWithoutWaitingBool)) 
	|| 
	(mgmTfA_configgv_minimumWaitingTimeBetweenFixedDestinationTaxiBookingsInSecondsNumber <= (time - mgmTfA_dynamicgv_lastFixedDestinationTaxiBookingPlacedAtTimestampInSecondsNumber))
	)	then {
	// he is a first timer & first timers can book immediately
	// OR
	// minimumWaitingTime requirement has been fulfilled. Player may place a booking at this time. 	// In any case, the next Booking can not be to soon - he must wait as long as defined in masterConfig
	_bookingPermitted = true;
} else {
	// Player may not book at this time - it is too soon since the last Booking that was placed!
	_bookingPermitted = false;
	_timeToWaitInSecondsNumber = (round (mgmTfA_configgv_minimumWaitingTimeBetweenFixedDestinationTaxiBookingsInSecondsNumber - ((time) - mgmTfA_dynamicgv_lastFixedDestinationTaxiBookingPlacedAtTimestampInSecondsNumber)));
	// Note that anything below 1 second and above 0 second (e.g.: 0.374s) will cause the message "PLEASE WAIT 0 SECONDS" to be displayed, so artificially increment by 1 if it is zero.
	if (_timeToWaitInSecondsNumber == 0) then { _timeToWaitInSecondsNumber = _timeToWaitInSecondsNumber + 1 };
	private	[
			"_msg2HintTextString",
			"_msg2SyschatTextString1",
			"_msg2SyschatTextString2"
			];
	_msg2HintTextString = parsetext format ["<img size='6' image='custom\mgmTfA\img\mgmTfA_img_client_warningStopSign.jpg'/><br/><br/><t size='1.40' color='#FF0037'>SORRY %1!<br/><br/>YOU MAY NOT BOOK<br/>ANOTHER TAXI<br/>THAT QUICKLY.<br/>PLEASE WAIT ANOTHER<br/>%2 SECONDS<br/>BEFORE TRYING AGAIN.", (profileName), (str _timeToWaitInSecondsNumber)];
	_msg2SyschatTextString1 = parsetext format ["[SYSTEM]  SORRY %1! YOU MAY NOT BOOK ANOTHER TAXI THAT QUICKLY", (profileName)];
	_msg2SyschatTextString2 = parsetext format ["[SYSTEM]  PLEASE WAIT ANOTHER %1 SECONDS BEFORE TRYING AGAIN", (str _timeToWaitInSecondsNumber)];
	hint _msg2HintTextString;
	systemChat (str _msg2SyschatTextString1);
	systemChat (str _msg2SyschatTextString2);
	if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_fnc_returnNearbyRandomOnRoadPosition3DArray.sqf] [TV3] Player attempted booking too soon. _timeToWaitInSecondsNumber is: (%1)", (str _timeToWaitInSecondsNumber)];};//dbg
};
if (_bookingPermitted) then {

	// This is a new request - we should increment the global counter: mgmTfA_gvdb_PV_fixedDestinationTaxisTotalRequestsReceivedNumber
	mgmTfA_gvdb_PV_fixedDestinationTaxisTotalRequestsReceivedNumber=mgmTfA_gvdb_PV_fixedDestinationTaxisTotalRequestsReceivedNumber+1;
	// Broadcast the value to all computers
	publicVariable "mgmTfA_gvdb_PV_fixedDestinationTaxisTotalRequestsReceivedNumber";
	
	// Check whether we have any available drivers
	if (mgmTfA_gvdb_PV_fixedDestinationTaxisNumberOfCurrentlyAvailableTaxiDriversNumber<=0)  exitWith {
		// No drivers available!	Kill the rest of the workflow		// but first inform the Requestor
		private	[
				"_msg2HintTextString"													
				];
		_msg2HintTextString = parsetext format ["<img size='6' image='custom\mgmTfA\img\mgmTfA_img_client_warningStopSign.jpg'/><br/><br/><t size='1.40' color='#FF0037'>SORRY %1<br/>THERE ARE NO FIXED DESTINATION TAXI DRIVERS<br/>AVAILABLE AT THE MOMENT. PLEASE TRY AGAIN LATER.<br/>", (profileName)];
		hint 				_msg2HintTextString;
		if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_fnc_returnNearbyRandomOnRoadPosition3DArray.sqf] [TV3] There are no drivers available - quitting!"];};//dbg
			
		// Increment publicVariable counter: mgmTfA_gvdb_PV_fixedDestinationTaxisTotalRequestsDroppedNumber
		mgmTfA_gvdb_PV_fixedDestinationTaxisTotalRequestsDroppedNumber = mgmTfA_gvdb_PV_fixedDestinationTaxisTotalRequestsDroppedNumber + 1;
		// Broadcast the value to all computers
		publicVariable "mgmTfA_gvdb_PV_fixedDestinationTaxisTotalRequestsDroppedNumber";
		if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_c_FD_fnc_sendBookingRequestForFDTaxi.sqf] [TV3] I have DROPPED a request due to lack of drivers therefore incremented mgmTfA_gvdb_PV_fixedDestinationTaxisTotalRequestsDroppedNumber by one. Current value, after the increment, is: (%1). The requestor for this dropped job was: (%2).", mgmTfA_gvdb_PV_fixedDestinationTaxisTotalRequestsDroppedNumber, (profileName)];};//dbg
	};
	mgmTfA_gv_pvs_requestorPositionArray3D = _this select 0;
	mgmTfA_gv_pvs_requestedTaxiFixedDestinationID = _this select 1;
	//Prepare the name of the  requested destination in Text
	//Use global var so that Phase2 can access it!
	switch mgmTfA_gv_pvs_requestedTaxiFixedDestinationID do {
		case 1:	{ mgmTfA_gv_requestedTaxiFixedDestinationNameTextString = mgmTfA_configgv_taxiFixedDestination01LocationNameTextString };
		case 2:	{ mgmTfA_gv_requestedTaxiFixedDestinationNameTextString = mgmTfA_configgv_taxiFixedDestination02LocationNameTextString };
		case 3:	{ mgmTfA_gv_requestedTaxiFixedDestinationNameTextString = mgmTfA_configgv_taxiFixedDestination03LocationNameTextString };
		case 0;
		default { mgmTfA_gv_requestedTaxiFixedDestinationNameTextString = "UNKNOWN-DEFAULT-DESTINATION" };
	};
	// Okay we've checked booking times and it appears this player CAN place a booking at this time.
	// But does he have enough cash to cover the full cost of fixedDestination Taxi journey?
	// Let's check it now and proceed only if he has enough money. Otherwise inform him & quit.
	//
	// In order to determine whether player has enough cash, first we need to know how much would the cost of full journey going to be?
	// find destination spot
	private		[
				"_fixedDestinationTaxiRequestedDestinationPosition3DArray",
				"_journeyTotalDistanceInMetersNumber",
				"_journeyTotalCostInCryptoNumber",
				"_journeyServiceFeeCostInCryptoNumber",
				"_playerCanAffordRequestedJourneyCostBool"
				];
	_journeyTotalCostInCryptoNumber = 0;
							//	CHEAT SHEET -- these are configured in the server-side masterConfig file!
							//	mgmTfA_configgv_taxiFixedDestination01LocationNameTextString="KAVALA";
							//	mgmTfA_configgv_taxiFixedDestination02LocationNameTextString="NEOCHORI";
							//	mgmTfA_configgv_taxiFixedDestination03LocationNameTextString="PYRGOS";
							//	mgmTfA_configgv_taxiFixedDestination01LocationPositionArray=[12573.5,14356.2];
							//	mgmTfA_configgv_taxiFixedDestination02LocationPositionArray=[3610.68,12939.6];
							//	mgmTfA_configgv_taxiFixedDestination03LocationPositionArray=[16811.8,12698];
	// STEP:	find distance between player & destination spot
	switch mgmTfA_gv_pvs_requestedTaxiFixedDestinationID do {
		case 1:	{ _fixedDestinationTaxiRequestedDestinationPosition3DArray = mgmTfA_configgv_taxiFixedDestination01LocationPositionArray };
		case 2:	{ _fixedDestinationTaxiRequestedDestinationPosition3DArray = mgmTfA_configgv_taxiFixedDestination02LocationPositionArray };
		case 3:	{ _fixedDestinationTaxiRequestedDestinationPosition3DArray = mgmTfA_configgv_taxiFixedDestination03LocationPositionArray };
		case 0;
		default		{ _fixedDestinationTaxiRequestedDestinationPosition3DArray = [0,0] };
	};
	_journeyTotalDistanceInMetersNumber				= (round ((player) distance _fixedDestinationTaxiRequestedDestinationPosition3DArray));
	// STEP:	calculate total journey cost
				//	CHEAT SHEET
				//	mgmTfA_configgv_fixedDestinationTaxisNonRefundableStandardBookingFeeCostInCryptoNumber
				//	mgmTfA_configgv_fixedDestinationTaxisServiceFeeBaseFeeInCryptoNumber
				//	mgmTfA_configgv_fixedDestinationTaxisServiceFeeCostForTravellingAdditional100MetresInCryptoNumber
				// Distance to NEOCHORI=6900 metres	Fixed Destination Taxi to NEOCHORI cost	= (StandardBooking=100) + (BaseFee=100) + (69 times CostForTravellingAdditional100Metres = 69 x 10 = 690)	= 100+100+690	= 890 crypto in total
	_journeyTotalCostInCryptoNumber =	(round (mgmTfA_configgv_fixedDestinationTaxisNonRefundableStandardBookingFeeCostInCryptoNumber) + (mgmTfA_configgv_fixedDestinationTaxisServiceFeeBaseFeeInCryptoNumber) + ((_journeyTotalDistanceInMetersNumber / 100) * mgmTfA_configgv_fixedDestinationTaxisServiceFeeCostForTravellingAdditional100MetresInCryptoNumber));
	// Now that we know the cost, let's see if player can afford it?
	if (EPOCH_playerCrypto >= _journeyTotalCostInCryptoNumber) then {
		_playerCanAffordRequestedJourneyCostBool = true;
	} else {
		_playerCanAffordRequestedJourneyCostBool = false;
	};
	if (_playerCanAffordRequestedJourneyCostBool) then {
		// Player's current cash amount is adequate to pay for the full journey cost
		// Charge the player for standard booking fee
		EPOCH_playerCrypto = (EPOCH_playerCrypto - mgmTfA_configgv_fixedDestinationTaxisNonRefundableStandardBookingFeeCostInCryptoNumber);
		// Inform the player that he just paid the Standard Booking Fee
		private	[
				"_msg2HintTextString",
				"_msg2SyschatTextString"
				];
		_msg2HintTextString = parsetext format ["<img size='6' image='custom\mgmTfA\img\mgmTfA_img_client_taxiPaymentReceivedManyThanks.jpg'/><br/><br/><t size='1.40' color='#00FF00'>%1<br/><br/>THANKS FOR PAYING<br/>THE BOOKING FEE<br/>%2 CRYPTO<br/><br/>PLEASE WAIT<br/>", (profileName), (str mgmTfA_configgv_fixedDestinationTaxisNonRefundableStandardBookingFeeCostInCryptoNumber)];
		_msg2SyschatTextString = parsetext format ["[TAXI DISPATCHER] BOOKING FEE %1 CRYPTO PAID, THANKS! PLEASE WAIT...", (str mgmTfA_configgv_fixedDestinationTaxisNonRefundableStandardBookingFeeCostInCryptoNumber)];
		hint _msg2HintTextString;
		systemChat str _msg2SyschatTextString;
		// Player just paid for the standard booking fee. The outstanding balance (assuming he will complete the journey fully) is:		_journeyServiceFeeCostInCryptoNumber	<= we should charge him this much when he gets in the vehicle!
		_journeyServiceFeeCostInCryptoNumber = (round (_journeyTotalCostInCryptoNumber - mgmTfA_configgv_fixedDestinationTaxisNonRefundableStandardBookingFeeCostInCryptoNumber));
		// Let's store this in a global variable as next phase(s) will require this information.
		mgmTfA_dynamicgv_journeyServiceFeeCostInCryptoNumber = _journeyServiceFeeCostInCryptoNumber;
		// We might also need the total journey distance to refund any 'untravelled distance'
		mgmTfA_dynamicgv_journeyTotalDistanceInMetersNumber = _journeyTotalDistanceInMetersNumber;
		// SEND THE BOOKING TO THE SERVER
		if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA] [mgmTfA_c_FD_fnc_sendBookingRequestForFDTaxi.sqf] [TV4] (_bookingPermitted) is true. executing main function block now."];};//dbg
		// Do these at this stage
		mgmTfA_dynamicgv_lastFixedDestinationTaxiBookingRecordKeeperThisIsTheFirstTimeBool = false;
		mgmTfA_dynamicgv_lastFixedDestinationTaxiBookingPlacedAtTimestampInSecondsNumber = (time);
		// Craft the booking request package		
		mgmTfA_gv_pvs_req_fixedDestinationTaxiToMyPositionPleaseConfirmPacket = [player, mgmTfA_gv_pvs_requestorPositionArray3D, mgmTfA_gv_pvs_requestedTaxiFixedDestinationID, (getPlayerUID player)];
		publicVariableServer "mgmTfA_gv_pvs_req_fixedDestinationTaxiToMyPositionPleaseConfirmPacket";
		if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA] [mgmTfA_c_FD_fnc_sendBookingRequestForFDTaxi.sqf] [TV4] BOOKING REQUEST SENT. Details: mgmTfA_gv_pvs_requestorPositionArray3D: (%1)   mgmTfA_gv_pvs_requestedTaxiFixedDestinationID: (%2)", mgmTfA_gv_pvs_requestorPositionArray3D, mgmTfA_gv_pvs_requestedTaxiFixedDestinationID];};//dbg
		// Let the player know
		private	[
				"_bookingRequestSubmittedPleaseStandByForDespatchersResponseMessageTextOnly"
				];
		// UPDATE -- MESSAGE HERE IS ONLY IN 1 FORMAT!					OLD => Message in 2 different formats:	Rich (to be `hint`ed) 	and 	Text-only (to be systemChat`ed). No need to add "PLEASE STAND BY" in rich format as it already contains a picture saying that!
		//DO NOT USE THE HINT BOX. WE WILL OUTPUT THE RESPONSE FROM SERVER (mgmTfA_gv_pvc_ack_processingYourFixedDestinationTaxiRequestToYourPositionPleaseWaitPacketSignalOnly) IN THERE 			_bookingRequestSubmittedPleaseStandByForDespatchersResponseMessageRich = parsetext format ["<img size='6' image='custom\mgmTfA\img\mgmTfA_img_client_pleaseWait.jpg'/><br/><br/><t size='1.40' color='#00FF00'>ALRIGHT %1 A TAXI TO %2.<br/>CHECKING DRIVER AVAILABILITY...", (profileName), mgmTfA_gv_requestedTaxiFixedDestinationNameTextString];
		//DO NOT USE THE HINT BOX. WE WILL OUTPUT THE RESPONSE FROM SERVER (mgmTfA_gv_pvc_ack_processingYourFixedDestinationTaxiRequestToYourPositionPleaseWaitPacketSignalOnly) IN THERE 			hint _bookingRequestSubmittedPleaseStandByForDespatchersResponseMessageRich;
		// TODO:	do we need this clear hint area at this point?
		// Clear the hint are
		hint "";
		_bookingRequestSubmittedPleaseStandByForDespatchersResponseMessageTextOnly = parsetext format ["[RADIO_OUT] TAXI REQUEST SUBMITTED, PLEASE STAND BY"];
		systemChat str _bookingRequestSubmittedPleaseStandByForDespatchersResponseMessageTextOnly;
	} else {
		// Player's current cash is NOT adequate to pay for the full journey cost	// Let the player know
		private	[
				"_msg2HintTextString",
				"_msg2SyschatTextString1",
				"_msg2SyschatTextString2"
				];
		_msg2HintTextString = parsetext format ["<img size='6' image='custom\mgmTfA\img\mgmTfA_img_client_taxiCannotAfford.jpg'/><br/><br/><t size='1.40' color='#FF0037'>SORRY %1<br/><br/>YOU CANNOT AFFORD<br/>THE COST OF SERVICE:<br/>%2 CRYPTO<br/><br/>PLEASE TRY AGAIN<br/>WHEN YOU HAVE ENOUGH CASH<br/><br/>THANK YOU<br/>", (profileName), (str (round _journeyTotalCostInCryptoNumber))];
		_msg2SyschatTextString1 = parsetext format ["[SYSTEM]  SORRY %1 YOU CANNOT AFFORD THE COST OF SERVICE %2 CRYPTO", (profileName), (str _journeyTotalCostInCryptoNumber)];
		_msg2SyschatTextString2 = parsetext format ["[SYSTEM]  PLEASE TRY AGAIN WHEN YOU HAVE ENOUGH CASH.   THANK YOU"];
		hint _msg2HintTextString;
		systemChat str _msg2SyschatTextString1;
		systemChat str _msg2SyschatTextString2;
	};
};
//EOF