local timer = 0;
local recording = false;
local lastBoss = nil;
local zone = nil;
local IsInInstance = IsInInstance;
local plagueRecord = false;
local plagueTimer = 0;
local dkRecord = false;
local dkTimer = 0;
local spiderRecord = false;
local spiderTimer = 0;
local aboRecord = false;
local aboTimer = 0;

local hmCount = 0;
local bossdwn = 0;

local VSR_SEGMENTS = nil;
local VSR_SEGMENTS_seg = {};
local VSR_SEGMENTS_tim = {};

function MakeMovable(frame)
    frame:SetMovable(true);
    frame:RegisterForDrag("LeftButton");
    frame:SetScript("OnDragStart", function() this:StartMoving() end);
    frame:SetScript("OnDragStop", function() this:StopMovingOrSizing() end);
end

local VSR_MAIN_FRAME = CreateFrame("Frame", "VSR_MAIN_FRAME");
VSR_MAIN_FRAME:SetFrameStrata("BACKGROUND");
VSR_MAIN_FRAME:SetWidth(150);
VSR_MAIN_FRAME:SetHeight(25);
VSR_MAIN_FRAME:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeSize = 5});
VSR_MAIN_FRAME:SetBackdropColor(0,0,0,0.5);
VSR_MAIN_FRAME:EnableMouse(true);
VSR_MAIN_FRAME:ClearAllPoints();
VSR_MAIN_FRAME:SetPoint("CENTER", 0, 0);
VSR_MAIN_FRAME:Show();
MakeMovable(VSR_MAIN_FRAME); 

local VSR_TITLE = CreateFrame("Frame", "VSR_TITLE", VSR_MAIN_FRAME);
VSR_TITLE:SetPoint("TOP", "VSR_MAIN_FRAME", 0, -0);
VSR_TITLE:SetPoint("BOTTOM", "VSR_MAIN_FRAME", 0, -0);
VSR_TITLE:SetPoint("LEFT", "VSR_MAIN_FRAME", 0, -0);
VSR_TITLE:SetPoint("RIGHT", "VSR_MAIN_FRAME", 0, -0);
local VSR_TITLE_text = VSR_TITLE:CreateFontString("VSR_TITLE_text", "ARTWORK", "GameFontWhite")
VSR_TITLE_text:SetPoint("TOP", "VSR_TITLE", 0, -5);
VSR_TITLE_text:SetText("Vanilla SpeedRun");
VSR_TITLE_text:SetFont("Fonts\\FRIZQT__.TTF", 10)
VSR_TITLE_text:SetTextColor(0.90, 0.45, 0.45, 1);

local VSR_CURRINST = CreateFrame("Frame", "VSR_CURRINST", VSR_MAIN_FRAME);
VSR_CURRINST:SetPoint("TOP", "VSR_TITLE_text", "BOTTOM", 0, -5);
VSR_CURRINST:SetPoint("BOTTOM", "VSR_TITLE", 0, -0);
VSR_CURRINST:SetPoint("LEFT", "VSR_TITLE", 0, -0);
VSR_CURRINST:SetPoint("RIGHT", "VSR_TITLE", 0, -0);
local VSR_CURRINST_text = VSR_CURRINST:CreateFontString("VSR_CURRINST_text", "ARTWORK", "GameFontNormal")
VSR_CURRINST_text:SetPoint("TOP", "VSR_CURRINST", 0, -0);
VSR_CURRINST_text:SetPoint("LEFT", "VSR_CURRINST", 5, -0);
VSR_CURRINST_text:SetJustifyH("LEFT");
VSR_CURRINST_text:SetFont("Fonts\\FRIZQT__.TTF", 8)
local VSR_CURRINST_timer = VSR_CURRINST:CreateFontString("VSR_CURRINST_timer", "ARTWORK", "GameFontWhite")
VSR_CURRINST_timer:SetPoint("TOP", "VSR_CURRINST", 0, -0);
VSR_CURRINST_timer:SetPoint("RIGHT", "VSR_CURRINST", -5, -0);
VSR_CURRINST_timer:SetJustifyH("RIGHT");
VSR_CURRINST_timer:SetFont("Fonts\\FRIZQT__.TTF", 8)

