

power_gravity_get_unique_index = {
	_uniqueIndex = missionNamespace getVariable ["GDC_power_gravity_unique_index", 0];
	missionNamespace setVariable ["GDC_power_gravity_unique_index", _uniqueIndex + 1];
	_uniqueIndex;
};

power_gravity_server_destroy = {
	params ["_uid", "_veh_data"];
	_veh_data params ["_current_pos", "_current_alt", "_current_dir", "_current_pitchBank"];

	_ref_veh = missionNamespace getVariable ["GDC_power_gravity_server_veh" + (str _uid), objNull];

	_ref_veh setPosATL [_current_pos#0, _current_pos#1, _current_alt];
	[_ref_veh, _current_pitchBank#0, _current_pitchBank#1] call BIS_fnc_setPitchBank;
	_ref_veh setDir _current_dir;

	[_uid, {
		_local_veh = missionNamespace getVariable ["GDC_power_gravity_client_veh" + (str _this), objNull];
		deleteVehicle _local_veh;
	}] remoteExec ["call", 0];

	_ref_veh hideObjectGlobal false;
	_ref_veh enableSimulationGlobal true;
	_ref_veh setDamage [1, true];
};

power_gravity_client_destroy = {
	params ["_uid", "_local_veh"];

	_local_veh setVariable ["GDC_power_gravity_client_uid", _uid];
	_local_veh addEventHandler ["Killed", {
		params ["_unit", "_killer", "_instigator", "_useEffects"];
		_uid = _unit getVariable ["GDC_power_gravity_client_uid", 0];

		[_uid, [
			getPosATL _unit,
			getPosATL _unit#2,
			getDir _unit,
			_unit call BIS_fnc_getPitchBank
		]] remoteExec ["power_gravity_server_destroy", 2];

		false;
	}];
};

power_gravity_client_rotate = {
	if (!hasInterface) exitWith {}; // All credits to ALIAS!
	params ["_uid", "_class_name_obj", "_vit_rot", "_dir_rot", "_dist_dependent", "_poz_ini", "_alt_obj", "_slide_alt", "_slide_vel", "_dir_slide", "_vit_pitch", "_vit_bank", "_init_pitchBank"];

	_local_veh = _class_name_obj createVehicleLocal _poz_ini;
	_local_veh setVehicleLock "LOCKED";
	_local_veh enableSimulation false;
	_local_veh setPosATL _poz_ini;
	[_local_veh, _init_pitchBank#0, _init_pitchBank#1] call BIS_fnc_setPitchBank;
	missionNamespace setVariable ["GDC_power_gravity_client_veh" + (str _uid), _local_veh];

	if(_local_veh isKindOf "Man") then {
		_local_veh disableAI "all";
	};

	_poz_ini = getPosATL _local_veh;
	_poz_ini = [_poz_ini#0, _poz_ini#1, _alt_obj];
	_local_veh setPosATL _poz_ini;
	_local_veh setDir _dir_slide;

	if (!_dir_rot) then { _vit_rot = (-1) * _vit_rot };

	[_uid, _local_veh] call power_gravity_client_destroy;

	_incr = 0;
	while {_incr < _slide_alt} do {
		_incr = _incr + _slide_vel;
		// _new_poz=[_poz_ini, _incr, _dir_slide] call BIS_fnc_relPos;
		_local_veh setposATL [_poz_ini#0, _poz_ini#1, _poz_ini#2 + _incr];
		sleep 0.01;
	};

	_dir = _dir_slide;
	_pitch = _init_pitchBank#0;
	_bank = _init_pitchBank#1;
	while {true} do {
		while {(player distance _local_veh) < _dist_dependent} do {
			_local_veh setDir _dir;
			[_local_veh, _pitch, _bank] call BIS_fnc_setPitchBank;

			sleep 0.01;
			_dir = _dir + _vit_rot;
			if (_dir > 360) then { _dir = 0 };
			if (_dir <= 0) then { _dir = 360 };
			_pitch = _pitch + _vit_pitch;
			if (_pitch > 180) then { _pitch = -180 };
			if (_pitch <= -180) then { _pitch = 180 };
			_bank = _bank + _vit_bank;
			if (_bank > 180) then { _bank = -180 };
			if (_bank <= -180) then { _bank = 180 };
		};
		waitUntil {(player distance _local_veh) < _dist_dependent};
	};
};

power_gravity_server_rotate = {
	if (!isServer) exitWith {}; // All credits to ALIAS!
	params ["_ref_veh", "_vit_rot", "_dir_rot", "_dist_dependent", "_slide_alt", "_slide_vel", "_vit_pitch", "_vit_bank"];

	if (!isNil{_ref_veh getVariable "activ"}) exitWith {};
	_ref_veh setVariable ["activ", true, true];

	_nclass = typeOf _ref_veh;
	_poz_obj = getPosATL _ref_veh;
	_alt_obj = getPosATL _ref_veh#2;
	_dir_slide = getDir _ref_veh;
	_init_pitchBank = _ref_veh call BIS_fnc_getPitchBank;

	_uid = call power_gravity_get_unique_index;
	missionNamespace setVariable ["GDC_power_gravity_server_veh" + (str _uid), _ref_veh];
	// deleteVehicle _ref_veh;
    hideObjectGlobal _ref_veh;

	[_uid, _nclass, _vit_rot, _dir_rot, _dist_dependent, _poz_obj, _alt_obj, _slide_alt, _slide_vel, _dir_slide, _vit_pitch, _vit_bank, _init_pitchBank] remoteExec ["power_gravity_client_rotate", 0, true];
};
