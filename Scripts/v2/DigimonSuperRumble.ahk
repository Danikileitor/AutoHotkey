#Requires AutoHotkey v2.0

;#################
;### Variables ###
;#################

/** La ventana del `Digimon Super Rumble`.*/
ventana := 'ahk_exe Client-Win64-Shipping.exe'
/** Boolean que indica si hay un timer activo.*/
timer := false
/** Boolean que indica si el timer `Comer` está activo.*/
comiendo := false
/** Boolean que indica si el timer `Beber` está activo.*/
bebiendo := false
/** Boolean que indica si el timer para `Mouse4` está activo.*/
timerM4 := false

;################
;### Interfaz ###
;################

interfaz := Gui('-MaximizeBox -MinimizeBox', '[DNK]{AHK}{DSR}')
lTitle := interfaz.AddText('Center w300 vTitle', 'Digimon Super Rumble')
sb := interfaz.AddStatusBar('vSB', 'Digimon Super Rumble')
sb.SetParts(250)
tTabs := interfaz.AddTab3('w280', ['KeyBinds', 'Opciones', 'Ayuda'])

tTabs.UseTab('Opciones')
tKeyDelay := interfaz.AddText('Section vtKeyDelay', 'Key Delay')
sdKeyDelay := interfaz.AddSlider('ys ToolTip Range50-1000 TickInterval50 Line50 Page50 Buddy1tKeyDelay Buddy2eKeyDelay vKeyDelay', 100)
sdKeyDelay.range := { min: 50, max: 1000 }
sdKeyDelay.interval := 50
eKeyDelay := interfaz.AddEdit('ys w50 Number Limit4 veKeyDelay')
uKeyDelay := interfaz.AddUpDown('ys Range50-1000 0x80 vuKeyDelay', 100)
uKeyDelay.edit := eKeyDelay
uKeyDelay.slider := sdKeyDelay
sdKeyDelay.UpDown := uKeyDelay
sdKeyDelay.OnEvent('Change', ControlChangeKeyDelay)
uKeyDelay.OnEvent('Change', ControlChangeKeyDelay)
chkTop := interfaz.AddCheckbox('xs Section vcTop', 'Siempre visible')
chkTop.OnEvent('Click', Top)

tTabs.UseTab('KeyBinds')
hkF4 := interfaz.AddHotkey('Disabled w24 Section vF4', 'F4')
tF4 := interfaz.AddText('ys+5 vtF4', 'Cerrar el programa')
hkFG := interfaz.AddHotkey('Disabled xs w24 Section vFG', 'F5')
chkFG := interfaz.AddCheckbox('ys+5 vcFG', ' Farmeo: FGGG cada ' . sdKeyDelay.range.max . 'ms')
chkFG.OnEvent('Click', OnClick)
hkFFF := interfaz.AddHotkey('Disabled xs w24 Section vFFF', 'F6')
chkFFF := interfaz.AddCheckbox('ys+5 vcFFF', ' Skip: F cada ' . sdKeyDelay.range.max . ' ms')
chkFFF.OnEvent('Click', OnClick)
hkComer := interfaz.AddHotkey('Disabled xs w24 Section vComer', 'F7')
chkComer := interfaz.AddCheckbox('ys w23 vcComer', ' Comer:')
cbComer := interfaz.AddComboBox('ys w30 Limit1 vcbComer', ['1', '3'])
cbComer.Choose(1)
tComer := interfaz.AddText('ys+5 vtComer', 'cada ' . sdKeyDelay.range.max . ' ms')
chkComer.OnEvent('Click', OnClick)
hkBeber := interfaz.AddHotkey('Disabled xs w24 Section vBeber', 'F8')
chkBeber := interfaz.AddCheckbox('ys w23 vcBeber', ' Beber:')
cbBeber := interfaz.AddComboBox('ys w30 Limit1 vcbBeber', ['2', '4'])
cbBeber.Choose(1)
tBeber := interfaz.AddText('ys+5 vtBeber', 'cada ' . sdKeyDelay.range.max . ' ms')
chkBeber.OnEvent('Click', OnClick)
hkF9 := interfaz.AddHotkey('Disabled xs w24 Section vF9', 'F9')
tF9 := interfaz.AddText('ys+5 vtF9', 'Abrir/Cerrar esta ventana')
hkF10 := interfaz.AddHotkey('Disabled xs w24 Section vF10', 'F10')
tF10 := interfaz.AddText('ys+5 vtF10', 'Espacio cada ' . sdKeyDelay.range.max . ' ms')
eM4 := interfaz.AddEdit('Disabled ReadOnly -Wrap r1 xs w24 Section vM4', 'M4')
tM4 := interfaz.AddText('ys+5 vtM4', 'Función personalizada:')
cbM4 := interfaz.AddComboBox('ys w30 Limit1 vcbM4', ['F', 'G', 'I', 'T'])
chkM4 := interfaz.AddCheckbox('ys w23 vcM4', ' Loop')
chkM4.OnEvent('Click', OnClick)
eM5 := interfaz.AddEdit('Disabled ReadOnly -Wrap r1 xs w24 Section vM5', 'M5')
tM5 := interfaz.AddText('ys+5 vtM5', 'Autorun / Cambiar cámara de combate')

