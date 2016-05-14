//H
//H ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_fnc_server_ClickNGoTaxi_ServicePhase03_CreateServiceUnitAndGoToRequestor.sqf
//H $PURPOSE$	:	This function create a new Service Unit for clickNGo Taxi request and start travelling towards RequestorPosition
//H ~~
//H
//HH
//HH ~~
//HH	NEED UPDATE			//HH	Example usage	:	_null =	[_taxiAnywhereRequestorClientIDNumber, _taxiAnywhereRequestorPosition3DArray, _THISDOESNOTEXISTINTHISFILE__fixedDestinationRequestedTaxiFixedDestinationIDNumber, _THISDOESNOTEXISTINTHISFILE__fixedDestinationRequestedDestinationNameTextString, _taxiAnywhereRequestorPlayerUIDTextString, _taxiAnywhereRequestorProfileNameTextString, _positionToSpawnSUVehiclePosition3DArray, _myGUSUIDNumber] spawn mgmTfA_fnc_server_ClickNGoTaxi_ServicePhase03_CreateServiceUnitAndGoToRequestor;
//HH	NEED UPDATE			//HH	Parameters	:	
//HH	NEED UPDATE			//HH					// We will not need all these but pass everything for now as we might change the script in the future...
//HH	NEED UPDATE			//HH					// Argument #0:		_taxiAnywhereRequestorClientIDNumber
//HH	NEED UPDATE			//HH					// Argument #1:		_taxiAnywhereRequestorPosition3DArray
//HH	NEED UPDATE			//HH					// Argument #2:		_THISDOESNOTEXISTINTHISFILE__fixedDestinationRequestedTaxiFixedDestinationIDNumber
//HH	NEED UPDATE			//HH					// Argument #3:		_THISDOESNOTEXISTINTHISFILE__fixedDestinationRequestedDestinationNameTextString
//HH	NEED UPDATE			//HH					// Argument #4:		_taxiAnywhereRequestorPlayerUIDTextString
//HH	NEED UPDATE			//HH					// Argument #5:		_taxiAnywhereRequestorProfileNameTextString
//HH	NEED UPDATE			//HH					// Argument #6:		_positionToSpawnSUVehiclePosition3DArray
//HH	NEED UPDATE			//HH					// Argument #7:		_myGUSUIDNumber
//HH	NEED UPDATE			//HH	Return Value	:	none	[this function spawns the next function in "clickNGo Taxi - Service Request - Workflow"
//HH ~~
//HH	The server-side master configuration file read (and/or publicVariable publish) the following value(s) this function rely on:
//HH		mgmTfA_configgv_serverVerbosityLevel
//HH		mgmTfA_dynamicgv_sideRelationSetupHasNotBeenDoneYetBool
//HH		
//HH	Note: we will send an initial "we are processing your request - please wait" message to the Requestor
//HH	Note: we will send the FINAL confirmation to the Requestor ONLY AFTER successfully creating the SU (vehicle+driver).
//HH
if (!isServer) exitWith {}; if (isNil("mgmTfA_Server_Init")) then {mgmTfA_Server_Init=0;}; waitUntil {mgmTfA_Server_Init==1}; private ["_thisFileVerbosityLevelNumber"]; _thisFileVerbosityLevelNumber = mgmTfA_configgv_serverVerbosityLevel;
scopeName "mgmTfA_fnc_server_ClickNGoTaxi_ServicePhase03_CreateServiceUnitAndGoToRequestorMainScope";
private	[
		"_taxiAnywhereRequestorClientIDNumber",
		"_taxiAnywhereRequestorPosition3DArray",
		"_taxiAnywhereRequestorPlayerUIDTextString",
		"_taxiAnywhereRequestorProfileNameTextString",
		"_taxiAnywhereTaxiRequestedDestinationPosition3DArray",
		"_positionToSpawnSUVehiclePosition3DArray",
		"_myGUSUIDNumber",
		"_SUCurrentTaskThresholdInSecondsNumber",
		"_SUCurrentTaskAgeInSecondsNumber",
		"_SUCurrentTaskBirthTimeInSecondsNumber",
		"_thisFileVerbosityLevelNumber",
		"_SUAICharacterDriverObject",
		"_SUAIGroup",
		"_SUTaxiVehicleSpawnPosition3DArray",
		"_SUUnitPosPosition3DArray",
		"_SUTaxiWaypointRadiusInMetersNumber",
		"_SUTaxiAIVehicleDriverObject",
		"_SUTaxiAIVehicleWaypointMainArray",
		"_SUTaxiAIVehicleWaypointMainArrayIndexNumber",
		"_SUTaxiAIVehicleFirstWaypointPosition3DArray",
		"_SUTaxiAIVehicleVehicleDirectionInDegreesNumber",
		"_SUAIVehicleVehicleDirectionInDegreesNumber",
		"_SUTaxiAIVehicleObject",
		"_SUAIVehicleObject",
		"_SUAIVehicleSpeedOfVehicleInKMHNumber",
		"_SUTaxiAIVehicleObjectBirthTimeInSecondsNumber",
		"_SUAIVehicleObjectBirthTimeInSecondsNumber",
		"_SUTaxiAIVehicleObjectAgeInSecondsNumber",
		"_SUAIVehicleObjectAgeInSecondsNumber",
		"_SUAIVehicleObjectCurrentPositionPosition3DArray",
		"_SUDriversFirstnameTextString",
		"_SUTypeTextString",
		"_SUCurrentActionInProgressTextString",
		"_SURequestorProfileNameTextString",
		"_SUActiveWaypointPositionPosition3DArray",
		"_iWantToTravelThisManyMetresNumber",
		"_doorsLockedBool",
		"_SUTaxiAIVehicleDistanceToWayPointMetersNumber",
		"_initiateServiceUnitAbnormalShutdownImmediatelyBool",
		"_SUMarkerShouldBeDestroyedAfterExpiryBool",
		"_SUPickUpHasOccurredBool",
		"_SUDropOffHasOccurredBool",
		"_SUPickUpPositionPosition3DArray",
		"_SUDropOffPositionHasBeenDeterminedBool",
		"_SUDropOffPositionPosition3DArray",
		// This one below is not in use but keep for now (so that we won't have to renumber all function arguments) // to be cleaned up one day
		"_SUDropOffPositionNameTextString",
		"_SUTerminationPointPositionHasBeenDeterminedBool",
		"_SUTerminationPointPosition3DArray",
		"_SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray",
		"_broadcastSUInformationCounter",
		"_SUDistanceToActiveWaypointInMetersNumber",
		"_SURequestorPlayerUIDTextString",
		"_counterForLogOnlyEveryNthPINGNumber",
		"_emergencyEscapeNeeded",
		// keep these for now (so that we won't have to renumber all function arguments) // to be cleaned up one day
		"_THISDOESNOTEXISTINTHISFILE__fixedDestinationRequestedTaxiFixedDestinationIDNumber",
		"_THISDOESNOTEXISTINTHISFILE__fixedDestinationRequestedDestinationNameTextString"
		];

