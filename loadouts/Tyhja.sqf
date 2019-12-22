/* ----------------------------------------------------------------------------
Description:
    Geariscirpti
Parameters:
    _type
    _unit
Returns:
    Ei mitään
Examples:
    ["Sl", this] call compile preprocessFileLineNumbers "loadouts\Tyhja.sqf";
Author:
    Alkuperäinen Bummeri
    Modifioinut Tuntematon
Scipti Versio:
    v2
    12.11.2018
---------------------------------------------------------------------------- */
params ["_type","_unit"];

if (!(local _unit)) exitwith {}; // Todella tärkeä. Estää skriptin pyörimisen ei locaaleilla uniteilla

private ["_OrbatinSide", "_Radioit", "_Nightvision", "_VaadittuFunctio_versio", "_GeariFunctiot_Versio", "_thermalit", "_Optiikka", "_Silencer"];

/////////////////////////
////////ASETUKSET////////
/////////////////////////
//Vaadittava gearifunctio versio
_VaadittuFunctio_versio = 4;

//Geariscriptin polku
_gearscript_path = "loadouts\Tyhja.sqf";

//Orbatin osapuoli "east", "west" , "guer"
_OrbatinSide = "east";

//Lyhyet radiot kaikille. true/false
_Radioit = true;

//Onko ajoneuvoissa thermalit
_Thermalit = false;

//Onko NVG kaikilla. true/false
_Nightvision = false;

//Onko zoomaavaa optiikkaa
_Optiikka = false;

//Onko zoomaavaa optiikkaa
_Silencer = false;

//Lisää tähän haluttu NVG classname "ACE_NVG_Gen4"
_item_NV = "ACE_NVG_Gen4";

#include "GeariFunctiot.sqf"
//Muokkaa tätä vastaamaan vaadittavaa gearifunctio tiedostoa
if (_GeariFunctiot_Versio == _VaadittuFunctio_versio) then {player sideChat "Geariscripti vaatii udemman gearifunctiot.sqf"};

/////////////////////////
////////ASETUKSET////////
/////////////////////////



_fnc_TUNaddBasicEquipment = { //PerusTavaroiden functio//
	//Params [_unit, varusteet, kiikarit] call _fnc_TUNaddBasicEquipment;

	params ["_unit", ["_mode", ""], ["_kiikarit", ""]];
	private ["_tavarat"];
	Switch toLower (_mode) do {

		Case toLower "johtaja": {
			_tavarat = [["SmokeShell",2], ["SmokeShellGreen",2], ["HandGrenade",1]]; //Tässä voit muutta mitä perus tavaroita annetaan
		};

		Case toLower "VaraJohtaja": {
			_tavarat = [["SmokeShell",2], ["SmokeShellGreen",2], ["HandGrenade",1]];
		};

		Case toLower "kevyt": {
			_tavarat = [["SmokeShell",1],["HandGrenade",1]];
		};

		Case toLower "Engineer": {
			_tavarat = [["SmokeShell",4],["HandGrenade",1],["ACE_DefusalKit",1],["ACE_Clacker",1],["ToolKit",1],["ACE_wirecutter",1],["DemoCharge_Remote_Mag",3],["SatchelCharge_Remote_Mag",0]];
		};

		Case toLower "Explosive": {
			_tavarat = [["SmokeShell",2],["HandGrenade",1]];
		};

		Case toLower "Breach": {
			_tavarat = [["SmokeShell",2],["HandGrenade",1],["ACE_DefusalKit",1],["ACE_Clacker",1],["DemoCharge_Remote_Mag",2]];
		};

		Case toLower "Medic": {
			_tavarat = [["SmokeShell",6],["HandGrenade",1]];
		};


		default { //Vakio romut
			_tavarat = [["SmokeShell",2],["HandGrenade",1]];
		};
	};

	//Annetaan valitut tavarat
	[_unit, _tavarat] Call _fnc_TUNaddmagazines;

	Switch toLower (_kiikarit) do {
		Case toLower "kiikari": {
			_unit addWeapon "Binocular";
		};

		Case toLower "range": {
			_unit addWeapon "ACE_Vector";
		};

		Case toLower "laser": {
			_unit addWeapon "Laserdesignator";
			_unit addItem "Laserbatteries";
		};
		default {};
	};
};



