local C,M,L,V = unpack(select(2,...))

if V.hide_chat_junk then
	local f = function() return true end;
	ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_JOIN",f);
	ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_LEAVE",f);
	ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_NOTICE",f);
	ChatFrame_AddMessageEventFilter("CHAT_MSG_AFK",f);
	ChatFrame_AddMessageEventFilter("CHAT_MSG_DND",f);
	DUEL_WINNER_KNOCKOUT, DUEL_WINNER_RETREAT = "", "";
	DRUNK_MESSAGE_ITEM_OTHER1 = "";
	DRUNK_MESSAGE_ITEM_OTHER2 = "";
	DRUNK_MESSAGE_ITEM_OTHER3 = "";
	DRUNK_MESSAGE_ITEM_OTHER4 = "";
	DRUNK_MESSAGE_OTHER1 = "";
	DRUNK_MESSAGE_OTHER2 = "";
	DRUNK_MESSAGE_OTHER3 = "";
	DRUNK_MESSAGE_OTHER4 = "";
	DRUNK_MESSAGE_ITEM_SELF1 = "";
	DRUNK_MESSAGE_ITEM_SELF2 = "";
	DRUNK_MESSAGE_ITEM_SELF3 = "";
	DRUNK_MESSAGE_ITEM_SELF4 = "";
	DRUNK_MESSAGE_SELF1 = "";
	DRUNK_MESSAGE_SELF2 = "";
	DRUNK_MESSAGE_SELF3 = "";
	DRUNK_MESSAGE_SELF4 = "";
	RAID_MULTI_LEAVE = "";
	RAID_MULTI_JOIN = "";
	ERR_PET_LEARN_ABILITY_S = "";
	ERR_PET_LEARN_SPELL_S = "";
	ERR_PET_SPELL_UNLEARNED_S = "";
	CHAT_BATTLEGROUND_GET = "|Hchannel:Battleground|h".."[BG]".."|h %s:\32";
	CHAT_BATTLEGROUND_LEADER_GET = "|Hchannel:Battleground|h".."[BG]".."|h %s:\32";
	CHAT_BN_WHISPER_GET = "%s:\32";
	CHAT_GUILD_GET = "|Hchannel:Guild|h".."[G]".."|h %s:\32";
	CHAT_OFFICER_GET = "|Hchannel:o|h".."[O]".."|h %s:\32";
	CHAT_PARTY_GET = "|Hchannel:Party|h".."[P]".."|h %s:\32";
	CHAT_PARTY_GUIDE_GET = "|Hchannel:party|h".."[P]".."|h %s:\32";
	CHAT_PARTY_LEADER_GET = "|Hchannel:party|h".."[P]".."|h %s:\32";
	CHAT_RAID_GET = "|Hchannel:raid|h".."[R]".."|h %s:\32";
	CHAT_RAID_LEADER_GET = "|Hchannel:raid|h".."[R]".."|h %s:\32";
	CHAT_RAID_WARNING_GET = "[W]".." %s:\32";
	CHAT_SAY_GET = "%s:\32";
	CHAT_WHISPER_GET = "%s:\32";
	CHAT_YELL_GET = "%s:\32";
	CHAT_FLAG_AFK = "|cffFF0000".."[AFK]".."|r ";
	CHAT_FLAG_DND = "|cffE7E716".."[DND]".."|r ";
	CHAT_FLAG_GM = "|cff4154F5".."[GM]".."|r ";
	ERR_FRIEND_ONLINE_SS = "|Hplayer:%s|h[%s]|h ".."|cff298F00online|r";
	ERR_FRIEND_OFFLINE_S = "%s ".."|cffff0000offline|r";
end