local loc = {};
loc["enUS"] = {
    dies     = "dies.",
    slain    = "slain",
    slain2   = "slain",

    mc       = "Molten Core",
    ragnaros = "Ragnaros",
    lucifron = "Lucifron",
    magmadar = "Magmadar",
    gehennas = "Gehennas",
    garr     = "Garr",
    geddon   = "Baron Geddon",
    shazzrah = "Shazzrah",
    sulfuron = "Sulfuron Harbinger",
    golemagg = "Golemagg the Incinerator",

    giant    = "Molten Giant",

    bwl      = "Blackwing Lair",
    nefarian = "Nefarian",
    razor    = "Razorgore the Untamed",
    vael     = "Vaelastrasz the Corrupt",
    broodlord= "Broodlord Lashlayer",
    firemaw  = "Firemaw",
    ebonroc  = "Ebonroc",
    flamegor = "Flamegor",
    chroma   = "Chromaggus",

    grethok  = "Grethok the Controller",

    aq40     = "Ahn'Qiraj",
    cthun    = "C'Thun",
    skeram   = "The Prophet Skeram",
    sartura  = "Battleguard Sartura",
    fankriss = "Fankriss the Unyielding",
    huhuran  = "Princess Huhuran",
    veklor   = "Emperor Vek'lor",

    eradicat = "Obsidian Eradicator",

    naxx     = "Naxxramas",
    kt       = "Kel'Thuzad",
    patch    = "Patchwerk",
    grobbulus= "Grobbulus",                
    gluth     = "Gluth",                 
    thaddius = "Thaddius",         
    razuvious= "Instructor Razuvious",         
    gothik   = "Gothik the Harvester",
    blaumeux = "Lady Blaumeux",
    thane    = "Thane Korth'azz",
    mograine  = "Highlord Mograine",
    zeliek   = "Sir Zeliek",
    noth     = "Noth the Plaguebringer",
    heigan   = "Heigan the Unclean",
    loatheb  = "Loatheb",
    anub     = "Anub'Rekhan",
    faerlina = "Grand Widow Faerlina",
    maexxna  = "Maexxna",
    sapphi   = "Sapphiron",

    -- DK start
    dk       = "Death Knight",
    risendk  = "Risen Deathknight",
    -- ABO start
    pwgolem  = "Patchwork Golem",
    -- SPIDER Start
    poisonous= "Poisonous Skitterer",
    carrionsp= "Carrion Spinner",
    dreadcre = "Dread Creeper",
    venomstk = "Venom Stalker",
    -- PLAGUE start
    infghoul = "Infectious Ghoul",
    plaguesl = "Plague Slime",
    gargoyle = "Stoneskin Gargoyle"

}
--Pic Blackrock
loc["frFR"] = {
    dies     = "meurt.",
    slain    = "tué",
    slain2   = "tue",

    mc       = "Cœur du Magma",
    ragnaros = "Ragnaros",
    lucifron = "Lucifron",
    magmadar = "Magmadar",
    gehennas = "Gehennas",
    garr     = "Garr",
    geddon   = "Baron Geddon",
    shazzrah = "Shazzrah",
    sulfuron = "Messager de Sulfuron",
    golemagg = "Golemagg l'Incinérateur",
    
    giant    = "Géant de lave",

    bwl      = "Repaire de l'Aile noire",
    nefarian = "Nefarian",
    razor    = "Tranchetripe l'Indompté",
    vael     = "Vaelastrasz le Corrompu",
    broodlord= "Seigneur des couvées Lanistaire",
    firemaw  = "Gueule-de-feu",
    ebonroc  = "Rochébène",
    flamegor = "Flamegor",
    chroma   = "Chromaggus",

    grethok  = "Grethok le Contrôleur",

    aq40     = "Ahn'qiraj",
    cthun    = "C'Thun",
    skeram   = "Le Prophète Skeram",
    sartura  = "Garde de guerre Sartura",
    fankriss = "Fankriss l'Inflexible",
    huhuran  = "Princesse Huhuran",
    veklor   = "Empereur Vek'lor",

    eradicat = "Eradicateur d'obsidienne",

    naxx     = "Naxxramas",
    kt       = "Kel'Thuzad",
    patch    = "Le Recousu",
    grobbulus= "Grobbulus",                
    gluth    = "Gluth",                 
    thaddius = "Thaddius",         
    razuvious= "Instructeur Razuvious",         
    gothik   = "Gothik le Moissonneur",
    blaumeux = "Dame Blaumeux",
    thane    = "Thane Korth'azz",
    mograine  = "Généralissime Mograine",
    zeliek   = "Sire Zeliek",
    noth     = "Noth le Porte-peste",
    heigan   = "Heigan l'Impur",
    loatheb  = "Horreb",
    anub     = "Anub'Rekhan",
    faerlina = "Grande veuve Faerlina",
    maexxna  = "Maexxna",
    sapphi   = "Saphiron",

    -- DK start
    dk       = "Chevalier de la mort",
    risendk  = "Chevalier de la mort ressuscité",
    -- ABO start
    pwgolem  = "Golem recousu",
    -- SPIDER Start
    poisonous= "Glisseuse venimeuse",
    carrionsp= "Tisse-charogne",
    dreadcre = "Rampant de l'effroi",
    venomstk = "Traque-venin",
    -- PLAGUE start
    infghoul = "Goule infectieuse",
    plaguesl = "Gelée de la peste",
    gargoyle = "Gargouille peau de pierre"
}

