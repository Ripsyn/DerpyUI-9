local C,M,L,V = unpack(select(2,...))
local _G = _G
C.coress_unit[3] = _G.PetActionButton1
local menuFrame = M.menuframe
local pet_n = "PetActionButton"
local InCombatLockdown = _G.InCombatLockdown
local simple_move = M.simple_move
local side = C.side

local Mover = CreateFrame("Frame",nil,UIParent)
	Mover:SetSize(10,10)
	Mover.hor = true
	Mover.alt = 187
	Mover.point_2 = "RIGHT"
	Mover.point_1 = "TOPRIGHT"
	Mover.parent = side
	Mover.pos = -6
	Mover:SetPoint("TOPRIGHT",side,"RIGHT",-6,187)

local points = {
	[1] = 0,
	[2] = -34,
	[3] = -68,
}

local petaway = {"TOPRIGHT",side,"TOPRIGHT",200,187}

local dx1,dx2,dx3 = "TOPRIGHT",Mover,"TOPRIGHT"
local move_to = function(self,num)
	self:SetPoint(dx1,dx2,dx3,points[num],0)
end

Mover._SetPoint = Mover.SetPoint
Mover.SetPoint = function(self,...)
	if InCombatLockdown() then
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		self:SetScript("OnUpdate",nil)
		return
	end
	self:_SetPoint(...)
end

Mover:SetScript("OnEvent",function(self)
	self:UnregisterAllEvents()
	self:SetScript("OnUpdate",simple_move)
end)

Mover.left = function(self)
	self:SetScript("OnUpdate",nil)
	self.mod = 1
	self.limit = -6
	self.speed = 180
	self:SetScript("OnUpdate",simple_move)
end

Mover.right = function(self)
	self:SetScript("OnUpdate",nil)
	self.mod = -1
	self.limit = -40
	self.speed = -180
	self:SetScript("OnUpdate",simple_move)
end

local show = function(self)
	self:hide()
	self:show_()
	for i=2,10 do
		_G[pet_n..i]:hide()
		_G[pet_n..i]:show()
	end
end

for i = 1,10 do M.make_plav(_G[pet_n..i],.13,true,1) end

C.coress_unit[3].show_ = C.coress_unit[3].show
C.coress_unit[3].show = show

local pettriger = CreateFrame("Button",nil,UIParent)
	pettriger:SetAlpha(0)
	pettriger:SetPoint("RIGHT",side,2,199)
	pettriger:SetSize(40,20)
	pettriger:RegisterForClicks("anydown")

M.ChangeTemplate(pettriger)

local _enable = function(x,orly)
	if orly then
		x:SetBackdropColor(unpack(M["media"]["button"][2]))
		x:SetBackdropBorderColor(unpack(M["media"]["button"][2]))
	else
		x:SetBackdropColor(unpack(M["media"]["button"][1]))
		x:SetBackdropBorderColor(unpack(M["media"]["button"][1]))
	end
end

local pet_textures = {}
for i=1,3 do
	local x = CreateFrame("Frame",nil,pettriger)
	x:SetBackdrop(M.bg)
	x:SetSize(12,14)
	if i == 1 then
		x:SetPoint("LEFT",4,0)
	else
		x:SetPoint("LEFT",pet_textures[i-1],"RIGHT",-2,0)
	end
	x.enable = _enable
	pet_textures[i] = x
end

local SAVED = V["pet_unit"]

local away = function(i)
	if C.coress_unit[i].__enabled == false then return end
	C.coress_unit[i].__enabled = false
	if i == 3 then
		C.coress_unit[i]:SetPoint(unpack(petaway))
	else
		C.coress_unit[i]:Hide()
	end
	pet_textures[i]:enable(false)
end

local display = function(i)
	if C.coress_unit[i].__enabled == true then return end
	C.coress_unit[i].__enabled = true
	C.coress_unit[i]:show()
	pet_textures[i]:enable(true)
end

C.checkthepet = function()
	local pos_enable = false
	local current_stage = 1
	for i=1,3 do
		if SAVED[i] == true then
			pos_enable = true
			display(i)
			move_to(C.coress_unit[i],current_stage)
			current_stage = current_stage + 1
		else
			away(i)		
		end
	end
	V.showpet = pos_enable
	C.check_right_bar()
	if pos_enable == true then
		if V.savedright == 0 then
			Mover:left()
		else
			Mover:right()
		end
	end
end

local orly = function(ar1,ar2)
	if InCombatLockdown() then return end
	SAVED[ar1] = ar2
	C.checkthepet()
end

local tmen = {'MicroMenu','MarkBar','PetBar'}
local _title = {text = "DISPLAY", isTitle = 1, notCheckable = 1}

local menu = function()
	local a = {}
	a[1] = _title
	for i=1,3 do
		a[i+1] = {text = tmen[i],func = function() 
		local c
		if SAVED[i]==true then c = false else c = true end
		orly(i,c) 
		end, checked = SAVED[i]}
	end
	return a
end

pettriger:SetScript("OnEnter",function(self) UIFrameFadeIn(self,.2,0,1) end)
pettriger:SetScript("OnLeave",function(self) UIFrameFadeOut(self,.2,1,0) end)
pettriger:SetScript("OnClick",function(self) _G.EasyMenu(menu(), menuFrame, "cursor", 0, 0, "MENU", 2) end)
