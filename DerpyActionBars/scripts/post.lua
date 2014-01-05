local C,M,L,V = unpack(select(2,...))
C.update_grid = function()
	local ActionButton_ShowGrid = ActionButton_ShowGrid
	for i = 1, 12 do
		local button = _G["ActionButton"..i]
		button:SetAttribute("showgrid", 1)
		ActionButton_ShowGrid(button)

		button = _G["BonusActionButton"..i]
		--button:SetAttribute("showgrid", 1)
		--ActionButton_ShowGrid(button)
			
		button = _G["MultiBarRightButton"..i]
		button:SetAttribute("showgrid", 1)
		ActionButton_ShowGrid(button)

		button = _G["MultiBarBottomRightButton"..i]
		button:SetAttribute("showgrid", 1)
		ActionButton_ShowGrid(button)
			
		button = _G["MultiBarLeftButton"..i]
		button:SetAttribute("showgrid", 1)
		ActionButton_ShowGrid(button)
			
		button = _G["MultiBarBottomLeftButton"..i]
		button:SetAttribute("showgrid", 1)
		ActionButton_ShowGrid(button)
	end
end

M.addenter(function()
	-- Settings
	InterfaceOptionsActionBarsPanelBottomLeft:Hide()
	InterfaceOptionsActionBarsPanelBottomRight:Hide()
	InterfaceOptionsActionBarsPanelRight:Hide()
	InterfaceOptionsActionBarsPanelRightTwo:Hide()
	InterfaceOptionsActionBarsPanelSecureAbilityToggle:ClearAllPoints()
	InterfaceOptionsActionBarsPanelAlwaysShowActionBars:Hide()
	InterfaceOptionsActionBarsPanelSecureAbilityToggle:SetPoint("LEFT",InterfaceOptionsActionBarsPanelBottomLeft)
	-- Chat
	if FirstFrameChat then
		FirstFrameChat.offset_point =  C.ChatPoint
		SecondFrameChat.offset_point = C.ChatPoint
	end
	C.ChatPoint = nil
	C.check_right_bar()
end)

M.addenter(function()
	SHOW_MULTI_ACTIONBAR_1 = 1
	SHOW_MULTI_ACTIONBAR_2 = 1
	SHOW_MULTI_ACTIONBAR_3 = 1
	SHOW_MULTI_ACTIONBAR_4 = 1
	MultiActionBar_Update()
	SetActionBarToggles(1, 1, 1, 1)
	SetCVar("alwaysShowActionBars", 0)	
	ActionButton_HideGrid = M.null
end)

hooksecurefunc('TalentFrame_LoadUI',function()
	PlayerTalentFrame:UnregisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
end)
