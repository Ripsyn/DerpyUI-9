local C,M,L,V = unpack(select(2,...))

C.coress_unit = {}
C.side_table = {}
local side_table = C.side_table
local count = 0
local _G = _G
local reverse = V.reverse
local layout = 	V.layout
M.oufspawn = ({124,162,124,162,162,162,200,200})[layout]
C.ChatPoint= ({380,380,570,570,285,475,266,380})[layout]

local bar = CreateFrame("Frame", "DerpyMainMenuBar", UIParent, "SecureHandlerStateTemplate")
bar:ClearAllPoints()
bar:SetSize(100,100)
bar:SetPoint("CENTER")

local resetbt = function(b)
	local bg = M.frame(b,0,"MEDIUM")
	bg:SetPoint("TOP",0,4)
	bg:SetPoint("BOTTOM",0,-4)
	bg:SetPoint("LEFT",-4,0)
	bg:SetPoint("RIGHT",4,0)
	count = count + 1
	side_table[count] = b
	b._derpy_mask = bg
	b.passed = true -- ONLY MY BUTTONS
	b.hotkey = _G[b:GetName().."HotKey"]
end

do
	local t = {
		"MultiBarBottomLeft",
		"MultiBarLeft",
		"MultiBarRight",
		"MultiBarBottomRight"}
	for i=1,#t do
		local b = CreateFrame("Frame", "Derpy"..t[i], UIParent)
		b:SetAllPoints(bar)
		_G[t[i]]:SetParent(b)
	end
	local havetodo = {
		"ActionButton",
		"MultiBarBottomLeftButton",
		"MultiBarBottomRightButton",
		"MultiBarLeftButton",
		"MultiBarRightButton"}
	for i=1, #havetodo do
		for p = 1, 12 do
			resetbt(_G[havetodo[i]..p])
		end
	end
end

C.side = CreateFrame("Frame",nil,UIParent) -- no name = do not save
local side = C.side
	side:SetSize(10,394)
	side:SetPoint("RIGHT",0,V.side)
	side:SetFrameLevel(1)
	side:SetFrameStrata"BACKGROUND"

local rp = M.frame(C.side,1,"BACKGROUND")
	rp:SetHeight(394)
	rp:SetPoint("RIGHT",5,0)
	rp:SetWidth(18)
	rp.bg:SetGradientAlpha("HORIZONTAL",.26,.26,.26,.14,.2,.2,.2,.47)
	rp.point_1 = "RIGHT"
	rp.point_2 = "RIGHT"
	rp.pos = 5
	rp.hor = true
	rp.parent = C.side
	
local on_update = M.simple_move
	
rp.start_go_up = function(self)
	self:SetScript("OnUpdate",nil)
	self.mod = -1
	self.limit = 5
	self.speed = -30
	self:SetScript("OnUpdate",on_update)
end
	
rp.start_go_down = function(self)
	self:SetScript("OnUpdate",nil)
	self.mod = 1
	self.limit = 18
	self.speed = 30
	self:SetScript("OnUpdate",on_update)
end

C.check_right_bar = function()
	if V["savedright"] == 0 and V["showpet"] ~= true then
		if rp.moving_right == true then return end
		rp.moving_right = true
		rp:start_go_down()
	else
		if rp.moving_right ~= true then return end
		rp.moving_right = false
		rp:start_go_up()
	end
end

-- Mover unck
side:EnableMouse(true)

local can_move = false

local tex_can = side:CreateTexture(nil,"HIGHLIGHT")
tex_can:SetPoint("TOPRIGHT",0,-4)
tex_can:SetPoint("BOTTOMRIGHT",0,4)
tex_can:SetWidth(24)
tex_can:SetTexture(M.media.blank)
tex_can:SetGradientAlpha("HORIZONTAL",0,.8,.8,0,0,.8,.8,.8)
tex_can:Hide()

local tex_no = side:CreateTexture(nil,"HIGHLIGHT")
tex_no:SetPoint("TOPRIGHT",0,-4)
tex_no:SetPoint("BOTTOMRIGHT",0,4)
tex_no:SetWidth(24)
tex_no:SetTexture(M.media.blank)
tex_no:SetGradientAlpha("HORIZONTAL",1,.1,.1,0,1,.1,.1,.8)

side.yes = tex_can
side.no = tex_no

local right = function(self)
	if can_move then
		can_move = false
		self.yes:Hide()
		self.no:Show()
	else
		can_move = true
		self.no:Hide()
		self.yes:Show()
	end
end

local writevar
local left
do
	local InCombatLockdown = InCombatLockdown
	local last_cursor = 0
	local curent_y = V.side
	local floor = floor 
	local GetCursorPosition = GetCursorPosition
	local scale = 1
	
	local update = function(self)
		if InCombatLockdown() then
			self:SetScript("OnUpdate",nil)
			writevar()
			return
		end
		local _,y = GetCursorPosition()
		y = y / scale 
		curent_y = y - last_cursor + curent_y
		last_cursor = y
		self:SetPoint("RIGHT",0,floor(curent_y+.5))
	end
	
	left = function(self)
		if InCombatLockdown() or can_move == false then return end
		local _,y = GetCursorPosition()
		last_cursor = y / scale
		self:SetScript("OnUpdate",update)
	end
	
	writevar = function()
		V.side = floor(curent_y+.5)
	end
	
	M.addenter(function()
		scale = M.scale
	end)	
end

side["RightButton"] = right
side["LeftButton"] = left

side:SetScript("OnMouseDown",function(self,b)
	self[b](self)
end)

side:SetScript("OnMouseUp",function(self,b)
	self:SetScript("OnUpdate",nil)
	writevar()
end)

M.addafter(function()
	-- Extra
	local p = CreateFrame("Frame",nil,UIParent)
	p.realname = "EXTRABUTTON"
	M.tex_move(p,"EXTRA BUTTON",p.Hide)
	p.combat = true
	M.make_movable(p)
	p:Hide()
	p:SetSize(160,80)
	p:SetPoint("BOTTOM",0,280)	

	local holder = CreateFrame("Frame", "DerpyExtraActionBarFrameHolder", UIParent, "SecureHandlerStateTemplate")
	holder:SetSize(160,80)
	holder:SetPoint("CENTER",p)

	ExtraActionBarFrame:SetParent(holder)
	ExtraActionBarFrame:ClearAllPoints()
	ExtraActionBarFrame:SetPoint("CENTER", holder, "CENTER", 0, 0)
end)
