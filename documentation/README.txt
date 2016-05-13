TRANSPORT FOR ARMA - README

Transport for Arma by mgm
Official project repo	:	https://gitlab.com/themgm/Transport_for_Arma
Official forum thread	:	http://epochmod.com/forum/topic/33927-taxi-bus-transport-for-arma/



INTRODUCTION
Transport for Arma (TfA) is server-side mod (with some client-side extensions) which aim improving transport aspect of the game by providing Taxi and Public Bus services.
It is by default set up to work with Epoch Mod for Arma 3 however base Arma 3 or any other mod should be easy to configure after a few tweaks.
*Server-side module contain	:		the service units (vehicles+AI characters to control them), management logic, logging and reporting facilities.
*Client-side module contain	:		client interaction and client<>server communication code.



DESIGN GOALS
TfA has been designed with the following keypoints on mind:
* Highly customizable, modular structure
* Highly reliable & optimized for performance -- this part is, and will always be, a Work-in-Progress
* Good documentation user side and in-line code comments
* Realism by default		[fresh spawn, no radio, ex nihilo "call-a-taxi via magic communications" is a no]
* Internationalization (I18n) & Localization (L10n) support (WIP)



MAIN FEATURES 
Transport for Arma has several independent "Service Operation Mode"s. Server owners can enable or disable service modes in the CONFIGURATION file.

	-----------------------------------
	1) Fixed Destination Taxi Service
	HOW THIS WORKS:  In this mode, players can book taxis from CATPs (Call-a-Taxi Points) and choose a destination from the list. FD Taxi will then take them to the chosen location and will charge accordingy to a flexible cost.
									Cost is defined in CONFIGURATION file.
									List of CATPs defined in CONFIGURATION file.
									List of FDs defined in CONFIGURATION file.
	TODO: add "show me" link here
	-----------------------------------



	-----------------------------------
	2) TaxiAnywhere Taxi Service
	HOW THIS WORKS: In this mode, players from anywhere on the map can call a taxi via the TfAGUI and go to any other part of the map.
									Communication is done via radio thus, player must have a radio item.
									This service is not based on a fixed fee but taximeter based; as the Taxi keeps driving, driver keeps charging the player every n seconds x amounts of Crypto.
									Cost is defined in CONFIGURATION file.
									Radio requirement is defined in CONFIGURATION file (WIP).
									While inside a TaxiAnywhere Taxi, (if server configuration allows) at any time, bring up the TfAGUI to set a new destination.
	TODO: add "show me" link here
	-----------------------------------



	-----------------------------------
	3) (NOT IMPLEMENTED) Public Bus Service
									In this planned mode, a player can hop on & hop off whenever he desires free of charge.
									Note that the vehicle type is not actually 'bus' until someone imports it to Arma 3!
									Players stand by road and signal the approaching PublicBus with "please stop!", bus will slow down and stop to let the player in. To get off, players use the GUI button "please stop"
	TODO: add "show me" link here
	-----------------------------------



		
ADDITIONAL FEATURES

-----------------------------------
FEATURE	:	REALTIME MAP UPDATES 
				All Transport for Arma SUs (ServiceUnits) (i.e.: vehicles) belong to Taxi Corp.
				All Taxi Corp assets broadcast their position and actions to the Taxi Corp HQ.
				Each SU will report the following information:
							SUID | DriverName | ActionInProgress | NameOfThePlayerBeingServed | Speed | Direction | # of Passengers | DistanceToWaypoint | UnitAge
				Broadcasted information is visible to members of totalOmniscience group.
				To be clear members of this group can monitor all TfA vehicles at all times.
				Vanilla Players: 	(i.e.: not an admin && not a member of totalOmniscience group) can monitor only the vehicle currently serving them.
							This is useful in many ways; one practical use is monitoring an inbound taxi that is on its journey to pick up the player.
TODO: add "show me" link here
-----------------------------------


-----------------------------------
FEATURE: 		IN-GAME STATUS REPORT
				Members of totalOmniscience group receive an in-game "status report" that is printed at the bottom right corner of the game map. 
				In-Game Status Report is similar to the server RPT log report and contain the following:
						DRIVERS   	Busy | Available | Total
						REQUESTS   	InProgress | Success | Fail | Total
						MILEAGE   	Total
						SERVER UPTIME
TODO: add "show me" link here
-----------------------------------


-----------------------------------
FEATURE: (NOT IMPLEMENTED)	SERVER LOG MANAGER (SLM)
				SLM Report service status to the server RPT log every n seconds [configured in CONFIGURATION]. Status report contains the following:
				SLM Status Report is similar to the in-game status report and contain the following:
						DRIVERS   	Busy | Available | Total
						REQUESTS   	InProgress | Success | Fail | Total
						MILEAGE   	Total
						SERVER UPTIME
TODO: add "show me" link here
-----------------------------------


-----------------------------------
FEATURE	:	ANTIHOARDING PROTECTION
			A player cannot book all taxis at the same time. In fact cannot book more than one at any given time, this is to prevent DoS attacks.
TODO: add "show me" link here
-----------------------------------

-----------------------------------
FEATURE	:	EASY CONFIGURATION & CUSTOMIZATION
				From ground up this mod is designed to be extremely customizable - almost anything is configurable from one single CONFIGURATION file.
				Copied below just a few configuration options -- see the CONFIGURATION file for the full list.
//---------------------------------------


-----------------------------------
FEATURE: (NOT IMPLEMENTED)	ACCIDENTAL EJECT RECOVERY
							For their own safety, players do not have the option to "get out" while vehicle is in transit however (due to emergencies etc.) they DO have the option to jump out via EJECT button.
							DISCLAIMER:	Taxi Corp strongly recommend seat belts to be fastened during the entirety of journey and customers not eject out of in-transit vehicles as there has been several cases of severe injury and death.
							In  the event of customer ejecting while in transit, driver will assume this is due to a mistake and will stop the vehicle and await for the customer to get back in.
							After a while, if the customer does not get back in, driver will be convinced that it was indeed an intentional eject-while-in-transit and he will carry on with his workflow [i.e.: as per customer's wishes, driver will leave the customer behind].
			TODO: add "show me" link here
//---------------------------------------


-----------------------------------
FEATURE: (NOT IMPLEMENTED) BANK TRANSFERS 
							Bank Transfer will be an accepted method of payment, meaning player does not have to have cash to use the Taxi Service. Cost will be taken from players Epoch Bank Account.
							Server owners can turn this off if they wish to keep the 'carrying cash risk'
TODO: add "show me" link here
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~




// EOF