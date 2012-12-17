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

platoon "translateDefaultPlatoon"{
	consts{
		disableFire=0;
		enableFire=1;

		//comboLights
		LIGHTS_AUTO = 0;
		LIGHTS_ON   = 1;
		LIGHTS_OFF  = 2;
	}

	enum comboLights{
		"translateCommandStateLightsAUTO", //LIGHTS_AUTO
		"translateCommandStateLightsON",   //LIGHTS_ON
		"translateCommandStateLightsOFF",  //LIGHTS_OFF
	multi:
		"translateCommandStateLightsMode"
	}

	enum comboPlatoonType{
		"translateCommandPlatoonNormal",
		"translateCommandPlatoonDefensive",
	multi:
		"translateCommandPlatoonType"
	}

	unit uTarget;
	int nTargetX;
	int nTargetY;
	int nTargetZ;


	int bAuto;
	int nKeepFormationCounter;

	function int GoToPoint(){
		int nRangeMode;
		nRangeMode=IsPointInCannonRange(0, 0, nTargetX, nTargetY, nTargetZ);

		if(nRangeMode==inRangeGoodHit){ //in range
			if(IsMoving()){
				CallStopMoving();
			}
			return false;
		}
		CallMoveToPoint(nTargetX, nTargetY, nTargetZ);
		return true;
	}

	function int GoToTarget(){
		int nRangeMode;
		int i;

		for(i=0;i<GetUnitsCount();++i){
			nRangeMode=IsTargetInCannonRange(i,0, uTarget);
			if(nRangeMode!=notInRange){
				SetLeader(i);
				if(IsMoving()){
					CallStopMoving();
				}
				return false;
			}
		}
		CallMoveToPoint(uTarget.GetLocationX(), uTarget.GetLocationY(), uTarget.GetLocationZ());
		return true;
	}

	function int PrepareEnter(unit uEntrance){
		int i;
		punit member;
		EnableFeatures(platoonFreeUnits,true);
		for(i=0;i<GetUnitsCount();++i){
			member=GetUnit(i);
			member.CommandEnter(uEntrance);
		}
		if(GetType()==typeHelicopters){
			//musimy sie juz teraz skasowac bo inaczej nie da sie wleciec
			Dispose();
		}
	}

	function int PrepareAttack(unit uTargetToAttack){
		int i;
		punit member;
		EnableFeatures(platoonFreeUnits,true);
		for(i=0;i<GetUnitsCount();++i){
			member=GetUnit(i);
			member.CommandAttack(uTargetToAttack);
		}
	}

	function int EndAttack(){
		int i;
		punit member;
		EnableFeatures(platoonFreeUnits,false);
		for(i=0;i<GetUnitsCount();++i){
			member=GetUnit(i);
			member.CommandStop();
		}
	}

	function int PrepareMove(int x,int y){
		int i;
		punit member;
		EnableFeatures(platoonFreeUnits,true);
		for(i=0;i<GetUnitsCount();++i){
			member=GetUnit(i);
			member.CommandMove(x,y,0);
		}
	}

	function int PrepareStop(){
		int i;
		punit member;
		EnableFeatures(platoonFreeUnits,true);
		for(i=0;i<GetUnitsCount();++i){
			member=GetUnit(i);
			member.CommandStop();
		}
	}

	state Initialize;
	state Nothing;
	state Moving;
	state Attacking;
	state AttackingPoint;

	state Initialize{ //pluton jest w tym stanie dopuki nie zobaczy pierwszego wroga w tym stanie rozgladaja sie wszysy bo pluton moze byc rozproszony
		return Initialize;
	}

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

	state AttackingPoint{
		if(GoToPoint()){
			return AttackingPoint;
		}
		CannonFireGround(-1, -1, nTargetX, nTargetY, nTargetZ, 1);
		return AttackingPoint;
	}

	state Attacking{
		if(!bAuto){
			if(uTarget.IsLive()){
				PrepareAttack(uTarget);
				return Attacking,60;
			}
			EndAttack();
			NextCommand(true);
			return Nothing;
		}
		//--auto attack
		if(uTarget.IsLive()){
			if(bAuto && DistanceTo(uTarget.GetLocationX(), uTarget.GetLocationY())>22){
				uTarget=null;
				return Nothing;
			}
			if(GoToTarget()){
				return Attacking;
			}
			CannonFireToTarget(-1,-1, uTarget, -1);
			return Attacking,60;
		}
		//target not exist
		uTarget=null;
		if(IsMoving()){
			CallStopMoving();
		}
		NextCommand(true);
		return Nothing;
	}


	state Entering{
		return Entering;
	}

	state Frozen{
		if(IsFrozen()){
			return Frozen;
		}
		return Nothing;
	}

	command Initialize(){
		bAuto=false;
		SetCannonFireMode(-1, -1, enableFire);
		EnableFeatures(platoonHQDefense, false);
		EnableFeatures(platoonKeepFormation, true);
	}

	command Uninitialize(){
		//wykasowac referencje
		uTarget=null;
	}

	command Stop() button "translateCommandStop" description "translateCommandStopDescription" hotkey priority 20{
		uTarget=null;
		SetCannonFireMode(-1, -1, enableFire);
		EndAttack();
		CallStopMoving();
		EnableFeatures(platoonFreeUnits,false);
		if(GetType()==typeHelicopters){
			PrepareStop();
		}
		state Nothing;
	}

	command Move(int nGx, int nGy, int nLz) hidden button "translateCommandMove" description "translateCommandMoveDescription" hotkey priority 21{
		EndAttack();
		uTarget=null;
		SetCannonFireMode(-1,-1, enableFire);
		CallMoveToPoint(nGx, nGy, nLz);
		nTargetX=nGx;
		nTargetY=nGy;
		nTargetZ=nLz;
		EnableFeatures(platoonFreeUnits, false);
		if(GetType()==typeHelicopters){
			PrepareMove(nGx, nGy);
		}
		state Moving;
	}

	command Attack(unit uTargetToAttack) hidden button "translateCommandAttack" description "translateCommandAttackDescription" hotkey priority 22{
		bAuto=false;
		uTarget=uTargetToAttack;
		SetCannonFireMode(-1, -1, enableFire);
		PrepareAttack(uTargetToAttack);
		state Attacking;
	}

	command AttackOnPoint(int nX, int nY, int nZ) hidden button "translateCommandAttack"{
		bAuto=false;
		uTarget=null;
		nTargetX=nX;
		nTargetY=nY;
		nTargetZ=nZ;
		state AttackingPoint;
	}

	command SendSupplyRequest() button "translateCommandSupply" description "translateCommandSupplyDescription" hotkey priority 27{
		SendSupplyRequest(-1);
	}

	command RotateRigth()  button "translateCommandPlatoonTurnRight" description "translateCommandPlatoonTurnRightDescription" hotkey priority 30{
		EndAttack();
		Turn(64);
		nKeepFormationCounter=GetUnitsCount();
		if(!IsMoving()){
			CallStopMoving();
		}
	}

	command RotateLeft() button "translateCommandPlatoonTurnLeft" description "translateCommandPlatoonTurnLeftDescription" hotkey priority 31{
		EndAttack();
		Turn(-64);
		nKeepFormationCounter=GetUnitsCount();
		if(!IsMoving()){
			CallStopMoving();
		}
	}

	command UserNoParam2() button "translateCommandPlatoonFormLine" description "translateCommandPlatoonFormLineDescription" hotkey priority 32{
		int i;
		EndAttack();
		for(i=1;i<GetUnitsCount();++i){
			if(i%2){
				SetPosition(i, (i/2)+1, 0);
			}else{
				SetPosition(i, -(i/2), 0);
			}
		}
		nKeepFormationCounter=GetUnitsCount();
		if(!IsMoving()){
			CallStopMoving();
		}
	}

	command UserNoParam3() button "translateCommandPlatoonFormSquare" description "translateCommandPlatoonFormSquareDescription" hotkey priority 33{
		int i;
		int sqrt;

		EndAttack();
		//posortowac wedlug HP
		sqrt=1;
		while(sqrt*sqrt<GetUnitsCount()){
			sqrt=sqrt+1;
		}

		for(i=1;i<GetUnitsCount();++i){
			SetPosition(i, i%sqrt, i/sqrt);
		}
		if(!IsMoving()){
			CallStopMoving();
		}
	}

	command UserOneParam2(int nMode) button comboPlatoonType description "translateCommandPlatoonTypeDescription" hotkey priority 40{
		if(nMode==-1){
			comboPlatoonType=(comboPlatoonType+1)%2;
		}else{
			comboPlatoonType=nMode;
		}
		EnableFeatures(platoonHQDefense, comboPlatoonType);
	}

	command SetLights(int nMode) button comboLights description "translateCommandStateLightsModeDescription" hotkey priority 204{
		if(nMode==-1){
			comboLights=(comboLights+1)%3;
		}else{
			comboLights=nMode;
		}
		SetLightsMode(-1, comboLights);
		NextCommand(false);
	}

	command AddUnitToPlatoon(unit uUnit) button "translateCommandPlatoonAddUnit" description "translateCommandPlatoonAddUnitDescription" hotkey priority 220{
		AddUnitToPlatoon(uUnit);
		SetLightsMode(-1, comboLights);
		NextCommand(true);
	}

	command RemoveUnitFromPlatoon(unit uUnit) button "translateCommandPlatoonRemoveUnit" description "translateCommandPlatoonRemoveUnitDescription" hotkey priority 222{
		RemoveUnitFromPlatoon(uUnit);
		NextCommand(true);
	}

	command DisposePlatoon() button "translateCommandPlatoonDispose" description "translateCommandPlatoonDisposeDescription" hotkey priority 224{
		Dispose();
	}

	command Enter(unit uEntrance) hidden button "translateCommandEnter"{
		EndAttack();
		uTarget=null;
		SetCannonFireMode(-1, -1, enableFire);
		PrepareEnter(uEntrance);
		state Entering;
	}

	command SpecialChangeUnitsScript() button "translateCommandChangeScript" description "translateCommandChangeScriptDescription" hotkey priority 254{
		//special command - no implementation
	}
}
