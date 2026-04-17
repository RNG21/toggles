#Requires AutoHotkey v2.0
#Include gtao toggle.ahk

t := Toggles()
*>^F1::t.toggle("hold", "w")
*>^F2::t.toggle("spam", "e")
*>^F3::t.toggle("spam", "LCtrl", 300, 10000)
*>^F4::t.toggle("spam", "Click")
*>^F5::t.toggle("hold", "x")
*>^F6::t.toggle("hold", "LShift")
*>^F7::t.toggle("spam", "Enter")

^+F12::t.stopAll()
