/*
	Author: Aaron Clark - EpochMod.com

    Contributors:

	Description:
	Reject players own connection

    Licence:
    Arma Public License Share Alike (APL-SA) - https://www.bistudio.com/community/licenses/arma-public-license-share-alike

    Github:
    https://github.com/EpochModTeam/Epoch/tree/master/Sources/epoch_code/compile/setup/EPOCH_client_rejectPlayer.sqf

    Example:
    call EPOCH_clientInit;

    Parameter(s):
		_this: BOOL - true = set bad publicVariable to server forces kick

	Returns:
	NOTHING
*/
if (_this) then {
	PLAYER_BADHIVE = true;
	publicVariableServer "PLAYER_BADHIVE";
};
