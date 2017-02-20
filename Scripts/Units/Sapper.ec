/* Copyright 2009-2017 surrim
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

sapper "translateScriptNameMiner"{
	consts{
		//comboLights
		LIGHTS_AUTO = 0;
		LIGHTS_ON   = 1;
		LIGHTS_OFF  = 2;

		//nState
		STATE_NOTHING                  = 0;
		STATE_MOVING                   = 1;
		STATE_MOVING_TO_MINE_PUT_POINT = 2;
	}

	int nMoveToX;
	int nMoveToY;
	int nMoveToZ;
	int nMinePointX;
	int nMinePointY;
	int nMinePointZ;
	int nState;

	enum comboLights{
		"translateCommandStateLightsAUTO", //LIGHTS_AUTO
		"translateCommandStateLightsON",   //LIGHTS_ON
		"translateCommandStateLightsOFF",  //LIGHTS_OFF
	multi:
		"translateCommandStateLightsMode"
	}

	function int MoveToCurrMinePointForce(){
		nMinePointX=GetCurrMinePointX();
		nMinePointY=GetCurrMinePointY();
		nMinePointZ=GetCurrMinePointZ();
		CallMoveToPointForce(nMinePointX, nMinePointY, nMinePointZ);
	}

	state Nothing;
	state Moving;
	state MovingToMinePutPoint;
	state PuttingMine;
	state WaitForMines;

	state Nothing{
		return Nothing;
	}

	state Moving{
		if(IsMoving()){
			return Moving;
		}
		NextCommand(true);
		return Nothing;
	}

	state MovingToMinePutPoint{
		if(IsMoving()){
			return MovingToMinePutPoint;
		}
		if(GetLocationX()==nMinePointX && GetLocationY()==nMinePointY && GetLocationZ()==nMinePointZ){
			if(HaveMines()){
				CallPutMine();
				return PuttingMine;
			}
			return WaitForMines;
		}
		CallMoveToPointForce(nMinePointX, nMinePointY, nMinePointZ);
		return MovingToMinePutPoint;
	}

	state PuttingMine{
		if(IsPuttingMine()){
			return PuttingMine;
		}
		if(NextMinePoint()){
			MoveToCurrMinePointForce();
			return MovingToMinePutPoint;
		}
		NextCommand(true);
		return Nothing;
	}

	state WaitForMines{
		if(HaveMines()){
			CallPutMine();
			return PuttingMine;
		}
		return WaitForMines;
	}

	state Froozen{
		if(IsFroozen()){
			return Froozen;
		}
		if(nState==STATE_MOVING_TO_MINE_PUT_POINT){
			CallMoveToPoint(nMinePointX, nMinePointY, nMinePointZ);
			return MovingToMinePutPoint;
		}
		if(nState==STATE_MOVING){
			CallMoveToPoint(nMoveToX, nMoveToY, nMoveToZ);
			return Moving;
		}
		return Nothing;
	}

	event OnFreezeForSupplyOrRepair(int nFreezeTicks){
		if(state!=Froozen){
			if(state==Moving){
				nState=STATE_MOVING;
			}else if(state==MovingToMinePutPoint || state==PuttingMine || state==WaitForMines){
				nState=STATE_MOVING_TO_MINE_PUT_POINT;
			}else{
				nState=STATE_NOTHING;
			}
		}
		CallFreeze(nFreezeTicks);
		state Froozen;
		true;
	}

	command Initialize(){
		SetCannonFireMode(-1, 1);
		false;
	}

	command Uninitialize(){
		false;
	}

	command MineTerrainClose(int nX1, int nY1, int nZ1, int nX2, int nY2, int nZ2) button "translateCommandMineClose" description "translateCommandMineCloseDescription" hotkey priority 100{
		ResetMinePoints();
		if(AddMineAreaClose(nX1, nY1, nZ1, nX2, nY2, nZ2)){
			MoveToCurrMinePointForce();
			state MovingToMinePutPoint;
		}
		true;
	}

	command MineTerrainMedium(int nX1, int nY1, int nZ1, int nX2, int nY2, int nZ2) button "translateCommandMineMedium" description "translateCommandMineMediumDescription" hotkey priority 101{
		ResetMinePoints();
		if(AddMineAreaMedium(nX1, nY1, nZ1, nX2, nY2, nZ2)){
			MoveToCurrMinePointForce();
			state MovingToMinePutPoint;
		}
		true;
	}

	command MineTerrainFar(int nX1, int nY1, int nZ1, int nX2, int nY2, int nZ2) button "translateCommandMineFar" description "translateCommandMineFarDescription" hotkey priority 102{
		ResetMinePoints();
		if(AddMineAreaFar(nX1, nY1, nZ1, nX2, nY2, nZ2)){
			MoveToCurrMinePointForce();
			state MovingToMinePutPoint;
		}
		true;
	}

	command MineTerrainLine(int nX1, int nY1, int nZ1, int nX2, int nY2, int nZ2) button "translateCommandMineLine" description "translateCommandMineLineDescription" hotkey priority 103{
		ResetMinePoints();
		if(AddMineLine(nX1, nY1, nZ1, nX2, nY2, nZ2)){
			MoveToCurrMinePointForce();
			state MovingToMinePutPoint;
		}
		true;
	}

	command UserPoint0(int nX, int nY, int nZ) button "translateCommandAddPoint" description "translateCommandAddPointDescription" hotkey priority 102{
		ResetMinePoints();
		if(AddMinePoint(nX, nY, nZ)){
			if(state!=MovingToMinePutPoint && state!=WaitForMines && state!=PuttingMine){
				MoveToCurrMinePointForce();
				state MovingToMinePutPoint;
			}
		}else{
			NextCommand(false);
		}
		true;
	}

	command Move(int nGx, int nGy, int nLz) hidden button "translateCommandMove" description "translateCommandMoveDescription" hotkey priority 21{
		ResetMinePoints();
		nMoveToX=nGx;
		nMoveToY=nGy;
		nMoveToZ=nLz;
		CallMoveToPoint(nMoveToX, nMoveToY, nMoveToZ);
		state Moving;
		true;
	}

	command Enter(unit uEntrance) hidden button "translateCommandEnter"{
		ResetMinePoints();
		nMoveToX=GetEntranceX(uEntrance);
		nMoveToY=GetEntranceY(uEntrance);
		nMoveToZ=GetEntranceZ(uEntrance);
		CallMoveInsideObject(uEntrance);
		state Moving;
		true;
	}

	command SendSupplyRequest() button "translateCommandSupply" description "translateCommandSupplyDescription" hotkey priority 27{
		SendSupplyRequest();
		NextCommand(true);
		true;
	}

	command Stop() button "translateCommandStop" description "translateCommandStopDescription" hotkey priority 20{
		ResetMinePoints();
		CallStopMoving();
		state Moving;
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

	command SpecialChangeUnitsScript() button "translateCommandChangeScript" description "translateCommandChangeScriptDescription" hotkey priority 254{
		//special command, no implementation
	}
}
