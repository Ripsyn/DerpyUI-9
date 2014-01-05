local select = select
local C,M,L,V = unpack(select(2,...))
local names = L['latency']
local int, Memory, Total, Mem, MEMORY_TEXT = 0, {}
local GetAddOnInfo = GetAddOnInfo
local GetAddOnMemoryUsage = GetAddOnMemoryUsage
local UpdateAddOnMemoryUsage = UpdateAddOnMemoryUsage
local collectgarbage = collectgarbage
local sort = table.sort
local IsAddOnLoaded = IsAddOnLoaded
local floor = math.floor
local format = string.format
local GetFramerate = GetFramerate
local GetNetStats = GetNetStats
local GetAvailableBandwidth = GetAvailableBandwidth
local GetDownloadedPercentage = GetDownloadedPercentage

local function formatMem(memory, color)		
	local mult = 10^1
	if memory > 999 then
		local mem = floor((memory/1024) * mult + 0.5) / mult
		if mem % 1 == 0 then
			return mem..".0"..names.memorymfrom
		else
			return mem..names.memorymfrom
		end
	else
		local mem = floor(memory * mult + 0.5) / mult
			if mem % 1 == 0 then
				return mem..".0"..names.memorykfrom
			else
				return mem..names.memorykfrom
			end
	end
end
	
local function RefreshMem(self)
	Memory = {}
	Total = 0
	collectgarbage("collect")
	UpdateAddOnMemoryUsage()
	for i = 1, GetNumAddOns() do
		Mem = GetAddOnMemoryUsage(i)
		Memory[i] = { select(2, GetAddOnInfo(i)), Mem, IsAddOnLoaded(i) }
		Total = Total + Mem
	end
	MEMORY_TEXT = formatMem(Total, true)
	sort(Memory, function(a, b)
		if a and b then
			return a[2] > b[2]
		end
	end)
end

local set_color_r_g = function(p)
	local r,g
	local a = 1 - p/300
		if a >= .7 then
			r = 0; g = 1
		elseif a >= .3 then
			r = 1; g  = 1
		else 
			r = 1; g = 0
		end
	return r,g,0
end

local formtooltip = function(self)
	GameTooltip:ClearLines()
	GameTooltip:AddDoubleLine(names._local..names.ping,select(3, GetNetStats())..names.pingval,1,1,1,set_color_r_g(self.pg_l))
	GameTooltip:AddDoubleLine(names.global..names.ping,select(4, GetNetStats())..names.pingval,1,1,1,set_color_r_g(self.pg))
	GameTooltip:AddDoubleLine (names.framerate,floor(GetFramerate()+.5)..names.framerateval,1,1,1,1,1,1)
	GameTooltip:AddDoubleLine (names.memorytotal,MEMORY_TEXT,1,1,1,1,1,1)
	local bandwidth = GetAvailableBandwidth()
	if bandwidth ~= 0 then
		GameTooltip:AddDoubleLine(names.band,(floor(bandwidth*100+.5)/100)..names.mps,1,1,1,1,1,1)
		GameTooltip:AddDoubleLine(names.done,floor((100*GetDownloadedPercentage())+.5).." %",1,1,1,1,1,1)
	end
	GameTooltip:AddLine(" ")
	GameTooltip:AddLine (names.memorytool,1,1,1)
	GameTooltip:AddLine(" ")
	for i = 1, #Memory do
		if Memory[i][3] then 
			local red = Memory[i][2]/Total*2
			local green = 1 - red
			GameTooltip:AddDoubleLine(Memory[i][1], formatMem(Memory[i][2], false), 1, 1, 1, red, green+1, 0)						
		end
	end
	GameTooltip:Show()
end

if not V[37] then V[37] = 300 end
if not V[36] then V[36] = 1 end

local ping = C.frame("Latency",V[37],true)

ping.h = 0
ping.k = 0
local updatem = function(self,t)
	self.h = self.h - t
	self.k = self.k - t
	if self.h > 0 then return end
	self.h = .5
	formtooltip(self)
	if self.k > 0 then return end
	self.k = 10
	RefreshMem(self)
end

ping.mx = math.max
ping._time = 5
ping.pg_l = -1
ping.pg = -1
ping.modif = 30

ping._update = M.null

ping.common_ping = function(self)
	self.pg = select(4, GetNetStats())
	self.pg_l = select(3, GetNetStats())
end

ping.bar_only = function(self)
	self:common_ping()
	self:SetVal(self.mx(self.pg,self.pg_l))
end

ping.bar_ping = function(self)
	self:bar_only()
	self.lt:SetText(self.mx(self.pg,self.pg_l))
end

ping.fps_only = function(self)
	self.lt:SetText(floor(GetFramerate()+.5))
end

ping.fps_bar = function(self)
	self:bar_only()
	self:fps_only()
end 

ping.ping_only = function(self)
	self:common_ping()
	self.lt:SetText(self.mx(self.pg,self.pg_l))
end

ping._update_function = function(self)
	self._time = self._time - self.modif
	if self._time > 0 then return end
	self:_update()
end

local help_mn = function(text,modif,value)
	ping.modif = 1
	ping.rt:SetText(text)
	ping:_update()
	V[36] = value
end

local switch_table = {
	{text = "DISPLAY MODE", isTitle = 1, notCheckable = 1},
	{text = "Lacency Bar Only", func = function() ping._update = ping.bar_only; help_mn("Latency",1,1); ping.lt:SetText() end},
	{text = "Lacency Bar + Text", func = function() ping._update = ping.bar_ping; help_mn("MS",1,2) end},
	{text = "Lacency Bar + FPS", func = function() ping._update = ping.fps_bar; help_mn("FPS",31,3) end},
	{text = "Latency Text Only", func = function() ping._update = ping.ping_only; ping:SetVal(ping.max); help_mn("MS",1,4) end},
	{text = "FPS Text Only", func = function() ping._update = ping.fps_only; ping:SetVal(ping.max); help_mn("FPS",31,5) end},
}

switch_table[V[36]+1].func()
ping:SetScript("OnShow",C.Insert)
ping:SetScript("OnHide",C.Remove)

ping:SetScript("OnEnter", function(self)
	RefreshMem(self)
	GameTooltip:SetOwner(self, "ANCHOR_NONE");
	GameTooltip:ClearAllPoints()
	GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -2)
	self.h = 0
	self.k = 0
	self:SetScript("OnUpdate",updatem)
end)

--generate max table:
local gen_max = function()
	local a = {}
	for i=1,20 do
		local x = i*100
		a[i+1] = {text = x,func = function() ping.max = x; V[37] = x; ping:_update() end}
	end
	a[V[37]/100+1]['checked'] = 1
	a[1] = {text = "MAX LATENCY", isTitle = 1, notCheckable = 1}
	return a
end
	
local menuFrame = CreateFrame("Frame", "PingFrameMenu", UIParent, "UIDropDownMenuTemplate")

ping:SetScript("OnMouseDown", function(self,bt)
	if bt == "RightButton" then
		EasyMenu(gen_max(), menuFrame, "cursor", 0, 0, "MENU", 3)
	else
		switch_table[V[36]+1]['checked'] = 1
		EasyMenu(switch_table, menuFrame, "cursor", 0, 0, "MENU", 3)
		switch_table[V[36]+1]['checked'] = nil
	end
end)
	
ping:SetScript("OnLeave", function(self)
	self:SetScript("OnUpdate",nil)
	GameTooltip:Hide()
end)