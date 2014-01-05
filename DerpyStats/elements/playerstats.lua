local C,M,L,V = unpack(select(2,...))
local Class = M.Class
local GetSpellBonusHealing = GetSpellBonusHealing
local GetSpellBonusDamage = GetSpellBonusDamage
local UnitRangedAttackPower = UnitRangedAttackPower
local UnitAttackPower = UnitAttackPower
local player = "player"
local hunter = "HUNTER"
local format = format
local abs = abs
local GetCombatRating = GetCombatRating

-- Dis is Power
local Power = C.frame("Power",nil,true)
	
local get_spd = function(self)
	local h = GetSpellBonusHealing()
	local s = GetSpellBonusDamage(7)
	if h > s then
		self.lt:SetText(h)
		self.rt:SetText("Sph")
	else
		self.lt:SetText(s)
		self.rt:SetText("Spd")
	end
end

local get_hunter = function(self)
	local Rbase, RposBuff, RnegBuff = UnitRangedAttackPower(player)
	self.lt:SetText(Rbase + RposBuff + RnegBuff)
end

local get_other = function(self)
	local base, posBuff, negBuff = UnitAttackPower(player)
	self.lt:SetText(base + posBuff + negBuff)
end

-- checking
M.addenter(function()
	local base, posBuff, negBuff = UnitAttackPower(player)
	local a = base + posBuff + negBuff
	local h = GetSpellBonusHealing()
	local s = GetSpellBonusDamage(7)
	local b = max(h,s)
	if a > b and Class ~= hunter then
		Power.rt:SetText('Ap')
		Power._update_function = get_other
	elseif Class == hunter then
		Power._update_function = get_hunter
		Power.rt:SetText('Ap')
	else
		Power._update_function = get_spd
	end
end)

Power:SetScript("OnShow",C.Insert)
Power:SetScript("OnHide",C.Remove)
----------------------------------------


-- Dis is Hit Rating
local Hit = C.frame("Hit",nil,true)
Hit.rt:SetText("Hit")

local GetCombatRatingBonus = GetCombatRatingBonus

M.addafter(function()
	local base, posBuff, negBuff = UnitAttackPower(player)
	local a = base + posBuff + negBuff
	local h = GetSpellBonusHealing()
	local s = GetSpellBonusDamage(7)
	local b = max(h,s)
	if a > b and Class ~= hunter then
		Hit._num = 6
	elseif Class == hunter then
		Hit._num = 7
	else
		Hit._num = 8
	end
end)

Hit._update_function = function(self) self.lt:SetText(format("%.2f", GetCombatRatingBonus(self._num))) end
Hit:SetScript("OnShow",C.Insert)
Hit:SetScript("OnHide",C.Remove)
------------------------------------


-- Dis is Mastery
local Mastery = C.frame("Mastery",nil,true)
Mastery.rt:SetText("Mas")

Mastery._update_function = function(self)
	self.lt:SetText(GetCombatRating(26))
end

Mastery:SetScript("OnShow",C.Insert)
Mastery:SetScript("OnHide",C.Remove)
--------------------------------------------


-- Dis is Haste
local Haste = C.frame("Haste",nil,true)
Haste.rt:SetText("Haste")

local get_haste = M.null

M.addafter(function()
	local b = GetCombatRating(20)
	local a = GetCombatRating(18)
	if a > b and Class ~= hunter then
		Haste._num = 18
	elseif Class == hunter then
		Haste._num = 19
	else
		Haste._num = 20
	end
end)

Haste._update_function = function(self) self.lt:SetText(GetCombatRating(self._num)) end
Haste:SetScript("OnShow",C.Insert)
Haste:SetScript("OnHide",C.Remove)
----------------------------------------


-- Dis is Crit Rating
local Crit = C.frame("Crit",nil,true)
Crit.rt:SetText("Crit")
local GetSpellCritChance = GetSpellCritChance
local GetCritChance = GetCritChance
local GetRangedCritChance = GetRangedCritChance
local GetSpellCritChance = GetSpellCritChance

