_power_id = 'power_teleport';
if(player getVariable [_power_id, false]) exitWith {};

// Init functions
call compileFinal preprocessFileLineNumbers "functions\powers\teleport\functions.sqf";

// Power activated!
player setVariable [_power_id, true, true];


// PARAMS HERE!
params [
	['_cooldown', 10, [0]],
	['_distance', 300, [0]],
	['_classnameItem', '', ['']],
	['_itemDisplayName', '', ['']]
];
power_teleport_cooldown = _cooldown;
power_teleport_distance = _distance;
power_teleport_item_needed = _classnameItem;
power_teleport_item_display_name = _itemDisplayName;

_displayName = "Se téléporter (sur curseur, 300m max)";
_actionId = [ 
	_power_id,
	power_teleport_cooldown,
	{ call power_teleport_effect },
	_displayName,
	{ call power_teleport_can_teleport }
] call power_with_cooldown_init;

_displayName spawn {
	_this call power_teleport_ui_init;
};

[
	_power_id, 
	"Pouvoir de téléportation", 
	"Votre pouvoir vous permet de vous téléporter à vue.
	<br /> Certains vous appellent un jumpers, cibler et téléportez vous !
	<br />" +
	(if(power_teleport_item_display_name != "") then {
		"<br />Il vous faudra des " + power_teleport_item_display_name + "<br />"
	} else {
		""
	})
	+ "<br />Portée : " + (
		power_teleport_distance call secure_meter_to_text
	) + "
	<br />Cible : A vue
	<br />Cooldown : " + (
		power_teleport_cooldown call seconde_to_text
	)
] call common_power_description_init;
