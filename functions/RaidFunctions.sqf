//Максимум 12 Защ. 16 Ат.
//Минимум 6 Защ. 8 Ат.
prevBase = "Base1";

FREDDY_FNC_CREATERAID = {
[] spawn {
_baseArray = ["Base1","Base2","Base3"];
_baseArray deleteAt (_baseArray find prevBase);
_baseSelected = _baseArray call BIS_fnc_selectRandom;
prevBase = _baseSelected;

switch (true) do { 
  case (_baseSelected == "Base1") : {missionNamespace setVariable ["Base1Selected", true, true]; mrkPos = getPos BaseFlag1; posDef = getMarkerPos "DefSpawnBase1"; posAt = getMarkerPos "AtSpawnBase1";}; 
  case (_baseSelected == "Base2") : {missionNamespace setVariable ["Base2Selected", true, true]; mrkPos = getPos BaseFlag2; posDef = getMarkerPos "DefSpawnBase2"; posAt = getMarkerPos "AtSpawnBase2";};
  case (_baseSelected == "Base3") : {missionNamespace setVariable ["Base3Selected", true, true]; mrkPos = getPos BaseFlag3; posDef = getMarkerPos "DefSpawnBase3"; posAt = getMarkerPos "AtSpawnBase3";}; 
  default {}; 
  };

missionNamespace setVariable ["RaidWarmup",true, true];
//Тут создаются маркеры

call PENA_RAID_LIFES;

createMarker ["RaidEllipse", mrkPos];  
"RaidEllipse" setMarkerShape "ELLIPSE";  
"RaidEllipse" setMarkerType "ellipse";  
"RaidEllipse" setMarkerBrush "SolidBorder";  
"RaidEllipse" setMarkerSize [4000,4000];  
"RaidEllipse" setMarkerColor "ColorOrange"; 
 
createMarker ["RaidText", mrkPos];   
"RaidText" setMarkerType "hd_warning"; 
"RaidText" setMarkerText "Рейд"; 
"RaidText" setMarkerColor "ColorWhite";

//Тут у нас игроки переносятся на стартовые позиции и получают переменные
{(_x call BIS_fnc_getUnitByUid) setVariable ["Defender", true, true]; diag_log name (_x call BIS_fnc_getUnitByUid)} forEach raidLobbyDef;
{(_x call BIS_fnc_getUnitByUid) setVariable ["Attacker", true, true]; diag_log name (_x call BIS_fnc_getUnitByUid)} forEach raidLobbyAt;
_countDef = count (allPlayers select {_x getVariable ["Defender", false]});
_countAt = count (allPlayers select {_x getVariable ["Attacker", false]});
{[(_x call BIS_fnc_getUnitByUid), posDef] remoteExec ["freddy_fnc_teleportDef", (_x call BIS_fnc_getUnitByUid), false]} forEach raidLobbyDef;
{[(_x call BIS_fnc_getUnitByUid), posAt] remoteExec ["freddy_fnc_teleportAttack", (_x call BIS_fnc_getUnitByUid), false]} forEach raidLobbyAt;

//Тут отчет обратный до начала рейда
_time = 120; 
while {_time > 0} do { 
_time = _time - 1;   
_s = format["Рейд начнется через: %1", [((_time)/60)+.01,"HH:MM"] call BIS_fnc_timetostring];
_t = str(_s);
"RaidText" setMarkerText _t;

[_time] remoteExec ["Freddy_Fnc_UpdateTabletUntilStart", -2, false];
sleep 1; 
};
missionNamespace setVariable ["RaidWarmup",nil, true];

//Тут отчет обратный до конца рейда
missionNamespace setVariable ["Raid",true, true];
_time = 3600;

while {_time > 0 && missionNamespace getVariable ["Raid", false] == true && _countDef > 0 && _countAt > 0} do {
_countDef = count (allPlayers select {_x getVariable ["Defender", false]});
_countAt = count (allPlayers select {_x getVariable ["Attacker", false]}); 
_time = _time - 1;   
_s = format["Рейд закончится через: %1", [((_time)/60)+.01,"HH:MM"] call BIS_fnc_timetostring];
_t = str(_s);
"RaidText" setMarkerText _t;
[_time] remoteExec ["Freddy_Fnc_UpdateTabletUntilEnd", -2, false];
sleep 1; 
};

switch (true) do {
	case (_countAt > 0 && missionNamespace getVariable ["Raid", false] == false) : {call FREDDY_FNC_ENDRAIDATTACK;}; //Это значит что флаг захвачен
	case (_countDef > 0 && missionNamespace getVariable ["Raid", false] == true) : {call FREDDY_FNC_ENDRAIDDEF;}; //Это значит что время вышло и флаг не захвачен 
	case (_countAt > 0 && _countDef == 0 && missionNamespace getVariable ["Raid", false] == true) : {call FREDDY_FNC_ENDRAIDATTACK;}; //Это значит что убиты все защитники
	case (_countAt == 0 && _countDef > 0 && missionNamespace getVariable ["Raid", false] == true) : {call FREDDY_FNC_ENDRAIDDEF;}; //Это значит что убиты все атакующие
	default {call FREDDY_FNC_ENDRAIDDEF;}; 
};
	};
};

