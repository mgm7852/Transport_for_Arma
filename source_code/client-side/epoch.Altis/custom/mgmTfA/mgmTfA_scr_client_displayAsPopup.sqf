// Display:		hintC INFORMATION BOX
"TRANSPORT FOR ARMA clickNGo" hintC [
	"Thank you for choosing us!",
	"Please pay the Minimum Prepay Fee now via mouseWheel",
	"Driver will then drive towards chosen destination",
	"When pre-paid credits run out, PAY AS YOU GO will kick in",
	"You may set a new destination at any time",
	"PAYG Fees and SetCourseHotkey listed at the bottom of screen"
];
hintC_arr_EH = findDisplay 72 displayAddEventHandler ["unload", {
	0 = _this spawn {
		_this select 0 displayRemoveEventHandler ["unload", hintC_arr_EH];
		hintSilent "";
	};
}];
//EOF