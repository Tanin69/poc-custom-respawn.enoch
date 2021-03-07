
call compileFinal preprocessFileLineNumbers "functions\powers\common\common.sqf";
call compileFinal preprocessFileLineNumbers "functions\powers\common\text.sqf";
call compileFinal preprocessFileLineNumbers "functions\powers\common\addAction.sqf";
call compileFinal preprocessFileLineNumbers "functions\powers\common\holdActionAdd.sqf";

// Public functions for specific powers
call compileFinal preprocessFileLineNumbers "functions\powers\gravity\publicFunctions.sqf";


// Activate the power
// Example: ['teleport'] call activatePower
// Example: ['absolute_knowledge', [10000]] call activatePower
activatePower = {
	params ['_power', ['_params', []]];
	_params spawn compile preprocessFileLineNumbers ( "functions\powers\" + _power + "\activate.sqf");
};

// Desactivate the power
// Example: 'teleport' call desactivatePower
// Example: 'absolute_knowledge' call desactivatePower
desactivatePower = {
	params ['_power'];
	[] spawn compile preprocessFileLineNumbers ( "functions\powers\" + _power + "\desactivate.sqf");
};

