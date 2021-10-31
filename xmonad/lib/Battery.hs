module Battery where

----------------------------------------
-- BATTERY PLUGIN
----------------------------------------

import Xmobar
import Utils

import System.FilePath ((</>))

batteryBaseDir    = "/sys/class/power_supply/BAT0"  -- where the following files are located 
fullEnergyFile    = "energy_full"                   -- energy when battery is full
currEnergyFile    = "energy_now"                    -- current energy of the battery
statusFile        = "status"                        -- status file to read from 
dischargingStatus = ["Discharging"]                 -- possible file contents of the statusFile, indicating the battery is discharging

-- Battery symbols
battery0        = "\xF582" `withFont` 1
battery10       = "\xF579" `withFont` 1
battery20       = "\xF57A" `withFont` 1
battery30       = "\xF57B" `withFont` 1
battery40       = "\xF57C" `withFont` 1
battery50       = "\xF57D" `withFont` 1
battery60       = "\xF57E" `withFont` 1
battery70       = "\xF57F" `withFont` 1
battery80       = "\xF580" `withFont` 1
battery90       = "\xF581" `withFont` 1
battery100      = "\xF578" `withFont` 1
batteryCharging = "\xF583" `withFont` 1


getBatteryIcon :: Int -> String
getBatteryIcon charge
  | charge  < 10  = battery0
  | charge  < 20  = battery10
  | charge  < 30  = battery20
  | charge  < 40  = battery30
  | charge  < 50  = battery40
  | charge  < 60  = battery50
  | charge  < 70  = battery60
  | charge  < 80  = battery70
  | charge  < 90  = battery80
  | charge  < 100 = battery90
  | charge == 100 = battery100
  | otherwise     = "Something's wrong!"


batteryStatusText :: IO String
batteryStatusText = do
    energyNow     <- readAlphaNumFile (batteryBaseDir </> currEnergyFile)
    energyFull    <- readAlphaNumFile (batteryBaseDir </> fullEnergyFile)
    chargingState <- readAlphaNumFile (batteryBaseDir </> statusFile)
    let percentageEnergy = round ((read energyNow :: Float) / (read energyFull :: Float) * 100)

    let endingText = " " ++ show percentageEnergy ++ "%"
    let chosenIcon = if chargingState `elem` dischargingStatus
                     then getBatteryIcon percentageEnergy
                     else batteryCharging

    return (chosenIcon ++ endingText) :: IO String

data MyBattery = MyBattery Int
    deriving (Read, Show)

instance Exec MyBattery where
    rate  (MyBattery r) = r
    alias (MyBattery _) = "mybat"
    run   (MyBattery r) = batteryStatusText
