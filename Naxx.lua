
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

local NaxSpec = {
	["plague"] = {
		timer = 0,
		recording = false,
		startTime = nil,
		firstMobs = {
			[boss["Noth the Plaguebringer"]]			= true,
			[L["Infectious Ghoul"]]						= true,
			[L["Plague Slime"]]							= true,
			[L["Stoneskin Gargoyle"]]					= true,
		}
	},
	["construct"] = {
		timer = 0,
		recording = false,
		startTime = nil,
		firstMobs = {
			[L["Patchwork Golem"]] = true
		}
	},
	["spider"] = {
		timer = 0,
		recording = false,
		startTime = nil,
		firstMobs = {
			[L["Poisonous Skitterer"]]					= true,
			[L["Carrion Spinner"]]						= true,
			[L["Dread Creeper"]]						= true,
			[L["Venom Stalker"]]						= true,
		}
	},
	["deathknight"] = {
		timer = 0,
		recording = false,
		startTime = nil,
		firstMobs = {
			[L["Death Knight"]]							= true,
			[L["Risen Deathknight"]]					= true,
		}
	}
}
--Todo use theses

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

	print(self.name.." INIT");
end

function VSR_Naxx:UpdateWings(msg)

end

function VSR_Naxx:HandleWingsEnd(locale, timer)
	if (VSR[zone][locale] ~= nil) then
		if (VSR[zone][locale] > timer) then
			local diff = VSR[zone][locale] -  timer;
			VSR_SEGMENTS_tim[locale]:SetText(SecondsToClo(timer)..' (-'..STC_MIN(diff)..')');
			VSR_SEGMENTS_tim[locale]:SetTextColor(0.45, 0.90, 0.45, 1);
			VSR[zone][locale] =  timer;
		else 
			local diff =   timer - VSR[zone][locale];
			VSR_SEGMENTS_tim[locale]:SetText(SecondsToClock(timer)..' (+'..STC_MIN(diff)..')');
			VSR_SEGMENTS_tim[locale]:SetTextColor(0.90, 0.45, 0.45, 1);
		end
	else 
		VSR_SEGMENTS_tim[locale]:SetText(SecondsToClock(timer));
		VSR[zone][locale] = timer;
	end
end

function VSR_Naxx:CustomMobDeath(msg)
  
  if dkRecording then
	for hm,_ in pairs(hmDown) do
		if (msg == string.format(UNITDIESOTHER, hm)) then
			hmDown[hm] = true;
		end
	end
	
	if hmDown[L["Highlord Mograine"]] and hmDown[L["Lady Blaumeux"]] and hmDown[L["Thane Korth'azz"]] and hmDown[L["Sir Zeliek"]] then
		self:genericBossDeath(string.format(UNITDIESOTHER, boss["The Four Horsemen"]));
		NaxSpec["deathknight"]["recording"] = false;
	    HandleWingsEnd(L["|cFF73c5e6DeathKnight Wing|r"], NaxSpec["deathknight"]["timer"]);
	end
	else
		for mob,_ in pairs(dkStart) do
			if (msg == string.format(UNITDIESOTHER, mob)) then
	    		NaxSpec["deathknight"]["recording"] = true;
			end
		end
    end

    if not NaxSpec["construct"]["recording"] then
    	if (msg == string.format(UNITDIESOTHER, L["Patchwork Golem"])) then
        	NaxSpec["construct"]["recording"] = true;
    	end
    elseif (msg == string.format(UNITDIESOTHER, boss["Thaddius"])) then
    	NaxSpec["construct"]["recording"] = false;
    end

    for wing,_ in pairs(NaxSpec) do
        if not wing.recording then
            for mob,_ in pairs(wing.firstMobs) do
                if (msg == string.format(UNITDIESOTHER, mob)) then
                    wing.recording = true
                end
            end
        end
    end
        
  
  -- implement wings record start end and save here
  
end

function VSR_Naxx:OnEnable()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "mobDeath")
	VSR_Naxx:InitialiseRecord(zone, VSR[zone], boss["Kel'Thuzad"], {
		[0] = L["|cFF73c5e6Construction Quarter|r"],
		[1] = boss["Patchwerk"],
		[2] = boss["Grobbulus"],
		[3] = boss["Gluth"],
		[4] = boss["Thaddius"],
		[5] = L["|cFF73c5e6DeathKnight Wing|r"],
		[6] = boss["Instructor Razuvious"],
		[7] = boss["Gothik the Harvester"],
		[8] = boss["The Four Horsemen"],
		[9] = L["|cFF73c5e6Plague Wing|r"],
		[10] = L["|cFF73c5e6Plague Wing|r"],
		[11] = boss["Noth the Plaguebringer"],
		[12] = boss["Heigan the Unclean"],
		[13] = boss["Loatheb"],
		[14] = L["|cFF73c5e6Spider Wing|r"],
		[15] = boss["Anub'Rekhan"],
		[16] = boss["Grand Widow Faerlina"],
		[17] = boss["Maexxna"],
		[18] = boss["Sapphiron"],
		[19] = boss["Kel'Thuzad"],
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
	
	for k,v in pairs(VSR["NaxxCurr"]) do
	    if k["recording"] and (GetTime() - k["startTime"] < 6*60*60) then
		    NaxSpec[k]["recording"] = true;
		    NaxSpec[k]["startTime"] = k["startTime"];
	    end
	end
	
	self.core.VSR_MAIN_FRAME:SetScript("OnUpdate", function() self.Update() self.UpdateWings() end)
end