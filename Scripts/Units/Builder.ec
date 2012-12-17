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

builder "translateScriptNameConstructionVechicle"{
	consts{
		//comboLights
		LIGHTS_AUTO = 0;
		LIGHTS_ON   = 1;
		LIGHTS_OFF  = 2;

		//nMovingReason
		MOVING_ONLY              = 0;
		MOVING_TO_BUILD_BUILDING = 1;
		MOVING_TO_BUILD_WALL     = 2;
		MOVING_TO_BUILD_TERRAIN  = 3;

		//nBuildingOffsetPriority
		PRIORITY_X_FIRST = 0;
		PRIORITY_Y_FIRST = 1;
	}

	int nMovingReason;
	int nStayX;
	int nStayY;
	int nStayZ;
	int nBuildingX;
	int nBuildingY;
	int nBuildingZ;
	int nBuildingOffsetPriority;
	int nBuildingOffsetX;
	int nBuildingOffsetY;
	unit uWall;

	enum comboLights{
		"translateCommandStateLightsAUTO", //LIGHTS_AUTO
		"translateCommandStateLightsON",   //LIGHTS_ON
		"translateCommandStateLightsOFF",  //LIGHTS_OFF
	multi:
		"translateCommandStateLightsMode"
	}

	function int ABS(int n){
		if(n>=0){
			return n;
		}
		return -n;
	}

	function int Sign(int n){
		if(n<0){
			return -1;
		}
		if(n>0){
			return 1;
		}
		return 0;
	}

	function int SetCurrentBuildLocationForWall(){
		nBuildingX=GetCurrentElementX();
		nBuildingY=GetCurrentElementY();
		nBuildingZ=GetCurrentElementZ();

		nStayZ=nBuildingZ;
		if(nBuildingOffsetPriority==PRIORITY_X_FIRST){
			nStayX=nBuildingX+nBuildingOffsetX;
			nStayY=nBuildingY;
		}else{ //nBuildingOffsetPriority==PRIORITY_Y_FIRST
			nStayX=nBuildingX;
			nStayY=nBuildingY+nBuildingOffsetY;
		}
		if(!IsGoodPointForCurrentBuild(nStayX, nStayY, nStayZ) || !IsFreePoint(nStayX, nStayY, nStayZ)){
			if(nBuildingOffsetPriority==PRIORITY_X_FIRST){
				nStayX=nBuildingX;
				nStayY=nBuildingY+nBuildingOffsetY;
			}else{ //nBuildingOffsetPriority==PRIORITY_Y_FIRST
				nStayX=nBuildingX+nBuildingOffsetX;
				nStayY=nBuildingY;
			}
		}
	}

	function int MoveToCurrentBuildLocationForce(int nNewMovingReason){
		nMovingReason=nNewMovingReason;
		if(nMovingReason!=MOVING_ONLY){
			if(nMovingReason==MOVING_TO_BUILD_WALL){
				SetCurrentBuildLocationForWall();
			}
			if(!IsGoodPointForCurrentBuild(nStayX, nStayY, nStayZ) || !IsFreePoint(nStayX, nStayY, nStayZ)){
				nStayX=GetCurrentBuildLocationX();
				nStayY=GetCurrentBuildLocationY();
				nStayZ=GetCurrentBuildLocationZ();
			}
		}
		CallMoveToPointForce(nStayX, nStayY, nStayZ);
	}

	function int SetBuildingOffset(int nX1, int nY1, int nX2, int nY2){
		int nDeltaX;
		int nDeltaY;

		nDeltaX=nX2-nX1;
		nDeltaY=nY2-nY1;
		if(ABS(nDeltaX)>=ABS(nDeltaY)){
			nBuildingOffsetPriority=PRIORITY_X_FIRST;
		}else{
			nBuildingOffsetPriority=PRIORITY_Y_FIRST;
		}
		nBuildingOffsetX=Sign(nDeltaX);
		nBuildingOffsetY=Sign(nDeltaY);
	}

	state StartNothing;
	state Nothing;
	state StartMoving;
	state Moving;
	state MovingClose;
	state Building;
	state Froozen;

	state StartNothing{
		if(comboLights==LIGHTS_AUTO){
			SetLightsMode(LIGHTS_OFF);
		}
		return Nothing;
	}

	state Nothing{
		return Nothing;
	}

	state StartMoving{
		if(comboLights==LIGHTS_AUTO){
			SetLightsMode(LIGHTS_ON);
		}
		if(GetLocationX()!=nStayX || GetLocationY()!=nStayY || GetLocationZ()!=nStayX){
			return Moving;
		}
		return MovingClose, 1;
	}

	state Moving{
		if(DistanceTo(nStayX, nStayY)>4){
			return Moving;
		}
		return MovingClose, 1;
	}

	state MovingClose{
		if(IsMoving()){
			return MovingClose, 1;
		}
		if(nMovingReason==MOVING_ONLY){
			NextCommand(true);
			return StartNothing, 1;
		}
		if(IsInGoodPointForCurrentBuild()){
			if(nMovingReason==MOVING_TO_BUILD_BUILDING){
				CallBuildBuilding();
			}else{ //MOVING_TO_BUILD_WALL or MOVING_TO_BUILD_TERRAIN
				CallBuildCurrentElement();
			}
			return Building, 1;
		}
		MoveToCurrentBuildLocationForce(nMovingReason);
		return StartMoving, 1;
	}

	state Building{
		if(nMovingReason==MOVING_TO_BUILD_TERRAIN){
			if(IsBuildWorking()){
				return Building, 1;
			}
		}else{ //MOVING_TO_BUILD_BUILDING or MOVING_TO_BUILD_WALL
			if(IsBuildWorking()){
				if(nMovingReason==MOVING_TO_BUILD_BUILDING){
					if(IsFreePoint(nBuildingX, nBuildingY, nBuildingZ)){
						return Building, 1;
					}
				}else{ //MOVING_TO_BUILD_WALL
					BuildTargetsArray(findTargetWall, findNeutralUnit, findDestinationAnyUnit);
					StartEnumTargetsArray();
					do{
						uWall=GetNextTarget();
						if(
							uWall.GetLocationX()==nBuildingX
							&&
							uWall.GetLocationY()==nBuildingY
							&&
							uWall.GetLocationZ()==nBuildingZ
						){
							break;
						}
					}while(uWall!=null);
					EndEnumTargetsArray();
					if(uWall==null){
						return Building, 1;
					}
				}
			}
		}
		if(nMovingReason!=MOVING_TO_BUILD_BUILDING){ //MOVING_TO_BUILD_WALL or MOVING_TO_BUILD_TERRAIN
			if(NextElementPoint()){
				MoveToCurrentBuildLocationForce(nMovingReason);
				return StartMoving, 1;
			}
		}
		NextCommand(true);
		return StartNothing, 1;
	}

	state Froozen{
		if(IsFroozen()){
			return Froozen;
		}
		return StartNothing, 1;
	}

	event OnFreezeForSupplyOrRepair(int nFreezeTicks){
		CallFreeze(nFreezeTicks);
		state Froozen;
		true;
	}

	command Initialize(){
		comboLights=LIGHTS_AUTO;
		SetLightsMode(LIGHTS_OFF);
	}

	command BuildBuilding(int nX, int nY, int nZ, int nAlpha, int nID) hidden button "translateCommandBuilding"{
		nBuildingX=nX;
		nBuildingY=nY;
		nBuildingZ=nZ;
		SetBuildTypeBuildBuilding(nX, nY, nZ, nAlpha, nID);
		MoveToCurrentBuildLocationForce(MOVING_TO_BUILD_BUILDING);
		state StartMoving;
		true;
	}

	command BuildTrench(int nX1, int nY1, int nZ1, int nX2, int nY2, int nZ2) button "translateCommandTrench" hotkey{
		SetBuildTypeBuildElements(buildTrench);
		if(AddElementsLine(nX1, nY1, nZ1, nX2, nY2, nZ2)){
			MoveToCurrentBuildLocationForce(MOVING_TO_BUILD_TERRAIN);
			state StartMoving;
		}
		true;
	}

	command BuildFlatTerrain(int nX1, int nY1, int nZ1, int nX2, int nY2, int nZ2) button "translateCommandFlatten" hotkey{
		SetBuildTypeBuildElements(buildFlatTerrain);
		if(AddElementsLine(nX1, nY1, nZ1, nX2, nY2, nZ2)){
			MoveToCurrentBuildLocationForce(MOVING_TO_BUILD_TERRAIN);
			state StartMoving;
		}
		true;
	}

	command BuildWall(int nX1, int nY1, int nZ1, int nX2, int nY2, int nZ2) button "translateCommandWall" hotkey{
		SetBuildTypeBuildElements(buildWall);
		if(AddElementsLine(nX1, nY1, nZ1, nX2, nY2, nZ2)){
			SetBuildingOffset(nX1, nY1, nX2, nY2);
			MoveToCurrentBuildLocationForce(MOVING_TO_BUILD_WALL);
			state StartMoving;
		}
		true;
	}

	command BuildWideBridge(int nX1, int nY1, int nZ1, int nX2, int nY2, int nZ2) button "translateCommandBridge2" hotkey{
		SetBuildTypeBuildElements(buildWideBridge);
		if(AddElementsLine(nX1, nY1, nZ1, nX2, nY2, nZ2)){
			MoveToCurrentBuildLocationForce(MOVING_TO_BUILD_TERRAIN);
			state StartMoving;
		}
		true;
	}

	command BuildNarrowBridge(int nX1, int nY1, int nZ1, int nX2, int nY2, int nZ2) button "translateCommandBridge1" hotkey{
		SetBuildTypeBuildElements(buildNarrowBridge);
		if(AddElementsLine(nX1, nY1, nZ1, nX2, nY2, nZ2)){
			MoveToCurrentBuildLocationForce(MOVING_TO_BUILD_TERRAIN);
			state StartMoving;
		}
		true;
	}

	command BuildWideTunnel(int nX1, int nY1, int nZ1, int nX2, int nY2, int nZ2) button "translateCommandTunnel2" hotkey{
		SetBuildTypeBuildElements(buildWideTunnel);
		if(AddElementsLine(nX1, nY1, nZ1, nX2, nY2, nZ2)){
			MoveToCurrentBuildLocationForce(MOVING_TO_BUILD_TERRAIN);
			state StartMoving;
		}
		true;
	}

	command BuildNarrowTunnel(int nX1, int nY1, int nZ1, int nX2, int nY2, int nZ2) button "translateCommandTunnel1" hotkey{
		SetBuildTypeBuildElements(buildNarrowTunnel);
		if(AddElementsLine(nX1, nY1, nZ1, nX2, nY2, nZ2)){
			MoveToCurrentBuildLocationForce(MOVING_TO_BUILD_TERRAIN);
			state StartMoving;
		}
		true;
	}

	command SpecialNextAngle() button "translateCommandTurn" description "translateCommandTurnDescription" hotkey priority 50{
		//implemented in code
	}

	command Stop() button "translateCommandStop" description "translateCommandStopDescription" hotkey priority 20{
		nStayX=GetLocationX();
		nStayY=GetLocationY();
		nStayZ=GetLocationZ();
		if(IsMoving()){
			CallStopMoving();
		}
		state StartNothing;
	}

	command Move(int nX, int nY, int nZ) hidden button "translateCommandMove" description "translateCommandMoveDescription" hotkey priority 21{
		nStayX=nX;
		nStayY=nY;
		nStayZ=nZ;
		CallMoveToPoint(nStayX, nStayY, nStayZ);
		nMovingReason=MOVING_ONLY;
		state StartMoving;
		true;
	}

	command SetLights(int nMode) button comboLights description "translateCommandStateLightsModeDescription" hotkey priority 204{
		if(nMode==-1){
			comboLights=(comboLights+1)%3;
		}else{
			comboLights=nMode;
		}
		if(comboLights==LIGHTS_AUTO){
			if(IsMoving()){
				SetLightsMode(LIGHTS_ON);
			}else{
				SetLightsMode(LIGHTS_OFF);
			}
		}else{
			SetLightsMode(comboLights);
		}
	}

	command Enter(unit uEntrance) hidden button "translateCommandEnter"{
		CallMoveInsideObject(uEntrance);
		nMovingReason=MOVING_ONLY;
		state StartMoving;
		true;
	}

	command SpecialChangeUnitsScript() button "translateCommandChangeScript" description "translateCommandChangeScriptDescription" hotkey priority 254{
		//special command, no implementation
	}
}
