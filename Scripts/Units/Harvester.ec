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

		//other
		SQRT_1 = 5741;
		SQRT_2 = 8119;
	}

	int bValidHarvestPoint;
	int nHarvestPointX;
	int nHarvestPointY;
	int nHarvestPointZ;

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

	function int SetHarvestPoint(int nX, int nY, int nZ){
		nHarvestPointX=nX;
		nHarvestPointY=nY;
		nHarvestPointZ=nZ;
		bValidHarvestPoint=true;
		SetCurrentHarvestPoint(nHarvestPointX, nHarvestPointY, nHarvestPointZ);
	}

	function int BetterDistance(int nX1, int nY1, int nX2, int nY2){
		int xDiff;
		int yDiff;
		xDiff=nX1-nX2;
		yDiff=nY1-nY2;
		if(xDiff<0){
			xDiff=-xDiff;
		}
		if(yDiff<0){
			yDiff=-yDiff;
		}
		if(xDiff<yDiff){
			return xDiff*SQRT_2+(yDiff-xDiff)*SQRT_1;
		}
		return yDiff*SQRT_2+(xDiff-yDiff)*SQRT_1;
	}

	function int FindOrSetNewHarvestPoint(){
		int nNewHarvestPointX;
		int nNewHarvestPointY;

		int nBestHarvestPointX;
		int nBestHarvestPointY;

		int nBestDistance;
		int nNewBestDistance;

		if(bValidHarvestPoint){
			nBestHarvestPointX=nHarvestPointX;
			nBestHarvestPointY=nHarvestPointY;
			nBestDistance=2000000000;
			for(nNewHarvestPointX=nHarvestPointX-3;nNewHarvestPointX<=nHarvestPointX+3;++nNewHarvestPointX){
				for(nNewHarvestPointY=nHarvestPointY-3;nNewHarvestPointY<=nHarvestPointY+3;++nNewHarvestPointY){
					if(IsResourceInPoint(nNewHarvestPointX, nNewHarvestPointY, nHarvestPointZ) && IsFreePoint(nNewHarvestPointX, nNewHarvestPointY, nHarvestPointZ)){
						nNewBestDistance=BetterDistance(nHarvestPointX, nHarvestPointY, nNewHarvestPointX, nNewHarvestPointY);
						if(nNewBestDistance<nBestDistance){
							nBestHarvestPointX=nNewHarvestPointX;
							nBestHarvestPointY=nNewHarvestPointY;
							nBestDistance=nNewBestDistance;
						}
					}
				}
			}
			nHarvestPointX=nBestHarvestPointX;
			nHarvestPointY=nBestHarvestPointY;
			SetCurrentHarvestPoint(nHarvestPointX, nHarvestPointY, nHarvestPointZ);
			return true;
		}
		return false;
	}

	function int SwitchLightsOff(){
TraceD("SwitchLightsOff\n");
		if(comboLights==LIGHTS_AUTO){
			SetLightsMode(LIGHTS_OFF);
		}
	}

	function int SwitchLightsOn(int nNewMovingReason){
TraceD("SwitchLightsOn(");
TraceD(nNewMovingReason);
TraceD(")\n");
		nMovingReason=nNewMovingReason;
		if(nMovingReason==MOVING_ONLY){
			if(!IsMoving() && IsAt(nDestinationX, nDestinationY, nDestinationZ)){
				return false;
			}
			CallMoveToPoint(nDestinationX, nDestinationY, nDestinationZ);
		}else if(nMovingReason==MOVING_TO_HARVEST_POINT){
			if(HaveFullResources()){
				return SwitchLightsOn(MOVING_TO_DESTINATION_BUILDING);
			}
			if(!bValidHarvestPoint || IsPuttingResource() || (IsHarvesting() && IsAt(nHarvestPointX, nHarvestPointY, nHarvestPointZ))){
				return false;
			}
			CallMoveToPoint(nHarvestPointX, nHarvestPointY, nHarvestPointZ);
		}else if(nMovingReason==MOVING_TO_DESTINATION_BUILDING){
			if(!HaveSomeResources()){
				if(bValidHarvestPoint){
					return SwitchLightsOn(MOVING_TO_HARVEST_POINT);
				}
				return false;
			}
			if(IsPuttingResource() && IsAt(nDestinationX, nDestinationY, nDestinationZ)){
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
			CallMoveToPointForce(nDestinationX, nDestinationY, nDestinationZ);
		}else if(nMovingReason==MOVING_TO_LAND){
			if(IsOnGround()){
				return false;
			}
			CallMoveToPoint(nDestinationX, nDestinationY, nDestinationZ);
		}else if(nMovingReason==MOVING_TO_STOP){
			if(!IsMoving()){
				return false;
			}
			CallStopMoving();
		}else if(nMovingReason==MOVING_TO_ENTRANCE){
			CallMoveInsideObject(uEntrance);
		}
		if(comboLights==LIGHTS_AUTO){
			SetLightsMode(LIGHTS_AUTO);
		}
		return true;
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
			}else{
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
			return MovingClose, 1;
		}
/*		if(nMovingReason==MOVING_TO_HARVEST_POINT){
			if(!IsAt(nHarvestPointX, nHarvestPointY, nHarvestPointZ)){
				return MovingClose, 1;
			}
		}else{
			if(!IsAt(nDestinationX, nDestinationY, nDestinationZ)){
				return MovingClose, 1;
			}
		}
*/		if(nMovingReason==MOVING_TO_HARVEST_POINT){
			if(IsAt(nHarvestPointX, nHarvestPointY, nHarvestPointZ) && IsResourceInPoint(nHarvestPointX, nHarvestPointY, nHarvestPointZ)){
				if(IsOnGround()){
					CallHarvest();
					SwitchLightsOff();
					return Harvesting;
				}
				if(IsFreePoint(nHarvestPointX, nHarvestPointY, nHarvestPointZ)){
					CallLand();
					return MovingClose, 1;
				}
			}
			if(FindOrSetNewHarvestPoint()){
				if(SwitchLightsOn(MOVING_TO_HARVEST_POINT)){
					return Moving;
				}
			}
		}else if(nMovingReason==MOVING_TO_DESTINATION_BUILDING){
			if(IsAt(nDestinationX, nDestinationY, nDestinationZ)){
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
TraceD("MovingClose NextCommand()\n");
		NextCommand(true);
		SwitchLightsOff();
		return Nothing;
	}

	state Harvesting{
TraceD("Harvesting\n");
		if(IsHarvesting()){
			return Harvesting;
		}
		if(HaveFullResources()){
			if(SwitchLightsOn(MOVING_TO_DESTINATION_BUILDING)){
				return Moving;
			}
		}else if(FindOrSetNewHarvestPoint()){
			if(SwitchLightsOn(MOVING_TO_HARVEST_POINT)){
				return Moving;
			}
		}else if(HaveSomeResources()){
			if(SwitchLightsOn(MOVING_TO_DESTINATION_BUILDING)){
				return Moving;
			}
		}
TraceD("Harvesting NextCommand\n");
		NextCommand(true);
		SwitchLightsOff();
		return Nothing;
	}

	state PuttingResource{
TraceD("PuttingResource\n");
		if(IsPuttingResource()){
			return PuttingResource;
		}
		if(HaveSomeResources() && SwitchLightsOn(MOVING_TO_DESTINATION_BUILDING)){
			return Moving;
		}
		if(bValidHarvestPoint && SwitchLightsOn(MOVING_TO_HARVEST_POINT)){
			return Moving;
		}
TraceD("PuttingResource NextCommand\n");
		NextCommand(true);
		SwitchLightsOff();
		return Nothing;
	}

	state Froozen{
TraceD("Froozen\n");
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
TraceD("OnFreezeForSupplyOrRepair\n");
		if(state==Nothing){
			nState=STATE_NOTHING;
			CallFreeze(nFreezeTicks);
			state Froozen;
			true;
		}else if(state==Moving || state==MovingClose){
			nState=STATE_MOVING;
			CallFreeze(nFreezeTicks);
			state Froozen;
			true;
		}
		false;
	}

	command Initialize(){
TraceD("Initialize\n");
		SwitchLightsOff();
	}

	command Uninitialize(){
TraceD("Uninitialize\n");
		InvalidateCurrentHarvestPoint();
		SetHarvesterBuilding(null);
		uEntrance=null;
	}

	command SetHarvestPoint(int nX, int nY, int nZ) hidden button "translateCommandHarvest"{
TraceD("SetHarvestPoint\n");
		SetHarvestPoint(nX, nY, nZ);
		nDestinationX=GetHarvesterBuildingPutLocationX();
		nDestinationY=GetHarvesterBuildingPutLocationY();
		nDestinationZ=GetHarvesterBuildingPutLocationZ();
		if(SwitchLightsOn(MOVING_TO_HARVEST_POINT)){
			state Moving;
		}
TraceD("SetHarvestPoint NextCommand()\n");
		NextCommand(true);
		true;
	}

	command SetContainerDestination(unit uDestination) hidden button "translateCommandSetRefinery"{
TraceD("SetContainerDestination\n");
		SetHarvesterBuilding(uDestination);
		nDestinationX=GetHarvesterBuildingPutLocationX();
		nDestinationY=GetHarvesterBuildingPutLocationY();
		nDestinationZ=GetHarvesterBuildingPutLocationZ();
		if(SwitchLightsOn(MOVING_TO_DESTINATION_BUILDING)){
			state Moving;
		}
TraceD("SetContainerDestination NextCommand()\n");
		NextCommand(true);
		true;
	}

	command Move(int nX, int nY, int nZ) hidden button "translateCommandMove" description "translateCommandMoveDescription" hotkey priority 21{
TraceD("Move\n");
		nDestinationX=nX;
		nDestinationY=nY;
		nDestinationZ=nZ;
		if(SwitchLightsOn(MOVING_ONLY)){
			state Moving;
		}
		true;
	}

	command Enter(unit uNewEntrance) hidden button "translateCommandEnter"{
TraceD("Enter\n");
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
TraceD("Stop\n");
		bValidHarvestPoint=false;
		InvalidateCurrentHarvestPoint();
		SetHarvesterBuilding(null);
		if(SwitchLightsOn(MOVING_TO_STOP)){
			state Moving;
		}
		true;
	}

   command Land() button "translateCommandLand" description "translateCommandLandDescription" hotkey priority 31{
TraceD("Land\n");
		nDestinationX=GetMoveLocationX();
		nDestinationY=GetMoveLocationY();
		nDestinationZ=GetMoveLocationZ();
		if(SwitchLightsOn(MOVING_TO_LAND)){
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
