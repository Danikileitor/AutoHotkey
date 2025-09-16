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

;################
;### Interfaz ###
;################

interfaz := Gui('-MaximizeBox -MinimizeBox', '[DNK]{AHK}{DSR}')
lTitle := interfaz.AddText('Center w300 vTitle', 'Digimon Super Rumble')
sb := interfaz.AddStatusBar('vSB', 'Digimon Super Rumble')
tTabs := interfaz.AddTab3('w280', ['KeyBinds', 'Opciones'])

tTabs.UseTab('KeyBinds')
hkF4 := interfaz.AddHotkey('Disabled w22 Section vF4', 'F4')
tF4 := interfaz.AddText('ys+5 vtF4', 'Cerrar el programa')
hkFG := interfaz.AddHotkey('Disabled xs w22 Section vFG', 'F5')
chkFG := interfaz.AddCheckbox('ys+5 vcFG', ' Farmeo: FGGG cada 100ms')
chkFG.OnEvent('Click', OnClick)
hkFFF := interfaz.AddHotkey('Disabled xs w22 Section vFFF', 'F6')
chkFFF := interfaz.AddCheckbox('ys+5 vcFFF', ' Skip: F cada 100ms')
chkFFF.OnEvent('Click', OnClick)
hkComer := interfaz.AddHotkey('Disabled xs w22 Section vComer', 'F7')
chkComer := interfaz.AddCheckbox('ys w23 vcComer', ' Comer:')
cbComer := interfaz.AddComboBox('ys w30 Limit vcbComer', ['1', '3'])
cbComer.Choose(1)
tComer := interfaz.AddText('ys+5 vtComer', 'cada 100ms')
chkComer.OnEvent('Click', OnClick)
hkBeber := interfaz.AddHotkey('Disabled xs w22 Section vBeber', 'F8')
chkBeber := interfaz.AddCheckbox('ys w23 vcBeber', ' Beber:')
cbBeber := interfaz.AddComboBox('ys w30 Limit vcbBeber', ['2', '4'])
cbBeber.Choose(1)
tBeber := interfaz.AddText('ys+5 vtBeber', 'cada 100ms')
chkBeber.OnEvent('Click', OnClick)
hkF9 := interfaz.AddHotkey('Disabled xs w22 Section vF9', 'F9')
tF9 := interfaz.AddText('ys+5 vtF9', 'Abrir/Cerrar esta ventana')
eM5 := interfaz.AddEdit('Disabled ReadOnly -Wrap r1 xs w22 Section vM5', 'M5')
tM5 := interfaz.AddText('ys+5 vtM5', 'Autorun / Cambiar cámara de combate')

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
tTabs.UseTab()
btnSalir := interfaz.AddButton('Default Center x240 w50 vSalir', 'Salir')
btnSalir.OnEvent('Click', Salir)

SetKeyDelay(sdKeyDelay.Value)

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
 * Dependiendo del tipo de control que ha cambiado, lanza su respectiva función `OnChange` y posteriormente cambia el `KeyDelay` de los `Send`.
 * @param c En control que ha cambiado.
 */
ControlChangeKeyDelay(c, *) {
    if RegExMatch(c.ClassNN, "_([^\d_]+)", &match) {
        control := match[1]
    }
    switch control {
        case 'trackbar': SliderChange(c)
        case 'updown': UpDownChange(c)
        default: SetKeyDelay(sdKeyDelay.Value)
    }
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
 * Muestra o cierra la ventana de la aplicación.
 * @param {Integer} width El ancho de la ventana.
 */
Mostrar(width := 300) {
    if !WinActive(interfaz.Hwnd) {
        interfaz.Show('w' . width)
    } else {
        interfaz.Hide()
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
    global timer := false
    global comiendo := false
    global bebiendo := false
    chkFG.Value := false
    chkFFF.Value := false
    chkComer.Value := false
    chkBeber.Value := false
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
    }
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
 * Envía la tecla `º` del teclado español como si fuese `´` del teclado coreano.
 * @param {String} key Si se especifica, se envía la tecla después de la función.
 */
Autorun(key?) {
    if WinActive(ventana) {
        DetectHiddenWindows(true)
        PostMessage(0x0050, 0, 0x4120C0A, , ventana)
        Sleep(50)
        Send('{vkC0}')
        PostMessage(0x0050, 0, 0x40A0C0A, , ventana)
    }
    if IsSet(key) {
        Send('{' . key . '}')
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
XButton2:: Autorun('XButton2')