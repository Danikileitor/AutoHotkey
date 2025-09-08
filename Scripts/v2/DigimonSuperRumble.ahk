#Requires AutoHotkey v2.0

F4:: ExitApp()

interfaz := Gui(, '[DNK]{AHK}{DSR}')
lTitle := interfaz.AddText('Center w300 vTitle', '[DNK]{AHK}{DSR}')
btnSalir := interfaz.AddButton('Default w80 vSalir', 'Salir').OnEvent('Click', Salir)

Salir(*)
{
    ExitApp()
}

F9::
{
    interfaz.Show('w300')
}