//H
//H ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_scr_client_TAChargeMe1stMileFee.sqf
//H $PURPOSE$	:	This script is executed when player clicks on '(pay) 1st Mile Fee' button on the GUI. (In the future might also add ActionMenu item to TaxiAnywhere vehicles).
//H					Script does the appropriate checks and if player is eligible to pay the 1st Mile Fee, a "CHARGE ME" request is sent to the server.
//H ~~
//H
//HH
//HH ~~
//HH	Syntax		:	_null = [] mgmTfA_scr_client_TAChargeMe1stMileFee
//HH	Parameters	:	none
//HH	Return Value:	none
//HH ~~
//HH 	
//HH	The shared configuration file has the following values this function rely on: mgmTfA_configgv_clickNGoTaxisAbsoluteMinimumJourneyFeeInCryptoNumber
//HH	This function does not create/update any global variables.
//HH	This function does rely on publicVariables containing the information about the Service Unit.
//HH
if (isServer) exitWith {}; if (isNil("mgmTfA_Client_Init")) then {mgmTfA_Client_Init=0;}; waitUntil {mgmTfA_Client_Init==1}; private ["_thisFileVerbosityLevelNumber"]; _thisFileVerbosityLevelNumber = mgmTfA_configgv_clientVerbosityLevel;

