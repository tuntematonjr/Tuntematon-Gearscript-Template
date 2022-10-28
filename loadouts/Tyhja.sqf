/* ----------------------------------------------------------------------------
Description:
    Geariscirpti
Parameters:
    _type
    _unit
Returns:
    Ei mitään
Examples:
    ["sl", this] call compile preprocessFileLineNumbers "loadouts\Tyhja.sqf";
Author:
    Alkuperäinen Bummeri
    Modifioinut Tuntematon
Scipti Versio:
    v2.2
    27.8.2022
---------------------------------------------------------------------------- */
params ["_type","_unit"];

if (!(local _unit)) exitwith {}; // Todella tärkeä. Estää skriptin pyörimisen ei locaaleilla uniteilla
_type = toLower _type; //Make sure that type is all lowers, due to removing all tolower checks for performance reasons

/////////////////////////
////////ASETUKSET////////
/////////////////////////
//Vaadittava gearifunctio versio
private _VaadittuFunctio_versio = 6;

//Geariscriptin polku
private _gearscript_path = "loadouts\msv.sqf";

//Orbatin osapuoli "east", "west" , "guer"
private _OrbatinSide = "east";

//Lyhyet radiot kaikille. true/false
private _Radioit = true;

//Onko ajoneuvoissa thermalit
private _Thermalit = false;

//Onko NVG kaikilla. true/false
private _Nightvision = false;

// //Onko zoomaavaa optiikkaa
// private _Optiikka = false;

// //Onko zoomaavaa optiikkaa
// private _Silencer = false;

//Lisää tähän haluttu NVG classname "ACE_NVG_Gen4"
private _item_NV = "ACE_NVG_Gen4";

#include "GeariFunctiot.sqf"

/////////////////////////
////////ASETUKSET////////
/////////////////////////

_TUN_fnc_addBasicEquipment = { //PerusTavaroiden functio//
	//Params [_unit, varusteet, kiikarit] call _TUN_fnc_addBasicEquipment;

	params ["_unit", ["_mode", ""], ["_kiikarit", ""]];
	
	//Perus tavarat kaikille
	private _tavarat = [["ACE_EntrenchingTool",1], ["ACE_MapTools",1], ["HandGrenade",1], ["SmokeShell",2]];

	Switch (_mode) do {//!!!! caset pitää olla kaikki pienellä!!!!!

		case "johtaja": {
			_tavarat append [["SmokeShellGreen",2], ["ace_microdagr",1]]; //Tässä voit muutta mitä perus tavaroita annetaan
		};

		case "varajohtaja": {
			_tavarat append [["SmokeShellGreen",2]];
		};

		case "kevyt": {
			_tavarat = [["SmokeShell",1], ["ACE_MapTools",1]]; //tämä ylikirjoittaa perus setin
		};

		case "engineer": {
			_tavarat append [["SmokeShell",2],["ACE_DefusalKit",1],["ACE_Clacker",1],["ToolKit",1],["ACE_wirecutter",1],["DemoCharge_Remote_Mag",3],["SatchelCharge_Remote_Mag",0]];
		};

		case "explosive": {
			//_tavarat append [];
		};

		case "breach": {
			_tavarat append [["ACE_DefusalKit",1],["ACE_Clacker",1],["DemoCharge_Remote_Mag",2]];
		};

		case "medic": {
			_tavarat = [["ACE_EntrenchingTool",1], ["ACE_MapTools",1], ["SmokeShell",6]]; //tämä ylikirjoittaa perus setin
		};

		default { //Vakio romut
			//_tavarat = [];
		};
	};

	//Annetaan valitut tavarat
	[_unit, _tavarat] call _TUN_fnc_addItems;

	Switch (_kiikarit) do {
		case "kiikari": {
			_unit addWeapon "Binocular";
		};

		case "range": {
			_unit addWeapon "ACE_Vector";
		};

		case "laser": {//!!!! caset pitää olla kaikki pienellä!!!!!
			_unit addWeapon "Laserdesignator";
			_unit addItem "Laserbatteries";
		};
		default {};
	};
};

