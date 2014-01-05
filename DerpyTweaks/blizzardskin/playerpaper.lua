local C,M,L,V = unpack(select(2,...))

M.addenter(function()

	local closebg = M.frame(CharacterFrame,0,CharacterFrame:GetFrameStrata())
	closebg:SetSize(44,32)
	closebg:SetPoint("TOPRIGHT",-6,-30)
	closebg:SetBackdropColor(.4,0,0,1)
	CharacterFrameCloseButton.bg = closebg
	CharacterFrameCloseButton:SetAllPoints(closebg)
	CharacterFrameCloseButton:SetAlpha(0)
	CharacterFrameCloseButton.SetAlpha = M.null
	M.enterleave(CharacterFrameCloseButton,.4,0,0)
	
	local RAID_CLASS_COLORS = M.RaidColors
	local _G = _G
	local slots = {
	"Head", "Neck", "Shoulder", "Shirt", "Chest", "Waist", "Legs", "Feet", "Wrist",
	"Hands", "Finger0", "Finger1", "Trinket0", "Trinket1", "Back", "MainHand",
	"SecondaryHand", "Ranged", "Tabard",}
	local mod_tex = function(self,mode)
		if mode then
			self:GetHighlightTexture():SetTexture(1,1,1,.1)
		else
			tx = self:CreateTexture(nil,"HIGHLIGHT")
			tx:SetAllPoints()
			tx:SetTexture(1,1,1,.1)
		end
		self:GetPushedTexture():SetTexture(0,0,0,.4)
	end
	local set_vertex = function(self,r,g,b)
		if r == self._r and g == self.g and b == self._b then return end
		self._r = r
		self._g = g
		self._b = b
		self:SetGradient("VERTICAL",r*.5,g*.5,b*.5,r,g,b)
	end
	local GetInventoryItemID = GetInventoryItemID
	local GetItemQualityColor = GetItemQualityColor
	local seticon = function(self,icon)
		if icon == self._icon then return end
		self._icon = icon
		self:_SetTexture(icon)
		local itemLink = GetInventoryItemID('player',self.slotID)
		if itemLink then
			local _, _, itemQuality = GetItemInfo(itemLink)
			if itemQuality and itemQuality > 1 then
				local r, g, b = GetItemQualityColor(itemQuality)
				self.bg:backcolor(r,g,b,.88)
			else
				self.bg:backcolor(0,0,0)
			end
		else
			self.bg:backcolor(0,0,0)
		end
	end
	for i=1,#slots do
		local icon = _G["Character"..slots[i].."SlotIconTexture"]
		local slot = _G["Character"..slots[i].."Slot"]
		M.untex(slot)
		mod_tex(slot)
		slot:SetFrameLevel(4)
		slot:SetSize(41,33)
		local bg = M.frame(slot,3,"MEDIUM",true)
		icon.SetVertexColor = set_vertex
		icon:SetTexCoord(4/45,1-4/45,8/45,1-8/45)
		icon:ClearAllPoints()
		icon:SetPoint("TOPLEFT")
		icon:SetPoint("BOTTOMRIGHT")
		icon._SetTexture = icon.SetTexture
		icon.SetTexture = seticon
		icon.slotID = i % 20
		icon.bg = bg
		bg:points(icon)
	end
	_G.CharacterHeadSlot:ClearAllPoints()
	_G.CharacterHeadSlot:SetPoint("TOPLEFT",0,-66)
	_G.CharacterHandsSlot:ClearAllPoints()
	_G.CharacterHandsSlot:SetPoint("TOPLEFT",294,-66)
	slots = {"CharacterHeadSlot",
			"CharacterNeckSlot",
			"CharacterShoulderSlot",
			"CharacterBackSlot",
			"CharacterChestSlot",
			"CharacterShirtSlot",
			"CharacterTabardSlot",
			"CharacterWristSlot",}
	for i=2,#slots do
		_G[slots[i]]:ClearAllPoints()	
		_G[slots[i]]:SetPoint("TOP",_G[slots[i-1]],"BOTTOM",0,-8)
	end
	slots = {"CharacterHandsSlot",
			"CharacterWaistSlot",
			"CharacterLegsSlot",
			"CharacterFeetSlot",
			"CharacterFinger0Slot",
			"CharacterFinger1Slot",
			"CharacterTrinket0Slot",
			"CharacterTrinket1Slot",}
	for i=2,#slots do
		_G[slots[i]]:ClearAllPoints()	
		_G[slots[i]]:SetPoint("TOP",_G[slots[i-1]],"BOTTOM",0,-8)
	end
	slots = {"CharacterMainHandSlot",
			"CharacterSecondaryHandSlot",
			"CharacterRangedSlot",}
	for i=1,#slots do
		local slot = _G[slots[i]]
		slot:SetSize(47,37)
		slot:ClearAllPoints()
		if slots[i] ~= "CharacterMainHandSlot" then
			slot:SetPoint("LEFT",_G[slots[i-1]],"RIGHT",11,0)
		else
			slot:SetPoint("BOTTOMLEFT",86,14)
		end
	end
	local charframe = {
		"CharacterFrame",
		"CharacterModelFrame",
		"CharacterFrameInset", 
		"CharacterStatsPane",
		"CharacterFrameInsetRight",
		"PaperDollSidebarTabs",
		"PaperDollEquipmentManagerPane",
		"PaperDollFrame",
	}
	local function SkinItemFlyouts()
		--M.untex(PaperDollFrameItemFlyoutButtons)
		for i=1, PDFITEMFLYOUT_MAXITEMS do
			local button = _G["PaperDollFrameItemFlyoutButtons"..i]
			local icon = _G["PaperDollFrameItemFlyoutButtons"..i.."IconTexture"]
			if button then
				mod_tex(button,true)				
				button:GetNormalTexture():SetTexture(nil)
				icon:ClearAllPoints()
				icon:SetAllPoints()	
				button:SetSize(29,33)
				button:SetFrameLevel(button:GetFrameLevel() + 2)
				if not button.backdrop then
					local bg = M.frame(button,button:GetFrameLevel()-1,"MEDIUM") 
					bg:points()
					button.backdrop = bg
					icon:SetTexCoord(5/32,1-5/32,3/32,1-3/32)
					icon.SetVertexColor = set_vertex
					icon:SetVertexColor(1,1,1)
				end
				if i==1 then
					button.backdrop:backcolor(1,1,.2,.4)
				else
					button:ClearAllPoints()
					button:SetPoint("LEFT",	_G["PaperDollFrameItemFlyoutButtons"..i-1],"RIGHT",9,0)		
				end
			end
		end	
	end
	
	M.kill(_G.CharacterModelFrameControlFrame)
	
	--Swap item flyout frame (shown when holding alt over a slot)
	--PaperDollFrameItemFlyout:HookScript("OnShow", SkinItemFlyouts)
	--hooksecurefunc("PaperDollItemSlotButton_UpdateFlyout", SkinItemFlyouts)

	local scrollbars = {
		"PaperDollTitlesPaneScrollBar",
		"PaperDollEquipmentManagerPaneScrollBar",
		"CharacterStatsPaneScrollBar",
		"GearManagerDialogPopupScrollFrameScrollBar",
		"ReputationListScrollFrameScrollBar",
	}
	
	for _, scrollbar in pairs(scrollbars) do
		M.unscroll(_G[scrollbar])
	end
	
	for _, object in pairs(charframe) do
		M.untex(_G[object])
	end
	
	CharacterStatsPaneScrollBar:SetAllPoints(PaperDollTitlesPaneScrollBar)
	CharacterStatsPaneScrollBarScrollUpButton:SetAllPoints(PaperDollTitlesPaneScrollBarScrollUpButton)
	CharacterStatsPaneScrollBarScrollDownButton:SetAllPoints(PaperDollTitlesPaneScrollBarScrollDownButton)
	
	local back = M.frame(CharacterFrame,1,CharacterFrame:GetFrameStrata())
	back:SetPoint("TOPLEFT",-14,-43)
	back:SetPoint("BOTTOMRIGHT",11,-8)
	PaperDollFrame:EnableMouse(false)
	back.bg:SetDrawLayer("OVERLAY")
	
	
	local t = M.cirle(back)
	t:SetVertexColor(RAID_CLASS_COLORS[M.class].r,RAID_CLASS_COLORS[M.class].g,RAID_CLASS_COLORS[M.class].b,1)
	t:SetPoint("CENTER",CharacterModelFrame)
	t:Hide()
	
	local bl1 = back:CreateTexture(nil,"ARTWORK")
	bl1:SetWidth(62)
	bl1:SetTexture(unpack(M.media.color))
	bl1:SetPoint("TOPLEFT",4,-4)
	bl1:SetPoint("BOTTOMLEFT",4,4)
	
	local bl2 = back:CreateTexture(nil,"ARTWORK")
	bl2:SetTexture(unpack(M.media.color))
	bl2:SetPoint("TOPLEFT",297,-4)
	bl2:SetPoint("BOTTOMLEFT",297,4)
	bl2:SetPoint("TOPRIGHT",-4,-4)
	bl2:SetPoint("BOTTOMRIGHT",-4,4)
	
	local bl3 = back:CreateTexture(nil,"ARTWORK")
	bl3:SetHeight(70)
	bl3:SetTexture(unpack(M.media.color))
	bl3:SetPoint("BOTTOMLEFT",4,4)
	bl3:SetPoint("BOTTOMRIGHT",-4,4)
	
	local bl4 = back:CreateTexture(nil,"ARTWORK")
	bl4:SetHeight(40)
	bl4:SetTexture(unpack(M.media.color))
	bl4:SetPoint("TOPLEFT",4,-4)
	bl4:SetPoint("TOPRIGHT",-4,-4)
	
	local bgchar = M.frame(CharacterModelFrame,2,CharacterFrame:GetFrameStrata(),true)
	bgchar:points()
	bgchar:SetBackdrop(M.bg_edge)
	bgchar:SetBackdropBorderColor(unpack(M.media.shadow))
	
	local topbgchar =  M.frame(CharacterModelFrame,2,CharacterFrame:GetFrameStrata())
	topbgchar:SetBackdropBorderColor(0,0,0,0)
	topbgchar:SetPoint("TOPLEFT",bgchar)
	topbgchar:SetPoint("TOPRIGHT",bgchar)
	topbgchar:SetHeight(35)
	
	local bottombgchar =  M.frame(CharacterModelFrame,2,CharacterFrame:GetFrameStrata())
	bottombgchar:SetBackdropBorderColor(0,0,0,0)
	bottombgchar:SetPoint("BOTTOMLEFT",bgchar)
	bottombgchar:SetPoint("BOTTOMRIGHT",bgchar)
	bottombgchar:SetHeight(35)
	
	local left = back:CreateTexture(nil,"OVERLAY")
	left:SetPoint("TOPLEFT",bgchar,4,-4)
	left:SetPoint("BOTTOMLEFT",bgchar,4,4)
	left:SetPoint("RIGHT",bgchar,"CENTER")
	left:SetTexture(M.media.blank)
	left:SetGradientAlpha("HORIZONTAL",0,0,0,.8,0,0,0,0)
	left:Hide()
	
	local right = back:CreateTexture(nil,"OVERLAY")
	right:SetPoint("TOPRIGHT",bgchar,-4,-4)
	right:SetPoint("BOTTOMRIGHT",bgchar,-4,4)
	right:SetPoint("LEFT",bgchar,"CENTER")
	right:SetTexture(M.media.blank)
	right:SetGradientAlpha("HORIZONTAL",0,0,0,0,0,0,0,.8)
	right:Hide()
	
	local myname = M.setfont_lang(topbgchar,19,nil,"ARTWORK")
	myname:SetText(GetUnitName("player"))
	myname:SetPoint("LEFT",9,.4)
	myname:SetTextColor(RAID_CLASS_COLORS[M.class].r,RAID_CLASS_COLORS[M.class].g,RAID_CLASS_COLORS[M.class].b,1)
	
	local lvl = M.setfont(topbgchar,19,nil,"ARTWORK","RIGHT")
	lvl:SetPoint("RIGHT",-9,.4)
	lvl:SetTextColor(1,1,.1,1)
	lvl:SetText(UnitLevel("player"))
	
	if UnitLevel("player") ~= MAX_PLAYER_LEVEL then
		topbgchar._lvl = lvl
		topbgchar:RegisterEvent('PLAYER_LEVEL_UP')
		topbgchar:SetScript("OnEvent",function(self,level)
			self._lvl:SetText(level)
		end)
	end
	
	CharacterModelFrame.___t = t
	CharacterModelFrame._right = right
	CharacterModelFrame._left = left

	local PaperDollTitlesPane = PaperDollTitlesPane
	PaperDollTitlesPane:HookScript("OnShow", function(self)
		for x, object in pairs(PaperDollTitlesPane.buttons) do
			object.BgTop:SetTexture(nil)
			object.BgBottom:SetTexture(nil)
			object.BgMiddle:SetTexture(nil)
			object.Check:SetTexture(nil)
			object:GetHighlightTexture():SetTexture(.2,.7,1,.4)
			local x = select(6,object:GetRegions())
			x:SetTexture(1,1,.2,.5)
		end
	end)
	
	local sl = {
		"PaperDollEquipmentManagerPane",
		"PaperDollTitlesPane",
		"CharacterStatsPane",}
		
	for i=1,#sl do
		local x = _G[sl[i]]
		x:ClearAllPoints()
		if sl[i] ~= "CharacterStatsPane" then
			x:SetPoint("TOPRIGHT",back,-34,-24)
			x:SetPoint("BOTTOMRIGHT",back,-34,14)
		else
			x:SetPoint("TOPRIGHT",back,-34,-23)
			x:SetPoint("BOTTOMRIGHT",back,-34,15)
		end
		x:SetWidth(173)
	end
	
	local CharacterFrameExpandButton = CharacterFrameExpandButton
	local expand_button_template = M.frame(CharacterModelFrame,2,"MEDIUM",true)
	expand_button_template:SetSize(49,29)
	local x = expand_button_template:CreateTexture(nil,"BORDER")
	x:SetSize(64,32)
	x:SetPoint("TOPLEFT",4,-4)
	x:SetGradient("VERTICAL",0,0,0,.9,.9,.9)
	expand_button_template:SetPoint("TOP",_G.CharacterTrinket1Slot,"BOTTOM",0,-7)
	M.untex(CharacterFrameExpandButton)
	CharacterFrameExpandButton:SetAllPoints(expand_button_template)
	CharacterFrameExpandButton:SetFrameLevel(0)
	CharacterFrameExpandButton:SetAlpha(0)
	CharacterFrameExpandButton.back = back
	CharacterFrameExpandButton.SetAlpha = M.null
	CharacterFrameExpandButton.xtexture = x
	local check = function(self)
		if floor(self.back:GetWidth()) == 362 then
			-- LOW PROF
			self.xtexture:SetTexture(M.media.path.."arrow_one.tga")
		else
			-- HIGH PROF
			self.xtexture:SetTexture(M.media.path.."arrow_two.tga")
		end	
	end
	CharacterFrameExpandButton._T = .2
	CharacterFrameExpandButton:SetScript("OnUpdate",function(self,t)
		self._T = self._T - t
		if self._T >= 0 then return end
		self._T = nil
		self:SetScript("OnUpdate",nil)
		check(self)	
	end)
	CharacterFrameExpandButton:HookScript("OnClick",check)
	CharacterFrameExpandButton.bg = expand_button_template
	M.enterleave(CharacterFrameExpandButton,1,1,.2)
	
	-- DurabilityFrame
	local DurabilityFrame = DurabilityFrame
	DurabilityFrame_SetAlerts = M.null -- bb
	
	local bg = CreateFrame("Frame",nil,_G.CharacterModelFrame)
	bg:SetPoint("TOPLEFT")
	bg:SetPoint("TOPRIGHT")
	bg:SetHeight(80)
	bg:SetFrameStrata(_G.CharacterFrame:GetFrameStrata())
	bg:SetFrameLevel(3)
	bg:SetBackdrop({bgFile=M.media.blank})
	
	local dur_holder = CreateFrame("Frame",nil,bg)
	dur_holder:SetSize(10,10)
	dur_holder:SetPoint("CENTER",bg)
	DurabilityFrame:SetParent(dur_holder)
	DurabilityFrame:ClearAllPoints()
	DurabilityFrame:SetPoint("CENTER",dur_holder,0,0)
	DurabilityFrame.SetPoint = M.null
	
	local on_update = M.simple_move
	
	local last_update = function(self,t)
		self.last = self.last - t
		if self.last > 0 then return end
		self:SetScript("OnUpdate",nil)
		UIFrameFadeOut(bg,.24,1,0)
	end
	
	dur_holder.finish_function = function(self)
		self.last = 1
		self:SetScript("OnUpdate",last_update)
	end
	
	local Slots = L['dur'].durtable
	local nam = {
		[1] = "Head", 
		[3] = "Shoulders",
		[5] = "Chest",
		[6] = "Waist", 
		[7] = "Legs", 
		[8] = "Feet",
		[9] = "Wrists",
		[10] = "Hands"}
		
	local GetInventoryItemLink = GetInventoryItemLink
	local GetInventoryItemDurability = GetInventoryItemDurability
	
	local update_armore = function()
		local Total = 0
		local sum = 0
		
		for i = 2, 9 do
			if GetInventoryItemLink("player", Slots[i][1]) ~= nil then
				local current, max = GetInventoryItemDurability(Slots[i][1])
				local r,g,b = 1,1,1
				if current then
					local ration = current/max
					sum = sum + ration
					Total = Total + 1
					if ration > .7 then
						r = 1; g = 1; b = 1;
					elseif ration > .3 then
						r = 1; g = .82; b = .18;
					else 
						r = .93; g = .07; b = .07;
					end
					local tex = nam[Slots[i][1]]
					if tex then
						_G["Durability"..tex]:SetVertexColor(r,g,b,.8)
					end
				end
			end
		end
		
		local lol,r,g = (sum/Total)
			if lol > .7 then
				r = 0; g = 1
			elseif lol > .3 then
				r = 1; g = 1
			else 
				r = 1; g = 0
			end
		return r,g,floor((sum/Total)*100+.5)
	end
	
	dur_holder.mod = -1
	dur_holder.limit = -50
	dur_holder.speed = -80
	
	dur_holder.anim_go = function(self)
		UIFrameFadeIn(bg,0,1,1)
		UIFrameFadeIn(self,.3,0,1)
		self:SetScript("OnUpdate",nil)
		self:SetPoint("CENTER",bg)
		self.pos = 0
		self:SetScript("OnUpdate",on_update)
	end
	
	dur_holder.point_1 = "CENTER"
	dur_holder.point_2 = "CENTER"
	dur_holder.pos = 0
	dur_holder.hor = true
	dur_holder.parent = bg
	
	local text_holder = CreateFrame("Frame",nil,bg)
	text_holder:SetSize(10,10)
	text_holder:SetPoint("CENTER",bg)
	text_holder:SetFrameLevel(4)
	text_holder:SetFrameStrata(_G.CharacterFrame:GetFrameStrata())
	
	text_holder.point_1 = "CENTER"
	text_holder.point_2 = "CENTER"
	text_holder.pos = 0
	text_holder.hor = true
	text_holder.parent = bg
	
	text_holder.mod = 1
	text_holder.limit = 50
	text_holder.speed = 80
	
	text_holder.anim_go = function(self)
		self:SetScript("OnUpdate",nil)
		self:SetPoint("CENTER",bg)
		self.pos = 0
		self:SetScript("OnUpdate",on_update)
	end
	
	bg:SetBackdropColor(0,0,0,.9)
	DurabilityFrame:SetFrameLevel(5)
	DurabilityFrame:SetFrameStrata(_G.CharacterFrame:GetFrameStrata())
	DurabilityFrame:EnableMouse(false)
	
	local text_dur = M.setcdfont(text_holder,100)
	text_dur:SetPoint("CENTER",-4,0)
	
	local text_updater_f = CreateFrame("Frame",nil,text_holder)
	
	text_updater_f.tr = text_dur 
	
	for _,i in pairs(nam) do
		_G["Durability"..i]:Show()
	end
	DurabilityFrame:Show()
	DurabilityFrame:UnregisterAllEvents()
	
	local perc_weapon = {}
	
	for i=1,3 do
		local x = bg:CreateTexture(nil,"BORDER")
		local unk = _G[slots[i]]
		x:SetPoint("BOTTOMLEFT",unk,"TOPLEFT",-1,0)
		x:SetPoint("BOTTOMRIGHT",unk,"TOPRIGHT",1,0)
		x:SetHeight(34)
		x:SetTexture(M.media.blank)
		x:SetGradientAlpha("VERTICAL",0,0,0,1,0,0,0,0)
		perc_weapon[i] = M.setcdfont(text_holder,23)
		perc_weapon[i]:SetPoint("BOTTOM",unk,"TOP",0,6.5)
	end
	
	text_updater_f.perc_weapon = perc_weapon
	
	local get_weapon = function(s)
		s = s+15
		if GetInventoryItemLink("player", s) ~= nil then
			local current, max = GetInventoryItemDurability(s)
			local r,g = 1,1
			if current then
				local ration = current/max
				if ration > .7 then
					r = 0; g = 1;
				elseif ration > .3 then
					r = 1; g = 1;
				else 
					r = 1; g = 0;
				end
				return floor(ration*100+.5),r,g
			else
				return 0,0,0
			end
		end
		return 0,0,0		
	end
	
	local time_to = .90
	text_updater_f.t = 0
	
	local text_update = function(self,t)
		self.t = self.t + t
		if self.t >= time_to then self.t = 0
			if self.limit < 100 then
				self.tr:SetText(" "..self.limit.." %")
			else
				self.tr:SetText(self.limit.." %")
			end
			for i=1,3 do
				local o = self.perc_weapon[i]
				o:SetText(floor(o.limit).." %")
			end
			return self:SetScript("OnUpdate",nil)
		else
			self.tr:SetText(" "..floor(self.limit*(self.t/time_to)).." %")
			for i=1,3 do
				local o = self.perc_weapon[i]
				o:SetText(floor(o.limit*(self.t/time_to)).." %")
			end		
		end
	end
	
	local bt_text = bg:CreateTexture(nil,"BORDER")
	bt_text:SetPoint("TOPLEFT",bg,"BOTTOMLEFT")
	bt_text:SetPoint("TOPRIGHT",bg,"BOTTOMRIGHT")
	bt_text:SetHeight(20)
	bt_text:SetTexture(M.media.blank)
	bt_text:SetGradientAlpha("VERTICAL",0,0,0,0,0,0,0,.9)
	
	text_updater_f.run = function(self)
		local r,g,n = update_armore()
		self:SetScript("OnUpdate",nil)
		
		self.cur = 0
		self.limit = n
		
		for i=1,3 do
			local x,r,g = get_weapon(i)
			self.perc_weapon[i]:SetText(x)
			self.perc_weapon[i].limit = x
			self.perc_weapon[i].cur = 0
			self.perc_weapon[i]:SetTextColor(r,g,0)
		end		
		
		self.tr:SetTextColor(r,g,0)
		self:SetScript("OnUpdate",text_update)
		UIFrameFadeIn(text_holder,.3,0,1)
	end
	
	CharacterModelFrame:HookScript("OnHide", function(self) 
		self.___t:stop()
		self.___t:Hide()
		self._left:Hide()		
		self._right:Hide()
	end)
	CharacterModelFrame:HookScript("OnShow", function(self)
		self.___t:play()
		self.___t:Show() 
		self._left:Show()		
		self._right:Show()
		dur_holder:anim_go()
		text_holder:anim_go()
		text_updater_f:run()
	end)
	
	--Equipement Manager
	local _t = function(self) self.bg:backcolor(1,1,1,.8) end
	local __t = function(self) self.bg:backcolor(0,0,0) end
	local _temp_gen = function(self)
		M.untex(self,true)
		if self.bg then return end
		local x = M.frame(self,self:GetFrameLevel()-1,"MEDIUM")
		x:SetPoint("CENTER",self)
		self.bg = x
		self:HookScript("OnEnter",_t)
		self:HookScript("OnLeave",__t)
		return x
	end
	_temp_gen(PaperDollEquipmentManagerPaneEquipSet):SetSize(87,30)
	_temp_gen(PaperDollEquipmentManagerPaneSaveSet):SetSize(87,30)
	PaperDollEquipmentManagerPaneEquipSet:SetPoint("TOPLEFT", PaperDollEquipmentManagerPane, "TOPLEFT", 2, 1)
	PaperDollEquipmentManagerPaneEquipSet:SetFrameLevel(10)
	PaperDollEquipmentManagerPaneSaveSet:SetPoint("LEFT", PaperDollEquipmentManagerPaneEquipSet, "RIGHT", -1, 0)
	PaperDollEquipmentManagerPaneSaveSet:SetFrameLevel(10)
	PaperDollEquipmentManagerPaneEquipSet.ButtonBackground:SetTexture(nil)
	PaperDollEquipmentManagerPane:HookScript("OnShow", function(self)
		for x, object in pairs(PaperDollEquipmentManagerPane.buttons) do
			object.BgTop:SetTexture(nil)
			object.BgBottom:SetTexture(nil)
			object.BgMiddle:SetTexture(nil)
			object.Check:SetTexture(nil)
			object.HighlightBar:SetTexture(.2,.7,1,.4)
			object.SelectedBar:SetTexture(1,1,.2,.5)
			if not object.backdrop then
				local x = M.frame(object,2,"MEDIUM",true)
				x:points(object.icon)
				object.backdrop = x
				object.icon:SetTexCoord(5/32,1-5/32,3/32,1-3/32)
				object.icon.SetVertexColor = set_vertex
				object.icon:SetVertexColor(1,1,1)
				object.icon.SetPoint = M.null
				object.icon.SetSize = M.null
			end
			object.icon:SetParent(object.backdrop)
			object.icon:SetPoint("LEFT", object, "LEFT", 4, 0)
			object.icon:SetSize(32,36)
		end
		if not GearManagerDialogPopup.bg then
			M.untex(GearManagerDialogPopup,true)
			local x = M.frame(GearManagerDialogPopup,GearManagerDialogPopup:GetFrameLevel()-1,"MEDIUM")
			x:points()
			GearManagerDialogPopup.bg = x
			M.un_custom_regions(GearManagerDialogPopupEditBox,6,8)
			_temp_gen(GearManagerDialogPopupOkay):SetSize(76,24)
			_temp_gen(GearManagerDialogPopupCancel):SetSize(76,24)
			M.untex(_G.GearManagerDialogPopupScrollFrame)
		end
		GearManagerDialogPopup:SetPoint("TOPLEFT", PaperDollFrame, "TOPRIGHT", -2, -64)		
		for i=1, NUM_GEARSET_ICONS_SHOWN do
			local button = _G["GearManagerDialogPopupButton"..i]
			local icon = button.icon
			if button then	
				_G["GearManagerDialogPopupButton"..i.."Icon"]:SetTexture(nil)
				icon:ClearAllPoints()
				icon:SetAllPoints()	
				button:SetFrameLevel(button:GetFrameLevel() + 2)
				if not button.backdrop then
					local select = select	
					M.un_custom_regions(button,2,2)
					local x = select(5,button:GetRegions())
					x:SetTexture(1,1,.2,.3)
					local x = select(4,button:GetRegions())
					x:SetTexture(1,1,1,.1)
					icon:SetTexCoord(.1,.9,.1,.9)
					icon.SetVertexColor = set_vertex
					icon:SetVertexColor(1,1,1)
					local bg = M.frame(button,button:GetFrameLevel()-1,"MEDIUM",true)
					bg:points()
					button.backdrop = bg
				end
			end
		end
	end)
	
	--Handle Tabs at bottom of character frame
	local skintab = function(self)
		M.untex(self,true)
		local bg = M.frame(self,0,"MEDIUM")
		bg:SetPoint("TOPLEFT",8,20)
		bg:SetPoint("BOTTOMRIGHT",-8,5.2)
		local text = select(7,self:GetRegions())
		text:SetFont(M.media.font_lang,13)
		text:SetShadowOffset(1,-1)
		text.SetFont = M.null
		text:ClearAllPoints()
		text:SetPoint("BOTTOM",bg,0,7)
		text.SetPoint = M.null
	end
	for i=1, 4 do
		skintab(_G["CharacterFrameTab"..i])
	end
	
	local tabsbg = {}
	
	local _colors = {
		{0,.5,0},
		{0,.5,.5},
		{.5,.5,0},
	}
	
	for i=1,3 do
		local closebg1 = M.frame(PaperDollSidebarTab1,0,CharacterFrame:GetFrameStrata())
		closebg1:SetSize(44,32)
		closebg1:SetBackdropColor(unpack(_colors[i]))
		tabsbg[i] = closebg1
		if i == 1 then
			closebg1:SetPoint("RIGHT",closebg,"LEFT",-88,0)
		else
			closebg1:SetPoint("LEFT",tabsbg[i-1],"RIGHT",0,0)
		end
	end
	
	--Buttons used to toggle between equipment manager, titles, and character stats
	local function FixSidebarTabCoords()
		for i=1, #PAPERDOLL_SIDEBARS do
			local tab = _G["PaperDollSidebarTab"..i]
			if tab then
				tab.Highlight:SetTexture(nil)
				tab.Hider:SetTexture(nil)
				tab.Show = M.null
				M.kill(tab.TabBg)
				if i == 1 then
					for i=1, tab:GetNumRegions() do
						local region = select(i, tab:GetRegions())
						region:Hide()
						region.Show = M.null
					end
					tab:ClearAllPoints()
					tab:UnregisterAllEvents()
				else
					tab.Icon:Hide()
				end
				tab:ClearAllPoints()
				tab:SetAllPoints(tabsbg[i])
				if not tab.bg then
					tab.bg = tabsbg[i]
					local x1,x2,x3 = unpack(_colors[i])
					M.enterleave(tab,x1,x2,x3)
				end
			end
		end
	end
	hooksecurefunc("PaperDollFrame_UpdateSidebarTabs", FixSidebarTabCoords)
	--PaperDollSidebarTab1
	
	--Stat panels, atm it looks like 7 is the max
	for i=1, 7 do
		M.untex(_G["CharacterStatsPaneCategory"..i],true)
	end
	
	local what_color = function(self,texture)
		if texture == "Interface\\Buttons\\UI-MinusButton-Up" then
			self._mod:SetTexture(0,.7,1,.666)
		else
			self._mod:SetTexture(1,.7,0,.666)
		end
	end
	
	--Reputation
	local function UpdateFactionSkins()
		local ReputationListScrollFrame = ReputationListScrollFrame
		local ReputationFrame = ReputationFrame
		M.untex(ReputationListScrollFrame)
		M.untex(ReputationFrame)
		ReputationListScrollFrame:ClearAllPoints()
		ReputationListScrollFrame:SetPoint("TOP",0,-60)
		ReputationListScrollFrame:SetPoint("BOTTOM",0,8)
		ReputationListScrollFrame:SetPoint("RIGHT",-24,0)
		ReputationListScrollFrame:SetPoint("LEFT",0,0)
		ReputationFrame:ClearAllPoints()
		ReputationFrame:SetPoint("TOP",0,0)
		ReputationFrame:SetPoint("BOTTOM",0,0)
		ReputationFrame:SetPoint("RIGHT",0,0)
		ReputationFrame:SetPoint("LEFT",-8,0)
		for i=1, GetNumFactions() do
			local statusbar = _G["ReputationBar"..i.."ReputationBar"]
			
			if statusbar then
				
				if not statusbar.backdrop then
					statusbar.backdrop = M.frame(statusbar,statusbar:GetFrameLevel()-1,"MEDIUM")
					statusbar.backdrop:points()
					statusbar:SetSize(floor(statusbar:GetWidth()+.5+10),14)
					statusbar:SetStatusBarTexture(M["media"].barv)
					M.kill(_G["ReputationBar"..i.."LeftLine"])
					M.kill(_G["ReputationBar"..i.."BottomLine"])
					_G["ReputationBar"..i.."Background"]:SetTexture(nil)
					_G["ReputationBar"..i.."ReputationBarHighlight1"]:SetTexture(nil)
					_G["ReputationBar"..i.."ReputationBarHighlight2"]:SetTexture(nil)	
					_G["ReputationBar"..i.."ReputationBarAtWarHighlight1"]:SetTexture(nil)
					_G["ReputationBar"..i.."ReputationBarAtWarHighlight2"]:SetTexture(nil)
					_G["ReputationBar"..i.."ReputationBarLeftTexture"]:SetTexture(nil)
					_G["ReputationBar"..i.."ReputationBarRightTexture"]:SetTexture(nil)
				end
			
			end
			local colapse = _G["ReputationBar"..i.."ExpandOrCollapseButton"]
			if colapse then
				if not colapse._mod then
					local a = colapse:GetNormalTexture()
					colapse.SetNormalTexture = what_color
					colapse._mod = a
					colapse:SetNormalTexture(a:GetTexture())
					a:SetSize(18,10)
					a:ClearAllPoints()
					a:SetPoint("CENTER",2,1)
					a = colapse:GetHighlightTexture()
					a:SetTexture(1,.7,1,.666)
					a.SetTexture = M.null
					a:SetSize(18,10)
					a:ClearAllPoints()
					a:SetPoint("CENTER",2,1)
				end			
			end
		end
		if not ReputationDetailFrame.bg then
			local bg = M.frame(ReputationDetailFrame,1,"MEDIUM")
			bg:SetPoint("TOPRIGHT",4,4)
			bg:SetPoint("BOTTOMLEFT",-10,-4)
			ReputationDetailFrame.bg = bg
			M.untex(ReputationDetailFrame,true)
			M.restyle_close(ReputationDetailCloseButton)
		end
		ReputationDetailFrame:ClearAllPoints()
		ReputationDetailFrame:SetPoint("TOPLEFT", ReputationFrame, "TOPRIGHT", 4, -58)			
	end	
	ReputationFrame:HookScript("OnShow", UpdateFactionSkins)
	hooksecurefunc("ExpandFactionHeader", UpdateFactionSkins)
	hooksecurefunc("CollapseFactionHeader", UpdateFactionSkins)
	UpdateFactionSkins()
	
	--Currency
	TokenFrame:HookScript("OnShow", function()
		local TokenFrameContainer = TokenFrameContainer
		TokenFrameContainer:ClearAllPoints()
		TokenFrameContainer:SetPoint("TOPLEFT",8,-60)
		TokenFrameContainer:SetPoint("BOTTOMRIGHT",-10,8)
		for i=1, GetCurrencyListSize() do
			local button = _G["TokenFrameContainerButton"..i]
			if button then
				M.kill(button.highlight)
				M.kill(button.categoryMiddle)
				M.kill(button.categoryLeft)
				M.kill(button.categoryRight)
				if button.icon then
					button.icon:SetTexCoord(.1, .9, .1, .9)
				end
			end
		end
		if not TokenFramePopup.bg then
			local bg = M.frame(TokenFramePopup,1,"MEDIUM")
			bg:SetPoint("TOPRIGHT",4,4)
			bg:SetPoint("BOTTOMLEFT",-10,-4)
			TokenFramePopup.bg = bg
			M.untex(TokenFramePopup,true)
			M.restyle_close(TokenFramePopupCloseButton)
		end
		TokenFramePopup:ClearAllPoints()
		TokenFramePopup:SetPoint("TOPLEFT", ReputationFrame, "TOPRIGHT", 4, -58)			
	end)
	
	--Pet
	PetPaperDollFrame:EnableMouse(false)
	M.untex(PetPaperDollFrame)
	M.untex(PetPaperDollFrameExpBar,true)
	local back = M.cut_circle(PetModelFrame,2,"MEDIUM",734,200)
	back:RegisterEvent("UNIT_FACTION")
	local ccc = function(self)
		if UnitIsPVPFreeForAll("pet") then
			self.t:SetVertexColor(.93,.93,.07)
		elseif UnitIsPVP("pet") then
			self.t:SetVertexColor(.07,.93,.07)
		else
			self.t:SetVertexColor(.07,.07,.93)
		end
	end
	PetPaperDollFrameExpBar:EnableMouse(false)
	PetPaperDollFrameExpBar:SetStatusBarTexture(M.media.barv)
	PetPaperDollFrameExpBar:ClearAllPoints()
	back:SetScript("OnEvent",ccc)
	ccc(back)
	local bt = M.frame(back,3,"MEDIUM")
	bt:SetBackdropBorderColor(0,0,0,0)
	bt:SetHeight(36)
	bt:SetPoint("BOTTOMLEFT")
	bt:SetPoint("BOTTOMRIGHT")
	PetPaperDollFrameExpBar:SetPoint("TOPLEFT",bt,4,-4)
	PetPaperDollFrameExpBar:SetPoint("BOTTOMRIGHT",bt,-4,4)
	PetPaperDollFrameExpBar:SetAlpha(.5)
	local ttt = M.frame(back,3,"MEDIUM")
	ttt:SetBackdropBorderColor(0,0,0,0)
	ttt:SetHeight(34)
	ttt:SetPoint("TOPLEFT")
	ttt:SetPoint("TOPRIGHT")
	back.t:SetPoint("CENTER",back,0,-170)
	back:points(PetModelFrame)
	local left = back:CreateTexture(nil,"OVERLAY")
	left:SetPoint("TOPLEFT",back,4,-4)
	left:SetPoint("BOTTOMLEFT",back,4,4)
	left:SetPoint("RIGHT",back,"CENTER",-4,0)
	left:SetTexture(M.media.blank)
	left:SetGradientAlpha("HORIZONTAL",0,0,0,.7,0,0,0,0)
	local right = back:CreateTexture(nil,"OVERLAY")
	right:SetPoint("TOPRIGHT",back,-4,-4)
	right:SetPoint("BOTTOMRIGHT",back,-4,4)
	right:SetPoint("LEFT",back,"CENTER",4,0)
	right:SetTexture(M.media.blank)
	right:SetGradientAlpha("HORIZONTAL",0,0,0,0,0,0,0,.7)
	local myname = M.setfont_lang(ttt,19,nil,"ARTWORK")
	myname:SetText(GetUnitName("pet"))
	myname:SetPoint("LEFT",12,1.4)
	myname:SetTextColor(RAID_CLASS_COLORS[M.class].r,RAID_CLASS_COLORS[M.class].g,RAID_CLASS_COLORS[M.class].b,1)
	PetModelFrame:HookScript("OnShow",function()
		myname:SetText(GetUnitName("pet"))
	end)
	PetModelFrame:ClearAllPoints()
	PetModelFrame:SetPoint("BOTTOMLEFT",-1,5)
	PetModelFrame:SetSize(337,363)
	PetModelFrameShadowOverlay:Hide()
	if M.class == "HUNTER" then
		local nn = M.frame(back,4,"MEDIUM")
		nn:SetSize(42,18)
		nn:SetPoint("RIGHT",ttt,-10,0)
		nn:SetBackdropColor(RAID_CLASS_COLORS[M.class].r,RAID_CLASS_COLORS[M.class].g,RAID_CLASS_COLORS[M.class].b)
		nn:backcolor(RAID_CLASS_COLORS[M.class].r,RAID_CLASS_COLORS[M.class].g,RAID_CLASS_COLORS[M.class].b,.75)
		PetPaperDollPetInfo:ClearAllPoints()
		PetPaperDollPetInfo:SetAllPoints(nn)
		PetPaperDollPetInfo:SetAlpha(0)
	end
	M.kill(PetModelFrameRotateRightButton)
	M.kill(PetModelFrameRotateLeftButton)	
end)
