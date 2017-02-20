rem Copyright 2009-2017 surrim
rem
rem This file is part of OSMod.
rem
rem OSMod is free software: you can redistribute it and/or modify
rem it under the terms of the GNU General Public License as published by
rem the Free Software Foundation, either version 3 of the License, or
rem (at your option) any later version.
rem
rem OSMod is distributed in the hope that it will be useful,
rem but WITHOUT ANY WARRANTY; without even the implied warranty of
rem MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
rem GNU General Public License for more details.
rem
rem You should have received a copy of the GNU General Public License
rem along with OSMod.  If not, see <http://www.gnu.org/licenses/>.
rem

echo off
rem To run this script you have to add the 7z folder to your
rem rem "PATH" environment variable.
rem cls

path Tools;%path%
rd Work /s /q > nul
del OSMod.7z > nul
cd Scripts
del /s /q *.ecoMP
cd ..

mkdir Work
mkdir Work\WDFiles
xcopy Base Work /s /e

earthcmp Scripts\AIPlayers\1_Easy.ec Work\Scripts\AIPlayers\1_Easy.ecoMP
earthcmp Scripts\AIPlayers\2_Medium.ec Work\Scripts\AIPlayers\2_Medium.ecoMP
earthcmp Scripts\AIPlayers\3_Hard.ec Work\Scripts\AIPlayers\3_Hard.ecoMP
earthcmp Scripts\AIPlayers\4_Expert.ec Work\Scripts\AIPlayers\4_Expert.ecoMP
earthcmp Scripts\AIPlayers\5_TDBot.ec Work\Scripts\AIPlayers\5_TDBot.ecoMP
earthcmp Scripts\AIPlayers\Single\singleDefault.ec Work\Scripts\AIPlayers\Single\singleDefault.ecoMP
earthcmp Scripts\AIPlayers\Single\singleEasy.ec Work\Scripts\AIPlayers\Single\singleEasy.ecoMP
earthcmp Scripts\AIPlayers\Single\singleHard.ec Work\Scripts\AIPlayers\Single\singleHard.ecoMP
earthcmp Scripts\AIPlayers\Single\singleMedium.ec Work\Scripts\AIPlayers\Single\singleMedium.ecoMP
earthcmp Scripts\GameTypes\Arena.ec Work\Scripts\GameTypes\Arena.ecoMP
earthcmp Scripts\GameTypes\CaptureTheFlag.ec Work\Scripts\GameTypes\CaptureTheFlag.ecoMP
earthcmp Scripts\GameTypes\EarnMoney.ec Work\Scripts\GameTypes\EarnMoney.ecoMP
earthcmp Scripts\GameTypes\HarvestAndKill.ec Work\Scripts\GameTypes\HarvestAndKill.ecoMP
rem earthcmp Scripts\GameTypes\HarvestAndKillDemo.ec Work\Scripts\GameTypes\HarvestAndKillDemo.ecoMP
earthcmp Scripts\GameTypes\DestroyEnemyStructures.ec Work\Scripts\GameTypes\_DestroyEnemyStructures.ecoMP
earthcmp Scripts\GameTypes\UncleSam.ec Work\Scripts\GameTypes\UncleSam.ecoMP
earthcmp Scripts\GameTypes\Single\Arena.ec Work\Scripts\GameTypes\Single\Arena.ecoMP
earthcmp Scripts\GameTypes\Single\CaptureTheFlag.ec Work\Scripts\GameTypes\Single\CaptureTheFlag.ecoMP
earthcmp Scripts\GameTypes\Single\DieHard4MP.ec Work\Scripts\GameTypes\Single\DieHard4MP.ecoMP
earthcmp Scripts\GameTypes\Single\EarnMoney.ec Work\Scripts\GameTypes\Single\EarnMoney.ecoMP
earthcmp Scripts\GameTypes\Single\HarvestAndKill.ec Work\Scripts\GameTypes\Single\HarvestAndKill.ecoMP
copy Work\Scripts\GameTypes\_DestroyEnemyStructures.ecoMP Work\Scripts\GameTypes\Single\_DestroyEnemyStructures.ecoMP
earthcmp Scripts\GameTypes\Single\UncleSam.ec Work\Scripts\GameTypes\Single\UncleSam.ecoMP
earthcmp Scripts\Units\Builder.ec Work\Scripts\Units\Builder.ecoMP
earthcmp Scripts\Units\Carrier.ec Work\Scripts\Units\Carrier.ecoMP
earthcmp Scripts\Units\Civil.ec Work\Scripts\Units\Civil.ecoMP
earthcmp Scripts\Units\CivilLightsOff.ec Work\Scripts\Units\CivilLightsOff.ecoMP
earthcmp Scripts\Units\Harvester.ec Work\Scripts\Units\Harvester.ecoMP
earthcmp Scripts\Units\Helicopter.ec Work\Scripts\Units\Helicopter.ecoMP
earthcmp Scripts\Units\Platoon.ec Work\Scripts\Units\Platoon.ecoMP
earthcmp Scripts\Units\Repairer.ec Work\Scripts\Units\Repairer.ecoMP
earthcmp Scripts\Units\Sapper.ec Work\Scripts\Units\Sapper.ecoMP
earthcmp Scripts\Units\Supplier.ec Work\Scripts\Units\Supplier.ecoMP
earthcmp Scripts\Units\Tank.ec Work\Scripts\Units\Tank.ecoMP
earthcmp Scripts\Units\TankHoldPos.ec Work\Scripts\Units\TankHoldPos.ecoMP
earthcmp Scripts\Units\TankLightsOff.ec Work\Scripts\Units\TankLightsOff.ecoMP
earthcmp Scripts\Units\Transporter.ec Work\Scripts\Units\Transporter.ecoMP
earthcmp Scripts\Units\AI\Builder.ec Work\Scripts\Units\AI\Builder.ecoMP
earthcmp Scripts\Units\AI\Carrier.ec Work\Scripts\Units\AI\Carrier.ecoMP
earthcmp Scripts\Units\AI\Civil.ec Work\Scripts\Units\AI\Civil.ecoMP
earthcmp Scripts\Units\AI\CivilEmpty.ec Work\Scripts\Units\AI\CivilEmpty.ecoMP
earthcmp Scripts\Units\AI\Harvester.ec Work\Scripts\Units\AI\Harvester.ecoMP
earthcmp Scripts\Units\AI\Helicopter.ec Work\Scripts\Units\AI\Helicopter.ecoMP
earthcmp Scripts\Units\AI\Platoon.ec Work\Scripts\Units\AI\Platoon.ecoMP
earthcmp Scripts\Units\AI\Repairer.ec Work\Scripts\Units\AI\Repairer.ecoMP
earthcmp Scripts\Units\AI\Sapper.ec Work\Scripts\Units\AI\Sapper.ecoMP
earthcmp Scripts\Units\AI\Supplier.ec Work\Scripts\Units\AI\Supplier.ecoMP
earthcmp Scripts\Units\AI\Tank.ec Work\Scripts\Units\AI\Tank.ecoMP
earthcmp Scripts\Units\AI\Transporter.ec Work\Scripts\Units\AI\Transporter.ecoMP

