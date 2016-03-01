/* Copyright 2009-2016 surrim
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

player "translateAIPlayerExpert"{
	int nAttackMode;
	int nGetRace;

	state Initialize;
	state SetLimitState;
	state Nothing;

	state Initialize{
		int nGetIFFNumberMod5;

		nGetIFFNumberMod5=GetIFFNumber()%5;
		nGetRace=GetRace();

		SetName("translateAIPlayerExpert");

		SetMaxTankPlatoonSize(6);
		SetMaxHelicopterPlatoonSize(6);
		SetMaxShipPlatoonSize(6);

		SetNumberOfOffensiveTankPlatoons(4);
		SetNumberOfOffensiveShipPlatoons(1);
		SetNumberOfOffensiveHelicopterPlatoons(4);

		SetNumberOfDefensiveTankPlatoons(1);
		SetNumberOfDefensiveShipPlatoons(0);
		SetNumberOfDefensiveHelicopterPlatoons(1);

		if(nGetIFFNumberMod5==1){
			SetNumberOfOffensiveTankPlatoons(2);
		}else if(nGetIFFNumberMod5==2){
			SetNumberOfDefensiveTankPlatoons(0);
		}else if(nGetIFFNumberMod5==3){
			SetNumberOfDefensiveTankPlatoons(5);
		}else if(nGetIFFNumberMod5==4){
			SetMaxTankPlatoonSize(3);
			SetMaxHelicopterPlatoonSize(8);
		}

		AddResearch("RES_MCH2");
		AddResearch("RES_MCH3");
		AddResearch("RES_MCH4");
		AddResearch("RES_MSR2");
		AddResearch("RES_MSR3");
		AddResearch("RES_MSR4");
		AddResearch("RES_MMR2");
		AddResearch("RES_MMR3");
		AddResearch("RES_MMR4");
		if(nGetRace==raceED){
			EnableResearch("RES_EDUUT", false); //Einheitentransporter
			EnableResearch("RES_EDWAN1", false); //AntiRakete
			EnableResearch("RES_EDWEQ1", false); //Erdbebengenerator
			EnableResearch("RES_EDWEQ2", false); //Upg.Erdbebengenerator
			EnableResearch("RES_ED_BC1", false); //Gebäudestürmer
			EnableResearch("RES_ED_SDI", false); //SDI
			EnableResearch("RES_ED_WSDI", false); //SDI Defense Center

			AddResearch("RES_ED_MSC2");
			AddResearch("RES_ED_MSC3");
			AddResearch("RES_ED_MSC4");
			AddResearch("RES_ED_MHC2");
			AddResearch("RES_ED_MHC3");
			AddResearch("RES_ED_MHC4");
			AddResearch("RES_ED_MB2");
			AddResearch("RES_ED_MB3");
			AddResearch("RES_ED_MB4");
			AddResearch("RES_ED_UST2");
			AddResearch("RES_ED_UST3");
			AddResearch("RES_ED_UMT1");
			AddResearch("RES_ED_UMT2");
			AddResearch("RES_ED_UMT3");
			AddResearch("RES_ED_UMI1");
			AddResearch("RES_ED_UMI2");
			AddResearch("RES_ED_UA11");
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

			AddResearch("RES_LC_ULU2");
			AddResearch("RES_LC_ULU3");
			AddResearch("RES_LC_UMO2");
			AddResearch("RES_LC_UMO3");
			AddResearch("RES_LC_UME1");
		}else if(nGetRace==raceUCS){
			EnableResearch("RES_UCSUUT", false); //Einheitentransporter
			EnableResearch("RES_UCSWAN1", false); //AntiRakete
			EnableResearch("RES_UCSWEQ1", false); //Erdbebengenerator
			EnableResearch("RES_UCSWEQ2", false); //Upg.Erdbebengenerator
			EnableResearch("RES_UCS_WSD", false); //SDI-Laser
			EnableResearch("RES_UCS_BC1", false); //Gebäudestürmer
			EnableResearch("RES_UCS_UCSUOB2", false); //Aufklärer II

			AddResearch("RES_UCS_UOH2");
			AddResearch("RES_UCS_UOH3");
			AddResearch("RES_UCS_UAH1");
			AddResearch("RES_UCS_UAH2");
			AddResearch("RES_UCS_UAH3");
			AddResearch("RES_UCS_GARG1");
			AddResearch("RES_UCS_MB2");
			AddResearch("RES_UCS_MB3");
			AddResearch("RES_UCS_MB4");
			AddResearch("RES_UCS_MG2");
			AddResearch("RES_UCS_MG3");
			AddResearch("RES_UCS_MG4");
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
			SetMaxAttackFrequency(20);
			return Nothing, 200;
		}
		nAttackMode=0;
		SetMaxAttackFrequency(800);
		return Nothing, 5000;
	}
}
