/* ----------------------------------------------------------------------------
Description:
    Geariscirpti functiot

Author:
    Tuntematon

Muokattu
	7.1.2023
---------------------------------------------------------------------------- */
#define MAP(ARR,CODE) ARR = ARR apply {CODE}

if (_unit isKindof "Man") then {
	//_unit setVariable ["role",_type, true];//?
	_unit setVariable ["Tun_Respawn_Role",_type, true]; // Tun respawn gear variable
	_unit setVariable ["Tun_Respawn_GearPath",_gearscript_path, true]; // Tun respawn gearscript path
	removeAllWeapons _unit;
	_unit removeweapon "ItemGPS";

	_unit linkItem "itemMap";
	_unit linkItem "itemCompass";
	_unit linkItem "itemWatch";

	if (_Radioit) then {_unit linkItem "TFAR_microdagr"; _unit linkItem "itemradio" } else {_unit removeweapon "itemradio"};
	if (_Nightvision) then {_unit addweapon _item_NV} else {_unit addweapon "ACE_NVG_Gen4"; _unit removeweapon "ACE_NVG_Gen4"};

	if (isMultiplayer) then {

		if ((roleDescription _unit) find "@" isNotEqualTo  -1) then {
			private _description = (roleDescription _unit) select [0,((roleDescription _unit) find "@")];
		} else {
			private _description = roleDescription _unit;
		};

		if (!isNil "_description") then {
			_unit setVariable ["displayName", _description, true];
		};

	};
} else {
	if (_unit isKindof "LandVehicle" || _unit isKindof "Air" || _unit isKindOf "Ship" || _unit isKindOf "Static" || _unit isKindOf "thing") then {
		clearWeaponCargoglobal _unit;
		clearItemCargoGlobal _unit;
		clearMagazineCargoglobal _unit;
		clearBackpackCargoglobal _unit;
		_unit disableTIEquipment !(_Thermalit);
		_unit setVariable ["tf_side", _OrbatinSide, true];
		_unit setVariable ["Tun_startmarkers_vehicleSide", [east, west, resistance, civilian] select (["east", "west" , "guer", "civ"] find _OrbatinSide), true];	
		_unit setVariable ["AFI_vehicle_gear", _OrbatinSide, true];
		_unit setVehicleLock "UNLOCKED";
	};
};

