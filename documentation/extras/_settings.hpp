//--------------------------------------------------------------------------------
//
// POST-IT
// this should be 0 for production systems and greater when debugging // WARNING:	possibly massive output, if you leave this on, on a production system it WILL impact performance
mgmTfA_configgv_serverAndClientDebugVerbosityLevel										= 0;
//--------------------------------------------------------------------------------




//HEADER
//HEADER ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//HEADER $FILE$		:	<mission>/custom/mgmTfA/_settings.hpp
//HEADER $PURPOSE$	:	This is the shared masterConfiguration file, both server & clients will be aware of & rely on the values herein.
//HEADER ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//HEADER

//--------------------------------------------------------------------------------
// EXPIRY TIMEOUT THRESHOLDS		Anti DoS :)
//
// Players may not place multiple bookings in succession.
//
// Note: Lowering this, in MP game with a busy server, might cause issues due to client>server>client packet flow and CURRENT_JOB_ID desync // fixed with the rewrite in 0.2 branch?
//
mgmTfA_configgv_minimumWaitingTimeBetweenFixedDestinationTaxiBookingsInSecondsNumber		= 900;
mgmTfA_configgv_minimumWaitingTimeBetweenclickNGoTaxiBookingsInSecondsNumber			= 900;
// If this is false, a player who just joined the server will have to wait out the duration minimumWaitingTimeBetween*BookingsInSecondsNumber
mgmTfA_configgv_FixedDestinationTaxiBookingFirstTimersCanBookWithoutWaitingBool				= true;
// If this is false, a player who just joined the server will have to wait out the duration minimumWaitingTimeBetween*BookingsInSecondsNumber
mgmTfA_configgv_clickNGoTaxiBookingFirstTimersCanBookWithoutWaitingBool					= true;

// We do not want any single player to be able to press clickNGoHotkey multiple times & book all available clickNGo Taxis.
// This is practically a DoS, as it will prevent other players from booking one of the limited number of clickNGo Taxis.
//
// To prevent the above, when a player activate the clickNGoHotkey, a Cooldown Period will be in effect and player has to wait out before regaining access to clickNGoHotkey
//
// Default = 900 seconds (15 minutes)
mgmTfA_configgv_clickNGoTaxiBookingHotkeyCooldownDurationInSecondsNumber				= 900;

// This is used in mgmTfA_fnc_client_doLocalJanitorWorkForclickNGo.sqf
// Normally this is 5 minutes (= 300 seconds)
mgmTfA_configgv_clickNGoJanitorSleepDurationInSecondsNumber							= 300;

// When a player join the game, Janitor process will sleep a random amount of seconds before it starts it duty. With the settings below, the random duration will be Min=24 seconds & Max=48 seconds.
mgmTfA_configgv_clickNGoJanitorInitialRandomSleepDurationMinimumBaseInSecondsNumber			= 24;
mgmTfA_configgv_clickNGoJanitorInitialRandomSleepDurationMinimumAdditionInSecondsNumber		= 24;

mgmTfA_dynamicgv_clickNGoTaxiDisplayInstructionsOnGetInEnabledBool						= true;

//	method #1:	show popup first time, in the future, show memory refresher as hint
//	method #2:	always show as popup
//	method #3:	always show as hint
mgmTfA_dynamicgv_clickNGoTaxiDisplayInstructionsOnGetInDisplayMethodNumber				= 1;
mgmTfA_dynamicgv_clickNGoTaxiReDisplayInstructionsOnGetInTimeThresholdInSecondsNumber		= 300;
//--------------------------------------------------------------------------------

//--------------------------------------------------------------------------------
// BASIC SETTINGS

// ONLY 'EPOCH' IMPLEMENTED. 
// IF NOT EXACTLY 'EPOCH', (1) PAYMENT SYSTEM WON'T WORK.  (2) TFA VEHICLES WON'T GET EPOCH VTOKEN ON SPAWN.
//Game/Mode Setup
mgmTfA_configgv_currentMod														= "EPOCH"			;
//mgmTfA_configgv_currentMod="NOTEPOCH";

//Company - New Owner Name
//		If you have bought the Taxi Corp company on your server, feel free to rename it :)
//
//		Note: [This will be] Referred by a lot of files when interacting with players. If you set this to a really long value CLIENT COMMS will take an aesthetic hit. Keep it short.
//
// NOT IMPLEMENTED YET
mgmTfA_configgv_taxiCorpNewOwnerNameTextString="Shoreditch Minicabs";

//Establish Headquarters?		(i.e.: create the building in 3D game world yes/no)
// 		Referred by mgmTfA_scr_serverInitCreateObjectHQBuilding.sqf when creating the building
mgmTfA_configgv_establishTaxiCorpHqBool												= true				;

//HQ Location
// 		Referred by mgmTfA_scr_serverInitCreateObjectHQBuilding.sqf when creating the building
//		Change at your risk. We don't do any collision checks when spawning this building
mgmTfA_configgv_taxiCorpHqLocationPositionArray										= [13225.562,14755.877]	;

//HQ Building Object Class ID
//		Referred by mgmTfA_scr_serverInitCreateObjectHQBuilding.sqf when create the building
mgmTfA_configgv_taxiCorpHqBuildingObjectClassIDTextString								= "Land_Airport_Tower_F"	;

//HQ Map Marker Settings
//	These are referred by mgmTfA_scr_sharedInitCreateHQMapMarker.sqf
//	HQ 	Create Map Marker?
mgmTfA_configgv_createTaxiCorpHqLocationMapMarkerBool									= true				;

//	HQ	Map Marker Text
mgmTfA_configgv_taxiCorpHqLocationMapMarkerTextString									= "Taxi Corp HQ"		;

//	HQ	Map Marker Color
mgmTfA_configgv_taxiCorpHqLocationMapMarkerColorTextString								= "ColorBlack"			;

//	HQ	Map Marker Type
mgmTfA_configgv_taxiCorpHqLocationMapMarkerTypeTextString								= "mil_dot"			;

//	HQ	Map Marker Shape
mgmTfA_configgv_taxiCorpHqLocationMapMarkerShapeTextString								= "ICON"				;
//--------------------------------------------------------------------------------

//--------------------------------------------------------------------------------
//How often should the clients check whether a CATP is nearby?
//uiSleep will be used to wait for the next one.
mgmTfA_configgv_catpCheckFrequencySecondsNumber=2.5;
//--------------------------------------------------------------------------------

// --------------------------------------------------------------------------------
// CATP (CALL A TAXI POINT) SETTINGS
// These are referred by createMapMarker scripts

