//H
// ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_fnc_client_clickNGoTaxiDisplayInstructions.sqf
//H $PURPOSE$	:	undocumented
// ~~
//H
//HH
//HH	~~
//HH	Syntax		:	_null = [] mgmTfA_fnc_client_clickNGoTaxiDisplayInstructions;
//HH	Parameters	:	none
//HH	Return Value	:	none.		if conditions are met, this script will display on screen instructions.
//HH	~~
//HH	The server publishes the following publicVariables this function relies on:
//HH		mgmTfA_dynamicgv_clickNGoTaxiDisplayInstructionsOnGetInEnabledBool
//HH		mgmTfA_dynamicgv_clickNGoTaxiReDisplayInstructionsOnGetInTimeThresholdInSecondsNumber
//HH		mgmTfA_dynamicgv_clickNGoTaxiDisplayInstructionsOnGetInDisplayMethodNumber
//HH
//HH	Local client computer has the following global variables this function relies on:
//HH		mgmTfA_dynamicgv_clickNGoTaxiLastTimePlayerGotInInOneOfOurVehicles
//HH		mgmTfA_dynamicgv_clickNGoTaxiFirstGetInHasOccurred
//HH
//HH	This function does updates the following global variables:
//HH		mgmTfA_dynamicgv_clickNGoTaxiLastTimePlayerGotInInOneOfOurVehicles
//HH		mgmTfA_dynamicgv_clickNGoTaxiFirstGetInHasOccurred
//HH
//HH
private ["_thisFileVerbosityLevelNumber"];
_thisFileVerbosityLevelNumber = mgmTfA_configgv_clientVerbosityLevel;
// The Plan:
//	GetIn EH will call us every time player getIn a vehicle.
//	We will check if it is a clickNGo Taxi
//	It will then run a check: Is this the first time player got in a clickNGo Taxi?
//		YES:	display hintC fancy Instructions box and also mark that 1st get in has occurred ==>	mgmTfA_dynamicgv_clickNGoTaxiFirstGetInHasOccurred
//		NO:	display hint only (without disrupting the player as this won't require player to  click 'CONTINUE')
//
//	We do not want to message spam the player for quick hop off & hop back ons; 
//	thus a global variable (mgmTfA_dynamicgv_clickNGoTaxiLastTimePlayerGotInInOneOfOurVehicles) keeps track of last getIn to clickNGoTaxi and if 
//	mgmTfA_dynamicgv_clickNGoTaxiReDisplayInstructionsOnGetInTimeThresholdInSecondsNumber seconds have not passed since last getIn, the message will not be displayed
if (!((vehicle player) getVariable ["mgmTfAisclickNGoTaxi", false])) exitWith {
	if (_thisFileVerbosityLevelNumber>=7) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_client_clickNGoTaxiDisplayInstructions.sqf] [TV7]		DEVDEBUG		result of (str (((vehicle player) getVariable [''mgmTfAisclickNGoTaxi'', false]))) is: (%1).	note that the actual check reverses this with a ! sign", (str (((vehicle player) getVariable ["mgmTfAisclickNGoTaxi", false])))];};//dbg
	if (_thisFileVerbosityLevelNumber>=7) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_client_clickNGoTaxiDisplayInstructions.sqf] [TV7]		DEVDEBUG		Just determined player currently IS NOT in a clickNGoTaxi!"];};//dbg
};
// if we hit this line, player must be in a clickNGo Taxi
private	[
		"_thisIsTheFirstDisplay",
		"_timeElapsedInSecondsNumber",
		"_reminderShouldBeDisplayedNow"
		];
_reminderShouldBeDisplayedNow = false;

