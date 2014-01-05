-- local C,M,L,V = unpack(select(2,...)) --

local ns = select(2,...)
ns[1] = {}
ns[2] = DerpyData[1]
ns[3] = DerpyData[2]

if not _G.DerpyStatsVar_TEMP then
	_G.DerpyStatsVar_TEMP = {}
end

ns[4] = _G.DerpyStatsVar_TEMP

local C = ns[1]
local M = ns[2]
local L = ns[3]
local V = _G.DerpyStatsVar_TEMP

C.stat_table = {}
local place_table = {}

local m_f = M.frame(UIParent)
	m_f:SetWidth(78)
	m_f:Hide()
	m_f:SetFrameStrata("HIGH")
	m_f:SetFrameLevel(2)
	m_f.current_place = 1
	M.make_plav(m_f,.4)
	
local close_button_frame = CreateFrame("Frame",nil,m_f)
	close_button_frame:SetWidth(90)
	close_button_frame:SetHeight(16)
	close_button_frame:EnableMouse(true)
	close_button_frame:SetFrameLevel(3)
	close_button_frame:SetFrameStrata("HIGH")
	
local close_button = M.setfont(close_button_frame,12,nil,"CENTER")
	close_button:SetPoint("CENTER")
	close_button:SetText("CLOSE")

local mover_up = CreateFrame("Frame",nil,m_f)
local mover_down = CreateFrame("Frame",nil,m_f)

mover_up:Hide()
mover_down:Hide()

mover_up._x = 1
mover_down._x = -1
mover_down.stop = -26
	
local mover_update = function(self,t)
	self._y = self._y + (t * self._x * 60)
	self.parent:SetPoint("TOP",self.point_,0,self._y)
	if self.stop then
		if self.stop >= self._y then
			self.parent:SetPoint("TOP",self.point_,0,-26)
			self:Hide()
		end
	end
end

mover_up:SetScript("OnUpdate",mover_update)
mover_down:SetScript("OnUpdate",mover_update)
	
mover_up.parent = m_f
mover_down.parent = m_f
	
local m_f_hide = function()
	mover_down:Hide()
	mover_up._y = -26
	mover_up:Show()
	m_f:Hide()
end	
	
local fon_press = function(self)
	if mover_down.point_ == self and m_f:IsShown() then return end
	m_f:hide()
	mover_up:Hide()
	m_f:SetPoint("TOP",self,0,5)
	mover_down.point_ = self
	mover_up.point_ = self
	mover_down._y = 5
	mover_down:Show()
	m_f:show()
	m_f.current_place = self.realname
end

local fon_close = function(self)
	mover_down:Hide()
	mover_up._y = -26
	mover_up:Show()
	m_f:Hide()
end

local recolor_on = function(tt)
	tt:SetTextColor(.9,.7,.1)
end

local recolor_off = function(tt)
	tt:SetTextColor(1,1,1)
end

close_button_frame:SetScript("OnMouseDown",fon_close)
close_button_frame:SetScript("OnEnter",function() recolor_on(close_button) end)
close_button_frame:SetScript("OnLeave",function() recolor_off(close_button) end)

local mk_place = function(off,i)
	local self = CreateFrame("Frame","DerpyStatPlace"..i,UIParent)
	self:SetWidth(70)
	self:SetHeight(8)
	self:EnableMouse(true)
	self:SetPoint("TOPLEFT",UIParent,off,3)
	self:SetAlpha(1)
	self:SetScript("OnMouseDown",fon_press)
	
	local texture = self:CreateTexture(nil,"HIGHLIGHT")
	texture:SetTexture(M["media"].blank)
	texture:SetPoint("TOPLEFT",-3,0)
	texture:SetPoint("BOTTOMRIGHT",3,0)
	texture:SetGradientAlpha("VERTICAL",0,1,1,0,0,1,1,1)
	
	local top = self:CreateTexture(nil,"HIGHLIGHT")
	top:SetTexture(0,.7,.7,.9)
	top:SetSize(72,1)
	top:SetPoint("TOP",0,-7)
	
	local bottom = self:CreateTexture(nil,"HIGHLIGHT")
	bottom:SetTexture(0,.7,.7,.9)
	bottom:SetSize(72,1)
	bottom:SetPoint("TOP",0,-18)
	
	local left = self:CreateTexture(nil,"HIGHLIGHT")
	left:SetTexture(0,.7,.7,.9)
	left:SetSize(1,10)
	left:SetPoint("TOPLEFT",top,0,-1)
	
	local left = self:CreateTexture(nil,"HIGHLIGHT")
	left:SetTexture(0,.7,.7,.9)
	left:SetSize(1,10)
	left:SetPoint("TOPRIGHT",top,0,-1)
	
	return self
end

for i=0,9 do
	place_table[i+1] = mk_place(6+(82*i),i)
	place_table[i+1].realname = i+1
end

local on_fDown = function()
	local p = place_table[m_f.current_place]
	if p.cur then
		if p.cur.o == m_f.current_place then
			p.cur:Hide()
			p.cur.o = nil
			V[p.cur.num] = nil
		end
	end
	m_f_hide()
	m_f:Hide()
end

local sm_enter = function(self) recolor_on(self.op) end  
local sm_leave = function(self) recolor_off(self.op) end

