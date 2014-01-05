local C,M,L,V = unpack(select(2,...))
local frame = C.frame("Dps",nil,true)

frame.rt:SetText("Dps")
frame.lt:SetText("0")

--| Main Idea taked from tukui\\\\

local events = {
	SWING_DAMAGE = true,
	RANGE_DAMAGE = true,
	SPELL_DAMAGE = true,
	SPELL_PERIODIC_DAMAGE = true,
	DAMAGE_SHIELD = true,
	DAMAGE_SPLIT = true,
	SPELL_EXTRA_ATTACKS = true}

local player_id = UnitGUID("player")
local dmg_total, last_dmg_amount = 0, 0
local cmbt_time = 0
local floor = floor
local select = select
local pet_id = UnitGUID("pet")

frame:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
frame:RegisterEvent("PLAYER_LOGIN")

local function getDPS()
	local s
	if cmbt_time == 0 then
		s = 0
	else
		s = floor((dmg_total or 0) / (cmbt_time or 1))
	end
	return s
end

local counter = CreateFrame("Frame")
counter:Hide()

counter:SetScript("OnUpdate", function(self, elap)
	cmbt_time = cmbt_time + elap 
	frame.lt:SetText(getDPS())
end)

function frame:PLAYER_LOGIN()
	frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	frame:RegisterEvent("PLAYER_REGEN_ENABLED")
	frame:RegisterEvent("PLAYER_REGEN_DISABLED")
	frame:RegisterEvent("UNIT_PET")
	player_id = UnitGUID("player")
	frame:UnregisterEvent("PLAYER_LOGIN")
end

function frame:UNIT_PET(unit)
	if unit == "player" then
		pet_id = UnitGUID("pet")
	end
end

-- handler for the combat log. used http://www.wowwiki.com/API_COMBAT_LOG_EVENT for api
function frame:COMBAT_LOG_EVENT_UNFILTERED(...)		   
	-- filter for events we only care about. i.e heals
	if not events[select(2, ...)] then return end

	-- only use events from the player
	local id = select(4, ...)
	if id == player_id or id == pet_id then
		if select(2, ...) == "SWING_DAMAGE" then
			last_dmg_amount = select(12, ...)
		else
			last_dmg_amount = select(15, ...)
		end
			dmg_total = dmg_total + last_dmg_amount
	end    	
end

function frame:PLAYER_REGEN_ENABLED()
	counter:Hide()
end
	
function frame:PLAYER_REGEN_DISABLED()
	if not (frame:IsShown()) then return end
	counter:Show()
end

frame:SetScript("OnMouseDown", function (self, button, down)
	cmbt_time = 0
	dmg_total = 0
	last_dmg_amount = 0
	self.lt:SetText(getDPS())
end)