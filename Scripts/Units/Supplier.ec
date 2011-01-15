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

supplier "translateScriptNameSupplyTransporter"{
	consts{
		//comboLights
		LIGHTS_AUTO = 0;
		LIGHTS_ON   = 1;
		LIGHTS_OFF  = 2;
	}

	enum comboLights{
		"translateCommandStateLightsAUTO", //LIGHTS_AUTO
		"translateCommandStateLightsON",   //LIGHTS_ON
		"translateCommandStateLightsOFF",  //LIGHTS_OFF
	multi:
		"translateCommandStateLightsMode"
	}

	int nMoveToX;
	int nMoveToY;
	int nMoveToZ;
	int nLandCounter;

	state Nothing;
	state Moving;
	state Landing;
	state MovingToAssemblyPoint;
	state MovingToSupplyCenter;
	state MovingToObjectForSupply;
	state LoadingAmmo;
	state PuttingAmmo;

	function int Land(){
		if(!IsOnGround()){
			nMoveToX=GetLocationX();
			nMoveToY=GetLocationY();
			nMoveToZ=GetLocationZ();
			if(!IsFreePoint(nMoveToX, nMoveToY, nMoveToZ)){
				if(Rand(2)){
					nMoveToX=nMoveToX+(Rand(nLandCounter)+1);
				}else{
					nMoveToX=nMoveToX-(Rand(nLandCounter)+1);
				}
				if(Rand(2)){
					nMoveToY=nMoveToY+(Rand(nLandCounter)+1);
				}else{
					nMoveToY=nMoveToY-(Rand(nLandCounter)+1);
				}
				++nLandCounter;
				if(IsFreePoint(nMoveToX, nMoveToY, nMoveToZ)){
					CallMoveAndLandToPoint(nMoveToX, nMoveToY, nMoveToZ);
				}else{
					CallMoveLowToPoint(nMoveToX, nMoveToY, nMoveToZ);
				}
			}else{
				CallMoveAndLandToPoint(nMoveToX, nMoveToY, nMoveToZ);
			}
			return true;
		}
		return false;
	}

	state Nothing{
		int bIsEnd;
		if(HaveObjectsForSupply()){
			bIsEnd=false;
			while(!bIsEnd && !CanCurrentObjectBeSupplied()){
				if(!NextObjectForSupply()){
					bIsEnd=true;
				}
			}
			if(!bIsEnd){
				nMoveToX=GetCurrentPutSupplyPositionX();
				nMoveToY=GetCurrentPutSupplyPositionY();
				nMoveToZ=GetCurrentPutSupplyPositionZ();
				CallMoveToPointForce(nMoveToX, nMoveToY, nMoveToZ);
				return MovingToObjectForSupply;
			}
		}
		return Nothing;
	}

	state Moving{
		if(IsMoving()){
			return Moving;
		}
		NextCommand(true);
		return Nothing;
	}

	state Landing{
		if(IsMoving()){
			if((GetLocationX()==nMoveToX) && (GetLocationY()==nMoveToY) && (GetLocationZ()==nMoveToZ) && !IsFreePoint(nMoveToX, nMoveToY, nMoveToZ)){
				if(!Land()){
					NextCommand(true);
					return Nothing;
				}
			}
			return Landing;
		}
		if(!Land()){
			NextCommand(true);
			return Nothing;
		}
		return Landing;
	}

	state MovingToAssemblyPoint{
		if(IsMoving()){
			return MovingToAssemblyPoint;
		}
		return Nothing;
	}

	state MovingToSupplyCenter{
		int nPosX;
		int nPosY;
		int nPosZ;

		nPosX=GetLocationX();
		nPosY=GetLocationY();
		nPosZ=GetLocationZ();
		if(IsMoving()){
			if((nPosX==nMoveToX) && (nPosY==nMoveToY) && (nPosZ==nMoveToZ)){
				CallStopMoving();
			}
			return MovingToSupplyCenter;
		}
		if((nPosX==nMoveToX) && (nPosY==nMoveToY) && (nPosZ==nMoveToZ)){
			CallLoadAmmo();
			return LoadingAmmo;
		}
		CallMoveToPointForce(nMoveToX, nMoveToY, nMoveToZ);//dodane 09.03.2000
		return MovingToSupplyCenter;
	}

	state MovingToObjectForSupply{
		int nPosX;
		int nPosY;
		int nPosZ;
		int bIsEnd;

		if(IsMoving()){
			if(!CanCurrentObjectBeSupplied()){
				CallStopMoving();
				return MovingToObjectForSupply;
			}
			CheckCurrentPutSupplyLocation();
			if(nMoveToX!=GetCurrentPutSupplyPositionX() || nMoveToY!=GetCurrentPutSupplyPositionY()){
				nMoveToX=GetCurrentPutSupplyPositionX();
				nMoveToY=GetCurrentPutSupplyPositionY();
				nMoveToZ=GetCurrentPutSupplyPositionZ();
				CallMoveToPointForce(nMoveToX, nMoveToY, nMoveToZ);
			}

			//XXXMD zrobic gonienie czolgu
			return MovingToObjectForSupply;
		}
		if(IsInGoodCurrentPutSupplyLocation()){
			CallPutAmmo();
			return PuttingAmmo;
		}
		//nie jest w dobrym miejscu
		if(CanCurrentObjectBeSupplied()){
			nMoveToX=GetCurrentPutSupplyPositionX();
			nMoveToY=GetCurrentPutSupplyPositionY();
			nMoveToZ=GetCurrentPutSupplyPositionZ();
			CallMoveToPointForce(nMoveToX, nMoveToY, nMoveToZ);
			return MovingToObjectForSupply;
		}
		//nie mozna do niego dojechac (pod ziemia), lub zabity-biezemy nastepnego
		bIsEnd=false;
		do{
			if(!NextObjectForSupply()){
				bIsEnd=true;
			}
		}
		while(!bIsEnd && !CanCurrentObjectBeSupplied());
		if(!bIsEnd){
			nMoveToX=GetCurrentPutSupplyPositionX();
			nMoveToY=GetCurrentPutSupplyPositionY();
			nMoveToZ=GetCurrentPutSupplyPositionZ();
			CallMoveToPointForce(nMoveToX, nMoveToY, nMoveToZ);
			return MovingToObjectForSupply;
		}
		//nie ma juz obiektow do zaopatrzenia-wracamy do punktu zbiorki
		if(GetSupplyCenterBuilding()!=null){
			nMoveToX=GetSupplyCenterAssemblyPositionX();
			nMoveToY=GetSupplyCenterAssemblyPositionY();
			nMoveToZ=GetSupplyCenterAssemblyPositionZ();
			CallMoveToPoint(nMoveToX, nMoveToY, nMoveToZ);
			return MovingToAssemblyPoint;
		}
		return Nothing;
	}

	state LoadingAmmo{
		int bIsEnd;
		if(IsLoadingAmmo()){
			return LoadingAmmo;
		}
		if(HaveObjectsForSupply()){
			bIsEnd=false;
			while(!bIsEnd && !CanCurrentObjectBeSupplied()){
				if(!NextObjectForSupply()){
					bIsEnd=true;
				}
			}
			if(!bIsEnd){
				nMoveToX=GetCurrentPutSupplyPositionX();
				nMoveToY=GetCurrentPutSupplyPositionY();
				nMoveToZ=GetCurrentPutSupplyPositionZ();
				CallMoveToPointForce(nMoveToX, nMoveToY, nMoveToZ);
				return MovingToObjectForSupply;
			}
			//nie ma obiektow do zaopatrzenia-wracamy do punktu zbiorki
			if(GetSupplyCenterBuilding()!=null){
				nMoveToX=GetSupplyCenterAssemblyPositionX();
				nMoveToY=GetSupplyCenterAssemblyPositionY();
				nMoveToZ=GetSupplyCenterAssemblyPositionZ();
				CallMoveToPoint(nMoveToX, nMoveToY, nMoveToZ);
				return MovingToAssemblyPoint;
			}
			return Nothing;
		}
		//nie ma obiektow do zaopatrzenia-wracamy do punktu zbiorki
		if(GetSupplyCenterBuilding()!=null)
		{
			nMoveToX=GetSupplyCenterAssemblyPositionX();
			nMoveToY=GetSupplyCenterAssemblyPositionY();
			nMoveToZ=GetSupplyCenterAssemblyPositionZ();
			CallMoveToPoint(nMoveToX, nMoveToY, nMoveToZ);
			return MovingToAssemblyPoint;
		}
		return Nothing;
	}

	state PuttingAmmo{
		int bIsEnd;
		if(IsPuttingAmmo()){
			return PuttingAmmo;
		}
		//sprawdzic czy wrzucono amunicje do biezacego obiektu
		if(WasCurrentObjectSupplied()){
			//ok jedziemy do nastepnego
			bIsEnd=false;
			do{
				if(!NextObjectForSupply()){
					bIsEnd=true;
				}
			}
			while(!bIsEnd && !CanCurrentObjectBeSupplied());
			if(!bIsEnd){
				nMoveToX=GetCurrentPutSupplyPositionX();
				nMoveToY=GetCurrentPutSupplyPositionY();
				nMoveToZ=GetCurrentPutSupplyPositionZ();
				CallMoveToPointForce(nMoveToX, nMoveToY, nMoveToZ);
				return MovingToObjectForSupply;
			}
			//nie ma juz obiektow do zaopatrzenia-wracamy do punktu zbiorki
			if(GetSupplyCenterBuilding()!=null){
				nMoveToX=GetSupplyCenterAssemblyPositionX();
				nMoveToY=GetSupplyCenterAssemblyPositionY();
				nMoveToZ=GetSupplyCenterAssemblyPositionZ();
				CallMoveToPoint(nMoveToX, nMoveToY, nMoveToZ);
				return MovingToAssemblyPoint;
			}
			return Nothing;
		}
		//nie wrzucilismy zaopatrzenia do niego bo np. odjechal
		bIsEnd=false;
		while(!bIsEnd && !CanCurrentObjectBeSupplied()){
			if(!NextObjectForSupply()){
				bIsEnd=true;
			}
		}
		if(!bIsEnd){
			nMoveToX=GetCurrentPutSupplyPositionX();
			nMoveToY=GetCurrentPutSupplyPositionY();
			nMoveToZ=GetCurrentPutSupplyPositionZ();
			CallMoveToPointForce(nMoveToX, nMoveToY, nMoveToZ);
			return MovingToObjectForSupply;
		}
		//nie ma obiektow do zaopatrzenia-wracamy do punktu zbiorki
		if(GetSupplyCenterBuilding()!=null){
			nMoveToX=GetSupplyCenterAssemblyPositionX();
			nMoveToY=GetSupplyCenterAssemblyPositionY();
			nMoveToZ=GetSupplyCenterAssemblyPositionZ();
			CallMoveToPoint(nMoveToX, nMoveToY, nMoveToZ);
			return MovingToAssemblyPoint;
		}
		return Nothing;
	}

	state Froozen{
		if(IsFroozen()){
			return Froozen;
		}
		return Nothing;
	}

	event OnFreezeForSupplyOrRepair(int nFreezeTicks){
		CallFreeze(nFreezeTicks);
		state Froozen;
		true;
	}

	event OnKilledSupplyCenterBuilding(){
		unit uNewSupplyCenter;
		if(!GetSupplyCenterBuilding()){ //przeniesc do eventu
			uNewSupplyCenter=FindSupplyCenter();
			if((uNewSupplyCenter!=null) && SetSupplyCenterBuilding(uNewSupplyCenter)){
				//pojechac do jego punktu zbiorki o ile nie rozwozimy zaopatrzenia
				nMoveToX=GetSupplyCenterAssemblyPositionX();
				nMoveToY=GetSupplyCenterAssemblyPositionY();
				nMoveToZ=GetSupplyCenterAssemblyPositionZ();
				CallMoveToPoint(nMoveToX, nMoveToY, nMoveToZ);
				return MovingToAssemblyPoint;
			}
		}
	}

	command Initialize(){
		false;
	}

	command Uninitialize(){
		false;
	}

	command SetTransporterSupplyCenter(unit uSupplyCenter) hidden button "translateCommandSetSupplyCntr"{
		if(GetSupplyCenterBuilding()!=uSupplyCenter){
			if(SetSupplyCenterBuilding(uSupplyCenter)){
				//pojechac do jego punktu zbiorki o ile nie rozwozimy zaopatrzenia
				if(!HaveObjectsForSupply()){
					nMoveToX=GetSupplyCenterAssemblyPositionX();
					nMoveToY=GetSupplyCenterAssemblyPositionY();
					nMoveToZ=GetSupplyCenterAssemblyPositionZ();
					CallMoveToPoint(nMoveToX, nMoveToY, nMoveToZ);
					state MovingToAssemblyPoint;
				}
				NextCommand(true);
			}else{
				NextCommand(false);
			}
		}else{
			if(!HaveObjectsForSupply() && (state!=MovingToSupplyCenter)){
				nMoveToX=GetSupplyCenterAssemblyPositionX();
				nMoveToY=GetSupplyCenterAssemblyPositionY();
				nMoveToZ=GetSupplyCenterAssemblyPositionZ();
				CallMoveToPoint(nMoveToX, nMoveToY, nMoveToZ);
				state MovingToAssemblyPoint;
			}
			NextCommand(true);
		}
		true;
	}

	//komenda wydawana tylko przez budynek supplyCenter
	command MoveToSupplyCenterForLoading(){
		if(!HaveObjectsForSupply() && (state!=LoadingAmmo)){
			nMoveToX=GetSupplyCenterLoadPositionX();
			nMoveToY=GetSupplyCenterLoadPositionY();
			nMoveToZ=GetSupplyCenterLoadPositionZ();
			CallMoveToPointForce(nMoveToX, nMoveToY, nMoveToZ); //dodane 09.03.2000
			state MovingToSupplyCenter;
		}
		//komenda wewnetrzna z budynku wiec nie wolamy NextCommand
		true;
	}

	command Move(int nGx, int nGy, int nLz) hidden button "translateCommandMove" description "translateCommandMoveDescription" hotkey priority 21{
		nMoveToX=nGx;
		nMoveToY=nGy;
		nMoveToZ=nLz;
		CallMoveToPoint(nMoveToX, nMoveToY, nMoveToZ);
		state Moving;
		true;
	}

	command Enter(unit uEntrance) hidden button "translateCommandEnter"{
		nMoveToX=GetEntranceX(uEntrance);
		nMoveToY=GetEntranceY(uEntrance);
		nMoveToZ=GetEntranceZ(uEntrance);
		CallMoveInsideObject(uEntrance);
		state Moving;
		true;
	}

	command Stop() hidden button "translateCommandStop" description "translateCommandStopDescription" hotkey priority 20{
		CallStopMoving();
		state Nothing;
		true;
	}

	command Land() button "translateCommandLand" description "translateCommandLandDescription" hotkey priority 31{
		nLandCounter=1;
		if(Land()){
			state Landing;
		}else{
			NextCommand(true);
		}
	}

	command SetLights(int nMode) button comboLights description "translateCommandStateLightsModeDescription" hotkey priority 204{
		if(nMode==-1){
			comboLights=(comboLights+1) % 3;
		}else{
			comboLights=nMode;
		}
		SetLightsMode(comboLights);
	}

	command SpecialChangeUnitsScript() button "translateCommandChangeScript" description "translateCommandChangeScriptDescription" hotkey priority 254{
		//special command - no implementation
	}
}
