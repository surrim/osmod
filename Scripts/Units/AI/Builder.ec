/* Copyright 2009-2016 surrim
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

builder "translateScriptNameConstructionVechicle2"{
	consts{
		UCS_TRANSMITTER = 8323072;
		UCS_POWER       = 8257536;
		UCS_FACTORY     = 8519680;
		UCS_CIVIL       = 8454144;
		ED_POWER        = 4849664;
		ED_FACTORY      = 4980736;
		ED_CIVIL        = 4915200;

		//comboLights
		LIGHTS_AUTO = 0;
		LIGHTS_ON   = 1;
		LIGHTS_OFF  = 2;
	}

	int nDummy;
	int nBuildingCounter;

	enum comboLights{
		"translateCommandStateLightsAUTO", //LIGHTS_AUTO
		"translateCommandStateLightsON",   //LIGHTS_ON
		"translateCommandStateLightsOFF",  //LIGHTS_OFF
	multi:
		"translateCommandStateLightsMode"
	}

	function int MoveToCurrentBuildLocationForce(){
		nDummy=GetCurrentBuildLocationX();
		CallMoveToPointForce(nDummy, GetCurrentBuildLocationY(), GetCurrentBuildLocationZ());
	}

	state Nothing;
	state Moving;
	state StartMoving;
	state MovingToBuildBuilding;
	state MovingToBuildElement;
	state BuildBuilding;
	state BuildElement;

	state Nothing{ //imba ai hack
		int nID;

		if(FindTarget(findTargetBuildingUnit, findOurUnit, findNearestUnit, findDestinationAnyUnit)!=null){
			++nBuildingCounter;
			nBuildingCounter=nBuildingCounter%12;
			if(nBuildingCounter<10){
				if(nBuildingCounter&1){
					nID=UCS_FACTORY;
				}else{
					nID=ED_FACTORY;
				}
			}else{
				if(nBuildingCounter&1){
					nID=UCS_CIVIL;
				}else{
					nID=ED_CIVIL;
				}
			}

			SetBuildTypeBuildBuilding(GetLocationX()+Rand(12)-6, GetLocationY()+Rand(12)-6, GetLocationZ(), 0, nID);
			MoveToCurrentBuildLocationForce();
			return MovingToBuildBuilding;
		}
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

	state MovingToBuildBuilding{
		if(IsMoving()){
			return MovingToBuildBuilding;
		}
		if(IsInGoodPointForCurrentBuild()){
			CallBuildBuilding();
			return BuildBuilding;
		}
		MoveToCurrentBuildLocationForce();
		return Nothing;
	}

	state MovingToBuildElement{
		if(IsMoving()){
			return MovingToBuildElement;
		}
		if(IsInGoodPointForCurrentBuild()){
			CallBuildCurrentElement();
			return BuildElement;
		}
		MoveToCurrentBuildLocationForce();
		return Nothing;
	}

	state BuildBuilding{
		if(IsBuildWorking()){
			return BuildBuilding;
		}
		NextCommand(true);
		return Nothing;
	}

	state BuildElement{
		if(IsBuildWorking()){
			return BuildElement;
		}
		if(NextElementPoint()){
			MoveToCurrentBuildLocationForce();
			return MovingToBuildElement;
		}
		NextCommand(true);//!!1 czy 0?
		return Nothing;
	}

	command Initialize(){
		comboLights=LIGHTS_AUTO;
	}

	command BuildBuilding(int nX, int nY, int nZ, int nAlpha, int nID) hidden button "translateCommandBuilding"{
		SetBuildTypeBuildBuilding(nX, nY, nZ, nAlpha, nID);
		MoveToCurrentBuildLocationForce();
		state MovingToBuildBuilding;
		true;
	}

	command BuildTrench(int nX1, int nY1, int nZ1, int nX2, int nY2, int nZ2) button "translateCommandTrench" hotkey{
		SetBuildTypeBuildElements(buildTrench);
		if(AddElementsLine(nX1, nY1, nZ1, nX2, nY2, nZ2)){
			MoveToCurrentBuildLocationForce();
			state MovingToBuildElement;
		}
		true;
	}

	command BuildFlatTerrain(int nX1, int nY1, int nZ1, int nX2, int nY2, int nZ2) button "translateCommandFlatten" hotkey{
		SetBuildTypeBuildElements(buildFlatTerrain);
		if(AddElementsLine(nX1, nY1, nZ1, nX2, nY2, nZ2)){
			MoveToCurrentBuildLocationForce();
			state MovingToBuildElement;
		}
		true;
	}

	command BuildWall(int nX1, int nY1, int nZ1, int nX2, int nY2, int nZ2) button "translateCommandWall" hotkey{
		SetBuildTypeBuildElements(buildWall);
		if(AddElementsLine(nX1, nY1, nZ1, nX2, nY2, nZ2)){
			MoveToCurrentBuildLocationForce();
			state MovingToBuildElement;
		}
		true;
	}

	command BuildWideBridge(int nX1, int nY1, int nZ1, int nX2, int nY2, int nZ2) button "translateCommandBridge2" hotkey{
		SetBuildTypeBuildElements(buildWideBridge);
		if(AddElementsLine(nX1, nY1, nZ1, nX2, nY2, nZ2)){
			MoveToCurrentBuildLocationForce();
			state MovingToBuildElement;
		}
		true;
	}

	command BuildNarrowBridge(int nX1, int nY1, int nZ1, int nX2, int nY2, int nZ2) button "translateCommandBridge1" hotkey{
		SetBuildTypeBuildElements(buildNarrowBridge);
		if(AddElementsLine(nX1, nY1, nZ1, nX2, nY2, nZ2)){
			MoveToCurrentBuildLocationForce();
			state MovingToBuildElement;
		}
		true;
	}

	command BuildWideTunnel(int nX1, int nY1, int nZ1, int nX2, int nY2, int nZ2) button "translateCommandTunnel2" hotkey{
		SetBuildTypeBuildElements(buildWideTunnel);
		if(AddElementsLine(nX1, nY1, nZ1, nX2, nY2, nZ2)){
			MoveToCurrentBuildLocationForce();
			state MovingToBuildElement;
		}
		true;
	}

	command BuildNarrowTunnel(int nX1, int nY1, int nZ1, int nX2, int nY2, int nZ2) button "translateCommandTunnel1" hotkey{
		SetBuildTypeBuildElements(buildNarrowTunnel);
		if(AddElementsLine(nX1, nY1, nZ1, nX2, nY2, nZ2)){
			MoveToCurrentBuildLocationForce();
			state MovingToBuildElement;
		}
		true;
	}

	command SpecialNextAngle() button "translateCommandTurn" description "translateCommandTurnDescription" hotkey priority 50{
		//implemented in code
	}

	command Move(int nGx, int nGy, int nLz) button "translateCommandMove" description "translateCommandMoveDescription" hotkey priority 21{
		CallMoveToPoint(nGx, nGy, nLz);
		state StartMoving;
		true;
	}

	command SetLights(int nMode) button comboLights description "translateCommandStateLightsModeDescription" hotkey priority 204{
		if(nMode==-1){
			comboLights=(comboLights+1)%3;
		}else{
			comboLights=nMode;
		}
		SetLightsMode(comboLights);
	}

	command Enter(unit uEntrance) hidden button "translateCommandEnter"{
		CallMoveInsideObject(uEntrance);
		state StartMoving;
		true;
	}

	command SpecialChangeUnitsScript() button "translateCommandChangeScript" description "translateCommandChangeScriptDescription" hotkey priority 254{
		//special command - no implementation
	}
}