tTabs.UseTab('Ayuda')
lWikiKO := interfaz.AddLink('vWikiKO', 'Wiki coreana: <a href="https://dsrwiki.com/">DSRWIKI</a>')
lWikiEN := interfaz.AddLink('vWikiEN', 'Wiki inglesa: <a href="https://dsrwiki.net/">DSRWiki</a>')
lWikiES := interfaz.AddLink('vWikiES', 'Wiki española: <a href="https://dsrworldwiki.com/es/home">DSRWorldWiki</a>')
lWikiOP := interfaz.AddLink('vWikiOP', 'Wiki currada: <a href="https://digimonsr.wiki.gg/">DigimonSRWiki</a>')
lGuilmonFans := interfaz.AddLink('vGuilmonFans', 'Web con varias guías: <a href="https://guilmonfans.netlify.app/">GuilmonFans</a>')
lExcelKO := interfaz.AddLink('vExcelKO', 'Excel coreano: <a href="https://docs.google.com/spreadsheets/d/1Upv9NBj2pKVHb1ALPyS-p3cB52udF9fuJa-Z8E6QADo/edit">Excel</a>')
lDSR := interfaz.AddLink('vDSR', 'Web oficial: <a href="https://www.digimonsuperrumble.com/">DigimonSuperRumble</a>')

tTabs.UseTab()
btnSalir := interfaz.AddButton('Default Center x240 w50 vSalir', 'Salir')
btnSalir.OnEvent('Click', Salir)

UpdateKeyDelay()

;#################
;### Funciones ###
;#################

/**
 * Cierra la aplicación.
 */
Salir(*) {
    ExitApp()
}

/**
 * Función para controlar cuando se marca un checkbox.
 * @param chk El checkbox que ha sido marcado.
 */
OnClick(chk, *) {
    if chk.Value {
        switch chk.Name {
            case 'cFG': FG(true)
            case 'cFFF': FFF(true)
            case 'cComer': Comer(true)
            case 'cBeber': Beber(true)
        }
    } else {
        switch chk.Name {
            case 'cM4':
                SetTimer(Mouse4, 0)
                timerM4 := false
        }
    }
}

/**
 * Dependiendo del tipo de control que ha cambiado, lanza su respectiva función `OnChange` y posteriormente cambia el `KeyDelay` de los `Send`.
 * @param c En control que ha cambiado.
 */
ControlChangeKeyDelay(c, *) {
    if RegExMatch(c.ClassNN, "_([^\d_]+)", &match) {
        control := match[1]
    }
    switch control {
        case 'trackbar': SliderChange(c) UpdateKeyDelay()
        case 'updown': UpDownChange(c) UpdateKeyDelay()
    }
}

/**
 * Actualiza el texto de cada control que incluya `KeyDelay`.
 */