local lang = GetLocale();
if (lang ~= "frFR" or lang ~= "enUS") then lang = "enUS" end;
local L = loc[lang];

local VSR_struct = {};
VSR_struct[L["mc"]] = {
    ['best']      = nil,
    [1]           = nil,
    [2]           = nil,
    [3]           = nil,
    [4]           = nil,
    [5]           = nil,
    [6]           = nil,
    [7]           = nil,
};
VSR_struct[L["bwl"]] ={
    ['best']      = nil,
    [1]           = nil,
    [2]           = nil,
    [3]           = nil,
    [4]           = nil,
    [5]           = nil,
    [6]           = nil,
    [7]           = nil,
};
VSR_struct[L["aq40"]] = {
    ["best"]      = nil,
    [1]           = nil,
    [2]           = nil,
    [3]           = nil,
    [4]           = nil,
    [5]           = nil,
};
VSR_struct[L["naxx"]] = {
    ['best']      = nil,
    [1]           = nil,
    [2]           = nil,
    [3]           = nil,
    [4]           = nil,
    [5]           = nil,
    [6]           = nil,
    [7]           = nil,
    [8]           = nil,
    [9]           = nil,
    [10]          = nil,
    [11]          = nil,
    [12]          = nil,
    [13]          = nil,
    [14]          = nil,
    [15]          = nil,
    [16]          = nil,
    [17]          = nil,
    [18]          = nil
};

local firstMob = {
    L['dk'], L['risendk'], L['pwgolem'], L['poisonous'], 
    L['carrionsp'], L['dreadcre'], L['venomstk'], L['infghoul'], 
    L['plaguesl'], L['gargoyle'], L['eradicat'], L['giant'], L['grethok']
};

local downNbr = {};
downNbr[L["mc"]] = 9;
downNbr[L["bwl"]] = 7;
downNbr[L["aq40"]] = 6;
downNbr[L["naxx"]] = 15;

local recordedInstance = {}
recordedInstance[L["mc"]] = {
            ['lastBoss']  = L["ragnaros"],
            [1]           = L["lucifron"],
            [2]           = L["magmadar"],
            [3]           = L["gehennas"],
            [4]           = L["garr"],
            [5]           = L["geddon"],
            [6]           = L["shazzrah"],
            [7]           = L["sulfuron"],
			[8]           = L["golemagg"],
			[9] 		  = L["ragnaros"],
        };