// --------------------------------------------------------------------------------
// Define Shared Settings for all CATPs Here

// detection range to activate "NEAR CATP" status
mgmTfA_configgv_catpObjectDetectionRangeInMeters=10;

// detection object that activates "NEAR A CATP" status
//mgmTfA_configgv_catpObject="Land_cargo_house_slum_f";

//this below did spawn correctly in Epoch
//WORKING:	
mgmTfA_configgv_catpObject="C_man_polo_1_F";
// --------------------------------------------------------------------------------

// --------------------------------------------------------------------------------
// Settings for CATP01
//
// Create Callpoint?			(i.e.: create the physical structure in 3D game world: yes/no)
// 		Referred by mgmTfA_scr_serverInitCreateObjectHQBuilding.sqf when creating the building
mgmTfA_configgv_createObjectCatp01Bool=true;
// CATP01 Location
// 		Referred by mgmTfA_scr_serverInitCreateObjectHQBuilding.sqf when creating the building
//		Change at your risk. We don't do any collision checks when spawning this building
mgmTfA_configgv_catp01LocationPositionArray=[13287.2,14572.1,0];
// this below was supposed to make it look at trader but he's looking the other way!
mgmTfA_configgv_catp01DirectionDegreesNumber=131;
// CATP01	Create marker?
mgmTfA_configgv_createCatp01LocationMapMarkerBool=true;
// CATP01	Map Marker Type
mgmTfA_configgv_catp01LocationMapMarkerTypeTextString="mil_dot";
// CATP01	Map Marker Shape
mgmTfA_configgv_catp01LocationMapMarkerShapeTextString="ICON";
// CATP01	Map Marker Color
mgmTfA_configgv_catp01LocationMapMarkerColorTextString="ColorOrange";
// CATP01	Map Marker Text
mgmTfA_configgv_catp01LocationMapMarkerTextString="Central Taxis";
// --------------------------------------------------------------------------------

// --------------------------------------------------------------------------------
// Settings for CATP02
//
// Create Callpoint?			(i.e.: create the physical structure in 3D game world yes/no)
// 		Referred by mgmTfA_scr_serverInitCreateObjectHQBuilding.sqf when creating the building
mgmTfA_configgv_createObjectCatp02Bool=true;
// CATP02 Location
// 		Referred by mgmTfA_scr_serverInitCreateObjectHQBuilding.sqf when creating the building
//		Change at your risk. We don't do any collision checks when spawning this building
mgmTfA_configgv_catp02LocationPositionArray=[6141.08,16787.6];
// CATP02	Create marker?
mgmTfA_configgv_createCatp02LocationMapMarkerBool=true;
// CATP02	Map Marker Type
mgmTfA_configgv_catp02LocationMapMarkerTypeTextString="mil_dot";
// CATP02	Map Marker Shape
mgmTfA_configgv_catp02LocationMapMarkerShapeTextString="ICON";
// CATP02	Map Marker Color
mgmTfA_configgv_catp02LocationMapMarkerColorTextString="ColorOrange";
// CATP02	Map Marker Text
mgmTfA_configgv_catp02LocationMapMarkerTextString="West Taxis";
// --------------------------------------------------------------------------------

// --------------------------------------------------------------------------------
// Settings for CATP03
//
// Create Callpoint?			(i.e.: create the physical structure in 3D game world yes/no)
// 		Referred by mgmTfA_scr_serverInitCreateObjectHQBuilding.sqf when creating the building
mgmTfA_configgv_createObjectCatp03Bool=true;
// CATP03 Location
// 		Referred by mgmTfA_scr_serverInitCreateObjectHQBuilding.sqf when creating the building
//		Change at your risk. We don't do any collision checks when spawning this building
mgmTfA_configgv_catp03LocationPositionArray=[18396.9,14253.7];
// CATP03	Create marker?
mgmTfA_configgv_createCatp03LocationMapMarkerBool=true;
// CATP03	Map Marker Type
mgmTfA_configgv_catp03LocationMapMarkerTypeTextString="mil_dot";
// CATP03	Map Marker Shape
mgmTfA_configgv_catp03LocationMapMarkerShapeTextString="ICON";
// CATP03	Map Marker Color
mgmTfA_configgv_catp03LocationMapMarkerColorTextString="ColorOrange";
// CATP03	Map Marker Text
mgmTfA_configgv_catp03LocationMapMarkerTextString="East Taxis";
// --------------------------------------------------------------------------------

//--------------------------------------------------------------------------------
//TAXI CORP HR DEPARTMENT SETTINGS
//
//Total Number of Taxi Drivers
//Number of concurrent taxi drivers that will be serving customers at any particular moment in time. A driver who finished his customer drop off will not poop-magic-insta disappear.
//He will first drive away from dropped off passenger [and away from any other players] and only then, in a lone-spot, despawn himself and his car.
//
//This process can take some time... Provide a slightly higher number than your actual "intended concurrent active drivers"  due to the reason explained [if unsure, for starters, add 2 extra and tweak later].
//
//Examples situations when a driver could be (in-game) && (in-vehicle) && (without passenger in his car) BUT be UNAVAILABLE nevertheless. 
// 		Example 1: Driver is driving to the requestorLocation to pick up a passenger -- In HQs Fleet Management system this driver will still appear as BUSY.
// 		Example 2: Driver, after completing serving a customer, start driving to self_destruction_point -- In HQs Fleet Management system this driver will still appear as BUSY.
mgmTfA_dynamicgv_READ_DURING_SERVER_INIT_fixedDestinationTaxisNumberOfAvailableTaxiDriversOnStartNumber		= 5;
mgmTfA_dynamicgv_READ_DURING_SERVER_INIT_clickNGoTaxisNumberOfAvailableTaxiDriversOnStartNumber			= 5;
//--------------------------------------------------------------------------------



//--------------------------------------------------------------------------------//--------------------------------------------------------------------------------//--------------------------------------------------------------------------------//
//	ACCESS LISTS		//--------------------------------------------------------------------------------//--------------------------------------------------------------------------------//------------------------------------------------//
//--------------------------------------------------------------------------------//--------------------------------------------------------------------------------//--------------------------------------------------------------------------------//
//Permanently Blacklisted Entries
//

//TaxiCorp Fixed Destination Taxis will not serve any players with the following playerUIDs.		They must have pissed off an admin! :(
mgmTfA_dynamicgv_READ_DURING_SERVER_INIT_fixedDestinationTaxisBlacklistedPlayerPUIDsTextStringArray		=	[
																							"76666666666666666"					,
//																							"76561198124251001"					,
																							"76000000000000500"					
																							];

