-- Taked from tukui
local C,M,L,V = unpack(select(2,...))

local chatbubblehook = CreateFrame("Frame", nil, UIParent)
local curentlevel = 2
local numkids = 0
local bubbles = {}
local tinsert = tinsert

local function skinbubble(frame)
	if frame.ubg then return end
	for i=1, frame:GetNumRegions() do
		local region = select(i, frame:GetRegions())
		if region:GetObjectType() == "Texture" then
			region:SetTexture(nil)
			region.SetTexture = nil
		elseif region:GetObjectType() == "FontString" then
			frame.text = region
		end
	end
	frame:SetBackdrop(nil)
	frame.SetBackdrop = M.null
	frame:SetFrameLevel(curentlevel)
	frame.SetFrameLevel = M.null
	local bg = M.frame(frame,0,frame:GetFrameStrata())
	bg:SetScale(M.scale)
	bg:SetBackdrop(M.bg_edge)
	bg:SetPoint("TOPLEFT",4,-4)
	bg:SetPoint("BOTTOMRIGHT",-4,4)
	frame.ubg = bg
	curentlevel = curentlevel + 3
	tinsert(bubbles, frame)
end

local function ischatbubble(frame)
	if frame:GetName() then return end
	if not frame:GetRegions() then return end
	return frame:GetRegions():GetTexture() == [[Interface\Tooltips\ChatBubble-Background]]
end

chatbubblehook:RegisterEvent("CHAT_MSG_PARTY")
chatbubblehook:RegisterEvent("CHAT_MSG_PARTY_LEADER")
chatbubblehook:RegisterEvent("CHAT_MSG_SAY")
chatbubblehook:RegisterEvent("CHAT_MSG_YELL")
chatbubblehook:RegisterEvent("CHAT_MSG_MONSTER_YELL")
chatbubblehook:RegisterEvent("CHAT_MSG_MONSTER_PARTY") -- что это?
chatbubblehook:RegisterEvent("CHAT_MSG_MONSTER_SAY")
chatbubblehook:RegisterEvent("CHAT_MSG_MONSTER_YELL")

M.addlast(function()
	local inserr = M.set_updater
	local WorldFrame = WorldFrame
	local skinbubble = skinbubble
	local select = select
	local updateallbubbles = function()
		local newnumkids = WorldFrame:GetNumChildren()
		if newnumkids ~= numkids then
			for i=numkids + 1, newnumkids do
				local frame = select(i, WorldFrame:GetChildren())
				if not frame.ubg then
					if ischatbubble(frame) then
						skinbubble(frame)
					end
				end
			end
			numkids = newnumkids
		end
		for i, frame in next, bubbles do
			local r, g, b = frame.text:GetTextColor()
			frame.ubg:backcolor(r,g,b,.8)
		end
		inserr("remove","Derpy_Bubble_Chat_Update",.1)
	end 
	
	chatbubblehook:SetScript("OnEvent",function() inserr(updateallbubbles,"Derpy_Bubble_Chat_Update",.1) end)
end)
