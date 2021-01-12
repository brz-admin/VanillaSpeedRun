
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

local hmDown = {
	[boss["Highlord Mograine"]] = false,
	[boss["Thane Korth'azz"]] 	= false,
	[boss["Lady Blaumeux"]] 	= false,
	[boss["Sir Zeliek"]] 		= false,
};

local NaxSpec = {
	[L["|cFF73c5e6Plague Wing|r"]] = {
		timer = 0,
		recording = false,
		startTime = nil,
		firstMobs = {
			[boss["Noth the Plaguebringer"]]			= true,
			[L["Infectious Ghoul"]]						= true,
			[L["Plague Slime"]]							= true,
			[L["Stoneskin Gargoyle"]]					= true,
		},
		lastBoss = boss["Loatheb"]
	},
	[L["|cFF73c5e6Construction Quarter|r"]] = {
		timer = 0,
		recording = false,
		startTime = nil,
		firstMobs = {
			[L["Patchwork Golem"]] = true
		},
		lastBoss = boss["Thaddius"]
	},
	[L["|cFF73c5e6Spider Wing|r"]] = {
		timer = 0,
		recording = false,
		startTime = nil,
		firstMobs = {
			[L["Poisonous Skitterer"]]					= true,
			[L["Carrion Spinner"]]						= true,
			[L["Dread Creeper"]]						= true,
			[L["Venom Stalker"]]						= true,
		},
		lastBoss = boss["Maexxna"]
	},
	[L["|cFF73c5e6DeathKnight Wing|r"]] = {
		timer = 0,
		recording = false,
		startTime = nil,
		firstMobs = {
			[L["Death Knight"]]							= true,
			[L["Risen Deathknight"]]					= true,
		},
		lastBoss = boss["The Four Horsemen"];
	}
}

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
	
	if VSR["NaxxCurr"] == nil then
	    VSR["NaxxCurr"] = NaxSpec;
	end
end

function VSR_Naxx:UpdateWings(msg)
	for wing,_ in pairs(NaxSpec) do
		if NaxSpec[wing].recording and NaxSpec[wing].startTime ~= nil then
			NaxSpec[wing].timer = math.floor(GetTime())-NaxSpec[wing].startTime
			if NaxSpec[wing].timer < 0 then
				NaxSpec[wing].timer = 0
			end
			VanillaSpeedRun.VSR_SEGMENTS_tim[wing]:SetText(SecondsToClock(NaxSpec[wing].timer));
			VanillaSpeedRun.VSR_SEGMENTS_tim[wing]:SetTextColor(0.90, 0.45, 0.45, 1);
		end
	end
end

function VSR_Naxx:HandleWingsEnd(locale, timer)
	if (VSR[zone][locale] ~= nil) then
		if (VSR[zone][locale] > timer) then
			local diff = VSR[zone][locale] -  timer;
			VanillaSpeedRun.VSR_SEGMENTS_tim[locale]:SetText(SecondsToClo(timer)..' (-'..STC_MIN(diff)..')');
			VanillaSpeedRun.VSR_SEGMENTS_tim[locale]:SetTextColor(0.45, 0.90, 0.45, 1);
			VSR[zone][locale] =  timer;
		else 
			local diff =   timer - VSR[zone][locale];
			VanillaSpeedRun.VSR_SEGMENTS_tim[locale]:SetText(SecondsToClock(timer)..' (+'..STC_MIN(diff)..')');
			VanillaSpeedRun.VSR_SEGMENTS_tim[locale]:SetTextColor(0.90, 0.45, 0.45, 1);
		end
	else 
		VanillaSpeedRun.VSR_SEGMENTS_tim[locale]:SetText(SecondsToClock(timer));
		VSR[zone][locale] = timer;
	end
end

function VSR_Naxx:CustomMobDeath(msg)
  
  	if NaxSpec[L["|cFF73c5e6DeathKnight Wing|r"]].recording then
		for hm,_ in pairs(hmDown) do
			if (msg == string.format(UNITDIESOTHER, hm)) then
				hmDown[hm] = true;
			end
		end
		
		if hmDown[boss["Highlord Mograine"]] and hmDown[boss["Lady Blaumeux"]] and hmDown[boss["Thane Korth'azz"]] and hmDown[boss["Sir Zeliek"]] then
			self:genericBossDeath(string.format(UNITDIESOTHER, boss["The Four Horsemen"]));
			NaxSpec[L["|cFF73c5e6DeathKnight Wing|r"]]["recording"] = false;
			self:HandleWingsEnd(L["|cFF73c5e6DeathKnight Wing|r"], NaxSpec[L["|cFF73c5e6DeathKnight Wing|r"]]["timer"]);
		end
	end

    for wing,_ in pairs(NaxSpec) do
        if not NaxSpec[wing].recording then
            for mob,_ in pairs(NaxSpec[wing].firstMobs) do
                if (msg == string.format(UNITDIESOTHER, mob)) then
					NaxSpec[wing].recording = true;
					NaxSpec[wing].startTime = math.floor(GetTime());
                end
			end
		else
			if (msg == string.format(UNITDIESOTHER, NaxSpec[wing].lastBoss)) then
				NaxSpec[wing].recording = false;
				self:HandleWingsEnd(wing, NaxSpec[wing].timer);
			end
        end
	end

	for k,_ in pairs(VSR["NaxxCurr"]) do
		VSR.NaxxCurr[k].recording = NaxSpec[k].recording;
		VSR.NaxxCurr[k].startTime = NaxSpec[k].startTime;
	end
	
end

function VSR_Naxx:OnEnable()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "mobDeath")

	VSR_Naxx:InitialiseRecord(zone, VSR[zone], boss["Kel'Thuzad"], {
		[1] = L["|cFF73c5e6Construction Quarter|r"],
		[2] = boss["Patchwerk"],
		[3] = boss["Grobbulus"],
		[4] = boss["Gluth"],
		[5] = boss["Thaddius"],
		[6] = "  ",
		[7] = L["|cFF73c5e6DeathKnight Wing|r"],
		[8] = boss["Instructor Razuvious"],
		[9] = boss["Gothik the Harvester"],
		[10] = boss["The Four Horsemen"],
		[11] = "   ",
		[12] = L["|cFF73c5e6Plague Wing|r"],
		[13] = boss["Noth the Plaguebringer"],
		[14] = boss["Heigan the Unclean"],
		[15] = boss["Loatheb"],
		[16] = "    ",
		[17] = L["|cFF73c5e6Spider Wing|r"],
		[18] = boss["Anub'Rekhan"],
		[19] = boss["Grand Widow Faerlina"],
		[20] = boss["Maexxna"],
		[21] = "     ",
		[22] = boss["Sapphiron"],
		[23] = boss["Kel'Thuzad"],
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
	
	for k,_ in pairs(VSR["NaxxCurr"]) do
	    if VSR["NaxxCurr"][k]["recording"] and (GetTime() - VSR["NaxxCurr"][k]["startTime"] < 6*60*60) then
		    NaxSpec[k]["recording"] = true;
		    NaxSpec[k]["startTime"] = VSR["NaxxCurr"][k]["startTime"];
	    end
	end
	
	self.core.VSR_MAIN_FRAME:SetScript("OnUpdate", function() self.Update() self.UpdateWings() end)
end
