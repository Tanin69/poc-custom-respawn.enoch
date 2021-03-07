_power_id = 'power_vehicle_linked';
if(player getVariable [_power_id, false]) exitWith {};

// Init functions
call compileFinal preprocessFileLineNumbers "functions\powers\vehicle_linked\functions.sqf";

// Regneration power activated!
player setVariable [_power_id, true, true];


// PARAMS HERE!
params [
	['_cooldown', 5*60, [0]],
	['_distance', 10, [0]],
	['_vehicleClassnames', [
		"B_LSV_01_unarmed_F",
		"CUP_C_Golf4_kitty_Civ",
		"C_Offroad_01_covered_F",
		"CUP_C_Ikarus_Chernarus",
		"CUP_B_LR_Transport_GB_W",
		"CUP_B_Ural_Open_CDF",
		"B_G_Offroad_01_F"
	], [[]]]
];
power_vehicle_linked_cooldown = _cooldown;
power_vehicle_linked_distance = _distance;
power_vehicle_linked_vehicles = _vehicleClassnames;

player setVariable ['power_vehicle_linked_current_vehicle', objNull, true];
player setVariable ['power_vehicle_linked_next_vehicle', "", true];


[ 
	_power_id,
	power_vehicle_linked_cooldown,
	{ call power_vehicle_linked_spawn_type },
	"Appeler son véhicule",
	{ call power_vehicle_linked_spawn_can_spawn }
] call power_with_cooldown_init;

[
	_power_id, 
	"Pouvoir : Lié avec son véhicule", 
	"Votre pouvoir vous permet d'appeler à vous votre véhicule selon votre humeur.
	<br /> Votre humeur change sans arrêt, aussi le véhicule qui pourrait répondre à votre appel peut changer !
	<br />
	<br />Portée : " + (
		power_vehicle_linked_distance call secure_meter_to_text
	) + "
	<br />Cible : Sol (dégagé)
	<br />Cooldown : " + (
		power_vehicle_linked_cooldown call seconde_to_text
	)
] call common_power_description_init;
