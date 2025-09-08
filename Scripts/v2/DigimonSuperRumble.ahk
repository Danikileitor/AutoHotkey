#Requires AutoHotkey v2.0

F4:: ExitApp()

interfaz := Gui('-MaximizeBox -MinimizeBox', '[DNK]{AHK}{DSR}')
lTitle := interfaz.AddText('Center w300 vTitle', 'Digimon Super Rumble')
tTabs := interfaz.AddTab3('w280', ['KeyBinds', 'Options'])

tTabs.UseTab('KeyBinds')
hkFG := interfaz.AddHotkey('vFG', 'FG')
hkFG.Value := 'F5'

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