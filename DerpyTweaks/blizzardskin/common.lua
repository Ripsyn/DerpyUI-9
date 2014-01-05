local C,M,L,V = unpack(select(2,...))

local insets = {left = 2, right = 2, top = 2, bottom = 2}

local modsd = {
		bgFile = M["media"].blank,
		edgeFile = M.media.glow,
		edgeSize = 2, insets = insets}

local ChangeTemplate = function(self,mods)
	M.setbackdrop(self)
	if mods then
		self:SetBackdrop(modsd)
		self:SetBackdropColor(unpack(M["media"].color))
		self:SetBackdropBorderColor(0,0,0,0)
		M.style(self,false,2)
	else
		M.style(self)
	end
end

local function SetModifiedBackdrop(self)
	self:backcolor(.2,1,1,.5)
	if self.text then self.text:SetTextColor(.2,1,1) end
end

local function SetOriginalBackdrop(self)
	self:backcolor(0,0,0)
	if self.text then self.text:SetTextColor(self.text.r,self.text.g,self.text.b) end
end

local function SkinButton(f,mods)
	if not f then return end
	f:SetNormalTexture(nil)
	f:SetHighlightTexture(nil)
	f:SetPushedTexture(nil)
	f:SetDisabledTexture(nil)
	ChangeTemplate(f,mods)
	f.text = _G[f:GetName().."Text"]
	if f.text then
		local r,g,b = f.text:GetTextColor()
		f.text.r = r
		f.text.g = g
		f.text.b = b
	end
	f:HookScript("OnEnter", SetModifiedBackdrop)
	f:HookScript("OnLeave", SetOriginalBackdrop)
end