//TaxiCorp clickNGo Taxis will not serve any players with the following playerUIDs.			They must have pissed off an admin! :(
mgmTfA_dynamicgv_READ_DURING_SERVER_INIT_clickNGoTaxisBlacklistedPlayerPUIDsTextStringArray =				[
																							"76666666666666666"					,
//																							"76561198124251001"					,
																							"76000000000000500"					
																							];
//--------------------------------------------------------------------------------
// Total Omniscience pUIDs Array
// playerUIDs in this array will know everything that can be known: every single service unit, why it is there [serving which player], which direction it is facing, what it is doing [waiting/moving], how fast travelling, where is it going and so on
// The reason this is split from the above is that in some cases an admin might wish to retain his capacity to control the system without actually receiving too  many notifications/map markers.
mgmTfA_configgv_totalOmniscienceGroupTextStringArray												=	[
																							"76561198070011111"					,
																							"76561198124251001"					,
																							"76561198070022222"					,
																							"76561198070033333"					,
																							"76561198070044444"					,
																							"76561198070055555"					,
																							"76561198070066666"					
																							];
//--------------------------------------------------------------------------------
// NOT IMPLEMENTED
//
// Admin pUIDs Array
// SteamID64 list of admins.		admins can do magic things like:	pull ex nihilo taxi when there are zero available drivers, get a free ride, offer a free ride and so on.
//
// NOTHING ABOUT ADMINS IMPLEMENTED YET.  totalOmniscience however *is* implemented, so add yourself there to have access to global map-tracking of Service Units.
//
//I BELIEVE THIS IS NOT IN USE							mgmTfA_configgv_adminsGroupTextStringArray =		[
//I BELIEVE THIS IS NOT IN USE																		"76561198070088888",
//I BELIEVE THIS IS NOT IN USE																		"76561198070099999"
//I BELIEVE THIS IS NOT IN USE																		];
//--------------------------------------------------------------------------------


//--------------------------------------------------------------------------------
mgmTfA_configgv_timeToSleepBeforeLockingSpawnedFixedDestinationTaxiVehicleDoors 						= 5										;
mgmTfA_configgv_timeToSleepBeforeLockingSpawnedclickNGoVehicleDoors									= 5										;
//--------------------------------------------------------------------------------

//--------------------------------------------------------------------------------
//Static Text Entries
//TODO: Move to LANGUAGE_EN.SQF file && add language selection at the very top of configuration file
// Current Action In Progress for: fixedDestination Taxis
mgmTfA_configgv_currentFixedDestinationTaxiActionInProgressIs00TextString								= "Awaiting Init Clearance"						;
mgmTfA_configgv_currentFixedDestinationTaxiActionInProgressIs01TextString								= "Driving to Requestor"						;
mgmTfA_configgv_currentFixedDestinationTaxiActionInProgressIs02TextString								= "Awaiting Get In"							;
mgmTfA_configgv_currentFixedDestinationTaxiActionInProgressIs03TextString								= "Awaiting Payment"							;
mgmTfA_configgv_currentFixedDestinationTaxiActionInProgressIs04TextString								= "Driving to Requested Destination"				;
mgmTfA_configgv_currentFixedDestinationTaxiActionInProgressIs05TextString								= "Awaiting Get Off"							;
mgmTfA_configgv_currentFixedDestinationTaxiActionInProgressIs06TextString								= "Driving to Termination"						;
mgmTfA_configgv_currentFixedDestinationTaxiActionInProgressIs07TextString								= "At Termination"							;
mgmTfA_configgv_currentFixedDestinationTaxiActionInProgressIs08TextString								= "Terminated (Map Marker In Deletion Queue)"		;
// Current Action In Progress for: clickNGo Taxis
mgmTfA_configgv_currentclickNGoTaxiActionInProgressIs00TextString										= "Awaiting Init Clearance"						;
mgmTfA_configgv_currentclickNGoTaxiActionInProgressIs01TextString										= "Driving to Requestor"						;
mgmTfA_configgv_currentclickNGoTaxiActionInProgressIs02TextString										= "Awaiting Get In"							;
mgmTfA_configgv_currentclickNGoTaxiActionInProgressIs03TextString										= "Awaiting Payment"							;
mgmTfA_configgv_currentclickNGoTaxiActionInProgressIs04TextString										= "Driving to Requested Destination"				;
mgmTfA_configgv_currentclickNGoTaxiActionInProgressIs05TextString										= "Awaiting Get Off"							;
mgmTfA_configgv_currentclickNGoTaxiActionInProgressIs06TextString										= "Driving to Termination"						;
mgmTfA_configgv_currentclickNGoTaxiActionInProgressIs07TextString										= "At Termination"							;
mgmTfA_configgv_currentclickNGoTaxiActionInProgressIs08TextString										= "Terminated (Map Marker In Deletion Queue)"		;
//--------------------------------------------------------------------------------

//--------------------------------------------------------------------------------
//Taxi Vehicle Settings for Fixed Destination Taxi Service
mgmTfA_configgv_fixedDestinationTaxisTaxiVehicleClassnameTextString									= "C_Offroad_01_F"							;
mgmTfA_configgv_clickNGoTaxisTaxiVehicleClassnameTextString											= "C_Offroad_01_F"							;
//
// Define Vehicle Color Options here		http://www.rapidtables.com/web/color/RGB_Color.htm			http://www.colorpicker.com/
// #(argb,8,8,3)color(R,G,B,A), where R,G,B stands for Red, Green, Blue, and A stands for Alpha, all values can be anything between 0 and 1 (including decimals)
mgmTfA_configgv_fixedDestinationTaxisVehicleColorObjectTextureGlobalTextStringYellow1						= "#(rgb,8,8,3)color(255,255,0,0.8)"				;
mgmTfA_configgv_fixedDestinationTaxisVehicleColorObjectTextureGlobalTextStringRed1							= "#(rgb,8,8,3)color(255,0,0,1)"					;
//
mgmTfA_configgv_clickNGoTaxisVehicleColorObjectTextureGlobalTextStringYellow1							= "#(rgb,8,8,3)color(255,255,0,0.8)"				;
mgmTfA_configgv_clickNGoTaxisVehicleColorObjectTextureGlobalTextStringRed1								= "#(rgb,8,8,3)color(255,0,0,1)"					;
//
// Set the active color option here; use one of the options above [or add your own option there]
mgmTfA_configgv_fixedDestinationTaxisTaxiVehicleActiveColorSchemeTextString								= mgmTfA_configgv_fixedDestinationTaxisVehicleColorObjectTextureGlobalTextStringYellow1;
mgmTfA_configgv_clickNGoTaxisTaxiVehicleActiveColorSchemeTextString									= mgmTfA_configgv_clickNGoTaxisVehicleColorObjectTextureGlobalTextStringYellow1;
//--------------------------------------------------------------------------------

