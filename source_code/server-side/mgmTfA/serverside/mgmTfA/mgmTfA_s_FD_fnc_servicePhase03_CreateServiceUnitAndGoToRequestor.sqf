//H
//H ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_s_FD_fnc_servicePhase03_CreateServiceUnitAndGoToRequestor.sqf
//H $PURPOSE$	:	This function create a new Service Unit for Fixed Destination Taxi request and start travelling towards RequestorPosition
//H ~~
//H
//HH
//HH ~~
//HH	Example usage	:	_null =	[_fixedDestinationRequestorClientIDNumber, _fixedDestinationRequestorPosition3DArray, _fixedDestinationRequestedTaxiFixedDestinationIDNumber, _fixedDestinationRequestedDestinationNameTextString, _fixedDestinationRequestorPlayerUIDTextString, _fixedDestinationRequestorProfileNameTextString, _positionToSpawnSUVehiclePosition3DArray, _myGUSUIDNumber] spawn mgmTfA_s_FD_fnc_servicePhase03_CreateServiceUnitAndGoToRequestor;
//HH	Parameters	:	
//HH					// We will not need all these but pass everything for now as we might change the script in the future...
//HH					// Argument #0:		_fixedDestinationRequestorClientIDNumber
//HH					// Argument #1:		_fixedDestinationRequestorPosition3DArray
//HH					// Argument #2:		_fixedDestinationRequestedTaxiFixedDestinationIDNumber
//HH					// Argument #3:		_fixedDestinationRequestedDestinationNameTextString
//HH					// Argument #4:		_fixedDestinationRequestorPlayerUIDTextString
//HH					// Argument #5:		_fixedDestinationRequestorProfileNameTextString
//HH					// Argument #6:		_positionToSpawnSUVehiclePosition3DArray
//HH					// Argument #7:		_myGUSUIDNumber
//HH	Return Value	:	none	[this function spawns the next function in "Fixed Destination Taxi - Service Request - Workflow"
//HH ~~
//HH	The server-side master configuration file read (and/or publicVariable publish) the following value(s) this function rely on:
//HH		mgmTfA_configgv_serverVerbosityLevel
//HH		mgmTfA_dynamicgv_sideRelationSetupHasNotBeenDoneYetBool
//HH		
//HH	Note: we will send an initial "we are processing your request - please wait" message to the Requestor
//HH	Note: we will send the FINAL confirmation to the Requestor ONLY AFTER successfully creating the SU (vehicle+driver).
//HH
if (!isServer) exitWith {}; if (isNil("mgmTfA_Server_Init")) then {mgmTfA_Server_Init=0;}; waitUntil {mgmTfA_Server_Init==1}; private ["_thisFileVerbosityLevelNumber"]; _thisFileVerbosityLevelNumber = mgmTfA_configgv_serverVerbosityLevel;
scopeName "mgmTfA_s_FD_fnc_servicePhase03_CreateServiceUnitAndGoToRequestorMainScope";
private	[
		"_fixedDestinationRequestorClientIDNumber",
		"_fixedDestinationRequestorPosition3DArray",
		"_fixedDestinationRequestedTaxiFixedDestinationIDNumber",
		"_fixedDestinationRequestedDestinationNameTextString",
		"_fixedDestinationRequestorPlayerUIDTextString",
		"_fixedDestinationRequestorProfileNameTextString",
		"_fixedDestinationRequestedTaxiFixedDestinationPosition3DArray",
		"_positionToSpawnSUVehiclePosition3DArray",
		"_myGUSUIDNumber",
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
		"_SUCurrentTaskThresholdInSecondsNumber",
		"_SUCurrentTaskAgeInSecondsNumber",
		"_SUCurrentTaskBirthTimeInSecondsNumber",
		"_initiateServiceUnitAbnormalShutdownImmediatelyBool",
		"_SUMarkerShouldBeDestroyedAfterExpiryBool",
		"_SUPickUpHasOccurredBool",
		"_SUDropOffHasOccurredBool",
		"_SUPickUpPositionPosition3DArray",
		"_SUDropOffPositionHasBeenDeterminedBool",
		"_SUDropOffPositionPosition3DArray",
		"_SUDropOffPositionNameTextString",
		"_SUTerminationPointPositionHasBeenDeterminedBool",
		"_SUTerminationPointPosition3DArray",
		"_SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray",
		"_broadcastSUInformationCounter",
		"_SUDistanceToActiveWaypointInMetersNumber",
		"_emergencyEscapeNeeded",
		"_SURequestorPlayerUIDTextString"									
];

