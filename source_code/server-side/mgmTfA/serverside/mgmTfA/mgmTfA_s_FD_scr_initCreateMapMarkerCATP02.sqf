//H
//H ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_scr_server_initCreateMapMarkerCatp02.sqf
//H $PURPOSE$	:	This server side script creates a particular Map Marker on server start.
//H ~~
//H
if (!isServer) exitWith {}; if (isNil("mgmTfA_Server_Init")) then {mgmTfA_Server_Init=0;}; waitUntil {mgmTfA_Server_Init==1}; private ["_thisFileVerbosityLevelNumber"]; _thisFileVerbosityLevelNumber = mgmTfA_configgv_serverVerbosityLevel;

// Create a Map Marker for Catp02, if requested in configuration file, as per details defined therein
if(mgmTfA_configgv_createCatp02LocationMapMarkerBool) then {
		markerCatp02String = createMarker["Catp02MapMarker", mgmTfA_configgv_Catp02LocationPositionArray];
		markerCatp02String setMarkerType mgmTfA_configgv_Catp02LocationMapMarkerTypeTextString;
		markerCatp02String setMarkerShape mgmTfA_configgv_Catp02LocationMapMarkerShapeTextString;
		markerCatp02String setMarkerColor mgmTfA_configgv_Catp02LocationMapMarkerColorTextString;
		markerCatp02String setMarkerText mgmTfA_configgv_Catp02LocationMapMarkerTextString;
};
//EOF