//--------------------------------------------------------------------------------
// EXPIRY TIMEOUT THRESHOLDS
mgmTfA_configgv_expiryTimeOutThresholdfixedDestinationTaxiOnTheWayToPickingUpRequestorInSecondsNumber		= 180									;
mgmTfA_configgv_expiryTimeOutThresholdclickNGoTaxiOnTheWayToPickingUpRequestorInSecondsNumber			= 180									;
//
mgmTfA_configgv_expiryTimeOutThresholdfixedDestinationTaxiRequestorIsNotHereInSecondsNumber				= 90										;
mgmTfA_configgv_expiryTimeOutThresholdclickNGoTaxiRequestorIsNotHereInSecondsNumber					= 90										;
//
mgmTfA_configgv_expiryTimeOutThresholdfixedDestinationTaxiRequestorOutsideVehicleInSecondsNumber			= 90										;
mgmTfA_configgv_expiryTimeOutThresholdclickNGoTaxiRequestorOutsideVehicleInSecondsNumber					= 90										;
//
mgmTfA_configgv_expiryTimeOutThresholdfixedDestinationTaxiRequestorHasNotPaidInSecondsNumber				= 90										;
mgmTfA_configgv_expiryTimeOutThresholdclickNGoTaxiRequestorHasNotPaidInSecondsNumber					= 90										;
//
mgmTfA_configgv_expiryTimeOutThresholdfixedDestinationTaxiOnTheWayToDropOffInSecondsNumber				= 900									;
mgmTfA_configgv_expiryTimeOutThresholdclickNGoTaxiOnTheWayToDropOffInSecondsNumber					= 900									;
//
mgmTfA_configgv_expiryTimeOutThresholdfixedDestinationTaxiRequestorInsideVehicleInSecondsNumber				= 90										;
mgmTfA_configgv_expiryTimeOutThresholdclickNGoTaxiRequestorInsideVehicleInSecondsNumber					= 90										;
//
mgmTfA_configgv_expiryTimeOutThresholdfixedDestinationTaxiOnTheWayToTerminationInSecondsNumber			= 240									;
mgmTfA_configgv_expiryTimeOutThresholdclickNGoTaxiOnTheWayToTerminationInSecondsNumber					= 240									;
//--------------------------------------------------------------------------------

//--------------------------------------------------------------------------------
// CLICKNGO SERVICE SPECIFIC SETTINGS

// clickNGo Miscellaneous Settings
// Define the key to be used for the action: "Call-a-Taxi-to-my-position"		// This is used for Click-N-Go Taxi Service Mode
// 		https://resources.bisimulations.com/wiki/DIK_KeyCodes
//DIK_INSERT 	[Ins] 	0xD2 	210 	[Insert] on arrow keypad 
mgmTfA_configgv_clickNGoCallATaxiHotkeyDIKCodeNumber											= 210									;
//DIK_MULTIPLY 	[*] 	0x37 	55 	[*] on numeric keypad 
//DIK_DIVIDE 	[Num/] 	0xB5 	181 	[/] on numeric keypad 
mgmTfA_configgv_clickNGoSetCourseHotkeyDIKCodeNumber											= 55										;
// Whatever 'SetCourseHotkey' you define with the above DIK code will be communicated to customers when they get in (in the INSTRUCTIONS screen) just like this =>		"You may press * key to set a new destination at any time",
// So we need to know how to refer to that key you define above. Put it's "TextRepresentation" below [examples.: "INSERT" or "NumPad+" and so on]
mgmTfA_configgv_clickNGoSetCourseHotkeyTextRepresentationTextString									= "*"									;
//
// Workaround for:	"Epoch AntiHack is blocking my hotkey for non-admins!" issue
// TfA can now monitor 'openMap' command and take it as the pre-agreed signal that player request a clickNGo Taxi to his position. If enabled (and constraints below fulfilled), this will have exactly the same effect of player pressing the "clickNGo Call a Taxi Hotkey" meaning cooldowns, first timer settings etc. are in effect // default=yes
mgmTfA_configgv_clickNGoOpenMapCommandMonitoringEnabledBool										= true									;
// If the openMap command is issued this many times (within time frame below), TfA will be convinced that player is signalling us
mgmTfA_configgv_clickNGoOpenMapCommandMonitoringThisMustBeTheSignalThresholdMapOpenedNTimesNumber		= 3										;
// Whatever number you set above, you should add as many "Zero-And-A-Comma"s below
mgmTfA_configgv_clickNGoOpenMapCommandMonitoringThisMustBeTheSignalTurnThePage						= [0,0,0]									;
// Whatever number you set above should happen within a time range of this many seconds otherwise it will not qualify as 'The Signal'
mgmTfA_configgv_clickNGoOpenMapCommandMonitoringThisMustBeTheSignalThresholdMapOpenedNTimesInSecsNumber	= 8										;
//--------------------------------------------------------------------------------
//
mgmTfA_configgv_fixedDestinationTaxisSpinBeforeDeletionBool											= true									;
mgmTfA_configgv_clickNGoTaxisSpinBeforeDeletionBool												= true									;
//
mgmTfA_configgv_fixedDestinationTaxisClientSideScannerSleepDurationBetweenScansInSecondsNumber			= 5										;
mgmTfA_configgv_clickNGoTaxisClientSideScannerSleepDurationBetweenScansInSecondsNumber					= 5										;
mgmTfA_configgv_fixedDestinationTaxisClientSideScannerScanRadiusInMetresNumber							= 250									;
mgmTfA_configgv_clickNGoDestinationTaxisClientSideScannerScanRadiusInMetresNumber						= 250									;
//--------------------------------------------------------------------------------

