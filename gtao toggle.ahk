#Requires AutoHotkey v2.0

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
    toggle(mode, keyName, holdTime:=50, intervals:=50, info:="") {

        if this.toggles.Get(keyName, false) {
            SetTimer this.toggles[keyName]["callback"], 0
            if mode == "hold" {
                Send "{" keyName " up}"
            }
            this.toggles.Delete(keyName) 
            this.updateTooltips_()
            return
        }

        hold_(mode, keyName, holdTime){
            Send "{" keyName " down}"
            sleep holdTime
            if mode == "spam"{
                Send "{" keyName " up}"
            }
        }
        callback := hold_.Bind(mode, keyName, holdTime)

        setKey_() {
            this.toggles[keyName] := Map(
                "callback", callback,
                "mode", mode,
                "info", info,
                "holdTime", holdTime,
                "intervals", intervals
            )
            this.updateTooltips_()
            return callback
        }
        
        callback()
        SetTimer setKey_(), intervals
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