// Expiry Timeout Threshold: mgmTfA_configgv_expiryTimeOutThresholdfixedDestinationTaxiOnTheWayToPickingUpRequestorInSecondsNumber
_SUCurrentTaskThresholdInSecondsNumber = mgmTfA_configgv_expiryTimeOutThresholdfixedDestinationTaxiOnTheWayToPickingUpRequestorInSecondsNumber;
// Reset Current Task Age
_SUCurrentTaskAgeInSecondsNumber = 0;
//Start the Current Task Age Timer
_SUCurrentTaskBirthTimeInSecondsNumber = (time);

//Debug level for this file
_thisFileVerbosityLevelNumber = mgmTfA_configgv_serverVerbosityLevel;

//// Prep Function Arguments
_fixedDestinationRequestorClientIDNumber = (_this select 0);
_fixedDestinationRequestorPosition3DArray = (_this select 1);
_fixedDestinationRequestedTaxiFixedDestinationIDNumber = (_this select 2);
_fixedDestinationRequestedDestinationNameTextString = (_this select 3);
_fixedDestinationRequestorPlayerUIDTextString = (_this select 4);
_fixedDestinationRequestorProfileNameTextString = (_this select 5);
_positionToSpawnSUVehiclePosition3DArray = (_this select 6);
_myGUSUIDNumber = (_this select 7);
_fixedDestinationRequestedTaxiFixedDestinationPosition3DArray = [];
// Start with zero
_iWantToTravelThisManyMetresNumber = 0;
_doorsLockedBool = false;
_SUTaxiAIVehicleDistanceToWayPointMetersNumber = 0;
_SUCurrentActionInProgressTextString = "UNDEFINED";
_initiateServiceUnitAbnormalShutdownImmediatelyBool = false;
// These below are a duplicate variables - they are created just to keep function-calling-code consistent.
	_SUActiveWaypointPositionPosition3DArray = _fixedDestinationRequestorPosition3DArray;
	_SURequestorPlayerUIDTextString = _fixedDestinationRequestorPlayerUIDTextString;
	_SURequestorProfileNameTextString = _fixedDestinationRequestorProfileNameTextString;
// This below should not be necessary at this stage. It is added to this function to keep function-calling-code consistent.
_SUMarkerShouldBeDestroyedAfterExpiryBool = false;

