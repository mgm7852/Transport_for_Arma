//H
//H
//H ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_c_TA_fnc_pleaseBeginSystemChatInformingCommandingPlayerSUWaitingForGetOut.sqf
//H $PURPOSE$	:	This function will be spawn'd with one argument only SU ID (GUSUIDNumber) by an EH and it will live only for a predetermined amount of time.
//H
//H					Lifetime is a setting in the CONFIGURATION file, and the default value 10 seconds.
//H					Function will keep looping and doing a simple check: Has the player left the vehicle?
//H					Note that GUSUID was supplied as function call parameter.
//H
//H					NO, player is still in vehicle = print another systemChat reminder that driver is waiting for him to get out, 10... 9... countdown style.
//H					YES, player got out = terminate this function immediately.
//H ~~
//H
//HH
//H ~~
//HH	Syntax		:	_null = [SU_ID] mgmTfA_c_TA_fnc_pleaseBeginSystemChatInformingCommandingPlayerSUWaitingForGetOut
//HH	Parameters	:	GUSUIDNumber Globally Unique Service Unit ID number		Number		Examples: 1, 2, 5, 384, 384728473
//HH	Return Value:	Nothing	[outputs reminders to client's systemChat]
//H ~~
//HH	The shared configuration file has the following values this function rely on:
//HH		mgmTfA_configgv_clientVerbosityLevel
//HH		mgmTfA_configgv_taxiAnywhereTaxisKeepSystemChatInformingCommandingPlayerSUAwaitingGetOutTimeoutInSecondsNumber
//HH	This function does not create/update any global variables.
//HH	This function does not rely on any publicVariables.
//HH
if (isServer) exitWith {}; if (isNil("mgmTfA_Client_Init")) then {mgmTfA_Client_Init=0;}; waitUntil {mgmTfA_Client_Init==1}; private ["_thisFileVerbosityLevelNumber"]; _thisFileVerbosityLevelNumber = mgmTfA_configgv_clientVerbosityLevel;
scopeName "mgmTfA_c_TA_fnc_pleaseBeginSystemChatInformingCommandingPlayerSUWaitingForGetOutMainScope";
if (!isServer) then { waitUntil {!isnull (finddisplay 46)}; };

private	[
		"_continueInformingThatDriverIsWaitingGetOutBool",
		"_lifetimeLeftInSecondsNumber",
		"_suppliedGUSUIDNumber",
		"_classnameOfTheCurrentVehicle"
		];

// if we have been called, then this is initially TRUE
_continueInformingThatDriverIsWaitingGetOutBool = true;
_lifetimeLeftInSecondsNumber = mgmTfA_configgv_taxiAnywhereTaxisKeepSystemChatInformingCommandingPlayerSUAwaitingGetOutTimeoutInSecondsNumber;
_suppliedGUSUIDNumber = (_this select 0);
// log it -- do not move this line any higher due to GUSUID
// TODO: Change this to 10
if (_thisFileVerbosityLevelNumber>=0) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_fnc_pleaseBeginSystemChatInformingCommandingPlayerSUWaitingForGetOut.sqf]  [TV0]	BEGIN RUNNING FUNCTION		I will  keep reminding that driver is awaiting get out, for SU: (%1).", (str _suppliedGUSUIDNumber)];};