UpdateKeyDelay(*) {
    SetKeyDelay(sdKeyDelay.Value)
    chkFG.Text := ' Farmeo: FGGG cada ' . sdKeyDelay.Value . ' ms'
    chkFFF.Text := ' Skip: F cada ' . sdKeyDelay.Value . ' ms'
    tComer.Text := 'cada ' . sdKeyDelay.Value . ' ms'
    tBeber.Text := 'cada ' . sdKeyDelay.Value . ' ms'
    tF10.Text := 'Espacio cada ' . sdKeyDelay.Value . ' ms'
}

/**
 * Cambia el intervalo de un control `Slider`.
 * @param sd El control `Slider` que ha cambiado.
 */
SliderChange(sd, *) {
    sd.Value := Round(sd.Value / sd.interval) * sd.interval
    sd.UpDown.Value := sd.Value
}

/**
 * Cambia el intervalo de un control `UpDown`.
 * @param u El control `UpDown` que ha cambiado.
 */
UpDownChange(u, *) {
    static e := u.edit
    static sd := u.slider
    if u.Value <= sd.range.min {
        e.Value := sd.range.min
    } else if u.Value >= sd.range.max {
        e.Value := sd.range.max
    } else {
        if u.Value < sd.Value {
            e.Value := e.Value - sd.interval + 1
        } else {
            e.Value := e.Value + sd.interval - 1
        }
    }
    sd.Value := u.Value
}

/**
 * Actualiza el reloj de la barra de estado.
 */
UpdateClock(*) {
    time := FormatTime(A_Now, 'HH:mm:ss')
    sb.SetText(time, 2)
}

/**
 * Muestra o cierra la ventana de la aplicación.
 * @param {Integer} width El ancho de la ventana.
 */
Mostrar(width := 300) {
    if !WinActive(interfaz.Hwnd) {
        interfaz.Show('w' . width)
        SetTimer(UpdateClock, 1000)
    } else {
        interfaz.Hide()
        SetTimer(UpdateClock, 0)
    }
}

Top(c, *) {
    switch c.Value {
        case 1: c.Gui.Opt("+AlwaysOnTop +ToolWindow")
        case 0: c.Gui.Opt("-AlwaysOnTop -ToolWindow")
    }
}

/**
 * Detiene todos los timers y cambia la variable `timer` a `false`.
 */
StopTimers() {
    SetTimer(FG, 0)
    SetTimer(FFF, 0)
    SetTimer(Comer, 0)
    SetTimer(Beber, 0)
    SetTimer(Space, 0)
    global timer := false
    global comiendo := false
    global bebiendo := false
    chkFG.Value := false
    chkFFF.Value := false
    chkComer.Value := false
    chkBeber.Value := false
}

/**
 * Si existe la `ventana` del Digimon Super Rumble le envía las teclas `fggg` cada `100ms`.
 * En caso contrario detiene todos los timers y cambia la variable `timer` a `false`.
 * @param start Si se especifica un parámetro `start` se cambia la variable `timer` a `true`, se marca `chkFG` y se lanza el timer `FG`.
 */
FG(start?) {
    if IsSet(start) {
        global timer
        if !timer {
            timer := true
            chkFG.Value := true
            SetTimer(FG, sdKeyDelay.Value)
        } else {
            StopTimers()
        }
    } else {
        if WinExist(ventana) {
            ControlSend('fggg', , ventana)
        } else {
            StopTimers()
        }
    }
}

/**
 * Si existe la `ventana` del Digimon Super Rumble le envía la tecla `f` cada `100ms`.
 * En caso contrario detiene todos los timers y cambia la variable `timer` a `false`.
 * @param start Si se especifica un parámetro `start` se cambia la variable `timer` a `true`, se marca `chkFFF` y se lanza el timer `FFF`.
 */
FFF(start?) {
    if IsSet(start) {
        global timer
        if !timer {
            timer := true
            chkFFF.Value := true
            SetTimer(FFF, sdKeyDelay.Value)
        } else {
            StopTimers()
        }
    } else {
        if WinExist(ventana) {
            ControlSend('f', , ventana)
        } else {
            StopTimers()
        }
    }
}

