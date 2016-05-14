//H
//H
//H ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_c_TA_fnc_pleaseStopVehicle.sqf
//H $PURPOSE$	:	When a player click on "Exit Vehicle" button on the GUI, this function is called; does all the necessary checks, and if deems it an eligible stopVehReq, passes it on to the server-side via a PVS
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
		"_playerInTAVehicleBool",
		"_playerIsAuthorizedToRequestAVehicleStopBool",
		"_settingNumber",
		"_vehSpeed",
		"_doorsLockedBool",
		"_playerIsInMatchingVehicleBool",
		"_msg2HintTextString",
		"_msg2SyschatTextString1",
		"_myGUSUIDNumber"
		];

// by default, no
_playerInTAVehicleBool = false;
// by default, player is not authorized to request vehicle stop
_playerIsAuthorizedToRequestAVehicleStopBool = false;
// if we can't read this, it's not allowing
_settingNumber=-2;
// if we can't detect speed correctly (below) for any reason, don't allow exit
_vehSpeed = 100;
// default, no
_playerIsInMatchingVehicleBool=false;

// OBTAIN INFO
_vehSpeed = (velocity vehicle player select 2);

// player has requested this "TaxiAnywhereTaxi" to be (immediately stopped & doors unlocked). 
_playerInTAVehicleBool = vehicle player getVariable ["mgmTfAisTATaxi", false];

