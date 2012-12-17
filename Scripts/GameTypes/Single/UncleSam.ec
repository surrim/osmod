/* Copyright 2009, 2010, 2011, 2012 surrim
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

mission "translateGameTypeUncleSamMP"{

	int nCashRate;
	int nCashTime;

	int bGameEnded;

	enum comboMoney{
		"translateScript10000CR",
		"translateScript15000CR",
		"translateScript20000CR",
		"translateScript30000CR",
		"translateScript40000CR",
		"translateScript50000CR",
		multi:"translateGameMenuStartingMoney"
	} enum comboCashRate{
		"translateScript1000CR",
		"translateScript2500CR",
		"translateScript5000CR",
		"translateScript10000CR",
		"translateScript15000CR",
		"translateScript20000CR",
		multi:"translateGameMenuCashRate"
	} enum comboCashTime{

		"translateGameMenuRateFrequency1min",
		"translateGameMenuRateFrequency3min",
		"translateGameMenuRateFrequency5min",
		"translateGameMenuRateFrequency10min",
		"translateGameMenuRateFrequency15min",

		multi:"translateGameMenuRateFrequency"
	} enum comboStartingUnits{
		"translateGameMenuStartingUnitsDefault",
		"translateGameMenuStartingUnitsBuilderOnly",
		multi:"translateGameMenuStartingUnits"
	} enum comboUnitsLimit{
		"translateGameMenuUnitsLimitNoLimit",
		"translateGameMenuUnitsLimit10000CR",
		"translateGameMenuUnitsLimit20000CR",
		"translateGameMenuUnitsLimit30000CR",
		"translateGameMenuUnitsLimit50000CR",
		multi:"translateGameMenuUnitsLimit"
	} enum comboAlliedVictory{
		"translateGameMenuAlliedVictoryNo",
		"translateGameMenuAlliedVictoryYes",
		multi:"translateGameMenuAlliedVictory"
	} state Initialize;
	state Nothing;

	state Initialize{
		player rPlayer;
		int i;
		int nStartingMoney;


		if(comboMoney==0)
			nStartingMoney=10000;
		if(comboMoney==1)
			nStartingMoney=15000;
		if(comboMoney==2)
			nStartingMoney=20000;
		if(comboMoney==3)
			nStartingMoney=30000;
		if(comboMoney==4)
			nStartingMoney=40000;
		if(comboMoney==5)
			nStartingMoney=50000;

		if(comboCashRate==0)
			nCashRate=1000;
		if(comboCashRate==1)
			nCashRate=2500;
		if(comboCashRate==2)
			nCashRate=5000;
		if(comboCashRate==3)
			nCashRate=10000;
		if(comboCashRate==4)
			nCashRate=15000;
		if(comboCashRate==5)
			nCashRate=20000;

		if(comboCashTime==0)
			nCashTime=1*60*20;
		if(comboCashTime==1)
			nCashTime=3*60*20;
		if(comboCashTime==2)
			nCashTime=5*60*20;
		if(comboCashTime==3)
			nCashTime=10*60*20;
		if(comboCashTime==4)
			nCashTime=15*60*20;

		for(i=0;i<15;++i){
			rPlayer=GetPlayer(i);
			if(rPlayer!=null){
				if(rPlayer.GetRace()==raceUCS){
					rPlayer.EnableBuilding("UCSBLZ", false);
					rPlayer.EnableBuilding("UCSBTB", false);
				}
				if(rPlayer.GetRace()==raceED){
					rPlayer.EnableBuilding("EDBLZ", false);
					rPlayer.EnableBuilding("EDBTC", false);
				}
				if(rPlayer.GetRace()==raceLC){
					rPlayer.EnableBuilding("LCBLZ", false);
					rPlayer.EnableBuilding("LCBSR", false);
				}
			}
		}

		bGameEnded=false;
		for(i=0;i<15;++i){
			rPlayer=GetPlayer(i);

			if(rPlayer!=null){
				rPlayer.SetMaxDistance(30);
				if(comboAlliedVictory)
					rPlayer.EnableAIFeatures2(ai2BNSendResult, false);	//nie wysylac rezultatow do EARTH NETu

				rPlayer.SetMoney(nStartingMoney);
				rPlayer.
					EnableAIFeatures(aiBuildMiningBuildings |
									 aiBuildMiningUnits |
									 aiControlMiningUnits, false);
				rPlayer.LookAt(rPlayer.GetStartingPointX(),
							   rPlayer.GetStartingPointY(), 6, 0, 20, 0);

				if(comboUnitsLimit==0)
					rPlayer.EnableMilitaryUnitsLimit(false);
				if(comboUnitsLimit==1)
					rPlayer.SetMilitaryUnitsLimit(10000);
				if(comboUnitsLimit==2)
					rPlayer.SetMilitaryUnitsLimit(20000);
				if(comboUnitsLimit==3)
					rPlayer.SetMilitaryUnitsLimit(30000);
				if(comboUnitsLimit==4)
					rPlayer.SetMilitaryUnitsLimit(50000);

				if(!rPlayer.GetNumberOfUnits()
					&& !rPlayer.GetNumberOfBuildings())
					rPlayer.CreateDefaultUnit(rPlayer.GetStartingPointX(),
											  rPlayer.GetStartingPointY(),
											  0);

				rPlayer.EnableCommand(commandSoldBuilding, true);
				rPlayer.AddResearch("RES_MISSION_PACK1_ONLY");	//Enable mission pack units and buildings

				rPlayer.EnableBuilding("EDBMI", false);
				rPlayer.EnableBuilding("EDBRE", false);
				rPlayer.EnableBuilding("UCSBRF", false);
				rPlayer.EnableBuilding("LCBMR", false);

				rPlayer.EnableResearch("RES_UCS_UOH2", false);
				rPlayer.EnableResearch("RES_UCS_UOH3", false);
				rPlayer.EnableResearch("RES_UCS_UAH1", false);
				rPlayer.EnableResearch("RES_UCS_UAH2", false);
				rPlayer.EnableResearch("RES_UCS_UAH3", false);

			}
		}
		SetTimer(0, 100);
		SetTimer(1, nCashTime);
		SetTimer(2, 200);
		SetTimer(5, 200);
		return Nothing;
	}

	state Nothing{
		return Nothing;
	} event RemoveResources(){
		true;
	}

	event RemoveUnits(){
		if(comboStartingUnits)
			true;
		else
			false;
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

		rLastPlayer=null;
		iAlivePlayers=0;
		if(comboAlliedVictory)	//--------------------------------------------------------------
		{
			bOneHasBeenDestroyed=false;
			for(i=0;i<15;++i){
				rPlayer=GetPlayer(i);
				if(rPlayer!=null && rPlayer.IsAlive()){
					iCountBuilding =
						rPlayer.GetNumberOfBuildings() +
						rPlayer.GetNumberOfUnits();
					if(iCountBuilding==0){
						rPlayer.Defeat();
					}
				}
				if(rPlayer!=null && !rPlayer.IsAlive())
					bOneHasBeenDestroyed=true;
			}

			bActiveEnemies=false;
			for(i=0;i<15;++i){
				rPlayer=GetPlayer(i);
				if(rPlayer!=null && rPlayer.IsAlive()){
					for (j=i+1; j<15; j=j+1){
						rPlayer2=GetPlayer(j);
						if(rPlayer2!=null && rPlayer2.IsAlive()
							&& !rPlayer.IsAlly(rPlayer2)){
							bActiveEnemies=true;
						}
					}
				}
			}
			if(bActiveEnemies)
				return;
			if(!bOneHasBeenDestroyed)
				return;

			for(i=0;i<15;++i){
				rPlayer=GetPlayer(i);
				if(rPlayer!=null && rPlayer.IsAlive()){
					rPlayer.Victory();
				}
			}
		} else					//---------------------------------------------------------------------------------
		{
			for(i=0;i<15;++i){
				rPlayer=GetPlayer(i);
				if(rPlayer!=null && rPlayer.IsAlive()){
					iCountBuilding =
						rPlayer.GetNumberOfBuildings() +
						rPlayer.GetNumberOfUnits();
					if(iCountBuilding>0){
						iAlivePlayers=iAlivePlayers+1;
						rLastPlayer=rPlayer;
					} else{
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
		int money;
		player rPlayer;

		for(i=0;i<15;++i){
			rPlayer=GetPlayer(i);
			if(rPlayer!=null){
				if(rPlayer.GetMoney()<100000)
					rPlayer.AddMoney(nCashRate);
			}
		}
	}

	event Timer2(){
		int i;
		player rPlayer;

		for(i=0;i<15;++i){
			rPlayer=GetPlayer(i);
			if(rPlayer!=null){
				if(rPlayer.GetMaxDistance()<255)
					rPlayer.SetMaxDistance(rPlayer.GetMaxDistance()+1);
			}
		}
	}

	event Timer5(){
		int i;
		int j;
		player rPlayer;
		player rPlayer2;
		//sprawdzanie zenablowania szpiegowania
		//(po 10 minutach+warunek player ma 2 lub mniej budynki inne niz wiezyczki
		//i 4 lub mniej wiezyczki i 6 lub mniej unitow)
		//jesli warunek nie jest spelniony to z powrotem disablujemy szpiegowanie
		if(GetMissionTime()>10*60*20){
			for(i=0;i<15;++i){
				rPlayer=GetPlayer(i);
				if((rPlayer!=null) && rPlayer.IsAlive()){
					if((rPlayer.GetNumberOfBuildings(buildingNormal)<=4)
						&&
						((rPlayer.GetNumberOfBuildings() -
						  rPlayer.GetNumberOfBuildings(buildingNormal)) <=
						 2) && (rPlayer.GetNumberOfUnits()<=6)){
						for (j=0; j<15; j=j+1){
							rPlayer2=GetPlayer(j);
							if((j!=i) && (rPlayer2!=null)
								&& rPlayer2.IsAlive()
								&& !rPlayer2.IsAlly(rPlayer)){
								if(rPlayer2.
									IsCommandDisabled
									(commandBuildingSpyPlayer0+i))
									rPlayer2.
										EnableCommand
										(commandBuildingSpyPlayer0+i,
										 true);
							}
						}
					} else{
						for (j=0; j<15; j=j+1){
							rPlayer2=GetPlayer(j);
							if((j!=i) && (rPlayer2!=null)
								&& rPlayer2.IsAlive()){
								if(rPlayer2.
									IsCommandEnabled
									(commandBuildingSpyPlayer0+i))
									rPlayer2.
										EnableCommand
										(commandBuildingSpyPlayer0+i,
										 false);
							}
						}
					}
				}
			}
		}
	}

	command Initialize(){
		nCashRate=5000;
		comboCashRate=2;
		nCashTime=60*20;
		comboStartingUnits=1;
		comboAlliedVictory=1;
		comboUnitsLimit=2;
	}

	command Combo1(int nMode) button comboMoney{
		comboMoney=nMode;
	} command Combo2(int nMode) button comboCashRate{
		comboCashRate=nMode;
	} command Combo3(int nMode) button comboCashTime{
		comboCashTime=nMode;
	} command Combo4(int nMode) button comboStartingUnits{
		comboStartingUnits=nMode;
	} command Combo5(int nMode) button comboUnitsLimit{
		comboUnitsLimit=nMode;
	} command Combo6(int nMode) button comboAlliedVictory{
		comboAlliedVictory=nMode;
}}
