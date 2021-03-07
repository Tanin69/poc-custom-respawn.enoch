COOLDOWN_INCREMENT = 20;
HEX_REF = "0123456789ABCDEF" splitString "";

int_to_hex = {
	_hex = ""; 
	_num = _this; 

	while{ _num > 0 } do { 
		_current = _num / 16; 
		_num = floor _current;
		_hex = (HEX_REF select ((floor ((_current - _num)*16) mod 16))) + _hex; 
	}; 

	_hex; 
};

int_to_2hex = {
	_hex = _this call int_to_hex;
	if(count _hex == 1) then {
		"0" + _hex;
	} else {
		_hex;
	};
};

common_power_with_cooldown_effect_text = {

	// [                    ]
	// to 
	// [--------------------]

	_text = "[";
	for "_i" from 1 to (_this min COOLDOWN_INCREMENT) do {
		_text = _text + "-";
	};

	for "_i" from (_this min COOLDOWN_INCREMENT) to COOLDOWN_INCREMENT do {
		_text = _text + " ";
	};

	_text = _text + "]";

	_text;
};

common_power_with_cooldown_effect_color = {
	_scale = 255 / ( COOLDOWN_INCREMENT / 2 );

	switch (true) do {
		case (_this <= 0): { "FF0000" };
		case (_this >= COOLDOWN_INCREMENT): { "00FF00" };
		case (_this < COOLDOWN_INCREMENT / 2): {
			"FF" + ( (_this * _scale ) call int_to_2hex ) + "00";
		};
		default {
			( (255 - ((_this - COOLDOWN_INCREMENT / 2) * _scale) ) call int_to_2hex ) + "FF00";
		};
	};
};

common_power_with_cooldown_effect_ready_text = {
	params ['_actionId', '_power_name', '_calculate_target'];
	player setUserActionText [
		_actionId,
		"<t color='#00ff00'>" + _power_name + "</t>",
		"<t color='#00ff00'>Prêt</t>",
		"<br>" + (call _calculate_target)
	];
};

common_power_with_cooldown_target = {
	_this spawn {
		params ['_actionId', '_power_id', '_calculate_target'];
		while { (player getVariable [_power_id, false]) } do {
			(player actionParams _actionId) params [
				'_title', // String - action title text
				'_script', // String - script file or script expression assigned to the action
				'_arguments', // Anything or nil - arguments passed to the action
				'_priority', // Number - action priority on the action menu
				'_showWindow', // Boolean - whether the action is shown in the center of the screen too
				'_hideOnUse', // Boolean - whether the action menu should close after selecting the action
				'_shortcut', // String - action bindings to some existing engine action if any
				'_condition', // String - expression returning true or nil for action to appear on the action menu
				'_radius', // Number - max distance to entity at which action becomes available. -1 means it is engine default (~15m)
				'_unconscious', // Boolean - whether the action is available to unconscious person
				'_textWindowBackground', // String - same as textWindowBackground in setUserActionText
				'_textWindowForeground', // String - same as textWindowForeground in setUserActionText
				'_selection', // String - named selection in Geometry LOD to which the action is attached
				'_memoryPoint' // String - memory point on the object to which the action is attached
			];

			player setUserActionText [
				_actionId,
				_title,
				_textWindowBackground,
				"<br/>" + (call _calculate_target)
			];

			sleep 0.5;
		};
	};
};

common_power_with_cooldown_effect = {
	params ['_target', '_actionId', '_cooldown_var', '_power_name', '_time_start', '_calculate_target'];

	_time_end = player getVariable [_cooldown_var, 0];
	_time_step = (_time_end - _time_start) / COOLDOWN_INCREMENT;

	for [{ _i = 0 }, { _i < COOLDOWN_INCREMENT }, { _i = _i + 1 }] do {

		// Change the texte of the action
		player setUserActionText [
			_actionId,
			"<t color='#" + (_i call common_power_with_cooldown_effect_color) + "'>" + _power_name + "</t>",
			"<t color='#" + (_i call common_power_with_cooldown_effect_color) + "'>" + (_i call common_power_with_cooldown_effect_text) + "</t>"
		];

		sleep _time_step;
	};

	[_actionId, _power_name, _calculate_target] call common_power_with_cooldown_effect_ready_text;
};

common_power_get_display_name = {
	private ["_suppliedtype", "_type", "_cfg_type", "_data",  "_ret"];
	params ["_suppliedtype"];

	if ((typeName _suppliedtype) == "OBJECT") then {
		_type = (typeof _suppliedtype);
	} else {
		_type = _suppliedtype;
	};

    switch (true) do
    {
        case(isClass(configFile >> "CfgMagazines" >> _type)): {_cfg_type = "CfgMagazines"};
        case(isClass(configFile >> "CfgWeapons" >> _type)): {_cfg_type = "CfgWeapons"};
        case(isClass(configFile >> "CfgVehicles" >> _type)): {_cfg_type = "CfgVehicles"};
        // case(isClass(configFile >> "CfgAmmo" >> _type)): {_cfg_type = "CfgAmmo"};
        case(isClass(configFile >> "CfgGlasses" >> _type)): {_cfg_type = "CfgGlasses"};
		default { };
    };

	if (isNil "_cfg_type") exitWith { "" };

	_hierarchy = configHierarchy (configFile >> "CfgVehicles" >> "Car");
	_ret = getText (configFile >> _cfg_type >> _type >> "displayName");
	_ret;
};


common_power_description_init = {
	params ['_power_id', '_title', '_description'];

	_record_rec = player createDiaryRecord ["Diary", [_title, _description]];

	// secure if call the function and not spawn
	[_power_id, _record_rec] spawn {
		waitUntil { sleep 1; !(player getVariable [_this#0, true]) };
		// TODO: To fixe, crash the command
		// player removeDiaryRecord ["diary", _record_rec];
	};
};


common_power_cursorTarget_or_self = {
	params [['_max_distance', 3], ['_currentTarget', cursorTarget]];

	_target = player;
	if(_currentTarget isKindOf "Man") then {
		if((player distance _currentTarget) <= _max_distance) then {
			_target = _currentTarget;
		};
	};

	_target;
};

string_replace = {
  params ["_str", "_toFind", "_subsitution"];
  _char = count _toFind;
  _no = _str find _toFind;
  while {-1 != _str find _toFind} do {
      _no = _str find _toFind;
      _splitStr = _str splitString "";
      _splitStr deleteRange [(_no +1), _char -1];
      _splitStr set [_no, _subsitution];
      _str = _splitStr joinString "";
  };
  _str
};


string_remove_html_tag = {
	_str = _this splitString ">";
	if(count _str == 1) then {
		_this;
	} else {
		((_str select [1, count _str]) apply {(_x splitString "<") #0}) joinString "";
	};
};

string_remove_all_spaces = {
	_this splitString " " joinString ""; 
};