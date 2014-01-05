local ns,M,L,V = unpack(select(2,...))
local DB = V["trigers"]
DB.guild_repair = M.check_nil(DB.guild_repair,false)

local invate_table = {
	"inv",
	"инв",
	"byd",
	"пати",
	"party",
	"сиськи"} -- on demand

local names = L['tweaks']

local autoinvite 
do
	local lower = string.lower
	local pairs = pairs
	local GetNextChar = M.GetNextChar
	local DB = DB
	local invate_table = invate_table
	local InviteUnit = InviteUnit
	autoinvite = function(self,event,arg1,arg2,...)
		if DB.autoinv ~= true then return end
		local newstring = ""
		local count = 1
		for i = 1,3 do
			local chng
			chng,count = GetNextChar(arg1,count)
			newstring = newstring..chng
		end
		newstring = lower(newstring)
		for _,v in pairs(invate_table) do
			if newstring == v or arg1 == v then InviteUnit(arg2) return end
		end
	end
end

local inviteplx,invitelol = CreateFrame("Frame"),CreateFrame("Frame")
invitelol:RegisterEvent("CHAT_MSG_WHISPER")
invitelol:SetScript("OnEvent",autoinvite)
inviteplx:SetScript("OnEvent", M.d_event)

local function invmelol()
	StaticPopup_Hide("PARTY_INVITE")
	inviteplx:UnregisterEvent("PARTY_MEMBERS_CHANGED")
end

do
	local GetNumFriends = GetNumFriends
	local IsInGuild = IsInGuild
	local ShowFriends = ShowFriends
	local GetFriendInfo = GetFriendInfo
	local GetNumGuildMembers = GetNumGuildMembers
	local GetGuildRosterInfo = GetGuildRosterInfo
	local SendWho = SendWho
	local invmelol = invmelol
	inviteplx["PARTY_INVITE_REQUEST"] = function(self,event,leader,...)
		if DB.autoacceptinv == true then
		
			local InGroup = false
		
			if GetNumFriends() > 0 then ShowFriends() end
			if IsInGuild() then GuildRoster() end
		
		for friendIndex = 1, GetNumFriends() do
			local friendName = GetFriendInfo(friendIndex)
			if friendName == leader then
				AcceptGroup()
				M.allertrun(names.malinvacc..leader)
				inviteplx:RegisterEvent("PARTY_MEMBERS_CHANGED")
				inviteplx["PARTY_MEMBERS_CHANGED"] = invmelol
				InGroup = true
				break
			end
		end
	
		if not InGroup then
			for guildIndex = 1, GetNumGuildMembers(true) do
				local guildMemberName = GetGuildRosterInfo(guildIndex)
				if guildMemberName == leader then
				M.allertrun(names.malinvacc..leader)
					AcceptGroup()
					inviteplx:RegisterEvent("PARTY_MEMBERS_CHANGED")
					inviteplx["PARTY_MEMBERS_CHANGED"] = invmelol
					InGroup = true
					break
				end
			end
		end
		
		if not InGroup then
			SendWho(leader)
		end
		
		if DB.autodeclineinv == true and not InGroup then 
			DeclineGroup()
			HideUIPanel(StaticPopup1)
			M.allertrun(names.malinvde..arg1)	
		end
		
		elseif DB.autodeclineinv == true then
			DeclineGroup()
			HideUIPanel(StaticPopup1)
			M.allertrun(names.malinvde..arg1)
		end
	end
end; inviteplx:RegisterEvent("PARTY_INVITE_REQUEST")

local declineduels = CreateFrame("Frame")
declineduels:RegisterEvent("DUEL_REQUESTED")
declineduels:SetScript("OnEvent", function(self, event, name)
	if DB.declineduels ~= true then return end
		HideUIPanel(StaticPopup1)
		CancelDuel()
		M.allertrun(names.malduelde..name)
end)

local form_money = function(cost)
	local c,s,g
		c = " "..(cost%100).."|cffeda55fc|r."
		g = floor(cost/10000)
		s = floor((cost%10000)/100)
			if s~=0 or g~=0 then
				s = " "..s.."|cffc7c7cfs|r"
			else
				s = ""
			end
			if g~=0 then
				g = " "..g.."|cffffd700g|r"
			else
				g = ""
			end
	return g,s,c
end
-- 

local repair_nomoney, repair_yra;
do
	local RepairAllItems = RepairAllItems
	local form_money = form_money
	repair_nomeny = function(cost,text)
		local g,s,c = form_money(cost)
		print(text..":"..g..s..c)
		M.sl_run(text..".")
	end
	repair_yra = function(cost,text,mode)
		RepairAllItems(mode)
		local g,s,c = form_money(cost)
		print(text..":"..g..s..c)
		M.sl_run(text..".")
	end
end

local sell_junk_q
do
	local UseContainerItem = UseContainerItem
	local GetContainerItemLink = GetContainerItemLink
	local find = string.find
	local GetContainerNumSlots = GetContainerNumSlots
	local ITEM_QUALITY_COLORS = ITEM_QUALITY_COLORS
	local GetContainerItemInfo = GetContainerItemInfo
	local select = select
	sell_junk_q = function()
		for bagIndex = 0, 4 do
				if GetContainerNumSlots(bagIndex) > 0 then
					for slotIndex = 1, GetContainerNumSlots(bagIndex) do
						if select(2,GetContainerItemInfo(bagIndex, slotIndex)) then
							local quality = select(3, find(GetContainerItemLink(bagIndex, slotIndex), "(|c%x+)"))
							if quality == ITEM_QUALITY_COLORS[0].hex then
								UseContainerItem(bagIndex, slotIndex)
							end
						end
					end
				end
			end
	end
end

do
	local CanMerchantRepair = CanMerchantRepair
	local DB = DB
	local repair_nomoney, repair_yra = repair_nomoney, repair_yra
	local sell_junk_q = sell_junk_q
	local CanGuildBankRepair = CanGuildBankRepair
	local GetGuildBankWithdrawMoney = GetGuildBankWithdrawMoney
	local GetMoney = GetMoney
	local merc = CreateFrame("Frame")
	merc:SetScript("OnEvent",function()
		if DB.junk == true then sell_junk_q() end
		if DB.repair == true or DB.guild_repair == true then
			if not(CanMerchantRepair()) then return end
			local cost = GetRepairAllCost(); if cost == 0 then return end
			if DB.guild_repair == true then
				if CanGuildBankRepair() then
					local money = GetGuildBankWithdrawMoney() - cost
					if money >= 0 then
						return repair_yra(cost,names.repairtrue_g,true)
					else
						repair_nomeny(-money,names.repairfalse_g)
					end
				end
			end
			if DB.repair == true then
				local money = GetMoney() - cost
				if money >= 0 then
					return repair_yra(cost,names.repairtrue)
				else
					repair_nomeny(-money,names.repairfalse)
				end
			end
		end
	end)
	merc:RegisterEvent("MERCHANT_SHOW")
end

local settingsframe = CreateFrame("Frame",nil,ns["topright"])
M.tweaks_mvn(settingsframe,DB,L['tweaks_st'],38,2)
settingsframe.name = "TWEAKS"
settingsframe:Hide()
M.make_plav(settingsframe,.2)
settingsframe:SetPoint("RIGHT",-3,0)
settingsframe:SetSize(236,136)
ns["topright"].frames[1] = settingsframe
