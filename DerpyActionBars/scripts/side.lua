local C,M,L,V = unpack(select(2,...))
local _G = _G
local UIFrameFadeIn = UIFrameFadeIn
local UIFrameFadeOut = UIFrameFadeOut
local stoped
local layout = V.layout
local reverse = V.reverse
local side = C.side

do
	local side_table = C.side_table
	local secondroll = ({nil,21,nil,31,16,26,15,21})[layout]
	local from = ({20,40,30,60,30,50,42,60})[layout]
	for i=13, from do
		side_table[i]:SetSize(32,28)
		side_table[i]:ClearAllPoints()
		side_table[i]:SetPoint("LEFT",side_table[i-1],"RIGHT",6,0)
		side_table[i].flyT = true
	end
	if secondroll then
		side_table[secondroll]:ClearAllPoints()
		if reverse then
			side_table[secondroll]:SetPoint("TOP",side_table[1],"BOTTOM",0,-6)
		else
			side_table[secondroll]:SetPoint("BOTTOM",side_table[1],"TOP",0,6)
		end
	end
	stoped = from
	if layout == 7 or layout == 8 then
		local x = layout == 7 and 29 or 41
		local y = layout == 7 and 15 or 21
		side_table[x]:ClearAllPoints()
		if reverse then
			side_table[x]:SetPoint("TOP",side_table[y],"BOTTOM",0,-6)
		else
			side_table[x]:SetPoint("BOTTOM",side_table[y],"TOP",0,6)
		end
	end
end

if stoped~= 60 then
	local rightg,k,z = {},1,1
	local side_table = C.side_table
	rightg[1] = {}
	for i=stoped+1,60 do
		side_table[i]:SetSize(28,32)
		side_table[i].flyR = true
		side_table[i]:ClearAllPoints()
		side_table[i]:Hide()
		if i~= stoped+1 and z~= 1 then
			side_table[i]:SetPoint("TOP",side_table[i-1],"BOTTOM",0,-6)
		elseif z == 1 then
			side_table[i]:SetPoint("RIGHT",side,-6,171)
		end
		side_table[i].show = side_table[i].Show
		side_table[i].Show = M.null
		side_table[i].hide = side_table[i].Hide
		side_table[i].Hide = M.null
		rightg[k][z] = side_table[i]
		z = z+1
		if z == 11 then
			k = k + 1
			z = 1
			rightg[k] = {}
		end
	end
	--add 2 fake
	if layout == 7 then
		k = k + 1
		for i=9,10 do
			rightg[2][i] = M.frame(UIParent)
			rightg[2][i].show = rightg[2][i].Show
			rightg[2][i].hide = rightg[2][i].Hide
			rightg[2][i]:SetSize(40,40)
			rightg[2][i]:SetPoint("TOP",rightg[2][i-1],"BOTTOM",0,i == 9 and -2 or 2)
			local t = rightg[2][i]:CreateTexture(nil,"HIGHLIGHT")
			t:SetPoint("TOPLEFT",4,-4)
			t:SetPoint("BOTTOMRIGHT",-4,4)
			t:SetTexture(1,1,1,.2)
		end
	end
	
	local on_show_rep = function(self) if not InCombatLockdown() then self:Hide() end end
	
	local hideroll = function(coord)
		for i=1,10 do
			rightg[coord][i]:hide()
		end
	end
	
	local showroll = function(coord)
		for i=1,10 do
			rightg[coord][i]:show()
		end
	end
	
	local bright = M.frame(UIParent,2)
	bright:SetAlpha(0)
	bright:SetPoint("RIGHT",side,2,-199)
	bright:SetSize(40,20)
	bright:EnableMouse(true)
	bright:SetScript("OnEnter", function(self) UIFrameFadeIn(self,.2,0,1) end)
	bright:SetScript("OnLeave", function(self) UIFrameFadeOut(self,.2,1,0) end)	
	
	local deadline = k - 1
	
	_colors = {
		[1] = {0,1,0},
		[2] = {1,1,0},
		[3] = {0,1,1},
		[4] = {1,0,0},
	}
	
	local bstatus = CreateFrame("StatusBar",nil,bright)
	bstatus:SetPoint("TOPLEFT",4,-4)
	bstatus:SetPoint("BOTTOMRIGHT",-4,4)
	bstatus:SetStatusBarTexture(M.media.barv)
	bstatus:SetMinMaxValues(0,deadline)
	bstatus.Value = function(self,val)
		self:SetValue(val)
		if val ~= 0 then
			local x1,x2,x3 = unpack(_colors[val])
			self:SetStatusBarColor(x1,x2,x3)
			bright:backcolor(x1,x2,x3,.8)
		else
			bright:backcolor(0,0,0)
		end	
	end
	
	M.addafter(function()
		for i=1,deadline do
			hideroll(i)
		end
		if deadline < V.savedright then
			showroll(1)
			V.savedright = 1
			bstatus:Value(1)
		elseif V.savedright ~= 0 then
			showroll(V.savedright)
			bstatus:Value(V.savedright)
		else
			bstatus:Value(0)
		end
		C.checkthepet()
		C.update_grid()
	end)
	
	local switch = function(change)
		local abc = V.savedright
		if abc ~= 0 then
			hideroll(abc)
		end
		abc = abc + change
		if abc > deadline then
			abc = 0
		elseif abc < 0 then
			abc = deadline
		end
		if abc == 0 then
			bstatus:Value(0)
		else
			bstatus:Value(abc)
			showroll(abc)
		end
		V.savedright = abc
		C.checkthepet()
		C.update_grid()
		C.check_right_bar()
	end
	
	bright:SetScript("OnMouseDown",function(self,b)
		if InCombatLockdown() then return end
		if b == "LeftButton" then
			switch(1)
		elseif b == "RightButton" then
			switch(-1)
		end
	end)
	
else
	M.addafter(function()
		C.checkthepet()
		C.update_grid()
	end)
	V.savedright = 0
end
