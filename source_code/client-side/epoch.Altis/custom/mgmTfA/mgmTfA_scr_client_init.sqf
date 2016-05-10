//H
//HH ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_scr_client_init.sqf
//H $PURPOSE$	:	This client-side script contains the tasks that need to be executed on player initialization.
//HH ~~
//H
//HH
//HH	The server-side init file create the following value(s) this function rely on:
//HH		mgmTfA_pvdb_PUIDsAndPlayernamesTextStringArray
//HH		mgmTfA_configgv_TfAScriptVersionTextString
//HH		mgmTfA_configgv_TfAScriptVersionRevisionSumValueNumber
//HH
//HH	This script will pushBack to the following global variables:
//HH		mgmTfA_pvdb_PUIDsAndPlayernamesTextStringArray
//HH
waitUntil {mgmTfA_Server_Init==1};
_thisFileVerbosityLevelNumber = mgmTfA_configgv_clientVerbosityLevel;
if (!isServer) then {
	private	["_null"];

	////////////////////////////////////////
	/// COMPILE GLOBAL FUNCTIONS
	mgmTfA_fnc_client_returnTrueIfThereIsACatpNearby = compile preprocessFileLineNumbers "custom\mgmTfA\mgmTfA_fnc_client_returnTrueIfThereIsACatpNearby.sqf";
	mgmTfA_fnc_client_sendBookingRequestFixedDestinationTaxi = compile preprocessFileLineNumbers "custom\mgmTfA\mgmTfA_fnc_client_sendBookingRequestFixedDestinationTaxi.sqf";
	mgmTfA_fnc_client_doLocalMarkerWork = compile preprocessFileLineNumbers "custom\mgmTfA\mgmTfA_fnc_client_doLocalMarkerWork.sqf";
	mgmTfA_fnc_client_clickNGoSetCourse = compile preprocessFileLineNumbers "custom\mgmTfA\mgmTfA_fnc_client_clickNGoSetCourse.sqf";
	mgmTfA_fnc_client_doLocalJanitorWorkForclickNGo = compile preprocessFileLineNumbers "custom\mgmTfA\mgmTfA_fnc_client_doLocalJanitorWorkForclickNGo.sqf";
	mgmTfA_fnc_client_doScanVicinityForFixedDestinationTaxiVehicles = compile preprocessFileLineNumbers "custom\mgmTfA\mgmTfA_fnc_client_doScanVicinityForFixedDestinationTaxiVehicles.sqf";
	mgmTfA_fnc_client_doScanVicinityForclickNGoTaxiVehicles = compile preprocessFileLineNumbers "custom\mgmTfA\mgmTfA_fnc_client_doScanVicinityForclickNGoTaxiVehicles.sqf";
	mgmTfA_fnc_client_doProcessFixedDestinationTaxiAddActionWork = compile preprocessFileLineNumbers "custom\mgmTfA\mgmTfA_fnc_client_doProcessFixedDestinationTaxiAddActionWork.sqf";
	mgmTfA_fnc_client_doProcessclickNGoTaxiAddActionWork = compile preprocessFileLineNumbers "custom\mgmTfA\mgmTfA_fnc_client_doProcessclickNGoTaxiAddActionWork.sqf";
	mgmTfA_fnc_client_clickNGoTaxiDisplayInstructions = compile preprocessFileLineNumbers "custom\mgmTfA\mgmTfA_fnc_client_clickNGoTaxiDisplayInstructions.sqf";
	mgmTfA_fnc_client_purchasingPowerCheckAndPAYGChargeForTimeTicks = compile preprocessFileLineNumbers "custom\mgmTfA\mgmTfA_fnc_client_purchasingPowerCheckAndPAYGChargeForTimeTicks.sqf";
	mgmTfA_fnc_client_clickNGoContinuouslyRequestPayment = compile preprocessFileLineNumbers "custom\mgmTfA\mgmTfA_fnc_client_clickNGoContinuouslyRequestPayment.sqf";
	mgmTfA_fnc_client_launchTfAGUIViaRapidMapOpen = compile preprocessFileLineNumbers "custom\mgmTfA\mgmTfA_fnc_client_launchTfAGUIViaRapidMapOpen.sqf";
	// this below MUST be under the one above or will be renamed prematurely!
	mgmTfA_fnc_client_clickNGoRequestTaxi = compile preprocessFileLineNumbers "custom\mgmTfA\mgmTfA_fnc_client_clickNGoRequestTaxi.sqf";
	mgmTfA_fnc_client_TA_keepRequesting1stMileFeePayment = compile preprocessFileLineNumbers "custom\mgmTfA\mgmTfA_fnc_client_TA_keepRequesting1stMileFeePayment.sqf";

	//// Reset global variables of counter nature
	mgmTfA_dynamicgv_lastFixedDestinationTaxiBookingRecordKeeperThisIsTheFirstTimeBool = true;
	mgmTfA_dynamicgv_lastFixedDestinationTaxiBookingPlacedAtTimestampInSecondsNumber = (time);
	mgmTfA_dynamicgv_lastclickNGoTaxiBookingRecordKeeperThisIsTheFirstTimeBool = true;
	mgmTfA_dynamicgv_lastclickNGoTaxiBookingPlacedAtTimestampInSecondsNumber = (time);
	mgmTfA_dynamicgv_clickNGoTaxiFirstGetInHasOccurred = false;
	mgmTfA_dynamicgv_clickNGoTaxiInstructionsAutoDisplayOnGetInHappenedAtTimeInSecondsNumber = -1;
	mgmTfA_PurchasingPowerCheckAndPAYGChargeForTimeTicksFunctionCurrentlyRunningBool = false;
	mgmTfA_dynamicgv_mapOpenedAtTimestampsInSecondTextStringArray = [];
	mgmTfA_dynamicgv_clickNGoRequestTaxiViaTripleMapOpenViaTripleMapOpenFunctionRunningBool = false;

	// Since we are just spawning now, we cannot have any fixedDestinationTaxis checked
	mgmTfA_dynamicgv_mapOpenedAtTimestampsInSecondTextStringArray = [0,0,0];
	// TaxiAnywhere (a.k.a.: clickNGo does not need it anymore due to simplified payment process) but we still need this for the fixeddestination!!
	mgmTfA_dynamicgv_listOfFixedDestinationTaxisThatWeHaveAddedActionMenuOptionTextStringArray = [];

	// Send our PUID & ProfileName to the "server-side global PUID and ProfileNames Database"
	myPUIDAndProfileNameTextStringArray = [(getPlayerUID player), (profileName)];
	mgmTfA_pvdb_PUIDsAndPlayernamesTextStringArray pushBack myPUIDAndProfileNameTextStringArray;
	publicVariable "mgmTfA_pvdb_PUIDsAndPlayernamesTextStringArray";

	// spawn the clickNGo janitor function
	_null =	[] spawn mgmTfA_fnc_client_doLocalJanitorWorkForclickNGo;
	// spawn the fixedDestination VicinityTaxiScanner function
	_null =	[] spawn mgmTfA_fnc_client_doScanVicinityForFixedDestinationTaxiVehicles;
	// spawn the clickNGo VicinityTaxiScanner function
	_null =	[] spawn mgmTfA_fnc_client_doScanVicinityForclickNGoTaxiVehicles;
	
	////Register Client-side Event Handlers
	[] execVM "custom\mgmTfA\mgmTfA_scr_client_initRegisterClientEventHandlers.sqf";
	if (isNil("mgmTfA_Client_Init")) then {
		mgmTfA_Client_Init=1;
		diag_log format ["[mgmTfA] [mgmTfA_scr_clientInit.sqf]          VERSION INFO: Transport for Arma (%1).     [VerRevSumNum: (%2)]	mgmTfA_Client_Init is: (%3)", mgmTfA_configgv_TfAScriptVersionTextString, mgmTfA_configgv_TfAScriptVersionRevisionSumValueNumber, (str mgmTfA_Client_Init)];
	};
};
// EOF