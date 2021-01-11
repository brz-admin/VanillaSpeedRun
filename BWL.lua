
local zone = AceLibrary("Babble-Zone-2.2")["Blackwing Lair"];
local boss = AceLibrary("Babble-Boss-2.2");
local L = AceLibrary("AceLocale-2.2"):new("VanillaSpeedRun"..zone);

VSR_BWL = VanillaSpeedRun:NewModule(zone);

function VSR_BWL:OnInitialize()
	self.core:RegisterModule(self.name, self)

	if (VSR[zone] == nil) then
		VSR[zone] = {
			['best'] 							= nil,
			[boss["Razorgore the Untamed"]] 	= nil,
			[boss["Vaelastrasz the Corrupt"]]   = nil,
			[boss["Broodlord Lashlayer"]]   	= nil,
			[boss["Firemaw"]]          			= nil,
			[boss["Ebonroc"]]          			= nil,
			[boss["Flamegor"]]          		= nil,
			[boss["Chromaggus"]]          		= nil,
			[boss["Nefarian"]]           		= nil,
		}
	end
end

function VSR_BWL:OnEnable()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "mobDeath")
	VSR_BWL:InitialiseRecord(zone, VSR[zone], boss["Nefarian"], {
		[1] = boss["Razorgore the Untamed"],
		[2] = boss["Vaelastrasz the Corrupt"],
		[3] = boss["Broodlord Lashlayer"],
		[4] = boss["Firemaw"],
		[5] = boss["Ebonroc"],
		[6] = boss["Flamegor"],
		[7] = boss["Chromaggus"],
		[8] = boss["Nefarian"],
	}, {
		[boss["Grethok the Controller"]] = true
	}, 8);
	self.core.VSR_MAIN_FRAME:SetScript("OnUpdate", function() self.Update() end)
end
