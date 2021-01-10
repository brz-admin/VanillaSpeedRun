
local zone = AceLibrary("Babble-Zone-2.2")["Blackwing Lair"];
local boss = AceLibrary("Babble-Boss-2.2");
local L = AceLibrary("AceLocale-2.2"):new("VanillaSpeedRun"..zone);

L:RegisterTranslations("enUS", function() return {
	["Obsidian Eradicator"] = true,
} end)

L:RegisterTranslations("frFR", function() return {
	["Obsidian Eradicator"] = "Eradicateur d'obsidienne",
} end)

VSR_AQ40 = VanillaSpeedRun:NewModule(zone);

function VSR_AQ40:OnInitialize()
	self.core:RegisterModule(self.name, self)

	if (VSR[zone] == nil) then
		VSR[zone] = {
			['best'] 							= nil,
			[boss["The Prophet Skeram"]] 		= nil,
			[boss["Battleguard Sartura"]]       = nil,
			[boss["Fankriss the Unyielding"]]   = nil,
			[boss["Princess Huhuran"]]          = nil,
			[boss["C'Thun"]]           			= nil,
		}
	end
end

function VSR_AQ40:CustomMobDeath(msg)
	if (msg == string.format(UNITDIESOTHER, boss["Emperor Vek'lor"])) then
		self:genericBossDeath(string.format(UNITDIESOTHER, boss["The Twin Emperors"]))
	end
end

function VSR_AQ40:OnEnable()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "mobDeath")
	VSR_AQ40:InitialiseRecord(zone, VSR[zone], boss["C'Thun"], {
		[1] = boss["The Prophet Skeram"],
		[2] = boss["Battleguard Sartura"],
		[3] = boss["Fankriss the Unyielding"],
		[4] = boss["Princess Huhuran"],
		[5] = boss["The Twin Emperors"],
		[6] = boss["C'Thun"],
	}, {
		[L["Obsidian Eradicator"]] = true
	}, 6);
	self.core.VSR_MAIN_FRAME:SetScript("OnUpdate", function() self.Update() end)
end
