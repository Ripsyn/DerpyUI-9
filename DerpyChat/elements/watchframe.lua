local C,M,L,V = unpack(select(2,...))
local _G = _G
local WatchFrameCollapseExpandButton = WatchFrameCollapseExpandButton

local world_state = true

local alt_holder
local use_a = V["watch_frame_alt"]

if use_a then
	alt_holder = CreateFrame("Frame",nil,UIParent)
	alt_holder:SetSize(V["watch_frame_w"],V["watch_frame_h"])
	alt_holder:SetPoint("CENTER",UIParent,V["watch_frame_w"]*2,0)
	alt_holder:SetFrameStrata("LOW")
	alt_holder:SetFrameLevel(20)
	alt_holder.realname = "WATCHFRAME"
	M.tex_move(alt_holder,"WATCHFRAME",alt_holder.Hide)
	M.make_movable(alt_holder)
	alt_holder:Hide()
end

M.addenter(function()
	local ex = WatchFrameCollapseExpandButton
	M.untex(ex)
		
	local mask = M.frame(ex,ex:GetFrameLevel(),ex:GetFrameStrata())
	mask:SetPoint("TOPLEFT",ex,-6,1)
	mask:SetPoint("BOTTOMRIGHT",ex,6,1)
	mask:backcolor(1,.7,.1,.4)
	mask:SetBackdropColor(1,.7,.1)

	ex:GetNormalTexture().SetTexCoord = function(self,_,_,_,t4)	
		if t4 ~= 1 then
			mask:backcolor(0,0,0)
			mask:SetBackdropColor(0,0,0)
			world_state = false
		else
			mask:backcolor(1,.7,.1,.4)
			mask:SetBackdropColor(1,.7,.1)
			world_state = true
		end
	end
end)

	_G.WatchFrame:SetClampedToScreen(false)
	_G.WatchFrame:ClearAllPoints()
	_G.WatchFrame._ClearAllPoints = _G.WatchFrame.ClearAllPoints
	_G.WatchFrame.ClearAllPoints = M.null
	
local maskframe___ = CreateFrame("Frame",nil,UIParent)
	maskframe___:SetSize(40,1)
	maskframe___:SetPoint("TOPRIGHT",UIParent,-134,-210)

	_G.WatchFrame._SetPoint = _G.WatchFrame.SetPoint
	_G.WatchFrame.SetPoint = M.null
	_G.WatchFrame.mask_ = maskframe___
	
_G.WatchFrame.enable_ = function(self)
	WatchFrameCollapseExpandButton:SetAlpha(1)
	WatchFrameCollapseExpandButton:EnableMouse(true)
	self:SetParent(UIParent)
	if use_a then
		self:_ClearAllPoints()
		self:SetAllPoints(alt_holder)
	else
		self:_ClearAllPoints()
		self:_SetPoint("TOPRIGHT",self.mask_,"BOTTOMRIGHT")
		self:_SetPoint("BOTTOMRIGHT",UIParent,-134,150)
	end
end

local VehicleSeatIndicator = VehicleSeatIndicator
	VehicleSeatIndicator:ClearAllPoints()
	VehicleSeatIndicator:SetPoint("TOPRIGHT",maskframe___,"TOPRIGHT",-24,2)
	VehicleSeatIndicator.SetPoint = M.null
	VehicleSeatIndicator.ClearAllPoints = M.null
	VehicleSeatIndicator:HookScript("OnShow",function(self)
		maskframe___:SetHeight(floor(self:GetWidth()))
	end)
	VehicleSeatIndicator:HookScript("OnHide",function(self) 
		maskframe___:SetHeight(1)
	end)

local questlog = CreateFrame("ScrollFrame", "DerpyQuestScroll", UIParent, "UIPanelScrollFrameTemplate")
questlog:SetFrameLevel(ChatFrame1:GetFrameLevel()+1)
questlog:SetFrameStrata(ChatFrame1:GetFrameStrata())
M.unscroll(_G.DerpyQuestScrollScrollBar)

local chattwo = C.SecondFrameChat
questlog:SetPoint("TOPLEFT",chattwo,6,-7)
questlog:SetPoint("BOTTOMRIGHT",chattwo,-30,7)

local questchil = CreateFrame("Frame","DerpyQuestList",questlog)
questchil:SetSize(284,1680)
questchil:SetPoint("TOPLEFT")
questlog:SetScrollChild(questchil)

