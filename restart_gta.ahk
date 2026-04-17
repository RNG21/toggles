restartGTA(multiplier := 1) {    
    waitClose(name, timeout) {
        start := A_TickCount
        timeoutMs := timeout * 1000

        while ProcessExist(name) {
            if (A_TickCount - start >= timeoutMs)
                return false
            Sleep 100
        }
        return true
    }

    if ProcessExist("GTA5_Enhanced.exe"){
        Run 'taskkill /f /im GTA5_Enhanced.exe', , "Hide"
        waitClose("SocialClubHelper.exe", 120 * multiplier)
    }
    Run "steam://rungameid/3240220"
    WinWait ("ahk_exe GTA5_Enhanced.exe", 180 * multiplier)
    Sleep 75000 * multiplier
    WinActivate "ahk_exe GTA5_Enhanced.exe"


    press(key, wait := 1) {
        wait *= 1000
        Send "{" . key . " down}"
        Sleep 100
        Send "{" . key . " up}"
        Sleep wait
    }

    ; Select story
    loop 2 {
        press("e")
    }
    press("Enter", 20 * multiplier + 5)

    ; Select online tab in pause menu
    WinActivate "ahk_exe GTA5_Enhanced.exe"
    press("p")
    loop 5 {
        press("e")
    }
    press("Enter", 5)
    ; Enter online
    loop 2 {
        press("w")
        press("Enter")
    }
    press("Enter", 30 * multiplier + 5)

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