recordedInstance[L["bwl"]] = {
            ['lastBoss']  = L["nefarian"],
            [1]           = L["razor"],
            [2]           = L["vael"],
            [3]           = L["broodlord"],
            [4]           = L["firemaw"],
            [5]           = L["ebonroc"],
            [6]           = L["flamegor"],
			[7]           = L["chroma"],
			[8]  	 	  = L["nefarian"],
        };
recordedInstance[L["aq40"]] = {
            ['lastBoss']  = L["cthun"],
            [1]           = L["skeram"],
            [2]           = L["sartura"],
            [3]           = L["fankriss"],
            [4]           = L["huhuran"],
			[5]           = "Twins emperors",
			[6] 		  = L["cthun"],
        };
recordedInstance[L["naxx"]] = {
            ['lastBoss']  = L["kt"],
            [1]           = "|cFF73c5e6Construction Quarter|r",
            [2]           = L["patch"],
            [3]           = L["grobbulus"],
            [4]           = L["gluth"],
            [5]           = L["thaddius"],
            [6]           = "|cFF73c5e6DeathKnight Wing|r",
            [7]           = L["razuvious"],
            [8]           = L["gothik"],
            [9]           = "4 Horsemens",
            [10]          = "|cFF73c5e6Plague Wing|r",
            [11]          = L["noth"],
            [12]          = L["heigan"],
            [13]          = L["loatheb"],
            [14]          = "|cFF73c5e6Spider Wing|r",
            [15]          = L["anub"],
            [16]          = L["faerlina"],
            [17]          = L["maexxna"],
			[18]          = L["sapphi"],
			[19]  		  = L["kt"],
        };

-- This function is realy useful
local function has_value (tab, val)
    for value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    if (tab[val] ~= nil) then
        return true
    end

    return false
end

-- Same but non associative
local function in_table ( e, t )
    for _,v in pairs(t) do
        if (v==e) then return true end
    end
    return false
end

local function isNaN( v ) 
    return type( v ) == "number" and v ~= v 
end

local function SecondsToClock(seconds)
    local seconds = tonumber(seconds)
    if seconds <= 0 then
        return "00:00:00";
    else
        hours = string.format("%02.f", math.floor(seconds/3600));
        mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
        secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
        return hours..":"..mins..":"..secs
    end
end

local function STC_MIN(seconds)
    local seconds = tonumber(seconds)
    local str;
    if seconds <= 0 then
        return "0";
    else
        hours = string.format("%02.f", math.floor(seconds/3600));
        mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
        secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
        str = secs.."s";
        if (math.floor(seconds/60) > 0) then
            str = mins..":"..secs
        elseif (math.floor(seconds/3600) > 0) then
            str = hours..":"..mins..":"..secs;
        end
        
        return str;
    end
end

