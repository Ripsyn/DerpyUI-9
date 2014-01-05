local C,M,L,V = unpack(select(2,...))
local text_on_right = V.text_on_right

-- Chat holders
local chatone = C.FirstFrameChat
local chattwo = C.SecondFrameChat

-- Bnet toast fix
BNToastFrame:SetScript("OnShow",function(self)
	self:ClearAllPoints()
	self:SetPoint("BOTTOMLEFT",chatone,"TOPLEFT",0,20)
end)
M.setbackdrop(BNToastFrame)
M.style(BNToastFrame,true)
BNToastFrame:SetBackdropColor(.08,.08,.08,.9)
BNToastFrameCloseButton:SetAlpha(0)
BNToastFrameCloseButton.SetAlpha = M.null

-- Chat swichng system
if V.ch_max < V.ch_min then
	local a = V.ch_max
	V.ch_max = V.ch_min
	V.ch_min = a
end

if V.ch_max == V.ch_min then
	V.ch_max = V.ch_max + 10
end

local max_h = V.ch_max
local min_h = V.ch_min
local speed = (max_h-min_h)

-- current
local n = {
	[1] = V.chatcur[1],
	[2] = V.chatcur[2], }
-- check it
for i=1,2 do
	if n[i] ~= max_h and n[i] ~= min_h then n[i] = min_h; V.chatcur[i] = min_h end
end
	
local to_move
do
	local n = n
	local min = min
	local max = max
	to_move = function (self,t)
		n[self.num] = n[self.num] + t * self.change * max(abs(self.level_t-n[self.num]),.1) * 5
		if self.change*n[self.num] < self.level_t*self.change then
			self.target:SetHeight(n[self.num])
		else
			self:Hide()
			n[self.num] = self.level_t
			self.target:SetHeight(self.level_t)
		end
	end
end

local _ldsjf83d = function(self) self.anim:Play() end
local _sad3844d = function(self) self.anim:Finish() end
local set_indicate = function(parent,r,g,b,name,point,x,y,height,start)
	local self = M.frame(parent,10,"MEDIUM",true)
	self:SetBackdrop(M.bg_edge)
	self:backcolor(r,g,b,.95)
	self:SetPoint("BOTTOMLEFT")
	self:SetPoint("BOTTOMRIGHT")
	self:SetHeight(height)
	
	local t = M.setfont(self,25)
	t:SetPoint(point,self,x,y)
	t:SetText(name)
	t:SetTextColor(r,g,b)
	
	local anim = self:CreateAnimationGroup("lol")
	local a,b = {},{1,0,-1,0}
	if start then for i=1,4 do a[i]=i end
	else a[1]=2; a[2]=1; a[3]=4; a[4]=3; end
	for i=1,4 do
		M.anim_alpha(anim,"x"..i,a[i],.1,b[i])
	end
	anim:SetLooping("REPEAT")
	self.anim = anim
	
	self.play = _ldsjf83d
	self.stop = _sad3844d
	
	self:SetAlpha(0)
	return self
end

local make_ud = function(frame,num,change,level)
	local f = CreateFrame("Frame")
	f:Hide()
	f.level_t = level
	f.target = frame
	f.num = num
	f.change = change
	f:SetScript("OnUpdate",to_move)
	return f
end

local fr_button
local _hdgfsjdf = function(self)
	if V.chatcur[self.num] == min_h then
		self.ex:play()
	else
		self.mi:play()
	end
end
local _sdfjdshf = function(self) 
	self.ex:stop()
	self.mi:stop()
end
local _kdhjfksd = function(self)
	self:GetParent().postupd()
	if V.chatcur[self.num] == min_h then
		V.chatcur[self.num] = max_h
		self.down.smooth = 0
		self.down:Hide()
		self.up:Show()
	else 
		V.chatcur[self.num] = min_h
		self.up:Hide()
		self.down:Show()
	end
end
local buttons = {}
local mk_frbutton = function(frame,num)
	frame:SetHeight(V.chatcur[num])
	local bt = CreateFrame("Frame",nil,frame)
	if num == 2 then
		fr_button = bt
	end
	bt:SetFrameStrata("MEDIUM")
	bt:SetPoint("TOPLEFT",frame.top,-2,5)
	bt:SetPoint("BOTTOMRIGHT",frame.top,2,-5)
	bt:EnableMouse(true)
	bt.wait = true
	
	bt.ex = set_indicate(frame,0,.8,.8,"MAXIMIZE",num == 2 and "TOPLEFT" or "TOPRIGHT",num == 2 and 11 or -11,-6,max_h,true)
	bt.mi = set_indicate(frame,1,0,0,"MINIMIZE",num == 2 and "TOPLEFT" or "TOPRIGHT",num == 2 and 11 or -11,-6,min_h,false)
	
	bt:SetScript("OnEnter",_hdgfsjdf)
	bt:SetScript("OnLeave",_sdfjdshf)
	bt:SetScript("OnMouseDown",_kdhjfksd)
	
	frame.postupd = M.null
	bt.num = num
	bt.up = make_ud(frame,num,1,max_h)
	bt.down = make_ud(frame,num,-1,min_h)
	buttons[num]=bt