// CHECK: Player has requested to be charged 1st Mile Fee amount... Is the player even in a mgmTfAisclickNGoTaxi at the moment?
if (((vehicle player) getVariable ["mgmTfAisclickNGoTaxi", false])) then {
	// YES, the player is in a mgmTfAisclickNGoTaxi at the moment
	if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_scr_client_TAChargeMe1stMileFee.sqf] [TV8]     DETECTED     Player is currently in a clickNGoTaxi."];};

	private		[
				"_myVehiclesCommandingCustomerPlayerUIDNumber",
				"_playerMustPayBool",
				"_playerCashNumber",
				"_myGUSUIDNumber",
				//"_functionExecutionTimeInSecondsNumber",
				//"_emergencyEscapeNeeded",
				//"_tooManyFailedPAYGTransactionsObservedBool",
				"_myPUID"
				//"_playerWentBankruptBool",
				//"_checkedAndPlayerWasNotInAclickNGoVehicleCountNumber",
				//"_player"
				];

	// obtain vehicle's CommandingCustomer PUID		-- only CommandingCustomer can pay!
	_myVehiclesCommandingCustomerPlayerUIDNumber = (vehicle player) getVariable "commandingCustomerPlayerUIDNumber";
	if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_scr_client_TAChargeMe1stMileFee.sqf] [TV8]          I have just obtained (_myVehiclesCommandingCustomerPlayerUIDNumber) as: (%1).		My PUID is: (%2).", (str _myVehiclesCommandingCustomerPlayerUIDNumber), (str _myPUID)];};

	// is the local player supposed to pay the next tick?	NOTE: currently, we are running this function for all players on board even if they are not the requestor. in the future, on-the-fly "payingCustomer" switching will be supported, meaning requestor running out of money, from inside the vehicle, one of the other players can take over "PAYG payment" duty. this below is the prep.
	_myPUID = (getPlayerUID player);
	if (_myPUID == _myVehiclesCommandingCustomerPlayerUIDNumber) then {
		// YES, player is the commandingCustomer and mustPay the nextTick
		if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_scr_client_TAChargeMe1stMileFee.sqf] [TV8]          YES, player is the commandingCustomer and mustPay the nextTick.		_playerMustPayBool  is set to true."];};
		_playerMustPayBool = true;
	} else {
		if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_scr_client_TAChargeMe1stMileFee.sqf] [TV8]          NO, player is NOT the commandingCustomer and will not pay the nextTick.		_playerMustPayBool  is set to false."];};
		_playerMustPayBool = false;
	};
	// if player mustPay, 	CHECK: can the player afford the 1st Mile Fee?
	if (_playerMustPayBool) then {
		_playerCashNumber = (EPOCH_playerCrypto);

		if (_playerCashNumber >= mgmTfA_configgv_clickNGoTaxisAbsoluteMinimumJourneyFeeInCryptoNumber) then {
			// YES, player can afford the 1st Mile Fee - do nothing at this deep level, just proceed.
			if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_scr_client_TAChargeMe1stMileFee.sqf] [TV8]          YES, player can afford the 1st Mile Fee	-- sending a request to the server to get charged.	"];};

			// player will be charged the 1st Mile Fee amount now -- SEND REQUEST to server so that server will charge customer's wallet
			_myGUSUIDNumber = ((vehicle player) getVariable ["GUSUIDNumber", -1]);
			if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA]  [mgmTfA_scr_client_TAChargeMe1stMileFee.sqf] [TV8] _myGUSUIDNumber has been obtained as: (%1)", (str _myGUSUIDNumber)];};
			// convert to global to put on the wire
			myGUSUIDNumber = _myGUSUIDNumber;
			// PUID was already set in RequestTaxi section but just ensuring..
			mgmTfA_gv_pvs_clickNGoRequestorPlayerUIDTextString = (getPlayerUID player);
			mgmTfA_gv_pvs_req_TAChargeMe1stMileFeePacket = [player, mgmTfA_gv_pvs_clickNGoRequestorPlayerUIDTextString, myGUSUIDNumber];
			publicVariableServer "mgmTfA_gv_pvs_req_TAChargeMe1stMileFeePacket";
			// report to log
			if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_scr_client_TAChargeMe1stMileFee.sqf] [TV8]          CHARGED		the player TaxiAnywhere 1st Mile Fee cost	"];};

		} else {
			// NO, player cannot afford the 1st Mile Fee - log it
			if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_scr_client_TAChargeMe1stMileFee.sqf] [TV8]          NO, player cannot afford the next PAYGtickCost.	let him & the server now.	"];};
			// let the customer know via hint && systemChat
			private	[
					"_msg2HintTextString",
					"_messageTextOnlyFormat"
					];
			_msg2HintTextString = parsetext format ["<img size='6' image='custom\mgmTfA\img_comms\mgmTfA_img_client_taxiCannotAfford.jpg'/><br/><br/><t size='1.40' color='#00FF00'>%1<br/><br/>SORRY BUT YOU<br/>CANNOT AFFORD<br/>THE 1ST MILE FEE<br/><br/>%2 CRYPTO<br/><br/>HAVE A NICE DAY!<br/>", (profileName), (str mgmTfA_configgv_clickNGoTaxisAbsoluteMinimumJourneyFeeInCryptoNumber)];
			hint _msg2HintTextString;
			_messageTextOnlyFormat = parsetext format ["%1 SORRY BUT YOU CANNOT AFFORD THE 1ST MILE FEE %2 CRYPTO! HAVE A NICE DAY!", (profileName), (str mgmTfA_configgv_clickNGoTaxisAbsoluteMinimumJourneyFeeInCryptoNumber)];
			systemChat str _messageTextOnlyFormat;

			private	[
					"_msg2HintTextString",
					"_messageTextOnlyFormat"
					];
			_msg2HintTextString = parsetext format ["<img size='6' image='custom\mgmTfA\img_comms\mgmTfA_img_client_taxiCannotAfford.jpg'/><br/><br/><t size='1.40' color='#00FF00'>%1<br/><br/>SORRY BUT YOU<br/>CANNOT AFFORD<br/>THE 1ST MILE FEE<br/><br/>%2 CRYPTO<br/><br/>HAVE A NICE DAY!<br/>", (profileName), (str mgmTfA_configgv_clickNGoTaxisAbsoluteMinimumJourneyFeeInCryptoNumber)];
			_messageTextOnlyFormat = parsetext format ["%1 SORRY BUT YOU CANNOT AFFORD THE 1ST MILE FEE %2 CRYPTO! HAVE A NICE DAY!", (profileName), (str mgmTfA_configgv_clickNGoTaxisAbsoluteMinimumJourneyFeeInCryptoNumber)];
			// Print the message
			hint _msg2HintTextString;
			systemChat (str _messageTextOnlyFormat);
			_playerWentBankruptBool = true;
			// signal the server via customerCannotAffordService=true
			(vehicle player) setVariable ["customerCannotAffordService", true, true];
			// break out of main loop
			breakTo "mgmTfA_scr_client_TAChargeMe1stMileFeeMainScope";
		};
	} else {
		// NO, player does not have to pay the 1st Mile Fee
		if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_scr_client_TAChargeMe1stMileFee.sqf] [TV8]          NO, player does not have to pay the 1st Mile Fee"];};
	};
} else {
	// NO, the player is NOT in a mgmTfAisclickNGoTaxi at the moment		-- log it, inform player & quit
	if (_thisFileVerbosityLevelNumber>=5) then {diag_log format ["[mgmTfA] [mgmTfA_scr_client_TAChargeMe1stMileFee.sqf] [TV5]		DETECTED		Player currently IS NOT in a clickNGoTaxi!		The result of (str (((vehicle player) getVariable ['mgmTfAisclickNGoTaxi', false]))) is: (%1).", (str (((vehicle player) getVariable ["mgmTfAisclickNGoTaxi", false])))];};//dbg
	// let the player know via hint && systemChat
	private	[
			"_msg2HintTextString",
			"_msg2SyschatTextString"
			];
	// with hint
	_msg2HintTextString = parsetext format ["<img size='6' image='custom\mgmTfA\img_comms\mgmTfA_img_client_warningStopSign.jpg'/><br/><br/><t size='1.40' color='#00FF00'>SORRY %1!<br/>YOU CANNOT PAY<br/>TAXI-ANYWHERE 1ST MILE FEE<br/>AS YOU ARE NOT<br/>IN A TAXI-ANYWHERE VEHICLE", (profileName)];
	hint _msg2HintTextString;
	// with systemChat
	_msg2SyschatTextString = parsetext format ["SORRY %1! YOU CANNOT PAY TAXI-ANYWHERE 1ST MILE FEE AS YOU ARE NOT IN A TAXI-ANYWHERE VEHICLE", (profileName)];
	systemChat str _msg2SyschatTextString;
};