M.addafter(function(self, event, addon)
	if V.commonskin ~= true then return end
	-- stuff not in Blizzard load-on-demand
		-- Blizzard frame we want to reskin
		local skins = {
			"StaticPopup1",
			"StaticPopup2",
			"GameMenuFrame",
			"InterfaceOptionsFrame",
			"VideoOptionsFrame",
			"AudioOptionsFrame",
			"TicketStatusFrameButton",
			"DropDownList1MenuBackdrop",
			"DropDownList2MenuBackdrop",
			"DropDownList1Backdrop",
			"DropDownList2Backdrop",
			"AutoCompleteBox", -- this is the /w *nickname* box, press tab
			"ReadyCheckFrame",
			"GhostFrameContentsFrame",
		}

		-- reskin popup buttons
		for i = 1, 3 do
			for j = 1, 3 do
				SkinButton(_G["StaticPopup"..i.."Button"..j])
			end
		end
		
		for i = 1, #skins do
			ChangeTemplate(_G[skins[i]])
		end
		
		local ChatMenus = {
			"EmoteMenu",
			"LanguageMenu",
			"VoiceMacroMenu",
		}
 
		for i = 1, #ChatMenus do
			_G[ChatMenus[i]]:HookScript("OnShow", function(self) ChangeTemplate(self) end)
		end
		
		-- reskin all esc/menu buttons
		local BlizzardMenuButtons = {
			"Options", 
			"SoundOptions", 
			"UIOptions", 
			"Keybindings", 
			"Macros",
			"Ratings",
			"AddOns", 
			"Logout", 
			"Quit", 
			"Continue", 
			"MacOptions",
			"Help",
		}
		
		for i = 1, #BlizzardMenuButtons do
			local MenuButtons = _G["GameMenuButton"..BlizzardMenuButtons[i]]
			if MenuButtons then
				SkinButton(MenuButtons,true)
				--_G["GameMenuButton"..BlizzardMenuButtons[i].."Left"]:SetAlpha(0)
				--_G["GameMenuButton"..BlizzardMenuButtons[i].."Middle"]:SetAlpha(0)
				--_G["GameMenuButton"..BlizzardMenuButtons[i].."Right"]:SetAlpha(0)
			end
		end
		
		-- hide header textures and move text/buttons.
		local BlizzardHeader = {
			"GameMenuFrame", 
			"InterfaceOptionsFrame", 
			"AudioOptionsFrame", 
			"VideoOptionsFrame",
			"KeyBindingFrame",
		}
		
		for i = 1, #BlizzardHeader do
			local title = _G[BlizzardHeader[i].."Header"]			
			if title then
				title:SetTexture("")
				title:ClearAllPoints()
				if title == _G["GameMenuFrameHeader"] then
					title:SetPoint("TOP", GameMenuFrame, 0, 7)
				else
					title:SetPoint("TOP", BlizzardHeader[i], 0, 0)
				end
			end
		end
		
		-- here we reskin all "normal" buttons
		local BlizzardButtons = {
			"VideoOptionsFrameOkay", 
			"VideoOptionsFrameCancel", 
			"VideoOptionsFrameDefaults", 
			"VideoOptionsFrameApply", 
			"AudioOptionsFrameOkay", 
			"AudioOptionsFrameCancel", 
			"AudioOptionsFrameDefaults", 
			"InterfaceOptionsFrameDefaults", 
			"InterfaceOptionsFrameOkay", 
			"InterfaceOptionsFrameCancel",
			"ReadyCheckFrameYesButton",
			"ReadyCheckFrameNoButton",
		}
		
		for i = 1, #BlizzardButtons do
			SkinButton(_G[BlizzardButtons[i]],true)
		end
		
		-- if a button position or text is not really where we want, we move it here
		_G["VideoOptionsFrameCancel"]:ClearAllPoints()
		_G["VideoOptionsFrameCancel"]:SetPoint("RIGHT",_G["VideoOptionsFrameApply"],"LEFT",-4,0)		 
		_G["VideoOptionsFrameOkay"]:ClearAllPoints()
		_G["VideoOptionsFrameOkay"]:SetPoint("RIGHT",_G["VideoOptionsFrameCancel"],"LEFT",-4,0)	
		_G["AudioOptionsFrameOkay"]:ClearAllPoints()
		_G["AudioOptionsFrameOkay"]:SetPoint("RIGHT",_G["AudioOptionsFrameCancel"],"LEFT",-4,0)
		_G["InterfaceOptionsFrameOkay"]:ClearAllPoints()
		_G["InterfaceOptionsFrameOkay"]:SetPoint("RIGHT",_G["InterfaceOptionsFrameCancel"],"LEFT", -4,0)
		_G["ReadyCheckFrameYesButton"]:SetParent(_G["ReadyCheckFrame"])
		_G["ReadyCheckFrameNoButton"]:SetParent(_G["ReadyCheckFrame"]) 
		_G["ReadyCheckFrameYesButton"]:SetPoint("RIGHT", _G["ReadyCheckFrame"], "CENTER", -1, 0)
		_G["ReadyCheckFrameNoButton"]:SetPoint("LEFT", _G["ReadyCheckFrameYesButton"], "RIGHT", 3, 0)
		_G["ReadyCheckFrameText"]:SetParent(_G["ReadyCheckFrame"])	
		_G["ReadyCheckFrameText"]:ClearAllPoints()
		_G["ReadyCheckFrameText"]:SetPoint("TOP", 0, -12)
		
		-- others
		_G["ReadyCheckListenerFrame"]:SetAlpha(0)
		_G["ReadyCheckFrame"]:HookScript("OnShow", function(self) if UnitIsUnit("player", self.initiator) then self:Hide() end end) -- bug fix, don't show it if initiator
	
		local mm = {
			"GameMenuFrame", 
			"InterfaceOptionsFrame", 
			"AudioOptionsFrame", 
			"VideoOptionsFrame",
		}
		
		for i=1,#mm do
			local unmask = _G[mm[i]]:CreateTexture(nil,"border")
			unmask:SetAllPoints(UIParent)
			unmask:SetTexture(0,0,0,.6)
		end
		
		M.addlast(function()
			local x = CreateFrame"Frame"
			n = .4
			x:SetScript("OnUpdate",function(self,t)
				n = n - t
				if n>0 then return end
				n = nil
				self:SetScript("OnUpdate",nil)
				x = nil
				M.model_holder:SetBackdrop({})
				M.model_holder:SetParent(_G["GameMenuFrame"])
				_G["GameMenuFrame"].model = M.model_holder
				_G["GameMenuFrame"]:HookScript("OnShow",function(self)
					self.model:show()
				end)
				_G["GameMenuFrame"]:HookScript("OnHide",function(self)
					self.model:Hide()
				end)				
			end)
		end)
	
	-- mac menu/option panel, made by affli.
	if IsMacClient() then
		-- Skin main frame and reposition the header
		ChangeTemplate(MacOptionsFrame)
		MacOptionsFrameHeader:SetTexture("")
		MacOptionsFrameHeader:ClearAllPoints()
		MacOptionsFrameHeader:SetPoint("TOP", MacOptionsFrame, 0, 0)
 
		--Skin internal frames
		ChangeTemplate(MacOptionsFrameMovieRecording)
		ChangeTemplate(MacOptionsITunesRemote)
 
		--Skin buttons
		SkinButton(_G["MacOptionsFrameCancel"],true)
		SkinButton(_G["MacOptionsFrameOkay"],true)
		SkinButton(_G["MacOptionsButtonKeybindings"],true)
		SkinButton(_G["MacOptionsFrameDefaults"],true)
		SkinButton(_G["MacOptionsButtonCompress"],true)
 
		--Reposition and resize buttons
		local tPoint, tRTo, tRP, tX, tY =  _G["MacOptionsButtonCompress"]:GetPoint()
		_G["MacOptionsButtonCompress"]:SetWidth(136)
		_G["MacOptionsButtonCompress"]:ClearAllPoints()
		_G["MacOptionsButtonCompress"]:SetPoint(tPoint, tRTo, tRP, 4, tY)
 
		_G["MacOptionsFrameCancel"]:SetWidth(96)
		_G["MacOptionsFrameCancel"]:SetHeight(22)
		tPoint, tRTo, tRP, tX, tY =  _G["MacOptionsFrameCancel"]:GetPoint()
		_G["MacOptionsFrameCancel"]:ClearAllPoints()
		_G["MacOptionsFrameCancel"]:SetPoint(tPoint, tRTo, tRP, -14, tY)
 
		_G["MacOptionsFrameOkay"]:ClearAllPoints()
		_G["MacOptionsFrameOkay"]:SetWidth(96)
		_G["MacOptionsFrameOkay"]:SetHeight(22)
		_G["MacOptionsFrameOkay"]:SetPoint("LEFT",_G["MacOptionsFrameCancel"],-99,0)
 
		_G["MacOptionsButtonKeybindings"]:ClearAllPoints()
		_G["MacOptionsButtonKeybindings"]:SetWidth(96)
		_G["MacOptionsButtonKeybindings"]:SetHeight(22)
		_G["MacOptionsButtonKeybindings"]:SetPoint("LEFT",_G["MacOptionsFrameOkay"],-99,0)
 
		_G["MacOptionsFrameDefaults"]:SetWidth(96)
		_G["MacOptionsFrameDefaults"]:SetHeight(22)
		
		-- why these buttons is using game menu template? oO
		_G["MacOptionsButtonCompressLeft"]:SetAlpha(0)
		_G["MacOptionsButtonCompressMiddle"]:SetAlpha(0)
		_G["MacOptionsButtonCompressRight"]:SetAlpha(0)
		_G["MacOptionsButtonKeybindingsLeft"]:SetAlpha(0)
		_G["MacOptionsButtonKeybindingsMiddle"]:SetAlpha(0)
		_G["MacOptionsButtonKeybindingsRight"]:SetAlpha(0)
	end
end)

if V.watch_frame == true then
	-- Capture Bar
	local function CaptureUpdate()
		if NUM_EXTENDED_UI_FRAMES then
			local captureBar
			for i=1, NUM_EXTENDED_UI_FRAMES do
				captureBar = getglobal("WorldStateCaptureBar" .. i)
				if captureBar and captureBar:IsVisible() then
					captureBar:ClearAllPoints()
					if( i == 1 ) then
						captureBar:SetPoint("TOP",Minimap,"BOTTOM",0,-9)
					else
						captureBar:SetPoint("TOP", getglobal("WorldStateCaptureBar" .. i - 1 ), "TOP", 0, -25)
					end
				end	
			end	
		end
	end
	hooksecurefunc("UIParent_ManageFramePositions", CaptureUpdate)
end