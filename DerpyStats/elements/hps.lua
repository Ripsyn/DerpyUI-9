local C,M,L,V = unpack(select(2,...))

local frame = C.frame("Hps",nil,true)
frame.rt:SetText("Hps")
frame.lt:SetText("0")
local floor = floor
local select = select

--| Main Idea taked from tukui\\\\

local events = {SPELL_HEAL = true, SPELL_PERIODIC_HEAL = true}
local player_id = UnitGUID("player")
local dmg_total = 0
local cmbt_time = 0

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
	player_id = UnitGUID("player")
	frame:UnregisterEvent("PLAYER_LOGIN")
end
	
-- handler for the combat log. used http://www.wowwiki.com/API_COMBAT_LOG_EVENT for api
local max = math.max
function frame:COMBAT_LOG_EVENT_UNFILTERED(...)		   
	-- filter for events we only care about. i.e heals
		-- filter for events we only care about. i.e heals
		if not events[select(2, ...)] then return end
		if event == "PLAYER_REGEN_DISABLED" then return end
		-- only use events from the player
		local id = select(4, ...)
		if id == player_id then
			local x = select(16, ...)
			local y = select(15, ...)
			-- add to the total the healed amount subtracting the overhealed amount
			dmg_total = dmg_total + max(0,y-x)
		end 
end

function frame:PLAYER_REGEN_ENABLED()
	counter:Hide()
	frame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end
	
function frame:PLAYER_REGEN_DISABLED()
	if not (frame:IsShown()) then return end
	frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	counter:Show()
end
     
frame:SetScript("OnMouseDown", function (self, button, down)
	cmbt_time = 0
	dmg_total = 0
	frame.lt:SetText(getDPS())
end)