// Set the Expiry Timeout Threshold
_SUCurrentTaskThresholdInSecondsNumber = mgmTfA_configgv_expiryTimeOutThresholdTATaxiOnTheWayToPickingUpRequestorInSecondsNumber;
// Reset Current Task Age
_SUCurrentTaskAgeInSecondsNumber = 0;
//Start the Current Task Age Timer
_SUCurrentTaskBirthTimeInSecondsNumber = (time);
//// Prep Function Arguments
_taxiAnywhereRequestorClientIDNumber = (_this select 0);
_taxiAnywhereRequestorPosition3DArray = (_this select 1);
_taxiAnywhereRequestorPlayerUIDTextString = (_this select 2);
_taxiAnywhereRequestorProfileNameTextString = (_this select 3);
_taxiAnywhereTaxiRequestedDestinationPosition3DArray = (_this select 4);
_positionToSpawnSUVehiclePosition3DArray = (_this select 5);
_myGUSUIDNumber = (_this select 6);

// keep these for now (so that we won't have to renumber all function arguments) // to be cleaned up one day
_THISDOESNOTEXISTINTHISFILE__fixedDestinationRequestedTaxiFixedDestinationIDNumber = "_THISDOESNOTEXISTINTHISFILE__fixedDestinationRequestedTaxiFixedDestinationIDNumber";
_THISDOESNOTEXISTINTHISFILE__fixedDestinationRequestedDestinationNameTextString = "_THISDOESNOTEXISTINTHISFILE__fixedDestinationRequestedDestinationNameTextString";

// Start with zero
_iWantToTravelThisManyMetresNumber = 0;
_doorsLockedBool = false;
_SUTaxiAIVehicleDistanceToWayPointMetersNumber = 0;
_SUCurrentActionInProgressTextString = "UNDEFINED";
_initiateServiceUnitAbnormalShutdownImmediatelyBool = false;
// These below are a duplicate variables - they are created just to keep function-calling-code consistent.
	_SUActiveWaypointPositionPosition3DArray = _taxiAnywhereRequestorPosition3DArray;
	_SURequestorPlayerUIDTextString = _taxiAnywhereRequestorPlayerUIDTextString;
	_SURequestorProfileNameTextString = _taxiAnywhereRequestorProfileNameTextString;
// This below should not be necessary at this stage. It is added to this function to keep function-calling-code consistent.
_SUMarkerShouldBeDestroyedAfterExpiryBool = false;

//// Begin the work on creating SU
_SUAICharacterDriverObject  = objNull;
_SUAIGroup = createGroup RESISTANCE;
_SUTaxiVehicleSpawnPosition3DArray = _positionToSpawnSUVehiclePosition3DArray;
_SUUnitPosPosition3DArray = _positionToSpawnSUVehiclePosition3DArray;
_SUTaxiWaypointRadiusInMetersNumber = 5;
_SUTaxiAIVehicleDriverObject = objNull;
_SUTypeTextString = "TxAnyw";
_SUPickUpHasOccurredBool = false;
_SUPickUpPositionPosition3DArray = [];
_SUDropOffPositionHasBeenDeterminedBool = true;
_SUDropOffPositionNameTextString = _THISDOESNOTEXISTINTHISFILE__fixedDestinationRequestedDestinationNameTextString;
// _SUDropOffPositionPosition3DArray will be updated below, at about line 200
//NO NEED TO PROVIDE FALSE VALUE HERE! about 100 lines down, this will be set to the actual value!		_SUDropOffPositionPosition3DArray = [-1000, -1000, -1000];
_SUDropOffHasOccurredBool = false;
_SUTerminationPointPositionHasBeenDeterminedBool = false;
_SUTerminationPointPosition3DArray = [];
_SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray = [];
_SUDistanceToActiveWaypointInMetersNumber = -1;
//_SUAIVehicleObject									//<=	do not set this variable yet (it will be done later in this file)
//_SUAIVehicleObjectBirthTimeInSecondsNumber			//<=	do not set this variable yet (it will be done later in this file)
//_SUAIVehicleObjectAgeInSecondsNumber					//<=	do not set this variable yet (it will be done later in this file)
//_SUAIVehicleObjectCurrentPositionPosition3DArray		//<=	do not set this variable yet (it will be done later in this file)
//_SUAIVehicleSpeedOfVehicleInKMHNumber					//<=	do not set this variable yet (it will be done later in this file)
// Start with false
_emergencyEscapeNeeded = false;

