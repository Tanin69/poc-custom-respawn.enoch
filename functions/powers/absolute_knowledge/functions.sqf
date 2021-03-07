
// If already initiated
if (!(isNil "power_absolute_knowledge_init")) exitWith { };
power_absolute_knowledge_init = true;


power_absolute_knowledge_show_own_position_on_map = {

	_marker = createMarkerlocal [format ["OwnManMarker_%1", player], visiblePosition player];  
	format ["OwnManMarker_%1", player] setMarkerTypelocal "Mil_dot";  

	_marker_color = switch (side player) do {
		case east: { "ColorRed"; }; 
		case blufor: { "ColorBlue"; }; 
		case independent: { "ColorGreen"; }; 
		default { "ColorBlack"; }; 
	}; 

	format ["OwnManMarker_%1", player] setMarkerColorlocal _marker_color;  
	_own_marker = (format ["OwnManMarker_%1", player]);

	while { player getVariable ['power_absolute_knowledge', true] && alive player} do {
		_own_marker setMarkerPosLocal (visiblePosition (vehicle player)); 
	};

	deleteMarkerlocal _own_marker;
};

power_absolute_knowledge_show_units_on_map = {
	// _this == player

	_this spawn { 
		_markedmen =[];  
		{  
			if ((_x IsKindof 'Man') && (_x != player)) then   
			{  
				if(power_absolute_knowledge_distance <= 0 || player distance2D _x <= power_absolute_knowledge_distance) then {
					_marker = createMarkerlocal [format ["ManMarker_%1", _x], visiblePosition _x];  
					format ["ManMarker_%1", _x] setMarkerTypelocal (if (vehicle _x != _x) then { "mil_box"; } else { "Mil_dot"; });  

					_marker_color = switch (side _x) do {
						case east: { "ColorRed"; }; 
						case blufor: { "ColorBlue"; }; 
						case independent: { "ColorGreen"; }; 
						default { "ColorBlack"; }; 
					}; 

					format ["ManMarker_%1", _x] setMarkerColorlocal _marker_color;  
					_markedmen pushBack [(format ["ManMarker_%1", _x]), _x];
				};
			};
		} forEach allUnits;  

		// Update data during 29sec
		[_markedmen] spawn {
			params ['_markedmen'];
			_step = 0.05;
			for [{_i = 1}, { _i <= power_absolute_knowledge_show_time/_step }, {_i = _i + 1}] do {
				{ (_x#0) setMarkerPosLocal (visiblePosition (_x#1)); } foreach _markedmen; 
				sleep _step;
			};
		};

		// Disapear after 10 + during 20sec
		sleep power_absolute_knowledge_show_time - power_absolute_knowledge_blur_time;

		_step = power_absolute_knowledge_blur_time / 100;
		for [{_i = 1}, {_i >= 0}, {_i = _i - 0.01}] do {
			{ (_x#0) setMarkerAlphaLocal _i; } foreach _markedmen; 
			sleep _step;
		};

		{deleteMarkerlocal (_x#0)} foreach _markedmen; 
	}; 

};

