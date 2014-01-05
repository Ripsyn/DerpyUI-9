local W,M,L,V = unpack(select(2,...))
if not V.common.popup then return end
local UnitPopupMenus = UnitPopupMenus
for _, menu in pairs(UnitPopupMenus) do
	for index = #menu, 1, -1 do
		if menu[index] == "SET_FOCUS" or menu[index] == "CLEAR_FOCUS" or menu[index] == "MOVE_PLAYER_FRAME" or menu[index] == "MOVE_TARGET_FRAME" or (M.class == "HUNTER" and menu[index] == "PET_DISMISS") then
			table.remove(menu, index)
		end
	end
end