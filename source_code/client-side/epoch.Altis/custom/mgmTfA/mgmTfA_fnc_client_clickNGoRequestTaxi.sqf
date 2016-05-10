//H
//H ~~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_fnc_client_clickNGoRequestTaxi.sqf
//H $PURPOSE$	:	This client side script contains 'request clickNGo taxi' code.
//H ~~~
//H
if (isServer) exitWith {}; if (isNil("mgmTfA_Client_Init")) then {mgmTfA_Client_Init=0;}; waitUntil {mgmTfA_Client_Init==1}; private ["_thisFileVerbosityLevelNumber"]; _thisFileVerbosityLevelNumber = mgmTfA_configgv_clientVerbosityLevel;
scopeName "mgmTfA_fnc_client_clickNGoRequestTaxiMainScope";
if (!isServer) then { waitUntil {!isnull (finddisplay 46)}; };
// STAGE IN WORKFLOW:		if player is not on foot -- kill the request
if ((vehicle player) != player) exitWith {
	// player in a vehicle at the moment 		and therefore will not be allowed to request a clickNGo Taxi at this time
	// inform the player that we have received this request however a clickNGo Taxi cannot be ordered from inside another vehicle
	private	[
			"_msg2HintTextString",
			"_msg2SyschatTextString"
			];
	// with hint
	_msg2HintTextString = parsetext format ["<img size='6' image='custom\mgmTfA\img_comms\mgmTfA_img_client_warningStopSign.jpg'/><br/><br/><t size='1.40' color='#00FF00'>SORRY %1!<br/>YOU MAY NOT PLACE<br/>A BOOKING FROM<br/>INSIDE ANOTHER VEHICLE", (profileName)];
	hint _msg2HintTextString;
	// with systemChat
	_msg2SyschatTextString = parsetext format ["SORRY %1! YOU MAY NOT PLACE A clickNGo BOOKING REQUEST FROM INSIDE ANOTHER VEHICLE", (profileName)];
	systemChat str _msg2SyschatTextString;
	if (_thisFileVerbosityLevelNumber>=5) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_client_clickNGoRequestTaxi.sqf]      [TV5]  Player attempted to place a clickNGo Taxi booking request from inside another vehicle and got rejected."];};
};
// STAGE IN WORKFLOW:		determine whether timeout requirements are met -- kill the request otherwise
//
// BEFORE WE send a booking request, let's first check - did this request arrive too soon?
// configuration value provided by the server => mgmTfA_configgv_minimumWaitingTimeBetweenclickNGoTaxiBookingsInSecondsNumber
// Before doing a time calculation, let's clarify a few things: is this the first ever Booking Request?
// And if so, does the player still need to wait or can he go ahead? (masterConfig configuration value determines this behaviour)
// he can book if he meets either of the options (FirstTimers can immediately book && this guy is a FirstTimer) OR (Cooldown time threshold has been honoured)
private	[
		// this _bookingPermitted means		1) requestor candidate  is not in another vehicle	2) requestor candidate is not limited by 'lastOrderCooldown' timers
		"_bookingPermitted",
		"_timeToWaitInSecondsNumber"
		];
