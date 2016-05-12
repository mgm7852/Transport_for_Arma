//H
//H ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_c_FD_scr_chargeMeServiceFee.sqf
//H $PURPOSE$	:	This script triggers when the 'Pay Fixed Destination Taxi Service Fee' GUI button is clicked
//H					We do several checks to ensure this is a valid request
//H					Once we confirm button-clicker is authorized to & able to pay FDTServiceFee, we signal the server-side to "incur charges" on the local player.
//H ~~
//H
//HH
//H ~~
//HH	Syntax		:	_null = [] mgmTfA_c_FD_scr_chargeMeServiceFee
//HH	Parameters	:	none
//HH	Return Value	:	none
//H ~~
//HH	The shared configuration file has the following values this function rely on: none
//HH	This function updates the following global variable(s):
//HH		none
//HH	This function relies on the following global variable(s):
//HH		mgmTfA_dynamicgv_journeyServiceFeeCostInCryptoNumber	-- created by mgmTfA_c_FD_fnc_sendBookingRequestForFDTaxi
//HH
if (isServer) exitWith {}; if (isNil("mgmTfA_Client_Init")) then {mgmTfA_Client_Init=0;}; waitUntil {mgmTfA_Client_Init==1}; private ["_thisFileVerbosityLevelNumber"]; _thisFileVerbosityLevelNumber = mgmTfA_configgv_clientVerbosityLevel;