_fnc_BUMaddMedicalSupplies = {
	//Params [unit, mode] call _fnc_BUMaddMedicalSupplies;
	params ["_unit", ["_mode", " "]];
	private ["_supplies"];

	Switch (toLower(_mode)) do {

		Case toLower "cls": {
			_unit setVariable ["Ace_medical_medicClass", 1]; //Asettaa ace medikin tason
			_supplies = [["ACE_adenosine",1],["ACE_morphine",12],["ACE_epinephrine",8],["ACE_elasticBandage",15],["adv_aceSplint_splint",12],["ACE_tourniquet",6],["ACE_bloodIV",8]]; //Tässä voit muutta mitä medicaali tavaroita kukin saa.
		};

		Case toLower "medic": {
			_unit setVariable ["Ace_medical_medicClass", 2];//Asettaa ace medikin tason
			_supplies = [["ACE_adenosine",1],["ACE_morphine",12],["ACE_epinephrine",8],["ACE_elasticBandage",15],["adv_aceSplint_splint",12],["ACE_tourniquet",6],["ACE_bloodIV",8]]; //Tässä voit muutta mitä medicaali tavaroita kukin saa.
		};

		default {
			_unit setVariable ["Ace_medical_medicClass", 0];//Asettaa ace medikin tason
			_supplies = [["ACE_elasticBandage",4],["ACE_tourniquet",2],["ACE_morphine",1]]; //Tässä voit muutta mitä medicaali tavaroita kukin saa.
		};
	};

	[_unit, _supplies] Call _fnc_TUNaddmagazines;
};


