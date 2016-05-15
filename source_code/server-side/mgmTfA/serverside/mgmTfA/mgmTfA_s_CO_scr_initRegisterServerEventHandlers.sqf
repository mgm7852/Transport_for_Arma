//H
//H ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf
//H $PURPOSE$	:	This server-side script registers Event Handlers on server startup.
//H ~~
//H
if (!isServer) exitWith {}; if (isNil("mgmTfA_Server_Init")) then {mgmTfA_Server_Init=0;}; waitUntil {mgmTfA_Server_Init==1}; private ["_thisFileVerbosityLevelNumber"]; _thisFileVerbosityLevelNumber = mgmTfA_configgv_serverVerbosityLevel;

"mgmTfA_gv_pvs_req_fixedDestinationTaxiToMyPositionPleaseConfirmPacket" addPublicVariableEventHandler {
	private	[
			"_fixedDestinationRequestorClientIDNumber",
			"_fixedDestinationRequestorPosition3DArray",
			"_fixedDestinationRequestedTaxiFixedDestinationIDNumber",
			"_fixedDestinationRequestedDestinationNameTextString",
			"_fixedDestinationRequestorPlayerUIDTextString",
			"_fixedDestinationRequestorProfileNameTextString",
			"_fixedDestinationRequestorIsInBlacklist"
			];
	// STAGE IN WORKFLOW:		Parse Arguments & Prepare Local Variables
	// Number - ID of the client where the request originates		this is the clientComputerID
	_fixedDestinationRequestorClientIDNumber = (owner	(_this select 1 select 0));
	_fixedDestinationRequestorPosition3DArray = (_this select 1 select 1);
	// Shared configuration file has a list of "Available Taxi Destinations" && this list is presented to the player in mgmTfA_scr_clientPresentCATPActionMenu.sqf
	_fixedDestinationRequestedTaxiFixedDestinationIDNumber = (_this select 1 select 2);
	//Prepare the name of the  requested destination in Text
	switch _fixedDestinationRequestedTaxiFixedDestinationIDNumber do {
		case 1:	{ _fixedDestinationRequestedDestinationNameTextString = mgmTfA_configgv_taxiFixedDestination01LocationNameTextString };
		case 2:	{ _fixedDestinationRequestedDestinationNameTextString = mgmTfA_configgv_taxiFixedDestination02LocationNameTextString };
		case 3:	{ _fixedDestinationRequestedDestinationNameTextString = mgmTfA_configgv_taxiFixedDestination03LocationNameTextString };
		case 0;
		default	{ _fixedDestinationRequestedDestinationNameTextString = "UNKNOWN-DEFAULT-DESTINATION" };
	};
	_fixedDestinationRequestorPlayerUIDTextString = (_this select 1 select 3);
	_fixedDestinationRequestorProfileNameTextString = "CANTFINDAMATCHINGNAME";
	// TODO:		MOVE THIS TO A SEPARATE FUNCTION FILE 		MOVE THIS TO A SEPARATE FUNCTION FILE 		MOVE THIS TO A SEPARATE FUNCTION FILE 		MOVE THIS TO A SEPARATE FUNCTION FILE 
	// STAGE IN WORKFLOW:		Determine Requestor's profileName
	// NOTE: Clients, in client-side init stage, pushBack their PUID & profileNames to a PV =>	mgmTfA_pvdb_PUIDsAndPlayernamesTextStringArray	<= we will use this array to find matching profileName
	private	[
			"_PUIDsAndPlayernamesTextStringArrayCountNumber"
			];
	_PUIDsAndPlayernamesTextStringArrayCountNumber 	 = count	(mgmTfA_pvdb_PUIDsAndPlayernamesTextStringArray);
		if (mgmTfA_configgv_serverVerbosityLevel>=3) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]  [TV3] _PUIDsAndPlayernamesTextStringArrayCountNumber is: (%1).", _PUIDsAndPlayernamesTextStringArrayCountNumber];};//dbg
	// Now that we know the size, if there's anything at all in the array, let's traverse it
	if (_PUIDsAndPlayernamesTextStringArrayCountNumber >0) then {
	scopeName "_PUIDsAndPlayernamesTextStringArrayCountNumberGreaterThanZeroScope";

		// We will traverse each array element
		// We will compare the 0th element [playerUID] with the playerUID we have been provided
		// If PUID  matches, we will return the profileName
		{
			if (mgmTfA_configgv_serverVerbosityLevel>=4) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]  [TV3]          Traversing the mgmTfA_pvdb_PUIDsAndPlayernamesTextStringArray. Current index is: (%1)     Content PUID/name is: (%2)/(%3)", _forEachIndex, (_x select 0), (_x select 1)];};//dbg
			if (_fixedDestinationRequestorPlayerUIDTextString == (_x select 0)) then {
				if (mgmTfA_configgv_serverVerbosityLevel>=4) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]  [TV3]          We got a match! Player with PUID (%1) has the following profileName: (%2).", (_x select 0), (_x select 1)];};//dbg
				_fixedDestinationRequestorProfileNameTextString  = (_x select 1);
				// This below is just to report in STATUS REPORT...
				mgmTfA_dynamicgv_fixedDestinationTaxisTheLastServedPlayerNameTextString = _fixedDestinationRequestorProfileNameTextString;
				if (mgmTfA_configgv_serverVerbosityLevel>=4) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]  [TV3]          _fixedDestinationRequestorProfileNameTextString is now set to: (%1). issuing (breakTo _PUIDsAndPlayernamesTextStringArrayCountNumberGreaterThanZeroScope) now.", (_x select 1)];};//dbg
				breakTo "_PUIDsAndPlayernamesTextStringArrayCountNumberGreaterThanZeroScope";
			};
		}  forEach mgmTfA_pvdb_PUIDsAndPlayernamesTextStringArray;
	};
	if (mgmTfA_configgv_serverVerbosityLevel>=3) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]  [TV3] [Call-a-fdTaxi]    RECEIVED FIXED DESTINATION TAXI REQUEST		here is the full raw DUMP via (str _this): (%1)", (str _this)];};//dbg
	if (mgmTfA_configgv_serverVerbosityLevel>=3) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]  [TV3] [Call-a-fdTaxi]    RECEIVED FIXED DESTINATION TAXI REQUEST		_fixedDestinationRequestorClientIDNumber: (%1).		_fixedDestinationRequestorPosition3DArray: (%2).		_fixedDestinationRequestedTaxiFixedDestinationIDNumber: (%3) / resolved to locationName: (%4).		_fixedDestinationRequestorPlayerUIDTextString: (%5) / resolved to profileName: (%6)", (str _fixedDestinationRequestorClientIDNumber), (str _fixedDestinationRequestorPosition3DArray), (str _fixedDestinationRequestedTaxiFixedDestinationIDNumber), _fixedDestinationRequestedDestinationNameTextString, _fixedDestinationRequestorPlayerUIDTextString, _fixedDestinationRequestorProfileNameTextString];};//dbg
	// STAGE IN WORKFLOW:		Determine what the response should be (accept or reject) and pass the request to the appropriate function via SPAWN	(the next function will inject artificial delay via uiSleep)
	// Let's make a decision here: are we going to APPROVE or REJECT the booking request? Then pass the request to appropriate script to respond AFTER an artificial delay.
	// Is the Requestor blacklisted?		is his PUID in mgmTfA_dynamicgv_fixedDestinationTaxisBlacklistedPlayerPUIDsTextStringArray?
	// He is not blacklisted unless the code block below say otherwise!
	_fixedDestinationRequestorIsInBlacklist = false;
	// Is the Requestor Blacklisted Check
	if (mgmTfA_configgv_serverVerbosityLevel>=3) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]  [TV3]           Will start traversing (mgmTfA_dynamicgv_fixedDestinationTaxisBlacklistedPlayerPUIDsTextStringArray) in the next line."];};//dbg
	{
		scopeName "fixedDestinationTaxisBlacklistTraverseScope";
		// compare player's PUID with the current Blacklisted PUID in array.
		//	if current entry does not match, proceed with the next one
		//	if current entry does match, issue "_fixedDestinationRequestorIsInBlacklist = true"; 	and breakOut
		//	if no entries match, end routine, as there is nothing to be done
		if (_fixedDestinationRequestorPlayerUIDTextString == _x) then {
			if (mgmTfA_configgv_serverVerbosityLevel>=4) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]  [TV4]           Player is in _fixedDestinationRequestorIsInBlacklist! He is blacklisted! He cannot use the Fixed Destination Taxi service!"];};
			_fixedDestinationRequestorIsInBlacklist = true;
			breakOut "fixedDestinationTaxisBlacklistTraverseScope";
		} else {
			if (mgmTfA_configgv_serverVerbosityLevel>=4) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]  [TV4]           Requestor's PUID did not match the current blacklisted PUID entry in this iteration. Proceeding to the next iteration (if there are any entries left in blacklist array)."];};
		};
	} forEach mgmTfA_dynamicgv_fixedDestinationTaxisBlacklistedPlayerPUIDsTextStringArray;
	if (mgmTfA_configgv_serverVerbosityLevel>=3) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]  [TV3]           We are just outside `forEach` loop. The value for _fixedDestinationRequestorIsInBlacklist is: (%1).", (str _fixedDestinationRequestorIsInBlacklist)];};
			
	
	// We have done the checks above. Now let's proceed accordingly.

	if(_fixedDestinationRequestorIsInBlacklist) then {
			// Report to log
			if (mgmTfA_configgv_serverVerbosityLevel>=3) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]  [TV3] Requestor is in blacklist; now spawn'ing function: (mgmTfA_s_FD_fnc_servicePhase02b_SendResponse_BookingRequestRejected_RequestorIsInBlacklist)"];};//dbg
		_null = [_fixedDestinationRequestorClientIDNumber, _fixedDestinationRequestorPosition3DArray, _fixedDestinationRequestedTaxiFixedDestinationIDNumber, _fixedDestinationRequestedDestinationNameTextString, _fixedDestinationRequestorPlayerUIDTextString, _fixedDestinationRequestorProfileNameTextString] spawn mgmTfA_s_FD_fnc_servicePhase02b_SendResponse_BookingRequestRejected_RequestorIsInBlacklist;
	} else {
			// Report to log
			if (mgmTfA_configgv_serverVerbosityLevel>=3) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]  [TV3] Request accepted; now spawn'ing function: mgmTfA_s_FD_fnc_servicePhase02a_SendResponse_BookingRequestAccepted"];};//dbg
		_null = [_fixedDestinationRequestorClientIDNumber, _fixedDestinationRequestorPosition3DArray, _fixedDestinationRequestedTaxiFixedDestinationIDNumber, _fixedDestinationRequestedDestinationNameTextString, _fixedDestinationRequestorPlayerUIDTextString, _fixedDestinationRequestorProfileNameTextString] spawn mgmTfA_s_FD_fnc_servicePhase02a_SendResponse_BookingRequestAccepted;
	};
};