//--------------------------------------------------------------------------------
// PAYMENT SETTINGS
//
// Fixed Destination Taxi Payment Settings
// Amount of cash will be immediately taken  from the player on booking.	Should the player change his mind (or get killed etc.) and not go ahead with the Fixed Destination Taxi journey, this amount will NOT be refunded.
mgmTfA_configgv_fixedDestinationTaxisNonRefundableStandardBookingFeeCostInCryptoNumber					= 100									;
// Amount of cash that player will need to pay at Pickup Point, as soon as player gets in the vehicle.		Should the player change his mind (or get killed etc.) and not go ahead with the entirety of the Fixed Destination Taxi journey, this amount will be partially refunded.
//
//
///////////////////////////////////////////////////// DESIGN DECISION CHANGE:	NO REFUNDS! ///////////////////////////////////////////////////////////////////////////////////////
// IGNORE THE BELOW! -- KEEPING TEXT HERE AS IT MIGHT BE ADDED, MUCH LATER.
// Refund system works like this:	for example, at Central Taxis player requested a taxi to Kavala, 
//								let's say this is 8000 meters (not real distance), 
//								and let's assume it costs 800 cryptos (not real cost, just an example).
//								Note: booking fee is NOT related to the actual journey thus Kavala does not cost 700 now (it still costs 800).
//								later player decide to eject while in transit, for the sake of example he did this exactly halfway through the journey at 4000 metres from CATP (and 4000 metres away from requestedDestination Kavala).
//								after the 'accidental eject recovery' times out, driver decides the player intentionally ejected, and driver starts self-destruction routine.
//								just before he starts moving away to self-destruct, the 'unused' part of the journey cost is refunded to the player.
//								in this example totalDistance=8000
//								untravelledDistance=4000
//								untravelledDistanceRatio = (((100 * untravelledDistance) / totalDistance) * 0.01)	=> (((100 * 4000) / 8000) * 0.01) => 0.5
//								refundAmount = (serviceFee * untravelledDistanceRatio)	=>	(800 * 0.5)	=>	400 cryptos
///////////////////////////////////////////////////// DESIGN DECISION CHANGE:	NO REFUNDS! ///////////////////////////////////////////////////////////////////////////////////////
//
// If you prefer a single static cost [e.g.: all Fixed Destinations cost 175 crypto, then set the base to 175 and set the tick to 0].
// Service Fees - Base Fee
mgmTfA_configgv_fixedDestinationTaxisServiceFeeBaseFeeInCryptoNumber									= 100									;
// Service Fees - Tick Per 100 Metres
mgmTfA_configgv_fixedDestinationTaxisServiceFeeCostForTravellingAdditional100MetresInCryptoNumber			= 10										;
//
//// EXAMPLE:	When player is at Central Taxis
// Distance to NEOCHORI=780 metres		Fixed Destination Taxi to NEOCHORI cost	= (StandardBooking=100) + (BaseFee=100) + (8 times CostForTravellingAdditional100Metres = 8 x 10 = 80)		= 100+100+80		= 280 crypto in total
// Distance to KAVALA=9900 metres		Fixed Destination Taxi to KAVALA cost		= (StandardBooking=100) + (BaseFee=100) + (99 times CostForTravellingAdditional100Metres = 99 x 10 = 990)	= 100+100+990	= 1190 crypto in total
// Distance to PYRGOS=4000 metres		Fixed Destination Taxi to PYRGOS cost		= (StandardBooking=100) + (BaseFee=100) + (40 times CostForTravellingAdditional100Metres = 40 x 10= 400)	= 100+100+400	= 600 crypto in total
//
//// EXAMPLE:	When player is at West Taxis
// Distance to NEOCHORI=6900 metres	Fixed Destination Taxi to NEOCHORI cost	= (StandardBooking=100) + (BaseFee=100) + (69 times CostForTravellingAdditional100Metres = 69 x 10 = 690)	= 100+100+690	= 890 crypto in total
// Distance to KAVALA=4600 metres		Fixed Destination Taxi to KAVALA cost		= (StandardBooking=100) + (BaseFee=100) + (46 times CostForTravellingAdditional100Metres = 46 x 10 = 460)	= 100+100+460	= 660 crypto in total
// Distance to PYRGOS=11400 metres		Fixed Destination Taxi to PYRGOS cost		= (StandardBooking=100) + (BaseFee=100) + (40 times CostForTravellingAdditional100Metres = 114 x 10 = 1140)	= 100+100+1140	= 1340 crypto in total
//
// NOTE:	Distances given are 'as the crow flies'
// NOTE:	Player must have adequate amount of cash to cover the full cost of the requested Fixed Destination Journey on him. Otherwise booking will fail - this is to protect both player & Taxi Corp unnecessary waste of time!
//
//
//
// clickNGo Cost Settings 			(This is the PAYG / Pay-as-You-Go module of Transport for Arma)
// This is the cost of 'calling a driver' to your location
mgmTfA_configgv_clickNGoTaxisNonRefundableBookingFeeCostInCryptoNumber								= 400;
// AbsoluteMinimumJourneyTimeInSeconds			(default = 120 seconds; 2 minutes)		A clickNGo journey will always be pre-paid at least for (AbsoluteMinimumJourneyTimeInSeconds). Even if actual journey last shorter, a refund will not be made. Customer MUST pre-pay the cost to prevent unnecessary disputes.
// RELEASE TODO: enable 120 secs below. delete 10 secs underneath.
mgmTfA_configgv_clickNGoTaxisPrepaidAbsoluteMinimumJourneyTimeInSeconds								= 120;
//mgmTfA_configgv_clickNGoTaxisPrepaidAbsoluteMinimumJourneyTimeInSeconds								= 10;
// Note: player is paying for the time of Driver (not for distance). If the vehicle gets stuck, it's still costing a lot of money to Taxi Corp, such as:	(driver's time) + (energy) + (insurance) + (blah blah)
// This is the cost of 'calling a driver' to your location
mgmTfA_configgv_clickNGoTaxisAbsoluteMinimumJourneyFeeInCryptoNumber								= 100;
mgmTfA_configgv_clickNGoTaxisTickStepTimeInSecondsNumber											= 60;
mgmTfA_configgv_clickNGoTaxisTickCostInCryptoNumber												= 20;
// if enabled:	every time a 'tick charge' goes through, we will display a hint message and let the player know that he has been charged				(default: false)
mgmTfA_configgv_clickNGoTaxisDisplayTickChargeHintMessageBool										= true;
// if enabled:	every time a 'tick charge' goes through, we will display a systemChat message and let the player know that he has been charged		(default: true)
mgmTfA_configgv_clickNGoTaxisDisplayTickChargeSystemChatMessageBool									= false;
mgmTfA_configgv_thresholdNumberOfFailedPAYGTransactionsToPermitBeforeInitiatingPAYGserviceAbruptTerminationNumber	= 2;
mgmTfA_configgv_monitoringAgentMissedPurchasingPowerCheckAndPAYGTickChargesAgentSleepTime				= mgmTfA_configgv_clickNGoTaxisTickStepTimeInSecondsNumber;
// when player get in a clickNGo vehicle, driver will not start driving unless the 'PAYG Initial Fee' is paid.	At this time, 		only for the first get in, player receives a popup window, instructing him TO PAY THE INITIAL FEE,		on any future get ins, player will receive a hint message (no popup), instructing hem to PAY THE INITIAL FEE.		however, it is a proven fact that some people just don't read.		if the setting below is enabled (default option),	driver will continously systemChat message the player [once every second], requesting the 'Initial Fee' payment.
mgmTfA_configgv_clickNGoTaxisDriverWillKeepRemindingThatTheInitialFeeMustBePaidBool						= true;
//--------------------------------------------------------------------------------
//Define Shared Settings for Taxi Fixed Destinations
//none
//--------------------------------------------------------------------------------

						// NOT IMPLEMENTED
						//--------------------------------------------------------------------------------
						//TAXI SERVICE SETTINGS
						//
						//Fixed Destination Settings
						//List of available destinations for the Taxi service
						//
						//Note: Each destination must also be added to "mgmTfA_scr_clientPresentCatpActionMenu.sqf" to present the actionMenu option - otherwise players can't choose a valid but not-presented destination!
						//Note: Use only upper case for Text Strings (in accordance with current Transport for Arma user interface standard - all client communications must be in UPPERCASE)

									// CHEAT SHEET
									//TAXI-DESTINATION-ID		LOCATION					POS
									//0						NOT-IN-USE					N/A
									//1						Neochori City Centre				[12573.5,14356.2]						[12573.5,14356.2,0.00155258]
									//2						Kavala City Centre				[3610.68,12939.6]						[3610.68,12939.6,0.00157928]
									//3						Pyrgos City Centre				[16811.8,12698]						[16811.8,12698,0.00141716]
						//
						//
						//Write service status information to server's RPT log file every n seconds // Default: 300
						// ALPHA RELEASE TODO: INCREASE THIS!
						// TODO: CHANGE THIS
						//I BELIEVE THIS IS NOT IN USE							mgmTfA_configgv_taxiWriteStatusToServerRptLogEveryNSecondsNumber=60;
						//
						//Sleep time in between serverPosManager updates (in seconds) // Default: 2
						//I BELIEVE THIS IS NOT IN USE							mgmTfA_configgv_sleepDurationInBetweenPosManagerUpdatesInSecondsNumber=2;
						//
						//Sleep time in between Marker Updated Daemon updates (in seconds) // Default: 1
						//I BELIEVE THIS IS NOT IN USE							mgmTfA_configgv_sleepDurationInBetweenMarkerUpdaterDaemonUpdatesInSecondsNumber=2;
						//--------------------------------------------------------------------------------

