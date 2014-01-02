/* Copyright 2009-2014 surrim
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

	state Initialize;
	state Nothing;

	state Initialize{
		int nGetIFFNumberMod5;
		int nGetRace;

		nGetIFFNumberMod5=GetIFFNumber()%5;
		nGetRace=GetRace();

		if(nGetRace==raceUCS){
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
		}else if(nGetRace==raceED){
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
		}

		SetMaxTankPlatoonSize(6);
		SetMaxHelicopterPlatoonSize(6);
		SetMaxShipPlatoonSize(6);

		SetNumberOfOffensiveTankPlatoons(4);
		SetNumberOfOffensiveShipPlatoons(4);
		SetNumberOfOffensiveHelicopterPlatoons(4);

		SetNumberOfDefensiveTankPlatoons(4);
		SetNumberOfDefensiveShipPlatoons(0);
		SetNumberOfDefensiveHelicopterPlatoons(3);

		SetMaxAttackFrequency(400);

		return Nothing, 6000;
	}

	state Nothing{
		if(!nAttackMode){
			nAttackMode=1;
			SetMaxAttackFrequency(10);
			return Nothing, 200;
		}
		nAttackMode=0;
		SetMaxAttackFrequency(800);
		return Nothing, 6000;
	}
}