earthc Work\Scripts\AIPlayers\1_Easy.ecoMP --id >> Work\Parameters\gamescripts.txt
earthc Work\Scripts\AIPlayers\2_Medium.ecoMP --id >> Work\Parameters\gamescripts.txt
earthc Work\Scripts\AIPlayers\3_Hard.ecoMP --id >> Work\Parameters\gamescripts.txt
earthc Work\Scripts\AIPlayers\4_Expert.ecoMP --id >> Work\Parameters\gamescripts.txt
earthc Work\Scripts\AIPlayers\5_TDBot.ecoMP --id >> Work\Parameters\gamescripts.txt
earthc Work\Scripts\AIPlayers\Single\singleDefault.ecoMP --id >> Work\Parameters\gamescripts.txt
earthc Work\Scripts\AIPlayers\Single\singleEasy.ecoMP --id >> Work\Parameters\gamescripts.txt
earthc Work\Scripts\AIPlayers\Single\singleHard.ecoMP --id >> Work\Parameters\gamescripts.txt
earthc Work\Scripts\AIPlayers\Single\singleMedium.ecoMP --id >> Work\Parameters\gamescripts.txt
earthc Work\Scripts\GameTypes\Arena.ecoMP --id >> Work\Parameters\gamescripts.txt
earthc Work\Scripts\GameTypes\CaptureTheFlag.ecoMP --id >> Work\Parameters\gamescripts.txt
earthc Work\Scripts\GameTypes\EarnMoney.ecoMP --id >> Work\Parameters\gamescripts.txt
earthc Work\Scripts\GameTypes\HarvestAndKill.ecoMP --id >> Work\Parameters\gamescripts.txt
rem earthc Work\Scripts\GameTypes\HarvestAndKillDemo.ecoMP --id >> Work\Parameters\gamescripts.txt
earthc Work\Scripts\GameTypes\UncleSam.ecoMP --id >> Work\Parameters\gamescripts.txt
earthc Work\Scripts\GameTypes\_DestroyEnemyStructures.ecoMP --id >> Work\Parameters\gamescripts.txt
earthc Work\Scripts\GameTypes\Single\Arena.ecoMP --id >> Work\Parameters\gamescripts.txt
earthc Work\Scripts\GameTypes\Single\CaptureTheFlag.ecoMP --id >> Work\Parameters\gamescripts.txt
earthc Work\Scripts\GameTypes\Single\DieHard4MP.ecoMP --id >> Work\Parameters\gamescripts.txt
earthc Work\Scripts\GameTypes\Single\EarnMoney.ecoMP --id >> Work\Parameters\gamescripts.txt
earthc Work\Scripts\GameTypes\Single\HarvestAndKill.ecoMP --id >> Work\Parameters\gamescripts.txt
earthc Work\Scripts\GameTypes\Single\UncleSam.ecoMP --id >> Work\Parameters\gamescripts.txt
earthc Work\Scripts\Units\Builder.ecoMP --setbuilderid
earthc Work\Scripts\Units\Carrier.ecoMP --setcarrierid
earthc Work\Scripts\Units\Civil.ecoMP --setcivilid
earthc Work\Scripts\Units\CivilLightsOff.ecoMP --setcivillightsoffid
earthc Work\Scripts\Units\Harvester.ecoMP --setharvesterid
earthc Work\Scripts\Units\Helicopter.ecoMP --sethelicopterid
earthc Work\Scripts\Units\Platoon.ecoMP --setplatoonid
earthc Work\Scripts\Units\Repairer.ecoMP --setrepairerid
earthc Work\Scripts\Units\Sapper.ecoMP --setsapperid
earthc Work\Scripts\Units\Supplier.ecoMP --setsupplierid
earthc Work\Scripts\Units\Tank.ecoMP --settankid
earthc Work\Scripts\Units\TankHoldPos.ecoMP --settankholdposid
earthc Work\Scripts\Units\TankLightsOff.ecoMP --settanklightsoffid
earthc Work\Scripts\Units\Transporter.ecoMP --settransporterid
earthc Work\Scripts\Units\AI\Builder.ecoMP --setaibuilderid
earthc Work\Scripts\Units\AI\Carrier.ecoMP --setaicarrierid
earthc Work\Scripts\Units\AI\Civil.ecoMP --setaicivilid
earthc Work\Scripts\Units\AI\CivilEmpty.ecoMP --setaicivilemptyid
earthc Work\Scripts\Units\AI\Harvester.ecoMP --setaiharvesterid
earthc Work\Scripts\Units\AI\Helicopter.ecoMP --setaihelicopterid
earthc Work\Scripts\Units\AI\Platoon.ecoMP --setaiplatoonid
earthc Work\Scripts\Units\AI\Repairer.ecoMP --setairepairerid
earthc Work\Scripts\Units\AI\Sapper.ecoMP --setaisapperid
earthc Work\Scripts\Units\AI\Supplier.ecoMP --setaisupplierid
earthc Work\Scripts\Units\AI\Tank.ecoMP --setaitankid
earthc Work\Scripts\Units\AI\Transporter.ecoMP --setaitransporterid

