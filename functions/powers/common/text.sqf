
secure_meter_to_text = {
	(
		if(_this >= 0) then {
			_this; 
		} else {
			20000;
		}
	) call meter_to_text;
};

meter_to_text = {
	if(_this <= 0) then {
		"-";
	} else {
		_txt = [];

		if(_this > 1000) then {
			_txt pushBack (str (floor (_this / 1000)) + "km"); 
		};

		if(_this % 1000 != 0) then {
			_txt pushBack (str (_this % 1000) + "m");
		};

      	_txt joinString ", ";
	};
};


seconde_to_text = {
	if(_this <= 0) then {
		"-";
	} else {

		_time = _this;
		_txt = [];

		if(_time % 60 > 0) then { _txt pushBack (str (_time % 60) + "s"); }; 
		_time = floor (_time / 60);
		if(_time % 60 > 0) then { _txt pushBack (str (_time % 60) + "m"); }; 
		_time = floor (_time / 60);
		if(_time % 24 > 0) then { _txt pushBack (str (_time % 24) + "h"); }; 
		_time = floor (_time / 24);
		if(_time > 0) then { _txt pushBack (str (_time) + "j"); };

		reverse _txt;
      	_txt joinString " ";
	};
};