local function InitialiseRaid(arg)
    local lastKey = nil;
    local zonez = arg;
    bossdwn = 0;
    if (VSR_SEGMENTS ~= nil) then VSR_SEGMENTS:Hide(); end

    if (zone == "naxxramas") then
        plagueRecord = false;
        plagueTimer = 0;
        dkRecord = false;
        dkTimer = 0;
        spiderRecord = false;
        spiderTimer = 0;
        aboRecord = false;
        aboTimer = 0;
    end

    VSR_CURRINST_text:SetText(arg)
    VSR_CURRINST_timer:SetText("00:00:00")
    VSR_CURRINST_timer:SetTextColor(1, 1, 1, 1);

    VSR_SEGMENTS_seg = {};
    VSR_SEGMENTS_tim = {};

    VSR_SEGMENTS = CreateFrame("Frame", "VSR_SEGMENTS", VSR_MAIN_FRAME);
    VSR_SEGMENTS:SetPoint("TOP", "VSR_CURRINST_text", "BOTTOM", 0, -5);

    VSR_SEGMENTS:SetPoint("BOTTOM", "VSR_TITLE", 0, -0);
    VSR_SEGMENTS:SetPoint("LEFT", "VSR_TITLE", 0, -0);
    VSR_SEGMENTS:SetPoint("RIGHT", "VSR_TITLE", 0, -0);

    local VSR_SEGMENTS_bestTxt = VSR_SEGMENTS:CreateFontString("VSR_SEGMENTS_bestTxt", "ARTWORK", "GameFontNormal")
    VSR_SEGMENTS_bestTxt:SetPoint("TOP", "VSR_CURRINST_text", "BOTTOM", 0, -0);
    VSR_SEGMENTS_bestTxt:SetPoint("LEFT", "VSR_SEGMENTS", 5, -0);
    VSR_SEGMENTS_bestTxt:SetJustifyH("LEFT");
    VSR_SEGMENTS_bestTxt:SetFont("Fonts\\FRIZQT__.TTF", 8)
    VSR_SEGMENTS_bestTxt:SetText("BEST :")
    local VSR_SEGMENTS_bestTim = VSR_SEGMENTS:CreateFontString("VSR_SEGMENTS_bestTim", "ARTWORK", "GameFontWhite")
    VSR_SEGMENTS_bestTim:SetPoint("TOP", "VSR_CURRINST_timer", "BOTTOM", 0, -0);
    VSR_SEGMENTS_bestTim:SetPoint("RIGHT", "VSR_SEGMENTS", -5, -0);
    VSR_SEGMENTS_bestTim:SetJustifyH("RIGHT");
    VSR_SEGMENTS_bestTim:SetFont("Fonts\\FRIZQT__.TTF", 8)
    local bestTime = "none";
    if (VSR[zonez]["best"] ~= nil) then bestTime = SecondsToClock(VSR[zonez]["best"]) end
    VSR_SEGMENTS_bestTim:SetText(bestTime);
    local count = 0;
    lastBoss = recordedInstance[zonez]['lastBoss']
    for key, value in recordedInstance[zonez] do
        if (key ~= "lastBoss") then
            count = count +1;
            VSR_SEGMENTS_seg[key] = VSR_SEGMENTS:CreateFontString("VSR_SEGMENTS_Seg"..key, "ARTWORK", "GameFontWhite");
            VSR_SEGMENTS_tim[key] = VSR_SEGMENTS:CreateFontString("VSR_SEGMENTS_tim"..key, "ARTWORK", "GameFontWhite");
            if (lastKey ~= nil) then 
                VSR_SEGMENTS_seg[key]:SetPoint("TOP", "VSR_SEGMENTS_Seg"..lastKey, "BOTTOM", 0, -0);
                VSR_SEGMENTS_tim[key]:SetPoint("TOP", "VSR_SEGMENTS_tim"..lastKey, "BOTTOM", 0, -0);
            else 
                VSR_SEGMENTS_seg[key]:SetPoint("TOP", "VSR_SEGMENTS", 0, -10);
                VSR_SEGMENTS_tim[key]:SetPoint("TOP", "VSR_SEGMENTS", 0, -10);
            end
            VSR_SEGMENTS_seg[key]:SetPoint("LEFT", "VSR_SEGMENTS", 5, -0);
            VSR_SEGMENTS_seg[key]:SetJustifyH("LEFT");
            VSR_SEGMENTS_seg[key]:SetFont("Fonts\\FRIZQT__.TTF", 8)
            VSR_SEGMENTS_seg[key]:SetText(value);

            VSR_SEGMENTS_tim[key]:SetPoint("RIGHT", "VSR_SEGMENTS", -5, -0);
            VSR_SEGMENTS_tim[key]:SetJustifyH("RIGHT");
            VSR_SEGMENTS_tim[key]:SetFont("Fonts\\FRIZQT__.TTF", 8)
            VSR_SEGMENTS_tim[key]:SetText("none");
            if (VSR[zonez][key] ~= nil) then
                VSR_SEGMENTS_tim[key]:SetText(SecondsToClock(VSR[zonez][key]));
            end
            lastKey = key;
        end
    end
    VSR_MAIN_FRAME:SetHeight(40 +(count * 10));
    timer = 0;
