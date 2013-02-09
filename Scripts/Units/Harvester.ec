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
		STATE_NOTHING = 0;
		STATE_MOVING  = 1;

		//nMovingReason
		MOVING_ONLY                    = 0;
		MOVING_TO_HARVEST_POINT        = 1;
		MOVING_TO_DESTINATION_BUILDING = 2;
		MOVING_TO_LAND                 = 3;
		MOVING_TO_STOP                 = 4;
		MOVING_TO_ENTRANCE             = 5;
	}

	int bValidHarvestPoint;
	int nHarvestPointX;
	int nHarvestPointY;
	int nHarvestPointZ;

	unit uDestination; //destination building or entrance
	int nDestinationX;
	int nDestinationY;
	int nDestinationZ;

	int nState;
	int nMovingReason;

	enum comboLights{
		"translateCommandStateLightsAUTO", //LIGHTS_AUTO
		"translateCommandStateLightsON",   //LIGHTS_ON
		"translateCommandStateLightsOFF",  //LIGHTS_OFF
	multi:
		"translateCommandStateLightsMode"
	}

	state Nothing;
	state Moving;
	state MovingClose;
	state Harvesting;
	state PuttingResource;

	function int IsAt(int nX, int nY, int nZ){
		if(GetLocationX()==nX && GetLocationY()==nY && GetLocationZ()==nZ){
			return true;
		}
		return false;
	}

	function int SetHarvestPoint(int nX, int nY, int nZ){
		nHarvestPointX=nX;
		nHarvestPointY=nY;
		nHarvestPointZ=nZ;
		bValidHarvestPoint=true;
		SetCurrentHarvestPoint(nHarvestPointX, nHarvestPointY, nHarvestPointZ);
	}

	function int FindOrSetNewHarvestPoint(){
		int nNewHarvestPointX;
		int nNewHarvestPointY;
		int nNewHarvestPointZ;
		if(IsFreePoint(nHarvestPointX, nHarvestPointY, nHarvestPointZ)){
			return true;
		}
		nNewHarvestPointX=GetLocationX();
		nNewHarvestPointY=GetLocationY();
		if(DistanceTo(nHarvestPointX, nHarvestPointY)<2){
			nNewHarvestPointZ=GetLocationZ();
			if(IsResourceInPoint(nNewHarvestPointX, nNewHarvestPointY, nNewHarvestPointZ)){
				SetHarvestPoint(nNewHarvestPointX, nNewHarvestPointY, nNewHarvestPointZ);
				return true;
			}
		}
		if(FindResource()){
			nNewHarvestPointX=GetFoundResourceX();
			nNewHarvestPointY=GetFoundResourceY();
			if(Distance(nHarvestPointX, nHarvestPointY, nNewHarvestPointX, nNewHarvestPointY)>4){
				return false;
			}
			SetHarvestPoint(nNewHarvestPointX, nNewHarvestPointY, GetFoundResourceZ());
			return true;
		}
		return false;
	}

	function int SetDestination(unit uNewDestination){
		if(SetHarvesterBuilding(uNewDestination)){
			uDestination=uNewDestination;
			nDestinationX=GetHarvesterBuildingPutLocationX();
			nDestinationY=GetHarvesterBuildingPutLocationY();
			nDestinationZ=GetHarvesterBuildingPutLocationZ();
			return true;
		}
		uDestination=null;
		return false;
	}

	function int StartNothing(){
TraceD("StartNothing\n");
		if(comboLights==LIGHTS_AUTO){
			SetLightsMode(LIGHTS_OFF);
		}
	}

	function int StartMoving(int nNewMovingReason){
TraceD("StartMoving(");
TraceD(nNewMovingReason);
TraceD(")\n");
		nMovingReason=nNewMovingReason;
		if(nMovingReason==MOVING_TO_HARVEST_POINT){
			if(!bValidHarvestPoint){
				return false;
			}
			if(IsHarvesting() && IsAt(nHarvestPointX, nHarvestPointY, nHarvestPointZ)){
				return false;
			}
			CallMoveAndLandToPoint(nHarvestPointX, nHarvestPointY, nHarvestPointZ);
		}else if(nMovingReason==MOVING_TO_DESTINATION_BUILDING){
			if(GetHarvesterBuilding()==null){
				if(!SetDestination(FindHarvesterRefineryBuilding())){
					return false;
				}
			}
			if(IsPuttingResource() && IsAt(nDestinationX, nDestinationY, nDestinationZ)){
				return false;
			}
			CallMoveToPointForce(nDestinationX, nDestinationY, nDestinationZ);
		}else if(nMovingReason==MOVING_TO_LAND){
			if(IsOnGround()){
				return false;
			}
			CallMoveAndLandToPoint(nDestinationX, nDestinationY, nDestinationZ);
		}else if(nMovingReason==MOVING_ONLY){
			if(!IsMoving() && IsAt(nDestinationX, nDestinationY, nDestinationZ)){
				return false;
			}
			CallMoveToPoint(nDestinationX, nDestinationY, nDestinationZ);
		}else if(nMovingReason==MOVING_TO_STOP){
			if(!IsMoving()){
				return false;
			}
			CallStopMoving();
		}else if(nMovingReason==MOVING_TO_ENTRANCE){
			CallMoveInsideObject(uDestination);
		}
		if(comboLights==LIGHTS_AUTO){
			SetLightsMode(LIGHTS_AUTO);
		}
		return true;
	}

	function int StartMovingToHarvestPoint(int nX, int nY, int nZ){
TraceD("StartMovingToHarvestPoint\n");
		SetHarvestPoint(nX, nY, nZ);
		SetDestination(GetHarvesterBuilding()); //TODO: optimize
		if(HaveFullResources()){
			return StartMoving(MOVING_TO_DESTINATION_BUILDING);
		}
		if(!IsPuttingResource()){
			return StartMoving(MOVING_TO_HARVEST_POINT);
		}
		return false;
	}

	function int StartMovingToDestinationBuilding(unit uDestination){
TraceD("StartMovingToDestinationBuilding\n");
		SetDestination(uDestination);
		if(!HaveSomeResources()){
			return false;
		}
		return StartMoving(MOVING_TO_DESTINATION_BUILDING);
	}

	function int StartMovingToPoint(int nX, int nY, int nZ){
TraceD("StartMovingToPoint\n");
		nDestinationX=nX;
		nDestinationY=nY;
		nDestinationZ=nZ;
		return StartMoving(MOVING_ONLY);
	}

	function int StartMovingToEntrance(unit uEntrance){
		uDestination=uEntrance;
		nDestinationX=GetEntranceX(uEntrance);
		nDestinationY=GetEntranceY(uEntrance);
		nDestinationZ=GetEntranceZ(uEntrance);
		return StartMoving(MOVING_TO_ENTRANCE);
	}

	function int StartMovingToStop(){
		bValidHarvestPoint=false;
		InvalidateCurrentHarvestPoint();
		SetDestination(null);
		return StartMoving(MOVING_TO_STOP);
	}

	function int StartMovingToLand(){
		if(IsHarvesting() || IsPuttingResource()){
			return false;
		}
		nDestinationX=GetMoveLocationX();
		nDestinationY=GetMoveLocationY();
		nDestinationZ=GetMoveLocationZ();
		return StartMoving(MOVING_TO_LAND);
	}

	state Nothing{
TraceD("Nothing\n");
		return Nothing;
	}

	state Moving{
TraceD("Moving\n");
		if(IsHarvesting() || IsPuttingResource()){
			return Moving;
		}
		if(IsMoving()){
			if(nMovingReason==MOVING_TO_HARVEST_POINT){
				if(DistanceTo(nHarvestPointX, nHarvestPointY)>4){
					return Moving;
				}
			}else{ //nMovingReason==MOVING_TO_DESTINATION_BUILDING|MOVING_ONLY
				if(DistanceTo(nDestinationX, nDestinationY)>4){
					return Moving;
				}
			}
		}
		return MovingClose, 1;
	}

	state MovingClose{
TraceD("MovingClose\n");
		if(IsMoving()){
			if(nMovingReason==MOVING_TO_LAND){
				if(IsFreePoint(nDestinationX, nDestinationY, nDestinationZ)){
					return MovingClose, 1;
				}
			}else{
				return MovingClose, 1;
			}
		}
		if(nMovingReason==MOVING_TO_HARVEST_POINT){
			if(IsAt(nHarvestPointX, nHarvestPointY, nHarvestPointZ) && IsResourceInPoint(nHarvestPointX, nHarvestPointY, nHarvestPointZ) && IsOnGround()){
				CallHarvest();
				return Harvesting;
			}
			if(FindOrSetNewHarvestPoint()){
				if(StartMoving(MOVING_TO_HARVEST_POINT)){
					return Moving;
				}
			}
		}else if(nMovingReason==MOVING_TO_DESTINATION_BUILDING){
			if(IsAt(nDestinationX, nDestinationY, nDestinationZ)){
				CallPutResource();
				return PuttingResource;
			}
			if(StartMoving(MOVING_TO_DESTINATION_BUILDING)){
				return Moving;
			}
		}else if(nMovingReason==MOVING_TO_LAND){
			if(!IsAt(nDestinationX, nDestinationY, nDestinationZ) || !IsOnGround()){
				while(!IsFreePoint(nDestinationX, nDestinationY, nDestinationZ)){
					nDestinationX=nDestinationX+Rand(5)-2;
					nDestinationY=nDestinationY+Rand(5)-2;
				}
				if(StartMoving(MOVING_TO_LAND)){
					return Moving;
				}
			}
		}
TraceD("MovingClose NextCommand()\n");
		NextCommand(true);
		StartNothing();
		return Nothing;
	}

	state Harvesting{
TraceD("Harvesting\n");
		if(IsHarvesting()){
			return Harvesting;
		}
		if(HaveFullResources()){
			if(StartMoving(MOVING_TO_DESTINATION_BUILDING)){
				return Moving;
			}
		}else if(FindOrSetNewHarvestPoint()){
			if(StartMoving(MOVING_TO_HARVEST_POINT)){
				return Moving;
			}
		}else if(HaveSomeResources()){
			if(StartMoving(MOVING_TO_DESTINATION_BUILDING)){
				return Moving;
			}
		}
		NextCommand(true);
		StartNothing();
		return Nothing;
	}

	state PuttingResource{
TraceD("PuttingResource\n");
		if(IsPuttingResource()){
			return PuttingResource;
		}
		if(HaveSomeResources()){
			if(SetDestination(FindHarvesterRefineryBuilding())){
				if(StartMoving(MOVING_TO_DESTINATION_BUILDING)){
					return Moving;
				}
			}
		}else if(bValidHarvestPoint){
			if(StartMoving(MOVING_TO_HARVEST_POINT)){
				return Moving;
			}
		}else if(FindOrSetNewHarvestPoint()){
			if(StartMoving(MOVING_TO_HARVEST_POINT)){
				return Moving;
			}
		}
		NextCommand(true);
		StartNothing();
		return Nothing;
	}

	state Froozen{
TraceD("Froozen\n");
		if(IsFroozen()){
			return Froozen;
		}
		if(nState==STATE_MOVING){
			if(StartMoving(nMovingReason)){
				return Moving;
			}
		}
		StartNothing();
		return Nothing;
	}

	event OnFreezeForSupplyOrRepair(int nFreezeTicks){
TraceD("OnFreezeForSupplyOrRepair\n");
		if(state==Moving || state==MovingClose){
			nState=STATE_MOVING;
			CallFreeze(nFreezeTicks);
			state Froozen;
			true;
		}else if(state==Nothing){
			nState=STATE_NOTHING;
			CallFreeze(nFreezeTicks);
			state Froozen;
			true;
		}
		false;
	}

	command Initialize(){
TraceD("Initialize\n");
		StartNothing();
	}

	command Uninitialize(){
TraceD("Uninitialize\n");
		InvalidateCurrentHarvestPoint();
		SetHarvesterBuilding(null);
		uDestination=null;
	}

	command SetHarvestPoint(int nX, int nY, int nZ) hidden button "translateCommandHarvest"{
TraceD("SetHarvestPoint\n");
		if(StartMovingToHarvestPoint(nX, nY, nZ)){
			state Moving;
		}
TraceD("SetHarvestPoint NextCommand()\n");
		NextCommand(true);
		true;
	}

	command SetContainerDestination(unit uDestination) hidden button "translateCommandSetRefinery"{
TraceD("SetContainerDestination\n");
		if(StartMovingToDestinationBuilding(uDestination)){
			state Moving;
		}
TraceD("SetContainerDestination NextCommand()\n");
		NextCommand(true);
		true;
	}

	command Move(int nX, int nY, int nZ) hidden button "translateCommandMove" description "translateCommandMoveDescription" hotkey priority 21{
TraceD("Move\n");
		if(StartMovingToPoint(nX, nY, nZ)){
			state Moving;
		}
		true;
	}

	command Enter(unit uEntrance) hidden button "translateCommandEnter"{
TraceD("Enter\n");
		if(StartMovingToEntrance(uEntrance)){
			state Moving;
		}
		true;
	}

	command Stop() button "translateCommandStop" description "translateCommandStopDescription" hotkey priority 20{
TraceD("Stop\n");
		if(StartMovingToStop()){
			state Moving;
		}
		true;
	}

   command Land() button "translateCommandLand" description "translateCommandLandDescription" hotkey priority 31{
TraceD("Land\n");
		if(StartMovingToLand()){
			state Moving;
		}
		true;
	}

	command SetLights(int nMode) button comboLights description "translateCommandStateLightsModeDescription" hotkey priority 204{
TraceD("SetLights\n");
		if(nMode==-1){
			comboLights=(comboLights+1)%3;
		}else{
			comboLights=nMode;
		}
		if(comboLights==LIGHTS_AUTO){
			if(IsMoving()){
				SetLightsMode(LIGHTS_AUTO);
			}else{
				SetLightsMode(LIGHTS_OFF);
			}
		}else{
			SetLightsMode(comboLights);
		}
	}

	command SpecialChangeUnitsScript() button "translateCommandChangeScript" description "translateCommandChangeScriptDescription" hotkey priority 254{
		//special command, no implementation
	}
}
