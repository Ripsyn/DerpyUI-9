local M = unpack(select(2,...))

-- Reset Saved Vars
SlashCmdList.HTSDEFF = M.resetdeff
SLASH_HTSDEFF1 = "/pyreset"

-- Get Hovered frame name
local function print_name(t,x)
	if not x then return end
	if x:GetName() then
		print(t..": "..x:GetName())
	else
		print(t..":",x)
	end	
end
local function forward(x,c)
	print_name(c,x)
	if x ~= nil then
		return x:GetParent()
	end
end
SlashCmdList.GETFRAMENAME = function()
	forward(forward(forward(forward(forward(GetMouseFocus(),1),2),3),4),5)
end
SLASH_GETFRAMENAME1 = "/frame"

-- Reload UI
SlashCmdList.REL = ReloadUI
SLASH_REL1 = "/rl"
SLASH_REL2 = "/кд"

-- Center alert
SlashCmdList.ALLEYRUN = M.allertrun
SLASH_ALLEYRUN1 = "/arn"

-- Menu call
SlashCmdList.PMENU = M.show_config
SLASH_PMENU1 = "/py" 

-- Move something
SlashCmdList.PMOVE = M.switch_lock
SLASH_PMOVE1 = "/pymove" 