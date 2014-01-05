local W,M,L,V = unpack(select(2,...))

local sif_channel_hide = function(self)
	if not self.dublicate.spellcast_started then
		self.dublicate:SetAlpha(0)
	else
		self.dublicate:SetAlpha(1)
	end
end

local sif_show = function(self)
	if not self.dublicate.spellcast_started then return end
	self.dublicate:SetAlpha(1)
end

local isf_hook_show = function(self)
	self:GetParent().isf:SetAlpha(0)
	if not self.dublicate.spellcast_started then return end
	self.dublicate:SetAlpha(1)
end

local isf_hook_hide = function(self)
	self:GetParent().isf:SetAlpha(1)
end

local tf_changed = function(self)
	if self.cast:IsShown() then
		if self.cast.channeling then
			self:SetAlpha(0)
			self.spellcast_started = false
		else
			self.spellcast_started = true
		end
	else
		self:SetAlpha(0)
		self.spellcast_started = false
	end
end

local fadecast_events = {
	["UNIT_SPELLCAST_START"] = function(self)
		self:SetAlpha(0)
		self:Stop()
		self.dublicate.spellcast_started = true
	end,
	["UNIT_SPELLCAST_CHANNEL_START"] = function(self)
		self:SetAlpha(0)
		self:Stop()
		self.dublicate:SetAlpha(0)
	end,
	["UNIT_SPELLCAST_SUCCEEDED"] = function(self)
		self.fails = false
	end,
	["UNIT_SPELLCAST_FAILED"] = function(self) --["UNIT_SPELLCAST_FAILED_QUIET"]
		self.fails = true
	end,
	["UNIT_SPELLCAST_INTERRUPTED"] = function(self)
		self.fails = true
	end,
	["UNIT_SPELLCAST_STOP"] = function(self)
		if self.fails then
			self:backcolor(1,0,0,.5)
			self:SetBackdropColor(1,0,0)
		else
			self:backcolor(0,1,0,.5)
			self:SetBackdropColor(0,1,0)
		end
		self.dublicate:SetAlpha(0)
		self.dublicate.spellcast_started = false
		self:Play()
	end,
}

local reg_events = function(self)
	for t,p in pairs(fadecast_events) do
		self[t] = p	
		self:RegisterEvent(t)
	end
	self["UNIT_SPELLCAST_FAILED_QUIET"] = fadecast_events["UNIT_SPELLCAST_FAILED"]
	self:RegisterEvent("UNIT_SPELLCAST_FAILED_QUIET")
end

local PlayerCastbarFade = function(self,event,arg1)
	if arg1 ~= self.unit then return end
	self[event](self)
end

local UIFrameFadeOut = UIFrameFadeOut
local update = function(self,t)
	self.t = self.t - t;
	if self.t < 0 then
		self:SetScript("OnUpdate",nil)
		UIFrameFadeOut(self,.4,.8,0)
	end
end

local _play = function(self)
	self:SetScript("OnUpdate",nil)
	self.t = .6
	UIFrameFadeOut(self,.6,1,.8)
	self:SetScript("OnUpdate",update)
end

local _stop = function(self)
	self:SetScript("OnUpdate",nil)
	UIFrameFadeOut(self,0,0,0)
end

local set_fadecast = function(self,unit,dublicate,obj_unchor)
	local fade = CreateFrame("Frame",nil,self)
	fade:SetFrameLevel(8)
	fade:SetBackdrop(M.bg)
	fade.backcolor = M.backcolor
	M.style(fade,true)
	fade:SetPoint("TOPLEFT",obj_unchor)
	fade:SetPoint("BOTTOMRIGHT",obj_unchor)
	fade:SetAlpha(0)
	reg_events(fade)
	fade.Play = _play
	fade.Stop = _stop
	fade.unit = unit
	fade:SetScript("OnEvent",PlayerCastbarFade)
	fade.dublicate = dublicate
end

local __SetValue_color = function(self,value)
	self:TehSetValue(value)
	if value == 0 then return end
	if self.maximum == 0 then return end
	local max_modifi = value/self.maximum
	self:SetStatusBarColor(1-max_modifi,max_modifi-.2,0)
end

local minmax = function(self,value1,value2)
	self:TehSetMinMaxValues(value1,value2)
	self.maximum = value2
end

local cc;
local places = {}
local form_cast_place = function(unit,var)
	local p = CreateFrame("Frame",nil,UIParent)
	p.realname = string.upper(unit).."CASTBAR"
	p:SetFrameStrata("LOW")
	p:SetFrameLevel(20)
	M.tex_move(p,string.upper(unit).."CASTBAR",p.Hide)
	M.make_movable(p)
	p:Hide()
	places[unit] = p;
	if not cc then
		p:SetPoint("CENTER",0,-46);
	else
		p:SetPoint("TOP",places[cc],"BOTTOM",0,0);
	end
	p:SetSize(var.cast_w,var.cast_h); cc = unit;
	return p;
end