_fnc_TUNchangeWeapons = { //ASEFUNCTIO//


	//Kutsuminen [_unit, "ase", "sinko"] call _fnc_TUNchangeWeapons;
	private [ "_weapons", "_magazines","_weaponitems", "_suujarru", "_ase", "_tahtain"];
	params ["_unit",["_weapon", ""],["_Singonvalinta", ""],["_Assistantti", ""]];
	_weapons = [];
	_magazines = [];
	_weaponitems = [];


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

	Switch toLower (_weapon) do {


		////////////
		//Kiväärit//
		////////////

		case toLower "Rif": { //Rynnäkkökivääri optiikalla
			_ase = selectRandom ["clasname","clasname"]; //jos radom ase. Käytä tätä. Jos ei, poista/kommentoi tämä rivi.
			_ase = "className"; //Käytä tätä jos ei aseen randomointia. Muuten poista/kommentoi tämä rivi.

			//if lauseen pitää poistaa jos valintaa ei ole. Jos toinen vaihtoehto on ei mitään, laita arvoksi ""
			if (_Optiikka) then {
				_tahtain = "zoomaava optiikan clasname";
			} else {
				_tahtain = "EI zoomaava optiikan clasname";
			};

			//if lauseen pitää poistaa jos valintaa ei ole. Jos toinen vaihtoehto on ei mitään, laita arvoksi ""
			if (_Silencer) then {
				_suujarru = "silencer className";
			} else {
				_suujarru = "EI silencer className";
			};

			_weapons append [_ase, "classname"];
			_magazines append [["lipas1",lippaidenmäärä],["rhs_30Rnd_545x39_AK_green",3]];
			_weaponitems append [["classname","primary/handgun/secondary"],[_suujarru,"primary"],[_tahtain,"primary"]];
		};

		case toLower "Rif1": { //Rynnäkkökivääri

		};

		case toLower "Rif2": { //Rynnäkkökivääri

		};

		case toLower "GL": { //Heittimen sisältävät rynnäkkökiväärit

		};


		//////
		//MG//
		//////

		case toLower "MG": { //Raskaammat konekiväärit (PKM, PKP, M240) Natossa 7.62x51, muilla 7.62x54/53

		};

		case toLower "MG1": { //Raskaammat konekiväärit (PKM, PKP, M240) Natossa 7.62x51, muilla 7.62x54/53

		};

		//////
		//AR//
		//////

		case toLower "AR": { //Kevyet konekiväärit (M249, RPK, M27)

		};

		case toLower "Ar1": { //Kevyet konekiväärit (M249, RPK, M27)

		};


		//////////////////
		//Sniper & Marks//
		//////////////////

		case toLower "Mark": { //Marksman eli ryhmätason puoliautomaatti tukiase (MK11, SVD, AK+PSO, VSS Vintorez) Myös spottereiden ase

		};

		case toLower "Mark1": { //Marksman eli ryhmätason puoliautomaatti tukiase (MK11, SVD, AK+PSO, VSS Vintorez) Myös spottereiden ase

		};

		case toLower "Sniper": { //Tarkkuuskivääri

		};

		case toLower "Sniper1": { //Tarkkuuskivääri

		};

		////////////////
		//Pienet aseet//
		////////////////
		case toLower "SMG": { //Erikoiset johtajat, mahd. vaunumiehistöt, pilotit

		};

		case toLower "Carbine": { //Erikoiset johtajat, mahd. vaunumiehistöt, pilotit

		};

		case toLower "Pistol": { //Erikoiset johtajat, mahd. vaunumiehistöt, pilotit

		};

		case toLower "Shotgun": { //Pääaseena haulikko. Eli Engineer T:Tuntematon

		};

		default {};
	};

/////////////////
//SingonValinta//
/////////////////
	Switch toLower (_Singonvalinta) do {

		Case toLower "AT": { //AT = RPG7, SMAW, MAAWS (Raskaat singot)
			_weapons append ["rhs_weap_rpg7"];
			_magazines append [["rhs_rpg7_PG7VL_mag",3]];
			//_weaponitems append [];
		};

		Case toLower "LAT": { //kevyt kertasinko (M72, RPG26, M136)

		};

		Case toLower "LAT1": { //kevyt kertasinko (M72, RPG26, M136)

		};

		Case toLower "AA": { //Anti-air

		};

		Case toLower "AAAS": { //Anti-air

		};

		Case toLower "HAT": { //NLAW, JAVELIN (Ylipäätänsä ohjuspohjainen)

		};

		Case toLower "HATAS": { //NLAW, JAVELIN (Ylipäätänsä ohjuspohjainen)

		};

		default {};//Tyhjänä ei ajaa tämä eli ei anna mitään.
	};


///////////////
//Assisntatti//
///////////////

	Switch toLower (_Assistantti) do {

		Case toLower "HAT": { //NLAW, JAVELIN (Ylipäätänsä ohjuspohjainen)

		};

		Case toLower "AA": { //Anti-air

		};

		Case toLower "AT": { //AT = RPG7, SMAW, MAAWS (Raskaat singot)

		};

		case toLower "AR": { //Kevyet konekiväärit (M249, RPK, M27)
			_magazines append [["rhsusf_100Rnd_556x45_soft_pouch",4]];
		};

		case toLower "MG": { //Raskaammat konekiväärit (PKM, PKP, M240) Natossa 7.62x51, muilla 7.62x54/53
			_magazines append [["rhsusf_50Rnd_762x51",10]];
		};

		default {};//Tyhjänä ei ajaa tämä eli ei anna mitään.
	};


	if (count _weapons > 0) then {
		[_unit, _weapons] Call _fnc_BUMaddweapons;
	};

	if (count _magazines > 0) then {
		[_unit, _magazines] Call _fnc_TUNaddmagazines;
	};

	if (count _weaponitems > 0) then {
		[_unit, _weaponitems] Call fnc_TUNaddWeaponItem;
	};
};


