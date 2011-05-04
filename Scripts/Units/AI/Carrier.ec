/* Copyright 2009, 2010, 2011 surrim
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

carrier "translateScriptNameContainerTransporter"{
	consts{
		//comboLights
		LIGHTS_AUTO = 0;
		LIGHTS_ON   = 1;
		LIGHTS_OFF  = 2;

		//nGetContainerFrom
		MINE             = 0;
		SINGLE_CONTAINER = 1;
	}

	int m_nMoveToX;
	int m_nMoveToY;
	int m_nMoveToZ;
	int m_nCurrPutGetX;
	int m_nCurrPutGetY;
	int m_nCurrPutGetZ;
	int m_nContainerX;
	int m_nContainerY;
	int m_nContainerZ;
	int nGetContainerFrom; //0 - mine, 1 - single container

	enum comboLights{
		"translateCommandStateLightsAUTO", //LIGHTS_AUTO
		"translateCommandStateLightsON",   //LIGHTS_ON
		"translateCommandStateLightsOFF",  //LIGHTS_OFF
	multi:
		"translateCommandStateLightsMode"
	}

	state Initialize;
	state Nothing;
	state StartMoving;
	state Moving;
	state MovingToContainerSource;
	state MovingToContainerDestination;
	state GettingContainer;
	state PuttingContainer;

	state Initialize{
		return Nothing;
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

	state MovingToContainerSource{
		int nPosX;
		int nPosY;
		int nPosZ;

		if(IsMoving()){
			return MovingToContainerSource;
		}
		nPosX=GetLocationX();
		nPosY=GetLocationY();
		nPosZ=GetLocationZ();
		if((nPosX==m_nCurrPutGetX) && (nPosY==m_nCurrPutGetY) && (nPosZ==m_nCurrPutGetZ)){
			if(nGetContainerFrom==MINE){
				CallGetContainer();
			}else{ //nGetContainerFrom==SINGLE_CONTAINER;
				CallGetSingleContainer(m_nContainerX, m_nContainerY, m_nContainerZ);
			}
			return GettingContainer;
		}
		CallMoveToPointForce(m_nCurrPutGetX, m_nCurrPutGetY, m_nCurrPutGetZ);
		return MovingToContainerSource;
	}

	state MovingToContainerDestination{
		int nPosX;
		int nPosY;
		int nPosZ;

		if(IsMoving()){
			return MovingToContainerDestination;
		}
		nPosX=GetLocationX();
		nPosY=GetLocationY();
		nPosZ=GetLocationZ();
		if((nPosX==m_nCurrPutGetX) && (nPosY==m_nCurrPutGetY) && (nPosZ==m_nCurrPutGetZ)){
			CallPutContainer();
			return PuttingContainer;
		}
		CallMoveToPointForce(m_nCurrPutGetX, m_nCurrPutGetY, m_nCurrPutGetZ);
		return MovingToContainerDestination;
	}

	state GettingContainer{
		unit uBuilding;
		unit uContainer;
		if(IsGettingContainer()){
			return GettingContainer;
		}
		if(HaveContainer()){
			if(nGetContainerFrom==SINGLE_CONTAINER){
				uContainer=FindSingleContainer();
				if(uContainer){
					m_nContainerX=uContainer.GetLocationX();
					m_nContainerY=uContainer.GetLocationY();
					m_nContainerZ=uContainer.GetLocationZ();
					nGetContainerFrom=SINGLE_CONTAINER;
				}else{
					nGetContainerFrom=MINE;
				}
			}
			if(GetDestinationBuilding()!=null){
				m_nCurrPutGetX=GetDestinationBuildingPutLocationX();
				m_nCurrPutGetY=GetDestinationBuildingPutLocationY();
				m_nCurrPutGetZ=GetDestinationBuildingPutLocationZ();
				CallMoveToPointForce(m_nCurrPutGetX, m_nCurrPutGetY, m_nCurrPutGetZ);
				return MovingToContainerDestination;
			}
			uBuilding=FindContainerRefineryBuilding();
			if(uBuilding!=null){
				SetDestinationBuilding(uBuilding);
				m_nCurrPutGetX=GetDestinationBuildingPutLocationX();
				m_nCurrPutGetY=GetDestinationBuildingPutLocationY();
				m_nCurrPutGetZ=GetDestinationBuildingPutLocationZ();
				CallMoveToPointForce(m_nCurrPutGetX, m_nCurrPutGetY, m_nCurrPutGetZ);
				return MovingToContainerDestination;
			}
			return Nothing;
		}
		if(nGetContainerFrom==MINE){
			uBuilding=GetSourceBuilding();//aby sie upewnic czy zabity (i skasowac referencje w kodzie)
			if(uBuilding==null){
				uBuilding=FindContainerMineBuilding();
			}
			if(uBuilding!=null){
				SetSourceBuilding(uBuilding);
				m_nCurrPutGetX=GetSourceBuildingTakeLocationX();
				m_nCurrPutGetY=GetSourceBuildingTakeLocationY();
				m_nCurrPutGetZ=GetSourceBuildingTakeLocationZ();
				nGetContainerFrom=MINE;
				CallMoveToPointForce(m_nCurrPutGetX, m_nCurrPutGetY, m_nCurrPutGetZ);
				return MovingToContainerSource;
			}
			uContainer=FindSingleContainer();
			if(uContainer){
				m_nContainerX=uContainer.GetLocationX();
				m_nContainerY=uContainer.GetLocationY();
				m_nContainerZ=uContainer.GetLocationZ();
				m_nCurrPutGetX=GetContainerTakeLocationX(m_nContainerX, m_nContainerY, m_nContainerZ);
				m_nCurrPutGetY=GetContainerTakeLocationY(m_nContainerX, m_nContainerY, m_nContainerZ);
				m_nCurrPutGetZ=GetContainerTakeLocationZ(m_nContainerX, m_nContainerY, m_nContainerZ);
				nGetContainerFrom=SINGLE_CONTAINER;
				CallMoveToPointForce(m_nCurrPutGetX, m_nCurrPutGetY, m_nCurrPutGetZ);
				return MovingToContainerSource;
			}
			return Nothing;
		}
		//nGetContainerFrom==SINGLE_CONTAINER;
		uContainer=FindSingleContainer();
		if(uContainer){
			m_nContainerX=uContainer.GetLocationX();
			m_nContainerY=uContainer.GetLocationY();
			m_nContainerZ=uContainer.GetLocationZ();
			m_nCurrPutGetX=GetContainerTakeLocationX(m_nContainerX, m_nContainerY, m_nContainerZ);
			m_nCurrPutGetY=GetContainerTakeLocationY(m_nContainerX, m_nContainerY, m_nContainerZ);
			m_nCurrPutGetZ=GetContainerTakeLocationZ(m_nContainerX, m_nContainerY, m_nContainerZ);
			nGetContainerFrom=SINGLE_CONTAINER;
			CallMoveToPointForce(m_nCurrPutGetX, m_nCurrPutGetY, m_nCurrPutGetZ);
			return MovingToContainerSource;
		}
		uBuilding=GetSourceBuilding();
		if(uBuilding==null){
			uBuilding=FindContainerMineBuilding();
		}
		if(uBuilding!=null){
			SetSourceBuilding(uBuilding);
			m_nCurrPutGetX=GetSourceBuildingTakeLocationX();
			m_nCurrPutGetY=GetSourceBuildingTakeLocationY();
			m_nCurrPutGetZ=GetSourceBuildingTakeLocationZ();
			nGetContainerFrom=MINE;
			CallMoveToPointForce(m_nCurrPutGetX, m_nCurrPutGetY, m_nCurrPutGetZ);
			return MovingToContainerSource;
		}
		return Nothing;
	}

	state PuttingContainer{
		unit uBuilding;
		unit uContainer;
		if(IsPuttingContainer()){
			return PuttingContainer;
		}
		if(!HaveContainer()){
			if((nGetContainerFrom==SINGLE_CONTAINER) && IsContainerInPoint(m_nContainerX, m_nContainerY, m_nContainerZ)){
				nGetContainerFrom=SINGLE_CONTAINER;
				m_nCurrPutGetX=GetContainerTakeLocationX(m_nContainerX, m_nContainerY, m_nContainerZ);
				m_nCurrPutGetY=GetContainerTakeLocationY(m_nContainerX, m_nContainerY, m_nContainerZ);
				m_nCurrPutGetZ=GetContainerTakeLocationZ(m_nContainerX, m_nContainerY, m_nContainerZ);
				CallMoveToPointForce(m_nCurrPutGetX, m_nCurrPutGetY, m_nCurrPutGetZ);
				return MovingToContainerSource;
			}
			if(GetSourceBuilding()!=null){
				m_nCurrPutGetX=GetSourceBuildingTakeLocationX();
				m_nCurrPutGetY=GetSourceBuildingTakeLocationY();
				m_nCurrPutGetZ=GetSourceBuildingTakeLocationZ();
				nGetContainerFrom=MINE;
				CallMoveToPointForce(m_nCurrPutGetX, m_nCurrPutGetY, m_nCurrPutGetZ);
				return MovingToContainerSource;
			}
			uBuilding=FindContainerMineBuilding();
			if(uBuilding!=null){
				SetSourceBuilding(uBuilding);
				m_nCurrPutGetX=GetSourceBuildingTakeLocationX();
				m_nCurrPutGetY=GetSourceBuildingTakeLocationY();
				m_nCurrPutGetZ=GetSourceBuildingTakeLocationZ();
				nGetContainerFrom=MINE;
				CallMoveToPointForce(m_nCurrPutGetX, m_nCurrPutGetY, m_nCurrPutGetZ);
				return MovingToContainerSource;
			}
			uContainer=FindSingleContainer();
			if(uContainer){
				m_nContainerX=uContainer.GetLocationX();
				m_nContainerY=uContainer.GetLocationY();
				m_nContainerZ=uContainer.GetLocationZ();
				m_nCurrPutGetX=GetContainerTakeLocationX(m_nContainerX, m_nContainerY, m_nContainerZ);
				m_nCurrPutGetY=GetContainerTakeLocationY(m_nContainerX, m_nContainerY, m_nContainerZ);
				m_nCurrPutGetZ=GetContainerTakeLocationZ(m_nContainerX, m_nContainerY, m_nContainerZ);
				nGetContainerFrom=SINGLE_CONTAINER;
				CallMoveToPointForce(m_nCurrPutGetX, m_nCurrPutGetY, m_nCurrPutGetZ);
				return MovingToContainerSource;
			}
			return Nothing;
		}
		uBuilding=GetDestinationBuilding();
		if(uBuilding==null){
			uBuilding=FindContainerRefineryBuilding();
		}
		if(uBuilding!=null){
			SetDestinationBuilding(uBuilding);
			m_nCurrPutGetX=GetDestinationBuildingPutLocationX();
			m_nCurrPutGetY=GetDestinationBuildingPutLocationY();
			m_nCurrPutGetZ=GetDestinationBuildingPutLocationZ();
			CallMoveToPointForce(m_nCurrPutGetX, m_nCurrPutGetY, m_nCurrPutGetZ);
			return MovingToContainerDestination;
		}
		return Nothing;
	}

	state Froozen{
		if(IsFroozen()){
			state Froozen;
		}else{
			state Nothing;
		}
	}

	event OnFreezeForSupplyOrRepair(int nFreezeTicks){
		CallFreeze(nFreezeTicks);
		state Froozen;
		true;
	}

	command Initialize(){
		nGetContainerFrom=MINE;
		SetCannonFireMode(-1, 1);
		false;
	}

	command Uninitialize(){
		SetDestinationBuilding(null);
		SetSourceBuilding(null);
		false;
	}

	command SetContainerSource(unit uTarget) hidden button "translateCommandSetMine"{
		SetSourceBuilding(uTarget);
		nGetContainerFrom=MINE;
		if(!HaveContainer()){
			m_nCurrPutGetX=GetSourceBuildingTakeLocationX();
			m_nCurrPutGetY=GetSourceBuildingTakeLocationY();
			m_nCurrPutGetZ=GetSourceBuildingTakeLocationZ();
			CallMoveToPointForce(m_nCurrPutGetX, m_nCurrPutGetY, m_nCurrPutGetZ);
			state MovingToContainerSource;
		}else{
			if(GetDestinationBuilding()!=null){
				m_nCurrPutGetX=GetDestinationBuildingPutLocationX();
				m_nCurrPutGetY=GetDestinationBuildingPutLocationY();
				m_nCurrPutGetZ=GetDestinationBuildingPutLocationZ();
				CallMoveToPointForce(m_nCurrPutGetX, m_nCurrPutGetY, m_nCurrPutGetZ);
				state MovingToContainerDestination;
			}
		}
		NextCommand(true);
		true;
	}

	command GetSingleContainer(unit uTarget) hidden button "translateCommandGetContainer"{
		m_nContainerX=uTarget.GetLocationX();
		m_nContainerY=uTarget.GetLocationY();
		m_nContainerZ=uTarget.GetLocationZ();
		nGetContainerFrom=SINGLE_CONTAINER;
		if(!HaveContainer()){
			m_nCurrPutGetX=GetContainerTakeLocationX(m_nContainerX, m_nContainerY, m_nContainerZ);
			m_nCurrPutGetY=GetContainerTakeLocationY(m_nContainerX, m_nContainerY, m_nContainerZ);
			m_nCurrPutGetZ=GetContainerTakeLocationZ(m_nContainerX, m_nContainerY, m_nContainerZ);
			CallMoveToPointForce(m_nCurrPutGetX, m_nCurrPutGetY, m_nCurrPutGetZ);
			state MovingToContainerSource;
		}else{
			if(GetDestinationBuilding()!=null){
				m_nCurrPutGetX=GetDestinationBuildingPutLocationX();
				m_nCurrPutGetY=GetDestinationBuildingPutLocationY();
				m_nCurrPutGetZ=GetDestinationBuildingPutLocationZ();
				CallMoveToPointForce(m_nCurrPutGetX, m_nCurrPutGetY, m_nCurrPutGetZ);
				state MovingToContainerDestination;
			}
		}
		NextCommand(true);
		true;
	}

	command SetContainerDestination(unit uTarget) hidden button "translateCommandSetRefinery"{
		SetDestinationBuilding(uTarget);
		if(HaveContainer()){
			m_nCurrPutGetX=GetDestinationBuildingPutLocationX();
			m_nCurrPutGetY=GetDestinationBuildingPutLocationY();
			m_nCurrPutGetZ=GetDestinationBuildingPutLocationZ();
			CallMoveToPointForce(m_nCurrPutGetX, m_nCurrPutGetY, m_nCurrPutGetZ);
			state MovingToContainerDestination;
		}else{
			if(GetSourceBuilding()!=null){
				m_nCurrPutGetX=GetSourceBuildingTakeLocationX();
				m_nCurrPutGetY=GetSourceBuildingTakeLocationY();
				m_nCurrPutGetZ=GetSourceBuildingTakeLocationZ();
				nGetContainerFrom=MINE;
				CallMoveToPointForce(m_nCurrPutGetX, m_nCurrPutGetY, m_nCurrPutGetZ);
				state MovingToContainerSource;
			}
		}
		NextCommand(true);
		true;
	}

	command Move(int nGx, int nGy, int nLz) button "translateCommandMove" description "translateCommandMoveDescription" hotkey priority 21{
		m_nMoveToX=nGx;
		m_nMoveToY=nGy;
		m_nMoveToZ=nLz;
		CallMoveToPoint(m_nMoveToX, m_nMoveToY, m_nMoveToZ);
		state StartMoving;
		true;
	}

	command Enter(unit uEntrance) hidden button "translateCommandEnter"{
		m_nMoveToX=GetEntranceX(uEntrance);
		m_nMoveToY=GetEntranceY(uEntrance);
		m_nMoveToZ=GetEntranceZ(uEntrance);
		CallMoveInsideObject(uEntrance);
		state StartMoving;
		true;
	}

	command Stop() button "translateCommandStop" description "translateCommandStopDescription" hotkey priority 20{
		CallStopMoving();
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

	command SpecialChangeUnitsScript() button "translateCommandChangeScript" description "translateCommandChangeScriptDescription" hotkey priority 254{
		//special command - no implementation
	}
}
