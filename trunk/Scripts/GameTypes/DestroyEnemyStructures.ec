/* Copyright 2009, 2010 surrim
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

mission "translateGameTypeDestroyStructures"{
	consts{
		/** ScriptData Index **/
		//Player.ScriptData indexes
		//DISTANCE_0  =  0; //ally 0 or distance to player 0
		//DISTANCE_14 = 14; //ally 14 or distance to player 14
		TO_ALLY       = 15; //number of stored allies
		DEAD          = 16; //true or false
		HASBUILD      = 17; //true or false
		TEAM          = 18; //ScriptData(TEAM) contains the team number
			//Player.ScriptData(TEAM) values
			//TEAM_0      =  0;
			//TEAM_14     = 14; //max. 14 teams (14er FFA)
			WATCHER       = 15;

		DEFAULT_DISTANCE = 25;

		DEFAULT_MONEY  =      25000;
		TECHWAR_MONEY  = 1000000000;

		//comboCashType
		MINE_FOR_MONEY    = 0;
		MINE_FOR_MONEY_XL = 1;
		MINE_FOREVER      = 2;
		CR15000           = 3;
		CR20000           = 4;
		CR25000           = 5;
		CR30000           = 6;
		CR40000           = 7;
		TECHWAR           = 8;

		//comboResearchTime
		RESEARCH_1X      = 0;
		RESEARCH_2X      = 1;
		RESEARCH_4X      = 2;
		RESEARCH_8X      = 3;
		RESEARCH_ENDLESS = 4;
		RESEARCH_TECHWAR = 5;

		//comboResearchLimit
		RESEARCH_ALL              = 0;
		RESEARCH_NO_BOMBS         = 1;
		RESEARCH_NO_MDW           = 2;
		RESEARCH_NO_BOMBS_AND_MDW = 3;

		//comboUnitsLimit
		UNITS_ALL         = 0;
		UNITS_SMALL       = 1;
		UNITS_PANZER_ONLY = 2;
		UNITS_NO_IMBA     = 3;

		//comboStartingUnits
		DEFAULT      = 0;
		BUILDER_ONLY = 1;

		//comboExtras
		EXTRA_NONE          = 0;
		EXTRA_BEAUTIFULMOON = 1;
	}

	int nMaxDistance;         //max allowed distance of new building from starting point
	int nMaxPossibleDistance; //max relevant distance
	int nCashRate;            //uncle sam money
	int mToKill;              //iff mask of killed players and watchers
	int nGetRight;            //GetRight(), better performance
	int nGetBottom;           //GetBottom(), better performance
	int nGetRight2;           //GetRight()/2, better performance
	int nGetBottom2;          //GetBottom()/2, better performance

	enum comboCashType{
		"translateScriptMineForMoney", //MINE_FOR_MONEY
		"XL",                          //MINE_FOR_MONEY_XL
		"Endless Resources",           //MINE_FOREVER
		"15000 CR/min",                //CR15000
		"20000 CR/min",                //CR20000
		"25000 CR/min",                //CR25000
		"30000 CR/min",                //CR30000
		"40000 CR/min",                //CR40000
		"TechWar",                     //TECHWAR
	multi:
		"translateScriptGainingMoney"
	}

	enum comboResearchTime{
		"translateScriptNormalTime", //RESEARCH_1X
		"translateScript2xfaster",   //RESEARCH_2X
		"translateScript4xfaster",   //RESEARCH_4X
		"translateScript8xfaster",   //RESEARCH_8X
		"translateEditorAliens",     //RESEARCH_ENDLESS
		"TechWar",                   //RESEARCH_TECHWAR
	multi:
		"translateScriptResearchTime"
	}

	enum comboResearchLimit{
		"translateScriptAllResearches",            //RESEARCH_ALL
		"translateScriptNoBombs",                  //RESEARCH_NO_BOMBS
		"translateScriptNoMassDestructionWeapons", //RESEARCH_NO_MDW
		"translateScriptNoBombsAndMDW",            //RESEARCH_NO_BOMBS_AND_MDW
	multi:
		"translateScriptAvailableResearches"
	}

	enum comboUnitsLimit{
		"translateGameMenuUnitsLimitNoLimit", //UNITS_ALL
		"translateEditorNewSmall",            //UNITS_SMALL
		"translateEDUMM41",                   //UNITS_PANZER_ONLY
		"XL Units",                           //UNITS_NO_IMBA
	multi:
		"translateGameMenuUnitsLimit"
	}

	enum comboStartingUnits{
		"translateGameMenuStartingUnitsDefault",     //DEFAULT
		"translateGameMenuStartingUnitsBuilderOnly", //BUILDER_ONLY
	multi:
		"translateGameMenuStartingUnits"
	}

	enum comboExtras{
		"translateOptionAdditionalInfoNone", //EXTRA_NONE
		"translateNEASHOWMAP0",              //EXTRA_BEAUTIFULMOON
	multi:
		"Extras:"
	}

	function int IsActivePlayer(player rPlayer){
		if(rPlayer!=null && rPlayer.IsAlive() && rPlayer.GetScriptData(TEAM)!=WATCHER && !rPlayer.GetScriptData(DEAD)){
			return true;
		}
		return false;
	}

	function int IsBot(player rPlayer){
		if(rPlayer.GetMaxAttackFrequency()!=200){
			return true;
		}
		return false;
	}

	function int DisablePlayer(player rPlayer){
		rPlayer.SetMaxDistance(0);
		rPlayer.EnableAI(false);
		rPlayer.EnableAIFeatures(aiBuildBuildings, false);
		rPlayer.EnableCommand(commandBuildBuilding, false);
		mToKill=mToKill|rPlayer.GetIFF();
	}

	function int TeamExists(int nTeam){
		player rPlayer;
		int i;

		for(i=0;i<15;++i){
			rPlayer=GetPlayer(i);
			if(rPlayer!=null && rPlayer.GetScriptData(TEAM)==nTeam){
				return true;
			}
		}
		return false;
	}

	function int CreateTeams(int nMaxPlayerDistance){
		player rPlayer;
		player rPlayer2;
		int rPlayerTeam;
		int i;
		int j;

		for(i=0;i<15;++i){ //every player gets his own team
			rPlayer=GetPlayer(i);
			if(rPlayer!=null && rPlayer.GetScriptData(TEAM)!=WATCHER){
				rPlayer.SetScriptData(TEAM, i);
			}
		}

		for(i=0;i<15;++i){ //let rPlayer2 join rPlayer's team when required
			rPlayer=GetPlayer(i);
			if(rPlayer){
				rPlayerTeam=rPlayer.GetScriptData(TEAM);
				if(rPlayerTeam!=WATCHER){
					for(j=i+1;j<15;++j){
						rPlayer2=GetPlayer(j);
						if(rPlayer2!=null && rPlayer2.GetScriptData(TEAM)!=WATCHER && rPlayer.GetScriptData(j)<=nMaxPlayerDistance){
							rPlayer2.SetScriptData(TEAM, rPlayerTeam);
						}
					}
				}
			}
		}

		j=0;
		for(i=0;i<15;++i){ //count teams
			if(TeamExists(i)){
				++j;
			}
		}

		return j; //return number of teams
	}

	function int IsEnded(){
		player rPlayer;
		player rPlayer2;
		int i;
		int j;
		int bOneHasBeenDestroyed;

		for(i=0;i<15;++i){
			rPlayer=GetPlayer(i);
			if(rPlayer!=null && rPlayer.GetScriptData(TEAM)!=WATCHER){
				if(rPlayer.IsAlive() && !rPlayer.GetScriptData(DEAD)){
					for(j=i+1;j<15;++j){
						rPlayer2=GetPlayer(j);
						if(IsActivePlayer(rPlayer2) && !rPlayer.IsAlly(rPlayer2)){
							return false; //exit when somebody isn't allied
						}
					}
				}else{
					bOneHasBeenDestroyed=true;
				}
			}
		}
		return bOneHasBeenDestroyed;
	}

	function int FindTeamSize(int nTeamSize, int nMax){
		int nMin;
		int nAvg;

		while(nMin+1<nMax){
			nAvg=(nMin+nMax)/2;
			if(CreateTeams(nAvg)>nTeamSize){
				nMin=nAvg;
			}else{
				nMax=nAvg;
			}
		}
		return nMax;
	}

	function int IsEmptyPoint(int x, int y){
		if(x>=17 && x<nGetRight-17 && y>=17 && y<nGetBottom-17 && GetUnit(x, y, 0)==null){
			return true;
		}
		return false;
	}

	function int EnableResearch(player rPlayer, string strResearchID, int nEnable){
		if(nEnable){
			if(comboResearchTime==RESEARCH_TECHWAR){
				rPlayer.AddResearch(strResearchID);
			}
		}else{
			rPlayer.EnableResearch(strResearchID, false);
		}
	}

	function int Ally(player rPlayer, player rPlayer2){
		if(!IsBot(rPlayer) || IsBot(rPlayer2)){
			rPlayer.SetAlly(rPlayer2);
		}else{
			rPlayer2.SetAlly(rPlayer);
		}
	}

	function int ArrangeAlly(player rPlayer, player rPlayer2){
		int nToAlly;

		nToAlly=rPlayer2.GetScriptData(TO_ALLY);
		rPlayer2.SetScriptData(nToAlly, rPlayer.GetIFFNumber());
		rPlayer2.SetScriptData(TO_ALLY, nToAlly+1);
	}

	state Initialize;
	state Ally;
	state Nothing;

	state Initialize{
		player rPlayer;
		player rPlayer2;
		int i;
		int j;
		int nStartingPointX;
		int nStartingPointY;
		int nD34;
		int nD23;
		int nD12;

		int bHasTrade;
		int bHasMDW;
		int bHasBombs;
		int bHasAir;
		int bHasBig;
		int bImba;
		int bIsHuman;
		int bHasBots;

		SetConsoleText("0:00");
		nGetRight=GetRight();
		nGetBottom=GetBottom();
		nGetRight2=nGetRight/2;
		nGetBottom2=nGetBottom/2;
		nMaxDistance=DEFAULT_DISTANCE;
		nMaxPossibleDistance=Distance(GetLeft(), GetTop(), nGetRight, nGetBottom);

		if(comboCashType==MINE_FOR_MONEY || comboCashType==MINE_FOR_MONEY_XL || comboCashType==MINE_FOREVER){
			bHasTrade=true;
		}
		if(comboResearchLimit==RESEARCH_ALL || comboResearchLimit==RESEARCH_NO_BOMBS){
			bHasMDW=true;
		}
		if(comboResearchLimit==RESEARCH_ALL || comboResearchLimit==RESEARCH_NO_MDW){
			bHasBombs=true;
		}
		bHasAir=true;
		bHasBig=true;
		bImba=true;
		if(comboUnitsLimit==UNITS_PANZER_ONLY){
			bHasAir=false;
		}else if(comboUnitsLimit==UNITS_SMALL){
			bHasBig=false;
		}else if(comboUnitsLimit==UNITS_NO_IMBA){
			bImba=false;
		}

		if(comboCashType==MINE_FOR_MONEY){
			ResourcesPerContainer(2);
		}else if(comboCashType==MINE_FOR_MONEY_XL){
			ResourcesPerContainer(1);
		}else if(comboCashType==MINE_FOREVER){
			ResourcesPerContainer(-10);
		}else if(comboCashType==CR15000){
			nCashRate=15000;
		}else if(comboCashType==CR20000){
			nCashRate=20000;
		}else if(comboCashType==CR25000){
			nCashRate=25000;
		}else if(comboCashType==CR30000){
			nCashRate=30000;
		}else if(comboCashType==CR40000){
			nCashRate=40000;
		}

		if(comboResearchTime==RESEARCH_2X){
			SetTimeDivider(2);
		}else if(comboResearchTime==RESEARCH_4X){
			SetTimeDivider(4);
		}else if(comboResearchTime==RESEARCH_8X){
			SetTimeDivider(8);
		}else if(comboResearchTime==RESEARCH_ENDLESS){
			SetTimeDivider(65535);
		}

		for(i=0;i<15;++i){
			rPlayer=GetPlayer(i);
			if(rPlayer){
				bIsHuman=IsBot(rPlayer)^1;
				if(!bIsHuman){
					bHasBots=true;
				}

				//researches
				rPlayer.AddResearch("RES_MISSION_PACK1_ONLY");
				EnableResearch(rPlayer, "RES_MCH2", true); //Upg: MG-Kugeln (Schaden: 20)
				EnableResearch(rPlayer, "RES_MCH3", true); //Upg: MG-Kugeln (Schaden: 25)
				EnableResearch(rPlayer, "RES_MCH4", true); //Upg: MG-Kugeln (Schaden: 30)
				EnableResearch(rPlayer, "RES_MSR2", true); //Upg: Rakete (Schaden: 25)
				EnableResearch(rPlayer, "RES_MSR3", true); //Upg: Rakete (Schaden: 30)
				EnableResearch(rPlayer, "RES_MSR4", true); //Upg: Rakete (Schaden: 35)
				EnableResearch(rPlayer, "RES_MMR2", bHasBig); //Upg: Schwere Rakete (Schaden: 45)
				EnableResearch(rPlayer, "RES_MMR3", bHasBig); //Upg: Schwere Rakete (Schaden: 50)
				EnableResearch(rPlayer, "RES_MMR4", bHasBig); //Upg: Schwere Rakete (Schaden: 60)
				if(rPlayer.GetRace()==raceED){
					rPlayer.EnableBuilding("EDBLZ", false);
					rPlayer.EnableBuilding("EDBTC", false);

					if(comboResearchTime==RESEARCH_TECHWAR){
						rPlayer.EnableBuilding("EDBRC", false); //Research Center
					}

					if(!bHasTrade){
						rPlayer.EnableBuilding("EDBBMI", false); //Mine
						rPlayer.EnableBuilding("EDBBRE", false); //Refinery
					}

					EnableResearch(rPlayer, "RES_ED_UST2", true); //Upg: Pamir 100
					EnableResearch(rPlayer, "RES_ED_UST3", true); //Upg: Pamir 220
					EnableResearch(rPlayer, "RES_ED_UHT1", bHasBig); //Kaukasus
					EnableResearch(rPlayer, "RES_ED_UHT2", bHasBig); //Upg: Kaukasus
					EnableResearch(rPlayer, "RES_ED_UHT3", bHasBig); //Upg: HT 500 Kaukasus
					EnableResearch(rPlayer, "RES_ED_UJP1", bHasBig); //Rasputin
					EnableResearch(rPlayer, "RES_ED_UJP2", bHasBig); //Upg: Rasputin 200
					EnableResearch(rPlayer, "RES_ED_UJP3", bHasBig); //Upg: Rasputin 300
					EnableResearch(rPlayer, "RES_ED_UMT1", true); //ZT 100 Sibiria
					EnableResearch(rPlayer, "RES_ED_UMT2", true); //Upg: ZT 100 Sibiria
					EnableResearch(rPlayer, "RES_ED_UMT3", true); //Upg: ZT 220 Sibiria
					EnableResearch(rPlayer, "RES_ED_UOH2", true); //ZK Taiga 2
					EnableResearch(rPlayer, "RES_ED_UMI1", true); //ZT 200 Minenleger
					EnableResearch(rPlayer, "RES_ED_UMI2", true); //Upg: ZT 200 Minenleger
					EnableResearch(rPlayer, "RES_ED_UMW1", true); //TK 100 Don (Amphibie)
					EnableResearch(rPlayer, "RES_ED_UMW2", true); //Upg: TK 100 Don
					EnableResearch(rPlayer, "RES_ED_UMW3", true); //Upg: TK 110 Don
					EnableResearch(rPlayer, "RES_EDUSTEALTH", true); //Stealth Einheit
					EnableResearch(rPlayer, "RES_ED_UHW1", bHasBig); //TL 70 Wolga
					EnableResearch(rPlayer, "RES_ED_UHW2", bHasBig); //TL 80 Wolga
					EnableResearch(rPlayer, "RES_ED_USS2", true); //ESS 40 Oka
					EnableResearch(rPlayer, "RES_ED_USS3", true); //ESS 50 Oka
					EnableResearch(rPlayer, "RES_ED_UHS1", bHasBig); //ESS 200 Baikal
					EnableResearch(rPlayer, "RES_ED_UHS2", bHasBig); //ESS 300 Baikal
					EnableResearch(rPlayer, "RES_ED_USM1", bHasBig&bImba); //Kiev
					EnableResearch(rPlayer, "RES_ED_USM2", bHasBig&bImba); //Kiev II
					EnableResearch(rPlayer, "RES_ED_UA11", bHasAir); //Kozak
					EnableResearch(rPlayer, "RES_ED_UA12", bHasAir); //Upg: Kozak
					EnableResearch(rPlayer, "RES_ED_UA21", bHasAir); //Ataman
					EnableResearch(rPlayer, "RES_ED_UA22", bHasAir); //Upg: Ataman
					EnableResearch(rPlayer, "RES_EDUUT", bHasAir&bIsHuman); //Einheitentransporter
					EnableResearch(rPlayer, "RES_ED_UAHH1", bHasBig&bHasAir); //Odin
					EnableResearch(rPlayer, "RES_ED_UAHH2", bHasBig&bHasAir); //Upg: Odin 45Z
					EnableResearch(rPlayer, "RES_ED_UA41", bHasBig&bHasAir); //Thor (schwerer Bomber)
					EnableResearch(rPlayer, "RES_ED_UA42", bHasBig&bHasAir); //Upg: Thor
					EnableResearch(rPlayer, "RES_ED_UA31", bHasBig&bHasAir); //Han (Bomber)
					EnableResearch(rPlayer, "RES_ED_UA32", bHasBig&bHasAir); //Upg: Han
					EnableResearch(rPlayer, "RES_ED_AB1", bHasBig&bHasAir&bHasBombs&bImba); //Bomb-Bay (6 Bomben)
					EnableResearch(rPlayer, "RES_ED_AB2", bHasBig&bHasAir&bHasBombs&bImba); //Upg: Bomb-Bay (10 Bomben)
					EnableResearch(rPlayer, "RES_ED_MB2", bHasBig&bHasAir&bHasBombs&bImba); //Upg: Bombe (Schaden: 500)
					EnableResearch(rPlayer, "RES_ED_MB3", bHasBig&bHasAir&bHasBombs&bImba); //Upg: Bombe (Schaden: 600)
					EnableResearch(rPlayer, "RES_ED_MB4", bHasBig&bHasAir&bHasBombs&bImba); //Atombombe (Schaden: 1000)
					EnableResearch(rPlayer, "RES_ED_WCH2", true); //Upg: MGs
					EnableResearch(rPlayer, "RES_EDWAA1", true); //AA Gun
					EnableResearch(rPlayer, "RES_ED_ACH2", bHasAir); //Upg: Helikopter-MGs
					EnableResearch(rPlayer, "RES_MCH2", true); //Upg: MG-Kugeln (Schaden: 20)
					EnableResearch(rPlayer, "RES_MCH3", true); //Upg: MG-Kugeln (Schaden: 25)
					EnableResearch(rPlayer, "RES_MCH4", true); //Upg: MG-Kugeln (Schaden: 30)
					EnableResearch(rPlayer, "RES_ED_WCA2", true); //Upg: Geschütz
					EnableResearch(rPlayer, "RES_ED_WHC1", bHasBig); //Schweres Geschütz
					EnableResearch(rPlayer, "RES_ED_WHC2", bHasBig); //Upg: Schweres Geschütz
					EnableResearch(rPlayer, "RES_ED_LRC", bHasBig); //Longe Range Cannon
					EnableResearch(rPlayer, "RES_ED_MOBART", bHasBig); //Mobile Artillerie
					EnableResearch(rPlayer, "RES_ED_MHC2", bHasBig); //Upg: Schwere Kanonenkugel (Schaden: 60)
					EnableResearch(rPlayer, "RES_ED_MHC3", bHasBig); //Upg: Schwere Kanonenkugel (Schaden: 70)
					EnableResearch(rPlayer, "RES_ED_MHC4", bHasBig); //Upg: Schwere Kanonenkugel (Schaden: 80)
					EnableResearch(rPlayer, "RES_ED_MSC2", true); //Upg: Kanonenkugel (Schaden: 35)
					EnableResearch(rPlayer, "RES_ED_MSC3", true); //Upg: Kanonenkugel (Schaden: 40)
					EnableResearch(rPlayer, "RES_ED_MSC4", true); //Upg: Kanonenkugel (Schaden: 45)
					EnableResearch(rPlayer, "RES_ED_WSR1", true); //Raketenwerfer
					EnableResearch(rPlayer, "RES_ED_WSR2", true); //Upg: Raketenwerfer
					EnableResearch(rPlayer, "RES_ED_WSR3", true); //Upg: Raketenwerfer II
					EnableResearch(rPlayer, "RES_ED_WMR1", bHasBig); //Schwerer Raketenwerfer
					EnableResearch(rPlayer, "RES_ED_WMR2", bHasBig); //Upg: Schwerer Raketenwerfer
					EnableResearch(rPlayer, "RES_ED_WMR3", bHasBig); //Upg: Schwerer Raketenwerfer II
					EnableResearch(rPlayer, "RES_ED_WHR1", bHasBig&bHasMDW&bImba); //Ballistischer Raketenwerfer
					EnableResearch(rPlayer, "RES_ED_MHR2", bHasBig&bHasMDW&bImba); //Upg: ballistische Rakete (Schaden: 500)
					EnableResearch(rPlayer, "RES_ED_MHR3", bHasBig&bHasMDW&bImba); //Upg: ballistische Rakete (Schaden: 600)
					EnableResearch(rPlayer, "RES_ED_MHR4", bHasBig&bHasMDW&bImba); //ballistische Atomrakete (Schaden: 1000)
					EnableResearch(rPlayer, "RES_ED_ASR1", bHasAir); //Helikopter-Raketenwerfer
					EnableResearch(rPlayer, "RES_ED_ASR2", bHasAir); //Upg: Helikopter-Raketenwerfer
					EnableResearch(rPlayer, "RES_ED_AMR1", bHasBig&bHasAir); //Schwerer Helikopter-Raketenwerfer
					EnableResearch(rPlayer, "RES_ED_AMR2", bHasBig&bHasAir); //Upg: Schwerer Helikopter-Raketenwerfer
					EnableResearch(rPlayer, "RES_ED_WSO1", bHasBig); //Stalin Orgel
					EnableResearch(rPlayer, "RES_ED_WSO2", bHasBig); //Upg: Stalin Orgel II
					EnableResearch(rPlayer, "RES_MMR2", bHasBig); //Upg: Schwere Rakete (Schaden: 45)
					EnableResearch(rPlayer, "RES_MMR3", bHasBig); //Upg: Schwere Rakete (Schaden: 50)
					EnableResearch(rPlayer, "RES_MMR4", bHasBig); //Upg: Schwere Rakete (Schaden: 60)
					EnableResearch(rPlayer, "RES_MSR2", true); //Upg: Rakete (Schaden: 25)
					EnableResearch(rPlayer, "RES_MSR3", true); //Upg: Rakete (Schaden: 30)
					EnableResearch(rPlayer, "RES_MSR4", true); //Upg: Rakete (Schaden: 35)
					EnableResearch(rPlayer, "RES_EDWAN1", bIsHuman); //AntiRakete
					EnableResearch(rPlayer, "RES_ED_WSL1", true); //Lasergeschütz
					EnableResearch(rPlayer, "RES_ED_WSL2", true); //Upg: Lasergeschütz
					EnableResearch(rPlayer, "RES_ED_WSL3", true); //Upg: Lasergeschütz
					EnableResearch(rPlayer, "RES_ED_WHL1", bHasBig); //Schweres Lasergeschütz
					EnableResearch(rPlayer, "RES_ED_WHL2", bHasBig); //Upg: Schweres Lasergeschütz
					EnableResearch(rPlayer, "RES_ED_WHL3", bHasBig); //Upg: Schweres Lasergeschütz
					EnableResearch(rPlayer, "RES_ED_LRL", bHasBig); //Long Range Laser
					EnableResearch(rPlayer, "RES_ED_WHHLA1", bHasBig&bHasAir); //Heavy Air Laser Cannon
					EnableResearch(rPlayer, "RES_ED_WHHLA2", bHasBig&bHasAir); //Upg: Heavy Air Laser Cannon II
					EnableResearch(rPlayer, "RES_ED_WHHLA3", bHasBig&bHasAir); //Upg: Heavy Air Laser Cannon III
					EnableResearch(rPlayer, "RES_ED_WHLA1", bHasBig&bHasAir); //Heavy Air Laser Cannon
					EnableResearch(rPlayer, "RES_ED_WHLA2", bHasBig&bHasAir); //Upg: Heavy Air Laser Cannon II
					EnableResearch(rPlayer, "RES_ED_WHLA3", bHasBig&bHasAir); //Upg: Heavy Air Laser Cannon III
					EnableResearch(rPlayer, "RES_ED_WLAA1", true); //AA Laser Cannon
					EnableResearch(rPlayer, "RES_ED_WLAA2", true); //Upg: AA Laser Cannon II
					EnableResearch(rPlayer, "RES_ED_WSI1", true); //Ionengeschütz
					EnableResearch(rPlayer, "RES_ED_WSI2", true); //Upg: Ionengeschütz
					EnableResearch(rPlayer, "RES_ED_WHI1", bHasBig); //Schweres Ionengeschütz
					EnableResearch(rPlayer, "RES_ED_WHI2", bHasBig); //Upg: Schweres Ionengeschütz
					EnableResearch(rPlayer, "RES_ED_WHI3", bHasBig); //Upg: Heavy ION Destroyer
					EnableResearch(rPlayer, "RES_EDWEQ1", bHasBig&bIsHuman); //Erdbebengenerator
					EnableResearch(rPlayer, "RES_EDWEQ2", bHasBig&bIsHuman); //Upg.Erdbebengenerator
					EnableResearch(rPlayer, "RES_ED_WSCL1", true); //Shockwave Generator
					EnableResearch(rPlayer, "RES_ED_WSCL2", true); //Upg: Shockwave Generator II
					EnableResearch(rPlayer, "RES_ED_WSCL3", true); //Upg: Shockwave Generator III
					EnableResearch(rPlayer, "RES_ED_WSCH1", bHasBig); //Heavy Shockwave Generator
					EnableResearch(rPlayer, "RES_ED_WSCH2", bHasBig); //Upg: Heavy Shockwave Generator II
					EnableResearch(rPlayer, "RES_ED_WSCH3", bHasBig); //Upg: Heavy Shockwave Generator III
					EnableResearch(rPlayer, "RES_ED_BMD", bHasBig); //Mittleres Abwehrgebäude
					EnableResearch(rPlayer, "RES_EDBHT", bHasBig); //Schwerer Turm
					EnableResearch(rPlayer, "RES_ED_BHD", bHasBig); //Schweres Abwehrgebäude
					EnableResearch(rPlayer, "RES_ED_ART", bHasBig&bImba); //Artillerie
					EnableResearch(rPlayer, "RES_ED_RepHand", true); //RepTure-Einheit
					EnableResearch(rPlayer, "RES_ED_RepHand2", true); //Upg: RepTure-Einheit
					EnableResearch(rPlayer, "RES_ED_BC1", bIsHuman); //Gebäudestürmer
					EnableResearch(rPlayer, "RES_ED_SCR", true); //Upg: Radar
					EnableResearch(rPlayer, "RES_ED_SCR2", true); //Upg: Screamer
					EnableResearch(rPlayer, "RES_ED_SCR3", true); //Upg: Screamer II
					EnableResearch(rPlayer, "RES_ED_SGen", true); //Energieschild-Generator
					EnableResearch(rPlayer, "RES_ED_MGen", true); //Upg. Energieschild-Generator
					EnableResearch(rPlayer, "RES_ED_HGen", true); //Upg. Energieschild-Generator
					EnableResearch(rPlayer, "RES_ED_SDI", bHasBig&bHasMDW&bIsHuman&bImba); //SDI
					EnableResearch(rPlayer, "RES_ED_WSDI", bHasBig&bHasMDW&bIsHuman&bImba); //SDI Defense Center
					EnableResearch(rPlayer, "RES_ED_UBT1", bHasBig); //Ural (Doppelgeschützpanzer)
					EnableResearch(rPlayer, "RES_ED_UBT2", bHasBig); //Upg: HT 800 Ural
					EnableResearch(rPlayer, "RES_ED_EDUOB2", bIsHuman); //Upg: Aufklärer
				}else if(rPlayer.GetRace()==raceLC){
					rPlayer.EnableBuilding("LCBLZ", false);
					rPlayer.EnableBuilding("LCBSR", false);

					if(comboResearchTime==RESEARCH_TECHWAR){
						rPlayer.EnableBuilding("LCBRC", false); //Research Center
					}

					if(!bHasTrade){
						rPlayer.EnableBuilding("LCBMR", false); //Mine
					}

					EnableResearch(rPlayer, "RES_LC_ULU2", true); //Upg: Lunar
					EnableResearch(rPlayer, "RES_LC_ULU3", true); //Upg: Lunar
					EnableResearch(rPlayer, "RES_LCUNH", true); //New Hope (2.2)
					EnableResearch(rPlayer, "RES_LC_UNH1", true); //New Hope
					EnableResearch(rPlayer, "RES_LC_UNH2", true); //New Hope II
					EnableResearch(rPlayer, "RES_LC_UMO2", true); //Upg: Moon
					EnableResearch(rPlayer, "RES_LC_UMO3", true); //Upg: Moon
					EnableResearch(rPlayer, "RES_LC_LCSS1", true); //Charon
					EnableResearch(rPlayer, "RES_LC_UCR1", bHasBig); //Crater
					EnableResearch(rPlayer, "RES_LC_UCR2", bHasBig); //Upg: Crater
					EnableResearch(rPlayer, "RES_LC_UCR3", bHasBig); //Upg: Crater
					EnableResearch(rPlayer, "RES_LC_UHF1", bHasBig); //Fang
					EnableResearch(rPlayer, "RES_LC_UHF2", bHasBig); //Upg: Fang II
					EnableResearch(rPlayer, "RES_LC_UHF3", bHasBig); //Upg: Fang III
					EnableResearch(rPlayer, "RES_LCUFG1", true); //Fat Girl c2
					EnableResearch(rPlayer, "RES_LCUFG2", true); //Fat Girl c3
					EnableResearch(rPlayer, "RES_LCUFG3", true); //Fat Girl c4
					EnableResearch(rPlayer, "RES_LC_WARTILLERY", bHasBig); //Plasma-Artillerie
					EnableResearch(rPlayer, "RES_LC_UHT2", bHasBig); //Crion II
					EnableResearch(rPlayer, "RES_LC_UME1", bHasAir); //Meteor (Jagdflieger)
					EnableResearch(rPlayer, "RES_LC_UME2", bHasAir); //Upg: Meteor
					EnableResearch(rPlayer, "RES_LC_UME3", bHasAir); //Upg: Meteor
					EnableResearch(rPlayer, "RES_LC_UBO1", bHasBig&bHasAir); //Thunderer (Bomber)
					EnableResearch(rPlayer, "RES_LC_UBO2", bHasBig&bHasAir); //Upg: Thunderer
					EnableResearch(rPlayer, "RES_LC_UAP1", bHasBig&bHasAir); //Storm
					EnableResearch(rPlayer, "RES_LC_UAP2", bHasBig&bHasAir); //Upg: Storm II
					EnableResearch(rPlayer, "RES_LC_UAP3", bHasBig&bHasAir); //Upg: Storm III
					EnableResearch(rPlayer, "RES_LCUSF1", bHasAir); //Super Fighter
					EnableResearch(rPlayer, "RES_LCUSF2", bHasAir); //Super Fighter m2
					EnableResearch(rPlayer, "RES_LCUSF3", bHasAir); //Upg: SuperFighter III
					EnableResearch(rPlayer, "RES_LCUUT", bHasAir&bIsHuman); //Einheitentransporter
					EnableResearch(rPlayer, "RES_LC_WCH2", true); //Upg: Maschinengewehr
					EnableResearch(rPlayer, "RES_LC_ACH2", bHasAir); //Upg: Luft-Maschinengewehr
					EnableResearch(rPlayer, "RES_LC_MCH2", true); //Upg: 20 mm Bullets
					EnableResearch(rPlayer, "RES_LC_MCH3", true); //Upg: 20 mm Bullets
					EnableResearch(rPlayer, "RES_LC_MCH4", true); //Upg: 20 mm Bullets
					EnableResearch(rPlayer, "RES_LC_WSR2", true); //Upg: Raketenwerfer
					EnableResearch(rPlayer, "RES_LC_WSR3", true); //Upg: Raketenwerfer
					EnableResearch(rPlayer, "RES_LCWAN1", bIsHuman); //Antirocket
					EnableResearch(rPlayer, "RES_LC_ASR1", bHasAir); //Luft Raketenwerfer
					EnableResearch(rPlayer, "RES_LC_ASR2", bHasAir); //Upg: Luft Raketenwerfer
					EnableResearch(rPlayer, "RES_LC_WMR1", bHasBig); //WMR
					EnableResearch(rPlayer, "RES_LC_WMR2", bHasBig); //WMR2
					EnableResearch(rPlayer, "RES_LC_WMR3", bHasBig); //WMR3
					EnableResearch(rPlayer, "RES_LC_METEORK", bHasBig&bIsHuman&bImba); //Meteoritenkontrollzentrum
					EnableResearch(rPlayer, "RES_LCCAA1", true); //AA Raktenwerfer
					EnableResearch(rPlayer, "RES_LC_AMR1", bHasBig&bHasAir); //AMR1
					EnableResearch(rPlayer, "RES_LC_AMR2", bHasBig&bHasAir); //WMR2
					EnableResearch(rPlayer, "RES_LC_MMR2", bHasBig); //Upg: Heavy Rocket (guided: 25%)
					EnableResearch(rPlayer, "RES_LC_MMR3", bHasBig); //Upg: Heavy Rocket (guided: 50%)
					EnableResearch(rPlayer, "RES_LC_MMR4", bHasBig); //Upg: Heavy Rocket (guided: 100%)
					EnableResearch(rPlayer, "RES_LC_WRG2", true); //Upg: Railgun II
					EnableResearch(rPlayer, "RES_LC_WHRG1", bHasBig); //Heavy Railgun
					EnableResearch(rPlayer, "RES_LC_WHRG2", bHasBig); //Upg: Heavy Railgun II
					EnableResearch(rPlayer, "RES_LC_SLP", bHasBig&bHasMDW&bIsHuman&bImba); //Sunlight Project
					EnableResearch(rPlayer, "RES_LC_WAARG1", true); //AA Railgun
					EnableResearch(rPlayer, "RES_LC_MIS_HRG2", bHasBig); //Ammo Heavy Railgun
					EnableResearch(rPlayer, "RES_LC_MIS_HRG3", bHasBig); //Upg: Ammo Heavy Railgun II
					EnableResearch(rPlayer, "RES_LC_MIS_HRG4", bHasBig); //Upg: Ammo Heavy Railgun III
					EnableResearch(rPlayer, "RES_LC_MIS_RG2", true); //Ammo Railgun
					EnableResearch(rPlayer, "RES_LC_MIS_RG3", true); //Upg: Ammo Railgun II
					EnableResearch(rPlayer, "RES_LC_MIS_RG4", true); //Upg: Ammo Railgun III
					EnableResearch(rPlayer, "RES_LC_WSL1", true); //Elektrogeschütz
					EnableResearch(rPlayer, "RES_LC_WSL2", true); //Upg: Elektrogeschütz
					EnableResearch(rPlayer, "RES_LCUNH1", true); //Plasmastrahl (2.2)
					EnableResearch(rPlayer, "RES_LC_WHL1", bHasBig); //Schweres Elektrogeschütz
					EnableResearch(rPlayer, "RES_LC_WHL2", bHasBig); //Upg: Schweres Elektrogeschütz
					EnableResearch(rPlayer, "RES_LC_WBART1", bHasBig); //Mobile Lightning Generator
					EnableResearch(rPlayer, "RES_LC_WBART2", bHasBig); //Upg: Mobile Lightning Generator II
					EnableResearch(rPlayer, "RES_LC_WAHE1", bHasBig&bHasAir); //Heavy Air Electro-Cannon
					EnableResearch(rPlayer, "RES_LC_WAHE2", bHasBig&bHasAir); //Upg: Heavy Air Electro-Cannon II
					EnableResearch(rPlayer, "RES_LC_WAE1", bHasAir); //Air Electro-Cannon
					EnableResearch(rPlayer, "RES_LC_WAE2", bHasAir); //Upg: Air Electro-Cannon II
					EnableResearch(rPlayer, "RES_LC_WHERO", true); //Plasma Beam Projector
					EnableResearch(rPlayer, "RES_LC_WHERO2", true); //Upg: Small Plasma Beam II
					EnableResearch(rPlayer, "RES_LC_WHP1", bHasBig); //Heavy Plasma Beam I
					EnableResearch(rPlayer, "RES_LC_WHP2", bHasBig); //Upg: Heavy Plasma Beam II
					EnableResearch(rPlayer, "RES_LC_WHP3", bHasBig); //Upg: Heavy Plasma Beam III
					EnableResearch(rPlayer, "RES_LC_WHCART1", true); //Plasma Cannon
					EnableResearch(rPlayer, "RES_LC_WHCART2", true); //Upg: Plasma Cannon II
					EnableResearch(rPlayer, "RES_LC_WAAE1", true); //AA Plasma Beam Projector
					EnableResearch(rPlayer, "RES_LC_WAAE2", true); //Upg: AA Plasma Beam Projector II
					EnableResearch(rPlayer, "RES_LC_WSS1", true); //Schallkanone
					EnableResearch(rPlayer, "RES_LC_WSS2", true); //Upg: Schallkanone
					EnableResearch(rPlayer, "RES_LC_WHS1", bHasBig); //Schwere Schallkanone
					EnableResearch(rPlayer, "RES_LC_WHS2", bHasBig); //Upg: Schwere Schallkanone
					EnableResearch(rPlayer, "RES_LC_WAS1", bHasBig&bHasAir&bImba); //Air Schallkanone
					EnableResearch(rPlayer, "RES_LC_WAS2", bHasBig&bHasAir&bImba); //Upg: Luft-Schallkanone
					EnableResearch(rPlayer, "RES_LCWEQ1", bHasBig&bIsHuman); //Erdbebengenerator
					EnableResearch(rPlayer, "RES_LCWEQ2", bHasBig&bIsHuman); //Upg.Erdbebengenerator
					EnableResearch(rPlayer, "RES_LC_MSR2", true); //Upg: Rocket (guided: 25%)
					EnableResearch(rPlayer, "RES_LC_MSR3", true); //Upg: Rocket (guided: 50%)
					EnableResearch(rPlayer, "RES_LC_MSR4", true); //Upg: Rocket (guided: 100%)
					EnableResearch(rPlayer, "RES_LCBNE", true); //NEST
					EnableResearch(rPlayer, "RES_LC_BMD", true); //Mittleres Abwehrgebäude
					EnableResearch(rPlayer, "RES_LC_BHD", bHasBig); //Schweres Abwehrgebäude
					EnableResearch(rPlayer, "RES_LC_BPM", bHasBig); //Peacemaker
					EnableResearch(rPlayer, "RES_LC_BWC", bHasBig&bHasMDW&bImba); //Wetterkontrollzentrum
					EnableResearch(rPlayer, "RES_LC_ART", bHasBig&bImba); //Artillerie
					EnableResearch(rPlayer, "RES_LCBPP2", bIsHuman); //Xylit Kraftwerk
					EnableResearch(rPlayer, "RES_LC_LCBMR2", bHasTrade&bIsHuman); //Mine upg.
					EnableResearch(rPlayer, "RES_LCMINEUPD", bHasTrade&bIsHuman); //Mine upg.
					EnableResearch(rPlayer, "RES_LC_SDIDEF", bHasBig&bHasMDW&bIsHuman&bImba); //SDI-Laser
					EnableResearch(rPlayer, "RES_LC_SGen", true); //Energieschild-Generator
					EnableResearch(rPlayer, "RES_LC_MGen", true); //Upg: Energieschild-Generator
					EnableResearch(rPlayer, "RES_LC_HGen", true); //Upg: Energieschild-Generator
					EnableResearch(rPlayer, "RES_LC_SHR1", true); //Schild-Akku
					EnableResearch(rPlayer, "RES_LC_SHR2", true); //Upg: Schild-Akku I
					EnableResearch(rPlayer, "RES_LC_SHR3", true); //Upg: Schild-Akku II
					EnableResearch(rPlayer, "RES_LC_REG1", true); //Regenerator
					EnableResearch(rPlayer, "RES_LC_REG2", true); //Upg: Regenerator I
					EnableResearch(rPlayer, "RES_LC_REG3", true); //Upg: Regenerator II
					EnableResearch(rPlayer, "RES_LC_BC1", bIsHuman); //Gebäudestürmer
					EnableResearch(rPlayer, "RES_LC_SOB1", true); //Detektor
					EnableResearch(rPlayer, "RES_LC_SOB2", true); //Upg: Detektor
					EnableResearch(rPlayer, "RES_LC_SOB3", true); //Detektor II (2.2)
					EnableResearch(rPlayer, "RES_LCUOB2", true); //Detektor II (2.2)
					EnableResearch(rPlayer, "RES_LC_UTD2", true); //Upg: Mercury II
					EnableResearch(rPlayer, "RES_LC_UCU1", bHasBig); //Crusher
					EnableResearch(rPlayer, "RES_LC_UCU2", bHasBig); //Crusher II
					EnableResearch(rPlayer, "RES_LC_UCU3", bHasBig); //Crusher III
				}else if(rPlayer.GetRace()==raceUCS){
					rPlayer.EnableBuilding("UCSBLZ", false);
					rPlayer.EnableBuilding("UCSBTB", false);

					if(comboResearchTime==RESEARCH_TECHWAR){
						rPlayer.EnableBuilding("UCSBRC", false); //Research Center
					}

					if(!bHasTrade){
						rPlayer.EnableBuilding("UCSBRF", false); //Refinery
					}

					EnableResearch(rPlayer, "RES_UCS_USL2", true); //Upg: Tiger I
					EnableResearch(rPlayer, "RES_UCS_USL3", true); //Upg: Tiger II
					EnableResearch(rPlayer, "RES_UCS_UML1", true); //Spider
					EnableResearch(rPlayer, "RES_UCS_UML2", true); //Upg: Spider I
					EnableResearch(rPlayer, "RES_UCS_UML3", true); //Upg: Spider II
					EnableResearch(rPlayer, "RES_UCS_UTAR1", bHasBig); //Tarantula
					EnableResearch(rPlayer, "RES_UCS_UTAR2", bHasBig); //Upg: Tarantula II
					EnableResearch(rPlayer, "RES_UCS_UTAR3", bHasBig); //Upg: Tarantula III
					EnableResearch(rPlayer, "RES_UCS_UHL1", bHasBig); //Panther
					EnableResearch(rPlayer, "RES_UCS_UHL2", bHasBig); //Upg: Panther I
					EnableResearch(rPlayer, "RES_UCS_UHL3", bHasBig); //Upg: Panther II
					EnableResearch(rPlayer, "RES_UCS_UMI1", true); //Minenleger
					EnableResearch(rPlayer, "RES_UCS_UMI2", true); //Upg: Minenleger
					EnableResearch(rPlayer, "RES_UCS_UOH2", bHasTrade); //Upg: Erntefahrzeug
					EnableResearch(rPlayer, "RES_UCS_UOH3", bHasTrade); //Upg: Erntefahrzeug II
					EnableResearch(rPlayer, "RES_UCS_UAH1", bHasTrade); //Fliegendes Erntefahrzeug I
					EnableResearch(rPlayer, "RES_UCS_UAH2", bHasTrade); //Fliegendes Erntefahrzeug II
					EnableResearch(rPlayer, "RES_UCS_UAH3", bHasTrade); //Fliegendes Erntefahrzeug III
					EnableResearch(rPlayer, "RES_UCS_GARG1", bHasAir); //Gargoil
					EnableResearch(rPlayer, "RES_UCS_GARG2", bHasAir); //Upg: Gargoil
					EnableResearch(rPlayer, "RES_UCS_GARG3", bHasAir); //Upg: Gargoil II
					EnableResearch(rPlayer, "RES_UCS_UAST1", bHasAir); //Manticore (Stealth)
					EnableResearch(rPlayer, "RES_UCS_UAST2", bHasAir); //Manticore II
					EnableResearch(rPlayer, "RES_UCSUUT", bHasAir&bIsHuman); //Einheitentransporter
					EnableResearch(rPlayer, "RES_UCS_BOMBER21", bHasBig&bHasAir); //Bat (Bomber)
					EnableResearch(rPlayer, "RES_UCS_BOMBER22", bHasBig&bHasAir); //Upg: Bat
					EnableResearch(rPlayer, "RES_UCS_BOMBER31", bHasBig&bHasAir); //Dragon (schwerer Bomber)
					EnableResearch(rPlayer, "RES_UCS_BOMBER32", bHasBig&bHasAir); //Upg: Dragon
					EnableResearch(rPlayer, "RES_UCS_WAPB1", bHasBig&bHasAir&bHasBombs&bImba); //Bomb-bay
					EnableResearch(rPlayer, "RES_UCS_WAPB2", bHasBig&bHasAir&bHasBombs&bImba); //Upg: Bomb-bay
					EnableResearch(rPlayer, "RES_UCS_WCH2", true); //Doppel-MG
					EnableResearch(rPlayer, "RES_UCS_WGATL2", true); //Upg: Minigun
					EnableResearch(rPlayer, "RES_UCS_WGATH1", bHasBig); //Heavy Minigun
					EnableResearch(rPlayer, "RES_UCS_WGATH2", bHasBig); //Upg: Heavy Minigun II
					EnableResearch(rPlayer, "RES_UCS_MHMG2", bHasBig); //Heavy Minigun Ammo I
					EnableResearch(rPlayer, "RES_UCS_MHMG3", bHasBig); //Heavy Minigun Ammo II
					EnableResearch(rPlayer, "RES_UCS_MHMG4", bHasBig); //Heavy Minigun Ammo III
					EnableResearch(rPlayer, "RES_UCS_WGATAA1", true); //AA Minigun
					EnableResearch(rPlayer, "RES_UCS_WGATAA2", true); //Upg: AA Minigun II
					EnableResearch(rPlayer, "RES_UCS_MCH2", true); //Upg: 20 mm Bullets
					EnableResearch(rPlayer, "RES_UCS_MCH3", true); //Upg: 20 mm Bullets
					EnableResearch(rPlayer, "RES_UCS_MCH4", true); //Upg: 20 mm Bullets
					EnableResearch(rPlayer, "RES_UCS_WACH2", bHasAir); //Upg Gargoil-Maschinengewehr
					EnableResearch(rPlayer, "RES_UCS_WGATHA1", bHasBig&bHasAir); //Heavy Air Minigun
					EnableResearch(rPlayer, "RES_UCS_WGATHA2", bHasBig&bHasAir); //Upg: Heavy Air Minigun II
					EnableResearch(rPlayer, "RES_UCS_WSR1", bHasBig); //Kleiner Raketenwerfer
					EnableResearch(rPlayer, "RES_UCS_WSR2", bHasBig); //Upg: Kleiner Raketenwerfer I
					EnableResearch(rPlayer, "RES_UCS_WSR3", bHasBig); //Upg: Kleiner Raketenwerfer II
					EnableResearch(rPlayer, "RES_UCS_WMR1", bHasBig); //Raketenwerfer
					EnableResearch(rPlayer, "RES_UCS_WMR2", bHasBig); //Upg: Raketenwerfer I
					EnableResearch(rPlayer, "RES_UCS_WMR3", bHasBig); //Upg: Raketenwerfer II
					EnableResearch(rPlayer, "RES_UCS_WASR1", bHasAir); //Gargoil-Raketenwerfer
					EnableResearch(rPlayer, "RES_UCS_WASR2", bHasAir); //Upg: Gargoil-Raketenwerfer
					EnableResearch(rPlayer, "RES_UCS_WAMR1", bHasBig&bHasAir); //Bomber-Raketenwerfer
					EnableResearch(rPlayer, "RES_UCS_WAMR2", bHasBig&bHasAir); //Upg: Bomber-Raketenwerfer
					EnableResearch(rPlayer, "RES_UCS_MMR2", bHasBig); //Upg: Heavy Rocket (guided: 25%)
					EnableResearch(rPlayer, "RES_UCS_MMR3", bHasBig); //Upg: Heavy Rocket (guided: 50%)
					EnableResearch(rPlayer, "RES_UCS_MMR4", bHasBig); //Upg: Heavy Rocket (guided: 100%)
					EnableResearch(rPlayer, "RES_UCS_MSR2", bHasBig); //Upg: Rocket (guided: 25%)
					EnableResearch(rPlayer, "RES_UCS_MSR3", bHasBig); //Upg: Rocket (guided: 50%)
					EnableResearch(rPlayer, "RES_UCS_MSR4", bHasBig); //Upg: Rocket (guided: 100%)
					EnableResearch(rPlayer, "RES_UCSWAN1", bIsHuman); //AntiRakete
					EnableResearch(rPlayer, "RES_UCS_WSG2", true); //Upg: Granatenwerfer
					EnableResearch(rPlayer, "RES_UCS_WHG1", bHasBig); //Schwerer Granatenwerfer
					EnableResearch(rPlayer, "RES_UCS_WHG2", bHasBig); //Upg: Schwerer Granatenwerfer
					EnableResearch(rPlayer, "RES_UCS_MHG2", bHasBig); //Upg: Grenade
					EnableResearch(rPlayer, "RES_UCS_MHG3", bHasBig); //Upg: Grenade
					EnableResearch(rPlayer, "RES_UCS_MHG4", bHasBig); //Upg: Grenade
					EnableResearch(rPlayer, "RES_UCS_MG2", true); //Upg: Granate (Schaden: 35)
					EnableResearch(rPlayer, "RES_UCS_MG3", true); //Upg: Granate (Schaden: 40)
					EnableResearch(rPlayer, "RES_UCS_MG4", true); //Upg: Granate (Schaden: 45)
					EnableResearch(rPlayer, "RES_UCS_WSP1", true); //Plasmageschütze
					EnableResearch(rPlayer, "RES_UCS_WSP2", true); //Upg: Plasma Cannon II
					EnableResearch(rPlayer, "RES_UCS_WHP1", bHasBig); //Schwere Plasmageschütze
					EnableResearch(rPlayer, "RES_UCS_WHP2", bHasBig); //Upg: Schwere Plasmageschütze I
					EnableResearch(rPlayer, "RES_UCS_WHP3", bHasBig); //Upg: Schwere Plasmageschütze II
					EnableResearch(rPlayer, "RES_UCS_WART1", bHasBig); //Mobile Plasma Artillery
					EnableResearch(rPlayer, "RES_UCS_WART2", bHasBig); //Upg: Mobile Plasma Artillery II
					EnableResearch(rPlayer, "RES_UCSWAP1", bHasAir); //Gargoil Plasma Kanone
					EnableResearch(rPlayer, "RES_UCSWAP2", bHasAir); //Gargoil Plasma Kanone m2
					EnableResearch(rPlayer, "RES_UCS_MB2", bHasBig&bHasAir&bHasBombs&bImba); //Upg: Plasmabombe (Schaden: 500)
					EnableResearch(rPlayer, "RES_UCS_MB3", bHasBig&bHasAir&bHasBombs&bImba); //Upg: Plasmabombe (Schaden: 600)
					EnableResearch(rPlayer, "RES_UCS_MB4", bHasBig&bHasAir&bHasBombs&bImba); //Upg: Plasmabombe (Schaden: 1000)
					EnableResearch(rPlayer, "RES_UCSCAA1", true); //AA PlasmaKanone
					EnableResearch(rPlayer, "RES_UCSCAA2", true); //AA PlasmaKanone II
					EnableResearch(rPlayer, "RES_UCS_PC", bHasBig&bHasMDW&bImba); //Offensive Plasmakanone
					EnableResearch(rPlayer, "RES_UCSWEQ1", bHasBig&bIsHuman); //Erdbebengenerator
					EnableResearch(rPlayer, "RES_UCSWEQ2", bHasBig&bIsHuman); //Upg. Erdbebengen.
					EnableResearch(rPlayer, "RES_UCSWTSC1", true); //Kanone
					EnableResearch(rPlayer, "RES_UCSWTSC2", true); //DoppelKanone 105mm
					EnableResearch(rPlayer, "RES_UCSWBHC1", bHasBig); //DoppelKanone 120mm
					EnableResearch(rPlayer, "RES_UCSWBHC2", bHasBig); //Vierfach Kanone 120mm
					EnableResearch(rPlayer, "RES_UCS_WCART1", bHasBig); //Mobile Cannon Artillery
					EnableResearch(rPlayer, "RES_UCS_WCART2", bHasBig); //Upg: Mobile Cannon Artillery II
					EnableResearch(rPlayer, "RES_UCS_MHC2", bHasBig); //Upg: 120mm Munition
					EnableResearch(rPlayer, "RES_UCS_MHC3", bHasBig); //Upg: 120mm Munition
					EnableResearch(rPlayer, "RES_UCS_MHC4", bHasBig); //Upg: 120mm Munition
					EnableResearch(rPlayer, "RES_UCS_MSC2", true); //Upg: 105mm Munition
					EnableResearch(rPlayer, "RES_UCS_MSC3", true); //Upg: 105mm Munition
					EnableResearch(rPlayer, "RES_UCS_MSC4", true); //Upg: 105mm Munition
					EnableResearch(rPlayer, "RES_UCS_WFL1", true); //Flamethrower
					EnableResearch(rPlayer, "RES_UCS_WFL2", true); //Upg: Flamethrower II
					EnableResearch(rPlayer, "RES_UCS_WFLH1", bHasBig); //Heavy Flamethrower
					EnableResearch(rPlayer, "RES_UCS_WFLH2", bHasBig); //Upg: Heavy Flamethrower II
					EnableResearch(rPlayer, "RES_UCS_BFLT", bHasBig); //Flametower
					EnableResearch(rPlayer, "RES_UCS_FB2", bHasBig&bHasAir&bHasBombs&bImba); //Upg: Napalm BombBay Ammo II
					EnableResearch(rPlayer, "RES_UCS_FB3", bHasBig&bHasAir&bHasBombs&bImba); //Upg: Napalm BombBay Ammo III
					EnableResearch(rPlayer, "RES_UCS_FB4", bHasBig&bHasAir&bHasBombs&bImba); //Upg: Napalm BombBay Ammo IV
					EnableResearch(rPlayer, "RES_UCS_MIS_FLH2", true); //Upg: Black Napalm II
					EnableResearch(rPlayer, "RES_UCS_MIS_FLH3", true); //Upg: Black Napalm III
					EnableResearch(rPlayer, "RES_UCS_MIS_FLH4", true); //Upg: Black Napalm IV
					EnableResearch(rPlayer, "RES_UCS_MIS_FL2", true); //Upg: Napalm II
					EnableResearch(rPlayer, "RES_UCS_MIS_FL3", true); //Upg: Napalm III
					EnableResearch(rPlayer, "RES_UCS_MIS_FL4", true); //Upg: Napalm IV
					EnableResearch(rPlayer, "RES_UCS_BMD", bHasBig); //Mittleres Abwehrgebäude
					EnableResearch(rPlayer, "RES_UCSBHT", bHasBig); //Schwerer Turm
					EnableResearch(rPlayer, "RES_UCS_BHD", bHasBig); //Schweres Abwehrgebäude
					EnableResearch(rPlayer, "RES_UCS_ART", bHasBig&bImba); //Artillerie
					EnableResearch(rPlayer, "RES_UCS_WSD", bHasBig&bHasMDW&bIsHuman&bImba); //SDI-Laser
					EnableResearch(rPlayer, "RES_UCS_RepHand", true); //RepTure-Einheit
					EnableResearch(rPlayer, "RES_UCS_RepHand2", true); //Upg: RepTure-Einheit
					EnableResearch(rPlayer, "RES_UCS_BC1", bIsHuman); //Gebäudestürmer
					EnableResearch(rPlayer, "RES_UCS_SGen", true); //Schildgenerator
					EnableResearch(rPlayer, "RES_UCS_MGen", true); //Upg. Schildgenerator
					EnableResearch(rPlayer, "RES_UCS_HGen", true); //Upg. Schildgenerator
					EnableResearch(rPlayer, "RES_UCS_URAD2", true); //Upg: Radar II
					EnableResearch(rPlayer, "RES_UCS_SHD", true); //Schattengenerator
					EnableResearch(rPlayer, "RES_UCS_SHD2", true); //Upg: Schattengenerator I
					EnableResearch(rPlayer, "RES_UCS_SHD3", true); //Upg: Schattengenerator II
					EnableResearch(rPlayer, "RES_UCS_SHD4", true); //Upg: Schattengenerator III
					EnableResearch(rPlayer, "RES_UCS_UBL1", bHasBig); //Jaguar
					EnableResearch(rPlayer, "RES_UCS_UBL2", bHasBig); //Jaguar
					EnableResearch(rPlayer, "RES_UCS_U4L1", bHasBig&bImba); //Grizzly
					EnableResearch(rPlayer, "RES_UCS_U4L2", bHasBig&bImba); //Grizzly II
					EnableResearch(rPlayer, "RES_UCS_U4L3", bHasBig&bImba); //Grizzly III
					EnableResearch(rPlayer, "RES_UCSUCS", true); //Cargo Salamander
					EnableResearch(rPlayer, "RES_UCS_USS2", true); //Shark II
					EnableResearch(rPlayer, "RES_UCS_UBS1", bHasBig); //Hydra I
					EnableResearch(rPlayer, "RES_UCS_UBS2", bHasBig); //Hydra II
					EnableResearch(rPlayer, "RES_UCS_UBS3", bHasBig); //Hydra III
					EnableResearch(rPlayer, "RES_UCS_USM1", bHasBig&bImba); //Orca I
					EnableResearch(rPlayer, "RES_UCS_USM2", bHasBig&bImba); //Orca II
					EnableResearch(rPlayer, "RES_UCS_UCSUOB2", bIsHuman); //Aufklärer II
				}

				//ai features
				if(comboResearchTime==RESEARCH_TECHWAR){
					rPlayer.EnableAIFeatures(aiBuildResearchBuildings|aiControlResearches, false);
				}
				if(!bHasTrade){
					rPlayer.EnableAIFeatures(aiBuildMiningBuildings|aiBuildMiningUnits|aiControlMiningUnits, false);
				}
				if(!bHasAir){
					rPlayer.EnableAIFeatures(aiBuildHelicopters, false);
				}
				if(!bHasMDW){
					rPlayer.EnableAIFeatures(aiBuildSuperAttack, false);
				}

				if(comboCashType==TECHWAR){
					rPlayer.SetAllowGiveMoney(false);
				}

				rPlayer.EnableMilitaryUnitsLimit(false);
				rPlayer.EnableCommand(commandSoldBuilding, true);
				if(comboCashType==MINE_FOREVER){
					rPlayer.EnableCommand(commandBuildTrench, false);
					rPlayer.EnableCommand(commandBuildWall, false);
				}
				if(comboUnitsLimit==UNITS_NO_IMBA){
					rPlayer.EnableCommand(commandBuildTrench, false);
				}
				rPlayer.EnableAIFeatures2(ai2NeutralAI|ai2ChooseEnemy, false);

				nStartingPointX=rPlayer.GetStartingPointX();
				nStartingPointY=rPlayer.GetStartingPointY();
				if(
					(
						 IsEmptyPoint(nStartingPointX,   nStartingPointY+1)
						+IsEmptyPoint(nStartingPointX+1, nStartingPointY+1)
						+IsEmptyPoint(nStartingPointX+1, nStartingPointY  )
						+IsEmptyPoint(nStartingPointX+1, nStartingPointY-1)
						+IsEmptyPoint(nStartingPointX,   nStartingPointY-1)
						+IsEmptyPoint(nStartingPointX-1, nStartingPointY-1)
						+IsEmptyPoint(nStartingPointX-1, nStartingPointY  )
						+IsEmptyPoint(nStartingPointX-1, nStartingPointY+1)
					)>4
				){ //is player
					if(comboCashType==TECHWAR){
						rPlayer.SetMoney(TECHWAR_MONEY);
					}else{
						rPlayer.SetMoney(DEFAULT_MONEY);
					}
					rPlayer.SetMaxDistance(nMaxDistance);
					if(comboStartingUnits==BUILDER_ONLY){
						rPlayer.CreateDefaultUnit(nStartingPointX, nStartingPointY, 0);
					}
					rPlayer.LookAt(nStartingPointX, nStartingPointY, 6, 0, 20, 0);
				}else{ //is watcher
					rPlayer.SetScriptData(TEAM, WATCHER); //add to watcher team
					DisablePlayer(rPlayer);
					rPlayer.EnableStatistics(false); //no stats at the end for watchers
					rPlayer.SetMoney(0);
					rPlayer.SetAllowGiveMoney(false);
				}
			}
		}

		if(comboExtras==EXTRA_BEAUTIFULMOON){
			ShowArea(32767, nGetRight2, nGetBottom2, 0, 256); //make everybody see everything
		}else{
			ShowArea(mToKill, nGetRight2, nGetBottom2, 0, 256); //make watchers see everything
		}

		for(i=0;i<15;++i){ //calculate distances
			rPlayer=GetPlayer(i);
			if(rPlayer!=null && rPlayer.GetScriptData(TEAM)!=WATCHER){
				for(j=i+1;j<15;++j){
					rPlayer2=GetPlayer(j);
					if(rPlayer2!=null && rPlayer2.GetScriptData(TEAM)!=WATCHER){
						rPlayer.SetScriptData(j, Distance(rPlayer.GetStartingPointX(), rPlayer.GetStartingPointY(), rPlayer2.GetStartingPointX(), rPlayer2.GetStartingPointY()));
					}
				}
			}
		}

		nD12=FindTeamSize(1, nMaxPossibleDistance);
		nD23=FindTeamSize(2, nD12);
		nD34=FindTeamSize(3, nD23);

		//create teams
		if(nD12-nD23>nD23-nD34){
			CreateTeams(nD23); //2 teams
		}else{
			CreateTeams(nD34); //3 teams
		}

		SetTimer(0, 5*20); //check victory
		SetTimer(1,   20); //display time
		if(nMaxDistance<nMaxPossibleDistance){
			SetTimer(2, 10*20); //increase max distance
		}
		if(bHasBots){
			SetTimer(3, 60*20); //find new enemies
		}
		if(!bHasTrade){
			if(comboCashType==TECHWAR){
				SetTimer(4,    20); //techwar money
			}else{
				SetTimer(5, 60*20); //uncle sam money
			}
		}

		return Ally, 240; //ally after 12 seconds
	}

	state Ally{
		player rPlayer;
		player rPlayer2;
		int i;
		int j;
		int nRandom;

		for(i=0;i<15;++i){ //enable ai ally
			rPlayer=GetPlayer(i);
			if(rPlayer!=null && rPlayer.IsAlive()){
				rPlayer.EnableAIFeatures(aiRejectAlliance, false);
			}
		}

		for(i=0;i<15;++i){ //ally
			rPlayer=GetPlayer(i);
			if(rPlayer!=null && rPlayer.IsAlive()){
				for(j=i+1;j<15;++j){ //arrange allies
					rPlayer2=GetPlayer(j);
					if(rPlayer2!=null && rPlayer2.IsAlive() && !rPlayer.IsAlly(rPlayer2)){
						if(rPlayer.GetScriptData(TEAM)==rPlayer2.GetScriptData(TEAM)){ //when in same team or both are watchers decide by random who gets asked
							if(Rand(2)){
								ArrangeAlly(rPlayer, rPlayer2);
							}else{
								ArrangeAlly(rPlayer2, rPlayer);
							}
						}else if(rPlayer.GetScriptData(TEAM)==WATCHER){ //first is watcher
							ArrangeAlly(rPlayer2, rPlayer);
						}else if(rPlayer2.GetScriptData(TEAM)==WATCHER){ //second is watcher
							ArrangeAlly(rPlayer, rPlayer2);
						}
					}
				}
				j=rPlayer.GetScriptData(TO_ALLY);
				while(j){ //ally in random order
					nRandom=Rand(j);
					Ally(GetPlayer(rPlayer.GetScriptData(nRandom)), rPlayer);
					--j;
					rPlayer.SetScriptData(nRandom, rPlayer.GetScriptData(j));
				}
			}
		}

		for(i=0;i<15;++i){ //disable ai ally
			rPlayer=GetPlayer(i);
			if(rPlayer!=null && rPlayer.IsAlive()){
				rPlayer.EnableAIFeatures(aiRejectAlliance, true);
			}
		}

		return Nothing;
	}

	state Nothing{
		return Nothing;
	}

	event RemoveResources(){
		if(comboCashType!=MINE_FOR_MONEY && comboCashType!=MINE_FOR_MONEY_XL && comboCashType!=MINE_FOREVER){
			true;
		}else{
			false;
		}
	}

	event RemoveUnits(){
		if(comboStartingUnits==BUILDER_ONLY){
			true;
		}else{
			false;
		}
	}

	event Timer0(){ //check victory
		player rPlayer;
		int i;
		int bHasBuild;

		for(i=0;i<15;++i){
			rPlayer=GetPlayer(i);
			if(IsActivePlayer(rPlayer)){
				if(rPlayer.GetNumberOfBuildings()){
					rPlayer.SetScriptData(HASBUILD, true);
				}else{
					bHasBuild=rPlayer.GetScriptData(HASBUILD);
					if(bHasBuild || (!bHasBuild && !rPlayer.GetNumberOfUnits())){
						DisablePlayer(rPlayer);
						rPlayer.SetScriptData(DEAD, true); //add to dead
						if(comboCashType==TECHWAR){
							rPlayer.SetMoney(0);
						}
						if(IsBot(rPlayer)){
							rPlayer.Defeat();
						}else{
							if(!IsEnded()){
								AddBriefing("translateEliminatedMessage", rPlayer.GetName());
							}
						}
					}
				}
			}
		}
		KillArea(mToKill, nGetRight2, nGetBottom2, 0, 256);

		if(IsEnded()){
			for(i=0;i<15;++i){ //end game
				rPlayer=GetPlayer(i);
				if(rPlayer!=null && rPlayer.IsAlive()){
					if(rPlayer.GetScriptData(DEAD)){
						rPlayer.Defeat();
					}else{
						rPlayer.Victory();
					}
				}
			}
		}
	}

	event Timer1(){ //display time
		int time;

		time=GetMissionTime()/20;
		SetConsoleText("<%0>:<%1><%2>", time/60, (time%60)/10, time%10);
	}

	event Timer2(){ //increase max distance
		player rPlayer;
		int i;

		if(nMaxDistance<nMaxPossibleDistance){
			++nMaxDistance;
			for(i=0;i<15;++i){
				rPlayer=GetPlayer(i);
				if(IsActivePlayer(rPlayer)){
					rPlayer.SetMaxDistance(nMaxDistance);
				}
			}
		}
	}

	event Timer3(){ //find new enemies
		player rPlayer;
		player rPlayer2;
		player rNewEnemy;
		int i;
		int j;
		int rPlayer2Buildings;
		int rNewEnemyBuildings;

		rNewEnemyBuildings=-1;
		for(i=0;i<15;++i){
			rPlayer=GetPlayer(i);
			if(IsActivePlayer(rPlayer) && IsBot(rPlayer)){
				for(j=0;j<15;++j){
					rPlayer2=GetPlayer(j);
					if(IsActivePlayer(rPlayer2) && rPlayer!=rPlayer2 && !rPlayer.IsAlly(rPlayer2)){
						rPlayer2Buildings=
							rPlayer2.GetNumberOfBuildings(buildingBase)
							+rPlayer2.GetNumberOfBuildings(buildingFactory)
							+rPlayer2.GetNumberOfBuildings(buildingWaterBase)
							+rPlayer2.GetNumberOfBuildings(buildingBaseFactory)
							+rPlayer2.GetNumberOfBuildings(buildingSilos)
							+rPlayer2.GetNumberOfBuildings(buildingWeatherControl)
							+rPlayer2.GetNumberOfBuildings(buildingPlasmaCannon);
						if(rPlayer2Buildings>rNewEnemyBuildings){
							rNewEnemy=rPlayer2;
							rNewEnemyBuildings=rPlayer2Buildings;
						}
					}
				}
				if(rNewEnemy){
					rPlayer.ChooseEnemy(rNewEnemy);
					rNewEnemy=null;
					rNewEnemyBuildings=-1;
				}
			}
		}
	}

	event Timer4(){ //techwar money
		player rPlayer;
		int i;

		for(i=0;i<15;++i){
			rPlayer=GetPlayer(i);
			if(IsActivePlayer(rPlayer)){
				rPlayer.SetMoney(TECHWAR_MONEY);
			}
		}
	}

	event Timer5(){ //uncle sam money
		player rPlayer;
		int i;

		for(i=0;i<15;++i){
			rPlayer=GetPlayer(i);
			if(IsActivePlayer(rPlayer)){
				rPlayer.AddMoney(nCashRate);
			}
		}
	}

	command Initialize(){
		comboCashType      = MINE_FOR_MONEY;
		comboResearchTime  = RESEARCH_2X;
		comboResearchLimit = RESEARCH_ALL;
		comboUnitsLimit    = UNITS_ALL;
		comboStartingUnits = BUILDER_ONLY;
		comboExtras        = EXTRA_NONE;
	}

	command Uninitialize(){
		ResourcesPerContainer(8);
	}

	command Combo1(int nMode) button comboCashType{
		comboCashType=nMode;
	}

	command Combo2(int nMode) button comboResearchTime{
		comboResearchTime=nMode;
	}

	command Combo3(int nMode) button comboResearchLimit{
		comboResearchLimit=nMode;
	}

	command Combo4(int nMode) button comboUnitsLimit{
		comboUnitsLimit=nMode;
	}

	command Combo5(int nMode) button comboStartingUnits{
		comboStartingUnits=nMode;
	}

	command Combo6(int nMode) button comboExtras{
		comboExtras=nMode;
	}
}