end

function VSR_OnLoad()
    this:RegisterEvent("ADDON_LOADED")
    this:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    this:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
    this:RegisterForClicks("RightButtonUp")
    this:RegisterForDrag("LeftButton")
end

function VSR_OnEvent()
    if (event == "ADDON_LOADED") then
        if (VSR == nil) then
            VSR = {};
        end
    elseif (event == "ZONE_CHANGED_NEW_AREA") then
        if (zone ~= nil and IsInInstance("player") and has_value(recordedInstance, zone) and zone ~= GetRealZoneText()) then
            recording = false;
            if (VSR[zone] == nil) then
                VSR[zone] = VSR_struct[zone];
            end
            InitialiseRaid(zone);
        end
            
        zone = GetRealZoneText();
        if (recording == false) and IsInInstance("player") and has_value(recordedInstance, zone) then
            if (VSR[zone] == nil) then
                VSR[zone] = VSR_struct[zone];
            end
            InitialiseRaid(zone);
        end
    elseif (event == "CHAT_MSG_COMBAT_HOSTILE_DEATH") then
        if (zone ~= nil) then 
            if (string.find(arg1, L['slain']) or string.find(arg1, L['slain2'])) then 
                return;
            end

            local mob = string.sub(arg1,1,string.len(arg1)-(string.len(" "..L["dies"])))

            if (recording == false and in_table(mob, firstMob)) then
                recording = true;
            end
            
            -- Nax is a bit of a special place
            if (zone == L['naxx']) then
                if (mob == L["noth"] or mob == L["gargoyle"] or mob == L["infghoul"] or mob == L["plaguesl"]) and (plagueRecord == false) then
                    plagueRecord = true;
                elseif (mob == L["dk"].." "..L["dies"] or mob == L["risendk"]) and (dkRecord == false) then
                    dkRecord = true;
                elseif (mob == L["pwgolem"]) and (aboRecord == false) then
                    aboRecord = true;
                elseif (mob == L["poisonous"] or mob == L["carrionsp"] or mob == L['dreadcre'] or mob == L["venomstk"]) and (spiderRecord == false) then
                    spiderRecord = true;
                end

                if (aboRecord == true) then
                    if (mob == L["thaddius"]) then
                        aboRecord = false;
                        if (VSR[zone][1] ~= nil) then
                            if (VSR[zone][1] > aboTimer) then
                                local diff = VSR[zone][1] - aboTimer;
                                VSR_SEGMENTS_tim[1]:SetText(SecondsToClock(aboTimer)..' (-'..STC_MIN(diff)..')');
                                VSR_SEGMENTS_tim[1]:SetTextColor(0.45, 0.90, 0.45, 1);
                                VSR[zone][1] = aboTimer;
                            else 
                                local diff =  aboTimer - VSR[zone][1];
                                VSR_SEGMENTS_tim[1]:SetText(SecondsToClock(aboTimer)..' (+'..STC_MIN(diff)..')');
                                VSR_SEGMENTS_tim[1]:SetTextColor(0.90, 0.45, 0.45, 1);
                            end
                        else 
                            VSR_SEGMENTS_tim[1]:SetText(SecondsToClock(aboTimer));
                            VSR[zone][1] = aboTimer;
                        end
                    end
                end

                if (in_table(mob, {L["blaumeux"], L['thane'], L['zeliek'], L['mograin']})) then
					hmCount = hmCount +1;
					
                    if (hmCount == 4) then
                        mob = "4 Horsemens";
                        if (dkRecord == true) then
                            dkRecord = false;
                            if (VSR[zone][6] ~= nil) then
                                if (VSR[zone][6] > dkTimer) then
                                    local diff = VSR[zone][6] - dkTimer;
                                    VSR_SEGMENTS_tim[6]:SetText(SecondsToClock(dkTimer)..' (-'..STC_MIN(diff)..')');
                                    VSR_SEGMENTS_tim[6]:SetTextColor(0.45, 0.90, 0.45, 1);
                                    VSR[zone][6] = dkTimer;
                                else 
                                    local diff =  dkTimer - VSR[zone][1];
                                    VSR_SEGMENTS_tim[6]:SetText(SecondsToClock(dkTimer)..' (+'..STC_MIN(diff)..')');
                                    VSR_SEGMENTS_tim[6]:SetTextColor(0.90, 0.45, 0.45, 1);
                                end
                            else 
                                VSR_SEGMENTS_tim[6]:SetText(SecondsToClock(dkTimer));
                                VSR[zone][6] = dkTimer;
                            end
                        end
                    end
                end

                if (plagueRecord == true) then
                    if (mob == L["loatheb"]) then
                        plagueRecord = false;
                        if (VSR[zone][10] ~= nil) then
                            if (VSR[zone][10] > plagueTimer) then
                                local diff = VSR[zone][10] - plagueTimer;
                                VSR_SEGMENTS_tim[10]:SetText(SecondsToClock(plagueTimer)..' (-'..STC_MIN(diff)..')');
                                VSR_SEGMENTS_tim[10]:SetTextColor(0.45, 0.90, 0.45, 1);
                                VSR[zone][10] = plagueTimer;
                            else 
                                local diff =  plagueTimer - VSR[zone][1];
                                VSR_SEGMENTS_tim[10]:SetText(SecondsToClock(plagueTimer)..' (+'..STC_MIN(diff)..')');
                                VSR_SEGMENTS_tim[10]:SetTextColor(0.90, 0.45, 0.45, 1);
                            end
                        else 
                            VSR_SEGMENTS_tim[10]:SetText(SecondsToClock(plagueTimer));
                            VSR[zone][10] = plagueTimer;
                        end
                    end
                end

                if (spiderRecord == true) then
                    if (mob == L["maexxna"]) then
                        spiderRecord = false;
                        if (VSR[zone][14] ~= nil) then
                            if (VSR[zone][14] > spiderTimer) then
                                local diff = VSR[zone][14] - spiderTimer;
                                VSR_SEGMENTS_tim[14]:SetText(SecondsToClock(spiderTimer)..' (-'..STC_MIN(diff)..')');
                                VSR_SEGMENTS_tim[14]:SetTextColor(0.45, 0.90, 0.45, 1);
                                VSR[zone][14] = spiderTimer;
                            else 
                                local diff =  spiderTimer - VSR[zone][1];
                                VSR_SEGMENTS_tim[14]:SetText(SecondsToClock(spiderTimer)..' (+'..STC_MIN(diff)..')');
                                VSR_SEGMENTS_tim[14]:SetTextColor(0.90, 0.45, 0.45, 1);
                            end
                        else 
                            VSR_SEGMENTS_tim[14]:SetText(SecondsToClock(spiderTimer));
                            VSR[zone][14] = spiderTimer;
                        end
                    end
                end
            end

            if (recording == true) then
                for key, value in recordedInstance[zone] do
                    if (key ~= "lastBoss") then
						-- Twins emperor special case
                        if (mob == L['veklor']) then mob = "Twins emperors" end
                        if (mob == value) then
							bossdwn = bossdwn +1;
                            if (VSR[zone][key] ~= nil) then
                                local oldRecord = VSR[zone][key];
                                if (oldRecord > timer) then
                                    local diff = oldRecord-timer;
                                    VSR_SEGMENTS_tim[key]:SetText(SecondsToClock(timer).." (-"..STC_MIN(diff)..')');
                                    VSR_SEGMENTS_tim[key]:SetTextColor(0.45, 0.90, 0.45, 1);
                                    VSR[zone][key] = timer;
                                else 
                                    local diff = timer-oldRecord;
                                    VSR_SEGMENTS_tim[key]:SetText(SecondsToClock(timer).." (+"..STC_MIN(diff)..')');
                                    VSR_SEGMENTS_tim[key]:SetTextColor(0.90, 0.45, 0.45, 1);
                                end
							else
                                VSR_SEGMENTS_tim[key]:SetText(SecondsToClock(timer));
                                VSR[zone][key] = timer;
                            end
                        end
                    end
				end
				
				if (mob == lastBoss) and (recording == true) and (bossdwn == downNbr[zone]) then
					recording = false;
	
					if (VSR[zone]["best"] == nil) then 
						VSR[zone]["best"] = timer;
						VSR_SEGMENTS_bestTim:SetText(SecondsToClock(timer));
						VSR_CURRINST_timer:SetTextColor(0.90, 0.45, 0.45, 1);
						SendChatMessage("Premier enregistrement pour "..GetRealZoneText().." : "..SecondsToClock(timer))
					else
						if (timer < VSR[zone]["best"]) then 
							local diff = VSR[zone]["best"]-timer;
							VSR[zone]["best"] = timer; 
							VSR_SEGMENTS_bestTim:SetText(SecondsToClock(timer));
							VSR_CURRINST_timer:SetText(SecondsToClock(timer).." (-"..STC_MIN(diff)..')');
							VSR_CURRINST_timer:SetTextColor(0.45, 0.90, 0.45, 1);
							SendChatMessage("Record battu pour "..GetRealZoneText().."!! Faite en "..SecondsToClock(timer).." soit -"..STC_MIN(diff));
						else
							local diff = timer-VSR[zone]["best"];
							VSR_CURRINST_timer:SetText(SecondsToClock(timer).." (+"..STC_MIN(diff)..')');
							VSR_CURRINST_timer:SetTextColor(0.90, 0.45, 0.45, 1);
							SendChatMessage("Temps pour clean "..GetRealZoneText().." : "..SecondsToClock(timer).." soit +"..STC_MIN(diff)" par rapport au meilleur temps ("..VSR[zone]["best"]..")");
						end
					end
				end
            end
        end
    end
