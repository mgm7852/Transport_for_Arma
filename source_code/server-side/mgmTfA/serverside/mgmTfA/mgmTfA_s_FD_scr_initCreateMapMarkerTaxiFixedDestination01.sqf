//H
//H ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_s_FD_scr_initCreateMapMarkerTaxiFixedDestination01.sqf
//H $PURPOSE$	:	This server side script creates a particular Map Marker on server start.
//H ~~
//H
if (!isServer) exitWith {}; if (isNil("mgmTfA_Server_Init")) then {mgmTfA_Server_Init=0;}; waitUntil {mgmTfA_Server_Init==1}; private ["_thisFileVerbosityLevelNumber"]; _thisFileVerbosityLevelNumber = mgmTfA_configgv_serverVerbosityLevel;

// Create a Map Marker for Taxi Fixed Destination01, if requested in configuration file, as per details defined therein
if(mgmTfA_configgv_taxiFixedDestination01LocationMapMarkerBool) then {
		markerTaxiFixedDestination01String = createMarker["taxiFixedDestination01MapMarker", mgmTfA_configgv_taxiFixedDestination01LocationPositionArray];
		markerTaxiFixedDestination01String setMarkerType mgmTfA_configgv_taxiFixedDestination01LocationMapMarkerTypeTextString;
		markerTaxiFixedDestination01String setMarkerShape mgmTfA_configgv_taxiFixedDestination01LocationMapMarkerShapeTextString;
		markerTaxiFixedDestination01String setMarkerColor mgmTfA_configgv_taxiFixedDestination01LocationMapMarkerColorTextString;
		markerTaxiFixedDestination01String setMarkerText mgmTfA_configgv_taxiFixedDestination01LocationMapMarkerTextString;
};
//EOF