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

supplier "translateScriptNameSupplyTransporter"
{
    enum lights
    {
        "translateCommandStateLightsAUTO",
        "translateCommandStateLightsON",
        "translateCommandStateLightsOFF",
multi:
        "translateCommandStateLightsMode"
    }

    int m_nMoveToX;
    int m_nMoveToY;
    int m_nMoveToZ;

    state Initialize;
    state Nothing;
    state StartMoving;
    state Moving;
    state MovingToAssemblyPoint;
    state MovingToSupplyCenter;
    state MovingToObjectForSupply;
    state LoadingAmmo;
    state PuttingAmmo;

    state Initialize
    {
        return Nothing;
    }

    state Nothing
    {
        int bIsEnd;
        if (HaveObjectsForSupply())
        {
            //kontynujemy zaopatrzenie bo nie mozna zostawic zadnego obiektu
            bIsEnd = false;
            while (!bIsEnd && !CanCurrentObjectBeSupplied())
            {
                if (!NextObjectForSupply())
                {
                    bIsEnd = true;
                }
            }
            if (!bIsEnd)
            {
                m_nMoveToX = GetCurrentPutSupplyPositionX();
                m_nMoveToY = GetCurrentPutSupplyPositionY();
                m_nMoveToZ = GetCurrentPutSupplyPositionZ();
                CallMoveToPointForce(m_nMoveToX, m_nMoveToY, m_nMoveToZ);
                return MovingToObjectForSupply;
            }
            else
            {
                return Nothing;
            }
        }
        else
        {
            return Nothing;
        }
    }

    state StartMoving
    {
        return Moving, 20;
    }
    //--------------------------------------------------------------------------
    state Moving
    {
        if (IsMoving())
        {
            return Moving;
        }
        else
        {
            NextCommand(true);
            return Nothing;
        }
    }

    state MovingToAssemblyPoint
    {
        if (IsMoving())
        {
            return MovingToAssemblyPoint;
        }
        else
        {
            return Nothing;
        }
    }

    state MovingToSupplyCenter
    {
        int nPosX;
        int nPosY;
        int nPosZ;
        if (IsMoving())
        {
                        nPosX = GetLocationX();
            nPosY = GetLocationY();
            nPosZ = GetLocationZ();
            if ((nPosX == m_nMoveToX) && (nPosY == m_nMoveToY) && (nPosZ == m_nMoveToZ))//added 25.01.2000
                            CallStopMoving();

            return MovingToSupplyCenter;
        }
        else
        {
            nPosX = GetLocationX();
            nPosY = GetLocationY();
            nPosZ = GetLocationZ();
            if ((nPosX == m_nMoveToX) && (nPosY == m_nMoveToY) && (nPosZ == m_nMoveToZ))
            {
                CallLoadAmmo();
                return LoadingAmmo;
            }
            else
            {
                //CallMoveAndLandToPointForce(m_nMoveToX, m_nMoveToY, m_nMoveToZ);
                                CallMoveToPointForce(m_nMoveToX, m_nMoveToY, m_nMoveToZ);//dodane 09.03.2000
                return MovingToSupplyCenter;
            }
        }
    }

    state MovingToObjectForSupply
    {
        int nPosX;
        int nPosY;
        int nPosZ;
        int bIsEnd;
        if (IsMoving())
        {
            if (!CanCurrentObjectBeSupplied())
            {
                CallStopMoving();
                return MovingToObjectForSupply;
            }
            CheckCurrentPutSupplyLocation();
            if(m_nMoveToX != GetCurrentPutSupplyPositionX()||
                m_nMoveToY != GetCurrentPutSupplyPositionY())
            {
                m_nMoveToX = GetCurrentPutSupplyPositionX();
                m_nMoveToY = GetCurrentPutSupplyPositionY();
                m_nMoveToZ = GetCurrentPutSupplyPositionZ();
                CallMoveToPointForce(m_nMoveToX, m_nMoveToY, m_nMoveToZ);
            }

            //XXXMD zrobic gonienie czolgu
            return MovingToObjectForSupply;
        }
        else
        {
            if (IsInGoodCurrentPutSupplyLocation())
            {
                CallPutAmmo();
                return PuttingAmmo;
            }
            else
            {
                //nie jest w dobrym miejscu
                if (CanCurrentObjectBeSupplied())
                {
                    m_nMoveToX = GetCurrentPutSupplyPositionX();
                    m_nMoveToY = GetCurrentPutSupplyPositionY();
                    m_nMoveToZ = GetCurrentPutSupplyPositionZ();
                    CallMoveToPointForce(m_nMoveToX, m_nMoveToY, m_nMoveToZ);
                    return MovingToObjectForSupply;
                }
                else
                {
                    //nie mozna do niego dojechac (pod ziemia), lub zabity - biezemy nastepnego
                    bIsEnd = false;
                    do
                    {
                        if (!NextObjectForSupply())
                        {
                            bIsEnd = true;
                        }
                    }
                    while (!bIsEnd && !CanCurrentObjectBeSupplied());
                    if (!bIsEnd)
                    {
                        m_nMoveToX = GetCurrentPutSupplyPositionX();
                        m_nMoveToY = GetCurrentPutSupplyPositionY();
                        m_nMoveToZ = GetCurrentPutSupplyPositionZ();
                        CallMoveToPointForce(m_nMoveToX, m_nMoveToY, m_nMoveToZ);
                        return MovingToObjectForSupply;
                    }
                    else
                    {
                        //nie ma juz obiektow do zaopatrzenia - wracamy do punktu zbiorki
                        if (GetSupplyCenterBuilding() != null)
                        {
                            m_nMoveToX = GetSupplyCenterAssemblyPositionX();
                            m_nMoveToY = GetSupplyCenterAssemblyPositionY();
                            m_nMoveToZ = GetSupplyCenterAssemblyPositionZ();
                            CallMoveToPoint(m_nMoveToX, m_nMoveToY, m_nMoveToZ);
                            return MovingToAssemblyPoint;
                        }
                        else
                        {
                            return Nothing;
                        }
                    }
                }
            }
        }
    }

    state LoadingAmmo
    {
        int bIsEnd;
        if (IsLoadingAmmo())
        {
            return LoadingAmmo;
        }
        else
        {
            if (HaveObjectsForSupply())
            {
                bIsEnd = false;
                while (!bIsEnd && !CanCurrentObjectBeSupplied())
                {
                    if (!NextObjectForSupply())
                    {
                        bIsEnd = true;
                    }
                }
                if (!bIsEnd)
                {
                    m_nMoveToX = GetCurrentPutSupplyPositionX();
                    m_nMoveToY = GetCurrentPutSupplyPositionY();
                    m_nMoveToZ = GetCurrentPutSupplyPositionZ();
                    CallMoveToPointForce(m_nMoveToX, m_nMoveToY, m_nMoveToZ);
                    return MovingToObjectForSupply;
                }
                else
                {
                    //nie ma obiektow do zaopatrzenia - wracamy do punktu zbiorki
                    if (GetSupplyCenterBuilding() != null)
                    {
                        m_nMoveToX = GetSupplyCenterAssemblyPositionX();
                        m_nMoveToY = GetSupplyCenterAssemblyPositionY();
                        m_nMoveToZ = GetSupplyCenterAssemblyPositionZ();
                        CallMoveToPoint(m_nMoveToX, m_nMoveToY, m_nMoveToZ);
                        return MovingToAssemblyPoint;
                    }
                    else
                    {
                        return Nothing;
                    }
                }
            }
            else
            {
                //nie ma obiektow do zaopatrzenia - wracamy do punktu zbiorki
                if (GetSupplyCenterBuilding() != null)
                {
                    m_nMoveToX = GetSupplyCenterAssemblyPositionX();
                    m_nMoveToY = GetSupplyCenterAssemblyPositionY();
                    m_nMoveToZ = GetSupplyCenterAssemblyPositionZ();
                    CallMoveToPoint(m_nMoveToX, m_nMoveToY, m_nMoveToZ);
                    return MovingToAssemblyPoint;
                }
                else
                {
                    return Nothing;
                }
            }
        }
    }

    state PuttingAmmo
    {
        int bIsEnd;
        if (IsPuttingAmmo())
        {
            return PuttingAmmo;
        }
        else
        {
            //sprawdzic czy wrzucono amunicje do biezacego obiektu
            if (WasCurrentObjectSupplied())
            {
                //ok jedziemy do nastepnego
                bIsEnd = false;
                do
                {
                    if (!NextObjectForSupply())
                    {
                        bIsEnd = true;
                    }
                }
                while (!bIsEnd && !CanCurrentObjectBeSupplied());
                if (!bIsEnd)
                {
                    m_nMoveToX = GetCurrentPutSupplyPositionX();
                    m_nMoveToY = GetCurrentPutSupplyPositionY();
                    m_nMoveToZ = GetCurrentPutSupplyPositionZ();
                    CallMoveToPointForce(m_nMoveToX, m_nMoveToY, m_nMoveToZ);
                    return MovingToObjectForSupply;
                }
                else
                {
                    //nie ma juz obiektow do zaopatrzenia - wracamy do punktu zbiorki
                    if (GetSupplyCenterBuilding() != null)
                    {
                        m_nMoveToX = GetSupplyCenterAssemblyPositionX();
                        m_nMoveToY = GetSupplyCenterAssemblyPositionY();
                        m_nMoveToZ = GetSupplyCenterAssemblyPositionZ();
                        CallMoveToPoint(m_nMoveToX, m_nMoveToY, m_nMoveToZ);
                        return MovingToAssemblyPoint;
                    }
                    else
                    {
                        return Nothing;
                    }
                }
            }
            else
            {
                //nie wrzucilismy zaopatrzenia do niego bo np. odjechal
                bIsEnd = false;
                while (!bIsEnd && !CanCurrentObjectBeSupplied())
                {
                    if (!NextObjectForSupply())
                    {
                        bIsEnd = true;
                    }
                }
                if (!bIsEnd)
                {
                    m_nMoveToX = GetCurrentPutSupplyPositionX();
                    m_nMoveToY = GetCurrentPutSupplyPositionY();
                    m_nMoveToZ = GetCurrentPutSupplyPositionZ();
                    CallMoveToPointForce(m_nMoveToX, m_nMoveToY, m_nMoveToZ);
                    return MovingToObjectForSupply;
                }
                else
                {
                    //nie ma obiektow do zaopatrzenia - wracamy do punktu zbiorki
                    if (GetSupplyCenterBuilding() != null)
                    {
                        m_nMoveToX = GetSupplyCenterAssemblyPositionX();
                        m_nMoveToY = GetSupplyCenterAssemblyPositionY();
                        m_nMoveToZ = GetSupplyCenterAssemblyPositionZ();
                        CallMoveToPoint(m_nMoveToX, m_nMoveToY, m_nMoveToZ);
                        return MovingToAssemblyPoint;
                    }
                    else
                    {
                        return Nothing;
                    }
                }
            }
        }
    }

    //-------------------------------------------------------
    state Froozen
    {
        if (IsFroozen())
        {
            state Froozen;
        }
        else
        {
            //!!wrocic do tego co robilismy
            state Nothing;
        }
    }

    event OnFreezeForSupplyOrRepair(int nFreezeTicks)
    {
        CallFreeze(nFreezeTicks);
        state Froozen;
        true;
    }
    event OnKilledSupplyCenterBuilding()
    {
        unit uNewSupplyCenter;
        if(!GetSupplyCenterBuilding())//przeniesc do eventu
        {
            uNewSupplyCenter = FindSupplyCenter();
            if ((uNewSupplyCenter != null) && SetSupplyCenterBuilding(uNewSupplyCenter))
            {
                //pojechac do jego punktu zbiorki o ile nie rozwozimy zaopatrzenia
                m_nMoveToX = GetSupplyCenterAssemblyPositionX();
                m_nMoveToY = GetSupplyCenterAssemblyPositionY();
                m_nMoveToZ = GetSupplyCenterAssemblyPositionZ();
                CallMoveToPoint(m_nMoveToX, m_nMoveToY, m_nMoveToZ);
                return MovingToAssemblyPoint;
            }
        }
    }
    //-------------------------------------------------------

    command Initialize()
    {
        false;
    }

    command Uninitialize()
    {
        //wykasowac referencje
        false;
    }

    command SetTransporterSupplyCenter(unit uSupplyCenter) hidden button "translateCommandSetSupplyCntr"
    {
        if (GetSupplyCenterBuilding() != uSupplyCenter)
        {
            if (SetSupplyCenterBuilding(uSupplyCenter))
            {
                //pojechac do jego punktu zbiorki o ile nie rozwozimy zaopatrzenia
                if (!HaveObjectsForSupply())
                {
                    m_nMoveToX = GetSupplyCenterAssemblyPositionX();
                    m_nMoveToY = GetSupplyCenterAssemblyPositionY();
                    m_nMoveToZ = GetSupplyCenterAssemblyPositionZ();
                    CallMoveToPoint(m_nMoveToX, m_nMoveToY, m_nMoveToZ);
                    state MovingToAssemblyPoint;
                }
                NextCommand(true);
            }
            else
            {
                NextCommand(false);
            }
        }
        else
        {
            if (!HaveObjectsForSupply() && (state != MovingToSupplyCenter))
            {
                m_nMoveToX = GetSupplyCenterAssemblyPositionX();
                m_nMoveToY = GetSupplyCenterAssemblyPositionY();
                m_nMoveToZ = GetSupplyCenterAssemblyPositionZ();
                CallMoveToPoint(m_nMoveToX, m_nMoveToY, m_nMoveToZ);
                state MovingToAssemblyPoint;
            }
            NextCommand(true);
        }
        true;
    }

    //komenda wydawana tylko przez budynek supplyCenter
    command MoveToSupplyCenterForLoading()
    {
        if (!HaveObjectsForSupply() && (state != LoadingAmmo))
        {
            m_nMoveToX = GetSupplyCenterLoadPositionX();
            m_nMoveToY = GetSupplyCenterLoadPositionY();
            m_nMoveToZ = GetSupplyCenterLoadPositionZ();
            //CallMoveAndLandToPointForce(m_nMoveToX, m_nMoveToY, m_nMoveToZ);
                        CallMoveToPointForce(m_nMoveToX, m_nMoveToY, m_nMoveToZ);//dodane 09.03.2000
            state MovingToSupplyCenter;
        }
        //komenda wewnetrzna z budynku wiec nie wolamy NextCommand
        true;
    }

    command Move(int nGx, int nGy, int nLz) hidden button "translateCommandMove" description "translateCommandMoveDescription" hotkey priority 21
    {
        m_nMoveToX = nGx;
        m_nMoveToY = nGy;
        m_nMoveToZ = nLz;
        CallMoveToPoint(m_nMoveToX, m_nMoveToY, m_nMoveToZ);
        state StartMoving;
        true;
    }

    command Enter(unit uEntrance) hidden button "translateCommandEnter"
    {
        m_nMoveToX = GetEntranceX(uEntrance);
        m_nMoveToY = GetEntranceY(uEntrance);
        m_nMoveToZ = GetEntranceZ(uEntrance);
        CallMoveInsideObject(uEntrance);
        state StartMoving;
        true;
    }

    command Stop() hidden button "translateCommandStop" description "translateCommandStopDescription" hotkey priority 20
    {
        CallStopMoving();
        state Nothing;
        true;
    }
    command Land() button "translateCommandLand" description "translateCommandLandDescription" hotkey priority 31
    {
        CallLand();
        state Nothing;
    }

    //-------------------------------------------------------
    command SpecialChangeUnitsScript() button "translateCommandChangeScript" description "translateCommandChangeScriptDescription" hotkey priority 254
    {
        //special command - no implementation
    }
    //-------------------------------------------------------
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
        SetLightsMode(lights);
    }
}