// --------------------------------------------------------------------------------
// Settings for TaxiFixedDestination01
//
// Does this exist?						(i.e.: ignore the rest of the settings below this line)
// 		Referred by TODO-FILL-THIS
mgmTfA_configgv_createTaxiFixedDestination01Bool						= true;
// Taxi Fixed Destination 01 Location
// 		Referred by mgmTfA_scr_serverInitCreateObjectHQBuilding.sqf when creating the building
//		Change at your risk. We don't do any collision checks when spawning this building lol
mgmTfA_configgv_taxiFixedDestination01LocationPositionArray				= [12573.5,14356.2,0.00155258];
//
// Taxi Fixed Destination 01	Location Name Text String
// 		Used by server when responding to requestor
// Note: USE UPPER CASE FOR TEXT STRINGS (in accordance with current Transport for Arma user interface standard - all client communications are in UPPERCASE)
//mgmTfA_configgv_taxiFixedDestination01LocationNameTextString="NEOCHORI";
//mgmTfA_configgv_taxiFixedDestination01LocationNameTextString				= "NEOCHORI CITY CENTRE";
mgmTfA_configgv_taxiFixedDestination01LocationNameTextString				= "NEOCHORI";
//
// Taxi Fixed Destination 01	Menu Option Text
mgmTfA_configgv_taxiFixedDestination01ActionMenuTextString				= "CALL A TAXI TO NEOCHORI";
//
// Taxi Fixed Destination 01	Create marker?
mgmTfA_configgv_taxiFixedDestination01LocationMapMarkerBool				= true;
//
// Taxi Fixed Destination 01	Map Marker Type
mgmTfA_configgv_taxiFixedDestination01LocationMapMarkerTypeTextString		= "mil_dot";
//
// Taxi Fixed Destination 01	Map Marker Shape
mgmTfA_configgv_taxiFixedDestination01LocationMapMarkerShapeTextString		= "ICON";
//
// Taxi Fixed Destination 01	Map Marker Color
mgmTfA_configgv_taxiFixedDestination01LocationMapMarkerColorTextString		= "ColorPink";
//
// Taxi Fixed Destination 01	Map Marker Text
//mgmTfA_configgv_taxiFixedDestination01LocationMapMarkerTextString		="Taxi Destination Kavala";
mgmTfA_configgv_taxiFixedDestination01LocationMapMarkerTextString			= "";
// --------------------------------------------------------------------------------

// --------------------------------------------------------------------------------
// Settings for TaxiFixedDestination02
//
// Does this exist?						(i.e.: ignore the rest of the settings below this line)
// 		Referred by TODO-FILL-THIS
mgmTfA_configgv_createTaxiFixedDestination02Bool						= true;
// Taxi Fixed Destination 02 Location
// 		Referred by mgmTfA_scr_serverInitCreateObjectHQBuilding.sqf when creating the building
//		Change at your risk. We don't do any collision checks when spawning this building
mgmTfA_configgv_taxiFixedDestination02LocationPositionArray				= [3610.68,12939.6];
// Taxi Fixed Destination 02	Location Name Text String
// 		Used by server when responding to requestor
// Note: USE UPPER CASE FOR TEXT STRINGS (in accordance with current Transport for Arma user interface standard - all client communications are in UPPERCASE)
mgmTfA_configgv_taxiFixedDestination02LocationNameTextString				= "KAVALA CITY CENTRE";
// Taxi Fixed Destination 02	Menu Option Text
mgmTfA_configgv_taxiFixedDestination02ActionMenuTextString				= "CALL A TAXI TO KAVALA";
// Taxi Fixed Destination 02	Create marker?
mgmTfA_configgv_taxiFixedDestination02LocationMapMarkerBool				= true;
// Taxi Fixed Destination 02	Map Marker Type
mgmTfA_configgv_taxiFixedDestination02LocationMapMarkerTypeTextString		= "mil_dot";
// Taxi Fixed Destination 02	Map Marker Shape
mgmTfA_configgv_taxiFixedDestination02LocationMapMarkerShapeTextString		= "ICON";
// Taxi Fixed Destination 02	Map Marker Color
mgmTfA_configgv_taxiFixedDestination02LocationMapMarkerColorTextString		= "ColorPink";
// Taxi Fixed Destination 02	Map Marker Text
//mgmTfA_configgv_taxiFixedDestination02LocationMapMarkerTextString="Taxi Destination Neochori";
mgmTfA_configgv_taxiFixedDestination02LocationMapMarkerTextString			= "";
// --------------------------------------------------------------------------------