// Begin looping the main loop -- we will keep looping as long as player is still in the same vehicle (checked via GUSUID comparison)
while {_continueInformingThatDriverIsWaitingGetOutBool} do
{
	// sleep is at the bottom of loop - keep it there

	// if classname don't match, we won't even try to obtain GUSUID
	_classnameOfTheCurrentVehicle = (typeOf (vehicle player));
	if (_classnameOfTheCurrentVehicle == mgmTfA_configgv_taxiAnywhereTaxisTaxiVehicleClassnameTextString) then {
		// YES, classnames match -- do further checks
		if (mgmTfA_configgv_clientVerbosityLevel>=4) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_fnc_pleaseBeginSystemChatInformingCommandingPlayerSUWaitingForGetOut.sqf]  [TV4]          I have determined that (_classnameOfTheCurrentVehicle == mgmTfA_configgv_taxiAnywhereTaxisTaxiVehicleClassnameTextString).		I will do further checks.		_suppliedGUSUIDNumber:(%1)		Timeout:(%2)seconds", _suppliedGUSUIDNumber, _lifetimeLeftInSecondsNumber];};

		// Is the player in a mgmTfA TaxiAnywhere vehicle?
		private ["_playerInTAVehicleBool"];
		_playerInTAVehicleBool = (vehicle player getVariable ["mgmTfAisTATaxi", false]);
		if (_playerInTAVehicleBool) then {
			// YES, player is in a TA Taxi vehicle -- log it & do further checks
			if (mgmTfA_configgv_clientVerbosityLevel>=4) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_fnc_pleaseBeginSystemChatInformingCommandingPlayerSUWaitingForGetOut.sqf]  [TV4]          I have determined that player is in a TaxiAnywhere vehicle. May or may not be the original vehicle - I will do further checks.		_suppliedGUSUIDNumber:(%1)		Timeout:(%2)seconds", _suppliedGUSUIDNumber, _lifetimeLeftInSecondsNumber];};

			// Is the player in the exact same vehicle?
			private ["_GUSUIDNumberOfTheCurrentVehicle"];
			_GUSUIDNumberOfTheCurrentVehicle = ((vehicle player) getVariable "GUSUIDNumber");
			//Compare current vehicle's Classname with the pre-defined Taxi Classname, if it matches, message the player. Otherwise do nothing.
			if (_GUSUIDNumberOfTheCurrentVehicle == _suppliedGUSUIDNumber) then {
				// YES, player is still in the same exact vehile -- log it & send a reminder
				if (mgmTfA_configgv_clientVerbosityLevel>=4) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_fnc_pleaseBeginSystemChatInformingCommandingPlayerSUWaitingForGetOut.sqf]  [TV4]          I have determined that player is still in the original vehicle - systemChat reminding now that driver is awaiting get out.		_suppliedGUSUIDNumber:(%1)		Timeout:(%2)seconds", _suppliedGUSUIDNumber, _lifetimeLeftInSecondsNumber];};
				private ["_msg2SyschatTextString1"];
				_msg2SyschatTextString1 = parsetext format["[DRIVER]  AWAITING GET OUT. TIMEOUT IN %1 SECONDS...", _lifetimeLeftInSecondsNumber];
				systemChat (str _msg2SyschatTextString1);
			} else {
				// NO. Player is in a TA vehicle but not the original one -- no point in carrying on, silently terminating
				if (mgmTfA_configgv_clientVerbosityLevel>=4) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_fnc_pleaseBeginSystemChatInformingCommandingPlayerSUWaitingForGetOut.sqf]  [TV4]          I have determined that player is still in a TaxiAnywhere vehicle but not the original vehicle	-- no point in carrying on, silently terminating now.		_suppliedGUSUIDNumber:(%1)		Timeout:(%2)seconds", _suppliedGUSUIDNumber, _lifetimeLeftInSecondsNumber];};
				_continueInformingThatDriverIsWaitingGetOutBool = false;
			};
		} else {
			// NO. Player is not in a TA vehicle -- no point in carrying on, silently terminating
			if (mgmTfA_configgv_clientVerbosityLevel>=4) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_fnc_pleaseBeginSystemChatInformingCommandingPlayerSUWaitingForGetOut.sqf]  [TV4]          I have determined (_playerInTAVehicleBool=false) -- no point in carrying on, silently terminating now.			_suppliedGUSUIDNumber:(%1)		Timeout:(%2)seconds", _suppliedGUSUIDNumber, _lifetimeLeftInSecondsNumber];};
			_continueInformingThatDriverIsWaitingGetOutBool = false;
		};
	} else {
		// NO, player cannot be in a TaxiAnywhere vehicle, as classnames don't match. There is no need to keep looping, silently terminating now.
		if (mgmTfA_configgv_clientVerbosityLevel>=4) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_fnc_pleaseBeginSystemChatInformingCommandingPlayerSUWaitingForGetOut.sqf]  [TV4]		NO, player cannot be in a TaxiAnywhere vehicle, as classnames don't match. There is no need to keep looping, silently terminating now.		_suppliedGUSUIDNumber:(%1)		Timeout:(%2)seconds", _suppliedGUSUIDNumber, _lifetimeLeftInSecondsNumber];};
		_continueInformingThatDriverIsWaitingGetOutBool = false;
	};	
	// keep going?
	if (_lifetimeLeftInSecondsNumber <= 0) then {
		// YES, do nothing
	} else {
		// NO, time to stop!
		_continueInformingThatDriverIsWaitingGetOutBool = false;
	};
	// sleep a sec
	uiSleep 1;
};
// TODO: Change this to 10
if (_thisFileVerbosityLevelNumber>=0) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_fnc_pleaseBeginSystemChatInformingCommandingPlayerSUWaitingForGetOut.sqf] [TV0] This is _suppliedGUSUIDNumber: (%1)		THIS IS THE LAST LINE. TERMINATING.", (str _suppliedGUSUIDNumber)];};//DEVDEBUG
// EOF