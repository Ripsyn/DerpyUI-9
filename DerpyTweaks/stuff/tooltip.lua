local C,M,L,V = unpack(select(2,...))

if V.tooltip ~= true then return end
local _G = getfenv(0)
local GameTooltipStatusBar = GameTooltipStatusBar
local oUF = oUF

local tooltips = {
	GameTooltip,
	ShoppingTooltip1,
	ShoppingTooltip2,
	ShoppingTooltip3,
	ItemRefTooltip,
	WorldMapTooltip,
	WorldMapCompareTooltip1,
	WorldMapCompareTooltip2,
	WorldMapCompareTooltip3}

local c1,c2,c3,c4 = unpack(M["media"].color)
local s1,s2,s3,s4 = unpack(M["media"].shadow)

-- Hide PVP text
PVP_ENABLED = ""

-- Statusbar
GameTooltipStatusBar:SetStatusBarTexture(M["media"].blank)
GameTooltipStatusBar:ClearAllPoints()
GameTooltipStatusBar:SetPoint("TOPLEFT", GameTooltip, 4, -4)
GameTooltipStatusBar:SetPoint("BOTTOMRIGHT", GameTooltip, -4, 4)
GameTooltipStatusBar:SetFrameLevel(1)
GameTooltipStatusBar:SetAlpha(.12345)
GameTooltipStatusBar.NewSetStatusBarColor = GameTooltipStatusBar.SetStatusBarColor
GameTooltipStatusBar.SetStatusBarColor = M.null

if SecondFrameChat then
	local main_anchor = SecondFrameChat.right_holder
	-- Position default anchor
	local function defaultPosition(tt, parent)
		tt:ClearAllPoints()
		tt:SetOwner(parent, "ANCHOR_NONE")
		tt:SetPoint("BOTTOMRIGHT",main_anchor,"TOPRIGHT")
	end
	hooksecurefunc("GameTooltip_SetDefaultAnchor", defaultPosition)
end

local _colors = M.RaidColors
local _reaction

if oUF then
	_reaction = oUF.colors.reaction
else
	_reaction = {
	{.8,.3,.22},
	{.8,.3,.22},
	{.75,.27,0},
	{.9,.7,0},
	{0,.6,.1},
	{0,.6,.1},
	{0,.6,.1},
	{0,.6,.1}}
end

M.addenter(function()
	local UnitIsPlayer = UnitIsPlayer
	local UnitClass = UnitClass
	local UnitReaction = UnitReaction
	local UnitIsTapped = UnitIsTapped
	local UnitIsTappedByPlayer = UnitIsTappedByPlayer
	function GameTooltip_UnitColor(unit)
		local c
		if UnitIsPlayer(unit) then
			c = _colors[select(2, UnitClass(unit))]
			c[1],c[2],c[3] = c.r,c.g,c.b
		elseif UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) then
			c = {.5,.5,.5}
		else
			c = _reaction[UnitReaction(unit, "player")]
		end
		if not c then
			c = {.5,.5,.5}
		end
		return c[1], c[2], c[3]
	end
end)

local floor = floor

local form_health
do
	local UnitHealth = UnitHealth
	local UnitHealthMax = UnitHealthMax
	local flo = math.floor
	form_health = function(unit)
		local min = UnitHealth(unit)
		local max = UnitHealthMax(unit)
		if max == 0 then
			return "|cffffffffHP:|r 0/0 - 0 %",1,0,0
		end
		local ratio = flo((min/max)*100)
		local r,g
		if ratio >= 70 then
			r = 0; g = 1
		elseif ratio >= 30 then
			r = 1; g  = 1
		else 
			r = 1; g = 0
		end
		return "|cffffffffHP: |r"..min.."/"..max.." - "..ratio.." %",r,g,0
	end
end

