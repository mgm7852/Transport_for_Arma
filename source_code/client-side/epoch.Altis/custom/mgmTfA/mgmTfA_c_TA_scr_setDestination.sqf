//H
// ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_c_TA_scr_setDestination.sqf
//H $PURPOSE$	:	This client-side script contains the code to set the destination of a clickNGo taxi.
// ~~
//H
private ["_thisFileVerbosityLevelNumber"];
_thisFileVerbosityLevelNumber = 0;
scopeName "mgmTfA_c_TA_scr_setDestinationMainScope";
if (isServer) exitWith {};
if (!isServer) then {
	waitUntil {!isnull (finddisplay 46)};
	if (isNil("mgmTfA_Client_Init")) then {
		mgmTfA_Client_Init=0;
	};
	waitUntil {mgmTfA_Client_Init==1};
};
if (!(isNil "TATaxiDestinationChoser_systemReady")) exitWith {hint "SYSTEM CURRENTLY NOT AVAILABLE"};
private	[
		"_msg2HintTextString",
		"_msg2SyschatTextString",
		"_posOld"
		];
_posOld = getMarkerPos "TATaxiChosenPosition";
diag_log format ["[mgmTfA] [mgmTfA_c_TA_scr_setDestination.sqf]      TATaxiChosenPosition INITIAL SPOT is: (%1)", (str _posOld)];
deleteMarker "TATaxiChosenPosition";
// Open the map
openMap true;
// Inform via hint (in Rich format)
_msg2HintTextString = parsetext format ["AWAITING INPUT<br/><br/>SINGLE LEFT CLICK<br/>TO SET DESTINATION"];
hint _msg2HintTextString;
// Inform via systemChat (in Text-Only format)
_msg2SyschatTextString = parsetext format ["[SYSTEM]  AWAITING INPUT. SINGLE LEFT CLICK TO SET DESTINATION"];
systemChat (str _msg2SyschatTextString);
// Insert the actual code to handle the mouse-left-click-on-map
onMapSingleClick "
	TATaxiChosenDestinationMarker			= createMarkerLocal		[""TATaxiChosenPosition"",_pos];
	TATaxiChosenDestinationMarker			setMarkerTypeLocal		""hd_dot"";
	TATaxiChosenDestinationMarker			setMarkerColorLocal		""ColorBlue"";
	TATaxiChosenDestinationMarker			setMarkerTextLocal		""clickNGo Taxi Destination"";
	diag_log format [""[mgmTfA] [mgmTfA_c_TA_scr_setDestination.sqf]      TATaxiChosenPosition NEW SPOT is: (%1)"", (str _pos)];
	TATaxiDestinationChoser_mapClicked								= true;
	onMapSingleClick {};
	hint """";
";
waitUntil { !(isNil "TATaxiDestinationChoser_mapClicked") };
TATaxiDestinationChoser_mapClicked									= nil;
// Close the map
openMap false;
// EOF