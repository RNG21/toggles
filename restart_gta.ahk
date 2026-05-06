CoordMode("ToolTip", "Screen")

using_tooltips := Map()
/**
 * Tooltip that countdowns
 * @param text Text to prepend 
 * @param waitTime Time to wait in seconds
 * @param x Position of tooltip
 * @param y Position of tooltip
 * @param i Index of tooltip
 * @param endTime End Time in epoch, ignores waitTime if set
 */
tooltip_countdown(text, waitTime:=1, x:=3, y:=530, i:=11, endtime:=-1) {
    global using_tooltips
    using_tooltips[i] := text

    if endTime == -1 {
        endTime := waitTime * 1000 + A_TickCount
    }

    update_tooltip() {
        rem_time := endTime - A_TickCount
        time := rem_time < 1000
                ? Format("{:.1f}s", (endTime - A_TickCount) / 1000)
                : Floor((endTime - A_TickCount) / 1000) . "s"
        ToolTip(text . time, x, y, i)
        if A_TickCount <= endTime && using_tooltips[i]==text {
            SetTimer(update_tooltip, -100)
        } else {
            ToolTip("",,, i)
        }
    }

    update_tooltip()
}


/**
 * Wait for a process to start or close
 * @param name Name of process
 * @param timeout in seconds
 * @param waitClose wait close or start
 */
wait(name, timeout, waitClose:=true) {
    start := A_TickCount
    timeoutMs := timeout * 1000

    while (ProcessExist(name) ? waitClose : !waitClose) {
        if (A_TickCount - start >= timeoutMs)
            return false
        Sleep(100)
    }
    return true
}
waitClose(name, timeout) {  ; shorthand
    return wait(name, timeout, true)
}
waitStart(name, timeout) {  ; shorthand
    return wait(name, timeout, false)
}

/**
 * Presses a key in Blind mdoe
 * @param key key to press
 * @param wait wait time after pressing the key
 * @param holdTime time to hold the key down
 */
press(key, wait := 0.5, holdTime := 100) {
    wait *= 1000
    Send("{Blind}{" . key . " down}")
    Sleep(holdTime)
    Send("{Blind}{" . key . " up}")
    Sleep(wait)
}

; Load config
fileName := A_ScriptDir . "\timings.ini"
waitCloseTimeout := IniRead(fileName, "Timeout", "waitCloseTimeout", 120)
winWaitTimeout := IniRead(fileName, "Timeout", "winWaitTimeout", 300)
mainMenuWait := IniRead(fileName, "WaitTimes", "mainMenuWait", 130)
storyWait := IniRead(fileName, "WaitTimes", "storyWait", 120)
onlineWait := IniRead(fileName, "WaitTimes", "onlineWait", 80)


restartGTA() {    

    ; Restart GTA
    if ProcessExist("GTA5_Enhanced.exe"){
        Run('taskkill /f /im GTA5_Enhanced.exe', , "Hide")
        tooltip_countdown("Waiting close ", waitCloseTimeout)
        waitClose("SocialClubHelper.exe", waitCloseTimeout)
    }
    Run("steam://rungameid/3240220")

    ; Wait for GTA window
    tooltip_countdown("Waiting window ", winWaitTimeout)
    WinWait("Grand Theft Auto V",, winWaitTimeout)
    ToolTip("",,, 11)

    ; Wait for main menu
    tooltip_countdown("Waiting menu ", mainMenuWait)
    Sleep(mainMenuWait * 1000)

    ; Select story
    ToolTip("Select story", 3, 530, 11)
    WinActivate("ahk_exe GTA5_Enhanced.exe")
    loop 3 {
        press("e", 1)
    }
    tooltip_countdown("Waiting story ", storyWait)
    press("Enter", storyWait)

    ; Select online tab in pause menu
    ToolTip("Enter online", 3, 530, 11)
    WinActivate("ahk_exe GTA5_Enhanced.exe")
    press("p")
    loop 5 {  ; Select online tab
        press("e")
    }
    press("Enter", 3)
    loop 2 {  ; Enter online
        press("w")
        press("Enter")
    }
    tooltip_countdown("Waiting online ", onlineWait)
    press("Enter", onlineWait) ; Confirm online

    ; Enter job
    ToolTip("Enter job", 3, 530, 11)
    WinActivate "ahk_exe GTA5_Enhanced.exe"
    press("p") ; pause
    press("d", 3) ; online tab
    press("Enter") ; select online
    press("Enter") ; Jobs
    press("s") ; Play job
    press("Enter") ; Play job
    loop 2 {
        loop 3 {
            press("s") ; Rockstar created, Races
        }
        press("Enter")
    }
    press("Enter") ; Start job
    press("Enter") ; Confirm
    ToolTip("",,, 11)
}