// let's check timings now:			if enough time has not passed, then the rest of this file should not even be processed
if (mgmTfA_dynamicgv_clickNGoTaxiInstructionsAutoDisplayOnGetInHappenedAtTimeInSecondsNumber == -1) then {
	// this was set to -1 in client init, it is still the same meaning firstDisplay has not occurred yet
	_thisIsTheFirstDisplay = true;
	// firstDisplay is happening right now so let's update the global variable timestamp for future iterations
	mgmTfA_dynamicgv_clickNGoTaxiInstructionsAutoDisplayOnGetInHappenedAtTimeInSecondsNumber = (time);
} else {
	// this is not the firstDisplay
	_thisIsTheFirstDisplay = false;

	// should we display a reminder at this time?
	_timeElapsedInSecondsNumber = (time) - mgmTfA_dynamicgv_clickNGoTaxiInstructionsAutoDisplayOnGetInHappenedAtTimeInSecondsNumber;
	if (_timeElapsedInSecondsNumber > mgmTfA_dynamicgv_clickNGoTaxiReDisplayInstructionsOnGetInTimeThresholdInSecondsNumber) then {
		// more than threshold seconds have passed, we will need to display a reminder time 
		_reminderShouldBeDisplayedNow = true;
		// update the global variable so that it can be evaluated in any future iterations
		mgmTfA_dynamicgv_clickNGoTaxiInstructionsAutoDisplayOnGetInHappenedAtTimeInSecondsNumber = (time);
		if (_thisFileVerbosityLevelNumber>=7) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_client_clickNGoTaxiDisplayInstructions.sqf] [TV7]		DEVDEBUG		Just determined more than threshold seconds HAVE passed. we SHOULD display Instructions. Time Elapsed since last display is calculated as: (%1).", (str _timeElapsedInSecondsNumber)];};//dbg
	} else {
		// more than threshold seconds have NOT passed. we should not display a hint  reminder at this time
		_reminderShouldBeDisplayedNow = false;
		if (_thisFileVerbosityLevelNumber>=7) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_client_clickNGoTaxiDisplayInstructions.sqf] [TV7]		DEVDEBUG		Just determined more than threshold seconds HAVEN'T passed. we should NOT display Instructions. Time Elapsed since last display is calculated as: (%1).", (str _timeElapsedInSecondsNumber)];};//dbg
	};
};
// if there's nothing to do, exitWith
if ((!_thisIsTheFirstDisplay) && (!_reminderShouldBeDisplayedNow)) exitWith {
	if (_thisFileVerbosityLevelNumber>=7) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_client_clickNGoTaxiDisplayInstructions.sqf] [TV7]		DEVDEBUG		Terminating now as we have =>		(!_thisIsTheFirstDisplay) && (!_reminderShouldBeDisplayedNow)."];};//dbg
};
// if we hit this line, there must be something that we will need to do.
if (_thisFileVerbosityLevelNumber>=7) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_client_clickNGoTaxiDisplayInstructions.sqf] [TV7]		DEVDEBUG		Current situation:	(str _thisIsTheFirstDisplay) is: (%1).		(str _reminderShouldBeDisplayedNow) is: (%2).", (str _thisIsTheFirstDisplay), (str _reminderShouldBeDisplayedNow)];};//dbg

// Prepare systemChat messages
private	[
		"_systemChatMessageTextLine1",
		"_systemChatMessageTextLine2",
		"_systemChatMessageTextLine3",
		"_systemChatMessageTextLine4"
		];
_systemChatMessageTextLine1 = parsetext format ["PAY AS YOU GO PRICING"];
_systemChatMessageTextLine2 = parsetext format ["Service fee is	%1 cryptos	every %2 seconds", (str mgmTfA_configgv_clickNGoTaxisTickCostInCryptoNumber), (str mgmTfA_configgv_clickNGoTaxisTickStepTimeInSecondsNumber)];
_systemChatMessageTextLine3 = parsetext format [" "];
_systemChatMessageTextLine4 = parsetext format ["Set Course Hotkey is:		%1", (str mgmTfA_configgv_clickNGoSetCourseHotkeyTextRepresentationTextString)];

// FUNCTIONS
// ~~
DisplayAsPopup = {
	// Display systemChat messages for the first time
	// send 3x empty (line3) first to dismiss menuRemoved message
	systemChat (str _systemChatMessageTextLine3);
	systemChat (str _systemChatMessageTextLine3);
	systemChat (str _systemChatMessageTextLine3);
	systemChat (str _systemChatMessageTextLine1);
	systemChat (str _systemChatMessageTextLine2);
	//don't send this	 -- as it's possibly better without space?		systemChat (str _systemChatMessageTextLine3);
	systemChat (str _systemChatMessageTextLine4);

	// Display the popup hintC message
	[] execVM "custom\mgmTfA\mgmTfA_scr_client_displayAsPopup.sqf"							;
};
// ~~