//// Begin the work on creating SU
_SUAICharacterDriverObject = objNull;
_SUAIGroup = createGroup RESISTANCE;
_SUTaxiVehicleSpawnPosition3DArray = _positionToSpawnSUVehiclePosition3DArray;
_SUUnitPosPosition3DArray = _positionToSpawnSUVehiclePosition3DArray;
_SUTaxiWaypointRadiusInMetersNumber = 5;
_SUTaxiAIVehicleDriverObject = objNull;
_SUTypeTextString = "TxFdt";
_SUPickUpHasOccurredBool = false;
_SUPickUpPositionPosition3DArray = [];
_SUDropOffPositionHasBeenDeterminedBool = true;
_SUDropOffPositionNameTextString = _fixedDestinationRequestedDestinationNameTextString;
//NO NEED TO PROVIDE FALSE VALUE HERE! about 100 lines down, this will be set to the actual value!		_SUDropOffPositionPosition3DArray = [-1000, -1000, -1000];
_SUDropOffHasOccurredBool = false;
_SUTerminationPointPositionHasBeenDeterminedBool = false;
_SUTerminationPointPosition3DArray = [];
_SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray = [];
_SUDistanceToActiveWaypointInMetersNumber = -1;
//_SUAIVehicleObject										//<=	do not set this variable yet (it will be done later in this file)
//_SUAIVehicleObjectBirthTimeInSecondsNumber				//<=	do not set this variable yet (it will be done later in this file)
//_SUAIVehicleObjectAgeInSecondsNumber						//<=	do not set this variable yet (it will be done later in this file)
//_SUAIVehicleObjectCurrentPositionPosition3DArray			//<=	do not set this variable yet (it will be done later in this file)
//_SUAIVehicleSpeedOfVehicleInKMHNumber						//<=	do not set this variable yet (it will be done later in this file)
// start with false
_emergencyEscapeNeeded = false;
if (mgmTfA_configgv_serverVerbosityLevel>=4) then {diag_log format ["[mgmTfA] [mgmTfA_s_FD_fnc_servicePhase03_CreateServiceUnitAndGoToRequestor.sqf]  [TV4] <ThisIs:%1> I have been SPAWN'd. Here is the raw dump of the arguments I have in (_this)=(%2).", _myGUSUIDNumber, (str _this)];};//dbg
if (_thisFileVerbosityLevelNumber>=2) then {diag_log format ["[mgmTfA] [mgmTfA_s_FD_fnc_servicePhase03_CreateServiceUnitAndGoToRequestor.sqf]  [TV2] A fixed destination taxi request was FORWARDED to me.			This is what I have received:		_fixedDestinationRequestorClientIDNumber: (%1).		_fixedDestinationRequestorPosition3DArray: (%2).		_fixedDestinationRequestedTaxiFixedDestinationIDNumber: (%3) / resolved to locationName: (%4).		_fixedDestinationRequestorPlayerUIDTextString: (%5) / resolved to profileName: (%6).		_positionToSpawnSUVehiclePosition3DArray is: (%7).		_myGUSUIDNumber is: (%8).", _fixedDestinationRequestorClientIDNumber, (str _fixedDestinationRequestorPosition3DArray), _fixedDestinationRequestedTaxiFixedDestinationIDNumber, _fixedDestinationRequestedDestinationNameTextString, _fixedDestinationRequestorPlayerUIDTextString, _fixedDestinationRequestorProfileNameTextString, (str _positionToSpawnSUVehiclePosition3DArray), _myGUSUIDNumber];};//dbg

//Set Sides (Only If Hasn't Been Done Before)
if (mgmTfA_dynamicgv_sideRelationSetupHasNotBeenDoneYetBool) then {
	if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA] [mgmTfA_s_FD_fnc_servicePhase03_CreateServiceUnitAndGoToRequestor.sqf]  [TV4] Sides DO NEED set up -- I will do it now. I will set mgmTfA_dynamicgv_sideRelationSetupHasNotBeenDoneYetBool to false."];};//dbg
	createCenter RESISTANCE;
	RESISTANCE setFriend [WEST,1];
	RESISTANCE setFriend [EAST,0];
	WEST setFriend [RESISTANCE,1];
	EAST setFriend [RESISTANCE,0];
	
	// This is now done
	mgmTfA_dynamicgv_sideRelationSetupHasNotBeenDoneYetBool  = false;
} else {
	if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA] [mgmTfA_s_FD_fnc_servicePhase03_CreateServiceUnitAndGoToRequestor.sqf]  [TV4] Sides DO NOT NEED set up -- nothing to be done on this."];};//dbg
};

_SUTaxiAIVehicleWaypointMainArrayIndexNumber  = 2;
_SUTaxiAIVehicleFirstWaypointPosition3DArray = _fixedDestinationRequestorPosition3DArray;
//Note:	_SUTaxiAIVehicleWaypointMainArrayIndexNumber is still pointing at 2. by default 0 & 1 exist, so we are at the right index value to insert the 3rd item!
_SUTaxiAIVehicleWaypointMainArray = _SUAIGroup addWaypoint [_SUTaxiAIVehicleFirstWaypointPosition3DArray, _SUTaxiWaypointRadiusInMetersNumber,_SUTaxiAIVehicleWaypointMainArrayIndexNumber];
_SUTaxiAIVehicleWaypointMainArray setWaypointType "MOVE";
_SUTaxiAIVehicleWaypointMainArray setWaypointTimeout [1, 1, 1];

