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
	consts{
		//comboLights
		LIGHTS_AUTO = 0;
		LIGHTS_ON   = 1;
		LIGHTS_OFF  = 2;

		//nGetContainerFrom
		MINE             = 0;
		SINGLE_CONTAINER = 1;
	}

	int nMoveToX;
	int nMoveToY;
	int nMoveToZ;
	int nCurrPutGetX;
	int nCurrPutGetY;
	int nCurrPutGetZ;
	int nContainerX;
	int nContainerY;
	int nContainerZ;
	int nGetContainerFrom;
	int nState;

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
		//sprawdzic czy dojechalismy tam gdzie nalezalo
		if(nPosX==nCurrPutGetX && nPosY==nCurrPutGetY && nPosZ==nCurrPutGetZ){
			if(nGetContainerFrom==MINE){
				CallGetContainer();
			}else{
				CallGetSingleContainer(nContainerX, nContainerY, nContainerZ);
			}
			return GettingContainer;
		}
		//kazac mu tam znowu jechac (!moze jakis licznik zeby nie wywolywal w kolko)
		CallMoveToPointForce(nCurrPutGetX, nCurrPutGetY, nCurrPutGetZ);
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
		//sprawdzic czy dojechalismy tam gdzie nalezalo
		if((nPosX==nCurrPutGetX) && (nPosY==nCurrPutGetY) && (nPosZ==nCurrPutGetZ)){
			CallPutContainer();
			return PuttingContainer;
		}else{
			//kazac mu tam znowu jechac (!moze jakis licznik zeby nie wywolywal w kolko)
			CallMoveToPointForce(nCurrPutGetX, nCurrPutGetY, nCurrPutGetZ);
			return MovingToContainerDestination;
		}
	}

	state GettingContainer{
		unit uBuilding;
		unit uContainer;

		if(IsGettingContainer()){
			return GettingContainer;
		}
		if(HaveContainer()){
			//jesli biezemy pojedynczy kontener to teraz znalezc nastepny w poblizu
			if(nGetContainerFrom==SINGLE_CONTAINER){
				uContainer=FindSingleContainer();
				if(uContainer){
					nContainerX=uContainer.GetLocationX();
					nContainerY=uContainer.GetLocationY();
					nContainerZ=uContainer.GetLocationZ();
					nGetContainerFrom=SINGLE_CONTAINER;
				}else{
					//juz nie ma nastepnego w poblizu
					nGetContainerFrom=MINE;
				}
			}
			//pojechac do budynku przeznaczenia jesli jest
			if(GetDestinationBuilding()){
				nCurrPutGetX=GetDestinationBuildingPutLocationX();
				nCurrPutGetY=GetDestinationBuildingPutLocationY();
				nCurrPutGetZ=GetDestinationBuildingPutLocationZ();
				CallMoveToPointForce(nCurrPutGetX, nCurrPutGetY, nCurrPutGetZ);
				return MovingToContainerDestination;
			}
			//sprobowac znalezc ten budynek
			uBuilding=FindContainerRefineryBuilding();
			if(uBuilding){
				SetDestinationBuilding(uBuilding);
				nCurrPutGetX=GetDestinationBuildingPutLocationX();
				nCurrPutGetY=GetDestinationBuildingPutLocationY();
				nCurrPutGetZ=GetDestinationBuildingPutLocationZ();
				CallMoveToPointForce(nCurrPutGetX, nCurrPutGetY, nCurrPutGetZ);
				return MovingToContainerDestination;
			}
			//!!transportBase
			return Nothing;
		}
		//z jakiegos powodu nie wzielismy kontenera - poszukac nowej kopalni lub pojedynczego kontenera
		if(nGetContainerFrom==MINE){
			uBuilding=GetSourceBuilding();	//aby sie upewnic czy zabity (i skasowac referencje w kodzie)
			if(!uBuilding){
				//najpierw probujemy znalezc kopalnie
				uBuilding=FindContainerMineBuilding();
			}
			if(uBuilding){
				SetSourceBuilding(uBuilding);
				nCurrPutGetX=GetSourceBuildingTakeLocationX();
				nCurrPutGetY=GetSourceBuildingTakeLocationY();
				nCurrPutGetZ=GetSourceBuildingTakeLocationZ();
				nGetContainerFrom=MINE;
				CallMoveToPointForce(nCurrPutGetX, nCurrPutGetY, nCurrPutGetZ);
				return MovingToContainerSource;
			}
			//probujemy znalezc wolny kontener
			uContainer=FindSingleContainer();
			if(uContainer){
				nContainerX=uContainer.GetLocationX();
				nContainerY=uContainer.GetLocationY();
				nContainerZ=uContainer.GetLocationZ();
				nCurrPutGetX=GetContainerTakeLocationX(nContainerX, nContainerY, nContainerZ);
				nCurrPutGetY=GetContainerTakeLocationY(nContainerX, nContainerY, nContainerZ);
				nCurrPutGetZ=GetContainerTakeLocationZ(nContainerX, nContainerY, nContainerZ);
				nGetContainerFrom=SINGLE_CONTAINER;
				CallMoveToPointForce(nCurrPutGetX, nCurrPutGetY, nCurrPutGetZ);
				return MovingToContainerSource;
			}
			return Nothing;
		}
		//najpierw probujemy znalezc nastepny wolny kontener
		uContainer=FindSingleContainer();
		if(uContainer){
			nContainerX=uContainer.GetLocationX();
			nContainerY=uContainer.GetLocationY();
			nContainerZ=uContainer.GetLocationZ();
			nCurrPutGetX=GetContainerTakeLocationX(nContainerX, nContainerY, nContainerZ);
			nCurrPutGetY=GetContainerTakeLocationY(nContainerX, nContainerY, nContainerZ);
			nCurrPutGetZ=GetContainerTakeLocationZ(nContainerX, nContainerY, nContainerZ);
			nGetContainerFrom=SINGLE_CONTAINER;
			CallMoveToPointForce(nCurrPutGetX, nCurrPutGetY, nCurrPutGetZ);
			return MovingToContainerSource;
		}
		uBuilding=GetSourceBuilding();	//aby sie upewnic czy zabity (i skasowac referencje w kodzie)
		if(!uBuilding){
			//probujemy znalezc kopalnie
			uBuilding=FindContainerMineBuilding();
		}
		if(uBuilding){
			SetSourceBuilding(uBuilding);
			nCurrPutGetX=GetSourceBuildingTakeLocationX();
			nCurrPutGetY=GetSourceBuildingTakeLocationY();
			nCurrPutGetZ=GetSourceBuildingTakeLocationZ();
			nGetContainerFrom=MINE;
			CallMoveToPointForce(nCurrPutGetX, nCurrPutGetY, nCurrPutGetZ);
			return MovingToContainerSource;
		}
		//probujemy znalezc wolny kontener
		return Nothing;
	}

	state PuttingContainer{
		unit uBuilding;
		unit uContainer;

		if(IsPuttingContainer()){
			return PuttingContainer;
		}
		if(!HaveContainer()){
			//pojechac do kopalni lub po pojedynczy kontener
			if(nGetContainerFrom==SINGLE_CONTAINER && IsContainerInPoint(nContainerX, nContainerY, nContainerZ)){
				nCurrPutGetX=GetContainerTakeLocationX(nContainerX, nContainerY, nContainerZ);
				nCurrPutGetY=GetContainerTakeLocationY(nContainerX, nContainerY, nContainerZ);
				nCurrPutGetZ=GetContainerTakeLocationZ(nContainerX, nContainerY, nContainerZ);
				CallMoveToPointForce(nCurrPutGetX, nCurrPutGetY, nCurrPutGetZ);
				return MovingToContainerSource;
			}
			if(GetSourceBuilding()){
				nCurrPutGetX=GetSourceBuildingTakeLocationX();
				nCurrPutGetY=GetSourceBuildingTakeLocationY();
				nCurrPutGetZ=GetSourceBuildingTakeLocationZ();
				nGetContainerFrom=MINE;
				CallMoveToPointForce(nCurrPutGetX, nCurrPutGetY, nCurrPutGetZ);
				return MovingToContainerSource;
			}
			//probujemy znalezc kopalnie
			uBuilding=FindContainerMineBuilding();
			if(uBuilding){
				SetSourceBuilding(uBuilding);
				nCurrPutGetX=GetSourceBuildingTakeLocationX();
				nCurrPutGetY=GetSourceBuildingTakeLocationY();
				nCurrPutGetZ=GetSourceBuildingTakeLocationZ();
				nGetContainerFrom=MINE;
				CallMoveToPointForce(nCurrPutGetX, nCurrPutGetY, nCurrPutGetZ);
				return MovingToContainerSource;
			}
			//!!jeszcze transportBase
			//probujemy jeszcze znalezc wolny kontener
			uContainer=FindSingleContainer();
			if(uContainer){
				nContainerX=uContainer.GetLocationX();
				nContainerY=uContainer.GetLocationY();
				nContainerZ=uContainer.GetLocationZ();
				nCurrPutGetX=GetContainerTakeLocationX(nContainerX, nContainerY, nContainerZ);
				nCurrPutGetY=GetContainerTakeLocationY(nContainerX, nContainerY, nContainerZ);
				nCurrPutGetZ=GetContainerTakeLocationZ(nContainerX, nContainerY, nContainerZ);
				nGetContainerFrom=SINGLE_CONTAINER;
				CallMoveToPointForce(nCurrPutGetX, nCurrPutGetY, nCurrPutGetZ);
				return MovingToContainerSource;
			}
			return Nothing;
		}
		uBuilding=GetDestinationBuilding();	//aby sie upewnic czy zabity (i skasowac referencje w kodzie)
		if(!uBuilding){
			//z jakiegos powodu nie zdolalismy oddac kontenera - znalezc nowa rafinerie
			uBuilding=FindContainerRefineryBuilding();
		}
		if(uBuilding){
			SetDestinationBuilding(uBuilding);
			nCurrPutGetX=GetDestinationBuildingPutLocationX();
			nCurrPutGetY=GetDestinationBuildingPutLocationY();
			nCurrPutGetZ=GetDestinationBuildingPutLocationZ();
			CallMoveToPointForce(nCurrPutGetX, nCurrPutGetY, nCurrPutGetZ);
			return MovingToContainerDestination;
		}
		//!!transportBase
		return Nothing;
	}

	state Froozen{
		if(IsFroozen()){
			state Froozen;
		}else{
			//!!wrocic do tego co robilismy
			if(nState==1){
				CallMoveToPointForce(nCurrPutGetX, nCurrPutGetY, nCurrPutGetZ);
				state MovingToContainerDestination;
			}else{
				if(nState==2){
					CallMoveToPointForce(nCurrPutGetX, nCurrPutGetY, nCurrPutGetZ);
					state MovingToContainerSource;
				}else{
					if(nState==3){
						CallMoveToPoint(nMoveToX, nMoveToY, nMoveToZ);
						state StartMoving;
					}else{
						state Nothing;
					}
				}
			}
		}
	}

	event OnFreezeForSupplyOrRepair(int nFreezeTicks){
		if(state!=GettingContainer && state!=PuttingContainer){
			nState=0;
			if(state==MovingToContainerDestination){
				nState=1;
			}else if(state==MovingToContainerSource){
				nState=2;
			}else if(state==Moving){
				nState=3;
			}
			CallFreeze(nFreezeTicks);
			state Froozen;
		}
		true;
	}

	command Initialize(){
		nGetContainerFrom=MINE;
		//pozwolic dzialkom strzelac samym (o ile sa jakies)
		SetCannonFireMode(-1, 1);
		false;
	}

	command Uninitialize(){
		//wykasowac referencje
		SetDestinationBuilding(null);
		SetSourceBuilding(null);
		false;
	}

	/*bez nazwy - wywolywane po kliknieciu kursorem */
	command SetContainerSource(unit uTarget) hidden button "translateCommandSetMine"{
		SetSourceBuilding(uTarget);
		nGetContainerFrom=MINE;
		if(!HaveContainer()){
			nCurrPutGetX=GetSourceBuildingTakeLocationX();
			nCurrPutGetY=GetSourceBuildingTakeLocationY();
			nCurrPutGetZ=GetSourceBuildingTakeLocationZ();
			CallMoveToPointForce(nCurrPutGetX, nCurrPutGetY, nCurrPutGetZ);
			state MovingToContainerSource;
		}else{
			if(GetDestinationBuilding()){
				nCurrPutGetX=GetDestinationBuildingPutLocationX();
				nCurrPutGetY=GetDestinationBuildingPutLocationY();
				nCurrPutGetZ=GetDestinationBuildingPutLocationZ();
				CallMoveToPointForce(nCurrPutGetX, nCurrPutGetY, nCurrPutGetZ);
				state MovingToContainerDestination;
			}
		}
		NextCommand(true);
		true;
	}

	command GetSingleContainer(unit uTarget) hidden button "translateCommandGetContainer"{
		nContainerX=uTarget.GetLocationX();
		nContainerY=uTarget.GetLocationY();
		nContainerZ=uTarget.GetLocationZ();
		nGetContainerFrom=SINGLE_CONTAINER;
		if(!HaveContainer()){
			nCurrPutGetX=GetContainerTakeLocationX(nContainerX, nContainerY, nContainerZ);
			nCurrPutGetY=GetContainerTakeLocationY(nContainerX, nContainerY, nContainerZ);
			nCurrPutGetZ=GetContainerTakeLocationZ(nContainerX, nContainerY, nContainerZ);
			CallMoveToPointForce(nCurrPutGetX, nCurrPutGetY, nCurrPutGetZ);
			state MovingToContainerSource;
		}else{
			if(GetDestinationBuilding()){
				nCurrPutGetX=GetDestinationBuildingPutLocationX();
				nCurrPutGetY=GetDestinationBuildingPutLocationY();
				nCurrPutGetZ=GetDestinationBuildingPutLocationZ();
				CallMoveToPointForce(nCurrPutGetX, nCurrPutGetY, nCurrPutGetZ);
				state MovingToContainerDestination;
			}
		}
		NextCommand(true);
		true;
	}

	command SetContainerDestination(unit uTarget) hidden button "translateCommandSetRefinery"{
		SetDestinationBuilding(uTarget);
		if(HaveContainer()){
			nCurrPutGetX=GetDestinationBuildingPutLocationX();
			nCurrPutGetY=GetDestinationBuildingPutLocationY();
			nCurrPutGetZ=GetDestinationBuildingPutLocationZ();
			CallMoveToPointForce(nCurrPutGetX, nCurrPutGetY, nCurrPutGetZ);
			state MovingToContainerDestination;
		}else{
			if(GetSourceBuilding()){
				nCurrPutGetX=GetSourceBuildingTakeLocationX();
				nCurrPutGetY=GetSourceBuildingTakeLocationY();
				nCurrPutGetZ=GetSourceBuildingTakeLocationZ();
				nGetContainerFrom=MINE;
				CallMoveToPointForce(nCurrPutGetX, nCurrPutGetY, nCurrPutGetZ);
				state MovingToContainerSource;
			}
		}
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
