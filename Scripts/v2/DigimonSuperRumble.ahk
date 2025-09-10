#Requires AutoHotkey v2.0

F4:: ExitApp()

interfaz := Gui('-MaximizeBox -MinimizeBox', '[DNK]{AHK}{DSR}')
lTitle := interfaz.AddText('Center w300 vTitle', 'Digimon Super Rumble')
tTabs := interfaz.AddTab3('w280', ['KeyBinds', 'Options'])

tTabs.UseTab('KeyBinds')
hkF4 := interfaz.AddHotkey('Disabled w20 Section vF4', 'F4')
tF4 := interfaz.AddText('ys+5 vtF4', 'Cerrar el programa')
hkFG := interfaz.AddHotkey('Disabled w20 xs Section vFG', 'F5')
chkFG := interfaz.AddCheckbox('Disabled ys+5 vcFG')
tFG := interfaz.AddText('ys+5 vtFG', 'Farmeo: FGGG cada 100ms')
hkFFF := interfaz.AddHotkey('Disabled w20 xs Section vFFF', 'F6')
chkFFF := interfaz.AddCheckbox('Disabled ys+5 vcFFF')
tFFF := interfaz.AddText('ys+5 vtFFF', 'Skip: F cada 100ms')

tTabs.UseTab('Options')

tTabs.UseTab()
btnSalir := interfaz.AddButton('Default Center x240 w50 vSalir', 'Salir')
btnSalir.OnEvent('Click', Salir)

Salir(*)
{
    ExitApp()
}

SetKeyDelay(100)
ventana := "ahk_exe Client-Win64-Shipping.exe"
farmeo := false

StopTimers() {
    SetTimer(FG, 0)
    SetTimer(FFF, 0)
    global farmeo := false
    chkFG.Value := false
    chkFFF.Value := false
}

F9::
{
    if (!WinActive(interfaz.Hwnd)) {
        interfaz.Show('w300')
    } else {
        interfaz.Hide()
    }
}

F5:: {
    global farmeo
    if !farmeo {
        farmeo := true
        chkFG.Value := true
        SetTimer(FG, 100)
    } else {
        StopTimers()
    }
}

F6:: {
    global farmeo
    if !farmeo {
        farmeo := true
        chkFFF.Value := true
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