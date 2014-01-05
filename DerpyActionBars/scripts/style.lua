local C,M,L,V = unpack(select(2,...))
local _G = _G

-- HOOK FOR VERTEX COLOR
local the_vertex_freepas = function(self,r,g,b)
	self:SetGradient("VERTICAL",r*.345,g*.345,b*.345,r,g,b)
end

C.ModFont = function(parent)
	local HotKey = _G[parent:GetName().."HotKey"]
		HotKey:ClearAllPoints()
		HotKey:SetPoint("TOPRIGHT", 1, -1)
		HotKey:SetFont(M["media"].font, 13, "OUTLINE")
		HotKey:SetShadowOffset(1, -1)
	if V.shownames ~= true then
		HotKey:Hide()
	elseif V.hovernames == true then
		HotKey:SetDrawLayer("HIGHLIGHT")
	end
	if HotKey:GetText() then
		HotKey:SetFormattedText("|cffFFFFFF%s",HotKey:GetText())
	end
	HotKey.ClearAllPoints = M.null
	HotKey.SetPoint = M.null
end

-- MAIN STYLE
local style
do
	local showmacro = V.showmacro 
	local hovermacro = V.hovermacro
	local select = select
	local range_ = V.range
	local the_vertex_freepas = the_vertex_freepas
	local mod_font = C.ModFont
	local getregion = function(self,num)
		local x = select(num,self:GetRegions())
		return x
	end
	style = function(self,mode)
	
		if not self.passed and not mode then return end
		
		local __t = self:GetPushedTexture()
			if __t then
				if __t.maked ~= true then
					__t:SetTexture(M.media.blank)
					__t:SetVertexColor(1,1,1,.2)
					__t.SetTexture = M.null
					__t.maked = true
				end
			end
		local Border = getregion(self,14)
			if Border then
				if Border.maked ~= true then
					Border:SetTexture(nil)
					Border:Hide()
					Border.Show = M.null
					Border.maked = true
				end
			end
			
		if self.setd then return end -- END

			local name = self:GetName()
			self:SetNormalTexture(nil)
			self.SetSetNormalTexture = M.null
			
			local Flash	 = _G[name.."Flash"]
			Flash:SetTexture(nil)
			Flash.SetTexture = M.null
			
			local __t = self:GetCheckedTexture()
			__t:SetTexture(M.media.blank)
			__t:SetVertexColor(1,1,1,.2)
			__t.SetTexture = M.null
			
			local __t = self:GetHighlightTexture()
			__t:SetTexture(M.media.blank)
			__t:SetVertexColor(1,1,1,.2)
			__t.SetTexture = M.null
			
			local __t = getregion(self,3)
			__t:Hide()
			__t.Show = M.null
			
			local __t = getregion(self,4)
			__t:Hide()
			__t.Show = M.null
			
			local __t = getregion(self,9)
			__t:SetTexture(M.media.blank)
			__t:SetGradientAlpha("VERTICAL",0,1,0,0,0,.5,0,.44)
			__t.SetTexture = M.null
			__t.SetVertexColor = M.null
			__t:ClearAllPoints()
			
		local Icon = _G[name.."Icon"]
			__t:SetAllPoints(Icon)
			self.lolicon = Icon
			
			self.setd = true
			
		local Icon = _G[name.."Icon"]
		local Count = _G[name.."Count"]
		local Btname = _G[name.."Name"]
			
		if not mode then
			if self.flyR then
				Icon:SetTexCoord(5/32,1-5/32,3/32,1-3/32)
			else
				Icon:SetTexCoord(3/32,1-3/32,5/32,1-5/32)
			end
		end
			
		Icon:SetPoint("TOPLEFT", self)
		Icon:SetPoint("BOTTOMRIGHT", self)

		if not mode then
			Icon.SetVertexColor = the_vertex_freepas
			Icon:SetVertexColor(1,1,1)
		else
			Icon:SetGradient("VERTICAL",.25,.25,.25,1,1,1)
		end
		
		if Btname then
			Btname:ClearAllPoints()
			Btname:SetPoint("LEFT",.5,-1)
			Btname:SetPoint("RIGHT",-.5,-1)
			Btname:SetJustifyH("CENTER")
			if showmacro ~= true then
				Btname:SetText("")
				Btname:Hide()
				Btname.Show = M.null
			elseif hovermacro == true then
				Btname:SetDrawLayer("HIGHLIGHT")
			end
		end
			
		mod_font(self)
			
		Count:ClearAllPoints()
		Count:SetPoint("BOTTOMRIGHT", 1, 1)
		Count:SetShadowOffset(1, -1)
		Count:SetFont(M["media"].font, 13, "OUTLINE")
	end
end