M.addafter(function()
	local b = GetSpellCritChance(1)
	local a = GetCritChance()
	if a > b and Class ~= hunter then
		Crit._update_function = function(self) self.lt:SetText(format("%.2f",GetCritChance())) end
	elseif Class == hunter then
		Crit._update_function = function(self) self.lt:SetText(format("%.2f",GetRangedCritChance())) end
	else
		Crit._update_function = function(self) self.lt:SetText(format("%.2f",GetSpellCritChance(1))) end
	end
end)

Crit:SetScript("OnShow",C.Insert)
Crit:SetScript("OnHide",C.Remove)
----------------------------------------


-- Dis is Armor
local Armor = C.frame("Armor",nil,true)
Armor.rt:SetText("Arm")
Armor:RegisterEvent("UNIT_INVENTORY_CHANGED")
Armor:RegisterEvent("UNIT_AURA")
Armor:RegisterEvent("PLAYER_ENTERING_WORLD")

local correct = function(attackerLevel,armor)
	local levelModifier = attackerLevel;
	if ( levelModifier > 59 ) then
	levelModifier = levelModifier + (4.5 * (levelModifier-59));
	end
	local temp = 0.1*armor/(8.5*levelModifier + 40);
	temp = temp/(1+temp);

	if ( temp > 0.75 ) then
		return 75;
	end

	if ( temp < 0 ) then
		return 0;
	end

	return temp*100;
end

local UnitArmor,UnitLevel = UnitArmor,UnitLevel

local Armor_Update = function(self)
	local _,arm = UnitArmor("player")
	self.lt:SetText(arm)
end

local every_color = {
	[1] = {1,0},
	[2] = {.888,.3},
	[3] = {.780,.480},
	[4] = {.9,.9},
	[5] = {.480,.780},
	[6] = {.4,.888},
	[7] = {0,1},
}

local Armor_Enter = function(self)
	GameTooltip:SetOwner(self, "ANCHOR_NONE");
	GameTooltip:ClearAllPoints()
	GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -2)
	GameTooltip:ClearLines()
	local lvl = UnitLevel("player") + 3
	local _,arm = UnitArmor("player")
	for i = 1,7 do
		local a = every_color[i]
		GameTooltip:AddDoubleLine(lvl.." level",format("%.2f",correct(lvl,arm)).."%",1,1,1,a[1],a[2],0)
		lvl = lvl - 1
	end
	GameTooltip:Show()
end

Armor:SetScript("OnEvent",Armor_Update)
Armor:SetScript("OnEnter",Armor_Enter)
Armor:SetScript("OnLeave",function() GameTooltip:Hide() end)
--------------------------------------------


-- Dis is Avoidance
local Avoidance = C.frame("Avoidance",nil,true)
Avoidance.rt:SetText("Avd")
Avoidance:RegisterEvent("UNIT_AURA")
Avoidance:RegisterEvent("UNIT_INVENTORY_CHANGED")
Avoidance:RegisterEvent("PLAYER_TARGET_CHANGED")
Avoidance:RegisterEvent("PLAYER_ENTERING_WORLD")

local targetlv
local playerlv
local dodge
local parry
local block
local MissChance
local GetDodgeChance,GetParryChance = GetDodgeChance,GetParryChance
local GetBlockChance,GetCombatRating = GetBlockChance,GetCombatRating 

