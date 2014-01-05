local C,M,L,V = unpack(select(2,...)) --

local _combat = V.nameplates_combat
local _enhancethreat = V.nameplates_enhancethreat
local tank_ = V.nameplates_tank
local showhealth = V.nameplates_showhealth
local hpHeight = V.nameplates_height
local hpWidth = V.nameplates_width
local iconSize = V.nameplates_height + 5 + V.nameplates_edge
local cbHeight = V.nameplates_height - 1
local cbWidth = V.nameplates_width
local blankTex = M["media"].blank
local frames = {}
local SetCVar = SetCVar
local floor,unpack,tonumber,select = math.floor,unpack,tonumber,select
local hide_player_level = V.nameplates_hide_player_level
local UnitName = UnitName
local CreateFrame = CreateFrame

local NamePlates = CreateFrame("Frame", nil, UIParent)
NamePlates:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)

SetCVar("bloatthreat", 0)
SetCVar("bloattest", 0)
SetCVar("bloatnameplates", 0)

local function QueueObject(parent, object)
	parent.queue = parent.queue or {}
	parent.queue[object] = true
end

local HideObjects
do
	local N = M.null
	local pairs = pairs
	HideObjects = function(parent)
		for object in pairs(parent.queue) do
			if(object:GetObjectType() == 'Texture') then
				object:SetTexture(nil)
				object.SetTexture = N
			elseif (object:GetObjectType() == 'FontString') then
				object.ClearAllPoints = N
				object.SetFont = N
				object.SetPoint = N
				object:Hide()
				object.Show = N
				object.SetText = N
				object.SetShadowOffset = N
			else
				object:Hide()
				object.Show = N
			end
		end
	end
end

local mk_tex = function(self)
	if not self.tex then
		local bg = self:CreateTexture(nil,"BORDER")
		bg:SetAllPoints()
		bg:SetTexture(M['media'].blank)
		bg:SetGradientAlpha("VERTICAL",.2,.2,.2,.14,.4,.4,.4,.28)
		bg:SetBlendMode("ADD")
		self.tex = bg
	end
end

local THE_EDGE = V.nameplates_edge

--Create a fake backdrop frame using textures
local CreateVirtualFrame
do
	local x = THE_EDGE - 1
	local bg__ = {
		bgFile = M["media"].blank, 
		edgeFile = M["media"].glow, 
		tile = false , tileSize = 0, edgeSize = THE_EDGE,
		insets = {
			left=x, 
			right=x,
			top=x,
			bottom=x}}
	local x1,x2,x3,x4 = unpack(M["media"].shadow)
	local y1,y2,y3,y4 = unpack(M["media"].color)
	CreateVirtualFrame = function(parent, point)
		if point == nil then point = parent end
		if point.back then return end
		parent.back = CreateFrame("Frame",nil,parent)
		parent.back:SetFrameLevel(parent:GetFrameLevel())
		parent.back:SetFrameStrata(parent:GetFrameStrata())
		M.setbackdrop(parent.back)
		parent.back:SetBackdrop(bg__)
		parent.back:SetBackdropBorderColor(x1,x2,x3,x4)
		parent.back:SetBackdropColor(y1,y2,y3,y4)
		parent.back:SetPoint("TOPLEFT",point,-THE_EDGE,THE_EDGE)
		parent.back:SetPoint("BOTTOMRIGHT",point,THE_EDGE,-THE_EDGE)
		parent.back.SetPoint = M.null
	end
end

local function SetVirtualBorder(parent, r, g, b)
	parent.back:SetBackdropBorderColor(r, g, b, 1)
	parent.back:SetBackdropColor(r*.1, g*.1, b*.1)
end

--Color the castbar depending on if we can interrupt or not, 
--also resize it as nameplates somehow manage to resize some frames when they reappear after being hidden
local function UpdateCastbar(frame)
	if(frame.shield:IsShown()) then
		frame:SetStatusBarColor(1, 0, 0, 1)
	end
end 

--Determine whether or not the cast is Channelled or a Regular cast so we can grab the proper Cast Name
local UpdateCastText
do
	local UnitChannelInfo = UnitChannelInfo
	local UnitCastingInfo = UnitCastingInfo
	local select = select
	UpdateCastText = function(frame, curValue)
		local minValue, maxValue = frame:GetMinMaxValues()
		
		if UnitChannelInfo("target") then
			frame.time:SetFormattedText("%.1f ", curValue)
			frame.name:SetText(select(1, (UnitChannelInfo("target"))))
		end
		
		if UnitCastingInfo("target") then
			frame.time:SetFormattedText("%.1f ", maxValue - curValue)
			frame.name:SetText(select(1, (UnitCastingInfo("target"))))
		end
	end
