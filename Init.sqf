
	KaikkiAseet = [];
	KaikkienLippaat = [];
	KaikkiLisavarusteet = [];

Tun_fnc_arraytolower = {
	params ["_array"];
	private _newarray = [];
	{
		_newarray pushBack (toLower _x);
	} forEach _array;
	_newarray
};



TUN_fnc_Primary = {
	_Lippaat = [];
	_LippaatLista = [];
	_Lisavarusteet = [];
	_kranaatit = [];
	_EiAsetta = "";
	_EiLippaita = "";
	_EiVarusteita = "";
	_haveGL = false;
	_ase = getText (configFile >> "CfgWeapons" >> (primaryWeapon player) >> "baseWeapon");
	if (_ase == "") then  {_ase = primaryWeapon player};

	{
		if ("UGL_F" in ([(configFile >> "CfgWeapons" >> (primaryWeapon player) >> _x),true] call BIS_fnc_returnParents)) then {
			_kranaatit = getArray (configFile >> "CfgWeapons" >> (primaryWeapon player) >> _x >> "magazines");
			_haveGL = true;
		};
		if (_haveGL) exitWith { _kranaatit = [_kranaatit] call Tun_fnc_arraytolower; };
	} forEach GetArray (configFile >> "CfgWeapons" >> (primaryWeapon player) >> "muzzles");

	_primaryAmmo = [primaryWeapon player] call CBA_fnc_compatibleMagazines;
	_primaryAmmo = [_primaryAmmo] call Tun_fnc_arraytolower;
	_kaikkilippaat = _primaryAmmo + _kranaatit;

	{
		_lipas = toLower _x;
		if (_lipas in _kaikkilippaat && !(_lipas in _LippaatLista)) then {
	 		_LippaatLista append [(toLower _x)];
	  		_Lippaat pushBack [_x,{_x in (magazines player + primaryWeaponMagazine player) && _lipas == _x} count (magazines player + primaryWeaponMagazine player)]
	 	};
	} forEach magazines player + primaryWeaponMagazine player;

	{
		if !(_x == "") then {
			_Lisavarusteet pushBack [_x, "primary"];
		}
	} forEach primaryWeaponItems player;

	if (_ase == "") then { _EiAsetta = "//"} else {KaikkiAseet pushBack _ase;};
	if (count _Lippaat == 0) then { _EiLippaita = "//"} else {KaikkienLippaat append _Lippaat;};
	if (count _Lisavarusteet == 0) then { _EiVarusteita = "//"} else {KaikkiLisavarusteet append _Lisavarusteet;};

	PrimaryAse = formatText  ['%5_weapons append [%1];%4%6_magazines append %2;%4%7_weaponitems append %3;',str _ase, _Lippaat, _Lisavarusteet, toString [13,10], _EiAsetta, _EiLippaita, _EiVarusteita];
	//copyToClipboard format  ['%5_weapons append [%1];%4%6_magazines append %2;%4%7_weaponitems append %3;',str _ase, _Lippaat, _Lisavarusteet, toString [13,10], _EiAsetta, _EiLippaita, _EiVarusteita];
};





TUN_fnc_Secondary = {
	_Lippaat = [];
	_LippaatLista = [];
	_Lisavarusteet = [];
	_EiAsetta = "";
	_EiLippaita = "";
	_EiVarusteita = "";
	_sopivatLippaat = [secondaryWeapon player] call CBA_fnc_compatibleMagazines;
	_sopivatLippaat = [_sopivatLippaat] call Tun_fnc_arraytolower;
	_ase = getText (configFile >> "CfgWeapons" >> (secondaryWeapon player) >> "baseWeapon");
	if (_ase == "") then  {_ase = secondaryWeapon player};


	{
		if (tolower _x in _sopivatLippaat && !(_x in _LippaatLista) && !(_x == "ACE_PreloadedMissileDummy")) then {
	 		_LippaatLista append [_x];
	  		_Lippaat pushBack [_x,{_x in getArray (configFile >> "CFGWeapons" >> _ase >> "magazines")} count (magazines player + secondaryWeaponMagazine player)]
	 	};
	} forEach magazines player + secondaryWeaponMagazine player;

	{
		if !(_x == "") then {
			_Lisavarusteet pushBack [_x, "secondary"];
		}
	} forEach secondaryWeaponItems player;

	if (_ase == "") then { _EiAsetta = "//"};
	if (count _Lippaat == 0) then { _EiLippaita = "//"};
	if (count _Lisavarusteet == 0) then { _EiVarusteita = "//"};

	SecondaryAse = formatText  ['%5_weapons append [%1];%4%6_magazines append %2;%4%7_weaponitems append %3;',str _ase, _Lippaat, _Lisavarusteet, toString [13,10], _EiAsetta, _EiLippaita, _EiVarusteita];
	//copyToClipboard format  ['%5_weapons append [%1];%4%6_magazines append %2;%4%7_weaponitems append %3;',str secondaryWeapon player, _Lippaat, _Lisavarusteet, toString [13,10], _EiAsetta, _EiLippaita, _EiVarusteita];
};