local function AV_Update(self)
	local format = string.format
	targetlv, playerlv = UnitLevel("target"), UnitLevel("player")
	local basemisschance
	local leveldifference
	local avoidance

	if targetlv == -1 then
		basemisschance = (5 - (3*.2))  --Boss Value
		leveldifference = 3
	elseif targetlv > playerlv then
		basemisschance = (5 - ((targetlv - playerlv)*.2)) --Mobs above player level
		leveldifference = (targetlv - playerlv)
	elseif targetlv < playerlv and targetlv > 0 then
		basemisschance = (5 + ((playerlv - targetlv)*.2)) --Mobs below player level
		leveldifference = (targetlv - playerlv)
	else
		basemisschance = 5 --Sets miss chance of attacker level if no target exists, lv80=5, 81=4.2, 82=3.4, 83=2.6
		leveldifference = 0
	end

	if leveldifference >= 0 then
		dodge = (GetDodgeChance()-leveldifference*.2)
		parry = (GetParryChance()-leveldifference*.2)
		block = (GetBlockChance()-leveldifference*.2)
		local x = GetCombatRating(CR_DEFENSE_SKILL)
		MissChance = (basemisschance + 1/(0.0625 + 0.956/((x~=0 and x or 0.00000000001)/4.91850*0.04)))
		avoidance = (dodge+parry+block+MissChance)
		self.lt:SetText(format("%.2f", avoidance))
	else
		dodge = (GetDodgeChance()+abs(leveldifference*.2))
		parry = (GetParryChance()+abs(leveldifference*.2))
		block = (GetBlockChance()+abs(leveldifference*.2))
		local x = GetCombatRating(CR_DEFENSE_SKILL)
		MissChance = (basemisschance + 1/(0.0625 + 0.956/((x~=0 and x or 0.00000000001)/4.91850*0.04)))
		avoidance = (dodge+parry+block+MissChance)
		self.lt:SetText(format("%.2f", avoidance))
	end
end
	
local names = L['avoid']
Avoidance:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_NONE");
	GameTooltip:ClearAllPoints()
	GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -2)
	GameTooltip:ClearLines()
	if targetlv > 1 then
		GameTooltip:AddDoubleLine(names["avoid"],"("..targetlv.." lvl)")
	elseif targetlv == -1 then
		GameTooltip:AddDoubleLine(names["avoid"],"(boss)")
	else
		GameTooltip:AddDoubleLine(names["avoid"],"("..targetlv.." lvl)")
	end
	GameTooltip:AddDoubleLine(names["miss"],format("%.2f",MissChance) .. "%",1,1,1, 1,1,1)
	GameTooltip:AddDoubleLine(names["dodge"],format("%.2f",dodge) .. "%",1,1,1, 1,1,1)
	GameTooltip:AddDoubleLine(names["parry"],format("%.2f",parry) .. "%",1,1,1, 1,1,1)
	GameTooltip:AddDoubleLine(names["block"],format("%.2f",block) .. "%",1,1,1, 1,1,1)
	GameTooltip:Show()
end)
Avoidance:SetScript("OnLeave", function() GameTooltip:Hide() end)
Avoidance:SetScript("OnEvent",AV_Update)


-- Honor kills
local Honor = C.frame("Honor Kills",nil,true)
Honor.rt:SetText("HK")
Honor:RegisterEvent("PLAYER_PVP_KILLS_CHANGED")
Honor:RegisterEvent("PLAYER_ENTERING_WORLD")
Honor:SetScript("OnEvent",function(self) self.lt:SetText(GetPVPLifetimeStats()) end)
Honor:SetScript("OnEnter",function(self)
	GameTooltip:SetOwner(self, "ANCHOR_NONE");
	GameTooltip:ClearAllPoints()
	GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -2)
	local _,x = GetCurrencyInfo(392) -- is honor
	GameTooltip:AddDoubleLine(names["honor"],x.."/4000",1,1,1,1,1,1)
	local _,x,_,_,y = GetCurrencyInfo(390) -- is not honor
	GameTooltip:AddDoubleLine(names["cc"],x.."/"..y,1,1,1,1,1,1)
	GameTooltip:Show()
end)
Honor:SetScript("OnLeave",function(self)
	GameTooltip:Hide()
end)

-- Ressssss
local Res = C.frame("Resilience",nil,true)
Res.rt:SetText("Res")
Res._update_function = function(self) self.lt:SetText(GetCombatRating(16)) end
Res:SetScript("OnShow",C.Insert)
Res:SetScript("OnHide",C.Remove)