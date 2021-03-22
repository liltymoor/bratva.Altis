globalCost = 0;

PENA_CALLBACK_LIFES_FNC = {
  diag_log "Лайфы загружены на клиент";
  Lifes = (_this select 0);
};


 FREDDT_FNC_LOADLIGHTVEHARRAY = {
 [] spawn {
 _vehArray = ["ver_vaz_2114_uck", "BPAN_priora", "ver_vaz_2114_OPER", "ivory_evox", "ivory_wrx", "ivory_supra", "ivory_r34"];
{
	_vehName = getText (configFile >> "CfgVehicles" >> _x >> "displayname");	
	lbAdd [3614, _vehName];
	lbSetData [3614, _forEachIndex, _x];
} forEach  _vehArray;


while {!IsNull (FindDisplay 1234389)} do {
  _index = lbCurSel 3614;
  _vehicle = lbData [3614, _index];
    _loadedLifes = Lifes;

    switch (true) do {
  case (_vehicle isKindOf "I_MBT_03_cannon_F") : {_lifes = (_loadedLifes select 0);((Finddisplay 1234389) displayCtrl 131214) ctrlSetText format ["%1", _lifes];};//Кума
  case (_vehicle isKindOf "O_MBT_04_command_F") : {_lifes = (_loadedLifes select 1);((Finddisplay 1234389) displayCtrl 131214) ctrlSetText format ["%1", _lifes];};//Ангара
  case (_vehicle isKindOf "O_MBT_02_cannon_F") : {_lifes = (_loadedLifes select 2);((Finddisplay 1234389) displayCtrl 131214) ctrlSetText format ["%1", _lifes];};//Варсук
  case (_vehicle isKindOf "B_MBT_01_cannon_F") : {_lifes = (_loadedLifes select 3);((Finddisplay 1234389) displayCtrl 131214) ctrlSetText format ["%1", _lifes];};//Сламмер
  case (_vehicle isKindOf "I_APC_Wheeled_03_cannon_F") : {_lifes = (_loadedLifes select 4);((Finddisplay 1234389) displayCtrl 131214) ctrlSetText format ["%1", _lifes];};//Горгона
  case (_vehicle isKindOf "O_APC_Tracked_02_AA_F") : {_lifes = (_loadedLifes select 5);((Finddisplay 1234389) displayCtrl 131214) ctrlSetText format ["%1", _lifes];};//Тигрис
  case (_vehicle isKindOf "B_APC_Tracked_01_AA_F") : {_lifes = (_loadedLifes select 6);((Finddisplay 1234389) displayCtrl 131214) ctrlSetText format ["%1", _lifes];};//Читаха
  case (_vehicle isKindOf "O_Heli_Light_02_F") : {_lifes = (_loadedLifes select 7);((Finddisplay 1234389) displayCtrl 131214) ctrlSetText format ["%1", _lifes];};//орка
  case (_vehicle isKindOf "O_Heli_Attack_02_F") : {_lifes = (_loadedLifes select 8);((Finddisplay 1234389) displayCtrl 131214) ctrlSetText format ["%1", _lifes];};//кайман
  case (_vehicle isKindOf "B_Heli_Attack_01_F") : {_lifes = (_loadedLifes select 9);((Finddisplay 1234389) displayCtrl 131214) ctrlSetText format ["%1", _lifes];};//бф
  default {_lifes = " ";((Finddisplay 1234389) displayCtrl 131214) ctrlSetText format ["%1", _lifes];};
  };
  sleep 0.1;
      };
		};
	};

 FREDDT_FNC_TRUCKVEHARRAY = {
 [] spawn {
 _vehArray = ["C_Van_01_box_F", "B_Truck_01_transport_F", "B_Truck_01_covered_F", "B_Truck_01_mover_F", "B_Truck_01_box_F", "O_Truck_03_transport_F", "O_Truck_03_covered_F", "O_Truck_03_device_F"];
{
  _vehName = getText (configFile >> "CfgVehicles" >> _x >> "displayname");  
  lbAdd [3614, _vehName];
  lbSetData [3614, _forEachIndex, _x];
} forEach  _vehArray;
  };
};

 FREDDT_FNC_HEAVYVEHARRAY = {
 _Lifes = (_this select 0); 
 _opforArray = ["mgs_ifrit"];
 _bluforArray = ["swat_ifrit_1"];
 _independentArray = ["msf_ifrit"];
 _finalArray = [];
 _finalArray = _finalArray;
 switch (side player) do {
  case east: {_finalArray = + _opforArray + _Lifes};
    case west: {_finalArray = + _bluforArray + _Lifes};
    case independent: {_finalArray = + _independentArray + _Lifes};
  };
{
  _vehName = getText (configFile >> "CfgVehicles" >> _x >> "displayname");  
  lbAdd [3614, _vehName];
  lbSetData [3614, _forEachIndex, _x];
} forEach  _finalArray;

  _player = player;
  _UID = getPlayerUID _player;
 [_player,_UID] remoteExec ["PENA_DB_LOADLIFES_FNC", 2 , false];

    };
 
  PENA_FNC_PREVEHARRAY = {
	_player = player;
	_UID = getPlayerUID player;
	[_player, _UID] remoteExec ["PENA_DB_LOAD_ARMORED_VEH", 2 , false];
};


  PENA_FNC_PREHELIARRAY = {
  _player = player;
  _UID = getPlayerUID player;

  [_player, _UID] remoteExec ["PENA_DB_LOAD_HELI", 2 ,false];
};

  FREDDY_FNC_HELIARRAY = {
_Lifes = (_this select 0);
 _vehArray = ["B_Heli_Light_01_F"];
 _vehArray = _vehArray + _Lifes;
{
  _vehName = getText (configFile >> "CfgVehicles" >> _x >> "displayname");  
  lbAdd [3614, _vehName];
  lbSetData [3614, _forEachIndex, _x];
} forEach  _vehArray;

  _player = player;
  _UID = getPlayerUID _player;
 [_player,_UID] remoteExec ["PENA_DB_LOADLIFES_FNC", 2 , false];
  };


