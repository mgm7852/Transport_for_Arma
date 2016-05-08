//H
//H ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_fnc_server_returnNearbyRandomOnRoadPosition3DArray.sqf
//H $PURPOSE$	:	This function will choose and a random position within min/max radius range of origin and return the randomly chosen position.
//H ~~
//H
//HH
//HH ~~
//HH	Syntax		:	Array = mgmTfA_fnc_server_returnNearbyRandomOnRoadPosition3DArray RADIUS(number), ORIGIN MARKER(string - "MarkerName")
//HH	Parameters	:
//HH		parameter  0:		RADIUS 			The radius where to randomly place the unit/group within				- number
//HH		parameter  1:		MIN. DISTANCE		The randomly chosen spot MUST not be closer than this value to origin	- number
//HH		parameter  2:		ORIGIN																	- pos: Array - format Position2D
//HH	Return Value	:	Array - format Position3D
//HH	Example usage	:	_outputPosArray = [50, [18396.9,14253.7]] call mgmTfA_fnc_server_returnNearbyRandomOnRoadPosition3DArray;
//HH ~~
//HH
if (!isServer) exitWith {}; if (isNil("mgmTfA_Server_Init")) then {mgmTfA_Server_Init=0;}; waitUntil {mgmTfA_Server_Init==1}; private ["_thisFileVerbosityLevelNumber"]; _thisFileVerbosityLevelNumber = mgmTfA_configgv_serverVerbosityLevel;
scopeName "mgmTfA_fnc_server_returnNearbyRandomOnRoadPosition3DArrayMainScope";
private	[
		"_randomPickRadius",
		"_minDistanceInMeters",
		"_originalPositionArray2D",
		"_direction717",
		"_distance717",
		"_ranPos",
		"_isWater",
		"_isHouse",
		"_isOnRoad",
		"_numberOfAllowedMaxAttempts",
		"_currentAttemptNumber",
		"_iAmInPanic",
		"_typeResult",
		"_originX",
		"_originY",
		"_nearRoadsArray",
		"_fartherThanMinDistanceBool",
		"_distanceBetweenRanPosAndOriginalPositionMeters"
		];

// ~~~~~~~~~~
//Initialization

//Debug level for this file
_thisFileVerbosityLevel = 1;

//Nothing to panic - so far :)
_iAmInPanic = false;

//We will set this to true as soon as we find a "onRoad spot"!
_isOnRoad = false;

//We will set this to true as soon as we find a spot which is farther than Min. Distance parameter and therefore is OKAY to return as the result.
_fartherThanMinDistanceBool = false;

// The default ERROR value for _ranPos -- this is what we will return if we cannot find a suitable position fulfilling requested criteria
_ranPos = [-1,-1,-1];
// ~~~~~~~~~~


// ~~~~~~~~~~
// argument validation:		_randomPickRadius		 		(checks are basic - not definitive!)
_randomPickRadius = (_this select 0);

// _randomPickRadius must be a SCALAR (i.e.: number)
if (typeName _randomPickRadius != "SCALAR") exitWith {
		_typeResult = typeName _randomPickRadius;
		diag_log format ["[mgmTfA] [mgmTfA_fnc_server_returnNearbyRandomOnRoadPosition3DArray.sqf] [ERROR] First parameter (RADIUS) must be a number! (Received: %1)", _typeResult];//dbg
		_ranPos;
};

// _randomPickRadius must be provided and must be greater than zero
if (!(_randomPickRadius >0)) exitWith {
		diag_log format ["[mgmTfA] [mgmTfA_fnc_server_returnNearbyRandomOnRoadPosition3DArray.sqf] [ERROR] _randomPickRadius is nil! (%1). It must be provided as parameter0. Terminating function. Returning empty array.", _randomPickRadius];//dbg
		_ranPos;
};
	if (_thisFileVerbosityLevel>=4) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_returnNearbyRandomOnRoadPosition3DArray.sqf] [TV4] Successfully validated argument _randomPickRadius. _randomPickRadius value is: (%1)", _randomPickRadius]; };//dbg
// ~~~~~~~~~~