echo.|wdcreator Work\WDFiles\OSMod.wd p "Work/Banners/BannerDef.tex"
rem echo.|wdcreator Work\WDFiles\OSMod.wd p "Work/Interface/*.tex"
echo.|wdcreator Work\WDFiles\OSMod.wd p "Work/Language/*.lan"
echo.|wdcreator Work\WDFiles\OSMod.wd p "Work/Language/Credits.txt"
echo.|wdcreator Work\WDFiles\OSMod.wd p "Work/Meshes/*.msh"
echo.|wdcreator Work\WDFiles\OSMod.wd p "Work/Parameters/Earth2150.par"
echo.|wdcreator Work\WDFiles\OSMod.wd p "Work/Parameters/gamescripts.txt"
echo.|wdcreator Work\WDFiles\OSMod.wd p "Work/Parameters/objdef.txt"
echo.|wdcreator Work\WDFiles\OSMod.wd p "Work/Parameters/resnum.txt"
echo.|wdcreator Work\WDFiles\OSMod.wd p "Work/Parameters/updnum.txt"
echo.|wdcreator Work\WDFiles\OSMod.wd c "Work/Scripts/>.ecoMP"
echo.|wdcreator Work\WDFiles\OSMod.wd p "Work/Textures/*.tex"

rd Work\Banners Work\Interface Work\Language Work\Meshes Work\Parameters Work\Scripts Work\Textures /s /q

cd Work
7z a -r -t7z -mx9 ..\OSMod.7z
cd ..

rd Work /s /q
