/* ----------------------------------------------------------------------------
Description:
    Geariscirpti
Parameters:
    _type
    _unit
Returns:
    
Examples:
    ["sl", this] call compile preprocessFileLineNumbers "loadouts\Example.sqf";
Author:
    Based on Bummeris version around 2015
    Modified by Tuntematon
Scipti Versio:
    13.12.2023
---------------------------------------------------------------------------- */
params ["_type","_unit"];

if (!(local _unit)) exitwith {}; // Very important. Prevents script from running for non local units
_type = toLower _type; //Make sure that type is all lowers, due to removing all tolower checks for performance reasons

////////////////////////
////////Settings////////
////////////////////////

//Gearscript path
private _gearscriptPath = "loadouts\Example.sqf";

//Orbat side east, west, resistance, civilian. Do not use string!!
private _orbatSide = east;

//Short range radios for everyone. true/false
private _enableRadios = true;

//Enable/disable vehicle thermals
private _enableThermals = false;

//NVGs for everyone. true/false
private _enableNVGs = false;

//NVG className "ACE_NVG_Gen4"
private _NVG_classname = "ACE_NVG_Gen4";

//Defaulty not in use. But just in case someone needs them.
// //Global modifier for dynamic gearscript to enable magnifying optic. 4x etc.
// private _enableMagnifyingOptic = false;

// //Global modifier for dynamic gearscript to enable silencers
// private _enableSilencers = false;

#include "GeariFunctiot.sqf"

////////////////////////
////////Settings////////
////////////////////////

_TUN_fnc_addBasicEquipment = { //Basic items
	params ["_unit", ["_mode", ""], ["_binoculars", ""]];
	
	//These are defaulty given for everyone.
	//Can be overwriten in the switch case using _items = [...] instead of _items append [...]
	private _items = [["ACE_EntrenchingTool",1], ["ACE_MapTools",1], ["HandGrenade",1], ["SmokeShell",1]];

	switch (_mode) do {//!!!!every case must be in lowercaes!!!!!

		case "leader": {
			_items append [["SmokeShellGreen",2], ["ace_microdagr",1]]; //These are additional things given in addition to basic items defined earlier
			//_unit linkItem "itemRadio"; //If radios for everyone is disabled, this is the way to give them to selected units.
		};

		case "varajohtaja": {
			_items append [["SmokeShellGreen",2]];
		};

		case "kevyt": {
			_items = [["SmokeShell",1], ["ACE_MapTools",1]]; //This is to overwrite the default basic items
		};

		case "engineer": {
			_items append [["SmokeShell",2],["ACE_DefusalKit",1],["ACE_Clacker",1],["ToolKit",1],["ACE_wirecutter",1],["DemoCharge_Remote_Mag",3],["SatchelCharge_Remote_Mag",0]];
		};

		case "explosive": {
			//_items append [];
		};

		case "breach": {
			_items append [["ACE_DefusalKit",1],["ACE_Clacker",1],["DemoCharge_Remote_Mag",2]];
		};

		case "medic": {
			_items = [["ACE_EntrenchingTool",1], ["ACE_MapTools",1], ["SmokeShell",6]];
		};

		default { //Default case where one could give more basic stuff what other cases does not need.
			//_items = [];
		};
	};

	[_unit, _items] call _TUN_fnc_addItems;

	switch (_binoculars) do {//!!!!every case must be in lowercaes!!!!!
		case "binoculars";
		case "binocular": {
			_unit addWeapon "Binocular";
		};

		case "range": {
			_unit addWeapon "ACE_Vector";
		};

		case "laser": {
			_unit addWeapon "Laserdesignator";
			_unit addItem "Laserbatteries";
		};
		default {};
	};
};