// --------------------------------------------------------------------------------
// Settings for TaxiFixedDestination03
//
// Does this exist?						(i.e.: ignore the rest of the settings below this line)
// 		Referred by TODO-FILL-THIS
mgmTfA_configgv_createTaxiFixedDestination03Bool						= true;
// Taxi Fixed Destination 03 Location
// 		Referred by mgmTfA_scr_serverInitCreateObjectHQBuilding.sqf when creating the building
//		Change at your risk. We don't do any collision checks when spawning this building
mgmTfA_configgv_taxiFixedDestination03LocationPositionArray				= [16811.8,12698];
// Taxi Fixed Destination 03	Location Name Text String
// 		Used by server when responding to requestor
// Note: USE UPPER CASE FOR TEXT STRINGS (in accordance with current Transport for Arma user interface standard - all client communications are in UPPERCASE)
mgmTfA_configgv_taxiFixedDestination03LocationNameTextString				= "PYRGOS CITY CENTRE";
// Taxi Fixed Destination 03	Menu Option Text
mgmTfA_configgv_taxiFixedDestination03ActionMenuTextString				= "CALL A TAXI TO PYRGOS";
// Taxi Fixed Destination 03	Create marker?
mgmTfA_configgv_taxiFixedDestination03LocationMapMarkerBool				= true;
// Taxi Fixed Destination 03	Map Marker Type
mgmTfA_configgv_taxiFixedDestination03LocationMapMarkerTypeTextString		= "mil_dot";
// Taxi Fixed Destination 03	Map Marker Shape
mgmTfA_configgv_taxiFixedDestination03LocationMapMarkerShapeTextString		= "ICON";
// Taxi Fixed Destination 03	Map Marker Color
mgmTfA_configgv_taxiFixedDestination03LocationMapMarkerColorTextString		= "ColorPink";
// Taxi Fixed Destination 03	Map Marker Text
//mgmTfA_configgv_taxiFixedDestination03LocationMapMarkerTextString="Taxi Destination Pyrgos";
mgmTfA_configgv_taxiFixedDestination03LocationMapMarkerTextString			= "";
// --------------------------------------------------------------------------------

// --------------------------------------------------------------------------------
// ================================== TAXI FIXED DESTINATIONS CONFIGURATION - end ==================================





//--------------------------------------------------------------------------------
// ENABLE/DISABLE MODULES
//I BELIEVE THIS IS NOT IN USE							mgmTfA_configgv_serverPosManagerEnabled								=	true;
// NOT IMPLEMENTED
mgmTfA_configgv_inGameMapEmbeddedStatusReportEnabledBool								= true;
// This bypasses Access Control List based map-tracking information security and allows ALL players to see all Service Units. Think twice before enabling this as it is equal to getPos cheat (for players using Service Units).
mgmTfA_configgv_makeAllMarkersPublicIWantZeroPrivacyAndSecurityBool						= false;
//--------------------------------------------------------------------------------


//--------------------------------------------------------------------------------
//TAXI CORP HR DEPARTMENT SETTINGS
//
// Taxi Driver Classname(s)
// Every time a new driver is to be created, one of the classnames below will be randomly picked.
// Note: Apparently no female characters exist in Arma 3 dam!	ref: http://forums.bistudio.com/showthread.php?119587-They-better-have-female-soldiers
// TODO: Post Public Alpha Initial Release - add more variety
//I BELIEVE THIS IS NOT IN USE							mgmTfA_configgv_taxiDriverClassNamesArrayTextString					= ["B_soldier_AR_F"];
//I BELIEVE THIS IS NOT IN USE							mgmTfA_configgv_clickNGoTaxiDriverClassnameTextString				= ["B_soldier_AR_F"];
//
//Taxi Vehicle Settings for clickNGo Taxi Service
//I BELIEVE THIS IS NOT IN USE							mgmTfA_configgv_clickNGoTaxiVehicleClassnameTextString				= "C_Offroad_01_F";
//
//Taxi Driver Settings
//This is to prevent players from 'stealing' cars. //TODO: can they even steal the car if you lockdriver? Test this. If proven to be unnecessary get rid of this!
//If you start finding your drivers getting 
//--------------------------------------------------------------------------------

//--------------------------------------------------------------------------------
//
// CLIENT COMMUNICATIONS & GUI STUFF
//
//Introduce an artificial delay while responding to incoming booking requests. Just a few seconds. a random number will be generated within the parameters below.
//This is to simulate real life case, where a requestor does not usually get a 3 ms response
//Note: If you want to disable it, set both values to 0.
// TODO: Pre Public Alpha Initial Release - set it to ummm say 5 & 12?
//I BELIEVE THIS IS NOT IN USE							mgmTfA_configgv_artificialDelayProcessingYourRequestMinSecondsNumber = 2;
//I BELIEVE THIS IS NOT IN USE							mgmTfA_configgv_artificialDelayProcessingYourRequestMaxSecondsNumber = 4;

//RADIO/PHONE COMMUNICATIONS MECHANICS
//Radio Position Broadcast Channel Mode
//If enabled, a special radio channel exist, over which, each Taxi Corp asset regularly broadcast their position, speed, direction, current active task, and task age.

//
//
//	0	=	Disabled
//	1	=	Only  can access this encrypted channel (a.k.a. Admins)
//				//Constraints: (TACOZAP do NOT have to have a radio equipped) && (They do not have to near a TaxiCorp asset)  ==> Admins have a chip in their brain apparently
//				//Note: Admins list is configured in this document (the masterConfig document, at the very top)
//	2	=	Only players with radio can access		<= both options will work: (radio on body) or (radio in backpack)
//
//

//I BELIEVE THIS IS NOT IN USE							mgmTfA_configgv_fleetRadioPositionBroadcastChannelMode=1;
//--------------------------------------------------------------------------------

//--------------------------------------------------------------------------------
//MAP SETTINGS

//When a Service Unit self-terminates, by default 60 seconds later, all its map markers are deleted. You can change the threshold here. In seconds.
mgmTfA_configgv_mapMarkerExpiryTimeForTerminatedServiceUnitsInSecondsNumber=60;


