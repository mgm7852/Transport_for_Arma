//H
//H ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_s_FD_scr_initCreateMapMarkerCATP02.sqf
//H $PURPOSE$	:	This server-side script creates a particular Map Marker on server start.
//H ~~
//H
if (!isServer) exitWith {}; if (isNil("mgmTfA_Server_Init")) then {mgmTfA_Server_Init=0;}; waitUntil {mgmTfA_Server_Init==1}; private ["_thisFileVerbosityLevelNumber"]; _thisFileVerbosityLevelNumber = mgmTfA_configgv_serverVerbosityLevel;

// Create a Map Marker for CATP02, if requested in configuration file, as per details defined therein
if(mgmTfA_configgv_createCATP02LocationMapMarkerBool) then {
		markerCATP02String = createMarker["CATP02MapMarker", mgmTfA_configgv_CATP02LocationPositionArray];
		markerCATP02String setMarkerType mgmTfA_configgv_CATP02LocationMapMarkerTypeTextString;
		markerCATP02String setMarkerShape mgmTfA_configgv_CATP02LocationMapMarkerShapeTextString;
		markerCATP02String setMarkerColor mgmTfA_configgv_CATP02LocationMapMarkerColorTextString;
		markerCATP02String setMarkerText mgmTfA_configgv_CATP02LocationMapMarkerTextString;
};
//EOF