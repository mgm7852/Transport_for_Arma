//H
//H ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_fnc_client_doScanVicinityForFixedDestinationTaxiVehicles.sqf
//H $PURPOSE$	:	This function will be SPAWN'd by mgmTfA_scr_client_onPlayerRespawn.sqf with no arguments. It will continuously scan vicinity for Fixed Destination Taxi Vehicles and will ensure 'payNow' action is attached to valid target vehicles.
//H ~~
//H
//HH
//HH ~~
//HH	Syntax		:	_null = [] mgmTfA_fnc_client_doScanVicinityForFixedDestinationTaxiVehicles;
//HH	Parameters	:	none
//HH	Return Value	:	none
//HH ~~
//HH	The server publishes the following publicVariables this function relies on:
//HH		mgmTfA_configgv_fixedDestinationTaxisTaxiVehicleClassnameTextString
//HH	This function does not create/update any global variables.
//HH
if (isServer) exitWith {}; if (isNil("mgmTfA_Client_Init")) then {mgmTfA_Client_Init=0;}; waitUntil {mgmTfA_Client_Init==1}; private ["_thisFileVerbosityLevelNumber"]; _thisFileVerbosityLevelNumber = mgmTfA_configgv_clientVerbosityLevel;
if (!isServer) then {	waitUntil {vehicle player == player};	waitUntil {!isNull (finddisplay 46)};	};
if (_thisFileVerbosityLevelNumber>=6) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_client_doScanVicinityForFixedDestinationTaxiVehicles.sqf]  [TV6]          will sleep 15 secs now..."];};
// Slow down...
sleep 15;
if (_thisFileVerbosityLevelNumber>=6) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_client_doScanVicinityForFixedDestinationTaxiVehicles.sqf]  [TV6]          sleep 15 secs completed. Proceeding with the rest of the script..."];};

private	[
		"_thisFileVerbosityLevelNumber",
		"_nearestFixedDestinationTaxiSameClassVehiclesArray",
		"_scanRadiusInMetresNumber",
		"_fixedDestinationTaxiVehiclesArray",
		"_numberOfSameClassVehicleResultsNumber",
		"_numberOfFixedDestinationTaxisFoundNumber",
		"_scanStartTimeInSecondsNumber",
		"_scanCompletionTimeInSecondsNumber",
		"_scanDurationInSecondsNumber",
		"_sleepDurationBetweenScans",
		"_iterationIDNumber",
		"_myGUSUIDNumber",
		"_fdTxPayNowMenuIsCurrentlyNotAttachedBool"
		];

_thisFileVerbosityLevelNumber = 0;
_scanRadiusInMetresNumber = mgmTfA_configgv_fixedDestinationTaxisClientSideScannerScanRadiusInMetresNumber;
_sleepDurationBetweenScans = mgmTfA_configgv_fixedDestinationTaxisClientSideScannerSleepDurationBetweenScansInSecondsNumber;
_iterationIDNumber = 0;
_myGUSUIDNumber = nil;

