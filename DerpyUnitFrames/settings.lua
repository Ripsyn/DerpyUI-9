local W,M,L,V = unpack(select(2,...))

local title_table = {
	"PLAYER: COMMON",
	"PLAYER: CASTBAR",
	"PLAYER: BUFFS",
	"PLAYER: DEBUFFS",
	"TARGET: COMMON",
	"TARGET: CASTBAR",
	"TARGET: BUFFS",
	"TARGET: DEBUFFS",
	"FOCUS: COMMON",
	"FOCUS: CAST BAR",
	"FOCUS: BUFFS",
	"FOCUS: DEBUFFS",
	"PET: COMMON",
	"PET: CAST BAR",
	"PET: BUFFS",
	"PET: DEBUFFS",
	"TARGETTARGET",
	"FOCUSTARGET",
}; title_table[0] = "COMMON"

local MAX_STEP = #title_table
local width = 380
local holder = M.make_settings_template("UNIT FRAMES",width,544)
local step = 348
local strata = holder:GetFrameStrata()
local level = holder:GetFrameLevel()+4

local teh_scroll = CreateFrame("ScrollFrame", "DerpyUnitSettings", holder)
	teh_scroll:SetPoint("TOPLEFT",12,-40)
	teh_scroll:SetPoint("BOTTOMRIGHT",-12,12)
	teh_scroll:SetFrameLevel(level)
	teh_scroll:SetFrameStrata(strata)

local teh_mask = CreateFrame("Frame",nil,teh_scroll)
	teh_mask:SetSize(step,428)
	teh_mask:SetFrameLevel(level)
	teh_mask:SetFrameStrata(strata)
	teh_mask:SetPoint("TOPLEFT")

local teh_holder = CreateFrame("Frame",nil,teh_mask)
	teh_holder:SetSize(step*(MAX_STEP+1),428)
	teh_holder:SetFrameLevel(level)
	teh_holder:SetFrameStrata(strata)

	teh_holder.point_1 = "LEFT"
	teh_holder.point_2 = "LEFT"
	teh_holder.pos = 0
	teh_holder.hor = true
	teh_holder.parent = teh_mask
	
	teh_scroll:SetScrollChild(teh_mask)
	teh_holder:SetPoint("LEFT",teh_mask,"LEFT")

local current_step = 0
local on_update = M.simple_move

local title = M.setfont(holder,21)
	title:SetPoint("TOPLEFT",14,-14)

title.update = function(self)
	self:SetText(title_table[current_step])
end; title:update()

teh_holder.where_to_go = function(self)
	title:update()
	if self.pos > self.limit then
		return -1
	else
		return 1
	end
end

teh_holder.go_go = function(self)
	self.limit = (-current_step) * step
	self.speed = 100 * self:where_to_go()
	self.mod = 1 * self:where_to_go()
	self:SetScript("OnUpdate",on_update)
end

teh_holder.next = function(self)
	if current_step == MAX_STEP then return self:start() end
	self:SetScript("OnUpdate",nil)
	current_step = current_step + 1
	return self:go_go()
end

teh_holder.back = function(self)
	if current_step == 0 then return self:start(true) end
	self:SetScript("OnUpdate",nil)
	current_step = current_step - 1
	return self:go_go()
end

teh_holder.start = function(self,mode)
	if not(mode) and current_step == 0 then 
		return
	end
	if mode and current_step == MAX_STEP then 
		return 
	end
	self:SetScript("OnUpdate",nil)
	current_step = mode==true and MAX_STEP or 0
	return 
	self:go_go()
end

teh_holder.cost = function(self,value)
	if current_step == value then return end
	current_step = value
	return self:go_go()
end

local laystate = M.setfont(holder,21)
	laystate:SetPoint("TOPRIGHT",-38,-14)
	laystate:SetText("SLCT")
	
local _d = function(self) self.text:SetTextColor(0,1,1) end
local _p = function(self) self.text:SetTextColor(1,1,1) end
local crbutton = function(parent,t,change,x,y,point1,point2,functio)
	local f = CreateFrame("Frame",nil,parent)
	f:SetSize(30,30)
	f:SetFrameLevel(11)
	f:EnableMouse(true)
	local text = f:CreateFontString(nil,"OVERLAY")
	text:SetAllPoints()
	text:SetFont(M["media"].font_s,32)
	text:SetText(t)
	f.text = text
	f:SetPoint(point1,laystate,point2,x,y)
	f:SetScript("OnEnter",_d)
	f:SetScript("OnLeave",_p)
	f:SetScript("OnMouseDown",functio)
