local M,L = unpack(select(2,...))

local pairs = pairs
local _G = _G

-- direct event
M.d_event = function(self, event, ...) self[event](self, event, ...) end

-- "PLAYER ENTERING WORLD" load
local enterload = {}
-- after player entering world load
local afterload = {}
-- 1 second after 3 seconds load
local lastload = {}

local model_frame

UIParent:SetAlpha(0)
Minimap:Hide()

local Mess_start = CreateFrame("Frame")
Mess_start:SetPoint("CENTER")
Mess_start:SetSize(380,320)
Mess_start.t = 0
Mess_start:SetBackdrop({
edgeFile = M["media"].blank, 
edgeSize = 1})
Mess_start:Hide()

local muffin = Mess_start:CreateTexture(nil,"OVERLAY")
muffin:SetSize(106,106)
muffin:SetPoint("TOPRIGHT",-23,-12)
muffin:SetTexture(M.media.path.."muffin.tga")

local muf_anim = muffin:CreateAnimationGroup("Muffin")

local pr_bar = Mess_start:CreateTexture(nil,"BORDER")
pr_bar:SetPoint("TOPLEFT")
pr_bar:SetPoint("TOPRIGHT")
pr_bar:SetTexture(149/255,186/255,204/255,.5)
Mess_start.pr = pr_bar

local mess_proc = CreateFrame("MessageFrame",nil,Mess_start)
mess_proc:SetPoint("BOTTOMLEFT",16,36)
mess_proc:SetPoint("BOTTOMRIGHT",-16,36)
mess_proc:SetHeight(150)
mess_proc:SetFont(M.media.fontn,14)
mess_proc:SetSpacing(2)
mess_proc:SetShadowOffset(1.25,-1.25)
mess_proc:SetShadowColor(0,0,0,1)

local _total = 0
local _temp = 0
local _c = 1
local cur_table = enterload
local cur_n = "enter"
local can_destroy_last

local fin_ = {
	"|cff00ff00SUCCESS|r",
	"|cffff0000UNSTABLE|r",
	"|cffff0000WARNING|r",
	"|cffffff00STABLE|r",
	"|cff00ff00PASSED|r",
}

local mes = {
	"Establishing minimap connection...",

}

local end_now
local d = 1
local prt
local prt2 = function()
	if d > #mes then mes = nil prt = M.null prt2 = nil return end
	--mess_proc:AddMessage(mes[d])
	d = d + 1
	if d > #mes then
		if can_destroy_last then
			lastload = nil
		else
			can_destroy_last = true
		end
		end_now = true
	end
end

prt = function()
	--mess_proc:AddMessage("Processing "..gsub(tostring(cur_table[_c]),"00000000","0x").." from #"..cur_n.." >>> "..fin_[floor(random(399)/100)+1])
		_c = _c + 1 
		if _c > #cur_table then
			if cur_table == lastload then prt = prt2 return end
			_c = 1; 
			cur_table = cur_table == enterload and afterload or lastload
			cur_n = cur_table == afterload and "after" or "last"
		end
end

local last_stay1 = function(self,t)
	self.t = self.t - t*4
	if self.t <= 0 then
		self:Hide()
		self:SetScript("OnUpdate",nil)
		muf_anim = nil
		collectgarbage("collect")
	else
		self:SetScale(self.t)
	end
end

local last_stay = function(self,t)
	self.t = self.t + t
	if self.t > 2 then mess_proc:Hide(); self.text:Hide() self.t = 1; return self:SetScript("OnUpdate",last_stay1) end
end

local done = 0
Mess_start:SetScript("OnUpdate",function(self,t)
	self.t = self.t + t
	_temp = _temp + t
	if _temp >= _total then
		if lastload then
			_total = #lastload + #afterload + #enterload + #mes - done
			self.pr:SetHeight(((done+1)/(_total+done))*320)
			_total = (4-self.t)/_total
		end
		_temp = 0
		done = done + 1
		prt()
	end
	if end_now then 
		afterload = nil
		enterload = nil
		fin_ = nil
		self.t = 0
		self.pr:SetHeight(320)
		return self:SetScript("OnUpdate",last_stay)
	end
end)

local frame = CreateFrame("Frame")
frame:Hide()
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent",function(self)
	Mess_start:SetScale(UIParent:GetScale())
	
	muffin:SetAlpha(.7)
	M.anim_alpha(muf_anim,"a",0,0,-1)
	M.anim_alpha(muf_anim,"a",1,1.8,0)
	M.anim_alpha(muf_anim,"a",2,1,.7)
	M.anim_alpha(muf_anim,"a",3,.2,-.1)
	M.anim_alpha(muf_anim,"a",4,.2,.05)
	M.anim_alpha(muf_anim,"a",5,.2,-.1)
	M.anim_alpha(muf_anim,"a",6,.2,.15)
	
	local a = muf_anim:CreateAnimation("Rotation")
	a:SetDuration(0) 
	a:SetOrder(0)
	a:SetDegrees(30)
	
	local a = muf_anim:CreateAnimation("Rotation")
	a:SetDuration(1) 
	a:SetOrder(2)
	a:SetDegrees(-30)
	a:SetSmoothing("OUT")
	
	muf_anim:Play()
	
	local t = M.setfont(Mess_start,28,nil,nil,"CENTER")
	t:SetFont(M.media.fontn,28)
	t:SetHeight(96)
	t:SetPoint("TOPLEFT",36,-18)
	t:SetText("DERPY MEDIA\nATTEMPTING TO\nINITIALIZE UI")
	
	self:SetScript("OnEvent",nil)
	self:UnregisterAllEvents()	
	
	M.scale = UIParent:GetScale()
	
	if #enterload~=0 then
		for i=1,#enterload do enterload[i]() end
	end
	
	if #afterload~=0 then
		for i=1,#afterload do afterload[i]() end
	end
	
	Mess_start:Show()
	Mess_start.text = t
	self:Show()
