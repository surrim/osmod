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

repairer "translateScriptNameRepairer"{
	consts{
		//comboLights
		LIGHTS_AUTO = 0;
		LIGHTS_ON   = 1;
		LIGHTS_OFF  = 2;

		//comboAutoRepairMode
		AUTOREPAIR_OFF = 0;
		AUTOREPAIR_ON = 1;

		//comboAutoUpgradeMode
		AUTOUPGRADE_OFF = 0;
		AUTOUPGRADE_ON = 1;

		//comboAutoCaptureMode
		AUTOCAPTURE_OFF = 0;
		AUTOCAPTURE_ON = 1;

		MAX_DISTANCE_FOR_AUTOMODE = 8;

		//nOperation
		OPERATION_REPAIR  = 0;
		OPERATION_CAPTURE = 1;
		OPERATION_REPAINT = 2;
		OPERATION_UPGRADE = 3;
	}

	int nMoveToX;
	int nMoveToY;
	int nMoveToZ;
	unit uTarget;
	int nOperation;
	int nRepaintSideColor;
	int nStayX;
	int nStayY;
	int nStayZ;

	enum comboLights{
		"translateCommandStateLightsAUTO", //LIGHTS_AUTO
		"translateCommandStateLightsON",   //LIGHTS_ON
		"translateCommandStateLightsOFF",  //LIGHTS_OFF
	multi:
		"translateCommandStateLightsMode"
	}

	enum comboAutoRepairMode{
		"translateCommandStateDontRepair", //AUTOREPAIR_OFF
		"translateCommandStateAutoRepair", //AUTOREPAIR_ON
	multi:
		"translateCommandStateRepairMode"
	}

	enum comboAutoCaptureMode{
		"translateCommandStateDontCapture", //AUTOCAPTURE_OFF
		"translateCommandStateAutoCapture", //AUTOCAPTURE_ON
	multi:
		"translateCommandStateCaptureMode"
	}

	enum comboAutoUpgradeMode{
		"*Upgrade Off", //AUTOUPGRADE_OFF
		"*AutoUpgrade", //AUTOUPGRADE_ON
	multi:
		"? Upgrade"
	}

	function int SetTarget(unit uNewTarget){
		uTarget=uNewTarget;
		SetTargetObject(uTarget);
	}

	function int FindTargetToRepair(){
		int i;
		int nTargetsCount;
		unit uNewTarget;

		BuildTargetsArray(findTargetWaterUnit|findTargetNormalUnit|findTargetBuildingUnit, findAllyUnit|findOurUnit, findDestinationAnyUnit);
		nTargetsCount=GetTargetsCount();
		if(nTargetsCount){
			SortFoundTargetsArray();
			StartEnumTargetsArray();
			for(i=0;i<nTargetsCount;++i){
				uNewTarget=GetNextTarget();

				if(CanBeRepaired(uNewTarget) && (DistanceTo(uNewTarget.GetLocationX(), uNewTarget.GetLocationY())<MAX_DISTANCE_FOR_AUTOMODE)){
					nMoveToX=GetOperateOnTargetLocationX(uNewTarget);
					nMoveToY=GetOperateOnTargetLocationY(uNewTarget);
					nMoveToZ=GetOperateOnTargetLocationZ(uNewTarget);

					if(IsGoodPointForOperateOnTarget(uNewTarget,nMoveToX,nMoveToY,nMoveToZ)){
						EndEnumTargetsArray();
						SetTarget(uNewTarget);
						return true;
					}
				}
			}
			EndEnumTargetsArray();
		}
		return false;
	}

	function int FindTargetToCapture(){
		int i;
		int nTargetsCount;
		unit uNewTarget;

		BuildTargetsArray(findTargetWaterUnit|findTargetNormalUnit|findTargetBuildingUnit, findEnemyUnit,findDestinationAnyUnit);
		nTargetsCount=GetTargetsCount();

		if(nTargetsCount){
			SortFoundTargetsArray();
			StartEnumTargetsArray();
			for(i=0;i<nTargetsCount;++i){
				uNewTarget=GetNextTarget();
				if(CanBeConverted(uNewTarget) && (DistanceTo(uNewTarget.GetLocationX(), uNewTarget.GetLocationY())<MAX_DISTANCE_FOR_AUTOMODE)){
					nMoveToX=GetOperateOnTargetLocationX(uNewTarget);
					nMoveToY=GetOperateOnTargetLocationY(uNewTarget);
					nMoveToZ=GetOperateOnTargetLocationZ(uNewTarget);

					if(IsGoodPointForOperateOnTarget(uNewTarget, GetOperateOnTargetLocationX(uNewTarget), GetOperateOnTargetLocationY(uNewTarget), GetOperateOnTargetLocationZ(uNewTarget))){
						EndEnumTargetsArray();
						SetTarget(uNewTarget);
						return true;
					}
				}
			}
			EndEnumTargetsArray();
		}
		return false;
	}

	function int FindTargetToUpgrade(){
		int i;
		int nTargetsCount;
		unit uNewTarget;

		BuildTargetsArray(findTargetWaterUnit|findTargetNormalUnit|findTargetBuildingUnit, findAllyUnit|findOurUnit, findDestinationAnyUnit);
		nTargetsCount=GetTargetsCount();
		if(nTargetsCount){
			SortFoundTargetsArray();
			StartEnumTargetsArray();
			for(i=0;i<nTargetsCount;++i){
				uNewTarget=GetNextTarget();
				if(CanBeUpgraded(uNewTarget) && (DistanceTo(uNewTarget.GetLocationX(), uNewTarget.GetLocationY())<MAX_DISTANCE_FOR_AUTOMODE)){
					nMoveToX=GetOperateOnTargetLocationX(uNewTarget);
					nMoveToY=GetOperateOnTargetLocationY(uNewTarget);
					nMoveToZ=GetOperateOnTargetLocationZ(uNewTarget);

					if(IsGoodPointForOperateOnTarget(uNewTarget, GetOperateOnTargetLocationX(uNewTarget), GetOperateOnTargetLocationY(uNewTarget), GetOperateOnTargetLocationZ(uNewTarget))){
						EndEnumTargetsArray();
						SetTarget(uNewTarget);
						return true;
					}
				}
			}
			EndEnumTargetsArray();
		}
		return false;
	}

	state Nothing;
	state Moving;
	state MovingToTarget;
	state Repairing;
	state Converting;
	state Repainting;
	state Upgrading;

	state Nothing{
		if(IsMoving()){
			return Nothing;
		}
		if(InPlatoon()){
			nStayX=GetLocationX();
			nStayY=GetLocationY();
			nStayZ=GetLocationZ();
		}

		if(comboAutoRepairMode==AUTOREPAIR_ON){
			if(FindTargetToRepair()){
				nOperation=OPERATION_REPAIR;
				CallMoveToPointForce(nMoveToX, nMoveToY, nMoveToZ);
				return MovingToTarget;
			}
		}
		if(comboAutoCaptureMode==AUTOCAPTURE_ON){
			if(FindTargetToCapture()){
				nOperation=OPERATION_CAPTURE;
				CallMoveToPointForce(nMoveToX, nMoveToY, nMoveToZ);
				return MovingToTarget;
			}
		}
		if(comboAutoUpgradeMode==AUTOUPGRADE_ON){
			if(FindTargetToUpgrade()){
				nOperation=OPERATION_UPGRADE;
				CallMoveToPointForce(nMoveToX, nMoveToY, nMoveToZ);
				return MovingToTarget;
			}
		}
		if(InPlatoon()){
			return Nothing;
		}

		if(nStayX && (GetLocationX()!=nStayX || GetLocationY()!=nStayY ||GetLocationZ()!=nStayZ)){
			SetTarget(null);
			nMoveToX=nStayX;
			nMoveToY=nStayY;
			nMoveToZ=nStayZ;
			CallMoveToPoint(nMoveToX, nMoveToY, nMoveToZ);
			return Moving;
		}
	}

	state Moving{
		if(IsMoving()){
			return Moving;
		}
		NextCommand(true);
		return Nothing;
	}

	state MovingToTarget{
		if(IsMoving()){
			if(
				!uTarget.IsFroozen() &&
				(nOperation==OPERATION_REPAIR && CanBeRepaired(uTarget)) ||
				(nOperation==OPERATION_CAPTURE && CanBeConverted(uTarget)) ||
				(nOperation==OPERATION_REPAINT && CanBeRepainted(uTarget)) ||
				(nOperation==OPERATION_UPGRADE && CanBeUpgraded(uTarget))
			){
				if(!IsGoodPointForOperateOnTarget(uTarget, nMoveToX, nMoveToY, nMoveToZ)){ //target has moved
					nMoveToX=GetOperateOnTargetLocationX(uTarget);
					nMoveToY=GetOperateOnTargetLocationY(uTarget);
					nMoveToZ=GetOperateOnTargetLocationZ(uTarget);
					if(IsGoodPointForOperateOnTarget(uTarget, nMoveToX, nMoveToY, nMoveToZ)){
						CallMoveToPointForce(nMoveToX, nMoveToY, nMoveToZ);
						return MovingToTarget;
					}
					//unable to find operation point for target
					nOperation=OPERATION_REPAIR;
					CallStopMoving();
					SetTarget(null);
					NextCommand(true);
					return Nothing;
				}
			}else{
				nOperation=OPERATION_REPAIR;
				CallStopMoving();
				SetTarget(null);
				NextCommand(true);
				return Nothing;
			}
			return MovingToTarget;
		}
		if(IsInGoodPointForOperateOnTarget(uTarget)){
			if(nOperation==OPERATION_REPAIR){
				if(CanBeRepaired(uTarget)){
					CallRepair(uTarget);
					return Repairing;
				}
				SetTarget(null);
				NextCommand(true);
				return Nothing;
			}
			if(nOperation==OPERATION_CAPTURE){
				if(CanBeConverted(uTarget)){
					CallConvert(uTarget);
					return Converting;
				}
				SetTarget(null);
				NextCommand(true);
				return Nothing;
			}
			if(nOperation==OPERATION_REPAINT){
				if(CanBeRepainted(uTarget)){
					CallRepaint(uTarget, nRepaintSideColor);
					return Repainting;
				}
				SetTarget(null);
				NextCommand(true);
				return Nothing;
			}
			//assert nOperation==OPERATION_UPGRADE;
			if(CanBeUpgraded(uTarget)){
				CallUpgrade(uTarget);
				return Upgrading;
			}
			SetTarget(null);
			NextCommand(true);
			return Nothing;
		}
		nMoveToX=GetOperateOnTargetLocationX(uTarget);
		nMoveToY=GetOperateOnTargetLocationY(uTarget);
		nMoveToZ=GetOperateOnTargetLocationZ(uTarget);
		if(IsGoodPointForOperateOnTarget(uTarget, nMoveToX, nMoveToY, nMoveToZ)){
			CallMoveToPointForce(nMoveToX, nMoveToY, nMoveToZ);
			return MovingToTarget;
		}
		//unable to find operation point for target
		nOperation=OPERATION_REPAIR;
		CallStopMoving();
		SetTarget(null);
		NextCommand(true);
		return Nothing;
	}

	state Repairing{
		if(IsRepairing()){
			return Repairing, 5;
		}
		if(CanBeRepaired(uTarget)){
			nMoveToX=GetOperateOnTargetLocationX(uTarget);
			nMoveToY=GetOperateOnTargetLocationY(uTarget);
			nMoveToZ=GetOperateOnTargetLocationZ(uTarget);
			CallMoveToPointForce(nMoveToX, nMoveToY, nMoveToZ);
			return MovingToTarget;
		}
		SetTarget(null);
		NextCommand(true);
		return Nothing;
	}

	state Converting{
		if(IsConverting()){
			return Converting, 5;
		}
		if(CanBeConverted(uTarget)){
			nMoveToX=GetOperateOnTargetLocationX(uTarget);
			nMoveToY=GetOperateOnTargetLocationY(uTarget);
			nMoveToZ=GetOperateOnTargetLocationZ(uTarget);
			CallMoveToPointForce(nMoveToX, nMoveToY, nMoveToZ);
			return MovingToTarget;
		}
		SetTarget(null);
		NextCommand(true);
		return Nothing;
	}

	state Repainting{
		if(IsRepainting()){
			return Repainting, 5;
		}
		if(uTarget.IsLive() && (uTarget.GetSideColor()!=nRepaintSideColor)){
			nMoveToX=GetOperateOnTargetLocationX(uTarget);
			nMoveToY=GetOperateOnTargetLocationY(uTarget);
			nMoveToZ=GetOperateOnTargetLocationZ(uTarget);
			CallMoveToPointForce(nMoveToX, nMoveToY, nMoveToZ);
			return MovingToTarget;
		}
		SetTarget(null);
		NextCommand(true);
		return Nothing;
	}

	state Upgrading{
		if(IsUpgrading()){
			return Upgrading, 5;
		}
		if(uTarget.IsLive() && CanBeUpgraded(uTarget)){
			nMoveToX=GetOperateOnTargetLocationX(uTarget);
			nMoveToY=GetOperateOnTargetLocationY(uTarget);
			nMoveToZ=GetOperateOnTargetLocationZ(uTarget);
			CallMoveToPointForce(nMoveToX, nMoveToY, nMoveToZ);
			return MovingToTarget;
		}
		SetTarget(null);
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
		int nColor;
		int nMaxColor;

		nMaxColor=GetMaxSideColor();
		nRepaintSideColor=GetSideColor();
		for(nColor=nRepaintSideColor+1;nColor<=nMaxColor;nColor=nColor+1){
			if(IsPlayer(nColor)){
				nRepaintSideColor=nColor;
				break;
			}
		}
		if(nColor>nMaxColor){
			for(nColor=0;nColor<nRepaintSideColor;++nColor){
				if(IsPlayer(nColor)){
					nRepaintSideColor=nColor;
					break;
				}
			}
		}
		SetRepaintSideColor(nRepaintSideColor);
		comboAutoRepairMode=AUTOREPAIR_ON;
		comboAutoUpgradeMode=AUTOUPGRADE_ON;
		comboAutoCaptureMode=AUTOCAPTURE_ON;
		false;
	}

	command Uninitialize(){
		SetTarget(null);
		false;
	}

	command Repair(unit uUnitToRepair) hidden button "translateCommandRepair"{
		if(CanBeRepaired(uUnitToRepair)){
			nOperation=OPERATION_REPAIR;
			SetTarget(uUnitToRepair);
			nMoveToX=GetOperateOnTargetLocationX(uTarget);
			nMoveToY=GetOperateOnTargetLocationY(uTarget);
			nMoveToZ=GetOperateOnTargetLocationZ(uTarget);
			CallMoveToPointForce(nMoveToX, nMoveToY, nMoveToZ);
			state MovingToTarget;
		}else{
			NextCommand(false);
		}
		true;
	}

	command Convert(unit uUnitToConvert) hidden button "translateCommandCapture"{
		if(CanBeConverted(uUnitToConvert)){
			nOperation=OPERATION_CAPTURE;
			SetTarget(uUnitToConvert);
			nMoveToX=GetOperateOnTargetLocationX(uTarget);
			nMoveToY=GetOperateOnTargetLocationY(uTarget);
			nMoveToZ=GetOperateOnTargetLocationZ(uTarget);
			CallMoveToPointForce(nMoveToX, nMoveToY, nMoveToZ);
			state MovingToTarget;
		}else{
			NextCommand(false);
		}
		true;
	}

	command Repaint(unit uUnitToRepaint) button "translateCommandRepaint" description "translateCommandRepaintDescription" hotkey priority 100{
		if(CanBeRepainted(uUnitToRepaint)){
			nOperation=OPERATION_REPAINT;
			SetTarget(uUnitToRepaint);
			nMoveToX=GetOperateOnTargetLocationX(uTarget);
			nMoveToY=GetOperateOnTargetLocationY(uTarget);
			nMoveToZ=GetOperateOnTargetLocationZ(uTarget);
			CallMoveToPointForce(nMoveToX, nMoveToY, nMoveToZ);
			state MovingToTarget;
		}else{
			NextCommand(false);
		}
		true;
	}

	command Upgrade(unit uUnitToUpgrade) button "translateCommandUpgrade" description "translateCommandUpgradeDescription" hotkey priority 99{
		if(CanBeUpgraded(uUnitToUpgrade)){
			nOperation=OPERATION_UPGRADE;
			SetTarget(uUnitToUpgrade);
			nMoveToX=GetOperateOnTargetLocationX(uTarget);
			nMoveToY=GetOperateOnTargetLocationY(uTarget);
			nMoveToZ=GetOperateOnTargetLocationZ(uTarget);
			CallMoveToPointForce(nMoveToX, nMoveToY, nMoveToZ);
			state MovingToTarget;
		}else{
			NextCommand(false);
		}
		true;
	}

	command SetRepaintSideColor(int nNewSideColor) hidden button "translateCommandSetColor"{
		nRepaintSideColor=nNewSideColor;
		SetRepaintSideColor(nRepaintSideColor);
		NextCommand(true);
		true;
	}

	command SpecialSetRepaintSideColorDialog() button "translateCommandSetColor" description "translateCommandSetColorDescription" hotkey priority 101{
		//specjalna komenda obslugiwana przez dialog
	}

	command Move(int nGx, int nGy, int nLz) hidden button "translateCommandMove" description "translateCommandMoveDescription" hotkey priority 21{
		SetTarget(null);
		nMoveToX=nGx;
		nMoveToY=nGy;
		nMoveToZ=nLz;
		nStayX=nGx;
		nStayY=nGy;
		nStayZ=nLz;

		CallMoveToPoint(nMoveToX, nMoveToY, nMoveToZ);
		state Moving;
		true;
	}

	command Enter(unit uEntrance) hidden button "translateCommandEnter"{
		SetTarget(null);
		nMoveToX=GetEntranceX(uEntrance);
		nMoveToY=GetEntranceY(uEntrance);
		nMoveToZ=GetEntranceZ(uEntrance);
		CallMoveInsideObject(uEntrance);
		state Moving;
		true;
	}

	command Stop() button "translateCommandStop" description "translateCommandStopDescription" hotkey priority 20{
		SetTarget(null);
		CallStopMoving();
		state Nothing;
		true;
	}

	command SetRepairMode(int nMode) button comboAutoRepairMode description "translateCommandStateRepairModeDescription" priority 190{
		if(nMode==-1){
			comboAutoRepairMode=(comboAutoRepairMode+1)%2;
		}else{
			comboAutoRepairMode=nMode;
		}
	}

	command SetUpgradeMode(int nMode) button comboAutoUpgradeMode priority 191{
		if(nMode==-1){
			comboAutoUpgradeMode=(comboAutoUpgradeMode+1)%2;
		}else{
			comboAutoUpgradeMode=nMode;
		}
	}


	command SetConvertMode(int nMode) button comboAutoCaptureMode description "translateCommandStateCaptureModeDescription" priority 192{
		if(nMode==-1){
			comboAutoCaptureMode=(comboAutoCaptureMode+1)%2;
		}else{
			comboAutoCaptureMode=nMode;
		}
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