end
			
local bleft = crbutton(holder,"<",-1,2,-.5,"RIGHT","LEFT",function() teh_holder:back() end)
local bright = crbutton(holder,">",1,-2,-.5,"LEFT","RIGHT",function() teh_holder:next() end); crbutton = nil;	

local menuFrame = M.menuframe
local menu_table = {}
for i=0, #title_table do
	menu_table[i+1] = {text = title_table[i], func = function() teh_holder:cost(i) end, notCheckable = 1}
end

local bt = CreateFrame("Frame",nil,holder); bt.text = laystate
bt:SetAllPoints(laystate)
bt:EnableMouse(true)
bt:SetScript("OnMouseDown",function()
	EasyMenu(menu_table, menuFrame, "cursor", 0, 0, "MENU", 2)
end)
bt:SetScript("OnEnter",_d)
bt:SetScript("OnLeave",_p)

--[[-- NOW THE SETTINGS --]]--

local cc = 0
local c_c = 0
local gen_basics = function()
	local frame = CreateFrame("Frame",nil,teh_holder);
	frame:SetSize(step,428)
	frame:SetFrameLevel(level)
	frame:SetFrameStrata(strata)
	frame:SetPoint("LEFT",step * cc, 0); cc = cc + 1; c_c = 0
	return frame
end

local off_point = function(x)
	c_c = c_c + x; return c_c;
end

local var_width = step-4

local make_str = function(frame,x,_table,name,title,setting)
	local tt = M.setfont(frame,21)
		tt:SetPoint("TOPLEFT",6,-x)
		tt:SetText(title)
	local ttcur = M.point_menu(frame,_table,name,setting)
		ttcur:SetPoint("TOPRIGHT",-6,-x)
end


-- [0] COMMON
local frame = gen_basics()

M.makevarbar(frame, var_width, 0, 100, V['common'], "updatemod", "SMOOTH UPDATE MODIFIER", .1):SetPoint("TOP",0,-off_point(4))

local st = {
	["popup"] = "POPUP MENU",
	["partyraid"] = "SHOW PARTY IN RAID",
	["spellrange"] = "SPELL RANGE FADE",}
	
M.tweaks_mvn(frame,V['common'],st,off_point(52))


-- [1] PLAYER: COMMON
local frame = gen_basics()

local player = V['player']
		
local a = M.makevarbar(frame, var_width, 32, 512, player, "w", "INITIAL WIDTH", 1)
a:SetPoint("TOP",0,-off_point(4))
local b = M.makevarbar(frame, var_width, 32, 512, player, "h", "INITIAL HEIGHT", 1)
b:SetPoint("TOP",a,"BOTTOM")
local c = M.makevarbar(frame, var_width, -1, 100, player, "lowhealth", "LOW HEATH FLASH INIT", 1)
c:SetPoint("TOP",b,"BOTTOM")
local d = M.makevarbar(frame, var_width, -1, 100, player, "lowmana", "LOW MANA FLASH INIT", 1)
d:SetPoint("TOP",c,"BOTTOM")
local e = M.makevarbar(frame, var_width, 12, 64, player, "isf_height", "INFO PANEL HEIGHT", 1)
e:SetPoint("TOP",d,"BOTTOM")
local g = M.makevarbar(frame, var_width, 0, 60, player, "isf_offset", "INFO TEXT OFFSET", 1)
g:SetPoint("TOP",e,"BOTTOM")
local f = M.makevarbar(frame, var_width, 2, 64, player, "ph", "POWER PANEL HEIGHT", 1)
f:SetPoint("TOP",g,"BOTTOM")

local st = {
	["enable"] = "ENABLE PLAYER FRAME",
	["exp"] = "EXPERIENCE BAR",
	["rep"] = "REPUTATION BAR",
	["runes"] = "RUNES",
	["shards"] = "SHARDS",
	["totem"] = "TOTEMS",
	["combatfeedback"] = "COMBAT FEEDBACK",
	["eclipse"] = "ECLIPSE BAR",
	["hunter"] = "HUNTER BAR",}
	