questlog.update = function(self)
	questchil:SetWidth(self:GetWidth())
end

questlog:Hide()
questlog.state = false

_G.WatchFrame.disable_ = function(self)
	WatchFrameCollapseExpandButton:SetAlpha(0)
	WatchFrameCollapseExpandButton:EnableMouse(false)
	if world_state == false then
		WatchFrameCollapseExpandButton:Click()
	end
	_G.WatchFrame:SetParent(questchil)
	_G.WatchFrame:_ClearAllPoints()
	_G.WatchFrame:_SetPoint("TOPLEFT",questchil,40,0)
	_G.WatchFrame:_SetPoint("BOTTOMRIGHT",questchil,0,0)
end

local WATCHFRAME_LINKBUTTONS = WATCHFRAME_LINKBUTTONS
local WATCHFRAME_QUESTLINES = WATCHFRAME_QUESTLINES
local WATCHFRAME_TIMERLINES = WATCHFRAME_TIMERLINES
local WATCHFRAME_ACHIEVEMENTLINES = WATCHFRAME_ACHIEVEMENTLINES
local size_offset = _G.DerpyMediaVars.font_offset + 9

-- Quest log icons
local update_icons = function(self)
	if questlog.state ~= false then
		if self._step == nil then
			questchil:SetHeight(max(questchil:GetHeight(),6000)+random(1000))
			self._step = 1
			return
		elseif self._step == 1 then
			local link = #WATCHFRAME_LINKBUTTONS
			local quest = #WATCHFRAME_QUESTLINES
			local times = #WATCHFRAME_TIMERLINES
			local achi = #WATCHFRAME_ACHIEVEMENTLINES
			self._step = 2
			return questchil:SetHeight(max((size_offset+1)*quest+(size_offset+1)*achi+(size_offset+1)*times+(size_offset+5)*link+30,32))
		elseif self._step == 2 then
			self._step = nil
		end
	end
	for i=1,#WATCHFRAME_LINKBUTTONS do
		local a = _G["WatchFrameItem"..i]
		if not a then return end
		if not a.bg_ then
				a:SetSize(32,floor(32*(.875)+.5))
				_G["WatchFrameItem"..i.."IconTexture"]:SetTexCoord(3/32,1-3/32,5/32,1-5/32)
				_G["WatchFrameItem"..i.."IconTexture"]:SetGradient("VERTICAL",.345,.345,.345,1,1,1)
				a:GetNormalTexture():SetTexture("")
				local _t = a:GetPushedTexture()
				_t:SetTexture(M.media.blank)
				_t:SetVertexColor(.7,.7,.7,.4)
				local _t = a:GetHighlightTexture()
				_t:SetTexture(M.media.blank)
				_t:SetVertexColor(.6,.6,.6,.2)
			local bg = M.frame(a,nil,nil,true)
				bg:SetBackdrop(M.bg_edge)
				bg:backcolor(0,0,0)
				bg:points()
				bg:SetFrameLevel(a:GetFrameLevel()+2)
				bg:SetFrameStrata(a:GetFrameStrata())
			a.bg_ = bg
		end
	end
end
M.addenter(function()
	-- FPS DROP :( no hooks
	local _WatchFrame_Update = WatchFrame_Update
	local update_icons = update_icons
	_G.WatchFrame_Update = function(self,...)
		_WatchFrame_Update(self,...)
		if not self then return end
		update_icons(self)
	end
end)

M.addlast(function()
	local init_force_update = function()
		if questlog.state == false then return end
		questchil:SetHeight(max(questchil:GetHeight(),6000)+random(1000))
		_G.WatchFrame._step = 1
	end
	hooksecurefunc("AddQuestWatch",init_force_update)
	hooksecurefunc("RemoveQuestWatch",init_force_update)
	hooksecurefunc("AddTrackedAchievement",init_force_update)
	hooksecurefunc("RemoveTrackedAchievement",init_force_update)
end)

C.QuestLog = questlog
_G.WatchFrame:enable_()

questlog.Switch = function(self,mode)
	if mode ~= true then
		if self.state ~= true then return end
		self.state = false
		self:Hide()
		_G.WatchFrame:enable_()
	else
		if self.state == true then return end
		self.state = true
		self:Show()
		self:update()
		_G.WatchFrame:disable_()
	end
end
