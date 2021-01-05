
local zone = AceLibrary("Babble-Zone-2.2")["Naxxramas"];
local boss = AceLibrary("Babble-Boss-2.2");
local L = AceLibrary("AceLocale-2.2"):new("VanillaSpeedRun"..zone);

L:RegisterTranslations("enUS", function() return {
	-- DK start
	["|cFF73c5e6DeathKnight Wing|r"] = true,
    ["Death Knight"] = true,
    ["Risen Deathknight"] = true,
	-- ABO start
	["|cFF73c5e6Construction Quarter|r"] = true,
    ["Patchwork Golem"] = true,
	-- SPIDER Start
	["|cFF73c5e6Spider Wing|r"] = true,
    ["Poisonous Skitterer"] = true,
    ["Carrion Spinner"] = true,
    ["Dread Creeper"] = true,
    ["Venom Stalker"] = true,
	-- PLAGUE start
	["|cFF73c5e6Plague Wing|r"] = true,
    ["Infectious Ghoul"] = true,
    ["Plague Slime"] = true,
    ["Stoneskin Gargoyle"] = true
} end)

L:RegisterTranslations("frFR", function() return {
	-- DK start
	["|cFF73c5e6DeathKnight Wing|r"] = "|cFF73c5e6Aile des Chevaliers de la mort|r",
	["Death Knight"] = "Chevalier de la mort",
	["Risen Deathknight"] = "Chevalier de la mort ressuscité",
	-- ABO start
	["|cFF73c5e6Construction Quarter|r"] = "|cFF73c5e6Aile des Abominations|r",
	["Patchwork Golem"] = "Golem recousu",
	-- SPIDER Start
	["|cFF73c5e6Spider Wing|r"] = "|cFF73c5e6Aile des Araignées|r",
	["Poisonous Skitterer"] = "Glisseuse venimeuse",
	["Carrion Spinner"] = "Tisse-charogne",
	["Dread Creeper"] = "Rampant de l'effroi",
	["Venom Stalker"] = "Traque-venin",
	-- PLAGUE start
	["|cFF73c5e6Plague Wing|r"] = "|cFF73c5e6Aile de la Peste|r",
	["Infectious Ghoul"] = "Goule infectieuse",
	["Plague Slime"] = "Gelée de la peste",
	["Stoneskin Gargoyle"] = "Gargouille peau de pierre"
} end)

local plagueStart = {
	[boss["Noth the Plaguebringer"]]			= true,
	[L["Infectious Ghoul"]]						= true,
	[L["Plague Slime"]]							= true,
	[L["Stoneskin Gargoyle"]]					= true,
};

local dkStart = {
	[L["Death Knight"]]							= true,
	[L["Risen Deathknight"]]					= true,
}

local spiderStart = {
	[L["Poisonous Skitterer"]]					= true,
	[L["Carrion Spinner"]]						= true,
	[L["Dread Creeper"]]						= true,
	[L["Venom Stalker"]]						= true,
}

local hmDown = {
	[boss["Highlord Mograine"]] = false,
	[boss["Thane Korth'azz"]] 	= false,
	[boss["Lady Blaumeux"]] 	= false,
	[boss["Sir Zeliek"]] 		= false,
};
local plagueTimer, plagueRecording, aboTimer, aboRecording, spiderTimer, spiderRecording, dkTimer, dkRecording = 0, false, 0, false, 0, false, 0, false;

VSR_Naxx = VanillaSpeedRun:NewModule(zone);

function VSR_Naxx:OnInitialize()
	self.core:RegisterModule(self.name, self)

	if (VSR[zone] == nil) then
		VSR[zone] = {
			['best'] 									= nil,
			[L["|cFF73c5e6Construction Quarter|r"]] 	= nil,
			[boss["Patchwerk"]]							= nil,
			[boss["Grobbulus"]]							= nil,
			[boss["Gluth"]]								= nil,
			[boss["Thaddius"]]							= nil,
			[L["|cFF73c5e6DeathKnight Wing|r"]]			= nil,
			[boss["Instructor Razuvious"]]				= nil,
			[boss["Gothik the Harvester"]]				= nil,
			[boss["The Four Horsemen"]]					= nil,
			[L["|cFF73c5e6Plague Wing|r"]]				= nil,
			[boss["Noth the Plaguebringer"]]			= nil,
			[boss["Heigan the Unclean"]]				= nil,
			[boss["Loatheb"]]							= nil,
			[L["|cFF73c5e6Spider Wing|r"]]				= nil,
			[boss["Anub'Rekhan"]]						= nil,
			[boss["Grand Widow Faerlina"]]				= nil,
			[boss["Maexxna"]]							= nil,
			[boss["Sapphiron"]]							= nil,
			[boss["Kel'Thuzad"]]						= nil,
		}
	end

	print(self.name.." INIT");
end

function VSR_Naxx:UpdateWings(msg)

end

function VSR_Naxx:CustomMobDeath(msg)
	for hm,_ in pairs(hmDown) do
		if (msg == string.format(UNITDIESOTHER, hm)) then
			hmDown[hm] = true;
		end
	end
	
	
end

function VSR_Naxx:OnEnable()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "mobDeath")
	VSR_Naxx:InitialiseRecord(zone, VSR[zone], boss["Kel'Thuzad"], {
		[L["|cFF73c5e6Construction Quarter|r"]] 	= true,
		[boss["Patchwerk"]]							= true,
		[boss["Grobbulus"]]							= true,
		[boss["Gluth"]]								= true,
		[boss["Thaddius"]]							= true,
		[L["|cFF73c5e6DeathKnight Wing|r"]]			= true,
		[boss["Instructor Razuvious"]]				= true,
		[boss["Gothik the Harvester"]]				= true,
		[boss["The Four Horsemen"]]					= true,
		[L["|cFF73c5e6Plague Wing|r"]]				= true,
		[L["|cFF73c5e6Plague Wing|r"]]				= true,
		[boss["Noth the Plaguebringer"]]			= true,
		[boss["Heigan the Unclean"]]				= true,
		[boss["Loatheb"]]							= true,
		[L["|cFF73c5e6Spider Wing|r"]]				= true,
		[boss["Anub'Rekhan"]]						= true,
		[boss["Grand Widow Faerlina"]]				= true,
		[boss["Maexxna"]]							= true,
		[boss["Sapphiron"]]							= true,
		[boss["Kel'Thuzad"]]						= true,
	}, {
		[L["Death Knight"]]							= true,
		[L["Risen Deathknight"]]					= true,
		[L["Patchwork Golem"]]						= true,
		[L["Poisonous Skitterer"]]					= true,
		[L["Carrion Spinner"]]						= true,
		[L["Dread Creeper"]]						= true,
		[L["Venom Stalker"]]						= true,
		[L["Infectious Ghoul"]]						= true,
		[L["Plague Slime"]]							= true,
		[L["Stoneskin Gargoyle"]]					= true,
	}, 15);
	self.core.VSR_MAIN_FRAME:SetScript("OnUpdate", function() self.Update() self.UpdateWings() end)
end