if (mgmTfA_configgv_serverVerbosityLevel>=4) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_ClickNGoTaxi_ServicePhase03_CreateServiceUnitAndGoToRequestor.sqf]  [TV4] <ThisIs:%1> I have been SPAWN'd. Here is the raw dump of the arguments I have in (_this)=(%2).", _myGUSUIDNumber, (str _this)];};//dbg
if (_thisFileVerbosityLevelNumber>=2) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_ClickNGoTaxi_ServicePhase03_CreateServiceUnitAndGoToRequestor.sqf]  [TV2] A clickNGo taxi request was FORWARDED to me.			This is what I have received:		_taxiAnywhereRequestorClientIDNumber: (%1).		_taxiAnywhereRequestorPosition3DArray: (%2).		_taxiAnywhereRequestorPlayerUIDTextString: (%3) / resolved to _taxiAnywhereRequestorProfileNameTextString: (%4).		_taxiAnywhereTaxiRequestedDestinationPosition3DArray: (%5).	_positionToSpawnSUVehiclePosition3DArray is: (%6).		_myGUSUIDNumber is: (%7).", _taxiAnywhereRequestorClientIDNumber, (str _taxiAnywhereRequestorPosition3DArray), _taxiAnywhereRequestorPlayerUIDTextString, _taxiAnywhereRequestorProfileNameTextString, _taxiAnywhereTaxiRequestedDestinationPosition3DArray, (str _positionToSpawnSUVehiclePosition3DArray), _myGUSUIDNumber];};//dbg

// ANYTHING BELOW HERE HAS NOT BEEN MOVED UP YET ***		ANYTHING BELOW HERE HAS NOT BEEN MOVED UP YET ***		ANYTHING BELOW HERE HAS NOT BEEN MOVED UP YET ***		ANYTHING BELOW HERE HAS NOT BEEN MOVED UP YET ***
	// lol wut?
	// go back in gitlogs try and understand what this is about?

//Set Sides (Only If Hasn't Been Done Before)
if (mgmTfA_dynamicgv_sideRelationSetupHasNotBeenDoneYetBool) then {
	if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_ClickNGoTaxi_ServicePhase03_CreateServiceUnitAndGoToRequestor.sqf]  [TV4] Sides DO NEED set up -- I will do it now. I will set mgmTfA_dynamicgv_sideRelationSetupHasNotBeenDoneYetBool to false."];};//dbg
	createCenter RESISTANCE;
	RESISTANCE setFriend [WEST,1];
	RESISTANCE setFriend [EAST,0];
	WEST setFriend [RESISTANCE,1];
	EAST setFriend [RESISTANCE,0];
	// This is now done
	mgmTfA_dynamicgv_sideRelationSetupHasNotBeenDoneYetBool = false;
} else {
	if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_ClickNGoTaxi_ServicePhase03_CreateServiceUnitAndGoToRequestor.sqf]  [TV4] Sides DO NOT NEED set up -- nothing to be done on this."];};//dbg
};

_SUTaxiAIVehicleWaypointMainArrayIndexNumber = 2;
_SUTaxiAIVehicleFirstWaypointPosition3DArray = _taxiAnywhereRequestorPosition3DArray;
//Note:	_SUTaxiAIVehicleWaypointMainArrayIndexNumber is still pointing at 2. by default 0 & 1 exist, so we are at the right index value to insert the 3rd item!
_SUTaxiAIVehicleWaypointMainArray = _SUAIGroup addWaypoint [_SUTaxiAIVehicleFirstWaypointPosition3DArray, _SUTaxiWaypointRadiusInMetersNumber,_SUTaxiAIVehicleWaypointMainArrayIndexNumber];
_SUTaxiAIVehicleWaypointMainArray setWaypointType "MOVE";
_SUTaxiAIVehicleWaypointMainArray setWaypointTimeout [1, 1, 1];

//Our goal (after picking up the Requestor, will be) reaching =>		_taxiAnywhereTaxiRequestedDestinationPosition3DArray
_SUDropOffPositionPosition3DArray = _taxiAnywhereTaxiRequestedDestinationPosition3DArray;
// Need the below to fix the issue with dropOffMarker being placed exactly on top of clickNGoMarker causing the latter to be difficult to read
_SUDropOffPositionPosition3DArray	set [1,((_SUDropOffPositionPosition3DArray select 1)+15)];

// Inform all clients so that authorized clients can create a local marker for Drop Off Point
if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_ClickNGoTaxi_ServicePhase03_CreateServiceUnitAndGoToRequestor.sqf]  [TV3]           Waypoint Added: %2 at %1", _taxiAnywhereRequestorPosition3DArray, _SUTaxiAIVehicleWaypointMainArray];};//dbg
if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_ClickNGoTaxi_ServicePhase03_CreateServiceUnitAndGoToRequestor.sqf]  [TV3]           Waypoints Added: The current Waypoint Array is: (%1). _SUTaxiAIVehicleWaypointMainArrayIndexNumber is: (%2)",_SUTaxiAIVehicleWaypointMainArray, _SUTaxiAIVehicleWaypointMainArrayIndexNumber];};//dbg

// Reduce number of available TATaxis TaxiDrivers by one
mgmTfA_gvdb_PV_taxiAnywhereTaxisNumberOfCurrentlyAvailableTaxiDriversNumber = mgmTfA_gvdb_PV_taxiAnywhereTaxisNumberOfCurrentlyAvailableTaxiDriversNumber - 1;