// CHECK: Player has requested to be charged Service Fee amount... Is the player even in a FixedDestinationTaxi at the moment?
if (((vehicle player) getVariable ["mgmTfAisfixedDestinationTaxi", false])) then {
	// YES, the player is in a FixedDestinationTaxi at the moment
	if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_FD_scr_chargeMeServiceFee.sqf] [TV8]     DETECTED     Player is currently in a FixedDestinationTaxi."];};

	private		[
				"_myVehiclesCommandingCustomerPlayerUIDNumber",
				"_playerAuthorizedToPayBool",
				"_playerCashNumber",
				"_myGUSUIDNumber",
				"_myPUID",
				"_FD_serviceFeeNeedToBePaidBool"
				];

	_myGUSUIDNumber = ((vehicle player) getVariable ["GUSUIDNumber", -1]);
	if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_FD_scr_chargeMeServiceFee.sqf] [TV8] _myGUSUIDNumber has been obtained as: (%1)", (str _myGUSUIDNumber)];};
	// check vehicle payment await status here
	_FD_serviceFeeNeedToBePaidBool = call compile format ["mgmTfA_gv_PV_SU%1SUFDServiceFeeNeedToBePaidBool", _myGUSUIDNumber];
	if (_thisFileVerbosityLevelNumber>=5) then {diag_log format ["[mgmTfA] [mgmTfA_c_FD_scr_chargeMeServiceFee.sqf] [TV4] This is _myGUSUIDNumber: (%1)		TOP OF FUNCTION EVALUATION 		(_FD_serviceFeeNeedToBePaidBool) is DETECTED: (%2)			", (str _myGUSUIDNumber), (str _FD_serviceFeeNeedToBePaidBool)];};
	// obtain vehicle's CommandingCustomer PUID		-- only CommandingCustomer can pay!
	_myVehiclesCommandingCustomerPlayerUIDNumber = (vehicle player) getVariable "commandingCustomerPlayerUIDNumber";
	_myPUID = (getPlayerUID player);
	if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_FD_scr_chargeMeServiceFee.sqf] [TV8]          I have just obtained (_myVehiclesCommandingCustomerPlayerUIDNumber) as: (%1).		My PUID is: (%2).", (str _myVehiclesCommandingCustomerPlayerUIDNumber), (str _myPUID)];};

	// is the local player authorized to pay the Service Fee?	NOTE: currently, we are running this function for all players on board even if they are not the requestor. in the future, on-the-fly "payingCustomer" switching will be supported, meaning requestor running out of money, from inside the vehicle, one of the other players can take over "PAYG payment" duty. this below is the prep.
	if (_myPUID == _myVehiclesCommandingCustomerPlayerUIDNumber) then {
		// YES, player is the commandingCustomer and therefore authorized to pay the Service Fee
		if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_FD_scr_chargeMeServiceFee.sqf] [TV8]          YES, player is the commandingCustomer and mustPay the Service Fee.		_playerAuthorizedToPayBool  is set to true."];};
		_playerAuthorizedToPayBool = true;
	} else {
		if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_FD_scr_chargeMeServiceFee.sqf] [TV8]          NO, player is NOT the commandingCustomer and will not pay Service Fee.		_playerAuthorizedToPayBool  is set to false."];};
		_playerAuthorizedToPayBool = false;
	};

	// if _playerAuthorizedToPayBool, 	CHECK: is this vehicle waiting for Service Fee payment?
	if (_playerAuthorizedToPayBool) then {
		if (_FD_serviceFeeNeedToBePaidBool) then {
			// YES, this vehicle is awaiting Service Fee payment (and player is authorized to pay) --log & carry on
			if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_FD_scr_chargeMeServiceFee.sqf] [TV8]          YES, this vehicle is awaiting Service Fee payment.	(and player is authorized to pay)	"];};
		} else {
			// NO, this vehicle IS NOT awaiting Service Fee payment
			if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_FD_scr_chargeMeServiceFee.sqf] [TV8]          NO, this vehicle IS NOT awaiting Service Fee payment.	"];};
			private	[
					"_msg2HintTextString",
					"_messageTextOnlyFormat"
					];
			// we DO NOT NEED a payment but why?	do a check here: (a) are both costs zero	or	(b) it was greater than zero but has already been paid?
			// if either of the two global(server config level) variables are greater than zero then the service fee must have been greater than zero
			if	(
					(mgmTfA_configgv_fixedDestinationTaxisServiceFeeBaseFeeInCryptoNumber > 0) ||
					(mgmTfA_configgv_fixedDestinationTaxisServiceFeeCostForTravellingAdditional100MetresInCryptoNumber > 0)
				) then {
				// YES Service Fee is greater than zero and since it does not need to be paid now, it appears this has already been paid! -- log what we learned and do ServiceFeePayRequestor comms
				if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_c_FD_scr_chargeMeServiceFee.sqf] [TV3] 	DETECTED: 	DUPLICATE PAYMENT ATTEMPT		Service Fee is ENABLED but does NOT NEED TO BE PAID now.		"];};
				// do ServiceFeePayRequestor comms
				_msg2HintTextString = parsetext format ["<img size='6' image='custom\mgmTfA\img\mgmTfA_c_CO_img_warningSign.jpg'/><br/><br/><t size='1.40' color='#FF0037'>SORRY %1!<br/><br/>SERVICE FEE<br/>HAS ALREADY<br/>BEEN PAID<br/><br/>", (profileName)];
				_msg2SyschatTextString = parsetext format ["SORRY %1! SERVICE FEE HAS ALREADY BEEN PAID", (profileName)];
				hint _msg2HintTextString;
				systemChat (str _msg2SyschatTextString);
			} else {
				// NO Service Fee is zero and thus it does not need to be paid -- log what we learned
				if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_c_FD_scr_chargeMeServiceFee.sqf] [TV3] 	DETECTED: 	PLAYER ATTEMPTED TO PAY UNNECESSARILY 		Service Fee is NOT ENABLED on this server.		"];};
				// do ServiceFeePayRequestor comms
				_msg2HintTextString = parsetext format ["<img size='6' image='custom\mgmTfA\img\mgmTfA_c_CO_img_warningSign.jpg'/><br/><br/><t size='1.40' color='#FF0037'>SORRY %1!<br/><br/>SERVICE FEE<br/>IS ZERO<br/><br/>", (profileName)];
				_msg2SyschatTextString = parsetext format ["SORRY %1! SERVICE FEE IS ZERO", (profileName)];
				hint _msg2HintTextString;
				systemChat (str _msg2SyschatTextString);
			};
		};
	} else {
		// NO, player is not authorized to pay the Service Fee
		if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_FD_scr_chargeMeServiceFee.sqf] [TV8]          NO, player is not authorized to pay the Service Fee"];};
	};
	// if _playerAuthorizedToPayBool AND vehicle waiting for payment, then, 	CHECK: can the player afford the Service Fee?
	if (_playerAuthorizedToPayBool && _FD_serviceFeeNeedToBePaidBool) then {
		_playerCashNumber = (EPOCH_playerCrypto);

		if (_playerCashNumber >= mgmTfA_dynamicgv_journeyServiceFeeCostInCryptoNumber) then {
			// YES, player can afford the Service Fee - do nothing at this deep level, just proceed.
			if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_FD_scr_chargeMeServiceFee.sqf] [TV8]          YES, player can afford the Service Fee	-- sending a request to the server to get charged.	"];};

			// player will be charged the Service Fee amount now -- SEND REQUEST to server so that server will charge customer's wallet
			_myGUSUIDNumber = ((vehicle player) getVariable ["GUSUIDNumber", -1]);
			if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_FD_scr_chargeMeServiceFee.sqf] [TV8] _myGUSUIDNumber has been obtained as: (%1)", (str _myGUSUIDNumber)];};
			// convert to global to put on the wire
			myGUSUIDNumber = _myGUSUIDNumber;
			// PUID was already set in RequestTaxi section but just ensuring..
			mgmTfA_gv_pvs_taxiAnywhereRequestorPlayerUIDTextString = (getPlayerUID player);
			mgmTfA_gv_pvs_req_FD_chargeMeServiceFeePacket = [player, mgmTfA_gv_pvs_taxiAnywhereRequestorPlayerUIDTextString, myGUSUIDNumber, mgmTfA_dynamicgv_journeyServiceFeeCostInCryptoNumber];
			publicVariableServer "mgmTfA_gv_pvs_req_FD_chargeMeServiceFeePacket";
			// report to log
			if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_FD_scr_chargeMeServiceFee.sqf] [TV8]          CHARGED		the player TaxiAnywhere Service Fee cost	"];};
		} else {
			// NO, player cannot afford the Service Fee - log it
			if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_FD_scr_chargeMeServiceFee.sqf] [TV8]          NO, player cannot afford the next Service Fee.	let him & the server now.	"];};
			// let the customer know via hint && systemChat
			private	[
					"_msg2HintTextString",
					"_messageTextOnlyFormat1",
					"_messageTextOnlyFormat2"
					];
			_msg2HintTextString = parsetext format ["<img size='6' image='custom\mgmTfA\img\mgmTfA_c_CO_img_cannotAfford.jpg'/><br/><br/><t size='1.40' color='#00FF00'>%1<br/><br/>SORRY BUT YOU<br/>CANNOT AFFORD<br/>THE Service Fee<br/><br/>%2 CRYPTO<br/><br/>HAVE A NICE DAY!<br/>", (profileName), (str mgmTfA_configgv_taxiAnywhereTaxisAbsoluteMinimumJourneyFeeInCryptoNumber)];
			_messageTextOnlyFormat1 = parsetext format ["[DRIVER]  %1 SORRY BUT YOU CANNOT AFFORD THE Service Fee %2 CRYPTO", (profileName), (str mgmTfA_configgv_taxiAnywhereTaxisAbsoluteMinimumJourneyFeeInCryptoNumber)];
			_messageTextOnlyFormat2 = parsetext format ["[DRIVER]  HAVE A NICE DAY!"];
			hint _msg2HintTextString;
			systemChat (str _messageTextOnlyFormat1);
			systemChat (str _messageTextOnlyFormat2);
			_playerWentBankruptBool = true;
			if (_playerWentBankruptBool) then {if (mgmTfA_configgv_clientVerbosityLevel>=5) then {diag_log format ["[mgmTfA] [mgmTfA_c_FD_scr_chargeMeServiceFee.sqf] [TV5]				I noticed (_playerWentBankruptBool) is  true!	"];};};
			// signal the server via customerCannotAffordService=true
			(vehicle player) setVariable ["customerCannotAffordService", true, true];
			// break out of main loop
			breakTo "mgmTfA_c_TA_scr_chargeMe1stMileFee";
		};
	} else {
		// NO, player does not have to pay the Service Fee
		if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_FD_scr_chargeMeServiceFee.sqf] [TV8]          NO, player does not have to pay the Service Fee"];};
	};
} else {
	// NO, the player is NOT in a mgmTfAisfixedDestinationTaxi at the moment		-- log it, inform player & quit
	if (_thisFileVerbosityLevelNumber>=5) then {diag_log format ["[mgmTfA] [mgmTfA_c_FD_scr_chargeMeServiceFee.sqf] [TV5]		DETECTED		Player currently IS NOT in a FixedDestinationTaxi!		The result of (str (((vehicle player) getVariable ['mgmTfAisfixedDestinationTaxi', false]))) is: (%1).", (str (((vehicle player) getVariable ["mgmTfAisfixedDestinationTaxi", false])))];};//dbg
	// let the player know via hint && systemChat
	private	[
			"_msg2HintTextString",
			"_msg2SyschatTextString1",
			"_msg2SyschatTextString2"
			];
	// with hint
	_msg2HintTextString = parsetext format ["<img size='6' image='custom\mgmTfA\img\mgmTfA_c_CO_img_warningSign.jpg'/><br/><br/><t size='1.40' color='#00FF00'><br/>SORRY %1!<br/><br/><br/>YOU CANNOT PAY<br/>FD TAXI SERVICE FEE<br/><br/>AS YOU ARE NOT IN A<br/>FIXED DESTINATION TAXI<br/><br/>", (profileName)];
	hint _msg2HintTextString;
	// with systemChat
	_msg2SyschatTextString1 = parsetext format ["[SYSTEM]  SORRY %1! YOU CANNOT PAY FD TAXI SERVICE FEE", (profileName)];
	_msg2SyschatTextString2 = parsetext format ["[SYSTEM]  AS YOU ARE NOT IN A FIXED DESTINATION TAXI"];
	systemChat str _msg2SyschatTextString1;
	systemChat str _msg2SyschatTextString2;
};
// EOF