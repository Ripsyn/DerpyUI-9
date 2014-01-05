local C,M,L,V = unpack(select(2,...)) --

local AZ = M.frame(Minimap,18,"LOW",true)
	AZ:SetPoint("TOPRIGHT",4,-1)
	AZ:SetPoint("BOTTOMLEFT",-4,1)
	AZ:SetBackdropBorderColor(1,1,1,0)

local y = CreateFrame("ScrollFrame",nil,AZ)
	y:SetPoint("TOPLEFT",4,-4)
	y:SetPoint("BOTTOMRIGHT",-4,4)
	y:SetFrameStrata("LOW")
	y:SetFrameLevel(19)
	
local h = CreateFrame("Frame",nil,y)
	h:SetSize(256,256)
	h:SetPoint("CENTER",Minimap)
	h:SetFrameLevel(19)
	h:SetFrameStrata("LOW")
		
	y:SetScrollChild(h)
	
local az_tex = h:CreateTexture(nil,"BORDER")
	az_tex:SetTexture(M.media.path.."az.tga")
	az_tex:SetSize(256,256)
	az_tex:SetPoint("CENTER",Minimap)

local az_anim = az_tex:CreateAnimationGroup("Az_rotate")

local a = az_anim:CreateAnimation("Rotation")
	a:SetDuration(50) 
	a:SetOrder(1)
	a:SetDegrees(360)
	az_anim:SetLooping("REPEAT")

	az_anim:Play()
	
local az_boreder1 =  h:CreateTexture(nil,"ARTWORK")	
	az_boreder1:SetPoint("BOTTOMLEFT",y)
	az_boreder1:SetPoint("TOPRIGHT",y,"RIGHT",0,14)
	az_boreder1:SetTexture(M.media.blank)
	az_boreder1:SetGradientAlpha("VERTICAL",0,0,0,1,0,0,0,0)
	
local mesageframe = CreateFrame("Frame",nil,Minimap)
	mesageframe:SetFrameLevel(20)
	mesageframe:SetFrameStrata("LOW")
	mesageframe:SetAllPoints(y)
	
local bg = mesageframe:CreateTexture(nil,"BORDER")	
	bg:SetAllPoints()
	bg:SetTexture(M.media.blank)
	bg:SetGradientAlpha("VERTICAL",unpack(M["media"].gradient))

mesageframe.str = {}	
	
local _play = function(self)
	self.anim:Play()
end

local _stop = function(self,force)
	if force then
		self.anim:Stop()
	else
		self.anim:Finish()
	end
end
	
for i=1,3 do
	local self = M.setfont_lang(mesageframe,25)
	if i == 1 then
		self:SetPoint("TOP",-.5,-22)
	else
		self:SetPoint("TOP",mesageframe.str[i-1],"BOTTOM",0,-5.8)
	end
	mesageframe.str[i] = self
	local anim = self:CreateAnimationGroup("sdhgkbgl"..i)
	M.anim_alpha(anim,"b",1,.2,1)
	M.anim_alpha(anim,"c",2,.4,0)
	M.anim_alpha(anim,"a",3,.2,-1)
	anim:SetLooping("REPEAT")
	self.anim = anim
	self.Play = _play
	self.Stop = _stop
	self:SetAlpha(0)
end

mesageframe.str[3]:SetText("CONNECTING")
mesageframe.str[3]:Play()

local THE_BLACK = CreateFrame("Frame",nil,Minimap)
	THE_BLACK:SetFrameLevel(21)
	THE_BLACK:SetFrameStrata("LOW")
	THE_BLACK:SetAllPoints(y)
	THE_BLACK:SetBackdrop({bgFile = M.media.blank})
	THE_BLACK:SetBackdropColor(unpack(M.media.color))
	THE_BLACK:SetAlpha(0)
	
local rota_tex = M.cirle(h,30,400,360)
rota_tex:SetPoint("CENTER",Minimap,0,-100)
rota_tex:Hide()
local x1,x2,x3 = unpack(M.media.color)
rota_tex:SetVertexColor(x1+.2,x2+.2,x3+.2)

local fac = UnitFactionGroup("player");

local col = {
	["Horde"] = {.9,.1,.2},
	["Alliance"] = {0,.4,.9}}

local faction_tex = mesageframe:CreateTexture(nil,"ARTWORK")
	faction_tex:SetSize(128,128)
	faction_tex:SetPoint("CENTER",Minimap,0,2)
	faction_tex:SetTexture("Interface\\Timer\\"..fac.."-Logo")
	faction_tex:Hide()	
	
local f_a = faction_tex:CreateAnimationGroup("lol")

local ls = f_a:CreateAnimation("Scale")
	ls:SetDuration(0)
	ls:SetScale(.05,.05)
	ls:SetOrder(1)
	
local ls = f_a:CreateAnimation("Alpha")
	ls:SetDuration(0)
	ls:SetChange(-1)
	ls:SetOrder(1)	
	
local ls = f_a:CreateAnimation("Scale")
	ls:SetDuration(.4)
	ls:SetScale(20,20)
	ls:SetOrder(2)
	
local ls = f_a:CreateAnimation("Alpha")
	ls:SetDuration(.4)
	ls:SetChange(1)
	ls:SetOrder(2)
	
local black_end = CreateFrame("Frame",nil,Minimap)
	black_end:SetAllPoints(y)
	black_end:Hide()
	
	local w__ = floor(black_end:GetWidth()+.5)/4
	local h__ = floor(black_end:GetHeight()+.5)/3

local _tsf = {}
	
