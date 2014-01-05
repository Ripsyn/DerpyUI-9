--[[																
				      		   !         !          
                              ! !       ! !          
                             ! . !     ! . !          
                               ^^^^^^^^^ ^            
                             ^             ^          
                           ^  (0)       (0)  ^       
                          ^        ""         ^       
                         ^   ***************    ^     
                       ^   *                 *   ^    
                      ^   *   /\   /\   /\    *    ^   
                     ^   *                     *    ^
                    ^   *   /\   /\   /\   /\   *    ^
                   ^   *                         *    ^
                   ^  *                           *   ^
                   ^  *                           *   ^
                    ^ *                           *  ^  
                     ^*                           * ^ 
                      ^ *                        * ^
                      ^  *                      *  ^
                        ^  *       ) (         * ^
                            ^^^^^^^^ ^^^^^^^^^ 
					
--]]																

local M,L = unpack(select(2,...))

local frame = M.make_settings_template("MISCELLANEOUS",433,416)

local resetframe = M.frame(frame,frame:GetFrameLevel()+2,frame:GetFrameStrata())
resetframe:SetSize(140,224)
resetframe:SetPoint("TOPLEFT",4,-4)

local clean_table = function(self)
	if GetMouseFocus() ~= self then return end
	_G["Derpy"..self.name] = nil
	self:EnableMouse(false)
	self:backcolor(1,0,0,.8)
	self.text:SetTextColor(1,0,0)
end

local vars = {
	["AB"] = "ACTION BARS",
	["Nav"] = "NAVIGATION",
	["XCT"] = "COMBAT TEXT",
	["Chat"] = "CHAT",
	["Nameplates"] = "NAMEPLATES",
	["UF"] = "UNIT FRAMES",
	["PosVars"] = "POSITIONS",
}

local make = function(x,y)
	local f = M.frame(resetframe,resetframe:GetFrameLevel()+2,resetframe:GetFrameStrata())
	f:SetSize(120,28)
	local n = M.setfont(f,14)
	n:SetPoint("CENTER",.3,.3)
	n:SetText(y)
	f.text = n
	M.enterleave(f,1,0,0,true)
	f.name = x
	f:SetScript("OnMouseUp",clean_table)
	return f
end

local bt = {}

local reset_tite = M.setfont(resetframe,18)
reset_tite:SetPoint("TOP",.3,-9)
reset_tite:SetText("RESET SETTINGS")

for x,y in pairs(vars) do
	local t = #bt+1
	bt[t] = make(x,y)
	if t==1 then
		bt[t]:SetPoint("TOP",0,-32)
	else
		bt[t]:SetPoint("TOP",bt[t-1],"BOTTOM",0,2)
	end
end

---

local tweaks = M.frame(frame,frame:GetFrameLevel()+2,frame:GetFrameStrata())
tweaks:SetSize(280,224)
tweaks:SetPoint("TOPLEFT",resetframe,"TOPRIGHT",-2,0)

local tweaks_tite = M.setfont(tweaks,18)
tweaks_tite:SetPoint("TOPLEFT",11.3,-9)
tweaks_tite:SetText("TWEAKS")

M.addenter(function()
	if not DerpyTweaksVar then return end
		
	local st = {	
		["watch_frame"] = "WATCHFRAME SKIN",
		["commonskin"] = "COMMON SKIN",
		["combat"] = "COMBAT MSG",
		["minor"] = "MINOR BAR",
		["shadow"] = "SHADOW",
		["error"] = "ERRORS",
		["loot"] = "LOOT",
		["lootroll"] = "LOOT ROLL",
		["tooltip_show_hp"] = "TOOLTIP SHOW HP",
		["tooltip_hide_in_combat"] = "TOOLTIP HIDE IN COMBAT",
		["tooltip"] = "TOOLTIP",
	}
	
	M.tweaks_mvn(tweaks,DerpyTweaksVar,st,48)
end)

---

local common = M.frame(frame,frame:GetFrameLevel()+2,frame:GetFrameStrata())
common:SetSize(280,178)
common:SetPoint("TOP",tweaks,"BOTTOM",0,2)

local common_tite = M.setfont(common,18)
common_tite:SetPoint("TOPLEFT",11.3,-9)
common_tite:SetText("COMMON")

M.addenter(function()
	local st = {	
		["font_replace"] = "FONT REPLACE",
		["scale_lock"] = "LOCK UISCALE",
	}
	M.tweaks_mvn(common,_G.DerpyMediaVars,st,48)
	
	local a = M.makevarbar(common, 276, 0, 32, _G.DerpyMediaVars, "font_offset", "FONT SIZE OFFSET RATIO")	
	a:SetPoint("TOP",0,-90)
	local b = M.makevarbar(common, 276, 0, 200, _G.DerpyMediaVars, "layout_offset", "LAYOUT OFFSET RATIO")
	b:SetPoint("TOP",a,"BOTTOM")
end)

--- 

local other = M.frame(frame,frame:GetFrameLevel()+2,frame:GetFrameStrata())
other:SetSize(140,178)
other:SetPoint("TOP",resetframe,"BOTTOM",0,2)

local other_tite = M.setfont(other,18)
other_tite:SetPoint("TOPLEFT",11.3,-9)
other_tite:SetText("OTHER")

local al = function(name,val)
	print(name,"=",val..";")
	SetCVar(name,val)
end

local load_def_svars = function()
	al("removeChatDelay", 1)
	al("autoDismountFlying", 1)
	al("autoQuestWatch", 1)
	al("autoQuestProgress", 1)
	al("buffDurations", 1)
	al("lootUnderMouse", 1)
	al("bloatthreat", 0)
	al("bloattest", 0)
	al("bloatnameplates", 0)
	al("nameplateShowFriends", 0)
	al("nameplateShowFriendlyPets", 0)
	al("nameplateShowFriendlyGuardians", 0)
	al("nameplateShowFriendlyTotems", 0)
	al("nameplateShowEnemies", 1)
	al("nameplateShowEnemyPets", 1)
	al("nameplateShowEnemyGuardians", 1)
	al("nameplateShowEnemyTotems", 1)
	al("ShowClassColorInNameplate", 1)
end

local b = make(nil,"LOAD CVARS")
b:SetScript("OnMouseUp",function(self)
	if GetMouseFocus() ~= self then return end
	load_def_svars()
end)

b.b=1; b.g=1;
b:SetPoint("TOP",other,0,-32)

