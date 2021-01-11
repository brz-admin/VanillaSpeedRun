local zone = AceLibrary("Babble-Zone-2.2")["Molten Core"];
local boss = AceLibrary("Babble-Boss-2.2");
local L = AceLibrary("AceLocale-2.2"):new("VanillaSpeedRun"..zone);

L:RegisterTranslations("enUS", function() return {
	["Molten Giant"] = true,
	executus_string = "Impossible! Stay your attack, mortals... I submit! I submit!"
} end)

L:RegisterTranslations("frFR", function() return {
	["Molten Giant"] = "Géant de lave",
	executus_string = "Impossible ! Retenez vos coups, mortels ! Je me rends ! Je me rends !"
} end)

VSR_MC = VanillaSpeedRun:NewModule(zone);

function VSR_MC:OnInitialize()
	self.core:RegisterModule(self.name, self)

	if (VSR[zone] == nil) then
		VSR[zone] = {
			['best'] 							= nil,
			[boss["Lucifron"]] 					= nil,
			[boss["Magmadar"]]   				= nil,
			[boss["Gehennas"]]   				= nil,
			[boss["Garr"]]          			= nil,
			[boss["Baron Geddon"]]          	= nil,
			[boss["Shazzrah"]]          		= nil,
			[boss["Sulfuron Harbinger"]]        = nil,
			[boss["Golemagg the Incinerator"]]  = nil,
			[boss["Majordomo Executus"]]        = nil,
			[boss["Ragnaros"]]  = nil,
		}
	end
end

function VSR_MC:OnEnable()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "mobDeath")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	VSR_MC:InitialiseRecord(zone, VSR[zone], boss["Ragnaros"], {
		[1] = boss["Lucifron"],
		[2] = boss["Magmadar"],
		[3] = boss["Gehennas"],
		[4] = boss["Garr"],
		[5] = boss["Baron Geddon"],
		[6] = boss["Shazzrah"],
		[7] = boss["Sulfuron Harbinger"],
		[8] = boss["Golemagg the Incinerator"],
		[9] = boss["Majordomo Executus"],
		[10] = boss["Ragnaros"],
	}, {
		[L["Molten Giant"]] = true
	}, 10);
	self.core.VSR_MAIN_FRAME:SetScript("OnUpdate", function() self.Update() end)
end

function VSR_MC:CHAT_MSG_MONSTER_YELL(msg)
	if (string.find(msg, L["executus_string"])) then
		self:genericBossDeath(string.format(UNITDIESOTHER, boss["Majordomo Executus"]))
	end
end