--PET BAR
local StylePet
do
	local range_ = V.range
	local the_vertex_freepas = the_vertex_freepas
	local function stylesmallbutton(name)
		local button = _G[name]
		if button.setd then return end

		local Flash	 = _G[name.."Flash"]
		Flash:SetTexture(nil)
		Flash.SetTexture = M.null
		
		button:SetNormalTexture(nil)
		button.SetNormalTexture = M.null
		
		local hilight = button:GetHighlightTexture()
		hilight:SetTexture(M.media.blank)
		hilight:SetVertexColor(1,1,1,.2)
		hilight.SetTexture = M.null
		
		local pushed = button:GetPushedTexture()
		pushed:SetTexture(M.media.blank)
		pushed:SetVertexColor(0,0,0,.4)
		pushed.SetTexture = M.null
		
		local check = button:GetCheckedTexture()
		check:SetTexture(M.media.blank)
		check:SetVertexColor(1,1,1,.2)
		check.SetTexture = M.null
		
		button:SetWidth(28)
		button:SetHeight(32)
			
		local icon = _G[name.."Icon"]
		icon:SetTexCoord(5/32,1-5/32,3/32,1-3/32)
		icon:ClearAllPoints()
		icon:SetAllPoints()
		if range_ then
			icon.SetVertexColor = M.null
		end
		icon.SetVertexColor = the_vertex_freepas
		icon:SetVertexColor(1,1,1)
			
		button.setd = true
			
		local autocast = _G[name.."AutoCastable"]
		autocast:Hide()
		autocast.Show = M.null
	end
	local NUM_PET_ACTION_SLOTS = NUM_PET_ACTION_SLOTS
	StylePet = function()
		for i=1, NUM_PET_ACTION_SLOTS do
			stylesmallbutton("PetActionButton"..i)
		end
	end
end

-- COOLDOWN POINTS
do
	local tostring = tostring
	local ipairs = ipairs
	local buttonNames = { 
		"ActionButton",  
		"MultiBarBottomLeftButton", 
		"MultiBarBottomRightButton", 
		"MultiBarLeftButton",
		"MultiBarRightButton", 
		"ShapeshiftButton", 
		"PetActionButton"}
	for _, name in ipairs( buttonNames ) do
		for index = 1, 12 do
			local buttonName = name .. tostring(index)
			local button = _G[buttonName]
			local cooldown = _G[buttonName .. "Cooldown"]
	 
			if ( button == nil or cooldown == nil ) then
				break
			end
			
			cooldown:ClearAllPoints()
			cooldown:SetPoint("TOPLEFT", button)
			cooldown:SetPoint("BOTTOMRIGHT", button)
		end
	end
end

-- FLYOUT
local styleflyout
do
	local SpellFlyout = SpellFlyout
	local buttons = 0
	local function SetupFlyoutButton()
		for i=1, buttons do
			local p = _G["SpellFlyoutButton"..i]
			if p then style(p,true)
				_G["SpellFlyoutButton"..i.."Icon"]:SetGradient("VERTICAL",.24,.24,.24,1,1,1)
				if not p.bgs_ then
					local x = M.frame(p,p:GetFrameLevel()-1,p:GetFrameStrata(),true)
					x:points(p)
					p.bgs_ = x
				end
			end
		end
	end
	SpellFlyout:HookScript("OnShow", SetupFlyoutButton)
	local function FlyoutButtonPos(self, buttons, direction)
		for i=1, buttons do
			local parent = SpellFlyout:GetParent()
			if not _G["SpellFlyoutButton"..i] then return end
			
			if InCombatLockdown() then return end
			local x = _G["SpellFlyoutButton"..i]
		
			if direction == "LEFT" then
				if i == 1 then
					x:ClearAllPoints()
					x:SetPoint("RIGHT", parent, "LEFT", -6, 0)
				else
					x:ClearAllPoints()
					x:SetPoint("RIGHT", _G["SpellFlyoutButton"..i-1], "LEFT", -6, 0)
				end
				x:SetSize(28,32)
				_G["SpellFlyoutButton"..i.."Icon"]:SetTexCoord(5/32,1-5/32,3/32,1-3/32)
			else
				if i == 1 then
					x:ClearAllPoints()
					x:SetPoint("BOTTOM", parent, "TOP", 0, 6)
				else
					x:ClearAllPoints()
					x:SetPoint("BOTTOM", _G["SpellFlyoutButton"..i-1], "TOP", 0, 6)
				end
				x:SetSize(32,28)
				_G["SpellFlyoutButton"..i.."Icon"]:SetTexCoord(3/32,1-3/32,5/32,1-5/32)
			end
		end
	end
	local GetFlyoutID = GetFlyoutID
	local SetClampedTextureRotation = SetClampedTextureRotation
	local GetMouseFocus = GetMouseFocus
	M.addenter(function()
		SpellFlyoutHorizontalBackground:SetAlpha(0)
		SpellFlyoutVerticalBackground:SetAlpha(0)
		SpellFlyoutBackgroundEnd:SetAlpha(0)
	end)
	styleflyout = function(self)
		if not self.FlyoutArrow or not self.FlyoutArrow:IsShown() then return end
		for i=1, GetNumFlyouts() do
			local x = GetFlyoutID(i)
			local _, _, numSlots, isKnown = GetFlyoutInfo(x)
			if isKnown then
				buttons = numSlots
				break
			end
		end
		local arrowDistance
		if ((SpellFlyout and SpellFlyout:IsShown() and SpellFlyout:GetParent() == self) or GetMouseFocus() == self) then
			arrowDistance = 5
		else
			arrowDistance = 2
		end
		if (self.flyR) then
			self.FlyoutArrow:ClearAllPoints()
			self.FlyoutArrow:SetPoint("LEFT", self, "LEFT", -arrowDistance, 0)
			SetClampedTextureRotation(self.FlyoutArrow, 270)
			FlyoutButtonPos(self,buttons,"LEFT")
		elseif (self.flyT) then
			self.FlyoutArrow:ClearAllPoints()
			self.FlyoutArrow:SetPoint("TOP", self, "TOP", 0, arrowDistance)
			SetClampedTextureRotation(self.FlyoutArrow, 0)
			FlyoutButtonPos(self,buttons,"UP")	
		end
	end
