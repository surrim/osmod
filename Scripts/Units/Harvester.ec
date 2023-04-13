/* Copyright 2009-2023 surrim
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

		//other
		SQRT_1 = 29;
		SQRT_2 = 41;
	}

	int bHarvestPointWasSet;
	int nHarvestPointX;
	int nHarvestPointY;

	unit uEntrance;
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

	function int BetterDistance(int nX1, int nY1, int nX2, int nY2){
		int xDiff;
		int yDiff;
		if(nX1<nX2){
			xDiff=nX2-nX1;
		}else{
			xDiff=nX1-nX2;
		}
		if(nY1<nY2){
			yDiff=nY2-nY1;
		}else{
			yDiff=nY1-nY2;
		}
		if(xDiff<yDiff){
			return xDiff*SQRT_2+(yDiff-xDiff)*SQRT_1;
		}
		return yDiff*SQRT_2+(xDiff-yDiff)*SQRT_1;
	}

	function int SetNewHarvestPoint(){
		int nNewHarvestPointX;
		int nNewHarvestPointY;

		int nBestHarvestPointX;
		int nBestHarvestPointY;

		int nLocationX;
		int nLocationY;

		int nBestDistance;
		int nNewBestDistance;
//TraceD("SetNewHarvestPoint()\n");

		if(bHarvestPointWasSet){
			nLocationX=GetLocationX();
			nLocationY=GetLocationY();
			nBestHarvestPointX=nHarvestPointX;
			nBestHarvestPointY=nHarvestPointY;
			nBestDistance=2000000000;
			for(nNewHarvestPointX=nHarvestPointX-3;nNewHarvestPointX<=nHarvestPointX+3;++nNewHarvestPointX){
				for(nNewHarvestPointY=nHarvestPointY-3;nNewHarvestPointY<=nHarvestPointY+3;++nNewHarvestPointY){
					if(
							IsResourceInPoint(nNewHarvestPointX, nNewHarvestPointY, 0)
							&&
							(
								IsFreePoint(nNewHarvestPointX, nNewHarvestPointY, 0)
								||
								(
									IsAt(nNewHarvestPointX, nNewHarvestPointY, 0)
									&&
									IsOnGround()
								)
							)
					){
						nNewBestDistance=16*BetterDistance(nHarvestPointX, nHarvestPointY, nNewHarvestPointX, nNewHarvestPointY)+BetterDistance(nLocationX, nLocationY, nNewHarvestPointX, nNewHarvestPointY);
						if(nNewBestDistance<nBestDistance){
							nBestHarvestPointX=nNewHarvestPointX;
							nBestHarvestPointY=nNewHarvestPointY;
							nBestDistance=nNewBestDistance;
						}
					}
				}
			}
			if(nBestDistance!=2000000000){
				nHarvestPointX=nBestHarvestPointX;
				nHarvestPointY=nBestHarvestPointY;
				SetCurrentHarvestPoint(nHarvestPointX, nHarvestPointY, 0);
			}
		}
	}

	function int SwitchLightsOff(){
//TraceD("SwitchLightsOff()\n");
		if(comboLights==LIGHTS_AUTO){
			SetLightsMode(LIGHTS_OFF);
		}
	}

	function int SwitchLightsOn(int nNewMovingReason){
//TraceD("SwitchLightsOn(");
//TraceD(nNewMovingReason);
//TraceD(")\n");
		nMovingReason=nNewMovingReason;
		if(nMovingReason==MOVING_ONLY){
			if(!IsMoving() && IsAt(nDestinationX, nDestinationY, nDestinationZ)){
				return false;
			}
//TraceD("CallMoveToPoint(");
//TraceD(nDestinationX);
//TraceD(", ");
//TraceD(nDestinationY);
//TraceD(", ");
//TraceD(nDestinationZ);
//TraceD(")\n");
			CallMoveToPoint(nDestinationX, nDestinationY, nDestinationZ);
		}else if(nMovingReason==MOVING_TO_HARVEST_POINT){
			if(HaveFullResources()){
				return SwitchLightsOn(MOVING_TO_DESTINATION_BUILDING);
			}
			if(
					!bHarvestPointWasSet
					||
					(state==Harvesting && IsAt(nHarvestPointX, nHarvestPointY, 0))
			){
				return false;
			}
			SetNewHarvestPoint();
//TraceD("CallMoveToPoint(");
//TraceD(nHarvestPointX);
//TraceD(", ");
//TraceD(nHarvestPointY);
//TraceD(", ");
//TraceD(0);
//TraceD(")\n");
			CallMoveToPoint(nHarvestPointX, nHarvestPointY, 0);
		}else if(nMovingReason==MOVING_TO_DESTINATION_BUILDING){
			if(!HaveSomeResources()){
				if(bHarvestPointWasSet){
					return SwitchLightsOn(MOVING_TO_HARVEST_POINT);
				}
				return false;
			}
			if(state==PuttingResource && IsAt(nDestinationX, nDestinationY, nDestinationZ)){
				return false;
			}
			if(GetHarvesterBuilding()==null){
				if(SetHarvesterBuilding(FindHarvesterRefineryBuilding())){
					nDestinationX=GetHarvesterBuildingPutLocationX();
					nDestinationY=GetHarvesterBuildingPutLocationY();
					nDestinationZ=GetHarvesterBuildingPutLocationZ();
				}else{
					return false;
				}
			}
//TraceD("CallMoveToPointForce(");
//TraceD(nDestinationX);
//TraceD(", ");
//TraceD(nDestinationY);
//TraceD(", ");
//TraceD(nDestinationZ);
//TraceD(")\n");
			CallMoveToPointForce(nDestinationX, nDestinationY, nDestinationZ);
		}else if(nMovingReason==MOVING_TO_LAND){
			if(IsOnGround()){
				return false;
			}
//TraceD("CallMoveToPoint(");
//TraceD(nDestinationX);
//TraceD(", ");
//TraceD(nDestinationY);
//TraceD(", ");
//TraceD(nDestinationZ);
//TraceD(")\n");
			CallMoveToPoint(nDestinationX, nDestinationY, nDestinationZ);
		}else if(nMovingReason==MOVING_TO_STOP){
			if(!IsMoving()){
				return false;
			}
//TraceD("CallStopMoving()\n");
			CallStopMoving();
		}else if(nMovingReason==MOVING_TO_ENTRANCE){
//TraceD("CallMoveInsideObject(@{");
//TraceD(uEntrance.GetLocationX());
//TraceD(", ");
//TraceD(uEntrance.GetLocationY());
//TraceD("})\n");
			CallMoveInsideObject(uEntrance);
		}
		if(comboLights==LIGHTS_AUTO){
			SetLightsMode(LIGHTS_AUTO);
		}
		return true;
	}

	state Nothing{
//TraceD("Nothing\n");
		return Nothing;
	}

	state Moving{
//TraceD("Moving\n");
		if(IsHarvesting() || IsPuttingResource()){
			return Moving;
		}
		if(IsMoving()){
			if(nMovingReason==MOVING_TO_HARVEST_POINT){
				if(DistanceTo(nHarvestPointX, nHarvestPointY)>4){
					return Moving;
				}
			}else{
				if(DistanceTo(nDestinationX, nDestinationY)>4){
					return Moving;
				}
			}
		}
		return MovingClose, 1;
	}

	state MovingClose{
//TraceD("MovingClose\n");
		if(IsMoving()){
			if(
					IsOnGround()
					||
					!IsAt(nHarvestPointX, nHarvestPointY, 0)
					||
					IsFreePoint(nHarvestPointX, nHarvestPointY, 0)
			){
				return MovingClose, 1;
			}
		}
		if(nMovingReason==MOVING_TO_HARVEST_POINT){
			if(
					IsAt(nHarvestPointX, nHarvestPointY, 0)
					&&
					IsResourceInPoint(nHarvestPointX, nHarvestPointY, 0)
			){
				if(IsOnGround()){
//TraceD("CallHarvest()\n");
					CallHarvest();
					SwitchLightsOff();
					return Harvesting;
				}
				if(IsFreePoint(nHarvestPointX, nHarvestPointY, 0)){
//TraceD("CallLand()\n");
					CallLand();
					return MovingClose, 1;
				}
			}
			if(bHarvestPointWasSet){
				SetNewHarvestPoint();
				if(SwitchLightsOn(MOVING_TO_HARVEST_POINT)){
					return Moving;
				}
			}
		}else if(nMovingReason==MOVING_TO_DESTINATION_BUILDING){
			if(IsAt(nDestinationX, nDestinationY, nDestinationZ)){
//TraceD("CallPutResource()\n");
				CallPutResource();
				return PuttingResource;
			}
			if(SwitchLightsOn(MOVING_TO_DESTINATION_BUILDING)){
				return Moving;
			}
		}else if(nMovingReason==MOVING_TO_LAND){
			if(IsAt(nDestinationX, nDestinationY, nDestinationZ)){
				if(!IsOnGround()){
					if(IsFreePoint(nDestinationX, nDestinationY, nDestinationZ)){
//TraceD("CallLand()\n");
						CallLand();
						return MovingClose, 1;
					}
					while(!IsFreePoint(nDestinationX, nDestinationY, nDestinationZ)){
						nDestinationX=nDestinationX+Rand(5)-2;
						nDestinationY=nDestinationY+Rand(5)-2;
					}
					if(SwitchLightsOn(MOVING_TO_LAND)){
						return Moving;
					}
				}
			}
		}
//TraceD("MovingClose NextCommand()\n");
		NextCommand(true);
		SwitchLightsOff();
		return Nothing;
	}

	state Harvesting{
//TraceD("Harvesting\n");
		if(IsHarvesting()){
			return Harvesting;
		}
		if(HaveFullResources()){
			if(SwitchLightsOn(MOVING_TO_DESTINATION_BUILDING)){
				return Moving;
			}
		}else if(SwitchLightsOn(MOVING_TO_HARVEST_POINT)){
			return Moving;
		}else if(HaveSomeResources()){
			if(SwitchLightsOn(MOVING_TO_DESTINATION_BUILDING)){
				return Moving;
			}
		}
//TraceD("Harvesting NextCommand\n");
		NextCommand(true);
		SwitchLightsOff();
		return Nothing;
	}

	state PuttingResource{
//TraceD("PuttingResource\n");
		if(IsPuttingResource()){
			return PuttingResource;
		}
		if(
				(HaveSomeResources() && SwitchLightsOn(MOVING_TO_DESTINATION_BUILDING))
				||
				(bHarvestPointWasSet && SwitchLightsOn(MOVING_TO_HARVEST_POINT))
		){
			return Moving;
		}
		if(Rand(2)){
			if(Rand(2)){
				nDestinationX=nDestinationX+3;
			}else{
				nDestinationX=nDestinationX-3;
			}
			nDestinationY=nDestinationY+Rand(6)-3;
		}else{
			if(Rand(2)){
				nDestinationY=nDestinationY+3;
			}else{
				nDestinationY=nDestinationY-3;
			}
			nDestinationX=nDestinationX+Rand(6)-3;
		}
		if(SwitchLightsOn(MOVING_ONLY)){
			return Moving;
		}
//TraceD("PuttingResource NextCommand\n");
		NextCommand(true);
		SwitchLightsOff();
		return Nothing;
	}

	state Froozen{
//TraceD("Froozen\n");
		if(IsFroozen()){
			return Froozen;
		}
		if(nState==STATE_MOVING && SwitchLightsOn(nMovingReason)){
			return Moving;
		}
		SwitchLightsOff();
		return Nothing;
	}

	event OnFreezeForSupplyOrRepair(int nFreezeTicks){
//TraceD("OnFreezeForSupplyOrRepair(");
//TraceD(nFreezeTicks);
//TraceD(")\n");
		if(state==Nothing){
			nState=STATE_NOTHING;
//TraceD("CallFreeze(");
//TraceD(nFreezeTicks);
//TraceD(")\n");
			CallFreeze(nFreezeTicks);
			state Froozen;
			true;
		}else if(state==Moving || state==MovingClose){
			nState=STATE_MOVING;
//TraceD("CallFreeze(");
//TraceD(nFreezeTicks);
//TraceD(")\n");
			CallFreeze(nFreezeTicks);
			state Froozen;
			true;
		}
		false;
	}

	command Initialize(){
//TraceD("Initialize()\n");
		SwitchLightsOff();
	}

	command Uninitialize(){
//TraceD("Uninitialize()\n");
		InvalidateCurrentHarvestPoint();
		SetHarvesterBuilding(null);
		uEntrance=null;
	}

	command SetHarvestPoint(int nX, int nY, int nZ) hidden button "translateCommandHarvest"{
//TraceD("SetHarvestPoint(");
//TraceD(nX);
//TraceD(", ");
//TraceD(nY);
//TraceD(", ");
//TraceD(nZ);
//TraceD(")\n");
		nHarvestPointX=nX;
		nHarvestPointY=nY;
		bHarvestPointWasSet=true;
		SetNewHarvestPoint();
		nDestinationX=GetHarvesterBuildingPutLocationX();
		nDestinationY=GetHarvesterBuildingPutLocationY();
		nDestinationZ=GetHarvesterBuildingPutLocationZ();
		if(SwitchLightsOn(MOVING_TO_HARVEST_POINT)){
			state Moving;
		}
//TraceD("SetHarvestPoint NextCommand()\n");
		NextCommand(true);
		true;
	}

	command SetContainerDestination(unit uDestination) hidden button "translateCommandSetRefinery"{
//TraceD("SetContainerDestination(@{");
//TraceD(uDestination.GetLocationX());
//TraceD(", ");
//TraceD(uDestination.GetLocationY());
//TraceD("})\n");
		SetHarvesterBuilding(uDestination);
		nDestinationX=GetHarvesterBuildingPutLocationX();
		nDestinationY=GetHarvesterBuildingPutLocationY();
		nDestinationZ=GetHarvesterBuildingPutLocationZ();
		if(SwitchLightsOn(MOVING_TO_DESTINATION_BUILDING)){
			state Moving;
		}
//TraceD("SetContainerDestination NextCommand()\n");
		NextCommand(true);
		true;
	}

	command Move(int nX, int nY, int nZ) hidden button "translateCommandMove" description "translateCommandMoveDescription" hotkey priority 21{
//TraceD("Move(");
//TraceD(nX);
//TraceD(", ");
//TraceD(nY);
//TraceD(", ");
//TraceD(nZ);
//TraceD(")\n");
		nDestinationX=nX;
		nDestinationY=nY;
		nDestinationZ=nZ;
		if(SwitchLightsOn(MOVING_ONLY)){
			state Moving;
		}
		true;
	}

	command Enter(unit uNewEntrance) hidden button "translateCommandEnter"{
//TraceD("Enter(@{");
//TraceD(uNewEntrance.GetLocationX());
//TraceD(", ");
//TraceD(uNewEntrance.GetLocationY());
//TraceD("})\n");
		uEntrance=uNewEntrance;
		nDestinationX=GetEntranceX(uEntrance);
		nDestinationY=GetEntranceY(uEntrance);
		nDestinationZ=GetEntranceZ(uEntrance);
		if(SwitchLightsOn(MOVING_TO_ENTRANCE)){
			state Moving;
		}
		true;
	}

	command Stop() button "translateCommandStop" description "translateCommandStopDescription" hotkey priority 20{
//TraceD("Stop()\n");
		bHarvestPointWasSet=false;
		InvalidateCurrentHarvestPoint();
		SetHarvesterBuilding(null);
		if(SwitchLightsOn(MOVING_TO_STOP)){
			state Moving;
		}
		true;
	}

   command Land() button "translateCommandLand" description "translateCommandLandDescription" hotkey priority 31{
//TraceD("Land()\n");
		nDestinationX=GetMoveLocationX();
		nDestinationY=GetMoveLocationY();
		nDestinationZ=GetMoveLocationZ();
		if(SwitchLightsOn(MOVING_TO_LAND)){
			state Moving;
		}
		true;
	}

	command SetLights(int nMode) button comboLights description "translateCommandStateLightsModeDescription" hotkey priority 204{
//TraceD("SetLights(");
//TraceD(nMode);
//TraceD(")\n");
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
//TraceD("SpecialChangeUnitsScript()\n");
		//special command, no implementation
	}
}
