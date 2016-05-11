//H
// ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_c_CO_fnc_launchTfAGUIViaMapRapidToggle.sqf
//H $PURPOSE$	:	This client side script monitors the 'opening' of in-game map; if it is opened rapidly more than a threshold value in a given amount of time, it will bring up the mgmTfA GUI
// ~~
//H
private ["_thisFileVerbosityLevelNumber"];
_thisFileVerbosityLevelNumber = 0;
scopeName "mgmTfA_c_CO_fnc_launchTfAGUIViaMapRapidToggleMainScope";
if (isServer) exitWith {};
if (!mgmTfA_configgv_GUIOpenMapCommandMonitoringEnabledBool) exitWith {diag_log format ["[mgmTfA] [mgmTfA_c_CO_fnc_launchTfAGUIViaMapRapidToggle.sqf] mgmTfA_configgv_GUIOpenMapCommandMonitoringEnabledBool is not true! Quitting!"];};
if (!isServer) then {
	if (isNil("mgmTfA_Client_Init")) then {
		mgmTfA_Client_Init=0;
	};
	waitUntil {mgmTfA_Client_Init==1};
};

if (mgmTfA_dynamicgv_clickNGoRequestTaxiViaTripleMapOpenViaTripleMapOpenFunctionRunningBool) exitWith {diag_log format ["[mgmTfA] [mgmTfA_c_CO_fnc_launchTfAGUIViaMapRapidToggle.sqf] ATTEMPTED executing another instance of mgmTfA_c_CO_fnc_launchTfAGUIViaMapRapidToggle however mgmTfA_dynamicgv_clickNGoRequestTaxiViaTripleMapOpenViaTripleMapOpenFunctionRunningBool is true! Quitting!"];};
mgmTfA_dynamicgv_clickNGoRequestTaxiViaTripleMapOpenViaTripleMapOpenFunctionRunningBool = true;

private	[
		"_xclickNGoOpenMapCommandMonitoringThisMustBeTheSignalThresholdMapOpenedNTimesNumber",
		"_xclickNGoOpenMapCommandMonitoringThisMustBeTheSignalTurnThePage",
		"_xclickNGoOpenMapCommandMonitoringThisMustBeTheSignalThresholdMapOpenedNTimesInSecsNumber",
		"_curTimeSecondsNumber",
		"_iterationID",
		"_arraySizeCountNumber",
		"_thirdMostRecentTimestampsIndexPositionFromLeftNumber",
		"_thirdMostRecentTimestampNumber"
		];
