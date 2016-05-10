//H
//HH ~~
//H $FILE$		:	<mission>/custom/mgmTfA/mgmTfA_scr_client_initRegisterClientEventHandlers.sqf
//H $PURPOSE$	:	This server side script registers Event Handlers on server startup.
//HH ~~
//H
"mgmTfA_gv_pvc_pos_processingYourFixedDestinationTaxiRequestPleaseWaitPacketSignalOnly" addPublicVariableEventHandler {
	// initialize local variables
	private [
			"_msg2HintTextString",
			"_msg2SyschatTextString"							
			];
	// We assume, on the client PC "mgmTfA_gv_requestedTaxiFixedDestinationNameTextString" globalVariable is still holding the correct location name	 [it was (switch...do...) determined just few seconds ago]
	_msg2HintTextString = parsetext format ["<img size='6' image='custom\mgmTfA\img_comms\mgmTfA_img_client_pleaseWait.jpg'/><br/><br/><t size='1.40' color='#00FF00'>FIXED DESTINATION<br/>TAXI TO:<br/><br/>%1<br/><br/>PROCESSING REQUEST<br/></t>", mgmTfA_gv_requestedTaxiFixedDestinationNameTextString];
	_msg2SyschatTextString = parsetext format ["FIXED DESTINATION TAXI TO %1.      PROCESSING - PLEASE WAIT", mgmTfA_gv_requestedTaxiFixedDestinationNameTextString];
	hint _msg2HintTextString;
	systemChat (str _msg2SyschatTextString);
};
"mgmTfA_gv_pvc_pos_processingYourclickNGoTaxiRequestPleaseWaitPacketSignalOnly" addPublicVariableEventHandler {
	// initialize local variables
	private [
			"_msg2HintTextString",
			"_msg2SyschatTextString"							
			];
			
	// We assume, on the client PC "mgmTfA_gv_requestedTaxiclickNGoNameTextString" globalVariable is still holding the correct location name	 [it was (switch...do...) determined just few seconds ago]
	_msg2HintTextString = parsetext format ["<img size='6' image='custom\mgmTfA\img_comms\mgmTfA_img_client_pleaseWait.jpg'/><br/><br/><t size='1.40' color='#00FF00'>clickNGo TAXI<br/><br/>PROCESSING REQUEST<br/></t>"];
	_msg2SyschatTextString = parsetext format ["clickNGo TAXI REQUEST.      PROCESSING - PLEASE WAIT"];
	hint _msg2HintTextString;
	systemChat (str _msg2SyschatTextString);
};
"mgmTfA_gv_pvc_pos_yourFixedDestinationTaxiHasArrivedPleaseGetInPacketSignalOnly" addPublicVariableEventHandler {
	// initialize local variables
	private [
			"_msg2HintTextString",
			"_msg2SyschatTextString"							
			];
			
	// We assume, on the client PC "mgmTfA_gv_requestedTaxiFixedDestinationNameTextString" globalVariable is still holding the correct location name	 [it was (switch...do...) determined just few seconds ago]
	_msg2HintTextString = parsetext format["<img size='6' image='custom\mgmTfA\img_comms\mgmTfA_img_client_taxiLetsGo.jpg'/><br/><br/><t size='1.40' color='#00FF00'>%1<br/><br/>YOUR TAXI<br/>HAS ARRIVED<br/><br/>PLEASE GET IN!<br/></t>", (profileName)];
	_msg2SyschatTextString = parsetext format ["%1 YOUR TAXI HAS ARRIVED. PLEASE GET IN!", (profileName)];
	hint _msg2HintTextString;
	systemChat (str _msg2SyschatTextString);
};
"mgmTfA_gv_pvc_pos_yourclickNGoTaxiHasArrivedPleaseGetInPacketSignalOnly" addPublicVariableEventHandler {
	// initialize local variables
	private [
			"_msg2HintTextString",
			"_msg2SyschatTextString"							
			];
			
	// We assume, on the client PC "mgmTfA_gv_requestedTaxiFixedDestinationNameTextString" globalVariable is still holding the correct location name	 [it was (switch...do...) determined just few seconds ago]
	_msg2HintTextString = parsetext format["<img size='6' image='custom\mgmTfA\img_comms\mgmTfA_img_client_taxiLetsGo.jpg'/><br/><br/><t size='1.40' color='#00FF00'>%1<br/><br/>YOUR TAXI<br/>HAS ARRIVED<br/><br/>PLEASE GET IN!<br/></t>", (profileName)];
	_msg2SyschatTextString = parsetext format ["%1 YOUR TAXI HAS ARRIVED. PLEASE GET IN!", (profileName)];
	hint _msg2HintTextString;
	systemChat (str _msg2SyschatTextString);
};
"mgmTfA_gv_pvc_pos_fixedDestinationTaxiDoorsHaveBeenLockedPacketSignalOnly" addPublicVariableEventHandler {
	// initialize local variables
	private [
			"_msg2HintTextString",
			"_msg2SyschatTextString",
			"_classnameOfTheCurrentVehicle"
			];
	//This below is a relevant message only if the player is still in the Taxi vehicle	i.e.: if player ejected/got out, let's NOT send him this message!
	//Get current vehicle's Classname
	_classnameOfTheCurrentVehicle = typeOf (vehicle player);
	//Compare current vehicle's Classname with the pre-defined Taxi Classname, if it matches, message the player. Otherwise do nothing.
	if (mgmTfA_configgv_fixedDestinationTaxisTaxiVehicleClassnameTextString == _classnameOfTheCurrentVehicle) then {
		_msg2HintTextString = parsetext format["<img size='6' image='custom\mgmTfA\img_comms\mgmTfA_img_client_doorsLocked.jpg'/><br/><br/><t size='1.40' color='#00FF00'>%1<br/><br/>DOORS HAVE BEEN LOCKED<br/>FOR YOUR SECURITY<br/>AND SAFETY<br/><br/>THANK YOU<br/><br/></t>", (profileName)];
		_fixedDestinationTaxiDoorsHaveBeenLockedPacketSignalOnlyTex	=	parsetext format ["%1 DOORS HAVE BEEN LOCKED FOR YOUR SECURITY AND SAFETY. THANK YOU.", (profileName)];
		hint _msg2HintTextString;
		systemChat (str _msg2SyschatTextString);
	} else {
		//Player is not in a Taxi vehicle at the moment
		//Do not display anything about Taxi's doors being locked/unlocked
	};
};
"mgmTfA_gv_pvc_pos_clickNGoTaxiDoorsHaveBeenLockedPacketSignalOnly" addPublicVariableEventHandler {
	// initialize local variables
	private [
			"_msg2HintTextString",
			"_msg2SyschatTextString",
			"_classnameOfTheCurrentVehicle"
			];
	//This below is a relevant message only if the player is still in the Taxi vehicle	i.e.: if player ejected/got out, let's NOT send him this message!
	//Get current vehicle's Classname
	_classnameOfTheCurrentVehicle = typeOf (vehicle player);
	//Compare current vehicle's Classname with the pre-defined Taxi Classname, if it matches, message the player. Otherwise do nothing.
	if (mgmTfA_configgv_clickNGoTaxisTaxiVehicleClassnameTextString == _classnameOfTheCurrentVehicle) then {
		_msg2HintTextString = parsetext format["<img size='6' image='custom\mgmTfA\img_comms\mgmTfA_img_client_doorsLocked.jpg'/><br/><br/><t size='1.40' color='#00FF00'>%1<br/><br/>DOORS HAVE BEEN LOCKED<br/>FOR YOUR SECURITY<br/>AND SAFETY<br/><br/>THANK YOU<br/><br/></t>", (profileName)];
		_msg2SyschatTextString = parsetext format ["%1 DOORS HAVE BEEN LOCKED FOR YOUR SECURITY AND SAFETY. THANK YOU.", (profileName)];
		hint _msg2HintTextString;
		systemChat (str _msg2SyschatTextString);
	} else {
		//Player is not in a Taxi vehicle at the moment
		//Do not display anything about Taxi's doors being locked/unlocked
	};
};
"mgmTfA_gv_pvc_pos_clickNGoTaxiDoorsHaveBeenLockedNoHintPacketSignalOnly" addPublicVariableEventHandler {
	// initialize local variables
	private [
			"_msg2SyschatTextString",
			"_classnameOfTheCurrentVehicle"
			];
	//This below is a relevant message only if the player is still in the Taxi vehicle	i.e.: if player ejected/got out, let's NOT send him this message!
	//Get current vehicle's Classname
	_classnameOfTheCurrentVehicle = typeOf (vehicle player);
	//Compare current vehicle's Classname with the pre-defined Taxi Classname, if it matches, message the player. Otherwise do nothing.
	if (mgmTfA_configgv_clickNGoTaxisTaxiVehicleClassnameTextString == _classnameOfTheCurrentVehicle) then {
		_msg2SyschatTextString = parsetext format ["%1 DOORS HAVE BEEN LOCKED FOR YOUR SECURITY AND SAFETY. THANK YOU.", (profileName)];
		systemChat (str _msg2SyschatTextString);
	} else {
		//Player is not in a Taxi vehicle at the moment -- do not display anything about Taxi's doors being locked/unlocked
	};
};
// Fixed Destination Taxi - Doors Unlocked
"mgmTfA_gv_pvc_pos_fixedDestinationTaxiDoorsHaveBeenUnlockedPacketSignalOnly" addPublicVariableEventHandler {
	// initialize local variables
	private [
			"_msg2HintTextString",
			"_msg2SyschatTextString",
			"_classnameOfTheCurrentVehicle"
			];
	
	//This below is a relevant message only if the player is still in the Taxi vehicle	i.e.: if player ejected/got out, let's NOT send him this message!
	//Get current vehicle's Classname
	_classnameOfTheCurrentVehicle = typeOf (vehicle player);
	//Compare current vehicle's Classname with the pre-defined Taxi Classname, if it matches, message the player. Otherwise do nothing.
	if (mgmTfA_configgv_fixedDestinationTaxisTaxiVehicleClassnameTextString == _classnameOfTheCurrentVehicle) then {
		// We assume, on the client PC "mgmTfA_gv_requestedTaxiFixedDestinationNameTextString" globalVariable is still holding the correct location name	 [it was (switch...do...) determined just few seconds ago]
		_msg2HintTextString = parsetext format["<img size='6' image='custom\mgmTfA\img_comms\mgmTfA_img_client_doorsUnlocked.jpg'/><br/><br/><t size='1.40' color='#00FF00'>%1<br/><br/>WE ARE ABOUT TO<br/>REACH %2<br/><br/>DOORS HAVE BEEN<br/>UNLOCKED<br/><br/>THANK YOU<br/><br/></t>", (profileName), mgmTfA_gv_requestedTaxiFixedDestinationNameTextString];
		_msg2SyschatTextString = parsetext format ["%1 WE ARE ABOUT TO REACH %2. DOORS HAVE BEEN UNLOCKED. THANK YOU.", (profileName), mgmTfA_gv_requestedTaxiFixedDestinationNameTextString];
		hint _msg2HintTextString;
		systemChat (str _msg2SyschatTextString);
	} else {
		//Player is not in a Taxi vehicle at the moment
		//Do not display anything about Taxi's doors being locked/unlocked
	};
};
// Fixed Destination Taxi - Doors Unlocked
"mgmTfA_gv_pvc_pos_clickNGoTaxiDoorsHaveBeenUnlockedPacketSignalOnly" addPublicVariableEventHandler {
	// initialize local variables
	private [
			"_msg2HintTextString",
			"_msg2SyschatTextString",
			"_classnameOfTheCurrentVehicle"
			];
	
	//This below is a relevant message only if the player is still in the Taxi vehicle	i.e.: if player ejected/got out, let's NOT send him this message!
	//Get current vehicle's Classname
	_classnameOfTheCurrentVehicle = typeOf (vehicle player);
	//Compare current vehicle's Classname with the pre-defined Taxi Classname, if it matches, message the player. Otherwise do nothing.
	if (mgmTfA_configgv_clickNGoTaxisTaxiVehicleClassnameTextString == _classnameOfTheCurrentVehicle) then {
		// We assume, on the client PC "mgmTfA_gv_requestedTaxiclickNGoNameTextString" globalVariable is still holding the correct location name	 [it was (switch...do...) determined just few seconds ago]
		_msg2HintTextString = parsetext format["<img size='6' image='custom\mgmTfA\img_comms\mgmTfA_img_client_doorsUnlocked.jpg'/><br/><br/><t size='1.40' color='#00FF00'>%1<br/><br/>WE ARE ABOUT TO<br/>REACH OUR DESTINATION<br/><br/>DOORS HAVE BEEN<br/>UNLOCKED<br/><br/>THANK YOU<br/><br/></t>", (profileName)];
		_msg2SyschatTextString = parsetext format ["%1 WE ARE ABOUT TO REACH OUR DESTINATION. DOORS HAVE BEEN UNLOCKED. THANK YOU.", (profileName)];
		hint _msg2HintTextString;
		systemChat (str _msg2SyschatTextString);
	} else {
		//Player is not in a Taxi vehicle at the moment
		//Do not display anything about Taxi's doors being locked/unlocked
	};
		
};
"mgmTfA_gv_pvc_pos_yourFixedDestinationTaxiRequestApprovedDriverEnRoutePacketSignalOnly" addPublicVariableEventHandler {
	// initialize local variables
	private [
			"_msg2HintTextString",
			"_msg2SyschatTextString"
			];
			
	// We assume, on the client PC "mgmTfA_gv_requestedTaxiFixedDestinationNameTextString" globalVariable is still holding the correct location name	 [it was (switch...do...) determined just few seconds ago]
	_msg2HintTextString = parsetext format ["<img size='6' image='custom\mgmTfA\img_comms\mgmTfA_img_client_taxiApproved.jpg'/><br/><br/><t size='1.40' color='#00FF00'>%1<br/><br/>TAXI REQUEST TO<br/>%2<br/><br/>APPROVED<br/><br/>DRIVER EN ROUTE<br/><br/></t>", (profileName), mgmTfA_gv_requestedTaxiFixedDestinationNameTextString];
	_msg2SyschatTextString = parsetext format ["%1 TAXI REQUEST TO %2 APPROVED.     DRIVER EN ROUTE", (profileName), mgmTfA_gv_requestedTaxiFixedDestinationNameTextString];
	hint _msg2HintTextString;
	systemChat (str _msg2SyschatTextString);
};
"mgmTfA_gv_pvc_pos_yourclickNGoTaxiRequestApprovedDriverEnRoutePacketSignalOnly" addPublicVariableEventHandler {
	// initialize local variables
	private [
			"_msg2HintTextString",
			"_msg2SyschatTextString"
			];
			
	// We assume, on the client PC "mgmTfA_gv_requestedTaxiclickNGoNameTextString" globalVariable is still holding the correct location name	 [it was (switch...do...) determined just few seconds ago]
	_msg2HintTextString = parsetext format ["<img size='6' image='custom\mgmTfA\img_comms\mgmTfA_img_client_taxiApproved.jpg'/><br/><br/><t size='1.40' color='#00FF00'>%1<br/><br/>CLICKNGO<br/>TAXI REQUEST APPROVED<br/><br/>DRIVER EN ROUTE<br/><br/></t>", (profileName)];
	_msg2SyschatTextString = parsetext format ["%1 CLICKNGO TAXI REQUEST APPROVED.     DRIVER EN ROUTE", (profileName)];
	hint _msg2HintTextString;
	systemChat (str _msg2SyschatTextString);
};
"mgmTfA_gv_pvc_pos_yourFixedDestinationTaxiHaveArrivedThankYouForYourBusinessHaveANiceDayPacket" addPublicVariableEventHandler {
	// initialize local variables
	private [
			"_msg2HintTextString",
			"_msg2SyschatTextString",
			"_classnameOfTheCurrentVehicle"
			];
			
	// Comparing only 'Classname' is not good enough because Requestor might have ejected the original vehicle and later got on a DIFFERENT TfA vehicle, in which case we should not inform him that his previous TfA vehicle has reached its destination!
	// We must compare GUSUID to be 100% sure that we are sending a relevant "we have arrived!" notification!
	
	// This below is a relevant message only if the player is still in the Taxi vehicle	i.e.: if player ejected/got out, let's NOT send him this message!
	// Get current vehicle's Classname
	_classnameOfTheCurrentVehicle = typeOf (vehicle player);
	_originalVehiclesGUSUIDNumber = (_this select 1);
	_currentVehiclesGUSUIDNumber = ((vehicle player) getVariable "GUSUIDNumber");
	if (mgmTfA_configgv_clientVerbosityLevel>=4) then {diag_log format ["[mgmTfA] [mgmTfA_scr_client_initRegisterClientEventHandlers.sqf]  [D3]          I have received mgmTfA_gv_pvc_pos_yourFixedDestinationTaxiHaveArrivedThankYouForYourBusinessHaveANiceDayPacket package. _this is: (%1).", (str _this)];};
	if (mgmTfA_configgv_clientVerbosityLevel>=4) then {diag_log format ["[mgmTfA] [mgmTfA_scr_client_initRegisterClientEventHandlers.sqf]  [D3]          I have received mgmTfA_gv_pvc_pos_yourFixedDestinationTaxiHaveArrivedThankYouForYourBusinessHaveANiceDayPacket package. the (str _originalVehiclesGUSUIDNumber) is: (%1)	(str _currentVehiclesGUSUIDNumber) is: (%2).", (str _originalVehiclesGUSUIDNumber), (str _currentVehiclesGUSUIDNumber)];};
	
	//Compare current vehicle's Classname with the pre-defined Taxi Classname, if it matches, message the player. Otherwise do nothing.
	if ((mgmTfA_configgv_fixedDestinationTaxisTaxiVehicleClassnameTextString == _classnameOfTheCurrentVehicle) && (_originalVehiclesGUSUIDNumber == _currentVehiclesGUSUIDNumber)) then {
		// We assume, on the client PC "mgmTfA_gv_requestedTaxiFixedDestinationNameTextString" globalVariable is still holding the correct location name	 [it was (switch...do...) determined just few seconds ago]
		_msg2HintTextString = parsetext format["<img size='8' image='custom\mgmTfA\img_comms\mgmTfA_img_client_thankYouForYourBusinessHaveANiceDay.jpg'/><br/><br/><t size='1.40' color='#00FF00'>%1<br/><br/>WE HAVE ARRIVED<br/>%2<br/><br/>THANK YOU FOR<br/>CHOOSING TAXI CORP<br/><br/>HAVE A NICE DAY!<br/><br/></t>", (profileName), mgmTfA_gv_requestedTaxiFixedDestinationNameTextString];
		_msg2SyschatTextString = parsetext format["%1 WE HAVE ARRIVED %2. THANK YOU FOR CHOOSING TAXI CORP. HAVE A NICE DAY!", (profileName), mgmTfA_gv_requestedTaxiFixedDestinationNameTextString];
		hint _msg2HintTextString;
		systemChat (str _msg2SyschatTextString);
	} else {
		//Player is not in a Taxi vehicle at the moment
		//Do not display anything about Taxi's doors being locked/unlocked
	};
};
"mgmTfA_gv_pvc_pos_yourclickNGoTaxiHaveArrivedThankYouForYourBusinessHaveANiceDayPacket" addPublicVariableEventHandler {
	// initialize local variables
	private [
			"_msg2HintTextString",
			"_msg2SyschatTextString",
			"_classnameOfTheCurrentVehicle"
			];
			
	// Comparing only 'Classname' is not good enough because Requestor might have ejected the original vehicle and later got on a DIFFERENT TfA vehicle, in which case we should not inform him that his previous TfA vehicle has reached its destination!
	// We must compare GUSUID to be 100% sure that we are sending a relevant "we have arrived!" notification!
	
	// This below is a relevant message only if the player is still in the Taxi vehicle	i.e.: if player ejected/got out, let's NOT send him this message!
	// Get current vehicle's Classname
	_classnameOfTheCurrentVehicle = typeOf (vehicle player);
	_originalVehiclesGUSUIDNumber = (_this select 1);
	_currentVehiclesGUSUIDNumber = ((vehicle player) getVariable "GUSUIDNumber");
	if (mgmTfA_configgv_clientVerbosityLevel>=4) then {diag_log format ["[mgmTfA] [mgmTfA_scr_client_initRegisterClientEventHandlers.sqf]  [D3]          I have received mgmTfA_gv_pvc_pos_yourclickNGoTaxiHaveArrivedThankYouForYourBusinessHaveANiceDayPacket package. _this is: (%1).", (str _this)];};
	if (mgmTfA_configgv_clientVerbosityLevel>=4) then {diag_log format ["[mgmTfA] [mgmTfA_scr_client_initRegisterClientEventHandlers.sqf]  [D3]          I have received mgmTfA_gv_pvc_pos_yourclickNGoTaxiHaveArrivedThankYouForYourBusinessHaveANiceDayPacket package. the (str _originalVehiclesGUSUIDNumber) is: (%1)	(str _currentVehiclesGUSUIDNumber) is: (%2).", (str _originalVehiclesGUSUIDNumber), (str _currentVehiclesGUSUIDNumber)];};
	
	//Compare current vehicle's Classname with the pre-defined Taxi Classname, if it matches, message the player. Otherwise do nothing.
	if ((mgmTfA_configgv_clickNGoTaxisTaxiVehicleClassnameTextString == _classnameOfTheCurrentVehicle) && (_originalVehiclesGUSUIDNumber == _currentVehiclesGUSUIDNumber)) then {
		// We assume, on the client PC "mgmTfA_gv_requestedTaxiFixedDestinationNameTextString" globalVariable is still holding the correct location name	 [it was (switch...do...) determined just few seconds ago]
		_msg2HintTextString = parsetext format["<img size='8' image='custom\mgmTfA\img_comms\mgmTfA_img_client_thankYouForYourBusinessHaveANiceDay.jpg'/><br/><br/><t size='1.40' color='#00FF00'>%1<br/><br/>WE HAVE ARRIVED<br/>AT OUR DESTINATION<br/><br/>THANK YOU FOR<br/>CHOOSING TAXI CORP<br/><br/>HAVE A NICE DAY!<br/><br/></t>", (profileName)];
		_msg2SyschatTextString = parsetext format["%1 WE HAVE ARRIVED AT OUR DESTINATION. THANK YOU FOR CHOOSING TAXI CORP. HAVE A NICE DAY!", (profileName)];
		hint _msg2HintTextString;
		systemChat (str _msg2SyschatTextString);
	} else {
		//Player is not in a Taxi vehicle at the moment
		//Do not display anything about Taxi's doors being locked/unlocked
	};	
	// delete the clickNGoTaxi Chosen Position Marker
	deleteMarker "clickNGoTaxiChosenPosition";
	// once player exits clickNGo taxi, allow player to use clickNGoHotKey again
	mgmTfA_dynamicgv_thisPlayerCanOrderclickNGoTaxiViaHotkey = true;
};
"mgmTfA_gv_pvc_neg_yourFixedDestinationTaxiRequestHasBeenRejectedAsYouAreBlacklistedPacketSignalOnly" addPublicVariableEventHandler {
	// initialize local variables
	private [
			"_msg2HintTextString",
			"_msg2SyschatTextString"
			];
			
	// We assume, on the client PC "mgmTfA_gv_requestedTaxiFixedDestinationNameTextString" globalVariable is still holding the correct location name	 [it was (switch...do...) determined just few seconds ago]
	_msg2HintTextString = parsetext format ["<img size='6' image='custom\mgmTfA\img_comms\mgmTfA_img_client_blacklist.jpg'/><br/><br/><t size='1.40' color='#00FF00'>SORRY %1<br/><br/>WE CANNOT<br/>SERVE YOU!<br/></t>", (profileName)];
	_msg2SyschatTextString = parsetext format ["SORRY %1 YOU ARE BLACKLISTED - WE CANNOT SERVE YOU!", (profileName)];
	hint _msg2HintTextString;
	systemChat (str _msg2SyschatTextString);
};
"mgmTfA_gv_pvc_neg_yourclickNGoTaxiRequestHasBeenRejectedAsYouAreBlacklistedPacketSignalOnly" addPublicVariableEventHandler {
	// initialize local variables
	private [
			"_msg2HintTextString",
			"_msg2SyschatTextString"
			];
			
	// We assume, on the client PC "mgmTfA_gv_requestedTaxiFixedDestinationNameTextString" globalVariable is still holding the correct location name	 [it was (switch...do...) determined just few seconds ago]
	_msg2HintTextString = parsetext format ["<img size='6' image='custom\mgmTfA\img_comms\mgmTfA_img_client_blacklist.jpg'/><br/><br/><t size='1.40' color='#00FF00'>SORRY %1<br/><br/>WE CANNOT<br/>SERVE YOU!<br/></t>", (profileName)];
	_msg2SyschatTextString = parsetext format ["SORRY %1 YOU ARE BLACKLISTED - WE CANNOT SERVE YOU!", (profileName)];
	hint _msg2HintTextString;
	systemChat (str _msg2SyschatTextString);
};
//// Add PublicVariableEventHandler for mgmTfA_gvdb_PV_GUSUIDNumber
"mgmTfA_gvdb_PV_GUSUIDNumber" addPublicVariableEventHandler {
	scopeName "mgmTfA_gvdb_PV_GUSUIDNumberMainScope";
	
	private	[
			"_uid",
			"_aclMatchFound",
			"_totalOmniscienceGroupMatchFound",
			"_quickEscapeNow"
			];
	//// There is a new SU in service. Determine whether to map-track it.
	_uid = (getPlayerUID player);
	_totalOmniscienceGroupMatchFound = false;
	_quickEscapeNow = false;
	// check for BYPASS:	mgmTfA_configgv_makeAllMarkersPublicIWantZeroPrivacyAndSecurityBool		// if this is enabled, respond to every single request with "a member of Total Omniscience found!"
	if (mgmTfA_configgv_makeAllMarkersPublicIWantZeroPrivacyAndSecurityBool) then {
		_totalOmniscienceGroupMatchFound = true;
		if (mgmTfA_configgv_clientVerbosityLevel>=2) then {diag_log format ["[mgmTfA] [mgmTfA_scr_client_initRegisterClientEventHandlers.sqf] [TV2] A _totalOmniscienceGroupMatchFound has been found due to mgmTfA_configgv_makeAllMarkersPublicIWantZeroPrivacyAndSecurityBool. Launching mgmTfA_fnc_client_doLocalMarkerWork.sqf as totalOmniscienceGroup member to continuously map-track the new SU until Termination Stage!"];};
		[mgmTfA_gvdb_PV_GUSUIDNumber, true] spawn mgmTfA_fnc_client_doLocalMarkerWork;
		// Now let's send this client to map-tracker with the information that he is a TO member
	};
	// FIRST TRAVERSE TOTAL OMNISCIENCE GROUP.	=> 	IF A MATCH IS FOUND, call map-tracker script with the information that we are sending a Total Omniscience group  member so that it will not revoke authorization right after  Drop Off.
	// Prep work for Total Omniscience traversing
	if (mgmTfA_configgv_clientVerbosityLevel>=3) then {diag_log format ["[mgmTfA] [mgmTfA_scr_client_initRegisterClientEventHandlers.sqf] [TV3] Will start traversing Total Omniscience group in the next line."];};
	{
		if(_quickEscapeNow) then {	breakTo "mgmTfA_gvdb_PV_GUSUIDNumberMainScope";	};
		scopeName "totalOmniscienceGroupTraverseScope";
		// compare my PUID with the current PUID in array. 
		//	if current entry does not match, proceed with the next one
		//	if current entry does match, issue "_yesIShouldTrackThisSU = true"; 	and breakTo mgmTfA_gvdb_PV_GUSUIDNumberMainScope
		//	if no entries match, end routine, as there is nothing to be done
		if (_uid == _x) then {
			if (mgmTfA_configgv_clientVerbosityLevel>=4) then {diag_log format ["[mgmTfA] [mgmTfA_scr_client_initRegisterClientEventHandlers.sqf] [TV4] totalOmniscienceGroup match found - local computer is to track!"];};//dbg
			_totalOmniscienceGroupMatchFound = true;
			breakOut "totalOmniscienceGroupTraverseScope";
		} else {
		};
	} forEach mgmTfA_configgv_totalOmniscienceGroupTextStringArray;
	// So how did it go?
	if (_totalOmniscienceGroupMatchFound) then {
		if(_quickEscapeNow) then {	breakTo "mgmTfA_gvdb_PV_GUSUIDNumberMainScope";	};
									if (mgmTfA_configgv_clientVerbosityLevel>=1) then {diag_log format ["[mgmTfA] [mgmTfA_scr_client_initRegisterClientEventHandlers.sqf]          About to execVM mgmTfA_fnc_client_doLocalMarkerWork. I will pass the following mgmTfA_gvdb_PV_GUSUIDNumber: (%1)", mgmTfA_gvdb_PV_GUSUIDNumber];};//dbg
		//THIS SHOULD CALL A FUNCTION - NOT A SCRIPT!
		[mgmTfA_gvdb_PV_GUSUIDNumber, true] spawn mgmTfA_fnc_client_doLocalMarkerWork;
		// Now let's send this client to map-tracker with the information that he is a TO member
		} else {
			if(_quickEscapeNow) then {	breakTo "mgmTfA_gvdb_PV_GUSUIDNumberMainScope";	};
			// OK this client is NOT a member of TO but maybe he is the requestor? SUACL can tell us...
			private	["_suIDACLContents"];
			// NOW TRAVERSE SU ACL.	=> 	IF A MATCH IS FOUND, call map-tracker script with the information that we are sending a non-Total Omniscience group  member so that it MUST revoke authorization right after  Drop Off.
			_aclMatchFound = false;
			_suID = _this select 1;
			_suIDACLContents = call compile format ["mgmTfA_gv_PV_SU%1SUACLTextStringArray", _suID];
			{
				scopeName "mgmTfA_gvdb_PV_GUSUIDNumberTraverseACLScope";
				// compare my PUID with the current PUID in array. 
				//	if current entry does not match, proceed with the next one
				//	if current entry does match, issue "_yesIShouldTrackThisSU = true"; 	and breakTo mgmTfA_gvdb_PV_GUSUIDNumberMainScope
				//	if no entries match, end routine, as there is nothing to be done
				if (_uid == _x) then {
					_aclMatchFound = true;
					breakOut "mgmTfA_gvdb_PV_GUSUIDNumberTraverseACLScope";
				} else {
				};
			} forEach _suIDACLContents;
		};
	// So how did it go?
	if (_aclMatchFound) then {
		if(_quickEscapeNow) then {	breakTo "mgmTfA_gvdb_PV_GUSUIDNumberMainScope";	};
		[mgmTfA_gvdb_PV_GUSUIDNumber, false] spawn mgmTfA_fnc_client_doLocalMarkerWork;
	};
};
"mgmTfA_gv_pvc_req_fixedDestinationTaxiPleasePayTheServiceFeePacketSignalOnly" addPublicVariableEventHandler {
	// initialize local variables
	private [
			"_msg2HintTextString",
			"_msg2SyschatTextString"
			];
			
	// We assume, on the client PC "mgmTfA_gv_requestedTaxiFixedDestinationNameTextString" globalVariable is still holding the correct location name	 [it was (switch...do...) determined just few seconds ago]
	_msg2HintTextString = parsetext format ["<img size='6' image='custom\mgmTfA\img_comms\mgmTfA_img_client_taxiPleasePay.jpg'/><br/><br/><t size='1.40' color='#00FF00'>Greetings<br/>%1<br/><br/><br/>PLEASE PAY:<br/>%2 CRYPTO<br/><br/>FOR:<br/>%3 METRES<br/><br/>TO:<br/>%4<br/><br/>THANKS!<br/><br/></t>", (profileName), (str mgmTfA_dynamicgv_journeyServiceFeeCostInCryptoNumber), (str mgmTfA_dynamicgv_journeyTotalDistanceInMetersNumber), mgmTfA_gv_requestedTaxiFixedDestinationNameTextString];
	_msg2SyschatTextString = parsetext format ["Greetings %1 PLEASE PAY: %2 CRYPTO  FOR %3 METRES TO: %4. THANKS!", (profileName), (str mgmTfA_dynamicgv_journeyServiceFeeCostInCryptoNumber), (str mgmTfA_dynamicgv_journeyTotalDistanceInMetersNumber), mgmTfA_gv_requestedTaxiFixedDestinationNameTextString];
	hint _msg2HintTextString;
	systemChat (str _msg2SyschatTextString);
};
"mgmTfA_gv_pvc_pos_thanksForFixedDestinationTaxiPaymentWeAreLeavingNowPacketSignalOnly" addPublicVariableEventHandler {
	// initialize local variables
	private [
			//"_msg2HintTextString",
			"_msg2SyschatTextString"
			];
	// We assume, on the client PC "mgmTfA_gv_requestedTaxiFixedDestinationNameTextString" globalVariable is still holding the correct location name	 [it was (switch...do...) determined just few seconds ago]
	// THIS HINT BOX WAS BEING OVERRIDEN BY 'DOORS LOCKED HINT BOX' thus player never actually saw this one. As a quick hack HINT version of the message is now commented out & image file deleted to save space. Might add it one day with a solution...
	//_msg2HintTextString = parsetext format["<img size='6' image='custom\mgmTfA\img_comms\mgmTfA_img_client_taxiPaymentReceivedManyThanks.jpg'/><br/><br/><t size='1.40' color='#00FF00'>%1<br/><br/>THANK YOU<br/>FOR THE PAYMENT<br/><br/>WE ARE NOW HEADING OUT TO:<br/>%2.<br/><br/>HERE SOME GOOD OLD<br/>COUNTRY MUSIC - ENJOY!</t><br/><br/><img size='6' image='custom\mgmTfA\img_comms\mgmTfA_img_client_taxiGreatMusic.jpg'/><br/>", (profileName), mgmTfA_gv_requestedTaxiFixedDestinationNameTextString];
	_msg2SyschatTextString = parsetext format ["%1 THANK YOU FOR THE PAYMENT. WE ARE NOW HEADING OUT TO %2. HERE SOME GOOD OLD COUNTRY MUSIC - ENJOY!", (profileName), mgmTfA_gv_requestedTaxiFixedDestinationNameTextString];
	//hint _msg2HintTextString;
	systemChat 		(str _msg2SyschatTextString);
		
};
"mgmTfA_gv_pvc_pos_yourclickNGoPAYGTickCostChargeRequestActionedPacketSignalOnly" addPublicVariableEventHandler {
	// initialize local variables
	private	[
			"_msg2HintTextString",
			"_msg2SyschatTextString",
			"_playerActualCashBalance"
			];
	//it seems we always show the "pre-transaction balance" for some reason. maybe it's due to communication delay? let's try doing the calculation on this side and show the result
	_playerActualCashBalance = EPOCH_playerCrypto - mgmTfA_configgv_clickNGoTaxisTickCostInCryptoNumber;
	// inform the player via Hint 	-- only if the global config allows
	if (mgmTfA_configgv_clickNGoTaxisDisplayTickChargeHintMessageBool) then {
		// display hint messages requested -- let's do that	// let the customer know that he just has been charged $amount
		private	["_msg2HintTextString"];
		_msg2HintTextString = parsetext format ["<img size='6' image='custom\mgmTfA\img_comms\mgmTfA_img_client_taxiPaymentReceivedManyThanks.jpg'/><br/><br/><t size='1.40' color='#00FF00'>%1<br/><br/>YOU JUST PAID THE<br/>PAYG TICK FEE:<br/><br/>%2 CRYPTO<br/><br/><br/><br/>YOUR NEW<br/>CASH BALANCE:<br/><br/>%3 CRYPTO<br/><br/>", (profileName), (str mgmTfA_configgv_clickNGoTaxisTickCostInCryptoNumber), (str _playerActualCashBalance)];
		hint _msg2HintTextString;
	};
	// inform the player via systemChat 	-- only if the global config allows
	if (mgmTfA_configgv_clickNGoTaxisDisplayTickChargeSystemChatMessageBool) then {
		// display systemChat messages requested -- let's do that	// let the customer know that he just has been charged $amount
		private	["_messageTextOnlyFormat"];
		// same issue as above! _messageTextOnlyFormat = parsetext format ["%1 YOU JUST PAID THE PAYG TICK FEE: %2 CRYPTO. THANK YOU FOR THE PAYMENT! YOUR NEW CASH BALANCE: %3 CRYPTO", (profileName), (str mgmTfA_configgv_clickNGoTaxisTickCostInCryptoNumber), (str EPOCH_playerCrypto)];
		_messageTextOnlyFormat = parsetext format ["%1 YOU JUST PAID THE PAYG TICK FEE: %2 CRYPTO. THANK YOU FOR THE PAYMENT! YOUR NEW CASH BALANCE: %3 CRYPTO", (profileName), (str mgmTfA_configgv_clickNGoTaxisTickCostInCryptoNumber), (str _playerActualCashBalance)];
		systemChat (str _messageTextOnlyFormat);
	};
	/*
					NOT IMPLEMENTED
					NOT IMPLEMENTED
					NOT IMPLEMENTED
						// inform the player via cutText 	-- only if the global config allows
						if (mgmTfA_configgv_clickNGoTaxisDisplayTickChargeCutTextMessageBool) then {
							// display systemChat messages requested -- let's do that	// let the customer know that he just has been charged $amount
							private	["_messageTextOnlyFormat"];
							_messageTextOnlyFormat = parsetext format ["%1 YOU JUST PAID THE PAYG TICK FEE: %2 CRYPTO. THANK YOU FOR THE PAYMENT! YOUR NEW CASH BALANCE: %3 CRYPTO", (profileName), (str mgmTfA_configgv_clickNGoTaxisTickCostInCryptoNumber), (str EPOCH_playerCrypto)];
							systemChat 		(str _messageTextOnlyFormat);
						};
					NOT IMPLEMENTED
					NOT IMPLEMENTED
					NOT IMPLEMENTED
	*/
};
"mgmTfA_gv_pvc_pos_yourclickNGoPAYGInitialBookingFeeChargeRequestActionedPacketSignalOnly" addPublicVariableEventHandler {
	// initialize local variables
	private [
			"_msg2HintTextString",
			"_msg2SyschatTextString"
			];
	// inform the player via Hint		-- let the customer know that he just has been charged $amount
	private	["_msg2HintTextString"];
	_msg2HintTextString = parsetext format ["<img size='6' image='custom\mgmTfA\img_comms\mgmTfA_img_client_taxiPaymentReceivedManyThanks.jpg'/><br/><br/><t size='1.40' color='#00FF00'>%1<br/><br/>YOU JUST PAID THE<br/>PAYG BOOKING FEE:<br/><br/>%2 CRYPTO<br/><br/><br/><br/>YOUR NEW<br/>CASH BALANCE:<br/><br/>%3 CRYPTO<br/><br/>", (profileName), (str mgmTfA_configgv_clickNGoTaxisNonRefundableBookingFeeCostInCryptoNumber), (str EPOCH_playerCrypto)];
	hint _msg2HintTextString;
	// inform the player via systemChat 	-- only if the global config allows
	// display systemChat messages requested -- let's do that	// let the customer know that he just has been charged $amount
	private	["_messageTextOnlyFormat"];
	_messageTextOnlyFormat = parsetext format ["%1 YOU JUST PAID THE PAYG BOOKING FEE: %2 CRYPTO. THANK YOU FOR THE PAYMENT! YOUR NEW CASH BALANCE: %3 CRYPTO", (profileName), (str mgmTfA_configgv_clickNGoTaxisNonRefundableBookingFeeCostInCryptoNumber), (str EPOCH_playerCrypto)];
	systemChat 		(str _messageTextOnlyFormat);
	/*
					NOT IMPLEMENTED
					NOT IMPLEMENTED
					NOT IMPLEMENTED
						// inform the player via cutText 	-- only if the global config allows
						if (mgmTfA_configgv_clickNGoTaxisDisplayTickChargeCutTextMessageBool) then {
							// display systemChat messages requested -- let's do that	// let the customer know that he just has been charged $amount
							private	["_messageTextOnlyFormat"];
							_messageTextOnlyFormat = parsetext format ["%1 YOU JUST PAID THE PAYG TICK FEE: %2 CRYPTO. THANK YOU FOR THE PAYMENT! YOUR NEW CASH BALANCE: %3 CRYPTO", (profileName), (str mgmTfA_configgv_clickNGoTaxisTickCostInCryptoNumber), (str EPOCH_playerCrypto)];
							systemChat 		(str _messageTextOnlyFormat);
						};
					NOT IMPLEMENTED
					NOT IMPLEMENTED
					NOT IMPLEMENTED
	*/
};
/*
DUPLICATE - DELETE THIS BLOCK
DUPLICATE - DELETE THIS BLOCK
DUPLICATE - DELETE THIS BLOCK
DUPLICATE - DELETE THIS BLOCK
																				"mgmTfA_gv_pvc_req_TAPleasePay1stMileFeePacketSignalOnly" addPublicVariableEventHandler {
																					// initialize local variables
																					private [
																							"_msg2HintTextString",
																							"_msg2SyschatTextString"
																							];
																					_msg2HintTextString = parsetext format ["<img size='6' image='custom\mgmTfA\img_comms\mgmTfA_img_client_taxiPleasePay1stMileFee.jpg'/><br/><br/><t size='1.40' color='#00FF00'>Greetings<br/>%1<br/><br/><br/>PLEASE PAY<br/>THE 1ST MILE FEE<br/>%2 CRYPTO<br/><br/><br/>THANKS!<br/><br/></t>", (profileName), (str mgmTfA_configgv_clickNGoTaxisAbsoluteMinimumJourneyFeeInCryptoNumber)];
																					_msg2SyschatTextString = parsetext format ["Greetings %1 PLEASE PAY THE 1ST MILE FEE: %2 CRYPTO. THANKS!", (profileName), (str mgmTfA_configgv_clickNGoTaxisAbsoluteMinimumJourneyFeeInCryptoNumber)];
																					hint _msg2HintTextString;
																					systemChat (str _msg2SyschatTextString);
																				};
																				"mgmTfA_gv_pvc_pos_TAYouJustPaid1stMileFeePacketSignalOnly" addPublicVariableEventHandler {
																					// initialize local variables
																					private	[
																							"_msg2HintTextString",
																							"_msg2SyschatTextString"
																							];
																					// inform the player via Hint		-- let the customer know that he just has been charged $amount
																					private	["_msg2HintTextString"];
																					_msg2HintTextString = parsetext format ["<img size='6' image='custom\mgmTfA\img_comms\mgmTfA_img_client_taxiPaymentReceivedManyThanks.jpg'/><br/><br/><t size='1.40' color='#00FF00'>%1<br/><br/>YOU JUST PAID THE<br/>1ST MILE FEE:<br/><br/>%2 CRYPTO<br/><br/><br/><br/>YOUR NEW<br/>CASH BALANCE:<br/><br/>%3 CRYPTO<br/><br/>", (profileName), (str mgmTfA_configgv_clickNGoTaxisAbsoluteMinimumJourneyFeeInCryptoNumber), (str EPOCH_playerCrypto)];
																					hint _msg2HintTextString;
																					// inform the player via systemChat 	-- only if the global config allows
																					// display systemChat messages requested -- let's do that	// let the customer know that he just has been charged $amount
																					private	["_messageTextOnlyFormat"];
																					_messageTextOnlyFormat = parsetext format ["%1 YOU JUST PAID THE 1ST MILE FEE: %2 CRYPTO. THANK YOU FOR THE PAYMENT! YOUR NEW CASH BALANCE: %3 CRYPTO", (profileName), (str mgmTfA_configgv_clickNGoTaxisAbsoluteMinimumJourneyFeeInCryptoNumber), (str EPOCH_playerCrypto)];
																					systemChat 		(str _messageTextOnlyFormat);
																					// IDEA/TODO:	inform the player via cutText 	-- only if the global config allows
																				};
*/
"mgmTfA_gv_pvc_pos_yourTaxiAnywhere1stMileFeeChargeRequestActionedPacketSignalOnly" addPublicVariableEventHandler {
	// initialize local variables
	private	[
			"_msg2HintTextString",
			"_msg2SyschatTextString",
			"_playerActualCashBalance"
			];
	//it seems we always show the "pre-transaction balance" for some reason. maybe it's due to communication delay? let's try doing the calculation on this side and show the result
	_playerActualCashBalance = EPOCH_playerCrypto - mgmTfA_configgv_clickNGoTaxisAbsoluteMinimumJourneyFeeInCryptoNumber;
	// inform the player via Hint 	-- only if the global config allows
	if (true) then {
		// not a config option yet - just go ahead & inform the player
		private	["_msg2HintTextString"];
		_msg2HintTextString = parsetext format ["<img size='6' image='custom\mgmTfA\img_comms\mgmTfA_img_client_taxiPaymentReceivedManyThanks.jpg'/><br/><br/><t size='1.40' color='#00FF00'>%1<br/><br/>YOU JUST PAID<br/>TAXI-ANYWHERE<br/>1ST MILE FEE:<br/><br/>%2 CRYPTO<br/><br/>THANK YOU FOR THE PAYMENT<br/><br/>YOUR NEW<br/>CASH BALANCE:<br/><br/>%3 CRYPTO<br/><br/>", (profileName), (str mgmTfA_configgv_clickNGoTaxisAbsoluteMinimumJourneyFeeInCryptoNumber), (str _playerActualCashBalance)];
		hint _msg2HintTextString;
	};
	// inform the player via systemChat 	-- only if the global config allows
	if (true) then {
		// not a config option yet - just go ahead & inform the player
		private	["_messageTextOnlyFormat"];
		_messageTextOnlyFormat = parsetext format ["YOU JUST PAID THE TAXI-ANYWHERE 1ST MILE FEE: %2 CRYPTO. THANK YOU FOR THE PAYMENT. YOUR NEW CASH BALANCE: %3 CRYPTO.", (profileName), (str mgmTfA_configgv_clickNGoTaxisAbsoluteMinimumJourneyFeeInCryptoNumber), (str _playerActualCashBalance)];
		systemChat (str _messageTextOnlyFormat);
	};
	/*	NOT IMPLEMENTED	- add cutText option here? */
};
"mgmTfA_gv_pvc_req_pleaseBeginPurchasingPowerCheckAndPAYGChargeForTimeTicksSignalOnly" addPublicVariableEventHandler {
	private	[
			"_GUSUIDNumberOfTheCurrentVehicle",
			"_classnameOfTheCurrentVehicle"						
			];
	// The requested action is relevant only if player is still in the mentioned clickNGo Taxi vehicle	i.e.: if player ejected/got out, let's NOT send him this message!	//Compare current vehicle's Classname with the pre-defined Taxi Classname, if it matches, message the player. Otherwise do nothing.
	_classnameOfTheCurrentVehicle = typeOf (vehicle player);
	_GUSUIDNumberOfTheCurrentVehicle									= ((vehicle player) getVariable "GUSUIDNumber");
	if (mgmTfA_configgv_clientVerbosityLevel>=4) then {diag_log format ["[mgmTfA] [mgmTfA_scr_client_initRegisterClientEventHandlers.sqf]  [V4]          I have received mgmTfA_gv_pvc_req_pleaseBeginPurchasingPowerCheckAndPAYGChargeForTimeTicksSignalOnly package. _this is: (%1).		(str _GUSUIDNumberOfTheCurrentVehicle) is: (%2).", (str _this), (str _GUSUIDNumberOfTheCurrentVehicle)];};
	if (_classnameOfTheCurrentVehicle == mgmTfA_configgv_clickNGoTaxisTaxiVehicleClassnameTextString) then {
		// yes, player is still in a clickNGo vehicle -- quite possibly the same one!	launch the function [_GUSUIDNumberReceivedFromServer] mgmTfA_fnc_client_purchasingPowerCheckAndPAYGChargeForTimeTicks;
		if (mgmTfA_configgv_clientVerbosityLevel>=4) then {diag_log format ["[mgmTfA] [mgmTfA_scr_client_initRegisterClientEventHandlers.sqf]  [V4]          I have determined that player is in the matching vehicle. I will now SPAWN (mgmTfA_fnc_client_purchasingPowerCheckAndPAYGChargeForTimeTicks)."];};
		_null = [_GUSUIDNumberOfTheCurrentVehicle] spawn mgmTfA_fnc_client_purchasingPowerCheckAndPAYGChargeForTimeTicks;
	} else {
		// no, player is no longer in the mentioned vehicle -- do nothing
		if (mgmTfA_configgv_clientVerbosityLevel>=4) then {diag_log format ["[mgmTfA] [mgmTfA_scr_client_initRegisterClientEventHandlers.sqf]  [V4]          I have determined that player is NOT in the matching vehicle. I will NOT spawn (mgmTfA_fnc_client_purchasingPowerCheckAndPAYGChargeForTimeTicks)."];};
	};	
};
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ code - begin ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// SYNOPSIS: Player press INS (INSERT) key. eventHandler added via this file detect the keypress and do the following:
//	1. update the timestamp for last INS key press -- so that player won't be able to accidentally (or on purpose) order several taxis to his position. =
//		Note that server will ALSO check the last request from a certain player and if it is found to be "too soon" after the last request, server will not progress the request.
//		The purpose of doing this here is reducing network traffic and load on the server.
//	n. next, check if the player has a radio in his inventory or personal gear
//		if he does have one - progress to the next step.
//		if he does not have one - kill the request and `hint` him why.
//	n. we send the request to the server, asking for a taxi to players current position.
//DIK_INSERT 	[Ins] 	0xD2 	210 	[Insert] on arrow keypad 
// https://resources.bisimulations.com/wiki/DIK_KeyCodes
private ["_execmgmTfA_null_client_clickNGoRequestTaxi"];
mgmTfA_EHInsertKeyDown = (findDisplay 46) displayAddEventHandler ["KeyDown", "if (_this select 1 == mgmTfA_configgv_clickNGoCallATaxiHotkeyDIKCodeNumber) then	{_execmgmTfA_null_client_clickNGoRequestTaxi	= [] spawn mgmTfA_fnc_client_clickNGoRequestTaxi;}"];
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ code - end ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// clickNGo Set Course Key and EH
private ["_execmgmTfA_null_client_clickNGoSetCourse"];
mgmTfA_EHNumPadMultiplyKeyDown = (findDisplay 46) displayAddEventHandler ["KeyDown", "if (_this select 1 == mgmTfA_configgv_clickNGoSetCourseHotkeyDIKCodeNumber) then	{_execmgmTfA_null_client_clickNGoSetCourse	= [] spawn mgmTfA_fnc_client_clickNGoSetCourse;}"];
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ END OF FILE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if (mgmTfA_configgv_clientVerbosityLevel>=2) then {diag_log format ["[mgmTfA][mgmTfA_scr_client_initRegisterClientEventHandlers.sqf] END reading file."];};//dbg
// EOF