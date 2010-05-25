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

builder "Builder2"{
	consts{
		//comboLights
		LIGHTS_AUTO = 0;
		LIGHTS_ON   = 1;
		LIGHTS_OFF  = 2;

		//nMovingReason
		MOVING_ONLY              = 0;
		MOVING_TO_BUILD_BUILDING = 1;
		MOVING_TO_BUILD_ELEMENT  = 2;
	}

	int nMovingReason;
	int nStayX;
	int nStayY;
	int nStayZ;
	int nBuildingX;
	int nBuildingY;
	int nBuildingZ;

	enum comboLights{
		"translateCommandStateLightsAUTO", //LIGHTS_AUTO
		"translateCommandStateLightsON",   //LIGHTS_ON
		"translateCommandStateLightsOFF",  //LIGHTS_OFF
	multi:
		"translateCommandStateLightsMode"
	}

	function int MoveToCurrentBuildLocationForce(int nReason){
		nMovingReason=nReason;
		if(!IsGoodPointForCurrentBuild(nStayX, nStayY, nStayZ)){
			nStayX=GetCurrentBuildLocationX();
			nStayY=GetCurrentBuildLocationY();
			nStayZ=GetCurrentBuildLocationZ();
		}
		CallMoveToPointForce(nStayX, nStayY, nStayZ);
	}

	state Nothing;
	state Nothing2;
	state StartMoving;
	state Moving;
	state MovingClose;
	state Building;
	state Froozen;

	state Nothing{
		if(comboLights==LIGHTS_AUTO){
			SetLightsMode(LIGHTS_OFF);
		}
		return Nothing2;
	}

	state Nothing2{
		return Nothing2;
	}

	state StartMoving{
		if(comboLights==LIGHTS_AUTO){
			SetLightsMode(LIGHTS_ON);
		}
		if(DistanceTo(nStayX, nStayY)>4){
			return Moving;
		}
		return MovingClose, 1;
	}

	state Moving{
		if(DistanceTo(nStayX, nStayY)>4){
			return Moving;
		}
		return MovingClose;
	}

	state MovingClose{
		if(IsMoving()){
			return MovingClose, 1;
		}
		if(nMovingReason==MOVING_ONLY){
			NextCommand(true);
			return Nothing;
		}
		//nMovingReason==MOVING_TO_BUILD_BUILDING || nMovingReason==MOVING_TO_BUILD_ELEMENT
		if(IsInGoodPointForCurrentBuild()){
			if(nMovingReason==MOVING_TO_BUILD_BUILDING){
				CallBuildBuilding();
			}else if(nMovingReason==MOVING_TO_BUILD_ELEMENT){
				CallBuildCurrentElement();
			}
			return Building, 1;
		}
		MoveToCurrentBuildLocationForce(nMovingReason);
	}

	state Building{
		if(IsBuildWorking()){
			if(nMovingReason==MOVING_TO_BUILD_BUILDING){
				if(IsFreePoint(nBuildingX, nBuildingY, nBuildingZ)){
					return Building, 1;
				}
			}else{ //nMovingReason==MOVING_TO_BUILD_ELEMENT
				return Building, 1;
			}
		}
		if(nMovingReason==MOVING_TO_BUILD_ELEMENT){
			if(NextElementPoint()){
				MoveToCurrentBuildLocationForce(MOVING_TO_BUILD_ELEMENT);
				return StartMoving, 1;
			}
		}
		NextCommand(true);
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

	command Initialize(){
		comboLights=LIGHTS_AUTO;
		SetLightsMode(comboLights);
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
			MoveToCurrentBuildLocationForce(MOVING_TO_BUILD_ELEMENT);
			state StartMoving;
		}
		true;
	}

	command BuildFlatTerrain(int nX1, int nY1, int nZ1, int nX2, int nY2, int nZ2) button "translateCommandFlatten" hotkey{
		SetBuildTypeBuildElements(buildFlatTerrain);
		if(AddElementsLine(nX1, nY1, nZ1, nX2, nY2, nZ2)){
			MoveToCurrentBuildLocationForce(MOVING_TO_BUILD_ELEMENT);
			state StartMoving;
		}
		true;
	}

	command BuildWall(int nX1, int nY1, int nZ1, int nX2, int nY2, int nZ2) button "translateCommandWall" hotkey{
		SetBuildTypeBuildElements(buildWall);
		if(AddElementsLine(nX1, nY1, nZ1, nX2, nY2, nZ2)){
			MoveToCurrentBuildLocationForce(MOVING_TO_BUILD_ELEMENT);
			state StartMoving;
		}
		true;
	}

	command BuildWideBridge(int nX1, int nY1, int nZ1, int nX2, int nY2, int nZ2) button "translateCommandBridge2" hotkey{
		SetBuildTypeBuildElements(buildWideBridge);
		if(AddElementsLine(nX1, nY1, nZ1, nX2, nY2, nZ2)){
			MoveToCurrentBuildLocationForce(MOVING_TO_BUILD_ELEMENT);
			state StartMoving;
		}
		true;
	}

	command BuildNarrowBridge(int nX1, int nY1, int nZ1, int nX2, int nY2, int nZ2) button "translateCommandBridge1" hotkey{
		SetBuildTypeBuildElements(buildNarrowBridge);
		if(AddElementsLine(nX1, nY1, nZ1, nX2, nY2, nZ2)){
			MoveToCurrentBuildLocationForce(MOVING_TO_BUILD_ELEMENT);
			state StartMoving;
		}
		true;
	}

	command BuildWideTunnel(int nX1, int nY1, int nZ1, int nX2, int nY2, int nZ2) button "translateCommandTunnel2" hotkey{
		SetBuildTypeBuildElements(buildWideTunnel);
		if(AddElementsLine(nX1, nY1, nZ1, nX2, nY2, nZ2)){
			MoveToCurrentBuildLocationForce(MOVING_TO_BUILD_ELEMENT);
			state StartMoving;
		}
		true;
	}

	command BuildNarrowTunnel(int nX1, int nY1, int nZ1, int nX2, int nY2, int nZ2) button "translateCommandTunnel1" hotkey{
		SetBuildTypeBuildElements(buildNarrowTunnel);
		if(AddElementsLine(nX1, nY1, nZ1, nX2, nY2, nZ2)){
			MoveToCurrentBuildLocationForce(MOVING_TO_BUILD_ELEMENT);
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
		state Nothing;
	}

	command Move(int nX, int nY, int nZ) hidden button "translateCommandMove" description "translateCommandMoveDescription" hotkey priority 21{
		if(comboLights==LIGHTS_AUTO){
			SetLightsMode(LIGHTS_ON);
		}
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
		if(comboLights==LIGHTS_AUTO){
			SetLightsMode(LIGHTS_ON);
		}
		CallMoveInsideObject(uEntrance);
		nMovingReason=MOVING_ONLY;
		state StartMoving;
		true;
	}

	command SpecialChangeUnitsScript() button "translateCommandChangeScript" description "translateCommandChangeScriptDescription" hotkey priority 254{
		//special command, no implementation
	}
}