//Our goal (after picking up the Requestor, will be) reaching =>		_fixedDestinationRequestedTaxiFixedDestinationPosition3DArray
//Let's get the coordinates first
switch _fixedDestinationRequestedTaxiFixedDestinationIDNumber do {
	case 1: { _fixedDestinationRequestedTaxiFixedDestinationPosition3DArray = mgmTfA_configgv_taxiFixedDestination01LocationPositionArray	};
	case 2: { _fixedDestinationRequestedTaxiFixedDestinationPosition3DArray = mgmTfA_configgv_taxiFixedDestination02LocationPositionArray	};
	case 3: { _fixedDestinationRequestedTaxiFixedDestinationPosition3DArray = mgmTfA_configgv_taxiFixedDestination03LocationPositionArray	};
	case 0;
	default { _fixedDestinationRequestedTaxiFixedDestinationPosition3DArray = [-1000,-1000,-1000]; };
};
_SUDropOffPositionPosition3DArray = _fixedDestinationRequestedTaxiFixedDestinationPosition3DArray;
if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_s_FD_fnc_servicePhase03_CreateServiceUnitAndGoToRequestor.sqf]  [TV3]           Waypoint Added: %2 at %1", _fixedDestinationRequestorPosition3DArray, _SUTaxiAIVehicleWaypointMainArray];};//dbg
if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_s_FD_fnc_servicePhase03_CreateServiceUnitAndGoToRequestor.sqf]  [TV3]           Waypoints Added: The current Waypoint Array is: (%1). _SUTaxiAIVehicleWaypointMainArrayIndexNumber is: (%2)",_SUTaxiAIVehicleWaypointMainArray, _SUTaxiAIVehicleWaypointMainArrayIndexNumber];};//dbg

// Reduce number of available FixedDestinationTaxis TaxiDrivers by one
mgmTfA_gvdb_PV_fixedDestinationTaxisNumberOfCurrentlyAvailableTaxiDriversNumber = mgmTfA_gvdb_PV_fixedDestinationTaxisNumberOfCurrentlyAvailableTaxiDriversNumber - 1;