//// main loop
while {alive player} do
//while {true} do
{
	_iterationIDNumber = _iterationIDNumber + 1;
	
	// Empty dynamic variables before the next scan
	_nearestFixedDestinationTaxiSameClassVehiclesArray = [];
	_fixedDestinationTaxiVehiclesArray = [];
	_numberOfSameClassVehicleResultsNumber = 0;
	_numberOfFixedDestinationTaxisFoundNumber = 0;
	_scanStartTimeInSecondsNumber = 0;
	_scanCompletionTimeInSecondsNumber = 0;
	_scanDurationInSecondsNumber = 0;
	_arraySearchResult = false;
	_myGUSUIDNumber = nil;
	//_fdTxPayNowMenuIsCurrentlyNotAttachedBool <= do not initialize this here
	//I GUESS BETTER TO LEAVE IT UNDEFINED SO THAT THE RPT LOG DEBUG WRITE BELOW WILL BE MORE MEANINGFUL. IF IT'S TRUE OR FALSE, IT MUST BE COMING FROM THE NETWORK! _hasFixedDestinationTaxiPayNowMenuToggleStatusBool			= false;

	// Do the scan
	_scanStartTimeInSecondsNumber = (time);
	_nearestFixedDestinationTaxiSameClassVehiclesArray = (nearestObjects [(player), [mgmTfA_configgv_fixedDestinationTaxisTaxiVehicleClassnameTextString], _scanRadiusInMetresNumber]);
	_numberOfSameClassVehicleResultsNumber = (count _nearestFixedDestinationTaxiSameClassVehiclesArray);
	{
	//_check7 = ((vehicle player) _x getVariable "mgmTfAisclickNGoTaxi");
		if ((alive _x) && (_x getVariable "isfixedDestinationTaxi")) then {
			// we found a fixedDestinationTaxi here!
			
			// add it to the found fixed DestinationTaxiVehicles array
			_fixedDestinationTaxiVehiclesArray set [(count _fixedDestinationTaxiVehiclesArray),_x];
			
			// what we want to do is attach a payNow action to this vehicle ONLY IF we haven't done so before.			how do we know whether we've done this before?
			// when we add a payNow action, we save vehicles GUSUID to a global variable array on our client-side.		so now, we can simply, check the array, 
			//	if this vehicle's GUSUID exists, it has been processed before
			//	if this vehicle's GUSUID does not exist, let's do it now!
			// does it have the variable attached? if not, let's attach it now
			
			// Get this current vehicle's GUSUID number and assign to our local _myGUSUIDNumber
			_myGUSUIDNumber = (_x getVariable "GUSUIDNumber");
			
			// at this point in workflow, if _myGUSUIDNumber is holding "any", does this mean we're dealing with non-TfA vehicle? // check debug log!
			if (isNil "_myGUSUIDNumber") then {
				// _myGUSUIDNumber isNil, I think this means "any". not sure though. let's check...
				if (_thisFileVerbosityLevelNumber>=5) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_client_doScanVicinityForFixedDestinationTaxiVehicles.sqf] [TV5]		DEVDEBUG		_myGUSUIDNumber isNil!		(str _myGUSUIDNumber) is: (%1)" , (str _myGUSUIDNumber)];};//dbg
			} else {
				// _myGUSUIDNumber is not Nil
				if (_thisFileVerbosityLevelNumber>=5) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_client_doScanVicinityForFixedDestinationTaxiVehicles.sqf] [TV5]		DEVDEBUG		_myGUSUIDNumber is not nil.		(str _myGUSUIDNumber) is: (%1)" , (str _myGUSUIDNumber)];};//dbg

				// do the rest of the (forEach _nearestFixedDestinationTaxiSameClassVehiclesArray) stuff below

				// example:		mgmTfA_dynamicgv_listOfFixedDestinationTaxisThatWeHaveAddedActionMenuOptionTextStringArray = ["1","3","15"];
				//mgmTfA_dynamicgv_listOfFixedDestinationTaxisThatWeHaveAddedActionMenuOptionTextStringArray = [];
				
				// let's check, have we processed this vehicle before?
				// "mgmTfA_dynamicgv_listOfFixedDestinationTaxisThatWeHaveAddedActionMenuOptionTextStringArray" should actually be renamed to "list of vehicles we have added actionMenu to"
				_arraySearchResult = _myGUSUIDNumber in mgmTfA_dynamicgv_listOfFixedDestinationTaxisThatWeHaveAddedActionMenuOptionTextStringArray;
				if (_thisFileVerbosityLevelNumber>=5) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_client_doScanVicinityForFixedDestinationTaxiVehicles.sqf] [TV5]		DEVDEBUG		Just executed _arraySearchResult now, for (str _myGUSUIDNumber): (%1),		at: (%2) seconds uptime.			(str _arraySearchResult) is: (%3).", (str _myGUSUIDNumber), (str time), (str _arraySearchResult)];};//dbg

				// if we have processed it before, _arraySearchResult would be true
				if (_arraySearchResult) then {
					// yes we have processed it before - it's not a new vehicle and there is nothing to be done at this time...
				} else {
					// no we have not processed it before - this is a new vehicle and we are processing it for the first time!

					// since we haven't processed it before, obviously we couldn't have had attached a menu to it.
					// but did any other player attach a menu to it?	let's determine the toggle status for this particular vehicle in array
					_fdTxPayNowMenuIsCurrentlyNotAttachedBool								= call compile format ["mgmTfA_gv_PV_SU%1SUfdTxPayNowMenuIsCurrentlyNotAttachedBool", _myGUSUIDNumber];
					if (_thisFileVerbosityLevelNumber>=5) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_client_doScanVicinityForFixedDestinationTaxiVehicles.sqf] [TV5]		DEVDEBUG		Just determined (str _fdTxPayNowMenuIsCurrentlyNotAttachedBool) is: (%1).", (str _fdTxPayNowMenuIsCurrentlyNotAttachedBool)];};//dbg

					// so what's the current status, menu attached or not attached?
					if (_fdTxPayNowMenuIsCurrentlyNotAttachedBool) then {
						_null = [_x, _myGUSUIDNumber] spawn mgmTfA_fnc_client_doProcessFixedDestinationTaxiAddActionWork;
					} else {
						// this vehicle already have menuOption attached, nothing to be done
					};
					//_EHkilledIdx = player addEventHandler ["killed", {_this exec "playerKilled.sqs"}]
				};
			};
		};
	} forEach _nearestFixedDestinationTaxiSameClassVehiclesArray;
	
	// Do post processing
	_numberOfFixedDestinationTaxisFoundNumber = (count _fixedDestinationTaxiVehiclesArray);
	_scanCompletionTimeInSecondsNumber = (time);
	_scanDurationInSecondsNumber = _scanCompletionTimeInSecondsNumber - _scanStartTimeInSecondsNumber;

	// we have completed forEach -- Report findings to client-side RPT log
	if (_numberOfFixedDestinationTaxisFoundNumber > 0) then {
		// there is at least 1 fixed destination taxi around
		if (_thisFileVerbosityLevelNumber>=5) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_client_doScanVicinityForFixedDestinationTaxiVehicles.sqf] [TV5]		DEVDEBUG		I have completed a vicinity scan for validFixedDestinationTaxiVehicles just now (time=%1).		Scan and post-processing completed in (%2) seconds.		I have found (%3) matching sameClass vehicles.		Out of these (%4) were FixedDestinationTaxis.	Here is the contents of	(str _fixedDestinationTaxiVehiclesArray): (%5).		(str _iterationIDNumber) is: (%6).	I have completed appropriate hasMenuAttached processing on each fixedDestinationTaxi vehicle.", (str time), (str _scanDurationInSecondsNumber), (str _numberOfSameClassVehicleResultsNumber), (str _numberOfFixedDestinationTaxisFoundNumber), (str _fixedDestinationTaxiVehiclesArray), (str _iterationIDNumber) ];};//dbg
	} else {
		// no fixed destination taxis nearby
		if (_thisFileVerbosityLevelNumber>=5) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_client_doScanVicinityForFixedDestinationTaxiVehicles.sqf] [TV5]		DEVDEBUG		I have completed a vicinity scan for validFixedDestinationTaxiVehicles just now (time=%1).		Scan and post-processing completed in (%2) seconds.		I have not found any FixedDestinationTaxis.		(str _iterationIDNumber) is: (%3).", (str time), (str _scanDurationInSecondsNumber), (str _iterationIDNumber)];};//dbg
	};
	// uiSleep between iterations
	uiSleep _sleepDurationBetweenScans;
};
// EOF