M.tweaks_mvn(frame,player,st,off_point(256))
make_str(frame,off_point(146),player,"isf_pos","PLAYER INFO POSITION:",{nil,true,nil,nil,nil,nil,nil,true}) 


-- [2] PLAYER: CASTBAR
local frame = gen_basics()

local a = M.makevarbar(frame, var_width, 8, 64, player, "iconsize", "CASTBAR ICON SIZE", 1)
a:SetPoint("TOP",0,-off_point(4))
local b = M.makevarbar(frame, var_width, 32, 512, player, "cast_w", "CASRBAR WIDTH", 1)
b:SetPoint("TOP",a,"BOTTOM")
local c = M.makevarbar(frame, var_width, 0, 128, player, "cast_h", "CASTBAR HEIGHT", 1)
c:SetPoint("TOP",b,"BOTTOM")
local e = M.makevarbar(frame, var_width, 12, 64, player, "cast_font", "CASTBAR FONTSIZE", 1)
e:SetPoint("TOP",c,"BOTTOM")
local g = M.makevarbar(frame, var_width, 0, 40, player, "cast_offset", "CASTBAR TEXT OFFSET", .1)
g:SetPoint("TOP",e,"BOTTOM")

local st = {
	["icon"] = "CASTBAR ICON",
	["safezone"] = "CASTBAR SAFEZONE",}
	
M.tweaks_mvn(frame,player,st,off_point(188))


---------------- BUFFS|DEBUFFS TEMPLATE ------------------
local mk_bufffs = function(target,fix)
	local frame = gen_basics()

	local up = string.upper
	
	local a = M.makevarbar(frame, var_width, 0, 64, target, fix.."buffsmax", up(fix).."MAX BUFFS", 1)
	a:SetPoint("TOP",0,-off_point(4))
	local b = M.makevarbar(frame, var_width, 12, 64, target, fix.."buffs_size", up(fix).."BUFFS SIZE", 1)
	b:SetPoint("TOP",a,"BOTTOM")
	local a = M.makevarbar(frame, var_width, 8, 32, target, fix.."buffs_num_cd_size", up(fix).."BUFFS CD SIZE", 1)
	a:SetPoint("TOP",b,"BOTTOM")
	local b = M.makevarbar(frame, var_width, -40, 40, target, fix.."buffs_num_cd_pos_x", up(fix).."BUFFS CD X OFFSET", .1)
	b:SetPoint("TOP",a,"BOTTOM")
	local a = M.makevarbar(frame, var_width, -40, 40, target, fix.."buffs_num_cd_pos_y", up(fix).."BUFFS CD Y OFFSET", .1)
	a:SetPoint("TOP",b,"BOTTOM")
	local b = M.makevarbar(frame, var_width, 8, 32, target, fix.."buffs_count_size", up(fix).."BUFFS COUNT SIZE", 1)
	b:SetPoint("TOP",a,"BOTTOM")
	local a = M.makevarbar(frame, var_width, -40, 40, target, fix.."buffs_count_pos_x", up(fix).."BUFFS COUNT X OFFSET", .1)
	a:SetPoint("TOP",b,"BOTTOM")
	local b = M.makevarbar(frame, var_width, -40, 40, target, fix.."buffs_count_pos_y", up(fix).."BUFFS COUNT Y OFFSET", .1)
	b:SetPoint("TOP",a,"BOTTOM")

	local st = {
		[fix.."buffs_gray"] = "GRAY "..up(fix).."BUFFS",
		[fix.."buffs_show_numcd"] = "NUMCD ON "..up(fix).."BUFFS",
		[fix.."buffs_show_cd"] = "CD ON "..up(fix).."BUFFS",
		[fix.."buffs"] = "ENABLE "..up(fix).."BUFFS",}
		
	M.tweaks_mvn(frame,target,st,off_point(290))

	make_str(frame,off_point(75),target,fix.."buffspos",up(fix).."BUFFS POSITION:",{nil,true,nil,nil,nil,nil,nil,true}) --(x,_table,name,title,setting)
	make_str(frame,off_point(29),target,fix.."buffsgr_x",up(fix).."BUFFS DIRECTION:",{nil,nil,nil,true,nil,true}) --(x,_table,name,title,setting)
	make_str(frame,off_point(29),target,fix.."buffs_num_cd_pos",up(fix).."BUFFS CDNUM POSITION:",{true,true,true,true,true,true,true,true,true}) --(x,_table,name,title,setting)
	make_str(frame,off_point(29),target,fix.."buffs_count_pos",up(fix).."BUFFS COUNT POSITION:",{true,true,true,true,true,true,true,true,true}) --(x,_table,name,title,setting)
