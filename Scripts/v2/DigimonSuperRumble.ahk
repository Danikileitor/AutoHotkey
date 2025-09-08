#Requires AutoHotkey v2.0

F4:: ExitApp()

interfaz := Gui('-MaximizeBox -MinimizeBox', '[DNK]{AHK}{DSR}')
lTitle := interfaz.AddText('Center w300 vTitle', 'Digimon Super Rumble')
btnSalir := interfaz.AddButton('Default Center x210 w80 vSalir', 'Salir').OnEvent('Click', Salir)

Salir(*)
{
    ExitApp()
}

F9::
{
    interfaz.Show('w300')
}