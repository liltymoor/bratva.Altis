	raidLobbyAt = [];
	raidLobbyDef = [];

	raidLobbyQueAt = [];
	raidLobbyQueDef = [];

	OnGoingRadeData = [];

	HeavyVehArr = ["I_MRAP_03_hmg_F", "I_MRAP_03_gmg_F", "B_AFV_Wheeled_01_up_cannon_F", "I_MBT_03_cannon_F", "O_MBT_04_command_F", "O_MBT_02_cannon_F", "B_MBT_01_TUSK_F", "B_APC_Wheeled_01_cannon_F", "I_APC_tracked_03_cannon_F", "I_APC_Wheeled_03_cannon_F", "O_APC_Tracked_02_cannon_F", "I_LT_01_AA_F", "O_APC_Tracked_02_AA_F", "B_APC_Tracked_01_AA_F", "B_Heli_Transport_01_camo_F", "O_Heli_Light_02_F", "I_Heli_light_03_F", "O_Heli_Attack_02_F", "B_Heli_Attack_01_F"]; //AddHeavyVehToRaid - сюда боевая

	waitingForRewardArray = []; 

	//Погода
	0 setOvercast 1;
	0 setRain 0.2;
	0 setFog 0; 
	setWind [0.5, 0.5, true];
	setDate [1986, 2, 25, 14, 0];
	forceWeatherChange;

	diag_log "Инициализация скриптов выполнена";
	protocol = "PenaUpal";
	db_name = "PenaDB";
	_result = "Extdb3" callExtension format["9:ADD_DATABASE:%1",db_name];
	if (!(_result isEqualTo "[1]")) then {
  	diag_log "extDB3: Ошибка соединения с базой данных";
	};
	diag_log [_result];
	_result = "Extdb3" callExtension format["9:ADD_DATABASE_PROTOCOL:%1:SQL:%2:TEXT",db_name,protocol];
	if (!(_result isEqualTo "[1]")) then {
  	diag_log "extDB3: Ошибка соединения с базой данных";
	};
	diag_log [_result];


/*
'########::'########:::'#######::'########:'####:'##:::::::'########:
 ##.... ##: ##.... ##:'##.... ##: ##.....::. ##:: ##::::::: ##.....::
 ##:::: ##: ##:::: ##: ##:::: ##: ##:::::::: ##:: ##::::::: ##:::::::
 ########:: ########:: ##:::: ##: ######:::: ##:: ##::::::: ######:::
 ##.....::: ##.. ##::: ##:::: ##: ##...::::: ##:: ##::::::: ##...::::
 ##:::::::: ##::. ##:: ##:::: ##: ##:::::::: ##:: ##::::::: ##:::::::
 ##:::::::: ##:::. ##:. #######:: ##:::::::'####: ########: ########:
..:::::::::..:::::..:::.......:::..::::::::....::........::........::
*/