// ~~~~~~~~~~
// argument validation:		_minDistanceInMeters	 		(checks are basic - not definitive!)
_minDistanceInMeters = (_this select 1);

// _minDistanceInMeters must be a SCALAR (i.e.: number)
if (typeName _minDistanceInMeters != "SCALAR") exitWith {
	_typeResult = typeName _minDistanceInMeters;
	diag_log format ["[mgmTfA] [mgmTfA_fnc_server_returnNearbyRandomOnRoadPosition3DArray.sqf] [ERROR] Second parameter (MIN. DISTANCE) must be a number! (Received: %1)", _typeResult];//dbg
	_ranPos;
};

// _minDistanceInMeters must be provided and must be greater than zero
if (!(_minDistanceInMeters >0)) exitWith {
	diag_log format ["[mgmTfA] [mgmTfA_fnc_server_returnNearbyRandomOnRoadPosition3DArray.sqf] [ERROR] _minDistanceInMeters is nil! (%1). It must be provided as parameter1. Terminating function. Returning empty array.", _minDistanceInMeters];//dbg
	_ranPos;
};
	if (_thisFileVerbosityLevel>=4) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_returnNearbyRandomOnRoadPosition3DArray.sqf] [TV4] Successfully validated argument _minDistanceInMeters. _minDistanceInMeters value is: (%1)", _minDistanceInMeters]; };//dbg
// ~~~~~~~~~~


// ~~~~~~~~~~
// argument validation:		_originalPositionArray2D 		(checks are basic - not definitive!)
_originalPositionArray2D = (_this select 2);
if (isnil "_originalPositionArray2D") exitWith {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_returnNearbyRandomOnRoadPosition3DArray.sqf] [ERROR] _originalPositionArray2D is nil! It must be passed as parameter2 and must contain ""Array - format Position2D"" (e.g.: [13284.4,14571.6]). Terminating function. Returning empty array."];};//dbg
if (count _originalPositionArray2D == 0) exitWith {
	diag_log format ["[mgmTfA] [mgmTfA_fnc_server_returnNearbyRandomOnRoadPosition3DArray.sqf] [ERROR] _originalPositionArray2D is empty! It must be passed as parameter2 and must contain ""Array - format Position2D"" (e.g.: [13284.4,14571.6]). Terminating function. Returning empty array."];//dbg
	_ranPos;
};
	if (_thisFileVerbosityLevel>=4) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_returnNearbyRandomOnRoadPosition3DArray.sqf] [TV4] Successfully validated argument _originalPositionArray2D. _originalPositionArray2D value is: (%1)", _originalPositionArray2D];};//dbg
// ~~~~~~~~~~


// ~~~~~~~~~~
// MAIN SECTION

// choose a random point in a random direction away from the origin
_direction717 = random 360;

// distance -- the position for random spot pick should be this far away from origin
_distance717 = random _randomPickRadius;
	if (_thisFileVerbosityLevel>=4) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_returnNearbyRandomOnRoadPosition3DArray.sqf] [TV4] random _direction717 is %1. random _distance717 is %2.", _direction717, _distance717]; };//dbg
// generate the random position
_currentAttemptNumber = 0;
_numberOfAllowedMaxAttempts = 99;
	if (_thisFileVerbosityLevel>=4) then {
		diag_log format ["[mgmTfA] [mgmTfA_fnc_server_returnNearbyRandomOnRoadPosition3DArray.sqf] [TV4] _currentAttemptNumber is 1. _numberOfAllowedMaxAttempts is %1", _numberOfAllowedMaxAttempts];//dbg
		_originX = (_originalPositionArray2D select 0);
		_originY = (_originalPositionArray2D select 1);
		diag_log format ["[mgmTfA] [mgmTfA_fnc_server_returnNearbyRandomOnRoadPosition3DArray.sqf] [TV4] originX is: (%1)     originY is: (%2)", _originX, _originY];//dbg
	};
_ranPos = [(_originalPositionArray2D select 0) + _distance717 * sin _direction717, (_originalPositionArray2D select 1) + _distance717 * cos _direction717, 0];
	if (_thisFileVerbosityLevel>=4) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_returnNearbyRandomOnRoadPosition3DArray.sqf] [TV4] _ranPos is %1.", _ranPos];};//dbg
