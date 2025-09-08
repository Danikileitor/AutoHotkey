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

F9::
{
    interfaz.Show('w300')
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
        Reload()
    }
}

F6:: {
    global farmeo
    if !farmeo {
        farmeo := 1
        SetTimer(FFF, 100)
    } else {
        Reload()
    }
}

XButton2:: {
    if WinExist(ventana) {
        ControlSend("{w down}", , ventana)
    } else {
        ExitApp()
    }
    Send("{XButton2}")
}

XButton1:: {
    if WinExist(ventana) {
        ControlSend("{w up}", , ventana)
    } else {
        ExitApp()
    }
    Send("{XButton1}")
}

FG() {
    if WinExist(ventana) {
        ControlSend("fggg", , ventana)
    } else {
        ExitApp()
    }
}

FFF() {
    if WinExist(ventana) {
        ControlSend("f", , ventana)
    } else {
        ExitApp()
    }
}