//Create the vehicle for AI-Service-Unit
_SUTaxiAIVehicleVehicleDirectionInDegreesNumber = (floor (random 361));
_SUTaxiAIVehicleObject = mgmTfA_configgv_taxiAnywhereTaxisTaxiVehicleClassnameTextString createVehicle _SUTaxiVehicleSpawnPosition3DArray;
if (mgmTfA_configgv_currentMod == "EPOCH") then {
	_SUTaxiAIVehicleObject		call		EPOCH_server_setVToken;
	if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_ClickNGoTaxi_ServicePhase03_CreateServiceUnitAndGoToRequestor.sqf]  [TV3]           Server is running EPOCH MOD. Post vehicle creation, setVToken issued to prevent accidental-clean up."];};//dbg
};
_SUTaxiAIVehicleObjectBirthTimeInSecondsNumber = (time);
_SUTaxiAIVehicleObject setFormDir _SUTaxiAIVehicleVehicleDirectionInDegreesNumber;
_SUTaxiAIVehicleObject setDir _SUTaxiAIVehicleVehicleDirectionInDegreesNumber;
_SUTaxiAIVehicleObject setPos getPos _SUTaxiAIVehicleObject;
_SUTaxiAIVehicleObject setVariable ["BIS_enableRandomization", false];
_SUTaxiAIVehicleObject setObjectTextureGlobal [0, mgmTfA_configgv_taxiAnywhereTaxisTaxiVehicleActiveColorSchemeTextString];
_SUTaxiAIVehicleObject setFuel 1;
_SUTaxiAIVehicleObject allowDammage false;
_SUTaxiAIVehicleObject addEventHandler ["HandleDamage", {false}];	
_SUTaxiAIVehicleObject setVariable ["isMemberOfTaxiCorpFleet", _SUAIGroup, true];
_SUTaxiAIVehicleObject setVariable ["mgmTfAisTATaxi", true, true];
_SUTaxiAIVehicleObject setVariable ["GUSUIDNumber", _myGUSUIDNumber, true];
_SUTaxiAIVehicleObject setVariable ["commandingCustomerPlayerUIDNumber", _taxiAnywhereRequestorPlayerUIDTextString, true];
_SUTaxiAIVehicleObject setVariable ["customerCannotAffordService", false, true];
_SUTaxiAIVehicleObject setVariable ["exitRequestedAndAuthorized", false, true];
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUVehDoorsLockedBool", _myGUSUIDNumber], _doorsLockedBool];
publicVariable format ["mgmTfA_gv_PV_SU%1SUVehDoorsLockedBool", _myGUSUIDNumber];

//NO LONGER IN USE -- TO BE CLEANED UP		//missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUTxAnywPayNowMenuIsCurrentlyNotAttachedBool", _myGUSUIDNumber], true];
//NO LONGER IN USE -- TO BE CLEANED UP		//publicVariable format ["mgmTfA_gv_PV_SU%1SUTxAnywPayNowMenuIsCurrentlyNotAttachedBool", _myGUSUIDNumber];
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUTxAnywServiceFeeHasBeenPaidBool", _myGUSUIDNumber], false];
publicVariable format ["mgmTfA_gv_PV_SU%1SUTxAnywServiceFeeHasBeenPaidBool", _myGUSUIDNumber];

// Is 1st Mile Fee enabled on the server?
if (mgmTfA_configgv_taxiAnywhereTaxisAbsoluteMinimumJourneyFeeInCryptoNumber > 0) then {
	// yes 1st Mile Fee is enabled and thus it need to be paid -- log the detected 1st Mile Fee setting
	if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_ClickNGoTaxi_ServicePhase03_CreateServiceUnitAndGoToRequestor.sqf] [TV3] DETECTED: 1st Mile Fee is ENABLED"];};
	// mark the vehicle accordingly on all MP clients
	missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUTA1stMileFeeNeedToBePaidBool", _myGUSUIDNumber], true];
	publicVariable format ["mgmTfA_gv_PV_SU%1SUTA1stMileFeeNeedToBePaidBool", _myGUSUIDNumber];
} else {
	// no 1st Mile Fee is not enabled and thus it does not need to be paid -- log the detected 1st Mile Fee setting
	if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_ClickNGoTaxi_ServicePhase03_CreateServiceUnitAndGoToRequestor.sqf] [TV3] DETECTED: 1st Mile Fee is ENABLED"];};
	// mark the vehicle accordingly on all MP clients
	missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUTA1stMileFeeNeedToBePaidBool", _myGUSUIDNumber], false];
	publicVariable format ["mgmTfA_gv_PV_SU%1SUTA1stMileFeeNeedToBePaidBool", _myGUSUIDNumber];
};
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUTxAnywPAYGIsCurrentlyActiveBool", _myGUSUIDNumber], false];
publicVariable format ["mgmTfA_gv_PV_SU%1SUTxAnywPAYGIsCurrentlyActiveBool", _myGUSUIDNumber];
// if *Global variants is used, the effect will be global. otherwise players continue seeing the old items in cargo		ref:	http://www.reddit.com/r/arma/comments/2rpk6e/arma_3_ammo_boxes_and_similar_reset_to_original/cniglrb
clearMagazineCargoGlobal _SUTaxiAIVehicleObject;
clearWeaponCargoGlobal _SUTaxiAIVehicleObject;
clearBackpackCargoGlobal _SUTaxiAIVehicleObject;
clearAllItemsFromBackpack _SUTaxiAIVehicleObject;
clearItemCargoGlobal _SUTaxiAIVehicleObject;