_isWater = surfaceIsWater _ranPos;
_isHouse = _ranPos nearObjects ["House_F",10];
_nearRoadsArray = _ranPos nearRoads 25;
//Measure the distance between _ranPos we just picked and the origin. If it is greater than provided "Min. Distance" argument, then this is true.
_distanceBetweenRanPosAndOriginalPositionMeters=round(_ranPos distance _originalPositionArray2D);
if(_distanceBetweenRanPosAndOriginalPositionMeters>_minDistanceInMeters) then {
	_fartherThanMinDistanceBool=true;
} else {
	_fartherThanMinDistanceBool=false;
};
if (count _nearRoadsArray>0) then {
	_ranPos = getPos (_nearRoadsArray select 0);
	_isOnRoad=true;
};
	if (_thisFileVerbosityLevel>=4) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_returnNearbyRandomOnRoadPosition3DArray.sqf] [TV4] Created the first RanPos. I do not know if it matches the requested criteria (it will be checked in the loop below shortly). Current parameters: numberOfAllowedMaxAttempts=%1. RanPos should be nonWater && nonNearHouse && onRoad. Radius=%2 metres. Origin=%3. Proceeding to the loop.", _numberOfAllowedMaxAttempts, _randomPickRadius, _originalPositionArray2D];};//dbg

/// KEEP PICKING NEW RANDOM POSITIONS TILL WE FIND A "NON-WATER && NON-HOUSE && ON-ROAD && NOT CLOSER THAN MIN DISTANCE" SPOT
while {((_isWater) || (count _isHouse > 0) || (!_isOnRoad) || (!_fartherThanMinDistanceBool))} do {

	// keep track of number of attempts
	_currentAttemptNumber = _currentAttemptNumber + 1;

	// proceed only if we have not exceeded numberOfAllowedMaxAttempts
	if (_currentAttemptNumber > _numberOfAllowedMaxAttempts) then {
		diag_log format ["[mgmTfA] [mgmTfA_fnc_server_returnNearbyRandomOnRoadPosition3DArray.sqf] [TV4] Consumed numberOfAllowedMaxAttempts (%1). Could not find a suitable RanPos within the radius (%2 metres) of origin (%3). Panic Mode: on!.", _numberOfAllowedMaxAttempts, _randomPickRadius, _originalPositionArray2D];//dbg
		_iAmInPanic = true;
		breakTo "mgmTfA_fnc_server_returnNearbyRandomOnRoadPosition3DArrayMainScope";
	};
	
	_direction717 = random 360;
	_distance717 = random _randomPickRadius;
	_ranPos = [(_originalPositionArray2D select 0) + _distance717 * sin _direction717, (_originalPositionArray2D select 1) + _distance717 * cos _direction717, 0];

	_isWater = surfaceIsWater _ranPos;
	_isHouse = _ranPos nearObjects ["House_F",10];
	_nearRoadsArray = _ranPos nearRoads 25;
	//Measure the distance between _ranPos we just picked and the origin. If it is greater than provided "Min. Distance" argument, then this is true.
	_distanceBetweenRanPosAndOriginalPositionMeters=round(_ranPos distance _originalPositionArray2D);
	if(_distanceBetweenRanPosAndOriginalPositionMeters>_minDistanceInMeters) then {
		_fartherThanMinDistanceBool=true;
	} else {
		_fartherThanMinDistanceBool=false;
	};
	if (count _nearRoadsArray>0) then {
		_ranPos = getPos (_nearRoadsArray select 0);
		_isOnRoad=true;
	};
	if (_thisFileVerbosityLevel>=4) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_returnNearbyRandomOnRoadPosition3DArray.sqf] [TV4] Previous RanPos was not matching the active search criteria. Created a new RanPos (this was attemptNo=%1). New RanPos is at: %2. Whether it matches the criteria will be checked shortly.", _currentAttemptNumber, _ranPos];};//dbg
};

