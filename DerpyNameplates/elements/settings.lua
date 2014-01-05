local unpack = unpack
local C,M,L,V = unpack(select(2,...))

local plate = M.make_settings_template("NAMEPLATES",250,592)
local names = C.names

local st = {
	["nameplates_tank"] = "TANK MODE",
	["nameplates_enhancethreat"] = "ENHANCE THREAT",
	["nameplates_combat"] = "COMBAT MODE",
	["nameplates_hide_player_level"] = "HIDE SAME LEVEL",
	["nameplates_showhealth"] = "SHOW HEALTH",}
	
M.tweaks_mvn(plate,V,st,496)
	
local st_colors = M["media"].button

local ccheck = function(self)
	if V.nameplates_blacklist[self.num] == true then
		self:SetBackdropColor(unpack(st_colors[2]))
		self:SetBackdropBorderColor(unpack(st_colors[2]))
	else
		self:SetBackdropColor(unpack(st_colors[1]))
		self:SetBackdropBorderColor(unpack(st_colors[1]))
	end
end

local push = function(self)
	if V.nameplates_blacklist[self.num] == true then
		V.nameplates_blacklist[self.num] = false
	else
		V.nameplates_blacklist[self.num] = true
	end
	ccheck(self)
end

local mk_swich_bt = function(frame,p)
	local bt = CreateFrame("Frame",nil,frame)
		bt:SetFrameLevel(frame:GetFrameLevel()+4)
		bt:SetSize(35,11)
		bt:SetBackdrop(M.bg)
		bt:SetPoint("RIGHT",-8,0)
		bt.num = p
		ccheck(bt)
		bt:EnableMouse(true)
		bt:SetScript("OnMouseDown",push)
	return frame
end

local o = 1
local frames__ = {}

for t,r in pairs(V.nameplates_blacklist) do
	local f = M.frame(plate,plate:GetFrameLevel()+4,"HIGH")
		f:SetSize(214,20)
	local b = mk_swich_bt(f,t)
	local a = M.setfont_lang(f,12)
	a:SetText(names[t])
	a:SetPoint("LEFT",7,1)
	a:SetPoint("RIGHT",-43,1)
	if o == 1 then
		f:SetPoint("TOP",plate,0,-37)
	else
		f:SetPoint("TOP",frames__[o-1],"BOTTOM",0,2)
	end
	frames__[o] = f
	o = o + 1
end

local g = M.setfont(frames__[1],15)
g:SetPoint("BOTTOMLEFT",frames__[1],"TOPLEFT",7,4)
g:SetText("BLACK LIST: ")

local a = M.makevarbar(plate,234,32,200,V,'nameplates_width',"NAMEPLATES WIDTH RATIO"); a:SetPoint("TOP",frames__[o-1],0,-34)
local b = M.makevarbar(plate,234,2,32,V,'nameplates_height',"NAMEPLATES HEIGHT RATIO"); b:SetPoint("TOP",a,"BOTTOM")
local c = M.makevarbar(plate,234,8,24,V,'nameplates_font_size',"NAMEPLATES FONT SIZE"); c:SetPoint("TOP",b,"BOTTOM")
local d = M.makevarbar(plate,234,2,12,V,'nameplates_edge',"NAMEPLATES EDGE SIZE"); d:SetPoint("TOP",c,"BOTTOM")
