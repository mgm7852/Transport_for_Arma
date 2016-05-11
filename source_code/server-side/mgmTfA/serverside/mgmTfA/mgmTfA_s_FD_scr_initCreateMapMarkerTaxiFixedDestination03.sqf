//H
//H ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_s_FD_scr_initCreateMapMarkerTaxiFixedDestination03.sqf
//H $PURPOSE$	:	This server-side script creates a particular Map Marker on server start.
//H ~~
//H
if (!isServer) exitWith {}; if (isNil("mgmTfA_Server_Init")) then {mgmTfA_Server_Init=0;}; waitUntil {mgmTfA_Server_Init==1}; private ["_thisFileVerbosityLevelNumber"]; _thisFileVerbosityLevelNumber = mgmTfA_configgv_serverVerbosityLevel;

// Create a Map Marker for Taxi Fixed Destination03, if requested in configuration file, as per details defined therein
if(mgmTfA_configgv_taxiFixedDestination03LocationMapMarkerBool) then {
		markerTaxiFixedDestination03String = createMarker["taxiFixedDestination03MapMarker", mgmTfA_configgv_taxiFixedDestination03LocationPositionArray];
		markerTaxiFixedDestination03String setMarkerType mgmTfA_configgv_taxiFixedDestination03LocationMapMarkerTypeTextString;
		markerTaxiFixedDestination03String setMarkerShape mgmTfA_configgv_taxiFixedDestination03LocationMapMarkerShapeTextString;
		markerTaxiFixedDestination03String setMarkerColor mgmTfA_configgv_taxiFixedDestination03LocationMapMarkerColorTextString;
		markerTaxiFixedDestination03String setMarkerText mgmTfA_configgv_taxiFixedDestination03LocationMapMarkerTextString;
};
//EOF