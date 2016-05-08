diag_log format ['[mgmTfA] BEGIN Transport for Arma launch...'];
// Transport for Arma server-side	--	our very own 'initServer.sqf' imitation		-- non-scheduled environment
[] call compile preprocessFileLineNumbers	"\x\addons\custom\serverside\mgmTfA\mgmTfA_scr_server_initServer.sqf";
// Transport for Arma server-side	--	our very own 'init.sqf' imitation		-- scheduled environment
[] call compile preprocessFileLineNumbers	"\x\addons\custom\serverside\mgmTfA\mgmTfA_scr_server_init.sqf";
diag_log format ['[mgmTfA] COMPLETED Transport for Arma launch...'];
//EOF