end

-- PETBAR UPDATE
local PetBarUpdate
do
	local NUM_PET_ACTION_SLOTS = NUM_PET_ACTION_SLOTS
	local IsPetAttackAction = IsPetAttackAction
	local PetActionButton_StopFlash = PetActionButton_StopFlash
	local PetActionButton_StartFlash = PetActionButton_StartFlash
	local AutoCastShine_AutoCastStart = AutoCastShine_AutoCastStart
	local GetPetActionSlotUsable = GetPetActionSlotUsable
	local SetDesaturation = SetDesaturation
	local GetPetActionInfo = GetPetActionInfo
	local PetHasActionBar = PetHasActionBar
	PetBarUpdate = function()
		local petActionButton
		local petActionIcon
		local petAutoCastableTexture
		local petAutoCastShine
		for i=1, NUM_PET_ACTION_SLOTS do
			local buttonName = "PetActionButton" .. i
			local petActionButton = _G[buttonName]
			local petActionIcon = _G[buttonName.."Icon"]
			local petAutoCastShine = _G[buttonName.."Shine"]
			local name, subtext, texture, isToken, isActive, autoCastAllowed, autoCastEnabled = GetPetActionInfo(i)

			if not isToken then
				petActionIcon:SetTexture(texture)
				petActionButton.tooltipName = name
			else
				petActionIcon:SetTexture(_G[texture])
				petActionButton.tooltipName = _G[name]
			end
		
			petAutoCastShine:SetScale(1.2)
			petActionButton.isToken = isToken
			petActionButton.tooltipSubtext = subtext

			if isActive and name ~= "PET_ACTION_FOLLOW" then
				petActionButton:SetChecked(1)
				if IsPetAttackAction(i) then
					PetActionButton_StartFlash(petActionButton)
				end
			else
				petActionButton:SetChecked(0)
				if IsPetAttackAction(i) then
					PetActionButton_StopFlash(petActionButton)
				end
			end

			if autoCastEnabled then
				AutoCastShine_AutoCastStart(petAutoCastShine)
			else
				AutoCastShine_AutoCastStop(petAutoCastShine)
			end

			if texture then
				if GetPetActionSlotUsable(i) then
					SetDesaturation(petActionIcon, nil)
				else
					SetDesaturation(petActionIcon, 1)
				end
				petActionIcon:Show()
			else
				petActionIcon:Hide()
			end

			if not PetHasActionBar() and texture and name ~= "PET_ACTION_FOLLOW" then
					PetActionButton_StopFlash(petActionButton)
					SetDesaturation(petActionIcon, 1)
					petActionButton:SetChecked(0)
			end
		end
	end
end