_fnc_TUNchangeClothes = { //VAATEFUNCTIO//

	//Kutsuminen [_unit, "puvunvalinta", "liivinvalinta", "repunvalinta"] call _fnc_TUNchangeClothes;
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
	switch toLower (_kypara) do {

		Case toLower "Johtaja": {

		};

		Case toLower "Sl": {

		};

		Case toLower "RTO": {

		};

		Case toLower "Medic": {

		};

		Case toLower "Tl": {

		};

		Case toLower "Crew": {

		};

		Case toLower "Pilot": {

		};

		default { //Vakio kypärä

		};
	};

////////////////
//Puvunvalinta//
////////////////

	switch toLower (_puku) do {

		Case toLower "Johtaja": {
					};

		Case toLower "Sl": {

		};

		Case toLower "Tl": {

		};

		Case toLower "RTO": {

		};

		Case toLower "Crew": {

		};

		Case toLower "Pilot": {

		};

		default { //Vakio Puku

		};
	};


/////////////////
//Liivinvalinta//
/////////////////
	switch toLower (_liivi) do {

		Case toLower "Johtaja": {

		};

		Case toLower "Sl": {

		};

		Case toLower "Tl": {

		};

		Case toLower "Medic": {

		};

		Case toLower "Mg": {

		};

		Case toLower "At": {

		};

		Case toLower "RTO": {

		};

		Case toLower "Crew": {

		};

		Case toLower "Pilot": {

		};

		default { //Vakio liivi

		};
	};

////////////////
//Repunvalinta//
////////////////
	switch toLower (_reppu) do
	{
		Case toLower "Radio": {

		};

		Case toLower "Medic": {

		};

		Case toLower "AT": {

		};

		Case toLower "Pienireppu": {

		};

		Case toLower "Mg": {

		};

		Case toLower "Engineer": {

		};

		default { //Vakio reppu

		};
	};
};
/*
//Vaate function muuttujat. _fnc_TUNchangeClothes
_Tun_Kypara = ""; //Kypäränvalinta
_Tun_Puku = ""; //Puvunvalinta
_Tun_Liivi = ""; //Liivinvalinta
_Tun_Reppu = ""; //Repunvalinta

//Ase function muuttuja. _fnc_TUNchangeWeapons
_Tun_Aseistus = ""; //Kiväärin valitna
_Tun_Sinko = ""; //Singon valinta

//Perusvaruste functio muutujat. _fnc_TUNaddBasicEquipment
_Tun_Perustavarat = ""; //perustavaroiden valinta
_Tun_Kiikari = ""; /Kiikarien valinta

//Medikaali varuste functio. _fnc_BUMaddMedicalSupplies
_Tun_Medikaali = "";

*/

