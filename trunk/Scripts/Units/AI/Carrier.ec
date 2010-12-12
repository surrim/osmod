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

carrier "translateScriptNameContainerTransporter"{
	int m_nMoveToX;
	int m_nMoveToY;
	int m_nMoveToZ;
	int m_nCurrPutGetX;
	int m_nCurrPutGetY;
	int m_nCurrPutGetZ;
	int m_nContainerX;
	int m_nContainerY;
	int m_nContainerZ;
	int m_nGetContainerFrom; //0 - mine, 1 - single container

	enum lights{
		"translateCommandStateLightsAUTO",
		"translateCommandStateLightsON",
		"translateCommandStateLightsOFF",
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
			if(m_nGetContainerFrom==0){
				CallGetContainer();
			}else{
				assert m_nGetContainerFrom==1;
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
			if(m_nGetContainerFrom==1){
				uContainer=FindSingleContainer();
				if(uContainer){
					m_nContainerX=uContainer.GetLocationX();
					m_nContainerY=uContainer.GetLocationY();
					m_nContainerZ=uContainer.GetLocationZ();
					m_nGetContainerFrom=1;
				}else{
					m_nGetContainerFrom=0;
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
		if(m_nGetContainerFrom==0){
			uBuilding=GetSourceBuilding();//aby sie upewnic czy zabity (i skasowac referencje w kodzie)
			if(uBuilding==null){
				uBuilding=FindContainerMineBuilding();
			}
			if(uBuilding!=null){
				SetSourceBuilding(uBuilding);
				m_nCurrPutGetX=GetSourceBuildingTakeLocationX();
				m_nCurrPutGetY=GetSourceBuildingTakeLocationY();
				m_nCurrPutGetZ=GetSourceBuildingTakeLocationZ();
				m_nGetContainerFrom=0;
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
				m_nGetContainerFrom=1;
				CallMoveToPointForce(m_nCurrPutGetX, m_nCurrPutGetY, m_nCurrPutGetZ);
				return MovingToContainerSource;
			}
			return Nothing;
		}
		assert m_nGetContainerFrom==1;
		uContainer=FindSingleContainer();
		if(uContainer){
			m_nContainerX=uContainer.GetLocationX();
			m_nContainerY=uContainer.GetLocationY();
			m_nContainerZ=uContainer.GetLocationZ();
			m_nCurrPutGetX=GetContainerTakeLocationX(m_nContainerX, m_nContainerY, m_nContainerZ);
			m_nCurrPutGetY=GetContainerTakeLocationY(m_nContainerX, m_nContainerY, m_nContainerZ);
			m_nCurrPutGetZ=GetContainerTakeLocationZ(m_nContainerX, m_nContainerY, m_nContainerZ);
			m_nGetContainerFrom=1;
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
			m_nGetContainerFrom=0;
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
			if((m_nGetContainerFrom==1) && IsContainerInPoint(m_nContainerX, m_nContainerY, m_nContainerZ)){
				m_nGetContainerFrom=1;
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
				m_nGetContainerFrom=0;
				CallMoveToPointForce(m_nCurrPutGetX, m_nCurrPutGetY, m_nCurrPutGetZ);
				return MovingToContainerSource;
			}
			uBuilding=FindContainerMineBuilding();
			if(uBuilding!=null){
				SetSourceBuilding(uBuilding);
				m_nCurrPutGetX=GetSourceBuildingTakeLocationX();
				m_nCurrPutGetY=GetSourceBuildingTakeLocationY();
				m_nCurrPutGetZ=GetSourceBuildingTakeLocationZ();
				m_nGetContainerFrom=0;
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
				m_nGetContainerFrom=1;
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
		m_nGetContainerFrom=0;
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
		m_nGetContainerFrom=0;
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
		m_nGetContainerFrom=1;
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
				m_nGetContainerFrom=0;
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

	command SetLights(int nMode) button lights priority 204{
		if(nMode==-1){
			lights=(lights+1)%3;
		}else{
			assert(nMode==0);
			lights=nMode;
		}
		SetLightsMode(lights);
	}

	command SpecialChangeUnitsScript() button "translateCommandChangeScript" description "translateCommandChangeScriptDescription" hotkey priority 254{
		//special command - no implementation
	}
}
