//H
//H ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_c_TA_scr_chargeMe1stMileFee.sqf
//H $PURPOSE$	:	This script is executed when player clicks on '(pay) 1st Mile Fee' button on the GUI. (In the future might also add ActionMenu item to TaxiAnywhere vehicles).
//H					Script does the appropriate checks and if player is eligible to pay the 1st Mile Fee, a "CHARGE ME" request is sent to the server.
//H ~~
//H
//HH
//HH ~~
//HH	Syntax		:	_null = [] mgmTfA_c_TA_scr_chargeMe1stMileFee
//HH	Parameters	:	none
//HH	Return Value:	none
//HH ~~
//HH 	
//HH	The shared configuration file has the following values this function rely on: mgmTfA_configgv_taxiAnywhereTaxisAbsoluteMinimumJourneyFeeInCryptoNumber
//HH	This function does not create/update any global variables.
//HH	This function does rely on publicVariables containing the information about the Service Unit.
//HH
if (isServer) exitWith {}; if (isNil("mgmTfA_Client_Init")) then {mgmTfA_Client_Init=0;}; waitUntil {mgmTfA_Client_Init==1}; private ["_thisFileVerbosityLevelNumber"]; _thisFileVerbosityLevelNumber = mgmTfA_configgv_clientVerbosityLevel;

