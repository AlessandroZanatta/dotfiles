module Plugins.Microphone where
----------------------------------------
-- MICROPHONE PLUGIN
----------------------------------------

import Xmobar
import Utils

import Sound.ALSA.Mixer

-- Playback file (https://stackoverflow.com/questions/35772758/alsa-how-to-programmatically-find-if-a-device-is-busy-in-use-using-it-name-and/39260690)
micMicrophoneRunningFile = "/proc/asound/card0/pcm0c/sub0/status"
micClosedState = "closed"

-- Icons
micIconOn  = " \xF86B " `withFont` 1
micIconOff = " \xF86C " `withFont` 1

micIsNotMuted :: IO Bool
micIsNotMuted =
    withMixer "default" $ \mixer -> do
        Just control <- getControlByName mixer "Capture"
        let Just captureSwitch = capture $ switch control
        Just sw <- getChannel FrontLeft captureSwitch
        return sw

micIsNotRunning :: IO Bool
micIsNotRunning = do
    status <- readAlphaNumFile micMicrophoneRunningFile
    return $ status == micClosedState

micStatusText :: String -> IO String
micStatusText bgColor = do
    isNotRunning  <- micIsNotRunning
    isNotMuted <- micIsNotMuted
    let stateString
          | isNotRunning = ""
          | isNotMuted = micIconOn  `wrapWithAction` "pactl set-source-mute 1 1"
          | otherwise = wrapWithColors micIconOff "darkred" "#DDDDDD" `wrapWithAction` "pactl set-source-mute 1 0"

    -- Formatting stuff 
    if stateString == ""
        then return (stateString ++ wrapWithColors arrowLeft "#a0a0a0" bgColor)
        else return (doArrow LeftArrow stateString "#DDDDDD" "#222222" bgColor ++ wrapWithColors arrowLeft "#a0a0a0" "#DDDDDD")

data MyMicrophone = MyMicrophone String Int
    deriving (Read, Show)

instance Exec MyMicrophone where
    rate  (MyMicrophone _ r) = r
    alias (MyMicrophone _ _) = "mymic"
    run   (MyMicrophone bg _) = micStatusText bg
