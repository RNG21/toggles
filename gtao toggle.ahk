#Requires AutoHotkey v2.0
#Include restart_gta.ahk

class Toggles {

    __New() {
        CoordMode "ToolTip", "Screen"
        this.toggles := Map()
    }

    /**
     * Starts/Ends a toggle key
     * Only works with single keys
     * @param mode Literal, spam or hold
     * @param keyName the key to spam or hold
     * @param holdTime time to hold down the key for in one iteration
     * @param intervals delay until key is pressed again
     * @param info extra info for the toggle
     */
    toggle(mode, keyName, holdTime:=50, intervals:=50, info:="", callback?) {
        identifier := mode . keyName

        if this.toggles.Get(identifier, false) {
            SetTimer this.toggles[identifier]["callback"], 0
            if mode == "hold" {
                Send "{" keyName " up}"
            }
            this.toggles.Delete(identifier) 
            this.updateTooltips_()
            return
        }

        hold_(mode, keyName, holdTime){
            if IsSet(callback) {
                callback()
            }
            Send "{" keyName " down}"
            sleep holdTime
            if mode == "spam"{
                Send "{" keyName " up}"
            }
        }
        mCallback := hold_.Bind(mode, keyName, holdTime)

        ; Store and display
        this.toggles[identifier] := Map(
            "callback", mCallback,
            "mode", mode,
            "info", info,
            "holdTime", holdTime,
            "intervals", intervals
        )
        this.updateTooltips_()
        
        mCallback()
        SetTimer mCallback, intervals
    }

    /**
     * Show tooltips to display which keys are currently active
     * @param deleteAll deletes all tooltips if true
     */
    updateTooltips_(deleteAll:=false) {

        ; Delete all tooltips
        loop 20 {
            i := A_Index
            ToolTip("",,,i)
        }
        
        ; Add tooltips
        i := 1
        for keyName, inner in this.toggles {
            callback := inner["callback"]
            info := inner["info"]
            mode := inner["mode"]
            suffix := info != "" ? " " info : info  ; Adds space in front if not empty str

            ToolTip(keyName suffix, 3, 650+20*i, i)
            i += 1
        }
    }

    /**
     * Stops all hotkeys
     */
    stopAll(){
        ; Stop all callbacks
        for keyName, inner in this.toggles {
            SetTimer inner["callback"], 0
            Send "{" keyName " up}"
        }
        ; Reset vars
        this.toggles := Map()
        this.updateTooltips_(true)
    }
}


t := Toggles()
*>^F1::t.toggle("spam", "w",, 300000,, WinActivate.Bind("ahk_exe GTA5_Enhanced.exe"))
*>^F2:: {
    if t.toggles.Has("spamw") {
        t.toggle("spam", "w")
    }
    restartGTA(2)
    t.toggle("spam", "w",, 300000,, WinActivate.Bind("ahk_exe GTA5_Enhanced.exe"))
}

^+F12::t.stopAll()