end

--We need to reset everything when a nameplate it hidden, this is so theres no left over data when a nameplate gets reshown for a differant mob.
local function OnHide(frame)
	frame.hp:SetStatusBarColor(frame.hp.rcolor, frame.hp.gcolor, frame.hp.bcolor)
	frame.overlay:Hide()
	frame.cb:Hide()
	frame.hasClass = nil
	frame.isFriendly = nil
	frame.hp.rcolor = nil
	frame.hp.gcolor = nil
	frame.hp.bcolor = nil
	frame:SetScript("OnUpdate",nil)
end

--Color Nameplate
local Colorize
do
	local RAID_CLASS_COLORS = M.RaidColors
	local UpdateCastbar = UpdateCastbar
	local floor = floor
	local pairs = pairs
	Colorize = function(frame)
		local r,g,b = frame.hp:GetStatusBarColor()
		for class, color in pairs(RAID_CLASS_COLORS) do
			local r, g, b = floor(r*100+.5)/100, floor(g*100+.5)/100, floor(b*100+.5)/100
			if RAID_CLASS_COLORS[class].r == r and RAID_CLASS_COLORS[class].g == g and RAID_CLASS_COLORS[class].b == b then
				frame.hasClass = true
				frame.isFriendly = false
				return
			end
		end
		if g+b == 0 then -- hostile
			r,g,b = 1,0,0
			frame.isFriendly = false
		elseif r+b == 0 then -- friendly npc
			r,g,b = 0,1,0
			frame.isFriendly = true
		elseif r+g > 1.95 then -- neutral
			r,g,b =1,1,0
			frame.isFriendly = false
		elseif r+g == 0 then -- friendly player
			r,g,b =  0,1,1 
			frame.isFriendly = true
		else -- enemy player
			frame.isFriendly = false
		end
		frame.hasClass = false
		frame.hp:SetStatusBarColor(r,g,b)
		UpdateCastbar(frame.cb)
	end
end

--HealthBar OnShow, use this to set variables for the nameplate, also size the healthbar here because it likes to lose it's
--size settings when it gets reshown
local UpdateObjects
do
	local HideObjects = HideObjects
	local SetVirtualBorder = SetVirtualBorder
	local Colorize = Colorize
	local x1,x2,x3,x4 = unpack(M["media"].shadow)
	local _enhancethreat = _enhancethreat
	local tonumber = tonumber
	local hide_player_level = hide_player_level
	UpdateObjects = function(frame)
		local frame = frame:GetParent()
		
		local r, g, b = frame.hp:GetStatusBarColor()

		--Have to reposition this here so it doesnt resize after being hidden
		frame.hp:ClearAllPoints()
		frame.hp:SetSize(hpWidth, hpHeight)	
		frame.hp:SetPoint('TOP', frame, 'TOP', 0, -15)
		frame.hp:GetStatusBarTexture():SetHorizTile(true)
				
		--Colorize Plate
		Colorize(frame)
		frame.hp.rcolor, frame.hp.gcolor, frame.hp.bcolor = frame.hp:GetStatusBarColor()
		SetVirtualBorder(frame.hp, x1,x2,x3,x4)
		
		if _enhancethreat == true then
			frame.hp.name:SetTextColor(frame.hp.rcolor, frame.hp.gcolor, frame.hp.bcolor)
		end
		
		--Set the name text
		frame.hp.name:SetText(frame.hp.oldname:GetText())
		
		--Setup level text
		local level, elite, mylevel = tonumber(frame.hp.oldlevel:GetText()), frame.hp.elite:IsShown(), UnitLevel("player")
		frame.hp.level:ClearAllPoints()
		frame.hp.level:SetPoint("RIGHT", frame.hp, "LEFT",-1,.5)
		
		frame.hp.level:SetTextColor(frame.hp.oldlevel:GetTextColor())
		if frame.hp.boss:IsShown() then
			frame.hp.level:SetText("??")
			frame.hp.level:SetTextColor(0.8, 0.05, 0)
			frame.hp.level:Show()
		elseif not elite and level == mylevel and hide_player_level then
			frame.hp.level:Hide()
		else
			frame.hp.level:SetText(level..(elite and "+" or ""))
			frame.hp.level:Show()
		end
		
		frame.overlay:ClearAllPoints()
		frame.overlay:SetAllPoints(frame.hp)
		
		HideObjects(frame)
	end
end