end)

M.addenter = function(f)
	enterload[#enterload+1] = f
end

local start_frame = CreateFrame("Frame")
start_frame:Hide()
start_frame:SetAlpha(0)
start_frame:SetBackdrop({bgFile = M.media.blank})
start_frame:SetBackdropColor(0,0,0,1)
start_frame:SetFrameLevel(Minimap:GetFrameLevel()+2)
start_frame:SetFrameStrata(Minimap:GetFrameStrata())
start_frame.count = 0

local st = 18
local st_1 = true
start_frame:SetScript("OnUpdate",function(self,t)
	self.count = self.count - t;
	if self.count > 0 then return end
	st = st - 1
	self.count = st/222;
	if st_1 == true then
		st_1 = false
		UIParent:SetAlpha(1)
	else
		st_1 = true
		UIParent:SetAlpha(0)
	end
	if st == 0 then 
		st,st_1 = nil,nil; 
		start_frame:SetScript("OnUpdate",nil) 
		start_frame:ClearAllPoints()
		start_frame:Hide()
		return UIParent:SetAlpha(1) 
	end
end)

local temp = function()
	start_frame:SetPoint("TOP",Minimap,0,-5*UIParent:GetScale())
	start_frame:SetPoint("BOTTOM",Minimap,0,5*UIParent:GetScale())
	start_frame:SetWidth(172)
	start_frame:SetScale(UIParent:GetScale())
	start_frame:Show()
end

local reset_load = function(self,t)
	self.n = self.n - t; if self.n > 0 then return end; self.n = 1;
	temp(); temp = M.null
	if not InCombatLockdown() then
		self:SetScript("OnUpdate",nil)
		self:Hide()
		if #lastload~=0 then
			for i=1,#lastload do lastload[i]() end
		end
		if can_destroy_last then
			lastload = nil
		else
			can_destroy_last = true
		end
		temp = nil
		Minimap:Show()
		start_frame:SetAlpha(1)
		collectgarbage("collect")
	else
		self.n = 1
	end
end

frame.n = 3
frame:SetScript("OnUpdate",function(self,t)
	self.n = self.n - t; if self.n > 0 then return end; self.n = 1;
	
		M.make_plav(model_frame,.2)
		
		local model = CreateFrame("PlayerModel",nil,model_frame)
		model:SetPoint("TOPLEFT")
		model:SetPoint("BOTTOMLEFT")
		model:SetPoint("TOPRIGHT",UIParent,"TOP")
		model:SetPoint("BOTTOMLEFT",UIParent,"BOTTOM")
		model:SetUnit('player')
		model:SetFacing(0.65)
		
		local name = M.setfont_lang(model_frame,32)
		name:SetPoint("TOPRIGHT",-250,-80)
		
		local a,b = UnitClass("player")
		name:SetTextColor(M.RaidColors[b].r,M.RaidColors[b].g,M.RaidColors[b].b)
		
		local zone = M.setfont_lang(model_frame,32)
		zone:SetPoint("BOTTOMRIGHT",-250,80)
		
		model_frame.z = zone
		model_frame.v = name
		model_frame:SetScript("OnShow",function(self)
			self.v:SetText(UnitName('player').." |cffffffff"..UnitLevel("player").."|r")
			local text = GetMinimapZoneText()
			local p = GetZoneText()
			if p:match(text) then
				text = ""
			else
				text = ": "..text
			end
			self.z:SetText(p..text)
		end)
		
		self:Hide()
		
		self:SetScript("OnUpdate",reset_load)
		self:Show()

		M.model_holder = model_frame
		
end)

M.addafter = function(f) 
	afterload[#afterload+1] = f
end

M.addlast = function(f) 
	lastload[#lastload+1] = f
end

model_frame = CreateFrame"Frame"
model_frame:SetAllPoints(UIParent)
model_frame:SetBackdrop({bgFile = M.media.blank})
model_frame:SetBackdropColor(0,0,0,0)
model_frame:SetAlpha(1)
model_frame:Hide()

model_frame:RegisterEvent"ADDON_LOADED"
model_frame:SetScript("OnEvent",function(self,event,arg)
	if arg ~= "DerpyMedia" then return end
	if not _G.DerpyMediaVars then
		_G.DerpyMediaVars = {
			["font_replace"] = true,
			["scale_lock"] = true,
			["font_offset"] = 4,
		}
	end
	_G.DerpyMediaVars.layout_offset = M.check_nil(_G.DerpyMediaVars.layout_offset,10)
end)