//Gearin valinta JV ukoille
if (_unit isKindof "Man") then {
	private ["_Tun_Kypara", "_Tun_Puku", "_Tun_Liivi", "_Tun_Reppu", "_Tun_Aseistus", "_Tun_Sinko", "_Tun_Perustavarat", "_Tun_Kiikari", "_Tun_Medikaali","_Tun_Assistantti"];
	Switch toLower(_type) do {

		////////////
		//Johtajat//
		////////////

		Case toLower "CL": { //Komppanin johtaja
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

		Case toLower "PL": { //Joukkueen johtaja
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

		Case toLower "RTO": { //Radisti
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

		Case toLower "FAC": { //Tulenjohtaja/Ilmatulenjohtaja
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

		Case toLower "SL": { //Ryhmän johtaja
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

		Case toLower "TL": { // Partion johtaja
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

		//////////////////
		//Machinegunners//
		//////////////////

		Case toLower "MG": {
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

		Case toLower "MG1": {
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

		Case toLower "MGAS": {
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

		Case toLower "MGAS1": {
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

		/////////////////
		//Autoriflemans//
		/////////////////

		Case toLower "AR": {
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

		Case toLower "AR1": {
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

		Case toLower "ArAS": {
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

		Case toLower "ARAS1": {
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

		////////////
		//Perus jv//
		////////////

		Case toLower "GL": {
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

		Case toLower "Rif": {
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

		Case toLower "Medic": { //Joukkueen tai isompi.
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

		Case toLower "CLS": { //Ryhmän medikki
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

		/////////////////////
		//PST & Muut singot//
		/////////////////////

		Case toLower "AT": { //Raskas Sinko (SMAW,RPG)
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

		Case toLower "ATAS": { //Raskaan singon avustaja
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

		Case toLower "HAT": { //Ohjus AT NLAW, JAVELIN (Ylipäätänsä ohjuspohjainen)
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

		Case toLower "HATAS": { //Ohjus AT assistant
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

		Case toLower "RifAT": { //KES taistelija
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

		Case toLower "RifAT1": { //KES taistelija
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

		Case toLower "AA": { //Anti Air
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

		Case toLower "AAAS": { ////Anti Air Avustaja
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

		//////////////////////
		//Ajoneuvo miehistöt//
		//////////////////////

		Case toLower "CrewL": { //Vaununjohtaja
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

		Case toLower "Crew": { //Vaunumiehistö
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

		Case toLower "Heli": { //Helikoperi
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

		Case toLower "Pilot": { //Pilotti
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

		Case toLower "Sniper": {
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

		Case toLower "Sniper1": {
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

		Case toLower "Spotter": {
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

		Case toLower "Mark": {
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

		Case toLower "Mark1": {
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

		////////////
		//Engineer//
		////////////

		Case toLower "Eng": { //Pioneeri (Räjähteet, miinaharava tms)
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
			_Tun_Perustavarat = "";
			_Tun_Kiikari = "";
			_Tun_Medikaali = "";
		};

		Case toLower "Exp": { //Räjähde expertti. Isoja räjähteitä / IED
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
			_Tun_Perustavarat = "";
			_Tun_Kiikari = "";
			_Tun_Medikaali = "";
		};

		Case toLower "Breach": { //Kevyesti räjähteitä, haulikko tms
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
			_Tun_Perustavarat = "";
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
	[_unit, _Tun_Kypara, _Tun_Puku, _Tun_Liivi, _Tun_Reppu] call _fnc_TUNchangeClothes;
	[_unit, _Tun_Aseistus, _Tun_Sinko, _Tun_Assistantti] call _fnc_TUNchangeWeapons;
	[_unit, _Tun_Medikaali] Call _fnc_BUMaddMedicalSupplies;
	[_unit, _Tun_Perustavarat, _Tun_Kiikari] call _fnc_TUNaddBasicEquipment;
};





	/////////////////////////
	//Ajoneuvot ja Laatikot//
	/////////////////////////

if (_unit isKindof "LandVehicle" || _unit isKindof "Air" || _unit isKindOf "Ship" || _unit isKindOf "Static" || _unit isKindOf "thing") then {
	Switch toLower(_type) do {

		Case toLower "Auto": { //perus
			_unit addMagazineCargoGlobal ["rhs_30Rnd_545x39_7N10_AK", 6];
			_unit addMagazineCargoGlobal ["rhs_100Rnd_762x54mmR",2];
			_unit addItemCargoGlobal ["ACE_wirecutter",2];
			_unit addItemCargoGlobal ["ACE_bodyBag",10];
			_unit addItemCargoGlobal ["ACE_bloodIV",5];
			_unit addItemCargoGlobal ["ACE_EntrenchingTool",3];
			_unit addItemCargoGlobal ["ACE_Sandbag_empty",50];
		};

		Case toLower "Laatikko": { //perus
			_unit addMagazineCargoGlobal ["rhs_30Rnd_545x39_7N10_AK", 6];
			_unit addMagazineCargoGlobal ["rhs_100Rnd_762x54mmR",2];
			_unit addItemCargoGlobal ["ACE_wirecutter",2];
			_unit addItemCargoGlobal ["ACE_bodyBag",10];
			_unit addItemCargoGlobal ["ACE_bloodIV",5];
			_unit addItemCargoGlobal ["ACE_Sandbag_empty",50];
		};

		Case toLower "Rekka": { //perus
			_unit addMagazineCargoGlobal ["rhs_30Rnd_545x39_7N10_AK", 6];
			_unit addMagazineCargoGlobal ["rhs_100Rnd_762x54mmR",2];
			_unit addItemCargoGlobal ["ACE_wirecutter",2];
			_unit addItemCargoGlobal ["ACE_bodyBag",10];
			_unit addItemCargoGlobal ["ACE_bloodIV",5];
			_unit addItemCargoGlobal ["ACE_EntrenchingTool",3];
			_unit addItemCargoGlobal ["ACE_Sandbag_empty",50];
		};

		default{};
	};
};