--This is where we create most 'Static' objects for the nameplate, it gets fired when a nameplate is first seen.
local SkinObjects
do
	local frames = frames
	local THE_EDGE = THE_EDGE
	local TEXTURE = M["media"].blank
	local FONTSIZE = V.nameplates_font_size
	local FONTFLAG = "OUTLINE"
	local FONT = M["media"].font
	local FONT_LANG = M["media"].font_lang
	SkinObjects = function(frame)
		local hp, cb = frame:GetChildren()
		local threat, hpborder, overlay, oldname, oldlevel, bossicon, raidicon, elite = frame:GetRegions()
		local _, cbborder, cbshield, cbicon = cb:GetRegions()
		
		--Health Bar
		frame.healthOriginal = hp
		hp:SetStatusBarTexture(TEXTURE)
		CreateVirtualFrame(hp)
		hp.hpbg = mk_tex(hp)
		
		--Create Level
		hp.level = hp:CreateFontString(nil, "OVERLAY")
		hp.level:SetFont(FONT, FONTSIZE-1, FONTFLAG)
		hp.level:SetShadowColor(0, 0, 0, 1)
		hp.level:SetTextColor(1, 1, 1)
		hp.level:SetShadowOffset(1.25, -1.25)
		hp.oldlevel = oldlevel
		hp.boss = bossicon
		hp.elite = elite
		hp.oldlevel:Hide()
		hp.oldlevel.Show = M.null
		
		--Create Name Text
		hp.name = hp:CreateFontString(nil, 'OVERLAY')
		hp.name:SetPoint("BOTTOM", hp, "TOP", 0, 5)
		hp.name:SetFont(FONT_LANG, FONTSIZE, FONTFLAG)
		hp.name:SetShadowColor(0, 0, 0, 1)
		hp.name:SetTextColor(1,1, 1)
		hp.name:SetShadowOffset(1.25, -1.25)
		hp.oldname = oldname

		--Create Health Text
		if showhealth == true then
			hp.value = hp:CreateFontString(nil, "OVERLAY")	
			hp.value:SetFont(FONT, FONTSIZE, FONTFLAG)
			hp.value:SetShadowColor(0, 0, 0, 1)
			hp.value:SetPoint("LEFT", hp.name, "RIGHT")
			hp.value:SetTextColor(1,1,1)
			hp.value:SetShadowOffset(1.25, -1.25)
		end
		
		hp:HookScript('OnShow', UpdateObjects)
		frame.hp = hp
		
		--Cast Bar
		cb:SetStatusBarTexture(TEXTURE)
		CreateVirtualFrame(cb)
		cb.hpbg = mk_tex(cb)
		
			-- Only 1 time
		local x = -cbWidth/2
		local y = -THE_EDGE-cbHeight
		--Using six points to fix random size change
		cb:ClearAllPoints()
		cb:SetPoint("TOP",hp,"BOTTOM",0,-THE_EDGE)
		cb:SetPoint("TOPLEFT",hp,"BOTTOM",x,-THE_EDGE)
		cb:SetPoint("TOPRIGHT",hp,"BOTTOM",-x,-THE_EDGE)
		cb:SetPoint("BOTTOMLEFT",hp,"BOTTOM",x,y)
		cb:SetPoint("BOTTOMRIGHT",hp,"BOTTOM",-x,y)
		cb:SetPoint("BOTTOM",hp,"BOTTOM",0,THE_EDGE)
		--Don`t need anymore:
		cb.SetPoint = M.null
		cb.SetWidth = M.null
		cb.SetHeight = M.null
		cb.SetSize = M.null
		cb.ClearAllPoints = M.null
		
		--Create Cast Time Text
		cb.time = cb:CreateFontString(nil, "ARTWORK")
		cb.time:SetPoint("RIGHT", cb, "LEFT",1,-.5)
		cb.time:SetFont(FONT, FONTSIZE-1, FONTFLAG)
		cb.time:SetShadowColor(0, 0, 0, 1)
		cb.time:SetTextColor(1, 1, 1)
		cb.time:SetShadowOffset(1.25, -1.25)

		--Create Cast Name Text
		cb.name = cb:CreateFontString(nil, "ARTWORK")
		cb.name:SetPoint("TOP", cb, "BOTTOM", 0, 1)
		cb.name:SetFont(FONT_LANG, FONTSIZE, FONTFLAG)
		cb.name:SetTextColor(1, 1, 1)
		cb.name:SetShadowColor(0, 0, 0, 1)
		cb.name:SetShadowOffset(1.25, -1.25)
		
		--Setup CastBar Icon
		cbicon:ClearAllPoints()
		cbicon:SetPoint("TOPLEFT", hp, "TOPRIGHT", THE_EDGE+1, 0)		
		cbicon:SetSize(iconSize, iconSize)
		cbicon:SetTexCoord(.1,.9,.1,.9)
		cbicon:SetDrawLayer("OVERLAY")
		cbicon:SetGradient("VERTICAL",.5,.5,.5,1,1,1)
		cbicon:SetBlendMode("ADD")
		cb.icon = cbicon
		CreateVirtualFrame(cb, cb.icon)
		
		cb.shield = cbshield
		cbshield:ClearAllPoints()
		cbshield:SetPoint("TOP", cb, "BOTTOM")
		cb:HookScript('OnShow', UpdateCastbar)
		cb:HookScript('OnValueChanged', UpdateCastText)			
		frame.cb = cb
		
		--Highlight
		overlay:SetTexture(1,1,1,0.15)
		overlay:SetAllPoints(hp)	
		frame.overlay = overlay

		--Reposition and Resize RaidIcon
		raidicon:ClearAllPoints()
		raidicon:SetPoint("BOTTOM", hp, "TOP", 0, 12)
		raidicon:SetSize(iconSize*2, iconSize*2)
		raidicon:SetTexture(M["media"].ricon)
		frame.raidicon = raidicon
		
		--Hide Old Stuff
		QueueObject(frame, oldlevel)
		QueueObject(frame, threat)
		QueueObject(frame, hpborder)
		QueueObject(frame, cbshield)
		QueueObject(frame, cbborder)
		QueueObject(frame, oldname)
		QueueObject(frame, bossicon)
		QueueObject(frame, elite)
		
		UpdateObjects(hp)
		UpdateCastbar(cb)
		
		frame:HookScript('OnHide', OnHide)
		frames[frame] = true
	end
end

local UpdateThreat
do
	local goodR, goodG, goodB = 0,1,0
	local badR, badG, badB = 1,0,0
	local transitionR, transitionG, transitionB = 1,1,0
	local x1,x2,x3,x4 = unpack(M["media"].shadow)
	local InCombatLockdown = InCombatLockdown
	local _enhancethreat = _enhancethreat
	local SetVirtualBorder = SetVirtualBorder
	local tank_ = tank_
	UpdateThreat = function(frame)
		frame.hp:Show()
		if frame.hasClass == true then return end
		if _enhancethreat ~= true then
			frame.hp:SetStatusBarColor(frame.hp.rcolor, frame.hp.gcolor, frame.hp.bcolor)
			if(frame.region:IsShown()) then
				local _, val = frame.region:GetVertexColor()
				if(val > 0.7) then
					SetVirtualBorder(frame.hp, transitionR, transitionG, transitionB)
				else
					SetVirtualBorder(frame.hp, frame.hp.rcolor, frame.hp.gcolor, frame.hp.bcolor)
				end
			else
				SetVirtualBorder(frame.hp, x1,x2,x3,x4)
			end
			frame.hp:SetStatusBarColor(frame.hp.rcolor, frame.hp.gcolor, frame.hp.bcolor)
		else
			if not frame.region:IsShown() then
				if InCombatLockdown() and frame.isFriendly ~= true then
					--No Threat
					if tank_ == true then
						frame.hp:SetStatusBarColor(badR, badG, badB)
					else
						frame.hp:SetStatusBarColor(goodR, goodG, goodB)
					end		
				else
					--Set colors to their original, not in combat
					frame.hp:SetStatusBarColor(frame.hp.rcolor, frame.hp.gcolor, frame.hp.bcolor)
				end
			else
				--Ok we either have threat or we're losing/gaining it
				local r, g, b = frame.region:GetVertexColor()
				if g + b == 0 then
					--Have Threat
					if tank_ == true then
						frame.hp:SetStatusBarColor(goodR, goodG, goodB)
					else
						frame.hp:SetStatusBarColor(badR, badG, badB)
					end
				else
					--Losing/Gaining Threat
					frame.hp:SetStatusBarColor(transitionR, transitionG, transitionB)	
				end
			end
		end
	end
end

--Force the name text of a nameplate to be behind other nameplates unless it is our target
local AdjustNameLevel
do
	local UnitName = UnitName
	AdjustNameLevel = function(frame, ...)
		if UnitName("target") == frame.hp.name:GetText() and frame:GetAlpha() == 1 then
			frame.hp.name:SetDrawLayer("OVERLAY")
		else
			frame.hp.name:SetDrawLayer("BORDER")
		end
	end
end

--Health Text, also border coloring for certain plates depending on health
local ShowHealth
do
	local showhealth = showhealth
	local x1,x2,x3,x4 = unpack(M["media"].shadow)
	local _enhancethreat = _enhancethreat
	local SetVirtualBorder = SetVirtualBorder
	local floor = floor
	local cf = function(x) return floor(x+.5) end
	local teh_short = function(value)
		if value < 1000 then return value end
		if value < 100000 then return (cf(value/100)/10).."k" end
		return cf(value/1000).."k"
	end
	ShowHealth = function(frame, ...)
		-- show current health value
		local minHealth, maxHealth = frame.healthOriginal:GetMinMaxValues()
		local valueHealth = frame.healthOriginal:GetValue()
		local d =(valueHealth/maxHealth)*100
		
		if showhealth == true then
			frame.hp.value:SetText("- "..teh_short(valueHealth))
		end
				
		--Setup frame shadow to change depending on enemy players health, also setup targetted unit to have white shadow
		if frame.hasClass == true or frame.isFriendly == true then
			if(d <= 50 and d >= 20) then
				SetVirtualBorder(frame.hp, 1, 1, 0)
			elseif(d < 20) then
				SetVirtualBorder(frame.hp, 1, 0, 0)
			else
				SetVirtualBorder(frame.hp, x1,x2,x3,x4)
			end
		elseif (frame.hasClass ~= true and frame.isFriendly ~= true) and _enhancethreat == true then
			SetVirtualBorder(frame.hp,x1,x2,x3,x4)
		end
	end
end

--Run a function for all visible nameplates
local ForEachPlate = ForEachPlate
do
	local frames = frames
	ForEachPlate = function(functionToRun)
		for frame in pairs(frames) do
			if frame:IsShown() then
				functionToRun(frame)
			end
		end
	end
end

--Check if the frames default overlay texture matches blizzards nameplates default overlay texture
local HookFrames
do
	local OVERLAY = [=[Interface\TargetingFrame\UI-TargetingFrame-Flash]=]
	local select = select
	local SkinObjects = SkinObjects
	HookFrames = function(...)
		for index = 1, select('#', ...) do
		local frame = select(index, ...)
		local region = frame:GetRegions()
		
		if(not frames[frame] and (frame:GetName() and not frame.isSkinned and frame:GetName():find("NamePlate%d")) and region and region:GetObjectType() == 'Texture') then
			SkinObjects(frame)
			frame.region = region
			frame.isSkinned = true
		end
	end
	end
end

--Core right here, scan for any possible nameplate frames that are Children of the WorldFrame
do
	local WorldFrame = WorldFrame
	local ForEachPlate = ForEachPlate
	local ShowHealth = ShowHealth
	local UpdateThreat = UpdateThreat
	local AdjustNameLevel = AdjustNameLevel
	local CheckBlacklist = C.CheckBlacklist
	local numChildren = -1
	local HookFrames = HookFrames
	-- 0.1 sec
	M.set_updater(function()
		if(WorldFrame:GetNumChildren() ~= numChildren) then
			numChildren = WorldFrame:GetNumChildren()
			HookFrames(WorldFrame:GetChildren())
		end
			ForEachPlate(ShowHealth)
	end,"Derpy_Nameplates_Update",.1)
	-- 0.2 sec
	M.set_updater(function()
		ForEachPlate(UpdateThreat)
		ForEachPlate(AdjustNameLevel)
	end,"Derpy_Nameplates_Update",.2)
	-- 1 sec
	M.set_updater(function()
		ForEachPlate(CheckBlacklist)
	end,"Derpy_Nameplates_Update",1)
end

--Only show nameplates when in combat
if _combat == true then
	NamePlates:RegisterEvent("PLAYER_REGEN_ENABLED")
	NamePlates:RegisterEvent("PLAYER_REGEN_DISABLED")
	
	function NamePlates:PLAYER_REGEN_ENABLED()
		SetCVar("nameplateShowEnemies", 0)
	end

	function NamePlates:PLAYER_REGEN_DISABLED()
		SetCVar("nameplateShowEnemies", 1)
	end
end

NamePlates:RegisterEvent("PLAYER_ENTERING_WORLD")
function NamePlates:PLAYER_ENTERING_WORLD()
	if _combat == true then
		if InCombatLockdown() then
			SetCVar("nameplateShowEnemies", 1)
		else
			SetCVar("nameplateShowEnemies", 0)
		end
	end
	
	if _enhancethreat == true then
		SetCVar("threatWarning", 3)
	end
end