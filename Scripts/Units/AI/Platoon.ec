/* Copyright 2009-2014 surrim
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

platoon "translateDefaultPlatoon"
{
    consts
    {
        disableFire=0;
        enableFire=1;
    }


    enum lights
    {
        "translateCommandStateLightsAUTO",
        "translateCommandStateLightsON",
        "translateCommandStateLightsOFF",
multi:
        "translateCommandStateLightsMode"
    }

    unit m_uTarget;
    int  m_nTargetGx;
    int  m_nTargetGy;
    int  m_nTargetLz;

    int  bOnTheWay;
    int  bAuto;
    int  m_bFindAndDestroyWalls;

    function int GoToPoint()
    {
        int nRangeMode;
        nRangeMode = IsPointInCannonRange(0,0,m_nTargetGx, m_nTargetGy, m_nTargetLz);

        if (nRangeMode == 4) //in range
        {
            if (IsMoving())
                CallStopMoving();
            return false;
        }
        CallMoveToPoint(m_nTargetGx, m_nTargetGy, m_nTargetLz);
        return true;
    }

    //-------------------------------------------------------
    function int GoToTarget()
    {
        int nRangeMode;
        int i;
        for(i=0;i<GetUnitsCount();i=i+1)
        {
            nRangeMode = IsTargetInCannonRange(i,0, m_uTarget);
            if (nRangeMode == inRangeGoodHit)
            {
                if(i) SetLeader(i);
                if (IsMoving())
                    CallStopMoving();
                return false;
            }
        }
        CallMoveToPoint(m_uTarget.GetLocationX(), m_uTarget.GetLocationY(), m_uTarget.GetLocationZ());
        return true;
    }
    //-------------------------------------------------------
    function int PrepareAttack(unit uTarget)
    {
        int i;
        punit member;
        EnableFeatures(platoonFreeUnits,true);
        for(i=0;i<GetUnitsCount();i=i+1)
        {
            member = GetUnit(i);
            member.CommandAttack(uTarget);
        }
    }
    //-------------------------------------------------------
    function int EndAttack()
    {
        int i;
        punit member;
        EnableFeatures(platoonFreeUnits,false);
        for(i=0;i<GetUnitsCount();i=i+1)
        {
            member=GetUnit(i);
            member.CommandStop();
        }
    }

    //-------------------------------------------------------
    function int EndState()
    {
        NextCommand(true);
    }
    //********************************************************
    //************* S T A T E S ******************************
    //********************************************************
    state FirstState;
    state Nothing;
    state StartMoving;
    state Moving;
    state Attacking;
    state AttackingPoint;
    //-------------------------------------------------------
    state FirstState //pluton jest w tym stanie dopuki nie zobaczy pierwszego wroga w tym stanie rozgladaja sie wszysy bo pluton moze byc rozproszony
    {
        int i;
        int nFindTarget;

        //m_uTarget = GetAttacker(-1);
        //ClearAttacker(-1);

        if(!m_uTarget)
        {
            for(i=0;i<GetUnitsCount() && !m_uTarget;i=i+1)
            {
                nFindTarget = 0;
                if (CanCannonFireToAircraft(i, -1))
                {
                    nFindTarget = findTargetFlyingUnit;
                }
                if (CanCannonFireToGround(i, -1))
                {
                    if (GetCannonType(i,0) == cannonTypeEarthquake)
                    {
                        nFindTarget = nFindTarget | findTargetBuildingUnit;
                    }
                    else
                    {
                                                    nFindTarget = nFindTarget | findTargetNormalUnit | findTargetWaterUnit | findTargetBuildingUnit;
                    }
                }
                m_uTarget = FindTarget(i,nFindTarget,findEnemyUnit,findNearestUnit,findDestinationAnyUnit);
                if (m_uTarget != null) SetLeader(i);
            }
        }
        if (m_uTarget != null)
        {
            bAuto=true;
            PrepareAttack(m_uTarget);
            return Attacking;
        }

        return FirstState,20;
    }
    //-------------------------------------------------------
    state Nothing
    {
              int i;
              int nFindTarget;
        m_uTarget = GetAttacker(-1);
        ClearAttacker(-1);
        if(!m_uTarget)
        {
                        for(i=0;i<GetUnitsCount() && !m_uTarget;i=i+1)
            {
                nFindTarget = 0;
                if (CanCannonFireToAircraft(i, -1))
                {
                    nFindTarget = findTargetFlyingUnit;
                }
                if (CanCannonFireToGround(i, -1))
                {
                    if (GetCannonType(i,0) == cannonTypeEarthquake)
                    {
                        nFindTarget = nFindTarget | findTargetBuildingUnit;
                    }
                    else
                    {
                        nFindTarget = nFindTarget | findTargetNormalUnit | findTargetWaterUnit | findTargetBuildingUnit | findTargetBuildingRuin;
                        if (m_bFindAndDestroyWalls && GetType()!=typeHelicopters)
                        {
                                                    nFindTarget = nFindTarget | findTargetWall;
                        }
                    }
                }
                m_uTarget = FindTarget(i,nFindTarget,findEnemyUnit,findNearestUnit,findDestinationAnyUnit);
                if (m_uTarget != null)
                                {
                                    SetLeader(i);
                                }
            }

        }
        if (m_uTarget != null)
        {
            bAuto=true;
            PrepareAttack(m_uTarget);
            return Attacking;
        }
        return Nothing,20;
    }
    //--------------------------------------------------------------------------
    state StartMoving
    {
        return Moving, 20;
    }
    //--------------------------------------------------------------------------
    state Moving
    {
        int nFindTarget;
        if(bOnTheWay)//bOnTheWay jest po to aby nie robic tego przy komendzie Enter
        {
            nFindTarget = 0;
            if (CanCannonFireToAircraft(0, -1))
            {
                nFindTarget = findTargetFlyingUnit;
            }
            if (CanCannonFireToGround(0, -1))
            {
                if (GetCannonType(0,0) == cannonTypeEarthquake)
                {
                    nFindTarget = nFindTarget | findTargetBuildingUnit;
                }
                else
                {
                    nFindTarget = nFindTarget | findTargetNormalUnit | findTargetWaterUnit | findTargetBuildingRuin;
                    if (m_bFindAndDestroyWalls && GetType()!=typeHelicopters)
                    {
                        nFindTarget = nFindTarget | findTargetWall;
                    }
                }
            }
            m_uTarget = FindTarget(0,nFindTarget,findEnemyUnit,findNearestUnit,findDestinationAnyUnit);
            if (m_uTarget != null)
            {
                bAuto=true;
                PrepareAttack(m_uTarget);
                return Attacking;
            }
        }
        if (IsMoving())
        {
            return Moving;
        }
        else
        {
            bOnTheWay=false;
            EndState();
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
            CannonFireGround(-1,-1, m_nTargetGx, m_nTargetGy, m_nTargetLz, 1);
            return AttackingPoint;
        }
    }
    //----------------------------------------------------
    state Attacking
    {
        if (m_uTarget.IsLive())
        {
            if(bAuto && DistanceTo(m_uTarget.GetLocationX(),m_uTarget.GetLocationY())>20)
            {
                m_uTarget=null;
                EndAttack();
                if(bOnTheWay)
                {
                    CallMoveToPoint(m_nTargetGx, m_nTargetGy, m_nTargetLz);
                    return StartMoving;
                }
                return Nothing;
            }
                        PrepareAttack(m_uTarget);
            return Attacking,80;
        }
        else //target not exist
        {
            m_uTarget=null;
            EndAttack();
            if(bOnTheWay)
            {
                CallMoveToPoint(m_nTargetGx, m_nTargetGy, m_nTargetLz);
                return StartMoving;
            }

            EndState();
            return Nothing;
        }
    }

    //--------------------------------------------------------------------------
    state Frozen
    {
        if (IsFrozen())
        {
            state Frozen;
        }
        else
        {
            state Nothing;
        }
    }
    //--------------------------------------------------------------------------
    //--------------------------------------------------------------------------
    //********************************************************
    //************* C O M M A N D S S ************************
    //********************************************************
    command Stop() button "translateCommandStop" description "translateCommandStopDescription" hotkey priority 20
    {
        EndAttack();
        m_uTarget = null;
        SetCannonFireMode(-1,-1, enableFire);
        CallStopMoving();
        bOnTheWay=true;
        state Nothing;
    }
    //--------------------------------------------------------------------------
    command Move(int nGx, int nGy, int nLz) button "translateCommandMove" description "translateCommandMoveDescription" hotkey priority 21
    {
        EndAttack();
        m_uTarget = null;
        SetCannonFireMode(-1,-1, enableFire);
        CallMoveToPoint(nGx, nGy, nLz);
        m_nTargetGx = nGx;
        m_nTargetGy = nGy;
        m_nTargetLz = nLz;
        bOnTheWay=true;
        state StartMoving;
    }
    //--------------------------------------------------------------------------
    command Attack(unit uTarget) button "translateCommandAttack" description "translateCommandAttackDescription" hotkey priority 22
    {
        PrepareAttack(m_uTarget);
        bAuto=false;
        bOnTheWay=false;
        m_uTarget = uTarget;
        SetCannonFireMode(-1,-1, enableFire);
        state Attacking;
    }
    //--------------------------------------------------------------------------
    /*komenda nie wystawiana na zewnatrz*/
    command AttackOnPoint(int nX, int nY, int nZ) hidden button "translateCommandAttack"
    {
        bAuto=false;
        bOnTheWay=false;
        m_uTarget = null;
        m_nTargetGx = nX;
        m_nTargetGy = nY;
        m_nTargetLz = nZ;
        state AttackingPoint;
    }
    //--------------------------------------------------------------------------
    command DisposePlatoon() button "translateCommandPlatoonDispose" description "translateCommandPlatoonDisposeDescription" hotkey priority 13
    {
        Dispose();
    }
    //--------------------------------------------------------------------------
    command SetLights(int nMode) button lights priority 204
    {
        if (nMode == -1)
        {
            lights = (lights + 1) % 3;
        }
        else
        {
            assert(nMode == 0);
            lights = nMode;
        }
        SetLightsMode(-1,lights);
        NextCommand(false);
    }
    //--------------------------------------------------------------------------
    command SpecialChangeUnitsScript() button "translateCommandChangeScript" description "translateCommandChangeScriptDescription" hotkey priority 254
    {
        //special command - no implementation
    }
    //--------------------------------------------------------------------------
    command Enter(unit uEntrance) hidden button "translateCommandEnter"
    {
    }
    //--------------------------------------------------------------------------
    command SendSupplyRequest() button "translateCommandSupply" description "translateCommandSupplyDescription" hotkey priority 27
    {
        SendSupplyRequest(-1);
    }
    //--------------------------------------------------------------------------
    command AddUnitToPlatoon(unit uUnit) button "translateCommandPlatoonAddUnit" description "translateCommandPlatoonAddUnitDescription" hotkey priority 11
    {
        AddUnitToPlatoon(uUnit);
        NextCommand(true);
    }
    //--------------------------------------------------------------------------
    command RemoveUnitFromPlatoon(unit uUnit) button "translateCommandPlatoonRemoveUnit" description "translateCommandPlatoonRemoveUnitDescription" hotkey priority 12
    {
        RemoveUnitFromPlatoon(uUnit);
        NextCommand(true);
    }
    //--------------------------------------------------------------------------
    command Initialize()
    {
        bAuto=false;
        bOnTheWay=false;
        m_bFindAndDestroyWalls=0;
        SetCannonFireMode(-1,-1, enableFire);
    }
    //--------------------------------------------------------------------------
    command UserOneParam0(int nMode) hidden button "F2W"
    {
        m_bFindAndDestroyWalls=1;
    }
    //--------------------------------------------------------------------------
    command UserOneParam1(int nMode) hidden button "Don't F2W"
    {
        m_bFindAndDestroyWalls=0;
    }
    //--------------------------------------------------------------------------
    command Uninitialize()
    {
        //wykasowac referencje
        m_uTarget = null;
    }
    //--------------------------------------------------------------------------
}

