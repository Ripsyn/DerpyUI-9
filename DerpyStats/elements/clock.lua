local C,M,L,V = unpack(select(2,...))
local names = L['clocks']

local clocks = C.frame("Clocks",9000,true)

if not V[41] then V[41] = 0 end

local int = 0
local sus = 0
local time_sesion = 0
local step = 0

local pending = function(self,t)
	sus = sus - t
	if sus > 0 then return end
	sus = 30
	local pendingCalendarInvites = CalendarGetNumPendingInvites() or 0
	if pendingCalendarInvites ~= 0 then
		M.backcolor(self,.8,.8,0,.8)
	else
		M.backcolor(self,0,0,0)
	end
	self.rt:SetText(date("%a"))
end

local cur_mon = V[41]

local getbgtime = function(num)
	local _,_,_,_,wgtime = GetWorldPVPAreaInfo(num)
	return wgtime or 9000
end

local setval = function(self)
	if cur_mon ~= 0 then
		self:SetVal(getbgtime(cur_mon))
	end
end

local clocks_update = function(self,t)
	int = int - t
	if int > 0 then return end
		int = .5
	if step == 0 then
		time_sesion = time_sesion + 1
		self.lt:SetText(date("%H")..":"..date("%M"))
		step = 1
		pending(self,step)
		setval(self)
	else
		step = 0
		self.lt:SetText(date("%H").."|cff22eeee:|r"..date("%M"))
	end
end

clocks:SetScript("OnUpdate",clocks_update)

local form_time = function(target)
	local d = 		floor(target/(3600*24))
	local h = 		floor(target/3600 - d*24)
	local day = 	format("%01.f", d)
	local hour = 	format(d > 0 and "%02.f" or "%01.f", floor(target/3600 - d*24))
	local min = 	format(h > 0 and "%02.f" or "%01.f", floor(target/60 - ((h+d*24)*60)))
	local sec = 	format("%02.f", floor(target - (h+d*24)*3600 - min*60))
	return ((d>0 and day..":" or "")..(h>0 and hour..":" or "")..min..":"..sec)
end   

local time_off = 0
local h = 0

local printwg = function(tool,num)
	local _,_,_,_,wg = GetWorldPVPAreaInfo(num)
	local inInstance, instanceType = IsInInstance()
	if not (instanceType == "none") then
		wg = names.wgtoolna
	elseif wg == nil then
		wg = names.wgtoolinprogress
	else
		wg = form_time(wg)
	end
	if cur_mon == num then
		return tool,wg,0,.9,.9,1,1,1
	else
		return tool,wg,1,1,1,1,1,1
	end
end

local updatetool = function()
	GameTooltip:ClearLines()      
	GameTooltip:AddDoubleLine(printwg(names.lagspring..":",1))
	GameTooltip:AddDoubleLine(printwg(names.tolbar..":",2))
	GameTooltip:AddDoubleLine(names.session,form_time(time_sesion),1,1,1,1,1,1)
	GameTooltip:AddDoubleLine(names.total,form_time(time_sesion+time_off),1,1,1,1,1,1)
	GameTooltip:Show()
end

clocks.toolupd = CreateFrame("Frame",nil,clocks)
clocks.toolupd:Hide()

local showtool = function(self,t)
	h = h - t
	if h > 0 then return end
	h = 1
	updatetool()
end
clocks.toolupd:SetScript("OnUpdate",showtool)

clocks:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_NONE");
	GameTooltip:ClearAllPoints()
	GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -2)
	updatetool()
	self.toolupd:Show()
end)
	
clocks:SetScript("OnLeave", function(self)
	self.toolupd:Hide()
	GameTooltip:Hide()
end)

local menuFrame = CreateFrame("Frame", "Derpy_ClocksFrameMenu", UIParent, "UIDropDownMenuTemplate")
local menu = {
	{text = "DISPLAY MODE", isTitle = 1, notCheckable = 1},
	{text = L['hide'],func = function() cur_mon = 0; V[41] = 0; clocks:SetVal(9000); end},
	{text = names.lagspring,func = function() cur_mon = 1; V[41] = 1; end},
	{text = names.tolbar,func = function() cur_mon = 2; V[41] = 2; end},}

clocks:SetScript("OnMouseDown", function(self,button)
	if button == "LeftButton" then
		GameTimeFrame:Click()
	else
		menu[V[41]+2]['checked'] = 1
		EasyMenu(menu, menuFrame, "cursor", 0, 0, "MENU", 2)
		menu[V[41]+2]['checked'] = nil
	end
end)

clocks:RegisterEvent("TIME_PLAYED_MSG")
clocks:SetScript("OnEvent",function(self,event,...)
	time_off = ...;
	self:UnregisterAllEvents()
	self:SetScript("OnEvent",nil)
end)

M.addafter(function() RequestTimePlayed() end)