//Create an AI character - the driver
for [{_n=1}, {_n <2}, {_n=_n+1;}] do
{
		// create the AI unit
		"B_soldier_AR_F" createUnit [_SUUnitPosPosition3DArray, _SUAIGroup, "_SUAICharacterDriverObject=this;",0.6,"Private"];
		_SUDriversFirstnameTextString = [] call mgmTfA_s_CO_fnc_returnARandomFirstnameTextString;
		_SUAICharacterDriverObject setVariable ["firstName",_SUDriversFirstnameTextString,true];
			if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_ClickNGoTaxi_ServicePhase03_CreateServiceUnitAndGoToRequestor.sqf]  [TV3]           Just picked a random name, here is the result... _SUDriversFirstnameTextString is set to: (%1)", _SUDriversFirstnameTextString];};//dbg

		//set AI unit's AI parameters
		_SUAICharacterDriverObject enableAI "TARGET";
		_SUAICharacterDriverObject enableAI "AUTOTARGET";
		_SUAICharacterDriverObject enableAI "MOVE";
		_SUAICharacterDriverObject enableAI "ANIM";
		_SUAICharacterDriverObject enableAI "FSM";
		_SUAICharacterDriverObject	allowDammage true;
		_SUAICharacterDriverObject	setCombatMode "GREEN";
		_SUAICharacterDriverObject	setBehaviour "CARELESS";
		
		//remove AI unit's default weapons & ammo
		removeAllWeapons			_SUAICharacterDriverObject;
		
		//set AI unit's skills
		_SUAICharacterDriverObject setSkill ["aimingAccuracy",1];
		_SUAICharacterDriverObject setSkill ["aimingShake",1];
		_SUAICharacterDriverObject setSkill ["aimingSpeed",1];
		_SUAICharacterDriverObject setSkill ["endurance",1];
		_SUAICharacterDriverObject setSkill ["spotDistance",0.6];
		_SUAICharacterDriverObject setSkill ["spotTime",1];
		_SUAICharacterDriverObject setSkill ["courage",1];
		_SUAICharacterDriverObject setSkill ["reloadSpeed",1];
		_SUAICharacterDriverObject setSkill ["commanding",1];
		_SUAICharacterDriverObject setSkill ["general",1];

		// 1st AI unit is the designated driver - special actions for him: (assignAsCargo) && (moveInCargo)
		if(_n==1) then {
			_SUAICharacterDriverObject assignAsCargo _SUTaxiAIVehicleObject;
			_SUAICharacterDriverObject moveInCargo _SUTaxiAIVehicleObject;
			_SUAICharacterDriverObject addEventHandler ["HandleDamage", {false}];
			
			//Driver is the leader (and sole member for now)
			_SUAIGroup selectLeader _SUAICharacterDriverObject;
			_SUTaxiAIVehicleDriverObject = _SUAICharacterDriverObject;
			_SUTaxiAIVehicleDriverObject addEventHandler ["HandleDamage", {false}];
			_SUAICharacterDriverObject assignAsDriver _SUTaxiAIVehicleObject;
			_SUAICharacterDriverObject moveInDriver _SUTaxiAIVehicleObject;
		} else {
				//Code to create additional AI characters (i.e.: bodyguards) can be added in this section
		};
};
waitUntil{!isNull _SUTaxiAIVehicleObject};
if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_ClickNGoTaxi_ServicePhase03_CreateServiceUnitAndGoToRequestor.sqf]  [TV3] SPAWN Completed. Vehicle: (%1) | GUSUID: (%2) | Driver: (%3)", _SUTaxiAIVehicleObject, _myGUSUIDNumber, _SUDriversFirstnameTextString];};//dbg

//When setting the waypoint, make a note: How far are we going to go?
_iWantToTravelThisManyMetresNumber = (round (_SUTaxiAIVehicleObject distance _taxiAnywhereRequestorPosition3DArray));
if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_ClickNGoTaxi_ServicePhase03_CreateServiceUnitAndGoToRequestor.sqf]  [TV3] current value:   (_iWantToTravelThisManyMetresNumber)=(%1)   ]", _iWantToTravelThisManyMetresNumber];};//dbg
if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_ClickNGoTaxi_ServicePhase03_CreateServiceUnitAndGoToRequestor.sqf]  [TV4] SLEEPing now for %1 seconds before locking doors.", mgmTfA_configgv_timeToSleepBeforeLockingSpawnedclickNGoVehicleDoors];};//dbg
uiSleep mgmTfA_configgv_timeToSleepBeforeLockingSpawnedclickNGoVehicleDoors;
_SUTaxiAIVehicleObject lockDriver true;
//We will unlock it when necessary. For now, no need to unlock it.
_SUTaxiAIVehicleObject lockCargo true;
//Save the new status of vehicleDoorLock
_doorsLockedBool=true;
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUVehDoorsLockedBool", _myGUSUIDNumber], _doorsLockedBool];
publicVariable format ["mgmTfA_gv_PV_SU%1SUVehDoorsLockedBool", _myGUSUIDNumber];
//check distance to our Current Waypoint (_taxiAnywhereRequestorPosition3DArray) and write to server RPT log
_SUTaxiAIVehicleDistanceToWayPointMetersNumber = (round (_SUTaxiAIVehicleObject distance _taxiAnywhereRequestorPosition3DArray));
if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_ClickNGoTaxi_ServicePhase03_CreateServiceUnitAndGoToRequestor.sqf]  [TV4] Distance to Waypoint _taxiAnywhereRequestorPosition3DArray is: (%1). Locked the doors & going there now.", _SUTaxiAIVehicleDistanceToWayPointMetersNumber];};//dbg
//Change our status to:		1 DRIVING-TO-REQUESTOR		to _taxiAnywhereRequestorPosition3DArray
_SUCurrentActionInProgressTextString  = mgmTfA_configgv_currentTATaxiActionInProgressIs01TextString;

