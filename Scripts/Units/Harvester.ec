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

harvester "translateScriptNameHarvester"{
	consts{
		//comboLights
		LIGHTS_AUTO = 0;
		LIGHTS_ON   = 1;
		LIGHTS_OFF  = 2;

		//nState
		STATE_NOTHING                        = 0;
		STATE_MOVING_TO_HARVEST_POINT        = 1;
		STATE_MOVING_TO_DESTINATION_BUILDING = 2;
		STATE_MOVING                         = 3;
	}

	int nMoveToX;
	int nMoveToY;
	int nMoveToZ;

	int bValidHarvest;
	int nHarvestX;
	int nHarvestY;
	int nHarvestZ;

	int bValidDestination;
	int nDestinationX;
	int nDestinationY;
	int nDestinationZ;

	int nState;
	int nLandCounter;

	enum comboLights{
		"translateCommandStateLightsAUTO", //LIGHTS_AUTO
		"translateCommandStateLightsON",   //LIGHTS_ON
		"translateCommandStateLightsOFF",  //LIGHTS_OFF
	multi:
		"translateCommandStateLightsMode"
	}

	state Nothing;
	state StartMoving;
	state Moving;
	state Landing;
	state WaitForMovingToHarvestPoint;
	state MovingToHarvestPoint;
	state MovingToDestinationBuilding;
	state Harvesting;
	state PuttingResource;

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

	function int SetHarvestPoint(int nX, int nY, int nZ){
		nHarvestX=nX;
		nHarvestY=nY;
		nHarvestZ=nZ;
		bValidHarvest=true;
		SetCurrentHarvestPoint(nHarvestX, nHarvestY, nHarvestZ);
	}

	function int FindNewHarvestPoint(){
		if(FindResource()){
			if(Distance(nHarvestX, nHarvestY, GetFoundResourceX(), GetFoundResourceY())>12 && Distance(nDestinationX, nDestinationY, GetFoundResourceX(), GetFoundResourceY())>10){
				return false;
			}
			SetHarvestPoint(GetFoundResourceX(), GetFoundResourceY(), GetFoundResourceZ());
			return true;
		}
		return false;
	}

	state Nothing{
		return Nothing;
	}

	state StartMoving{
		return Moving;
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
			if((GetLocationX()==nMoveToX) && (GetLocationY()==nMoveToY) && (GetLocationZ()==nMoveToZ) &&  !IsFreePoint(nMoveToX, nMoveToY, nMoveToZ)){
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

	state WaitForMovingToHarvestPoint{
		if(IsHarvesting()){
			return WaitForMovingToHarvestPoint;
		}
		//tak dla pewnosci wywolujemy jeszcze raz Call...
		CallMoveAndLandToPoint(nHarvestX, nHarvestY, nHarvestZ);
		return MovingToHarvestPoint, 40;
	}

	state MovingToHarvestPoint{
		int nPosX;
		int nPosY;
		int nPosZ;

		if(IsMoving()){
			return MovingToHarvestPoint;
		}
		nPosX=GetLocationX();
		nPosY=GetLocationY();
		nPosZ=GetLocationZ();
		if(bValidHarvest && (nPosX==nHarvestX) && (nPosY==nHarvestY) && (nPosZ==nHarvestZ)){
			if(IsResourceInPoint(nPosX, nPosY, nPosZ)){
				CallHarvest();
				return Harvesting;
			}
			if(FindNewHarvestPoint()){
				CallMoveAndLandToPoint(nHarvestX, nHarvestY, nHarvestZ);
				return MovingToHarvestPoint;
			}
			return Nothing;
		}
		if(IsResourceInPoint(nPosX, nPosY, nPosZ) && (!bValidDestination || (nPosX != nDestinationX) || (nPosY != nDestinationY) || (nPosZ != nDestinationZ))){
			SetHarvestPoint(nPosX, nPosY, nPosZ);
			CallHarvest();
			return Harvesting;
		}
		if(FindNewHarvestPoint()){
			CallMoveAndLandToPoint(nHarvestX, nHarvestY, nHarvestZ);
			return MovingToHarvestPoint;
		}
		return MovingToHarvestPoint, 101;
	}

	state MovingToDestinationBuilding{
		int nPosX;
		int nPosY;
		int nPosZ;
		if(IsMoving()){
			return MovingToDestinationBuilding;
		}
		nPosX=GetLocationX();
		nPosY=GetLocationY();
		nPosZ=GetLocationZ();
		if(bValidDestination && (nPosX==nDestinationX) && (nPosY==nDestinationY) && (nPosZ==nDestinationZ)){
			CallPutResource();
			return PuttingResource;
		}
		if(bValidDestination){
			CallMoveToPointForce(nDestinationX, nDestinationY, nDestinationZ);
			return MovingToDestinationBuilding, 41;
		}
		return Nothing;
	}

	state Harvesting{
		unit uBuilding;
		if(IsHarvesting()){
			return Harvesting;
		}
		//skonczyl-jedziemy do budynku
		if(HaveFullResources()){
			if(bValidDestination && (GetHarvesterBuilding()!=null)){
				CallMoveToPointForce(nDestinationX, nDestinationY, nDestinationZ);
				return MovingToDestinationBuilding;
			}
			//!!znalezc inny budynek
			uBuilding=FindHarvesterRefineryBuilding();
			if(uBuilding){
				SetHarvesterBuilding(uBuilding);
				nDestinationX=GetHarvesterBuildingPutLocationX();
				nDestinationY=GetHarvesterBuildingPutLocationY();
				nDestinationZ=GetHarvesterBuildingPutLocationZ();
				bValidDestination=true;
				CallMoveToPointForce(nDestinationX, nDestinationY, nDestinationZ);
				return MovingToDestinationBuilding;
			}
			return Nothing;
		}
		if(FindNewHarvestPoint()){
			CallMoveAndLandToPoint(nHarvestX, nHarvestY, nHarvestZ);
			return MovingToHarvestPoint;
		}
		if(HaveSomeResources()){
			if(bValidDestination && (GetHarvesterBuilding()!=null)){
				CallMoveToPointForce(nDestinationX, nDestinationY, nDestinationZ);
				return MovingToDestinationBuilding;
			}
			uBuilding=FindHarvesterRefineryBuilding();
			if(uBuilding){
				SetHarvesterBuilding(uBuilding);
				nDestinationX=GetHarvesterBuildingPutLocationX();
				nDestinationY=GetHarvesterBuildingPutLocationY();
				nDestinationZ=GetHarvesterBuildingPutLocationZ();
				bValidDestination=true;
				CallMoveToPointForce(nDestinationX, nDestinationY, nDestinationZ);
				return MovingToDestinationBuilding;
			}
		}
		return Nothing;
	}

	state PuttingResource{
		unit uBuilding;
		if(IsPuttingResource()){
			return PuttingResource;
		}
		if(HaveSomeResources()){
			if(bValidDestination && (GetHarvesterBuilding()!=null)){
				CallMoveToPointForce(nDestinationX, nDestinationY, nDestinationZ);
				return MovingToDestinationBuilding;
			}
			uBuilding=FindHarvesterRefineryBuilding();
			if(uBuilding!=null){
				SetHarvesterBuilding(uBuilding);
				nDestinationX=GetHarvesterBuildingPutLocationX();
				nDestinationY=GetHarvesterBuildingPutLocationY();
				nDestinationZ=GetHarvesterBuildingPutLocationZ();
				bValidDestination=true;
				CallMoveToPointForce(nDestinationX, nDestinationY, nDestinationZ);
				return MovingToDestinationBuilding;
			}
		}
		if(bValidHarvest){
			CallMoveAndLandToPoint(nHarvestX, nHarvestY, nHarvestZ);
			return MovingToHarvestPoint;
		}
		if(FindNewHarvestPoint()){
			CallMoveAndLandToPoint(nHarvestX, nHarvestY, nHarvestZ);
			return MovingToHarvestPoint;
		}
		return Nothing;
	}

	state Froozen{
		if(IsFroozen()){
			return Froozen;
		}
		if(nState==STATE_MOVING_TO_HARVEST_POINT){
			CallMoveAndLandToPoint(nHarvestX, nHarvestY, nHarvestZ);
			return MovingToHarvestPoint;
		}
		if(nState==STATE_MOVING_TO_DESTINATION_BUILDING){
			CallMoveToPointForce(nDestinationX, nDestinationY, nDestinationZ);
			return MovingToDestinationBuilding;
		}
		if(nState==STATE_MOVING){
			CallMoveToPoint(nMoveToX, nMoveToY, nMoveToZ);
			return StartMoving;
		}
		return Nothing;
	}

	event OnFreezeForSupplyOrRepair(int nFreezeTicks){
		if(state!=WaitForMovingToHarvestPoint && state!=PuttingResource && state!=Harvesting){
			if(state==MovingToHarvestPoint){
				nState=STATE_MOVING_TO_HARVEST_POINT;
			}else if(state==MovingToDestinationBuilding){
				nState=STATE_MOVING_TO_DESTINATION_BUILDING;
			}else if(state==Moving){
				nState=STATE_MOVING;
			}else{
				nState=STATE_NOTHING;
			}
			CallFreeze(nFreezeTicks);
			state Froozen;
		}
		true;
	}

	command Initialize(){
		bValidHarvest=false;
		bValidDestination=false;
		false;
	}

	command Uninitialize(){
		bValidHarvest=false;
		bValidDestination=false;
		InvalidateCurrentHarvestPoint();
		SetHarvesterBuilding(null);
		false;
	}

	command SetHarvestPoint(int nX, int nY, int nZ) hidden button "translateCommandHarvest"{
		SetHarvestPoint(nX, nY, nZ);
		if(!HaveFullResources()){
			CallMoveAndLandToPoint(nHarvestX, nHarvestY, nHarvestZ);
			if(IsHarvesting()){
				state WaitForMovingToHarvestPoint;
			}else{
				state MovingToHarvestPoint;
			}
		}else{
			if(bValidDestination && (GetHarvesterBuilding()!=null)){
				CallMoveToPointForce(nDestinationX, nDestinationY, nDestinationZ);
				state MovingToDestinationBuilding;
			}
		}
		NextCommand(true);
		true;
	}

	command SetContainerDestination(unit uObject) hidden button "translateCommandSetRefinery"{
		SetHarvesterBuilding(uObject);
		nDestinationX=GetHarvesterBuildingPutLocationX();
		nDestinationY=GetHarvesterBuildingPutLocationY();
		nDestinationZ=GetHarvesterBuildingPutLocationZ();
		bValidDestination=true;
		NextCommand(true);
		true;
	}

	command Move(int nGx, int nGy, int nLz) hidden button "translateCommandMove" description "translateCommandMoveDescription" hotkey priority 21{
		nMoveToX=nGx;
		nMoveToY=nGy;
		nMoveToZ=nLz;
		CallMoveToPoint(nMoveToX, nMoveToY, nMoveToZ);
		state StartMoving;
		true;
	}

	command Enter(unit uEntrance) hidden button "translateCommandEnter"{
		nMoveToX=GetEntranceX(uEntrance);
		nMoveToY=GetEntranceY(uEntrance);
		nMoveToZ=GetEntranceZ(uEntrance);
		CallMoveInsideObject(uEntrance);
		state StartMoving;
		true;
	}

	command Stop() button "translateCommandStop" description "translateCommandStopDescription" hotkey priority 20{
		CallStopMoving();
		state StartMoving;
		true;
	}

   command Land() button "translateCommandLand" description "translateCommandLandDescription" hotkey priority 31{
		if(state==Harvesting || state==PuttingResource){
			return;
		}
		nLandCounter=1;
		if(Land()){
			state Landing;
		}else{
			NextCommand(true);
		}
	}

	command SetLights(int nMode) button comboLights description "translateCommandStateLightsModeDescription" hotkey priority 204{
		if(nMode==-1){
			comboLights=(comboLights+1)%3;
		}else{
			comboLights=nMode;
		}
		SetLightsMode(comboLights);
	}

	command SpecialChangeUnitsScript() button "translateCommandChangeScript" description "translateCommandChangeScriptDescription" hotkey priority 254{
		//special command, no implementation
	}
}