if	(
	((mgmTfA_dynamicgv_lastclickNGoTaxiBookingRecordKeeperThisIsTheFirstTimeBool) && (mgmTfA_configgv_clickNGoTaxiBookingFirstTimersCanBookWithoutWaitingBool)) 
	|| 
	(mgmTfA_configgv_minimumWaitingTimeBetweenclickNGoTaxiBookingsInSecondsNumber <= (time - mgmTfA_dynamicgv_lastclickNGoTaxiBookingPlacedAtTimestampInSecondsNumber))
	)	then {
	// he is a first timer & first timers can book immediately
	// OR
	// minimumWaitingTime requirement has been fulfilled. Player may place a booking at this time. 	// In any case, the next Booking can not be to soon - he must wait as long as defined in masterConfig
	_bookingPermitted															= true;
} else {
	// Player may not book at this time - it is too soon since the last Booking that was placed!
	_bookingPermitted 															= false;
	_timeToWaitInSecondsNumber = (round (mgmTfA_configgv_minimumWaitingTimeBetweenclickNGoTaxiBookingsInSecondsNumber - ((time) - mgmTfA_dynamicgv_lastclickNGoTaxiBookingPlacedAtTimestampInSecondsNumber)));
	// Note that anything below 1 second and above 0 second (e.g.: 0.374s) will cause the message "PLEASE WAIT 0 SECONDS" to be displayed, so artificially increment by 1 if it is zero.
	if (_timeToWaitInSecondsNumber == 0) then { _timeToWaitInSecondsNumber = _timeToWaitInSecondsNumber + 1 };
	_msg2HintTextString = parsetext format ["<img size='6' image='custom\mgmTfA\img_comms\mgmTfA_img_client_warningStopSign.jpg'/><br/><br/><t size='1.40' color='#FF0037'>SORRY %1!<br/><br/>YOU MAY NOT BOOK<br/>ANOTHER TAXI<br/>THAT QUICKLY.<br/>PLEASE WAIT ANOTHER<br/>%2 SECONDS<br/>BEFORE TRYING AGAIN.", (profileName), (str _timeToWaitInSecondsNumber)];
	_msg2SyschatTextString = parsetext format ["SORRY %1! YOU MAY NOT BOOK ANOTHER TAXI THAT QUICKLY. PLEASE WAIT ANOTHER %2 SECONDS BEFORE TRYING AGAIN.", (profileName), (str _timeToWaitInSecondsNumber)];
	hint 				_msg2HintTextString;
	systemChat		(str _msg2SyschatTextString);
	if (_thisFileVerbosityLevelNumber>=5) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_client_clickNGoRequestTaxi.sqf] [TV5] Player attempted booking too soon. _timeToWaitInSecondsNumber is: (%1)", (str _timeToWaitInSecondsNumber)];};//dbg
};
// STAGE IN WORKFLOW:		if booking is permitted, run the main request block below
if (_bookingPermitted) then {
	// this _bookingPermitted means		1) requestor candidate  is not in another vehicle	2) requestor candidate is not limited by 'lastOrderCooldown' timers
	// put the rest of the file under this block

	// if we are still here, it means player is on foot and there are no issues with booking time restrictions - so let's proceed with the clickNGo request workflow
	// HOWTO_do_map_position_take
	private	[
			"_pos",
			"_clickNGoTaxiRequestedDestinationPosition3DArray",
			"_msg2HintTextString",
			"_msg2SyschatTextString"
			];
	// DESTINATION PICKER CODE
	// Kill the workflow if there is another instance active		("clickNGoTaxiDestinationChoser_systemReady" global variable should be nil if not nil, there must be another instance currently running...)
	if (!(isNil "clickNGoTaxiDestinationChoser_systemReady")) exitWith {hint "SYSTEM CURRENTLY NOT AVAILABLE"};
	
	if (mgmTfA_dynamicgv_thisPlayerCanOrderclickNGoTaxiViaHotkey) then {
		
		// disable players access to the hotkey. this is to prevent keyspam when there is actually zero use case for it.
		mgmTfA_dynamicgv_thisPlayerCanOrderclickNGoTaxiViaHotkey = false;
		// we mustn't do this here as currently booking is in progress but has not been placed. we will do it further down only when we actually contact the server.		mgmTfA_dynamicgv_lastclickNGoTaxiBookingPlacedAtTimestampInSecondsNumber = (time);

		///////// STEP:	FINANCIAL CHECKS 	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Okay we've checked booking times and it appears this player CAN place a booking at this time.
		// But does he have enough cash to cover the initial cost of clickNGo journey?
		// Let's check it now and proceed only if he has enough money. Otherwise inform him & quit.

		// In order to determine whether player has enough cash, first we need to know how much would the cost of clickNGo initial journey going to be?
		// find destination spot
		private		[
					//	NOTE:	this is still in memory from few lines above us => 	_clickNGoTaxiRequestedDestinationPosition3DArray
					"_journeyInitialCostInCryptoNumber",
					"_playerCanAffordRequestedJourneyCostBool",
					"_bookingFeeInCryptoNumber",
					"_minimumFeeInCryptoNumber",
					"_journeyPrepaidInitialTimeSliceInSecondsNumber",
					"_journeyStartTimeInSecondsNumber",
					"_tickStartTimeInSecondsNumber",
					"_tickCostInCryptoNumber",
					"_tickTimeElapsedInSecondsNumber",
					"_tickTimeStepInSecondsNumber",
					"_hintExpiryTimerDurationInSecondsNumber",
					"_hintTimerTheLastTimeItWasResetSecondsInNumber",
					"_hintMessageIsCurrentlyActiveOnScreenBool"
					];
		///////// local variables of counter or configSetting nature to initialize on startup /////////
		_playerCanAffordRequestedJourneyCostBool = false;
		_bookingFeeInCryptoNumber = (round mgmTfA_configgv_clickNGoTaxisNonRefundableBookingFeeCostInCryptoNumber);
		_minimumFeeInCryptoNumber = (round mgmTfA_configgv_clickNGoTaxisAbsoluteMinimumJourneyFeeInCryptoNumber);
		_journeyInitialCostInCryptoNumber = (round (_bookingFeeInCryptoNumber + _minimumFeeInCryptoNumber));
		_journeyPrepaidInitialTimeSliceInSecondsNumber = (round mgmTfA_configgv_clickNGoTaxisPrepaidAbsoluteMinimumJourneyTimeInSeconds);
		_journeyStartTimeInSecondsNumber = (time);
		_tickStartTimeInSecondsNumber = (time) + _journeyPrepaidInitialTimeSliceInSecondsNumber;		// 0 + 120 = 120;
		_tickCostInCryptoNumber = (round mgmTfA_configgv_clickNGoTaxisTickCostInCryptoNumber);
		_tickTimeElapsedInSecondsNumber = 0;
		_tickTimeStepInSecondsNumber = (round mgmTfA_configgv_clickNGoTaxisTickStepTimeInSecondsNumber);
		// when a hint message is displayed, it will stay on the screen for this long
		_hintExpiryTimerDurationInSecondsNumber = 2.5;
		// set it to 24 hours, since no Arma 3 server would be runnig for that long, we're practically disabling the timer for the time being. The next time main loop code below, issues this command (_hintTimerTheLastTimeItWasReset = (time);) timer will start doing its job.
		_hintTimerTheLastTimeItWasResetSecondsInNumber = -86400;
		_hintMessageIsCurrentlyActiveOnScreenBool = false;

		// Now that we know the cost, let's see if player can afford it?
		if (EPOCH_playerCrypto >= _journeyInitialCostInCryptoNumber) then {
			_playerCanAffordRequestedJourneyCostBool = true;
		} else {
			_playerCanAffordRequestedJourneyCostBool = false;
		};

		if (_playerCanAffordRequestedJourneyCostBool) then {
			// Player's current cash amount IS adequate to pay for the full journey cost
			deleteMarker "clickNGoTaxiChosenPosition";

			// Open the map
			openMap true;
			// Inform via hint (in Rich format)
			_msg2HintTextString 						= parsetext format ["<img size='6' image='custom\mgmTfA\img_comms\mgmTfA_img_client_taxiChooseDestination.jpg'/><br/><br/>AWAITING INPUT<br/><br/>SINGLE LEFT CLICK<br/>TO SET DESTINATION"];
			hint 										_msg2HintTextString;
			// Inform via systemChat (in Text-Only format)
			_msg2SyschatTextString 					= parsetext format ["AWAITING INPUT. SINGLE LEFT CLICK TO SET DESTINATION"];
			systemChat 								(str _msg2SyschatTextString);
			// Insert the actual code to handle the mouse-left-click-on-map
			onMapSingleClick "
			    clickNGoTaxiChosenDestinationMarker = createMarkerLocal [""clickNGoTaxiChosenPosition"",_pos];
			    clickNGoTaxiChosenDestinationMarker setMarkerTypeLocal ""hd_dot"";
			    clickNGoTaxiChosenDestinationMarker setMarkerColorLocal ""ColorBlue"";
			    clickNGoTaxiChosenDestinationMarker setMarkerTextLocal ""clickNGo Taxi Destination"";
			    clickNGoTaxiDestinationChoser_mapClicked = true;
			    onMapSingleClick {};
			    hint """";
			";
			// We now wait for the click
			waitUntil { !(isNil "clickNGoTaxiDestinationChoser_mapClicked") };
			clickNGoTaxiDestinationChoser_mapClicked = nil;
			// System is now busy processing the request - we can not take any further clicks until we finish processing this one
			clickNGoTaxiDestinationChoser_systemReady = false;
			
			// Prep - get the position coordinates
			_clickNGoTaxiRequestedDestinationPosition3DArray = getMarkerPos "clickNGoTaxiChosenPosition";
			// Close the map
			openMap false;
			// Inform via hint (in Rich format)
			_msg2HintTextString = parsetext format ["REQUESTING A TAXI TO<br/>CHOSEN DESTINATION...<br/><br/>"];
			hint _msg2HintTextString;
			// Inform via systemChat (in Text-Only format)
			_msg2SyschatTextString = parsetext format ["[SYSTEM]  REQUESTING A TAXI TO CHOSEN DESTINATION..."];
			systemChat (str _msg2SyschatTextString);
			if (_thisFileVerbosityLevelNumber>=5) then {diag_log format ["[mgmTfA]  [mgmTfA_fnc_client_clickNGoRequestTaxi.sqf]  [TV5] REQUESTING A TAXI TO CHOSEN DESTINATION...		(str _clickNGoTaxiRequestedDestinationPosition3DArray) is: (%1).", (str _clickNGoTaxiRequestedDestinationPosition3DArray)];};
			clickNGoTaxiDestinationChoser_systemReady = nil;

			///////// STEP:	PREPARE CLICKNGO REQUEST DETAILS
			// ~~
			mgmTfA_gv_pvs_clickNGoRequestorPlayerUIDTextString = (getPlayerUID player);
			mgmTfA_gv_pvs_clickNGoRequestorPositionArray3D = (getPosATL player);
			if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_client_clickNGoRequestTaxi.sqf]	[TV4]    clickNGo - I HAVE THE FOLLOWING DETAILS: mgmTfA_gv_pvs_clickNGoRequestorPlayerUIDTextString is: (%1).		mgmTfA_gv_pvs_clickNGoRequestorPositionArray3D is: (%2).", mgmTfA_gv_pvs_clickNGoRequestorPlayerUIDTextString, (str mgmTfA_gv_pvs_clickNGoRequestorPositionArray3D)];};
			
			///////// STEP:	MORE FINANCIAL STUFF
			// Charge the player for standard booking fee -- SEND REQUEST to server so that server will charge customer's wallet
			mgmTfA_gv_pvs_req_clickNGoTaxiChargeMeInitialBookingFeePleaseConfirmPacket = [player, mgmTfA_gv_pvs_clickNGoRequestorPlayerUIDTextString];
			publicVariableServer "mgmTfA_gv_pvs_req_clickNGoTaxiChargeMeInitialBookingFeePleaseConfirmPacket";
			// report to log
			if (_thisFileVerbosityLevelNumber>=5) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_client_clickNGoRequestTaxi.sqf] [TV5]          REQUEST SENT TO SERVER TO CHARGE			the player TaxiAnywhere Initial  Booking Fee (%1)", (str mgmTfA_configgv_clickNGoTaxisNonRefundableBookingFeeCostInCryptoNumber)];};


			// Inform the player that he just paid the Standard Booking Fee
			private	[
					"_msg2HintTextString",
					"_msg2SyschatTextString1",
					"_msg2SyschatTextString2"
					];
			_msg2HintTextString = parsetext format ["<img size='6' image='custom\mgmTfA\img_comms\mgmTfA_img_client_taxiPaymentReceivedManyThanks.jpg'/><br/><br/><t size='1.40' color='#00FF00'>%1<br/><br/>THANKS FOR PAYING<br/>THE CLICKNGO BOOKING FEE:<br/>%2 CRYPTO<br/><br/>PLEASE WAIT<br/>", (profileName), (str mgmTfA_configgv_clickNGoTaxisNonRefundableBookingFeeCostInCryptoNumber)];
			_msg2SyschatTextString1 = parsetext format ["[RADIO_IN]  %1 THANKS FOR PAYING THE CLICKNGO BOOKING FEE %2 CRYPTO", (profileName), (str mgmTfA_configgv_clickNGoTaxisNonRefundableBookingFeeCostInCryptoNumber)];
			_msg2SyschatTextString2 = parsetext format ["[RADIO_IN]  PROCESSING, PLEASE WAIT..."];
			// Print the message
			hint _msg2HintTextString;
			systemChat str _msg2SyschatTextString1;
			systemChat str _msg2SyschatTextString2;
			// SEND THE BOOKING TO THE SERVER
			if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_client_clickNGoRequestTaxi.sqf] [D4] (_bookingPermitted) is true. executing main function block now."];};//dbg

			// Do these at this stage
			mgmTfA_dynamicgv_lastclickNGoTaxiBookingRecordKeeperThisIsTheFirstTimeBool = false;
			mgmTfA_dynamicgv_lastclickNGoTaxiBookingPlacedAtTimestampInSecondsNumber = (time);
			// re-enable players access to the hotkey. this does not mean he can successfully place another booking in the next second (as cool down timer will prevent that)
			mgmTfA_dynamicgv_thisPlayerCanOrderclickNGoTaxiViaHotkey = true;

			///////// STEP:	PREPARE AND SUBMIT THE CLICKNGO REQUEST
			mgmTfA_gv_pvs_req_clickNGoTaxiToMyPositionPleaseConfirmPacket = [player, mgmTfA_gv_pvs_clickNGoRequestorPositionArray3D, mgmTfA_gv_pvs_clickNGoRequestorPlayerUIDTextString, _clickNGoTaxiRequestedDestinationPosition3DArray];
			publicVariableServer "mgmTfA_gv_pvs_req_clickNGoTaxiToMyPositionPleaseConfirmPacket";
			// ~~
		} else {
			// Player's current cash is NOT adequate to pay for the service fee		// Let the player know
			private	[
					"_msg2HintTextString",
					"_msg2SyschatTextString1",
					"_msg2SyschatTextString2"
					];
			_msg2HintTextString = parsetext format ["<img size='6' image='custom\mgmTfA\img_comms\mgmTfA_img_client_taxiCannotAfford.jpg'/><br/><br/><t size='1.40' color='#FF0037'>SORRY %1<br/><br/>YOU CANNOT AFFORD<br/>clickNGo MINIMUM<br/>PREPAY FEE:<br/>%2 CRYPTO<br/><br/>PLEASE TRY AGAIN<br/>WHEN YOU HAVE ENOUGH CASH<br/><br/>THANK YOU<br/>", (profileName), (str (round _journeyInitialCostInCryptoNumber))];
			_msg2SyschatTextString1 = parsetext format ["[RADIO_IN]  SORRY %1 YOU CANNOT AFFORD clickNGo MINIMUM PREPAY FEE %2 CRYPTO", (profileName), (str _journeyInitialCostInCryptoNumber)];
			_msg2SyschatTextString2 = parsetext format ["[RADIO_IN]  PLEASE TRY AGAIN WHEN YOU HAVE ENOUGH CASH. THANK YOU"];
			hint _msg2HintTextString;
			systemChat str _msg2SyschatTextString1;
			systemChat str _msg2SyschatTextString2;
			if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_client_clickNGoRequestTaxi.sqf] [D4] (_bookingPermitted) is true. executing main function block now."];};//dbg
			
			// re-enable players access to the hotkey. this does not mean he can successfully place another booking in the next second (as cool down timer will prevent that)
			mgmTfA_dynamicgv_thisPlayerCanOrderclickNGoTaxiViaHotkey = true;
		};
	} else {
		private	[
				"_msg2HintTextString",
				"_msg2SyschatTextString1",
				"_msg2SyschatTextString2"
				];
		// inform the player that he may not order a new clickNGo Taxi at this time as he already has one serving him!
		// with hint (Rich Format)
		_msg2HintTextString = parsetext format ["<img size='6' image='custom\mgmTfA\img_comms\mgmTfA_img_client_warningStopSign.jpg'/><br/><br/><t size='1.40' color='#00FF00'>SORRY %1!<br/><br/>YOU MAY NOT<br/>PLACE A BOOKING<br/>AT THIS TIME.<br/><br/>YOU ALREADY HAVE A<br/>TAXI SERVING YOU<br/>CURRENTLY", (profileName)];
		hint _msg2HintTextString;
		// with systemChat (Text-Only Format)
		_msg2SyschatTextString1 = parsetext format ["[RADIO_IN]  SORRY %1! YOU MAY NOT PLACE A BOOKING AT THIS TIME", (profileName)];
		_msg2SyschatTextString2 = parsetext format ["[RADIO_IN]  YOU ALREADY HAVE A TAXI SERVING YOU CURRENTLY"];
		systemChat str _msg2SyschatTextString1;
		systemChat str _msg2SyschatTextString2;
	};
};
if (_thisFileVerbosityLevelNumber>=5) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_client_clickNGoRequestTaxi.sqf]   [TV5]		Reached checkpoint: End of file."];};
// EOF