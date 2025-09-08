#Requires AutoHotkey v2.0

F4:: ExitApp()

interfaz := Gui('-MaximizeBox -MinimizeBox', '[DNK]{AHK}{DSR}')
lTitle := interfaz.AddText('Center w290 vTitle', 'Digimon Super Rumble')
tTabs := interfaz.AddTab3(, ['KeyBinds', 'Options'])
tTabs.UseTab()
btnSalir := interfaz.AddButton('Default Center x230 w50 vSalir', 'Salir')
btnSalir.OnEvent('Click', Salir)

Salir(*)
{
    ExitApp()
}

F9::
{
    interfaz.Show('w290')
}