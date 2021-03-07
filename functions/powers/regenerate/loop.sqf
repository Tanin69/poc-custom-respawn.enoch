

// #define DEFAULT_HEART_RATE 80
// #define DEFAULT_PERIPH_RES 100
// #define BLOOD_VOLUME_FATAL 3.0 // Lost more than 50% blood, Unrecoverable


// #define VAR_BLOOD_PRESS QEGVAR(medical,bloodPressure)
// #define VAR_BLOOD_VOL   QEGVAR(medical,bloodVolume)
// #define VAR_CRDC_ARRST  QEGVAR(medical,inCardiacArrest)
// #define VAR_HEART_RATE  QEGVAR(medical,heartRate)
// #define VAR_PAIN        QEGVAR(medical,pain)
// #define VAR_PAIN_SUPP   QEGVAR(medical,painSuppress)
// #define VAR_PERIPH_RES  QEGVAR(medical,peripheralResistance)
// #define VAR_UNCON       "ACE_isUnconscious"


// #define GET_BLOOD_VOLUME(unit)      (unit getVariable [VAR_BLOOD_VOL,DEFAULT_BLOOD_VOLUME])
// #define GET_HEART_RATE(unit)        (unit getVariable [VAR_HEART_RATE,DEFAULT_HEART_RATE])
// #define GET_HEMORRHAGE(unit)        (unit getVariable [VAR_HEMORRHAGE,0])
// #define GET_PAIN(unit)              (unit getVariable [VAR_PAIN,0])
// #define GET_PAIN_SUPPRESS(unit)     (unit getVariable [VAR_PAIN_SUPP,0])
// #define GET_TOURNIQUETS(unit)       (unit getVariable [VAR_TOURNIQUET, DEFAULT_TOURNIQUET_VALUES])
// #define IN_CRDC_ARRST(unit)         (unit getVariable [VAR_CRDC_ARRST,false])
// #define IS_BLEEDING(unit)           (unit getVariable [VAR_IS_BLEEDING,false])
// #define IS_IN_PAIN(unit)            (unit getVariable [VAR_IN_PAIN,false])
// #define IS_UNCONSCIOUS(unit)        (unit getVariable [VAR_UNCON,false])


[] spawn {
	// Cannot DIE!
	_old_ace_medical_playerDamageThreshold = ace_medical_playerDamageThreshold;
	_old_ace_medical_fatalDamageSource = ace_medical_fatalDamageSource;
	_old_ace_medical_const_heartHitChance = ace_medical_const_heartHitChance;
	_old_ace_medical_const_headDamageThreshold = ace_medical_const_headDamageThreshold;
	_old_ace_medical_const_organDamageThreshold = ace_medical_const_organDamageThreshold;
	_old_ace_medical_spontaneousWakeUpEpinephrineBoost = ace_medical_spontaneousWakeUpEpinephrineBoost;

	ace_medical_playerDamageThreshold = power_regenerate_playerDamageThreshold;
	ace_medical_fatalDamageSource = 1;
	ace_medical_const_heartHitChance = -1;
	ace_medical_const_headDamageThreshold = 5;
	ace_medical_const_organDamageThreshold = 5;
	ace_medical_spontaneousWakeUpEpinephrineBoost = 900;

	// Until the power is activated
	while  { player getVariable ['power_regenerate', false] } do {
		sleep power_regenerate_loop_tick;
		// The real effects
		execVM "functions\powers\regenerate\loopEffects.sqf";
	};

	// Now you can die!
	ace_medical_playerDamageThreshold = _old_ace_medical_playerDamageThreshold;
	ace_medical_fatalDamageSource = _old_ace_medical_fatalDamageSource;
	ace_medical_const_heartHitChance = _old_ace_medical_const_heartHitChance;
	ace_medical_const_headDamageThreshold = _old_ace_medical_const_headDamageThreshold;
	ace_medical_const_organDamageThreshold = _old_ace_medical_const_organDamageThreshold;
	ace_medical_spontaneousWakeUpEpinephrineBoost = _old_ace_medical_spontaneousWakeUpEpinephrineBoost;
};

