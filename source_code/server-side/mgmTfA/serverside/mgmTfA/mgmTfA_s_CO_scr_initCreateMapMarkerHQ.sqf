//H
//H ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_s_CO_scr_initCreateMapMarkerHQ.sqf
//H $PURPOSE$	:	This server-side script creates a particular Map Marker on server start.
//H ~~
//H
if (!isServer) exitWith {}; if (isNil("mgmTfA_Server_Init")) then {mgmTfA_Server_Init=0;}; waitUntil {mgmTfA_Server_Init==1}; private ["_thisFileVerbosityLevelNumber"]; _thisFileVerbosityLevelNumber = mgmTfA_configgv_serverVerbosityLevel;

// Create a Map Marker for Taxi Corp as requested in configuration file
if(mgmTfA_configgv_createTaxiCorpHqLocationMapMarkerBool) then {
		markerTaxiCorpHQString = createMarker["taxiCorpHQMapMarker", mgmTfA_configgv_taxiCorpHqLocationPositionArray];
		markerTaxiCorpHQString setMarkerType mgmTfA_configgv_taxiCorpHqLocationMapMarkerTypeTextString;
		markerTaxiCorpHQString setMarkerShape mgmTfA_configgv_taxiCorpHqLocationMapMarkerShapeTextString;
		markerTaxiCorpHQString setMarkerColor mgmTfA_configgv_taxiCorpHqLocationMapMarkerColorTextString;
		markerTaxiCorpHQString setMarkerText mgmTfA_configgv_taxiCorpHqLocationMapMarkerTextString;
};
//EOF