/**
 * Si existe la `ventana` del Digimon Super Rumble le envía la tecla `1` cada `100ms`.
 * En caso contrario detiene el timer `Comer` y cambia la variable `comiendo` a `false`.
 * @param start Si se especifica un parámetro `start` se cambia la variable `comiendo` a `true`, se marca `chkComer` y se lanza el timer `Comer`.
 * 
 * En caso de estar `bebiendo`, se para de `Beber`.
 */
Comer(start?) {
    if IsSet(start) {
        global comiendo, bebiendo
        if !comiendo {
            if bebiendo {
                SetTimer(Beber, 0)
                bebiendo := false
                chkBeber.Value := false
            }
            comiendo := true
            chkComer.Value := true
            SetTimer(Comer, sdKeyDelay.Value)
        } else {
            SetTimer(Comer, 0)
            comiendo := false
            chkComer.Value := false
        }
    } else {
        if WinExist(ventana) {
            ControlSend(cbComer.Text, , ventana)
        } else {
            StopTimers()
        }
    }
}

/**
 * Si existe la `ventana` del Digimon Super Rumble le envía la tecla `2` cada `100ms`.
 * En caso contrario detiene el timer `Beber` y cambia la variable `bebiendo` a `false`.
 * @param start Si se especifica un parámetro `start` se cambia la variable `bebiendo` a `true`, se marca `chkBeber` y se lanza el timer `Beber`.
 * 
 * En caso de estar `comiendo`, se para de `Comer`.
 */
Beber(start?) {
    if IsSet(start) {
        global bebiendo, comiendo
        if !bebiendo {
            if comiendo {
                SetTimer(Comer, 0)
                comiendo := false
                chkComer.Value := false
            }
            bebiendo := true
            chkBeber.Value := true
            SetTimer(Beber, sdKeyDelay.Value)
        } else {
            SetTimer(Beber, 0)
            bebiendo := false
            chkBeber.Value := false
        }
    } else {
        if WinExist(ventana) {
            ControlSend(cbBeber.Text, , ventana)
        } else {
            StopTimers()
        }
    }
}

/**
 * Si existe la `ventana` del Digimon Super Rumble le envía la tecla `Space` cada `100ms`.
 * En caso contrario detiene todos los timers y cambia la variable `timer` a `false`.
 * @param start Si se especifica un parámetro `start` se cambia la variable `timer` a `true`, y se lanza el timer `Space`.
 */
Space(start?) {
    if IsSet(start) {
        global timer
        if !timer {
            timer := true
            SetTimer(Space, sdKeyDelay.Value)
        } else {
            StopTimers()
        }
    } else {
        if WinExist(ventana) {
            ControlSend('{Space}', , ventana)
        } else {
            StopTimers()
        }
    }
}

/**
 * Envía la tecla `º` del teclado español como si fuese `´` del teclado coreano.
 */
Autorun(*) {
    if WinActive(ventana) {
        DetectHiddenWindows(true)
        PostMessage(0x0050, 0, 0x4120C0A, , ventana)
        Sleep(50)
        ControlSend('{vkC0}', , ventana)
        PostMessage(0x0050, 0, 0x40A0C0A, , ventana)
    }
}

/**
 * Función que envía las teclas configuradas para el `Mouse4`.
 */
Mouse4(start?) {
    if IsSet(start) {
        if chkM4.Value {
            global timerM4
            if !timerM4 {
                timerM4 := true
                SetTimer(Mouse4, sdKeyDelay.Value)
            } else {
                SetTimer(Mouse4, 0)
                timerM4 := false
            }
        } else {
            if WinActive(ventana) {
                ControlSend(cbM4.Text, , ventana)
            }
        }
    } else {
        if WinExist(ventana) {
            ControlSend(cbM4.Text, , ventana)
        } else {
            SetTimer(Mouse4, 0)
            timerM4 := false
        }
    }
}

;###############
;### Hotkeys ###
;###############

F4:: ExitApp()
F5:: FG(true)
F6:: FFF(true)
F7:: Comer(true)
F8:: Beber(true)
F9:: Mostrar()
F10:: Space(true)
~XButton1:: Mouse4(true)
~XButton2:: Autorun()