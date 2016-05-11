//H
//H ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_s_FD_scr_initCreateMapMarkerCATP03.sqf
//H $PURPOSE$	:	This server side script creates a particular Map Marker on server start.
//H ~~
//H
if (!isServer) exitWith {}; if (isNil("mgmTfA_Server_Init")) then {mgmTfA_Server_Init=0;}; waitUntil {mgmTfA_Server_Init==1}; private ["_thisFileVerbosityLevelNumber"]; _thisFileVerbosityLevelNumber = mgmTfA_configgv_serverVerbosityLevel;

// Create a Map Marker for CATP03, if requested in configuration file, as per details defined therein
if(mgmTfA_configgv_createCatp03LocationMapMarkerBool) then {
		markerCatp03String = createMarker["catp03MapMarker", mgmTfA_configgv_catp03LocationPositionArray];
		markerCatp03String setMarkerType mgmTfA_configgv_catp03LocationMapMarkerTypeTextString;
		markerCatp03String setMarkerShape mgmTfA_configgv_catp03LocationMapMarkerShapeTextString;
		markerCatp03String setMarkerColor mgmTfA_configgv_catp03LocationMapMarkerColorTextString;
		markerCatp03String setMarkerText mgmTfA_configgv_catp03LocationMapMarkerTextString;
};
//EOF