// LOOP ON THE WAY TO PICKUP!
_counterForLogOnlyEveryNthPINGNumber = 0;

///
// Broadcast ServiceUnit Information
///
// Need to calculate these now as we will publish it in the next line!
_SUCurrentTaskAgeInSecondsNumber = (round ((time) - _SUCurrentTaskBirthTimeInSecondsNumber));
_SUTaxiAIVehicleObjectAgeInSecondsNumber = (round ((time) -_SUTaxiAIVehicleObjectBirthTimeInSecondsNumber));
_SUAIVehicleObjectAgeInSecondsNumber = _SUTaxiAIVehicleObjectAgeInSecondsNumber;
_SUAIVehicleObjectCurrentPositionPosition3DArray = (getPosATL _SUTaxiAIVehicleObject);
_SUTaxiAIVehicleVehicleDirectionInDegreesNumber = (getDir _SUTaxiAIVehicleObject) + 45;
_SUAIVehicleVehicleDirectionInDegreesNumber = _SUTaxiAIVehicleVehicleDirectionInDegreesNumber;
_SUAIVehicleSpeedOfVehicleInKMHNumber = (round (speed _SUTaxiAIVehicleObject));
_SUPickUpPositionPosition3DArray = _taxiAnywhereRequestorPosition3DArray;
_SUAIVehicleObject = _SUTaxiAIVehicleObject;
_SUAIVehicleObjectBirthTimeInSecondsNumber = _SUTaxiAIVehicleObjectBirthTimeInSecondsNumber;
_SUDistanceToActiveWaypointInMetersNumber = (round (_SUAIVehicleObject distance _SUActiveWaypointPositionPosition3DArray));
_null = [_myGUSUIDNumber, _SUTypeTextString, _SUActiveWaypointPositionPosition3DArray, _SUCurrentActionInProgressTextString, _SUCurrentTaskThresholdInSecondsNumber, _SUCurrentTaskBirthTimeInSecondsNumber, _SUDriversFirstnameTextString, _SUMarkerShouldBeDestroyedAfterExpiryBool, _SURequestorPlayerUIDTextString, _SURequestorProfileNameTextString, _SUAIVehicleObject, _SUAIVehicleObjectBirthTimeInSecondsNumber, _SUPickUpHasOccurredBool, _SUPickUpPositionPosition3DArray, _SUDropOffPositionHasBeenDeterminedBool, _SUDropOffHasOccurredBool, _SUDropOffPositionPosition3DArray, _SUDropOffPositionNameTextString, _SUTerminationPointPositionHasBeenDeterminedBool, _SUTerminationPointPosition3DArray, _SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray, _SUAIVehicleObjectCurrentPositionPosition3DArray, _SUAIVehicleVehicleDirectionInDegreesNumber, _SUAIVehicleObjectAgeInSecondsNumber, _SUCurrentTaskAgeInSecondsNumber, _SUAIVehicleSpeedOfVehicleInKMHNumber, _SUDistanceToActiveWaypointInMetersNumber] call mgmTfA_s_CO_fnc_publicVariableBroadcastSUInformationInitialBroadcast;
///

// Client Communications - Send the initial "we are processing your request - please wait" message to the Requestor
mgmTfA_gv_pvc_pos_yourTATaxiRequestApprovedDriverEnRoutePacketSignalOnly = ".";
_taxiAnywhereRequestorClientIDNumber publicVariableClient "mgmTfA_gv_pvc_pos_yourTATaxiRequestApprovedDriverEnRoutePacketSignalOnly";
if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_ClickNGoTaxi_ServicePhase03_CreateServiceUnitAndGoToRequestor.sqf]  [TV3] SENT RESPONSE    (mgmTfA_gv_pvc_pos_yourTATaxiRequestApprovedDriverEnRoutePacketSignalOnly) to Requestor:  (%1)		on computer (_taxiAnywhereRequestorClientIDNumber)=(%2).", _taxiAnywhereRequestorProfileNameTextString, _taxiAnywhereRequestorClientIDNumber];};//dbg

//We are on the way to requestorPosition to pick up the requestor... We will loop till we are very close to the requestorPosition
_broadcastSUInformationCounter = 0;

