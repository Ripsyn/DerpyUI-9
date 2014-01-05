local W,M,L,V = unpack(select(2,...))
local unpack = unpack
local floor = floor

local UnitIsDead = UnitIsDead
local UnitIsGhost = UnitIsGhost
local UnitIsConnected = UnitIsConnected

local w_offline = "|cffFFFFFFOFFLINE|r"
local u_dead = "|cffFFFFFFDEAD|r"
local u_ghost = "|cffFFFFFFGHOST|r"
local u_offline = "|cffFFFFFFOFF|r"

local bar_value = function(self,value)
	if not self.value then return end
	self.value:SetText(value)
end

local are_you_dead = function(self,unit,up)
	if UnitIsDead(unit) 		 then	bar_value(self,u_dead) 		return true end
	if UnitIsGhost(unit) 		 then	bar_value(self,u_ghost) 	return true end
	if not UnitIsConnected(unit) then	bar_value(self,up and u_offline or w_offline) 	return true end
	return false
end

local health_color = function(per)
	if per <= .5 then 
		return 1,per*2,0
	else
		return 2*(1-per),1,0
	end
end

local stop_anim = function(self,bar,anim)
	if anim then
		bar.second.anim:Finish()
		bar.second:SetFrameLevel(5)
		bar:SetFrameLevel(6)
	end
end

local UnitIsPlayer = UnitIsPlayer
local UnitSelectionColor = UnitSelectionColor
local UnitClass = UnitClass
local color_class = W.oUF.colors.class

local for_target = function(value,unit,current,maxhp,value_percent)
	if not UnitIsPlayer(unit) then 
		value:SetTextColor(UnitSelectionColor(unit))		
	else
		value:SetTextColor(unpack(color_class[select(2, UnitClass(unit))]))		
	end
	value:SetText(current.." ")
	local perc = current/maxhp
	value_percent:SetText(floor(perc*100).." %")
	value_percent:SetTextColor(health_color(perc))
end

-- update function normal
local updateHealth = function(bar, unit, current, maxhp)  
	
	local second = bar.second
	local anim = second.anim:IsPlaying()
	
	if are_you_dead(bar,unit,bar.party) then
		bar:update_color(1)
		second:SetMinMaxValues(0,maxhp)
		second:SetValue(maxhp)
		stop_anim(second,bar,anim)
		second:SetAlpha(1)
		if bar.value_percent then
			bar.value_percent:SetText("")
		end
	else
		if unit == "player" and bar.value then 
			bar.value:SetText(current)
			bar.value:SetTextColor(health_color(current/maxhp))
		elseif unit == "target" then
			for_target(bar.value,unit,current,maxhp,bar.value_percent)
		elseif bar.party then
			bar.value:SetText()
		end

		bar:SetValue(maxhp-current)
		second:SetMinMaxValues(0,maxhp)
		second:SetValue(maxhp-current)
		
		if current == maxhp then
			bar:update_color(0)
			stop_anim(second,bar,anim)
			second:SetAlpha(1)
		else
			if (current/maxhp) <= bar.lowhealthcc then
				if not bar.second.anim:IsPlaying() then
					bar.second.anim:Play()
					bar:SetFrameLevel(5)
					bar.second:SetFrameLevel(6)	
				end
				bar:update_color(2)
			else
				stop_anim(second,bar,anim)
				bar:update_color(3)
			end
		end
	end
end

local color_mode = function(self,r1,g1,b1,r2,b2,g2,alpha)
	if self.port.abs_r > (self.port.abs_b + .25 + self.port.abs_g) then
		return r2,b2,g2,alpha
	else
		return r1,b1,g1,alpha
	end
end

local wtf = {
	[0] = function(self)
		self:SetStatusBarColor(0, 0, 0, 0)
		self.abs = 0 
	end,
	[1] = function(self)
		self:SetStatusBarColor(0,0,0,0)
		self.second:SetStatusBarColor(0.2, 0.2, 0.2, 0.75)
		self.abs = 1
	end,
	[2] = function(self)
		self.second:SetStatusBarColor(color_mode(self,1,0,0,0,.8,1,.95))
		self:SetStatusBarColor(color_mode(self,.09,0,0,0,.09,.12,.71))
		self.abs = 2
	end,
	[3] = function(self)
		self:SetStatusBarColor(color_mode(self,.25,0,0,0,.15,.25,.666))
		self.second:SetStatusBarColor(color_mode(self,.48,0,0,0,.54,.64,.6))
		self.abs = 3
	end,
}

local update_color = function(self,dead)
	if dead == self.abs then return end
	return wtf[dead](self)
end

W.Health = function(self,unit,var,party)
	local hp = CreateFrame("StatusBar", nil, self)
	hp:SetStatusBarTexture(M["media"].barv)
	hp:SetAllPoints(self.Portrait)
	hp:SetFrameLevel(6)
	hp:SetStatusBarColor(0,0,0,0)
	hp.Smooth = var.hsmooth
	hp.second = CreateFrame("StatusBar",nil,hp)
	hp.second:SetFrameLevel(5)
	hp.second:SetAllPoints(self.Portrait)
	hp.second:SetStatusBarTexture(M["media"].blank)
	hp.second:SetStatusBarColor(0,0,0,0)
	hp:SetOrientation(var.hp_orient)
	hp.second:SetOrientation(var.hp_orient)
	hp.update_color = update_color
	W.SetAnim(hp.second,.2,1,2)
	self.Health = hp
	self.Health.port = self.Portrait
	self.Portrait.hp = hp
	self.Health.party = party
	self.Health.lowhealthcc = var.lowhealth/100
	self.Health.PostUpdate = updateHealth
end