end

mk_frbutton(chatone,1)
mk_frbutton(chattwo,2)	

C.enable_demo = function()
	for i=1,2 do
		buttons[i]:EnableMouse(false)
		buttons[i].ex:SetAlpha(1)
		buttons[i].mi:SetAlpha(1)
		buttons[i].ex:SetHeight(V.ch_max)
		buttons[i].mi:SetHeight(V.ch_min)
	end
end

C.disable_demo = function()
	for i=1,2 do
		buttons[i]:EnableMouse(true)
		buttons[i].ex:SetAlpha(0)
		buttons[i].mi:SetAlpha(0)
		buttons[i].ex:SetHeight(max_h)
		buttons[i].mi:SetHeight(min_h)
	end
end

C.mod_a = function()
	for i=1,2 do
		buttons[i].ex:SetHeight(V.ch_max)
		buttons[i].mi:SetHeight(V.ch_min)
	end
end

local right_holder = CreateFrame("Frame",nil,UIParent)
right_holder:SetFrameStrata("LOW")

local moving = function(self,t)
	self.he = self.he + t*self.mult
	if self.he*self.ar < self.ma*self.ar then
		right_holder:ClearAllPoints()
		right_holder:SetPoint("BOTTOMRIGHT",chattwo,0,self.he)
		right_holder:SetPoint("BOTTOMLEFT",chattwo,0,self.he)
		right_holder:SetHeight(20)
	else
		right_holder:ClearAllPoints()
		right_holder:SetPoint(self.point1,chattwo,self.point2,0,self.p)
		right_holder:SetPoint(self.point3,chattwo,self.point4,0,self.p)
		right_holder:SetHeight(20)
		self:Hide()
	end
end

right_holder.mover = CreateFrame("Frame",nil,right_holder)
right_holder.mover:Hide()
right_holder.mover:SetScript("OnUpdate",moving)
chattwo.right_holder = right_holder

local fn_button = CreateFrame("Frame",nil,UIParent)
local work_unit = M.frame(right_holder)
chattwo.work_unit = work_unit

local hld_correct = function(he,ar,ma,mult,p1,p2,p3,p4,x,pi)
	local a = right_holder.mover
	a:Hide()
	a.he = he
	a.ar = ar
	a.ma = ma
	a.p = pi
	a.mult = (a.he + a.ma) * mult 
	a.point1 = p1
	a.point2 = p2
	a.point3 = p3
	a.point4 = p4
	a:Show()
	V.holder_cur = x
	fn_button:ClearAllPoints()
end

right_holder.go_up = function()
	hld_correct(2,1,floor(chattwo:GetHeight()+.5),1,"BOTTOMLEFT","TOPLEFT","BOTTOMRIGHT","TOPRIGHT",1,0)
	UIFrameFadeIn(chattwo,.8,0,1)
	fr_button:EnableMouse(true)
	fn_button:SetPoint("TOPRIGHT",chattwo,5,5)
	fn_button:SetPoint("BOTTOMLEFT",chattwo,"BOTTOMRIGHT",-6,-6)
end

right_holder.go_down = function()
	hld_correct(floor(chattwo:GetHeight()+.5),-1,2,-1,"BOTTOMLEFT","BOTTOMLEFT","BOTTOMRIGHT","BOTTOMRIGHT",0,2)
	UIFrameFadeOut(chattwo,.8,1,0)
	fr_button:EnableMouse(false)
	fn_button:SetAllPoints(work_unit)
	chattwo.update_w(0)
end

work_unit:SetPoint("RIGHT")
work_unit:SetHeight(24)
work_unit:SetFrameLevel(20)

local text_unit = M.setfont_lang(work_unit,12,nil,nil,"CENTER")
text_unit:SetPoint("LEFT",6.4,1)
text_unit:SetPoint("RIGHT",-5.3,1)