-- Unit tooltip style
local OnTooltipSetUnit
do
	local UnitIsPVPFreeForAll = UnitIsPVPFreeForAll
	local GameTooltip_UnitColor = GameTooltip_UnitColor
	local UnitIsPVP = UnitIsPVP
	local GetCVar = GetCVar
	local LEVEL = LEVEL
	local UnitIsPlayer = UnitIsPlayer
	local UnitRace = UnitRace
	local UnitLevel = UnitLevel
	local GetQuestDifficultyColor = GetQuestDifficultyColor
	local UnitClassification = UnitClassification
	local UnitCreatureType = UnitCreatureType
	local UnitExists = UnitExists
	local GetGuildInfo = GetGuildInfo
	local show_hp = V.tooltip_show_hp	
	local get_iLVL = M.iLVL
	local classification_compr = {
		["rareelite"] = " R+",
		["rare"] = " R",
		["elite"] = "+"}
	OnTooltipSetUnit = function(self)
		-- Most of this code was inspired from 
		-- aTooltip (from alza) based on sTooltip (from Shantalya)

		local lines = self:NumLines()
		local name, unit = self:GetUnit()

		if not unit then return end

		-- Name text, with level and classification
		local name,realm		= GetUnitName(unit)
		local race				= UnitRace(unit)
		local level				= UnitLevel(unit)
		local levelColor		= GetQuestDifficultyColor(level)
		local classification	= UnitClassification(unit)
		local creatureType		= UnitCreatureType(unit)
		
		_G["GameTooltipTextLeft1"]:SetText(name..(realm ~= nil and " - "..realm or ""))
		
		if level == -1 then
			level = "??"
			levelColor = { r = 1.00, g = 0.00, b = 0.00 }
		end
		
		classification = classification_compr[classification] or ""
		
		if UnitIsPlayer(unit) then
			local n = 2
			if GetCVar("colorblindMode") == "1" then n = n + 1 end
			
			local x1,x2,x3 = GetGuildInfo(unit)
			if x1 then
				local r,g,b
				if UnitIsPVPFreeForAll(unit) then
					r,g,b = 1,1,0
				elseif UnitIsPVP(unit) then
					r,g,b = 0,1,0
				else
					r,g,b = 0,.5,1
				end
				_G["GameTooltipTextLeft2"]:SetFormattedText("|cff%02x%02x%02x%s|r ("..x2.." - "..x3..")",r*255,g*255,b*255,x1)
				n = n + 1;
			end
					
			_G["GameTooltipTextLeft"..n]:SetFormattedText("|cff%02x%02x%02x%s%s|r %s%s", levelColor.r*255, levelColor.g*255, levelColor.b*255, level, classification, race, get_iLVL(unit))
		else
			for i = 0, lines-2 do
				local line = _G["GameTooltipTextLeft"..(lines-i)]
				if not line or not line:GetText() then return end
				if (level and line:GetText():find("^"..LEVEL)) or (creatureType and line:GetText():find("^"..creatureType)) then
					line:SetFormattedText("|cff%02x%02x%02x%s%s|r %s", levelColor.r*255, levelColor.g*255, levelColor.b*255, level, classification, creatureType or "")
					break
				end
			end
		end
		
		local _cc = lines+1
		if UnitExists(unit.."target") and unit~="player" then
			local r, g, b = GameTooltip_UnitColor(unit.."target")
			self:AddLine(UnitName(unit.."target"), r, g, b)
			_cc = _cc+1
		end
		if show_hp then
			self:AddLine(form_health(unit))
			self.current_line_hp = _G["GameTooltipTextLeft".._cc]
			self.current_unit_hp = unit
		end
	end
end

-- Item Ref icon
local itemTooltipIcon = CreateFrame("Frame", "ItemRefTooltipIcon", _G["ItemRefTooltip"])
itemTooltipIcon:SetPoint("TOPRIGHT", _G["ItemRefTooltip"], "TOPLEFT", 2, 0)
itemTooltipIcon:SetHeight(42)
itemTooltipIcon:SetWidth(42)
M.setbackdrop(itemTooltipIcon)
M.style(itemTooltipIcon,true)

itemTooltipIcon.texture = itemTooltipIcon:CreateTexture("ItemRefTooltipIcon", "TOOLTIP")
itemTooltipIcon.texture:SetPoint("TOPLEFT",4,-4)
itemTooltipIcon.texture:SetPoint("BOTTOMRIGHT",-4,4)
itemTooltipIcon.texture:SetTexCoord(.1, .9, .1, .9)
itemTooltipIcon.texture:SetGradient("VERTICAL",.4,.4,.4,1,1,1)

M.restyle_close(ItemRefCloseButton)

