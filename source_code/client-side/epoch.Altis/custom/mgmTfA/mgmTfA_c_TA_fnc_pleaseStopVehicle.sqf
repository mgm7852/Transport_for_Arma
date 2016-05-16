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

// TODO reduce the multi switches to a single inline pre-compiled function
if (isServer) exitWith {}; if (isNil("mgmTfA_Client_Init")) then {mgmTfA_Client_Init=0;}; waitUntil {mgmTfA_Client_Init==1}; private ["_thisFileVerbosityLevelNumber"]; _thisFileVerbosityLevelNumber = mgmTfA_configgv_clientVerbosityLevel;
scopeName "mgmTfA_c_TA_fnc_pleaseStopVehicleMainScope";
waitUntil {!isnull (finddisplay 46)};

// FUNCTION - begin
if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_fnc_pleaseStopVehicle.sqf]  [TV8] INFORMATION	I have been called"];};

private	[
		"_playerInTAVehicleBool",
		"_playerIsAuthorizedToRequestAVehicleStopBool",
		"_settingNumber",
		"_vehicleSpeedInKMHNumber",
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
_settingNumber=-999;
// if we can't detect speed correctly (below) -for any reason-, do not accept stopVehReq
_vehicleSpeedInKMHNumber = 100;
// by default, no
_playerIsInMatchingVehicleBool=false;

// obtain info
_vehicleSpeedInKMHNumber = (velocity vehicle player select 2);
// player has requested this "TaxiAnywhereTaxi" to be (immediately stopped & doors unlocked)		-- is the player really in a TA Taxi thougH?
_playerInTAVehicleBool = vehicle player getVariable ["mgmTfAisTATaxi", false];

if (_playerInTAVehicleBool) then {
	// YES, the player is in a TaxiAnywhereTaxi at the moment		-- log it
	if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_fnc_pleaseStopVehicle.sqf] [TV8]     DETECTED     Player is currently in a TaxiAnywhereTaxi.		DEVDEBUG"];};//DEVDEBUG
	_playerIsInMatchingVehicleBool=true;

	_myGUSUIDNumber = ((vehicle player) getVariable ["GUSUIDNumber", -1]);
	if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_fnc_pleaseStopVehicle.sqf] [TV8]     DETECTED     (_myGUSUIDNumber) is: (%1)	", (str _myGUSUIDNumber)];};//DEVDEBUG

	// check if doors locked
	_doorsLockedBool = call compile format ["mgmTfA_gv_PV_SU%1SUVehDoorsLockedBool", _myGUSUIDNumber];

	// If vehicle's at full stop && doors are not locked, then it's BYPASS state		-- CHECK: are we in bypass state now?
	if ((_vehicleSpeedInKMHNumber == 0) && (!_doorsLockedBool)) then {
		// YES we are in bypass state		-- inform the player
		if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_fnc_pleaseStopVehicle.sqf] [TV8]     DETECTED     We are in a bypass state, informing player he may exit.		DEVDEBUG"];};//DEVDEBUG
		_msg2HintTextString = parsetext format["<img size='6' image='custom\mgmTfA\img\mgmTfA_c_CO_img_doorsUnlocked.jpg'/><br/><br/><t size='1.40' color='#00FF00'>%1<br/><br/>YOU MAY EXIT<br/>THE VEHICLE<br/><br/></t>", (profileName)];
		_msg2SyschatTextString1 = parsetext format ["[DRIVER]  %1 YOU MAY EXIT THE VEHICLE", (profileName)];
		systemChat (str _msg2SyschatTextString1);
	} else {
		// NO, we ARE NOT in bypass state		-- more checks needed to identify what exactly is the situation
		if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_fnc_pleaseStopVehicle.sqf] [TV8]     DETECTED     NO we ARE NOT in a bypass state.		DEVDEBUG"];};//DEVDEBUG

		// does config allow VehStopRequests?
		_settingNumber = mgmTfA_configgv_taxiAnywherePlayersCanRequestAVehicleStopNumber;
		if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_fnc_pleaseStopVehicle.sqf] [TV8]     entering SWITCH..DO now		."];};

		// CHECK: how exactly are we supposed to respond to a "stop vehicle" request?		-- what does config instruct?
		switch _settingNumber do {

			case 0: {
				// 0 = nobody is allowed to request 'stopVehicle'	-- we will let the customer know via hint && systemChat. DRIVER will send the msg.
				if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_fnc_pleaseStopVehicle.sqf] [TV8]     DETECTED     (_settingNumber) is: (%1).		", (str _settingNumber)];};//DEVDEBUG
				_msg2HintTextString = parsetext format ["<img size='6' image='custom\mgmTfA\img\mgmTfA_c_CO_img_warningSign.jpg'/><br/><br/><t size='1.40' color='#00FF00'><br/>SORRY %1<br/><br/><br/>EXITING VEHICLE<br/>MID-JOURNEY<br/>IS NOT ALLOWED<br/><br/>", (profileName)];
				_msg2SyschatTextString1 = parsetext format ["[DRIVER]  %1 SORRY, EXITING VEHICLE MID-JOURNEY IS NOT ALLOWED", (profileName)];
				hint _msg2HintTextString;
				systemChat (str _msg2SyschatTextString1);
				};

			case 1: {
				// 1 = only commandingPlayer is allowed to request 'stopVehicle'	-- let's check if the local player is the commandingPlayer for this vehicle
				if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_fnc_pleaseStopVehicle.sqf] [TV8]     DETECTED     (_settingNumber) is: (%1).	I'll check if player is commandingPlayer", (str _settingNumber)];};//DEVDEBUG
				// obtain local player _myPUIDNumber & vehicle's commandingCustomerPlayerUIDNumber
				private	[
						"_myPUIDNumber",
						"_myVehiclesCommandingCustomerPlayerUIDNumber"
						];
				_myPUIDNumber = (getPlayerUID player);
				_myVehiclesCommandingCustomerPlayerUIDNumber = ((vehicle player) getVariable "commandingCustomerPlayerUIDNumber");

				if (_myPUIDNumber == _myVehiclesCommandingCustomerPlayerUIDNumber) then {
					// in TAveh=YES && doorsLocked=YES && player=commander=YES		-- all  good, we are stopping!
					if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_fnc_pleaseStopVehicle.sqf] [TV8]         DETECTED     YES, player is the commandingCustomer		(_myPUIDNumber)=(%1),			(_myVehiclesCommandingCustomerPlayerUIDNumber) is: (%2)		.", (str _myPUIDNumber), (str _myVehiclesCommandingCustomerPlayerUIDNumber)];};//DEVDEBUG
					// TODO: convert this to a function -  doing twice in this script!
					private	[
							"_mgmTfA_gv_pvs_TAStopVehicleRequestorPlayerUIDTextString",
							"_myGUSUIDNumber"
							];
					// send the stopVeh signalPacket to the server-side
					// TODO: clear the duplicate mess
					_mgmTfA_gv_pvs_TAStopVehicleRequestorPlayerUIDTextString = (getPlayerUID player);
					mgmTfA_gv_pvs_TAStopVehicleRequestorPlayerUIDTextString = _mgmTfA_gv_pvs_TAStopVehicleRequestorPlayerUIDTextString;
					_myGUSUIDNumber = ((vehicle player) getVariable ["GUSUIDNumber", -1]);
					myGUSUIDNumber = _myGUSUIDNumber;
					mgmTfA_gv_pvs_req_taxiAnywhereTaxiPleaseAllowExitPacketSignalOnly = [player, mgmTfA_gv_pvs_TAStopVehicleRequestorPlayerUIDTextString, myGUSUIDNumber];
					publicVariableServer "mgmTfA_gv_pvs_req_taxiAnywhereTaxiPleaseAllowExitPacketSignalOnly";
					if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_fnc_pleaseStopVehicle.sqf]	[TV8]    REQUEST VEH STOP SET TO SERVER		- I HAVE THE FOLLOWING DETAILS: mgmTfA_gv_pvs_TAStopVehicleRequestorPlayerUIDTextString is: (%1).		(myGUSUIDNumber): (%2).		", mgmTfA_gv_pvs_TAStopVehicleRequestorPlayerUIDTextString, (str myGUSUIDNumber)];};
					// Update player:	we are stopping as requested
					_msg2HintTextString = parsetext format ["<img size='6' image='custom\mgmTfA\img\mgmTfA_c_CO_img_requestApproved.jpg'/><br/><br/><t size='1.40' color='#00FF00'>%1<br/><br/>STOP VEHICLE REQUEST<br/><br/>APPROVED<br/><br/>WE ARE STOPPING<br/></t>", (profileName)];
					_msg2SyschatTextString = parsetext format ["[DRIVER]  %1 STOP VEHICLE REQUEST APPROVED. WE ARE STOPPING", (profileName)];
					hint _msg2HintTextString;
					systemChat (str _msg2SyschatTextString);
				} else {
					// no commander = no stop!
					if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_fnc_pleaseStopVehicle.sqf] [TV8]         DETECTED     NO, player IS NOT the commandingCustomer		(_myPUIDNumber)=(%1),			(_myVehiclesCommandingCustomerPlayerUIDNumber) is: (%2)		.", (str _myPUIDNumber), (str _myVehiclesCommandingCustomerPlayerUIDNumber)];};//DEVDEBUG
					_msg2HintTextString = parsetext format ["<img size='6' image='custom\mgmTfA\img\mgmTfA_c_CO_img_warningSign.jpg'/><br/><br/><t size='1.40' color='#00FF00'><br/>SORRY %1<br/><br/><br/>YOU ARE NOT<br/>THE VEHICLE COMMANDER<br/><br/>", (profileName)];
					_msg2SyschatTextString1 = parsetext format ["[DRIVER]  %1 SORRY, YOU ARE NOT THE VEHICLE COMMANDER", (profileName)];
					hint _msg2HintTextString;
					systemChat (str _msg2SyschatTextString1);
				};
			};

			case 2: {
				// 2 = any passenger player is allowed to request 'stopVehicle'		-- therefore this player can request stop for the current TaxiAnywhere veh.		-- we will let the customer know via hint && systemChat. DRIVER will send the msg.
				if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_fnc_pleaseStopVehicle.sqf] [TV8]     DETECTED     (_settingNumber) is: (%1).		", (str _settingNumber)];};//DEVDEBUG
				// TODO: convert this to a function -  doing twice in this script!
				private	[
						"mgmTfA_gv_pvs_TAStopVehicleRequestorPlayerUIDTextString",
						"_myGUSUIDNumber"
						];
				mgmTfA_gv_pvs_TAStopVehicleRequestorPlayerUIDTextString = (getPlayerUID player);
				_myGUSUIDNumber = ((vehicle player) getVariable ["GUSUIDNumber", -1]);
				myGUSUIDNumber = _myGUSUIDNumber;
				mgmTfA_gv_pvs_req_taxiAnywhereTaxiPleaseAllowExitPacketSignalOnly = [player, mgmTfA_gv_pvs_TAStopVehicleRequestorPlayerUIDTextString, myGUSUIDNumber];
				publicVariableServer "mgmTfA_gv_pvs_req_taxiAnywhereTaxiPleaseAllowExitPacketSignalOnly";
				if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_fnc_pleaseStopVehicle.sqf]	[TV8]    REQUEST VEH STOP SET TO SERVER		- I HAVE THE FOLLOWING DETAILS: mgmTfA_gv_pvs_TAStopVehicleRequestorPlayerUIDTextString is: (%1).		(myGUSUIDNumber): (%2).		", mgmTfA_gv_pvs_TAStopVehicleRequestorPlayerUIDTextString, (str myGUSUIDNumber)];};
				// update player:	we are stopping
				_msg2HintTextString = parsetext format ["<img size='6' image='custom\mgmTfA\img\mgmTfA_c_CO_img_requestApproved.jpg'/><br/><br/><t size='1.40' color='#00FF00'>%1<br/><br/>STOP VEHICLE REQUEST<br/><br/>APPROVED<br/><br/>WE ARE STOPPING<br/></t>", (profileName)];
				_msg2SyschatTextString = parsetext format ["[DRIVER]  %1 STOP VEHICLE REQUEST APPROVED. WE ARE STOPPING", (profileName)];
				hint _msg2HintTextString;
				systemChat (str _msg2SyschatTextString);
			};
		};
	};
} else {
	// NO, the player is NOT in a TaxiAnywhereTaxi at the moment		-- log it, inform player & quit
	if (_thisFileVerbosityLevelNumber>=5) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_fnc_pleaseStopVehicle.sqf] [TV5]		DETECTED		Player currently IS NOT in a TaxiAnywhereTaxi!		The result of (str (((vehicle player) getVariable ['mgmTfAisTATaxi', false]))) is: (%1).", (str (((vehicle player) getVariable ["mgmTfAisTATaxi", false])))];};//dbg //DEVDEBUG

	_playerIsInMatchingVehicleBool=false;
	// let the player know via hint && systemChat
	private	[
			"_msg2HintTextString",
			"_msg2SyschatTextString"
			];
	// with hint
	_msg2HintTextString = parsetext format ["<img size='6' image='custom\mgmTfA\img\mgmTfA_c_CO_img_warningSign.jpg'/><br/><br/><t size='1.40' color='#00FF00'><br/>%1<br/><br/><br/>YOU ARE NOT IN A<br/>TAXI ANYWHERE VEHICLE<br/><br/>", (profileName)];
	hint _msg2HintTextString;
	_msg2SyschatTextString = parsetext format ["[SYSTEM]  %1 YOU ARE NOT IN A TAXI ANYWHERE VEHICLE", (profileName)];
	systemChat str _msg2SyschatTextString;
};
// EOF