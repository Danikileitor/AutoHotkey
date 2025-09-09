#Requires AutoHotkey v2.0

F4:: ExitApp()

interfaz := Gui('-MaximizeBox -MinimizeBox', '[DNK]{AHK}{DSR}')
lTitle := interfaz.AddText('Center w300 vTitle', 'Digimon Super Rumble')
tTabs := interfaz.AddTab3('w280', ['KeyBinds', 'Options'])

tTabs.UseTab('KeyBinds')
hkFG := interfaz.AddHotkey('vFG', 'F5')
hkF := interfaz.AddHotkey('vF', 'F6')

tTabs.UseTab()
btnSalir := interfaz.AddButton('Default Center x240 w50 vSalir', 'Salir')
btnSalir.OnEvent('Click', Salir)

Salir(*)
{
    ExitApp()
}

StopTimers() {
    SetTimer(FG, 0)
    SetTimer(FFF, 0)
}

F9::
{
    if (!WinActive(interfaz.Hwnd)) {
        interfaz.Show('w300')
    } else {
        interfaz.Hide()
    }
}

SetKeyDelay(100)
ventana := "ahk_exe Client-Win64-Shipping.exe"
farmeo := 0

F5:: {
    global farmeo
    if !farmeo {
        farmeo := 1
        SetTimer(FG, 100)
    } else {
        StopTimers()
    }
}

F6:: {
    global farmeo
    if !farmeo {
        farmeo := 1
        SetTimer(FFF, 100)
    } else {
        StopTimers()
    }
}

XButton2:: {
    if WinExist(ventana) {
        ControlSend("{w down}", , ventana)
    }
    Send("{XButton2}")
}

XButton1:: {
    if WinExist(ventana) {
        ControlSend("{w up}", , ventana)
    }
    Send("{XButton1}")
}

FG() {
    if WinExist(ventana) {
        ControlSend("fggg", , ventana)
    } else {
        StopTimers()
    }
}

FFF() {
    if WinExist(ventana) {
        ControlSend("f", , ventana)
    } else {
        StopTimers()
    }
}