local C,M,L,V = unpack(select(2,...))

local C = select(2,...)
local REURL_COLOR = "1888FF"
local ReURL_Brackets = V.hyperlinks_show_brakets
local hyper_ = V.hyperlinks
local hi_ = V.chatplayer
local _G = _G
local gsub = gsub
local name = GetUnitName("player")

-- Hyperlink
-- SPACE FLOW 11111
M.addenter(function()
	local SetItemRef_orig = SetItemRef
	_G.SetItemRef = function(link, text, button, chatFrame)
		if (strsub(link, 1, 3) == "url") then
			local ChatFrameEditBox = ChatEdit_ChooseBoxForSend()
			local url = strsub(link, 5);
			if (not ChatFrameEditBox:IsShown()) then
				ChatEdit_ActivateChat(ChatFrameEditBox)
			end
			ChatFrameEditBox:Insert(url)
			ChatFrameEditBox:HighlightText()
		else
			SetItemRef_orig(link, text, button, chatFrame)
		end
	end
end)

local function ReURL_Link(url)
	if (ReURL_Brackets) then
		return " |cff"..REURL_COLOR.."|Hurl:"..url.."|h["..url.."]|h|r "
	else
		return " |cff"..REURL_COLOR.."|Hurl:"..url.."|h"..url.."|h|r "
	end
end

local find = string.find
local time = time
local time_called

local accpt_replace
do
	local name = name
	local gsub = gsub
	local name_replace = "|cff"..REURL_COLOR.."*"..name.."*|r"
	local PlaySoundFile = PlaySoundFile
	local file = M["media"].path.."cathedral.mp3"
	accpt_replace = function(text)
		PlaySoundFile(file,"MASTER")
		return gsub(text,name,name_replace)
	end
end

local hi_name
do
	local find = string.find
	local name = name
	local hi_ = hi_
	local accpt_replace = accpt_replace
	hi_name = function(text)							-- [ TOO STUPID . NEED REPALCE-OPTIMIZATION ] --
		if not(hi_) then return text end
		if find(text,"EMOTE") then return text end
		local x2 = find(text,name)
		if not x2 then return text end
		local _,x1 = find(text,"]|h")
		if not x1 then return accpt_replace(text) end
		x1 = find(text,"]|h",x1+1) or x1 -- AGAIN
		if x1 > x2 then 
			return text
		else
			return accpt_replace(text)
		end
	end
end

local ReURL_AddLinkSyntax 
do
	local gsub = gsub
	local strfind = strfind
	local type = type
	local ReURL_Link = ReURL_Link
	local strsub = strsub
	local hi_name = hi_name
	local message_proc = message_proc
	local form_t = M.clearhyper
	local _BetterDate = BetterDate
	local _G = _G
	local time_stamps = {
		["%I:%M "] = "%I:%M",
		["%I:%M %p "] = "%I:%M %p",
		["%I:%M:%S "] = "%I:%M:%S",
		["%I:%M:%S %p "] = "%I:%M:%S %p",
		["%H:%M "] = "%H:%M",
		["%H:%M:%S "] = "%H:%M:%S"}
	ReURL_AddLinkSyntax= function(chatstring)
		if (type(chatstring) == "string") then
			local extraspace;
			if (not strfind(chatstring, "^ ")) then
				extraspace = true;
				chatstring = " "..chatstring;
			end
			-- Short Channels
			chatstring = chatstring:gsub('|h%[(%d+)%. .-%]|h', '|h[%1]|h')
			if hyper_ then
				chatstring = gsub(chatstring," www%.([_A-Za-z0-9-]+)%.(%S+)%s?",
					ReURL_Link("www.%1.%2")):gsub(" (%a+)://(%S+)%s?",
					ReURL_Link("%1://%2")):gsub(" ([_A-Za-z0-9-%.]+)@([_A-Za-z0-9-]+)(%.+)([_A-Za-z0-9-%.]+)%s?", 
					ReURL_Link("%1@%2%3%4")):gsub(" (%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?):(%d%d?%d?%d?%d?)%s?",
					ReURL_Link("%1.%2.%3.%4:%5")):gsub(" (%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)%s?", 
					ReURL_Link("%1.%2.%3.%4"))
			end
			chatstring = hi_name(chatstring)
			if time_called and _G.CHAT_TIMESTAMP_FORMAT then
				local new_date = _BetterDate(time_stamps[CHAT_TIMESTAMP_FORMAT], time())
				local c = extraspace == true and "]" or "] "
				local d = extraspace == true and " " or ""
				chatstring = d.."|Hurl:["..new_date..c..form_t(chatstring).."|h[|cff"..REURL_COLOR..new_date.."|r]|h"..chatstring
				time_called = false
			end
			if (extraspace) then
				chatstring = strsub(chatstring, 2);
			end
		end
		return chatstring
	end
end

local add_mess = function(self, text, ...) self:addmessage(self.ReURL_AddLinkSyntax(text), ...) end

-- Icons
local GameTooltip = GameTooltip

local linktypes = {item = true, enchant = true, spell = true, quest = true, unit = true, talent = true, achievement = true, glyph = true}

local function OnHyperlinkEnter(frame, link, ...)
	local linktype = link:match("^([^:]+)")
	if linktype and linktypes[linktype] then
		if frame.lok then
			GameTooltip:SetOwner(frame, "ANCHOR_TOPRIGHT", 6, 24)
		else
			GameTooltip:SetOwner(frame, "ANCHOR_TOPLEFT", -6, 24)
		end
		GameTooltip:SetHyperlink(link)
		GameTooltip:Show()
	end

	if frame.OnHyperlinkEnter then return frame.OnHyperlinkEnter(frame, link, ...) end
end

local function OnHyperlinkLeave(frame, ...)
	GameTooltip:Hide()
	if frame.OnHyperlinkLeave then return frame.OnHyperlinkLeave(frame, ...) end
end

for i=1, NUM_CHAT_WINDOWS do
	if i ~= 2 then
		local frame = _G["ChatFrame"..i]
		frame.OnHyperlinkEnter = frame:GetScript("OnHyperlinkEnter")
		frame:SetScript("OnHyperlinkEnter", OnHyperlinkEnter)

		frame.OnHyperlinkLeave = frame:GetScript("OnHyperlinkLeave")
		frame:SetScript("OnHyperlinkLeave", OnHyperlinkLeave)
		
		frame.addmessage = frame.AddMessage
		frame.AddMessage = add_mess
		frame.ReURL_AddLinkSyntax = ReURL_AddLinkSyntax
	end
end

--body = BetterDate()..body;
M.addenter(function()
	BetterDate = function(...)
		time_called = true
		return ""
	end
end)