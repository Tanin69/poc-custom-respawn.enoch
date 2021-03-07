_power_id = 'power_infinite_stamina';
if(player getVariable [_power_id, false]) exitWith {};

// Power activated!
player setVariable [_power_id, true, true];


old_ace_advanced_fatigue_TerrainGradientFactor = ace_advanced_fatigue_TerrainGradientFactor;
old_ace_advanced_fatigue_Enabled = ace_advanced_fatigue_Enabled;
old_ace_advanced_fatigue_LoadFactor = ace_advanced_fatigue_LoadFactor;
old_ace_advanced_fatigue_RecoveryFactor = ace_advanced_fatigue_RecoveryFactor;



ace_advanced_fatigue_TerrainGradientFactor = 0;
ace_advanced_fatigue_Enabled = false;
ace_advanced_fatigue_LoadFactor = -1;
ace_advanced_fatigue_RecoveryFactor = 3000;

player enableFatigue false;
player enableStamina false;

[
	_power_id, 
	"Pouvoir inépuisable", 
	"Courir sur des distances quasi infinie sans problème mise à part peut être devoir récupérer sa respiration."
] call common_power_description_init;

waitUntil { sleep 1; !(player getVariable [_power_id, true]) };

ace_advanced_fatigue_TerrainGradientFactor = old_ace_advanced_fatigue_TerrainGradientFactor;
ace_advanced_fatigue_Enabled = old_ace_advanced_fatigue_Enabled;
ace_advanced_fatigue_LoadFactor = old_ace_advanced_fatigue_LoadFactor;
ace_advanced_fatigue_RecoveryFactor = old_ace_advanced_fatigue_RecoveryFactor;

player enableFatigue true;
player enableStamina true;
