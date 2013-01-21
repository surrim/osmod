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

tank "translateScriptNameTank"{
	consts{
		FIRE_MODE_SCRIPT = 0;
		FIRE_MODE_AUTO   = 1;

		//comboLights
		LIGHTS_AUTO = 0;
		LIGHTS_ON   = 1;
		LIGHTS_OFF  = 2;

		//comboMovementMode
		MOVEMENT_FOLLOW_ENEMY  = 0;
		MOVEMENT_HOLD_AREA     = 1;
		MOVEMENT_HOLD_POSITION = 2;

		//comboSearchMode
		SEARCH_NEAREST = 0;
		SEARCH_WEAKEST = 1;

		//comboCleanupMode
		CLEANUP_NOTHING         = 0;
		CLEANUP_RUINS           = 1;
		CLEANUP_WALLS           = 2;
		CLEANUP_RUINS_AND_WALLS = 3;

		STATE_NOTHING          = 0;
		STATE_ATTACKING_POINT  = 1;
		STATE_ATTACKING        = 2;
		STATE_MOVING           = 3;
		STATE_PATROL           = 4;
		STATE_ESCORT           = 5;
		STATE_IN_PLATOON_STATE = 6;
	}

	unit uTarget;
	int nTargetX;
	int nTargetY;
	int nTargetZ;

	int nStayX;
	int nStayY;
	int nStayZ;

	int nSpecialX; //Patrol point, escort
	int nSpecialY;
	int nSpecialZ;

	int nSpecialCounter;
	int nState;
	unit uEscortUnit;

	enum comboLights{
		"translateCommandStateLightsAUTO", //LIGHTS_AUTO
		"translateCommandStateLightsON",   //LIGHTS_ON
		"translateCommandStateLightsOFF",  //LIGHTS_OFF
	multi:
		"translateCommandStateLightsMode"
	}

	enum comboMovementMode{
		"translateCommandStateFollowEnemy",  //MOVEMENT_FOLLOW_ENEMY
		"translateCommandStateHoldArea",     //MOVEMENT_HOLD_AREA
		"translateCommandStateHoldPosition", //MOVEMENT_HOLD_POSITION
	multi:
		"translateCommandStateMovement"
	}

	enum comboSearchMode{
		"translateCommandStateNearestTarget", //SEARCH_NEAREST
		"translateCommandStateWeakestTarget", //SEARCH_WEAKEST
	multi:
		"translateCommandStateTargeting"
	}

	enum comboCleanupMode{
		"*No Cleanup",     //CLEANUP_NOTHING
		"*Kill Ruins",     //CLEANUP_RUINS
		"*Kill Walls",     //CLEANUP_WALLS
		"*Kill R. and W.", //CLEANUP_RUINS_AND_WALLS
	multi:
		"? Cleanup"
	}

	function int SetTarget(unit uNewTarget){
		uTarget=uNewTarget;
		SetTargetObject(uNewTarget);
	}

	function int GoToPoint(){
		int nRangeMode;

		nRangeMode=IsPointInCannonRange(0, nTargetX, nTargetY, nTargetZ);

		if(nRangeMode==notInRange){
			CallMoveToPoint(nTargetX, nTargetY, nTargetZ);
			return true;
		}
		if(nRangeMode==inRangeGoodHit){
			if(IsMoving()){
				CallStopMoving();
			}
			return false;
		}
		if(nRangeMode==inRangeBadAngleAlpha){ //in range, but you have to turn around the tank
			if(IsMoving()){
				CallStopMoving();
			}else{
				CallTurnToAngle(GetCannonAngleToPoint(0, nTargetX, nTargetY, nTargetZ));
			}
			return true;
		}
		//nRangeMode==inRangeBadAngleBeta || nRangeMode==inRangeBadHit
		CallMoveToPoint(nTargetX, nTargetY, nTargetZ);
		return true;
	}

	function int GoToTarget(){
		int nRangeMode;
		int nDistance;

		nRangeMode=IsTargetInCannonRange(0, uTarget);

		if(nRangeMode==notInRange){
			CallMoveToPoint(uTarget.GetLocationX(), uTarget.GetLocationY(), uTarget.GetLocationZ());
			return true;
		}
		if(nRangeMode==inRangeGoodHit){
			if(IsMoving()){
				CallStopMoving();
			}
			return false;
		}

		if(nRangeMode==inRangeBadAngleAlpha){ //in range, but you have to turn around the tank
			if(IsMoving()){
				CallStopMoving();
			}else{
				CallTurnToAngle(GetCannonAngleToTarget(0, uTarget));
			}
			return true;
		}

		nDistance=DistanceTo(uTarget.GetLocationX(), uTarget.GetLocationY());
		if(nRangeMode==inRangeBadAngleBeta){ //e.g. plane too high
			if(nDistance<3){ //move away
				CallMoveToPoint(2*GetLocationX()-uTarget.GetLocationX(), 2*GetLocationY()-uTarget.GetLocationY(), uTarget.GetLocationZ());
			}else{ //going to point, simple cornor (90°)
				nTargetX=uTarget.GetLocationX();
				nTargetY=uTarget.GetLocationY();
				nTargetZ=uTarget.GetLocationZ();
				CallMoveOneField(nTargetX-nTargetY+GetLocationY(), nTargetY+nTargetX-GetLocationX(), nTargetZ);
			}
			return true;
		}
		//nRangeMode==inRangeBadHit, in range but there is something between us
		if(nDistance<3){ //move away
			CallMoveToPoint(2*GetLocationX()-uTarget.GetLocationX(), 2*GetLocationY()-uTarget.GetLocationY(), uTarget.GetLocationZ());
		}else{ //going to point, simple cornor (90°)
			CallMoveToPoint(uTarget.GetLocationX(), uTarget.GetLocationY(), uTarget.GetLocationZ());
		}
		return true;
	}

	function int TargetInRange(){
		int nRangeMode;
		int nDx;
		int nDy;
		nRangeMode=IsTargetInCannonRange(0, uTarget);

		if(nRangeMode==inRangeGoodHit){
			return true;
		}
		if(nRangeMode==inRangeBadAngleAlpha){	//in range, but we have to turn to angle
			if(IsMoving()){
				CallStopMoving();
			}else{
				CallTurnToAngle(GetCannonAngleToTarget(0, uTarget));
			}
			return true;
		}
		return false;
	}

	function int FindBestTarget(){
		int i;
		int nTargetsCount;
		int nTargetType;
		unit uNewTarget;

		if(GetCannonType(0)!=cannonTypeIon){
			if(CanCannonFireToAircraft(-1)){
				nTargetType=findTargetFlyingUnit;
			}
			if(CanCannonFireToGround(-1)){
				if(GetCannonType(0)==cannonTypeEarthquake){
					nTargetType=nTargetType|findTargetBuildingUnit;
				}else{
					nTargetType=nTargetType|findTargetNormalUnit|findTargetWaterUnit|findTargetBuildingUnit;
					if(comboCleanupMode!=CLEANUP_NOTHING){
						if(comboCleanupMode==CLEANUP_RUINS){
							nTargetType=nTargetType|findTargetBuildingRuin;
						}else if(comboCleanupMode==CLEANUP_WALLS){
							nTargetType=nTargetType|findTargetWall;
						}else if(comboCleanupMode==CLEANUP_RUINS_AND_WALLS){
							nTargetType=nTargetType|findTargetBuildingRuin|findTargetWall;
						}
					}
				}
			}
			if(comboSearchMode==SEARCH_WEAKEST){
				SetTarget(FindTarget(nTargetType, findEnemyUnit, findWeakestUnit, findDestinationAnyUnit));
			}else{ //find closest target
				SetTarget(FindClosestEnemyUnitOrBuilding(nTargetType));
			}
			if(uTarget!=null && comboMovementMode==MOVEMENT_HOLD_POSITION && (IsTargetInCannonRange(0, uTarget)!=inRangeGoodHit)){
				SetTarget(FindTarget(nTargetType, findEnemyUnit, findNearestUnit, findDestinationAnyUnit));
			}

			return true;
		}
		BuildTargetsArray(findTargetWaterUnit|findTargetNormalUnit|findTargetBuildingUnit, findEnemyUnit, findDestinationAnyUnit);
		nTargetsCount=GetTargetsCount();
		if(nTargetsCount){
			SortFoundTargetsArray();
			StartEnumTargetsArray();
			for(i=0;i<nTargetsCount;++i){
				uNewTarget=GetNextTarget();
				if(!uNewTarget.IsDisabled()){
					EndEnumTargetsArray();
					SetTarget(uNewTarget);
					return true;
				}
			}
			EndEnumTargetsArray();
		}

		return false;
	}

	state Nothing;
	state HoldPosition;
	state StartMoving;
	state Moving;
	state AutoAttacking;
	state Attacking;
	state AttackingPoint;
	state Patrol;
	state Escort;
	state Froozen;
	state InPlatoonState;

	state Nothing{
		if(GetCannonType(0)==cannonTypeBallisticRocket){
			return Nothing;
		}
		if(comboMovementMode==MOVEMENT_HOLD_POSITION){
			return HoldPosition;
		}
		if(InPlatoon()){
			SetCannonFireMode(-1, FIRE_MODE_AUTO);
			return InPlatoonState;
		}
		if(!IsAllowingWithdraw()){
			AllowScriptWithdraw(true);
		}

		FindBestTarget();
		if(!uTarget){
			SetTarget(GetAttacker());
			ClearAttacker();
		}
		if(uTarget!=null){
			nStayX=GetLocationX();
			nStayY=GetLocationY();
			nStayZ=GetLocationZ();
			return AutoAttacking;
		}

		return Nothing;
	}

	state HoldPosition{
		if(comboMovementMode!=MOVEMENT_HOLD_POSITION){
			return Nothing;
		}
		if(IsAllowingWithdraw()){
			AllowScriptWithdraw(false);
		}

		if(uTarget){
			if(!uTarget.IsLive() || (!uTarget.IsPassive() && !IsEnemy(uTarget)) || (GetCannonType(0)==cannonTypeIon && uTarget.IsDisabled())){
				StopCannonFire(-1);
				SetTarget(null);
			}else{
				if(TargetInRange()){
					CannonFireToTarget(-2, uTarget, -1);
				}else{
					SetTarget(null);
				}
			}
		}else{
			FindBestTarget();
			if(!uTarget){
				SetTarget(GetAttacker());
				ClearAttacker();
			}
		}
		return HoldPosition;
	}

	state AutoAttacking{
		int nDistance;

		nDistance=Distance(nStayX, nStayY, GetLocationX(), GetLocationY());
		if(comboMovementMode==MOVEMENT_HOLD_AREA && nDistance>8){
			SetTarget(null);
			CallMoveToPoint(nStayX, nStayY, nStayZ);
			SetCannonFireMode(-1, FIRE_MODE_AUTO);
			return StartMoving;
		}

		if(!uTarget.IsLive() || (!uTarget.IsPassive() && !IsEnemy(uTarget)) || (GetCannonType(0)==cannonTypeIon && uTarget.IsDisabled())){
			StopCannonFire(-1);
			SetTarget(null);
		}

		if(uTarget){
			if(!GoToTarget()){
				CannonFireToTarget(-2, uTarget, -1);
				return AutoAttacking;
			}
			return AutoAttacking, 2;
		}

		FindBestTarget();
		if(uTarget!=null){
			return AutoAttacking;
		}

		if(nDistance>0 && comboMovementMode==MOVEMENT_HOLD_AREA){
			CallMoveToPoint(nStayX, nStayY, nStayZ);
			return StartMoving;
		}
		if(IsMoving()){
			CallStopMoving();
		}

		return Nothing;
	}

	state AttackingPoint{
		if(GoToPoint()){
			return AttackingPoint;
		}
		CannonFireGround(-1, nTargetX, nTargetY, nTargetZ, 1);
		return AttackingPoint;
	}

	state Attacking{
		if(uTarget.IsLive() && (GetCannonType(0)!=cannonTypeIon || !uTarget.IsDisabled())){
			if(GoToTarget()){
				return Attacking, 2;
			}
			CannonFireToTarget(-1, uTarget, -1);
			return Attacking;
		}
		//target does not exist or is disabled
		SetTarget(null);
		StopCannonFire(-1);
		if(IsMoving()){
			CallStopMoving();
		}
		NextCommand(true);
		return Nothing;
	}

	state StartMoving{
		SetCannonFireMode(-1, FIRE_MODE_AUTO);
		return Moving;
	}

	state Moving{
		if(IsMoving()){
			return Moving;
		}
		NextCommand(true);
		return Nothing;
	}

	state Patrol{
		if(uTarget){
			if(!uTarget.IsLive() || (!uTarget.IsPassive() && !IsEnemy(uTarget)) || (GetCannonType(0)==cannonTypeIon && uTarget.IsDisabled())){
				StopCannonFire(-1);
				SetTarget(null);
			}else{
				if(GoToTarget()){
					return Patrol, 2;
				}
				CannonFireToTarget(-2, uTarget, -1);
				return Patrol;
			}
		}else{
			FindBestTarget();
		}

		if(!IsMoving()){
			if(nSpecialCounter){
				CallMoveToPoint(nStayX, nStayY, nStayZ);
				nSpecialCounter=0;
			}else{
				CallMoveToPoint(nSpecialX, nSpecialY, nSpecialZ);
				nSpecialCounter=1;
			}
		}
		return Patrol;
	}

	state Escort{
		if(uTarget){
			if(!uTarget.IsLive() || (!uTarget.IsPassive() && !IsEnemy(uTarget)) || (GetCannonType(0)==cannonTypeIon && uTarget.IsDisabled())){
				StopCannonFire(-1);
				SetTarget(null);
			}else{
				if(GoToTarget()){
					return Escort, 2;
				}
				CannonFireToTarget(-2, uTarget, -1);
				return Escort;
			}
		}else{
			FindBestTarget();
		}

		if(!uEscortUnit.IsLive()){
			uEscortUnit=null;
			if(IsMoving()){
				CallStopMoving();
				return Escort;
			}
			NextCommand(true);
			return Nothing;
		}

		nTargetX=uEscortUnit.GetLocationX()+nSpecialX;
		nTargetY=uEscortUnit.GetLocationY()+nSpecialY;
		nTargetZ=uEscortUnit.GetLocationZ();
		if(Distance(nTargetX, nTargetY, GetLocationX(), GetLocationY())>0){
			CallMoveToPoint(nTargetX, nTargetY, nTargetZ);
			return Escort;
		}
		if(IsMoving()){
			CallStopMoving;
			return Escort;
		}
		return Escort;
	}

	state Froozen{
		if(IsFroozen() || IsMoving()){
			return Froozen;
		}else{
			if(nState==STATE_ATTACKING_POINT){
				return AttackingPoint;
			}
			if(nState==STATE_ATTACKING){
				return Attacking;
			}
			if(nState==STATE_MOVING){
				SetCannonFireMode(-1, FIRE_MODE_AUTO);
				CallMoveToPoint(nStayX, nStayY, nStayZ);
				return StartMoving;
			}
			if(nState==STATE_PATROL){
				return Patrol;
			}
			if(nState==STATE_ESCORT){
				return Escort;
			}
			if(nState==STATE_IN_PLATOON_STATE){
				return InPlatoonState;
			}

			state Nothing;
		}
	}

	state InPlatoonState{
		if(!IsAllowingWithdraw()){
			AllowScriptWithdraw(true);
		}
		if(!InPlatoon()){
			SetLightsMode(comboLights);
			SetCannonFireMode(-1, FIRE_MODE_SCRIPT);
			return Nothing;
		}
		return InPlatoonState;
	}

	event OnHit(){
		true;
	}

	event OnCannonLowAmmo(int nCannonNum){
		SendSupplyRequest();
		true;
	}

	event OnCannonNoAmmo(int nCannonNum){
		true;
	}

	event OnCannonFoundTarget(int nCannonNum, unit uFoundTarget){
		if(GetCannonType(nCannonNum)==cannonTypeIon && uFoundTarget.IsDisabled()){
			return true;
		}
		return false;
	}

	event OnCannonEndFire(int nCannonNum, int nEndStatus){
		false;
	}

	event OnFreezeForSupplyOrRepair(int nFreezeTicks){
		if(state!=Froozen){
			if(state==AttackingPoint){
				nState=STATE_ATTACKING_POINT;
			}else if(state==Attacking){
				nState=STATE_ATTACKING;
			}else if(state==Moving || state==StartMoving){
				nState=STATE_MOVING;
			}else if(state==Patrol){
				nState=STATE_PATROL;
			}else if(state==Escort){
				nState=STATE_ESCORT;
			}else if(state==InPlatoonState){
				nState=STATE_IN_PLATOON_STATE;
			}else{
				nState=STATE_NOTHING;
			}
		}
		CallFreeze(nFreezeTicks);
		state Froozen;
		true;
	}

	event OnTransportedToNewWorld(){
		StopCannonFire(-1);
		SetCannonFireMode(-1, FIRE_MODE_SCRIPT);
		SetTarget(null);
		uEscortUnit=null;
	}

	event OnConvertedToNewPlayer(){
		StopCannonFire(-1);
		SetCannonFireMode(-1, FIRE_MODE_SCRIPT);
		SetTarget(null);
		uEscortUnit=null;
		ClearAttacker();
		state Nothing;
	}

	command Initialize(){
		comboLights       = LIGHTS_AUTO;
		comboMovementMode = MOVEMENT_FOLLOW_ENEMY;
		//comboSearchMode   = SEARCH_NEAREST;
		SetLightsMode(comboLights);
		SetCannonFireMode(-1, FIRE_MODE_SCRIPT);
	}

	command Uninitialize(){
		SetTarget(null);
		uEscortUnit=null;
	}

	command UserOneParam1(int nMode) button comboSearchMode description "translateCommandStateTargetingDescription" priority 8{
		if(nMode==-1){
			comboSearchMode=(comboSearchMode+1)%2;
		}else{
			comboSearchMode=nMode;
		}
	}

	command Stop() button "translateCommandStop" description "translateCommandStopDescription" hotkey priority 20{
		SetTarget(null);
		StopCannonFire(-1);
		nStayX=GetLocationX();
		nStayY=GetLocationY();
		nStayZ=GetLocationZ();
		if(IsMoving()){
			CallStopMoving();
		}
		SetCannonFireMode(-1, FIRE_MODE_SCRIPT);
		state Nothing;
	}

	command Move(int nX, int nY, int nZ) hidden button "translateCommandMove" description "translateCommandMoveDescription" hotkey priority 21{
		SetTarget(null);
		nStayX=nX;
		nStayY=nY;
		nStayZ=nZ;
		SetCannonFireMode(-1, FIRE_MODE_AUTO);
		CallMoveToPoint(nX, nY, nZ);
		state StartMoving;
	}

	command Attack(unit uTargetToAttack) hidden button "translateCommandAttack" description "translateCommandAttackDescription" hotkey priority 22{
		SetTarget(uTargetToAttack);
		SetCannonFireMode(-1, FIRE_MODE_AUTO);
		AllowScriptWithdraw(true);
		if(state==Froozen){
			nState=STATE_ATTACKING;
		}else{
			state Attacking;
		}
	}

	command SendSupplyRequest() button "translateCommandSupply" description "translateCommandSupplyDescription" hotkey priority 27{
		SendSupplyRequest();
	}

	command Patrol(int nX, int nY, int nZ) button "translateCommandPatrol" description "translateCommandPatrolDescription" hotkey priority 29{
		nSpecialX=nX;
		nSpecialY=nY;
		nSpecialZ=nZ;
		nStayX=GetLocationX();
		nStayY=GetLocationY();
		nStayZ=GetLocationZ();
		CallMoveToPoint(nX, nY, nZ);
		nSpecialCounter=1;
		SetCannonFireMode(-1, FIRE_MODE_SCRIPT);
		state Patrol;
	}

	command Escort(unit uUnit) hidden button "translateCommandEscort" description "translateCommandEscortDescription" hotkey priority 31{
		uEscortUnit=uUnit;
		nSpecialX=GetLocationX()+uEscortUnit.GetLocationX();
		nSpecialY=GetLocationY()+uEscortUnit.GetLocationY();
		if(nSpecialX>2){
			nSpecialX=2;
		}else if(nSpecialX<-2){
			nSpecialX=-2;
		}
		if(nSpecialY>2){
			nSpecialY=2;
		}else if(nSpecialY<-2){
			nSpecialY=-2;
		}
		state Escort;
	}

	command HoldPosition() hidden button "translateCommandHoldPosition" description "translateCommandHoldPositionDescription" hotkey priority 20{
		SetTarget(null);
		StopCannonFire(-1);
		nStayX=GetLocationX();
		nStayY=GetLocationY();
		nStayZ=GetLocationZ();
		if(IsMoving()){
			CallStopMoving();
		}
		comboMovementMode=MOVEMENT_HOLD_POSITION;
		SetCannonFireMode(-1, FIRE_MODE_SCRIPT);
		ChangedCommandValue();
		state Nothing;
	}

	command SetLights(int nMode) button comboLights description "translateCommandStateLightsModeDescription" hotkey priority 204{
		if(nMode==-1){
			comboLights=(comboLights+1)%3;
		}else{
			comboLights=nMode;
		}
		SetLightsMode(comboLights);
		NextCommand(false);
	}

	command SetMovementMode(int nMode) button comboMovementMode description "translateCommandStateMovementDescription" priority 205{
		if(nMode==-1){
			comboMovementMode=(comboMovementMode+1)%3;
		}else{
			comboMovementMode=nMode;
		}
		NextCommand(false);
	}

	command UserOneParam2(int nMode) button comboCleanupMode priority 209{
		if(nMode==-1){
			comboCleanupMode=(comboCleanupMode+1)%4;
		}else{
			comboCleanupMode=nMode;
		}
	}

	/*komenda nie wystawiana na zewnatrz */
	command AttackOnPoint(int nX, int nY, int nZ) hidden button "translateCommandAttack"{
		SetTarget(null);
		nTargetX=nX;
		nTargetY=nY;
		nTargetZ=nZ;
		AllowScriptWithdraw(true);
		SetCannonFireMode(-1, FIRE_MODE_SCRIPT);
		if(state==Froozen){
			nState=STATE_ATTACKING_POINT;
		}else{
			state AttackingPoint;
		}
	}

	command Enter(unit uEntrance) hidden button "translateCommandEnter"{
		CallMoveInsideObject(uEntrance);
		nTargetX=GetEntranceX(uEntrance);
		nTargetY=GetEntranceY(uEntrance);
		nTargetZ=GetEntranceZ(uEntrance);
		SetCannonFireMode(-1, FIRE_MODE_SCRIPT);
		state StartMoving;
	}

	command SpecialChangeUnitsScript() button "translateCommandChangeScript" description "translateCommandChangeScriptDescription" hotkey priority 254{
		//special command, no implementation
	}
}