_TUN_fnc_addMedicalSupplies = {
	params ["_unit", ["_mode", " "]];
	private ["_supplies"];

	switch (_mode) do {//!!!!every case must be in lowercaes!!!!!

		case "medic": {
			_unit setVariable ["Ace_medical_medicClass", 1];//Makes sure that unit is medic
			_supplies = [["ACE_elasticBandage",22],["ACE_morphine",10],["ACE_epinephrine",10],["ACE_adenosine",3],["ACE_splint",5],["ACE_surgicalKit",1],["ACE_bloodIV",8],["ACE_bloodIV_500",5],["ACE_tourniquet",4]];
		};

		default {
			_unit setVariable ["Ace_medical_medicClass", 0];//Makes sure that unit is NOT medic
			_supplies = [["ACE_packingBandage",7],["ACE_tourniquet",2],["ACE_morphine",1],["ACE_splint",1]];
		};
	};

	[_unit, _supplies] call _TUN_fnc_addItems;
};

_TUN_fnc_changeWeapons = {
	params ["_unit",["_weaponSelection", ""],["_launcherSelection", ""],["_assistantSelection", ""]];
	private _weapons = [];
	private _magazines = [];
	private _weaponItems = [];
	private _muzzlebrake = "";
	private _gun = "";
	private _sight = "";
	private _grip = "";

///////////////////
//Primary weapons//
///////////////////
/*
These can be used for the dynamic thing.

if (_enableMagnifyingOptic) then {
	// code here if optiikkaa
} else {
	// code here if ei optiikkaa
};

if (_enableSilencers) then {
	// code here if silencer
} else {
	// code here if ei silencer
};
*/

	switch (_weaponSelection) do {//!!!!every case must be in lowercaes!!!!!  //Delete unused cases, after you are done.

		//////////
		//Rifles//
		//////////

		case "rif": { //Rifle with optic (this is example and does not work)
			_gun = selectRandom ["clasname","clasname"]; //If you want to have random gun, use this. If not, remove or comment this out
			_gun = "className"; //If you dont want to use random weapon, you can use this to keep it more readable. But you can just put the classname to "_weapons append [_gun, "classname"];" and overwrite the _gun with the classname
			_muzzlebrake = "classname";
			_sight = "classname";
			_grip = "classname";

			_weapons append [_gun, "classname"]; // you can put multiple weapon classnames here, but remember that only one primary, secondary (lancher) and pistol. But there is seperate case for lanchers.
			_magazines append [["magazine1",magazinecount],["rhs_30Rnd_545x39_AK_green",3]]; //Magazines [classname, magazinecount]
			_weaponItems append [["classname","primary/handgun/secondary"],["_muzzlebrake","primary"],["_sight","primary"],["_sight","primary"]]; //Weapon attatchments [classname,which weapon slot] "primary/handgun/secondary"
		};

		case "rif1": { //Rifle (this is example and does not work)
			_weapons append ["rhs_weap_m21a"];
			_magazines append [["rhsgref_30rnd_556x45_m21",10],["rhsgref_30rnd_556x45_m21_t",4]];
			_weaponItems append [["rhs_acc_pkas","primary"]];
		};

		case "rif2": { //Rifle

		};

		case "gl": { //Rifle with UGL

		};


		//////
		//MG//
		//////

		case "mg": { //Heavy machinegun (PKM, PKP, M240) Nato 7.62x51, other 7.62x54/53

		};

		case "mg1": { //Heavy machinegun (PKM, PKP, M240) Nato 7.62x51, other 7.62x54/53

		};

		//////
		//AR//
		//////

		case "ar": { //Light machinegun (M249, RPK, M27)

		};

		case "ar1": { //Light machinegun (M249, RPK, M27)

		};


		//////////////////
		//Sniper & Marks//
		//////////////////

		case "mark": { //Marksman = squad lever semi automatic support weapon or spotters weapon (MK11, SVD, AK+PSO, VSS Vintorez)

		};

		case "mark1": { //Marksman = squad lever semi automatic support weapon or spotters weapon (MK11, SVD, AK+PSO, VSS Vintorez)

		};

		case "sniper": { //Sniper

		};

		case "sniper1": { //Sniper

		};

		//////////////
		//Small arms//
		//////////////
		case "smg": { //Special leaders, vehicle crew, pilots etc

		};

		case "carbine": { //Special leaders, vehicle crew, pilots etc

		};

		case "pistol": { //Special leaders, vehicle crew, pilots etc

		};

		case "shotgun": { //Engineers must have shotguns T:Tuntematon

		};

		default {};
	};

//////////////////////
//Launcher selection//
//////////////////////

	switch (_launcherSelection) do {//!!!!every case must be in lowercaes!!!!!

		case "at": { //AT = RPG7, SMAW, MAAWS (Heavy launcher)
			_weapons append ["rhs_weap_smaw_green"];
			_magazines append [["rhs_mag_smaw_HEAA",2],["rhs_mag_smaw_SR",2]];
			_weaponItems append [["rhs_weap_optic_smaw","secondary"]];
		};

		case "lat": { //light single use launchers (M72, RPG26, M136)

		};

		case "lat1": { //light single use launchers (M72, RPG26, M136)

		};

		case "aa": { //Anti-air

		};

		case "hat": { //NLAW, JAVELIN (missile based)

		};

		default {}; //Leave this empty
	};


/////////////
//Assistans//
/////////////


	switch (_assistantSelection) do {//!!!!every case must be in lowercaes!!!!! //These are for assistant

		case "hat": { //NLAW, JAVELIN

		};

		case "aa": { //Anti-air

		};

		case "at": { //AT = RPG7, SMAW, MAAWS (Heavy launcher)

		};

		case "ar": { //Light machinegun (M249, RPK, M27)

		};

		case "mg": { //Heavy machinegun (PKM, PKP, M240) Nato 7.62x51, other 7.62x54/53
			//_magazines append [["",10]];
		};

		default {}; //Leave this empty
	};

	[_unit, _weapons, _magazines, _weaponItems] call _TUN_fnc_addWeaponStuff;

};


