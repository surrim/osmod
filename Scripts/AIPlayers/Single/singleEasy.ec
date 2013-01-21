/* Copyright 2009, 2010, 2011, 2012, 2013 surrim
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

player "translateAIPlayerEasy"{
	state Initialize;
	state Nothing;

	state Initialize{
		int nGetIFFNumberMod5;
		int nGetRace;

		nGetIFFNumberMod5=GetIFFNumber()%5;
		nGetRace=GetRace();

		if(nGetRace==raceUCS){
			if(nGetIFFNumberMod5==0){
				SetName("translateAIPlayerNameUCSEasy");
			}else if(nGetIFFNumberMod5==1){
				SetName("translateAINameEasyUCS1");
			}else if(nGetIFFNumberMod5==2){
				SetName("translateAINameEasyUCS2");
			}else if(nGetIFFNumberMod5==3){
				SetName("translateAINameEasyUCS3");
			}else if(nGetIFFNumberMod5==4){
				SetName("translateAINameEasyUCS4");
			}
		}else if(nGetRace==raceED){
			if(nGetIFFNumberMod5==0){
				SetName("translateAIPlayerNameEDEasy");
			}else if(nGetIFFNumberMod5==1){
				SetName("translateAINameEasyED1");
			}else if(nGetIFFNumberMod5==2){
				SetName("translateAINameEasyED2");
			}else if(nGetIFFNumberMod5==3){
				SetName("translateAINameEasyED3");
			}else if(nGetIFFNumberMod5==4){
				SetName("translateAINameEasyED4");
			}
		}else if(nGetRace==raceLC){
			if(nGetIFFNumberMod5==0){
				SetName("translateAIPlayerNameLCEasy");
			}else if(nGetIFFNumberMod5==1){
				SetName("translateAINameEasyLC1");
			}else if(nGetIFFNumberMod5==2){
				SetName("translateAINameEasyLC2");
			}else if(nGetIFFNumberMod5==3){
				SetName("translateAINameEasyLC3");
			}else if(nGetIFFNumberMod5==4){
				SetName("translateAINameEasyLC4");
			}
		}

		SetMaxTankPlatoonSize(3);
		SetMaxHelicopterPlatoonSize(3);
		SetMaxShipPlatoonSize(3);

		SetNumberOfOffensiveTankPlatoons(1);
		SetNumberOfOffensiveShipPlatoons(1);
		SetNumberOfOffensiveHelicopterPlatoons(1);

		SetNumberOfDefensiveTankPlatoons(3);
		SetNumberOfDefensiveShipPlatoons(0);
		SetNumberOfDefensiveHelicopterPlatoons(1);

		EnableAIFeatures(aiUpgradeCannons, false);
		EnableAIFeatures(aiRush, false);
		SetMaxAttackFrequency(800);

		return Nothing;
	}
	state Nothing{
		return Nothing, 100000;
	}
}