// ~~
DisplayAsHint = {
	// Display systemChat messages for the first time
	// send 3x empty (line3) first to dismiss menuRemoved message
	systemChat (str _systemChatMessageTextLine3);
	systemChat (str _systemChatMessageTextLine3);
	systemChat (str _systemChatMessageTextLine3);
	systemChat (str _systemChatMessageTextLine1);
	systemChat (str _systemChatMessageTextLine2);
	systemChat (str _systemChatMessageTextLine4);
private ["_text1", "_text2", "_text3", "_text4", "_text5", "_text6", "_text7", "_text8"];
_text1 = "<t color='#ff0000' size='1.5' shadow='1' shadowColor='#000000' align='left'>TRANSPORT FOR ARMA<br/><br/></t>";
_text2 = "<t color='#FFFFFF' size='1.2' align='left'>clickNGo Taxi Service<br/><br/></t>";
_text3 = "<t color='#FFFFFF' size='1.2' align='left'>Thank you for choosing us!<br/><br/></t>";
_text4 = "<t color='#FFFFFF' size='1.2' align='left'>Please pay the<br/>Minimum Prepay Fee now via mouseWheel<br/><br/></t>";
_text5 = "<t color='#FFFFFF' size='1.2' align='left'>Driver will then drive towards chosen destination<br/><br/></t>";
_text6 = "<t color='#FFFFFF' size='1.2' align='left'>When pre-paid credits run out, PAY AS YOU GO will kick in<br/><br/></t>";
_text7 = "<t color='#FFFFFF' size='1.2' align='left'>You may set a new destination at any time<br/><br/></t>";
_text8 = "<t color='#FFFFFF' size='1.2' align='left'>PAYG Fees and SetCourseHotkey listed at the bottom of screen<br/><br/></t>";
hint parseText (_text1 + _text2 + _text3 + _text4 + _text5 + _text6 + _text7 + _text8);
};
// ~~

// MAIN
private	[
		"_functionToExecuteNow",
		"_null"							
		];
_functionToExecuteNow = 0;

// if we end up with:		_functionToExecuteNow == 1		then we will execute the "display instructions as popup"	function
// if we end up with:		_functionToExecuteNow == 2		then we will execute the "display instructions as hint" 	function

// show popup, if this method is chosen in masterConfig =>								method #2:	always show as popup
if (mgmTfA_dynamicgv_clickNGoTaxiDisplayInstructionsOnGetInDisplayMethodNumber == 2) 							then { _functionToExecuteNow = 1 };
	
// show popup, if this IS the first display and this method is chosen in masterConfig =>			method #1:	show popup first time, in the future, show memory refresher as hint
if ((mgmTfA_dynamicgv_clickNGoTaxiDisplayInstructionsOnGetInDisplayMethodNumber == 1) && (_thisIsTheFirstDisplay)) 		then { _functionToExecuteNow = 1 };

// show hint, if this is NOT the first display and this method is chosen in masterConfig =>			method #1:	show popup first time, in the future, show memory refresher as hint
if ((mgmTfA_dynamicgv_clickNGoTaxiDisplayInstructionsOnGetInDisplayMethodNumber == 1) && (!_thisIsTheFirstDisplay)) 		then { _functionToExecuteNow = 2 };

// show hint, if this method is chosen in masterConfig =>								method #3:	always show as hint
if (mgmTfA_dynamicgv_clickNGoTaxiDisplayInstructionsOnGetInDisplayMethodNumber == 3) 							then { _functionToExecuteNow = 2 };

// now that we know what to do, let's run the function now...
if (_functionToExecuteNow == 1) then { _null = [] call DisplayAsPopup;	};
if (_functionToExecuteNow == 2) then { _null = [] call DisplayAsHint;	};

// log & exit
if (_thisFileVerbosityLevelNumber>=7) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_client_clickNGoTaxiDisplayInstructions.sqf] [TV7]		DEVDEBUG		Executing the last line and exiting now. (str _functionToExecuteNow) is: (%1).", (str _functionToExecuteNow)];};//dbg
// EOF