for i=1,12 do
	local tex = black_end:CreateTexture(nil,"OVERLAY")
	tex:SetSize(w__,h__)
	if i==1 then
		tex:SetPoint("TOPLEFT")
	elseif i==5 or i==9 then
		tex:SetPoint("TOP",_tsf[i-4],"BOTTOM")
	else
		tex:SetPoint("LEFT",_tsf[i-1],"RIGHT")
	end
	tex:SetTexture(M.media.blank)
	tex:SetVertexColor(unpack(M.media.color))
	_tsf[i] = tex
	local f_a = tex:CreateAnimationGroup("lol")
	local ls = f_a:CreateAnimation("Alpha")
	ls:SetDuration(0)
	ls:SetChange(1)
	ls:SetOrder(1)	
	local ls = f_a:CreateAnimation("Alpha")
	ls:SetDuration(random(100)/100+.3)
	ls:SetChange(0)
	ls:SetOrder(2)	
	local ls = f_a:CreateAnimation("Alpha")
	ls:SetDuration(.2)
	ls:SetChange(-1)
	ls:SetOrder(3)
	tex.anim = f_a
	tex:SetAlpha(0)
end

local play_end = function()
	for i=1,12 do
		_tsf[i].anim:Play()
	end
end
	
---- SCR DO
local scr = {}

scr[1] = function(self)
	UIFrameFadeIn(self,.5,0,1)
	self.t = .5
	mesageframe.str[3]:Stop()
end

scr[2] = function(self)
	mesageframe.str[1]:SetText("FETCHING")
	mesageframe.str[1].anim.c:SetDuration(.3)
	UIFrameFadeOut(self,.3,1,0)
	mesageframe.str[1]:Play()
	mesageframe.str[1]:Stop()
	az_tex:SetSize(474,474)
	az_boreder1:Hide()
	a:SetDuration(45) 
	az_tex:SetPoint("CENTER",Minimap,64,-64)
	self.t = .7
end

scr[3] = function(self)
	mesageframe.str[2].anim.c:SetDuration(.3)
	mesageframe.str[2]:Play()
	mesageframe.str[2]:Stop()
	mesageframe.str[2]:SetText("VERIFYING")
	self.t = .6
end

scr[4] = function(self)
	mesageframe.str[3]:Play()
	mesageframe.str[3]:SetText("CONNECTED")
	self.t = .2
end

scr[5] = function(self)
	mesageframe.str[3]:Stop(true)
	mesageframe.str[3]:SetAlpha(1)
	self.t = .8
end

scr[6] = function(self)
	UIFrameFadeIn(self,.3,0,1)
	self.t = .3
end

scr[7] = function(self)
	mesageframe.str[3]:SetAlpha(0)
	mesageframe.str[3]:Play()
	mesageframe.str[3]:SetText("LOGGING IN")
	UIFrameFadeOut(self,.2,1,0)
	az_anim:Stop()
	az_tex:Hide()
	rota_tex:Show()
	az_boreder1:Show()
	az_boreder1:ClearAllPoints()
	az_boreder1:SetAllPoints(self)
	self.t = 1.2
end

scr[8] = function(self)
	mesageframe.str[3]:Stop(true)
	mesageframe.str[3]:SetAlpha(1)
	mesageframe.str[3]:SetText("SUCCESS")
	self.t = .4
end

scr[9] = function(self)
	mesageframe.str[1]:SetText(string.upper(fac))
	mesageframe.str[1]:SetTextColor(unpack(col[fac]))
	mesageframe.str[2]:SetText(string.upper(UnitName("player")))
	mesageframe.str[2]:SetTextColor(RAID_CLASS_COLORS[M.class].r,RAID_CLASS_COLORS[M.class].g,RAID_CLASS_COLORS[M.class].b)
	for i=1,2 do
		mesageframe.str[i].anim.c:SetDuration(10)
		mesageframe.str[i]:Play()
	end
	self.t = .6
end

scr[10] = function(self)
	UIFrameFadeIn(self,.2,0,1)
	self.t = .2
end

scr[11] = function(self)
	mesageframe.str[3]:SetAlpha(0)
	for i=1,2 do
		mesageframe.str[i]:Stop(true)
		mesageframe.str[i]:SetAlpha(0)
	end
	UIFrameFadeOut(self,.1,1,0)
	rota_tex:play()
	rota_tex:SetVertexColor(unpack(col[fac]))
	self.t = .2
end

scr[12] = function(self)
	faction_tex:Show()	
	f_a:Play()
	self.t = 3
end

scr[13] = function(self)
	mesageframe.str[3]:SetText("LOADING")
	mesageframe.str[3].anim.c:SetDuration(2)
	mesageframe.str[3]:Play()
	mesageframe.str[3]:Stop()
	self.t = .5
end

scr[14] = function(self)
	UIFrameFadeIn(self,.5,0,1)
	self.t = .5
end

scr[15] = function(self)
	for i=1,3 do
		mesageframe.str[i]:Stop(true)
		mesageframe.str[i]:Hide()
	end
	mesageframe:Hide()
	mesageframe=nil
	AZ:Hide()
	AZ=nil
	UIFrameFadeOut(self,.3,1,0)
	black_end:Show()
	play_end()
	M.checkvarleft()
	M.checkvarleft = nil
	M.mod_minimap()
	M.mod_minimap = nil
	self.t = 4
end

scr[16] = function(self)
	self.t = nil
	self:SetScript("OnUpdate",nil)
	self:Hide()
	black_end:Hide()
	black_end = nil
	scr=nil;
end

THE_BLACK:Hide()

M.addenter(function() THE_BLACK:Show() end)

local c = 1
THE_BLACK.t = 1
THE_BLACK:SetScript("OnUpdate",function(self,t)
	self.t = self.t - t
	if self.t > 0 then return end
	scr[c](self); c=c+1;
end)