right_holder.set_unit = function(text)
	text_unit:SetText(text)
	local a = floor(chattwo:GetWidth()/4+.5)
	local b = string.len(text)*6
	if a < b then
		work_unit:SetWidth(a+13)
	else
		work_unit:SetWidth(b+13)
	end
end

chatone.copyb = CreateFrame("Frame",nil,chatone)
chattwo.copyb = CreateFrame("Frame",nil,right_holder)
chatone.copyb:SetSize(24,24)
chattwo.copyb:SetSize(24,24)
chatone.copyb:SetPoint("BOTTOMRIGHT",chatone,"TOPRIGHT", 0, -2)
chattwo.copyb:SetPoint("LEFT",right_holder)

local QuestLog = C.QuestLog

local _t_com = {
	[1] = "TRACKING",
	[0] = "NONE",
	[-1] = "OFF",
}

local _LKJFL = function(self) 
	if self.lok == true then 
		self:GetFontString():SetAlpha(0)
		text_unit:SetTextColor(1,.7,.1) 
	end 
end

local _LKJFG = function(self) 
	if self.lok == true then 
		self:GetFontString():SetAlpha(0)
		text_unit:SetTextColor(1,1,1)
	end
end

local left_j = V["justy1"]
local right_j  = V["justy2"]

local lock_chat = function(target)
	QuestLog:Switch()
	if chattwo.curent_unit then
		local a = chattwo.curent_unit
		a.st_g:SetAlpha(1)
		a.tab.lok = nil
		a:SetJustifyH(left_j)
		a.copyb:ClearAllPoints()
		a.copyb:SetAllPoints(chatone.copyb)
		a.lok = nil
		FCF_DockFrame(a)
	end
	if target == 0 or target == 1 or target == -1 then
		chattwo.curent_unit = nil
		right_holder.set_unit(_t_com[target])
		if target == 1 then
			QuestLog:Switch(true)
		end
		chattwo.update_w(0)
	else
		local chat = _G["ChatFrame"..target]
		if not chat then return end
		FCF_UnDockFrame(chat)
		local tab = _G["ChatFrame"..target.."Tab"]
		local a = tab:GetFontString()
		a:SetAlpha(0)
		FCF_SetLocked(chat,1)
		if not tab._text_hooked then
			tab:HookScript("OnEnter",_LKJFL)
			tab:HookScript("OnLeave",_LKJFG)
			tab._text_hooked = true
		end
		chat:ClearAllPoints()
		tab.lok = true
		chat.lok = true
		if target == 2 then
			chat:SetPoint("TOPRIGHT", chattwo, -7, -30)
			chat:SetPoint("BOTTOMLEFT", chattwo, 7, 6)
		else
			chat:SetPoint("TOPRIGHT", chattwo, -7, -3)
			chat:SetPoint("BOTTOMLEFT", chattwo, 6, 6)
		end
		chat:SetJustifyH(right_j)
		tab:ClearAllPoints() 
		tab:SetAllPoints(work_unit)
		right_holder.set_unit(a:GetText())
		chat.copyb:ClearAllPoints()
		chat.copyb:SetAllPoints(chattwo.copyb)
		chattwo.curent_unit = chat
		chattwo.curent_unit.st_g = a
		chattwo.curent_unit.tab = tab
		chattwo.update_w(1)
	end
end

local check_work_mode = function(rly)
	if V.holder_cur == 1 then
		lock_chat(V.holder_unit)
	else
		if rly then
			lock_chat(V.holder_unit)
			right_holder.go_up()
		else
			lock_chat(-1)
		end
	end
end

M.addafter(function()
	if not V.holder_cur then
		V.holder_cur = 1
	end
	if not V.holder_unit then
		V.holder_unit = 0
	end
	if V.holder_cur == 1 then
		right_holder.go_up()
	else
		right_holder.go_down()
	end
	check_work_mode()
end)
 
local _title = {text = "DISPLAY", isTitle = 1, notCheckable = 1}
local _nan = {text = "NONE", func = function() V.holder_unit = 0; check_work_mode(true) end, notCheckable = 1}
local _hideframe = {text = "HIDE FRAME", func = function() V.holder_unit = -1; right_holder.go_down(); check_work_mode()  end, notCheckable = 1}
local _quest =  {text = "WATCH FRAME", func = function() V.holder_unit = 1; check_work_mode(true)  end, notCheckable = 1}
local menuFrame = M.menuframe

