	local M,L = unpack(select(2,...))

-- What point???
	local point = M.frame(UIParent,50,"HIGH")
	point:SetSize(162,190)
	point:SetPoint("CENTER")
	point:Hide()

	M.make_plav(point,.1)
	
	local title = M.frame(point,52,"HIGH")
	title:SetSize(146,30)
	title:SetPoint("TOP",0,-8)

	local tt = M.setfont(title,21)
	tt:SetPoint("CENTER",1,1)
	tt._point = "None"

	tt.reset = function(self) self:SetText(self._point) end

	local tex_init = {
		function(self,x)
			local y = self:CreateTexture(nil,"ARTWORK")
			y:SetTexture(M.media.blank)
			y:SetSize(18,18)
			y:SetVertexColor(0,0,0,1)
			y:SetPoint("TOPRIGHT",x)
		end,
		function(self,x)
			local y = self:CreateTexture(nil,"ARTWORK")
			y:SetTexture(M.media.blank)
			y:SetSize(28,18)
			y:SetVertexColor(0,0,0,1)
			y:SetPoint("TOP",x)
		end,
		function(self,x)
			local y = self:CreateTexture(nil,"ARTWORK")
			y:SetTexture(M.media.blank)
			y:SetSize(18,18)
			y:SetVertexColor(0,0,0,1)
			y:SetPoint("TOPLEFT",x)
		end,
		function(self,x)
			local y = self:CreateTexture(nil,"ARTWORK")
			y:SetTexture(M.media.blank)
			y:SetSize(18,28)
			y:SetVertexColor(0,0,0,1)
			y:SetPoint("RIGHT",x)
		end,
		function(self,x)
			return
		end,
		function(self,x)
			local y = self:CreateTexture(nil,"ARTWORK")
			y:SetTexture(M.media.blank)
			y:SetSize(18,28)
			y:SetVertexColor(0,0,0,1)
			y:SetPoint("LEFT",x)
		end,
		function(self,x)
			local y = self:CreateTexture(nil,"ARTWORK")
			y:SetTexture(M.media.blank)
			y:SetSize(18,18)
			y:SetVertexColor(0,0,0,1)
			y:SetPoint("BOTTOMRIGHT",x)
		end,
		function(self,x)
			local y = self:CreateTexture(nil,"ARTWORK")
			y:SetTexture(M.media.blank)
			y:SetSize(28,18)
			y:SetVertexColor(0,0,0,1)
			y:SetPoint("BOTTOM",x)
		end,
		function(self,x)
			local y = self:CreateTexture(nil,"ARTWORK")
			y:SetTexture(M.media.blank)
			y:SetSize(18,18)
			y:SetVertexColor(0,0,0,1)
			y:SetPoint("BOTTOMLEFT",x)
		end,
	}

	local bt = {}
	local units = {
		"BOTTOMLEFT",
		"BOTTOM",
		"BOTTOMRIGHT",
		"LEFT",
		"CENTER",
		"RIGHT",
		"TOPLEFT",
		"TOP",
		"TOPRIGHT",
	}

	local _e = function(self) 
		self.st:SetVertexColor(0,1,1) 
		self.title:SetText(self.unit)
	end
	local _l = function(self) 
		self.st:SetVertexColor(1,1,1) 
		self.title:reset()
	end
	local _p = function(self)
		self.parent:modify(self.unit)
	end	
	local _s = function(self,dis)
		if not dis then	
			self:EnableMouse(false)
			self.st:SetVertexColor(.6,.1,.1)
		else
			self:EnableMouse(true)
			self.st:SetVertexColor(1,1,1)
		end
	end
	
	for i=1,9 do
		local x = CreateFrame("Button","Derpy_Point_"..units[i],point)
		x:SetFrameLevel(52)
		M.setbackdrop(x)
		M.style(x)
		M.enterleave(x,0,1,1,true)
		x:SetSize(50,50)
		bt[i] = x
		x.bg:SetDrawLayer("OVERLAY")
		local t = x:CreateTexture(nil,"BORDER")
		t:SetTexture(M.media.blank)
		t:SetSize(28,28)
		t:SetPoint("CENTER")
		x.st = t; tex_init[i](x,t)
		x.unit = units[i]
		x.parent = point
		x.title = tt
		x.mode = _s
		x:SetScript("OnClick",_p)
		x:HookScript("OnEnter",_e)
		x:HookScript("OnLeave",_l)
		if i==1 then
			x:SetPoint("BOTTOMLEFT",8,8)
		elseif i==4 or i==7 then
			x:SetPoint("BOTTOMRIGHT",bt[i-3],"TOPRIGHT",0,-2)
		else
			x:SetPoint("LEFT",bt[i-1],"RIGHT",-2,0)
		end
	end
	
	point.buttons = bt
	point.modify = function(self,point)
		self.target[self.name_in_target] = point
		self.pp:SetText(point)
		self:Hide()
	end
	
	local what_point = function(V,name,enables,pp)
		tt._point = V[name]
		tt:SetText(tt._point)
		point.target = V
		point.name_in_target = name
		for i=1,9 do
			if enables then 
				point.buttons[i]:mode(enables[i])
			else
				point.buttons[i]:mode(true)
			end
		end
		point.pp = pp
		point:show()
	end
	
	units = nil
	tex_init = nil
	
	local _c = function(self)
		what_point(self.V,self.name,self.enables,self.text)	
	end
	local _os = function(self)
		self.text:SetTextColor(0,1,1)
	end
	local _os2 = function(self)
		self.text:SetTextColor(1,1,1)
	end
	
	M.point_menu = function(par,V,name,en_table,size)
		local x = CreateFrame("Button","DerpyConfigButton"..name,par)
		x:SetFrameLevel(par:GetFrameLevel()+2)
		x:SetFrameStrata(par:GetFrameStrata())
		x.enables = en_table
		x.V = V
		x.name = name
		x:SetScript("OnClick",_c)
		local size = size or 21
		local t = M.setfont(x,size)
		t:SetPoint("RIGHT",-2,1.3)
		t:SetText(V[name])
		x.text = t
		x:SetScript("OnEnter",_os)
		x:SetScript("OnLeave",_os2)
		x:SetSize(80,size+2)
		return x
	end