//Create the vehicle for AI-Service-Unit
_SUTaxiAIVehicleVehicleDirectionInDegreesNumber = (floor (random 361));
_SUTaxiAIVehicleObject = mgmTfA_configgv_fixedDestinationTaxisTaxiVehicleClassnameTextString createVehicle _SUTaxiVehicleSpawnPosition3DArray;
if (mgmTfA_configgv_currentMod == "EPOCH") then {
	_SUTaxiAIVehicleObject call EPOCH_server_setVToken;
	if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_s_FD_fnc_servicePhase03_CreateServiceUnitAndGoToRequestor.sqf]  [TV3]           Server is running EPOCH MOD. Post vehicle creation, setVToken issued to prevent accidental-clean up."];};//dbg
};
_SUTaxiAIVehicleObjectBirthTimeInSecondsNumber = (time);
_SUTaxiAIVehicleObject setFormDir _SUTaxiAIVehicleVehicleDirectionInDegreesNumber;
_SUTaxiAIVehicleObject setDir _SUTaxiAIVehicleVehicleDirectionInDegreesNumber;
_SUTaxiAIVehicleObject setPos getPos _SUTaxiAIVehicleObject;
_SUTaxiAIVehicleObject setVariable ["BIS_enableRandomization", false];
_SUTaxiAIVehicleObject setObjectTextureGlobal [0, mgmTfA_configgv_fixedDestinationTaxisTaxiVehicleActiveColorSchemeTextString];
_SUTaxiAIVehicleObject setFuel 1;
_SUTaxiAIVehicleObject allowDammage false;
_SUTaxiAIVehicleObject addEventHandler ["HandleDamage", {false}];	
_SUTaxiAIVehicleObject setVariable ["isMemberOfTaxiCorpFleet", _SUAIGroup, true];
_SUTaxiAIVehicleObject setVariable ["mgmTfAisfixedDestinationTaxi", true, true];
_SUTaxiAIVehicleObject setVariable ["GUSUIDNumber", _myGUSUIDNumber, true];
_SUTaxiAIVehicleObject setVariable ["commandingCustomerPlayerUIDNumber", _fixedDestinationRequestorPlayerUIDTextString, true];
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUFDServiceFeeNeedToBePaidBool", _myGUSUIDNumber], true];
publicVariable format ["mgmTfA_gv_PV_SU%1SUFDServiceFeeNeedToBePaidBool", _myGUSUIDNumber];
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUVehDoorsLockedBool", _myGUSUIDNumber], _doorsLockedBool];
publicVariable format ["mgmTfA_gv_PV_SU%1SUVehDoorsLockedBool", _myGUSUIDNumber];
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUfdTxPayNowMenuIsCurrentlyNotAttachedBool", _myGUSUIDNumber], true];
publicVariable format ["mgmTfA_gv_PV_SU%1SUfdTxPayNowMenuIsCurrentlyNotAttachedBool", _myGUSUIDNumber];
// NOTE: a FDT will never require "1st Mile Fee" however if we do not set this, when a requestor get out of TA and jump into a FDT it will break the code. To prevent, simply pass a FALSE here.
// mark all Fixed Destination Taxis as "1st Mile need not be paid"
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUTA1stMileFeeNeedToBePaidBool", _myGUSUIDNumber], false];
publicVariable format ["mgmTfA_gv_PV_SU%1SUTA1stMileFeeNeedToBePaidBool", _myGUSUIDNumber];
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
			if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_s_FD_fnc_servicePhase03_CreateServiceUnitAndGoToRequestor.sqf]  [TV3]           Just picked a random name, here is the result... _SUDriversFirstnameTextString is set to: (%1)", _SUDriversFirstnameTextString];};//dbg

		//set AI unit's AI parameters
		_SUAICharacterDriverObject enableAI "TARGET";
		_SUAICharacterDriverObject enableAI "AUTOTARGET";
		_SUAICharacterDriverObject enableAI "MOVE";
		_SUAICharacterDriverObject enableAI "ANIM";
		_SUAICharacterDriverObject enableAI "FSM";
		_SUAICharacterDriverObject allowDammage true;
		_SUAICharacterDriverObject setCombatMode "GREEN";
		_SUAICharacterDriverObject setBehaviour "CARELESS";
		
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
		if(_n==1)then{
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
if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_s_FD_fnc_servicePhase03_CreateServiceUnitAndGoToRequestor.sqf]  [TV3] SPAWN Completed. Vehicle: (%1) | GUSUID: (%2) | Driver: (%3)", _SUTaxiAIVehicleObject, _myGUSUIDNumber, _SUDriversFirstnameTextString];};//dbg

