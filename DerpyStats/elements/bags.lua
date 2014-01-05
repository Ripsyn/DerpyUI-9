local C,M,L,V = unpack(select(2,...))
local names = L['bags']

local bag = C.frame("Bags",10)
bag.tx:SetText("Bags")

local free,total,used = 0, 0, 0
			
local function OnEvent(self,event)
	free,total,used = 0, 0, 0
	for i = 0, NUM_BAG_SLOTS do
		free, total = free + GetContainerNumFreeSlots(i), total + GetContainerNumSlots(i)
	end
	used = total - free
	self.max = total
	self:SetVal(total-used)
	if free == 0 then
		M.sl_run(names.nomore,1,.1,.1)
	end
end
	
local function formatMoney(money)
	local gold = floor(math.abs(money) / 10000)
	local silver = mod(floor(math.abs(money) / 100), 100)
	local copper = mod(floor(math.abs(money)), 100)
	if gold ~= 0 then
		return format("%s|cffffd700g|r %s|cffc7c7cfs|r %s|cffeda55fc|r", gold, silver, copper)
	elseif silver ~= 0 then
		return format("%s|cffc7c7cfs|r %s|cffeda55fc|r", silver, copper)
	else
		return format("%s|cffeda55fc|r", copper)
	end
end

bag:RegisterEvent("PLAYER_LOGIN")
bag:RegisterEvent("BAG_UPDATE")
bag:SetScript("OnEvent", OnEvent)
bag:SetScript("OnMouseDown", function() OpenAllBags() end)
bag:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_NONE");
	GameTooltip:ClearAllPoints()
	GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -2)
	GameTooltip:ClearLines()
	GameTooltip:AddDoubleLine(names.free,free.."/"..total,1,1,1,1,1,1)
	GameTooltip:AddDoubleLine(names.gold,formatMoney(GetMoney()),1,1,1,1,1,1)
	GameTooltip:Show()
end)
	
bag:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)