_TUN_fnc_addMedicalSupplies = {
	//Params [unit, mode] call _TUN_fnc_addMedicalSupplies;
	params ["_unit", ["_mode", " "]];
	private ["_supplies"];

	Switch (_mode) do {//!!!! caset pitää olla kaikki pienellä!!!!!

		case "medic": {
			_unit setVariable ["Ace_medical_medicClass", 2];//Asettaa ace medikin tason
			_supplies = [["ACE_elasticBandage",22],["ACE_morphine",10],["ACE_epinephrine",10],["ACE_adenosine",3],["ACE_splint",5],["ACE_surgicalKit",1],["ACE_bloodIV",8],["ACE_bloodIV_500",5],["ACE_tourniquet",4]]; //Tässä voit muutta mitä medicaali tavaroita kukin saa.
		};

		default {
			_unit setVariable ["Ace_medical_medicClass", 0];//Asettaa ace medikin tason
			_supplies = [["ACE_packingBandage",7],["ACE_tourniquet",2],["ACE_morphine",1],["ACE_splint",1]]; //Tässä voit muutta mitä medicaali tavaroita kukin saa.
		};
	};

	[_unit, _supplies] call _TUN_fnc_addItems;
};

_TUN_fnc_changeWeapons = { //ASEFUNCTIO//


	//Kutsuminen [_unit, "ase", "sinko"] call _TUN_fnc_changeWeapons;
	params ["_unit",["_weapon", ""],["_Singonvalinta", ""],["_Assistantti", ""]];
	private _weapons = [];
	private _magazines = [];
	private _weaponitems = [];
	private _muzzlebrake = "";
	private _gun = "";
	private _sight = "";
	private _grip = "";

///////////////////
//PääaseenValinta//
///////////////////
/*
Listaa ase näin.
_weapons append ["classname"];
Lisää lipas
_magazines append [["lipas1",lippaidenmäärä],["rhs_30Rnd_545x39_AK_green",3]];
Aseiden lisävarusteet
_weaponitems append [["classname","primary/handgun/secondary"],["rhs_acc_dtk","primary"]];



//Optiikka on/off
if (_Optiikka) then {
	// code here if optiikkaa
} else {
	// code here if ei optiikkaa
};

if (_Silencer) then {
	// code here if silencer
} else {
	// code here if ei silencer
};
*/

	Switch (_weapon) do {//!!!! caset pitää olla kaikki pienellä!!!!!

		////////////
		//Kiväärit//
		////////////

		case "rif": { //Rynnäkkökivääri optiikalla
			_weapon = selectRandom ["clasname","clasname"]; //jos radom ase. Käytä tätä. Jos ei, poista/kommentoi tämä rivi.
			_weapon = "className"; //Käytä tätä jos ei aseen randomointia. Muuten poista/kommentoi tämä rivi.

			_weapons append [_weapon, "classname"];
			_magazines append [["lipas1",lippaidenmäärä],["rhs_30Rnd_545x39_AK_green",3]];
			_weaponitems append [["classname","primary/handgun/secondary"],["_muzzlebrake","primary"],["_sight","primary"]];
		};

		case "rif1": { //Rynnäkkökivääri

		};

		case "rif2": { //Rynnäkkökivääri

		};

		case "gl": { //Heittimen sisältävät rynnäkkökiväärit

		};


		//////
		//MG//
		//////

		case "mg": { //Raskaammat konekiväärit (PKM, PKP, M240) Natossa 7.62x51, muilla 7.62x54/53

		};

		case "mg1": { //Raskaammat konekiväärit (PKM, PKP, M240) Natossa 7.62x51, muilla 7.62x54/53

		};

		//////
		//AR//
		//////

		case "ar": { //Kevyet konekiväärit (M249, RPK, M27)

		};

		case "ar1": { //Kevyet konekiväärit (M249, RPK, M27)

		};


		//////////////////
		//Sniper & Marks//
		//////////////////

		case "mark": { //Marksman eli ryhmätason puoliautomaatti tukiase (MK11, SVD, AK+PSO, VSS Vintorez) Myös spottereiden ase

		};

		case "mark1": { //Marksman eli ryhmätason puoliautomaatti tukiase (MK11, SVD, AK+PSO, VSS Vintorez) Myös spottereiden ase

		};

		case "sniper": { //Tarkkuuskivääri

		};

		case "sniper1": { //Tarkkuuskivääri

		};

		////////////////
		//Pienet aseet//
		////////////////
		case "smg": { //Erikoiset johtajat, mahd. vaunumiehistöt, pilotit

		};

		case "carbine": { //Erikoiset johtajat, mahd. vaunumiehistöt, pilotit

		};

		case "pistol": { //Erikoiset johtajat, mahd. vaunumiehistöt, pilotit

		};

		case "shotgun": { //Pääaseena haulikko. Eli Engineer T:Tuntematon

		};

		default {};
	};

/////////////////
//SingonValinta//
/////////////////

	Switch (_Singonvalinta) do {//!!!! caset pitää olla kaikki pienellä!!!!!

		case "at": { //AT = RPG7, SMAW, MAAWS (Raskaat singot)
			// _weapons append ["rhs_weap_rpg7"];
			// _magazines append [["rhs_rpg7_PG7VL_mag",3]];
			//_weaponitems append [];
		};

		case "lat": { //kevyt kertasinko (M72, RPG26, M136)

		};

		case "lat1": { //kevyt kertasinko (M72, RPG26, M136)

		};

		case "aa": { //Anti-air

		};

		case "hat": { //NLAW, JAVELIN (Ylipäätänsä ohjuspohjainen)

		};

		default {};//Tyhjänä ei ajaa tämä eli ei anna mitään.
	};


///////////////
//Assisntatti//
///////////////


	Switch (_Assistantti) do {//!!!! caset pitää olla kaikki pienellä!!!!!

		case "hat": { //NLAW, JAVELIN (Ylipäätänsä ohjuspohjainen)

		};

		case "aa": { //Anti-air

		};

		case "at": { //AT = RPG7, SMAW, MAAWS (Raskaat singot)

		};

		case "ar": { //Kevyet konekiväärit (M249, RPK, M27)

		};

		case "mg": { //Raskaammat konekiväärit (PKM, PKP, M240) Natossa 7.62x51, muilla 7.62x54/53
			//_magazines append [["",10]];
		};

		default {};//Tyhjänä ei ajaa tämä eli ei anna mitään.
	};

	[_unit, _weapons, _magazines, _weaponitems] call _TUN_fnc_addWeaponStuff;

};


