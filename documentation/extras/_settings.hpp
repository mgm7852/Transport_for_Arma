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
//--------------------------------------------------------------------------------
// Global On/Off setting for anything about Public Bus system
mgmTfA_configgv_serviceModePublicBusSystemEnabled									= true;
// Read rest of the Public Bus System settings only this service is  enabled in the previous line
if (mgmTfA_configgv_serviceModePublicBusSystemEnabled) then {
	// This is the initial state of things which might change in the future in which case clients will re-draw their maps with the updated information
	mgmTfA_dynamicgv_publicBusSystemAnnouncementIDNumber							=1;
	mgmTfA_dynamicgv_routeAllRoutesSettingsTextStringArray								=[];
	mgmTfA_dynamicgv_publicBusSystemTotalNumberOfCurrentlyActiveRoutesNumberDONOTMODIFY	=0;	
	
	
	
	
	// === BEGIN: COMBINED ROUTE CONFIG for a new route =========================================================================================//
	//
	//
	//
	//----------BEGIN:	Configurable Settings for a particular Public Bus Route
	// Is this route enabled?
	mgmTfA_dynamicgv_routeCurrentRouteIsEnabledBool									= true;
	// Read rest of the settings on this route only if the route is enabled
	if (mgmTfA_dynamicgv_routeCurrentRouteIsEnabledBool) then {
		// Config name is only for administrative purposes - players won't see this
		mgmTfA_dynamicgv_routeCurrentRouteConfigNameTextString						= "AltisCoastalBusLine";
		// Globally Unique Route ID Number
		mgmTfA_dynamicgv_publicBusSystemTotalNumberOfCurrentlyActiveRoutesNumberDONOTMODIFY = mgmTfA_dynamicgv_publicBusSystemTotalNumberOfCurrentlyActiveRoutesNumberDONOTMODIFY + 1;
		mgmTfA_dynamicgv_routeCurrentRouteGUROIDNumber							= mgmTfA_dynamicgv_publicBusSystemTotalNumberOfCurrentlyActiveRoutesNumberDONOTMODIFY;
		// Configuration file values below are the 'initial state' of this route's settings thus its AnnouncementID is always 1. During runtime, should we make any changes (e.g.: disable a particular route), we will need to 1. change values, 2. arrayify the new values, 3. publicVariable broadcast the new settings array, 4. finally increment the AnnouncementID so that clients can know that there has been a change.
		mgmTfA_dynamicgv_routeCurrentRouteAnnouncementIDNumber						= 1;
		// Public Name is what players will see on the map (and in any User Communication text)
		mgmTfA_dynamicgv_routeCurrentRoutePublicNameTextString						= "The Coastal Bus Line";
		// Available route line colour options:			"ColorBlack", "ColorRed", "ColorGreen", "ColorBlue", "ColorYellow", "ColorWhite" 
		mgmTfA_dynamicgv_routeCurrentRouteLineColorTextString							= "ColorGreen";
		mgmTfA_dynamicgv_routeCurrentRoutePointsPositionArray							= [[4081.41,13743.5,0],[4155.77,13844,0],[4227.25,13896.4,0],[4504.66,14044.1,0],[4621.39,14145.1,0],[4757.8,14265.1,0],[4849.61,14376.7,0],[4948.73,14416.3,0],[5054.04,14466.7,0],[5173.1,14482.7,0],[5274.75,14493.3,0],[5352.49,14515.6,0],[5401.08,14550.2,0],[5454.34,14595.2,0],[5501.13,14639.1,0],[5560.16,14694.6,0],[5630.89,14731.3,0],[5712.59,14761.9,0],[5806.53,14796.9,0],[5901.9,14814.1,0],[5946.27,14839.6,0],[6008.5,14893.2,0],[6103.66,14981.5,0],[6190.14,15056.6,0],[6263.35,15110.6,0],[6321.33,15149.6,0],[6377.17,15188,0],[6441.42,15230.4,0],[6530.13,15282.9,0],[6622.03,15337,0],[6709.28,15385.3,0],[6770.8,15422.9,0],[6781.35,15443.6,0],[6782.57,15472.8,0],[6781.76,15520.3,0],[6775.85,15698.6,0],[6783.24,15820.7,0],[6797.29,15934.6,0],[6816.79,15964.5,0],[6775.95,15975.6,0],[6701.52,15929.6,0],[6707.43,15963.6,0],[6724.83,15994.7,0],[6752.64,16026.2,0],[6787.92,16052.2,0],[6828.94,16076,0],[6800.14,16112.5,0],[6772.39,16159.5,0],[6763.61,16191.8,0],[6763.61,16228.4,0],[6726.3,16222.3,0],[6697.22,16213.2,0],[6650.09,16186,0],[6585.45,16164.8,0],[6563.72,16157.4,0],[6549.71,16155.5,0],[6534.82,16158.5,0],[6503.81,16177.1,0],[6485.07,16194.5,0],[6433.52,16205.8,0],[6408.23,16203.4,0],[6374.65,16196.3,0],[6348.78,16191.4,0],[6317.37,16188.2,0],[6267,16184.7,0],[6214.46,16181.9,0],[6174.96,16181.7,0],[6134.46,16182.3,0],[6103.45,16179.1,0],[6074.22,16175.6,0],[6046.76,16174,0],[6012.59,16176,0],[5983.75,16179.9,0],[5953.14,16182.1,0],[5940.61,16183.7,0],[5928.17,16180.1,0],[5908.2,16169.3,0],[5879.82,16153,0],[5872.63,16150.2,0],[5852.14,16146.1,0],[5824.46,16144.7,0],[5806.41,16149.7,0],[5788.19,16154,0],[5755.61,16145.6,0],[5726.53,16158.4,0],[5702.88,16161.6,0],[5678,16159.8,0],[5654.52,16153.5,0],[5616.68,16138.6,0],[5608.45,16130.4,0],[5601.27,16110.1,0],[5590.4,16100.1,0],[5572.01,16093.8,0],[5543.1,16094.6,0],[5522.08,16108.1,0],[5481.96,16149.7,0],[5463.39,16161.4,0],[5443.6,16168.4,0],[5421.35,16171.2,0],[5398.4,16171.2,0],[5370.54,16169.3,0],[5342.69,16162.6,0],[5313.74,16145.5,0],[5280.11,16134.4,0],[5242.92,16123.7,0],[5209.74,16108.3,0],[5197.93,16110.3,0],[5109.52,16152,0],[5050.5,16151.5,0],[5021.75,16137.1,0],[4999.25,16128.7,0],[4981.23,16128,0],[4937.72,16138.5,0],[4897.95,16144.2,0],[4874.64,16145.9,0],[4846.67,16145.5,0],[4813.89,16146.2,0],[4759.66,16157.4,0],[4739.15,16156.2,0],[4697.2,16135.8,0],[4673.65,16135.6,0],[4646.45,16132.5,0],[4616.47,16126.4,0],[4591.61,16117.7,0],[4564.41,16106.1,0],[4537.38,16092.2,0],[4516.56,16084,0],[4492.47,16082.4,0],[4456.43,16079,0],[4434.49,16074,0],[4420.8,16068.8,0],[4405.88,16057.7,0],[4390.36,16027.8,0],[4382.74,15999.3,0],[4372.47,15975.6,0],[4359.5,15950.1,0],[4351.56,15945.9,0],[4320.03,15943,0],[4295.82,15931.8,0],[4277.86,15913.1,0],[4270.28,15899.3,0],[4266,15883.2,0],[4264.54,15856.4,0],[4261.85,15831,0],[4253.54,15810.3,0],[4232.64,15778.6,0],[4214.16,15766.8,0],[4192.61,15755.7,0],[4178.59,15748.7,0],[4160.37,15727.2,0],[4143.91,15707,0],[4134.62,15693,0],[4123.93,15666.7,0],[4121.83,15641,0],[4122.18,15624.5,0],[4118.15,15600.3,0],[4114.65,15580.7,0],[4105.37,15543.9,0],[4087.67,15528.1,0],[4073.31,15518.1,0],[4060.17,15500.9,0],[4050.88,15481,0],[4043.52,15456.8,0],[4034.94,15425.4,0],[4021.45,15408.1,0],[3991.32,15396,0],[3963.81,15386.3,0],[3938.55,15370.7,0],[3919.59,15351.7,0],[3904.78,15329.2,0],[3899.84,15316,0],[3904.38,15295.8,0],[3917.22,15272.7,0],[3937.37,15252.7,0],[3962.65,15232.2,0],[3999.98,15211.8,0],[4026.16,15197.9,0],[4040.58,15195.2,0],[4050.96,15199,0],[4063.64,15212.5,0],[4080.12,15227.2,0],[4092.37,15230.7,0],[4109.28,15222.4,0],[4110.58,15210.3,0],[4111.01,15198.1,0],[4116.87,15183.8,0],[4129.23,15163.9,0],[4142.13,15145.3,0],[4153.94,15127.4,0],[4152.41,15109.4,0],[4179.29,15108.2,0],[4212.16,15107.3,0],[4240.6,15105.5,0],[4256.05,15096.3,0],[4285.75,15073.8,0],[4304.33,15053.9,0],[4319,15025.8,0],[4327.31,14999.6,0],[4337.21,14976,0],[4353.83,14947.9,0],[4373.14,14936.6,0],[4402.22,14925.3,0],[4417.65,14914.1,0],[4434.19,14899.8,0],[4452.52,14885.3,0],[4469.88,14876.3,0],[4476.91,14868.3,0],[4481.05,14848.2,0],[4486.28,14830,0],[4494.83,14819.5,0],[4507.78,14809.6,0],[4527.35,14800.2,0],[4549.12,14785.3,0],[4569.8,14772.9,0],[4582.61,14766.2,0],[4596.94,14754.5,0],[4609.28,14744.9,0],[4621.14,14736.8,0],[4645.09,14726.1,0],[4665.26,14717.8,0],[4693.53,14715.5,0],[4719.82,14712.6,0],[4747.57,14701.4,0],[4776.3,14688.2,0],[4808.82,14676.9,0],[4818.22,14655.4,0],[4825.68,14643.6,0],[4840.44,14629.4,0],[4857.06,14617,0],[4878.19,14605.5,0],[4893.58,14586.2,0],[4904.45,14562.3,0],[4911.91,14544.6,0],[4914.71,14519.1,0],[4914.71,14493.6,0],[4909.27,14470.6,0],[4897.93,14453.3,0],[4899.33,14437.9,0],[4917.82,14405.5,0]];
		//mgmTfA_dynamicgv_routeCurrentRoutePointsPositionArray						= [[13089.9,14906.1,0], [13107.4,14886.2,0], [13128.7,14858.5,0], [13151.1,14832.9,0], [13177.6,14804,0], [13207.3,14768.3,0], [13230.3,14740,0], [13247.4,14711.1,0], [13260.5,14681.5,0], [13267.5,14660.3,0], [13274.6,14639.1,0], [13276.5,14620.2,0], [13286.7,14601.7,0], [13294,14583.9,0], [13304.7,14572,0]];
	//----------END:	Configurable Settings for a particular Public Bus Route
																																			//----------BEGIN:	DO NOT TOUCH SECTION
																																			mgmTfA_dynamicgv_routeCurrentRouteSettingsArray = [];
																																			{
																																			   mgmTfA_dynamicgv_routeCurrentRouteSettingsArray set [(count mgmTfA_dynamicgv_routeCurrentRouteSettingsArray), _x];
																																			} forEach [mgmTfA_dynamicgv_routeCurrentRouteGUROIDNumber, mgmTfA_dynamicgv_routeCurrentRouteAnnouncementIDNumber, mgmTfA_dynamicgv_routeCurrentRoutePublicNameTextString, mgmTfA_dynamicgv_routeCurrentRouteLineColorTextString, mgmTfA_dynamicgv_routeCurrentRoutePointsPositionArray];
																																			//publicVariable "mgmTfA_dynamicgv_route1RouteSettingsArray";
																																			//
																																			mgmTfA_dynamicgv_routeAllRoutesSettingsTextStringArray set [(count mgmTfA_dynamicgv_routeAllRoutesSettingsTextStringArray), mgmTfA_dynamicgv_routeCurrentRouteSettingsArray];
																																			//----------END:	DO NOT TOUCH SECTION
	};
	// === END: COMBINED ROUTE CONFIG for a new route ==========================================================================================//
	
	
	
	

	// === BEGIN: COMBINED ROUTE CONFIG for a new route =========================================================================================//
	//
	//----------BEGIN:	Configurable Settings for a particular Public Bus Route
	// Is this route enabled?
	mgmTfA_dynamicgv_routeCurrentRouteIsEnabledBool									= true;
	// Read rest of the settings on this route only if the route is enabled
	if (mgmTfA_dynamicgv_routeCurrentRouteIsEnabledBool) then {
		// Config name is only for administrative purposes - players won't see this
		mgmTfA_dynamicgv_routeCurrentRouteConfigNameTextString						= "AltisVictoriaBusLine";
		//IntercityExpress
		// Globally Unique Route ID Number
		mgmTfA_dynamicgv_publicBusSystemTotalNumberOfCurrentlyActiveRoutesNumberDONOTMODIFY = mgmTfA_dynamicgv_publicBusSystemTotalNumberOfCurrentlyActiveRoutesNumberDONOTMODIFY + 1;
		mgmTfA_dynamicgv_routeCurrentRouteGUROIDNumber							= mgmTfA_dynamicgv_publicBusSystemTotalNumberOfCurrentlyActiveRoutesNumberDONOTMODIFY;
		// Configuration file values below are the 'initial state' of this route's settings thus its AnnouncementID is always 1. During runtime, should we make any changes (e.g.: disable a particular route), we will need to 1. change values, 2. arrayify the new values, 3. publicVariable broadcast the new settings array, 4. finally increment the AnnouncementID so that clients can know that there has been a change.
		mgmTfA_dynamicgv_routeCurrentRouteAnnouncementIDNumber						= 1;
		// Public Name is what players will see on the map (and in any User Communication text)
		mgmTfA_dynamicgv_routeCurrentRoutePublicNameTextString						= "Victoria Bus Line";
		// Available route line colour options:			"ColorBlack", "ColorRed", "ColorGreen", "ColorBlue", "ColorYellow", "ColorWhite" 
		mgmTfA_dynamicgv_routeCurrentRouteLineColorTextString							= "ColorBlue";
		mgmTfA_dynamicgv_routeCurrentRoutePointsPositionArray							= [[3176.33,11859.7,0],[3450,11957.7,0],[3671.7,11969.4,0],[3779.77,12031.5,0],[3805.05,12134.7,0],[3864.89,12195.1,0],[3926.8,12213.1,0],[4134.18,12202.8,0],[4223.45,12257.5,0],[4286.39,12350.9,0],[4433.17,12467.4,0],[4501.8,12588.3,0],[4535.2,12664.7,0],[4627.16,12727.4,0],[4672.92,12843.2,0],[4644.09,12924.7,0],[4582.33,13024.9,0],[4608.29,13185.6,0],[4747.13,13433.7,0],[4829.63,13480.3,0],[4931.62,13503.3,0],[4978.73,13556.3,0],[5032.24,13740.1,0],[5097.64,13858.9,0],[5103.47,14019,0],[5166,14167.5,0],[5154.33,14331,0],[5171.84,14482.7,0],[5361.85,14521.2,0],[5473.49,14614.2,0],[5598.94,14718.2,0],[5808.2,14798.2,0],[5914.91,14819.1,0],[6216.71,15077.6,0],[6776.95,15432.9,0],[6801.96,15948.3,0],[6937.85,16016.7,0],[7131.27,16050.9,0],[7529.77,16209.4,0],[7761.28,16159.4,0],[7871.22,16051.8,0],[8418.51,15755.4,0],[8547.46,15769,0],[8622.14,15814.8,0],[8691.64,15922.1,0],[8722.6,15925.3,0],[8730.58,15904.9,0],[8725.15,15808.1,0],[8773.04,15786.4,0],[8841.61,15785.4,0],[9000.33,15746.2,0],[9130.6,15790.2,0],[9289.26,15857.2,0],[9494.94,15925.4,0],[9697.49,15919.5,0],[9819.43,15981.1,0],[9889.61,15980.7,0],[10287.7,15861.3,0],[10338.6,15873.4,0],[10428.5,15928.7,0],[10491.9,15923.5,0],[10706.6,15825.9,0],[10860,15734.5,0],[10992.3,15690.3,0],[11140,15685.8,0],[11302.7,15730.7,0],[11467.9,15771.1,0],[11648.7,15812.9,0],[11826.1,15851.1,0],[12223.9,15852.1,0],[12468.9,15883.1,0],[13187.8,15964,0],[13673.1,16096.5,0],[13734.7,16122.1,0],[15147.1,17548.1,0],[15355.6,17544.4,0],[15518.3,17493.4,0],[15815.1,17428.1,0],[16100.1,17364.7,0],[16187.2,17376.2,0],[16203.1,17454.7,0],[16266.4,17483.5,0],[16347,17491.1,0],[16473.2,17471.3,0],[16521.1,17482.5,0],[16556.3,17542.3,0],[16634.2,17622.8,0],[16892.9,17779.6,0],[17247.7,17904.9,0],[17425.4,17918.6,0],[17617.9,17862.3,0],[17783.1,17826.8,0],[18000.1,17695.9,0],[18089.7,17709.8,0],[18136.8,17679,0],[18357,17347.3,0],[18520,17191,0],[18688.4,16964.5,0],[18846,16646.5,0],[18866,16637.5,0],[18934.4,16642.4,0],[19005.4,16631.5,0],[19156.5,16579.3,0],[19449.7,16555.4,0],[19525.6,16517,0],[19552,16525.5,0],[19616.1,16645.3,0],[19931.7,16759.8,0],[20008.2,16778.1,0],[20071.8,16769.9,0],[20140,16791.9,0],[20308.8,16796.9,0],[20394.8,16784.8,0],[20459.9,16761,0],[20493,16757.9,0],[20540.9,16735.8,0],[20610,16722.5,0],[20772.2,16629.9,0],[20846.7,16726.2,0],[20867,16789.8,0],[20937.7,16866.2,0],[20920.2,16892.5,0],[20928.9,16929.2,0],[21020,17030.5,0],[21323.8,17219.6,0],[21468.2,17361.6,0],[21678.1,17629.1,0],[21711.1,17696.4,0],[21781.1,18016.7,0],[21860.3,18120.1,0],[22147.9,18378.6,0],[22305.5,18434.5,0],[22354.7,18474.5,0],[22592.3,18797.3,0],[22769,19111.7,0],[23020.8,19428.6,0],[23191.6,19633.4,0],[23768.3,19946.1,0],[23767.7,19952.2,0],[23760.8,19947.3,0],[23764.1,19941.3,0],[23764.1,19941.3,0],[23766.9,19941.3,0],[23770.5,19941.7,0],[23298.4,19714.5,0],[23445.2,19824.6,0],[23904.5,20173.2,0],[24022.9,20283.5,0],[24201.3,20440.8,0],[24344.8,20503.5,0],[25128.6,20898,0],[25349.8,21063.2,0],[25609.5,21257.2,0],[25753.1,21406.9,0],[25846.7,21487.6,0],[25964.3,21556.9,0],[26089.4,21665.5,0],[26142.7,21646.6,0],[26210.4,21705.6,0],[26352.3,21873.5,0],[26344.4,21938.7,0],[26300.1,22007.3,0],[26321.2,22096.1,0],[26395.3,22255.5,0],[26516.6,22379.7,0],[26557.2,22561.7,0],[26650.4,22802.1,0],[26762.3,23041.3,0],[26503.3,23086.7,0],[26460,23073.3,0],[26224.8,23018,0],[26089.6,23069.3,0],[25843.4,22965.8,0],[25564.2,22921.6,0],[25524.7,22883.1,0],[25333.2,22830.5,0],[25011,22633.3,0],[24929.4,22571.8,0],[24817.1,22524.1,0],[24651.8,22369.3,0],[24469.4,22243.2,0],[24408.3,22238.5,0],[24358.5,22262,0],[24266.4,22126.6,0],[24099,22059.9,0],[23909.2,21995,0],[23898.8,21956.4,0],[23738.1,21853.9,0],[23732.4,21830.4,0],[23737.4,21803.8,0],[23710.8,21780.5,0]];
		//mgmTfA_dynamicgv_routeCurrentRoutePointsPositionArray						= [[12047.8,14346.9,0], [12096,14360.9,0], [12153.5,14390.2,0], [12196.2,14416.2,0], [12229.4,14437.9,0], [12268.8,14464.2,0], [12301.4,14485,0], [12343.6,14512.7,0], [12381.5,14536.3,0], [12417.4,14562.3,0], [12443.4,14583.7,0], [12475.5,14609.8,0]];
	//----------END:	Configurable Settings for a particular Public Bus Route
																																			//----------BEGIN:	DO NOT TOUCH SECTION
																																			mgmTfA_dynamicgv_routeCurrentRouteSettingsArray = [];
																																			{
																																			   mgmTfA_dynamicgv_routeCurrentRouteSettingsArray set [(count mgmTfA_dynamicgv_routeCurrentRouteSettingsArray), _x];
																																			} forEach [mgmTfA_dynamicgv_routeCurrentRouteGUROIDNumber, mgmTfA_dynamicgv_routeCurrentRouteAnnouncementIDNumber, mgmTfA_dynamicgv_routeCurrentRoutePublicNameTextString, mgmTfA_dynamicgv_routeCurrentRouteLineColorTextString, mgmTfA_dynamicgv_routeCurrentRoutePointsPositionArray];
																																			//publicVariable "mgmTfA_dynamicgv_route1RouteSettingsArray";
																																			//
																																			mgmTfA_dynamicgv_routeAllRoutesSettingsTextStringArray set [(count mgmTfA_dynamicgv_routeAllRoutesSettingsTextStringArray), mgmTfA_dynamicgv_routeCurrentRouteSettingsArray];
																																			//----------END:	DO NOT TOUCH SECTION
	};
	// === END: COMBINED ROUTE CONFIG for a new route ==========================================================================================//
};
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