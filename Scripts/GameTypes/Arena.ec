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

mission "translateGameTypeArena"{
	int bDemo;
	int nTimeLimit;
	int bCheckBuilding;
	int nMeteor;
	int nPlayerInConsole;

	enum comboTechLevel{
		"translateGameMenuTechLevelLow",
		"translateGameMenuTechLevelMedium",
		"translateGameMenuTechLevelHigh",
	multi:
		"translateGameMenuTechLevel"
	}

	enum comboStartingUnits{
		"1",
		"2",
		"3",
	multi:
		"translateGameMenuStartingUnits"
	}

	enum comboTime{
		"translateGameMenuTimeLimitNoLimit",
		"translateGameMenuTimeLimit15min",
		"translateGameMenuTimeLimit30min",
		"translateGameMenuTimeLimit45min",
		"translateGameMenuTimeLimit1h",
		"translateGameMenuTimeLimit15h",
	multi:
		"translateGameMenuTimeLimit"
	}

	function int CreateArtefacts(player rPlayer){
		int i;
		int x;
		int y;

		if(!rPlayer){
			return false;
		}
		x=rPlayer.GetStartingPointX();
		y=rPlayer.GetStartingPointY();

		CreateArtefact("NEAAMMO", x, y, 0, -1, -1);
		CreateArtefact("NEAAMMO", x+1, y, 0, -1, -1);
		CreateArtefact("NEAAMMO", x+1, y, 0, -1, -1);

		CreateArtefact("NEAENERGY", x, y+1, 0, -1, -1);
		CreateArtefact("NEAENERGY", x+1, y+1, 0, -1, -1);
		CreateArtefact("NEAENERGY", x+1, y+1, 0, -1, -1);

		CreateArtefact("NEAMAXHP", x, y+1, 0, -1, -1);
		CreateArtefact("NEAMAXHP", x+1, y+1, 0, -1, -1);
		CreateArtefact("NEAMAXHP", x+1, y+1, 0, -1, -1);

		CreateArtefact("NEASHOWMAP0", x, y+2, 0, -1, -1);

		return true;
	}

	function int CreateStartingUnits(player rPlayer, player rPlayer2){
		int x;
		int y;

		if(!rPlayer || !rPlayer2){
			return false;
		}
		x=rPlayer2.GetStartingPointX();
		y=rPlayer2.GetStartingPointY();

		if(comboTechLevel==0){
			if(rPlayer.GetRace()==raceED){
				rPlayer.CreateUnitEx(x, y, 0, null, "EDUMT3", "EDWSL1", null, null, null, 0);
				if(comboStartingUnits>0){
					rPlayer.CreateUnitEx(x+1, y, 0, null, "EDUST3", "EDWCA2", null, null, null);
				}
				if(comboStartingUnits>1){
					rPlayer.CreateUnitEx(x+1, y, 0, null, "EDUMW3", "EDWSR3", null, null, null, 0);
				}
			}else if(rPlayer.GetRace()==raceLC){
				rPlayer.CreateUnitEx(x, y, 0, null, "LCUMO2", "LCWSL1", null, null, null, 0);
				if(comboStartingUnits>0){
					rPlayer.CreateUnitEx(x+1, y, 0, null, "LCUMO3", "LCWSR3", null, null, null);
				}
				if(comboStartingUnits>1){
					rPlayer.CreateUnitEx(x+1, y, 0, null, "LCUMO2", "LCWSS2", null, null, null, 0);
				}
			}else if(rPlayer.GetRace()==raceUCS){
				rPlayer.CreateUnitEx(x, y, 0, null, "UCSUML3", "UCSWSSP2", null, null, null, 2);
				if(comboStartingUnits>0){
					rPlayer.CreateUnitEx(x+1, y, 0, null, "UCSUSL3", "UCSWTSR3", null, null, null);
				}
				if(comboStartingUnits>1){
					rPlayer.CreateUnitEx(x+1, y, 0, null, "UCSUML3", "UCSWSMR1", null, null, null, 2);
				}
			}
		}else if(comboTechLevel==1){
			if(rPlayer.GetRace()==raceED){
				rPlayer.CreateUnitEx(x, y, 0, null, "EDUHT3", "EDWMR3", null, null, null, 1);
				if(comboStartingUnits>0){
					rPlayer.CreateUnitEx(x+1, y, 0, null, "EDUHW2", "EDWHL2", null, "EDWSL2", null, 2);
				}
				if(comboStartingUnits>1){
					rPlayer.CreateUnitEx(x+1, y, 0, null, "EDUHT3", "EDWHC2", null, "EDWSR3", null, 1);
				}
			}else if(rPlayer.GetRace()==raceLC){
				rPlayer.CreateUnitEx(x, y, 0, null, "LCUCR1", "LCWMR3", null, null, null, 2);
				if(comboStartingUnits>0){
					rPlayer.CreateUnitEx(x+1, y, 0, null, "LCUCR1", "LCWHL1", null, "LCWSL1", null, 2);
				}
				if(comboStartingUnits>1){
					rPlayer.CreateUnitEx(x+1, y, 0, null, "LCUCR1", "LCWHS2", null, null, null, 2);
				}
			}else if(rPlayer.GetRace()==raceUCS){
				rPlayer.CreateUnitEx(x, y, 0, null, "UCSUHL3", "UCSWBMR3", null, null, null, 2);
				if(comboStartingUnits>0){
					rPlayer.CreateUnitEx(x+1, y, 0, null, "UCSUHL3", "UCSWBHP3", null, "UCSWSSP2", null, 2);
				}
				if(comboStartingUnits>1){
					rPlayer.CreateUnitEx(x+1, y, 0, null, "UCSUHL3", "UCSWBSR3", null, "UCSWSSR3", null, 2);
				}
			}
		}else if(comboTechLevel==2){
			if(rPlayer.GetRace()==raceED){
				rPlayer.CreateUnitEx(x, y, 0, null, "EDUHW2", "EDWHL3", null, "EDWSL3", null, 2);
				if(comboStartingUnits>0){
					rPlayer.CreateUnitEx(x+1, y, 0, null, "EDUBT2", "EDWMR3", "EDWMR3", null, null, 1);
				}
				if(comboStartingUnits>1){
					rPlayer.CreateUnitEx(x+1, y, 0, null, "EDUHT3", "EDWHC2", null, "EDWSR3", null, 1);
				}
			}else if(rPlayer.GetRace()==raceLC){
				rPlayer.CreateUnitEx(x, y, 0, null, "LCUCR3", "LCWHL2", null, "LCWSL2", null, 2);
				if(comboStartingUnits>0){
					rPlayer.CreateUnitEx(x+1, y, 0, null, "LCUCU3", "LCWMR3", "LCWMR3", null, null, 1);
				}
				if(comboStartingUnits>1){
					rPlayer.CreateUnitEx(x+1, y, 0, null, "LCUCU3", "LCWHL2", "LCWHL2", "LCWSS2", "LCWSS2", 1);
				}
			}else if(rPlayer.GetRace()==raceUCS){
				rPlayer.CreateUnitEx(x, y, 0, null, "UCSUBL2", "UCSWBHP3", "UCSWSSP2", "UCSWSSP2", null, 2);
				if(comboStartingUnits>0){
					rPlayer.CreateUnitEx(x+1, y, 0, null, "UCSUBL2", "UCSWBMR3", "UCSWSSR3", null, null, 2);
				}
				if(comboStartingUnits>1){
					rPlayer.CreateUnitEx(x+1, y, 0, null, "UCSUBL2", "UCSWBHP3", "UCSWSSP2", "UCSWSSP2", null, 2);
				}
			}
		}

		rPlayer.SetScriptData(1, rPlayer.GetNumberOfUnits());

		return true;
	}

	state Initialize;
	state Nothing;

	state Initialize{
		player rPlayer;
		int i;
		int nStartingMoney;

		if(comboTime==0){
			nTimeLimit=0;
		}else if(comboTime==1){
			nTimeLimit=15*60*20;
		}else if(comboTime==2){
			nTimeLimit=30*60*20;
		}else if(comboTime==3){
			nTimeLimit=45*60*20;
		}else if(comboTime==4){
			nTimeLimit=60*60*20;
		}else if(comboTime==5){
			nTimeLimit=90*60*20;
		}

		for(i=0;i<15;++i){
			rPlayer=GetPlayer(i);
			if(rPlayer!=null){
				if(rPlayer.GetRace()==raceUCS){
					rPlayer.EnableBuilding("UCSBLZ", false);
					rPlayer.EnableBuilding("UCSBTB", false);
				}else if(rPlayer.GetRace()==raceED){
					rPlayer.EnableBuilding("EDBLZ", false);
					rPlayer.EnableBuilding("EDBTC", false);
				}else if(rPlayer.GetRace()==raceLC){
					rPlayer.EnableBuilding("LCBLZ", false);
					rPlayer.EnableBuilding("LCBSR", false);
				}
			}
		}

		bCheckBuilding=false;
		for(i=0;i<15;++i){
			rPlayer=GetPlayer(i);
			if(rPlayer!=null){
				rPlayer.SetAllowGiveUnits(false);
				rPlayer.EnableAIFeatures2(ai2BNSendResult, false);
				rPlayer.AddResearch("RES_MSR2");
				rPlayer.AddResearch("RES_MSR3");
				rPlayer.AddResearch("RES_MSR4");
				rPlayer.AddResearch("RES_MMR2");
				rPlayer.AddResearch("RES_MMR3");
				rPlayer.AddResearch("RES_MMR4");
				if(rPlayer.GetRace()==raceUCS){
					rPlayer.AddResearch("RES_UCS_SGen");
					rPlayer.AddResearch("RES_UCS_MGen");
					rPlayer.AddResearch("RES_UCS_HGen");
				}else if(rPlayer.GetRace()==raceED){
					rPlayer.AddResearch("RES_ED_SGen");
					rPlayer.AddResearch("RES_ED_MGen");
					rPlayer.AddResearch("RES_ED_HGen");
				}else if(rPlayer.GetRace()==raceLC){
					rPlayer.AddResearch("RES_LC_SGen");
					rPlayer.AddResearch("RES_LC_MGen");
					rPlayer.AddResearch("RES_LC_HGen");
				}

				rPlayer.SetMaxTankPlatoonSize(1);
				rPlayer.SetNumberOfOffensiveTankPlatoons(4);
				rPlayer.SetNumberOfDefensiveTankPlatoons(0);
				rPlayer.SetNumberOfDefensiveShipPlatoons(0);
				rPlayer.SetNumberOfDefensiveHelicopterPlatoons(0);
				rPlayer.EnableAIFeatures(aiRush, true);
				rPlayer.EnableAIFeatures(aiBuildBuildings, false);
				rPlayer.EnableAIFeatures2(ai2NeutralAI, false);
				rPlayer.SetMaxAttackFrequency(20);

				rPlayer.SetMoney(0);
				rPlayer.LookAt(rPlayer.GetStartingPointX(), rPlayer.GetStartingPointY(), 6, 0, 20, 0);
				CreateStartingUnits(rPlayer, rPlayer);
				CreateArtefacts(rPlayer);
				rPlayer.SetScriptData(0, 0);
			}
		}
		SetTimer(0, 23);		//respawn
		SetTimer(1, 1200);
		SetTimer(2, 53);		//console

		nMeteor=1;
		return Nothing;
	}

	state Nothing{
		return Nothing;
	}

	event RemoveResources(){
		true;
	}

	event RemoveUnits(){
		true;
	}

	event Timer2(){
		int i;
		int k;
		player rPlayer;
		player rPlayer2;

		rPlayer=null;
		for(i=nPlayerInConsole+1;i<15 && rPlayer==null;++i){
			rPlayer=GetPlayer(i);
			if(rPlayer!=null){
				nPlayerInConsole=i;
			}
		}
		if(rPlayer==null){
			nPlayerInConsole=0;
			for(i=0;i<15 && rPlayer==null;++i){
				rPlayer=GetPlayer(i);
				if(rPlayer!=null){
					nPlayerInConsole=i;
				}
			}
		}


		if(rPlayer!=null){
			k=1;
			for(i=0;i<15;++i){
				rPlayer2=GetPlayer(i);
				if(rPlayer2!=null && (rPlayer.GetScriptData(0)<rPlayer2.GetScriptData(0))){
					++k;
				}
			}
			SetConsoleTextCol(rPlayer.GetIFFNumber(), "translateArenaStatistics", k, rPlayer.GetName(), rPlayer.GetScriptData(0));
		}
	}

	event Timer0(){
		int i;
		int nPlayersCount;
		player rPlayer;
		player rPlayer2;
		player rLastPlayer;

		nPlayersCount=0;
		for(i=0;i<15;++i){
			rPlayer=GetPlayer(i);
			if(rPlayer!=null && rPlayer.IsAlive()){
				++nPlayersCount;
				rLastPlayer=rPlayer;
				if(!rPlayer.GetScriptData(1)){
					rPlayer2=GetPlayer(nPlayerInConsole);
					if(rPlayer2==null){
						rPlayer2=rPlayer;
					}
					rPlayer.LookAt(rPlayer2.GetStartingPointX(), rPlayer2.GetStartingPointY(), -1, -1, -1, 0);
					CreateStartingUnits(rPlayer, rPlayer2);
				}
			}
		}
		if(nPlayersCount==1){
			rLastPlayer.Victory();
		}
	}

	event Timer1(){
		int i;
		player rPlayer;
		player rBestPlayer;
		int bestScore;

		bCheckBuilding=true;
		if(nTimeLimit){
			if(GetMissionTime()>nTimeLimit){
				for(i=0;i<15;++i){
					rPlayer=GetPlayer(i);
					if(rPlayer!=null){
						if(rPlayer.GetScriptData(0)>bestScore){
							bestScore=rPlayer.GetScriptData(0);
						}
					}
				}
				for(i=0;i<15;++i){
					rPlayer=GetPlayer(i);
					if(rPlayer!=null && rPlayer.IsAlive()){
						if(rPlayer.GetScriptData(0)==bestScore){
							rPlayer.Victory();
						}else{
							rPlayer.Defeat();
						}
					}
				}
			}
		}
	}

	event UnitDestroyed(unit uUnit){
		unit uAttacker;
		player pAttacker;
		player pDestroyed;
		int tmp;

		pAttacker=GetPlayer(uUnit.GetIFFNumber());
		pAttacker.SetScriptData(1, pAttacker.GetScriptData(1)+1);
		uAttacker=uUnit.GetAttacker();
		if(uAttacker==null){
			return false;
		}
		pAttacker=GetPlayer(uAttacker.GetIFFNumber());
		if(uAttacker.GetIFFNumber()==uUnit.GetIFFNumber()){
			tmp=pAttacker.GetScriptData(0)+1;
		}else{
			tmp=pAttacker.GetScriptData(0)+1;
		}
		pAttacker.SetScriptData(0, tmp);

		return true;
	}

	command Initialize(){
		comboStartingUnits=1;
	}

	command Uninitialize(){
		ResourcesPerContainer(8);
	}

	command Combo1(int nMode) button comboTechLevel{
		comboTechLevel=nMode;
	}

	command Combo2(int nMode) button comboStartingUnits{
		comboStartingUnits=nMode;
	}

	command Combo3(int nMode) button comboTime{
		comboTime=nMode;
	}
}
