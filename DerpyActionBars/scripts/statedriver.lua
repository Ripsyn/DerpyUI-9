--[[ 
	Bonus bar classes id

	DRUID: Caster: 0, Cat: 1, Tree of Life: 0, Bear: 3, Moonkin: 4
	WARRIOR: Battle Stance: 1, Defensive Stance: 2, Berserker Stance: 3 
	ROGUE: Normal: 0, Stealthed: 1
	PRIEST: Normal: 0, Shadowform: 1
	
	When Possessing a Target: 5
]]--

local Page = {
    ["DRUID"] = "[bonusbar:1,nostealth] 7; [bonusbar:1,stealth] %s; [bonusbar:2] 8; [bonusbar:3] 9; [bonusbar:4] 10;",
    ["WARRIOR"] = "[bonusbar:1] 7; [bonusbar:2] 8; [bonusbar:3] 9;",
    ["PRIEST"] = "[bonusbar:1] 7;",
    ["ROGUE"] = "[bonusbar:1] 7; [form:3] 8;",
    ["WARLOCK"] = "[form:2] 7;",
    ["DEFAULT"] = "[bar:2] 2; [bar:3] 3; [bar:4] 4; [bar:5] 5; [bar:6] 6; [bonusbar:5] 11;",
}

local C,M,L,V = unpack(select(2,...))
local _G = _G
local bar = _G.DerpyMainMenuBar

local check
do
	local layout = V.layout
	local chat_point = ({380,380,570,570,285,475,266,380})[layout]
	local bt_x_point = ({-361,-361,-551,-551,-266,-456,-247,-361})[layout]
	local bt_y_point = V.reverse and ({10,44,10,44,44,44,78,78})[layout] or 10
	C.ChatPoint = chat_point
	check = function(bt)
		bt:SetPoint("BOTTOM",UIParent,bt_x_point,bt_y_point)
	end
end

local GetBar = function()
    local condition = Page["DEFAULT"]
    local page = Page[M.class]
    if page then
      if M.class == "DRUID" then
        if IsSpellKnown(33891) then
          page = page:format(7)
        else
          page = page:format(8)
        end
      end
      condition = condition.." "..page
    end
    condition = condition.." 1"
    return condition
end

bar:RegisterEvent("PLAYER_LOGIN")
bar["PLAYER_LOGIN"] = function(self)
	local button
	for i = 1, NUM_ACTIONBAR_BUTTONS do
		button = _G["ActionButton"..i]
		self:SetFrameRef("ActionButton"..i, button)
	end	

	self:Execute([[
		buttons = table.new()
		for i = 1, 12 do
			table.insert(buttons, self:GetFrameRef("ActionButton"..i))
		end
	]])
		
	self:SetAttribute("_onstate-page", [[ 
		for i, button in ipairs(buttons) do
			button:SetAttribute("actionpage", tonumber(newstate))
		end
	]])
			
	RegisterStateDriver(self, "page", GetBar())
	self:UnregisterEvent("PLAYER_LOGIN")
	self["PLAYER_LOGIN"] = nil
end

bar:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
bar["ACTIVE_TALENT_GROUP_CHANGED"] = function(self)
	local button
	for i = 1, NUM_ACTIONBAR_BUTTONS do
		button = _G["ActionButton"..i]
		self:SetFrameRef("ActionButton"..i, button)
	end	

	self:Execute([[
		buttons = table.new()
		for i = 1, 12 do
			table.insert(buttons, self:GetFrameRef("ActionButton"..i))
		end
	]])
		
	self:SetAttribute("_onstate-page", [[ 
		for i, button in ipairs(buttons) do
			button:SetAttribute("actionpage", tonumber(newstate))
		end
	]])
			
	RegisterStateDriver(self, "page", GetBar())
	
	LoadAddOn("Blizzard_GlyphUI")
end

bar:RegisterEvent("PLAYER_ENTERING_WORLD")
bar["PLAYER_ENTERING_WORLD"] = function(self)
	local button
	for i = 1, 12 do
		button = _G["ActionButton"..i]
		button:SetSize(32,28)
		button:ClearAllPoints()
		if i == 1 then
			check(button)
		else
			button:SetPoint("LEFT",_G["ActionButton"..i-1],"RIGHT",6,0)
		end
		button.flyT = true
		button:SetParent(self)
	end
end

local st = ({"KNOWN_CURRENCY_TYPES_UPDATE",
			"CURRENCY_DISPLAY_UPDATE",
			"BAG_UPDATE",})
	
for i=1,#st do
	local x = st[i]
	bar:RegisterEvent(x)
	bar[x] = MainMenuBar_OnEvent
end; st = nil;


bar:SetScript("OnEvent", function(self, event, ...)
	self[event](self,event,...)
end)