end

function VSR_OnUpdate(delta)
    if recording == true then
        timer = timer + delta
        if timer < 0 then
            timer = 0
        end
        VSR_CURRINST_timer:SetText(SecondsToClock(timer));
        VSR_CURRINST_timer:SetTextColor(0.90, 0.45, 0.45, 1);
    end

    if aboRecord == true then
        aboTimer = aboTimer + delta
        if aboTimer < 0 then
            aboTimer = 0
        end

        VSR_SEGMENTS_tim[1]:SetText(SecondsToClock(aboTimer));
        VSR_SEGMENTS_tim[1]:SetTextColor(0.90, 0.45, 0.45, 1);
    end

    if dkRecord == true then
        dkTimer = dkTimer + delta
        if dkTimer < 0 then
            dkTimer = 0
        end

        VSR_SEGMENTS_tim[6]:SetText(SecondsToClock(dkTimer));
        VSR_SEGMENTS_tim[6]:SetTextColor(0.90, 0.45, 0.45, 1);
    end

    if plagueRecord == true then
        plagueTimer = plagueTimer + delta
        if plagueTimer < 0 then
            plagueTimer = 0
        end

        VSR_SEGMENTS_tim[10]:SetText(SecondsToClock(plagueTimer));
        VSR_SEGMENTS_tim[10]:SetTextColor(0.90, 0.45, 0.45, 1);
    end

    if spiderRecord == true then
        spiderTimer = spiderTimer + delta
        if spiderTimer < 0 then
            spiderTimer = 0
        end

        VSR_SEGMENTS_tim[14]:SetText(SecondsToClock(spiderTimer));
        VSR_SEGMENTS_tim[14]:SetTextColor(0.90, 0.45, 0.45, 1);
    end

end