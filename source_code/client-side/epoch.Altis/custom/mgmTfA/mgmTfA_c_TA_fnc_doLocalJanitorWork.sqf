//H
//H
//H ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_c_TA_fnc_doLocalJanitorWork.sqf
//H $PURPOSE$	:	This function will be launched by client init, and it will kick in every 5 minutes; 
//H					(if player is not in a clickNGo vehicle) && (if it has been more than 15 minutes since player's clickNGoTaxiHotkeyLastSuccessfulUse) 
//H					then this script sets player's status to "mgmTfA_dynamicgv_thisPlayerCanOrderclickNGoTaxiViaHotkey=true"
//H ~~
//H
//HH
//HH ~~
//HH	Syntax		:	_null = [] mgmTfA_c_TA_fnc_doLocalJanitorWork
//HH	Parameters	:	none
//HH	Return Value	:	none
//HH ~~
//HH	The shared configuration file has the following values this function rely on: none
//HH	This function updates the following global variable(s):	mgmTfA_dynamicgv_thisPlayerCanOrderclickNGoTaxiViaHotkey
//HH
private ["_thisFileVerbosityLevelNumber"];
_thisFileVerbosityLevelNumber = 0;
scopeName "mgmTfA_c_TA_fnc_doLocalJanitorWorkMainScope";
if (isServer) exitWith {};
if (!isServer) then {
	waitUntil {!isnull (finddisplay 46)};
	// We would like to run only ONE instance of this janitor. If another instance is already running, exit.
	if (!isNil("mgmTfA_c_TA_fnc_doLocalJanitorWorkProcessActive")) exitWith {};
	waitUntil {mgmTfA_Client_Init==1};
	_thisFileVerbosityLevelNumber = mgmTfA_configgv_clientVerbosityLevel;
	// let's mark our work so other instances won't run in parallel!
	mgmTfA_c_TA_fnc_doLocalJanitorWorkProcessActive = true;
	
	// FUNCTION - begin
	private	[
			"_randomOneTimeOnlyDelay",
			"_iterationIDNumber"
			];
	_iterationIDNumber = 0;
	_randomOneTimeOnlyDelay = mgmTfA_configgv_taxiAnywhereJanitorInitialRandomSleepDurationMinimumBaseInSecondsNumber + (floor (random mgmTfA_configgv_taxiAnywhereJanitorInitialRandomSleepDurationMinimumAdditionInSecondsNumber));
	if (_thisFileVerbosityLevelNumber>=7) then {diag_log format ["[mgmTfA]  [mgmTfA_c_TA_fnc_doLocalJanitorWork.sqf]  [TV7] INFORMATION	I will now uiSleep for _randomOneTimeOnlyDelay amount of seconds, which is randomly set to: (%1) seconds.", _randomOneTimeOnlyDelay];};
	uiSleep _randomOneTimeOnlyDelay;
	if (_thisFileVerbosityLevelNumber>=7) then {diag_log format ["[mgmTfA]  [mgmTfA_c_TA_fnc_doLocalJanitorWork.sqf]  [TV7] INFORMATION	I have completed my uiSleep for _randomOneTimeOnlyDelay amount of seconds, which was randomly set to: (%1) seconds. Proceeding with the rest of the function now...", _randomOneTimeOnlyDelay];};
	_randomOneTimeOnlyDelay = nil;
	
	// main loop
	while {true} do
	{
		uiSleep mgmTfA_configgv_taxiAnywhereJanitorSleepDurationInSecondsNumber;

		_iterationIDNumber = _iterationIDNumber + 1;
		if (_thisFileVerbosityLevelNumber>=7) then {diag_log format ["[mgmTfA]  [mgmTfA_c_TA_fnc_doLocalJanitorWork.sqf]  [TV7] executing the main loop - currently at the top of the loop, in line 1. This is iteration number: (%1).", _iterationIDNumber];};

		// if player currently can order clickNGo taxis, then rest of the checks are meaningless and should be avoided.
		if (!mgmTfA_dynamicgv_thisPlayerCanOrderclickNGoTaxiViaHotkey) then {
			if (isNil "mgmTfA_dynamicgv_lastclickNGoTaxiBookingPlacedAtTimestampInSecondsNumber") then {
				if (_thisFileVerbosityLevelNumber>=6) then {diag_log format ["[mgmTfA]  [mgmTfA_c_TA_fnc_doLocalJanitorWork.sqf]  [TV6] mgmTfA_dynamicgv_lastclickNGoTaxiBookingPlacedAtTimestampInSecondsNumber is nil. nothing to be done at this time. will loop and check again..."];};
				// do nothing
				// if the above global variable is nil, then player has not placed any clickNGo taxi bookings yet, thus he is not in a state unable-to-order-clickNgo-Taxis-at-the-moment-because-he-abruptly-exited-the-last-workflow-run
				// this also means he does not need our clean up service
				// which also means we will now sleep a bit and loop again...
			} else {
				if (_thisFileVerbosityLevelNumber>=6) then {diag_log format ["[mgmTfA]  [mgmTfA_c_TA_fnc_doLocalJanitorWork.sqf]  [TV6] mgmTfA_dynamicgv_lastclickNGoTaxiBookingPlacedAtTimestampInSecondsNumber is not nil. player had ordered clickNGo Taxi earlier - I will investigate further..."];};
				// mgmTfA_dynamicgv_lastclickNGoTaxiBookingPlacedAtTimestampInSecondsNumber global variable has been declared.
				// this means Player has already used the hotkey successfully at least once since server start
				// perhaps he abruptly exit'ed the clickNGo workflow and currently unable to place another booking because system still thinks "player is being served by a clickNGo Taxi at the moment"
				// let's find out and if he is actually supposed to have access to clickNGo booking system, let's grant him access!
				
				// if (player is not in a clickNGo vehicle at the moment) && (last successful hotkey use was more than 15 minutes ago) then (let's set mgmTfA_dynamicgv_thisPlayerCanOrderclickNGoTaxiViaHotkey to true so that player will be able to place a new booking)
				private ["_classnameOfTheCurrentVehicle"];
				
				//Get current vehicle's Classname
				_classnameOfTheCurrentVehicle = (typeOf (vehicle player));

				//Compare current vehicle's Classname with the pre-defined Taxi Classname, if it matches, message the player. Otherwise do nothing.
				if (mgmTfA_configgv_taxiAnywhereTaxisTaxiVehicleClassnameTextString == _classnameOfTheCurrentVehicle) then {
					// player is in same type of vehicle that we use for clickNGo. but is it actually a TfA vehicle or just a coincidence? let's investigate further
					private ["_check7"];
					_check7 = ((vehicle player) getVariable "mgmTfAisclickNGoTaxi");
					if (!isNil "_check7") then {
						if (_thisFileVerbosityLevelNumber>=7) then {diag_log format ["[mgmTfA]  [mgmTfA_c_TA_fnc_doLocalJanitorWork.sqf]  [TV7] check7 is not nil! player's vehicle does have the 'mgmTfAisclickNGoTaxi' variable attached to it, so it can be a clickNGoTaxi (we will need to check and see if this variable is set to 'true'). if it is 'true', this means he should not be able to order another clickNGo taxi at this time. we will NOT remove his inability to order taxis at this iteration. will loop and try again! Note: (str _check7) is: (%1)", (str _check7)];};
					} else {
						if (_thisFileVerbosityLevelNumber>=7) then {diag_log format ["[mgmTfA]  [mgmTfA_c_TA_fnc_doLocalJanitorWork.sqf]  [TV7] check7 is nil. player's vehicle does not have 'mgmTfAisclickNGoTaxi' variable attached to it, so it cannot be a clickNGoTaxi. perhaps he is unfairly being denied access to clickNGo taxis due to an abrupt workflow termination? let's investigate further!"];};
						// since player is not in a clickNGo taxi -- is he supposed to be able to order clickNGo Taxis at this time (is he being unfairly rejected service?)
						if ((((time) - mgmTfA_dynamicgv_lastclickNGoTaxiBookingPlacedAtTimestampInSecondsNumber) > mgmTfA_configgv_taxiAnywhereTaxiBookingHotkeyCooldownDurationInSecondsNumber)) then {
							if (_thisFileVerbosityLevelNumber>=7) then {diag_log format ["[mgmTfA]  [mgmTfA_c_TA_fnc_doLocalJanitorWork.sqf]  [TV7] '(time) - mgmTfA_dynamicgv_lastclickNGoTaxiBookingPlacedAtTimestampInSecondsNumber) > mgmTfA_configgv_taxiAnywhereTaxiBookingHotkeyCooldownDurationInSecondsNumber)' so it has been at least a minute since players last clickNGo taxi booking and he is NOT in a clickNGo taxi at the moment. he should be able to order taxis. his current status however is: (str mgmTfA_dynamicgv_thisPlayerCanOrderclickNGoTaxiViaHotkey): (%1)", (str mgmTfA_dynamicgv_thisPlayerCanOrderclickNGoTaxiViaHotkey)];};
							if (_thisFileVerbosityLevelNumber>=7) then {diag_log format ["[mgmTfA]  [mgmTfA_c_TA_fnc_doLocalJanitorWork.sqf]  [TV7] I have now set 'mgmTfA_dynamicgv_thisPlayerCanOrderclickNGoTaxiViaHotkey' to true. He should be able to order from now on!"];};
							mgmTfA_dynamicgv_thisPlayerCanOrderclickNGoTaxiViaHotkey = true;
						};
					};
				} else {
					// player is not even in a "same type" vehicle with clickNGo vehicle. he is in another vehicle or on foot. in any case, perhaps he is currently being unfairly prevented from ordering clickNGo taxis. let's investigate further.
					if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA]  [mgmTfA_c_TA_fnc_doLocalJanitorWork.sqf]  [TV4] player's vehicle does not match the clickNGo vehicle type. will investigate further now..."];};
					// has it been more than threshold time since his last successful use of clickNGo Taxis hotkey?
					// since player is not in a clickNGo taxi -- is he supposed to be able to order clickNGo Taxis at this time (is he being unfairly rejected service?)
					if ((((time) - mgmTfA_dynamicgv_lastclickNGoTaxiBookingPlacedAtTimestampInSecondsNumber) > mgmTfA_configgv_taxiAnywhereTaxiBookingHotkeyCooldownDurationInSecondsNumber)) then {
						if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA]  [mgmTfA_c_TA_fnc_doLocalJanitorWork.sqf]  [TV4] '(time) - mgmTfA_dynamicgv_lastclickNGoTaxiBookingPlacedAtTimestampInSecondsNumber) > mgmTfA_configgv_taxiAnywhereTaxiBookingHotkeyCooldownDurationInSecondsNumber)' so it has been at least a minute since players last clickNGo taxi booking and he is NOT in a clickNGo taxi at the moment. he should be able to order taxis. his current status however is: (str mgmTfA_dynamicgv_thisPlayerCanOrderclickNGoTaxiViaHotkey): (%1)", (str mgmTfA_dynamicgv_thisPlayerCanOrderclickNGoTaxiViaHotkey)];};
						if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA]  [mgmTfA_c_TA_fnc_doLocalJanitorWork.sqf]  [TV4] I have now set 'mgmTfA_dynamicgv_thisPlayerCanOrderclickNGoTaxiViaHotkey' to true. He should be able to order from now on!"];};
						mgmTfA_dynamicgv_thisPlayerCanOrderclickNGoTaxiViaHotkey = true;
					} else {
						if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA]  [mgmTfA_c_TA_fnc_doLocalJanitorWork.sqf]  [TV4] I looked into this, but it has not been more than threshold seconds therefore player is not suppposed to have access to clickNGo taxis at this time. There is no adjustment needed to his current 'ability to order clickNGo Taxis via Hotkey'. I will loop and check again"];};
					};
				};		
			
			};
		} else {
			if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA]  [mgmTfA_c_TA_fnc_doLocalJanitorWork.sqf]  [TV4] mgmTfA_dynamicgv_thisPlayerCanOrderclickNGoTaxiViaHotkey is true, meaning player already has ability to book clickNGo Taxis. there is definitely no unfair service rejection. I will not do the rest of the checks - it's unnecessary. will wait and loop again."];};
		};
	};
};
if (_thisFileVerbosityLevelNumber>=7) then {diag_log format ["[mgmTfA] [mgmTfA_c_TA_fnc_doLocalJanitorWork.sqf] [TV7] Reached checkpoint: Bottom of function. Returning now."];};
// PLACE THE RETURN VALUE (IF ANY) UNDER THIS LINE
if (_thisFileVerbosityLevelNumber>=6) then {diag_log format ["[mgmTfA]  [mgmTfA_c_TA_fnc_doLocalJanitorWork.sqf] [TV6] Reached checkpoint: Bottom of SQF. Exiting now."];};
// EOF