if (_playerInTAVehicleBool) then {

	// YES, the player is in a TaxiAnywhereTaxi at the moment		-- log it
	if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_fnc_pleaseStopVehicle.sqf] [TV8]     DETECTED     Player is currently in a TaxiAnywhereTaxi."];};
	_playerIsInMatchingVehicleBool=true;
	_myGUSUIDNumber = ((vehicle player) getVariable ["GUSUIDNumber", -1]);
	if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_fnc_pleaseStopVehicle.sqf] [TV8]     DETECTED     (_myGUSUIDNumber) is: (%1)	", (str _myGUSUIDNumber)];};

	// check if doors locked
	_doorsLockedBool = call compile format ["mgmTfA_gv_PV_SU%1SUVehDoorsLockedBool", _myGUSUIDNumber];

	// CHECK: are we in bypass state?	If it's a TA vehicle && vehicle is at full stop && doors are not locked then yes
	if ((_vehSpeed == 0) && (!_doorsLockedBool)) then {
		// YES we are in bypass state		-- inform the player
		_msg2HintTextString = parsetext format["<img size='6' image='custom\mgmTfA\img\mgmTfA_c_CO_img_doorsUnlocked.jpg'/><br/><br/><t size='1.40' color='#00FF00'>%1<br/><br/>YOU MAY EXIT<br/>THE VEHICLE<br/><br/></t>", (profileName)];
		_msg2SyschatTextString1 = parsetext format ["[DRIVER]  %1 YOU MAY EXIT THE VEHICLE", (profileName)];
		systemChat (str _msg2SyschatTextString1);
	} else {
		// NO, we ARE NOT in bypass state		-- more checks needed to identify what exactly is the situation

		// Why not a bypass?

		// is it not a bypass due to being on the move?
		if (_vehSpeed > 0) then {
			// YES, we're on the move

			// does config allow mid-journey VehStopRequests?
			_settingNumber = mgmTfA_configgv_taxiAnywherePlayersCanRequestAVehicleStopNumber;
			if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_fnc_pleaseStopVehicle.sqf] [TV8]     DETECTED     (_settingNumber) is: (%1).		entering SWITCH..DO now		.", (str _settingNumber)];};

			// CHECK: how exactly are we supposed to respond to a "stop vehicle" request? -- what does config instruct?
			switch _settingNumber do {
				case 0: {
					// 0 = nobody is allowed to request 'stopVehicle'	-- we will let the customer know via hint && systemChat. DRIVER will send the msg.
					_msg2HintTextString = parsetext format ["<img size='6' image='custom\mgmTfA\img\mgmTfA_c_CO_img_warningSign.jpg'/><br/><br/><t size='1.40' color='#00FF00'><br/>SORRY %1<br/><br/><br/>EXITING VEHICLE<br/>MID-JOURNEY<br/>IS NOT ALLOWED<br/><br/>", (profileName)];
					_msg2SyschatTextString1 = parsetext format ["[DRIVER]  %1 SORRY, EXITING VEHICLE MID-JOURNEY IS NOT ALLOWED", (profileName)];
					hint _msg2HintTextString;
					systemChat (str _msg2SyschatTextString1);
					};

				case 1: {
					// 1 = only commandingPlayer is allowed to request 'stopVehicle'	-- let's check if local player == commandingPlayer for this vehicle

					// obtain local player _myPUIDNumber & vehicle's commandingCustomerPlayerUIDNumber
					private	[
							"_myPUIDNumber",
							"_myVehiclesCommandingCustomerPlayerUIDNumber"
							];
					_myPUIDNumber = (getPlayerUID player);
					_myVehiclesCommandingCustomerPlayerUIDNumber = (vehicle player) getVariable "commandingCustomerPlayerUIDNumber";

					if (_myPUIDNumber == _myVehiclesCommandingCustomerPlayerUIDNumber) then {
						if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_fnc_pleaseStopVehicle.sqf] [TV8]         DETECTED     YES, player is the commandingCustomer		(_myPUIDNumber)=(%1),			(_myVehiclesCommandingCustomerPlayerUIDNumber) is: (%2)		.", (str _myPUIDNumber), (str _myVehiclesCommandingCustomerPlayerUIDNumber)];};

						// ADD CODE: SEND PLEASE-STOP SIGNAL TO SERVER
						// ADD CODE: SEND PLEASE-STOP SIGNAL TO SERVER

						// update player:	we are stopping
						_msg2HintTextString = parsetext format ["<img size='6' image='custom\mgmTfA\img\mgmTfA_c_CO_img_requestApproved.jpg'/><br/><br/><t size='1.40' color='#00FF00'>%1<br/><br/>STOP VEHICLE REQUEST<br/><br/>APPROVED<br/><br/>WE ARE STOPPING<br/></t>", (profileName)];
						_msg2SyschatTextString = parsetext format ["[DRIVER]  %1 STOP VEHICLE REQUEST APPROVED. WE ARE STOPPING", (profileName)];
						hint _msg2HintTextString;
						systemChat (str _msg2SyschatTextString);
					} else {
						if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_fnc_pleaseStopVehicle.sqf] [TV8]         DETECTED     NO, player IS NOT the commandingCustomer		(_myPUIDNumber)=(%1),			(_myVehiclesCommandingCustomerPlayerUIDNumber) is: (%2)		.", (str _myPUIDNumber), (str _myVehiclesCommandingCustomerPlayerUIDNumber)];};

						// ADD CODE: UPDATE PLAYER SORRY BUT YOU ARE NOT THE COMMANDING PLAYER
						_msg2HintTextString = parsetext format ["<img size='6' image='custom\mgmTfA\img\mgmTfA_c_CO_img_warningSign.jpg'/><br/><br/><t size='1.40' color='#00FF00'><br/>SORRY %1<br/><br/><br/>YOU ARE NOT<br/>THE VEHICLE COMMANDER<br/><br/>", (profileName)];
						_msg2SyschatTextString1 = parsetext format ["[DRIVER]  %1 SORRY, YOU ARE NOT THE VEHICLE COMMANDER", (profileName)];
						hint _msg2HintTextString;
						systemChat (str _msg2SyschatTextString1);
					};
				};

				case 2: {
					// 2 = any passenger player is allowed to request 'stopVehicle'		-- therefore this player (any player) can request stop for the current TaxiAnywhere veh.		-- we will let the customer know via hint && systemChat. DRIVER will send the msg.

					// ADD CODE: SEND PLEASE-STOP SIGNAL TO SERVER
					// ADD CODE: SEND PLEASE-STOP SIGNAL TO SERVER

					// update player:	we are stopping
					_msg2HintTextString = parsetext format ["<img size='6' image='custom\mgmTfA\img\mgmTfA_c_CO_img_requestApproved.jpg'/><br/><br/><t size='1.40' color='#00FF00'>%1<br/><br/>STOP VEHICLE REQUEST<br/><br/>APPROVED<br/><br/>WE ARE STOPPING<br/></t>", (profileName)];
					_msg2SyschatTextString = parsetext format ["[DRIVER]  %1 STOP VEHICLE REQUEST APPROVED. WE ARE STOPPING", (profileName)];
					hint _msg2HintTextString;
					systemChat (str _msg2SyschatTextString);
				};
			};
		} else {

			// NO, we are not on the move
			// then the doors must be locked?

 			if (_doorsLockedBool) then {

 				// YES, doors are in locked state

 				// is the player authorized to request a doorUnlock (or is anyone on the server allowed to request it?)
 				// if yes, we will send signal to server to unlock doors

				// CHECK: how exactly are we supposed to respond to a "stop vehicle" request? -- what does config instruct?
				switch _settingNumber do {

					case 0: {
						// 0 = nobody is allowed to request 'stopVehicle'	-- we will let the customer know via hint && systemChat. DRIVER will send the msg.
						_msg2HintTextString = parsetext format ["<img size='6' image='custom\mgmTfA\img\mgmTfA_c_CO_img_warningSign.jpg'/><br/><br/><t size='1.40' color='#00FF00'><br/>SORRY %1<br/><br/><br/>EXITING VEHICLE<br/>MID-JOURNEY<br/>IS NOT ALLOWED<br/><br/>", (profileName)];
						_msg2SyschatTextString1 = parsetext format ["[DRIVER]  %1 SORRY, EXITING VEHICLE MID-JOURNEY IS NOT ALLOWED", (profileName)];
						hint _msg2HintTextString;
						systemChat (str _msg2SyschatTextString1);
					};

					case 1: {
						// 1 = only commandingPlayer is allowed to request 'stopVehicle'	-- let's check if local player == commandingPlayer for this vehicle

						// obtain local player _myPUIDNumber & vehicle's commandingCustomerPlayerUIDNumber
						private	[
								"_myPUIDNumber",
								"_myVehiclesCommandingCustomerPlayerUIDNumber"
								];
						_myPUIDNumber = (getPlayerUID player);
						_myVehiclesCommandingCustomerPlayerUIDNumber = (vehicle player) getVariable "commandingCustomerPlayerUIDNumber";

						if (_myPUIDNumber == _myVehiclesCommandingCustomerPlayerUIDNumber) then {
							if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_fnc_pleaseStopVehicle.sqf] [TV8]         DETECTED     YES, player is the commandingCustomer		(_myPUIDNumber)=(%1),			(_myVehiclesCommandingCustomerPlayerUIDNumber) is: (%2)		.", (str _myPUIDNumber), (str _myVehiclesCommandingCustomerPlayerUIDNumber)];};

							// ADD CODE: SEND PLEASE-STOP SIGNAL TO SERVER
							// ADD CODE: SEND PLEASE-STOP SIGNAL TO SERVER

							// update player:	we are stopping
							_msg2HintTextString = parsetext format ["<img size='6' image='custom\mgmTfA\img\mgmTfA_c_CO_img_requestApproved.jpg'/><br/><br/><t size='1.40' color='#00FF00'>%1<br/><br/>STOP VEHICLE REQUEST<br/><br/>APPROVED<br/><br/>WE ARE STOPPING<br/></t>", (profileName)];
							_msg2SyschatTextString = parsetext format ["[DRIVER]  %1 STOP VEHICLE REQUEST APPROVED. WE ARE STOPPING", (profileName)];
							hint _msg2HintTextString;
							systemChat (str _msg2SyschatTextString);
						} else {
							if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_fnc_pleaseStopVehicle.sqf] [TV8]         DETECTED     NO, player IS NOT the commandingCustomer		(_myPUIDNumber)=(%1),			(_myVehiclesCommandingCustomerPlayerUIDNumber) is: (%2)		.", (str _myPUIDNumber), (str _myVehiclesCommandingCustomerPlayerUIDNumber)];};

							// ADD CODE: UPDATE PLAYER SORRY BUT YOU ARE NOT THE COMMANDING PLAYER
							_msg2HintTextString = parsetext format ["<img size='6' image='custom\mgmTfA\img\mgmTfA_c_CO_img_warningSign.jpg'/><br/><br/><t size='1.40' color='#00FF00'><br/>SORRY %1<br/><br/><br/>YOU ARE NOT<br/>THE VEHICLE COMMANDER<br/><br/>", (profileName)];
							_msg2SyschatTextString1 = parsetext format ["[DRIVER]  %1 SORRY, YOU ARE NOT THE VEHICLE COMMANDER", (profileName)];
							hint _msg2HintTextString;
							systemChat (str _msg2SyschatTextString1);
						};
					};

					case 2: {
						// 2 = any passenger player is allowed to request 'stopVehicle'		-- therefore this player (any player) can request stop for the current TaxiAnywhere veh.		-- we will let the customer know via hint && systemChat. DRIVER will send the msg.

						// ADD CODE: SEND PLEASE-STOP SIGNAL TO SERVER
						// ADD CODE: SEND PLEASE-STOP SIGNAL TO SERVER

						// update player:	we are stopping
						_msg2HintTextString = parsetext format ["<img size='6' image='custom\mgmTfA\img\mgmTfA_c_CO_img_requestApproved.jpg'/><br/><br/><t size='1.40' color='#00FF00'>%1<br/><br/>STOP VEHICLE REQUEST<br/><br/>APPROVED<br/><br/>WE ARE STOPPING<br/></t>", (profileName)];
						_msg2SyschatTextString = parsetext format ["[DRIVER]  %1 STOP VEHICLE REQUEST APPROVED. WE ARE STOPPING", (profileName)];
						hint _msg2HintTextString;
						systemChat (str _msg2SyschatTextString);
					};
				};
 			} else {
 				// NO, doors are NOT in locked state
 			};


			// TODO WRITE THIS CODE
			// TODO WRITE THIS CODE
			// TODO WRITE THIS CODE
			// TODO WRITE THIS CODE
			// TODO WRITE THIS CODE
			// TODO WRITE THIS CODE
		};
	};
} else {
	// NO, the player is NOT in a TaxiAnywhereTaxi at the moment		-- log it, inform player & quit
	if (_thisFileVerbosityLevelNumber>=5) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_fnc_pleaseStopVehicle.sqf] [TV5]		DETECTED		Player currently IS NOT in a TaxiAnywhereTaxi!		The result of (str (((vehicle player) getVariable ['mgmTfAisTATaxi', false]))) is: (%1).", (str (((vehicle player) getVariable ["mgmTfAisTATaxi", false])))];};//dbg
	_playerIsInMatchingVehicleBool=false;

	// let the player know via hint && systemChat
	private	[
			"_msg2HintTextString",
			"_msg2SyschatTextString"
			];
	// with hint
	_msg2HintTextString = parsetext format ["<img size='6' image='custom\mgmTfA\img\mgmTfA_c_CO_img_warningSign.jpg'/><br/><br/><t size='1.40' color='#00FF00'><br/>%1<br/><br/><br/>YOU ARE NOT<br/>IN A TAXI ANYWHERE VEHICLE<br/><br/>", (profileName)];
	hint _msg2HintTextString;
	_msg2SyschatTextString = parsetext format ["[SYSTEM]  %1 YOU ARE NOT IN A TAXI ANYWHERE VEHICLE"];
	systemChat str _msg2SyschatTextString;
};
// EOF