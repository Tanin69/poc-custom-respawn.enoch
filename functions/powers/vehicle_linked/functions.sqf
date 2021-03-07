
// If already initiated
if (!(isNil "power_vehicle_linked_init")) exitWith { };
power_vehicle_linked_init = true;

power_vehicle_linked_find_pos = {
	(player getRelPos [power_vehicle_linked_distance - 2,0]) isFlatEmpty  [3, -1, -1, -1, 0, false];
};

power_vehicle_linked_spawn_can_spawn = {
	_veh = player getVariable ['power_vehicle_linked_current_vehicle', objNull];

	player setVariable ['power_vehicle_linked_next_vehicle', selectRandom power_vehicle_linked_vehicles, true];

	if (count (call power_vehicle_linked_find_pos) > 0) then {
		if(isNull _veh) then {
			true;
		} else {
			if ((alive _veh && ((count (crew _veh)) == 0))) then {
				true;
			} else {
				systemChat "Encore du monde à bord de votre ancien véhicule";
				hint "Encore du monde à bord de votre ancien véhicule";
				false;
			};
		};
	} else {
		systemChat "Aucune position disponible à proximité.";
		hint "Aucune position disponible à proximité.";
		false;
	};
};

power_vehicle_linked_despawn = {
	_veh = player getVariable ['power_vehicle_linked_current_vehicle', objNull];
	if(isNull _veh) then {
	} else {
		deleteVehicle _veh;
	};
};

power_vehicle_linked_spawn_type = {

	call power_vehicle_linked_despawn;
	_class = player getVariable ['power_vehicle_linked_next_vehicle', selectRandom power_vehicle_linked_vehicles];

	_veh = createVehicle [ _class, ASLToATL (call power_vehicle_linked_find_pos), [], 0, "CAN_COLLIDE" ];
	_veh setdir (_veh getDir player);

	player setVariable ['power_vehicle_linked_current_vehicle', _veh, true];
};