// Copy global config values to local vars
_xclickNGoOpenMapCommandMonitoringThisMustBeTheSignalThresholdMapOpenedNTimesNumber = mgmTfA_configgv_clickNGoOpenMapCommandMonitoringThisMustBeTheSignalThresholdMapOpenedNTimesNumber;
_xclickNGoOpenMapCommandMonitoringThisMustBeTheSignalTurnThePage = mgmTfA_configgv_clickNGoOpenMapCommandMonitoringThisMustBeTheSignalTurnThePage;
_xclickNGoOpenMapCommandMonitoringThisMustBeTheSignalThresholdMapOpenedNTimesInSecsNumber = mgmTfA_configgv_clickNGoOpenMapCommandMonitoringThisMustBeTheSignalThresholdMapOpenedNTimesInSecsNumber;
_iterationID = 0;
// as long as player is alive, never stop doing this clickNGo hotkey-replacement check
while {alive player} do {
	// force slow down
	uiSleep 0.10;
	// wait till map is screen		-- wait for the main map display is detected (display = 12)
	waitUntil {!isNull findDisplay 12};
	// proceed when map is visible
	waitUntil {visibleMap};
	// player just opened the map. let's record this in the database
	_iterationID = _iterationID + 1;
	_curTimeSecondsNumber = (time);
	mgmTfA_dynamicgv_mapOpenedAtTimestampsInSecondTextStringArray pushBack (_curTimeSecondsNumber);
	_arraySizeCountNumber = (count (mgmTfA_dynamicgv_mapOpenedAtTimestampsInSecondTextStringArray));
	if (_arraySizeCountNumber >= _xclickNGoOpenMapCommandMonitoringThisMustBeTheSignalThresholdMapOpenedNTimesNumber) then {
		// YES, the map has been opened at least n times since last spawn, meaning  there is a chance that the map has been opened 3 times in the last 8 seconds // let's dig deeper but first log what we got
		//if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA] [mgmTfA_c_CO_fnc_launchTfAGUIViaMapRapidToggle.sqf] [TV4] Uptime is now (%1) seconds.		It's a YES (_arraySizeCountNumber IS >=_xclickNGoOpenMapCommandMonitoringThisMustBeTheSignalThresholdMapOpenedNTimesNumber (%2)).		Since last player spawn, this function has iterated this many times:	_iterationID=(%3).		I have detected that the map has been opened _arraySizeCountNumber=(%4) times since since client init.", (str _curTimeSecondsNumber), (str _xclickNGoOpenMapCommandMonitoringThisMustBeTheSignalThresholdMapOpenedNTimesNumber), (str _iterationID), (str _arraySizeCountNumber)];};//dbg
		// is the 3rd most recent mapOpen timestamp dated 8 seconds ago or sooner?
		// get the 3rd timestamp
		_thirdMostRecentTimestampsIndexPositionFromLeftNumber = (_arraySizeCountNumber - _xclickNGoOpenMapCommandMonitoringThisMustBeTheSignalThresholdMapOpenedNTimesNumber);
		_thirdMostRecentTimestampNumber = (mgmTfA_dynamicgv_mapOpenedAtTimestampsInSecondTextStringArray select _thirdMostRecentTimestampsIndexPositionFromLeftNumber);
		if ((_curTimeSecondsNumber - _thirdMostRecentTimestampNumber) <= _xclickNGoOpenMapCommandMonitoringThisMustBeTheSignalThresholdMapOpenedNTimesInSecsNumber) then {
			// YES, the map has been opened more than n times in the last 8 seconds. Let's log this and activate the clickNGo hotkey, but first ensure the next 2 key presses won't activate this again
			mgmTfA_dynamicgv_mapOpenedAtTimestampsInSecondTextStringArray = _xclickNGoOpenMapCommandMonitoringThisMustBeTheSignalTurnThePage;
			// launch function.	note that, clickNGoRequestTaxi function has the following code which will make it wait for the main display:		if (!isServer) then {waitUntil {!isnull (finddisplay 46) blah blah 
			_null = CreateDialog "MGMTFA_DIALOG"
			//_null = [] spawn mgmTfA_c_TA_fncRequestTaxi;
		} else {
			// NO, the map has NOT been opened more than 3 times in the last 8 seconds. nothing to be done at this time
		};
	} else {
		// NO, since last spawn, map has not even been opened 3 times yet, there's no way player requested a clickNGo Taxi.	// do nothing.
		//if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA] [mgmTfA_c_CO_fnc_launchTfAGUIViaMapRapidToggle.sqf]  [TV4] Uptime is now (%1) seconds.		It's a NO (_arraySizeCountNumber is NOT >= _xclickNGoOpenMapCommandMonitoringThisMustBeTheSignalThresholdMapOpenedNTimesNumber (%2)).		Since last player spawn, this function has iterated this many times:	_iterationID=(%3).		I have detected that the map has been opened _arraySizeCountNumber=(%4) times since since client init.", (str _curTimeSecondsNumber), (str _xclickNGoOpenMapCommandMonitoringThisMustBeTheSignalThresholdMapOpenedNTimesNumber), (str _iterationID), (str _arraySizeCountNumber)];};//dbg
	};
	// we're done here. let's wait for the map to be closed.
	// proceed when map is no longer visible
	waitUntil {!visibleMap};
};
// EOF