"mgmTfA_gv_pvs_req_taxiAnywhereTaxiToMyPositionPleaseConfirmPacket" addPublicVariableEventHandler {
	scopeName "mgmTfA_gv_pvs_req_taxiAnywhereTaxiToMyPositionPleaseConfirmPacketMainScope";
	private	[
			"_taxiAnywhereRequestorClientIDNumber",
			"_taxiAnywhereRequestorPosition3DArray",
			"_taxiAnywhereRequestorPlayerUIDTextString",
			"_taxiAnywhereRequestorProfileNameTextString",
			"_taxiAnywhereRequestorIsInBlacklist",
			"_taxiAnywhereTaxiRequestedDestinationPosition3DArray"			
			];
	// STAGE IN WORKFLOW:		Parse Arguments & Prepare Local Variables
	_taxiAnywhereRequestorClientIDNumber	 = (owner	(_this select 1 select 0));
	_taxiAnywhereRequestorPosition3DArray	 = (_this select 1 select 1);
	_taxiAnywhereRequestorPlayerUIDTextString = (_this select 1 select 2);
	_taxiAnywhereTaxiRequestedDestinationPosition3DArray	 = (_this select 1 select 3);
	// TODO:		MOVE	THIS TO A SEPARATE FUNCTION FILE 		MOVE THIS TO A SEPARATE FUNCTION FILE 		MOVE THIS TO A SEPARATE FUNCTION FILE 		MOVE THIS TO A SEPARATE FUNCTION FILE 
	// STAGE IN WORKFLOW:		Determine Requestor's profileName
	// NOTE: Clients, in client-side init stage, pushBack their PUID & profileNames to a PV =>	mgmTfA_pvdb_PUIDsAndPlayernamesTextStringArray	<= we will use this array to find matching profileName
	private	[
			"_PUIDsAndPlayernamesTextStringArrayCountNumber"
			];
	_PUIDsAndPlayernamesTextStringArrayCountNumber 	 = count	(mgmTfA_pvdb_PUIDsAndPlayernamesTextStringArray);
		if (mgmTfA_configgv_serverVerbosityLevel>=3) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]  [TV3] _PUIDsAndPlayernamesTextStringArrayCountNumber is: (%1).", _PUIDsAndPlayernamesTextStringArrayCountNumber];};//dbg
	// Now that we know the size, if there's anything at all in the array, let's traverse it
	if (_PUIDsAndPlayernamesTextStringArrayCountNumber >0) then {
	scopeName "_PUIDsAndPlayernamesTextStringArrayCountNumberGreaterThanZeroScope";
		// We will traverse each array element
		// We will compare the 0th element [playerUID] with the playerUID we have been provided
		// If PUID  matches, we will return the profileName
		{
			if (mgmTfA_configgv_serverVerbosityLevel>=4) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]  [TV3]          Traversing the mgmTfA_pvdb_PUIDsAndPlayernamesTextStringArray. Current index is: (%1)     Content PUID/name is: (%2)/(%3)", _forEachIndex, (_x select 0), (_x select 1)];};//dbg
			if (_taxiAnywhereRequestorPlayerUIDTextString == (_x select 0)) then {
				if (mgmTfA_configgv_serverVerbosityLevel>=4) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]  [TV3]          We got a match! Player with PUID (%1) has the following profileName: (%2).", (_x select 0), (_x select 1)];};//dbg
				_taxiAnywhereRequestorProfileNameTextString = (_x select 1);
				// This below is just to report in STATUS REPORT...
				mgmTfA_dynamicgv_taxiAnywhereTaxisTheLastServedPlayerNameTextString = _taxiAnywhereRequestorProfileNameTextString;
				if (mgmTfA_configgv_serverVerbosityLevel>=4) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]  [TV3]          _taxiAnywhereRequestorProfileNameTextString is now set to: (%1). issuing (breakTo _PUIDsAndPlayernamesTextStringArrayCountNumberGreaterThanZeroScope) now.", (_x select 1)];};//dbg
				breakTo "_PUIDsAndPlayernamesTextStringArrayCountNumberGreaterThanZeroScope";
			};
		}  forEach mgmTfA_pvdb_PUIDsAndPlayernamesTextStringArray;
	};
	if (mgmTfA_configgv_serverVerbosityLevel>=3) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]      [Call-a-clickNGo-Taxi]    RECEIVED clickNGo REQUEST    here is the full raw DUMP via (str _this): (%1)", (str _this)];};//dbg
	if (mgmTfA_configgv_serverVerbosityLevel>=3) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]      [Call-a-clickNGo-Taxi]    RECEIVED clickNGo REQUEST    _taxiAnywhereRequestorClientIDNumber: (%1).	_taxiAnywhereRequestorProfileNameTextString: (%2).		Requestor Position: (%3).		_taxiAnywhereRequestorPlayerUIDTextString: (%4).		_taxiAnywhereTaxiRequestedDestinationPosition3DArray: (%5).", _taxiAnywhereRequestorClientIDNumber, _taxiAnywhereRequestorProfileNameTextString, _taxiAnywhereRequestorPosition3DArray, _taxiAnywhereRequestorPlayerUIDTextString, _taxiAnywhereTaxiRequestedDestinationPosition3DArray];};//dbg
	// STAGE IN WORKFLOW:		Determine what the response should be (accept or reject) and pass the request to the appropriate function via SPAWN	(the next function will inject artificial delay via uiSleep)
	// Let's make a decision here: are we going to APPROVE or REJECT the booking request? Then pass the request to appropriate script to respond AFTER an artificial delay.
	// Is the Requestor blacklisted?		is his PUID in mgmTfA_dynamicgv_taxiAnywhereTaxisBlacklistedPlayerPUIDsTextStringArray?
	// He is not blacklisted unless the code block below say otherwise!
	_taxiAnywhereRequestorIsInBlacklist = false;
	// Is the Requestor Blacklisted Check
	if (mgmTfA_configgv_serverVerbosityLevel>=3) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]  [TV3]           Will start traversing (mgmTfA_dynamicgv_taxiAnywhereTaxisBlacklistedPlayerPUIDsTextStringArray) in the next line."];};//dbg
	{
		scopeName "TATaxisBlacklistTraverseScope";
		
		// compare player's PUID with the current Blacklisted PUID in array.
		//	if current entry does not match, proceed with the next one
		//	if current entry does match, issue "_taxiAnywhereRequestorIsInBlacklist = true"; 	and breakOut
		//	if no entries match, end routine, as there is nothing to be done
		if (_taxiAnywhereRequestorPlayerUIDTextString == _x) then {
			if (mgmTfA_configgv_serverVerbosityLevel>=4) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]  [TV4]           Player is in _taxiAnywhereRequestorIsInBlacklist! He is blacklisted! He cannot use the clickNGo Taxi service!"];};
			_taxiAnywhereRequestorIsInBlacklist = true;
			breakOut "TATaxisBlacklistTraverseScope";
		} else {
			if (mgmTfA_configgv_serverVerbosityLevel>=4) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]  [TV4]           Requestor's PUID did not match the current blacklisted PUID entry in this iteration. Proceeding to the next iteration (if there are any entries left in blacklist array)."];};
		};
	} forEach mgmTfA_dynamicgv_taxiAnywhereTaxisBlacklistedPlayerPUIDsTextStringArray;
	if (mgmTfA_configgv_serverVerbosityLevel>=3) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]  [TV3]           We are just outside `forEach` loop. The value for _taxiAnywhereRequestorIsInBlacklist is: (%1).", (str _taxiAnywhereRequestorIsInBlacklist)];};
	// We have done the checks above. Now let's proceed accordingly.
	if(_taxiAnywhereRequestorIsInBlacklist) then {
		// Report to log
		if (mgmTfA_configgv_serverVerbosityLevel>=3) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]  [TV3] Requestor is in blacklist; now spawn'ing function: (mgmTfA_fnc_server_ClickNGoTaxi_ServicePhase02b_SendResponse_BookingRequestRejected_RequestorIsInBlacklist)"];};//dbg
		_null = [_taxiAnywhereRequestorClientIDNumber, _taxiAnywhereRequestorPosition3DArray, _taxiAnywhereRequestorPlayerUIDTextString, _taxiAnywhereRequestorProfileNameTextString, _taxiAnywhereTaxiRequestedDestinationPosition3DArray] spawn mgmTfA_s_TA_fnc_servicePhase02b_SendResponse_BookingRequestRejected_RequestorIsInBlacklist;
	} else {
		// Report to log
		if (mgmTfA_configgv_serverVerbosityLevel>=3) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]  [TV3] Request accepted; now spawn'ing function: mgmTfA_s_TA_fnc_servicePhase02a_SendResponse_BookingRequestAccepted"];};//dbg
		_null = [_taxiAnywhereRequestorClientIDNumber, _taxiAnywhereRequestorPosition3DArray, _taxiAnywhereRequestorPlayerUIDTextString, _taxiAnywhereRequestorProfileNameTextString, _taxiAnywhereTaxiRequestedDestinationPosition3DArray] spawn mgmTfA_s_TA_fnc_servicePhase02a_SendResponse_BookingRequestAccepted;
	};
};
"mgmTfA_gv_pvs_req_taxiAnywhereTaxiChargeMePAYGTickCostPleaseConfirmPacket" addPublicVariableEventHandler {
	scopeName "mgmTfA_gv_pvs_req_taxiAnywhereTaxiChargeMePAYGTickCostPleaseConfirmPacketMainScope";
	private	[
			"_taxiAnywhereRequestorClientIDNumber",
			"_taxiAnywhereRequestorPlayerUIDTextString",
			"_taxiAnywhereRequestorProfileNameTextString",
			"_myGUSUIDNumber",
			"_requestorPlayerObject"
			];
	// STAGE IN WORKFLOW:		Parse Arguments & Prepare Local Variables
	_taxiAnywhereRequestorClientIDNumber = (owner (_this select 1 select 0));
	_requestorPlayerObject = (_this select 1 select 0);
	_taxiAnywhereRequestorPlayerUIDTextString = (_this select 1 select 1);
	_myGUSUIDNumber = (_this select 1 select 2);
	// STAGE IN WORKFLOW:		Determine Requestor's profileName
	// NOTE: Clients, in client-side init stage, pushBack their PUID & profileNames to a PV =>	mgmTfA_pvdb_PUIDsAndPlayernamesTextStringArray	<= we will use this array to find matching profileName
	private	["_PUIDsAndPlayernamesTextStringArrayCountNumber"];
	_PUIDsAndPlayernamesTextStringArrayCountNumber = count	(mgmTfA_pvdb_PUIDsAndPlayernamesTextStringArray);
	if (mgmTfA_configgv_serverVerbosityLevel>=3) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]  [TV3] _PUIDsAndPlayernamesTextStringArrayCountNumber is: (%1).", _PUIDsAndPlayernamesTextStringArrayCountNumber];};//dbg
	// Now that we know the size, if there's anything at all in the array, let's traverse it
	if (_PUIDsAndPlayernamesTextStringArrayCountNumber >0) then {
	scopeName "_PUIDsAndPlayernamesTextStringArrayCountNumberGreaterThanZeroScope";
		// We will traverse each array element
		// We will compare the 0th element [playerUID] with the playerUID we have been provided
		// If PUID  matches, we will return the profileName
		{
			if (mgmTfA_configgv_serverVerbosityLevel>=4) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]  [TV3]          Traversing the mgmTfA_pvdb_PUIDsAndPlayernamesTextStringArray. Current index is: (%1)     Content PUID/name is: (%2)/(%3)", _forEachIndex, (_x select 0), (_x select 1)];};//dbg
			if (_taxiAnywhereRequestorPlayerUIDTextString == (_x select 0)) then {
				if (mgmTfA_configgv_serverVerbosityLevel>=4) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]  [TV3]          We got a match! Player with PUID (%1) has the following profileName: (%2).", (_x select 0), (_x select 1)];};//dbg
				_taxiAnywhereRequestorProfileNameTextString = (_x select 1);
				// This below is just to report in STATUS REPORT...
				mgmTfA_dynamicgv_taxiAnywhereTaxisTheLastServedPlayerNameTextString = _taxiAnywhereRequestorProfileNameTextString;
				if (mgmTfA_configgv_serverVerbosityLevel>=4) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]  [TV3]          _taxiAnywhereRequestorProfileNameTextString is now set to: (%1). issuing (breakTo _PUIDsAndPlayernamesTextStringArrayCountNumberGreaterThanZeroScope) now.", (_x select 1)];};//dbg
				breakTo "_PUIDsAndPlayernamesTextStringArrayCountNumberGreaterThanZeroScope";
			};
		}  forEach mgmTfA_pvdb_PUIDsAndPlayernamesTextStringArray;
	};
	if (mgmTfA_configgv_serverVerbosityLevel>=9) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]  [TV9]    [PAYG CHARGE ME TICK COST]    RECEIVED chargeMeTickCost REQUEST    here is the full raw DUMP via (str _this): (%1)", (str _this)];};//dbg
	if (mgmTfA_configgv_serverVerbosityLevel>=9) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]  [TV9]    [PAYG CHARGE ME TICK COST]    RECEIVED chargeMeTickCost REQUEST    _taxiAnywhereRequestorClientIDNumber: (%1).	_taxiAnywhereRequestorProfileNameTextString: (%2).		_taxiAnywhereRequestorPlayerUIDTextString: (%3).", _taxiAnywhereRequestorClientIDNumber, _taxiAnywhereRequestorProfileNameTextString, _taxiAnywhereRequestorPlayerUIDTextString];};//dbg
	// STAGE IN WORKFLOW:		Action the request = Charge the player
	_null = [_requestorPlayerObject, mgmTfA_configgv_taxiAnywhereTaxisTickCostInCryptoNegativeNumber] call EPOCH_exp_server_effectCrypto;
	// Report to log
	if (mgmTfA_configgv_serverVerbosityLevel>=3) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]  [TV3] SPAWN'ing function to inform customer: mgmTfA_s_TA_fnc_servicePhase04b_SendResponse_ChargePAYGTickCostRequestActioned"];};//dbg
	_null = [_taxiAnywhereRequestorClientIDNumber, _taxiAnywhereRequestorPlayerUIDTextString, _taxiAnywhereRequestorProfileNameTextString] spawn mgmTfA_s_TA_fnc_servicePhase04b_SendResponse_ChargePAYGTickCostRequestActioned;
};
"mgmTfA_gv_pvs_req_TAChargeMe1stMileFeePacket" addPublicVariableEventHandler {
	scopeName "mgmTfA_gv_pvs_req_TAChargeMe1stMileFeePacketMainScope";
	private	[
			"_taxiAnywhereRequestorClientIDNumber",
			"_taxiAnywhereRequestorPlayerUIDTextString",
			"_taxiAnywhereRequestorProfileNameTextString",
			"_myGUSUIDNumber",
			"_requestorPlayerObject",
			"_null"
			];
	// STAGE IN WORKFLOW:		Parse Arguments & Prepare Local Variables
	_taxiAnywhereRequestorClientIDNumber = (owner (_this select 1 select 0));
	_requestorPlayerObject = (_this select 1 select 0);
	_taxiAnywhereRequestorPlayerUIDTextString = (_this select 1 select 1);
	_myGUSUIDNumber = (_this select 1 select 2);
	// STAGE IN WORKFLOW:		Determine Requestor's profileName
	// NOTE: Clients, in client-side init stage, pushBack their PUID & profileNames to a PV =>	mgmTfA_pvdb_PUIDsAndPlayernamesTextStringArray	<= we will use this array to find matching profileName
	private	["_PUIDsAndPlayernamesTextStringArrayCountNumber"];
	_PUIDsAndPlayernamesTextStringArrayCountNumber = count	(mgmTfA_pvdb_PUIDsAndPlayernamesTextStringArray);
	if (mgmTfA_configgv_serverVerbosityLevel>=3) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]  [TV3] _PUIDsAndPlayernamesTextStringArrayCountNumber is: (%1).", _PUIDsAndPlayernamesTextStringArrayCountNumber];};//dbg
	// Now that we know the size, if there's anything at all in the array, let's traverse it
	if (_PUIDsAndPlayernamesTextStringArrayCountNumber >0) then {
	scopeName "_PUIDsAndPlayernamesTextStringArrayCountNumberGreaterThanZeroScope";
		// We will traverse each array element
		// We will compare the 0th element [playerUID] with the playerUID we have been provided
		// If PUID  matches, we will return the profileName
		{
			if (mgmTfA_configgv_serverVerbosityLevel>=4) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]  [TV3]          Traversing the mgmTfA_pvdb_PUIDsAndPlayernamesTextStringArray. Current index is: (%1)     Content PUID/name is: (%2)/(%3)", _forEachIndex, (_x select 0), (_x select 1)];};//dbg
			if (_taxiAnywhereRequestorPlayerUIDTextString == (_x select 0)) then {
				if (mgmTfA_configgv_serverVerbosityLevel>=4) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]  [TV3]          We got a match! Player with PUID (%1) has the following profileName: (%2).", (_x select 0), (_x select 1)];};//dbg
				_taxiAnywhereRequestorProfileNameTextString = (_x select 1);
				// This below is just to report in STATUS REPORT...
				mgmTfA_dynamicgv_taxiAnywhereTaxisTheLastServedPlayerNameTextString = _taxiAnywhereRequestorProfileNameTextString;
				if (mgmTfA_configgv_serverVerbosityLevel>=4) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]  [TV3]          _taxiAnywhereRequestorProfileNameTextString is now set to: (%1). issuing (breakTo _PUIDsAndPlayernamesTextStringArrayCountNumberGreaterThanZeroScope) now.", (_x select 1)];};//dbg
				breakTo "_PUIDsAndPlayernamesTextStringArrayCountNumberGreaterThanZeroScope";
			};
		}  forEach mgmTfA_pvdb_PUIDsAndPlayernamesTextStringArray;
	// TODO: add error handling - what if we cannot find it in the array? this most likely affect all similar traverses!
	};
	if (mgmTfA_configgv_serverVerbosityLevel>=9) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]      [TAXI ANYWHERE CHARGE ME 1ST MILE FEE REQUEST]    RECEIVED REQUEST    here is the full raw DUMP via (str _this): (%1)", (str _this)];};//dbg
	if (mgmTfA_configgv_serverVerbosityLevel>=9) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]      [TAXI ANYWHERE CHARGE ME 1ST MILE FEE REQUEST]    RECEIVED REQUEST    _taxiAnywhereRequestorClientIDNumber: (%1).	_taxiAnywhereRequestorProfileNameTextString: (%2).		_taxiAnywhereRequestorPlayerUIDTextString: (%3).", _taxiAnywhereRequestorClientIDNumber, _taxiAnywhereRequestorProfileNameTextString, _taxiAnywhereRequestorPlayerUIDTextString];};//dbg
	// STAGE IN WORKFLOW:		Action the request = Charge the player
	_null = [_requestorPlayerObject, mgmTfA_configgv_taxiAnywhereTaxisAbsoluteMinimumJourneyFeeInCryptoNegativeNumber] call EPOCH_exp_server_effectCrypto;
	// mark vehicle as 1st Mile Fee paid
	missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUTA1stMileFeeNeedToBePaidBool", _myGUSUIDNumber], false];
	publicVariable format ["mgmTfA_gv_PV_SU%1SUTA1stMileFeeNeedToBePaidBool", _myGUSUIDNumber];
	// Report to log
	if (mgmTfA_configgv_serverVerbosityLevel>=3) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]  [TV3] PLAYER CHARGED:		1ST MILE FEE			SPAWN'ing function to inform customer: mgmTfA_s_TA_fnc_servicePhase04a_SendResponse_Charge1stMileFeeRequestActioned"];};//dbg
	_null = [_taxiAnywhereRequestorClientIDNumber, _taxiAnywhereRequestorPlayerUIDTextString, _taxiAnywhereRequestorProfileNameTextString] spawn mgmTfA_s_TA_fnc_servicePhase04a_SendResponse_Charge1stMileFeeRequestActioned;
};
"mgmTfA_gv_pvs_req_FD_chargeMeServiceFeePacket" addPublicVariableEventHandler {
	scopeName "mgmTfA_gv_pvs_req_FD_chargeMeServiceFeePacketMainScope";
	private	[
			"_FD_RequestorClientIDNumber",
			"_FD_RequestorPlayerUIDTextString",
			"_FD_RequestorProfileNameTextString",
			"_myGUSUIDNumber",
			"_requestorPlayerObject",
			"_FD_journeyServiceFeeCostInCryptoNumber",
			"_journeyServiceFeeCostInCryptoNegativeNumber",
			"_null"
			];
	// STAGE IN WORKFLOW:		Parse Arguments & Prepare Local Variables
	_FD_RequestorClientIDNumber = (owner (_this select 1 select 0));
	_requestorPlayerObject = (_this select 1 select 0);
	_FD_RequestorPlayerUIDTextString = (_this select 1 select 1);
	_myGUSUIDNumber = (_this select 1 select 2);
	_FD_journeyServiceFeeCostInCryptoNumber = (_this select 1 select 3);
	_journeyServiceFeeCostInCryptoNegativeNumber = 0 - _FD_journeyServiceFeeCostInCryptoNumber;
	// STAGE IN WORKFLOW:		Determine Requestor's profileName
	// NOTE: Clients, in client-side init stage, pushBack their PUID & profileNames to a PV =>	mgmTfA_pvdb_PUIDsAndPlayernamesTextStringArray	<= we will use this array to find matching profileName
	private	["_PUIDsAndPlayernamesTextStringArrayCountNumber"];
	_PUIDsAndPlayernamesTextStringArrayCountNumber = count	(mgmTfA_pvdb_PUIDsAndPlayernamesTextStringArray);
	if (mgmTfA_configgv_serverVerbosityLevel>=3) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]  [TV3] _PUIDsAndPlayernamesTextStringArrayCountNumber is: (%1).", _PUIDsAndPlayernamesTextStringArrayCountNumber];};//dbg
	// Now that we know the size, if there's anything at all in the array, let's traverse it
	if (_PUIDsAndPlayernamesTextStringArrayCountNumber >0) then {
	scopeName "_PUIDsAndPlayernamesTextStringArrayCountNumberGreaterThanZeroScope";
		// We will traverse each array element
		// We will compare the 0th element [playerUID] with the playerUID we have been provided
		// If PUID  matches, we will return the profileName
		{
			if (mgmTfA_configgv_serverVerbosityLevel>=4) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]  [TV3]          Traversing the mgmTfA_pvdb_PUIDsAndPlayernamesTextStringArray. Current index is: (%1)     Content PUID/name is: (%2)/(%3)", _forEachIndex, (_x select 0), (_x select 1)];};//dbg
			if (_FD_RequestorPlayerUIDTextString == (_x select 0)) then {
				if (mgmTfA_configgv_serverVerbosityLevel>=4) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]  [TV3]          We got a match! Player with PUID (%1) has the following profileName: (%2).", (_x select 0), (_x select 1)];};//dbg
				_FD_RequestorProfileNameTextString = (_x select 1);
				// This below is just to report in STATUS REPORT...
				mgmTfA_dynamicgv_taxiAnywhereTaxisTheLastServedPlayerNameTextString = _FD_RequestorProfileNameTextString;
				if (mgmTfA_configgv_serverVerbosityLevel>=4) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]  [TV3]          _FD_RequestorProfileNameTextString is now set to: (%1). issuing (breakTo _PUIDsAndPlayernamesTextStringArrayCountNumberGreaterThanZeroScope) now.", (_x select 1)];};//dbg
				breakTo "_PUIDsAndPlayernamesTextStringArrayCountNumberGreaterThanZeroScope";
			};
		}  forEach mgmTfA_pvdb_PUIDsAndPlayernamesTextStringArray;
	// TODO: add error handling - what if we cannot find it in the array? this most likely affect all similar traverses!
	};
	if (mgmTfA_configgv_serverVerbosityLevel>=9) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]      [FIXED DESTINATION TAXI CHARGE ME SERVICE FEE REQUEST]    RECEIVED REQUEST    here is the full raw DUMP via (str _this): (%1)", (str _this)];};//dbg
	if (mgmTfA_configgv_serverVerbosityLevel>=9) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]      [FIXED DESTINATION TAXI CHARGE ME SERVICE FEE REQUEST]    RECEIVED REQUEST    _FD_RequestorClientIDNumber: (%1).	_FD_RequestorProfileNameTextString: (%2).		_FD_RequestorPlayerUIDTextString: (%3).", _FD_RequestorClientIDNumber, _FD_RequestorProfileNameTextString, _FD_RequestorPlayerUIDTextString];};//dbg
	// STAGE IN WORKFLOW:		Action the request = Charge the player
	_null = [_requestorPlayerObject, _journeyServiceFeeCostInCryptoNegativeNumber] call EPOCH_exp_server_effectCrypto;
	// mark vehicle as SERVICE FEE paid
	missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUFDServiceFeeNeedToBePaidBool", _myGUSUIDNumber], false];
	publicVariable format ["mgmTfA_gv_PV_SU%1SUFDServiceFeeNeedToBePaidBool", _myGUSUIDNumber];
	// Report to log
	if (mgmTfA_configgv_serverVerbosityLevel>=3) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]  [TV3] PLAYER CHARGED:		SERVICE FEE				SPAWN'ing function to inform customer: mgmTfA_s_TA_fnc_servicePhase04a_SendResponse_Charge1stMileFeeRequestActioned"];};//dbg
	_null = [_FD_RequestorClientIDNumber, _FD_RequestorPlayerUIDTextString, _FD_RequestorProfileNameTextString, _FD_journeyServiceFeeCostInCryptoNumber] spawn mgmTfA_s_FD_fnc_servicePhase04a_SendResponse_ChargeServiceFeeRequestActioned;
};
"mgmTfA_gv_pvs_req_taxiAnywhereTaxiChargeMeInitialBookingFeePleaseConfirmPacket" addPublicVariableEventHandler {
	scopeName "mgmTfA_gv_pvs_req_taxiAnywhereTaxiChargeMeInitialBookingFeePleaseConfirmPacketMainScope";
	private	[
			"_taxiAnywhereRequestorClientIDNumber",
			"_taxiAnywhereRequestorPlayerUIDTextString",
			"_taxiAnywhereRequestorProfileNameTextString",
			"_requestorPlayerObject"
			];
	// STAGE IN WORKFLOW:		Parse Arguments & Prepare Local Variables
	_taxiAnywhereRequestorClientIDNumber = (owner (_this select 1 select 0));
	_requestorPlayerObject = (_this select 1 select 0);
	_taxiAnywhereRequestorPlayerUIDTextString = (_this select 1 select 1);
	// STAGE IN WORKFLOW:		Determine Requestor's profileName
	// NOTE: Clients, in client-side init stage, pushBack their PUID & profileNames to a PV =>	mgmTfA_pvdb_PUIDsAndPlayernamesTextStringArray	<= we will use this array to find matching profileName
	private	["_PUIDsAndPlayernamesTextStringArrayCountNumber"];
	_PUIDsAndPlayernamesTextStringArrayCountNumber = count	(mgmTfA_pvdb_PUIDsAndPlayernamesTextStringArray);
	if (mgmTfA_configgv_serverVerbosityLevel>=3) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]  [TV3] _PUIDsAndPlayernamesTextStringArrayCountNumber is: (%1).", _PUIDsAndPlayernamesTextStringArrayCountNumber];};//dbg
	// Now that we know the size, if there's anything at all in the array, let's traverse it
	if (_PUIDsAndPlayernamesTextStringArrayCountNumber >0) then {
	scopeName "_PUIDsAndPlayernamesTextStringArrayCountNumberGreaterThanZeroScope";
		// We will traverse each array element
		// We will compare the 0th element [playerUID] with the playerUID we have been provided
		// If PUID  matches, we will return the profileName
		{
			if (mgmTfA_configgv_serverVerbosityLevel>=4) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]  [TV3]          Traversing the mgmTfA_pvdb_PUIDsAndPlayernamesTextStringArray. Current index is: (%1)     Content PUID/name is: (%2)/(%3)", _forEachIndex, (_x select 0), (_x select 1)];};//dbg
			if (_taxiAnywhereRequestorPlayerUIDTextString == (_x select 0)) then {
				if (mgmTfA_configgv_serverVerbosityLevel>=4) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]  [TV3]          We got a match! Player with PUID (%1) has the following profileName: (%2).", (_x select 0), (_x select 1)];};//dbg
				_taxiAnywhereRequestorProfileNameTextString = (_x select 1);
				// This below is just to report in STATUS REPORT...
				mgmTfA_dynamicgv_taxiAnywhereTaxisTheLastServedPlayerNameTextString = _taxiAnywhereRequestorProfileNameTextString;
				if (mgmTfA_configgv_serverVerbosityLevel>=4) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]  [TV3]          _taxiAnywhereRequestorProfileNameTextString is now set to: (%1). issuing (breakTo _PUIDsAndPlayernamesTextStringArrayCountNumberGreaterThanZeroScope) now.", (_x select 1)];};//dbg
				breakTo "_PUIDsAndPlayernamesTextStringArrayCountNumberGreaterThanZeroScope";
			};
		}  forEach mgmTfA_pvdb_PUIDsAndPlayernamesTextStringArray;
	};
	if (mgmTfA_configgv_serverVerbosityLevel>=3) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]      [PAYG CHARGE ME INITIAL BOOKING FEE ]    RECEIVED chargeMeInitialBookingFee REQUEST    here is the full raw DUMP via (str _this): (%1)", (str _this)];};//dbg
	if (mgmTfA_configgv_serverVerbosityLevel>=3) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]      [PAYG CHARGE ME INITIAL BOOKING FEE ]    RECEIVED chargeMeInitialBookingFee REQUEST    _taxiAnywhereRequestorClientIDNumber: (%1).	_taxiAnywhereRequestorProfileNameTextString: (%2).		_taxiAnywhereRequestorPlayerUIDTextString: (%3).", _taxiAnywhereRequestorClientIDNumber, _taxiAnywhereRequestorProfileNameTextString, _taxiAnywhereRequestorPlayerUIDTextString];};//dbg
	// STAGE IN WORKFLOW:		Action the request
	_null = [_requestorPlayerObject, mgmTfA_configgv_taxiAnywhereTaxisNonRefundableBookingFeeCostInCryptoNegativeNumber] call EPOCH_exp_server_effectCrypto;
	// Report to log
	if (mgmTfA_configgv_serverVerbosityLevel>=3) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]  [TV3] SPAWN'ing function to inform customer: mgmTfA_s_TA_fnc_servicePhase02aa_SendResponse_ChargePAYGInitialBookingFeeRequestActioned"];};//dbg
	_null = [_taxiAnywhereRequestorClientIDNumber, _taxiAnywhereRequestorPlayerUIDTextString, _taxiAnywhereRequestorProfileNameTextString] spawn mgmTfA_s_TA_fnc_servicePhase02aa_SendResponse_ChargePAYGInitialBookingFeeRequestActioned;
};
"mgmTfA_gv_pvs_req_taxiAnywhereTaxiPleaseAllowExitNoResponsePacket" addPublicVariableEventHandler {
	scopeName "mgmTfA_gv_pvs_req_taxiAnywhereTaxiPleaseAllowExitNoResponsePacketMainScope";
	private	[
			"_taxiAnywhereExitRequestorClientIDNumber",
			"_taxiAnywhereExitRequestorPlayerUIDTextString",
			"_taxiAnywhereExitRequestorProfileNameTextString",
			"_taxiAnywhereExitRequestorPlayerObject",
			"_myGUSUIDNumber"
			];
	_myGUSUIDNumber = (_this select 1 select 2);

	// STAGE IN WORKFLOW:		Parse Arguments & Prepare Local Variables
	_taxiAnywhereExitRequestorClientIDNumber = (owner (_this select 1 select 0));
	_taxiAnywhereExitRequestorPlayerObject = (_this select 1 select 0);
	_taxiAnywhereExitRequestorPlayerUIDTextString = (_this select 1 select 1);
	// STAGE IN WORKFLOW:		Determine Requestor's profileName
	// NOTE: Clients, in client-side init stage, pushBack their PUID & profileNames to a PV =>	mgmTfA_pvdb_PUIDsAndPlayernamesTextStringArray	<= we will use this array to find matching profileName
	private	["_PUIDsAndPlayernamesTextStringArrayCountNumber"];
	_PUIDsAndPlayernamesTextStringArrayCountNumber = count	(mgmTfA_pvdb_PUIDsAndPlayernamesTextStringArray);
	if (mgmTfA_configgv_serverVerbosityLevel>=6) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]  [TV6] _PUIDsAndPlayernamesTextStringArrayCountNumber is: (%1).", _PUIDsAndPlayernamesTextStringArrayCountNumber];};//dbg
	// Now that we know the size, if there's anything at all in the array, let's traverse it
	if (_PUIDsAndPlayernamesTextStringArrayCountNumber >0) then {
	scopeName "_PUIDsAndPlayernamesTextStringArrayCountNumberGreaterThanZeroScope";
		// We will traverse each array element
		// We will compare the 0th element [playerUID] with the playerUID we have been provided
		// If PUID  matches, we will return the profileName
		{
			if (mgmTfA_configgv_serverVerbosityLevel>=6) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]  [TV6]          Traversing the mgmTfA_pvdb_PUIDsAndPlayernamesTextStringArray. Current index is: (%1)     Content PUID/name is: (%2)/(%3)", _forEachIndex, (_x select 0), (_x select 1)];};//dbg
			if (_taxiAnywhereRequestorPlayerUIDTextString == (_x select 0)) then {
				if (mgmTfA_configgv_serverVerbosityLevel>=6) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]  [TV6]          We got a match! Player with PUID (%1) has the following profileName: (%2).", (_x select 0), (_x select 1)];};//dbg
				_taxiAnywhereExitRequestorProfileNameTextString = (_x select 1);
				// This below is just to report in STATUS REPORT...
				mgmTfA_dynamicgv_taxiAnywhereTaxisTheLastServedPlayerNameTextString = _taxiAnywhereExitRequestorProfileNameTextString;
				if (mgmTfA_configgv_serverVerbosityLevel>=6) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]  [TV6]          _taxiAnywhereExitRequestorProfileNameTextString is now set to: (%1). issuing (breakTo _PUIDsAndPlayernamesTextStringArrayCountNumberGreaterThanZeroScope) now.", (_x select 1)];};//dbg
				breakTo "_PUIDsAndPlayernamesTextStringArrayCountNumberGreaterThanZeroScope";
			};
		}  forEach mgmTfA_pvdb_PUIDsAndPlayernamesTextStringArray;
	};
	if (mgmTfA_configgv_serverVerbosityLevel>=6) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]  [TV6]      [AN AUTHORIZED TA PLEASE ALLOW EXIT REQUEST RECEIVED]    here is the full raw DUMP via (str _this): (%1)", (str _this)];};//dbg
	if (mgmTfA_configgv_serverVerbosityLevel>=6) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]  [TV6]      [AN AUTHORIZED TA PLEASE ALLOW EXIT REQUEST RECEIVED]    _taxiAnywhereExitRequestorClientIDNumber: (%1).	_taxiAnywhereExitRequestorProfileNameTextString: (%2).		_taxiAnywhereExitRequestorPlayerUIDTextString: (%3).", _taxiAnywhereExitRequestorClientIDNumber, _taxiAnywhereExitRequestorProfileNameTextString, _taxiAnywhereExitRequestorPlayerUIDTextString];};//dbg

	// ACTION the request -- set it to true
	missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUStopVehicleRequestedAndAuthorized", _myGUSUIDNumber], true];
	publicVariable format ["mgmTfA_gv_PV_SU%1SUStopVehicleRequestedAndAuthorized", _myGUSUIDNumber];

	// Report to log
	if (mgmTfA_configgv_serverVerbosityLevel>=5) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]  [TV5]		I have set mgmTfA_gv_PV_SU%1SUStopVehicleRequestedAndAuthorized to true"];};//dbg
};
if (mgmTfA_configgv_serverVerbosityLevel>=4) then {diag_log format ["[mgmTfA] [mgmTfA_s_CO_scr_initRegisterServerEventHandlers.sqf]  [TV4] END reading file."];};//dbg
// EOF