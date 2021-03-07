/*
  Author: tanin69
  Refuel the tank of a fuel vehicle from a nearby fuel station
 
  Arguments:
  0: Vehicle that the tank is to be refueled <OBJECT>
  1: Refuel station <OBJECT>
  2: Refueling area : area in which the vehicle must be to be refueled. If the vehicle leaves the area during refuling, the operation is cancelled <OBJECT - Trigger>
  3: (optional, default : 10000) Tank capacity of the vehicle <NUMBER>
 
  Return value:
  Nothing
 
  Example : [veh, fuelStation, trgRefuel, 5000] call fn_refuelTank.sqf
 
 */

params[
	"_vehicle", 
	"_station",
	"_area",
	["_tankCapacity", 10000]
];

private _tankLoad = 0;                 //Quantity of fuel in the vehicle tank
private _stationQuantity = 0;          //Quantity of fuel in the fuel station
private _refuelNeededQuantity = 0;     //Quantity of fuel to fill the vehicle tankto its maximum
private _refuelDeliveredQuantity = 0;  //Quantity of fuel delivered by the station

//Verify quantity of fuel in the vehicle tank
_tankLoad = [_vehicle] call ace_refuel_fnc_getFuel;

//Calculate the quantity required to refuel (to be removed from the station)
_refuelNeededQuantity = _tankCapacity - _tankLoad;

//Verify the quantity of fuel in the station
_stationQuantity = [_station] call ace_refuel_fnc_getFuel;

//If the station is empty, exit with no refuel for the vehicle
if (_stationQuantity == 0) exitWith {hint "La station ne contient plus de fuel, aucun ravitaillement n'a été effectué.";};

//If there is enough fuel in the station to refuel the vehicle to its maximum
if (_stationQuantity >= _refuelNeededQuantity) then {
	
	_refuelDeliveredQuantity = _refuelNeededQuantity;
	[
		_refuelDeliveredQuantity * 0.01,
		[_vehicle, _station, _area, _tankCapacity, _stationQuantity, _refuelNeededQuantity],
		{
			params ["_args"];
			_args params ["_vehicle", "_station", "_area", "_tankCapacity", "_stationQuantity","_refuelNeededQuantity"];
			//Update quantity of fuel in the station
			_stationQuantity = _stationQuantity - _refuelNeededQuantity;
			//Update quantity of fuel in the vehicle tank
			[_vehicle, _tankCapacity] call ace_refuel_fnc_setFuel;
			_refuelDeliveredQuantity = _refuelNeededQuantity;
			[_station, _stationQuantity] call ace_refuel_fnc_setFuel;
			[["%1 litres de carburant ajoutés à la citerne. %2 litres restant dans la station.", _refuelDeliveredQuantity, _stationQuantity],2.5] call ace_common_fnc_displayTextStructured;
		},
		{
			["Ravitaillement de la citerne interrompu. Aucun carburant n'a été transféré.",2.5] call ace_common_fnc_displayTextStructured;
		},
		"Ravitaillement en cours",		
		{
			params ["_args"];
			_args params ["_vehicle", "_station", "_area"];
			_vehicle inArea _area;
		}
		
	] call ace_common_fnc_progressBar
	
} else { //Else, refuel the vehicle with the remaining quantity of fuel in the station

	_refuelDeliveredQuantity = _stationQuantity;

	[
		_refuelDeliveredQuantity * 0.01,
		[_vehicle, _station, _area, _tankCapacity, _stationQuantity, _refuelDeliveredQuantity, _tankLoad],
		{
			params ["_args"];
			_args params ["_vehicle","_station", "_area", "_tankCapacity", "_stationQuantity", "_refuelDeliveredQuantity", "_tankLoad"];
			[_vehicle, _refuelDeliveredQuantity + _tankLoad] call ace_refuel_fnc_setFuel;
			_stationQuantity = 0;
			[_station, _stationQuantity] call ace_refuel_fnc_setFuel;
			[["%1 litres de carburant ajoutés à la citerne. %2 litres restant dans la station.", _refuelDeliveredQuantity, _stationQuantity],2.5] call ace_common_fnc_displayTextStructured;
		},
		{["Ravitaillement de la citerne interrompu.Aucun carburant n'a été transféré.",2.5] call ace_common_fnc_displayTextStructured;},
		"Ravitaillement en cours",
		{
			params ["_args"];
			_args params ["_vehicle", "_station", "_area"];
			_vehicle inArea _area;
		}
	] call ace_common_fnc_progressBar

};