local chatframe_menu = function()
	local abc = {[1] = _title,}
	if V.holder_unit ~= 0 then abc[2] = _nan end
	if V.holder_unit ~= 1 then abc[#abc+1] = _quest end
	for i=2, NUM_CHAT_WINDOWS do
		if _G["ChatFrame"..i.."Tab"]:IsShown() and i~=V.holder_unit then
			abc[#abc+1] = {text = _G["ChatFrame"..i.."Tab"]:GetFontString():GetText(),
				func = function() V.holder_unit = i; check_work_mode(true) end,
				notCheckable = 1}
		end
	end
	if V.holder_cur==1 then
		abc[#abc+1] = _hideframe
	end
	return abc
end

fn_button:SetFrameStrata("MEDIUM")
fn_button:EnableMouse(true)

fn_button:SetScript("OnMouseDown",function() EasyMenu(chatframe_menu(), menuFrame, "cursor", 0, 0, "MENU", 2) end)
fn_button:SetScript("OnEnter",function() chattwo:backcolor(0,.3,.7,.4); work_unit:backcolor(0,.3,.7,.4) end)
fn_button:SetScript("OnLeave",function() chattwo:backcolor(0,0,0);		work_unit:backcolor(0,0,0) 		end)

local side_width = V.side_width
local cha = V.ch_w

-- Edition Panels
local mk_side_panel = function(parent,num)
	local self = M.frame(chatone,parent:GetFrameLevel(),parent:GetFrameStrata())
	self:SetPoint(num == 1 and "BOTTOMLEFT" or "BOTTOMRIGHT",parent,num == 2 and "BOTTOMLEFT" or "BOTTOMRIGHT", num == 1 and -2 or 2,0)
	self:SetPoint(num == 1 and "TOPLEFT" or "TOPRIGHT",		 parent,num == 2 and "TOPLEFT" or "TOPRIGHT",		num == 1 and -2 or 2,0)
	self:SetWidth(side_width)
	local upper = M.frame(self,parent:GetFrameLevel(),parent:GetFrameStrata())
	upper:SetPoint("BOTTOMLEFT",self,"TOPLEFT",0,-2)
	upper:SetPoint("BOTTOMRIGHT",self,"TOPRIGHT",0,-2)
	upper:SetHeight(24)
	self.upper = upper
	parent.sside = self
	self:Hide()
end

mk_side_panel(chatone,1)
mk_side_panel(chattwo,2)

local shown_side = V.side_state
local action = V.fit_action
local fit_normal = V.fit_normal
local fitmod = V.center_offset

local update_chat_panels = function()
	for i=1,2 do
		local x = i==1 and chatone or chattwo
		if x.offset_point and action then
			local y = shown_side[i] == true and (side_width-2) or 0
			y = x.offset_point+y
			x:SetPoint(i==1 and "BOTTOMRIGHT" or "BOTTOMLEFT",UIParent,"BOTTOM",i == 1 and -y or y,2)
		elseif fit_normal then
			local y = shown_side[i] == true and (side_width-2) or 0
			y = floor(fitmod/2+.5)+y
			x:SetPoint(i==1 and "BOTTOMRIGHT" or "BOTTOMLEFT",UIParent,"BOTTOM",i == 1 and -y or y,2)
		else
			x:SetWidth(cha)
		end
		if shown_side[i] then
			x.sside:Show()
		else
			x.sside:Hide()
		end
	end
	check_work_mode()
end

M.addlast(update_chat_panels)

local _dkfpsokf = function(self)
	if shown_side[self.num] == true then
		shown_side[self.num] = false
	else
		shown_side[self.num] = true
	end
	update_chat_panels()
end
local _odkfpdff = function(self)
	self:GetParent():backcolor(.4,1,0,.8)
end
local _odkfpdee = function(self)
	self:GetParent():backcolor(0,0,0)
end
local mk_side_bt = function(self,num)
	local x = CreateFrame("Button",nil,self)
	if num == 1 then
		x:SetPoint("TOPLEFT",self,"TOPRIGHT",-7,4)
		x:SetPoint("BOTTOMLEFT",self,"BOTTOMRIGHT",-7,-4)
	else
		x:SetPoint("TOPRIGHT",self,"TOPLEFT",7,4)
		x:SetPoint("BOTTOMRIGHT",self,"BOTTOMLEFT",7,-4)
	end
	x:SetWidth(13)
	x:RegisterForClicks("AnyDown")
	x.num = num
	x:SetScript("OnClick",_dkfpsokf)
	x:SetScript("OnEnter",_odkfpdff)
	x:SetScript("OnLeave",_odkfpdee)
end

mk_side_bt(chatone,1)
mk_side_bt(chattwo,2)
