local C,M,L,V = unpack(select(2,...))

local replace_table = {
	['(s%-)'] = 'S',
	['(a%-)'] = 'A',
	['(c%-)'] = 'C',
	['(Num Pad )'] = 'N',
	['(Page Up)'] = 'PU',
	['(Page Down)'] = 'PD',
	['(Spacebar)'] = 'SpB',
	['(Insert)'] = 'Ins',
	['(Home)'] = 'Hm',
	['(Delete)'] = 'Del',
	['('..KEY_BUTTON3..')'] = 'M3',
	['('..string.gsub(KEY_BUTTON10,'10','')..')'] = 'M',
}

local updatehotkey; do
	if V.shownames ~= true then
		updatehotkey = function(self)
			if not self.hotkey then return end
			return self.hotkey:Hide()
		end
	else
		local _G = _G
		local replace = string.gsub
		local pairs = pairs
		local replace_table = replace_table
		updatehotkey = function(self)
			if not self.hotkey then return end
			local hotkey = self.hotkey
			local text = hotkey:GetText()
			for p,y in pairs(replace_table) do
				text = replace(text,p,y)
			end
			return hotkey:SetFormattedText("|cffffffff%s",text)
		end
	end
end; hooksecurefunc("ActionButton_UpdateHotkeys",updatehotkey)