local GetItemIcon = GetItemIcon
local AddItemIcon = function()
	local frame = _G["ItemRefTooltipIcon"]
	frame:Hide()
	local _, link = _G["ItemRefTooltip"]:GetItem()
	local icon = link and GetItemIcon(link)
	if not icon then return end
	_G["ItemRefTooltipIcon"].texture:SetTexture(icon)
	frame:Show()
end
hooksecurefunc("SetItemRef", AddItemIcon)

local y1,y2,y3 = 0,0,0
local r1,r2,r3 = 0,0,0
local sh1,sh2,sh3,sh4 = 0,0,0,0

local pp_recolor = function(self,r,g,b,if_,_status)
	if not(self.top) then return end
	self.top:SetTexture(r,g,b)
	self.bottom:SetTexture(r,g,b)
	self.left:SetTexture(r,g,b)
	self.right:SetTexture(r,g,b)
	r1,r2,r3 = r,g,b
	if if_ then
		self:_SetBackdropBorderColor(r,g,b,s4*.4)
	else
		self:_SetBackdropBorderColor(s1,s2,s3,s4)
	end
	if _status then
		GameTooltipStatusBar:NewSetStatusBarColor(r,g,b)
		y1,y2,y3 = r,g,b
	else
		GameTooltipStatusBar:NewSetStatusBarColor(.1,1,1)
		y1,y2,y3 = .1,1,1
	end
end

GameTooltipStatusBar:SetScript("OnValueChanged", function(self, value)
	self:NewSetStatusBarColor(y1,y2,y3)
	if self.current_unit_hp then
		local hp,r,g,b = form_health(self.current_unit_hp)
		self.current_line_hp:SetFormattedText("|cff%02x%02x%02x%s|r",r,g,b,hp)
	end
end)

local BorderColor
do
	local UnitReaction = UnitReaction
	local UnitClass = UnitClass
	local UnitIsPlayer = UnitIsPlayer
	local UnitReaction = UnitReaction
	local GetMouseFocus = GetMouseFocus
	local pp_recolor = pp_recolor
	local GetItemInfo = GetItemInfo
	local floor = floor
	BorderColor = function(self,_w,_h)
		self:SetSize(floor(_w+.5),floor(_h+.5))
		local _te = self.name:GetText()
		if self.skip_update == _te then return end
		self.skip_update = _te
		local GMF = GetMouseFocus()
		local unit = (select(2, self:GetUnit())) or (GMF and GMF:GetAttribute("unit"))
		local reaction = unit and UnitReaction("player", unit)
		local player = unit and UnitIsPlayer(unit)
		if player then
			local class = select(2, UnitClass(unit))
			local c = _colors[class]
			pp_recolor(self,c.r,c.g,c.b,true,true)
		elseif reaction then
			local c = _reaction[reaction]
			pp_recolor(self,c[1],c[2],c[3],true,true)
		else
			local _, link = self:GetItem()
			local quality = link and select(3, GetItemInfo(link))
			if quality and quality >= 2 then
				local r, g, b = GetItemQualityColor(quality)
				pp_recolor(self,r,g,b,true,false)
			else
				pp_recolor(self,0,0,0,false,false)
			end
		end
	end
end

M.addafter(function()
	for _, tt in pairs(tooltips) do
		M.setbackdrop(tt)
		M.style(tt)
		tt:SetBackdrop(M.bg_edge)
		tt.SetBackdrop = M.null
		tt._SetBackdropBorderColor = tt.SetBackdropBorderColor
		tt.SetBackdropBorderColor = M.null
		tt.name = _G[tt:GetName().."TextLeft1"]
		tt:SetScript("OnSizeChanged",BorderColor)
		local bg = tt:CreateTexture(nil,"BORDER")
		bg:SetPoint("TOPLEFT",4,-4)
		bg:SetPoint("BOTTOMRIGHT",-4,4)
		bg:SetTexture(M.media.blank)
		bg:SetVertexColor(c1,c2,c3,c4)
		tt.bg:SetDrawLayer("ARTWORK")
	end
	if V.tooltip_hide_in_combat then
		GameTooltip:HookScript("OnShow",function(self) 
			if InCombatLockdown() then
				self:Hide()
			end
		end)
		GameTooltip:RegisterEvent("PLAYER_REGEN_DISABLED")
		GameTooltip:SetScript("OnEvent",GameTooltip.Hide)
	end
	tooltips = nil
end)
GameTooltip:HookScript("OnTooltipSetUnit", OnTooltipSetUnit)