end


-- [3] PLAYER: BUFFS
mk_bufffs(player,"")


-- [4] PLAYER: DEBUFFS
mk_bufffs(player,"de")


-- [5] TARGET: COMMON
local frame = gen_basics()

local target = V['target']

local a = M.makevarbar(frame, var_width, 32, 512, target, "w", "INITIAL WIDTH", 1)
a:SetPoint("TOP",0,-off_point(4))
local b = M.makevarbar(frame, var_width, 32, 512, target, "h", "INITIAL HEIGHT", 1)
b:SetPoint("TOP",a,"BOTTOM")
local c = M.makevarbar(frame, var_width, -1, 100, target, "lowhealth", "LOW HEATH FLASH INIT", 1)
c:SetPoint("TOP",b,"BOTTOM")
local e = M.makevarbar(frame, var_width, 12, 64, target, "isf_height", "INFO PANEL HEIGHT", 1)
e:SetPoint("TOP",c,"BOTTOM")
local g = M.makevarbar(frame, var_width, 0, 60, target, "isf_offset", "INFO TEXT OFFSET", 1)
g:SetPoint("TOP",e,"BOTTOM")
local f = M.makevarbar(frame, var_width, 2, 64, target, "ph", "POWER PANEL HEIGHT", 1)
f:SetPoint("TOP",g,"BOTTOM")

local st = {
	["enable"] = "ENABLE TARGET FRAME",
	["combatfeedback"] = "COMBAT FEEDBACK",
	["hsmooth"] = "SMOOTH BAR",}
	
M.tweaks_mvn(frame,target,st,off_point(224))

make_str(frame,off_point(61),target,"isf_pos","TARGET INFO POSITION:",{nil,true,nil,nil,nil,nil,nil,true}) --(x,_table,name,title,setting)


-- [6] TARGET: CASTBAR
local frame = gen_basics()

local a = M.makevarbar(frame, var_width, 8, 64, target, "iconsize", "CASTBAR ICON SIZE", 1)
a:SetPoint("TOP",0,-off_point(4))
local b = M.makevarbar(frame, var_width, 32, 512, target, "cast_w", "CASRBAR WIDTH", 1)
b:SetPoint("TOP",a,"BOTTOM")
local c = M.makevarbar(frame, var_width, 0, 128, target, "cast_h", "CASTBAR HEIGHT", 1)
c:SetPoint("TOP",b,"BOTTOM")
local e = M.makevarbar(frame, var_width, 12, 64, target, "cast_font", "CASTBAR FONTSIZE", 1)
e:SetPoint("TOP",c,"BOTTOM")
local g = M.makevarbar(frame, var_width, 0, 4, target, "cast_offset", "CASTBAR TEXT OFFSET", .1)
g:SetPoint("TOP",e,"BOTTOM")

local st = {
	["icon"] = "CASTBAR ICON",}
	
M.tweaks_mvn(frame,target,st,off_point(188))


-- [7] TARGET: BUFFS
mk_bufffs(target,"")


-- [8] TARGET: DEBUFFS
mk_bufffs(target,"de")


-- [9] FOCUS: COMMON
local frame = gen_basics()

local target = V['focus']

local a = M.makevarbar(frame, var_width, 32, 512, target, "w", "INITIAL WIDTH", 1)
a:SetPoint("TOP",0,-off_point(4))
local b = M.makevarbar(frame, var_width, 32, 512, target, "h", "INITIAL HEIGHT", 1)
b:SetPoint("TOP",a,"BOTTOM")
local c = M.makevarbar(frame, var_width, -1, 100, target, "lowhealth", "LOW HEATH FLASH INIT", 1)
c:SetPoint("TOP",b,"BOTTOM")
local e = M.makevarbar(frame, var_width, 12, 64, target, "isf_height", "INFO PANEL HEIGHT", 1)
e:SetPoint("TOP",c,"BOTTOM")
local g = M.makevarbar(frame, var_width, 0, 60, target, "isf_offset", "INFO TEXT OFFSET", 1)
g:SetPoint("TOP",e,"BOTTOM")
local f = M.makevarbar(frame, var_width, 2, 64, target, "pw", "POWER PANEL WIDTH", 1)
f:SetPoint("TOP",g,"BOTTOM")

