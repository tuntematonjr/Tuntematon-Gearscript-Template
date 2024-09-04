/* ----------------------------------------------------------------------------
Description:
	Geariscirpti functiot

Author:
	Tuntematon

Edited
	4.9.2024
---------------------------------------------------------------------------- */
#include "\x\cba\addons\main\script_macros_common.hpp"

private _isServer = isServer;

if (_unit isKindOf "Man") then {
	_unit setVariable ["tunres_respawn_Role",_type, true]; // Tun respawn gear variable
	_unit setVariable ["tunres_respawn_GearPath",_gearscriptPath, true]; // Tun respawn gearscript path
	removeAllWeapons _unit;  
	removeAllContainers _unit; 
	removeAllAssignedItems [_unit, true, true];
	_unit linkItem "itemMap";
	_unit linkItem "itemCompass";
	_unit linkItem "itemWatch";

	if (_enableRadios) then {
		_unit linkItem "TFAR_microdagr";
		_unit linkItem "itemradio";
	};

	if (_enableNVGs) then {
		_unit linkItem _NVG_classname
	};

	if (isMultiplayer) then {
		private _group = group _unit;
		if (_unit isEqualTo leader _group) then {
			private _description = roleDescription _unit;
			private _descriptionAtLocation = _description find "@";
			if (_descriptionAtLocation isNotEqualTo -1) then {
				INC(_descriptionAtLocation);//Skips @ character
				private _groupID = _description select [_descriptionAtLocation];
				_group setGroupIdGlobal [_groupID];

				_description = _description select [0,(_description find "@")];
			};

			if (!isNil _description) then {
				_unit setVariable ["displayName", _description, true];
			};
		};
	};
} else {
	if (_unit isKindOf "LandVehicle" || {_unit isKindOf "Air"} || {_unit isKindOf "Ship"} || {_unit isKindOf "Static"} || {_unit isKindOf "thing"}) then {
		clearWeaponCargoGlobal _unit;
		clearItemCargoGlobal _unit;
		clearMagazineCargoGlobal _unit;
		clearBackpackCargoGlobal _unit;
		_unit disableTIEquipment !_enableThermals;
		_unit setVariable ["tf_side", str _orbatSide, true];
		_unit setVariable ["tunuti_startmarkers_vehicleSide", _orbatSide, true];	
		_unit setVariable ["AFI_vehicle_gear", str _orbatSide, true];
		_unit setVehicleLock "UNLOCKED";
	};
};

_TUN_fnc_addWeaponStuff = {
	//Adds list of magazines and items
	//Params [_unit,[[MagazineClassname,count],[MagazineClassname,count],...]] call _TUN_fnc_addmagazines;

	params ["_unit","_weapons", "_magazines", "_weaponitems"];

	if (_weapons isNotEqualTo []) then {
		{
			_unit addWeapon _x;
		} forEach _weapons;
	};

	if (_magazines isNotEqualTo []) then {
		private _secondaryAmmo = [];
		private _handgunAmmo = [];
		private _primaryWeapon = primaryWeapon _unit;
		private _secondaryWeapon = secondaryWeapon _unit;
		private _handgunWeapon = handgunWeapon _unit;
		private _primaryMuzzleMagazines = [];

		if (_primaryWeapon isNotEqualTo "") then {
			private _muzzles = getArray (configFile >> "CfgWeapons" >> _primaryWeapon >> "muzzles");
			private _primaryMagazines = (compatibleMagazines [_primaryWeapon, _muzzles select 0]);
			_muzzles deleteAt 0;
			MAP(_primaryMagazines,toLower _x);
			_primaryMuzzleMagazines pushBack _primaryMagazines;
			{
				private _muzzle = _x;
				if ("UGL_F" in ([(configFile >> "CfgWeapons" >> _primaryWeapon >> _muzzle),true] call BIS_fnc_returnParents)) then {
					private _muzzleMagazines = compatibleMagazines [_primaryWeapon, _muzzle];
					if (_muzzleMagazines isNotEqualTo []) then {
						MAP(_muzzleMagazines,toLower _x);
						_primaryMuzzleMagazines pushBack _muzzleMagazines;
						break
					};
				};
			} forEach _muzzles;
		};

		{
			private _items = _x;	
			private _item = toLower (_items select 0);
			private _count = _items select 1;
			
			//private _newCount = 0;
	
			if (isClass (configFile >> "CFGMagazines" >> _item)) then {
				if ( _primaryWeapon canAdd _item) then { //if is primary weapon
					private _currentMagazines = primaryWeaponMagazine _unit;
					{
						private _magazines = _x;
						if (_item in _magazines && {primaryWeaponMagazine _unit findIf { toLower _x in _magazines} isEqualTo -1}) then {
							_unit addWeaponItem [_primaryWeapon, _item, true];
							_count = _count - 1;
							_primaryMuzzleMagazines deleteAt _forEachIndex;
						};
					} forEach _primaryMuzzleMagazines;
				} else {

					if (_secondaryWeapon canAdd _item && {secondaryWeaponMagazine _unit isEqualTo []}) then  { //if is secondary weapon (launcher/at)
						_unit addWeaponItem [_secondaryWeapon, _item, true];
						_count = _count - 1;
					} else {
						if ( _handgunWeapon canAdd _item && {handgunMagazine _unit isEqualTo []}) then { //if is handgun
							_unit addWeaponItem [_handgunWeapon, _item, true];
							_count = _count - 1;
						};
					};
				};

				private _originalCoun = 0;
				if (_isServer)then {
					_originalCoun = ({_x == _item} count (magazines _unit + primaryWeaponMagazine _unit + handgunMagazine _unit + secondaryWeaponMagazine _unit + handgunMagazine _unit)) + _count;
				};
				_unit addMagazines [_item,_count];
				if (_isServer)then {
					private _newCount = ({_x == _item} count (magazines _unit + primaryWeaponMagazine _unit  + handgunMagazine _unit + secondaryWeaponMagazine _unit + handgunMagazine _unit));
					
					if (_newCount isNotEqualTo _originalCoun) then {
						player createDiaryRecord ["Diary",["!!Gear script ERROR!!",format ["Magazine %1 did not fit %2 to inventory, its type was %3. There should be %4, but only had room for %5",str _item, str _unit, str _type, _originalCoun, _newCount]]];
					};
				};
			} else {
				[_unit, _items] call _TUN_fnc_addItems;
			};
		} forEach _magazines;
	}; 
  
	if (_weaponitems isNotEqualTo []) then {

		{
			private _item = _x select 0;
			private _slot = toLower (_x select 1);
			switch _slot do {
				case "primary": {
					_unit addPrimaryWeaponItem _item;
				};

				case "secondary": {
					_unit addSecondaryWeaponItem _item;
				};

				default {
					_unit addHandgunItem _item;
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
		private _originalCoun = 0;
		if (_isServer) then {
			_originalCoun = ({_x == _item} count (magazines _unit + items _unit + assignedItems _unit)) + _count;
		};

		for "_i" from 1 to _count do {_unit addItem _item;};

		if (_isServer) then {
			private _newCount = {_x == _item} count (magazines _unit + items _unit + assignedItems _unit);
			if (_newCount isNotEqualTo _originalCoun) then {
				player createDiaryRecord ["Diary",["!!Gear script ERROR!!",format ["Item %1 did not fit %2 to inventory, its type was %3. There should be %4, but only had room for %5",str _item, str _unit, str _type, _originalCoun, _newCount]]];
			};			
		};
	} forEach _items;
};