local insade_isf_not_pet = function(self,unit,var)
	if unit == "pet" then return end
	if var.cast_h == 0 then return end
	if not self.isf then return end
	local cast = CreateFrame("StatusBar", nil, self)
	cast:SetFrameLevel(2)
	local obj_unchor
	if var.castpos == "OUTSIDE" then
		local d = form_cast_place(unit,var)
		local x = CreateFrame("Frame",nil,UIParent)
		x:SetAllPoints(d)
		obj_unchor = x
	else
		obj_unchor = self.isf
	end
	if var.iconpos ~= "INSIDE" or var.icon ~= true then
		cast:SetPoint("TOP",obj_unchor,0,-4)
		cast:SetPoint("BOTTOM",obj_unchor,0,4)
		cast:SetPoint("LEFT",obj_unchor,4,0)
		cast:SetPoint("RIGHT",obj_unchor,-4,0)
		if var.icon then
			local icon = cast:CreateTexture(nil,"OVERLAY")
			icon:SetSize(var.iconsize,var.iconsize*.875)
			icon:SetPoint(var.iconside == "LEFT" and "TOPRIGHT" or "TOPLEFT",cast,"TOP"..var.iconside,var.iconside == "LEFT" and -6 or 6,0)
			cast.Icon = icon
			local bg = M.frame(cast,2,cast:GetFrameStrata(),true)
			bg:points(icon)
			icon:SetGradient("VERTICAL",.345,.345,.345,1,1,1)
			icon:SetTexCoord(3/32,1-3/32,5/32,1-5/32)
			cast.Iconbg = bg
		end
	elseif var.iconpos == "INSIDE" and var.icon then
		local q
		if var.castpos ~= "OUTSIDE" then
			q = var.isf_height
		else
			q = var.cast_h -8 
		end
		local x = floor(q / .6 + .5)
		cast:SetPoint("TOPLEFT",obj_unchor,var.iconside == "LEFT" and (x+5) or 4,-4)
		cast:SetPoint("BOTTOMRIGHT",obj_unchor,var.iconside == "RIGHT" and (-x-5) or -4,4)
		local icon = cast:CreateTexture(nil,"OVERLAY")
		icon:SetSize(x,q)
		icon:SetPoint(var.iconside == "LEFT" and "RIGHT" or "LEFT",cast,var.iconside,var.iconside == "LEFT" and -1 or 1,0)
		icon:SetGradient("VERTICAL",.345,.345,.345,1,1,1)
		icon:SetTexCoord(.1,.9,.27,.73)
		local border = cast:CreateTexture(nil,"OVERLAY")
		border:SetTexture(0,0,0,1)
		border:SetSize(1,var.isf_height)
		border:SetPoint(var.iconside,cast,var.iconside == "LEFT" and -1 or 1,0)
		cast.Icon = icon
	end
	local font_size
	local text_offset = var.isf_offset/10 - 2
	if var.castpos ~= "OUTSIDE" then
		font_size = var.isf_height
		text_offset = var.isf_offset/10 - 2
	else
		font_size = var.cast_font
		text_offset = var.cast_offset/10 - 2
		obj_unchor:SetFrameLevel(cast:GetFrameLevel()-2)
		obj_unchor:SetFrameStrata(cast:GetFrameStrata())
	end
	cast:SetStatusBarTexture(M["media"].barv)
	local bg = M.frame(cast,1,cast:GetFrameStrata())
	bg:SetAllPoints(obj_unchor)
	cast.bg = bg
	local Time = M.setfont(cast,font_size,nil,nil,"RIGHT")
	Time:SetPoint("RIGHT",cast,-2.5,text_offset)
	cast.Time = Time
	local Text = M.setfont_lang(cast,font_size)
	Text:SetPoint("LEFT",cast,2.5,text_offset)
	Text:SetPoint("RIGHT",cast.Time,"LEFT", -1, 0)
	cast.Text = Text
	local Spark = cast:CreateTexture(nil, "OVERLAY")
	Spark:SetWidth(8)
	Spark:SetBlendMode("ADD")
	Spark:SetAlpha(.7)
	cast.Spark = Spark
	self.Castbar = cast
	if unit == "player" then
		cast.SafeZone = self.Castbar:CreateTexture(nil, "ARTWORK")
		cast.SafeZone:SetAllPoints(self.Castbar)
		cast.SafeZone:SetTexture(M["media"].barv)
		cast.SafeZone:SetVertexColor(.666,0,0,.444)
	end
	local dublicate = CreateFrame("Frame",nil,obj_unchor)
	dublicate:SetAlpha(0)
	cast.dublicate = dublicate
	dublicate:SetFrameLevel(4)
	local a = dublicate:CreateTexture(nil,"OVERLAY")
	a:SetTexture(0,1,0)
	a:SetPoint("TOPLEFT",obj_unchor,4,-4)
	a:SetPoint("BOTTOMRIGHT",obj_unchor,-4,4)
	set_fadecast(var.castpos ~= "OUTSIDE" and self or obj_unchor,unit,dublicate,obj_unchor)
	cast.maximum = 0
	cast.TehSetValue = cast.SetValue
	cast.SetValue = __SetValue_color
	cast.TehSetMinMaxValues = cast.SetMinMaxValues
	cast.SetMinMaxValues = minmax
	if var.castpos == "OUTSIDE" then
		cast:HookScript("OnShow",sif_channel_hide)
		cast:HookScript("OnHide",sif_show)
		dublicate:SetFrameLevel(obj_unchor:GetFrameLevel())
		dublicate:SetFrameStrata(obj_unchor:GetFrameStrata())
	else
		cast:HookScript("OnShow",isf_hook_show)
		cast:HookScript("OnHide",isf_hook_hide)
	end
	M.addafter(function() sif_channel_hide(cast) end)
	if unit == "target" or unit == "focus" then
		local up = string.upper(unit)
		dublicate:RegisterEvent("PLAYER_"..up.."_CHANGED")
		dublicate.cast = cast
		dublicate:SetScript("OnEvent",tf_changed)
	end
end

W.Castbar = function(self,var,unit)
	if unit == "targettarget" or unit == "focustarget" then return end
	if not var.castbar then return end
	insade_isf_not_pet(self,unit,var)	
end