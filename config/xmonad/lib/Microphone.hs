module Microphone where

----------------------------------------
-- MICROPHONE PLUGIN
----------------------------------------

import Sound.ALSA.Mixer
import Utils
import Xmobar

-- Playback file (https://stackoverflow.com/questions/35772758/alsa-how-to-programmatically-find-if-a-device-is-busy-in-use-using-it-name-and/39260690)
micMicrophoneRunningFile = "/proc/asound/card0/pcm0c/sub0/status"

micClosedState = "closed"

micAlsaInput = "alsa_input.pci-0000_00_1f.3.analog-stereo"

-- Icons
micIconOn = " \xF86B " `withFont` 1

micIconOff = " \xF86C " `withFont` 1

micIsMuted :: IO Bool
micIsMuted =
  withMixer "default" $ \mixer -> do
    Just control <- getControlByName mixer "Capture"
    let Just captureSwitch = capture $ switch control
    Just sw <- getChannel FrontLeft captureSwitch
    return $ not sw

micIsRunning :: IO Bool
micIsRunning = do
  status <- readAlphaNumFile micMicrophoneRunningFile
  return $ status /= micClosedState

micToggleMuteCommand :: String
micToggleMuteCommand = "pactl set-source-mute " ++ micAlsaInput ++ " toggle"

micStatusText :: String -> IO String
micStatusText bgColor = do
  isRunning <- micIsRunning
  isMuted <- micIsMuted
  let command = micToggleMuteCommand
  let stateString
        | not isRunning = ""
        | isMuted = wrapWithColors micIconOff "darkred" "#DDDDDD" `wrapWithAction` command
        | otherwise = micIconOn `wrapWithAction` command

  -- Formatting stuff
  if stateString == ""
    then return (stateString ++ wrapWithColors arrowLeft "#a0a0a0" bgColor)
    else return (doArrow LeftArrow stateString "#DDDDDD" "#222222" bgColor ++ wrapWithColors arrowLeft "#a0a0a0" "#DDDDDD")

data MyMicrophone = MyMicrophone String Int
  deriving (Read, Show)

instance Exec MyMicrophone where
  rate (MyMicrophone _ r) = r
  alias (MyMicrophone _ _) = "mymic"
  run (MyMicrophone bg _) = micStatusText bg
