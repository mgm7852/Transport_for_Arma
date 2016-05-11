//H
//H ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_s_CO_scr_initCreateMapMarkercatp01.sqf
//H $PURPOSE$	:	This server side script creates a particular Map Marker on server start.
//H ~~
//H
if (!isServer) exitWith {}; if (isNil("mgmTfA_Server_Init")) then {mgmTfA_Server_Init=0;}; waitUntil {mgmTfA_Server_Init==1}; private ["_thisFileVerbosityLevelNumber"]; _thisFileVerbosityLevelNumber = mgmTfA_configgv_serverVerbosityLevel;

// Create a Map Marker for CATP01, if requested in configuration file, as per details defined therein
if(mgmTfA_configgv_createCatp01LocationMapMarkerBool) then {
		markerCatp01String = createMarker["catp01MapMarker", mgmTfA_configgv_catp01LocationPositionArray];
		markerCatp01String setMarkerType mgmTfA_configgv_catp01LocationMapMarkerTypeTextString;
		markerCatp01String setMarkerShape mgmTfA_configgv_catp01LocationMapMarkerShapeTextString;
		markerCatp01String setMarkerColor mgmTfA_configgv_catp01LocationMapMarkerColorTextString;
		markerCatp01String setMarkerText mgmTfA_configgv_catp01LocationMapMarkerTextString;
};
//EOF