//H
//H ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_fnc_client_doScanVicinityForclickNGoTaxiVehicles.sqf
//H $PURPOSE$	:	This function will be SPAWN'd by mgmTfA_scr_client_onPlayerRespawn.sqf with no arguments. It will continuously scan vicinity for Fixed Destination Taxi Vehicles and will ensure 'payNow' action is attached to valid target vehicles.
//H ~~
//H
//HH
//H ~~
//HH	Syntax				:	_null = [] mgmTfA_fnc_client_doScanVicinityForclickNGoTaxiVehicles;
//HH	Parameters			:	none
//HH	Return Value			:	none
//HH
//HH	Public Variables relied on	:	mgmTfA_configgv_clickNGoTaxisTaxiVehicleClassnameTextString
//HH	Global Variables relied on	:	none
//HH	Global Variables modified	:	none
//HH
if (isServer) exitWith {};
if (!isServer) then {	waitUntil {vehicle player == player};	waitUntil {!isNull (finddisplay 46)};};
if (isNil("mgmTfA_Client_Init")) then {	mgmTfA_Client_Init = 0;};

private ["_thisFileVerbosityLevelNumber"];
_thisFileVerbosityLevelNumber = mgmTfA_configgv_clientVerbosityLevel;

if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_client_doScanVicinityForclickNGoTaxiVehicles.sqf]  [TV8]          STARTED waiting for constraint (mgmTfA_Client_Init==1) to be fulfilled..."];};
waitUntil {mgmTfA_Client_Init==1};
if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_client_doScanVicinityForclickNGoTaxiVehicles.sqf]  [TV8]          PROCEEDING     mgmTfA_Client_Init==1     <== constraint is now fulfilled..."];};

private	[
		"_nearestclickNGoTaxiSameClassVehiclesArray",
		"_scanRadiusInMetresNumber",
		"_clickNGoTaxiVehiclesArray",
		"_numberOfSameClassVehicleResultsNumber",
		"_numberOfclickNGoTaxisFoundNumber",
		"_scanStartTimeInSecondsNumber",
		"_scanCompletionTimeInSecondsNumber",
		"_scanDurationInSecondsNumber",
		"_sleepDurationBetweenScans",
		"_iterationIDNumber",
		"_myGUSUIDNumber",
		"_cNGoTxPayNowMenuIsCurrentlyNotAttachedBool"
		];

_scanRadiusInMetresNumber = mgmTfA_configgv_clickNGoTaxisClientSideScannerScanRadiusInMetresNumber;
_sleepDurationBetweenScans = mgmTfA_configgv_clickNGoTaxisClientSideScannerSleepDurationBetweenScansInSecondsNumber;
_iterationIDNumber = 0;
_myGUSUIDNumber = nil;

