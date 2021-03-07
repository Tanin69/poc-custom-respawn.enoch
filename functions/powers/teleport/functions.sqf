
// If already initiated
if (!(isNil "power_teleport_init")) exitWith { };
power_teleport_init = true;

// power_teleport_ui_init = {
// 	inGameUISetEventHandler ["PrevAction", "hint str _this; false"];
// 	inGameUISetEventHandler ["NextAction", "hint str _this; false"];
// };

power_teleport_ui_init = {
	power_teleport_ui_arrow = false;
	
	_trimHtml = _this call string_remove_html_tag;
	_trimHtml = _trimHtml call string_remove_all_spaces;

	_activate_teleport_ui = "
		if ( ((_this # 4) call string_remove_all_spaces) == " + (str _trimHtml) + " ) then {
			power_teleport_ui_arrow = true;
		} else {
			power_teleport_ui_arrow = false;
		};
	";

	inGameUISetEventHandler ["PrevAction", _activate_teleport_ui];
	inGameUISetEventHandler ["NextAction", _activate_teleport_ui];
	
	teleport_arrow = "Sign_Arrow_F" createVehicleLocal [0,0,0];
	onEachFrame {
		if (isActionMenuVisible && power_teleport_ui_arrow) then {
			teleport_arrow hideObject false;
			_ins = lineIntersectsSurfaces [
				AGLToASL positionCameraToWorld [0,0,0], 
				AGLToASL positionCameraToWorld [0,0,power_teleport_distance], 
				player
			];
			if (count _ins == 0) exitWith {teleport_arrow setPosASL [0,0,0]};
			teleport_arrow setPosASL (_ins select 0 select 0); 
			teleport_arrow setVectorUp (_ins select 0 select 1);
			// hintSilent str _ins;
		} else {
			teleport_arrow hideObject true;
		};
	};
};

power_teleport_sight_position = {
	_ins = lineIntersectsSurfaces [
		AGLToASL positionCameraToWorld [0,0,0], 
		AGLToASL positionCameraToWorld [0,0,1000], 
		player
	];
	if (count _ins == 0) exitWith { [] };
	_ins select 0 select 0;
};

power_teleport_smoke = {
	// systemChat ("test: " + (str _this));
	[_this, {

		_object = "chemlight_blue" createvehicleLocal _this; 
		_object setPosASL _this;
		hideObject _object; 
		_smokes = [];

		for "_i" from 0 to 8 do {
			_smoke = "#particlesource" createVehicleLocal (position _object); 
			_smoke setParticleCircle [0, [0, 0, 0]]; 
			_smoke setParticleRandom [0, [0, 0, 0], [0, 0, 0], 0, 0, [0, 0, 0, 0], 0, 0]; 
			_smoke setParticleParams [ 
				["\Ca\Data\ParticleEffects\FireAndSmokeAnim\SmokeAnim.p3d", 8, 3, 1], 
				"", // animationName, /*String*/ 
				"Billboard", // particleType, /*String - Enum: Billboard, SpaceObject*/ 
				1, // timerPeriod, /*Number*/ 
				4.5141, // lifeTime, /*Number*/ 
				[random 0.5, random 0.5, 0], // [0, 0, 2], // position, /*3D Array of numbers as relative position to particleSource or (if object at index 18 is set) object. Or (if object at index 18 is set) String as memoryPoint of object.*/ 
				[0.2*cos(45*_i),0.2*sin(45*_i), random 0.2], // [0, 0, 0], // moveVelocity, /*3D Array of numbers.*/ 
				1, // rotationVelocity, /*Number*/ 
				1.275, // weight, /*Number*/ 
				1, // volume, /*Number*/ 
				0, // rubbing, /*Number*/ 
				[0.7, 0.7], // size, /*Array of Number*/ 
				[[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1]], // color, /*Array of Array of RGBA Numbers*/ 
				[0,1], // animationSpeed, /*Array of Number*/ 
				1, // randomDirectionPeriod, /*Number*/ 
				0, // randomDirectionIntensity, /*Number*/ 
				"", // onTimerScript, /*String*/ 
				"", // beforeDestroyScript, /*String*/ 
				_object]; 
			_smoke setDropInterval 4.5;

			_smokes pushBack _smoke;
		};

		[_object, _smokes] spawn {
			sleep 4;
			deleteVehicle (_this#0);
			{ deleteVehicle _x; } forEach (_this#1);
		};

	}] remoteExec ["call", 0];	

	// _PS setParticleCircle [0, [0, 0, 0]]; 
	// _PS setParticleRandom [0, [0, 0, 0], [0, 0, 0], 0, 0, [0, 0, 0, 0], 0, 0];
	// _PS setDropInterval 0.05; 
	// _PS setParticleParams [["\Ca\Data\ParticleEffects\FireAndSmokeAnim\SmokeAnim.p3d", 8, 3, 1], "", "Billboard", 1, 1, [random 0.5, random 0.5, 0], [0, 0, 2], 1, 1, 0.9, 0.3, [0.2,1],[[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1]], [0,1], 1, 1, "", "", a_4];

	// _ps setParticleCircle [0, [0, 0, 0]];
	// _ps setParticleRandom [0, [0.25, 0.25, 0], [0.2, 0.2, 0], 0, 0.25, [0, 0, 0, 0.1], 0, 0];
	// _ps setParticleParams [["\Ca\Data\ParticleEffects\FireAndSmokeAnim\SmokeAnim.p3d", 8, 3, 1], "", "Billboard", 1, 8, [0, 0, 0], [0, 0, 1.5], 0, 10, 7.9, 0.066, [1, 3, 6], [[0.5, 0.5, 0.5, 0.15], [0.75, 0.75, 0.75, 0.075], [1, 1, 1, 0]], [0.125], 1, 0, "", "", _OBJ];
	// _ps setDropInterval 0.05;


	// _ps setParticleCircle [0, [0, 0, 0]];
	// _ps setParticleRandom [0, [0.25, 0.25, 0], [0.2, 0.2, 0], 0, 0.25, [0, 0, 0, 0.1], 0, 0];
	// _ps setParticleParams [["\Ca\Data\ParticleEffects\FireAndSmokeAnim\SmokeAnim.p3d", 8, 3, 1], "", "Billboard", 1, 8, [random 0.5, random 0.5, 0], [0, 0, 1.5], 0, 1, 2, 0.066, [0.2,1], [[0.5, 0.5, 0.5, 0.15], [0.75, 0.75, 0.75, 0.075], [1, 1, 1, 0]], [0,1], 1, 0, "", "", a_5];
	// _ps setDropInterval 0.05;
};

power_teleport_effect = {
	// player setPos screenToWorld [0.5,0.5];

	(getPosASL player) call power_teleport_smoke;

	_pos = call power_teleport_sight_position;
	if(count _pos == 3) then {
		player setPosASL _pos;
	};

	if(power_teleport_item_needed != "") then {
		[player, power_teleport_item_needed] call power_teleport_remove_item;
	};
	_pos call power_teleport_smoke;
};

power_teleport_can_teleport = {
	// _targetPos = screenToWorld [0.5,0.5];
	if(power_teleport_item_needed == "" || [player, power_teleport_item_needed] call power_teleport_has_item) then {
		_pos = call power_teleport_sight_position;
		if(count _pos == 3) then {
			// if(player distance _targetPos > 300) then {
			if(player distance _pos > power_teleport_distance) then {
				systemChat "Impossible de se téléporter : trop loin !";
				hint "Impossible de se téléporter : trop loin !";
				false;
			} else {
				true;
			};
		} else {
			systemChat "Impossible de se téléporter : Aucun  sol détecté";
			hint "Impossible de se téléporter : Aucun  sol détecté";
			false;
		};
	} else {
		systemChat ("Impossible de se téléporter : Plus de " + power_teleport_item_display_name + " !");
		hint ("Impossible de se téléporter : Plus de " + power_teleport_item_display_name + " !");
		false;
	};
};


/*
1)
	_objects = lineIntersectsWith [eyePos player, AGLtoASL screenToWorld [0.5,0.5], objNull, objNull, true];

2) 
	arrow = "Sign_Arrow_F" createVehicle [0,0,0];
	onEachFrame {
		_ins = lineIntersectsSurfaces [
			AGLToASL positionCameraToWorld [0,0,0], 
			AGLToASL positionCameraToWorld [0,0,1000], 
			player
		];
		if (count _ins == 0) exitWith {arrow setPosASL [0,0,0]};
		arrow setPosASL (_ins select 0 select 0); 
		arrow setVectorUp (_ins select 0 select 1);
		hintSilent str _ins;
	};

*/

power_teleport_list_items = {
    _items = (getItemCargo uniformContainer _this)#0;
    _items append ((getItemCargo vestContainer _this)#0);
    _items append ((getItemCargo backpackContainer _this)#0);

    _items arrayIntersect _items;
};

power_teleport_has_item = {
	params ['_unit', '_item'];
	_item in (_unit call power_teleport_list_items);
};

power_teleport_remove_item = {
	params ['_unit', '_item'];
	_unit removeItem _item;
};