_TUN_fnc_changeClothes = { //VAATEFUNCTIO//

	//Kutsuminen [_unit, "puvunvalinta", "liivinvalinta", "repunvalinta"] call _TUN_fnc_changeClothes;
	//Katso vaihtoehdot alempaa case kohdasta. Käytä "" jos haluat defaultin.

	params ["_unit", ["_kypara", ""], ["_puku", ""], ["_liivi", ""], ["_reppu", ""]];

	removeUniform _unit;
    removeVest _unit;
    removeBackpack _unit;
    removeHeadgear _unit;
    removeGoggles _unit;

//////////////////
//Kypäränvalinta//
//////////////////
	switch (_kypara) do {

		case "johtaja": {

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

		default { //Vakio kypärä

		};
	};

////////////////
//Puvunvalinta//
////////////////

	switch (_puku) do {

		case "johtaja": {

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

		default { //Vakio Puku

		};
	};

/////////////////
//Liivinvalinta//
/////////////////
	switch (_liivi) do {

		case "johtaja": {

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

		default { //Vakio liivi

		};
	};

////////////////
//Repunvalinta//
////////////////
	switch (_reppu) do
	{
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

		default { //Vakio reppu

		};
	};
};
/*
//Vaate function muuttujat. _TUN_fnc_changeClothes
_Tun_Kypara = ""; //Kypäränvalinta
_Tun_Puku = ""; //Puvunvalinta
_Tun_Liivi = ""; //Liivinvalinta
_Tun_Reppu = ""; //Repunvalinta

//Ase function muuttuja. _TUN_fnc_changeWeapons
_Tun_Aseistus = ""; //Kiväärin valitna
_Tun_Sinko = ""; //Singon valinta

//Perusvaruste functio muutujat. _TUN_fnc_addBasicEquipment
_Tun_Perustavarat = ""; //perustavaroiden valinta
_Tun_Kiikari = ""; /Kiikarien valinta

//Medikaali varuste functio. _TUN_fnc_addMedicalSupplies
_Tun_Medikaali = "";

*/

//Gearin valinta JV ukoille
if (_unit isKindof "Man") then {
	private ["_Tun_Kypara", "_Tun_Puku", "_Tun_Liivi", "_Tun_Reppu", "_Tun_Aseistus", "_Tun_Sinko", "_Tun_Perustavarat", "_Tun_Kiikari", "_Tun_Medikaali","_Tun_Assistantti"];
	Switch (_type) do {

		////////////
		//Johtajat//
		////////////

		case "cl": { //Komppanin johtaja
			//Vaatteet
			_Tun_Kypara = "johtaja";
			_Tun_Puku = "johtaja";
			_Tun_Liivi = "johtaja";
			_Tun_Reppu = "radio";

			//aseet
			_Tun_Aseistus = "";
			_Tun_Sinko = "";
			_Tun_Assistantti = "";

			//varusteet
			_Tun_Perustavarat = "";
			_Tun_Kiikari = "kiikari";
			_Tun_Medikaali = "";
		};

		case "pl": { //Joukkueen johtaja
			//Vaatteet
			_Tun_Kypara = "johtaja";
			_Tun_Puku = "johtaja";
			_Tun_Liivi = "johtaja";
			_Tun_Reppu = "radio";

			//aseet
			_Tun_Aseistus = "";
			_Tun_Sinko = "";
			_Tun_Assistantti = "";

			//varusteet
			_Tun_Perustavarat = "";
			_Tun_Kiikari = "kiikari";
			_Tun_Medikaali = "";
		};

		case "rto": { //Radisti
			//Vaatteet
			_Tun_Kypara = "";
			_Tun_Puku = "";
			_Tun_Liivi = "";
			_Tun_Reppu = "radio";

			//aseet
			_Tun_Aseistus = "";
			_Tun_Sinko = "";
			_Tun_Assistantti = "";

			//varusteet
			_Tun_Perustavarat = "";
			_Tun_Kiikari = "kiikari";
			_Tun_Medikaali = "";
		};

		case "fac": { //Tulenjohtaja/Ilmatulenjohtaja
			//Vaatteet
			_Tun_Kypara = "";
			_Tun_Puku = "";
			_Tun_Liivi = "";
			_Tun_Reppu = "radio";

			//aseet
			_Tun_Aseistus = "";
			_Tun_Sinko = "";
			_Tun_Assistantti = "";

			//varusteet
			_Tun_Perustavarat = "";
			_Tun_Kiikari = "laser";
			_Tun_Medikaali = "";
		};

		case "sl": { //Ryhmän johtaja
			//Vaatteet
			_Tun_Kypara = "sl";
			_Tun_Puku = "sl";
			_Tun_Liivi = "sl";
			_Tun_Reppu = "radio";

			//aseet
			_Tun_Aseistus = "";
			_Tun_Sinko = "";
			_Tun_Assistantti = "";

			//varusteet
			_Tun_Perustavarat = "";
			_Tun_Kiikari = "kiikari";
			_Tun_Medikaali = "";
		};

		case "tl": { // Partion johtaja
			//Vaatteet
			_Tun_Kypara = "tl";
			_Tun_Puku = "tl";
			_Tun_Liivi = "tl";
			_Tun_Reppu = "";

			//aseet
			_Tun_Aseistus = "";
			_Tun_Sinko = "";
			_Tun_Assistantti = "";

			//varusteet
			_Tun_Perustavarat = "";
			_Tun_Kiikari = "kiikari";
			_Tun_Medikaali = "";
		};

		//////////////////
		//Machinegunners//
		//////////////////

		case "mg": {
			//Vaatteet
			_Tun_Kypara = "";
			_Tun_Puku = "";
			_Tun_Liivi = "mg";
			_Tun_Reppu = "mg";

			//aseet
			_Tun_Aseistus = "mg";
			_Tun_Sinko = "";
			_Tun_Assistantti = "";

			//varusteet
			_Tun_Perustavarat = "";
			_Tun_Kiikari = "";
			_Tun_Medikaali = "";
		};

		case "mg1": {
			//Vaatteet
			_Tun_Kypara = "";
			_Tun_Puku = "";
			_Tun_Liivi = "mg";
			_Tun_Reppu = "mg";

			//aseet
			_Tun_Aseistus = "mg1";
			_Tun_Sinko = "";
			_Tun_Assistantti = "";

			//varusteet
			_Tun_Perustavarat = "";
			_Tun_Kiikari = "";
			_Tun_Medikaali = "";
		};

		case "mgas": {
			//Vaatteet
			_Tun_Kypara = "";
			_Tun_Puku = "";
			_Tun_Liivi = "";
			_Tun_Reppu = "";

			//aseet
			_Tun_Aseistus = "";
			_Tun_Sinko = "";
			_Tun_Assistantti = "mg";

			//varusteet
			_Tun_Perustavarat = "";
			_Tun_Kiikari = "kiikari";
			_Tun_Medikaali = "";
		};

		case "mgas1": {
			//Vaatteet
			_Tun_Kypara = "";
			_Tun_Puku = "";
			_Tun_Liivi = "";
			_Tun_Reppu = "";

			//aseet
			_Tun_Aseistus = "";
			_Tun_Sinko = "";
			_Tun_Assistantti = "mg1";

			//varusteet
			_Tun_Perustavarat = "";
			_Tun_Kiikari = "kiikari";
			_Tun_Medikaali = "";
		};

		/////////////////
		//Autoriflemans//
		/////////////////

		case "ar": {
			//Vaatteet
			_Tun_Kypara = "";
			_Tun_Puku = "";
			_Tun_Liivi = "";
			_Tun_Reppu = "";

			//aseet
			_Tun_Aseistus = "ar";
			_Tun_Sinko = "";
			_Tun_Assistantti = "";

			//varusteet
			_Tun_Perustavarat = "";
			_Tun_Kiikari = "";
			_Tun_Medikaali = "";
		};

		case "ar1": {
			//Vaatteet
			_Tun_Kypara = "";
			_Tun_Puku = "";
			_Tun_Liivi = "";
			_Tun_Reppu = "";

			//aseet
			_Tun_Aseistus = "ar1";
			_Tun_Sinko = "";
			_Tun_Assistantti = "";

			//varusteet
			_Tun_Perustavarat = "";
			_Tun_Kiikari = "";
			_Tun_Medikaali = "";
		};

		case "aras": {
			//Vaatteet
			_Tun_Kypara = "";
			_Tun_Puku = "";
			_Tun_Liivi = "";
			_Tun_Reppu = "";

			//aseet
			_Tun_Aseistus = "";
			_Tun_Sinko = "";
			_Tun_Assistantti = "ar";

			//varusteet
			_Tun_Perustavarat = "";
			_Tun_Kiikari = "kiikari";
			_Tun_Medikaali = "";
		};

		case "aras1": {
			//Vaatteet
			_Tun_Kypara = "";
			_Tun_Puku = "";
			_Tun_Liivi = "";
			_Tun_Reppu = "";

			//aseet
			_Tun_Aseistus = "";
			_Tun_Sinko = "";
			_Tun_Assistantti = "ar1";

			//varusteet
			_Tun_Perustavarat = "";
			_Tun_Kiikari = "kiikari";
			_Tun_Medikaali = "";
		};

		////////////
		//Perus jv//
		////////////

		case "gl": {
			//Vaatteet
			_Tun_Kypara = "";
			_Tun_Puku = "";
			_Tun_Liivi = "";
			_Tun_Reppu = "";

			//aseet
			_Tun_Aseistus = "gl";
			_Tun_Sinko = "";
			_Tun_Assistantti = "";

			//varusteet
			_Tun_Perustavarat = "";
			_Tun_Kiikari = "";
			_Tun_Medikaali = "";
		};

		case "rif": {
			//Vaatteet
			_Tun_Kypara = "";
			_Tun_Puku = "";
			_Tun_Liivi = "";
			_Tun_Reppu = "";

			//aseet
			_Tun_Aseistus = "";
			_Tun_Sinko = "";
			_Tun_Assistantti = "";

			//varusteet
			_Tun_Perustavarat = "";
			_Tun_Kiikari = "";
			_Tun_Medikaali = "";
		};

		///////////
		//Medikit//
		///////////

		case "medic": { //Joukkueen tai isompi.
			//Vaatteet
			_Tun_Kypara = "";
			_Tun_Puku = "";
			_Tun_Liivi = "";
			_Tun_Reppu = "medic";

			//aseet
			_Tun_Aseistus = "";
			_Tun_Sinko = "";
			_Tun_Assistantti = "";

			//varusteet
			_Tun_Perustavarat = "medic";
			_Tun_Kiikari = "";
			_Tun_Medikaali = "medic";
		};

		case "cls": { //Ryhmän medikki
			//Vaatteet
			_Tun_Kypara = "";
			_Tun_Puku = "";
			_Tun_Liivi = "";
			_Tun_Reppu = "medic";

			//aseet
			_Tun_Aseistus = "";
			_Tun_Sinko = "";
			_Tun_Assistantti = "";

			//varusteet
			_Tun_Perustavarat = "medic";
			_Tun_Kiikari = "";
			_Tun_Medikaali = "cls";
		};

		/////////////////////
		//PST & Muut singot//
		/////////////////////

		case "at": { //Raskas Sinko (SMAW,RPG)
			//Vaatteet
			_Tun_Kypara = "";
			_Tun_Puku = "";
			_Tun_Liivi = "";
			_Tun_Reppu = "at";

			//aseet
			_Tun_Aseistus = "";
			_Tun_Sinko = "at";
			_Tun_Assistantti = "";

			//varusteet
			_Tun_Perustavarat = "";
			_Tun_Kiikari = "";
			_Tun_Medikaali = "";
		};

		case "atas": { //Raskaan singon avustaja
			//Vaatteet
			_Tun_Kypara = "";
			_Tun_Puku = "";
			_Tun_Liivi = "";
			_Tun_Reppu = "at";

			//aseet
			_Tun_Aseistus = "";
			_Tun_Sinko = "";
			_Tun_Assistantti = "at";

			//varusteet
			_Tun_Perustavarat = "";
			_Tun_Kiikari = "kiikari";
			_Tun_Medikaali = "";
		};

		case "hat": { //Ohjus AT NLAW, JAVELIN (Ylipäätänsä ohjuspohjainen)
			//Vaatteet
			_Tun_Kypara = "";
			_Tun_Puku = "";
			_Tun_Liivi = "";
			_Tun_Reppu = "";

			//aseet
			_Tun_Aseistus = "";
			_Tun_Sinko = "hat";
			_Tun_Assistantti = "";

			//varusteet
			_Tun_Perustavarat = "";
			_Tun_Kiikari = "";
			_Tun_Medikaali = "";
		};

		case "hatas": { //Ohjus AT assistant
			//Vaatteet
			_Tun_Kypara = "";
			_Tun_Puku = "";
			_Tun_Liivi = "";
			_Tun_Reppu = "";

			//aseet
			_Tun_Aseistus = "";
			_Tun_Sinko = "";
			_Tun_Assistantti = "hat";

			//varusteet
			_Tun_Perustavarat = "";
			_Tun_Kiikari = "kiikari";
			_Tun_Medikaali = "";
			};

		case "rifat": { //KES taistelija
			//Vaatteet
			_Tun_Kypara = "";
			_Tun_Puku = "";
			_Tun_Liivi = "";
			_Tun_Reppu = "";

			//aseet
			_Tun_Aseistus = "";
			_Tun_Sinko = "lat";
			_Tun_Assistantti = "";

			//varusteet
			_Tun_Perustavarat = "";
			_Tun_Kiikari = "";
			_Tun_Medikaali = "";
		};

		case "rifat1": { //KES taistelija
			//Vaatteet
			_Tun_Kypara = "";
			_Tun_Puku = "";
			_Tun_Liivi = "";
			_Tun_Reppu = "";

			//aseet
			_Tun_Aseistus = "";
			_Tun_Sinko = "lat1";
			_Tun_Assistantti = "";

			//varusteet
			_Tun_Perustavarat = "";
			_Tun_Kiikari = "";
			_Tun_Medikaali = "";
		};

		case "aa": { //Anti Air
			//Vaatteet
			_Tun_Kypara = "";
			_Tun_Puku = "";
			_Tun_Liivi = "";
			_Tun_Reppu = "";

			//aseet
			_Tun_Aseistus = "";
			_Tun_Sinko = "aa";
			_Tun_Assistantti = "";

			//varusteet
			_Tun_Perustavarat = "";
			_Tun_Kiikari = "";
			_Tun_Medikaali = "";
		};

		case "aaas": { ////Anti Air Avustaja
			//Vaatteet
			_Tun_Kypara = "";
			_Tun_Puku = "";
			_Tun_Liivi = "";
			_Tun_Reppu = "";

			//aseet
			_Tun_Aseistus = "";
			_Tun_Sinko = "";
			_Tun_Assistantti = "aa";

			//varusteet
			_Tun_Perustavarat = "";
			_Tun_Kiikari = "kiikari";
			_Tun_Medikaali = "";
		};

		//////////////////////
		//Ajoneuvo miehistöt//
		//////////////////////

		case "crewc": { //Vaununjohtaja
			//Vaatteet
			_Tun_Kypara = "crew";
			_Tun_Puku = "crew";
			_Tun_Liivi = "crew";
			_Tun_Reppu = "radio";

			//aseet
			_Tun_Aseistus = "";
			_Tun_Sinko = "";
			_Tun_Assistantti = "";

			//varusteet
			_Tun_Perustavarat = "";
			_Tun_Kiikari = "kiikari";
			_Tun_Medikaali = "";
		};

		case "crew": { //Vaunumiehistö
			//Vaatteet
			_Tun_Kypara = "crew";
			_Tun_Puku = "crew";
			_Tun_Liivi = "crew";
			_Tun_Reppu = "crew";

			//aseet
			_Tun_Aseistus = "";
			_Tun_Sinko = "";
			_Tun_Assistantti = "";

			//varusteet
			_Tun_Perustavarat = "";
			_Tun_Kiikari = "";
			_Tun_Medikaali = "";
		};

		case "heli": { //Helikoperi
			//Vaatteet
			_Tun_Kypara = "";
			_Tun_Puku = "";
			_Tun_Liivi = "";
			_Tun_Reppu = "";

			//aseet
			_Tun_Aseistus = "";
			_Tun_Sinko = "";
			_Tun_Assistantti = "";

			//varusteet
			_Tun_Perustavarat = "";
			_Tun_Kiikari = "";
			_Tun_Medikaali = "";
		};

		case "pilot": { //Pilotti
			//Vaatteet
			_Tun_Kypara = "";
			_Tun_Puku = "";
			_Tun_Liivi = "";
			_Tun_Reppu = "";

			//aseet
			_Tun_Aseistus = "";
			_Tun_Sinko = "";
			_Tun_Assistantti = "";

			//varusteet
			_Tun_Perustavarat = "";
			_Tun_Kiikari = "";
			_Tun_Medikaali = "";
		};

		/////////////////////////
		//Sniperit & Marksmanit//
		/////////////////////////

		case "sniper": {
			//Vaatteet
			_Tun_Kypara = "";
			_Tun_Puku = "";
			_Tun_Liivi = "";
			_Tun_Reppu = "";

			//aseet
			_Tun_Aseistus = "sniper";
			_Tun_Sinko = "";
			_Tun_Assistantti = "";

			//varusteet
			_Tun_Perustavarat = "";
			_Tun_Kiikari = "";
			_Tun_Medikaali = "";
		};

		case "sniper1": {
			//Vaatteet
			_Tun_Kypara = "";
			_Tun_Puku = "";
			_Tun_Liivi = "";
			_Tun_Reppu = "";

			//aseet
			_Tun_Aseistus = "sniper1";
			_Tun_Sinko = "";
			_Tun_Assistantti = "";

			//varusteet
			_Tun_Perustavarat = "";
			_Tun_Kiikari = "";
			_Tun_Medikaali = "";
		};

		case "spotter": {
			//Vaatteet
			_Tun_Kypara = "";
			_Tun_Puku = "";
			_Tun_Liivi = "";
			_Tun_Reppu = "";

			//aseet
			_Tun_Aseistus = "";
			_Tun_Sinko = "";
			_Tun_Assistantti = "";

			//varusteet
			_Tun_Perustavarat = "";
			_Tun_Kiikari = "";
			_Tun_Medikaali = "";
		};

		case "mark": {
			//Vaatteet
			_Tun_Kypara = "";
			_Tun_Puku = "";
			_Tun_Liivi = "";
			_Tun_Reppu = "";

			//aseet
			_Tun_Aseistus = "mark";
			_Tun_Sinko = "";
			_Tun_Assistantti = "";

			//varusteet
			_Tun_Perustavarat = "";
			_Tun_Kiikari = "";
			_Tun_Medikaali = "";
		};

		case "mark1": {
			//Vaatteet
			_Tun_Kypara = "";
			_Tun_Puku = "";
			_Tun_Liivi = "";
			_Tun_Reppu = "";

			//aseet
			_Tun_Aseistus = "mark1";
			_Tun_Sinko = "";
			_Tun_Assistantti = "";

			//varusteet
			_Tun_Perustavarat = "";
			_Tun_Kiikari = "";
			_Tun_Medikaali = "";
		};

		////////////
		//Engineer//
		////////////

		case "eng": { //Pioneeri (Räjähteet, miinaharava tms)
			_unit setVariable ["ACE_IsEngineer",true,true];
			_unit setVariable ["ACE_isEOD",true,true];

			//Vaatteet
			_Tun_Kypara = "";
			_Tun_Puku = "";
			_Tun_Liivi = "";
			_Tun_Reppu = "";

			//aseet
			_Tun_Aseistus = "";
			_Tun_Sinko = "";
			_Tun_Assistantti = "";

			//varusteet
			_Tun_Perustavarat = "engineer";
			_Tun_Kiikari = "";
			_Tun_Medikaali = "";
		};

		case "exp": { //Räjähde expertti. Isoja räjähteitä / IED
			_unit setVariable ["ACE_isEOD",true,true];

			//Vaatteet
			_Tun_Kypara = "";
			_Tun_Puku = "";
			_Tun_Liivi = "";
			_Tun_Reppu = "";

			//aseet
			_Tun_Aseistus = "";
			_Tun_Sinko = "";
			_Tun_Assistantti = "";

			//varusteet
			_Tun_Perustavarat = "explosive";
			_Tun_Kiikari = "";
			_Tun_Medikaali = "";
		};

		case "breach": { //Kevyesti räjähteitä, haulikko tms
			_unit setVariable ["ACE_isEOD",true,true];

			//Vaatteet
			_Tun_Kypara = "";
			_Tun_Puku = "";
			_Tun_Liivi = "";
			_Tun_Reppu = "";

			//aseet
			_Tun_Aseistus = "";
			_Tun_Sinko = "";
			_Tun_Assistantti = "";

			//varusteet
			_Tun_Perustavarat = "breach";
			_Tun_Kiikari = "";
			_Tun_Medikaali = "";
		};

		default {
			removeUniform _unit;
		    removeVest _unit;
		    removeBackpack _unit;
		    removeHeadgear _unit;
		    removeGoggles _unit;
		};
	};

	//Kutsutaan varustefunctiot yksikölle.
	[_unit, _Tun_Kypara, _Tun_Puku, _Tun_Liivi, _Tun_Reppu] call _TUN_fnc_changeClothes;
	[_unit, _Tun_Aseistus, _Tun_Sinko, _Tun_Assistantti] call _TUN_fnc_changeWeapons;
	[_unit, _Tun_Medikaali] call _TUN_fnc_addMedicalSupplies;
	[_unit, _Tun_Perustavarat, _Tun_Kiikari] call _TUN_fnc_addBasicEquipment;
} else {
	/////////////////////////
	//Ajoneuvot ja Laatikot//
	/////////////////////////

	if (_unit isKindof "LandVehicle" || _unit isKindof "Air" || _unit isKindOf "Ship" || _unit isKindOf "Static" || _unit isKindOf "thing") then {
		Switch (_type) do {

			case "auto": { //perus
				_unit addMagazineCargoGlobal ["", 6];
				_unit addMagazineCargoGlobal ["",2];
				_unit addItemCargoGlobal ["ACE_wirecutter",2];
				_unit addItemCargoGlobal ["ACE_bodyBag",10];
				_unit addItemCargoGlobal ["ACE_bloodIV",5];
				_unit addItemCargoGlobal ["ACE_EntrenchingTool",3];
				_unit addItemCargoGlobal ["ACE_Sandbag_empty",50];
			};

			case "laatikko": { //perus
				_unit addMagazineCargoGlobal ["", 6];
				_unit addMagazineCargoGlobal ["",2];
				_unit addItemCargoGlobal ["ACE_wirecutter",2];
				_unit addItemCargoGlobal ["ACE_bodyBag",10];
				_unit addItemCargoGlobal ["ACE_bloodIV",5];
				_unit addItemCargoGlobal ["ACE_Sandbag_empty",50];
				_unit setVariable ["displayName", "Random Nimi tähän", true];
			};

			case "rekka": { //perus
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