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

player "translateAIPlayerHard"{
	int nAttackMode;
	int nGetRace;

	state Initialize;
	state SetLimitState;
	state Nothing;

	state Initialize{
		int nGetIFFNumberMod5;

		nGetIFFNumberMod5=GetIFFNumber()%5;
		nGetRace=GetRace();

		if(nGetRace==raceED){
			EnableResearch("RES_EDUUT", false); //Einheitentransporter
			EnableResearch("RES_EDWAN1", false); //AntiRakete
			EnableResearch("RES_EDWEQ1", false); //Erdbebengenerator
			EnableResearch("RES_EDWEQ2", false); //Upg.Erdbebengenerator
			EnableResearch("RES_ED_BC1", false); //Gebäudestürmer
			EnableResearch("RES_ED_SDI", false); //SDI
			EnableResearch("RES_ED_WSDI", false); //SDI Defense Center

			if(nGetIFFNumberMod5==0){
				SetName("translateAIPlayerNameEDHard");
			}else if(nGetIFFNumberMod5==1){
				SetName("translateAINameHardED1");
			}else if(nGetIFFNumberMod5==2){
				SetName("translateAINameHardED2");
			}else if(nGetIFFNumberMod5==3){
				SetName("translateAINameHardED3");
			}else if(nGetIFFNumberMod5==4){
				SetName("translateAINameHardED4");
			}
		}else if(nGetRace==raceLC){
			EnableResearch("RES_LCUUT", false); //Einheitentransporter
			EnableResearch("RES_LCWAN1", false); //Antirocket
			EnableResearch("RES_LC_METEORK", false); //Meteoritenkontrollzentrum
			EnableResearch("RES_LC_SLP", false); //Sunlight Project
			EnableResearch("RES_LCWEQ1", false); //Erdbebengenerator
			EnableResearch("RES_LCWEQ2", false); //Upg.Erdbebengenerator
			EnableResearch("RES_LCBPP2", false); //Xylit Kraftwerk
			EnableResearch("RES_LC_LCBMR2", false); //Mine upg.
			EnableResearch("RES_LC_LCBMR2", false); //Mine upg.
			EnableResearch("RES_LC_SDIDEF", false); //SDI-Laser
			EnableResearch("RES_LC_BC1", false); //Gebäudestürmer

			if(nGetIFFNumberMod5==0){
				SetName("translateAIPlayerNameLCHard");
			}else if(nGetIFFNumberMod5==1){
				SetName("translateAINameHardLC1");
			}else if(nGetIFFNumberMod5==2){
				SetName("translateAINameHardLC2");
			}else if(nGetIFFNumberMod5==3){
				SetName("translateAINameHardLC3");
			}else if(nGetIFFNumberMod5==4){
				SetName("translateAINameHardLC4");
			}
		}else if(nGetRace==raceUCS){
			EnableResearch("RES_UCSUUT", false); //Einheitentransporter
			EnableResearch("RES_UCSWAN1", false); //AntiRakete
			EnableResearch("RES_UCSWEQ1", false); //Erdbebengenerator
			EnableResearch("RES_UCSWEQ2", false); //Upg.Erdbebengenerator
			EnableResearch("RES_UCS_WSD", false); //SDI-Laser
			EnableResearch("RES_UCS_BC1", false); //Gebäudestürmer
			EnableResearch("RES_UCS_UCSUOB2", false); //Aufklärer II

			if(nGetIFFNumberMod5==0){
				SetName("translateAIPlayerNameUCSHard");
			}else if(nGetIFFNumberMod5==1){
				SetName("translateAINameHardUCS1");
			}else if(nGetIFFNumberMod5==2){
				SetName("translateAINameHardUCS2");
			}else if(nGetIFFNumberMod5==3){
				SetName("translateAINameHardUCS3");
			}else if(nGetIFFNumberMod5==4){
				SetName("translateAINameHardUCS4");
			}
		}

		SetMaxTankPlatoonSize(6);
		SetMaxHelicopterPlatoonSize(6);
		SetMaxShipPlatoonSize(6);

		SetNumberOfOffensiveTankPlatoons(5);
		SetNumberOfOffensiveShipPlatoons(2);
		SetNumberOfOffensiveHelicopterPlatoons(2);

		SetNumberOfDefensiveTankPlatoons(2);
		SetNumberOfDefensiveShipPlatoons(0);
		SetNumberOfDefensiveHelicopterPlatoons(1);

		if(GetIFFNumber()&1){
			EnableAIFeatures(aiBuildSuperAttack, false);
		}

		nAttackMode=0;
		SetMaxAttackFrequency(400);

		return SetLimitState, 10;
	}

	state SetLimitState{
		EnableMilitaryUnitsLimit(false);
		return Nothing, 6000;
	}

	state Nothing{
		if(nGetRace!=raceLC && GetNumberOfUnits()<10){
			CreateDefaultUnit(GetStartingPointX(), GetStartingPointY(), 0);
		}
		SetMoney(100000000);
		if(!nAttackMode){
			nAttackMode=1;
			SetMaxAttackFrequency(5);
			return Nothing, 600;
		}
		nAttackMode=0;
		SetMaxAttackFrequency(800);
		return Nothing, 6000;
	}
}
