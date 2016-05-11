//H
//HH ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_c_CO_scr_init.sqf
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
	mgmTfA_c_FD_fnc_returnTrueIfThereIsACATPNearby = compile preprocessFileLineNumbers "custom\mgmTfA\mgmTfA_c_FD_fnc_returnTrueIfThereIsACATPNearby.sqf";
	mgmTfA_c_FD_fnc_sendBookingRequestForFDTaxi = compile preprocessFileLineNumbers "custom\mgmTfA\mgmTfA_c_FD_fnc_sendBookingRequestForFDTaxi.sqf";
	mgmTfA_c_CO_fnc_doLocalMarkerWork = compile preprocessFileLineNumbers "custom\mgmTfA\mgmTfA_c_CO_fnc_doLocalMarkerWork.sqf";
	mgmTfA_c_TA_scr_setDestination = compile preprocessFileLineNumbers "custom\mgmTfA\mgmTfA_c_TA_scr_setDestination.sqf";
	mgmTfA_c_TA_fnc_doLocalJanitorWork = compile preprocessFileLineNumbers "custom\mgmTfA\mgmTfA_c_TA_fnc_doLocalJanitorWork.sqf";
	mgmTfA_c_TA_fncTaxiDisplayInstructions = compile preprocessFileLineNumbers "custom\mgmTfA\mgmTfA_c_TA_fncTaxiDisplayInstructions.sqf";
	mgmTfA_c_TA_fnc_purchasingPowerCheckAndPAYGChargeForTimeTicks = compile preprocessFileLineNumbers "custom\mgmTfA\mgmTfA_c_TA_fnc_purchasingPowerCheckAndPAYGChargeForTimeTicks.sqf";
	//NOT USED ANY MORE -- DELAYED DELETE THIS					mgmTfA_c_TA_fncContinuouslyRequestPayment = compile preprocessFileLineNumbers "custom\mgmTfA\mgmTfA_c_TA_fncContinuouslyRequestPayment.sqf";
	mgmTfA_c_CO_fnc_launchTfAGUIViaMapRapidToggle = compile preprocessFileLineNumbers "custom\mgmTfA\mgmTfA_c_CO_fnc_launchTfAGUIViaMapRapidToggle.sqf";
	// this below MUST be under the one above or will be renamed prematurely!
	mgmTfA_c_TA_fncRequestTaxi = compile preprocessFileLineNumbers "custom\mgmTfA\mgmTfA_c_TA_fncRequestTaxi.sqf";
	mgmTfA_c_TA_fnc_keepRequesting1stMileFeePayment = compile preprocessFileLineNumbers "custom\mgmTfA\mgmTfA_c_TA_fnc_keepRequesting1stMileFeePayment.sqf";
	mgmTfA_c_FD_fnc_keepRequestingServiceFeePayment = compile preprocessFileLineNumbers "custom\mgmTfA\mgmTfA_c_FD_fnc_keepRequestingServiceFeePayment.sqf";

	//// Reset global variables of counter nature
	mgmTfA_dynamicgv_lastFixedDestinationTaxiBookingRecordKeeperThisIsTheFirstTimeBool = true;
	mgmTfA_dynamicgv_lastFixedDestinationTaxiBookingPlacedAtTimestampInSecondsNumber = (time);
	mgmTfA_dynamicgv_lastTATaxiBookingRecordKeeperThisIsTheFirstTimeBool = true;
	mgmTfA_dynamicgv_lastTATaxiBookingPlacedAtTimestampInSecondsNumber = (time);
	mgmTfA_dynamicgv_taxiAnywhereTaxiFirstGetInHasOccurred = false;
	mgmTfA_dynamicgv_taxiAnywhereTaxiInstructionsAutoDisplayOnGetInHappenedAtTimeInSecondsNumber = -1;
	mgmTfA_PurchasingPowerCheckAndPAYGChargeForTimeTicksFunctionCurrentlyRunningBool = false;
	mgmTfA_dynamicgv_mapOpenedAtTimestampsInSecondTextStringArray = [];
	mgmTfA_dynamicgv_taxiAnywhereRequestTaxiViaTripleMapOpenViaTripleMapOpenFunctionRunningBool = false;

	// Since we are just spawning now, we cannot have any fixedDestinationTaxis checked
	mgmTfA_dynamicgv_mapOpenedAtTimestampsInSecondTextStringArray = [0,0,0];
	// TaxiAnywhere (a.k.a.: clickNGo does not need it anymore due to simplified payment process) but we still need this for the fixeddestination!!
	mgmTfA_dynamicgv_listOfFixedDestinationTaxisThatWeHaveAddedActionMenuOptionTextStringArray = [];

	// Send our PUID & ProfileName to the "server-side global PUID and ProfileNames Database"
	myPUIDAndProfileNameTextStringArray = [(getPlayerUID player), (profileName)];
	mgmTfA_pvdb_PUIDsAndPlayernamesTextStringArray pushBack myPUIDAndProfileNameTextStringArray;
	publicVariable "mgmTfA_pvdb_PUIDsAndPlayernamesTextStringArray";

	// spawn the clickNGo janitor function
	_null =	[] spawn mgmTfA_c_TA_fnc_doLocalJanitorWork;

	////Register Client-side Event Handlers
	[] execVM "custom\mgmTfA\mgmTfA_c_CO_scr_initRegisterClientEventHandlers.sqf";
	if (isNil("mgmTfA_Client_Init")) then {
		mgmTfA_Client_Init=1;
		diag_log format ["[mgmTfA] [mgmTfA_scr_clientInit.sqf]          VERSION INFO: Transport for Arma (%1).     [VerRevSumNum: (%2)]	mgmTfA_Client_Init is: (%3)", mgmTfA_configgv_TfAScriptVersionTextString, mgmTfA_configgv_TfAScriptVersionRevisionSumValueNumber, (str mgmTfA_Client_Init)];
	};
};
// EOF