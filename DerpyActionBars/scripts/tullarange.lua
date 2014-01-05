--[[
	Thx to Tulla, most lowest cpu usage range script
		Adds out of range coloring to action buttons
		Derived from RedRange with negligable improvements to CPU usage
--]]

--[[ locals and speed ]]--
local C,M,L,V = unpack(select(2,...))

local _G = _G
local TULLARANGE_COLORS

local ActionButton_GetPagedID = ActionButton_GetPagedID
local ActionButton_IsFlashing = ActionButton_IsFlashing
local ActionHasRange = ActionHasRange
local IsUsableAction = IsUsableAction
local HasAction = HasAction


--[[ The main thing ]]--

local tullaRange = CreateFrame('Frame', 'tullaRange', UIParent); tullaRange:Hide()
tullaRange.buttonsToUpdate = {}

--[[ Game Events ]]--

local LOAD = function()
	if not TULLARANGE_COLORS then
		TULLARANGE_COLORS = {
		[0] = {.333,.333,.333}, -- unuse
		[1] = {1, 0.1, 0.1}, -- oor
		[2] = {1, 1, 1}, -- 'normal'
		[3] = {0.1, 0.3, 1}, -- oom
	}
	end
	tullaRange.colors = TULLARANGE_COLORS
	do
		local tullaRange = tullaRange
		M.set_updater(function() tullaRange:UpdateButtons() end,"DerpyRangeColors",.1,true)
	end
	hooksecurefunc('ActionButton_OnUpdate', tullaRange.RegisterButton)
	hooksecurefunc('ActionButton_UpdateUsable', tullaRange.OnUpdateButtonUsableShown)
	hooksecurefunc('ActionButton_Update', tullaRange.OnUpdateButtonUsableShown)
end


--[[ Actions ]]--

function tullaRange:Update()
	self:UpdateButtons()
end

function tullaRange.ForceColorUpdate(self)
	for button in pairs(self.buttonsToUpdate) do
		self.OnUpdateButtonUsable(button)
	end
end

function tullaRange.UpdateShown(self)
	if next(self.buttonsToUpdate) then
		self:Show()
	else
		self:Hide()
	end
end

do
	local next = next
	local pairs = pairs
	function tullaRange.UpdateButtons(self)
		if not next(self.buttonsToUpdate) then
			self:Hide()
			return
		end
		for button in pairs(self.buttonsToUpdate) do
			self:UpdateButton(button)
		end
	end
end

function tullaRange.UpdateButton(self,button)
	self:UpdateButtonUsable(button)
end

function tullaRange.UpdateButtonStatus(self,button)
	local action = ActionButton_GetPagedID(button)
	if not(button:IsVisible() and action and HasAction(action) and ActionHasRange(action)) then
		self.buttonsToUpdate[button] = nil
		button._derpy_mask:backcolor(0,0,0)
	else
		self.buttonsToUpdate[button] = true
	end
	self:UpdateShown()
end

--[[ Button Hooking ]]--

M.addenter(function()
	local tullaRange = tullaRange
	function tullaRange.RegisterButton(button)
		button:SetScript('OnUpdate', nil)
		if not button.passed then return end
		if not button.tulla_hooked then
			button:HookScript('OnShow', tullaRange.OnButtonShow)
			button:HookScript('OnHide', tullaRange.OnButtonHide)
			button.tulla_hooked = true
		end
		tullaRange:UpdateButtonStatus(button)
	end
	function tullaRange.OnButtonShow(button)
		tullaRange:UpdateButtonStatus(button)
	end
	function tullaRange.OnButtonHide(button)
		tullaRange:UpdateButtonStatus(button)
	end
	function tullaRange.OnUpdateButtonUsable(button)
		tullaRange:UpdateButtonUsable(button)
	end
	function tullaRange.OnUpdateButtonUsableShown(button)
		if not button.passed then return end
		if not button:IsShown() then return end
		tullaRange:UpdateButtonUsable(button)
	end
	LOAD(); LOAD = nil
	M.addlast(function()
		for i=1,12 do
			_G["ActionButton"..i].tullaRangeColor = nil
			tullaRange:UpdateButtonUsable(_G["ActionButton"..i])
		end
	end)
end)

--[[ Range Coloring ]]--

do
	local IsActionInRange = IsActionInRange
	local ActionButton_GetPagedID = ActionButton_GetPagedID
	local IsUsableAction = IsUsableAction
	local tullaRange = tullaRange
	function tullaRange.UpdateButtonUsable(self,button)
		local action = ActionButton_GetPagedID(button)
		local isUsable, notEnoughMana = IsUsableAction(action)
		--usable
		if isUsable then
			--but out of range
			if IsActionInRange(action) == 0 then
				self:SetButtonColor(button, 1)
			--in range
			else
				self:SetButtonColor(button, 2)
			end
		--out of mana
		elseif notEnoughMana then
			self:SetButtonColor(button, 3)
		--unusable
		else
			self:SetButtonColor(button, 0)
		end
	end
end

function tullaRange.SetButtonColor(self, button, colorType)
	if button.tullaRangeColor ~= colorType then
		button.tullaRangeColor = colorType
		if colorType == 2 or colorType == 0 then 
			button._derpy_mask:backcolor(0,0,0)
			button.lolicon:SetVertexColor(self:GetColor(colorType))
		else
			local r, g, b = self:GetColor(colorType)
			button._derpy_mask:backcolor(r*.7,g*.7,b*.7,.7)
			button.lolicon:SetVertexColor(r,g,b)
		end
	end
end

function tullaRange:Reset()
	self.colors = TULLARANGE_COLORS
	self:ForceColorUpdate()
end

function tullaRange:GetColor(index)
	local color = self.colors[index]
	return color[1], color[2], color[3]
end