_TUN_fnc_changeClothes = {
	params ["_unit", ["_helmet", ""], ["_uniform", ""], ["_vest", ""], ["_backpack", ""]];

	removeUniform _unit;
    removeVest _unit;
    removeBackpack _unit;
    removeHeadgear _unit;
    removeGoggles _unit;

////////////////////
//Helmet selection//
////////////////////
	switch (_helmet) do {

		case "leader": {

		};

		case "sl": {

		};

		case "rto": {

		};

		case "medic": {

		};

		case "tl": {

		};

		case "crew": {

		};

		case "pilot": {

		};

		default { //Default helmet given for everyone who has not set other case
			_unit addHeadgear selectRandom ["rhssaf_helmet_m97_digital", "rhssaf_helmet_m97_digital_black_ess", "rhssaf_helmet_m97_digital_black_ess_bare", "rhssaf_helmet_m97_veil_digital"];
		};
	};

//////////////////
//Vest selection//
//////////////////

	switch (_vest) do {

		case "leader": {

		};

		case "sl": {

		};

		case "tl": {

		};

		case "medic": {

		};

		case "mg": {

		};

		case "at": {

		};

		case "rto": {

		};

		case "crew": {

		};

		case "pilot": {

		};

		default { //Default vest given for everyone who has not set other case
			_unit addVest "rhssaf_vest_md99_digital_rifleman";
		};
	};

/////////////////////
//Uniform selection//
/////////////////////

	switch (_uniform) do {

		case "leader": {

		};

		case "sl": {

		};

		case "tl": {

		};

		case "rto": {

		};

		case "crew": {

		};

		case "pilot": {

		};

		default { //Default uniform given for everyone who has not set other case
			_unit forceAddUniform "rhssaf_uniform_m10_digital";
		};
	};

//////////////////////
//Backpack selection//
//////////////////////

	switch (_backpack) do {
		case "radio": {

		};

		case "medic": {

		};

		case "at": {

		};

		case "pienireppu": {

		};

		case "mg": {

		};

		case "engineer": {

		};

		default { //Default backpack given for everyone who has not set other case
			_unit addBackpack "rhssaf_kitbag_digital";
		};
	};
};