local st = {
	["enable"] = "ENABLE FOCUS FRAME",
	["combatfeedback"] = "COMBAT FEEDBACK",
	["hsmooth"] = "SMOOTH BAR",}
	
M.tweaks_mvn(frame,target,st,off_point(224))

make_str(frame,off_point(61),target,"isf_pos","FOCUS INFO POSITION:",{nil,true,nil,nil,nil,nil,nil,true}) --(x,_table,name,title,setting)
make_str(frame,off_point(29),target,"power_pos","FOCUS POWER POSITION:",{nil,nil,nil,true,nil,true}) --(x,_table,name,title,setting)


-- [10] FOCUS: CAST BAR
local frame = gen_basics()

local a = M.makevarbar(frame, var_width, 8, 64, target, "iconsize", "CASTBAR ICON SIZE", 1)
a:SetPoint("TOP",0,-off_point(4))
local b = M.makevarbar(frame, var_width, 32, 512, target, "cast_w", "CASRBAR WIDTH", 1)
b:SetPoint("TOP",a,"BOTTOM")
local c = M.makevarbar(frame, var_width, 0, 128, target, "cast_h", "CASTBAR HEIGHT", 1)
c:SetPoint("TOP",b,"BOTTOM")
local e = M.makevarbar(frame, var_width, 12, 64, target, "cast_font", "CASTBAR FONTSIZE", 1)
e:SetPoint("TOP",c,"BOTTOM")
local g = M.makevarbar(frame, var_width, 0, 4, target, "cast_offset", "CASTBAR TEXT OFFSET", .1)
g:SetPoint("TOP",e,"BOTTOM")

local st = {
	["icon"] = "FOCUS CASTBAR ICON",}

M.tweaks_mvn(frame,target,st,off_point(188))


-- [11] FOCUS: BUFFS
mk_bufffs(target,"")


-- [12] FOCUS: DEBUFFS
mk_bufffs(target,"de")


-- [13] PET: COMMON
local frame = gen_basics()

local target = V['pet']
		
local a = M.makevarbar(frame, var_width, 32, 512, target, "w", "INITIAL WIDTH", 1)
a:SetPoint("TOP",0,-off_point(4))
local b = M.makevarbar(frame, var_width, 32, 512, target, "h", "INITIAL HEIGHT", 1)
b:SetPoint("TOP",a,"BOTTOM")
local c = M.makevarbar(frame, var_width, -1, 100, target, "lowhealth", "LOW HEATH FLASH INIT", 1)
c:SetPoint("TOP",b,"BOTTOM")
local e = M.makevarbar(frame, var_width, 12, 64, target, "isf_height", "INFO PANEL HEIGHT", 1)
e:SetPoint("TOP",c,"BOTTOM")
local g = M.makevarbar(frame, var_width, 0, 60, target, "isf_offset", "INFO TEXT OFFSET", 1)
g:SetPoint("TOP",e,"BOTTOM")
local f = M.makevarbar(frame, var_width, 2, 64, target, "pw", "POWER PANEL WIDTH", 1)
f:SetPoint("TOP",g,"BOTTOM")

local st = {
	["enable"] = "ENABLE PET FRAME",
	["combatfeedback"] = "COMBAT FEEDBACK",
	["hsmooth"] = "SMOOTH BAR",}
	
M.tweaks_mvn(frame,target,st,off_point(224))

make_str(frame,off_point(61),target,"isf_pos","PET INFO POSITION:",{nil,true,nil,nil,nil,nil,nil,true}) --(x,_table,name,title,setting)
make_str(frame,off_point(29),target,"power_pos","PET POWER POSITION:",{nil,nil,nil,true,nil,true}) --(x,_table,name,title,setting)


-- [14] PET: CAST BAR
local frame = gen_basics()