//When setting the waypoint, make a note: How far are we going to go?
_iWantToTravelThisManyMetresNumber = (round (_SUTaxiAIVehicleObject distance _fixedDestinationRequestorPosition3DArray));
if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_s_FD_fnc_servicePhase03_CreateServiceUnitAndGoToRequestor.sqf]  [TV3] current value:   (_iWantToTravelThisManyMetresNumber)=(%1)   ]", _iWantToTravelThisManyMetresNumber];};//dbg
if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_s_FD_fnc_servicePhase03_CreateServiceUnitAndGoToRequestor.sqf]  [TV4] SLEEPing now for %1 seconds before locking doors.", mgmTfA_configgv_timeToSleepBeforeLockingSpawnedFixedDestinationTaxiVehicleDoors];};//dbg
uiSleep mgmTfA_configgv_timeToSleepBeforeLockingSpawnedFixedDestinationTaxiVehicleDoors;
_SUTaxiAIVehicleObject lockDriver true;
//We will unlock it when necessary. For now, no need to unlock it.
_SUTaxiAIVehicleObject lockCargo true;
//Save the new status of vehicleDoorLock
_doorsLockedBool=true;
missionNamespace setVariable [format ["mgmTfA_gv_PV_SU%1SUVehDoorsLockedBool", _myGUSUIDNumber], _doorsLockedBool];
publicVariable format ["mgmTfA_gv_PV_SU%1SUVehDoorsLockedBool", _myGUSUIDNumber];
//check distance to our Current Waypoint (_fixedDestinationRequestorPosition3DArray) and write to server RPT log
_SUTaxiAIVehicleDistanceToWayPointMetersNumber = (round (_SUTaxiAIVehicleObject distance _fixedDestinationRequestorPosition3DArray));
if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_s_FD_fnc_servicePhase03_CreateServiceUnitAndGoToRequestor.sqf]  [TV4] Distance to Waypoint _fixedDestinationRequestorPosition3DArray is: (%1). Locked the doors & going there now.", _SUTaxiAIVehicleDistanceToWayPointMetersNumber];};//dbg
//Change our status to:		1 DRIVING-TO-REQUESTOR		to _fixedDestinationRequestorPosition3DArray
_SUCurrentActionInProgressTextString  = mgmTfA_configgv_currentFixedDestinationTaxiActionInProgressIs01TextString;

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
_SUPickUpPositionPosition3DArray = _fixedDestinationRequestorPosition3DArray;
_SUAIVehicleObject = _SUTaxiAIVehicleObject;
_SUAIVehicleObjectBirthTimeInSecondsNumber = _SUTaxiAIVehicleObjectBirthTimeInSecondsNumber;
_SUDistanceToActiveWaypointInMetersNumber = (round (_SUAIVehicleObject distance _SUActiveWaypointPositionPosition3DArray));
_null = [_myGUSUIDNumber, _SUTypeTextString, _SUActiveWaypointPositionPosition3DArray, _SUCurrentActionInProgressTextString, _SUCurrentTaskThresholdInSecondsNumber, _SUCurrentTaskBirthTimeInSecondsNumber, _SUDriversFirstnameTextString, _SUMarkerShouldBeDestroyedAfterExpiryBool, _SURequestorPlayerUIDTextString, _SURequestorProfileNameTextString, _SUAIVehicleObject, _SUAIVehicleObjectBirthTimeInSecondsNumber, _SUPickUpHasOccurredBool, _SUPickUpPositionPosition3DArray, _SUDropOffPositionHasBeenDeterminedBool, _SUDropOffHasOccurredBool, _SUDropOffPositionPosition3DArray, _SUDropOffPositionNameTextString, _SUTerminationPointPositionHasBeenDeterminedBool, _SUTerminationPointPosition3DArray, _SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray, _SUAIVehicleObjectCurrentPositionPosition3DArray, _SUAIVehicleVehicleDirectionInDegreesNumber, _SUAIVehicleObjectAgeInSecondsNumber, _SUCurrentTaskAgeInSecondsNumber, _SUAIVehicleSpeedOfVehicleInKMHNumber, _SUDistanceToActiveWaypointInMetersNumber] call mgmTfA_s_CO_fnc_publicVariableBroadcastSUInformationInitialBroadcast;
///

// Client Communications - Send the initial "we are processing your request - please wait" message to the Requestor
mgmTfA_gv_pvc_pos_yourFixedDestinationTaxiRequestApprovedDriverEnRoutePacketSignalOnly = ".";
_fixedDestinationRequestorClientIDNumber publicVariableClient "mgmTfA_gv_pvc_pos_yourFixedDestinationTaxiRequestApprovedDriverEnRoutePacketSignalOnly";
if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_s_FD_fnc_servicePhase03_CreateServiceUnitAndGoToRequestor.sqf]  [TV3] SENT RESPONSE    (mgmTfA_gv_pvc_pos_yourFixedDestinationTaxiRequestApprovedDriverEnRoutePacketSignalOnly) to Requestor:  (%1)		on computer (_fixedDestinationRequestorClientIDNumber)=(%2).", _fixedDestinationRequestorProfileNameTextString, _fixedDestinationRequestorClientIDNumber];};//dbg