Freddy_fnc_createveh = {
_trg = ["vehSpawnAtira", "vehSpawnKavalla", "vehSpawnPyrgos"];
_nearestTrg = [_trg, player] call BIS_fnc_nearestPosition;
_entitiesArray = (getMarkerPos _nearestTrg) nearEntities [["Landvehicle", "Air"], 10];
if (count (_entitiesArray)!=0) exitWith {hint "Место занято"};

  _player = player;
  _UID = getPlayerUID _player;
  _index = lbCurSel 3614;
  _vehicle = lbData [3614, _index];
   [_player, _UID, _vehicle] remoteExec ["PENA_DB_PAYLIFE_FNC",2,false];
  _markArray = ["vehSpawnAtira", "vehSpawnPyrgos", "vehSpawnKavalla"];
  _nearestMarker = [_markArray, player] call BIS_fnc_nearestPosition;
  _pos = getMarkerPos _nearestMarker;
  _azimuth = markerDir _nearestMarker;
  _govno = _vehicle createVehicle _pos;//тут ты получаешь из класснейма объект
  _govno setDir _azimuth;
  _govno disableTIEquipment true;      
  clearWeaponCargoGlobal _govno;      
  clearMagazineCargoGlobal _govno;      
  clearItemCargoGlobal _govno;      
  clearBackpackCargoGlobal _govno;
  _govno setVariable ["keys", _UID, true];
  _veh = _govno getVariable ["keys", 50];
};