while {(_SUTaxiAIVehicleDistanceToWayPointMetersNumber>10) && ((speed _SUTaxiAIVehicleObject) != 0)} do {

	scopeName "DrivingToPickUpPointWhileLoop";
	
	///
	// Broadcast ServiceUnit Information
	///
	// Only if it has been at least 1 second!	currently uiSleep`ing 0.05 seconds, meaning at least 1 second = 1.00 / 0.05 = 20th package.
	_broadcastSUInformationCounter = _broadcastSUInformationCounter + 1;
	if (_broadcastSUInformationCounter >= 20) then {
		// Need to calculate these now as we will publish it in the next line!
		_SUCurrentTaskAgeInSecondsNumber = (round ((time) - _SUCurrentTaskBirthTimeInSecondsNumber));
		_SUTaxiAIVehicleObjectAgeInSecondsNumber = (round ((time) -_SUTaxiAIVehicleObjectBirthTimeInSecondsNumber));
		_SUAIVehicleObjectAgeInSecondsNumber = _SUTaxiAIVehicleObjectAgeInSecondsNumber;
		_SUAIVehicleObjectCurrentPositionPosition3DArray = (getPosATL _SUTaxiAIVehicleObject);
		_SUTaxiAIVehicleVehicleDirectionInDegreesNumber = (getDir _SUTaxiAIVehicleObject) + 45;
		_SUAIVehicleVehicleDirectionInDegreesNumber = _SUTaxiAIVehicleVehicleDirectionInDegreesNumber;
		_SUAIVehicleSpeedOfVehicleInKMHNumber = (round (speed _SUTaxiAIVehicleObject));
		_SUPickUpPositionPosition3DArray = _taxiAnywhereRequestorPosition3DArray;
		_SUAIVehicleObject = _SUTaxiAIVehicleObject;
		_SUAIVehicleObjectBirthTimeInSecondsNumber = _SUTaxiAIVehicleObjectBirthTimeInSecondsNumber;
		_SUDistanceToActiveWaypointInMetersNumber = (round (_SUAIVehicleObject distance _SUActiveWaypointPositionPosition3DArray));
		_null = [_myGUSUIDNumber, _SUTypeTextString, _SUActiveWaypointPositionPosition3DArray, _SUCurrentActionInProgressTextString, _SUCurrentTaskThresholdInSecondsNumber, _SUCurrentTaskBirthTimeInSecondsNumber, _SUDriversFirstnameTextString, _SUMarkerShouldBeDestroyedAfterExpiryBool, _SURequestorPlayerUIDTextString, _SURequestorProfileNameTextString, _SUAIVehicleObject, _SUAIVehicleObjectBirthTimeInSecondsNumber, _SUPickUpHasOccurredBool, _SUPickUpPositionPosition3DArray, _SUDropOffPositionHasBeenDeterminedBool, _SUDropOffHasOccurredBool, _SUDropOffPositionPosition3DArray, _SUDropOffPositionNameTextString, _SUTerminationPointPositionHasBeenDeterminedBool, _SUTerminationPointPosition3DArray, _SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray, _SUAIVehicleObjectCurrentPositionPosition3DArray, _SUAIVehicleVehicleDirectionInDegreesNumber, _SUAIVehicleObjectAgeInSecondsNumber, _SUCurrentTaskAgeInSecondsNumber, _SUAIVehicleSpeedOfVehicleInKMHNumber, _SUDistanceToActiveWaypointInMetersNumber] call mgmTfA_s_CO_fnc_publicVariableBroadcastSUInformationPhaseB;
	};
	///

	//"Timed out while travelling to requestorPosition to pick him up"
	//First let's refresh the distance value
	_SUTaxiAIVehicleDistanceToWayPointMetersNumber = (round (_SUTaxiAIVehicleObject distance _SUActiveWaypointPositionPosition3DArray));
	uiSleep 0.05;
	
	// Calculate Current Task Age and Initiate Abnormal SU Termination (logged) if necessary
	// TODO: There is calculation duplication here [SUInformation is also calculating this. eliminate duplicate cost]
	_SUCurrentTaskAgeInSecondsNumber = (round ((time) - _SUCurrentTaskBirthTimeInSecondsNumber));
	if (_SUCurrentTaskAgeInSecondsNumber > _SUCurrentTaskThresholdInSecondsNumber) then {
		// Expiry Timeout Threshold Exceeded. Initiating Abnormal Termination of SU.		// We are being abnormally destroyed!
		_emergencyEscapeNeeded = true;
		if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_ClickNGoTaxi_ServicePhase03_CreateServiceUnitAndGoToRequestor.sqf] [TV3] Expiry Timeout Threshold Exceeded for SU (%1). Initiating Abnormal SU Termination! _SUCurrentTaskAgeInSecondsNumber is: (%2). _SUCurrentTaskThresholdInSecondsNumber is: (%3).", _myGUSUIDNumber, _SUCurrentTaskAgeInSecondsNumber, _SUCurrentTaskThresholdInSecondsNumber];};
		breakTo "mgmTfA_fnc_server_ClickNGoTaxi_ServicePhase03_CreateServiceUnitAndGoToRequestorMainScope";
	};

	// PING			log only every Nth package			(uiSleep=0.05)		(n=300) => 	log every 15 seconds
	_counterForLogOnlyEveryNthPINGNumber=_counterForLogOnlyEveryNthPINGNumber+1;
	if (_counterForLogOnlyEveryNthPINGNumber==300) then {
		if (_thisFileVerbosityLevelNumber>=2) then {
			_SUTaxiAIVehicleObjectAgeInSecondsNumber = (round ((time) -_SUTaxiAIVehicleObjectBirthTimeInSecondsNumber));
			diag_log format ["[mgmTfA] [mgmTfA_fnc_server_ClickNGoTaxi_ServicePhase03_CreateServiceUnitAndGoToRequestor.sqf] [TV2] PING from SU Vehicle: (%1) | Driver: (%2) | ServerUpTime: (%3) | MyAge: (%4) | Distance to WP: (%5) metres | Action In Progress: (%6)", _myGUSUIDNumber, _SUDriversFirstnameTextString, (round (time)), _SUTaxiAIVehicleObjectAgeInSecondsNumber, _SUTaxiAIVehicleDistanceToWayPointMetersNumber, _SUCurrentActionInProgressTextString];
		};
		_counterForLogOnlyEveryNthPINGNumber=0;
	};

	// Pit-stop checks: AutoRefuel
	if (fuel _SUTaxiAIVehicleObject < 0.2) then {
		_SUTaxiAIVehicleObject setFuel 1;
		if (_thisFileVerbosityLevelNumber>=2) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_ClickNGoTaxi_ServicePhase03_CreateServiceUnitAndGoToRequestor.sqf] [TV2] REFUELing SU Vehicle: (%1) | Driver: (%2) | ServerUpTime: (%3) | MyAge: (%4)", _myGUSUIDNumber, _SUDriversFirstnameTextString, (round (time)), _SUTaxiAIVehicleObjectAgeInSecondsNumber];};//dbg
	};
	
	// Pit-stop checks: AutoRepair
	if (damage _SUTaxiAIVehicleObject>0.2) then {
		_SUTaxiAIVehicleObject setDamage 0;
		if (_thisFileVerbosityLevelNumber>=2) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_ClickNGoTaxi_ServicePhase03_CreateServiceUnitAndGoToRequestor.sqf] [TV2] REPAIRing SU Vehicle: (%1) | Driver: (%2) | ServerUpTime: (%3) | MyAge: (%4)", _myGUSUIDNumber, _SUDriversFirstnameTextString, (round (time)), _SUTaxiAIVehicleObjectAgeInSecondsNumber];};//dbg
	};
};
if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_ClickNGoTaxi_ServicePhase03_CreateServiceUnitAndGoToRequestor.sqf] [TV4] EXITED LOOP: DrivingToPickUpPointWhileLoop.	Next, SPAWN'ing: (mgmTfA_s_TA_fnc_servicePhase04_PickUpPointAndBeyond)"];};//dbg

