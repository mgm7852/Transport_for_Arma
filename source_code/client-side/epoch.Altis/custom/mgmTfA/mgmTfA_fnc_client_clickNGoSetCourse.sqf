//H
// ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_fnc_client_clickNGoSetCourse.sqf
//H $PURPOSE$	:	This client side script contains the code to set the course of a clickNGo taxi.
// ~~
//H
private ["_thisFileVerbosityLevelNumber"];
_thisFileVerbosityLevelNumber = 0;
scopeName "mgmTfA_fnc_client_clickNGoSetCourseMainScope";
if (isServer) exitWith {};
if (!isServer) then {
	waitUntil {!isnull (finddisplay 46)};
	if (isNil("mgmTfA_Client_Init")) then {
		mgmTfA_Client_Init=0;
	};
	waitUntil {mgmTfA_Client_Init==1};
};
if (!(isNil "clickNGoTaxiDestinationChoser_systemReady")) exitWith {hint "SYSTEM CURRENTLY NOT AVAILABLE"};
private	[
		"_msg2HintTextString",
		"_msg2SyschatTextString",
		"_posOld"
		];
_posOld = getMarkerPos "clickNGoTaxiChosenPosition";
diag_log format ["[mgmTfA] [mgmTfA_fnc_client_clickNGoSetCourse.sqf]      clickNGoTaxiChosenPosition INITIAL SPOT is: (%1)", (str _posOld)];
deleteMarker "clickNGoTaxiChosenPosition";
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
	clickNGoTaxiChosenDestinationMarker			= createMarkerLocal		[""clickNGoTaxiChosenPosition"",_pos];
	clickNGoTaxiChosenDestinationMarker			setMarkerTypeLocal		""hd_dot"";
	clickNGoTaxiChosenDestinationMarker			setMarkerColorLocal		""ColorBlue"";
	clickNGoTaxiChosenDestinationMarker			setMarkerTextLocal		""clickNGo Taxi Destination"";
	diag_log format [""[mgmTfA] [mgmTfA_fnc_client_clickNGoSetCourse.sqf]      clickNGoTaxiChosenPosition NEW SPOT is: (%1)"", (str _pos)];
	clickNGoTaxiDestinationChoser_mapClicked								= true;
	onMapSingleClick {};
	hint """";
";
waitUntil { !(isNil "clickNGoTaxiDestinationChoser_mapClicked") };
clickNGoTaxiDestinationChoser_mapClicked									= nil;
// Close the map
openMap false;
// EOF