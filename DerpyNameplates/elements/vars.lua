-- local C,M,L,V = unpack(select(2,...)) --

local ns = select(2,...)
ns[1] = {}
ns[2] = DerpyData[1]
ns[3] = DerpyData[2]

if not _G.DerpyNameplates then
	_G.DerpyNameplates = {
		["nameplates_blacklist"] = {
			["Earth Elemental Totem"] = false,
			["Fire Elemental Totem"] = false,
			["Flametongue Totem"] = false,
			["Healing Stream Totem"] = false,
			["Magma Totem"] = false,
			["Mana Spring Totem"] = false,
			["Searing Totem"] = false,
			["Stoneclaw Totem"] = false,
			["Stoneskin Totem"] = false,
			["Strength of Earth Totem"] = false,
			["Windfury Totem"] = false,
			["Totem of Wrath"] = false,
			["Wrath of Air Totem"] = false,
			["Army of the Dead Ghoul"] = false,
			["Venomous Snake"] = false,
			["Viper"] = false,},
			
		["nameplates_showhealth"] = false,
		["nameplates_tank"] = false,
		["nameplates_enhancethreat"] = false,
		["nameplates_combat"] = false,
		["nameplates_hide_player_level"] = true,
		["nameplates_width"] = 100,
		["nameplates_height"] = 6,
		["nameplates_font_size"] = 12,
		["nameplates_edge"] = 4,
	}		
end

ns[4] = _G.DerpyNameplates