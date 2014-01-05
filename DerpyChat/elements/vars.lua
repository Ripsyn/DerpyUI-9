-- local C,M,L,V = unpack(select(2,...)) --

local ns = select(2,...)
ns[1] = {}
ns[2] = DerpyData[1]
ns[3] = DerpyData[2]

if not _G.DerpyChat then
	_G.DerpyChat = {
			
			["hyperlinks_show_brakets"] = false,
			["hide_chat_junk"] = true,
			["chatplayer"] = true,
			["show_flash"] = true,
			["hyperlinks"] = true,
			["fit_action"] = true,
			["fit_normal"] = false,
			
			["justy1"] = "LEFT",
			["justy2"] = "RIGHT",
			
			["ch_w"] = 300,
			["ch_max"] = 120,
			["ch_min"] = 48,
			["side_width"] = 180,
			["center_offset"] = 400,
			
			["side_state"] = {},
			
			["flash_blacklist"] = {
				[1] = false,
				[2] = false,
				[3] = false,
				[4] = false,
				[5] = false,
				[6] = false,
				[7] = false,
				[8] = false,
				[9] = false,
				[10] = false,
			},
			
			["chatcur"] = {
				[1] = 48,
				[2] = 48
			},
		
			["ChatBar"] = {
				{"CHAT_MSG_SAY","SAY","/s ",true},
				{"CHAT_MSG_PARTY","PARTY","/p ",true},
				{"CHAT_MSG_GUILD","GUILD","/g ",true},
				{"CHAT_MSG_RAID","RAID","/raid ",true},
				{"CHAT_MSG_YELL","YELL","/y ",true},
				{"CHAT_MSG_WHISPER","WHISPER","/w ",true},
				{"CHAT_MSG_BATTLEGROUND","BATTLEGROUND","/bg ",true},
			}
	}
end

-- Sorry Forget it :((
ns[4] = _G.DerpyChat
ns[4]["font_size"] = ns[2].check_nil(ns[4]["font_size"],12)
ns[4]["force_font_size"] = ns[2].check_nil(ns[4]["force_font_size"],false)
ns[4].center_offset = floor(ns[4].center_offset/2)*2
ns[4]["watch_frame_alt"] = ns[2].check_nil(ns[4]["watch_frame_alt"],false)
ns[4]["watch_frame_w"] = ns[2].check_nil(ns[4]["watch_frame_w"],256)
ns[4]["watch_frame_h"] = ns[2].check_nil(ns[4]["watch_frame_h"],468)

-- TEMP or not
ns[4]["justy1"] = ns[2].check_nil(ns[4]["justy1"],"LEFT")
ns[4]["justy2"] = ns[2].check_nil(ns[4]["justy2"],"RIGHT")