FREDDT_FNC_LOADARMOREDLANDVEH = {
 [] spawn {
 _vehArray = ["I_MBT_03_cannon_F", "O_MBT_04_command_F", "O_MBT_02_cannon_F", "B_MBT_01_TUSK_F", "I_APC_Wheeled_03_cannon_F", "O_APC_Tracked_02_AA_F", "B_APC_Tracked_01_AA_F"];
{
  _vehName = getText (configFile >> "CfgVehicles" >> _x >> "displayname");  
  lbAdd [3615, _vehName];
  lbSetData [3615, _forEachIndex, _x];
} forEach  _vehArray;


while {!IsNull (FindDisplay 12343891)} do {
  _index = lbCurSel 3615;
  _vehicle = lbData [3615, _index];
  switch (true) do {
  case (_vehicle isKindOf "I_MBT_03_cannon_F") : {_cost = 4590; globalCost = _cost; ((Finddisplay 12343891) displayCtrl 7777) ctrlSetText format ["%1", _cost]; ((Finddisplay 12343891) displayCtrl 777) ctrlSetStructuredText parseText "<img size = '3' align='center' valign='bottom' image='\A3\Armor_F_EPB\MBT_03\Data\UI\MBT_03_Ca.paa'/>";};//Кума
  case (_vehicle isKindOf "O_MBT_04_command_F") : {_cost = 6500; globalCost = _cost; ((Finddisplay 12343891) displayCtrl 7777) ctrlSetText format ["%1", _cost]; ((Finddisplay 12343891) displayCtrl 777) ctrlSetStructuredText parseText "<img size = '3' align='center' valign='bottom' image='\A3\Armor_F_Tank\MBT_04\Data\UI\MBT_04_command.paa'/>";};//Ангара
  case (_vehicle isKindOf "O_MBT_02_cannon_F") : {_cost = 5000; globalCost = _cost; ((Finddisplay 12343891) displayCtrl 7777) ctrlSetText format ["%1", _cost]; ((Finddisplay 12343891) displayCtrl 777) ctrlSetStructuredText parseText "<img size = '3' align='center' valign='bottom' image='\A3\armor_f_gamma\MBT_02\Data\UI\MBT_02_Base_ca.paa'/>";};//Варсук
  case (_vehicle isKindOf "B_MBT_01_TUSK_F") : {_cost = 4900; globalCost = _cost; ((Finddisplay 12343891) displayCtrl 7777) ctrlSetText format ["%1", _cost]; ((Finddisplay 12343891) displayCtrl 777) ctrlSetStructuredText parseText "<img size = '3' align='center' valign='bottom' image='\A3\armor_f_gamma\MBT_01\Data\UI\Slammer_M2A1_Base_ca.paa'/>";};//Сламмер
  case (_vehicle isKindOf "I_APC_Wheeled_03_cannon_F") : {_cost = 3500; globalCost = _cost; ((Finddisplay 12343891) displayCtrl 7777) ctrlSetText format ["%1", _cost]; ((Finddisplay 12343891) displayCtrl 777) ctrlSetStructuredText parseText "<img size = '3' align='center' valign='bottom' image='\A3\armor_f_gamma\APC_Wheeled_03\data\UI\APC_Wheeled_03_ca.paa'/>";};//Горгона
  case (_vehicle isKindOf "O_APC_Tracked_02_AA_F") : {_cost = 5650; globalCost = _cost; ((Finddisplay 12343891) displayCtrl 7777) ctrlSetText format ["%1", _cost]; ((Finddisplay 12343891) displayCtrl 777) ctrlSetStructuredText parseText "<img size = '3' align='center' valign='bottom' image='\A3\armor_f_beta\APC_Tracked_02\Data\UI\APC_Tracked_02_aa_ca.paa'/>";};//Тигрис
  case (_vehicle isKindOf "B_APC_Tracked_01_AA_F") : {_cost = 5500; globalCost = _cost; ((Finddisplay 12343891) displayCtrl 7777) ctrlSetText format ["%1", _cost]; ((Finddisplay 12343891) displayCtrl 777) ctrlSetStructuredText parseText "<img size = '3' align='center' valign='bottom' image='\A3\armor_f_beta\APC_Tracked_01\Data\UI\APC_Tracked_01_AA_ca.paa'/>";};//Читаха
  case (_vehicle isKindOf "O_Heli_Light_02_F") : {_cost = 12250; globalCost = _cost; ((Finddisplay 12343891) displayCtrl 7777) ctrlSetText format ["%1", _cost]; ((Finddisplay 12343891) displayCtrl 777) ctrlSetStructuredText parseText "<img size = '3' align='center' valign='bottom' image='\A3\Air_F\Heli_Light_02\Data\UI\Heli_Light_02_rockets_CA.paa'/>";};//Орка
  case (_vehicle isKindOf "O_Heli_Attack_02_F") : {_cost = 13650; globalCost = _cost; ((Finddisplay 12343891) displayCtrl 7777) ctrlSetText format ["%1", _cost]; ((Finddisplay 12343891) displayCtrl 777) ctrlSetStructuredText parseText "<img size = '3' align='center' valign='bottom' image='\A3\Air_F_Beta\Heli_Attack_02\Data\UI\Heli_Attack_02_CA.paa'/>";};//Кайман
  case (_vehicle isKindOf "B_Heli_Attack_01_F") : {_cost = 15350; globalCost = _cost; ((Finddisplay 12343891) displayCtrl 7777) ctrlSetText format ["%1", _cost]; ((Finddisplay 12343891) displayCtrl 777) ctrlSetStructuredText parseText "<img size = '3' align='center' valign='bottom' image='\A3\Air_F_Beta\Heli_Attack_01\Data\UI\Heli_Attack_01_CA.paa'/>";};//Бфка
  sleep 0.1;
      };
    };
  };
};