//We are on the way to requestorPosition to pick up the requestor... We will loop till we are very close to the requestorPosition
_broadcastSUInformationCounter = 0;
//	THIS IS THE OLD CODE. THIS CAUSES DRIVER TO SIGNAL THE REQUESTOR WHILE IN TRANSIT. REQUESTOR ENDS UP RUNNING AFTER THE CAR!!			while {_SUTaxiAIVehicleDistanceToWayPointMetersNumber>20} do {
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
		_SUPickUpPositionPosition3DArray = _fixedDestinationRequestorPosition3DArray;
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
		if (_thisFileVerbosityLevelNumber>=3) then {diag_log format ["[mgmTfA] [mgmTfA_s_FD_fnc_servicePhase03_CreateServiceUnitAndGoToRequestor.sqf] [TV3] Expiry Timeout Threshold Exceeded for SU (%1). Initiating Abnormal SU Termination! _SUCurrentTaskAgeInSecondsNumber is: (%2). _SUCurrentTaskThresholdInSecondsNumber is: (%3).", _myGUSUIDNumber, _SUCurrentTaskAgeInSecondsNumber, _SUCurrentTaskThresholdInSecondsNumber];};
		breakTo "mgmTfA_s_FD_fnc_servicePhase03_CreateServiceUnitAndGoToRequestorMainScope";
	};

	// PING			log only every Nth package			(uiSleep=0.05)		(n=300)  => 	log every 15 seconds
	_counterForLogOnlyEveryNthPINGNumber=_counterForLogOnlyEveryNthPINGNumber+1;
	if (_counterForLogOnlyEveryNthPINGNumber==300) then {
		if (_thisFileVerbosityLevelNumber>=1) then {
			_SUTaxiAIVehicleObjectAgeInSecondsNumber = (round ((time) -_SUTaxiAIVehicleObjectBirthTimeInSecondsNumber));
			diag_log format ["[mgmTfA] [mgmTfA_s_FD_fnc_servicePhase03_CreateServiceUnitAndGoToRequestor.sqf] [TV2] PING from SU Vehicle: (%1) | Driver: (%2) | ServerUpTime: (%3) | MyAge: (%4) | Distance to WP: (%5) metres | Action In Progress: (%6)", _myGUSUIDNumber, _SUDriversFirstnameTextString, (round (time)), _SUTaxiAIVehicleObjectAgeInSecondsNumber, _SUTaxiAIVehicleDistanceToWayPointMetersNumber, _SUCurrentActionInProgressTextString];
		};
		_counterForLogOnlyEveryNthPINGNumber=0;
	};

	// Pit-stop checks: AutoRefuel
	if (fuel _SUTaxiAIVehicleObject < 0.2) then {
		_SUTaxiAIVehicleObject setFuel 1;
		if (_thisFileVerbosityLevelNumber>=2) then {diag_log format ["[mgmTfA] [mgmTfA_s_FD_fnc_servicePhase03_CreateServiceUnitAndGoToRequestor.sqf] [TV2] REFUELing SU Vehicle: (%1) | Driver: (%2) | ServerUpTime: (%3) | MyAge: (%4)", _myGUSUIDNumber, _SUDriversFirstnameTextString, (round (time)), _SUTaxiAIVehicleObjectAgeInSecondsNumber];};//dbg
	};
	
	// Pit-stop checks: AutoRepair
	if (damage _SUTaxiAIVehicleObject>0.2) then {
		_SUTaxiAIVehicleObject setDamage 0;
		if (_thisFileVerbosityLevelNumber>=2) then {diag_log format ["[mgmTfA] [mgmTfA_s_FD_fnc_servicePhase03_CreateServiceUnitAndGoToRequestor.sqf] [TV2] REPAIRing SU Vehicle: (%1) | Driver: (%2) | ServerUpTime: (%3) | MyAge: (%4)", _myGUSUIDNumber, _SUDriversFirstnameTextString, (round (time)), _SUTaxiAIVehicleObjectAgeInSecondsNumber];};//dbg
	};
};
if (_thisFileVerbosityLevelNumber>=4) then {diag_log format ["[mgmTfA] [mgmTfA_s_FD_fnc_servicePhase03_CreateServiceUnitAndGoToRequestor.sqf] [TV4] EXITED LOOP: DrivingToPickUpPointWhileLoop.	Next, SPAWN'ing: (mgmTfA_s_FD_fnc_servicePhase04_PickUpPointAndBeyond)"];};//dbg


