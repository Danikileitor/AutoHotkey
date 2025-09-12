#Requires AutoHotkey v2.0

;#################
;### Variables ###
;#################

SetKeyDelay(100)
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
tTabs := interfaz.AddTab3('w280', ['KeyBinds', 'Options'])

tTabs.UseTab('KeyBinds')
hkF4 := interfaz.AddHotkey('Disabled w22 Section vF4', 'F4')
tF4 := interfaz.AddText('ys+5 vtF4', 'Cerrar el programa')
hkFG := interfaz.AddHotkey('Disabled w22 xs Section vFG', 'F5')
chkFG := interfaz.AddCheckbox('ys+5 vcFG', ' Farmeo: FGGG cada 100ms')
chkFG.OnEvent('Click', OnClick)
hkFFF := interfaz.AddHotkey('Disabled w22 xs Section vFFF', 'F6')
chkFFF := interfaz.AddCheckbox('ys+5 vcFFF', ' Skip: F cada 100ms')
chkFFF.OnEvent('Click', OnClick)
hkComer := interfaz.AddHotkey('Disabled w22 xs Section vComer', 'F7')
chkComer := interfaz.AddCheckbox('ys+5 vcComer', ' Comer: 1 cada 100ms')
chkComer.OnEvent('Click', OnClick)
hkBeber := interfaz.AddHotkey('Disabled w22 xs Section vBeber', 'F8')
chkBeber := interfaz.AddCheckbox('ys+5 vcBeber', ' Beber: 2 cada 100ms')
chkBeber.OnEvent('Click', OnClick)
hkF9 := interfaz.AddHotkey('Disabled w22 xs Section vF9', 'F9')
tF9 := interfaz.AddText('ys+5 vtF9', 'Abrir/Cerrar esta ventana')
eM5 := interfaz.AddEdit('Disabled ReadOnly -Wrap r1 w22 xs Section vM5', 'M5')
tM5 := interfaz.AddText('ys+5 vtM5', 'Autorun / Cambiar cámara de combate')

tTabs.UseTab('Options')

tTabs.UseTab()
btnSalir := interfaz.AddButton('Default Center x240 w50 vSalir', 'Salir')
btnSalir.OnEvent('Click', Salir)

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
 * Muestra o cierra la ventana de la aplicación
 * @param {Integer} width El ancho de la ventana
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
 * En caso contraro detiene todos los timers y cambia la variable `timer` a `false`.
 * @param start Si se especifica un parámetro `start` se cambia la variable `timer` a `true`, se marca `chkFG` y se lanza el timer `FG`
 */
FG(start?) {
    if IsSet(start) {
        global timer
        if !timer {
            timer := true
            chkFG.Value := true
            SetTimer(FG, 100)
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
 * En caso contraro detiene todos los timers y cambia la variable `timer` a `false`.
 * @param start Si se especifica un parámetro `start` se cambia la variable `timer` a `true`, se marca `chkFFF` y se lanza el timer `FFF`
 */
FFF(start?) {
    if IsSet(start) {
        global timer
        if !timer {
            timer := true
            chkFFF.Value := true
            SetTimer(FFF, 100)
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
 * En caso contraro detiene el timer `Comer` y cambia la variable `comiendo` a `false`.
 * @param start Si se especifica un parámetro `start` se cambia la variable `comiendo` a `true`, se marca `chkComer` y se lanza el timer `Comer`
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
            SetTimer(Comer, 100)
        } else {
            SetTimer(Comer, 0)
            comiendo := false
            chkComer.Value := false
        }
    } else {
        if WinExist(ventana) {
            ControlSend('1', , ventana)
        } else {
            StopTimers()
        }
    }
}

/**
 * Si existe la `ventana` del Digimon Super Rumble le envía la tecla `2` cada `100ms`.
 * En caso contraro detiene el timer `Beber` y cambia la variable `bebiendo` a `false`.
 * @param start Si se especifica un parámetro `start` se cambia la variable `bebiendo` a `true`, se marca `chkBeber` y se lanza el timer `Beber`
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
            SetTimer(Beber, 100)
        } else {
            SetTimer(Beber, 0)
            bebiendo := false
            chkBeber.Value := false
        }
    } else {
        if WinExist(ventana) {
            ControlSend('1', , ventana)
        } else {
            StopTimers()
        }
    }
}

/**
 * Cambia al teclado coreano, pulsa la tecla ` del autorun y vuelce a cambiar de teclado.
 * @param {String} key Si se especifica, se envía la tecla después de la función.
 * 
 * (Requiere tener solamente 2 teclados instalados y que el segundo sea el coreano)
 */
Autorun(key?) {
    if WinExist(ventana) {
        Send('{LWin down}{Space}{LWin up}')
        Sleep(50)
        ControlSend('{vkC0}', , WinExist('A'))
        Sleep(50)
        Send('{LWin down}{Space}{LWin up}')
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