FREDDT_FNC_LOADARMOREDAIRVEH = {
 [] spawn {
 _vehArray = ["O_Heli_Light_02_F", "O_Heli_Attack_02_F", "B_Heli_Attack_01_F"];
{
  _vehName = getText (configFile >> "CfgVehicles" >> _x >> "displayname");  
  lbAdd [3615, _vehName];
  lbSetData [3615, _forEachIndex, _x];
} forEach  _vehArray;
    };
  };


FNC_GOVNO = {	
  _index = (_this select 0);
  _vehicle = (_this select 1);
  _UID = getPlayerUID player;
   
  closeDialog 0;  
  _markArray = ["CreateArmoredVeh","CreateArmoredVehMazi", "CreateArmoredVehSelicano", "CreateArmoredVehMolos"];
  _nearestMarker = [_markArray, player] call BIS_fnc_nearestPosition;
  _pos = getMarkerPos _nearestMarker;
  _azimuth = markerDir _nearestMarker;
  _govno = _vehicle createVehicle _pos;//тут ты получаешь из класснейма объект
  _govno setDir _azimuth;
  _govno disableTIEquipment true;
  clearWeaponCargoGlobal _govno;
  clearMagazineCargoGlobal _govno;
  clearItemCargoGlobal _govno;
  clearBackpackCargoGlobal _govno;
  _govno setVariable ["keys", _UID, true];
  _veh = _govno getVariable ["keys", 50];
  hintSilent parseText format ["Покупка техники <t size='1' color='#80ff80'>совершена успешно</t>!"];
};


Freddy_fnc_checkArmoredveh = {
  _index = lbCurSel 3615;
  _vehicle = lbData [3615, _index];
  _player = player; 
  _UID = getPlayerUID player; 
  _transaction = globalCost; 
  if ((_player getVariable ["CouldntBuy", false]) != false) exitWith {hint "Подождите немного";};
  _player setVariable ["CouldntBuy", true, true];
  [_player, _UID, _transaction, _index, _vehicle]remoteExec["PENA_SHOP_TRANSACTION", 2 ,false];
};

Freddy_fnc_StoreVehicle = {
_trg = ["CreateArmoredVehMazi", "CreateArmoredVehSelicano", "CreateArmoredVehMolos", "vehSpawnAtira", "vehSpawnKavalla", "vehSpawnPyrgos"];
_vehicle = ["I_MBT_03_cannon_F", "O_MBT_04_command_F", "O_MBT_02_cannon_F", "B_MBT_01_TUSK_F", "I_APC_Wheeled_03_cannon_F", "O_APC_Tracked_02_AA_F", "B_APC_Tracked_01_AA_F", "O_Heli_Light_02_F", "O_Heli_Attack_02_F", "B_Heli_Attack_01_F", "O_T_VTOL_02_infantry_hex_F"];
_nearestTrg = [_trg, player] call BIS_fnc_nearestPosition;
_entitiesArray = (getMarkerPos _nearestTrg) nearestObject "AllVehicles";
_player = player;
_UID = getPlayerUID player;

_zaloopa1 = typeof _entitiesArray;
_vehName = getText (configFile >> "CfgVehicles" >> _zaloopa1 >> "displayname");
_veh = _entitiesArray getVariable ["keys", 50];
if ((_player getVariable ["StoreCooldown", false]) != false) exitWith {hint "Подождите немного";};
	call Freddy_fnc_StoreCooldown;
if (count crew _entitiesArray > 0) exitWith {hint "В технике кто-то есть";};
if ((_player getVariable ["CouldntStore", false]) != false) then {hint "Подождите немного";} else {
  if (typeOf _entitiesArray in _vehicle && _UID == _veh && typeOf _entitiesArray != "") then {
	_player setVariable ["CouldntStore", true, true];
  {moveOut _x} forEach crew _entitiesArray;
	[_entitiesArray, _vehName, _UID, _zaloopa1, _player] remoteExec ["Freddy_fnc_delvehServer", 2, false];
} else {
    "Рядом нет техники, которую можно поставить" remoteExec ["hint", player , false];
    _player setVariable ["CouldntStore", nil, true];
    };
  };
};

Freddy_fnc_StoreCooldown = {
[] spawn {
_unit = player;
_unit setVariable ["StoreCooldown", true, true];
sleep 10;
_unit setVariable ["StoreCooldown", nil, true];
	};
};