Freddy_Fnc_UpdateTabletUntilStart = {
_time = (_this select 0);
if (!isNull findDisplay 20999) then {
_s1 = format["%1", [((_time)/60)+.01,"HH:MM"] call BIS_fnc_timetostring];
_t1 = str(_s1);
ctrlSetText [20010, "До начала"]; 
ctrlSetText [20009, _t1];   
	};
};

Freddy_Fnc_UpdateTabletUntilEnd = {
_time = (_this select 0);
if (!isNull findDisplay 20999) then {
_s1 = format["%1", [((_time)/60)+.01,"HH:MM"] call BIS_fnc_timetostring];
_t1 = str(_s1);
ctrlSetText [20010, "До конца"]; 
ctrlSetText [20009, _t1];   
	};
};

//Скрипт захвата флага
FREDDY_FNC_CAPTUREFLAG = {
_unit = (_this # 0);
[_unit] spawn {
_unit = (_this # 0);
_time = 120;
missionNamespace setVariable ["CaptureInProgress", true, true];
  {"Участник атаки начал захват флага" remoteExec ["hintSilent", (_x call BIS_fnc_getUnitByUid), false]} forEach raidLobbyAt;
  {"Участник атаки начал захват флага" remoteExec ["hintSilent", (_x call BIS_fnc_getUnitByUid), false]} forEach raidLobbyDef; 
	while {_time > 0 && missionNamespace getVariable ["Raid", false] == true && lifeState _unit != "INCAPACITATED" && _unit distance BaseFlag1 <= 15 && isNull objectParent player} do { 
  _time = _time - 1;
  _result = format ["До захвата: %1", [((_time)/60)+.01,"HH:MM"] call BIS_fnc_timetostring];      
  [_result] remoteExec ["hintSilent", _unit , false];
  sleep 1; 
};
if (_time == 0 && lifeState _unit != "INCAPACITATED" && alive _unit) then {call FREDDY_FNC_ENDRAIDATTACK;} else {{"Захват сбит" remoteExec ["hintSilent", (_x call BIS_fnc_getUnitByUid), false]} forEach raidLobbyAt; {"Захват сбит" remoteExec ["hintSilent", (_x call BIS_fnc_getUnitByUid), false]} forEach raidLobbyDef; missionNamespace setVariable ["CaptureInProgress", nil, true];};
	};
};

FREDDY_FNC_CAPTUREFLAGATLAS = {
_unit = (_this # 0);
[_unit] spawn {
_unit = (_this # 0);
_time = 120;
missionNamespace setVariable ["CaptureInProgress", true, true];
  {"Участник атаки начал захват флага" remoteExec ["hintSilent", (_x call BIS_fnc_getUnitByUid), false]} forEach raidLobbyAt;
  {"Участник атаки начал захват флага" remoteExec ["hintSilent", (_x call BIS_fnc_getUnitByUid), false]} forEach raidLobbyDef; 
  while {_time > 0 && missionNamespace getVariable ["Raid", false] == true && lifeState _unit != "INCAPACITATED" && _unit distance BaseFlag2 <= 15 && isNull objectParent player} do { 
  _time = _time - 1;
  _result = format ["До захвата: %1", [((_time)/60)+.01,"HH:MM"] call BIS_fnc_timetostring];      
  [_result] remoteExec ["hintSilent", _unit , false];
  sleep 1; 
};
if (_time == 0 && lifeState _unit != "INCAPACITATED" && alive _unit) then {call FREDDY_FNC_ENDRAIDATTACK;} else {{"Захват сбит" remoteExec ["hintSilent", (_x call BIS_fnc_getUnitByUid), false]} forEach raidLobbyAt; {"Захват сбит" remoteExec ["hintSilent", (_x call BIS_fnc_getUnitByUid), false]} forEach raidLobbyDef; missionNamespace setVariable ["CaptureInProgress", nil, true];};
  };
};

FREDDY_FNC_CAPTUREFLAGSKOPOS = {
_unit = (_this # 0);
[_unit] spawn {
_unit = (_this # 0);
_time = 120;
missionNamespace setVariable ["CaptureInProgress", true, true];
  {"Участник атаки начал захват флага" remoteExec ["hintSilent", (_x call BIS_fnc_getUnitByUid), false]} forEach raidLobbyAt;
  {"Участник атаки начал захват флага" remoteExec ["hintSilent", (_x call BIS_fnc_getUnitByUid), false]} forEach raidLobbyDef; 
  while {_time > 0 && missionNamespace getVariable ["Raid", false] == true && lifeState _unit != "INCAPACITATED" && _unit distance BaseFlag3 <= 15 && isNull objectParent player} do { 
  _time = _time - 1;
  _result = format ["До захвата: %1", [((_time)/60)+.01,"HH:MM"] call BIS_fnc_timetostring];      
  [_result] remoteExec ["hintSilent", _unit , false];
  sleep 1; 
};
if (_time == 0 && lifeState _unit != "INCAPACITATED" && alive _unit) then {call FREDDY_FNC_ENDRAIDATTACK;} else {{"Захват сбит" remoteExec ["hintSilent", (_x call BIS_fnc_getUnitByUid), false]} forEach raidLobbyAt; {"Захват сбит" remoteExec ["hintSilent", (_x call BIS_fnc_getUnitByUid), false]} forEach raidLobbyDef; missionNamespace setVariable ["CaptureInProgress", nil, true];};
  };
};

//Скрипт победы защиты
FREDDY_FNC_ENDRAIDDEF = {
[] spawn {
_playersArray = allUnits inAreaArray "RaidEllipse";
_vehiclesArray = (vehicles inAreaArray "RaidEllipse"); 
"RaidText" setMarkerText "Победа защиты";
if (player getVariable ["Defender", false]==true) then {{(_x call BIS_fnc_getUnitByUid) setVariable ["Defender", nil, true];} forEach raidLobbyDef;};
if (player getVariable ["Attacker", false]==true) then {{(_x call BIS_fnc_getUnitByUid) setVariable ["Attacker", nil, true];} forEach raidLobbyAt;};
if (missionNamespace getVariable ["Base1Selected", false] == true) then {missionNamespace setVariable ["Base1Selected", nil, true];};
if (missionNamespace getVariable ["Base2Selected", false] == true) then {missionNamespace setVariable ["Base2Selected", nil, true];};
if (missionNamespace getVariable ["Base3Selected", false] == true) then {missionNamespace setVariable ["Base3Selected", nil, true];};
{["introLayer", ["<t size='2'>Победа защиты</t>", "PLAIN", 2, false, true]] remoteExec ["cutText", (_x call BIS_fnc_getUnitByUid), false]} forEach raidLobbyDef;
{["introLayer", ["<t size='2'>Победа защиты</t>", "PLAIN", 2, false, true]] remoteExec ["cutText", (_x call BIS_fnc_getUnitByUid), false]} forEach raidLobbyAt;
{[] remoteExec ["FREDDY_FNC_GETRANDOM_MNYRAIDWIN", (_x call BIS_fnc_getUnitByUid), false];}forEach raidLobbyDef;
sleep 15;
{_x setDamage 1;} forEach _playersArray;

_veh = []; 
    { 
        if (_x getVariable ["keys", "50"] != "50") then { 
            _buffer = []; 
            _buffer pushBack _x; 
            _buffer pushBack (_x getVariable "keys"); 
            _veh pushBack _buffer; 
        }; 
    }forEach (vehicles inAreaArray "RaidEllipse"); 
{ 
_getVehClass = typeOf (_x # 0);   
  switch (true) do {    
  case (((_x # 0)) isKindOf "I_MRAP_03_hmg_F") : {[_getVehClass, (_x # 1)]remoteExec["PENA_DB_BUY_ARMORED_VEH", 2 , false]; deletevehicle ((_x # 0));}; 
  case (((_x # 0)) isKindOf "I_MRAP_03_gmg_F") : {[_getVehClass, (_x # 1)]remoteExec["PENA_DB_BUY_ARMORED_VEH", 2 , false]; deletevehicle ((_x # 0));};    
    case (((_x # 0)) isKindOf "I_MBT_03_cannon_F") : {[_getVehClass, (_x # 1)]remoteExec["PENA_DB_BUY_ARMORED_VEH", 2 , false]; deletevehicle ((_x # 0));};   
    case (((_x # 0)) isKindOf "O_MBT_04_command_F") : {[_getVehClass,(_x # 1)]remoteExec["PENA_DB_BUY_ARMORED_VEH", 2 , false]; deletevehicle ((_x # 0));};   
    case (((_x # 0)) isKindOf "O_MBT_02_cannon_F") : {[_getVehClass, (_x # 1)]remoteExec["PENA_DB_BUY_ARMORED_VEH", 2 , false]; deletevehicle ((_x # 0));};   
    case (((_x # 0)) isKindOf "B_MBT_01_cannon_F") : {[_getVehClass, (_x # 1)]remoteExec["PENA_DB_BUY_ARMORED_VEH", 2 , false]; deletevehicle ((_x # 0));};   
    case (((_x # 0)) isKindOf "I_APC_Wheeled_03_cannon_F") : {[_getVehClass, (_x # 1)]remoteExec["PENA_DB_BUY_ARMORED_VEH", 2 , false]; deletevehicle ((_x # 0));}; 
    case (((_x # 0)) isKindOf "I_LT_01_AA_F") : {[_getVehClass, (_x # 1)]remoteExec["PENA_DB_BUY_ARMORED_VEH", 2 , false]; deletevehicle ((_x # 0));};   
    case (((_x # 0)) isKindOf "O_APC_Tracked_02_AA_F") : {[_getVehClass, (_x # 1)]remoteExec["PENA_DB_BUY_ARMORED_VEH", 2 , false]; deletevehicle ((_x # 0));};   
    case (((_x # 0)) isKindOf "B_APC_Tracked_01_AA_F") : {[_getVehClass, (_x # 1)]remoteExec["PENA_DB_BUY_ARMORED_VEH", 2 , false]; deletevehicle ((_x # 0));}; 
    case (((_x # 0)) isKindOf "B_Heli_Transport_01_camo_F") : {[_getVehClass, (_x # 1)]remoteExec["PENA_DB_BUY_ARMORED_VEH", 2 , false]; deletevehicle ((_x # 0));};   
    case (((_x # 0)) isKindOf "O_Heli_Light_02_F") : {[_getVehClass, (_x # 1)]remoteExec["PENA_DB_BUY_ARMORED_VEH", 2 , false]; deletevehicle ((_x # 0));};   
    case (((_x # 0)) isKindOf "O_Heli_Attack_02_F") : {[_getVehClass, (_x # 1)]remoteExec["PENA_DB_BUY_ARMORED_VEH", 2 , false]; deletevehicle ((_x # 0));};   
    case (((_x # 0)) isKindOf "B_Heli_Attack_01_F") : {[_getVehClass, (_x # 1)]remoteExec["PENA_DB_BUY_ARMORED_VEH", 2 , false]; deletevehicle ((_x # 0));};    
    default {};   
    };   
}forEach _veh;

_vehiclesArray = vehicles select {_x inArea "RaidEllipse"};
{if (_x isKindOf "Landvehicle" or _x isKindOf "Air") then {deleteVehicle _x};} forEach _vehiclesArray;

call FREDDY_FNC_NullArrayServer;
missionNamespace setVariable ["Raid",nil, true];
missionNamespace setVariable ["CaptureInProgress", nil, true]; 
deleteMarker "RaidEllipse";
deleteMarker "RaidText";
	};
};

//Скрипт победы атаки
FREDDY_FNC_ENDRAIDATTACK = {
[] spawn {
_playersArray = allUnits inAreaArray "RaidEllipse";
_vehiclesArray = (vehicles inAreaArray "RaidEllipse"); 
"RaidText" setMarkerText "Победа атаки";
if (player getVariable ["Defender", false]==true) then {{(_x call BIS_fnc_getUnitByUid) setVariable ["Defender", nil, true];} forEach raidLobbyDef;};
if (player getVariable ["Attacker", false]==true) then {{(_x call BIS_fnc_getUnitByUid) setVariable ["Attacker", nil, true];} forEach raidLobbyAt;};
if (missionNamespace getVariable ["Base1Selected", false] == true) then {missionNamespace setVariable ["Base1Selected", nil, true];};
if (missionNamespace getVariable ["Base2Selected", false] == true) then {missionNamespace setVariable ["Base2Selected", nil, true];};
if (missionNamespace getVariable ["Base3Selected", false] == true) then {missionNamespace setVariable ["Base3Selected", nil, true];};
{["introLayer", ["<t size='2'>Победа атаки</t>", "PLAIN", 2, false, true]] remoteExec ["cutText", (_x call BIS_fnc_getUnitByUid), false]} forEach raidLobbyDef;
{["introLayer", ["<t size='2'>Победа атаки</t>", "PLAIN", 2, false, true]] remoteExec ["cutText", (_x call BIS_fnc_getUnitByUid), false]} forEach raidLobbyAt;
{[] remoteExec ["FREDDY_FNC_GETRANDOM_MNYRAIDWIN", (_x call BIS_fnc_getUnitByUid), false];}forEach raidLobbyAt;
sleep 15;
{_x setDamage 1;} forEach _playersArray;

_veh = []; 
    { 
        if (_x getVariable ["keys", "50"] != "50") then { 
            _buffer = []; 
            _buffer pushBack _x; 
            _buffer pushBack (_x getVariable "keys"); 
            _veh pushBack _buffer; 
        }; 
    }forEach (vehicles inAreaArray "RaidEllipse"); 
{ 
_getVehClass = typeOf (_x # 0);   
  switch (true) do {    
  case (((_x # 0)) isKindOf "I_MRAP_03_hmg_F") : {[_getVehClass, (_x # 1)]remoteExec["PENA_DB_BUY_ARMORED_VEH", 2 , false]; deletevehicle ((_x # 0));}; 
  case (((_x # 0)) isKindOf "I_MRAP_03_gmg_F") : {[_getVehClass, (_x # 1)]remoteExec["PENA_DB_BUY_ARMORED_VEH", 2 , false]; deletevehicle ((_x # 0));};    
    case (((_x # 0)) isKindOf "I_MBT_03_cannon_F") : {[_getVehClass, (_x # 1)]remoteExec["PENA_DB_BUY_ARMORED_VEH", 2 , false]; deletevehicle ((_x # 0));};   
    case (((_x # 0)) isKindOf "O_MBT_04_command_F") : {[_getVehClass,(_x # 1)]remoteExec["PENA_DB_BUY_ARMORED_VEH", 2 , false]; deletevehicle ((_x # 0));};   
    case (((_x # 0)) isKindOf "O_MBT_02_cannon_F") : {[_getVehClass, (_x # 1)]remoteExec["PENA_DB_BUY_ARMORED_VEH", 2 , false]; deletevehicle ((_x # 0));};   
    case (((_x # 0)) isKindOf "B_MBT_01_cannon_F") : {[_getVehClass, (_x # 1)]remoteExec["PENA_DB_BUY_ARMORED_VEH", 2 , false]; deletevehicle ((_x # 0));};   
    case (((_x # 0)) isKindOf "I_APC_Wheeled_03_cannon_F") : {[_getVehClass, (_x # 1)]remoteExec["PENA_DB_BUY_ARMORED_VEH", 2 , false]; deletevehicle ((_x # 0));}; 
    case (((_x # 0)) isKindOf "I_LT_01_AA_F") : {[_getVehClass, (_x # 1)]remoteExec["PENA_DB_BUY_ARMORED_VEH", 2 , false]; deletevehicle ((_x # 0));};   
    case (((_x # 0)) isKindOf "O_APC_Tracked_02_AA_F") : {[_getVehClass, (_x # 1)]remoteExec["PENA_DB_BUY_ARMORED_VEH", 2 , false]; deletevehicle ((_x # 0));};   
    case (((_x # 0)) isKindOf "B_APC_Tracked_01_AA_F") : {[_getVehClass, (_x # 1)]remoteExec["PENA_DB_BUY_ARMORED_VEH", 2 , false]; deletevehicle ((_x # 0));}; 
    case (((_x # 0)) isKindOf "B_Heli_Transport_01_camo_F") : {[_getVehClass, (_x # 1)]remoteExec["PENA_DB_BUY_ARMORED_VEH", 2 , false]; deletevehicle ((_x # 0));};   
    case (((_x # 0)) isKindOf "O_Heli_Light_02_F") : {[_getVehClass, (_x # 1)]remoteExec["PENA_DB_BUY_ARMORED_VEH", 2 , false]; deletevehicle ((_x # 0));};   
    case (((_x # 0)) isKindOf "O_Heli_Attack_02_F") : {[_getVehClass, (_x # 1)]remoteExec["PENA_DB_BUY_ARMORED_VEH", 2 , false]; deletevehicle ((_x # 0));};   
    case (((_x # 0)) isKindOf "B_Heli_Attack_01_F") : {[_getVehClass, (_x # 1)]remoteExec["PENA_DB_BUY_ARMORED_VEH", 2 , false]; deletevehicle ((_x # 0));};    
    default {};   
    };   
}forEach _veh;

_vehiclesArray = vehicles select {_x inArea "RaidEllipse"};
{if (_x isKindOf "Landvehicle" or _x isKindOf "Air" && _x getVariable ["keys", "50"] == "50") then {deleteVehicle _x};} forEach _vehiclesArray;

call FREDDY_FNC_NullArrayServer;
missionNamespace setVariable ["Raid",nil, true];
missionNamespace setVariable ["CaptureInProgress", nil, true];
deleteMarker "RaidEllipse";
deleteMarker "RaidText"; 
	};
};

FREDDY_FNC_NullArrayServer = {
raidLobbyAt = [];
raidLobbyDef = [];
[raidLobbyAt, raidLobbyDef, raidLobbyQueDef, raidLobbyQueAt] remoteExec ["PENA_ARRAY_RAID_HANDLER", 2];
};

PENA_ARRAY_ONLOAD = {
	
};

PENA_Raid_OnLoad = {  
 lbClear 20006;
 lbClear 20008;
 lbClear 20005;
 lbClear 20007;  
[]spawn {
if (!isNull findDisplay 20999) then {
 waitUntil {!isNull findDisplay 20999};
 	_playerData = [];
    {   
     _uid = _x;     
         if (isPlayer (_x call BIS_fnc_getUnitByUid) && _playerData find (_x call BIS_fnc_getUnitByUid) == -1) then     
         {    
          _index = lbAdd [20006, name (_x call BIS_fnc_getUnitByUid)];     
          _data = lbSetData [20006, _index, _uid];     
          lbSetTooltip [20006, _index, name (_x call BIS_fnc_getUnitByUid)]; 	
          if ((_x call BIS_fnc_getUnitByUid) == player) then {raidLocalLoc = [20006, _index]};
          _playerData pushBack (_x call BIS_fnc_getUnitByUid);        
        };     
    }forEach raidLobbyDef;  
};
};

[]spawn {
if (!isNull findDisplay 20999) then {
 waitUntil {!isNull findDisplay 20999};
 	_playerData = [];
    {   
     _uid = _x;     
         if (isPlayer (_x call BIS_fnc_getUnitByUid) && _playerData find (_x call BIS_fnc_getUnitByUid) == -1) then     
         {    
          _index = lbAdd [20008, name (_x call BIS_fnc_getUnitByUid)];     
          _data = lbSetData [20008, _index, _uid];     
          lbSetTooltip [20008, _index, name (_x call BIS_fnc_getUnitByUid)]; 
          if ((_x call BIS_fnc_getUnitByUid) == player) then {raidLocalLoc = [20008, _index]};
          _playerData pushBack (_x call BIS_fnc_getUnitByUid);        
        };     
    }forEach raidLobbyAt;  
};
};

[]spawn {
if (!isNull findDisplay 20999) then {
 waitUntil {!isNull findDisplay 20999};
 	_playerData = [];
    {   
     _uid = _x;     
         if (isPlayer (_x call BIS_fnc_getUnitByUid) && _playerData find (_x call BIS_fnc_getUnitByUid) == -1) then     
         {    
          _index = lbAdd [20005, name (_x call BIS_fnc_getUnitByUid)];     
          _data = lbSetData [20005, _index, _uid];     
          lbSetTooltip [20005, _index, name (_x call BIS_fnc_getUnitByUid)]; 
          if ((_x call BIS_fnc_getUnitByUid) == player) then {raidLocalLoc = [20005, _index]};
          _playerData pushBack (_x call BIS_fnc_getUnitByUid);        
        };     
    }forEach raidLobbyQueDef;  
};
};

[]spawn {
if (!isNull findDisplay 20999) then {
 waitUntil {!isNull findDisplay 20999};
 	_playerData = [];
    {   
     _uid = _x;     
         if (isPlayer (_x call BIS_fnc_getUnitByUid) && _playerData find (_x call BIS_fnc_getUnitByUid) == -1) then     
         {    
          _index = lbAdd [20007, name (_x call BIS_fnc_getUnitByUid)];     
          _data = lbSetData [20007, _index, _uid];     
          lbSetTooltip [20007, _index, name (_x call BIS_fnc_getUnitByUid)]; 
          if ((_x call BIS_fnc_getUnitByUid) == player) then {raidLocalLoc = [20007, _index]};
          _playerData pushBack (_x call BIS_fnc_getUnitByUid);        
        };     
    }forEach raidLobbyQueAt;  
};
};

};

PENA_JoinToLobbyRaid = {
_idc = (_this # 0);
	if (raidLobbyDef find (getPlayerUID player) == -1 && raidLobbyQueDef find (getPlayerUID player) == -1 && raidLobbyQueAt find (getPlayerUID player) == -1) then {
	if (count raidLobbyAt < 14 && raidLobbyAt find (getPlayerUID player) == -1 && missionNamespace getVariable ["Raid", false] == false && missionNamespace getVariable ["RaidWarmup", false] == false) then { //Ограничение лобби
		raidLobbyAt pushBack (getPlayerUID player);
		[raidLobbyDef, raidLobbyAt, raidLobbyQueDef, raidLobbyQueAt]remoteExec["PENA_ARRAY_RAID_HANDLER", 2, false];
	} else {
		if (raidLobbyAt find (getPlayerUID player) == -1 && raidLobbyQueAt find (getPlayerUID player) == -1) then {
    _message = parseText format["<t size='1'>Вы были помещены в <t color='#ffb833'>очередь</t><br></br>из-за <br></br><t color='#ffb833'>нехватки мест</t> в лобби / рейд уже <t color='#ffb833'>начался</t></t>"];
    hint _message;
		raidLobbyQueAt pushBack (getPlayerUID player);
		[raidLobbyDef, raidLobbyAt, raidLobbyQueDef, raidLobbyQueAt]remoteExec["PENA_ARRAY_RAID_HANDLER", 2, false];
	} else { hint "Вы уже зашли в лобби"};
	};
} else {
  _message = parseText format["<t size='1'>Вы уже <t color='#ffb833'>числитесь</t> в другой команде или очереди</t>"];
  hint _message;
};
};

PENA_JoinToLobbyDef = {
	_idc = (_this # 0);
	if (raidLobbyAt find (getPlayerUID player) == -1 && raidLobbyQueDef find (getPlayerUID player) == -1 && raidLobbyQueAt find (getPlayerUID player) == -1) then {
	if (count raidLobbyDef < 10 && raidLobbyDef find (getPlayerUID player) == -1 && missionNamespace getVariable ["Raid", false] == false && missionNamespace getVariable ["RaidWarmup", false] == false) then {//Ограничение лобби
		raidLobbyDef pushBack (getPlayerUID player);
		[raidLobbyDef, raidLobbyAt, raidLobbyQueDef, raidLobbyQueAt]remoteExec["PENA_ARRAY_RAID_HANDLER", 2, false];
	} else {
		if (raidLobbyDef find (getPlayerUID player) == -1 && raidLobbyQueDef find (getPlayerUID player) == -1) then {
		_message = parseText format["<t size='1'>Вы были помещены в <t color='#ffb833'>очередь</t><br></br>из-за <br></br><t color='#ffb833'>нехватки мест</t> в лобби / рейд уже <t color='#ffb833'>начался</t></t>"];
    hint _message;
		raidLobbyQueDef pushBack (getPlayerUID player);
		[raidLobbyDef, raidLobbyAt, raidLobbyQueDef, raidLobbyQueAt]remoteExec["PENA_ARRAY_RAID_HANDLER", 2, false];
	} else { hint "Вы уже зашли в лобби"};
	};
} else {
  _message = parseText format["<t size='1'>Вы уже <t color='#ffb833'>числитесь</t> в другой команде или очереди</t>"];
  hint _message;
};
};

PENA_JoinToLobbyRaid_Squad = {
	

};



PENA_JoinToLobbyDef_Squad = {
	

};

PENA_QuitFromLobby_Queue = {
    _sender = (_this # 1);
    
    switch (true) do { 
        case (raidLobbyDef find (getPlayerUID player) != -1) : { raidLobbyDef deleteAt (raidLobbyDef find (getPlayerUID player));
        [raidLobbyDef, raidLobbyAt, raidLobbyQueDef, raidLobbyQueAt]remoteExec["PENA_ARRAY_RAID_HANDLER", 2, false]; 
        if (!isNull findDisplay 20999) then {
        lbDelete [raidLocalLoc # 0, raidLocalLoc # 1];
    };
    [_sender, raidLocalLoc # 0, raidLocalLoc # 1]remoteExec["PENA_QuitFromLobby_Helper", -2, false];
    }; 
        case (raidLobbyAt find (getPlayerUID player) != -1) : {raidLobbyAt deleteAt (raidLobbyAt find (getPlayerUID player));
        [raidLobbyDef, raidLobbyAt, raidLobbyQueDef, raidLobbyQueAt]remoteExec["PENA_ARRAY_RAID_HANDLER", 2, false]; 
        if (!isNull findDisplay 20999) then {
        lbDelete [raidLocalLoc # 0, raidLocalLoc # 1];
    };
    [_sender, raidLocalLoc # 0, raidLocalLoc # 1]remoteExec["PENA_QuitFromLobby_Helper", -2, false];
    };
        case (raidLobbyQueDef find (getPlayerUID player) != -1) : {raidLobbyQueDef deleteAt (raidLobbyQueDef find (getPlayerUID player));
        [raidLobbyDef, raidLobbyAt, raidLobbyQueDef, raidLobbyQueAt]remoteExec["PENA_ARRAY_RAID_HANDLER", 2, false]; 
        if (!isNull findDisplay 20999) then {
        lbDelete [raidLocalLoc # 0, raidLocalLoc # 1];
    };
    [_sender, raidLocalLoc # 0, raidLocalLoc # 1]remoteExec["PENA_QuitFromLobby_Helper", -2, false];
    }; 
        case (raidLobbyQueAt find (getPlayerUID player) != -1) : {raidLobbyQueAt deleteAt (raidLobbyQueAt find (getPlayerUID player));
        [raidLobbyDef, raidLobbyAt, raidLobbyQueDef, raidLobbyQueAt]remoteExec["PENA_ARRAY_RAID_HANDLER", 2, false]; 
        if (!isNull findDisplay 20999) then {
        lbDelete [raidLocalLoc # 0, raidLocalLoc # 1];
    };
    [_sender, raidLocalLoc # 0, raidLocalLoc # 1]remoteExec["PENA_QuitFromLobby_Helper", -2, false];
    }; 
        default { hint "Вы не находитесь в лобби" }; 
    };
};

PENA_QuitFromLobby_Helper = {
	_sender = (_this # 0);
	if (!isNull findDisplay 20999) then {
		lbDelete [(_this # 1), (_this # 2)];
	};
};


PENA_PLAYER_LOGISTIC = {
[]spawn { 
while {true} do { 
  _buffer = count raidLobbyAt; 
  waitUntil { _buffer != count raidLobbyAt };
  for "_i" from 0 to  (_buffer - count raidLobbyAt) do {
     raidLobbyAt pushBack raidLobbyQueAt # 0; 
     raidLobbyQueAt deleteAt 0; 
 	 };
    }; 
   };

[]spawn { 
while {true} do { 
  _buffer = count raidLobbyDef; 
  waitUntil { _buffer != count raidLobbyDef };
  for "_i" from 0 to (_buffer - count raidLobbyAt) do {
     raidLobbyDef pushBack raidLobbyQueDef # 0; 
     raidLobbyQueDef deleteAt 0; 
 	 };
    }; 
   };
};

//Авто килл если участник выходит за пределы круга
[] spawn {
while {true} do {
_countDefBuff = count (allPlayers select {(_x getVariable ["Defender", false] == true); _x inArea "RaidEllipse";});
_countAtBuff = count (allPlayers select {(_x getVariable ["Attacker", false] == true); _x inArea "RaidEllipse";});
	waitUntil {
_countDef = count (allPlayers select {(_x getVariable ["Defender", false] == true); _x inArea "RaidEllipse";});
_countAt = count (allPlayers select {(_x getVariable ["Attacker", false] == true); _x inArea "RaidEllipse";});
missionNamespace getVariable ["Raid", false] == true && (_countDef != _countDefBuff or _countAt != _countAtBuff);
};
{_x setDamage 1;} forEach (allPlayers select {((_x getVariable ["Attacker", false] == true) or (_x getVariable ["Defender", false] == true)) && !(_x inArea "RaidEllipse")});
	};	
};

//Авто килл если не участник входит в пределы круга
[] spawn {
while {true} do {
_countPlBuff = count (allPlayers select {(_x getVariable ["Defender", false] == false); (_x getVariable ["Attacker", false] == false); _x inArea "RaidEllipse";});
	waitUntil {
_countPl = count (allPlayers select {(_x getVariable ["Defender", false] == false); (_x getVariable ["Attacker", false] == false); _x inArea "RaidEllipse";});
_countPl != _countPlBuff;
};
{_x setDamage 1;} forEach (allPlayers select {(_x getVariable ["Attacker", false] == false) && (_x getVariable ["Defender", false] == false) && _x inArea "RaidEllipse"});
	};	
};

freddy_fnc_TeleportSupport = {
_pos = (_this # 0);
player setPos _pos;
};

freddy_fnc_teleportAttack = {
_player = (_this # 0);
_posAt = (_this # 1);
[_posAt] remoteExec ["freddy_fnc_TeleportSupport", _player, false]; if (lifeState _player == "INCAPACITATED") then {_player setDammage 0; _player setUnconscious false; _player switchMove "";}; _player setUnitLoadout (configFile >> "EmptyLoadout"); [0] remoteExec ["closeDialog", _player, false];
};

freddy_fnc_teleportDef = {
_player = (_this # 0);
_posDef = (_this # 1);
[_posDef] remoteExec ["freddy_fnc_TeleportSupport", _player, false]; if (lifeState _player == "INCAPACITATED") then {_player setDammage 0; _player setUnconscious false; _player switchMove "";}; _player setUnitLoadout (configFile >> "EmptyLoadout"); [0] remoteExec ["closeDialog", _player , false];  
};
/*
this addAction
[
	"Захватить",
	{
		params ["_target", "_caller", "_actionId", "_arguments"];
		if ((missionNamespace getVariable ["CaptureInProgress", false]) == false && (missionNamespace getVariable ["Raid", false]) == true && (player getVariable ["Attacker", false])==true) then {call FREDDY_FNC_CAPTUREFLAG;};
	},
	nil,		
	1.5,		
	true,		
	true,		
	"",			
	"true", 	
	10,			
	false,		
	"",			
	""			
];

this addAction
[
	"Включить",
	{
		params ["_target", "_caller", "_actionId", "_arguments"];
		call FREDDY_FNC_CREATERAID;
	},
	nil,		
	1.5,		
	true,		
	true,		
	"",			
	"true", 	
	10,			
	false,		
	"",			
	""			
];

this addAction
[
	"Включить",
	{
		params ["_target", "_caller", "_actionId", "_arguments"];
		[] remoteExec ["FREDDY_FNC_CREATERAID", 2, true];
	},
	nil,		
	1.5,		
	true,		
	true,		
	"",			
	"true", 	
	10,			
	false,		
	"",			
	""			
];