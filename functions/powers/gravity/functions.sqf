
// If already initiated
if (!(isNil "power_gravity_init")) exitWith { };
power_gravity_init = true;

// power_gravity_ui_init = {
// 	power_gravity_ui_activate = false;
// 	power_gravity_ui_has_text = false;

// 	_activate_gravity_ui = "
// 		if ( _this # 4 == " + (str _this) + " ) then {
// 			power_gravity_ui_activate = true;
// 		} else {
// 			power_gravity_ui_activate = false;
// 		};
// 	";

// 	inGameUISetEventHandler ["PrevAction", _activate_gravity_ui];
// 	inGameUISetEventHandler ["NextAction", _activate_gravity_ui];
	

// 	onEachFrame {
// 		if (isActionMenuVisible && power_gravity_ui_activate) then {

// 			if(cursorTarget isKindOf "Man") then {
// 				if(!power_gravity_ui_has_text) then {
// 					power_gravity_ui_has_text = true;
// 					cutText ["<br /><br /><t color='#0000ff' size='3'>Posséder</t>", "PLAIN", -1, false, true];
// 				};
// 			} else {
// 				if(power_gravity_ui_has_text) then {
// 					power_gravity_ui_has_text = false;
// 					cutText ["", "PLAIN", -1, false, true];
// 				};
// 			};
// 		} else {
// 			if(power_gravity_ui_has_text) then {
// 				power_gravity_ui_has_text = false;
// 				cutText ["", "PLAIN", -1, false, true];
// 			};
// 		};
// 	};
// };

power_gravity_effect = {
	_unit = vehicle cursortarget;
	_unit call power_gravity_main_rotate;
};

power_gravity_can_gravity = {

	_target = cursorTarget;

	if(player distance _target > power_gravity_distance) then {
		systemChat ("Impossible distance > " + str (power_gravity_distance call secure_meter_to_text));
		hint "Impossible de cibler un joueur";
		false;
	} else {
		switch (true) do
		{
			case (isPlayer _target && _target isKindOf "Man"): { // systemchat "Player";
				// Player
				systemChat "Impossible de cibler un joueur";
				hint "Impossible de cibler un joueur";
				false;
			};
			case (!isPlayer _target && {_target isKindOf "Man"}); // systemchat "AI";
			case (_target isKindOf "Car"); // systemchat "CAR";
			case (_target isKindOf "Tank"); // systemchat "TANK";
			case (_target isKindOf "Motorcycle"); // systemchat "Motorcycle";
			case (_target isKindOf "Ship"); // systemchat "Ship";
			case (_target isKindOf "Helicopter"); // systemchat "Helicopter";
			case (_target isKindOf "Plane"); // systemchat "Plane";
			case (_target isKindOf "StaticWeapon"): { // systemchat "Static Weapon";
				// Vehicle ?
				true;
			};
			// case (_target isKindOf "Building"); // systemchat "Building";
			// case (_target isKindOf "Wreck"); // systemchat "Wreck";
			// case (_target isKindOf "ReammoBox_F"); // systemchat "A BOX";
			// case (_target isKindOf "MineGeneric"): { // systemchat "A Mine"; 
			// 	// Object ?
			// };
			default {
				systemChat "Personne à cibler !";
				hint "Personne à cibler !";
				false;
			};
		};
	};
};


power_gravity_show_name = {

	_target = cursorTarget;
	if(switch (true) do
	{
		case (isPlayer _target && _target isKindOf "Man"): { // systemchat "Player";
			false;
		};
		case (!isPlayer _target && {_target isKindOf "Man"}); // systemchat "AI";
		case (_target isKindOf "Car"); // systemchat "CAR";
		case (_target isKindOf "Tank"); // systemchat "TANK";
		case (_target isKindOf "Motorcycle"); // systemchat "Motorcycle";
		case (_target isKindOf "Ship"); // systemchat "Ship";
		case (_target isKindOf "Helicopter"); // systemchat "Helicopter";
		case (_target isKindOf "Plane"); // systemchat "Plane";
		case (_target isKindOf "StaticWeapon"): { // systemchat "Static Weapon";
			true;
		};
		default {
			false;
		};
	}) then {
		cursorTarget call common_power_get_display_name;
	} else {
		"";
	};
};

power_gravity_main_rotate = {
	[_this, 0.3 - random 0.6, false, 2000, 3 + random 2, 0.01, 0.3 - random 0.6, 0.3 - random 0.6] remoteExec ["power_gravity_server_rotate", 2];
};