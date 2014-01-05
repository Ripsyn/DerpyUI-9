local C,M,L,V = unpack(select(2,...))
local names = L['dur']

local dur = C.frame("Durability",100)

dur.tx:SetText("Durability")
		
local Slots = names.durtable

local Total,current,max = 0
local red,green
local s_r_function = function(a, b) return a[3] < b[3] end

local function OnEvent(self)
	
	for i = 1, 11 do
		if GetInventoryItemLink("player", Slots[i][1]) ~= nil then
			current, max = GetInventoryItemDurability(Slots[i][1])
			if current then 
				Slots[i][3] = current/max
				Total = Total + 1
			end
		end
	end
	
	table.sort(Slots, s_r_function)
	
	if Total > 0 then
		local dura = floor(Slots[1][3]*100)
			local lol,r,g = (dura/100)
			if lol > .7 then
				r = 0; g = 1
			elseif lol > .3 then
				r = 1; g = 1
			else 
				r = 1; g = 0
			end
		self:SetVal(dura)
		self:SetScript("OnEnter", function(self)	
			GameTooltip:SetOwner(self, "ANCHOR_NONE");
			GameTooltip:ClearAllPoints()
			GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -2)
			GameTooltip:ClearLines()
			GameTooltip:AddDoubleLine(names.durtool,floor(Slots[1][3]*100).." %",1,1,1,r,g,0)
			GameTooltip:AddDoubleLine(" ")		
			for i = 1, 11 do
				if Slots[i][3] ~= 1000 then
					green = Slots[i][3]*2
					red = 1 - green
					GameTooltip:AddDoubleLine(Slots[i][2], floor(Slots[i][3]*100).."%",1 ,1 , 1, red + 1, green, 0)
				end
			end
			GameTooltip:Show()
		end)
		Total = 0
	end
	
end

dur:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
dur:RegisterEvent("MERCHANT_SHOW")
dur:RegisterEvent("PLAYER_ENTERING_WORLD")
dur:SetScript("OnEvent", OnEvent)
dur:SetScript("OnMouseDown", function() ToggleCharacter("PaperDollFrame") end)
dur:SetScript("OnLeave", function() GameTooltip:Hide() end)