//Проверка випки
freddy_fnc_getTimeleft = {
_UID = getPlayerUID (_this # 0);
_dateStart    = systemTime;
_dateEnd    = "extDB3" callExtension format ["0:PenaUpal:SELECT SPONSOR_TIMELEFT FROM `PlayerStats` WHERE UID=""%1""", _UID];
_dateEnd = (_dateEnd splitString ",][");    
_dateEnd deleteAt 0;

_yearStart    = _dateStart select 0;
_monthStart    = _dateStart select 1;
_dayStart    = _dateStart select 2;
_hourStart    = _dateStart select 3;
_minStart    = _dateStart select 4;

_yearEnd    = parsenumber (_dateEnd select 0);
_monthEnd    = parsenumber (_dateEnd select 1);
_dayEnd        = parsenumber (_dateEnd select 2);
_hourEnd    = parsenumber (_dateEnd select 3);
_minEnd        = parsenumber (_dateEnd select 4);

_daysTotal    = 0;

for "_i" from _yearStart to (_yearEnd - 1) do
{
LeapYear    = if(_i mod 4 == 0 && {_i mod 100 != 0 || _i mod 400 == 0}) then {true} else {false};
   if(LeapYear) then
   {
       _daysTotal = _daysTotal + 366;
   }
   else
   {
       _daysTotal = _daysTotal + 365;
   };
};

_isLeapYear    = if(_yearStart mod 4 == 0 && {_yearStart mod 100 != 0 || _yearStart mod 400 == 0}) then {true} else {false};
_daysSum    = 0;

_daysOfMonths    = [31, if(_isLeapYear) then {29} else {28}, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
{
   if(_monthStart isEqualTo (_forEachIndex + 1)) exitWith {};
   _daysSum = _daysSum - _x;
} forEach _daysOfMonths;

_isLeapYear    = if(_yearEnd mod 4 == 0 && {_yearEnd mod 100 != 0 || _yearEnd mod 400 == 0}) then {true} else {false};
_daysOfMonths    = [31, if(_isLeapYear) then {29} else {28}, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
{
   if(_monthEnd isEqualTo (_forEachIndex + 1)) exitWith {};
   _daysSum = _daysSum + _x;
} forEach _daysOfMonths;

_daysTotal = _daysTotal - _dayStart + _dayEnd + _daysSum;
diag_log _daysTotal;
switch (true) do {
        case (str(_dateEnd) == str([""""""])) : {diag_log "випка снята0"; "extDB3" callExtension format["0:PenaUpal:UPDATE PlayerStats SET SPONSOR_TIMELEFT='%1' WHERE UID='%2'", "", _UID]; "extDB3" callExtension format["0:PenaUpal:UPDATE PlayerStats SET SPONSOR_LVL='%1' WHERE UID='%2'", 1, _UID];}; //пусто
        case (_daysTotal <= 0) : {diag_log "випка снята1"; "extDB3" callExtension format["0:PenaUpal:UPDATE PlayerStats SET SPONSOR_TIMELEFT='%1' WHERE UID='%2'", "", _UID]; "extDB3" callExtension format["0:PenaUpal:UPDATE PlayerStats SET SPONSOR_LVL='%1' WHERE UID='%2'", 1, _UID];};
         default {diag_log "випка выдана"; "extDB3" callExtension format["0:PenaUpal:UPDATE PlayerStats SET SPONSOR_LVL='%1' WHERE UID='%2'", 5, _UID]; (_UID call BIS_fnc_getUnitByUID) setVariable ["SPONSOR", true, true];}; 
     };      
};
	
	PENA_LOAD_STATS = {
	
		_result  =  ("extDB3" callExtension format ["0:PenaUpal:SELECT NAME, KILL_STAT, UID, SCORE FROM `PlayerStats`"]);    
		_result = (_result splitString ",][");    
		_result deleteAt 0; 
		_player = (_this # 0);  
  
	   	_sortedPl = [];

		_counter = -1;   
		_size = count _result;   
		_playersArray = [];   
		   
		   
		for "_i" from 0 to _size do {    
		_counter = _counter + 1;   
		if (_counter == 4) then {   
		_sortedPl pushBack _playersArray;   
		_playersArray = [];   
		_counter = 0;   
		   
		};   
		_playersArray pushBack _result # _i;   
		};

		_result1  = "extDB3" callExtension format ["0:PenaUpal:SELECT KILL_STAT FROM `PlayerStats` WHERE UID=""%1""", getPlayerUID _player];
		_result1 = (_result1 splitString ",][");
		_result1 deleteAt 0; 
		_result1 = parseNumber(_result1 # 0);

		_kills = _result1;


		_result2 = "extDB3" callExtension format ["0:PenaUpal:SELECT SCORE FROM `PlayerStats` WHERE UID=""%1""", getPlayerUID _player];
		_result2 = (_result2 splitString ",][");
		_result2 deleteAt 0; 
		_result2 = parseNumber(_result2 # 0);

		_score = _result2;
		
		[_sortedPl, _kills, _score]remoteExecCall["PENA_SORTED_PLAYER", _player , false];

	};


	PENA_DB_EnmKilled = {
	_killer = (_this # 0);
	_UID = getPlayerUID _killer;
	_result  = "extDB3" callExtension format ["0:PenaUpal:SELECT KILL_STAT FROM `PlayerStats` WHERE UID=""%1""", getPlayerUID _killer];
	_result = (_result splitString ",][");
	_result deleteAt 0; 
	_result = parseNumber(_result # 0);
	_result = _result + 1;
	"extDB3" callExtension format["0:PenaUpal:UPDATE PlayerStats SET KILL_STAT='%1' WHERE UID='%2'", _result, _UID];
};



// фреди сыночек дуры 
	PENA_DB_CHECK = {
	_UID = (_this select 0);
	_name = (_this select 1);

	diag_log "Подключился новый чел";
	diag_log [_UID, _name];

	_result  = "extDB3" callExtension format ["0:PenaUpal:SELECT UID FROM `Player` WHERE UID=""%1""",_UID];

	_array = _result splitString ",][";
	 diag_log [_array select 1];

	if (isNil {_array select 1}) then {

	//Создание бд для нового чубрека	
	diag_log "Новый пользователь";

	_result = "extDB3" callExtension format["0:PenaUpal:USE PenaDB"]; 

	_Money = 0; 
	_UID = (_this select 0); 
	_name = (_this select 1);
	_unit = (_this select 3);
	private _gear = []; 
	protocol = "PenaUpal"; 
	db_name = "PenaDB";
	_currentTime = systemTime;
	_title = "";

	//Создание начальных бд
	"extDB3" callExtension format["0:PenaUpal:INSERT INTO Player (UID, NAME, MONEY, FIRST_CON, LAST_CON, TITLE) VALUES (""%1"",""%2"", ""%3"", ""%4"", ""%4"", ""%5"")", _UID, _name, _Money, _currentTime, _title]; //Player

	"extDB3" callExtension format["0:PenaUpal:INSERT INTO PlayerGear (UID, GearOpfor, GearBlufor, GearIndependent) VALUES ('%1','%2','%2','%2')", _UID,  _gear]; //PlayerGear

	"extDB3" callExtension format["0:PenaUpal:INSERT INTO PlayerGarage (UID) VALUES ('%1')", _UID]; //PlayerGarage

	"extDB3" callExtension format["0:PenaUpal:INSERT INTO PlayerStats (UID, NAME, KILL_STAT, SPONSOR_LVL, SCORE) VALUES ('%1', '%2', '%3', '%4', '%5')", _UID, _name, 0, 1, 0]; //PlayerStats



	diag_log "Создание тк бд нет";
	diag_log [_result];

	} else {
	//Обновление бд для старого чубрека



	diag_log "Старый пользователь";
	_time = systemTime;
	_result = "extDB3" callExtension format["0:PenaUpal:UPDATE Player SET NAME=""%1"", LAST_CON=""%2"" WHERE UID=""%3""", _name, _time, _UID]; 
	diag_log "Обновление так как бд есть";
	diag_log [_result];
	};


	};

		PENA_DB_LOADMONEY = {
	diag_log "Ало прием это подгрузка бабла";
	_UID = (_this select 0);
	_player = (_this select 1);

	_result  = "extDB3" callExtension format ["0:PenaUpal:SELECT MONEY FROM `Player` WHERE UID=""%1""",_UID];

	_array = _result splitString ",][";
	MoneyPlayer = _array select 1;
	 diag_log [MoneyPlayer];

	[MoneyPlayer] remoteExec ["PENA_MONEY_FROM_SERVER", _player, false];

	MoneyPlayer;
	};


	PENA_DB_SAVERATING = {
	_player = (_this select 0);
	_rating = (_this select 1);

	_result  = "extDB3" callExtension format ["0:PenaUpal:SELECT SCORE FROM `PlayerStats` WHERE UID=""%1""", getPlayerUID _player];
	_result = (_result splitString ",][");
	_result deleteAt 0;
	_result = parseNumber(_result # 0);
	_result = _result + _rating;
	

	_void = "extDB3" callExtension format["0:PenaUpal:UPDATE PlayerStats SET SCORE=""%1"" WHERE UID=""%2""", _result , getPlayerUID _player];
	[_player] remoteExec ["PENA_PROFILE_LOAD", 2, false];
};

	PENA_DB_SAVEMONEY = {

	_Money = (_this select 0);
	_UID = (_this select 1);
	_player = (_this select 2);
	diag_log ("Игроку " + str _UID  + "было зачислено: " + str _Money + " за убийство.");
	_CurrentMoney = [_UID, _player]call PENA_DB_LOADMONEY;
	_CurrentMoney = (parseNumber _CurrentMoney) + _Money;
	_result = "extDB3" callExtension format["0:PenaUpal:UPDATE Player SET MONEY=""%1"" WHERE UID=""%2""", _CurrentMoney, _UID]; 
	};

PENA_SAVE_GEAR_FNC = {
	_unit = (_this # 0);
	_uid = (_this # 1);
	_gear = (_this # 2);
	_playerSide = (_this # 3);

    diag_log "Сохранение снаряжения (2/2 - Сервер)";
    diag_log format ['%1', _playerSide];

    if (_unit getVariable ["Attacker", false] == true) exitWith {
    "extDB3" callExtension format ["0:PenaUpal:UPDATE PlayerGear SET GearAttacker='[]' WHERE UID='%1'",_uid];
    "extDB3" callExtension format ["0:PenaUpal:UPDATE PlayerGear SET GearAttacker='%1' WHERE UID='%2'",_gear, _uid];
    };
    if (_unit getVariable ["Defender", false] == true) exitWith {
    "extDB3" callExtension format ["0:PenaUpal:UPDATE PlayerGear SET GearDefender='[]' WHERE UID='%1'",_uid];
    "extDB3" callExtension format ["0:PenaUpal:UPDATE PlayerGear SET GearDefender='%1' WHERE UID='%2'",_gear, _uid];
	};
    switch (_playerSide) do {
        case EAST: 
        {
            "extDB3" callExtension format ["0:PenaUpal:UPDATE PlayerGear SET GearOpfor='[]' WHERE UID='%1'", _uid];
            "extDB3" callExtension format ["0:PenaUpal:UPDATE PlayerGear SET GearOpfor='%1' WHERE UID='%2'", _gear, _uid];
        };
        case WEST: 
        {
            "extDB3" callExtension format["0:PenaUpal:UPDATE PlayerGear SET GearBlufor='[]' WHERE UID='%1'", _uid];
            "extDB3" callExtension format["0:PenaUpal:UPDATE PlayerGear SET GearBlufor='%1' WHERE UID='%2'", _gear, _uid];
        };
        case independent: 
        {
            "extDB3" callExtension format["0:PenaUpal:UPDATE PlayerGear SET GearIndependent='[]' WHERE UID='%1'", _uid];
            "extDB3" callExtension format["0:PenaUpal:UPDATE PlayerGear SET GearIndependent='%1' WHERE UID='%2'", _gear, _uid];
        };
    };
};


PENA_TITLE_SAVE = {
	_title = (_this # 0);
	_player = (_this # 1);

	"extDB3" callExtension format["0:PenaUpal:UPDATE Player SET TITLE=""%1"" WHERE UID=""%2""", _title, getPlayerUID _player]; 
};

PENA_PROFILE_LOAD = {
	_player = (_this # 0);

	_title  = "extDB3" callExtension format ["0:PenaUpal:SELECT TITLE FROM `Player` WHERE UID=""%1""", getPlayerUID _player];
	_title = (_title splitString ",][");
	_title deleteAt 0; 

	_sponsorLVL = "extDB3" callExtension format ["0:PenaUpal:SELECT SPONSOR_LVL FROM `PlayerStats` WHERE UID=""%1""", getPlayerUID _player];
	_sponsorLVL = (_sponsorLVL splitString ",][");
	_sponsorLVL deleteAt 0; 

	_playerScore = "extDB3" callExtension format ["0:PenaUpal:SELECT SCORE FROM `PlayerStats` WHERE UID=""%1""", getPlayerUID _player];
	_playerScore = (_playerScore splitString ",][");
	_playerScore deleteAt 0;
	_playerScore = parseNumber (_playerScore # 0); 
	[_title # 0, _sponsorLVL # 0, _playerScore]remoteExecCall["PENA_GET_PROFILE", _player, false];
};


PENA_LOAD_GEAR_FNCS = {
  params [
        ['_netId', '', ['']]
    ];

    if (_netId isEqualTo '') exitWith {};
    _unit = objectFromNetId _netId;
    if (isNull _unit) exitWith {};

    _uid   =   getPlayerUID _unit;
    _side = side _unit;

    _result = nil; 

    switch (true) do {
        case (_unit getVariable ["Attacker", false] == true): 
        {
            _result  = parseSimpleArray ("extDB3" callExtension format ["0:PenaUpal:SELECT GearAttacker FROM PlayerGear WHERE UID='%1'",_uid]);//OPFOR
        };
        case (_unit getVariable ["Defender", false] == true): 
        {
            _result  = parseSimpleArray ("extDB3" callExtension format ["0:PenaUpal:SELECT GearDefender FROM PlayerGear WHERE UID='%1'",_uid]);//OPFOR
        };
        case (_side == EAST): 
        {
            _result  = parseSimpleArray ("extDB3" callExtension format ["0:PenaUpal:SELECT GearOpfor FROM PlayerGear WHERE UID='%1'",_uid]);//OPFOR
        };
        case (_side == WEST): 
        {
           	_result  = parseSimpleArray ("extDB3" callExtension format ["0:PenaUpal:SELECT GearBlufor FROM PlayerGear WHERE UID='%1'",_uid]);//BLUFOR
        };
        case (_side == independent): 
        {
            _result  = parseSimpleArray ("extDB3" callExtension format ["0:PenaUpal:SELECT GearIndependent FROM PlayerGear WHERE UID='%1'",_uid]); //INDEPENDENT
        };
    };

    if (_result # 1 isEqualType []) then {

        [_result # 1 # 0 # 0,
        {
            player setUnitLoadout _this;
            hint 'Вы получили снаряжение';
        }] remoteExecCall ['call', remoteExecutedOwner];

    } else {
        {
        hint 'Конфигурации снаряжения не найдено';
        } remoteExecCall ['call', remoteExecutedOwner];
    };
};

PENA_SHOP_TRANSACTION = { //Покупка техники -бабки + спавн
	_player = (_this select 0);
	_UID = (_this select 1);
	_VehCost = (_this select 2);
	_index = (_this select 3);
 	_vehicle = (_this select 4);

 	_trg = ["CreateArmoredVehMazi", "CreateArmoredVehSelicano", "CreateArmoredVehMolos"];
	_nearestTrg = [_trg, _player] call BIS_fnc_nearestPosition;
	_entitiesArray = (getMarkerPos _nearestTrg) nearEntities [["Landvehicle", "Air"], 10];

	if ((_player getVariable ["CouldntBuy", false]) != true) exitWith {"Подождите немного" remoteExec ["hint", _player, false];};
	_player setVariable ["CouldntBuy", nil, true];
	if (count (_entitiesArray)!=0) exitWith {"Место занято" remoteExec ["hint", _player, false];}; 

	_CurrentMoney = [_UID, _player]call PENA_DB_LOADMONEY;
	_curMoneyNumber = parseNumber _CurrentMoney;

	if (_curMoneyNumber < _VehCost) then {
		"У вас недостаточно денег" remoteExec ["hint", _player, false];
	} else {
	_curMoneyNumber = _curMoneyNumber - _VehCost;
	_result = "extDB3" callExtension format["0:PenaUpal:UPDATE Player SET MONEY=""%1"" WHERE UID=""%2""", _curMoneyNumber, _UID]; 
	[_UID, _player] remoteExec ["PENA_DB_LOADMONEY", 2 , false];
	[_index, _vehicle] remoteExec ["FNC_GOVNO", _player , false];
	};
};

//заносим поставленную технику в гараж
	PENA_DB_BUY_ARMORED_VEH = {

	_veh = (_this select 0);
	_UID = (_this select 1);

	_lifes = parseSimpleArray ("extDB3" callExtension format ["0:PenaUpal:SELECT %1 FROM PlayerGarage WHERE UID='%2'",_veh, _UID]);
	_lifes = _lifes # 1 # 0 # 0;
	_lifes = _lifes + 1;
	_result = "extDB3" callExtension format["0:PenaUpal:UPDATE PlayerGarage SET %1=""%2"" WHERE UID=""%3""", _veh, _lifes, _UID];
	
	diag_log ("Ставим технику " + getText (configFile >> "CfgVehicles" >> _veh >> "displayname") + " в гараж");
	diag_log ("Результат занесения в бд" + _result);
};


	PENA_DB_LOADLIFES_FNC = {

	_player = (_this select 0);
	_UID = (_this select 1);

	//_vehLifes = [_player, _UID] call PENA_DB_LOADVEH_FROM_DB;



    _lifes = parseSimpleArray ("extDB3" callExtension format ["0:PenaUpal:SELECT I_MRAP_03_hmg_F, I_MRAP_03_gmg_F, B_AFV_Wheeled_01_up_cannon_F, I_MBT_03_cannon_F, O_MBT_04_command_F, O_MBT_02_cannon_F, B_MBT_01_TUSK_F, B_APC_Wheeled_01_cannon_F, I_APC_tracked_03_cannon_F, I_APC_Wheeled_03_cannon_F, O_APC_Tracked_02_cannon_F, I_LT_01_AA_F, O_APC_Tracked_02_AA_F, B_APC_Tracked_01_AA_F, B_Heli_Transport_01_camo_F, O_Heli_Light_02_F, I_Heli_light_03_F, O_Heli_Attack_02_F, B_Heli_Attack_01_F FROM PlayerGarage WHERE UID='%1'",_uid]); 
    _lifes = _lifes # 1 # 0; 

	diag_log [_lifes];
	diag_log "Подгрузка жизней на серваке выполнена!";

	[_lifes] remoteExec ["PENA_CALLBACK_LIFES_FNC", _player, false];

};

	PENA_DB_LOAD_ARMORED_VEH = {


	_player = (_this select 0);
	_UID = (_this select 1);
	_idc = (_this # 2);
	diag_log _idc;
	_Lifes = [];
	//Земля
	_dbLifes = parseSimpleArray ("extDB3" callExtension format ["0:PenaUpal:SELECT I_MRAP_03_hmg_F, I_MRAP_03_gmg_F, B_AFV_Wheeled_01_up_cannon_F, I_MBT_03_cannon_F, O_MBT_04_command_F, O_MBT_02_cannon_F, B_MBT_01_TUSK_F, B_APC_Wheeled_01_cannon_F, I_APC_tracked_03_cannon_F, I_APC_Wheeled_03_cannon_F, O_APC_Tracked_02_cannon_F, I_LT_01_AA_F, O_APC_Tracked_02_AA_F, B_APC_Tracked_01_AA_F FROM PlayerGarage WHERE UID='%1'",_uid]); 
	_dbLifes = _dbLifes # 1 # 0; 
	for "_i" from 0 to count _dbLifes do {
		if (_dbLifes # _i != 0) then {
			switch (_i) do { 
				case 0 : {  _Lifes = _Lifes + ["I_MRAP_03_hmg_F"] }; //Страйдер 12.7
				case 1 : {  _Lifes = _Lifes + ["I_MRAP_03_gmg_F"] }; //Страйдер ГП
				case 2 : { _Lifes = _Lifes + ["B_AFV_Wheeled_01_up_cannon_F"]}; //Рино
				case 3 : { _Lifes = _Lifes + ["I_MBT_03_cannon_F"]}; //Кума
				case 4 : {  _Lifes = _Lifes + ["O_MBT_04_command_F"] }; //Angara
				case 5 : { _Lifes = _Lifes + ["O_MBT_02_cannon_F"] }; //Varsuk
				case 6 : {  _Lifes = _Lifes + ["B_MBT_01_TUSK_F"] }; //Slammer
				case 7 : {  _Lifes = _Lifes + ["B_APC_Wheeled_01_cannon_F"] }; //Маршалл
				case 8 : {  _Lifes = _Lifes + ["I_APC_tracked_03_cannon_F"] }; //Мора
				case 9 : { _Lifes = _Lifes + ["I_APC_Wheeled_03_cannon_F"] }; //Gorgone
				case 10 : { _Lifes = _Lifes + ["O_APC_Tracked_02_cannon_F"] }; //Камыш
				case 11 : { _Lifes = _Lifes + ["I_LT_01_AA_F"] }; //Нюкс ПВ
				case 12 : { _Lifes = _Lifes + ["O_APC_Tracked_02_AA_F"] }; //Tigris
				case 13 : {  _Lifes = _Lifes + ["B_APC_Tracked_01_AA_F"] }; //Cheetah
			};

		};


	};


	[_Lifes, _idc] remoteExec ["FREDDT_FNC_HEAVYVEHARRAY", _player, false];
	diag_log "Я наземный транспорт и я... вроде... работаю";
	diag_log _Lifes;
};


	PENA_DB_LOAD_HELI = {


		_player = (_this select 0);
		_UID = (_this select 1);
		_idc = (_this # 2);

		_Lifes = [];
		//Земля
		_dbLifes = parseSimpleArray ("extDB3" callExtension format ["0:PenaUpal:SELECT B_Heli_Transport_01_camo_F, O_Heli_Light_02_F, I_Heli_light_03_F, O_Heli_Attack_02_F, B_Heli_Attack_01_F FROM PlayerGarage WHERE UID='%1'",_uid]); 
		_dbLifes = _dbLifes # 1 # 0; 
		for "_i" from 0 to count _dbLifes do {
			if (_dbLifes # _i != 0) then {
				switch (_i) do {
					case 0 : {  _Lifes = _Lifes + ["B_Heli_Transport_01_camo_F"] }; //Госта 
					case 1 : {  _Lifes = _Lifes + ["O_Heli_Light_02_F"] }; //Orca
					case 2 : {  _Lifes = _Lifes + ["I_Heli_light_03_F"] }; //Хелка
					case 3 : {  _Lifes = _Lifes + ["O_Heli_Attack_02_F"] }; //Kajman
					case 4 : {  _Lifes = _Lifes + ["B_Heli_Attack_01_F"] }; //Bf
				};

			};


		};


		[_Lifes, _idc] remoteExec ["FREDDY_FNC_HELIARRAY", _player, false];
		diag_log "Я наземный воздушный и я... вроде... работаю";
		diag_log _Lifes;
	};



	PENA_DB_PAYLIFE_FNC = {

	_player = (_this select 0);
	_UID = (_this select 1);
	_veh = (_this select 2);

	if ((HeavyVehArr find _veh) == -1) exitWith {};
	diag_log [systemTime];
	diag_log "UID:";
	diag_log [_UID];
	diag_log [name _player];
	diag_log [_veh];

	_lifes = parseSimpleArray ("extDB3" callExtension format ["0:PenaUpal:SELECT %1 FROM PlayerGarage WHERE UID='%2'",_veh, _UID]);
	_lifes = _lifes # 1 # 0 # 0;
	_lifes = _lifes - 1;

	"extDB3" callExtension format["0:PenaUpal:UPDATE PlayerGarage SET %1=""%2"" WHERE UID=""%3""", _veh, _lifes, _UID];
};

Freddy_fnc_delvehServer = {
_entitiesArray = (_this select 0);
_vehName = (_this select 1);
_UID = (_this select 2);
_zaloopa1 = (_this select 3);
_player = (_this select 4);
_text = parsetext format ["Вы поставили <t size='1' color='#80ff80'>%1</t> в гараж", _vehName];
if (_player getVariable ["CouldntStore", false] == true) then {
	_player setVariable ["CouldntStore", nil, true];
  switch (true) do {
  case (_zaloopa1 isKindOf "I_MRAP_03_hmg_F") : {deleteVehicle _entitiesArray; [[_text], "hint",_player,false,true] call BIS_fnc_MP;[_zaloopa1, _UID]remoteExec["PENA_DB_BUY_ARMORED_VEH", 2 , false];};//Страйдер 12.7
  case (_zaloopa1 isKindOf "I_MRAP_03_gmg_F") : {deleteVehicle _entitiesArray; [[_text], "hint",_player,false,true] call BIS_fnc_MP;[_zaloopa1, _UID]remoteExec["PENA_DB_BUY_ARMORED_VEH", 2 , false];};//Страйдер ГП
  case (_zaloopa1 isKindOf "B_AFV_Wheeled_01_up_cannon_F") : {deleteVehicle _entitiesArray; [[_text], "hint",_player,false,true] call BIS_fnc_MP;[_zaloopa1, _UID]remoteExec["PENA_DB_BUY_ARMORED_VEH", 2 , false];};//Рино
  case (_zaloopa1 isKindOf "I_MBT_03_cannon_F") : {deleteVehicle _entitiesArray; [[_text], "hint",_player,false,true] call BIS_fnc_MP;[_zaloopa1, _UID]remoteExec["PENA_DB_BUY_ARMORED_VEH", 2 , false];};//Кума
  case (_zaloopa1 isKindOf "O_MBT_04_command_F") : {deleteVehicle _entitiesArray;[[_text], "hint",_player,false,true] call BIS_fnc_MP;[_zaloopa1, _UID]remoteExec["PENA_DB_BUY_ARMORED_VEH", 2 , false];};//Ангара
  case (_zaloopa1 isKindOf "O_MBT_02_cannon_F") : {deleteVehicle _entitiesArray; [[_text], "hint",_player,false,true] call BIS_fnc_MP;[_zaloopa1, _UID]remoteExec["PENA_DB_BUY_ARMORED_VEH", 2 , false];};//Варсук
  case (_zaloopa1 isKindOf "B_MBT_01_TUSK_F") : {deleteVehicle _entitiesArray; [[_text], "hint",_player,false,true] call BIS_fnc_MP;[_zaloopa1, _UID]remoteExec["PENA_DB_BUY_ARMORED_VEH", 2 , false];};//Сламмер
  case (_zaloopa1 isKindOf "B_APC_Wheeled_01_cannon_F") : {deleteVehicle _entitiesArray; [[_text], "hint",_player,false,true] call BIS_fnc_MP;[_zaloopa1, _UID]remoteExec["PENA_DB_BUY_ARMORED_VEH", 2 , false];};//Маршалл
  case (_zaloopa1 isKindOf "I_APC_tracked_03_cannon_F") : {deleteVehicle _entitiesArray; [[_text], "hint",_player,false,true] call BIS_fnc_MP;[_zaloopa1, _UID]remoteExec["PENA_DB_BUY_ARMORED_VEH", 2 , false];};//Мора
  case (_zaloopa1 isKindOf "I_APC_Wheeled_03_cannon_F") : {deleteVehicle _entitiesArray; [[_text], "hint",_player,false,true] call BIS_fnc_MP;[_zaloopa1, _UID]remoteExec["PENA_DB_BUY_ARMORED_VEH", 2 , false];};//Горгона
  case (_zaloopa1 isKindOf "O_APC_Tracked_02_cannon_F") : {deleteVehicle _entitiesArray; [[_text], "hint",_player,false,true] call BIS_fnc_MP;[_zaloopa1, _UID]remoteExec["PENA_DB_BUY_ARMORED_VEH", 2 , false];};//Камыш
  case (_zaloopa1 isKindOf "I_LT_01_AA_F") : {deleteVehicle _entitiesArray; [[_text], "hint",_player,false,true] call BIS_fnc_MP;[_zaloopa1, _UID]remoteExec["PENA_DB_BUY_ARMORED_VEH", 2 , false];};//Нюкс ПВ
  case (_zaloopa1 isKindOf "O_APC_Tracked_02_AA_F") : {deleteVehicle _entitiesArray; [[_text], "hint",_player,false,true] call BIS_fnc_MP;[_zaloopa1, _UID]remoteExec["PENA_DB_BUY_ARMORED_VEH", 2 , false];};//Тигрис
  case (_zaloopa1 isKindOf "B_APC_Tracked_01_AA_F") : {deleteVehicle _entitiesArray; [[_text], "hint",_player,false,true] call BIS_fnc_MP;[_zaloopa1, _UID]remoteExec["PENA_DB_BUY_ARMORED_VEH", 2 , false];};//Читаха
  case (_zaloopa1 isKindOf "B_Heli_Transport_01_camo_F") : {deleteVehicle _entitiesArray; [[_text], "hint",_player,false,true] call BIS_fnc_MP;[_zaloopa1, _UID]remoteExec["PENA_DB_BUY_ARMORED_VEH", 2 , false];};//Госта
  case (_zaloopa1 isKindOf "O_Heli_Light_02_F") : {deleteVehicle _entitiesArray; [[_text], "hint",_player,false,true] call BIS_fnc_MP;[_zaloopa1, _UID]remoteExec["PENA_DB_BUY_ARMORED_VEH", 2 , false];};//Орка
  case (_zaloopa1 isKindOf "I_Heli_light_03_F") : {deleteVehicle _entitiesArray; [[_text], "hint",_player,false,true] call BIS_fnc_MP;[_zaloopa1, _UID]remoteExec["PENA_DB_BUY_ARMORED_VEH", 2 , false];};//Хелка
  case (_zaloopa1 isKindOf "O_Heli_Attack_02_F") : {deleteVehicle _entitiesArray; [[_text], "hint",_player,false,true] call BIS_fnc_MP;[_zaloopa1, _UID]remoteExec["PENA_DB_BUY_ARMORED_VEH", 2 , false];};//Кайман
  case (_zaloopa1 isKindOf "B_Heli_Attack_01_F") : {deleteVehicle _entitiesArray; [[_text], "hint",_player,false,true] call BIS_fnc_MP;[_zaloopa1, _UID]remoteExec["PENA_DB_BUY_ARMORED_VEH", 2 , false];};//Бфка
  default {"Рядом нет техники, которую можно поставить" remoteExec ["hint", _player , false];};
      };	
	};
};

PENA_VEH_REWARD = {
        _unit = (_this # 0);
        _killer = (_this # 1);
       switch (true) do {
      			 case (_unit isKindOf "I_MRAP_03_hmg_F") : {_reward = 1150; {[_reward]remoteExec ["FREDDY_FNC_GETRANDOM_MNY_VEH", _x , false]} forEach crew vehicle _killer}; //Страйдер 12.7
      			 case (_unit isKindOf "I_MRAP_03_gmg_F") : {_reward = 1650; {[_reward]remoteExec ["FREDDY_FNC_GETRANDOM_MNY_VEH", _x , false]} forEach crew vehicle _killer}; //Страйдер ГП
                  case (_unit isKindOf "B_AFV_Wheeled_01_up_cannon_F") : {_reward = 3150; {[_reward]remoteExec ["FREDDY_FNC_GETRANDOM_MNY_VEH", _x , false]} forEach crew vehicle _killer}; //Рино
                  case (_unit isKindOf "I_MBT_03_cannon_F") : {_reward = 2725; {[_reward]remoteExec ["FREDDY_FNC_GETRANDOM_MNY_VEH", _x , false]} forEach crew vehicle _killer}; //Кума
                  case (_unit isKindOf "O_MBT_04_command_F") : {_reward = 3950; {[_reward]remoteExec ["FREDDY_FNC_GETRANDOM_MNY_VEH", _x , false]} forEach crew vehicle _killer}; //Ангара
                  case (_unit isKindOf "O_MBT_02_cannon_F") : {_reward = 3425; {[_reward]remoteExec ["FREDDY_FNC_GETRANDOM_MNY_VEH", _x , false]} forEach crew vehicle _killer}; //Варсук
                  case (_unit isKindOf "B_MBT_01_cannon_F") : {_reward = 2450; {[_reward]remoteExec ["FREDDY_FNC_GETRANDOM_MNY_VEH", _x , false]} forEach crew vehicle _killer}; //Сламмер
                  case (_unit isKindOf "B_APC_Wheeled_01_cannon_F") : {_reward = 1780; {[_reward]remoteExec ["FREDDY_FNC_GETRANDOM_MNY_VEH", _x , false]} forEach crew vehicle _killer}; //Маршалл
                  case (_unit isKindOf "I_APC_tracked_03_cannon_F") : {_reward = 1975; {[_reward]remoteExec ["FREDDY_FNC_GETRANDOM_MNY_VEH", _x , false]} forEach crew vehicle _killer}; //Мора
                  case (_unit isKindOf "I_APC_Wheeled_03_cannon_F") : {_reward = 4670; {[_reward]remoteExec ["FREDDY_FNC_GETRANDOM_MNY_VEH", _x , false]} forEach crew vehicle _killer}; //Горгона
                  case (_unit isKindOf "O_APC_Tracked_02_cannon_F") : {_reward = 5570; {[_reward]remoteExec ["FREDDY_FNC_GETRANDOM_MNY_VEH", _x , false]} forEach crew vehicle _killer}; //Камыш
                  case (_unit isKindOf "I_LT_01_AA_F") : {_reward = 3500; {[_reward]remoteExec ["FREDDY_FNC_GETRANDOM_MNY_VEH", _x , false]} forEach crew vehicle _killer}; //Нюкс ПВ
                  case (_unit isKindOf "O_APC_Tracked_02_AA_F") : {_reward = 3750; {[_reward]remoteExec ["FREDDY_FNC_GETRANDOM_MNY_VEH", _x , false]} forEach crew vehicle _killer}; //Тигрис
                  case (_unit isKindOf "B_APC_Tracked_01_AA_F") : {_reward = 4200; {[_reward]remoteExec ["FREDDY_FNC_GETRANDOM_MNY_VEH", _x , false]} forEach crew vehicle _killer}; //Читаха
                  case (_unit isKindOf "B_Heli_Transport_01_camo_F") : {_reward = 2500; {[_reward]remoteExec ["FREDDY_FNC_GETRANDOM_MNY_VEH", _x , false]} forEach crew vehicle _killer}; //Госта
                  case (_unit isKindOf "O_Heli_Light_02_F") : {_reward = 11000; {[_reward]remoteExec ["FREDDY_FNC_GETRANDOM_MNY_VEH", _x , false]} forEach crew vehicle _killer}; //Орка
                  case (_unit isKindOf "I_Heli_light_03_F") : {_reward = 5785; {[_reward]remoteExec ["FREDDY_FNC_GETRANDOM_MNY_VEH", _x , false]} forEach crew vehicle _killer};//Хелка
                  case (_unit isKindOf "O_Heli_Attack_02_F") : {_reward = 20000; {[_reward]remoteExec ["FREDDY_FNC_GETRANDOM_MNY_VEH", _x , false]} forEach crew vehicle _killer}; //Кайман
                  case (_unit isKindOf "B_Heli_Attack_01_F") : {_reward = 23000; {[_reward]remoteExec ["FREDDY_FNC_GETRANDOM_MNY_VEH", _x , false]} forEach crew vehicle _killer}; //Бфка
                  default {};
        };
    };

addMissionEventHandler ["EntityKilled", { 
 params ["_unit", "_killer", "_instigator", "_useEffects"];

    switch (true) do { 
	case (({_x getVariable "Defender"} forEach crew _unit && _instigator getVariable "Defender")) : {diag_log "сработал 1";};
	case (({_x getVariable "Attacker"} forEach crew _unit && _instigator getVariable "Attacker")) : {diag_log "сработал 2";};
	case (({_x getVariable "Attacker"} forEach crew _unit && _instigator getVariable "Defender")) : {[_unit, _killer] call PENA_VEH_REWARD; diag_log "сработал 3";};
	case (({_x getVariable "Defender"} forEach crew _unit && _instigator getVariable "Attacker")) : {[_unit, _killer] call PENA_VEH_REWARD; diag_log "сработал 4";}; 
	//case (_killer getVariable ["Defender", false] == true && {_x getVariable ["Attacker", false] == true} forEach crew _unit) : {[_unit, _killer] call PENA_VEH_REWARD;};
	//case ({_x getVariable ["Defender", false] == true} forEach crew _unit && _killer getVariable ["Attacker", false] == true) : {[_unit, _killer] call PENA_VEH_REWARD;};
	case ({side group _x} forEach crew _unit != side group _killer) : {[_unit, _killer] call PENA_VEH_REWARD; diag_log "сработал 5";};
	case ((count (crew _unit)) == 0) : {[_unit, _killer] call PENA_VEH_REWARD; diag_log "сработал 6";};  
	default {diag_log "сработал дефолт";}; 
	};
}];




//Удаление трупов при выходе с сервера
addMissionEventHandler ["HandleDisconnect", {
	params ["_unit", "_id", "_uid", "_name"];
	deleteVehicle _unit;
	switch (true) do { 
		case (raidLobbyDef find _uid != -1) : { raidLobbyDef deleteAt (raidLobbyDef find _uid); call PENA_RAID_LOAD;}; 
		case (raidLobbyAt find _uid != -1) : {  raidLobbyAt deleteAt (raidLobbyAt find _uid); call PENA_RAID_LOAD;};
		case (raidLobbyQueDef find _uid != -1) : {  raidLobbyQueDef deleteAt (raidLobbyQueDef find _uid); call PENA_RAID_LOAD;};
		case (raidLobbyQueAt find _uid != -1) : {  raidLobbyQueAt deleteAt (raidLobbyQueAt find _uid); call PENA_RAID_LOAD; };
		default {}; 
	};
	[]remoteExec["PENA_SOMEONE_LEAVES", -2, false];
}];

call compile preprocessFileLineNumbers "scripts\BattleZone.sqf";


//RAID
//Старт рейда
[] spawn {
while {true} do {
	diag_log "ожидание начала рейда";
waitUntil {count raidLobbyDef >= 6 && count raidLobbyAt >= 8 && missionNamespace getVariable ["Raid", false] == false && missionNamespace getVariable ["RaidWarmup",false] == false};
diag_log "начался обратный отчет до начала рейда";
sleep 30;
if (count raidLobbyDef >= 6 && count raidLobbyAt >= 8) then {
call FREDDY_FNC_CREATERAID;
diag_log "ожидание конца рейда";
sleep 5;
waitUntil {missionNamespace getVariable ["Raid", false] == false && missionNamespace getVariable ["RaidWarmup",false] == false};
		};
	};
};

PENA_ARRAY_RAID_HANDLER = {
	raidLobbyDef = (_this # 0);	
	raidLobbyAt = (_this # 1);
	raidLobbyQueDef = (_this # 2);
	raidLobbyQueAt = (_this # 3);
	call PENA_RAID_LOAD;
};

PENA_RAID_LOAD = {
	[raidLobbyDef, raidLobbyAt, raidLobbyQueDef, raidLobbyQueAt]remoteExecCall["PENA_Raid_Handler", -2 , false];
	[]remoteExec["PENA_Raid_OnLoad", -2 , false];
};

PENA_RAID_SETTINGS = {
	//Жизни на команду легковые машины
	_RaidLightLifesDef = 10;
	_RaidLightLifesAt = 10;

	_RaidLight = [];
	_RaidLight pushBack _RaidLightLifesDef;
	_RaidLight pushBack _RaidLightLifesAt;
	//Жизни на команду хомяки
	_RaidHummingBirdDef = 3;
	_RaidHummingBirdAt = 3;

	_RaidHummingBird = [];
	_RaidHummingBird pushBack _RaidHummingBirdDef;
	_RaidHummingBird pushBack _RaidHummingBirdAt;
	//Жизни на команду грузовая техника
	_RaidHeavyDef = 5;
	_RaidHeavyAt = 5;

	_RaidHeavy = [];
	_RaidHeavy pushBack _RaidHeavyDef;
	_RaidHeavy pushBack _RaidHeavyAt;
	//Жизни на команду специальная техника
	_RaidSpecialTechniqueDef = 2;
	_RaidSpecialTechniqueAt = 2;

	_RaidSpecial = [];
	_RaidSpecial pushBack _RaidSpecialTechniqueDef;
	_RaidSpecial pushBack _RaidSpecialTechniqueAt;

	//Итоговые жизни на игру
	_totalLifes = [];
	_totalLifes pushBack _RaidLight;
	_totalLifes pushBack _RaidHummingBird;
	_totalLifes pushBack _RaidHeavy;
	_totalLifes pushBack _RaidSpecial;
	_totalLifes;
};

lightVehArr = ["O_MRAP_02_F","ver_vaz_2114_uck", "BPAN_priora", "ver_vaz_2114_OPER", "ivory_evox", "ivory_wrx", "ivory_supra", "ivory_r34"]; // AddVehToRaid - сюда легковая техника
HeavyVehArr = ["I_MRAP_03_hmg_F", "I_MRAP_03_gmg_F", "B_AFV_Wheeled_01_up_cannon_F", "I_MBT_03_cannon_F", "O_MBT_04_command_F", "O_MBT_02_cannon_F", "B_MBT_01_TUSK_F", "B_APC_Wheeled_01_cannon_F", "I_APC_tracked_03_cannon_F", "I_APC_Wheeled_03_cannon_F", "O_APC_Tracked_02_cannon_F", "I_LT_01_AA_F", "O_APC_Tracked_02_AA_F", "B_APC_Tracked_01_AA_F", "B_Heli_Transport_01_camo_F", "O_Heli_Light_02_F", "I_Heli_light_03_F", "O_Heli_Attack_02_F", "B_Heli_Attack_01_F"]; //AddHeavyVehToRaid - сюда боевая
specVehArr = ["O_Truck_03_ammo_F"]; //AddSpecVehToRaid - сюда специальная
heliVehArr = ["B_Heli_Light_01_F", "B_mas_UH1Y_UNA_F"]; //AddHeliToRaid - сюда вертолеты

PENA_CREATEVEH = {
	_player = (_this # 0);
	_vehicle = (_this # 1);
	diag_log ["Создаем технику на рейде ", _vehicle];

	if (_player getVariable ["Defender", false] == true) then {
		//Defender
		switch (true) do {
			case ((HeavyVehArr find _vehicle) != -1) : { [_vehicle]remoteExec["PENA_CREATING_VEH", _player, false];};
			case ((lightVehArr find _vehicle) != -1) : {  if ((OnGoingRadeData # 0 # 0) >= 1) then { [_vehicle]remoteExec["PENA_CREATING_VEH", _player , false];} else {  };};
			case ((specVehArr find _vehicle) != -1) : {  if ((OnGoingRadeData # 3 # 0) >= 1) then { [_vehicle]remoteExec["PENA_CREATING_VEH", _player , false];} else {  };};
			case ((heliVehArr find _vehicle) != -1) : {  if ((OnGoingRadeData # 1 # 0) >= 1) then { [_vehicle]remoteExec["PENA_CREATING_VEH", _player , false];} else {  };};
			default {   }; 
		};
	} else {
		//Attacker
		switch (true) do {
			case ((HeavyVehArr find _vehicle) != -1) : { [_vehicle]remoteExec["PENA_CREATING_VEH", _player, false];};
			case ((lightVehArr find _vehicle) != -1) : {  if ((OnGoingRadeData # 0 # 1) >= 1) then { [_vehicle]remoteExec["PENA_CREATING_VEH", _player , false];} else {  };};
			case ((specVehArr find _vehicle) != -1) : {  if ((OnGoingRadeData # 3 # 1) >= 1) then { [_vehicle]remoteExec["PENA_CREATING_VEH", _player , false];} else {  };};
			case ((heliVehArr find _vehicle) != -1) : {  if ((OnGoingRadeData # 1 # 1) >= 1) then { [_vehicle]remoteExec["PENA_CREATING_VEH", _player , false];} else {  };};
			default {   }; 
		};
	};
};

PENA_DECREASE_RAID_LIFE = {
	_player = (_this # 0);
	_vehicle = (_this # 1);
	_decreaseNum = (_this # 2);

	if (_player getVariable ["Defender", false] == true) then {
		//Defender
		switch (true) do { 
				case ((lightVehArr find _vehicle) != -1) : {  if ((OnGoingRadeData # 0 # 0) >= 1) then {_buffer = OnGoingRadeData # 0; _buffer set [0, (_buffer # 0) - _decreaseNum]; OnGoingRadeData set [0, _buffer]; [OnGoingRadeData] call PENA_RAID_LIFES_LOAD;} else {  };}; 
				case ((specVehArr find _vehicle) != -1) : {  if ((OnGoingRadeData # 3 # 0) >= 1) then {_buffer = OnGoingRadeData # 3; _buffer set [0, (_buffer # 0) - _decreaseNum]; OnGoingRadeData set [3, _buffer]; [OnGoingRadeData] call PENA_RAID_LIFES_LOAD;} else {  };}; 
				case ((heliVehArr find _vehicle) != -1) : {  if ((OnGoingRadeData # 1 # 0) >= 1) then {_buffer = OnGoingRadeData # 1; _buffer set [0, (_buffer # 0) - _decreaseNum]; OnGoingRadeData set [1, _buffer]; [OnGoingRadeData] call PENA_RAID_LIFES_LOAD;} else {  };}; 
			default {   }; 
		};
	} else {
		//Attacker
		switch (true) do { 
			case ((lightVehArr find _vehicle) != -1) : {  if ((OnGoingRadeData # 0 # 1) >= 1) then { _buffer = OnGoingRadeData # 0; _buffer set [1, (_buffer # 1) - _decreaseNum]; OnGoingRadeData set [0, _buffer]; [OnGoingRadeData] call PENA_RAID_LIFES_LOAD;} else {  };}; 
			case ((specVehArr find _vehicle) != -1) : {  if ((OnGoingRadeData # 3 # 1) >= 1) then {_buffer = OnGoingRadeData # 3; _buffer set [1, (_buffer # 1) - _decreaseNum]; OnGoingRadeData set [3, _buffer]; [OnGoingRadeData] call PENA_RAID_LIFES_LOAD;} else {  };}; 
			case ((heliVehArr find _vehicle) != -1) : {  if ((OnGoingRadeData # 1 # 1) >= 1) then {_buffer = OnGoingRadeData # 1; _buffer set [1, (_buffer # 1) - _decreaseNum]; OnGoingRadeData set [1, _buffer]; [OnGoingRadeData] call PENA_RAID_LIFES_LOAD;} else {  };}; 
			default {   }; 
		};
	};
};


PENA_RAID_LIFES = {
	OnGoingRadeData = call PENA_RAID_SETTINGS;
	diag_log "Создаем жизни в рейде по заданным настройкам";
	[OnGoingRadeData] call PENA_RAID_LIFES_LOAD;
};

PENA_RAID_LIFES_LOAD = {
	diag_log (_this # 0);
	[_this # 0]remoteExec["PENA_CALLBACK_RAIDLIFES_FNC", -2, false];
};

//Сейв зоны
vehiclesInSafeZone = [];

[] spawn {
while {true} do {
 
BluforSafe = vehicles inAreaArray "BluforS";
OpforSafe = vehicles inAreaArray "OpforS";
IndepSafe = vehicles inAreaArray "IndepS";
vehiclesInSafeZone = BluforSafe + OpforSafe + IndepSafe;
vehiclesNotInSafeZone = vehicles - vehiclesInSafeZone;
allVehWithVariable = vehiclesInSafeZone select {_x getVariable "FiredInSafeZone"};
allVehWithoutVariable = vehiclesInSafeZone select {_x getVariable ["FiredInSafeZone", false]==false;};
[BluforSafe, OpforSafe, IndepSafe, vehiclesInSafeZone, vehiclesNotInSafeZone, allVehWithVariable, allVehWithoutVariable] remoteExec ["Freddy_fnc_DamageInSafeZones", -2, true];
sleep 1;
	};
};

call compile preprocessFileLineNumbers "scripts\CleanUp.sqf";
