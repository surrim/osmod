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

mission "translateGameTypeHarvestAndKillMP"{
	int nTimeLimit;
	int bCheckBuilding;
	int nMeteor;

	enum comboMoney{
		"translateScript20000CR",
		"translateScript30000CR",
		"translateScript40000CR",
		"translateScript50000CR",
	multi:
		"translateGameMenuStartingMoney"
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

	enum comboResources{
		"translateGameMenuResourcesLow",
		"translateGameMenuResourcesNormal",
		"translateGameMenuResourcesHigh",
		"translateGameMenuResourcesVeryHigh",
	multi:
		"translateGameMenuResources"
	}

	enum comboStartingUnits{
		"translateGameMenuStartingUnitsDefault",
		"translateGameMenuStartingUnitsBuilderOnly",
	multi:
		"translateGameMenuStartingUnits"
	}

	enum comboUnitsLimit{
		"translateGameMenuUnitsLimitNoLimit",
		"translateGameMenuUnitsLimit10000CR",
		"translateGameMenuUnitsLimit20000CR",
		"translateGameMenuUnitsLimit30000CR",
		"translateGameMenuUnitsLimit50000CR",
	multi:
		"translateGameMenuUnitsLimit"
	}

	enum comboAlliedVictory{
		"translateGameMenuAlliedVictoryNo",
		"translateGameMenuAlliedVictoryYes",
	multi:
		"translateGameMenuAlliedVictory"
	}

	state Initialize;
	state Nothing;

	state Initialize{
		player rPlayer;
		int i;
		int nStartingMoney;

		if(comboMoney==0){
			nStartingMoney=20000;
		}else if(comboMoney==1){
			nStartingMoney=30000;
		}else if(comboMoney==2){
			nStartingMoney=40000;
		}else if(comboMoney==3){
			nStartingMoney=50000;
		}

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

		if(comboResources==0){
			ResourcesPerContainer(16);
		}else if(comboResources==1){
			ResourcesPerContainer(8);
		}else if(comboResources==2){
			ResourcesPerContainer(4);
		}else if(comboResources==3){
			ResourcesPerContainer(2);
		}

		for(i=0;i<15;++i){
			rPlayer=GetPlayer(i);
			if(rPlayer!=null){
				if((GetRight()+GetLeft())<128){	//width of the world
					rPlayer.SetMaxDistance(20);
				}else{
					rPlayer.SetMaxDistance(30);
				}

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
				rPlayer.EnableCommand(commandSoldBuilding, true);
				rPlayer.AddResearch("RES_MISSION_PACK1_ONLY");
			}
		}

		bCheckBuilding=false;
		for(i=0;i<15;++i){
			rPlayer=GetPlayer(i);
			if(rPlayer!=null){
				if(comboAlliedVictory){
					rPlayer.EnableAIFeatures2(ai2BNSendResult, false);
				}

				if(comboUnitsLimit==0){
					rPlayer.EnableMilitaryUnitsLimit(false);
				}else if(comboUnitsLimit==1){
					rPlayer.SetMilitaryUnitsLimit(10000);
				}else if(comboUnitsLimit==2){
					rPlayer.SetMilitaryUnitsLimit(20000);
				}else if(comboUnitsLimit==3){
					rPlayer.SetMilitaryUnitsLimit(30000);
				}else if(comboUnitsLimit==4){
					rPlayer.SetMilitaryUnitsLimit(50000);
				}

				rPlayer.SetMoney(nStartingMoney);
				rPlayer.LookAt(rPlayer.GetStartingPointX(), rPlayer.GetStartingPointY(), 6, 0, 20, 0);
				if(!rPlayer.GetNumberOfUnits() && !rPlayer.GetNumberOfBuildings()){
					rPlayer.CreateDefaultUnit(rPlayer.GetStartingPointX(), rPlayer.GetStartingPointY(), 0);
				}
			}
		}
		SetTimer(0,  5*20);
		SetTimer(3, 10*20);
		SetTimer(1, 60*20);

		nMeteor=1;

		return Nothing;
	}

	state Nothing{
		return Nothing;
	}

	event RemoveResources(){
		false;
	}

	event RemoveUnits(){
		if(comboStartingUnits){
			true;
		}else{
			false;
		}
	}

	event Timer0(){
		int iAlivePlayers;
		int i;
		int j;
		int iCountBuilding;
		int bActiveEnemies;
		int bOneHasBeenDestroyed;
		player rPlayer;
		player rPlayer2;
		player rLastPlayer;
		//----meteors
		//rPlayer=GetPlayer(1);
		//Meteor(rPlayer.GetStartingPointX()-nMeteor*2,rPlayer.GetStartingPointY(),nMeteor);
		//nMeteor=(nMeteor%10)+1;
		//end of meteors

		if(bCheckBuilding==false){
			return 0;
		}
		rLastPlayer=null;
		iAlivePlayers=0;
		if(comboAlliedVictory){
			bOneHasBeenDestroyed=false;
			for(i=0;i<15;++i){
				rPlayer=GetPlayer(i);
				if(rPlayer!=null && rPlayer.IsAlive()){
					iCountBuilding=
						rPlayer.GetNumberOfBuildings()
						+rPlayer.GetNumberOfUnits();
					if(iCountBuilding==0){
						rPlayer.Defeat();
					}
				}
				if(rPlayer!=null && !rPlayer.IsAlive()){
					bOneHasBeenDestroyed=true;
				}
			}

			bActiveEnemies=false;
			for(i=0;i<15;++i){
				rPlayer=GetPlayer(i);
				if(rPlayer!=null && rPlayer.IsAlive()){
					for(j=i+1;j<15;++j){
						rPlayer2=GetPlayer(j);
						if(rPlayer2!=null && rPlayer2.IsAlive() && !rPlayer.IsAlly(rPlayer2)){
							bActiveEnemies=true;
						}
					}
				}
			}
			if(bActiveEnemies || !bOneHasBeenDestroyed){
				return;
			}

			for(i=0;i<15;++i){
				rPlayer=GetPlayer(i);
				if(rPlayer!=null && rPlayer.IsAlive()){
					rPlayer.Victory();
				}
			}
		}else{
			for(i=0;i<15;++i){
				rPlayer=GetPlayer(i);
				if(rPlayer!=null && rPlayer.IsAlive()){
					iCountBuilding=
						rPlayer.GetNumberOfBuildings()
						+rPlayer.GetNumberOfUnits();
					if(iCountBuilding>0){
						++iAlivePlayers;
						rLastPlayer=rPlayer;
					}else{
						rPlayer.Defeat();
					}
				}
			}
			if(iAlivePlayers==1 && rLastPlayer!=null){
				rLastPlayer.Victory();
			}
		}
	}

	event Timer1(){
		int i;
		int minLeft;
		player rPlayer;

		bCheckBuilding=true;
		if(nTimeLimit){
			minLeft=(nTimeLimit+GetMissionTime())/1200;

			if(minLeft<0){
				minLeft=0;
			}
			SetConsoleText("translateScriptTimeLeft", minLeft);
			if(minLeft<1){
				for(i=0;i<15;++i){
					rPlayer=GetPlayer(i);
					if(rPlayer!=null && rPlayer.IsAlive()){
						rPlayer.Defeat();
						KillArea(rPlayer.GetIFF(), GetRight()/2, GetBottom()/2, 0, 256);
					}
				}
				nTimeLimit=0;
			}
		}
	}

	event Timer3(){
		int i;
		player rPlayer;

		for(i=0;i<15;++i){
			rPlayer=GetPlayer(i);
			if(rPlayer!=null){
				if(rPlayer.GetMaxDistance()<255){
					rPlayer.SetMaxDistance(rPlayer.GetMaxDistance()+1);
				}
			}
		}
	}

	command Initialize(){
		comboMoney=0;
		comboResources=1;
		comboStartingUnits=1;
		comboAlliedVictory=1;
		comboUnitsLimit=2;
	}

	command Uninitialize(){
		ResourcesPerContainer(8);
	}

	command Combo1(int nMode) button comboMoney{
		comboMoney=nMode;
	}

	command Combo2(int nMode) button comboTime{
		comboTime=nMode;
	}

	command Combo3(int nMode) button comboResources{
		comboResources=nMode;
	}

	command Combo4(int nMode) button comboStartingUnits{
		comboStartingUnits=nMode;
	}

	command Combo5(int nMode) button comboUnitsLimit{
		comboUnitsLimit=nMode;
	}

	command Combo6(int nMode) button comboAlliedVictory{
		comboAlliedVictory=nMode;
	}
}