local a = M.makevarbar(frame, var_width, 8, 64, target, "iconsize", "CASTBAR ICON SIZE", 1)
a:SetPoint("TOP",0,-off_point(4))
local b = M.makevarbar(frame, var_width, 32, 512, target, "cast_w", "CASRBAR WIDTH", 1)
b:SetPoint("TOP",a,"BOTTOM")
local c = M.makevarbar(frame, var_width, 0, 128, target, "cast_h", "CASTBAR HEIGHT", 1)
c:SetPoint("TOP",b,"BOTTOM")
local e = M.makevarbar(frame, var_width, 12, 64, target, "cast_font", "CASTBAR FONTSIZE", 1)
e:SetPoint("TOP",c,"BOTTOM")
local g = M.makevarbar(frame, var_width, 0, 4, target, "cast_offset", "CASTBAR TEXT OFFSET", .1)
g:SetPoint("TOP",e,"BOTTOM")

local st = {
	["icon"] = "PET CASTBAR ICON",}
	
-- [15] PET: BUFFS
mk_bufffs(target,"")


-- [16] PET: DEBUFFS
mk_bufffs(target,"de")


-- [17] TARGETTARGET
local frame = gen_basics()

local target = V['targettarget']
		
local a = M.makevarbar(frame, var_width, 32, 512, target, "w", "INITIAL WIDTH", 1)
a:SetPoint("TOP",0,-off_point(4))
local b = M.makevarbar(frame, var_width, 32, 512, target, "h", "INITIAL HEIGHT", 1)
b:SetPoint("TOP",a,"BOTTOM")
local c = M.makevarbar(frame, var_width, -1, 100, target, "lowhealth", "LOW HEATH FLASH INIT", 1)
c:SetPoint("TOP",b,"BOTTOM")
local e = M.makevarbar(frame, var_width, 12, 64, target, "isf_height", "INFO PANEL HEIGHT", 1)
e:SetPoint("TOP",c,"BOTTOM")
local g = M.makevarbar(frame, var_width, 0, 60, target, "isf_offset", "INFO TEXT OFFSET", 1)
g:SetPoint("TOP",e,"BOTTOM")
local f = M.makevarbar(frame, var_width, 2, 64, target, "pw", "POWER PANEL WIDTH", 1)
f:SetPoint("TOP",g,"BOTTOM")

local st = {
	["enable"] = "ENABLE TARGETTARGET FRAME",
	["combatfeedback"] = "COMBAT FEEDBACK",
	["hsmooth"] = "SMOOTH BAR",}
	
M.tweaks_mvn(frame,target,st,off_point(224))

make_str(frame,off_point(61),target,"isf_pos","TARGETTARGET INFO POSITION:",{nil,true,nil,nil,nil,nil,nil,true}) --(x,_table,name,title,setting)
make_str(frame,off_point(29),target,"power_pos","TARGETTARGET POWER POSITION:",{nil,nil,nil,true,nil,true}) --(x,_table,name,title,setting)


-- [18] FOCUSTARGET
local frame = gen_basics()

local target = V['focustarget']
		
local a = M.makevarbar(frame, var_width, 32, 512, target, "w", "INITIAL WIDTH", 1)
a:SetPoint("TOP",0,-off_point(4))
local b = M.makevarbar(frame, var_width, 32, 512, target, "h", "INITIAL HEIGHT", 1)
b:SetPoint("TOP",a,"BOTTOM")
local c = M.makevarbar(frame, var_width, -1, 100, target, "lowhealth", "LOW HEATH FLASH INIT", 1)
c:SetPoint("TOP",b,"BOTTOM")
local e = M.makevarbar(frame, var_width, 12, 64, target, "isf_height", "INFO PANEL HEIGHT", 1)
e:SetPoint("TOP",c,"BOTTOM")
local g = M.makevarbar(frame, var_width, 0, 60, target, "isf_offset", "INFO TEXT OFFSET", 1)
g:SetPoint("TOP",e,"BOTTOM")
local f = M.makevarbar(frame, var_width, 2, 64, target, "pw", "POWER PANEL WIDTH", 1)
f:SetPoint("TOP",g,"BOTTOM")

local st = {
	["enable"] = "ENABLE FOCUSTARGET FRAME",
	["combatfeedback"] = "COMBAT FEEDBACK",
	["hsmooth"] = "SMOOTH BAR",}
	
M.tweaks_mvn(frame,target,st,off_point(224))

make_str(frame,off_point(61),target,"isf_pos","FOCUSTARGET INFO POSITION:",{nil,true,nil,nil,nil,nil,nil,true}) --(x,_table,name,title,setting)
make_str(frame,off_point(29),target,"power_pos","FOCUSTARGET POWER POSITION:",{nil,nil,nil,true,nil,true}) --(x,_table,name,title,setting)