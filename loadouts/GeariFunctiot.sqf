/* ----------------------------------------------------------------------------
Description:
    Geariscirpti functiot

Author:
    Tuntematon

Muokattu
	3.4.2020
---------------------------------------------------------------------------- */
//Muuta numeroa jos muokkaan scriptiä niin ettei vanhat enään toimi.
#define COMPONENT gearscript
#define PREFIX Tun
#include "\x\cba\addons\main\script_macros_common.hpp"

_GeariFunctiot_Versio = 6;


if (_unit isKindof "Man") then {
	_unit setVariable ["role",_type, true];//?
	_unit setVariable ["Tun_Respawn_Role",_type, true]; // Tun respawn gear variable
	_unit setVariable ["Tun_Respawn_GearPath",_gearscript_path, true]; // Tun respawn gearscript path
	removeAllWeapons _unit;
	_unit removeweapon "ItemGPS";

	_unit linkItem "itemMap";
	_unit linkItem "itemCompass";
	_unit linkItem "itemWatch";
	_unit addItem "ACE_MapTools";


	if (_Radioit) then {_unit linkItem "TFAR_microdagr"; _unit linkItem "itemradio" } else {_unit removeweapon "itemradio"};
	if (_Nightvision) then {_unit addweapon _item_NV} else {_unit addweapon "ACE_NVG_Gen4"; _unit removeweapon "ACE_NVG_Gen4"};

	if (isMultiplayer) then {

		if ((roleDescription _unit) find "@" !=  -1) then {
			private _description = (roleDescription _unit) select [0,((roleDescription _unit) find "@")];
		} else {
			private _description = roleDescription _unit;
		};

		if (!isNil "_description") then {
			_unit setVariable ["displayName", _description, true];
		};

	};

};

/*if !(isDedicated) then {
	//_unit disableAI "all";
};*/

if (_unit isKindof "LandVehicle" || _unit isKindof "Air" || _unit isKindOf "Ship" || _unit isKindOf "Static" || _unit isKindOf "thing") then {
	clearWeaponCargoglobal _unit;
	clearItemCargoGlobal _unit;
	clearMagazineCargoglobal _unit;
	clearBackpackCargoglobal _unit;
	_unit disableTIEquipment !(_Thermalit);
	_unit setVariable ["tf_side", _OrbatinSide, true];
	_unit setVariable ["AFI_vehicle_gear", _OrbatinSide, true];
	_unit setVehicleLock "UNLOCKED";
};


_TUN_fnc_addweapons = {

	//Adds weapons from list
	//Params [unit,[ListOfWeapons] call _TUN_fnc_addweapons;

	params ["_unit","_weapons"];
	{
		_unit addweapon _x;
	} foreach _weapons;
};

_TUN_fnc_arraytolower = {
	params ["_array"];
	private _newarray = [];
	{
		_newarray pushBack (toLower _x);
	} forEach _array;
	_newarray
};

