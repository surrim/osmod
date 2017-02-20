/* Copyright 2009-2017 surrim
 *
 * This file is part of OSMod.
 *
 * OSMod is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * OSMod is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with OSMod.  If not, see <http://www.gnu.org/licenses/>.
 */

player "TD Bot"{
	consts{
		MAX_UNITS=20;

		/** UD/TD **/
		//chassis
		MAMMOTH=1;
		TIGER=2;
		SPIDER=3;
		TARANTULA=4;
		PANTHER=5;
		GRIZZLY=6;
		JAGUAR=7;
		SALAMANDER=8;
		LYNX=9;
		CENTIPEDE=10;
		CENTIPEDE2=11;
		UCSMINELAYER=12;
		HARVESTER=13;
		OBSERVER=14;
		GARGOIL=15;
		MANTICORE=16;
		BAT=17;
		DRAGON=18;
		UCSTRANSPORTER=19;
		FLYINGHARVESTER=20;
		CONDOR=21;
		GRUZ=22;
		PAMIR=23;
		DON=24;
		TAIGA=25;
		SIBIRIA=26;
		KAUKASUS=27;
		RASPUTIN=28;
		URAL=29;
		GOLIATH=30;
		GOLIATH2=31;
		STEALTH=32;
		KATYUSHA=33;
		SPION=34;
		EDMINELAYER=35;
		ALTAI=36;
		KOZAK=37;
		ATAMAN=38;
		ODIN=39;
		THOR=40;
		HAN=41;
		EDTRANSPORTER=42;
		BOJAR=43;
		TUNNELDIGGER=44;
		LUNAR=45;
		MOON=46;
		NEWHOPE=47;
		FATGIRL=48;
		CRATER=49;
		FANG=50;
		CRUSHER=51;
		CRION=52;
		CHARON=53;
		PLUTO=54;
		PLUTO2=55;
		PHOBOS=56;
		METEOR=57;
		SUPERFIGHTER=58;
		THUNDERER=59;
		STORM=60;
		LCTRANSPORTER=61;
		LCSUPPLIER=62;

		//weapons
		EDAACANNON=1;
		EDAALASER=2;
		EDAIRCARRIER=3;
		EDANTIROCKET=4;
		EDARTILLERY=5;
		EDBANNER=6;
		EDBANNER2=7;
		EDBIGBANNER=8;
		EDBOMBERBOMB=9;
		EDBOMBERROCKET=10;
		EDCANNON=11;
		EDCARRIER=12;
		EDEARTHQUAKE=13;
		EDHERO2CANNON=14;
		EDHERO2EARTHQUAKE=15;
		EDHERO2GRENADE=16;
		EDHERO2IONDESTROYER=17;
		EDHERO2LASER=18;
		EDHERO2LRCANNON=19;
		EDHERO2LRLASER=20;
		EDHERO2NUKE=21;
		EDHERO2ROCKET=22;
		EDHERO2SHOCKWAVE=23;
		EDIONDESTROYER=24;
		EDLASER=25;
		EDLRCANNON=26;
		EDLRLASER=27;
		EDNUKE=28;
		EDODINLASER=29;
		EDODINROCKET=30;
		EDPAMIRCANNON=31;
		EDPAMIRLASER=32;
		EDPAMIRROCKET=33;
		EDPAMIRSHOCKWAVE=34;
		EDREPAIR=35;
		EDROCKET=36;
		EDSCREAMER=37;
		EDSCREAMER2=38;
		EDSHOCKWAVE=39;
		EDSMALLAIRAACANNON=40;
		EDSMALLAIRAALASER=41;
		EDSMALLAIRLASER=42;
		EDSMALLAIRMG=43;
		EDSMALLAIRROCKET=44;
		EDSMALLION=45;
		EDSMALLLASER=46;
		EDSMALLMG=47;
		EDSMALLROCKET=48;
		EDSMALLSHOCKWAVE=49;
		EDSTALINORGEL=50;
		EDTRANSPORTERHOOK=51;
		LCAIRELECTRO=52;
		LCAIRROCKET=53;
		LCAIRSONIC=54;
		LCANTIROCKET=55;
		LCBANNER=56;
		LCBANNER2=57;
		LCBIGBANNER=58;
		LCCRATERDETECTOR=59;
		LCCRATERREGENERATOR=60;
		LCCRATERSHIELDREGENERATOR=61;
		LCDETECTOR=62;
		LCEARTHQUAKE=63;
		LCELECTRO=64;
		LCHERO2EARTHQUAKE=65;
		LCHERO2ELECTRO=66;
		LCHERO2PLASMA=67;
		LCHERO2RAILGUN=68;
		LCHERO2ROCKET=69;
		LCHERO2SONIC=70;
		LCLIGHTNING=71;
		LCLUNARDETECTOR=72;
		LCLUNARREGENERATOR=73;
		LCLUNARSHIELDREGENERATOR=74;
		LCPLASMA=75;
		LCPLASMACANNON=76;
		LCRAILGUN=77;
		LCREGENERATOR=78;
		LCROCKET=79;
		LCSHIELDREGENERATOR=80;
		LCSMALLAAPLASMA=81;
		LCSMALLAARAILGUN=82;
		LCSMALLAIRAAPLASMA=83;
		LCSMALLAIRAARAILGUN=84;
		LCSMALLAIRELECTRO=85;
		LCSMALLAIRMG=86;
		LCSMALLAIRROCKET=87;
		LCSMALLELECTRO=88;
		LCSMALLMG=89;
		LCSMALLPLASMA=90;
		LCSMALLRAILGUN=91;
		LCSMALLROCKET=92;
		LCSMALLSONIC=93;
		LCSONIC=94;
		LCTRANSPORTERHOOK=95;
		UCSAAMINIGUN=96;
		UCSAAPLASMA=97;
		UCSAIRAAMINIGUN=98;
		UCSAIRMINIGUN=99;
		UCSAIRNAPALMBOMB=100;
		UCSAIRPLASMABOMB=101;
		UCSAIRROCKET=102;
		UCSANTIROCKET=103;
		UCSBANNER=104;
		UCSBIGBANNER=105;
		UCSCANNON=106;
		UCSCANNONARTILLERY=107;
		UCSFLAMETHROWER=108;
		UCSGRENADE=109;
		UCSHERO2CANNON=110;
		UCSHERO2EARTHQUAKE=111;
		UCSHERO2FLAMETHROWER=112;
		UCSHERO2GRENADE=113;
		UCSHERO2MINIGUN=114;
		UCSHERO2PLASMA=115;
		UCSHERO2ROCKET=116;
		UCSHERO2SMALLROCKET=117;
		UCSMECHCANNON=118;
		UCSMECHEARTHQUAKE=119;
		UCSMECHFLAMETHROWER=120;
		UCSMECHGRENADE=121;
		UCSMECHMINIGUN=122;
		UCSMECHPLASMA=123;
		UCSMECHROCKET=124;
		UCSMECHSMALLROCKET=125;
		UCSMINIGUN=126;
		UCSPLASMA=127;
		UCSPLASMAARTILLERY=128;
		UCSRADAR=129;
		UCSREPAIR=130;
		UCSROCKET=131;
		UCSSALAMANDERRADAR=132;
		UCSSALAMANDERSHADOW=133;
		UCSSHADOW=134;
		UCSSMALLAIRAAMINIGUN=135;
		UCSSMALLAIRMG=136;
		UCSSMALLAIRPLASMA=137;
		UCSSMALLAIRROCKET=138;
		UCSSMALLFLAMETHROWER=139;
		UCSSMALLMINIGUN=140;
		UCSSMALLPLASMA=141;
		UCSSMALLROCKET=142;
		UCSTARANTULAROCKET=143;
		UCSTIGERCANNON=144;
		UCSTIGERFLAMETHROWER=145;
		UCSTIGERGRENADE=146;
		UCSTIGERMINIGUN=147;
		UCSTIGERPLASMA=148;
		UCSTIGERROCKET=149;
		UCSTRANSPORTERHOOK=150;
	}

	int nGetRace;
	int nTimer;
	int nMaxDistancePoints;
	int nMinHP;
	int nMaxHP;
	player rEnemy;

	/** TD/UD **/
	int newoneX;
	int newoneY;
	int newoneZ;
	int newoneChassis;
	int newoneWeapon0;
	int newoneWeapon1;
	int newoneWeapon2;
	int newoneWeapon3;
	int newoneTargetX;
	int newoneTargetY;
	int newoneScriptIndex;

	//ed chassis weights
	int wGruz;
	int wPamir;
	int wDon;
	int wTaiga;
	int wSibiria;
	int wKaukasus;
	int wRasputin;
	int wUral;
	int wGoliath;
	int wGoliath2;
	int wStealth;
	int wKatyusha;
	int wSpion;
	int wEDMinelayer;
	int wAltai;
	int wKozak;
	int wAtaman;
	int wOdin;
	int wThor;
	int wHan;
	int wEDTransporter;
	int wBojar;

	//lc chassis weights
	int wTunnelDigger;
	int wLunar;
	int wMoon;
	int wNewHope;
	int wFatGirl;
	int wCrater;
	int wFang;
	int wCrusher;
	int wCrion;
	int wCharon;
	int wPluto;
	int wPluto2;
	int wPhobos;
	int wMeteor;
	int wSuperFighter;
	int wThunderer;
	int wStorm;
	int wLCTransporter;
	int wLCSupplier;

	//ucs chassis weights
	int wMammoth;
	int wTiger;
	int wSpider;
	int wTarantula;
	int wPanther;
	int wGrizzly;
	int wJaguar;
	int wSalamander;
	int wLynx;
	int wCentipede;
	int wCentipede2;
	int wUCSMinelayer;
	int wHarvester;
	int wObserver;
	int wGargoil;
	int wManticore;
	int wBat;
	int wDragon;
	int wUCSTransporter;
	int wFlyingHarvester;
	int wCondor;

	//weapon weights
	int wAACannon;
	int wAALaser;
	int wAAMinigun;
	int wAAPlasma;
	int wAARailgun;

	int wMG;
	int wRocket;
	int wCannon;
	int wLRCannon;
	int wElectro;
	int wSonic;
	int wPlasma;
	int wRailgun;
	int wMinigun;
	int wFlamethrower;
	int wLaser;
	int wGrenade;
	int wEarthquake;
	int wLRLaser;
	int wShockwave;
	int wIonDestroyer;
	int wIon;

	int wPlasmaBomb;
	int wNapalmBomb;
	int wAtomBomb;

	int wCannonArtillery;
	int wPlasmaCannon;
	int wPlasmaArtillery;
	int wLightning;
	int wStalinOrgel;
	int wNuke;

	int wBanner;
	int wAntirocket;
	int wDetector;
	int wShieldRegenerator;
	int wRegenerator;
	int wShadow;
	int wRadar;
	int wScreamer;
	int wRepair;
	int wCarrier;
	int wTransporter;

	/** TD/UD **/
	//some of 6
	function int SomeOf(int w0, int n0, int w1, int n1, int w2, int n2, int w3, int n3, int w4, int n4, int w5, int n5){
		int nRandom;
		int w;
		if(n0==-1){
			w0=0;
		}
		if(n1==-1){
			w1=0;
		}
		if(n2==-1){
			w2=0;
		}
		if(n3==-1){
			w3=0;
		}
		if(n4==-1){
			w4=0;
		}
		if(n5==-1){
			w5=0;
		}

		w=w0+w1+w2+w3+w4+w5;
		if(!w){
			return -1;
		}

		nRandom=Rand(w);
		nRandom=nRandom-w0;
		if(nRandom<0){
			return n0;
		}
		nRandom=nRandom-w1;
		if(nRandom<0){
			return n1;
		}
		nRandom=nRandom-w2;
		if(nRandom<0){
			return n2;
		}
		nRandom=nRandom-w3;
		if(nRandom<0){
			return n3;
		}
		nRandom=nRandom-w4;
		if(nRandom<0){
			return n4;
		}
		return n5;
	}

	//some of 5
	function int SomeOf(int w0, int n0, int w1, int n1, int w2, int n2, int w3, int n3, int w4, int n4){
		return SomeOf(w0, n0, w1, n1, w2, n2, w3, n3, w4, n4, 0, 0);
	}

	//some of 4
	function int SomeOf(int w0, int n0, int w1, int n1, int w2, int n2, int w3, int n3){
		return SomeOf(w0, n0, w1, n1, w2, n2, w3, n3, 0, 0, 0, 0);
	}

	//some of 3
	function int SomeOf(int w0, int n0, int w1, int n1, int w2, int n2){
		return SomeOf(w0, n0, w1, n1, w2, n2, 0, 0, 0, 0, 0, 0);
	}

	//some of 2
	function int SomeOf(int w0, int n0, int w1, int n1){
		return SomeOf(w0, n0, w1, n1, 0, 0, 0, 0, 0, 0, 0, 0);
	}

	//some of 1
	function int SomeOf(int w0, int n0){
		return SomeOf(w0, n0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	}

	//some of 24
	function int SomeOf(int w0, int n0, int w1, int n1, int w2, int n2, int w3, int n3, int w4, int n4, int w5, int n5, int w6, int n6, int w7, int n7, int w8, int n8, int w9, int n9, int w10, int n10, int w11, int n11, int w12, int n12, int w13, int n13, int w14, int n14, int w15, int n15, int w16, int n16, int w17, int n17, int w18, int n18, int w19, int n19, int w20, int n20, int w21, int n21, int w22, int n22, int w23, int n23){
		return SomeOf(
			w0+w1+w2+w3+w4+w5, SomeOf(w0, n0, w1, n1, w2, n2, w3, n3, w4, n4, w5, n5),
			w6+w7+w8+w9+w10+w11, SomeOf(w6, n6, w7, n7, w8, n8, w9, n9, w10, n10, w11, n11),
			w12+w13+w14+w15+w16+w17, SomeOf(w12, n12, w13, n13, w14, n14, w15, n15, w16, n16, w17, n17),
			w18+w19+w20+w21+w22+w23, SomeOf(w18, n18, w19, n19, w20, n20, w21, n21, w22, n22, w23, n23)
		);
	}

	//some of 23
	function int SomeOf(int w0, int n0, int w1, int n1, int w2, int n2, int w3, int n3, int w4, int n4, int w5, int n5, int w6, int n6, int w7, int n7, int w8, int n8, int w9, int n9, int w10, int n10, int w11, int n11, int w12, int n12, int w13, int n13, int w14, int n14, int w15, int n15, int w16, int n16, int w17, int n17, int w18, int n18, int w19, int n19, int w20, int n20, int w21, int n21, int w22, int n22){
		return SomeOf(w0, n0, w1, n1, w2, n2, w3, n3, w4, n4, w5, n5, w6, n6, w7, n7, w8, n8, w9, n9, w10, n10, w11, n11, w12, n12, w13, n13, w14, n14, w15, n15, w16, n16, w17, n17, w18, n18, w19, n19, w20, n20, w21, n21, w22, n22, 0, 0);
	}

	//some of 22
	function int SomeOf(int w0, int n0, int w1, int n1, int w2, int n2, int w3, int n3, int w4, int n4, int w5, int n5, int w6, int n6, int w7, int n7, int w8, int n8, int w9, int n9, int w10, int n10, int w11, int n11, int w12, int n12, int w13, int n13, int w14, int n14, int w15, int n15, int w16, int n16, int w17, int n17, int w18, int n18, int w19, int n19, int w20, int n20, int w21, int n21){
		return SomeOf(w0, n0, w1, n1, w2, n2, w3, n3, w4, n4, w5, n5, w6, n6, w7, n7, w8, n8, w9, n9, w10, n10, w11, n11, w12, n12, w13, n13, w14, n14, w15, n15, w16, n16, w17, n17, w18, n18, w19, n19, w20, n20, w21, n21, 0, 0, 0, 0);
	}

	//some of 21
	function int SomeOf(int w0, int n0, int w1, int n1, int w2, int n2, int w3, int n3, int w4, int n4, int w5, int n5, int w6, int n6, int w7, int n7, int w8, int n8, int w9, int n9, int w10, int n10, int w11, int n11, int w12, int n12, int w13, int n13, int w14, int n14, int w15, int n15, int w16, int n16, int w17, int n17, int w18, int n18, int w19, int n19, int w20, int n20){
		return SomeOf(w0, n0, w1, n1, w2, n2, w3, n3, w4, n4, w5, n5, w6, n6, w7, n7, w8, n8, w9, n9, w10, n10, w11, n11, w12, n12, w13, n13, w14, n14, w15, n15, w16, n16, w17, n17, w18, n18, w19, n19, w20, n20, 0, 0, 0, 0, 0, 0);
	}

	//some of 20
	function int SomeOf(int w0, int n0, int w1, int n1, int w2, int n2, int w3, int n3, int w4, int n4, int w5, int n5, int w6, int n6, int w7, int n7, int w8, int n8, int w9, int n9, int w10, int n10, int w11, int n11, int w12, int n12, int w13, int n13, int w14, int n14, int w15, int n15, int w16, int n16, int w17, int n17, int w18, int n18, int w19, int n19){
		return SomeOf(w0, n0, w1, n1, w2, n2, w3, n3, w4, n4, w5, n5, w6, n6, w7, n7, w8, n8, w9, n9, w10, n10, w11, n11, w12, n12, w13, n13, w14, n14, w15, n15, w16, n16, w17, n17, w18, n18, w19, n19, 0, 0, 0, 0, 0, 0, 0, 0);
	}

	//some of 19
	function int SomeOf(int w0, int n0, int w1, int n1, int w2, int n2, int w3, int n3, int w4, int n4, int w5, int n5, int w6, int n6, int w7, int n7, int w8, int n8, int w9, int n9, int w10, int n10, int w11, int n11, int w12, int n12, int w13, int n13, int w14, int n14, int w15, int n15, int w16, int n16, int w17, int n17, int w18, int n18){
		return SomeOf(w0, n0, w1, n1, w2, n2, w3, n3, w4, n4, w5, n5, w6, n6, w7, n7, w8, n8, w9, n9, w10, n10, w11, n11, w12, n12, w13, n13, w14, n14, w15, n15, w16, n16, w17, n17, w18, n18, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	}

	//some of 18
	function int SomeOf(int w0, int n0, int w1, int n1, int w2, int n2, int w3, int n3, int w4, int n4, int w5, int n5, int w6, int n6, int w7, int n7, int w8, int n8, int w9, int n9, int w10, int n10, int w11, int n11, int w12, int n12, int w13, int n13, int w14, int n14, int w15, int n15, int w16, int n16, int w17, int n17){
		return SomeOf(
			w0+w1+w2+w3+w4+w5, SomeOf(w0, n0, w1, n1, w2, n2, w3, n3, w4, n4, w5, n5),
			w6+w7+w8+w9+w10+w11, SomeOf(w6, n6, w7, n7, w8, n8, w9, n9, w10, n10, w11, n11),
			w12+w13+w14+w15+w16+w17, SomeOf(w12, n12, w13, n13, w14, n14, w15, n15, w16, n16, w17, n17)
		);
	}

	//some of 14
	function int SomeOf(int w0, int n0, int w1, int n1, int w2, int n2, int w3, int n3, int w4, int n4, int w5, int n5, int w6, int n6, int w7, int n7, int w8, int n8, int w9, int n9, int w10, int n10, int w11, int n11, int w12, int n12, int w13, int n13){
		return SomeOf(w0, n0, w1, n1, w2, n2, w3, n3, w4, n4, w5, n5, w6, n6, w7, n7, w8, n8, w9, n9, w10, n10, w11, n11, w12, n12, w13, n13, 0, 0, 0, 0, 0, 0, 0, 0);
	}

	//some of 13
	function int SomeOf(int w0, int n0, int w1, int n1, int w2, int n2, int w3, int n3, int w4, int n4, int w5, int n5, int w6, int n6, int w7, int n7, int w8, int n8, int w9, int n9, int w10, int n10, int w11, int n11, int w12, int n12){
		return SomeOf(w0, n0, w1, n1, w2, n2, w3, n3, w4, n4, w5, n5, w6, n6, w7, n7, w8, n8, w9, n9, w10, n10, w11, n11, w12, n12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	}

	//some of 12
	function int SomeOf(int w0, int n0, int w1, int n1, int w2, int n2, int w3, int n3, int w4, int n4, int w5, int n5, int w6, int n6, int w7, int n7, int w8, int n8, int w9, int n9, int w10, int n10, int w11, int n11){
		return SomeOf(
			w0+w1+w2+w3+w4+w5, SomeOf(w0, n0, w1, n1, w2, n2, w3, n3, w4, n4, w5, n5),
			w6+w7+w8+w9+w10+w11, SomeOf(w6, n6, w7, n7, w8, n8, w9, n9, w10, n10, w11, n11)
		);
	}

	//some of 11
	function int SomeOf(int w0, int n0, int w1, int n1, int w2, int n2, int w3, int n3, int w4, int n4, int w5, int n5, int w6, int n6, int w7, int n7, int w8, int n8, int w9, int n9, int w10, int n10){
		return SomeOf(w0, n0, w1, n1, w2, n2, w3, n3, w4, n4, w5, n5, w6, n6, w7, n7, w8, n8, w9, n9, w10, n10, 0, 0);
	}

	//some of 10
	function int SomeOf(int w0, int n0, int w1, int n1, int w2, int n2, int w3, int n3, int w4, int n4, int w5, int n5, int w6, int n6, int w7, int n7, int w8, int n8, int w9, int n9){
		return SomeOf(w0, n0, w1, n1, w2, n2, w3, n3, w4, n4, w5, n5, w6, n6, w7, n7, w8, n8, w9, n9, 0, 0, 0, 0);
	}

	//some of 9
	function int SomeOf(int w0, int n0, int w1, int n1, int w2, int n2, int w3, int n3, int w4, int n4, int w5, int n5, int w6, int n6, int w7, int n7, int w8, int n8){
		return SomeOf(w0, n0, w1, n1, w2, n2, w3, n3, w4, n4, w5, n5, w6, n6, w7, n7, w8, n8, 0, 0, 0, 0, 0, 0, 0, 0);
	}

	//some of 8
	function int SomeOf(int w0, int n0, int w1, int n1, int w2, int n2, int w3, int n3, int w4, int n4, int w5, int n5, int w6, int n6, int w7, int n7){
		return SomeOf(w0, n0, w1, n1, w2, n2, w3, n3, w4, n4, w5, n5, w6, n6, w7, n7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	}

	//some of 7
	function int SomeOf(int w0, int n0, int w1, int n1, int w2, int n2, int w3, int n3, int w4, int n4, int w5, int n5, int w6, int n6){
		return SomeOf(w0, n0, w1, n1, w2, n2, w3, n3, w4, n4, w5, n5, w6, n6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	}

	//createunitex
	function int CreateUnit(string strChassis, int nShieldUpdateNum, string strWeapon0, string strWeapon1, string strWeapon2, string strWeapon3){
		unitex uUnit;
		uUnit=CreateUnitEx(newoneX, newoneY, newoneZ, null, strChassis, strWeapon0, strWeapon1, strWeapon2, strWeapon3, nShieldUpdateNum);
		if(uUnit){
			SetScriptUnit(newoneScriptIndex, uUnit);
			AddUnitToSpecialTab(uUnit, true, -1);
		}
		newoneChassis=0;
		newoneWeapon0=0;
		newoneWeapon1=0;
		newoneWeapon2=0;
		newoneWeapon3=0;
	}

	//translate chassis
	function int CreateUnit(string strWeapon0, string strWeapon1, string strWeapon2, string strWeapon3){
		if(newoneChassis==MAMMOTH){
			CreateUnit("UCSUBU1", 0, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==TIGER){
			CreateUnit("UCSUSL3", 0, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==SPIDER){
			CreateUnit("UCSUML3", 2, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==TARANTULA){
			CreateUnit("UCSUTAR3", 2, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==PANTHER){
			CreateUnit("UCSUHL3", 2, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==GRIZZLY){
			CreateUnit("UCSU4L1", 2, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==JAGUAR){
			CreateUnit("UCSUBL1", 2, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==SALAMANDER){
			CreateUnit("UCSUCSX", 2, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==LYNX){
			CreateUnit("UCSUART1", 1, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==CENTIPEDE){
			CreateUnit("UCSUHERO", 2, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==CENTIPEDE2){
			CreateUnit("UCSUHERO2", 2, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==UCSMINELAYER){
			CreateUnit("UCSUMI2", 0, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==HARVESTER){
			CreateUnit("UCSUOH3", 2, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==OBSERVER){
			CreateUnit("UCSUOBS1", 0, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==GARGOIL){
			CreateUnit("UCSUA13", 0, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==MANTICORE){
			CreateUnit("UCSUAST1", 1, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==BAT){
			CreateUnit("UCSUA22", 1, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==DRAGON){
			CreateUnit("UCSUA32", 1, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==UCSTRANSPORTER){
			CreateUnit("UCSUUT", 2, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==FLYINGHARVESTER){
			CreateUnit("UCSUAH1", 2, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==CONDOR){
			CreateUnit("UCSUAS1", 1, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==GRUZ){
			CreateUnit("EDUBU1", 0, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==PAMIR){
			CreateUnit("EDUST3", -1, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==DON){
			CreateUnit("EDUMW3", 1, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==TAIGA){
			CreateUnit("EDUOHX1", 1, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==SIBIRIA){
			CreateUnit("EDUMT3", 2, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==KAUKASUS){
			CreateUnit("EDUHT3", 2, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==RASPUTIN){
			CreateUnit("EDUJP3", 2, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==URAL){
			CreateUnit("EDUBT1", 2, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==GOLIATH){
			CreateUnit("EDUHERO", 2, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==GOLIATH2){
			CreateUnit("EDUHERO2", 2, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==STEALTH){
			CreateUnit("EDUSTEALTH", 0, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==KATYUSHA){
			CreateUnit("EDUART2", 1, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==SPION){
			CreateUnit("EDUSPY1", 0, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==EDMINELAYER){
			CreateUnit("EDUMI2", 0, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==ALTAI){
			CreateUnit("EDUOBS1", 0, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==KOZAK){
			CreateUnit("EDUA12", 0, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==ATAMAN){
			CreateUnit("EDUA22", 1, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==ODIN){
			CreateUnit("EDUAHH2", 2, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==THOR){
			CreateUnit("EDUA42", 1, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==HAN){
			CreateUnit("EDUA32", 1, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==EDTRANSPORTER){
			CreateUnit("EDUUT", 2, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==BOJAR){
			CreateUnit("EDUAS1", 1, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==TUNNELDIGGER){
			CreateUnit("LCUTD2", 0, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==LUNAR){
			CreateUnit("LCULU3", 0, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==MOON){
			CreateUnit("LCUMO3", 2, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==NEWHOPE){
			CreateUnit("LCUNH1", 0, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==FATGIRL){
			CreateUnit("LCUFG3", 2, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==CRATER){
			CreateUnit("LCUCR3", 2, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==FANG){
			CreateUnit("LCUHF3", 2, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==CRUSHER){
			CreateUnit("LCUCU1", 2, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==CRION){
			CreateUnit("LCUHT1", 1, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==CHARON){
			CreateUnit("LCUSS1", 2, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==PLUTO){
			CreateUnit("LCUP1", 2, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==PLUTO2){
			CreateUnit("LCUHERO2", 2, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==PHOBOS){
			CreateUnit("LCUOB1", 0, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==METEOR){
			CreateUnit("LCUME3", 1, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==SUPERFIGHTER){
			CreateUnit("LCUSF3", 1, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==THUNDERER){
			CreateUnit("LCUBO2", 1, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==STORM){
			CreateUnit("LCUAP3", 2, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==LCTRANSPORTER){
			CreateUnit("LCUUT", 2, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else if(newoneChassis==LCSUPPLIER){
			CreateUnit("LCUAS1", 1, strWeapon0, strWeapon1, strWeapon2, strWeapon3);
		}else{
			TraceD("Unknown Chassis: ");
			TraceD(newoneChassis);
			TraceD("\n");
		}
	}

	//translate weapon ids
	function int CreateUnit(string strWeapon0, string strWeapon1, string strWeapon2, string strWeapon3, int nReplaceWeapon, string strReplaceWeapon){
		int nWeapon;
		if(nReplaceWeapon!=-1){ //replace a weapon string
			if(nReplaceWeapon==0){
				CreateUnit(strReplaceWeapon, strWeapon1, strWeapon2, strWeapon3, -1, null);
			}else if(nReplaceWeapon==1){
				CreateUnit(strWeapon0, strReplaceWeapon, strWeapon2, strWeapon3, -1, null);
			}else if(nReplaceWeapon==2){
				CreateUnit(strWeapon0, strWeapon1, strReplaceWeapon, strWeapon3, -1, null);
			}else if(nReplaceWeapon==3){
				CreateUnit(strWeapon0, strWeapon1, strWeapon2, strReplaceWeapon, -1, null);
			}
			return;
		}

		//find weapon number to translate
		if(newoneWeapon0){
			nWeapon=newoneWeapon0;
			newoneWeapon0=0;
			nReplaceWeapon=0;
		}else if(newoneWeapon1){
			nWeapon=newoneWeapon1;
			newoneWeapon1=0;
			nReplaceWeapon=1;
		}else if(newoneWeapon2){
			nWeapon=newoneWeapon2;
			newoneWeapon2=0;
			nReplaceWeapon=2;
		}else if(newoneWeapon3){
			nWeapon=newoneWeapon3;
			newoneWeapon3=0;
			nReplaceWeapon=3;
		}else{ //everything is replaced
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3);
			return;
		}

		//translate weapon id
		if(nWeapon==EDAACANNON){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "EDWAA1");
		}else if(nWeapon==EDAALASER){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "EDWALAA2");
		}else if(nWeapon==EDAIRCARRIER){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "EDSACA1");
		}else if(nWeapon==EDANTIROCKET){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "EDWAN1");
		}else if(nWeapon==EDARTILLERY){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "EDWART");
		}else if(nWeapon==EDBANNER){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "EDBANNER");
		}else if(nWeapon==EDBANNER2){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "EDBANNER2");
		}else if(nWeapon==EDBIGBANNER){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "BIGBANNERSLOTED");
		}else if(nWeapon==EDBOMBERBOMB){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "EDWAB2");
		}else if(nWeapon==EDBOMBERROCKET){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "EDWAMR2");
		}else if(nWeapon==EDCANNON){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "EDWHC2");
		}else if(nWeapon==EDCARRIER){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "EDSCA1");
		}else if(nWeapon==EDEARTHQUAKE){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "EDWEQ2");
		}else if(nWeapon==EDHERO2CANNON){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "EDHEROWHC2");
		}else if(nWeapon==EDHERO2EARTHQUAKE){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "EDHEROWEQ2");
		}else if(nWeapon==EDHERO2GRENADE){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "EDHEROWART");
		}else if(nWeapon==EDHERO2IONDESTROYER){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "EDHEROWHI3");
		}else if(nWeapon==EDHERO2LASER){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "EDHEROWHL3");
		}else if(nWeapon==EDHERO2LRCANNON){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "EDHEROCJP2");
		}else if(nWeapon==EDHERO2LRLASER){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "EDHEROWLRL1");
		}else if(nWeapon==EDHERO2NUKE){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "EDHEROWHR1");
		}else if(nWeapon==EDHERO2ROCKET){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "EDHEROWMR3");
		}else if(nWeapon==EDHERO2SHOCKWAVE){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "EDHEROWSCH3");
		}else if(nWeapon==EDIONDESTROYER){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "EDWHI3");
		}else if(nWeapon==EDLASER){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "EDWHL3");
		}else if(nWeapon==EDLRCANNON){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "EDCJP2");
		}else if(nWeapon==EDLRLASER){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "EDWLRL1");
		}else if(nWeapon==EDNUKE){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "EDWHR1");
		}else if(nWeapon==EDODINLASER){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "EDWHHLA3");
		}else if(nWeapon==EDODINROCKET){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "EDCAMR2");
		}else if(nWeapon==EDPAMIRCANNON){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "EDWCA2");
		}else if(nWeapon==EDPAMIRLASER){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "EDWPSL2");
		}else if(nWeapon==EDPAMIRROCKET){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "EDWSR3AB");
		}else if(nWeapon==EDPAMIRSHOCKWAVE){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "EDWPSCL3");
		}else if(nWeapon==EDREPAIR){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "EDREPAIR2");
		}else if(nWeapon==EDROCKET){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "EDWMR3");
		}else if(nWeapon==EDSCREAMER){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "EDSCREAMER3");
		}else if(nWeapon==EDSCREAMER2){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "EDSCREAMER2");
		}else if(nWeapon==EDSHOCKWAVE){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "EDWSCH3");
		}else if(nWeapon==EDSMALLAIRAACANNON){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "EDWAAAC1");
		}else if(nWeapon==EDSMALLAIRAALASER){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "EDWAAAL2");
		}else if(nWeapon==EDSMALLAIRLASER){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "EDWHLA3");
		}else if(nWeapon==EDSMALLAIRMG){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "EDWAC2");
		}else if(nWeapon==EDSMALLAIRROCKET){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "EDWAR2");
		}else if(nWeapon==EDSMALLION){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "EDWSI2");
		}else if(nWeapon==EDSMALLLASER){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "EDWSL3");
		}else if(nWeapon==EDSMALLMG){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "EDWCH2");
		}else if(nWeapon==EDSMALLROCKET){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "EDWSR3");
		}else if(nWeapon==EDSMALLSHOCKWAVE){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "EDWSCL3");
		}else if(nWeapon==EDSTALINORGEL){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "EDWSO2");
		}else if(nWeapon==EDTRANSPORTERHOOK){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "EDSUT");
		}else if(nWeapon==LCAIRELECTRO){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "LCWAHE2");
		}else if(nWeapon==LCAIRROCKET){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "LCWAMR2");
		}else if(nWeapon==LCAIRSONIC){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "LCWAS2");
		}else if(nWeapon==LCANTIROCKET){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "LCWAN1");
		}else if(nWeapon==LCBANNER){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "LCBANNER");
		}else if(nWeapon==LCBANNER2){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "LCBANNER2");
		}else if(nWeapon==LCBIGBANNER){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "BIGBANNERSLOTLC");
		}else if(nWeapon==LCCRATERDETECTOR){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "LCSDETST2");
		}else if(nWeapon==LCCRATERREGENERATOR){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "LCUREGST3");
		}else if(nWeapon==LCCRATERSHIELDREGENERATOR){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "LCSSAKST3");
		}else if(nWeapon==LCDETECTOR){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "LCSOB2");
		}else if(nWeapon==LCEARTHQUAKE){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "LCWEQ2");
		}else if(nWeapon==LCELECTRO){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "LCWHL2");
		}else if(nWeapon==LCHERO2EARTHQUAKE){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "LCHEROWEQ2");
		}else if(nWeapon==LCHERO2ELECTRO){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "LCHEROWHL2");
		}else if(nWeapon==LCHERO2PLASMA){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "LCHEROWHP3");
		}else if(nWeapon==LCHERO2RAILGUN){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "LCHEROWHRG2");
		}else if(nWeapon==LCHERO2ROCKET){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "LCHEROWMR3");
		}else if(nWeapon==LCHERO2SONIC){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "LCHEROWHS2");
		}else if(nWeapon==LCLIGHTNING){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "LCWBART2");
		}else if(nWeapon==LCLUNARDETECTOR){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "LCSDET2");
		}else if(nWeapon==LCLUNARREGENERATOR){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "LCUREG3");
		}else if(nWeapon==LCLUNARSHIELDREGENERATOR){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "LCSSAK3");
		}else if(nWeapon==LCPLASMA){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "LCWHP3");
		}else if(nWeapon==LCPLASMACANNON){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSWCART2");
		}else if(nWeapon==LCRAILGUN){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "LCWHRG2");
		}else if(nWeapon==LCREGENERATOR){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "LCSREG3");
		}else if(nWeapon==LCROCKET){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "LCWMR3");
		}else if(nWeapon==LCSHIELDREGENERATOR){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "LCSSHR3");
		}else if(nWeapon==LCSMALLAAPLASMA){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "LCWAAE2");
		}else if(nWeapon==LCSMALLAARAILGUN){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "LCWAARG1");
		}else if(nWeapon==LCSMALLAIRAAPLASMA){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "LCWSAAE2");
		}else if(nWeapon==LCSMALLAIRAARAILGUN){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "LCWSAARG1");
		}else if(nWeapon==LCSMALLAIRELECTRO){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "LCWAE2");
		}else if(nWeapon==LCSMALLAIRMG){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "LCWAC2");
		}else if(nWeapon==LCSMALLAIRROCKET){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "LCWAR2");
		}else if(nWeapon==LCSMALLELECTRO){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "LCWSL2");
		}else if(nWeapon==LCSMALLMG){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "LCWCH2");
		}else if(nWeapon==LCSMALLPLASMA){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "LCWHERO2");
		}else if(nWeapon==LCSMALLRAILGUN){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "LCWRG2");
		}else if(nWeapon==LCSMALLROCKET){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "LCWSR3");
		}else if(nWeapon==LCSMALLSONIC){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "LCWSS2");
		}else if(nWeapon==LCSONIC){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "LCWHS2");
		}else if(nWeapon==LCTRANSPORTERHOOK){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "LCSUT");
		}else if(nWeapon==UCSAAMINIGUN){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSWGATAA2");
		}else if(nWeapon==UCSAAPLASMA){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSCAA2");
		}else if(nWeapon==UCSAIRAAMINIGUN){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSWGATAAA2");
		}else if(nWeapon==UCSAIRMINIGUN){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSWGATHA2");
		}else if(nWeapon==UCSAIRNAPALMBOMB){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSWAFB2");
		}else if(nWeapon==UCSAIRPLASMABOMB){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSWAPB2");
		}else if(nWeapon==UCSAIRROCKET){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSWAMR2");
		}else if(nWeapon==UCSANTIROCKET){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSWAN1");
		}else if(nWeapon==UCSBANNER){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSBANNER");
		}else if(nWeapon==UCSBIGBANNER){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "BIGBANNERSLOTUCS");
		}else if(nWeapon==UCSCANNON){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSWTCAN2");
		}else if(nWeapon==UCSCANNONARTILLERY){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSWCART2");
		}else if(nWeapon==UCSFLAMETHROWER){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSWFLHB2");
		}else if(nWeapon==UCSGRENADE){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSWGT2");
		}else if(nWeapon==UCSHERO2CANNON){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSHEROWBHC2");
		}else if(nWeapon==UCSHERO2EARTHQUAKE){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSHEROWEQ2");
		}else if(nWeapon==UCSHERO2FLAMETHROWER){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSHEROWHFLT2");
		}else if(nWeapon==UCSHERO2GRENADE){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSHEROWBHG2");
		}else if(nWeapon==UCSHERO2MINIGUN){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSHEROWGATH2");
		}else if(nWeapon==UCSHERO2PLASMA){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSHEROWBHP3");
		}else if(nWeapon==UCSHERO2ROCKET){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSHEROWBMR3");
		}else if(nWeapon==UCSHERO2SMALLROCKET){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSHEROWBSR3");
		}else if(nWeapon==UCSMECHCANNON){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSWBHC2");
		}else if(nWeapon==UCSMECHEARTHQUAKE){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSWEQ2");
		}else if(nWeapon==UCSMECHFLAMETHROWER){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSWHFLT2");
		}else if(nWeapon==UCSMECHGRENADE){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSWBHG2");
		}else if(nWeapon==UCSMECHMINIGUN){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSWGATH2");
		}else if(nWeapon==UCSMECHPLASMA){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSWBHP3");
		}else if(nWeapon==UCSMECHROCKET){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSWBMR3");
		}else if(nWeapon==UCSMECHSMALLROCKET){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSWBSR3");
		}else if(nWeapon==UCSMINIGUN){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSTGATH2");
		}else if(nWeapon==UCSPLASMA){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSTHP3");
		}else if(nWeapon==UCSPLASMAARTILLERY){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSWART2");
		}else if(nWeapon==UCSRADAR){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSURAD1");
		}else if(nWeapon==UCSREPAIR){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSREPAIR2");
		}else if(nWeapon==UCSROCKET){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSWSMR2");
		}else if(nWeapon==UCSSALAMANDERRADAR){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSSALAMIR1");
		}else if(nWeapon==UCSSALAMANDERSHADOW){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSSALAMIS1");
		}else if(nWeapon==UCSSHADOW){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSWSH3");
		}else if(nWeapon==UCSSMALLAIRAAMINIGUN){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSWGATAAA2");
		}else if(nWeapon==UCSSMALLAIRMG){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSWACH2");
		}else if(nWeapon==UCSSMALLAIRPLASMA){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSWAP2");
		}else if(nWeapon==UCSSMALLAIRROCKET){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSWASR2");
		}else if(nWeapon==UCSSMALLFLAMETHROWER){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSWFLLB2");
		}else if(nWeapon==UCSSMALLMINIGUN){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSWSCH3");
		}else if(nWeapon==UCSSMALLPLASMA){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSWSSP2");
		}else if(nWeapon==UCSSMALLROCKET){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSWSSR3");
		}else if(nWeapon==UCSTARANTULAROCKET){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSTSRAK3");
		}else if(nWeapon==UCSTIGERCANNON){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSWTSC2");
		}else if(nWeapon==UCSTIGERFLAMETHROWER){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSWTFL2");
		}else if(nWeapon==UCSTIGERGRENADE){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSWTSG2");
		}else if(nWeapon==UCSTIGERMINIGUN){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSWTCH3");
		}else if(nWeapon==UCSTIGERPLASMA){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSWTSP2");
		}else if(nWeapon==UCSTIGERROCKET){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSWTSR3");
		}else if(nWeapon==UCSTRANSPORTERHOOK){
			CreateUnit(strWeapon0, strWeapon1, strWeapon2, strWeapon3, nReplaceWeapon, "UCSSUT");
		}else{
			//XXX
			TraceD("Unknown Weapon: ");
			TraceD(nWeapon);
			TraceD("\n");
		}
	}

	//add chassis and weapons
	function int CreateUnit(){
		int i;
		int nWeapon;
		int nExtraPlug;

		//choose chassis
		if(nGetRace==raceED){
			newoneChassis=SomeOf(
				wGruz, GRUZ,
				wTaiga, TAIGA,
				wSpion, SPION,
				wEDMinelayer, EDMINELAYER,
				wPamir, PAMIR,
				wDon, DON,
				wSibiria, SIBIRIA,
				wKaukasus, KAUKASUS,
				wRasputin, RASPUTIN,
				wUral, URAL,
				wGoliath, GOLIATH,
				wGoliath2, GOLIATH2,
				wStealth, STEALTH,
				wKatyusha, KATYUSHA,
				wAltai, ALTAI,
				wEDTransporter, EDTRANSPORTER,
				wBojar, BOJAR,
				wKozak, KOZAK,
				wAtaman, ATAMAN,
				wOdin, ODIN,
				wThor, THOR,
				wHan, HAN
			);
		}else if(nGetRace==raceLC){
			newoneChassis=SomeOf(
				wTunnelDigger, TUNNELDIGGER,
				wLunar, LUNAR,
				wMoon, MOON,
				wNewHope, NEWHOPE,
				wFatGirl, FATGIRL,
				wCrater, CRATER,
				wFang, FANG,
				wCrusher, CRUSHER,
				wCrion, CRION,
				wCharon, CHARON,
				wPluto, PLUTO,
				wPluto2, PLUTO2,
				wPhobos, PHOBOS,
				wLCTransporter, LCTRANSPORTER,
				wLCSupplier, LCSUPPLIER,
				wMeteor, METEOR,
				wSuperFighter, SUPERFIGHTER,
				wThunderer, THUNDERER,
				wStorm, STORM
			);
		}else if(nGetRace==raceUCS){
			newoneChassis=SomeOf(
				wMammoth, MAMMOTH,
				wSalamander, SALAMANDER,
				wUCSMinelayer, UCSMINELAYER,
				wHarvester, HARVESTER,
				wTiger, TIGER,
				wSpider, SPIDER,
				wTarantula, TARANTULA,
				wPanther, PANTHER,
				wGrizzly, GRIZZLY,
				wJaguar, JAGUAR,
				wLynx, LYNX,
				wCentipede, CENTIPEDE,
				wCentipede2, CENTIPEDE2,
				wObserver, OBSERVER,
				wUCSTransporter, UCSTRANSPORTER,
				wFlyingHarvester, FLYINGHARVESTER,
				wCondor, CONDOR,
				wGargoil, GARGOIL,
				wManticore, MANTICORE,
				wBat, BAT,
				wDragon, DRAGON
			);
		}

		//choose weapon(s)
		if(newoneChassis==PAMIR){
			newoneWeapon0=SomeOf(
				wAACannon, EDAACANNON,
				wAALaser, EDAALASER,
				wCannon, EDPAMIRCANNON,
				wRocket, EDPAMIRROCKET,
				wShockwave, EDPAMIRSHOCKWAVE,
				wLaser, EDPAMIRLASER
			);
		}else if(newoneChassis==DON || newoneChassis==STEALTH){
			newoneWeapon0=SomeOf(
				wMG, EDSMALLMG,
				wShockwave, EDSMALLSHOCKWAVE,
				wRocket, EDSMALLROCKET,
				wLaser, EDSMALLLASER,
				wIon, EDSMALLION,
				wBanner, EDBANNER,
				wScreamer, EDSCREAMER
			);
		}else if(newoneChassis==TAIGA){
			newoneWeapon0=SomeOf(

				wBanner, EDBANNER2,
				wScreamer, EDSCREAMER2,
				wRepair, EDREPAIR,
				wCarrier, EDCARRIER
			);
		}else if(newoneChassis==SIBIRIA){
			newoneWeapon0=SomeOf(
				wMG, EDSMALLMG,
				wAACannon, EDAACANNON,
				wAALaser, EDAALASER,
				wShockwave, EDSMALLSHOCKWAVE,
				wRocket, EDSMALLROCKET,
				wLaser, EDSMALLLASER,
				wIon, EDSMALLION,
				wBanner, EDBANNER,
				wScreamer, EDSCREAMER
			);
		}else if(newoneChassis==KAUKASUS || newoneChassis==RASPUTIN){
			newoneWeapon0=SomeOf(
				wCannon, EDCANNON,
				wLRCannon, EDLRCANNON,
				wShockwave, EDSHOCKWAVE,
				wGrenade, EDARTILLERY,
				wRocket, EDROCKET,
				wNuke, EDNUKE,
				wLaser, EDLASER,
				wLRLaser, EDLRLASER,
				wIonDestroyer, EDIONDESTROYER,
				wEarthquake, EDEARTHQUAKE,
				wBanner, EDBIGBANNER
			);
		}else if(newoneChassis==URAL || newoneChassis==GOLIATH){
			newoneWeapon0=SomeOf(
				wCannon, EDCANNON,
				wLRCannon, EDLRCANNON,
				wShockwave, EDSHOCKWAVE,
				wGrenade, EDARTILLERY,
				wRocket, EDROCKET,
				wNuke, EDNUKE,
				wLaser, EDLASER,
				wLRLaser, EDLRLASER,
				wIonDestroyer, EDIONDESTROYER,
				wEarthquake, EDEARTHQUAKE
			);
			newoneWeapon1=newoneWeapon0;
		}else if(newoneChassis==GOLIATH2){
			newoneWeapon0=SomeOf(
				wCannon, EDHERO2CANNON,
				wLRCannon, EDHERO2LRCANNON,
				wShockwave, EDHERO2SHOCKWAVE,
				wGrenade, EDHERO2GRENADE,
				wRocket, EDHERO2ROCKET,
				wNuke, EDHERO2NUKE,
				wLaser, EDHERO2LASER,
				wLRLaser, EDHERO2LRLASER,
				wIonDestroyer, EDHERO2IONDESTROYER,
				wEarthquake, EDHERO2EARTHQUAKE
			);
			newoneWeapon1=newoneWeapon0;
		}else if(newoneChassis==KATYUSHA){
			newoneWeapon0=SomeOf(
				wStalinOrgel, EDSTALINORGEL
			);
		}else if(newoneChassis==KOZAK){
			newoneWeapon0=SomeOf(
				wMG, EDSMALLAIRMG,
				wRocket, EDSMALLAIRROCKET
			);
		}else if(newoneChassis==ATAMAN){
			newoneWeapon0=SomeOf(
				wMG, EDSMALLAIRMG,
				wAACannon, EDSMALLAIRAACANNON,
				wRocket, EDSMALLAIRROCKET,
				wLaser, EDSMALLAIRLASER,
				wAALaser, EDSMALLAIRAALASER
			);
		}else if(newoneChassis==ODIN){
			newoneWeapon0=SomeOf(
				wRocket, EDODINROCKET,
				wLaser, EDODINLASER
			);
			newoneWeapon1=newoneWeapon0;
		}else if(newoneChassis==THOR || newoneChassis==HAN){
			newoneWeapon0=SomeOf(
				wRocket, EDBOMBERROCKET,
				wAtomBomb, EDBOMBERBOMB
			);
		}else if(newoneChassis==EDTRANSPORTER){
			newoneWeapon0=SomeOf(
				wCarrier, EDAIRCARRIER,
				wTransporter, EDTRANSPORTERHOOK
			);
		}else if(newoneChassis==LUNAR || newoneChassis==NEWHOPE){
			newoneWeapon0=SomeOf(
				wMG, LCSMALLMG,
				wRocket, LCSMALLROCKET,
				wElectro, LCSMALLELECTRO,
				wAAPlasma, LCSMALLAAPLASMA,
				wSonic, LCSMALLSONIC,
				wRailgun, LCSMALLRAILGUN,
				wAARailgun, LCSMALLAARAILGUN,
				wPlasma, LCSMALLPLASMA,
				wBanner, LCBANNER,
				wDetector, LCLUNARDETECTOR,
				wShieldRegenerator, LCLUNARSHIELDREGENERATOR,
				wRegenerator, LCLUNARREGENERATOR
			);
		}else if(newoneChassis==MOON || newoneChassis==FATGIRL || newoneChassis==CHARON){
			newoneWeapon0=SomeOf(
				wMG, LCSMALLMG,
				wRocket, LCSMALLROCKET,
				wElectro, LCSMALLELECTRO,
				wSonic, LCSMALLSONIC,
				wRailgun, LCSMALLRAILGUN,
				wPlasma, LCSMALLPLASMA,
				wBanner, LCBANNER,
				wDetector, LCLUNARDETECTOR,
				wShieldRegenerator, LCLUNARSHIELDREGENERATOR,
				wRegenerator, LCLUNARREGENERATOR
			);
			if(newoneChassis!=MOON){
				newoneWeapon1=newoneWeapon0;
				/*
				if(newoneChassis==FATGIRL){
					newoneWeapon2=newoneWeapon0;
					newoneWeapon3=newoneWeapon0;
				}
				*/
			}
		}else if(newoneChassis==CRATER || newoneChassis==FANG){
			newoneWeapon0=SomeOf(
				wRocket, LCROCKET,
				wElectro, LCELECTRO,
				wSonic, LCSONIC,
				wRailgun, LCRAILGUN,
				wEarthquake, LCEARTHQUAKE,
				wPlasma, LCPLASMA,
				wBanner, LCBIGBANNER,
				wDetector, LCCRATERDETECTOR,
				wShieldRegenerator, LCCRATERSHIELDREGENERATOR,
				wRegenerator, LCCRATERREGENERATOR
			);
		}else if(newoneChassis==CRUSHER || newoneChassis==PLUTO){
			newoneWeapon0=SomeOf(
				wRocket, LCROCKET,
				wElectro, LCELECTRO,
				wSonic, LCSONIC,
				wRailgun, LCRAILGUN,
				wEarthquake, LCEARTHQUAKE,
				wPlasma, LCPLASMA
			);
			newoneWeapon1=newoneWeapon0;
		}else if(newoneChassis==PLUTO2){
			newoneWeapon0=SomeOf(
				wRocket, LCHERO2ROCKET,
				wElectro, LCHERO2ELECTRO,
				wSonic, LCHERO2SONIC,
				wRailgun, LCHERO2RAILGUN,
				wEarthquake, LCHERO2EARTHQUAKE,
				wPlasma, LCHERO2PLASMA
			);
			newoneWeapon1=newoneWeapon0;
		}else if(newoneChassis==CRION){
			newoneWeapon0=SomeOf(
				wPlasmaCannon, LCPLASMACANNON,
				wLightning, LCLIGHTNING
			);
		}else if(newoneChassis==PHOBOS){
			newoneWeapon0=SomeOf(
				wDetector, LCDETECTOR,
				wShieldRegenerator, LCSHIELDREGENERATOR,
				wRegenerator, LCREGENERATOR
			);
		}else if(newoneChassis==METEOR){
			newoneWeapon0=SomeOf(
				wMG, LCSMALLAIRMG,
				wRocket, LCSMALLAIRROCKET,
				wElectro, LCSMALLAIRELECTRO
			);
		}else if(newoneChassis==SUPERFIGHTER){
			newoneWeapon0=SomeOf(
				wMG, LCSMALLAIRMG,
				wRocket, LCSMALLAIRROCKET,
				wElectro, LCSMALLAIRELECTRO,
				wAAPlasma, LCSMALLAIRAAPLASMA,
				wAARailgun, LCSMALLAIRAARAILGUN
			);
			newoneWeapon1=newoneWeapon0;
		}else if(newoneChassis==THUNDERER || newoneChassis==STORM){
			newoneWeapon0=SomeOf(
				wRocket, LCAIRROCKET,
				wSonic, LCAIRSONIC,
				wElectro, LCAIRELECTRO
			);
			if(newoneChassis==STORM){
				newoneWeapon1=newoneWeapon0;
			}
		}else if(newoneChassis==LCTRANSPORTER){
			newoneWeapon0=SomeOf(
				wTransporter, LCTRANSPORTERHOOK
			);
		}else if(newoneChassis==TIGER){
			newoneWeapon0=SomeOf(
				wMinigun, UCSTIGERMINIGUN,
				wCannon, UCSTIGERCANNON,
				wPlasma, UCSTIGERPLASMA,
				wRocket, UCSTIGERROCKET,
				wFlamethrower, UCSTIGERFLAMETHROWER,
				wGrenade, UCSTIGERGRENADE
			);
		}else if(newoneChassis==SPIDER){
			newoneWeapon0=SomeOf(
				wMinigun, UCSSMALLMINIGUN,
				wPlasma, UCSSMALLPLASMA,
				wRocket, UCSSMALLROCKET,
				wRocket, UCSROCKET,
				wFlamethrower, UCSSMALLFLAMETHROWER,
				wBanner, UCSBANNER,
				wShadow, UCSSHADOW,
				wRadar, UCSRADAR
			);
		}else if(newoneChassis==TARANTULA){
			newoneWeapon0=SomeOf(
				wRocket, UCSTARANTULAROCKET,
				wPlasma, UCSPLASMA,
				wMinigun, UCSMINIGUN,
				wFlamethrower, UCSFLAMETHROWER,
				wGrenade, UCSGRENADE,
				wCannon, UCSCANNON,
				wBanner, UCSBIGBANNER
			);
		}else if(newoneChassis==PANTHER || newoneChassis==JAGUAR || newoneChassis==CENTIPEDE){
			newoneWeapon0=SomeOf(
				wCannon, UCSMECHCANNON,
				wRocket, UCSMECHROCKET,
				wRocket, UCSMECHSMALLROCKET,
				wPlasma, UCSMECHPLASMA,
				wMinigun, UCSMECHMINIGUN,
				wFlamethrower, UCSMECHFLAMETHROWER,
				wGrenade, UCSMECHGRENADE,
				wEarthquake, UCSMECHEARTHQUAKE,
				wBanner, UCSBIGBANNER
			);
			if(newoneChassis==JAGUAR){
				if(newoneWeapon0==UCSMECHCANNON || newoneWeapon0==UCSMECHROCKET || newoneWeapon0==UCSMECHSMALLROCKET || newoneWeapon0==UCSMECHMINIGUN || newoneWeapon0==UCSMECHGRENADE || newoneWeapon0==UCSMECHEARTHQUAKE){
					newoneWeapon1=SomeOf(
						wMinigun, UCSSMALLMINIGUN,
						wRocket, UCSSMALLROCKET,
						wRocket, UCSROCKET,
						wAntirocket, UCSANTIROCKET,
						wBanner, UCSBANNER,
						wShadow, UCSSHADOW,
						wRadar, UCSRADAR
					);
				}else if(newoneWeapon0==UCSMECHPLASMA || newoneWeapon0==UCSMECHFLAMETHROWER){
					newoneWeapon1=SomeOf(wPlasma, UCSSMALLPLASMA,
						wFlamethrower, UCSSMALLFLAMETHROWER,
						wAntirocket, UCSANTIROCKET,
						wBanner, UCSBANNER,
						wShadow, UCSSHADOW,
						wRadar, UCSRADAR
					);
				}else{ //Banner
					newoneWeapon1=SomeOf(wMinigun, UCSSMALLMINIGUN,
						wPlasma, UCSSMALLPLASMA,
						wRocket, UCSSMALLROCKET,
						wRocket, UCSROCKET,
						wFlamethrower, UCSSMALLFLAMETHROWER,
						wAntirocket, UCSANTIROCKET,
						wBanner, UCSBANNER,
						wShadow, UCSSHADOW,
						wRadar, UCSRADAR
					);
				}
			}else if(newoneChassis==CENTIPEDE){
				newoneWeapon1=newoneWeapon0;
			}
		}else if(newoneChassis==GRIZZLY){
			newoneWeapon0=SomeOf(
				wMinigun, UCSSMALLMINIGUN,
				wPlasma, UCSSMALLPLASMA,
				wRocket, UCSSMALLROCKET,
				wRocket, UCSROCKET,
				wFlamethrower, UCSSMALLFLAMETHROWER,
				wRocket, UCSTARANTULAROCKET,
				wPlasma, UCSPLASMA,
				wMinigun, UCSMINIGUN,
				wFlamethrower, UCSFLAMETHROWER,
				wGrenade, UCSGRENADE,
				wCannon, UCSCANNON,
				wBanner, UCSBANNER,
				wShadow, UCSSHADOW,
				wRadar, UCSRADAR
			);
			if(newoneWeapon0==UCSSMALLMINIGUN || newoneWeapon0==UCSSMALLROCKET || newoneWeapon0==UCSROCKET || newoneWeapon0==UCSTARANTULAROCKET || newoneWeapon0==UCSMINIGUN || newoneWeapon0==UCSGRENADE || newoneWeapon0==UCSCANNON){
				newoneWeapon1=SomeOf(wCannon, UCSMECHCANNON,
					wRocket, UCSMECHROCKET,
					wRocket, UCSMECHSMALLROCKET,
					wMinigun, UCSMECHMINIGUN,
					wGrenade, UCSMECHGRENADE,
					wEarthquake, UCSMECHEARTHQUAKE,
					wBanner, UCSBIGBANNER
				);
			}else if(newoneWeapon0==UCSSMALLPLASMA || newoneWeapon0==UCSSMALLFLAMETHROWER || newoneWeapon0==UCSPLASMA || newoneWeapon0==UCSFLAMETHROWER){
				newoneWeapon1=SomeOf(wPlasma, UCSMECHPLASMA,
					wFlamethrower, UCSMECHFLAMETHROWER,
					wBanner, UCSBIGBANNER
				);
			}else{ //banner, shadow, radar
				newoneWeapon1=SomeOf(
					wCannon, UCSMECHCANNON,
					wRocket, UCSMECHROCKET,
					wRocket, UCSMECHSMALLROCKET,
					wPlasma, UCSMECHPLASMA,
					wMinigun, UCSMECHMINIGUN,
					wFlamethrower, UCSMECHFLAMETHROWER,
					wGrenade, UCSMECHGRENADE,
					wEarthquake, UCSMECHEARTHQUAKE,
					wBanner, UCSBIGBANNER
				);
			}
		}else if(newoneChassis==SALAMANDER){
			newoneWeapon0=SomeOf(
				wAAPlasma, UCSAAPLASMA,
				wAAMinigun, UCSAAMINIGUN,
				wShadow, UCSSALAMANDERSHADOW,
				wRadar, UCSSALAMANDERRADAR,
				wRepair, UCSREPAIR
			);
		}else if(newoneChassis==LYNX){
			newoneWeapon0=SomeOf(
				wPlasmaArtillery, UCSPLASMAARTILLERY,
				wCannonArtillery, UCSCANNONARTILLERY
			);
		}else if(newoneChassis==CENTIPEDE2){
			newoneWeapon0=SomeOf(
				wCannon, UCSHERO2CANNON,
				wRocket, UCSHERO2ROCKET,
				wRocket, UCSHERO2SMALLROCKET,
				wPlasma, UCSHERO2PLASMA,
				wMinigun, UCSHERO2MINIGUN,
				wFlamethrower, UCSHERO2FLAMETHROWER,
				wGrenade, UCSHERO2GRENADE,
				wEarthquake, UCSMECHEARTHQUAKE
			);
			newoneWeapon1=newoneWeapon0;
		}else if(newoneChassis==GARGOIL || newoneChassis==MANTICORE){
			newoneWeapon0=SomeOf(
				wMG, UCSSMALLAIRMG,
				wPlasma, UCSSMALLAIRPLASMA,
				wRocket, UCSSMALLAIRROCKET,
				wAAMinigun, UCSSMALLAIRAAMINIGUN
			);
			if(newoneChassis==MANTICORE){
				newoneWeapon1=newoneWeapon0;
			}
		}else if(newoneChassis==BAT || newoneChassis==DRAGON){
			newoneWeapon0=SomeOf(
				wRocket, UCSAIRROCKET,
				wMinigun, UCSAIRMINIGUN,
				wPlasmaBomb, UCSAIRPLASMABOMB,
				wNapalmBomb, UCSAIRNAPALMBOMB
			);
		}else if(newoneChassis==UCSTRANSPORTER){
			newoneWeapon0=SomeOf(
				wTransporter, UCSTRANSPORTERHOOK
			);
		}

		//choose extra weapon(s)
		for(i=0; i<2; ++i){
			if(i==0){
				nWeapon=newoneWeapon0;
			}else{
				nWeapon=newoneWeapon1;
			}

			if(nWeapon){
				if(nWeapon==EDCANNON || nWeapon==EDLRCANNON){
					nExtraPlug=SomeOf(wMG, EDSMALLMG, wRocket, EDSMALLROCKET, wAntirocket, EDANTIROCKET, wBanner, EDBANNER, wScreamer, EDSCREAMER);
				}else if(nWeapon==EDLASER || nWeapon==EDLRLASER || nWeapon==EDIONDESTROYER){
					nExtraPlug=SomeOf(wShockwave, EDSMALLSHOCKWAVE, wLaser, EDSMALLLASER, wIon, EDSMALLION, wAntirocket, EDANTIROCKET, wBanner, EDBANNER, wScreamer, EDSCREAMER);
				}else if(nWeapon==EDHERO2CANNON || nWeapon==EDHERO2LRCANNON){
					nExtraPlug=SomeOf(wCannon, EDCANNON, wLRCannon, EDLRCANNON, wGrenade, EDARTILLERY, wRocket, EDROCKET, wNuke, EDNUKE, wEarthquake, EDEARTHQUAKE);
				}else if(nWeapon==EDHERO2IONDESTROYER || nWeapon==EDHERO2LASER || nWeapon==EDHERO2LRLASER){
					nExtraPlug=SomeOf(wShockwave, EDSHOCKWAVE, wLaser, EDLASER, wLRLaser, EDLRLASER, wIonDestroyer, EDIONDESTROYER);
				}else if(nWeapon==EDSHOCKWAVE || nWeapon==EDHERO2SHOCKWAVE){
					nExtraPlug=SomeOf(wBanner, EDBIGBANNER);
				}else if(nWeapon==LCELECTRO){
					nExtraPlug=SomeOf(wSonic, LCSMALLSONIC, wElectro, LCSMALLELECTRO, wPlasma, LCSMALLPLASMA, wAntirocket, LCANTIROCKET, wBanner, LCBANNER2, wDetector, LCLUNARDETECTOR, wShieldRegenerator, LCLUNARSHIELDREGENERATOR, wRegenerator, LCLUNARREGENERATOR);
				}else if(nWeapon==LCRAILGUN){
					nExtraPlug=SomeOf(wMG, LCSMALLMG, wRocket, LCSMALLROCKET, wAntirocket, LCANTIROCKET, wBanner, LCBANNER2, wDetector, LCLUNARDETECTOR, wShieldRegenerator, LCLUNARSHIELDREGENERATOR, wRegenerator, LCLUNARREGENERATOR);
				}else if(nWeapon==LCHERO2ELECTRO){
					nExtraPlug=SomeOf(wElectro, LCELECTRO, wSonic, LCSONIC, wPlasma, LCPLASMA);
				}else if(nWeapon==LCHERO2RAILGUN){
					nExtraPlug=SomeOf(wRocket, LCROCKET, wRailgun, LCRAILGUN, wEarthquake, LCEARTHQUAKE);
				}else if(nWeapon==UCSCANNON || nWeapon==UCSMINIGUN || nWeapon==UCSCANNON || nWeapon==UCSMECHCANNON || nWeapon==UCSMECHMINIGUN || nWeapon==UCSMECHSMALLROCKET){
					nExtraPlug=SomeOf(wMinigun, UCSSMALLMINIGUN, wRocket, UCSSMALLROCKET, wRocket, UCSROCKET, wAntirocket, UCSANTIROCKET, wBanner, UCSBANNER, wShadow, UCSSHADOW, wRadar, UCSRADAR);
				}else if(nWeapon==UCSFLAMETHROWER || nWeapon==UCSPLASMA || nWeapon==UCSMECHFLAMETHROWER || nWeapon==UCSMECHPLASMA || nWeapon==UCSPLASMA){
					nExtraPlug=SomeOf(wPlasma, UCSSMALLPLASMA, wFlamethrower, UCSSMALLFLAMETHROWER, wAntirocket, UCSANTIROCKET, wBanner, UCSBANNER, wShadow, UCSSHADOW, wRadar, UCSRADAR);
				}else if(nWeapon==UCSHERO2CANNON || nWeapon==UCSHERO2MINIGUN || nWeapon==UCSHERO2SMALLROCKET){
					nExtraPlug=SomeOf(wRocket, UCSTARANTULAROCKET, wMinigun, UCSMINIGUN, wGrenade, UCSGRENADE, wCannon, UCSCANNON, wBanner, UCSBIGBANNER);
				}else if(nWeapon==UCSHERO2FLAMETHROWER || nWeapon==UCSHERO2PLASMA){
					nExtraPlug=SomeOf(wPlasma, UCSPLASMA, wFlamethrower, UCSFLAMETHROWER, wBanner, UCSBIGBANNER);
				}

				if(i==0){
					newoneWeapon2=nExtraPlug;
				}else{
					newoneWeapon3=nExtraPlug;
				}
			}
		}

		CreateUnit(null, null, null, null, -1, null);
	}

	function int F(int nHP){
		if(nMinHP<=nHP && nHP<=nMaxHP){
			return 1000000/nHP;
		}
		return 1;
	}

	function int SetLevel(int nLevel){
		if(nLevel>nTimer/5){
			nLevel=nTimer/5;
		}
		if(nLevel<nTimer/96){
			nLevel=nTimer/96;
		}
		if(nLevel==0){
			nMinHP=100;
			nMaxHP=300;
		}else if(nLevel==1){
			nMinHP=100;
			nMaxHP=450;
		}else if(nLevel==2){
			nMinHP=350;
			nMaxHP=600;
		}else if(nLevel==3){
			nMinHP=500;
			nMaxHP=800;
		}else if(nLevel==4){
			nMinHP=700;
			nMaxHP=900;
		}else if(nLevel==5){
			nMinHP=800;
			nMaxHP=1000;
		}else if(nLevel==6){
			nMinHP=1000;
			nMaxHP=1150;
		}else if(nLevel==7){
			nMinHP=1150;
			nMaxHP=1400;
		}else if(nLevel==8){
			nMinHP=1400;
			nMaxHP=3600;
		}else if(nLevel==9){
			nMinHP=1400;
			nMaxHP=15000;
		}else{
			nMinHP=15000;
			nMaxHP=15000;
		}

		//ed chassis weights
		wGruz=F(1500);
		wPamir=F(260);
		wDon=F(700);
		wTaiga=F(450);
		wSibiria=F(600);
		wKaukasus=F(1200);
		wRasputin=F(1200);
		wUral=F(1500);
		wGoliath=F(15000);
		wGoliath2=F(15000);
		wStealth=F(450);
		wKatyusha=F(900);
		wSpion=F(500);
		wEDMinelayer=F(675);
		wAltai=F(450);
		wKozak=F(300);
		wAtaman=F(450);
		wOdin=F(700);
		wThor=F(500);
		wHan=F(800);
		wEDTransporter=F(550);
		wBojar=F(500);

		//lc chassis weights
		wTunnelDigger=F(1500);
		wLunar=F(300);
		wMoon=F(500);
		wNewHope=F(400);
		wFatGirl=F(750);
		wCrater=F(1150);
		wFang=F(1150);
		wCrusher=F(1400);
		wCrion=F(900);
		wCharon=F(700);
		wPluto=F(15000);
		wPluto2=F(15000);
		wPhobos=F(300);
		wMeteor=F(350);
		wSuperFighter=F(800);
		wThunderer=F(900);
		wStorm=F(1150);
		wLCTransporter=F(550);
		wLCSupplier=F(500);

		//ucs chassis weights
		wMammoth=F(1500);
		wTiger=F(300);
		wSpider=F(600);
		wTarantula=F(1200);
		wPanther=F(1200);
		wGrizzly=F(2200);
		wJaguar=F(1500);
		wSalamander=F(800);
		wLynx=F(900);
		wCentipede=F(15000);
		wCentipede2=F(15000);
		wUCSMinelayer=F(675);
		wHarvester=F(1000);
		wObserver=F(450);
		wGargoil=F(450);
		wManticore=F(500);
		wBat=F(500);
		wDragon=F(800);
		wUCSTransporter=F(550);
		wFlyingHarvester=F(1000);
		wCondor=F(500);

		wAACannon=1000;
		wAALaser=1000;
		wAAMinigun=1000;
		wAAPlasma=1000;
		wAARailgun=1000;

		wMG=1000;
		wRocket=1000;
		wCannon=1000;
		wLRCannon=1000;
		wElectro=1000;
		wSonic=1000;
		wPlasma=1000;
		wRailgun=1000;
		wMinigun=1000;
		wFlamethrower=1000;
		wLaser=1000;
		wGrenade=1000;
		wEarthquake=100;
		wLRLaser=1000;
		wShockwave=1000;
		wIonDestroyer=1000;
		wIon=1000;

		wPlasmaBomb=1000;
		wNapalmBomb=1000;
		wAtomBomb=1000;

		wCannonArtillery=1000;
		wPlasmaCannon=1000;
		wPlasmaArtillery=1000;
		wLightning=1000;
		wStalinOrgel=1000;
		wNuke=1000;

		wBanner=100;
		wAntirocket=100;
		wDetector=100;
		wShieldRegenerator=100;
		wRegenerator=100;
		wShadow=100;
		wRadar=100;
		wScreamer=100;
		wRepair=100;
		wCarrier=100;
		wTransporter=100;
	}

	function int Respawn(){
		unitex uUnit;
		int nCurrentDistancePoints;

		if(GetNumberOfUnits()<MAX_UNITS){
			for(newoneScriptIndex=0;newoneScriptIndex<MAX_UNITS;++newoneScriptIndex){
				uUnit=GetScriptUnit(newoneScriptIndex);
				if(uUnit){
					nCurrentDistancePoints=nCurrentDistancePoints+uUnit.DistanceTo(GetStartingPointX(), GetStartingPointY());
				}
			}
			SetLevel(10*(nMaxDistancePoints-nCurrentDistancePoints)/nMaxDistancePoints);
		}

		for(newoneScriptIndex=0;newoneScriptIndex<MAX_UNITS;++newoneScriptIndex){
			uUnit=GetScriptUnit(newoneScriptIndex);
			if(uUnit){
				uUnit.RegenerateAmmo();
			}else{
				CreateUnit();
				uUnit=GetScriptUnit(newoneScriptIndex);
			}
			if(uUnit.DistanceTo(newoneTargetX, newoneTargetY)>16){
				uUnit.CommandMove(newoneTargetX+Rand(16)-8, newoneTargetY+Rand(16)-8, 0);
			}
		}
	}

	state Initialize;
	state Nothing;

	state Initialize{
		SetName("TD Bot");
		SetMaxAttackFrequency(400);

		nGetRace=GetRace();
		newoneX=GetStartingPointX();
		newoneY=GetStartingPointY();
		EnableAIFeatures(aiBuildBuildings|aiControlOffense, false);
		EnableAIFeatures2(ai2BuildSappers, false);

		AddResearch("RES_MISSION_PACK1_ONLY");
		AddResearch("RES_MCH2"); //Upg: MG-Kugeln(Schaden: 20)
		AddResearch("RES_MCH3"); //Upg: MG-Kugeln(Schaden: 25)
		AddResearch("RES_MCH4"); //Upg: MG-Kugeln(Schaden: 30)
		AddResearch("RES_MSR2"); //Upg: Rakete(Schaden: 25)
		AddResearch("RES_MSR3"); //Upg: Rakete(Schaden: 30)
		AddResearch("RES_MSR4"); //Upg: Rakete(Schaden: 35)
		AddResearch("RES_MMR2"); //Upg: Schwere Rakete(Schaden: 45)
		AddResearch("RES_MMR3"); //Upg: Schwere Rakete(Schaden: 50)
		AddResearch("RES_MMR4"); //Upg: Schwere Rakete(Schaden: 60)
		if(nGetRace==raceED){
			AddResearch("RES_ED_UST2"); //Upg: Pamir 100
			AddResearch("RES_ED_UST3"); //Upg: Pamir 220
			AddResearch("RES_ED_UHT1"); //Kaukasus
			AddResearch("RES_ED_UHT2"); //Upg: Kaukasus
			AddResearch("RES_ED_UHT3"); //Upg: HT 500 Kaukasus
			AddResearch("RES_ED_UJP1"); //Rasputin
			AddResearch("RES_ED_UJP2"); //Upg: Rasputin 200
			AddResearch("RES_ED_UJP3"); //Upg: Rasputin 300
			AddResearch("RES_ED_UMT1"); //ZT 100 Sibiria
			AddResearch("RES_ED_UMT2"); //Upg: ZT 100 Sibiria
			AddResearch("RES_ED_UMT3"); //Upg: ZT 220 Sibiria
			AddResearch("RES_ED_UOH2"); //ZK Taiga 2
			AddResearch("RES_ED_UMI1"); //ZT 200 Minenleger
			AddResearch("RES_ED_UMI2"); //Upg: ZT 200 Minenleger
			AddResearch("RES_ED_UMW1"); //TK 100 Don(Amphibie)
			AddResearch("RES_ED_UMW2"); //Upg: TK 100 Don
			AddResearch("RES_ED_UMW3"); //Upg: TK 110 Don
			AddResearch("RES_EDUSTEALTH"); //Stealth Einheit
			AddResearch("RES_ED_UHW1"); //TL 70 Wolga
			AddResearch("RES_ED_UHW2"); //TL 80 Wolga
			AddResearch("RES_ED_USS2"); //ESS 40 Oka
			AddResearch("RES_ED_USS3"); //ESS 50 Oka
			AddResearch("RES_ED_UHS1"); //ESS 200 Baikal
			AddResearch("RES_ED_UHS2"); //ESS 300 Baikal
			AddResearch("RES_ED_USM1"); //Kiev
			AddResearch("RES_ED_USM2"); //Kiev II
			AddResearch("RES_ED_UA11"); //Kozak
			AddResearch("RES_ED_UA12"); //Upg: Kozak
			AddResearch("RES_ED_UA21"); //Ataman
			AddResearch("RES_ED_UA22"); //Upg: Ataman
			AddResearch("RES_EDUUT"); //Einheitentransporter
			AddResearch("RES_ED_UAHH1"); //Odin
			AddResearch("RES_ED_UAHH2"); //Upg: Odin 45Z
			AddResearch("RES_ED_UA41"); //Thor(schwerer Bomber)
			AddResearch("RES_ED_UA42"); //Upg: Thor
			AddResearch("RES_ED_UA31"); //Han(Bomber)
			AddResearch("RES_ED_UA32"); //Upg: Han
			AddResearch("RES_ED_AB1"); //Bomb-Bay(6 Bomben)
			AddResearch("RES_ED_AB2"); //Upg: Bomb-Bay(10 Bomben)
			AddResearch("RES_ED_MB2"); //Upg: Bombe(Schaden: 500)
			AddResearch("RES_ED_MB3"); //Upg: Bombe(Schaden: 600)
			AddResearch("RES_ED_MB4"); //Atombombe(Schaden: 1000)
			AddResearch("RES_ED_WCH2"); //Upg: MGs
			AddResearch("RES_EDWAA1"); //AA Gun
			AddResearch("RES_ED_ACH2"); //Upg: Helikopter-MGs
			AddResearch("RES_MCH2"); //Upg: MG-Kugeln(Schaden: 20)
			AddResearch("RES_MCH3"); //Upg: MG-Kugeln(Schaden: 25)
			AddResearch("RES_MCH4"); //Upg: MG-Kugeln(Schaden: 30)
			AddResearch("RES_ED_WCA2"); //Upg: Geschütz
			AddResearch("RES_ED_WHC1"); //Schweres Geschütz
			AddResearch("RES_ED_WHC2"); //Upg: Schweres Geschütz
			AddResearch("RES_ED_LRC"); //Longe Range Cannon
			AddResearch("RES_ED_MOBART"); //Mobile Artillerie
			AddResearch("RES_ED_MHC2"); //Upg: Schwere Kanonenkugel(Schaden: 60)
			AddResearch("RES_ED_MHC3"); //Upg: Schwere Kanonenkugel(Schaden: 70)
			AddResearch("RES_ED_MHC4"); //Upg: Schwere Kanonenkugel(Schaden: 80)
			AddResearch("RES_ED_MSC2"); //Upg: Kanonenkugel(Schaden: 35)
			AddResearch("RES_ED_MSC3"); //Upg: Kanonenkugel(Schaden: 40)
			AddResearch("RES_ED_MSC4"); //Upg: Kanonenkugel(Schaden: 45)
			AddResearch("RES_ED_WSR1"); //Raketenwerfer
			AddResearch("RES_ED_WSR2"); //Upg: Raketenwerfer
			AddResearch("RES_ED_WSR3"); //Upg: Raketenwerfer II
			AddResearch("RES_ED_WMR1"); //Schwerer Raketenwerfer
			AddResearch("RES_ED_WMR2"); //Upg: Schwerer Raketenwerfer
			AddResearch("RES_ED_WMR3"); //Upg: Schwerer Raketenwerfer II
			AddResearch("RES_ED_WHR1"); //Ballistischer Raketenwerfer
			AddResearch("RES_ED_MHR2"); //Upg: ballistische Rakete(Schaden: 500)
			AddResearch("RES_ED_MHR3"); //Upg: ballistische Rakete(Schaden: 600)
			AddResearch("RES_ED_MHR4"); //ballistische Atomrakete(Schaden: 1000)
			AddResearch("RES_ED_ASR1"); //Helikopter-Raketenwerfer
			AddResearch("RES_ED_ASR2"); //Upg: Helikopter-Raketenwerfer
			AddResearch("RES_ED_AMR1"); //Schwerer Helikopter-Raketenwerfer
			AddResearch("RES_ED_AMR2"); //Upg: Schwerer Helikopter-Raketenwerfer
			AddResearch("RES_ED_WSO1"); //Stalin Orgel
			AddResearch("RES_ED_WSO2"); //Upg: Stalin Orgel II
			AddResearch("RES_MMR2"); //Upg: Schwere Rakete(Schaden: 45)
			AddResearch("RES_MMR3"); //Upg: Schwere Rakete(Schaden: 50)
			AddResearch("RES_MMR4"); //Upg: Schwere Rakete(Schaden: 60)
			AddResearch("RES_MSR2"); //Upg: Rakete(Schaden: 25)
			AddResearch("RES_MSR3"); //Upg: Rakete(Schaden: 30)
			AddResearch("RES_MSR4"); //Upg: Rakete(Schaden: 35)
			AddResearch("RES_EDWAN1"); //AntiRakete
			AddResearch("RES_ED_WSL1"); //Lasergeschütz
			AddResearch("RES_ED_WSL2"); //Upg: Lasergeschütz
			AddResearch("RES_ED_WSL3"); //Upg: Lasergeschütz
			AddResearch("RES_ED_WHL1"); //Schweres Lasergeschütz
			AddResearch("RES_ED_WHL2"); //Upg: Schweres Lasergeschütz
			AddResearch("RES_ED_WHL3"); //Upg: Schweres Lasergeschütz
			AddResearch("RES_ED_LRL"); //Long Range Laser
			AddResearch("RES_ED_WHHLA1"); //Heavy Air Laser Cannon
			AddResearch("RES_ED_WHHLA2"); //Upg: Heavy Air Laser Cannon II
			AddResearch("RES_ED_WHHLA3"); //Upg: Heavy Air Laser Cannon III
			AddResearch("RES_ED_WHLA1"); //Heavy Air Laser Cannon
			AddResearch("RES_ED_WHLA2"); //Upg: Heavy Air Laser Cannon II
			AddResearch("RES_ED_WHLA3"); //Upg: Heavy Air Laser Cannon III
			AddResearch("RES_ED_WLAA1"); //AA Laser Cannon
			AddResearch("RES_ED_WLAA2"); //Upg: AA Laser Cannon II
			AddResearch("RES_ED_WSI1"); //Ionengeschütz
			AddResearch("RES_ED_WSI2"); //Upg: Ionengeschütz
			AddResearch("RES_ED_WHI1"); //Schweres Ionengeschütz
			AddResearch("RES_ED_WHI2"); //Upg: Schweres Ionengeschütz
			AddResearch("RES_ED_WHI3"); //Upg: Heavy ION Destroyer
			AddResearch("RES_EDWEQ1"); //Erdbebengenerator
			AddResearch("RES_EDWEQ2"); //Upg.Erdbebengenerator
			AddResearch("RES_ED_WSCL1"); //Shockwave Generator
			AddResearch("RES_ED_WSCL2"); //Upg: Shockwave Generator II
			AddResearch("RES_ED_WSCL3"); //Upg: Shockwave Generator III
			AddResearch("RES_ED_WSCH1"); //Heavy Shockwave Generator
			AddResearch("RES_ED_WSCH2"); //Upg: Heavy Shockwave Generator II
			AddResearch("RES_ED_WSCH3"); //Upg: Heavy Shockwave Generator III
			AddResearch("RES_ED_BMD"); //Mittleres Abwehrgebäude
			AddResearch("RES_EDBHT"); //Schwerer Turm
			AddResearch("RES_ED_BHD"); //Schweres Abwehrgebäude
			AddResearch("RES_ED_ART"); //Artillerie
			AddResearch("RES_ED_RepHand"); //RepTure-Einheit
			AddResearch("RES_ED_RepHand2"); //Upg: RepTure-Einheit
			AddResearch("RES_ED_BC1"); //Gebäudestürmer
			AddResearch("RES_ED_SCR"); //Upg: Radar
			AddResearch("RES_ED_SCR2"); //Upg: Screamer
			AddResearch("RES_ED_SCR3"); //Upg: Screamer II
			AddResearch("RES_ED_SGen"); //Energieschild-Generator
			AddResearch("RES_ED_MGen"); //Upg. Energieschild-Generator
			AddResearch("RES_ED_HGen"); //Upg. Energieschild-Generator
			AddResearch("RES_ED_SDI"); //SDI
			AddResearch("RES_ED_WSDI"); //SDI Defense Center
			AddResearch("RES_ED_UBT1"); //Ural(Doppelgeschützpanzer)
			AddResearch("RES_ED_UBT2"); //Upg: HT 800 Ural
			AddResearch("RES_ED_EDUOB2"); //Upg: Aufklärer
		}else if(nGetRace==raceLC){
			AddResearch("RES_LC_ULU2"); //Upg: Lunar
			AddResearch("RES_LC_ULU3"); //Upg: Lunar
			AddResearch("RES_LCUNH"); //New Hope (2.2)
			AddResearch("RES_LC_UNH1"); //New Hope
			AddResearch("RES_LC_UNH2"); //New Hope II
			AddResearch("RES_LC_UMO2"); //Upg: Moon
			AddResearch("RES_LC_UMO3"); //Upg: Moon
			AddResearch("RES_LC_LCSS1"); //Charon
			AddResearch("RES_LC_UCR1"); //Crater
			AddResearch("RES_LC_UCR2"); //Upg: Crater
			AddResearch("RES_LC_UCR3"); //Upg: Crater
			AddResearch("RES_LC_UHF1"); //Fang
			AddResearch("RES_LC_UHF2"); //Upg: Fang II
			AddResearch("RES_LC_UHF3"); //Upg: Fang III
			AddResearch("RES_LCUFG1"); //Fat Girl c2
			AddResearch("RES_LCUFG2"); //Fat Girl c3
			AddResearch("RES_LCUFG3"); //Fat Girl c4
			AddResearch("RES_LC_WARTILLERY"); //Plasma-Artillerie
			AddResearch("RES_LC_UHT2"); //Crion II
			AddResearch("RES_LC_UME1"); //Meteor (Jagdflieger)
			AddResearch("RES_LC_UME2"); //Upg: Meteor
			AddResearch("RES_LC_UME3"); //Upg: Meteor
			AddResearch("RES_LC_UBO1"); //Thunderer (Bomber)
			AddResearch("RES_LC_UBO2"); //Upg: Thunderer
			AddResearch("RES_LC_UAP1"); //Storm
			AddResearch("RES_LC_UAP2"); //Upg: Storm II
			AddResearch("RES_LC_UAP3"); //Upg: Storm III
			AddResearch("RES_LCUSF1"); //Super Fighter
			AddResearch("RES_LCUSF2"); //Super Fighter m2
			AddResearch("RES_LCUSF3"); //Upg: SuperFighter III
			AddResearch("RES_LCUUT"); //Einheitentransporter
			AddResearch("RES_LC_WCH2"); //Upg: Maschinengewehr
			AddResearch("RES_LC_ACH2"); //Upg: Luft-Maschinengewehr
			AddResearch("RES_LC_MCH2"); //Upg: 20 mm Bullets
			AddResearch("RES_LC_MCH3"); //Upg: 20 mm Bullets
			AddResearch("RES_LC_MCH4"); //Upg: 20 mm Bullets
			AddResearch("RES_LC_WSR2"); //Upg: Raketenwerfer
			AddResearch("RES_LC_WSR3"); //Upg: Raketenwerfer
			AddResearch("RES_LCWAN1"); //Antirocket
			AddResearch("RES_LC_ASR1"); //Luft Raketenwerfer
			AddResearch("RES_LC_ASR2"); //Upg: Luft Raketenwerfer
			AddResearch("RES_LC_WMR1"); //WMR
			AddResearch("RES_LC_WMR2"); //WMR2
			AddResearch("RES_LC_WMR3"); //WMR3
			AddResearch("RES_LC_METEORK"); //Meteoritenkontrollzentrum
			AddResearch("RES_LCCAA1"); //AA Raktenwerfer
			AddResearch("RES_LC_AMR1"); //AMR1
			AddResearch("RES_LC_AMR2"); //WMR2
			AddResearch("RES_LC_MMR2"); //Upg: Heavy Rocket (guided: 25%)
			AddResearch("RES_LC_MMR3"); //Upg: Heavy Rocket (guided: 50%)
			AddResearch("RES_LC_MMR4"); //Upg: Heavy Rocket (guided: 100%)
			AddResearch("RES_LC_WRG2"); //Upg: Railgun II
			AddResearch("RES_LC_WHRG1"); //Heavy Railgun
			AddResearch("RES_LC_WHRG2"); //Upg: Heavy Railgun II
			AddResearch("RES_LC_SLP"); //Sunlight Project
			AddResearch("RES_LC_WAARG1"); //AA Railgun
			AddResearch("RES_LC_MIS_HRG2"); //Ammo Heavy Railgun
			AddResearch("RES_LC_MIS_HRG3"); //Upg: Ammo Heavy Railgun II
			AddResearch("RES_LC_MIS_HRG4"); //Upg: Ammo Heavy Railgun III
			AddResearch("RES_LC_MIS_RG2"); //Ammo Railgun
			AddResearch("RES_LC_MIS_RG3"); //Upg: Ammo Railgun II
			AddResearch("RES_LC_MIS_RG4"); //Upg: Ammo Railgun III
			AddResearch("RES_LC_WSL1"); //Elektrogeschütz
			AddResearch("RES_LC_WSL2"); //Upg: Elektrogeschütz
			AddResearch("RES_LCUNH1"); //Plasmastrahl (2.2)
			AddResearch("RES_LC_WHL1"); //Schweres Elektrogeschütz
			AddResearch("RES_LC_WHL2"); //Upg: Schweres Elektrogeschütz
			AddResearch("RES_LC_WBART1"); //Mobile Lightning Generator
			AddResearch("RES_LC_WBART2"); //Upg: Mobile Lightning Generator II
			AddResearch("RES_LC_WAHE1"); //Heavy Air Electro-Cannon
			AddResearch("RES_LC_WAHE2"); //Upg: Heavy Air Electro-Cannon II
			AddResearch("RES_LC_WAE1"); //Air Electro-Cannon
			AddResearch("RES_LC_WAE2"); //Upg: Air Electro-Cannon II
			AddResearch("RES_LC_WHERO"); //Plasma Beam Projector
			AddResearch("RES_LC_WHERO2"); //Upg: Small Plasma Beam II
			AddResearch("RES_LC_WHP1"); //Heavy Plasma Beam I
			AddResearch("RES_LC_WHP2"); //Upg: Heavy Plasma Beam II
			AddResearch("RES_LC_WHP3"); //Upg: Heavy Plasma Beam III
			AddResearch("RES_LC_WHCART1"); //Plasma Cannon
			AddResearch("RES_LC_WHCART2"); //Upg: Plasma Cannon II
			AddResearch("RES_LC_WAAE1"); //AA Plasma Beam Projector
			AddResearch("RES_LC_WAAE2"); //Upg: AA Plasma Beam Projector II
			AddResearch("RES_LC_WSS1"); //Schallkanone
			AddResearch("RES_LC_WSS2"); //Upg: Schallkanone
			AddResearch("RES_LC_WHS1"); //Schwere Schallkanone
			AddResearch("RES_LC_WHS2"); //Upg: Schwere Schallkanone
			AddResearch("RES_LC_WAS1"); //Air Schallkanone
			AddResearch("RES_LC_WAS2"); //Upg: Luft-Schallkanone
			AddResearch("RES_LCWEQ1"); //Erdbebengenerator
			AddResearch("RES_LCWEQ2"); //Upg.Erdbebengenerator
			AddResearch("RES_LC_MSR2"); //Upg: Rocket (guided: 25%)
			AddResearch("RES_LC_MSR3"); //Upg: Rocket (guided: 50%)
			AddResearch("RES_LC_MSR4"); //Upg: Rocket (guided: 100%)
			AddResearch("RES_LCBNE"); //NEST
			AddResearch("RES_LC_BMD"); //Mittleres Abwehrgebäude
			AddResearch("RES_LC_BHD"); //Schweres Abwehrgebäude
			AddResearch("RES_LC_BPM"); //Peacemaker
			AddResearch("RES_LC_BWC"); //Wetterkontrollzentrum
			AddResearch("RES_LC_ART"); //Artillerie
			AddResearch("RES_LCBPP2"); //Xylit Kraftwerk
			AddResearch("RES_LC_LCBMR2"); //Mine upg.
			AddResearch("RES_LCMINEUPD"); //Mine upg.
			AddResearch("RES_LC_SDIDEF"); //SDI-Laser
			AddResearch("RES_LC_SGen"); //Energieschild-Generator
			AddResearch("RES_LC_MGen"); //Upg: Energieschild-Generator
			AddResearch("RES_LC_HGen"); //Upg: Energieschild-Generator
			AddResearch("RES_LC_SHR1"); //Schild-Akku
			AddResearch("RES_LC_SHR2"); //Upg: Schild-Akku I
			AddResearch("RES_LC_SHR3"); //Upg: Schild-Akku II
			AddResearch("RES_LC_REG1"); //Regenerator
			AddResearch("RES_LC_REG2"); //Upg: Regenerator I
			AddResearch("RES_LC_REG3"); //Upg: Regenerator II
			AddResearch("RES_LC_BC1"); //Gebäudestürmer
			AddResearch("RES_LC_SOB1"); //Detektor
			AddResearch("RES_LC_SOB2"); //Upg: Detektor
			AddResearch("RES_LC_SOB3"); //Detektor II (2.2)
			AddResearch("RES_LCUOB2"); //Detektor II (2.2)
			AddResearch("RES_LC_UTD2"); //Upg: Mercury II
			AddResearch("RES_LC_UCU1"); //Crusher
			AddResearch("RES_LC_UCU2"); //Crusher II
			AddResearch("RES_LC_UCU3"); //Crusher III
		}else if(nGetRace==raceUCS){
			AddResearch("RES_UCS_USL2"); //Upg: Tiger I
			AddResearch("RES_UCS_USL3"); //Upg: Tiger II
			AddResearch("RES_UCS_UML1"); //Spider
			AddResearch("RES_UCS_UML2"); //Upg: Spider I
			AddResearch("RES_UCS_UML3"); //Upg: Spider II
			AddResearch("RES_UCS_UTAR1"); //Tarantula
			AddResearch("RES_UCS_UTAR2"); //Upg: Tarantula II
			AddResearch("RES_UCS_UTAR3"); //Upg: Tarantula III
			AddResearch("RES_UCS_UHL1"); //Panther
			AddResearch("RES_UCS_UHL2"); //Upg: Panther I
			AddResearch("RES_UCS_UHL3"); //Upg: Panther II
			AddResearch("RES_UCS_UMI1"); //Minenleger
			AddResearch("RES_UCS_UMI2"); //Upg: Minenleger
			AddResearch("RES_UCS_UOH2"); //Upg: Erntefahrzeug
			AddResearch("RES_UCS_UOH3"); //Upg: Erntefahrzeug II
			AddResearch("RES_UCS_UAH1"); //Fliegendes Erntefahrzeug I
			AddResearch("RES_UCS_UAH2"); //Fliegendes Erntefahrzeug II
			AddResearch("RES_UCS_UAH3"); //Fliegendes Erntefahrzeug III
			AddResearch("RES_UCS_GARG1"); //Gargoil
			AddResearch("RES_UCS_GARG2"); //Upg: Gargoil
			AddResearch("RES_UCS_GARG3"); //Upg: Gargoil II
			AddResearch("RES_UCS_UAST1"); //Manticore (Stealth)
			AddResearch("RES_UCS_UAST2"); //Manticore II
			AddResearch("RES_UCSUUT"); //Einheitentransporter
			AddResearch("RES_UCS_BOMBER21"); //Bat (Bomber)
			AddResearch("RES_UCS_BOMBER22"); //Upg: Bat
			AddResearch("RES_UCS_BOMBER31"); //Dragon (schwerer Bomber)
			AddResearch("RES_UCS_BOMBER32"); //Upg: Dragon
			AddResearch("RES_UCS_WAPB1"); //Bomb-bay
			AddResearch("RES_UCS_WAPB2"); //Upg: Bomb-bay
			AddResearch("RES_UCS_WCH2"); //Doppel-MG
			AddResearch("RES_UCS_WGATL2"); //Upg: Minigun
			AddResearch("RES_UCS_WGATH1"); //Heavy Minigun
			AddResearch("RES_UCS_WGATH2"); //Upg: Heavy Minigun II
			AddResearch("RES_UCS_MHMG2"); //Heavy Minigun Ammo I
			AddResearch("RES_UCS_MHMG3"); //Heavy Minigun Ammo II
			AddResearch("RES_UCS_MHMG4"); //Heavy Minigun Ammo III
			AddResearch("RES_UCS_WGATAA1"); //AA Minigun
			AddResearch("RES_UCS_WGATAA2"); //Upg: AA Minigun II
			AddResearch("RES_UCS_MCH2"); //Upg: 20 mm Bullets
			AddResearch("RES_UCS_MCH3"); //Upg: 20 mm Bullets
			AddResearch("RES_UCS_MCH4"); //Upg: 20 mm Bullets
			AddResearch("RES_UCS_WACH2"); //Upg Gargoil-Maschinengewehr
			AddResearch("RES_UCS_WGATHA1"); //Heavy Air Minigun
			AddResearch("RES_UCS_WGATHA2"); //Upg: Heavy Air Minigun II
			AddResearch("RES_UCS_WSR1"); //*Kleiner Raketenwerfer
			AddResearch("RES_UCS_WSR2"); //*Upg: Kleiner Raketenwerfer I
			AddResearch("RES_UCS_WSR3"); //*Upg: Kleiner Raketenwerfer II
			AddResearch("RES_UCS_WMR1"); //Raketenwerfer
			AddResearch("RES_UCS_WMR2"); //Upg: Raketenwerfer I
			AddResearch("RES_UCS_WMR3"); //Upg: Raketenwerfer II
			AddResearch("RES_UCS_WASR1"); //Gargoil-Raketenwerfer
			AddResearch("RES_UCS_WASR2"); //Upg: Gargoil-Raketenwerfer
			AddResearch("RES_UCS_WAMR1"); //Bomber-Raketenwerfer
			AddResearch("RES_UCS_WAMR2"); //Upg: Bomber-Raketenwerfer
			AddResearch("RES_UCS_MMR2"); //Upg: Heavy Rocket (guided: 25%)
			AddResearch("RES_UCS_MMR3"); //Upg: Heavy Rocket (guided: 50%)
			AddResearch("RES_UCS_MMR4"); //Upg: Heavy Rocket (guided: 100%)
			AddResearch("RES_UCS_MSR2"); //*Upg: Rocket (guided: 25%)
			AddResearch("RES_UCS_MSR3"); //*Upg: Rocket (guided: 50%)
			AddResearch("RES_UCS_MSR4"); //*Upg: Rocket (guided: 100%)
			AddResearch("RES_UCSWAN1"); //AntiRakete
			AddResearch("RES_UCS_WSG2"); //Upg: Granatenwerfer
			AddResearch("RES_UCS_WHG1"); //Schwerer Granatenwerfer
			AddResearch("RES_UCS_WHG2"); //Upg: Schwerer Granatenwerfer
			AddResearch("RES_UCS_MHG2"); //Upg: Grenade
			AddResearch("RES_UCS_MHG3"); //Upg: Grenade
			AddResearch("RES_UCS_MHG4"); //Upg: Grenade
			AddResearch("RES_UCS_MG2"); //Upg: Granate (Schaden: 35)
			AddResearch("RES_UCS_MG3"); //Upg: Granate (Schaden: 40)
			AddResearch("RES_UCS_MG4"); //Upg: Granate (Schaden: 45)
			AddResearch("RES_UCS_WSP1"); //Plasmageschütz
			AddResearch("RES_UCS_WSP2"); //Upg: Plasma Cannon II
			AddResearch("RES_UCS_WHP1"); //Schwere Plasmageschütze
			AddResearch("RES_UCS_WHP2"); //Upg: Schwere Plasmageschütze I
			AddResearch("RES_UCS_WHP3"); //Upg: Schwere Plasmageschütze II
			AddResearch("RES_UCS_WART1"); //Mobile Plasma Artillery
			AddResearch("RES_UCS_WART2"); //Upg: Mobile Plasma Artillery II
			AddResearch("RES_UCSWAP1"); //Gargoil Plasma Kanone
			AddResearch("RES_UCSWAP2"); //Gargoil Plasma Kanone m2
			AddResearch("RES_UCS_MB2"); //Upg: Plasmabombe (Schaden: 500)
			AddResearch("RES_UCS_MB3"); //Upg: Plasmabombe (Schaden: 600)
			AddResearch("RES_UCS_MB4"); //Upg: Plasmabombe (Schaden: 1000)
			AddResearch("RES_UCSCAA1"); //AA PlasmaKanone
			AddResearch("RES_UCSCAA2"); //AA PlasmaKanone II
			AddResearch("RES_UCS_PC"); //Offensive Plasmakanone
			AddResearch("RES_UCSWEQ1"); //Erdbebengenerator
			AddResearch("RES_UCSWEQ2"); //Upg. Erdbebengen.
			AddResearch("RES_UCSWTSC1"); //Kanone
			AddResearch("RES_UCSWTSC2"); //DoppelKanone 105mm
			AddResearch("RES_UCSWBHC1"); //DoppelKanone 120mm
			AddResearch("RES_UCSWBHC2"); //Vierfach Kanone 120mm
			AddResearch("RES_UCS_WCART1"); //Mobile Cannon Artillery
			AddResearch("RES_UCS_WCART2"); //Upg: Mobile Cannon Artillery II
			AddResearch("RES_UCS_MHC2"); //Upg: 120mm Munition
			AddResearch("RES_UCS_MHC3"); //Upg: 120mm Munition
			AddResearch("RES_UCS_MHC4"); //Upg: 120mm Munition
			AddResearch("RES_UCS_MSC2"); //Upg: 105mm Munition
			AddResearch("RES_UCS_MSC3"); //Upg: 105mm Munition
			AddResearch("RES_UCS_MSC4"); //Upg: 105mm Munition
			AddResearch("RES_UCS_WFL1"); //Flamethrower
			AddResearch("RES_UCS_WFL2"); //Upg: Flamethrower II
			AddResearch("RES_UCS_WFLH1"); //Heavy Flamethrower
			AddResearch("RES_UCS_WFLH2"); //Upg: Heavy Flamethrower II
			AddResearch("RES_UCS_BFLT"); //Flametower
			AddResearch("RES_UCS_FB2"); //Upg: Napalm BombBay Ammo II
			AddResearch("RES_UCS_FB3"); //Upg: Napalm BombBay Ammo III
			AddResearch("RES_UCS_FB4"); //Upg: Napalm BombBay Ammo IV
			AddResearch("RES_UCS_MIS_FLH2"); //Upg: Black Napalm II
			AddResearch("RES_UCS_MIS_FLH3"); //Upg: Black Napalm III
			AddResearch("RES_UCS_MIS_FLH4"); //Upg: Black Napalm IV
			AddResearch("RES_UCS_MIS_FL2"); //Upg: Napalm II
			AddResearch("RES_UCS_MIS_FL3"); //Upg: Napalm III
			AddResearch("RES_UCS_MIS_FL4"); //Upg: Napalm IV
			AddResearch("RES_UCS_BMD"); //Mittleres Abwehrgebäude
			AddResearch("RES_UCSBHT"); //Schwerer Turm
			AddResearch("RES_UCS_BHD"); //Schweres Abwehrgebäude
			AddResearch("RES_UCS_ART"); //Artillerie
			AddResearch("RES_UCS_WSD"); //SDI-Laser
			AddResearch("RES_UCS_RepHand"); //RepTure-Einheit
			AddResearch("RES_UCS_RepHand2"); //Upg: RepTure-Einheit
			AddResearch("RES_UCS_BC1"); //Gebäudestürmer
			AddResearch("RES_UCS_SGen"); //Schildgenerator
			AddResearch("RES_UCS_MGen"); //Upg. Schildgenerator
			AddResearch("RES_UCS_HGen"); //Upg. Schildgenerator
			AddResearch("RES_UCS_URAD2"); //Upg: Radar II
			AddResearch("RES_UCS_SHD"); //Schattengenerator
			AddResearch("RES_UCS_SHD2"); //Upg: Schattengenerator I
			AddResearch("RES_UCS_SHD3"); //Upg: Schattengenerator II
			AddResearch("RES_UCS_SHD4"); //Upg: Schattengenerator III
			AddResearch("RES_UCS_UBL1"); //Jaguar
			AddResearch("RES_UCS_UBL2"); //Jaguar
			AddResearch("RES_UCS_U4L1"); //Grizzly
			AddResearch("RES_UCS_U4L2"); //Grizzly II
			AddResearch("RES_UCS_U4L3"); //Grizzly III
			AddResearch("RES_UCSUCS"); //Cargo Salamander
			AddResearch("RES_UCS_USS2"); //Shark II
			AddResearch("RES_UCS_UBS1"); //Hydra I
			AddResearch("RES_UCS_UBS2"); //Hydra II
			AddResearch("RES_UCS_UBS3"); //Hydra III
			AddResearch("RES_UCS_USM1"); //Orca I
			AddResearch("RES_UCS_USM2"); //Orca II
			AddResearch("RES_UCS_UCSUOB2"); //Aufklärer II
		}

		return Nothing;
	}

	state Nothing{
		++nTimer;
		if(rEnemy!=GetMainEnemy()){
			rEnemy=GetMainEnemy();
			if(rEnemy){
				newoneTargetX=rEnemy.GetStartingPointX();
				newoneTargetY=rEnemy.GetStartingPointY();
				nMaxDistancePoints=Distance(newoneX, newoneY, newoneTargetX, newoneTargetY)*MAX_UNITS;
			}
		}
		if(rEnemy){
			Respawn();
		}

		return Nothing, 240;
	}
}