-- INIT PET STYLE AND UPDATE
do
	local bar = CreateFrame("Frame", "DerpyPetBar", UIParent, "SecureHandlerStateTemplate")
	local PetBarUpdate = PetBarUpdate
	local PetActionBar_UpdateCooldowns = PetActionBar_UpdateCooldowns
	local StylePet = StylePet
	
	bar:ClearAllPoints()
	bar:SetAllPoints(DerpyMainMenuBar)	
	
	bar:RegisterEvent("PLAYER_LOGIN")
	bar["PLAYER_LOGIN"] = function(self)
		PetActionBarFrame.showgrid = 1	
			for i = 1, 10 do
				local button = _G["PetActionButton"..i]
				button:ClearAllPoints()
				button:SetParent(self)
				button:SetSize(28,32)
				if i ~= 1 then
					button:SetPoint("TOP", _G["PetActionButton"..(i - 1)], "BOTTOM", 0, -6)
				end
				button:Show()
				local bg = M.frame(button,0,"MEDIUM")
				bg:SetPoint("TOPLEFT",-4,4)
				bg:SetPoint("BOTTOMRIGHT",4,-4)
				self:SetAttribute("addchild", button)
			end
			RegisterStateDriver(self, "visibility", "[pet,novehicleui,nobonusbar:5] show; hide")
			PetActionButton_OnDragStart = M.null
			self:UnregisterEvent("PLAYER_LOGIN")
			self["PLAYER_LOGIN"] = nil
	end
	
	local st = ({"PET_BAR_UPDATE",
				"PLAYER_CONTROL_LOST",
				"PLAYER_CONTROL_GAINED",
				"PLAYER_FARSIGHT_FOCUS_CHANGED",
				"UNIT_FLAGS",})
	
	for i=1,#st do
		local x = st[i]
		bar:RegisterEvent(x)
		bar[x] = PetBarUpdate
	end; st = nil;
	
	bar:RegisterEvent("UNIT_AURA")
	bar["UNIT_AURA"] = function(_,arg1)
		if arg1 ~= "pet" then return end
		PetBarUpdate()
	end
	
	bar:RegisterEvent("UNIT_PET")
	bar["UNIT_PET"] = function(_,arg1)
		if arg1 ~= "player" then return end
		PetBarUpdate()
	end
	
	bar:RegisterEvent("PET_BAR_UPDATE_COOLDOWN")
	bar["PET_BAR_UPDATE_COOLDOWN"] = function()
		PetActionBar_UpdateCooldowns()
	end
	
	local st = {"PLAYER_ENTERING_WORLD",
				"PET_BAR_UPDATE_USABLE",
				"PET_BAR_HIDE"}
				
	for i=1,#st do
		local x = st[i]
		bar:RegisterEvent(x)
		bar[x] = StylePet
	end; st = nil;
	
	bar:SetScript("OnEvent", function(self, event, ...)
		self[event](self,...)
	end)
end

-- SECURE HOOKS
hooksecurefunc("ActionButton_Update",style)
hooksecurefunc("ActionButton_UpdateFlyout",styleflyout)

-- HIDE AND UNREGISTER SOME STUFF
do
	MainMenuBar:SetScale(0.00001)
	MainMenuBar:SetAlpha(0)
	MainMenuBar:EnableMouse(false)
	OverrideActionBar:SetScale(0.00001)
	OverrideActionBar:EnableMouse(false)
	PetActionBarFrame:EnableMouse(false)
	StanceBarFrame:EnableMouse(false)
	
	local elements = {
		MainMenuBar, MainMenuBarArtFrame, BonusActionBarFrame, VehicleMenuBar, PossessBarFrame,
		PetActionBarFrame, ShapeshiftBarFrame, ShapeshiftBarLeft, ShapeshiftBarMiddle, ShapeshiftBarRight,
	}
	for _, element in pairs(elements) do
		if element:GetObjectType() == "Frame" then
			element:UnregisterAllEvents()
		end
		
		-- Because of code changes by Blizzard developer thought 4.0.6 about action bars, we must have MainMenuBar always visible. :X
		-- MultiActionBar_Update() and IsNormalActionBarState() Blizzard functions make shit thought our bars. (example: Warrior after /rl)
		-- See 4.0.6 MultiActionBars.lua for more info at line ~25.
		if element ~= MainMenuBar then
			element:Hide()
		end
		element:SetAlpha(0)
	end
	elements = nil

	local uiManagedFrames = {
		"MultiBarLeft",
		"MultiBarRight",
		"MultiBarBottomLeft",
		"MultiBarBottomRight",
		"ShapeshiftBarFrame",
		"PossessBarFrame",
		"PETACTIONBAR_YPOS",
		"MultiCastActionBarFrame",
		"MULTICASTACTIONBAR_YPOS",
		"ChatFrame1",
		"ChatFrame2",
	}
	for _, frame in pairs(uiManagedFrames) do
		UIPARENT_MANAGED_FRAME_POSITIONS[frame] = nil
	end
	
	local have = {
		"MultiBarBottomLeft",
		"MultiBarLeft",
		"MultiBarRight",
		"MultiBarBottomRight",}
	for i=1, #have do
		_G[have[i]].Hide = M.null
		_G[have[i]]:Show()
	end
end
