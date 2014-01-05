local unpack = unpack
local C,M,L,V = unpack(select(2,...))

C.FirstFrameChat = M.frame(UIParent,2,nil,nil,nil,nil,"FirstFrameChat")
C.SecondFrameChat = M.frame(UIParent,2,nil,nil,nil,nil,"SecondFrameChat")

C.FirstFrameChat:SetSize(V.ch_w,32)
C.SecondFrameChat:SetSize(V.ch_w,32)

C.FirstFrameChat:SetPoint("BOTTOMLEFT",2,2)
C.SecondFrameChat:SetPoint("BOTTOMRIGHT",-2,2)

local chat = M.make_settings_template("CHAT",250,700)

-- Remake needed
local st = {
	["hide_chat_junk"] = "HIDE CHAT JUNK",
	["hyperlinks_show_brakets"] = "HYPER LINKS BRACKETS",
	["hyperlinks"] = "HYPER LINKS",
	["chatplayer"] = "HIGHLIGHT PLAYER NAME",
	["fit_action"] = "FIT TO ACTIONBARS",
	["fit_normal"] = "FIT TO CENTER OFFSET",
	["force_font_size"] = "FORCE FONT SIZE",
	["watch_frame_alt"] = "WATCHFRAME ALT HOLDER",
}
	
local tems = function(self,r,g,b,point1,point2,x,y)
	local a = self:CreateTexture(nil,"BORDER")
	a:SetPoint(point1,x or 0,y or 0)
	a:SetPoint(point2,x or 0,y or 0)
	a:SetSize(1,1)
	a:SetTexture(M.media.blank)
	a:SetVertexColor(r or 1,g or 1,b or 1)
end

local mk_settings_help = function(w,r,g,b)
	local self = CreateFrame("Frame",nil,chat)
	self:SetFrameLevel(20)
	self:SetFrameStrata("LOW")
	self:SetSize(w-6,200)
		
	tems(self,r,g,b,"TOPLEFT","BOTTOMLEFT")
	tems(self,r,g,b,"BOTTOMRIGHT","TOPRIGHT")
	tems(self,r,g,b,"TOPRIGHT","TOPLEFT",0,-20)
	
	return self
end 	
	
local left_config = mk_settings_help(V.ch_w)
local right_config = mk_settings_help(V.ch_w)
	left_config:SetPoint("BOTTOMLEFT",C.FirstFrameChat,5,5)
	right_config:SetPoint("BOTTOMRIGHT",C.SecondFrameChat,-5,5)
	
local left_side = mk_settings_help(V.side_width,0,1,0)
local right_side = mk_settings_help(V.side_width,0,1,0)
	left_side:SetPoint("BOTTOMLEFT",left_config,"BOTTOMRIGHT",4,0)
	right_side:SetPoint("BOTTOMRIGHT",right_config,"BOTTOMLEFT",-4,0)

local bottom = mk_settings_help(V.center_offset+14,1,1,0)
	bottom:SetPoint("BOTTOM",UIParent,0,5)
	bottom:SetHeight(220)
	bottom:SetFrameStrata("MEDIUM")
	
local g = M.setfont(chat,21)
g:SetPoint("TOP",0,-14)
g:SetText("FLASHTAB BLACK LIST")	
	
