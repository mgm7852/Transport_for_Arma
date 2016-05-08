//H
//H ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_scr_server_initServer.sqf
//H $PURPOSE$	:	This is the server side initialization script.
//H ~~
//H
#include "\x\addons\custom\serverside\mgmTfA\_settings.hpp"

// We are still initializing...
mgmTfA_Server_Init=0;
publicVariable "mgmTfA_Server_Init";

if (mgmTfA_configgv_serverVerbosityLevel>=3) then {diag_log format ["[mgmTfA] [mgmTfA_scr_server_initServer.sqf] [D2] BEGIN reading file."];};
if (!isServer) exitWith {diag_log format ["[mgmTfA] [mgmTfA_scr_server_initServer.sqf] ATTEMPTED executing server file but not a server! Quitting!"];};
if (isServer) then {
	publicVariable	"mgmTfA_configgv_serverVerbosityLevel";
	/// COMPILE GLOBAL FUNCTIONS
	mgmTfA_fnc_server_returnNearbyRandomOnRoadPosition3DArray = compileFinal preprocessFileLineNumbers "\x\addons\custom\serverside\mgmTfA\mgmTfA_fnc_server_returnNearbyRandomOnRoadPosition3DArray.sqf";
	mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase02a_SendResponse_BookingRequestAccepted = compileFinal preprocessFileLineNumbers "\x\addons\custom\serverside\mgmTfA\mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase02a_SendResponse_BookingRequestAccepted.sqf";
	mgmTfA_fnc_server_clickNGoTaxi_ServicePhase02a_SendResponse_BookingRequestAccepted = compileFinal preprocessFileLineNumbers "\x\addons\custom\serverside\mgmTfA\mgmTfA_fnc_server_clickNGoTaxi_ServicePhase02a_SendResponse_BookingRequestAccepted.sqf";
	mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase02b_SendResponse_BookingRequestRejected_RequestorIsInBlacklist = compileFinal preprocessFileLineNumbers "\x\addons\custom\serverside\mgmTfA\mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase02b_SendResponse_BookingRequestRejected_RequestorIsInBlacklist.sqf";
	mgmTfA_fnc_server_clickNGoTaxi_ServicePhase02b_SendResponse_BookingRequestRejected_RequestorIsInBlacklist = compileFinal preprocessFileLineNumbers "\x\addons\custom\serverside\mgmTfA\mgmTfA_fnc_server_clickNGoTaxi_ServicePhase02b_SendResponse_BookingRequestRejected_RequestorIsInBlacklist.sqf";
	mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase03_CreateServiceUnitAndGoToRequestor = compileFinal preprocessFileLineNumbers "\x\addons\custom\serverside\mgmTfA\mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase03_CreateServiceUnitAndGoToRequestor.sqf";
	mgmTfA_fnc_server_clickNGoTaxi_ServicePhase03_CreateServiceUnitAndGoToRequestor = compileFinal preprocessFileLineNumbers "\x\addons\custom\serverside\mgmTfA\mgmTfA_fnc_server_clickNGoTaxi_ServicePhase03_CreateServiceUnitAndGoToRequestor.sqf";
	mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyond = compileFinal preprocessFileLineNumbers "\x\addons\custom\serverside\mgmTfA\mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase04_PickUpPointAndBeyond.sqf";
	mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond = compileFinal preprocessFileLineNumbers "\x\addons\custom\serverside\mgmTfA\mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_PickUpPointAndBeyond.sqf";
	mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase05_DropOffPointAndBeyond = compileFinal preprocessFileLineNumbers "\x\addons\custom\serverside\mgmTfA\mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase05_DropOffPointAndBeyond.sqf";
	mgmTfA_fnc_server_clickNGoTaxi_ServicePhase05_DropOffPointAndBeyond = compileFinal preprocessFileLineNumbers "\x\addons\custom\serverside\mgmTfA\mgmTfA_fnc_server_clickNGoTaxi_ServicePhase05_DropOffPointAndBeyond.sqf";
	mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase06_ToTerminationAndTheEnd = compileFinal preprocessFileLineNumbers "\x\addons\custom\serverside\mgmTfA\mgmTfA_fnc_server_fixedDestinationTaxi_ServicePhase06_ToTerminationAndTheEnd.sqf";
	mgmTfA_fnc_server_clickNGoTaxi_ServicePhase06_ToTerminationAndTheEnd = compileFinal preprocessFileLineNumbers "\x\addons\custom\serverside\mgmTfA\mgmTfA_fnc_server_clickNGoTaxi_ServicePhase06_ToTerminationAndTheEnd.sqf";
	//mgmTfA_fnc_server_publicVariableBroadcastSUInformation = compileFinal preprocessFileLineNumbers "\x\addons\custom\serverside\mgmTfA\mgmTfA_fnc_server_publicVariableBroadcastSUInformation.sqf";
	mgmTfA_fnc_server_PublicVariableBroadcastSUInformationInitialBroadcast = compileFinal preprocessFileLineNumbers "\x\addons\custom\serverside\mgmTfA\mgmTfA_fnc_server_PublicVariableBroadcastSUInformationInitialBroadcast.sqf";
	mgmTfA_fnc_server_PublicVariableBroadcastSUInformationPhaseB = compileFinal preprocessFileLineNumbers "\x\addons\custom\serverside\mgmTfA\mgmTfA_fnc_server_PublicVariableBroadcastSUInformationPhaseB.sqf";
	mgmTfA_fnc_server_returnARandomFirstnameTextString	 = compileFinal preprocessFileLineNumbers "\x\addons\custom\serverside\mgmTfA\mgmTfA_fnc_server_returnARandomFirstnameTextString.sqf";
	mgmTfA_fnc_server_pubBus_doBusProvision			 = compileFinal preprocessFileLineNumbers "\x\addons\custom\serverside\mgmTfA\mgmTfA_fnc_server_pubBus_doBusProvision.sqf";
	// NEW GROUP
	mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_SendResponse_ChargePAYGTickCostRequestActioned = compileFinal preprocessFileLineNumbers "\x\addons\custom\serverside\mgmTfA\mgmTfA_fnc_server_clickNGoTaxi_ServicePhase04_SendResponse_ChargePAYGTickCostRequestActioned.sqf";
	// 3rd Party Functions
	EPOCH_effectCrypto = compileFinal preprocessFileLineNumbers "\x\addons\custom\serverside\mgmTfA\fnc__3rd_party\EPOCH_effectCrypto.sqf";
	EPOCH_server_effectCrypto = compileFinal preprocessFileLineNumbers "\x\addons\custom\serverside\mgmTfA\fnc__3rd_party\EPOCH_server_effectCrypto.sqf";

	/// INITIAL VALUES  FOR GLOBAL VARIABLES - begin
	////Initialize Global Variables of Counter Nature////
	//When a Fixed Destination Taxi request ENTER the workflow at Phase02, the value below will get incremented.		It is used when reporting to RPT LOG & also on, in-game map embedded Status Report.
	mgmTfA_gvdb_PV_fixedDestinationTaxisTotalRequestsReceivedNumber = 0;
	// Broadcast the value to all computers
	publicVariable "mgmTfA_gvdb_PV_fixedDestinationTaxisTotalRequestsReceivedNumber";
	if (mgmTfA_configgv_serverVerbosityLevel>=5) then {diag_log format ["[mgmTfA] [mgmTfA_scr_server_initServer.sqf]          dynamicGV SET mgmTfA_gvdb_PV_fixedDestinationTaxisTotalRequestsReceivedNumber is: (%1)", mgmTfA_gvdb_PV_fixedDestinationTaxisTotalRequestsReceivedNumber];};
	//When a clickNGo Taxi request ENTER the workflow at Phase02, the value below will get incremented.		It is used when reporting to RPT LOG & also on, in-game map embedded Status Report.
	mgmTfA_gvdb_PV_clickNGoTaxisTotalRequestsReceivedNumber = 0;
	// Broadcast the value to all computers
	publicVariable "mgmTfA_gvdb_PV_clickNGoTaxisTotalRequestsReceivedNumber";
	if (mgmTfA_configgv_serverVerbosityLevel>=5) then {diag_log format ["[mgmTfA] [mgmTfA_scr_server_initServer.sqf]          dynamicGV SET mgmTfA_gvdb_PV_clickNGoTaxisTotalRequestsReceivedNumber is: (%1)", mgmTfA_gvdb_PV_clickNGoTaxisTotalRequestsReceivedNumber];};
	//If we cannot fulfil a Fixed Destination Taxi request due to lack of available drivers, the value below will get incremented. It is used when reporting to RPT LOG & also on, in-game map embedded Status Report.
	mgmTfA_gvdb_PV_fixedDestinationTaxisTotalRequestsDroppedNumber = 0;
	// Broadcast the value to all computers
	publicVariable "mgmTfA_gvdb_PV_fixedDestinationTaxisTotalRequestsDroppedNumber";
	if (mgmTfA_configgv_serverVerbosityLevel>=5) then {diag_log format ["[mgmTfA] [mgmTfA_scr_server_initServer.sqf]          dynamicGV SET mgmTfA_gvdb_PV_fixedDestinationTaxisTotalRequestsDroppedNumber is: (%1)", mgmTfA_gvdb_PV_fixedDestinationTaxisTotalRequestsDroppedNumber];};
	//If we cannot serve a Fixed Destination Taxi request due to Requestor being in Blacklist, the value below will get incremented. It is used when reporting to RPT LOG & also on, in-game map embedded Status Report.
	mgmTfA_gvdb_PV_fixedDestinationTaxisTotalRequestsRejectedDueToBlacklistNumber = 0;
	// Broadcast the value to all computers
	publicVariable "mgmTfA_gvdb_PV_fixedDestinationTaxisTotalRequestsRejectedDueToBlacklistNumber";
	if (mgmTfA_configgv_serverVerbosityLevel>=5) then {diag_log format ["[mgmTfA] [mgmTfA_scr_server_initServer.sqf]          dynamicGV SET mgmTfA_gvdb_PV_fixedDestinationTaxisTotalRequestsRejectedDueToBlacklistNumber is: (%1)", mgmTfA_gvdb_PV_fixedDestinationTaxisTotalRequestsRejectedDueToBlacklistNumber];};
	//If we cannot serve a clickNGo Taxi request due to Requestor being in Blacklist, the value below will get incremented. It is used when reporting to RPT LOG & also on, in-game map embedded Status Report.
	mgmTfA_gvdb_PV_clickNGoTaxisTotalRequestsRejectedDueToBlacklistNumber = 0;
	// Broadcast the value to all computers
	publicVariable "mgmTfA_gvdb_PV_clickNGoTaxisTotalRequestsRejectedDueToBlacklistNumber";
	if (mgmTfA_configgv_serverVerbosityLevel>=5) then {diag_log format ["[mgmTfA] [mgmTfA_scr_server_initServer.sqf]          dynamicGV SET mgmTfA_gvdb_PV_clickNGoTaxisTotalRequestsRejectedDueToBlacklistNumber is: (%1)", mgmTfA_gvdb_PV_clickNGoTaxisTotalRequestsRejectedDueToBlacklistNumber];};
	//If we successfully fulfil a Fixed Destination Taxi request, the value below will get incremented. It is used when reporting to RPT LOG & also on, in-game map embedded Status Report.
	mgmTfA_gvdb_PV_fixedDestinationTaxisTotalRequestsSuccessfulNumber=0;
	if (mgmTfA_configgv_serverVerbosityLevel>=5) then {diag_log format ["[mgmTfA] [mgmTfA_scr_server_initServer.sqf]          dynamicGV SET mgmTfA_gvdb_PV_fixedDestinationTaxisTotalRequestsSuccessfulNumber is: (%1)", mgmTfA_gvdb_PV_fixedDestinationTaxisTotalRequestsSuccessfulNumber];};
	//Each driver tracks his mileage and these are combined in this pool. It is used when reporting to RPT LOG & also on, in-game map embedded Status Report. Marketing Manager might use this for advertisement campaigns.
	mgmTfA_dynamicgv_fixedDestinationTaxisTotalDistanceTravelledByTaxisNumber = 0;
	if (mgmTfA_configgv_serverVerbosityLevel>=5) then {diag_log format ["[mgmTfA] [mgmTfA_scr_server_initServer.sqf]          dynamicGV SET mgmTfA_dynamicgv_fixedDestinationTaxisTotalDistanceTravelledByTaxisNumber is: (%1)", mgmTfA_dynamicgv_fixedDestinationTaxisTotalDistanceTravelledByTaxisNumber];};
	//Each driver tracks his mileage and these are combined in this pool. It is used when reporting to RPT LOG & also on, in-game map embedded Status Report. Marketing Manager might use this for advertisement campaigns.
	mgmTfA_dynamicgv_clickNGoTaxisTotalDistanceTravelledByTaxisNumber = 0;
	if (mgmTfA_configgv_serverVerbosityLevel>=5) then {diag_log format ["[mgmTfA] [mgmTfA_scr_server_initServer.sqf]          dynamicGV SET mgmTfA_dynamicgv_clickNGoTaxisTotalDistanceTravelledByTaxisNumber is: (%1)", mgmTfA_dynamicgv_clickNGoTaxisTotalDistanceTravelledByTaxisNumber];};

	//READ-ON-INIT-SERVER Values
	//Settings below are configured in masterConfig file (just like pretty much anything). However all these values below are read only once during server start up. Subsequent scripts that parse masterConfig simply ignore those.
	// Number of Available Drivers
	mgmTfA_gvdb_PV_fixedDestinationTaxisNumberOfCurrentlyAvailableTaxiDriversNumber = mgmTfA_dynamicgv_READ_DURING_SERVER_INIT_fixedDestinationTaxisNumberOfAvailableTaxiDriversOnStartNumber			;
	publicVariable "mgmTfA_gvdb_PV_fixedDestinationTaxisNumberOfCurrentlyAvailableTaxiDriversNumber";
	mgmTfA_gvdb_PV_clickNGoTaxisNumberOfCurrentlyAvailableTaxiDriversNumber = mgmTfA_dynamicgv_READ_DURING_SERVER_INIT_clickNGoTaxisNumberOfAvailableTaxiDriversOnStartNumber					;
	publicVariable "mgmTfA_gvdb_PV_clickNGoTaxisNumberOfCurrentlyAvailableTaxiDriversNumber";

	// Blacklisted PUIDs
	mgmTfA_dynamicgv_fixedDestinationTaxisBlacklistedPlayerPUIDsTextStringArray = mgmTfA_dynamicgv_READ_DURING_SERVER_INIT_fixedDestinationTaxisBlacklistedPlayerPUIDsTextStringArray					;
	mgmTfA_dynamicgv_clickNGoTaxisBlacklistedPlayerPUIDsTextStringArray = mgmTfA_dynamicgv_READ_DURING_SERVER_INIT_clickNGoTaxisBlacklistedPlayerPUIDsTextStringArray						;
	//serverServeRequestor.sqf will read this dynamic global variable to determine whether it needs to create sides and set inter-side relations.
	//serverServeRequestor.sqf will set it to false as soon as it completes its first execution.
	mgmTfA_dynamicgv_sideRelationSetupHasNotBeenDoneYetBool=true;

	//GUSUID		Globally Unique Service Unit ID Number -- we start with zero, each service unit (taxi/bus/air etc.) increment this by one, thus the 1st ever Service Unit on server will start with GUSUID of 1.
	mgmTfA_gvdb_PV_GUSUIDNumber = 0;
	// Broadcast the value to all computers
	publicVariable "mgmTfA_gvdb_PV_GUSUIDNumber";
	if (mgmTfA_configgv_serverVerbosityLevel>=5) then {diag_log format ["[mgmTfA] [mgmTfA_scr_server_initServer.sqf]          globalVariableDBPV SET mgmTfA_gvdb_PV_GUSUIDNumber is: (%1)", mgmTfA_gvdb_PV_GUSUIDNumber];};

	// Total Number of Abnormally Shutdown Service Units (due to Timeout Threshold being Exceeded) -- we start with zero, each abnormal termination will increment this by one
	mgmTfA_gvdb_taxiTotalNumberOfAbnormallyShutdownSUsNumber  = 0;
	if (mgmTfA_configgv_serverVerbosityLevel>=5) then {diag_log format ["[mgmTfA] [mgmTfA_scr_server_initServer.sqf]          globalVariableDBPV SET mgmTfA_gvdb_taxiTotalNumberOfAbnormallyShutdownSUsNumber is: (%1)", mgmTfA_gvdb_taxiTotalNumberOfAbnormallyShutdownSUsNumber];};
										
	//PUIDs and Playernames Array Database:		a single dimensional array containing PUID, followed by playername. Example: 	[["76561198124251001","mgm"],["76999999999999999","John"]]
	//									Each requestor, simply read this and then pushBack their own array of ["PUID","playername"].
	mgmTfA_pvdb_PUIDsAndPlayernamesTextStringArray  = [];
	publicVariable "mgmTfA_pvdb_PUIDsAndPlayernamesTextStringArray";
	if (mgmTfA_configgv_serverVerbosityLevel>=5) then {diag_log format ["[mgmTfA] [mgmTfA_scr_server_initServer.sqf]          EMPTY DATABASE CREATED: (mgmTfA_pvdb_PUIDsAndPlayernamesTextStringArray) has been created without any content."];};
	
	// TotalOmniscience Group PUIDs Database:	a single dimensional array containing PUIDs. See masterConfig for details.
	// (contents come from masterConfig - we just publicVariable broadcast it so that clients can access to it & compare their PUID values after Drop Off point)
	publicVariable "mgmTfA_configgv_totalOmniscienceGroupTextStringArray";
	if (mgmTfA_configgv_serverVerbosityLevel>=5) then {diag_log format ["[mgmTfA] [mgmTfA_scr_server_initServer.sqf]          PublicVariable BROADCASTED:  mgmTfA_configgv_totalOmniscienceGroupTextStringArray is: (%1)", (str mgmTfA_configgv_totalOmniscienceGroupTextStringArray)];};

	// Vehicle type mgmTfA_configgv_fixedDestinationTaxisTaxiVehicleClassnameTextString. See masterConfig for details.
	// (contents come from masterConfig - we just publicVariable broadcast it so that clients can tell whether they are in a Fixed Destination Taxi or not and in turn display the doors locked message only if player is in one of these vehicles)
	publicVariable "mgmTfA_configgv_fixedDestinationTaxisTaxiVehicleClassnameTextString";
	if (mgmTfA_configgv_serverVerbosityLevel>=5) then {diag_log format ["[mgmTfA] [mgmTfA_scr_server_initServer.sqf]          PublicVariable BROADCASTED:  mgmTfA_configgv_fixedDestinationTaxisTaxiVehicleClassnameTextString is: (%1)", mgmTfA_configgv_fixedDestinationTaxisTaxiVehicleClassnameTextString];};
	// Vehicle type mgmTfA_configgv_clickNGoTaxisTaxiVehicleClassnameTextString. See masterConfig for details.
	// (contents come from masterConfig - we just publicVariable broadcast it so that clients can tell whether they are in a Fixed Destination Taxi or not and in turn display the doors locked message only if player is in one of these vehicles)
	publicVariable "mgmTfA_configgv_clickNGoTaxisTaxiVehicleClassnameTextString";
	if (mgmTfA_configgv_serverVerbosityLevel>=5) then {diag_log format ["[mgmTfA] [mgmTfA_scr_server_initServer.sqf]          PublicVariable BROADCASTED:  mgmTfA_configgv_clickNGoTaxisTaxiVehicleClassnameTextString is: (%1)", mgmTfA_configgv_clickNGoTaxisTaxiVehicleClassnameTextString];};

	// Expiry Timeout for map-markers
	// (value come from masterConfig - we just publicVariable broadcast it so that clients can tell how long to countdown before deleting local markers)
	publicVariable "mgmTfA_configgv_mapMarkerExpiryTimeForTerminatedServiceUnitsInSecondsNumber";
	if (mgmTfA_configgv_serverVerbosityLevel>=5) then {diag_log format ["[mgmTfA] [mgmTfA_scr_server_initServer.sqf]          PublicVariable BROADCASTED:	 mgmTfA_configgv_mapMarkerExpiryTimeForTerminatedServiceUnitsInSecondsNumber is: (%1).", (str mgmTfA_configgv_mapMarkerExpiryTimeForTerminatedServiceUnitsInSecondsNumber)];};

	// (value come from masterConfig - we only broadcast it -- see masterConfig for details)
	publicVariable "mgmTfA_configgv_minimumWaitingTimeBetweenFixedDestinationTaxiBookingsInSecondsNumber";
	if (mgmTfA_configgv_serverVerbosityLevel>=5) then {diag_log format ["[mgmTfA] [mgmTfA_scr_server_initServer.sqf]          PublicVariable BROADCASTED:	mgmTfA_configgv_minimumWaitingTimeBetweenFixedDestinationTaxiBookingsInSecondsNumber is: (%1).", (str mgmTfA_configgv_minimumWaitingTimeBetweenFixedDestinationTaxiBookingsInSecondsNumber)];};

	// prepare the initial STATUS REPORT one-line message
	mgmTfA_dynamicgv_statusReportMessageTextString = 	"[mgmTfA] [STATUS REPORT]          Please wait - initialization sequence in progress...";
	publicVariable "mgmTfA_dynamicgv_statusReportMessageTextString";
	if (mgmTfA_configgv_serverVerbosityLevel>=5) then {diag_log format ["[mgmTfA] [mgmTfA_scr_server_initServer.sqf]          PublicVariable BROADCASTED:	mgmTfA_dynamicgv_statusReportMessageTextString is: (%1).", mgmTfA_dynamicgv_statusReportMessageTextString];};

	// (value come from masterConfig - we only broadcast it -- see masterConfig for details)
	publicVariable "mgmTfA_configgv_makeAllMarkersPublicIWantZeroPrivacyAndSecurityBool";
	if (mgmTfA_configgv_serverVerbosityLevel>=5) then {diag_log format ["[mgmTfA] [mgmTfA_scr_server_initServer.sqf]          PublicVariable BROADCASTED:	mgmTfA_configgv_makeAllMarkersPublicIWantZeroPrivacyAndSecurityBool is: (%1).", mgmTfA_configgv_makeAllMarkersPublicIWantZeroPrivacyAndSecurityBool];};

	//The Last Served Playername -- just to report in STATUS REPORT
	mgmTfA_dynamicgv_fixedDestinationTaxisTheLastServedPlayerNameTextString= "NOONE";
	if (mgmTfA_configgv_serverVerbosityLevel>=5) then {diag_log format ["[mgmTfA] [mgmTfA_scr_server_initServer.sqf]          dynamicGV SET mgmTfA_dynamicgv_fixedDestinationTaxisTheLastServedPlayerNameTextString is: (%1)", mgmTfA_dynamicgv_fixedDestinationTaxisTheLastServedPlayerNameTextString];};

	//The Last Served Playername -- just to report in STATUS REPORT
	mgmTfA_dynamicgv_clickNGoTaxisTheLastServedPlayerNameTextString= "NOONE";
	if (mgmTfA_configgv_serverVerbosityLevel>=5) then {diag_log format ["[mgmTfA] [mgmTfA_scr_server_initServer.sqf]          dynamicGV SET mgmTfA_dynamicgv_clickNGoTaxisTheLastServedPlayerNameTextString is: (%1)", mgmTfA_dynamicgv_clickNGoTaxisTheLastServedPlayerNameTextString];};
	//If we successfully fulfil a request, the value below will get incremented. It is used when reporting to RPT LOG & also on, in-game map embedded Status Report.
	mgmTfA_dynamicgv_taxiCorpTaxiModuleTotalRequestsSuccessfulNumber=0;
	if (mgmTfA_configgv_serverVerbosityLevel>=5) then {diag_log format ["[mgmTfA] [mgmTfA_scr_server_initServer.sqf]          dynamicGV SET mgmTfA_dynamicgv_taxiCorpTaxiModuleTotalRequestsSuccessfulNumber is: (%1)", mgmTfA_dynamicgv_taxiCorpTaxiModuleTotalRequestsSuccessfulNumber];};


	/// clickNGo specific stuff Here
	//If we cannot fulfil a clickNGo Taxi request due to lack of driver, the value below will get incremented. It is used when reporting to RPT LOG & also on, in-game map embedded Status Report.
	mgmTfA_dynamicgv_taxiCorpclickNGoTaxiModuleTotalRequestsDroppedNumber = 0;
	if (mgmTfA_configgv_serverVerbosityLevel>=5) then {diag_log format ["[mgmTfA] [mgmTfA_scr_server_initServer.sqf]          dynamicGV COUNTER SET mgmTfA_dynamicgv_taxiCorpclickNGoTaxiModuleTotalRequestsDroppedNumber is: (%1)", mgmTfA_dynamicgv_taxiCorpclickNGoTaxiModuleTotalRequestsDroppedNumber];};
	
	//The Last Served Playername -- just to report in STATUS REPORT
	mgmTfA_dynamicgv_taxiCorpclickNGoTaxiModuleTheLastServedPlayerNameTextString = "NOONE";
	if (mgmTfA_configgv_serverVerbosityLevel>=5) then {diag_log format ["[mgmTfA] [mgmTfA_scr_server_initServer.sqf]          dynamicGV SET mgmTfA_dynamicgv_taxiCorpclickNGoTaxiModuleTheLastServedPlayerNameTextString is: (%1)", mgmTfA_dynamicgv_taxiCorpclickNGoTaxiModuleTheLastServedPlayerNameTextString];};
	/// clickNGo specific stuff Here

	
	
	/// Route specific stuff Here
	//
	// On each client computer (bus) routes are drawn on the map. 
	//
	// A route is a series of pre-determined points in 3D world, represented on the map	e.g.:		1, "The Coastal Line" = [[13089.9,14906.1,0], [13107.4,14886.2,0], [13128.7,14858.5,0], [13151.1,14832.9,0]];
	// For performance reasons these are passed to clients in MPmission files.
	// Client however, before drawing each route check the route status.	mgmTfA_dynamicgv_route1RouteIsEnabledBool = true|false
	// If a route is enabled, client then will draw it on local map.
	//
	// To draw the 'lines' between predetermined points, local mapMarkers of RECT type is used. 
	// Each marker is named as 'lineMarker' object and get a unique name based on a Globally Unique ID Number that is initialized as 0 during clientInit and is automatically incremented each time a new lineMarker is created.
	// Thus, a route (e.g.: the Coastal Line) will be a series of lineMarkers which is known and stored in a run-time dynamic global variable on client computer		e.g.:		1=[1,2,3,4,5,6,7,8,9,10,11,12,13];		1=route ID (name is not relevant here)	1 to 13 are the lineMarkerIDs, thus lineMarker1,lineMarker2...,lineMarker13 are the building blocks for route1
	//
	// This system allow, for example taking a route temporarily offline, server can simply set mgmTfA_dynamicgv_route1RouteIsEnabledBool=false; and publicVariable broadcast it, in turn,
	// during the next regular check, on each client computer, mgmTfA_fnc_client_routeJanitor function will detect the service status change, and action depending on configuration values:
	// e.g.: possibly mark the line with RED color and at the service status box on the very top left corner of the map put service status text as THIS ROUTE IS CURRENTLY DISABLED.
	//
	// TODO: a client side function will take care of periodic refreshing of all routes on the map -> mgmTfA_fnc_client_routeJanitor.sqf
	//
	// broadcast whether Public Bus System is enabled on this server
	mgmTfA_PV_serviceModePublicBusSystemEnabled  = mgmTfA_configgv_serviceModePublicBusSystemEnabled;
	publicVariable "mgmTfA_PV_serviceModePublicBusSystemEnabled";
	if (mgmTfA_configgv_serverVerbosityLevel>=5) then {diag_log format ["[mgmTfA] [mgmTfA_scr_server_initServer.sqf]          Public Bus SERVICE MODE Setting broadcasted.		mgmTfA_PV_serviceModePublicBusSystemEnabled is: (%1)", (str mgmTfA_PV_serviceModePublicBusSystemEnabled)];};
	// broadcast other settings only if Public Bus System is enabled on this server
	if (mgmTfA_configgv_serviceModePublicBusSystemEnabled) then {
		mgmTfA_PV_publicBusSystemAnnouncementIDNumber  = mgmTfA_dynamicgv_publicBusSystemAnnouncementIDNumber;
		publicVariable "mgmTfA_PV_publicBusSystemAnnouncementIDNumber";
		if (mgmTfA_configgv_serverVerbosityLevel>=5) then {diag_log format ["[mgmTfA] [mgmTfA_scr_server_initServer.sqf]          Public Bus ROUTE ANNOUNCEMENT ID  broadcasted.			mgmTfA_PV_publicBusSystemAnnouncementIDNumber is: (%1)", (str mgmTfA_PV_publicBusSystemAnnouncementIDNumber)];};
		mgmTfA_PV_routeAllRoutesSettingsTextStringArray  = mgmTfA_dynamicgv_routeAllRoutesSettingsTextStringArray;
		publicVariable "mgmTfA_PV_routeAllRoutesSettingsTextStringArray";
		if (mgmTfA_configgv_serverVerbosityLevel>=5) then {diag_log format ["[mgmTfA] [mgmTfA_scr_server_initServer.sqf]          Public Bus ROUTE SETTINGS broadcasted.			mgmTfA_PV_routeAllRoutesSettingsTextStringArray is: (%1)", (str mgmTfA_PV_routeAllRoutesSettingsTextStringArray)];};
	};
	/// Route specific stuff Here
	/// begin:		INITIAL VALUES  FOR GLOBAL VARIABLES
	//// CATP Configuration
	// Publish detection range to activate "NEAR CATP" status
	publicVariable "mgmTfA_configgv_catpObjectDetectionRangeInMeters";
	// Publish detection object that activates "NEAR A CATP" status
	publicVariable "mgmTfA_configgv_catpObject";
	// Publish TfA version info
	publicVariable "mgmTfA_configgv_TfAScriptVersionTextString";
	publicVariable "mgmTfA_configgv_TfAScriptVersionRevisionSumValueNumber";
	// Publish some of the masterConfig values that clients need to know
	publicVariable "mgmTfA_configgv_clientVerbosityLevel";
	publicVariable "mgmTfA_configgv_taxiFixedDestination01ActionMenuTextString";
	publicVariable "mgmTfA_configgv_taxiFixedDestination02ActionMenuTextString";
	publicVariable "mgmTfA_configgv_taxiFixedDestination03ActionMenuTextString";
	publicVariable "mgmTfA_configgv_catpCheckFrequencySecondsNumber";
	//DUPLICATE! already published above. todo: clean this up.
	//publicVariable "mgmTfA_configgv_minimumWaitingTimeBetweenFixedDestinationTaxiBookingsInSecondsNumber";
	publicVariable "mgmTfA_configgv_FixedDestinationTaxiBookingFirstTimersCanBookWithoutWaitingBool";
	publicVariable "mgmTfA_configgv_minimumWaitingTimeBetweenclickNGoTaxiBookingsInSecondsNumber";
	publicVariable "mgmTfA_configgv_clickNGoTaxiBookingFirstTimersCanBookWithoutWaitingBool";
	publicVariable "mgmTfA_configgv_taxiFixedDestination01LocationNameTextString";
	publicVariable "mgmTfA_configgv_taxiFixedDestination02LocationNameTextString";
	publicVariable "mgmTfA_configgv_taxiFixedDestination03LocationNameTextString";
	publicVariable "mgmTfA_configgv_currentFixedDestinationTaxiActionInProgressIs00TextString";
	publicVariable "mgmTfA_configgv_currentFixedDestinationTaxiActionInProgressIs01TextString";
	publicVariable "mgmTfA_configgv_currentFixedDestinationTaxiActionInProgressIs02TextString";
	publicVariable "mgmTfA_configgv_currentFixedDestinationTaxiActionInProgressIs03TextString";
	publicVariable "mgmTfA_configgv_currentFixedDestinationTaxiActionInProgressIs04TextString";
	publicVariable "mgmTfA_configgv_currentFixedDestinationTaxiActionInProgressIs05TextString";
	publicVariable "mgmTfA_configgv_currentFixedDestinationTaxiActionInProgressIs06TextString";
	publicVariable "mgmTfA_configgv_currentFixedDestinationTaxiActionInProgressIs07TextString";
	publicVariable "mgmTfA_configgv_currentFixedDestinationTaxiActionInProgressIs08TextString";
	publicVariable "mgmTfA_configgv_clickNGoCallATaxiHotkeyDIKCodeNumber";
	publicVariable "mgmTfA_configgv_clickNGoSetCourseHotkeyDIKCodeNumber";
	publicVariable "mgmTfA_configgv_clickNGoSetCourseHotkeyTextRepresentationTextString";
	publicVariable "mgmTfA_configgv_clickNGoTaxiBookingHotkeyCooldownDurationInSecondsNumber";
	publicVariable "mgmTfA_configgv_clickNGoJanitorSleepDurationInSecondsNumber";
	publicVariable "mgmTfA_configgv_clickNGoJanitorInitialRandomSleepDurationMinimumBaseInSecondsNumber";
	publicVariable "mgmTfA_configgv_clickNGoJanitorInitialRandomSleepDurationMinimumAdditionInSecondsNumber";
	publicVariable "mgmTfA_configgv_taxiFixedDestination01LocationPositionArray";
	publicVariable "mgmTfA_configgv_taxiFixedDestination02LocationPositionArray";
	publicVariable "mgmTfA_configgv_taxiFixedDestination03LocationPositionArray";
	publicVariable "mgmTfA_configgv_fixedDestinationTaxisNonRefundableStandardBookingFeeCostInCryptoNumber";
	publicVariable "mgmTfA_configgv_fixedDestinationTaxisServiceFeeBaseFeeInCryptoNumber";
	publicVariable "mgmTfA_configgv_fixedDestinationTaxisServiceFeeCostForTravellingAdditional100MetresInCryptoNumber";
	publicVariable "mgmTfA_configgv_clickNGoTaxisNonRefundableBookingFeeCostInCryptoNumber";
	publicVariable "mgmTfA_configgv_clickNGoTaxisPrepaidAbsoluteMinimumJourneyTimeInSeconds";
	publicVariable "mgmTfA_configgv_clickNGoTaxisAbsoluteMinimumJourneyFeeInCryptoNumber";
	publicVariable "mgmTfA_configgv_clickNGoTaxisTickStepTimeInSecondsNumber";
	publicVariable "mgmTfA_configgv_clickNGoTaxisTickCostInCryptoNumber";
	publicVariable "mgmTfA_configgv_clickNGoTaxisTickCostInCryptoNegativeNumber";
	publicVariable "mgmTfA_configgv_clickNGoTaxisDisplayTickHintMessagesBool";
	publicVariable "mgmTfA_configgv_fixedDestinationTaxisClientSideScannerSleepDurationBetweenScansInSecondsNumber";
	publicVariable "mgmTfA_configgv_clickNGoTaxisClientSideScannerSleepDurationBetweenScansInSecondsNumber";
	publicVariable "mgmTfA_configgv_fixedDestinationTaxisClientSideScannerScanRadiusInMetresNumber";
	publicVariable "mgmTfA_configgv_clickNGoTaxisClientSideScannerScanRadiusInMetresNumber";
	publicVariable "mgmTfA_dynamicgv_clickNGoTaxiDisplayInstructionsOnGetInEnabledBool";
	publicVariable "mgmTfA_dynamicgv_clickNGoTaxiDisplayInstructionsOnGetInDisplayMethodNumber";
	publicVariable "mgmTfA_dynamicgv_clickNGoTaxiReDisplayInstructionsOnGetInTimeThresholdInSecondsNumber";
	publicVariable "mgmTfA_configgv_catpObject";
	publicVariable "mgmTfA_configgv_catp01DirectionDegreesNumber";
	publicVariable "mgmTfA_configgv_thresholdNumberOfFailedPAYGTransactionsToPermitBeforeInitiatingPAYGserviceAbruptTerminationNumber";
	publicVariable "mgmTfA_configgv_monitoringAgentMissedPurchasingPowerCheckAndPAYGTickChargesAgentSleepTime";
	publicVariable "mgmTfA_configgv_clickNGoTaxisDisplayTickChargeHintMessageBool";
	publicVariable "mgmTfA_configgv_clickNGoTaxisDisplayTickChargeSystemChatMessageBool";
	publicVariable "mgmTfA_configgv_clickNGoTaxisDisplayTickChargeCutTextMessageBool";
	publicVariable "mgmTfA_configgv_clickNGoTaxisDriverWillKeepRemindingThatTheInitialFeeMustBePaidBool";
	publicVariable "mgmTfA_configgv_GUIOpenMapCommandMonitoringEnabledBool";
	publicVariable "mgmTfA_configgv_clickNGoOpenMapCommandMonitoringThisMustBeTheSignalThresholdMapOpenedNTimesNumber";
	publicVariable "mgmTfA_configgv_clickNGoOpenMapCommandMonitoringThisMustBeTheSignalThresholdMapOpenedNTimesInSecsNumber";
	publicVariable "mgmTfA_configgv_clickNGoOpenMapCommandMonitoringThisMustBeTheSignalTurnThePage";
	publicVariable "mgmTfA_configgv_serverAndClientDebugVerbosityLevel";
	// TODO: why the one below needs to be PV'd? check and remove if unnecessarily PV'd!
	publicVariable "mgmTfA_configgv_expiryTimeOutThresholdpubBusSUSpawnPhaseInSecondsNumber";
	publicVariable "mgmTfA_configgv_fixedDestinationTaxisSpawnDistanceRadiusInMetresNumber";
	publicVariable "mgmTfA_configgv_fixedDestinationTaxisSpawnDistanceRadiusMinDistanceInMetresNumber";
	publicVariable "mgmTfA_configgv_clickNGoTaxisSpawnDistanceRadiusInMetresNumber";
	publicVariable "mgmTfA_configgv_clickNGoTaxisSpawnDistanceRadiusMinDistanceInMetresNumber";
	publicVariable "mgmTfA_configgv_fixedDestinationTaxisTerminationDistanceRadiusInMetresNumber";
	publicVariable "mgmTfA_configgv_fixedDestinationTaxisTerminationDistanceRadiusMinDistanceInMetresNumber";
 	publicVariable "mgmTfA_configgv_clickNGoTaxisTerminationDistanceRadiusInMetresNumber";
	publicVariable "mgmTfA_configgv_clickNGoTaxisTerminationDistanceRadiusMinDistanceInMetresNumber";
	/// end:		INITIAL VALUES  FOR GLOBAL VARIABLES

	/// SEND SIGNAL: SERVER-SIDE INITIALIZATION COMPLETE /// 
	diag_log format ["[mgmTfA] [mgmTfA_scr_server_initServer.sqf]          VERSION INFO: Transport for Arma %1     [VerRevSumNum: (%2)]", mgmTfA_configgv_TfAScriptVersionTextString, mgmTfA_configgv_TfAScriptVersionRevisionSumValueNumber];
	// We have completed the initialization...
	mgmTfA_Server_Init=1;
	publicVariable "mgmTfA_Server_Init";
	if (mgmTfA_configgv_serverVerbosityLevel>=2) then {diag_log format ["[mgmTfA] [mgmTfA_scr_server_initServer.sqf]  [TV2]          Reached checkpoint: Finished processing script. Exiting now."];};
};
if (mgmTfA_configgv_serverVerbosityLevel>=2) then {diag_log format ["[mgmTfA][mgmTfA_scr_server_initServer.sqf] END reading file."];};
// EOF