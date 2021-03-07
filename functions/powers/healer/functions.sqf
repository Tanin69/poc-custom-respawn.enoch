
// If already initiated
// if (!(isNil "power_healer_init")) exitWith { };
// power_healer_init = true;

// power_healer_heal_target = {
// 	_target = [3] call common_power_cursorTarget_or_self;

// 	_target call power_regenerate_heal_tick;
// 	_target setVariable ['ace_medical_hasPain', false, true];
// };

// power_healer_full_heal_target = {
// 	_target = [3] call common_power_cursorTarget_or_self;
// 	[objNull, _target] call ace_medical_fnc_treatmentAdvanced_fullHeal;
// };

power_healer_ui_set_default_material = {
	params ["_unit"];

	_unit setObjectMaterial [0,"\a3\data_f\default.rvmat"]; 
	(backpackContainer _unit) setObjectMaterial [0,"\a3\data_f\default.rvmat"];	
};


power_healer_ui_set_glowing_material = {
	params ["_unit", "_mat"];

	_unit setObjectMaterial [0, _mat]; 
	(backpackContainer _unit) setObjectMaterial [0, _mat];
};

power_healer_ui_init = {
	player setVariable ['power_healer_target', objNull];
	player setVariable ['power_healer_target_old', objNull];
	power_healer_ui_show_target = false;
	power_healer_ui_show_target_texture = '';

	// _trimHtml = (((_this splitString ">") select [1,100]) apply {(_x splitString "<") #0}) joinString "";
	_trimHtml = _this call string_remove_html_tag;
	_trimHtml = [_trimHtml, "Se soigner", "Pouvoir de soin" ] call string_replace;
	_trimHtml = _trimHtml call string_remove_all_spaces;

	_activate_healer_ui = "
		if ( ((_this #4) call string_remove_all_spaces) == " + (str _trimHtml) + " ) then {
			power_healer_ui_show_target = true;
		} else {
			power_healer_ui_show_target = false;
		};
	";

	inGameUISetEventHandler ["PrevAction", _activate_healer_ui];
	inGameUISetEventHandler ["NextAction", _activate_healer_ui];
	
	/*
		_unit setObjectMaterial [0, "a3\characters_f_bootcamp\common\data\vrarmoremmisive.rvmat"]; 
		(backpackContainer _unit) setObjectMaterial [0, "a3\characters_f_bootcamp\common\data\vrarmoremmisive.rvmat"];
	*/

	onEachFrame {
		if (isActionMenuVisible && power_healer_ui_show_target) then {

			_target = player getVariable ['power_healer_target', objNull];
			_old_target = player getVariable ['power_healer_target_old', objNull];

			if(_target != _old_target) then {

				if(!(isNull _old_target)) then {
					_old_target setObjectTexture [0, power_healer_ui_show_target_texture];
					// [_old_target, power_healer_ui_show_target_texture] call power_healer_ui_set_glowing_material;
					// [_old_target] call power_healer_ui_set_default_material;
					player setVariable ['power_healer_target_old', objNull];

					// systemChat str ['OldTarget not null', _old_target, power_healer_ui_show_target_texture];
				};

				if((!(isNull _target))) then {

					power_healer_ui_show_target_texture = (getObjectTextures _target)#0;
					// power_healer_ui_show_target_texture = (getObjectMaterials _target)#0;
					 
					_target setObjectTexture [0,"#(rgb,8,8,3)color(0.2,1,0.1,1)"];
					// [_target, "a3\characters_f_bootcamp\common\data\vrarmoremmisive.rvmat"] call power_healer_ui_set_glowing_material;

					player setVariable ['power_healer_target_old', _target];

					// systemChat str ['Target not null', _target, power_healer_ui_show_target_texture];
				};
			};

		} else {
			_target = player getVariable ['power_healer_target', objNull];
			_old_target = player getVariable ['power_healer_target_old', objNull];
			if(!(isNull _target) && !(isNull _old_target)) then {
				_target setObjectTexture [0, power_healer_ui_show_target_texture];
				_old_target setObjectTexture [0, power_healer_ui_show_target_texture];
				// [_target, power_healer_ui_show_target_texture] call power_healer_ui_set_glowing_material;
				// [_target] call power_healer_ui_set_default_material;
				// [_old_target] call power_healer_ui_set_default_material;
				player setVariable ['power_healer_target', objNull];
				player setVariable ['power_healer_target_old', objNull];


				// systemChat str ['END not null', _old_target, power_healer_ui_show_target_texture];
			};
		};
	};
};





power_healer_hold_power_with_cooldown_desactivate = {
	// secure if call the function and not spawn
	_this spawn {
		params ['_power_id'];
		waitUntil { sleep 1; !(player getVariable [_power_id, true]) };
		{
			[_x, _x getVariable (_power_id + '_cooldown_actionId')] call BIS_fnc_holdActionRemove;
		} forEach playableUnits;
	}
};



power_healer_heal_target = {
	params ["_target", "_caller", "_actionId", "_arguments", "_progress", "_maxProgress"];
	// _target = [3] call common_power_cursorTarget_or_self;

	_target call power_regenerate_heal_tick;
	_target setVariable ['ace_medical_hasPain', false, true];
};

power_healer_full_heal_target = {
	params ["_target", "_caller", "_actionId", "_arguments"];
	// _target = [3] call common_power_cursorTarget_or_self;

	[objNull, _target] call ace_medical_fnc_treatmentAdvanced_fullHeal;
};