M.addafter(function()
	local st_colors = M["media"].button
	local ccheck = function(self)
		if V.flash_blacklist[self.num] == true then
			self:SetBackdropColor(unpack(st_colors[2]))
			self:SetBackdropBorderColor(unpack(st_colors[2]))
		else
			self:SetBackdropColor(unpack(st_colors[1]))
			self:SetBackdropBorderColor(unpack(st_colors[1]))
		end
	end
		
	local push = function(self)
		if V.flash_blacklist[self.num] == true then
			V.flash_blacklist[self.num] = false
		else
			V.flash_blacklist[self.num] = true
		end
		ccheck(self)
	end

	local mk_swich_bt = function(frame,p)
		local bt = CreateFrame("Frame",nil,frame)
			bt:SetFrameLevel(frame:GetFrameLevel()+4)
			bt:SetSize(35,11)
			bt:SetBackdrop(M.bg)
			bt:SetPoint("RIGHT",-8,0)
			bt.num = p
			ccheck(bt)
			bt:EnableMouse(true)
			bt:SetScript("OnMouseDown",push)
		return frame
	end

	local frames__ = {}
	for o = 1, #V.flash_blacklist do
		if o ~= 2 then
			local f = M.frame(chat,chat:GetFrameLevel()+4,"HIGH")
				f:SetSize(220,20)
			local b = mk_swich_bt(f,o)
			local a = M.setfont_lang(f,12)
				a:SetText(_G["ChatFrame"..o.."Tab"]:GetText())
				a:SetPoint("LEFT",7,1)
				a:SetPoint("RIGHT",-43,1)
			if o == 1 then
				f:SetPoint("TOP",chat,0,-44)
			elseif o == 3 then
				f:SetPoint("TOP",frames__[o-2],"BOTTOM",0,2)
			else
				f:SetPoint("TOP",frames__[o-1],"BOTTOM",0,2)
			end
			frames__[o] = f
		end
	end
	
	local convo = M.frame(chat,chat:GetFrameLevel()+4,"HIGH")
	convo:SetSize(220,20)
	local b = mk_swich_bt(convo,2)
	local a = M.setfont(convo,12)
	a:SetText("RealID Conversation")
	a:SetPoint("LEFT",7,1)
	a:SetPoint("RIGHT",-43,1)

	convo:SetPoint("TOP",frames__[#V.flash_blacklist],"BOTTOM",0,2)
	
	local num = {"ch_w","ch_max","ch_min","side_width","center_offset","font_size","watch_frame_h","watch_frame_w"}
	
	local names = {
		["ch_w"] = "CHAT WIDTH",
		["ch_max"] = "CHAT MAX HEIGHT PRESET",
		["ch_min"] = "CHAT MIN HEIGHT PRESET",
		["side_width"] = "SIDE PANEL WIDTH",
		["center_offset"] = "CENTER OFFSET RATIO",
		["font_size"] = "FORSED FONT SIZE",
		["watch_frame_h"] = "WHATCH FRAME ALT HEIGHT",
		["watch_frame_w"] = "WHATCH FRAME ALT WIDTH",}
		
	local limits = {
		["ch_w"] = 1000,
		["ch_max"] = 512,
		["ch_min"] = 128,
		["side_width"] = 400,
		["center_offset"] = 1000,
		["font_size"] = 32,
		["watch_frame_h"] = 1024,
		["watch_frame_w"] = 256,}
		
	local pers	

	local funcs = {
		function() 
			left_config:SetWidth(V.ch_w-6)
			right_config:SetWidth(V.ch_w-6)
		end,
		C.mod_a,
		C.mod_a,
		function() 
			left_side:SetWidth(V.side_width-6)
			right_side:SetWidth(V.side_width-6)
		end,
		function()
			bottom:SetWidth(floor(V.center_offset/2)*2+8)
		end,
	}
	
	for i=1,8 do
		local p = num[i]
		local a = M.makevarbar(chat,238,i~=6 and 32 or 8,limits[p],V,p,names[p])
		if i == 1 then
			a:SetPoint("TOP",convo,0,-28)
		else
			a:SetPoint("TOP",pers,"BOTTOM")
		end
		a.mainbar.function_ = funcs[i]
		pers = a
	end
end)

M.tweaks_mvn(chat,V,st,518)

local nname = M.setfont(chat,15)
	nname:SetPoint("BOTTOMLEFT",14,32)
	nname:SetText("LEFT FRAME JUSTIFY:")

local nname1 = M.setfont(chat,15)
	nname1:SetPoint("TOPLEFT",nname,"BOTTOMLEFT",0,-3)
	nname1:SetText("RIGHT FRAME JUSTIFY:")
	
local _vert = {nil,nil,nil,true,true,true}	
	
local cdcur = M.point_menu(chat,V,"justy1",_vert,15)
	cdcur:SetPoint("BOTTOMRIGHT",-14,30)

local cdcur1 = M.point_menu(chat,V,"justy2",_vert,15)
	cdcur1:SetPoint("TOPLEFT",cdcur,"BOTTOMLEFT",0,-2)	
	
M.addenter(function()
	chat:SetScript("OnShow",C.enable_demo)
	chat:SetScript("OnHide",C.disable_demo)
end)