//Gear for infantry
if (_unit isKindof "Man") then {
	private ["_Tun_Helmet", "_Tun_Uniform", "_Tun_Vest", "_Tun_Backpack", "_Tun_Weapon", "_Tun_Launcher", "_Tun_BasicItems", "_Tun_Binoculars", "_Tun_Medical","_Tun_Assistant"];
	switch (_type) do {

		///////////
		//Leaders//
		///////////

		case "cl": { //Company leader
			//Clothes
			_Tun_Helmet = "leader"; // Put here the case name. Leave "", if you want to use default/empty
			_Tun_Uniform = "leader";
			_Tun_Vest = "leader";
			_Tun_Backpack = "radio";

			//Weapons
			_Tun_Weapon = "";
			_Tun_Launcher = "";
			_Tun_Assistant = "";

			//Equipment
			_Tun_BasicItems = "";
			_Tun_Binoculars = "binocular"; // "binoculars", "range", "laser"
			_Tun_Medical = "";
		};

		case "pl": { //Platoon leader
			//Clothes
			_Tun_Helmet = "leader";
			_Tun_Uniform = "leader";
			_Tun_Vest = "leader";
			_Tun_Backpack = "radio";

			//Weapons
			_Tun_Weapon = "";
			_Tun_Launcher = "";
			_Tun_Assistant = "";

			//Equipment
			_Tun_BasicItems = "";
			_Tun_Binoculars = "binocular";
			_Tun_Medical = "";
		};

		case "rto": { //Radio operator
			//Clothes
			_Tun_Helmet = "";
			_Tun_Uniform = "";
			_Tun_Vest = "";
			_Tun_Backpack = "radio";

			//Weapons
			_Tun_Weapon = "";
			_Tun_Launcher = "";
			_Tun_Assistant = "";

			//Equipment
			_Tun_BasicItems = "";
			_Tun_Binoculars = "binocular";
			_Tun_Medical = "";
		};

		case "fac": { //Firesupport (air/artillery)
			//Clothes
			_Tun_Helmet = "";
			_Tun_Uniform = "";
			_Tun_Vest = "";
			_Tun_Backpack = "radio";

			//Weapons
			_Tun_Weapon = "";
			_Tun_Launcher = "";
			_Tun_Assistant = "";

			//Equipment
			_Tun_BasicItems = "";
			_Tun_Binoculars = "laser";
			_Tun_Medical = "";
		};

		case "sl": { //Squad leader
			//Clothes
			_Tun_Helmet = "sl";
			_Tun_Uniform = "sl";
			_Tun_Vest = "sl";
			_Tun_Backpack = "radio";

			//Weapons
			_Tun_Weapon = "";
			_Tun_Launcher = "";
			_Tun_Assistant = "";

			//Equipment
			_Tun_BasicItems = "";
			_Tun_Binoculars = "binocular";
			_Tun_Medical = "";
		};

		case "tl": { // Team leader
			//Clothes
			_Tun_Helmet = "tl";
			_Tun_Uniform = "tl";
			_Tun_Vest = "tl";
			_Tun_Backpack = "";

			//Weapons
			_Tun_Weapon = "";
			_Tun_Launcher = "";
			_Tun_Assistant = "";

			//Equipment
			_Tun_BasicItems = "";
			_Tun_Binoculars = "binocular";
			_Tun_Medical = "";
		};

		//////////////////
		//Machinegunners//
		//////////////////

		case "mg": {
			//Clothes
			_Tun_Helmet = "";
			_Tun_Uniform = "";
			_Tun_Vest = "mg";
			_Tun_Backpack = "mg";

			//Weapons
			_Tun_Weapon = "mg";
			_Tun_Launcher = "";
			_Tun_Assistant = "";

			//Equipment
			_Tun_BasicItems = "";
			_Tun_Binoculars = "";
			_Tun_Medical = "";
		};

		case "mg1": {
			//Clothes
			_Tun_Helmet = "";
			_Tun_Uniform = "";
			_Tun_Vest = "mg";
			_Tun_Backpack = "mg";

			//Weapons
			_Tun_Weapon = "mg1";
			_Tun_Launcher = "";
			_Tun_Assistant = "";

			//Equipment
			_Tun_BasicItems = "";
			_Tun_Binoculars = "";
			_Tun_Medical = "";
		};

		case "mgas": {
			//Clothes
			_Tun_Helmet = "";
			_Tun_Uniform = "";
			_Tun_Vest = "";
			_Tun_Backpack = "";

			//Weapons
			_Tun_Weapon = "";
			_Tun_Launcher = "";
			_Tun_Assistant = "mg";

			//Equipment
			_Tun_BasicItems = "";
			_Tun_Binoculars = "binocular";
			_Tun_Medical = "";
		};

		case "mgas1": {
			//Clothes
			_Tun_Helmet = "";
			_Tun_Uniform = "";
			_Tun_Vest = "";
			_Tun_Backpack = "";

			//Weapons
			_Tun_Weapon = "";
			_Tun_Launcher = "";
			_Tun_Assistant = "mg1";

			//Equipment
			_Tun_BasicItems = "";
			_Tun_Binoculars = "binocular";
			_Tun_Medical = "";
		};

		/////////////////
		//Autoriflemans//
		/////////////////

		case "ar": {
			//Clothes
			_Tun_Helmet = "";
			_Tun_Uniform = "";
			_Tun_Vest = "";
			_Tun_Backpack = "";

			//Weapons
			_Tun_Weapon = "ar";
			_Tun_Launcher = "";
			_Tun_Assistant = "";

			//Equipment
			_Tun_BasicItems = "";
			_Tun_Binoculars = "";
			_Tun_Medical = "";
		};

		case "ar1": {
			//Clothes
			_Tun_Helmet = "";
			_Tun_Uniform = "";
			_Tun_Vest = "";
			_Tun_Backpack = "";

			//Weapons
			_Tun_Weapon = "ar1";
			_Tun_Launcher = "";
			_Tun_Assistant = "";

			//Equipment
			_Tun_BasicItems = "";
			_Tun_Binoculars = "";
			_Tun_Medical = "";
		};

		case "aras": {
			//Clothes
			_Tun_Helmet = "";
			_Tun_Uniform = "";
			_Tun_Vest = "";
			_Tun_Backpack = "";

			//Weapons
			_Tun_Weapon = "";
			_Tun_Launcher = "";
			_Tun_Assistant = "ar";

			//Equipment
			_Tun_BasicItems = "";
			_Tun_Binoculars = "binocular";
			_Tun_Medical = "";
		};

		case "aras1": {
			//Clothes
			_Tun_Helmet = "";
			_Tun_Uniform = "";
			_Tun_Vest = "";
			_Tun_Backpack = "";

			//Weapons
			_Tun_Weapon = "";
			_Tun_Launcher = "";
			_Tun_Assistant = "ar1";

			//Equipment
			_Tun_BasicItems = "";
			_Tun_Binoculars = "binocular";
			_Tun_Medical = "";
		};

		/////////////
		//Basic Inf//
		/////////////

		case "gl": {
			//Clothes
			_Tun_Helmet = "";
			_Tun_Uniform = "";
			_Tun_Vest = "";
			_Tun_Backpack = "";

			//Weapons
			_Tun_Weapon = "gl";
			_Tun_Launcher = "";
			_Tun_Assistant = "";

			//Equipment
			_Tun_BasicItems = "";
			_Tun_Binoculars = "";
			_Tun_Medical = "";
		};

		case "rif": {
			//Clothes
			_Tun_Helmet = "";
			_Tun_Uniform = "";
			_Tun_Vest = "";
			_Tun_Backpack = "";

			//Weapons
			_Tun_Weapon = "";
			_Tun_Launcher = "";
			_Tun_Assistant = "";

			//Equipment
			_Tun_BasicItems = "";
			_Tun_Binoculars = "";
			_Tun_Medical = "";
		};

		//////////
		//Medics//
		//////////

		case "medic": {
			//Clothes
			_Tun_Helmet = "";
			_Tun_Uniform = "";
			_Tun_Vest = "";
			_Tun_Backpack = "medic";

			//Weapons
			_Tun_Weapon = "";
			_Tun_Launcher = "";
			_Tun_Assistant = "";

			//Equipment
			_Tun_BasicItems = "medic";
			_Tun_Binoculars = "";
			_Tun_Medical = "medic";
		};

		//////////////////////////
		//AT and other launchers//
		//////////////////////////

		case "at": { //Heavy AT (SMAW,RPG)
			//Clothes
			_Tun_Helmet = "";
			_Tun_Uniform = "";
			_Tun_Vest = "";
			_Tun_Backpack = "at";

			//Weapons
			_Tun_Weapon = "";
			_Tun_Launcher = "at";
			_Tun_Assistant = "";

			//Equipment
			_Tun_BasicItems = "";
			_Tun_Binoculars = "";
			_Tun_Medical = "";
		};

		case "atas": { //Heavy AT asst.
			//Clothes
			_Tun_Helmet = "";
			_Tun_Uniform = "";
			_Tun_Vest = "";
			_Tun_Backpack = "at";

			//Weapons
			_Tun_Weapon = "";
			_Tun_Launcher = "";
			_Tun_Assistant = "at";

			//Equipment
			_Tun_BasicItems = "";
			_Tun_Binoculars = "binocular";
			_Tun_Medical = "";
		};

		case "hat": { //Missile based
			//Clothes
			_Tun_Helmet = "";
			_Tun_Uniform = "";
			_Tun_Vest = "";
			_Tun_Backpack = "";

			//Weapons
			_Tun_Weapon = "";
			_Tun_Launcher = "hat";
			_Tun_Assistant = "";

			//Equipment
			_Tun_BasicItems = "";
			_Tun_Binoculars = "";
			_Tun_Medical = "";
		};

		case "hatas": { //Assistant for hat
			//Clothes
			_Tun_Helmet = "";
			_Tun_Uniform = "";
			_Tun_Vest = "";
			_Tun_Backpack = "";

			//Weapons
			_Tun_Weapon = "";
			_Tun_Launcher = "";
			_Tun_Assistant = "hat";

			//Equipment
			_Tun_BasicItems = "";
			_Tun_Binoculars = "binocular";
			_Tun_Medical = "";
			};

		case "rifat": { //LAT taistelija
			//Clothes
			_Tun_Helmet = "";
			_Tun_Uniform = "";
			_Tun_Vest = "";
			_Tun_Backpack = "";

			//Weapons
			_Tun_Weapon = "";
			_Tun_Launcher = "lat";
			_Tun_Assistant = "";

			//Equipment
			_Tun_BasicItems = "";
			_Tun_Binoculars = "";
			_Tun_Medical = "";
		};

		case "rifat1": { //LAT taistelija
			//Clothes
			_Tun_Helmet = "";
			_Tun_Uniform = "";
			_Tun_Vest = "";
			_Tun_Backpack = "";

			//Weapons
			_Tun_Weapon = "";
			_Tun_Launcher = "lat1";
			_Tun_Assistant = "";

			//Equipment
			_Tun_BasicItems = "";
			_Tun_Binoculars = "";
			_Tun_Medical = "";
		};

		case "aa": { //Anti Air
			//Clothes
			_Tun_Helmet = "";
			_Tun_Uniform = "";
			_Tun_Vest = "";
			_Tun_Backpack = "";

			//Weapons
			_Tun_Weapon = "";
			_Tun_Launcher = "aa";
			_Tun_Assistant = "";

			//Equipment
			_Tun_BasicItems = "";
			_Tun_Binoculars = "";
			_Tun_Medical = "";
		};

		case "aaas": { ////Anti Air asst.
			//Clothes
			_Tun_Helmet = "";
			_Tun_Uniform = "";
			_Tun_Vest = "";
			_Tun_Backpack = "";

			//Weapons
			_Tun_Weapon = "";
			_Tun_Launcher = "";
			_Tun_Assistant = "aa";

			//Equipment
			_Tun_BasicItems = "";
			_Tun_Binoculars = "binocular";
			_Tun_Medical = "";
		};

		//////////////////////
		//Ajoneuvo miehistöt//
		//////////////////////

		case "crewCommander": { //Tank commander
			//Clothes
			_Tun_Helmet = "crew";
			_Tun_Uniform = "crew";
			_Tun_Vest = "crew";
			_Tun_Backpack = "radio";

			//Weapons
			_Tun_Weapon = "";
			_Tun_Launcher = "";
			_Tun_Assistant = "";

			//Equipment
			_Tun_BasicItems = "";
			_Tun_Binoculars = "binocular";
			_Tun_Medical = "";
		};

		case "crew": { //vehicle crew
			//Clothes
			_Tun_Helmet = "crew";
			_Tun_Uniform = "crew";
			_Tun_Vest = "crew";
			_Tun_Backpack = "crew";

			//Weapons
			_Tun_Weapon = "";
			_Tun_Launcher = "";
			_Tun_Assistant = "";

			//Equipment
			_Tun_BasicItems = "";
			_Tun_Binoculars = "";
			_Tun_Medical = "";
		};

		case "heli": { //Helicopter pilot/crew
			//Clothes
			_Tun_Helmet = "";
			_Tun_Uniform = "";
			_Tun_Vest = "";
			_Tun_Backpack = "";

			//Weapons
			_Tun_Weapon = "";
			_Tun_Launcher = "";
			_Tun_Assistant = "";

			//Equipment
			_Tun_BasicItems = "";
			_Tun_Binoculars = "";
			_Tun_Medical = "";
		};

		case "pilot": { //Plane pilot
			//Clothes
			_Tun_Helmet = "";
			_Tun_Uniform = "";
			_Tun_Vest = "";
			_Tun_Backpack = "";

			//Weapons
			_Tun_Weapon = "";
			_Tun_Launcher = "";
			_Tun_Assistant = "";

			//Equipment
			_Tun_BasicItems = "";
			_Tun_Binoculars = "";
			_Tun_Medical = "";
		};

		///////////////////////
		//Snipers & Marksmans//
		///////////////////////

		case "sniper": {
			//Clothes
			_Tun_Helmet = "";
			_Tun_Uniform = "";
			_Tun_Vest = "";
			_Tun_Backpack = "";

			//Weapons
			_Tun_Weapon = "sniper";
			_Tun_Launcher = "";
			_Tun_Assistant = "";

			//Equipment
			_Tun_BasicItems = "";
			_Tun_Binoculars = "";
			_Tun_Medical = "";
		};

		case "sniper1": {
			//Clothes
			_Tun_Helmet = "";
			_Tun_Uniform = "";
			_Tun_Vest = "";
			_Tun_Backpack = "";

			//Weapons
			_Tun_Weapon = "sniper1";
			_Tun_Launcher = "";
			_Tun_Assistant = "";

			//Equipment
			_Tun_BasicItems = "";
			_Tun_Binoculars = "";
			_Tun_Medical = "";
		};

		case "spotter": {
			//Clothes
			_Tun_Helmet = "";
			_Tun_Uniform = "";
			_Tun_Vest = "";
			_Tun_Backpack = "";

			//Weapons
			_Tun_Weapon = "";
			_Tun_Launcher = "";
			_Tun_Assistant = "";

			//Equipment
			_Tun_BasicItems = "";
			_Tun_Binoculars = "";
			_Tun_Medical = "";
		};

		case "mark": {
			//Clothes
			_Tun_Helmet = "";
			_Tun_Uniform = "";
			_Tun_Vest = "";
			_Tun_Backpack = "";

			//Weapons
			_Tun_Weapon = "mark";
			_Tun_Launcher = "";
			_Tun_Assistant = "";

			//Equipment
			_Tun_BasicItems = "";
			_Tun_Binoculars = "";
			_Tun_Medical = "";
		};

		case "mark1": {
			//Clothes
			_Tun_Helmet = "";
			_Tun_Uniform = "";
			_Tun_Vest = "";
			_Tun_Backpack = "";

			//Weapons
			_Tun_Weapon = "mark1";
			_Tun_Launcher = "";
			_Tun_Assistant = "";

			//Equipment
			_Tun_BasicItems = "";
			_Tun_Binoculars = "";
			_Tun_Medical = "";
		};

		/////////////
		//Engineers//
		/////////////

		case "eng": { //Engineer (Explosives, mines, etc.)
			_unit setVariable ["ACE_IsEngineer",true,true];
			_unit setVariable ["ACE_isEOD",true,true];

			//Clothes
			_Tun_Helmet = "";
			_Tun_Uniform = "";
			_Tun_Vest = "";
			_Tun_Backpack = "";

			//Weapons
			_Tun_Weapon = "";
			_Tun_Launcher = "";
			_Tun_Assistant = "";

			//Equipment
			_Tun_BasicItems = "engineer";
			_Tun_Binoculars = "";
			_Tun_Medical = "";
		};

		case "exp": { //Explosive Expert. BIG BOMBS / IED
			_unit setVariable ["ACE_isEOD",true,true];

			//Clothes
			_Tun_Helmet = "";
			_Tun_Uniform = "";
			_Tun_Vest = "";
			_Tun_Backpack = "";

			//Weapons
			_Tun_Weapon = "";
			_Tun_Launcher = "";
			_Tun_Assistant = "";

			//Equipment
			_Tun_BasicItems = "explosive";
			_Tun_Binoculars = "";
			_Tun_Medical = "";
		};

		case "breach": { //Smol bombs, shotguns, etc.
			_unit setVariable ["ACE_isEOD",true,true];

			//Clothes
			_Tun_Helmet = "";
			_Tun_Uniform = "";
			_Tun_Vest = "";
			_Tun_Backpack = "";

			//Weapons
			_Tun_Weapon = "";
			_Tun_Launcher = "";
			_Tun_Assistant = "";

			//Equipment
			_Tun_BasicItems = "breach";
			_Tun_Binoculars = "";
			_Tun_Medical = "";
		};

		default {
			removeUniform _unit;
		    removeVest _unit;
		    removeBackpack _unit;
		    removeHeadgear _unit;
		    removeGoggles _unit;
		};
	};

	//calling the functions, do not change
	[_unit, _Tun_Helmet, _Tun_Uniform, _Tun_Vest, _Tun_Backpack] call _TUN_fnc_changeClothes;
	[_unit, _Tun_Weapon, _Tun_Launcher, _Tun_Assistant] call _TUN_fnc_changeWeapons;
	[_unit, _Tun_Medical] call _TUN_fnc_addMedicalSupplies;
	[_unit, _Tun_BasicItems, _Tun_Binoculars] call _TUN_fnc_addBasicEquipment;
} else {
	////////////////////
	//Vehicles & Boxes//
	////////////////////

	if (_unit isKindof "LandVehicle" || _unit isKindof "Air" || _unit isKindOf "Ship" || _unit isKindOf "Static" || _unit isKindOf "thing") then {
		switch (_type) do {

			case "car": {
				_unit addMagazineCargoGlobal ["", 6];
				_unit addMagazineCargoGlobal ["",2];
				_unit addItemCargoGlobal ["ACE_wirecutter",2];
				_unit addItemCargoGlobal ["ACE_bodyBag",10];
				_unit addItemCargoGlobal ["ACE_bloodIV",5];
				_unit addItemCargoGlobal ["ACE_EntrenchingTool",3];
				_unit addItemCargoGlobal ["ACE_Sandbag_empty",50];
			};

			case "box": {
				_unit addMagazineCargoGlobal ["", 6];
				_unit addMagazineCargoGlobal ["",2];
				_unit addItemCargoGlobal ["ACE_wirecutter",2];
				_unit addItemCargoGlobal ["ACE_bodyBag",10];
				_unit addItemCargoGlobal ["ACE_bloodIV",5];
				_unit addItemCargoGlobal ["ACE_Sandbag_empty",50];
				_unit setVariable ["displayName", "Random Nimi tähän", true];
			};

			case "truck": {
				_unit addMagazineCargoGlobal ["", 6];
				_unit addMagazineCargoGlobal ["",2];
				_unit addItemCargoGlobal ["ACE_wirecutter",2];
				_unit addItemCargoGlobal ["ACE_bodyBag",10];
				_unit addItemCargoGlobal ["ACE_bloodIV",5];
				_unit addItemCargoGlobal ["ACE_EntrenchingTool",3];
				_unit addItemCargoGlobal ["ACE_Sandbag_empty",50];
			};

			default{};
		};
	};
};