local fclose = CreateFrame("Frame",nil,m_f)
	fclose:SetWidth(100)
	fclose:SetHeight(16)
	fclose:EnableMouse(true)
	fclose:SetFrameLevel(3)
	fclose:SetFrameStrata("HIGH")
	fclose:SetPoint("TOP",m_f,0,-12)
	
	fclose.op = M.setfont(fclose,12,nil,"CENTER")
	fclose.op:SetShadowOffset(1,-1)
	fclose.op:SetPoint("CENTER")
	fclose.op:SetText("HIDE")
	
	fclose:SetScript("OnEnter",sm_enter)
	fclose:SetScript("OnLeave",sm_leave)
	fclose:SetScript("OnMouseDown",on_fDown)
	
local on_Down = function(self)
	local p = place_table[m_f.current_place]
	if p.cur then
		if p.cur.o == m_f.current_place then
			p.cur:Hide()
			p.cur.o = nil
			V[p.cur.num] = nil
		end
	end
	p.cur = self.target
	p.cur:Hide()
	p.cur:SetPoint("TOP",p,0,-4)
	p.cur:show()
	p.cur.o = m_f.current_place
	V[p.cur.num] = m_f.current_place
	m_f_hide()
	m_f:Hide()
end

local c = 1

local Make = function(self,statname)
	self.num = c
	
	local frame = CreateFrame("Frame",nil,UIParent)
	frame:SetWidth(100)
	frame:SetHeight(16)
	frame:EnableMouse(true)
	frame:SetFrameLevel(3)
	frame:SetFrameStrata("HIGH")
	frame.target = self	
	
	local op = M.setfont(frame,12,nil,"CENTER")
	op:SetShadowOffset(.3,-1)
	op:SetPoint("CENTER")
	op:SetText(statname)
	frame.op = op
	
	frame:SetScript("OnEnter",sm_enter)
	frame:SetScript("OnLeave",sm_leave)
	frame:SetScript("OnMouseDown",on_Down)
	
	C.stat_table[c] = frame
	c = c + 1
	
	self:Hide()
end

M.addafter(function()
	for i=1,#C.stat_table do			
		C.stat_table[i]:SetParent(m_f)
		C.stat_table[i]:ClearAllPoints()
		if i == 1 then
			C.stat_table[i]:SetPoint("TOP",fclose,"BOTTOM")
		else
			C.stat_table[i]:SetPoint("TOP",C.stat_table[i-1],"BOTTOM")
		end
		if V[i] then
			if V[i]~= 0 then
				local p = place_table[V[i]]
				p.cur = C.stat_table[i].target
				p.cur.o = V[i]
				p.cur:SetPoint("TOP",p,0,-4)
			end
		end
	end
	local f = CreateFrame"frame"
	f.a = 2; f.pos = 1;
	f:SetScript("OnUpdate",function(self,t)
		self.a = self.a - t
		if self.a > 0 then return end
		local x = place_table[self.pos].cur
		if x then 
			x:show()
			self.a = .4
		end
		self.pos = self.pos + 1
		if self.pos > #place_table then
			self:Hide()
		end
	end)
	m_f:SetHeight(#C.stat_table*16+61)
	close_button_frame:SetPoint("TOP",C.stat_table[#C.stat_table],"BOTTOM")
	
end)

local setval = function(self,value)
	self.tex:SetPoint("LEFT",self,"RIGHT",-70*(1-value/self.max)-4,0)
end	

C.frame = function(name,exmax,stand)
	name = string.upper(name)
	local a = M.frame(UIParent,nil,nil,nil,nil,nil,"DerpyStat_"..name)
	M.make_plav(a,.2,nil,1)
	a:SetSize(78,18)
	if exmax then 
		local tex = a:CreateTexture(nil,"ARTWORK")
		tex:SetHeight(10)
		tex:SetTexture(M["media"].blank)
		tex:SetGradient("VERTICAL",.6,.1,.1,.25,.05,.05)
		tex:SetPoint("RIGHT",-4,0)
		tex:SetPoint("LEFT",self,"RIGHT",-4,0)
		a.max = exmax; a.tex = tex
		a.SetVal = setval
	end
	if not stand then
		local tx = M.setfont(a,12,true,"OVERLAY","RIGHT",nil,"OUTLINE")
		tx:SetShadowOffset(2,-2)
		tx:SetPoint("BOTTOMRIGHT",-2.7,-1)
		a.tx = tx
	else
		lt = M.setcdfont(a,14,"OUTLINE")
		rt = M.setfont(a,12,true,"OVERLAY","RIGHT",nil,"OUTLINE")
		lt:SetPoint("BOTTOMLEFT",5.3,-3.5)
		rt:SetPoint("BOTTOMRIGHT",-2.7,-1)
		lt:SetShadowOffset(2,-2)
		rt:SetShadowOffset(2,-2)
		a.lt = lt; a.rt = rt;
	end
	a:EnableMouse(true)
	Make(a,name)
	return a
end

do
	local inss = M.set_updater
		
	C.Insert = function(self)
		inss(function() self:_update_function() end,self:GetName(),1,true)
	end

	C.Remove = function(self)
		inss("remove",self:GetName(),1)
	end
end