if (_iAmInPanic) then {
	// not good
	if (_thisFileVerbosityLevel>=1) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_returnNearbyRandomOnRoadPosition3DArray.sqf] [TV4] PANIC MODE INITIALIZING..."];};//dbg
	
	private	[
			"_bigCounter",
			"_randomPickRadiusOldValue"
			];
	
	_bigCounter = 1;
	// reconfigure number of allowed maximum attempts considerably; set it to 10% of original patience (this might get even more desperate soon - see below)
	_numberOfAllowedMaxAttempts = 10;
	// step up the _randomPickRadius
	_randomPickRadiusOldValue = _randomPickRadius;
	_randomPickRadius = _randomPickRadius + 500;
	
	// reset the attempt counter. this can never hit max limit any more but _bigCounter relies on it to track desperation level.
	_currentAttemptNumber = 0;

	/// KEEP PICKING NEW RANDOM POSITIONS TILL WE FIND A "NON-WATER && NON-HOUSE && ON-ROAD" SPOT
	// note that, in panic mode, we have already dropped the NotfartherThanMinDistance constraint...
	while {((_isWater) || (count _isHouse > 0) || (!_isOnRoad))} do {

		// keep track of number of attempts
		_currentAttemptNumber = _currentAttemptNumber + 1;
		
		// _bigCounter is watching
		if (_currentAttemptNumber == _numberOfAllowedMaxAttempts) then {
			// time for _bigCounter to intervene...
			_bigCounter = _bigCounter + 1;
			_currentAttemptNumber = 0;
			_randomPickRadiusOldValue = _randomPickRadius;
			_randomPickRadius = _randomPickRadius + 250;
			if (_thisFileVerbosityLevel>=4) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_returnNearbyRandomOnRoadPosition3DArray.sqf] [TV4]		_bigCounter has been incremented to: (%1)!		This has occurred after consuming: (%2) MaxAllowedAttempts to find a suitable spot.		We have now also incremented _randomPickRadius from: (%3)	to (%4).", (str _bigCounter), (str _numberOfAllowedMaxAttempts), (str _randomPickRadiusOldValue), (str _randomPickRadius)];};//dbg
		};

		// proceed only if we have not exceeded numberOfAllowedMaxAttempts for _bigCounter (which is 99)
		if (_bigCounter == 99) then {
			diag_log format ["[mgmTfA] [mgmTfA_fnc_server_returnNearbyRandomOnRoadPosition3DArray.sqf] [TV4] _bigCounter hit 99!!!	Could not find a suitable RanPos within the radius (%1 metres) of origin (%3). even in panic mode! double panicked and quitting!", _numberOfAllowedMaxAttempts, _randomPickRadius, _originalPositionArray2D];//dbg
			_iAmInPanic = true;
			breakTo "mgmTfA_fnc_server_returnNearbyRandomOnRoadPosition3DArrayMainScope";
		};
		
		_direction717 = random 360;
		_distance717 = random _randomPickRadius;
		_ranPos = [(_originalPositionArray2D select 0) + _distance717 * sin _direction717, (_originalPositionArray2D select 1) + _distance717 * cos _direction717, 0];

		_isWater = surfaceIsWater _ranPos;
		_isHouse = _ranPos nearObjects ["House_F",10];
		_nearRoadsArray = _ranPos nearRoads 25;
		// won't bother
		//Measure the distance between _ranPos we just picked and the origin. If it is greater than provided "Min. Distance" argument, then this is true.
		//_distanceBetweenRanPosAndOriginalPositionMeters=round(_ranPos distance _originalPositionArray2D);
		//if(_distanceBetweenRanPosAndOriginalPositionMeters>_minDistanceInMeters) then {
		//	_fartherThanMinDistanceBool=true;
		//} else {
		//	_fartherThanMinDistanceBool=false;
		//};
		if (count _nearRoadsArray>0) then {
			_ranPos = getPos (_nearRoadsArray select 0);
			_isOnRoad=true;
		};
	};
};
if (mgmTfA_configgv_serverVerbosityLevel>=3) then {diag_log format ["[mgmTfA] [mgmTfA_fnc_server_returnNearbyRandomOnRoadPosition3DArray.sqf] [TV2] Reached checkpoint: Bottom of function. Returning now. _ranPos array contain: (%1)", (str _ranPos)];};//dbg
//ALL DONE:	Let's return the generated random position in positionArray3D format.
_ranPos;
// EOF