//TODO: NOT IMPLEMENTED YET
// LOG RadioPositionBroadcastChannel BROADCAST MESSAGES
//if enabled, server RPT will show these 		=>		Received coordinates: <vehicleID> is at [1812.84,6067.58,-0.187176] 
//I BELIEVE THIS IS NOT IN USE							mgmTfA_configgv_verbosityLevelShowPosBroadcastReceivedOnServerRPT=1;
//--------------------------------------------------------------------------------
// EOF















//
//
//--------------------------------------------------------------------------------//--------------------------------------------------------------------------------//--------------------------------------------------------------------------------
// STUFF BELOW - MOSTLY NOT IMPLEMENTED
//--------------------------------------------------------------------------------//--------------------------------------------------------------------------------//--------------------------------------------------------------------------------
//
//
//VERSION INFORMATION
mgmTfA_configgv_TfAScriptVersionMajorNumber											= 0;
mgmTfA_configgv_TfAScriptVersionMinorNumber											= 3;
mgmTfA_configgv_TfAScriptVersionRevisionNumber										= 3;
mgmTfA_configgv_TfAScriptVersionTextString											= "0.3.3";
//-----
mgmTfA_configgv_TfAScriptVersionMajorMultipliedNumber = (mgmTfA_configgv_TfAScriptVersionMajorNumber * 100)			;
mgmTfA_configgv_TfAScriptVersionMinorMultipliedNumber = (mgmTfA_configgv_TfAScriptVersionMinorNumber * 10)			;
//-----
mgmTfA_configgv_TfAScriptVersionRevisionSumValueNumber = mgmTfA_configgv_TfAScriptVersionMajorMultipliedNumber + mgmTfA_configgv_TfAScriptVersionMinorMultipliedNumber + mgmTfA_configgv_TfAScriptVersionRevisionNumber;
//--------------------------------------------------------------------------------
//--------------------------------------------------------------------------------
//VERBOSITY SETTINGS

// This setting control how much output will be written to the server-side & client-side RPT, as per table below.
// NOTE:	Work In Progress
//
// VALUE	BRIEF INFO				REMARKS
// 0	Mute / Nothing	/ Nada			Will not write even a single character to the RPT. I (almost) promise you that
// 1	Normal					A limited number of basic items will be written to the log e.g.: regular server monitor (every n minutes)
// 2	Basic Debug				All the above plus some extras
// 3	Detailed Debug				All the above plus functions will report more output
// 4	Leaving Sanity Behind		All the above plus functions will report almost all output
// 5	Almost everything			All the above plus functions will report every iteration
// -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// server-side RPT logging verbosity		default = 0
//RELEASETODO
mgmTfA_configgv_serverVerbosityLevel												= 0;
//mgmTfA_configgv_serverVerbosityLevel												= 5;
// client-side RPT logging verbosity		default = 0
//RELEASETODO
mgmTfA_configgv_clientVerbosityLevel												= 0;
//mgmTfA_configgv_clientVerbosityLevel												= 5;
//--------------------------------------------------------------------------------

//--------------------------------------------------------------------------------
// MASTER ON/OFF SWITCH SETTINGS
//
// NOT IMPLEMENTED, WHOLE SECTION WILL BE IGNORED
mgmTfA_configgv_serviceModeFixedDestinationTaxisEnabled								= true;
mgmTfA_configgv_serviceModeclickNGoTaxisEnabled										= true;
mgmTfA_configgv_serviceModePublicBusSystemEnabled									= true;
mgmTfA_configgv_serviceModeFixedDestinationSeaTaxisEnabled								= true;
mgmTfA_configgv_serviceModeclickNGoSeaTaxisEnabled									= true;
mgmTfA_configgv_serviceModeclickNFlyAirTaxisEnabled									= true;
mgmTfA_configgv_serviceModeFIXERsEnabled											= true;
mgmTfA_configgv_serviceModeResponseForceTaskGroupEnabled								= true;
//--------------------------------------------------------------------------------

//--------------------------------------------------------------------------------
// PUBLIC BUS SYSTEM SETTINGS
//
// NOT IMPLEMENTED, WHOLE SECTION WILL BE IGNORED
mgmTfA_configgv_serviceModePublicBusSystemEnabled									= true;
//--------------------------------------------------------------------------------


//--------------------------------------------------------------------------------

// COMMAND & CONTROL - COMMUNICATIONS - PUBLICLY AVAILABLE INFORMATION

//TODO: NOT IMPLEMENTED YET
// many of them below not implemented yet.
//---------------------------------------------------------------------------------------------------------------------
//
//	TACOPOS				Taxi Corp Positioning System
//
//--------------------------------------------------------------------------------
//TACOPOS				Taxi Corp Positioning  					[unencrypted, public access]
//During server start up phase, enable/disable this wireless radio channel:		0=disabled	1=enabled
//
//TODO: A function with only one parameter [0=offline, 1=online] should configure the state of this service by setting global dynamic variable to 0 or 1, e.g.: mgmTfA_dynamicgv_enabled=1;
//mgmTfA_mng_serverTACOPOSManager.sqf should check the dynamic global variable mgmTfA_dynamicgv_enabled every 10 seconds and turn it on/off if necessary & log this action.
//I BELIEVE THIS IS NOT IN USE							mgmTfA_dynamicgv_READ_DURING_SERVER_INIT_TACOPOSenabled=1;
//--------------------------------------------------------------------------------

//--------------------------------------------------------------------------------
//	TACORAP				Taxi Corp Restricted Access Positioning		[encrypted, restricted-access]
//During server start up phase, enable/disable this wireless radio channel:		0=disabled	1=enabled
//I BELIEVE THIS IS NOT IN USE							mgmTfA_dynamicgv_READ_DURING_SERVER_INIT_TACORAPenabled=1;
//--------------------------------------------------------------------------------

//--------------------------------------------------------------------------------
//	TACOZEUZ			Taxi Corp ZEUZ Network					[encrypted, restricted-access]
//During server start up phase, enable/disable this wireless radio channel:		0=disabled	1=enabled
//I BELIEVE THIS IS NOT IN USE							mgmTfA_dynamicgv_READ_DURING_SERVER_INIT_TACOZEUZenabled=1;
//--------------------------------------------------------------------------------

//--------------------------------------------------------------------------------
//	WASNTUS				WASN Taxi Corp Unified System			[encrypted, restricted access]
//During server start up phase, enable/disable this wireless radio channel:		0=disabled	1=enabled
//I BELIEVE THIS IS NOT IN USE							mgmTfA_dynamicgv_READ_DURING_SERVER_INIT_TACOPOSenabled=1;
//--------------------------------------------------------------------------------

// EOF