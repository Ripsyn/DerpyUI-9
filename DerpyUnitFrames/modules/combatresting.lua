local W,M,L,V = unpack(select(2,...))

local new_form = function(self,t,y)
	self:_SetFormattedText(t,string.upper(y))
end

W.player_combat = function(self,unit)
	if unit ~= "player" then return end
	
	local init_combat = function(self)
		self.anim:Play()
		self:SetText("COMBAT")
		self:SetTextColor(1,.1,.1)
	end
	
	local end_combat = function(self)
		self.anim:Stop()
		if self.rest then
			self:init_rest()
		else
			self:SetText("")
		end
	end
	
	local InCombatLockdown = InCombatLockdown
	
	local init_rest = function(self)
		self:SetText("RESTING")
		self:SetTextColor(.8,1,1)
	end
	
	local text = M.setfont(self.level_,14)
	text:SetJustifyH("RIGHT")
	text:SetPoint("TOPRIGHT",-6.4,-6)
	
	-- local leader = M.setfont(self.level_,14)
	-- leader:SetPoint("TOPLEFT",7.3,-6)
	-- leader:SetTextColor(.8,1,1)
	-- leader._SetFormattedText = leader.SetFormattedText
	-- leader.SetFormattedText = new_form
	-- self:Tag(leader,"[leaderlong]")
	
	text.anim = text:CreateAnimationGroup("Flash")
	M.anim_alpha(text.anim,"a",0,.2,.666)
	M.anim_alpha(text.anim,"b",1,.1,0)
	M.anim_alpha(text.anim,"c",2,.2,-.666)
	M.anim_alpha(text.anim,"d",3,.1,0)
	text.anim:SetLooping("REPEAT")
	
	text.init_combat = init_combat
	text.end_combat = end_combat
	text.init_rest = init_rest
	
	local IsResting = IsResting
	
	local rest_watch = CreateFrame("Frame",nil,self.level_)
	rest_watch:RegisterEvent("PLAYER_REGEN_ENABLED")
	rest_watch:RegisterEvent("PLAYER_REGEN_DISABLED")
	rest_watch:RegisterEvent("PLAYER_UPDATE_RESTING")
	rest_watch:RegisterEvent("PLAYER_ENTERING_WORLD")
	rest_watch:SetScript("OnEvent",function(self,event)
		if event == "PLAYER_REGEN_DISABLED" then
			text:init_combat()
		elseif event == "PLAYER_REGEN_ENABLED" then
			text:end_combat()
		elseif IsResting() then
			text.rest = true
			if InCombatLockdown() then return end
			text:init_rest()
		else
			text.rest = false
			if InCombatLockdown() then return end
			text:SetText("")
		end
	end)
end

W.target_afk = function(self,unit)
	if unit ~= "target" then return end
	
	local afk = M.setfont(self.level_,14)
	afk:SetPoint("TOPLEFT",7.3,-6)
	afk:SetTextColor(1,.2,.2)
	afk:SetText("AFK ")
	
	-- local leader = M.setfont(self.level_,14)
	-- leader:SetPoint("LEFT",afk,"RIGHT",-.7,0)
	-- leader:SetTextColor(.8,1,1)
	-- leader._SetFormattedText = leader.SetFormattedText
	-- leader.SetFormattedText = new_form
	-- self:Tag(leader,"[leaderlong]")
	
	local afk_watch = CreateFrame("Frame",nil,self.level_)
	afk_watch.t = afk
	
	afk_watch:RegisterEvent("PLAYER_TARGET_CHANGED")
	afk_watch:RegisterEvent("PLAYER_FLAGS_CHANGED")
	
	afk_watch:SetScript("OnEvent",function(self)
		if UnitIsAFK("target") then
			self.t:SetText("AFK ")
		else
			self.t:SetText("")
		end
	end)
	
	local cc = M.setfont(self.level_,24)
	cc:SetFont(M.media.cdfont,24,"OUTLINE")
	cc:SetPoint("TOPRIGHT",self.level_,-7.5,-8.5)
	self:Tag(cc,"[cpoints]")

	cc.SetFormattedText = function(self,t,f)
		if f == 1 or f == 2 then
			self:SetTextColor(0,1,0)
		elseif f == 3 or f == 4 then
			self:SetTextColor(1,1,0)
		elseif f == 5 then
			self:SetTextColor(1,0,0)
		end
		self:SetText(f)
	end	
end