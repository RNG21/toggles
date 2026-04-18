restartGTA(multiplier := 1) {    
    wait(name, timeout, waitClose:=true) {
        start := A_TickCount
        timeoutMs := timeout * 1000

        while (ProcessExist(name) ? waitClose : !waitClose) {
            if (A_TickCount - start >= timeoutMs)
                return false
            Sleep 100
        }
        return true
    }
    waitClose(name, timeout) {
        return wait(name, timeout, true)
    }
    waitStart(name, timeout) {
        return wait(name, timeout, false)
    }

    if ProcessExist("GTA5_Enhanced.exe"){
        Run('taskkill /f /im GTA5_Enhanced.exe', , "Hide")
        waitClose("SocialClubHelper.exe", 120)
    }
    Run("steam://rungameid/3240220")
    WinWait("Grand Theft Auto V",, 120)
    Sleep(70000 * multiplier)
    WinActivate("ahk_exe GTA5_Enhanced.exe")


    press(key, wait := 0.5) {
        wait *= 1000
        Send("{" . key . " down}")
        Sleep(100)
        Send("{" . key . " up}")
        Sleep(wait)
    }

    ; Select story
    loop 3 {
        press("e", 1)
    }
    press("Enter", 20 * multiplier)

    ; Select online tab in pause menu
    WinActivate("ahk_exe GTA5_Enhanced.exe")
    press("p")
    loop 5 {
        press("e")
    }
    press("Enter", 3)
    ; Enter online
    loop 2 {
        press("w")
        press("Enter")
    }
    press("Enter", 30 * multiplier)

    ; Enter job
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
    press("Enter")
    press("Enter")
}
