globalCost = 0;
OnGoingData = [];
PENA_CALLBACK_LIFES_FNC = {
  diag_log "Лайфы загружены на клиент";
  Lifes = (_this select 0);
};

PENA_CALLBACK_RAIDLIFES_FNC = {
  OnGoingData = (_this # 0);
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
  case (_vehicle isKindOf "I_MRAP_03_hmg_F") : {_lifes = (_loadedLifes select 0);((Finddisplay 1234389) displayCtrl 131214) ctrlSetText format ["%1", _lifes];};//Кума
  case (_vehicle isKindOf "I_MRAP_03_gmg_F") : {_lifes = (_loadedLifes select 1);((Finddisplay 1234389) displayCtrl 131214) ctrlSetText format ["%1", _lifes];};//Кума
  case (_vehicle isKindOf "I_MBT_03_cannon_F") : {_lifes = (_loadedLifes select 2);((Finddisplay 1234389) displayCtrl 131214) ctrlSetText format ["%1", _lifes];};//Кума
  case (_vehicle isKindOf "O_MBT_04_command_F") : {_lifes = (_loadedLifes select 3);((Finddisplay 1234389) displayCtrl 131214) ctrlSetText format ["%1", _lifes];};//Ангара
  case (_vehicle isKindOf "O_MBT_02_cannon_F") : {_lifes = (_loadedLifes select 4);((Finddisplay 1234389) displayCtrl 131214) ctrlSetText format ["%1", _lifes];};//Варсук
  case (_vehicle isKindOf "B_MBT_01_cannon_F") : {_lifes = (_loadedLifes select 5);((Finddisplay 1234389) displayCtrl 131214) ctrlSetText format ["%1", _lifes];};//Сламмер
  case (_vehicle isKindOf "I_APC_Wheeled_03_cannon_F") : {_lifes = (_loadedLifes select 6);((Finddisplay 1234389) displayCtrl 131214) ctrlSetText format ["%1", _lifes];};//Горгона
  case (_vehicle isKindOf "I_LT_01_AA_F") : {_lifes = (_loadedLifes select 7);((Finddisplay 1234389) displayCtrl 131214) ctrlSetText format ["%1", _lifes];};//Нюкс ПВ
  case (_vehicle isKindOf "O_APC_Tracked_02_AA_F") : {_lifes = (_loadedLifes select 8);((Finddisplay 1234389) displayCtrl 131214) ctrlSetText format ["%1", _lifes];};//Тигрис
  case (_vehicle isKindOf "B_APC_Tracked_01_AA_F") : {_lifes = (_loadedLifes select 9);((Finddisplay 1234389) displayCtrl 131214) ctrlSetText format ["%1", _lifes];};//Читаха
  case (_vehicle isKindOf "B_Heli_Transport_01_camo_F") : {_lifes = (_loadedLifes select 10);((Finddisplay 1234389) displayCtrl 131214) ctrlSetText format ["%1", _lifes];};//Госта
  case (_vehicle isKindOf "O_Heli_Light_02_F") : {_lifes = (_loadedLifes select 11);((Finddisplay 1234389) displayCtrl 131214) ctrlSetText format ["%1", _lifes];};//орка
  case (_vehicle isKindOf "O_Heli_Attack_02_F") : {_lifes = (_loadedLifes select 12);((Finddisplay 1234389) displayCtrl 131214) ctrlSetText format ["%1", _lifes];};//кайман
  case (_vehicle isKindOf "B_Heli_Attack_01_F") : {_lifes = (_loadedLifes select 13);((Finddisplay 1234389) displayCtrl 131214) ctrlSetText format ["%1", _lifes];};//бф
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
 _idc = (_this # 1); 
 _opforArray = [];
 _bluforArray = [];
 _independentArray = [];
 _finalArray = [];
 _finalArray = _finalArray;
 switch (side player) do {
    case east: {_finalArray = + _opforArray + _Lifes};
    case west: {_finalArray = + _bluforArray + _Lifes};
    case independent: {_finalArray = + _independentArray + _Lifes};
  };
{
  _vehName = getText (configFile >> "CfgVehicles" >> _x >> "displayname");  
  lbAdd [_idc, _vehName];
  lbSetData [_idc, _forEachIndex, _x];
} forEach  _finalArray;

  _player = player;
  _UID = getPlayerUID _player;
 [_player,_UID] remoteExec ["PENA_DB_LOADLIFES_FNC", 2 , false];

};
 
  PENA_FNC_PREVEHARRAY = {
	_player = player;
	_UID = getPlayerUID player;
	[_player, _UID, (_this # 0)] remoteExec ["PENA_DB_LOAD_ARMORED_VEH", 2 , false];
};


  PENA_FNC_PREHELIARRAY = {
  _player = player;
  _UID = getPlayerUID player;

  [_player, _UID, (_this # 0)] remoteExec ["PENA_DB_LOAD_HELI", 2 ,false];
};

  FREDDY_FNC_HELIARRAY = {
_Lifes = (_this select 0);
 _vehArray = ["B_Heli_Light_01_F" , "B_mas_UH1Y_UNA_F"]; //AddHeliToRaid - сюда вертолеты
 _vehArray = _vehArray + _Lifes;
{
  _vehName = getText (configFile >> "CfgVehicles" >> _x >> "displayname");  
  lbAdd [(_this # 1), _vehName];
  lbSetData [(_this # 1), _forEachIndex, _x];
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
      _govno setVariable ["LoopValue", 0, true];
      _veh = _govno getVariable ["keys", 50];

    _govno addEventHandler ["Fired", { 
        params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"]; 
        _unit setVariable ["FiredInSafeZone", true, true];
        _unit setVariable ["TimerFired", 30, true];
        _loops = _unit getVariable "LoopValue";
        _unit setVariable ["LoopValue", _loops + 1, true];

        if (_unit getVariable ["TimerFired", 0] != 0) then 
        {

            [_unit] spawn 
            { 
                _unit = (_this # 0); 
                scopeName "loopVeh2";
                while {(_unit getVariable ["FiredInSafeZone",false]) || _unit getVariable ["TimerFired",0] != 0} do 
                {  
                     scopeName "loopVeh";  
                     _time = _unit getVariable "TimerFired";
                     if (alive _unit && (_unit getVariable "LoopValue") < 2 && _unit getVariable "TimerFired" > 0) then 
                            {
                              _unit setVariable ["TimerFired", _time - 1, true];
                              sleep 1;
                            }   else 
                                    {
                                    _currentLoops = _unit getVariable "LoopValue";
                                    _unit setVariable ["LoopValue", _currentLoops - 1, true];
                                    breakTo "loopVeh2";
                                    };
                if (_unit getVariable "TimerFired" == 0) then {_unit setVariable ["FiredInSafeZone", nil, true]; _unit setVariable ["TimerFired", nil, true]; _unit setVariable ["LoopValue", 0, true];}
                };
            };
       };
    }];

    _govno addEventHandler ["GetIn", { 
 params ["_vehicle", "_role", "_unit", "_turret"]; 
    if (_unit getVariable "FiredInSafeZone" == true ) then {
      _timer = _unit getVariable "SafeZoneTimer";

       _vehicle setVariable ["FiredInSafeZone", true, true];
        _vehicle setVariable ["TimerFired", _timer, true];
        _loops = _vehicle getVariable "LoopValue";
        _vehicle setVariable ["LoopValue", _loops + 1, true];

        if (_vehicle getVariable ["TimerFired", 0] != 0) then 
        {

            [_vehicle] spawn 
            { 
                _vehicle = (_this # 0); 
                scopeName "loopVeh2";
                while {(_vehicle getVariable ["FiredInSafeZone",false]) || _vehicle getVariable ["TimerFired",0] != 0} do 
                {  
                     scopeName "loopVeh";  
                     _time = _vehicle getVariable "TimerFired";
                     if (alive _vehicle && (_vehicle getVariable "LoopValue") < 2 && _vehicle getVariable "TimerFired" > 0) then 
                            {
                              _vehicle setVariable ["TimerFired", _time - 1, true];
                              sleep 1;
                            }   else 
                                    {
                                    _currentLoops = _vehicle getVariable "LoopValue";
                                    _vehicle setVariable ["LoopValue", _currentLoops - 1, true];
                                    breakTo "loopVeh2";
                                    };
                if (_vehicle getVariable "TimerFired" == 0) then {_vehicle setVariable ["FiredInSafeZone", nil, true]; _vehicle setVariable ["TimerFired", nil, true]; _vehicle setVariable ["LoopValue", 0, true];}
                };
            };
       };
    };
}];

    };


FREDDT_FNC_LOADARMOREDLANDVEH = {
 [] spawn {
 _vehArray = ["I_MRAP_03_hmg_F", "I_MRAP_03_gmg_F", "I_MBT_03_cannon_F", "O_MBT_04_command_F", "O_MBT_02_cannon_F", "B_MBT_01_TUSK_F", "I_LT_01_AA_F", "I_APC_Wheeled_03_cannon_F", "O_APC_Tracked_02_AA_F", "B_APC_Tracked_01_AA_F"];
{
  _vehName = getText (configFile >> "CfgVehicles" >> _x >> "displayname");  
  lbAdd [3615, _vehName];
  lbSetData [3615, _forEachIndex, _x];
} forEach  _vehArray;


while {!IsNull (FindDisplay 12343891)} do {
  _index = lbCurSel 3615;
  _vehicle = lbData [3615, _index];
  switch (true) do {
  case (_vehicle isKindOf "I_MRAP_03_hmg_F") : {_cost = 2300; globalCost = _cost; ((Finddisplay 12343891) displayCtrl 7777) ctrlSetText format ["%1", _cost]; ((Finddisplay 12343891) displayCtrl 777) ctrlSetStructuredText parseText "<img size = '3' align='center' valign='bottom' image='\A3\soft_f_beta\MRAP_03\Data\UI\MRAP_03_HMG_ca.paa'/>";};//Страйдер 12.7
  case (_vehicle isKindOf "I_MRAP_03_gmg_F") : {_cost = 3300; globalCost = _cost; ((Finddisplay 12343891) displayCtrl 7777) ctrlSetText format ["%1", _cost]; ((Finddisplay 12343891) displayCtrl 777) ctrlSetStructuredText parseText "<img size = '3' align='center' valign='bottom' image='\A3\soft_f_beta\MRAP_03\Data\UI\MRAP_03_RCWS_ca.paa'/>";};//Страйдер ГП
  case (_vehicle isKindOf "I_MBT_03_cannon_F") : {_cost = 5430; globalCost = _cost; ((Finddisplay 12343891) displayCtrl 7777) ctrlSetText format ["%1", _cost]; ((Finddisplay 12343891) displayCtrl 777) ctrlSetStructuredText parseText "<img size = '3' align='center' valign='bottom' image='\A3\Armor_F_EPB\MBT_03\Data\UI\MBT_03_Ca.paa'/>";};//Кума
  case (_vehicle isKindOf "O_MBT_04_command_F") : {_cost = 7900; globalCost = _cost; ((Finddisplay 12343891) displayCtrl 7777) ctrlSetText format ["%1", _cost]; ((Finddisplay 12343891) displayCtrl 777) ctrlSetStructuredText parseText "<img size = '3' align='center' valign='bottom' image='\A3\Armor_F_Tank\MBT_04\Data\UI\MBT_04_command.paa'/>";};//Ангара
  case (_vehicle isKindOf "O_MBT_02_cannon_F") : {_cost = 6850; globalCost = _cost; ((Finddisplay 12343891) displayCtrl 7777) ctrlSetText format ["%1", _cost]; ((Finddisplay 12343891) displayCtrl 777) ctrlSetStructuredText parseText "<img size = '3' align='center' valign='bottom' image='\A3\armor_f_gamma\MBT_02\Data\UI\MBT_02_Base_ca.paa'/>";};//Варсук
  case (_vehicle isKindOf "B_MBT_01_TUSK_F") : {_cost = 4900; globalCost = _cost; ((Finddisplay 12343891) displayCtrl 7777) ctrlSetText format ["%1", _cost]; ((Finddisplay 12343891) displayCtrl 777) ctrlSetStructuredText parseText "<img size = '3' align='center' valign='bottom' image='\A3\armor_f_gamma\MBT_01\Data\UI\Slammer_M2A1_Base_ca.paa'/>";};//Сламмер
  case (_vehicle isKindOf "I_APC_Wheeled_03_cannon_F") : {_cost = 9340; globalCost = _cost; ((Finddisplay 12343891) displayCtrl 7777) ctrlSetText format ["%1", _cost]; ((Finddisplay 12343891) displayCtrl 777) ctrlSetStructuredText parseText "<img size = '3' align='center' valign='bottom' image='\A3\armor_f_gamma\APC_Wheeled_03\data\UI\APC_Wheeled_03_ca.paa'/>";};//Горгона
  case (_vehicle isKindOf "I_LT_01_AA_F") : {_cost = 7000; globalCost = _cost; ((Finddisplay 12343891) displayCtrl 7777) ctrlSetText format ["%1", _cost]; ((Finddisplay 12343891) displayCtrl 777) ctrlSetStructuredText parseText "<img size = '3' align='center' valign='bottom' image='\A3\Armor_F_Tank\LT_01\data\UI\LT_01_AA.paa'/>";};//Нюкс ПВ
  case (_vehicle isKindOf "O_APC_Tracked_02_AA_F") : {_cost = 7500; globalCost = _cost; ((Finddisplay 12343891) displayCtrl 7777) ctrlSetText format ["%1", _cost]; ((Finddisplay 12343891) displayCtrl 777) ctrlSetStructuredText parseText "<img size = '3' align='center' valign='bottom' image='\A3\armor_f_beta\APC_Tracked_02\Data\UI\APC_Tracked_02_aa_ca.paa'/>";};//Тигрис
  case (_vehicle isKindOf "B_APC_Tracked_01_AA_F") : {_cost = 8400; globalCost = _cost; ((Finddisplay 12343891) displayCtrl 7777) ctrlSetText format ["%1", _cost]; ((Finddisplay 12343891) displayCtrl 777) ctrlSetStructuredText parseText "<img size = '3' align='center' valign='bottom' image='\A3\armor_f_beta\APC_Tracked_01\Data\UI\APC_Tracked_01_AA_ca.paa'/>";};//Читаха
  case (_vehicle isKindOf "B_Heli_Transport_01_camo_F") : {_cost = 5000; globalCost = _cost; ((Finddisplay 12343891) displayCtrl 7777) ctrlSetText format ["%1", _cost]; ((Finddisplay 12343891) displayCtrl 777) ctrlSetStructuredText parseText "<img size = '3' align='center' valign='bottom' image='\A3\Air_F_Beta\Heli_Transport_01\Data\UI\Heli_Transport_01_base_CA.paa'/>";};//Госта
  case (_vehicle isKindOf "O_Heli_Light_02_F") : {_cost = 18250; globalCost = _cost; ((Finddisplay 12343891) displayCtrl 7777) ctrlSetText format ["%1", _cost]; ((Finddisplay 12343891) displayCtrl 777) ctrlSetStructuredText parseText "<img size = '3' align='center' valign='bottom' image='\A3\Air_F\Heli_Light_02\Data\UI\Heli_Light_02_rockets_CA.paa'/>";};//Орка
  case (_vehicle isKindOf "O_Heli_Attack_02_F") : {_cost = 22500; globalCost = _cost; ((Finddisplay 12343891) displayCtrl 7777) ctrlSetText format ["%1", _cost]; ((Finddisplay 12343891) displayCtrl 777) ctrlSetStructuredText parseText "<img size = '3' align='center' valign='bottom' image='\A3\Air_F_Beta\Heli_Attack_02\Data\UI\Heli_Attack_02_CA.paa'/>";};//Кайман
  case (_vehicle isKindOf "B_Heli_Attack_01_F") : {_cost = 25350; globalCost = _cost; ((Finddisplay 12343891) displayCtrl 7777) ctrlSetText format ["%1", _cost]; ((Finddisplay 12343891) displayCtrl 777) ctrlSetStructuredText parseText "<img size = '3' align='center' valign='bottom' image='\A3\Air_F_Beta\Heli_Attack_01\Data\UI\Heli_Attack_01_CA.paa'/>";};//Бфка
  sleep 0.1;
      };
    };
  };
};



FREDDT_FNC_LOADARMOREDAIRVEH = {
 [] spawn {
 _vehArray = ["B_Heli_Transport_01_camo_F", "O_Heli_Light_02_F", "O_Heli_Attack_02_F", "B_Heli_Attack_01_F"];
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

      _govno addEventHandler ["Fired", { 
        params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"]; 
        _unit setVariable ["FiredInSafeZone", true, true];
        _unit setVariable ["TimerFired", 30, true];
        _loops = _unit getVariable "LoopValue";
        _unit setVariable ["LoopValue", _loops + 1, true];

        if (_unit getVariable ["TimerFired", 0] != 0) then 
        {

            [_unit] spawn 
            { 
                _unit = (_this # 0); 
                scopeName "loopVeh2";
                while {(_unit getVariable ["FiredInSafeZone",false]) || _unit getVariable ["TimerFired",0] != 0} do 
                {  
                     scopeName "loopVeh";  
                     _time = _unit getVariable "TimerFired";
                     if (alive _unit && (_unit getVariable "LoopValue") < 2 && _unit getVariable "TimerFired" > 0) then 
                            {
                              _unit setVariable ["TimerFired", _time - 1, true];
                              sleep 1;
                            }   else 
                                    {
                                    _currentLoops = _unit getVariable "LoopValue";
                                    _unit setVariable ["LoopValue", _currentLoops - 1, true];
                                    breakTo "loopVeh2";
                                    };
                if (_unit getVariable "TimerFired" == 0) then {_unit setVariable ["FiredInSafeZone", nil, true]; _unit setVariable ["TimerFired", nil, true]; _unit setVariable ["LoopValue", 0, true];}
                };
            };
       };
    }];

    _govno addEventHandler ["GetIn", { 
 params ["_vehicle", "_role", "_unit", "_turret"]; 
    if (_unit getVariable "FiredInSafeZone" == true ) then {
      _timer = _unit getVariable "SafeZoneTimer";

       _vehicle setVariable ["FiredInSafeZone", true, true];
        _vehicle setVariable ["TimerFired", _timer, true];
        _loops = _vehicle getVariable "LoopValue";
        _vehicle setVariable ["LoopValue", _loops + 1, true];

        if (_vehicle getVariable ["TimerFired", 0] != 0) then 
        {

            [_vehicle] spawn 
            { 
                _vehicle = (_this # 0); 
                scopeName "loopVeh2";
                while {(_vehicle getVariable ["FiredInSafeZone",false]) || _vehicle getVariable ["TimerFired",0] != 0} do 
                {  
                     scopeName "loopVeh";  
                     _time = _vehicle getVariable "TimerFired";
                     if (alive _vehicle && (_vehicle getVariable "LoopValue") < 2 && _vehicle getVariable "TimerFired" > 0) then 
                            {
                              systemChat (str(_vehicle getVariable "TimerFired"));
                              systemChat "Фреди сын шлюхи";
                              _vehicle setVariable ["TimerFired", _time - 1, true];
                              sleep 1;
                            }   else 
                                    {
                                    _currentLoops = _vehicle getVariable "LoopValue";
                                    _vehicle setVariable ["LoopValue", _currentLoops - 1, true];
                                    breakTo "loopVeh2";
                                    };
                if (_vehicle getVariable "TimerFired" == 0) then {_vehicle setVariable ["FiredInSafeZone", nil, true]; _vehicle setVariable ["TimerFired", nil, true]; _vehicle setVariable ["LoopValue", 0, true];}
                };
            };
       };
    };
}];
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
_vehicle = ["I_MRAP_03_hmg_F", "I_MRAP_03_gmg_F", "I_MBT_03_cannon_F", "O_MBT_04_command_F", "O_MBT_02_cannon_F", "B_MBT_01_TUSK_F", "I_APC_Wheeled_03_cannon_F", "I_LT_01_AA_F", "O_APC_Tracked_02_AA_F", "B_APC_Tracked_01_AA_F", "B_Heli_Transport_01_camo_F", "O_Heli_Light_02_F", "O_Heli_Attack_02_F", "B_Heli_Attack_01_F"];
_nearestTrg = [_trg, player] call BIS_fnc_nearestPosition;
_entitiesArray = (getMarkerPos _nearestTrg) nearestObject "AllVehicles";
_player = player;
_UID = getPlayerUID player;

_zaloopa1 = typeof _entitiesArray;
_vehName = getText (configFile >> "CfgVehicles" >> _zaloopa1 >> "displayname");
_veh = _entitiesArray getVariable ["keys", 50];
	call Freddy_fnc_StoreCooldown;
if (count crew _entitiesArray > 0) exitWith {hint "В технике кто-то есть";};
if (_player getVariable ["CouldntStore", false] == false) then {hint "Подождите немного";} else {
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

//Рейдовые функции гаража

//Вычитание общих жизней РЕЙД
PENA_RAID_CREATEVEH_CHECKER = {
  _index = lbCurSel 60000; 
  _vehicle = lbData [60000, _index]; 
  [player, _vehicle]remoteExec["PENA_CREATEVEH", 2 , false];
};

PENA_CREATING_VEH = {
  _trg = ["CreateVehRaidAt", "CreateVehRaidDef"];
  _nearestTrg = [_trg, player] call BIS_fnc_nearestPosition;
  _entitiesArray = (getMarkerPos _nearestTrg) nearEntities [["Landvehicle", "Air"], 10];
  if (count (_entitiesArray)!=0) exitWith {hint "Место занято"};

  [player, getPlayerUID player, (_this # 0)]remoteExec["PENA_DB_PAYLIFE_FNC", 2 , false];
  _player = player;
  _UID = getPlayerUID _player;
  _vehicle = (_this # 0);
  _markArray = ["CreateVehRaidAt" , "CreateVehRaidDef"];
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
  [_player, _vehicle, 1]remoteExec["PENA_DECREASE_RAID_LIFE", 2 , false];
  _govno setVariable ["keys", _UID, true];
  _veh = _govno getVariable ["keys", 50];
};

  freddy_fnc_LoadLightVehRaidArray = { 
   [] spawn { 
   _unitSide = 0; 
  if (player getVariable ["Defender", false] == true) then {_unitSide = "Defender"; hint "def";} else {_unitSide = "Attacker"; hint "at"}; 
   _vehArray = ["O_MRAP_02_F","ver_vaz_2114_uck", "BPAN_priora", "ver_vaz_2114_OPER", "ivory_evox", "ivory_wrx", "ivory_supra", "ivory_r34"]; // AddVehToRaid - сюда легковая техника
   _specVehArray = ["O_Truck_03_ammo_F"]; //AddSpecVehToRaid - сюда специальная
   _heliArray = ["B_Heli_Light_01_F", "B_mas_UH1Y_UNA_F"]; //AddHeliToRaid - сюда вертолеты
   
  { 
    _vehName = getText (configFile >> "CfgVehicles" >> _x >> "displayname");   
    lbAdd [60000, _vehName]; 
    lbSetData [60000, _forEachIndex, _x]; 
  } forEach  _vehArray; 
   
   
  while {!IsNull (FindDisplay 60100)} do { 
    _index = lbCurSel 60000; 
    _vehicle = lbData [60000, _index]; 
    _loadedLifes = Lifes; 
   
   
      switch (true) do { 
      //ЛЕГКОВАЯ ТЕХНИКА 
    case ((_vehArray find _vehicle) != -1 ) : { 
    if (_unitSide == "Defender") then { 
      ((Finddisplay 60100) displayCtrl 60002) ctrlSetText format ["%1", (OnGoingData # 0 # 0)];
  } else {
      ((Finddisplay 60100) displayCtrl 60002) ctrlSetText format ["%1", (OnGoingData # 0 # 1)];
  }; 
   
  };
       case ((_specVehArray find _vehicle) != -1 ) : { 
    if (_unitSide == "Defender") then { 
      ((Finddisplay 60100) displayCtrl 60002) ctrlSetText format ["%1", (OnGoingData # 3 # 0)];
  } else {
      ((Finddisplay 60100) displayCtrl 60002) ctrlSetText format ["%1", (OnGoingData # 3 # 1)];
  }; 
   
  };

  case ((_heliArray find _vehicle) != -1 ) : { 
    if (_unitSide == "Defender") then { 
      ((Finddisplay 60100) displayCtrl 60002) ctrlSetText format ["%1", (OnGoingData # 1 # 0)];
  } else {
      ((Finddisplay 60100) displayCtrl 60002) ctrlSetText format ["%1", (OnGoingData # 1 # 1)];
  }; 
   
  };
      //БРОНИРОВАННАЯ ТЕХНИКА
    case (_vehicle isKindOf "I_MRAP_03_hmg_F") : {_lifes = (_loadedLifes select 0);((Finddisplay 60100) displayCtrl 60002) ctrlSetText format ["%1", _lifes];};//Страйдер 12.7
    case (_vehicle isKindOf "I_MRAP_03_gmg_F") : {_lifes = (_loadedLifes select 1);((Finddisplay 60100) displayCtrl 60002) ctrlSetText format ["%1", _lifes];};//Страйдер ГП
    case (_vehicle isKindOf "I_MBT_03_cannon_F") : {_lifes = (_loadedLifes select 2);((Finddisplay 60100) displayCtrl 60002) ctrlSetText format ["%1", _lifes];};//Кума 
    case (_vehicle isKindOf "O_MBT_04_command_F") : {_lifes = (_loadedLifes select 3);((Finddisplay 60100) displayCtrl 60002) ctrlSetText format ["%1", _lifes];};//Ангара 
    case (_vehicle isKindOf "O_MBT_02_cannon_F") : {_lifes = (_loadedLifes select 4);((Finddisplay 60100) displayCtrl 60002) ctrlSetText format ["%1", _lifes];};//Варсук 
    case (_vehicle isKindOf "B_MBT_01_cannon_F") : {_lifes = (_loadedLifes select 5);((Finddisplay 60100) displayCtrl 60002) ctrlSetText format ["%1", _lifes];};//Сламмер 
    case (_vehicle isKindOf "I_APC_Wheeled_03_cannon_F") : {_lifes = (_loadedLifes select 6);((Finddisplay 60100) displayCtrl 60002) ctrlSetText format ["%1", _lifes];};//Горгона
    case (_vehicle isKindOf "I_LT_01_AA_F") : {_lifes = (_loadedLifes select 7);((Finddisplay 60100) displayCtrl 60002) ctrlSetText format ["%1", _lifes];};//Тигрис 
    case (_vehicle isKindOf "O_APC_Tracked_02_AA_F") : {_lifes = (_loadedLifes select 8);((Finddisplay 60100) displayCtrl 60002) ctrlSetText format ["%1", _lifes];};//Тигрис 
    case (_vehicle isKindOf "B_APC_Tracked_01_AA_F") : {_lifes = (_loadedLifes select 9);((Finddisplay 60100) displayCtrl 60002) ctrlSetText format ["%1", _lifes];};//Читаха
    case (_vehicle isKindOf "B_Heli_Transport_01_camo_F") : {_lifes = (_loadedLifes select 10);((Finddisplay 60100) displayCtrl 60002) ctrlSetText format ["%1", _lifes];};//Госта 
    case (_vehicle isKindOf "O_Heli_Light_02_F") : {_lifes = (_loadedLifes select 11);((Finddisplay 60100) displayCtrl 60002) ctrlSetText format ["%1", _lifes];};//орка 
    case (_vehicle isKindOf "O_Heli_Attack_02_F") : {_lifes = (_loadedLifes select 12);((Finddisplay 60100) displayCtrl 60002) ctrlSetText format ["%1", _lifes];};//кайман 
    case (_vehicle isKindOf "B_Heli_Attack_01_F") : {_lifes = (_loadedLifes select 13);((Finddisplay 60100) displayCtrl 60002) ctrlSetText format ["%1", _lifes];};//бф 
    default {_lifes = " ";((Finddisplay 60100) displayCtrl 60002) ctrlSetText format ["%1", _lifes];}; 
    }; 
    sleep 0.1; 
        }; 
      }; 
    };

  freddy_fnc_LoadTruckVehRaidArray = {
 [] spawn {
 _vehArray = ["O_Truck_03_ammo_F"];
{
  _vehName = getText (configFile >> "CfgVehicles" >> _x >> "displayname");  
  lbAdd [60000, _vehName];
  lbSetData [60000, _forEachIndex, _x];
} forEach  _vehArray;
  };
};

  pena_fnc_PreHeliArrayRaid = {
  _player = player;
  _UID = getPlayerUID player;

  [_player, _UID] remoteExec ["PENA_DB_LOAD_HELI", 2 ,false];
};

