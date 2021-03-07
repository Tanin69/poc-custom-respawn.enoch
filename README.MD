# Style de jeu Arma 3 Marathon, un POC simple pour tester un respawn customisé

## Pourquoi le style de jeu "Marathon"?

Dans notre communauté, nous n'utilisons jamais de respawn: un joueur tué est tué, et le jeu est terminé pour lui, même s'il meurt dans les premières minutes du jeu (et après près de 30/40 minutes de briefing et d'insertion). C'est parce que nous aimons un jeu très punitif. C'est une valeur très forte dans notre communauté pour de nombreuses raisons.

De plus, il est extrêmement rare que nous utilisions le mode Zeus, car nous préférons généralement jouer contre une véritable IA, une mission entièrement scriptée, pas avec un humain dans les coulisses durant la partie.

Mais, en tant que créateur de mission, j'aimerais organiser des jeux à grande échelle, avec des durées longues ou très longues (3 heures ou plus), pour des évènements exceptionnels (nostalgie de conflit de canards 'reloaded'). Ce n'est évidemment pas possible sans une sorte de système de respawn. Mais la mort doit rester très très punitive pour préserver notre style de jeu (bonne planification, jeu très dur et hard skills pour le chef d'opération et tous les joueurs).

## Description fonctionnelle

Les joueurs ne peuvent réapparaître qu'à certaines phases du jeu et dans des conditions définies par le créateur de la mission, contrôlées par le chef de l'opération.

### Que se passe-t-il lorsque le joueur meurt?

* Lorsqu'un joueur meurt, il est mis en mode spectateur
* Idéalement, le mode spectateur est personnalisé:
  * Le joueur ne peut voir que les unités hostiles à proximité immédiate des joueurs vivants
* il ne peut pas réapparaître tant que les conditions définies ne sont pas remplies

### Comment les joueurs réapparaissent-ils?

#### Premier exemple de règles

* Seul le chef de l'opération peut déclencher la réapparition
* Lorsqu'il déclenche la réapparition, tous les joueurs en attente en mode spectateur réapparaissent: le chef ne peut pas choisir qui réapparaît ou non
* Pour que le chef puisse déclencher une réapparition, certaines conditions doivent être remplies. Ces conditions peuvent être (une ou plusieurs ou toutes):
  * Un délai
  * Une zone où les respawn sont autorisés
  * La réussite de certaines tâches ou objectifs

## Implémentation basique

### Configuration de Respawn -> Eden (ou description.ext)

Dans les attributs de mission :

* Respawn on custom position
* Respawn delay : osef

### onPlayerKilled.sqf

```sqf 
setPlayerRespawnTime 28800
```
(valeur calée à 8 heures, sera modifiée dynamiquement pendant la partie)

### définition des conditions de respawn

On se contente de vérifier la valeur d'une variable globale par un pseudo gestionnaire d'événement :

### initPlayerLocal.sqf

```sqf
_condRespawn = ["ConditionalRespawn"] spawn {
	while { true && !goRsp} do {
		waitUntil {goRsp};
		setPlayerRespawnTime 5;
		sleep 5;
		goRsp = false;
	};
};
```

### Test

* Créer une mission
* Paramétrer les attributs de mission dans Eden
* Placer une unité jouable
* Lancer la mission *en mode multijoueurs*
* Dans la console de débogage, exécuter :

```sqf
player setDamage 1
```

-> Vous êtes mort et passez en vue spectateur

* Dans la console de débogage, exécuter :

```sqf
isRespawnCondMet = true
```

-> Vous réapparaissez

## Implémentation plus complète

### En mode spectateur, masquer les unités hostiles éloignées des joueurs vivants pour éviter le spoil

#### onPlayerkilled.sqf

```sqf
setPlayerRespawnTime 28800;

//Enter spectator mode
["Initialize", [player, [], true, true, true, true, true, true, true, true]] call BIS_fnc_EGSpectator;

//Hide hostile units that are not in vincinity of alive players to prevent spoil (thanks to VDauphin for the code optim !)
//Average loop execution time : 8ms (heavy !). Execution every 10 s. seems to be a good balance
while {!alive player} do {

	{hideObject _x;} count units opSide; //opSide variabale initialized in init.sqf
	{
		_alivePlayer = _x;
		{
			_x hideObject false;
		} forEach ((units opSide) inAreaArray [getPosWorld _alivePlayer, 500, 500]);

	} forEach (playableUnits + (switchableUnits select {_x != HC_Slot}));
	sleep 10;
};
```

### Définir des conditions de validation du respawn

Pour le POC, les conditions sont :

* Seul le leader d'opération peut déclencher le respawn. Pour cela, il doit posséder un objet particulier dans son inventaire. Ici, on a pris le téléphone mobile ACE parce que le leader a le 06 de Dieu.
* Le nombre de tickets de respawn doit être supérieur à 0. Charge au créateur de mission de gérer ce nombre à partir de conditions de type objectif rempli, etc.
* Il ne doit pas y avoir d'hostile dans les 300 m. autour du leader au moment où il déclenche le respawn

Déclenchement du respawn : sur valeur d'une variable, initialisée via une action ACE sur soi-même, quand les conditions sont réunies.

Initialisé dans le initPlayerLocal.sqf

```sqf
//ACE Self action to launch respawn  
_action = [ 
 "Respawn", 
 "Résusciter les morts", 
 "", 
	{ 
		goRsp = true; //Public variable that triggers the respawn (to be broadcast depending on where it updates) 
		publicVariable "goRsp";
		nbRspTck = nbRspTck -1; //Public variable that counts the tickets available to trigger the respawn (to be broadcast depending on where it is updated) 
		publicVariable "nbRspTck";
	}, 
	{
		//Check conditions to allow respawn
		//int_fnc_isInLoadout is a very simple function to ckeck the presence of an object in unit inventory 
		([player, "ACE_Cellphone"] call int_fnc_isInLoadout) &&	(nbRspTck > 0) && (count ((units opSide) inAreaArray [getPosWorld Player, 300, 300]) == 0);
	} 
] call ace_interact_menu_fnc_createAction;

[
 	player, 
 	1, 
 	["ACE_SelfActions"], 
 	_action 
] call ace_interact_menu_fnc_addActionToObject;
```

### onPlayerRespawn.sqf

```sqf
//Determine who is the leader at the moment by checking if unit has the "special item" in his inventory. If no leader is alive, no respawn is possible. But it would better to trap the error ;-)
{_x hideObject false;} count units opSide;

private _leader = "";
{
	if ([_x, "ACE_Cellphone"] call int_fnc_isInLoadout) then {
		_leader = _x;
	}
} forEach (playableUnits + (switchableUnits select {_x != HC_Slot}));

//Determine the respawn position : near the leader
private _rspPos = [[[position _leader,20]]] call BIS_fnc_randomPos;

[player, _rspPos, true] call BIS_fnc_moveToRespawnPosition;
```

Le script initPlayerLocal.sqf est inchangé



## Tests effectués sur dédié (merci nico57 !)

* Déco retour lobby/reco sur le même slot -> pas de souci, le joueur revient en mode spectateur
* Déco arma, retour lobby sur le même slot -> pas de souci, le joueur revient en mode spectateur
* Déco retour lobby, retour sur slot IA fermé -> retour vivant en jeu. Une IA pop sur le slot précédemment occupé par le joueur
* Verrouillage des slots -> les joueurs reviennent en mode spéctateur

## Ce qu'il reste à faire

* Gestion des loadout des joueurs au respawn, en fonction du contexte de mission (tout frais tout neuf, loadout qu'il avait lors de son décès...)