_TUN_fnc_addmagazines = {
	//Adds list of magazines and items
	//Params [_unit,[[MagazineClassname,count],[MagazineClassname,count],...]] call _TUN_fnc_addmagazines;

	params ["_unit","_elements"];

	private _haveGL = false;
	private _glAmmo = [];
	private _primaryAmmo = [];
	private _secondaryAmmo = [];
	private _handgunAmmo = [];

	if (primaryWeapon _unit != "") then {
		_primaryAmmo = [primaryWeapon _unit] call CBA_fnc_compatibleMagazines;

		{
			if ("UGL_F" in ([(configFile >> "CfgWeapons" >> (primaryWeapon _unit) >> _x),true] call BIS_fnc_returnParents)) then {
				_glAmmo = getArray (configFile >> "CfgWeapons" >> (primaryWeapon _unit) >> _x >> "magazines");
				_haveGL = true;
			};
			if (_haveGL) exitWith { _glAmmo = [_glAmmo] call _TUN_fnc_arraytolower; };
		} forEach GetArray (configFile >> "CfgWeapons" >> (primaryWeapon _unit) >> "muzzles");

		_primaryAmmo = [_primaryAmmo] call _TUN_fnc_arraytolower;
	};

	if (secondaryWeapon _unit != "") then {
		_secondaryAmmo = [secondaryWeapon _unit] call CBA_fnc_compatibleMagazines;
		_secondaryAmmo = [_secondaryAmmo] call _TUN_fnc_arraytolower;
	};

	if (handgunWeapon _unit != "") then {
		_handgunAmmo = [handgunWeapon _unit] call CBA_fnc_compatibleMagazines;
		_handgunAmmo = [_handgunAmmo] call _TUN_fnc_arraytolower;
	};


	{
		private ["_item", "_count"];
		_item = toLower (_x select 0);
		_count = _x select 1;

		if (isClass (configFile >> "CFGMagazines" >> _item)) then {
			if (_item in (_primaryAmmo + _glAmmo) && _count > 0) then { //Jos on primary weapon
				if (_item in _glAmmo && _haveGL && ({tolower _x in _glAmmo} count (primaryWeaponMagazine _unit) == 0)) then {
					_unit addPrimaryWeaponItem _item;
					_count = _count - 1;
				} else {
					if ({tolower _x in _primaryAmmo} count (primaryWeaponMagazine _unit) == 0) then {
						_unit addPrimaryWeaponItem _item;
						_count = _count - 1;
					};
				};

			} else {

				if (_item in _secondaryAmmo && _count > 0 && count secondaryWeaponMagazine _unit == 0) then  { //jos on secondary
					 _unit addSecondaryWeaponItem _item;
					 _count = _count - 1;
				} else {
					if (_item in _handgunAmmo && _count > 0 && count handgunMagazine _unit == 0) then { //jos on handgun
						_unit addHandgunItem _item;
						_count = _count - 1;
					};
				};
			};

		_oikeamaara = ({_x == _item} count (magazines _unit + handgunMagazine _unit + secondaryWeaponMagazine _unit + handgunMagazine _unit)) + _count;
		_unit addmagazines [_item,_count];
		_uusimaara = {_x == _item} count (magazines _unit + handgunMagazine _unit + secondaryWeaponMagazine _unit + handgunMagazine _unit);
		if (_uusimaara != _oikeamaara) then {
			player createDiaryRecord ["Diary",["!!Geari scripti ERROR!!",format ["lippaat %1 ei mahtunut %2 inventoryyn jonka tyyppi on %3. Pitäisi olla %4 mutta mahtui vain %5",str _item, str _unit, str _type, _oikeamaara, _uusimaara]]];
		};

		} else {

			_oikeamaara = ({_x == _item} count (items _unit + assignedItems _unit)) + _count;
			_unit addItemCargo [_item,_count];
			for "_i" from 1 to _count do {_unit addItem _item;};
			_uusimaara = {_x == _item} count (items _unit + assignedItems _unit);
			if (_uusimaara != _oikeamaara) then {
				player createDiaryRecord ["Diary",["!!Geari scripti ERROR!!",format ["itemit %1 ei mahtunut %2 inventoryyn jonka tyyppi on %3. Pitäisi olla %4 mutta mahtui vain %5",str _item, str _unit, str _type, _oikeamaara, _uusimaara]]];
			};
		};
	} Foreach _elements;
};

_TUN_fnc_addWeaponItem = {  //aseiden tähtäimet jne.

	params ["_unit", "_items"];

	{
		switch toLower (_x select 1) do {
			case toLower "primary": {
				if !(primaryWeapon _unit == "") then {
					_unit addPrimaryWeaponItem (_x select 0);
				};
			};

			case toLower "secondary": {
				if !(secondaryWeapon _unit == "") then {
					_unit addSecondaryWeaponItem (_x select 0);
				};
			};

			default {
				if !(handgunWeapon _unit == "") then {
					_unit addHandgunItem (_x select 0);
				};
			};
		};
	} forEach _items;
};