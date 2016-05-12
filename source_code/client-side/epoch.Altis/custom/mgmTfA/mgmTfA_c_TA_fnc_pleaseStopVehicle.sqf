//H
//H
//H ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_c_TA_fnc_pleaseStopVehicle.sqf
//H $PURPOSE$	:	When a player click on "Exit Vehicle" button on the GUI, we trigger and do all the necessary checks and if deem it an eligible stopVehReq, we pass it on to the server-side via a PVS
//H ~~
//H
//HH
//HH ~~
//HH	Syntax		:	_null = [] mgmTfA_c_TA_fnc_pleaseStopVehicle
//HH	Parameters	:	none
//HH	Return Value:	none
//HH ~~
//HH	The shared configuration file has the following values this function rely on: none
//HH	This function updates the following global variable(s):	mgmTfA_dynamicgv_thisPlayerCanOrderTATaxiViaHotkey
//HH
if (isServer) exitWith {}; if (isNil("mgmTfA_Client_Init")) then {mgmTfA_Client_Init=0;}; waitUntil {mgmTfA_Client_Init==1}; private ["_thisFileVerbosityLevelNumber"]; _thisFileVerbosityLevelNumber = mgmTfA_configgv_clientVerbosityLevel;
scopeName "mgmTfA_c_TA_fnc_pleaseStopVehicleMainScope";
waitUntil {!isnull (finddisplay 46)};

// FUNCTION - begin
if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_fnc_pleaseStopVehicle.sqf]  [TV8] INFORMATION	I have been called"];};

private	[
		"_playerIsAuthorizedToRequestAVehicleStop",
		"_setting",
		"_msg2HintTextString",
		"_messageTextOnlyFormat1"
		];

// by default, player is not authorized to request vehicle stop
_playerIsAuthorizedToRequestAVehicleStop = false;

// CHECK: Player has requested 'this TaxiAnywhereTaxi" to be (immediately stopped & doors unlocked). let's check is the player even in a TaxiAnywhereTaxi vehicle at the moment?
if (((vehicle player) getVariable ["mgmTfAisTATaxi", false])) then {

	// YES, the player is in a TaxiAnywhereTaxi at the moment		-- log it
	if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_fnc_pleaseStopVehicle.sqf] [TV8]     DETECTED     Player is currently in a TaxiAnywhereTaxi."];};

	// CHECK: Does server CONFIGURATION allow stopVehicle?
	_setting = mgmTfA_configgv_taxiAnywherePlayersCanRequestAVehicleStopNumber;
	if (_thisFileVerbosityLevelNumber>=10) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_fnc_pleaseStopVehicle.sqf] [TV8]     DETECTED     (_setting) is: (%1).		SWITCHing now		.", (str _setting)];};

	switch _setting do {
		case 0: {
			// 0 = nobody is allowed to request 'stopVehicle'	-- we will let the customer know via hint && systemChat. DRIVER will send the msg.
			_msg2HintTextString = parsetext format ["[DRIVER]  <img size='6' image='custom\mgmTfA\img\mgmTfA_c_CO_img_warningSign.jpg'/><br/><br/><t size='1.40' color='#00FF00'><br/>SORRY %1<br/><br/><br/>EXITING VEHICLE<br/>MID-JOURNEY<br/>IS NOT ALLOWED<br/><br/>", (profileName)];
			_messageTextOnlyFormat1 = parsetext format ["[DRIVER]  %1 SORRY, EXITING VEHICLE MID-JOURNEY IS NOT ALLOWED", (profileName)];
			hint _msg2HintTextString;
			systemChat (str _messageTextOnlyFormat1);
	 			["<t size='1.6' color='#99ffffff'>[DRIVER] Exiting vehicle mid-journey is not allowed</t>", 5] call Epoch_dynamicText;
			};
		case 1: {
			// 1 = only commandingPlayer is allowed to request 'stopVehicle'	-- let's check if local player == commandingPlayer for this vehicle


			hint "case is '1'";
			//TODO ADD CHECKS HERE -- commmanding player?
 			//			// let the customer know the outcome, via hint && systemChat. DRIVER will send the msg.
			//			_msg2HintTextString = parsetext format ["[DRIVER]  <img size='6' image='custom\mgmTfA\img\mgmTfA_c_CO_img_warningSign.jpg'/><br/><br/><t size='1.40' color='#00FF00'><br/>SORRY %1!<br/><br/><br/>EXITING VEHICLE<br/>MID-JOURNEY<br/>IS NOT ALLOWED<br/><br/>", (profileName)];
			//			_messageTextOnlyFormat1 = parsetext format ["[DRIVER]  %1 SORRY BUT EXITING VEHICLE MID-JOURNEY IS NOT ALLOWED", (profileName)];
			//			hint _msg2HintTextString;
			//			systemChat (str _messageTextOnlyFormat1);
	 		//				["<t size='1.6' color='#99ffffff'>[DRIVER] Exiting vehicle mid-journey is not allowed</t>", 5] call Epoch_dynamicText;
			//			};
		};

		default {
			hint "case is 'default'";
			["<t size='1.6' color='#99ffffff'>Case is 1</t>", 5] call Epoch_dynamicText;
		};

		case 2: {
			// 2 = any passenger player is allowed to request 'stopVehicle'		-- therefore this player (any player) can request stop for the current TaxiAnywhere veh.		-- we will let the customer know via hint && systemChat. DRIVER will send the msg.
			_msg2HintTextString = parsetext format ["<img size='6' image='custom\mgmTfA\img\mgmTfA_c_CO_img_requestApproved.jpg'/><br/><br/><t size='1.40' color='#00FF00'>%1<br/><br/>WE ARE STOPPING<br/>AS REQUESTED<br/><br/><br/><br/></t>", (profileName)];
			_messageTextOnlyFormat1 = parsetext format ["[DRIVER]  %1 WE ARE STOPPING<br/>AS REQUESTED", (profileName)];
			hint _msg2HintTextString;
			systemChat (str _messageTextOnlyFormat1);
	 			["<t size='1.6' color='#99ffffff'>[DRIVER] Exiting vehicle mid-journey is not allowed</t>", 5] call Epoch_dynamicText;
			};
		};
} else {
	// NO, the player is NOT in a TaxiAnywhereTaxi at the moment		-- log it, inform player & quit
	if (_thisFileVerbosityLevelNumber>=5) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_fnc_pleaseStopVehicle.sqf] [TV5]		DETECTED		Player currently IS NOT in a TaxiAnywhereTaxi!		The result of (str (((vehicle player) getVariable ['mgmTfAisTATaxi', false]))) is: (%1).", (str (((vehicle player) getVariable ["mgmTfAisTATaxi", false])))];};//dbg
	// let the player know via hint && systemChat
	private	[
			"_msg2HintTextString",
			"_msg2SyschatTextString"
			];
	// with hint
	_msg2HintTextString = parsetext format ["<img size='6' image='custom\mgmTfA\img\mgmTfA_c_CO_img_warningSign.jpg'/><br/><br/><t size='1.40' color='#00FF00'><br/>SORRY %1<br/><br/><br/>YOU ARE NOT<br/>IN A TAXI ANYWHERE VEHICLE<br/><br/>", (profileName)];
	hint _msg2HintTextString;
	_msg2SyschatTextString = parsetext format ["[SYSTEM]  SORRY %1! YOU ARE NOT IN A TAXI ANYWHERE VEHICLE"];
	systemChat str _msg2SyschatTextString;
};
// EOF