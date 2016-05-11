//H
//H ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_s_FD_scr_initCreateMapMarkerTaxiFixedDestination02.sqf
//H $PURPOSE$	:	This server-side script creates a particular Map Marker on server start.
//H ~~
//H
if (!isServer) exitWith {}; if (isNil("mgmTfA_Server_Init")) then {mgmTfA_Server_Init=0;}; waitUntil {mgmTfA_Server_Init==1}; private ["_thisFileVerbosityLevelNumber"]; _thisFileVerbosityLevelNumber = mgmTfA_configgv_serverVerbosityLevel;

// Create a Map Marker for Taxi Fixed Destination02, if requested in configuration file, as per details defined therein
if(mgmTfA_configgv_taxiFixedDestination02LocationMapMarkerBool) then {
		markerTaxiFixedDestination02String = createMarker["taxiFixedDestination02MapMarker", mgmTfA_configgv_taxiFixedDestination02LocationPositionArray];
		markerTaxiFixedDestination02String setMarkerType mgmTfA_configgv_taxiFixedDestination02LocationMapMarkerTypeTextString;
		markerTaxiFixedDestination02String setMarkerShape mgmTfA_configgv_taxiFixedDestination02LocationMapMarkerShapeTextString;
		markerTaxiFixedDestination02String setMarkerColor mgmTfA_configgv_taxiFixedDestination02LocationMapMarkerColorTextString;
		markerTaxiFixedDestination02String setMarkerText mgmTfA_configgv_taxiFixedDestination02LocationMapMarkerTextString;
};
//EOF