/* Copyright 2009, 2010, 2011 surrim
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

player "translateAIPlayerMedium"{
	state Initialize;
	state Nothing;

	state Initialize{
		int nGetIFFNumberMod5;
		int nGetRace;

		nGetIFFNumberMod5=GetIFFNumber()%5;
		nGetRace=GetRace();

		if(nGetRace==raceUCS){
			if(nGetIFFNumberMod5==0){
				SetName("translateAIPlayerNameUCSMedium");
			}else if(nGetIFFNumberMod5==1){
				SetName("translateAINameMediumUCS1");
			}else if(nGetIFFNumberMod5==2){
				SetName("translateAINameMediumUCS2");
			}else if(nGetIFFNumberMod5==3){
				SetName("translateAINameMediumUCS3");
			}else if(nGetIFFNumberMod5==4){
				SetName("translateAINameMediumUCS4");
			}
		}else if(nGetRace==raceED){
			if(nGetIFFNumberMod5==0){
				SetName("translateAIPlayerNameEDMedium");
			}else if(nGetIFFNumberMod5==1){
				SetName("translateAINameMediumED1");
			}else if(nGetIFFNumberMod5==2){
				SetName("translateAINameMediumED2");
			}else if(nGetIFFNumberMod5==3){
				SetName("translateAINameMediumED3");
			}else if(nGetIFFNumberMod5==4){
				SetName("translateAINameMediumED4");
			}
		}else if(nGetRace==raceLC){
			if(nGetIFFNumberMod5==0){
				SetName("translateAIPlayerNameLCMedium");
			}else if(nGetIFFNumberMod5==1){
				SetName("translateAINameMediumLC1");
			}else if(nGetIFFNumberMod5==2){
				SetName("translateAINameMediumLC2");
			}else if(nGetIFFNumberMod5==3){
				SetName("translateAINameMediumLC3");
			}else if(nGetIFFNumberMod5==4){
				SetName("translateAINameMediumLC4");
			}
		}

		SetMaxTankPlatoonSize(4);
		SetMaxHelicopterPlatoonSize(4);
		SetMaxShipPlatoonSize(4);

		SetNumberOfOffensiveTankPlatoons(3);
		SetNumberOfOffensiveShipPlatoons(2);
		SetNumberOfOffensiveHelicopterPlatoons(2);

		SetNumberOfDefensiveTankPlatoons(4);
		SetNumberOfDefensiveShipPlatoons(0);
		SetNumberOfDefensiveHelicopterPlatoons(2);

		EnableAIFeatures(aiRush, false);
		SetMaxAttackFrequency(400);

		return Nothing;
	}

	state Nothing{
		return Nothing, 100000;
	}
}