//// main loop
while {alive player} do {
	if (_thisFileVerbosityLevelNumber>=9) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_client_doScanVicinityForclickNGoTaxiVehicles.sqf]  [TV9]          inside {alive player} now.		will START WAITING"];};
	waitUntil {uiSleep 0.25 && !isnull (finddisplay 46) && vehicle player == player};
	if (_thisFileVerbosityLevelNumber>=9) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_client_doScanVicinityForclickNGoTaxiVehicles.sqf]  [TV9]          inside {alive player} now.		COMPLETED waiting"];};
	_iterationIDNumber = _iterationIDNumber + 1;
	// Empty or otherwise reset dynamic variables before running a new scan
	_nearestclickNGoTaxiSameClassVehiclesArray = [];
	_discoveredNewclickNGoTaxiVehiclesArray = [];
	_numberOfSameClassVehicleResultsNumber = 0;
	_numberOfDiscoveredNewclickNGoTaxiVehiclesNumber = 0;
	_scanStartTimeInSecondsNumber = 0;
	_scanCompletionTimeInSecondsNumber = 0;
	_scanDurationInSecondsNumber = 0;
	_myGUSUIDNumber = nil;
	// Do the scan
	_scanStartTimeInSecondsNumber = (time);
	_nearestclickNGoTaxiSameClassVehiclesArray = (nearestObjects [(player), [mgmTfA_configgv_clickNGoTaxisTaxiVehicleClassnameTextString], _scanRadiusInMetresNumber]);
	_numberOfSameClassVehicleResultsNumber = (count _nearestclickNGoTaxiSameClassVehiclesArray);
	{
		if (_thisFileVerbosityLevelNumber>=9) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_client_doScanVicinityForclickNGoTaxiVehicles.sqf] [TV9]		DEVDEBUG		Now at the top of (forEach _nearestclickNGoTaxiSameClassVehiclesArray) iteration block.	(_x) is: (%1).", (str _x)];};//dbg
		if ((alive _x) && (_x getVariable "mgmTfAmgmTfAisclickNGoTaxi") && ((_x	getVariable ["mgmTfAvehiclePayNowMenuStatus",0]) == 0)) then {
			if (_thisFileVerbosityLevelNumber>=9) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_client_doScanVicinityForclickNGoTaxiVehicles.sqf] [TV9]		DEVDEBUG		Now inside the block => ((alive _x) && (_x getVariable mgmTfAmgmTfAisclickNGoTaxi) && ((_x	getVariable [mgmTfAvehiclePayNowMenuStatus,0]) == 0))	(_x) is: (%1).", (str _x)];};//dbg
			// we found a clickNGoTaxi here which hasn't been processed by us before!		what we want to do is:		attach a payNow action to this vehicle via function (since its status is 0, we KNOW that it does not have one just yet)
			// Get this current vehicle's GUSUID number and assign to our local _myGUSUIDNumber
			_myGUSUIDNumber = (_x getVariable "GUSUIDNumber");
			// attach the menuOption via function
			_null = [_x, _myGUSUIDNumber] spawn mgmTfA_fnc_client_doProcessclickNGoTaxiAddActionWork;
			// mark this vehicle as processed, so the next time we won't waste time on it
			_x 	setVariable ["mgmTfAvehiclePayNowMenuStatus", 1, false];
			// add event handlers to manage clickNGo Taxi Instructions
			_getInEvent = _x addEventHandler ["GetIn", {_this spawn mgmTfA_fnc_client_clickNGoTaxiDisplayInstructions}];
			// add this vehicle to the found _clickNGoTaxiVehiclesArray array
			_discoveredNewclickNGoTaxiVehiclesArray pushBack _x;
		};
	} forEach _nearestclickNGoTaxiSameClassVehiclesArray;
	// Do post processing
	_numberOfDiscoveredNewclickNGoTaxiVehiclesNumber = (count _discoveredNewclickNGoTaxiVehiclesArray);
	_scanCompletionTimeInSecondsNumber = (time);
	_scanDurationInSecondsNumber = _scanCompletionTimeInSecondsNumber - _scanStartTimeInSecondsNumber;
	// we have completed forEach -- Report findings to client-side RPT log
	if (_numberOfDiscoveredNewclickNGoTaxiVehiclesNumber > 0) then {
		// there is at least 1 fixed destination taxi around
		if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_client_doScanVicinityForclickNGoTaxiVehicles.sqf] [TV8]		DEVDEBUG		I have completed a VICINITY SCAN for validclickNGoTaxiVehicles just now	(time=%1).		Scan and post-processing completed in (%2) seconds.		I have found (%3) new clickNGo Taxi vehicles.		Here is the contents of	(str _discoveredNewclickNGoTaxiVehiclesArray): (%4).		(str _iterationIDNumber) is: (%5).	I have attached the PayNow menu to new clickNGoTaxi vehicle(s).", (str time), (str _scanDurationInSecondsNumber), (str _numberOfDiscoveredNewclickNGoTaxiVehiclesNumber), (str _discoveredNewclickNGoTaxiVehiclesArray), (str _iterationIDNumber)];};//dbg
	} else {
		// no fixed destination taxis nearby
		if (_thisFileVerbosityLevelNumber>=8) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_client_doScanVicinityForclickNGoTaxiVehicles.sqf] [TV8]		DEVDEBUG		I have completed a VICINITY SCAN for validclickNGoTaxiVehicles just now	(time=%1).		Scan and post-processing completed in (%2) seconds.		I have not found any clickNGoTaxis.		(str _iterationIDNumber) is: (%3).", (str time), (str _scanDurationInSecondsNumber), (str _iterationIDNumber)];};//dbg
	};
	// uiSleep between iterations
	uiSleep _sleepDurationBetweenScans;
};
// EOF