_TUN_fnc_addWeaponStuff = {
	//Adds list of magazines and items
	//Params [_unit,[[MagazineClassname,count],[MagazineClassname,count],...]] call _TUN_fnc_addmagazines;

	params ["_unit","_weapons", "_magazines", "_weaponitems"];

	if (count _weapons > 0) then {
		{
			_unit addweapon _x;
		} foreach _weapons;
	};

	if (count _magazines > 0) then {
		private _secondaryAmmo = [];
		private _handgunAmmo = [];
		private _primaryWeapon = primaryWeapon _unit;
		private _secondaryWeapon = secondaryWeapon _unit;
		private _handgunWeapon = handgunWeapon _unit;
		private _primaryMuzzleMagazines = [];

		if (_primaryWeapon isNotEqualTo "") then {
			private _muzzles = getArray (configFile >> "CfgWeapons" >> _primaryWeapon >> "muzzles");
			private _primaryMagazines = (compatibleMagazines [_primaryWeapon, _muzzles select 0]);
			MAP(_primaryMagazines,toLower _x);
			_primaryMuzzleMagazines pushBack _primaryMagazines;
			{
				private _muzzle = _x;
				if ("UGL_F" in ([(configFile >> "CfgWeapons" >> _primaryWeapon >> _muzzle),true] call BIS_fnc_returnParents)) exitWith {
					private _muzzleMagazines = compatibleMagazines [_primaryWeapon, _muzzle];
					if (count _muzzleMagazines isNotEqualTo 0) then {
						MAP(_muzzleMagazines,toLower _x);
						_primaryMuzzleMagazines pushBack _muzzleMagazines;
					};
				};
			} forEach _muzzles;
		};

		if (_secondaryWeapon isNotEqualTo "") then {
			_secondaryAmmo = compatibleMagazines _secondaryWeapon;
			MAP(_secondaryAmmo,toLower _x);
		};

		if (_handgunWeapon isNotEqualTo "") then {
			_handgunAmmo = compatibleMagazines _handgunWeapon;
			MAP(_handgunAmmo,toLower _x);
		};

		{
			private _items = _x;	
			private _item = toLower (_items select 0);
			private _count = _items select 1;
			private _oikeamaara = 0;
			private _uusimaara = 0;
	
			if (isClass (configFile >> "CFGMagazines" >> _item)) then {
				if ( _primaryWeapon canAdd _item) then { //Jos on primary weapon
					private _currentMagazines = primaryWeaponMagazine _unit;
					{
						private _magazines = _x;
						if (_item in _magazines && {_currentMagazines findIf { toLower _x in _magazines} isEqualTo -1}) then {
							_unit addWeaponItem [_primaryWeapon, _item, true];
							_count = _count - 1;
						};
					} forEach _primaryMuzzleMagazines;

				} else {

					if (_secondaryWeapon canAdd _item && {secondaryWeaponMagazine _unit isEqualTo []}) then  { //jos on secondary
						_unit addWeaponItem [_secondaryWeapon, _item, true];
						_count = _count - 1;
					} else {
						if ( _handgunWeapon canAdd _item && {handgunMagazine _unit isEqualTo []}) then { //jos on handgun
							_unit addWeaponItem [_handgunWeapon, _item, true];
							_count = _count - 1;
						};
					};
				};

				if (isServer)then {
					_oikeamaara = ({_x == _item} count (magazines _unit + primaryWeaponMagazine _unit + handgunMagazine _unit + secondaryWeaponMagazine _unit + handgunMagazine _unit)) + _count;
				};
				_unit addMagazines [_item,_count];
				if (isServer)then {
					_uusimaara = {_x == _item} count (magazines _unit + primaryWeaponMagazine _unit  + handgunMagazine _unit + secondaryWeaponMagazine _unit + handgunMagazine _unit);

					if (_uusimaara isNotEqualTo _oikeamaara) then {
						player createDiaryRecord ["Diary",["!!Geari scripti ERROR!!",format ["lippaat %1 ei mahtunut %2 inventoryyn jonka tyyppi on %3. Pitäisi olla %4 mutta mahtui vain %5",str _item, str _unit, str _type, _oikeamaara, _uusimaara]]];
					};
				};
			} else {
				[_unit, _items] call _TUN_fnc_addItems;
			};
		} foreach _magazines;
	};

	if (count _weaponitems > 0) then {
		{
			private _item = _x select 0;
			private _slot = toLower (_x select 1);
			switch _slot do {
				case "primary": {
					if !(primaryWeapon _unit isEqualTo "") then {
						_unit addPrimaryWeaponItem _item;
					};
				};

				case "secondary": {
					if !(secondaryWeapon _unit isEqualTo "") then {
						_unit addSecondaryWeaponItem _item;
					};
				};

				default {
					if !(handgunWeapon _unit isEqualTo "") then {
						_unit addHandgunItem _item;
					};
				};
			};
		} forEach _weaponitems;
	};

};

_TUN_fnc_addItems = {
	params ["_unit","_items"];
	{
		private _item = toLower (_x select 0);
		private _count = _x select 1;
		private _oikeamaara = 0;
		private _uusimaara = 0;
		if (isServer) then {
			_oikeamaara = ({_x == _item} count (magazines _unit + items _unit + assignedItems _unit)) + _count;
		};

		for "_i" from 1 to _count do {_unit addItem _item;};

		if (isServer) then {
			_uusimaara = {_x == _item} count (magazines _unit + items _unit + assignedItems _unit);
			if (_uusimaara isNotEqualTo _oikeamaara) then {
				player createDiaryRecord ["Diary",["!!Geari scripti ERROR!!",format ["itemit %1 ei mahtunut %2 inventoryyn jonka tyyppi on %3. Pitäisi olla %4 mutta mahtui vain %5",str _item, str _unit, str _type, _oikeamaara, _uusimaara]]];
			};			
		};
	} forEach _items;
};