// If emergency escape needed:		skip Phase04 & 05 completely and jump to Phase06
// If emergency escape is NOT needed:	proceed to the next Phase
if (!_emergencyEscapeNeeded) then { 
	// proceed to next Phase as per normal
	if (_thisFileVerbosityLevelNumber>=2) then {diag_log format ["[mgmTfA] [mgmTfA_s_FD_fnc_servicePhase03_CreateServiceUnitAndGoToRequestor.sqf] [TV2] <<<reached end-of-file>>>.   no emergency. proceeding with normal next phase in the workflow.			SPAWN'ing (mgmTfA_s_FD_fnc_servicePhase04_PickUpPointAndBeyond)."];};//dbg
	_null = [_fixedDestinationRequestorClientIDNumber, _fixedDestinationRequestorPosition3DArray, _fixedDestinationRequestedTaxiFixedDestinationIDNumber, _fixedDestinationRequestedDestinationNameTextString, _fixedDestinationRequestorPlayerUIDTextString, _fixedDestinationRequestorProfileNameTextString, _myGUSUIDNumber, _iWantToTravelThisManyMetresNumber, _SUTaxiAIVehicleObject, _SUDriversFirstnameTextString, _fixedDestinationRequestedTaxiFixedDestinationPosition3DArray, _doorsLockedBool, _SUAIGroup, _SUTaxiWaypointRadiusInMetersNumber, _SUTaxiAIVehicleObjectBirthTimeInSecondsNumber, _SUTaxiAIVehicleWaypointMainArray, _SUTaxiAIVehicleWaypointMainArrayIndexNumber, _SUAICharacterDriverObject, _SUTypeTextString, _SUDropOffPositionHasBeenDeterminedBool, _SUDropOffPositionNameTextString, _SUDropOffPositionPosition3DArray, _SUDropOffHasOccurredBool, _SUTerminationPointPositionHasBeenDeterminedBool, _SUTerminationPointPosition3DArray, _SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray] spawn mgmTfA_s_FD_fnc_servicePhase04_PickUpPointAndBeyond;
 } else {
	// we have an emergency and we need to shutdown ASAP. forget about the normal workflow next phase(s) and go directly to termination phase!
	if (_thisFileVerbosityLevelNumber>=2) then {diag_log format ["[mgmTfA] [mgmTfA_s_FD_fnc_servicePhase03_CreateServiceUnitAndGoToRequestor.sqf]  [TV2] <<<reached end-of-file>>>.   there is an EMERGENCY therefore skipping Phases 04 & 05 completely 	and SPAWN'ing Phase06 immediately now (mgmTfA_s_FD_fnc_servicePhase06_ToTerminationAndTheEnd.sqf)"];};//dbg
	private	["_requestorPlayerObject"];
	_requestorPlayerObject = objNull;
	_null = [_fixedDestinationRequestorProfileNameTextString, _fixedDestinationRequestorClientIDNumber, _iWantToTravelThisManyMetresNumber, _requestorPlayerObject, _myGUSUIDNumber, _SUAICharacterDriverObject, _SUTaxiAIVehicleObject, _SUTaxiAIVehicleObjectBirthTimeInSecondsNumber, _SUDriversFirstnameTextString, _doorsLockedBool, _SUTaxiAIVehicleWaypointMainArray, _SUTaxiAIVehicleWaypointMainArrayIndexNumber, _SUTaxiWaypointRadiusInMetersNumber, _SUAIGroup, _SUAIVehicleObjectAgeInSecondsNumber, _SUAIVehicleObjectCurrentPositionPosition3DArray, _SUTaxiAIVehicleVehicleDirectionInDegreesNumber, _SUAIVehicleVehicleDirectionInDegreesNumber, _SUAIVehicleSpeedOfVehicleInKMHNumber, _SUPickUpPositionPosition3DArray, _SUAIVehicleObject, _SUAIVehicleObjectBirthTimeInSecondsNumber, _SUDistanceToActiveWaypointInMetersNumber, _SUActiveWaypointPositionPosition3DArray, _SUTypeTextString, _SUMarkerShouldBeDestroyedAfterExpiryBool, _SURequestorPlayerUIDTextString, _SURequestorProfileNameTextString, _SUPickUpHasOccurredBool, _SUDropOffPositionHasBeenDeterminedBool, _SUDropOffHasOccurredBool, _SUDropOffPositionPosition3DArray, _SUDropOffPositionNameTextString, _SUTerminationPointPositionHasBeenDeterminedBool, _SUTerminationPointPosition3DArray, _SUServiceAdditionalRecipientsPUIDAndProfileNameTextStringArray] spawn mgmTfA_s_FD_fnc_servicePhase06_ToTerminationAndTheEnd;
 };
// EOF