// CHECK: Player has requested to be charged 1st Mile Fee amount... Is the player even in a mgmTfAisTATaxi at the moment?
if (((vehicle player) getVariable ["mgmTfAisTATaxi", false])) then {
	// YES, the player is in a mgmTfAisTATaxi at the moment
	if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_scr_chargeMe1stMileFee.sqf] [TV8]     DETECTED     Player is currently in a TATaxi."];};

	private		[
				"_myVehiclesCommandingCustomerPlayerUIDNumber",
				"_playerAuthorizedToPayBool",
				"_playerCashNumber",
				"_myGUSUIDNumber",
				"_myPUID",
				"_TA1stMileFeeNeedToBePaidBool"
				];

	_myGUSUIDNumber = ((vehicle player) getVariable ["GUSUIDNumber", -1]);
	if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_scr_chargeMe1stMileFee.sqf] [TV8] _myGUSUIDNumber has been obtained as: (%1)", (str _myGUSUIDNumber)];};
	// check vehicle payment await status here
	_TA1stMileFeeNeedToBePaidBool = call compile format ["mgmTfA_gv_PV_SU%1SUTA1stMileFeeNeedToBePaidBool", _myGUSUIDNumber];
	if (_thisFileVerbosityLevelNumber>=5) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_scr_chargeMe1stMileFee.sqf] [TV4] This is _myGUSUIDNumber: (%1)		TOP OF FUNCTION EVALUATION 		(_TA1stMileFeeNeedToBePaidBool) is DETECTED: (%2)			", (str _myGUSUIDNumber), (str _TA1stMileFeeNeedToBePaidBool)];};
	// obtain vehicle's CommandingCustomer PUID		-- only CommandingCustomer can pay!
	_myVehiclesCommandingCustomerPlayerUIDNumber = (vehicle player) getVariable "commandingCustomerPlayerUIDNumber";
	_myPUID = (getPlayerUID player);
	if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_scr_chargeMe1stMileFee.sqf] [TV8]          I have just obtained (_myVehiclesCommandingCustomerPlayerUIDNumber) as: (%1).		My PUID is: (%2).", (str _myVehiclesCommandingCustomerPlayerUIDNumber), (str _myPUID)];};

	// is the local player authorized to pay the 1st Mile Fee?	NOTE: currently, we are running this function for all players on board even if they are not the requestor. in the future, on-the-fly "payingCustomer" switching will be supported, meaning requestor running out of money, from inside the vehicle, one of the other players can take over "PAYG payment" duty. this below is the prep.
	if (_myPUID == _myVehiclesCommandingCustomerPlayerUIDNumber) then {
		// YES, player is the commandingCustomer and therefore authorized to pay the 1st Mile Fee
		if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_scr_chargeMe1stMileFee.sqf] [TV8]          YES, player is the commandingCustomer and mustPay the 1st Mile Fee.		_playerAuthorizedToPayBool  is set to true."];};
		_playerAuthorizedToPayBool = true;
	} else {
		if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_scr_chargeMe1stMileFee.sqf] [TV8]          NO, player is NOT the commandingCustomer and will not pay 1st Mile Fee.		_playerAuthorizedToPayBool  is set to false."];};
		_playerAuthorizedToPayBool = false;
	};

	// if _playerAuthorizedToPayBool, 	CHECK: is this vehicle waiting for 1st Mile Fee payment?
	if (_playerAuthorizedToPayBool) then {
		if (_TA1stMileFeeNeedToBePaidBool) then {
			// YES, this vehicle is awaiting 1st Mile Fee payment (and player is authorized to pay) --log & carry on
			if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_scr_chargeMe1stMileFee.sqf] [TV8]          YES, this vehicle is awaiting 1st Mile Fee payment.	"];};
		} else {
			// NO, this vehicle IS NOT awaiting 1st Mile Fee payment
			if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_scr_chargeMe1stMileFee.sqf] [TV8]          NO, this vehicle IS NOT awaiting 1st Mile Fee payment.	"];};
			private	[
					"_msg2HintTextString",
					"_messageTextOnlyFormat"
					];
			// do a check here - is the 1st Mile Fee TURNED OFF or has it been ALREADY PAID?
			if (mgmTfA_configgv_taxiAnywhereTaxisAbsoluteMinimumJourneyFeeInCryptoNumber > 0) then {
				// yes 1st Mile Fee is enabled and since it does not need to be paid now, it appears this has already been paid! -- log what we learned and do 1stMileFeePayRequestor comms
				if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_scr_chargeMe1stMileFee.sqf] [TV3] 	DETECTED: 	DUPLICATE PAYMENT ATTEMPT		1st Mile Fee is ENABLED but does NOT NEED TO BE PAID now.		"];};
				// do 1stMileFeePayRequestor comms
				_msg2HintTextString = parsetext format ["<img size='6' image='custom\mgmTfA\img\mgmTfA_img_client_warningStopSign.jpg'/><br/><br/><t size='1.40' color='#FF0037'>SORRY %1!<br/><br/>1ST MILE FEE<br/>HAS ALREADY<br/>BEEN PAID<br/><br/>", (profileName)];
				_msg2SyschatTextString = parsetext format ["SORRY %1! 1ST MILE FEE HAS ALREADY BEEN PAID", (profileName)];
				hint _msg2HintTextString;
				systemChat (str _msg2SyschatTextString);
			} else {
				// no 1st Mile Fee is not enabled and thus it does not need to be paid -- log what we learned
				if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_scr_chargeMe1stMileFee.sqf] [TV3] 	DETECTED: 	PLAYER ATTEMPTED TO PAY UNNECESSARILY 		1st Mile Fee is NOT ENABLED on this server.		"];};
				// do 1stMileFeePayRequestor comms
				_msg2HintTextString = parsetext format ["<img size='6' image='custom\mgmTfA\img\mgmTfA_img_client_warningStopSign.jpg'/><br/><br/><t size='1.40' color='#FF0037'>SORRY %1!<br/><br/>1ST MILE FEE<br/>IS DISABLED<br/><br/>", (profileName)];
				_msg2SyschatTextString = parsetext format ["SORRY %1! 1ST MILE FEE IS DISABLED", (profileName)];
				hint _msg2HintTextString;
				systemChat (str _msg2SyschatTextString);
			};
		};
	} else {
		// NO, player is not authorized to pay the 1st Mile Fee
		if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_scr_chargeMe1stMileFee.sqf] [TV8]          NO, player is not authorized to pay the 1st Mile Fee"];};
	};
	// if _playerAuthorizedToPayBool AND vehicle waiting for payment, then, 	CHECK: can the player afford the 1st Mile Fee?
	if (_playerAuthorizedToPayBool && _TA1stMileFeeNeedToBePaidBool) then {
		_playerCashNumber = (EPOCH_playerCrypto);

		if (_playerCashNumber >= mgmTfA_configgv_taxiAnywhereTaxisAbsoluteMinimumJourneyFeeInCryptoNumber) then {
			// YES, player can afford the 1st Mile Fee - do nothing at this deep level, just proceed.
			if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_scr_chargeMe1stMileFee.sqf] [TV8]          YES, player can afford the 1st Mile Fee	-- sending a request to the server to get charged.	"];};

			// player will be charged the 1st Mile Fee amount now -- SEND REQUEST to server so that server will charge customer's wallet
			_myGUSUIDNumber = ((vehicle player) getVariable ["GUSUIDNumber", -1]);
			if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_scr_chargeMe1stMileFee.sqf] [TV8] _myGUSUIDNumber has been obtained as: (%1)", (str _myGUSUIDNumber)];};
			// convert to global to put on the wire
			myGUSUIDNumber = _myGUSUIDNumber;
			// PUID was already set in RequestTaxi section but just ensuring..
			mgmTfA_gv_pvs_taxiAnywhereRequestorPlayerUIDTextString = (getPlayerUID player);
			mgmTfA_gv_pvs_req_TAChargeMe1stMileFeePacket = [player, mgmTfA_gv_pvs_taxiAnywhereRequestorPlayerUIDTextString, myGUSUIDNumber];
			publicVariableServer "mgmTfA_gv_pvs_req_TAChargeMe1stMileFeePacket";
			// report to log
			if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_scr_chargeMe1stMileFee.sqf] [TV8]          CHARGED		the player TaxiAnywhere 1st Mile Fee cost	"];};
		} else {
			// NO, player cannot afford the 1st Mile Fee - log it
			if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_scr_chargeMe1stMileFee.sqf] [TV8]          NO, player cannot afford the next 1st Mile Fee.	let him & the server now.	"];};
			// let the customer know via hint && systemChat
			private	[
					"_msg2HintTextString",
					"_messageTextOnlyFormat1",
					"_messageTextOnlyFormat2"
					];
			_msg2HintTextString = parsetext format ["<img size='6' image='custom\mgmTfA\img\mgmTfA_img_client_taxiCannotAfford.jpg'/><br/><br/><t size='1.40' color='#00FF00'>%1<br/><br/>SORRY BUT YOU<br/>CANNOT AFFORD<br/>THE 1ST MILE FEE<br/><br/>%2 CRYPTO<br/><br/>HAVE A NICE DAY!<br/>", (profileName), (str mgmTfA_configgv_taxiAnywhereTaxisAbsoluteMinimumJourneyFeeInCryptoNumber)];
			_messageTextOnlyFormat1 = parsetext format ["[DRIVER]  %1 SORRY BUT YOU CANNOT AFFORD THE 1ST MILE FEE %2 CRYPTO", (profileName), (str mgmTfA_configgv_taxiAnywhereTaxisAbsoluteMinimumJourneyFeeInCryptoNumber)];
			_messageTextOnlyFormat2 = parsetext format ["[DRIVER]  HAVE A NICE DAY!"];
			hint _msg2HintTextString;
			systemChat (str _messageTextOnlyFormat1);
			systemChat (str _messageTextOnlyFormat2);
			_playerWentBankruptBool = true;
			if (_playerWentBankruptBool) then {if (mgmTfA_configgv_clientVerbosityLevel>=5) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_scr_chargeMe1stMileFee.sqf] [TV5]				I noticed (_playerWentBankruptBool) is  true!	"];};};
			// signal the server via customerCannotAffordService=true
			(vehicle player) setVariable ["customerCannotAffordService", true, true];
			// break out of main loop
			breakTo "mgmTfA_c_TA_scr_chargeMe1stMileFeeMainScope";
		};
	} else {
		// NO, player does not have to pay the 1st Mile Fee
		if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_scr_chargeMe1stMileFee.sqf] [TV8]          NO, player does not have to pay the 1st Mile Fee"];};
	};
} else {
	// NO, the player is NOT in a mgmTfAisTATaxi at the moment		-- log it, inform player & quit
	if (_thisFileVerbosityLevelNumber>=5) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_scr_chargeMe1stMileFee.sqf] [TV5]		DETECTED		Player currently IS NOT in a TATaxi!		The result of (str (((vehicle player) getVariable ['mgmTfAisTATaxi', false]))) is: (%1).", (str (((vehicle player) getVariable ["mgmTfAisTATaxi", false])))];};//dbg
	// let the player know via hint && systemChat
	private	[
			"_msg2HintTextString",
			"_msg2SyschatTextString1",
			"_msg2SyschatTextString2"
			];
	// with hint
	_msg2HintTextString = parsetext format ["<img size='6' image='custom\mgmTfA\img\mgmTfA_img_client_warningStopSign.jpg'/><br/><br/><t size='1.40' color='#00FF00'><br/>SORRY %1!<br/><br/><br/>YOU CANNOT PAY<br/>TAXI ANYWHERE<br/>1ST MILE FEE<br/><br/>AS YOU ARE<br/>NOT IN A<br/>TAXI ANYWHERE<br/>VEHICLE<br/><br/>", (profileName)];
	hint _msg2HintTextString;
	// with systemChat
	_msg2SyschatTextString1 = parsetext format ["[SYSTEM]  SORRY %1! YOU CANNOT PAY TAXI ANYWHERE 1ST MILE FEE", (profileName)];
	_msg2SyschatTextString2 = parsetext format ["[SYSTEM]  AS YOU ARE NOT IN A TAXI ANYWHERE VEHICLE"];
	systemChat str _msg2SyschatTextString1;
	systemChat str _msg2SyschatTextString2;
};
// EOF