local W,M,L,V = unpack(select(2,...))

M.addlast(function()
	for _,i in pairs({
		"Portrait",
		"Health",
		"Power",
		"Info",
		"Feed",
		"Experience",
		"Reputation",
		"SpellRange",
		"Totems",
		"Runes",
		"Shards",
		"SetAnim",
		"make_mask",
		"Spawn",
		"druid",
		"SniperOn",
		"SniperOff",
		"Threat",
		"ThreatBar",
		"Castbar",
		"AurasUnchor",
		"Auras",
		"player_combat",
		"target_afk",
	}) do W[i] = nil end
end)
