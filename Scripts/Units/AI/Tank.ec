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
		disableFire=0;
		enableFire =1;

		//comboLights
		LIGHTS_AUTO=0;
		LIGHTS_ON  =1;
		LIGHTS_OFF =2;
	}

	unit m_uTarget;
	int  m_nCannonsCount;
	int  m_nTargetGx;
	int  m_nTargetGy;
	int  m_nTargetLz;
	int  m_nStayGx;
	int  m_nStayGy;
	int  m_nStayLz;
	int  m_nSpecialCounter;
	unit m_uSpecialUnit;
	int  m_bFindAndDestroyWalls;

	enum comboLights{
		"translateCommandStateLightsAUTO", //LIGHTS_AUTO
		"translateCommandStateLightsON",   //LIGHTS_ON
		"translateCommandStateLightsOFF",  //LIGHTS_OFF
	multi:
		"translateCommandStateLightsMode"
	}

	function int SetTarget(unit uTarget){
		m_uTarget=uTarget;
		SetTargetObject(uTarget);
		return true;
	}

	function int GoToPoint(){
		int nRangeMode;
		int nDx;
		int nDy;

		nRangeMode=IsPointInCannonRange(0,m_nTargetGx, m_nTargetGy, m_nTargetLz);

		if(nRangeMode==inRangeGoodHit){
			if(IsMoving()){
				CallStopMoving();
			}
			return false;
		}
		if(nRangeMode==inRangeBadAngleAlpha){ //w zasiegu ale trzeba odwrocic czolg
			if(IsMoving()){
				CallStopMoving();
			}else{
				CallTurnToAngle(GetCannonAngleToPoint(0,m_nTargetGx, m_nTargetGy, m_nTargetLz));
			}
			return true;
		}

		CallMoveToPoint(m_nTargetGx, m_nTargetGy, m_nTargetLz);
		return true;
	}

	function int GoToTarget(){
		int nRangeMode;
		nRangeMode=IsTargetInCannonRange(0, m_uTarget);

		if(nRangeMode==inRangeGoodHit){
			if(IsMoving()){
				CallStopMoving();
			}
			return false;
		}

		if(nRangeMode==inRangeBadAngleAlpha){ //w zasiegu ale trzeba odwrocic czolg
			CallTurnToAngle(GetCannonAngleToTarget(0, m_uTarget));
			return true;
		}
		CallMoveToPoint(m_uTarget.GetLocationX(), m_uTarget.GetLocationY(), m_uTarget.GetLocationZ());
		return true;
	}

	function int EndState(){
		SetCannonFireMode(-1, disableFire);
		NextCommand(true);
	}

	function int FindBestTarget(){
		int i;
		int nTargetsCount;
		unit newTarget;
		int nFindTarget;

		if(GetCannonType(0)!=cannonTypeIon){
			nFindTarget=0;
			if(CanCannonFireToAircraft(-1)){
				nFindTarget=findTargetFlyingUnit;
			}
			if(CanCannonFireToGround(-1)){
				if(GetCannonType(0)==cannonTypeEarthquake){
					nFindTarget=nFindTarget|findTargetBuildingUnit;
				}else{
					nFindTarget=nFindTarget|findTargetNormalUnit|findTargetWaterUnit|findTargetBuildingUnit;
				}
			}
			SetTarget(FindClosestEnemyUnitOrBuilding(nFindTarget));
			return true;
		}

		SetTarget(null);
		BuildTargetsArray(findTargetWaterUnit|findTargetNormalUnit|findTargetBuildingUnit, findEnemyUnit,findDestinationAnyUnit);
		SortFoundTargetsArray();
		nTargetsCount=GetTargetsCount();
		if(nTargetsCount!=0){
			StartEnumTargetsArray();
			for(i=0;i<nTargetsCount;++i){
				newTarget=GetNextTarget();
				if(!newTarget.IsDisabled()){
					EndEnumTargetsArray();
					SetTarget(newTarget);
					return true;
				}
			}
			EndEnumTargetsArray();
		}
		return false;
	}

	state Nothing;
	state InPlatoonState;
	state StartMoving;
	state Moving;
	state AutoAttacking;
	state Attacking;
	state AttackingPoint;
	state Retreat;

	state Retreat{
		if(IsMoving())
			return Retreat,20;

		m_uTarget=FindClosestEnemy();
		SetTargetObject(null);

		if(!m_uTarget)
		{
			if(IsMoving())
				CallStopMoving();
			m_uTarget=null;
			SetTargetObject(null);
			return Nothing;
		}
		CallMoveToPoint(2*GetLocationX()-m_uTarget.GetLocationX(),2*GetLocationY() - m_uTarget.GetLocationY(),GetLocationZ());
		return Retreat,100;
	}
	//-------------------------------------------------------
	state InPlatoonState
	{
		if(!InPlatoon())
		{
			SetLightsMode(comboLights);
			SetCannonFireMode(-1, disableFire);
			return Nothing;
		}
		return InPlatoonState,40;
	}
	//-------------------------------------------------------

	state Nothing
	{
		if(InPlatoon())
		{
			SetCannonFireMode(-1, enableFire);
			return InPlatoonState;
		}

		SetTarget(GetAttacker());
		ClearAttacker();

		if(!m_uTarget)
		{
			FindBestTarget();
		}

		if(m_uTarget!=null)
		{
			m_nStayGx=GetLocationX();
			m_nStayGy=GetLocationY();
			m_nStayLz=GetLocationZ();
			return AutoAttacking;
		}
		return Nothing;
	}
	//----------------------------------------------------
	state AutoAttacking
	{
		int nDistance;

		// pozostawaj w okolicach punktu
		nDistance=DistanceTo(m_nStayGx,m_nStayGy);
		if( nDistance > 12)
		{
			SetTarget(null);
			CallMoveToPoint(m_nStayGx, m_nStayGy, m_nStayLz);
			SetCannonFireMode(-1, enableFire);
			return Moving;
		}

		if(!m_uTarget.IsLive() || (GetCannonType(0)==cannonTypeIon && m_uTarget.IsDisabled()))
		{
			StopCannonFire(-1);
			SetTarget(null);
		}

		if(m_uTarget)
		{
			if(!GoToTarget())
			{
				CannonFireToTarget(-1, m_uTarget, -1);
				if(GetAttacker()!=null){ SetTarget(GetAttacker()); ClearAttacker(); }
			}
			return AutoAttacking;
		}
		else//target not exist
		{
			SetTarget(GetAttacker());
			ClearAttacker();

			if(!m_uTarget)
			{
				FindBestTarget();
			}

			if(m_uTarget!=null)
				return AutoAttacking;


			if( nDistance > 0)
			{
				CallMoveToPoint(m_nStayGx, m_nStayGy, m_nStayLz);
				SetCannonFireMode(-1, enableFire);
				return Moving;
			}

			if(IsMoving())
			{
				CallStopMoving();
			}
			return Nothing;
		}
	}
	//--------------------------------------------------------------------------
	state AttackingPoint
	{
		if(GoToPoint())
		{
			return AttackingPoint;
		}
		else
		{
			CannonFireGround(-1, m_nTargetGx, m_nTargetGy, m_nTargetLz, 1);
			return AttackingPoint;
		}
	}
	//----------------------------------------------------
	state Attacking
	{
		if(m_uTarget.IsLive())
		{
			if(GoToTarget())
			{
				return Attacking;
			}
			else
			{
				CannonFireToTarget(-1, m_uTarget, -1);
				return Attacking;
			}
		}
		else //target not exist
		{
			SetTarget(null);
			if(IsMoving())
			{
				CallStopMoving();
			}
			EndState();
			return Nothing;
		}
	}

	//--------------------------------------------------------------------------
	state StartMoving
	{
		return Moving, 20;
	}
	//--------------------------------------------------------------------------
	state Moving
	{
	/*ten kawalek jest teraz w plutonie
	SetTarget(GetAttacker());
	ClearAttacker();

	  if(!m_uTarget)
	  {
	  FindBestTarget();
	  }

		if(m_uTarget!=null)
		{
		return AutoAttacking;
	}*/

		if(IsMoving())
		{
			return Moving;
		}
		else
		{
			EndState();
			return Nothing;
		}
	}
	//--------------------------------------------------------------------------
	state Froozen
	{
		if(IsFroozen())
		{
			state Froozen;
		}
		else
		{
			//!!wrocic do tego co robilismy
			state Nothing;
		}
	}



	//********************************************************
	//*********** E V E N T S ****************************
	//********************************************************
	//zwracaja true
	//false jak nie ma
	event OnHit()
	{
		if(!GetAmmoCount() && CannonRequiresSupply(-1))
		{
			SetCannonFireMode(-1, enableFire);
			state Retreat;
		}
		true;
	}
	//-------------------------------------------------------
	event OnCannonLowAmmo(int nCannonNum)
	{
		true;
	}
	//-------------------------------------------------------
	event OnCannonNoAmmo(int nCannonNum)
	{
		if(CannonRequiresSupply(nCannonNum))// && !InPlatoon())
		{
			m_nSpecialCounter=0;
			SetCannonFireMode(-1, enableFire);
			state Retreat;
		}
		true;
	}
	//-------------------------------------------------------
	event OnCannonFoundTarget(int nCannonNum, unit uTarget)
	{
		if(GetCannonType(nCannonNum)==cannonTypeIon)
		{
			if(uTarget.IsDisabled())
			{
				return true;
			}
		}
		return false;//gdyby zwrocic true to dzialko nie strzeli
	}
	//-------------------------------------------------------
	event OnCannonEndFire(int nCannonNum, int nEndStatus)//gdy zniszczony, poza zasiegiem lub brak ammunicji
	{
		false;
	}
	//-------------------------------------------------------
	event OnFreezeForSupplyOrRepair(int nFreezeTicks)
	{
		CallFreeze(nFreezeTicks);
		state Froozen;
		true;
	}
	//-------------------------------------------------------
	event OnTransportedToNewWorld()
	{
		StopCannonFire(-1);
		SetCannonFireMode(-1, disableFire);
		SetTarget(null);
		m_uSpecialUnit=null;
	}
	//-------------------------------------------------------
	event OnConvertedToNewPlayer()
	{
		StopCannonFire(-1);
		SetCannonFireMode(-1, disableFire);
		SetTarget(null);
				ClearAttacker();
		m_uSpecialUnit=null;
		state Nothing;
	}

	//********************************************************
	//*********** C O M M A N D S ****************************
	//********************************************************
	command Initialize()
	{
		m_nCannonsCount=GetCannonsCount();
		SetCannonFireMode(-1, disableFire);
	}
	//--------------------------------------------------------------------------
	command Uninitialize()
	{
		//wykasowac referencje
		SetTarget(null);
		m_uSpecialUnit=null;
	}
	//--------------------------------------------------------------------------
	command SetLights(int nMode) hidden button comboLights priority 204
	{
		if(nMode==-1)
		{
			comboLights=(comboLights + 1) % 3;
		}
		else
		{
			assert(nMode==0);
			comboLights=nMode;
		}
		SetLightsMode(comboLights);
		NextCommand(false);
	}
	//--------------------------------------------------------------------------
	command Stop() hidden button "translateCommandStop" description "translateCommandStopDescription" hotkey priority 20
	{
		SetTarget(null);
		StopCannonFire(-1);
		m_nStayGx=GetLocationX();
		m_nStayGy=GetLocationY();
		m_nStayLz=GetLocationZ();
		if(IsMoving())
			CallStopMoving();
		SetCannonFireMode(-1, disableFire);
		state Nothing;
	}
	//--------------------------------------------------------------------------
	command Move(int nGx, int nGy, int nLz) hidden button "translateCommandMove" description "translateCommandMoveDescription" hotkey priority 21
	{
		SetTarget(null);
		m_nStayGx=nGx;
		m_nStayGy=nGy;
		m_nStayLz=nLz;
		SetCannonFireMode(-1, enableFire);
		CallMoveToPoint(nGx, nGy, nLz);
		state StartMoving;
	}
	//--------------------------------------------------------------------------
	command Attack(unit uTarget) hidden button "translateCommandAttack" description "translateCommandAttackDescription" hotkey priority 22
	{
			  if((CanCannonFireToAircraft(-1) || !uTarget.IsHelicopter()) &&
					(GetAmmoCount() || !CannonRequiresSupply(-1)))
				{
					SetTarget(uTarget);
					SetCannonFireMode(-1, enableFire);
					state Attacking;
				}
	}

	/*komenda nie wystawiana na zewnatrz*/
	command AttackOnPoint(int nX, int nY, int nZ) hidden button "translateCommandAttack"
	{
		SetTarget(null);
		m_nTargetGx=nX;
		m_nTargetGy=nY;
		m_nTargetLz=nZ;
		SetCannonFireMode(-1, disableFire);
		state AttackingPoint;
	}

	//--------------------------------------------------------------------------
	command SendSupplyRequest() hidden button "translateCommandSupply" description "translateCommandSupplyDescription" hotkey priority 27
	{
		SendSupplyRequest();
	}

	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	command Enter(unit uEntrance) hidden button "translateCommandEnter"
	{
		CallMoveInsideObject(uEntrance);
		m_nTargetGx=GetEntranceX(uEntrance);
		m_nTargetGy=GetEntranceY(uEntrance);
		m_nTargetLz=GetEntranceZ(uEntrance);
		SetCannonFireMode(-1, disableFire);
		state StartMoving;
	}

	//-------------------------------------------------------
	command SpecialChangeUnitsScript() button "translateCommandChangeScript" description "translateCommandChangeScriptDescription" hotkey priority 254
	{
		//special command - no implementation
	}
	//--------------------------------------------------------------------------
	command UserOneParam0(int nMode)
	{
		m_bFindAndDestroyWalls=1;
	}
	//--------------------------------------------------------------------------
	command UserOneParam1(int nMode)
	{
		m_bFindAndDestroyWalls=0;
	}
}
