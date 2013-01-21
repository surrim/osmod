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

civil "translateScriptNameUnarmedVechicleLightsOff"{
	consts{
		//comboLights
		LIGHTS_AUTO = 0;
		LIGHTS_ON   = 1;
		LIGHTS_OFF  = 2;

		//nState
		STATE_NOTHING            = 0;
		STATE_CALL_MOVE_TO_POINT = 3;
		STATE_PATROL             = 4;
		STATE_ESCORT             = 5;
	}

	int nStayGx;
	int nStayGy;
	int nStayLz;
	int nSpecialGx; //Patrol point, escort
	int nSpecialGy;
	int nSpecialLz;
	int nSpecialCounter;
	int nState;
   unit uSpecialUnit;

	enum comboLights{
		"translateCommandStateLightsAUTO", //LIGHTS_AUTO
		"translateCommandStateLightsON",   //LIGHTS_ON
		"translateCommandStateLightsOFF",  //LIGHTS_OFF
	multi:
		"translateCommandStateLightsMode"
	}

	state Retreat;
	state Nothing;
	state StartMoving;
	state Moving;
	state Patrol;
	state Escort;
	state Froozen;

	state Retreat{
		unit uTarget;
		if(!nSpecialCounter){
			uTarget=FindClosestEnemy();
			++nSpecialCounter;
		}else{
			if(IsMoving()){
				nSpecialCounter=(nSpecialCounter+1)&15;
			}else{
				nSpecialCounter=0;
			}
			return Retreat;
		}

		if(!uTarget){
			if(IsMoving()){
				CallStopMoving();
			}
			return Nothing;
		}
		CallMoveToPoint(2*GetLocationX()-uTarget.GetLocationX(), 2*GetLocationY()-uTarget.GetLocationY(), GetLocationZ());
		return Retreat;
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

	state Patrol{
		if(!IsMoving()){
			if(nSpecialCounter){
				CallMoveToPoint(nStayGx, nStayGy, nStayLz);
				nSpecialCounter=0;
			}else{
				CallMoveToPoint(nSpecialGx, nSpecialGy, nSpecialLz);
				nSpecialCounter=1;
			}
		}
		return Patrol;
	}

	state Escort{
		int nTargetGx;
		int nTargetGy;

		if(!uSpecialUnit.IsLive()){
			uSpecialUnit=null;
			if(IsMoving()){
				CallStopMoving;
				return Escort;
			}
			NextCommand(true);
			return Nothing;
		}

		nTargetGx=uSpecialUnit.GetLocationX()+nSpecialGx;
		nTargetGy=uSpecialUnit.GetLocationY()+nSpecialGy;
		if(DistanceTo(nTargetGx, nTargetGy)>0){
			CallMoveToPoint(nTargetGx, nTargetGy, uSpecialUnit.GetLocationZ());
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
			state Froozen;
		}else{
			if(nState==STATE_CALL_MOVE_TO_POINT){
				CallMoveToPoint(nStayGx, nStayGy, nStayLz);
				return Moving;
			}
			if(nState==STATE_PATROL){
				return Patrol;
			}
			if(nState==STATE_ESCORT){
				return Escort;
			}
			state Nothing;
		}
	}

	event OnHit(){
		if(GetHP()*2<=GetMaxHP()){
			if(state==Nothing){
				nSpecialCounter=0;
				state Retreat;
			}
		}
		true;
	}

	event OnCannonLowAmmo(int nCannonNum){
		true;
	}

	event OnCannonNoAmmo(int nCannonNum){
		true;
	}

	event OnCannonFoundTarget(int nCannonNum, unit uTarget){
		false;
	}

	event OnCannonEndFire(int nCannonNum, int nEndStatus){
		false;
	}

	event OnFreezeForSupplyOrRepair(int nFreezeTicks){
		if(state!=Froozen){
			nState=STATE_NOTHING;
		}
		if(state==Moving || state==StartMoving){
			nState=STATE_CALL_MOVE_TO_POINT;
		}else if(state==Patrol){
			nState=STATE_PATROL;
		}else if(state==Escort){
			nState=STATE_ESCORT;
		}
		CallFreeze(nFreezeTicks);
		state Froozen;
	}

	command Initialize(){
		comboLights=LIGHTS_OFF;
		SetLightsMode(comboLights);
		nStayGx=GetLocationX();
		nStayGy=GetLocationY();
		nStayLz=GetLocationZ();
	}

	command Uninitialize(){
		uSpecialUnit=null;
	}

	command Stop() button "translateCommandStop" description "translateCommandStopDescription" hotkey priority 20{
		if(IsMoving()){
			CallStopMoving();
		}
		state Nothing;
	}

	command Move(int nGx, int nGy, int nLz) button "translateCommandMove" description "translateCommandMoveDescription" hotkey priority 21{
		nStayGx=nGx;
		nStayGy=nGy;
		nStayLz=nLz;

		if(state==Froozen){
			nState=STATE_CALL_MOVE_TO_POINT;
		}else{
			CallMoveToPoint(nGx, nGy, nLz);
			state StartMoving;
		}
	}

	command UserNoParam0() button "translateCommandRetreat" description "translateCommandRetreatDescription" hotkey priority 25{
		nSpecialCounter=0;
		state Retreat;
	}

	command Patrol(int nGx, int nGy, int nLz) button "translateCommandPatrol" description "translateCommandPatrolDescription" hotkey priority 29{
		nSpecialGx=nGx;
		nSpecialGy=nGy;
		nSpecialLz=nLz;
		nStayGx=GetLocationX();
		nStayGy=GetLocationY();
		nStayLz=GetLocationZ();
		CallMoveToPoint(nGx, nGy, nLz);
		nSpecialCounter=1;
		state Patrol;
	}

	command Escort(unit uUnit) button "translateCommandEscort" description "translateCommandEscortDescription" hotkey priority 31{
		uSpecialUnit=uUnit;
		nSpecialGx=GetLocationX()-uSpecialUnit.GetLocationX();
		nSpecialGy=GetLocationY()-uSpecialUnit.GetLocationY();
		if(nSpecialGx>2){
			nSpecialGx=2;
		}else if(nSpecialGx<-2){
			nSpecialGx=-2;
		}
		if(nSpecialGy>2){
			nSpecialGy=2;
		}else if(nSpecialGy<-2){
			nSpecialGy=-2;
		}
		state Escort;
	}

	command Enter(unit uEntrance) hidden button "translateCommandEnter"{
		CallMoveInsideObject(uEntrance);
		state StartMoving;
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

	command SpecialChangeUnitsScript() button "translateCommandChangeScript" description "translateCommandChangeScriptDescription" hotkey priority 254{
		//special command, no implementation
	}
}