TUN_fnc_Handgun = {
	_Lippaat = [];
	_LippaatLista = [];
	_Lisavarusteet = [];
	_EiAsetta = "";
	_EiLippaita = "";
	_EiVarusteita = "";
	_sopivatLippaat = [handgunWeapon player] call CBA_fnc_compatibleMagazines;
	_sopivatLippaat = [_sopivatLippaat] call Tun_fnc_arraytolower;
	_ase = getText (configFile >> "CfgWeapons" >> (handgunWeapon player) >> "baseWeapon");
	if (_ase == "") then  {_ase = handgunWeapon player};

	{
		if (tolower _x in _sopivatLippaat && !(_x in _LippaatLista)) then {
	 		_LippaatLista append [_x];
	  		_Lippaat pushBack [_x,{_x in getArray (configFile >> "CFGWeapons" >> _ase >> "magazines")} count (magazines player + handgunMagazine player)]
	 	};
	} forEach magazines player + handgunMagazine player;

	{
		if !(_x == "") then {
			_Lisavarusteet pushBack [_x, "handgun"];
		}
	} forEach handgunItems player;

	if (_ase == "") then { _EiAsetta = "//"} else {KaikkiAseet pushBack _ase;};
	if (count _Lippaat == 0) then { _EiLippaita = "//"} else {KaikkienLippaat append _Lippaat;};
	if (count _Lisavarusteet == 0) then { _EiVarusteita = "//"} else {KaikkiLisavarusteet append _Lisavarusteet;};

	HandgunAse = formatText  ['%5_weapons append [%1];%4%6_magazines append %2;%4%7_weaponitems append %3;',str _ase, _Lippaat, _Lisavarusteet, toString [13,10], _EiAsetta, _EiLippaita, _EiVarusteita];
	//copyToClipboard format  ['%5_weapons append [%1];%4%6_magazines append %2;%4%7_weaponitems append %3;',str handgunWeapon player, _Lippaat, _Lisavarusteet, toString [13,10], _EiAsetta, _EiLippaita, _EiVarusteita];
};



TUN_fnc_Kaikki = {
	KaikkiAseet = [];
	KaikkienLippaat = [];
	KaikkiLisavarusteet = [];

	PrimaryAse = nil;
	SecondaryAse = nil;
	HandgunAse = nil;


	[] call TUN_fnc_Primary;
	[] call TUN_fnc_Secondary;
	[] call TUN_fnc_Handgun;

	waitUntil {!isNil "PrimaryAse" && !isNil "SecondaryAse" && !isNil "HandgunAse"};
	_EiAsetta = "";
	_EiLippaita = "";
	_EiVarusteita = "";
	_KaikkiLippaatLista = ["HandGrenade","B_IR_Grenade","SmokeShell","SmokeShellGreen","Chemlight_green","MiniGrenade"];
	_KaikkiLippaat = [];

	if (handgunWeapon player == "" && primaryWeapon player == "") then { _EiAsetta = "//"};
	if (count KaikkienLippaat == 0) then { _EiLippaita = "//"};
	if (count KaikkiLisavarusteet == 0) then { _EiVarusteita = "//"};

	{
		if !(_x in _KaikkiLippaatLista) then {
			_mag = _x;
	 		_KaikkiLippaatLista append [_mag];
	  		_KaikkiLippaat pushBack [_mag,{_x == _mag} count (magazines player + handgunMagazine player + secondaryWeaponMagazine player + primaryWeaponMagazine player)]
	 	};
	} forEach magazines player + handgunMagazine player + secondaryWeaponMagazine player + primaryWeaponMagazine player;

	PistoolijaAse = formatText  ['%5_weapons append %1;%4%6_magazines append %2;%4%7_weaponitems append %3;',KaikkiAseet, KaikkienLippaat, KaikkiLisavarusteet, toString [13,10], _EiAsetta, _EiLippaita, _EiVarusteita];





	_reppu = backpack player;
	if ((count ("true" configClasses(configFile >> "CfgVehicles" >> _reppu >> "TransportMagazines")) > 0) || (count ("true" configClasses(configFile >> "CfgVehicles" >> _reppu >> "TransportItems")) > 0)) then
	{
		_reppu = [(configFile >> "CfgVehicles" >> _reppu), true] call BIS_fnc_returnParents select 1
	};

Kaikki = formatText ["/*PrimaryWeapon*/
%1


/*secondaryWeapon*/
%2


/*handgunWeapon*/
%3


/*Pistooli&Ase*/
%10


/*Kaikki lippaat*/
%11


/*Kypara & lasit*/
_unit addHeadgear %5;
_unit addGoggles %6;


/*Liivi*/
_unit addVest %7;


/*Puku*/
_unit forceAddUniform %8;


/*Reppu*/
_unit addBackpack %9;
",
PrimaryAse, SecondaryAse, HandgunAse, toString [13,10],str headgear player, str goggles player, str vest player, str uniform player, str backpack player, PistoolijaAse, _KaikkiLippaat];



copyToClipboard format ["/*PrimaryWeapon*/
%1


/*secondaryWeapon*/
%2


/*handgunWeapon*/
%3


/*Pistooli&Ase*/
%10


/*Kaikki lippaat*/
%11


/*kiikarit*/
%12


/*Kypara & lasit*/
_unit addHeadgear %5;
_unit addGoggles %6;


/*Liivi*/
_unit addVest %7;


/*Puku*/
_unit forceAddUniform %8;


/*Reppu*/
_unit addBackpack %9;
",
PrimaryAse, SecondaryAse, HandgunAse, toString [13,10],str headgear player, str goggles player, str vest player, str uniform player, str _reppu, PistoolijaAse, _KaikkiLippaat, binocular player];
};


player addAction ["Kopioi gearit leikepöydälle", { [] spawn TUN_fnc_Kaikki; }];


puvut = [];
hatut = [];
facegear = [];
vests = [];

sleep 3;
{
	_unit = _x;
	puvut pushBackUnique uniform _unit;
	hatut pushBackUnique headgear _unit;
	facegear pushBackUnique goggles _unit;
	vests pushBackUnique vest _unit;
} forEach allUnits;