// If emergency escape needed:		skip Phase04 & 05 completely and jump to Phase06
// If emergency escape is NOT needed:	proceed to the next Phase
if (!_emergencyEscapeNeeded) then { 
	// proceed to next Phase as per normal
	if (_thisFileVerbosityLevelNumber>=2) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_ClickNGoTaxi_ServicePhase03_CreateServiceUnitAndGoToRequestor.sqf] [TV2] <<<reached end-of-file>>>.   no emergency. proceeding with normal next phase in the workflow.			SPAWN'ing (mgmTfA_s_TA_fnc_servicePhase04_PickUpPointAndBeyond)."];};//dbg
	_null = [_taxiAnywhereRequestorClientIDNumber, _taxiAnywhereRequestorPosition3DArray, _THISDOESNOTEXISTINTHISFILE__fixedDestinationRequestedTaxiFixedDestinationIDNumber, _THISDOESNOTEXISTINTHISFILE__fixedDestinationRequestedDestinationNameTextString, _taxiAnywhereRequestorPlayerUIDTextString, _taxiAnywhereRequestorProfileNameTextString, _myGUSUIDNumber, _iWantToTravelThisManyMetresNumber, _SUTaxiAIVehicleObject, _SUDriversFirstnameTextString, _taxiAnywhereTaxiRequestedDestinationPosition3DArray, _doorsLockedBool, _SUAIGroup, _SUTaxiWaypointRadiusInMetersNumber, _SUTaxiAIVehicleObjectBirthTimeInSecondsNumber, _SUTaxiAIVehicleWaypointMainArray, _SUTaxiAIVehicleWaypointMainArrayIndexNumber, _SUAICharacterDriverObject, _SUTypeTextString, _SUDropOffPositionHasBeenDeterminedBool, _SUDropOffPositionNameTextString, _SUDropOffPositionPosition3DArray, _SUDropOffHasOccurredBool, _SUTerminationPointPositionHasBeenDeterminedBool, _SUTerminationPointPosition3DArray, _SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray] spawn mgmTfA_s_TA_fnc_servicePhase04_PickUpPointAndBeyond;
 } else {
	// we have an emergency and we need to shutdown ASAP. forget about the normal workflow next phase(s) and go directly to termination phase!
	if (_thisFileVerbosityLevelNumber>=2) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_ClickNGoTaxi_ServicePhase03_CreateServiceUnitAndGoToRequestor.sqf]  [TV2] <<<reached end-of-file>>>.   there is an EMERGENCY therefore skipping Phases 04 & 05 completely 	and SPAWN'ing Phase06 immediately now (mgmTfA_s_TA_fnc_servicePhase06_ToTerminationAndTheEnd)"];};//dbg
	private	["_requestorPlayerObject"];
	_requestorPlayerObject = objNull;
	_null = [_taxiAnywhereRequestorProfileNameTextString, _taxiAnywhereRequestorClientIDNumber, _iWantToTravelThisManyMetresNumber, _requestorPlayerObject, _myGUSUIDNumber, _SUAICharacterDriverObject, _SUTaxiAIVehicleObject, _SUTaxiAIVehicleObjectBirthTimeInSecondsNumber, _SUDriversFirstnameTextString, _doorsLockedBool, _SUTaxiAIVehicleWaypointMainArray, _SUTaxiAIVehicleWaypointMainArrayIndexNumber, _SUTaxiWaypointRadiusInMetersNumber, _SUAIGroup, _SUAIVehicleObjectAgeInSecondsNumber, _SUAIVehicleObjectCurrentPositionPosition3DArray, _SUTaxiAIVehicleVehicleDirectionInDegreesNumber, _SUAIVehicleVehicleDirectionInDegreesNumber, _SUAIVehicleSpeedOfVehicleInKMHNumber, _SUPickUpPositionPosition3DArray, _SUAIVehicleObject, _SUAIVehicleObjectBirthTimeInSecondsNumber, _SUDistanceToActiveWaypointInMetersNumber, _SUActiveWaypointPositionPosition3DArray, _SUTypeTextString, _SUMarkerShouldBeDestroyedAfterExpiryBool, _SURequestorPlayerUIDTextString, _SURequestorProfileNameTextString, _SUPickUpHasOccurredBool, _SUDropOffPositionHasBeenDeterminedBool, _SUDropOffHasOccurredBool, _SUDropOffPositionPosition3DArray, _SUDropOffPositionNameTextString, _SUTerminationPointPositionHasBeenDeterminedBool, _SUTerminationPointPosition3DArray, _SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray, _emergencyEscapeNeeded] spawn mgmTfA_s_TA_fnc_servicePhase06_ToTerminationAndTheEnd;
 };
// EOF