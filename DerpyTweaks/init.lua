-- local C,M,L,V = unpack(select(2,...)) --

local ns = select(2,...)
ns[1] = {}
ns[2] = DerpyData[1]
ns[3] = DerpyData[2]

if not _G.DerpyTweaksVar then
	_G.DerpyTweaksVar = {
		["watch_frame"] = true,
		["commonskin"] = true,
		["combat"] = true,
		["minor"] = true,
		["shadow"] = true,
		["error"] = true,
		["loot"] = true,
		["lootroll"] = true,
		["tooltip_show_hp"] = true,
		["tooltip_hide_in_combat"] = false,
		["tooltip"] = true,
	}
end

ns[4] = _G.DerpyTweaksVar

