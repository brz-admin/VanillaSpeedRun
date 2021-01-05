local L = AceLibrary("AceLocale-2.2"):new("VanillaSpeedRun");
local zones = AceLibrary("Babble-Zone-2.2")
local boss = AceLibrary("Babble-Boss-2.2")

L:RegisterTranslations("enUS", function() return {
	firstRec = "First record for %s : %s.",
	newRec = "New Record for %s !! Done in %s, -%s from the old one !",
	recRemains = "%s done in %s, +%s from the best record !",
	list = "Records list",
	listDesc = "Shows a list of all records",
	move = "Move Frame",
	moveDesc = "Move the timers frame"
} end);

L:RegisterTranslations("frFR", function() return {
	firstRec = "Premier enregistrement pour %s : %s.",
	newRec = "Nouveau record pour %s !! Faites en %s, -%s par rapport a l'ancien",
	recRemains = "%s fait en %s, +%s par rapport au meilleur record !",
	list = "Records list",
	listDesc = "Shows a list of all records",
	move = "Move Frame",
	moveDesc = "Move the timers frame"
} end);

VanillaSpeedRun = AceLibrary("AceAddon-2.0"):new("AceConsole-2.0", "AceEvent-2.0", "AceModuleCore-2.0");
VanillaSpeedRun:SetModuleMixins("AceEvent-2.0")
VanillaSpeedRun.recordedInstance = {};
VanillaSpeedRun.currentZone = nil;
VanillaSpeedRun.recording = false;
VanillaSpeedRun.bossdwn = 0;
VanillaSpeedRun.start = nil;
VanillaSpeedRun.timer = 0;
VanillaSpeedRun.firstMob = nil;
VanillaSpeedRun.instStruct = nil;
VanillaSpeedRun.lastBoss = nil;
VanillaSpeedRun.bossnbr = nil;
VanillaSpeedRun.varPath = nil;
VanillaSpeedRun.move = false;


local slashOptions = {
	type = 'group',
	args={
		list = {
			type='execute',
			name=L["list"],
			desc=L["listDesc"],
			func = function() VanillaSpeedRun:list() end

		},
		move = {
			type='toggle',
			name=L["move"],
			desc=L["moveDesc"],
			get = function() return VanillaSpeedRun.move end,
			set = function() MakeMovable(VanillaSpeedRun.VSR_MAIN_FRAME); end,
		},
	}
}
VanillaSpeedRun:RegisterChatCommand({"/VSR"}, slashOptions);

function VanillaSpeedRun:initFrames()
	self.VSR_SEGMENTS = nil;
	self.VSR_SEGMENTS_seg = {};
	self.VSR_SEGMENTS_tim = {};
	
	self.VSR_MAIN_FRAME = CreateFrame("Frame", "VSR_MAIN_FRAME");
	self.VSR_MAIN_FRAME:SetFrameStrata("BACKGROUND");
	self.VSR_MAIN_FRAME:SetWidth(150);
	self.VSR_MAIN_FRAME:SetHeight(25);
	self.VSR_MAIN_FRAME:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeSize = 5});
	self.VSR_MAIN_FRAME:SetBackdropColor(0,0,0,VSRoptions["alpha"]);
	self.VSR_MAIN_FRAME:EnableMouse(true);
	self.VSR_MAIN_FRAME:SetPoint(VSRoptions["point"], VSRoptions["xOfs"], VSRoptions["yOfs"]);
	self.VSR_MAIN_FRAME:SetScale(VSRoptions["scale"])
	self.VSR_MAIN_FRAME:Show();

	self.VSR_TITLE = CreateFrame("Frame", "VSR_TITLE", self.VSR_MAIN_FRAME);
	self.VSR_TITLE:SetPoint("TOP", "VSR_MAIN_FRAME", 0, -0);
	self.VSR_TITLE:SetPoint("BOTTOM", "VSR_MAIN_FRAME", 0, -0);
	self.VSR_TITLE:SetPoint("LEFT", "VSR_MAIN_FRAME", 0, -0);
	self.VSR_TITLE:SetPoint("RIGHT", "VSR_MAIN_FRAME", 0, -0);

	self.VSR_TITLE_text = VSR_TITLE:CreateFontString("VSR_TITLE_text", "ARTWORK", "GameFontWhite")
	self.VSR_TITLE_text:SetPoint("TOP", "VSR_TITLE", 0, -5);
	self.VSR_TITLE_text:SetText("Vanilla SpeedRun");
	self.VSR_TITLE_text:SetFont("Fonts\\FRIZQT__.TTF", 10)
	self.VSR_TITLE_text:SetTextColor(0.90, 0.45, 0.45, 1);

	self.VSR_CURRINST = CreateFrame("Frame", "VSR_CURRINST", self.VSR_MAIN_FRAME);
	self.VSR_CURRINST:SetPoint("TOP", "VSR_TITLE_text", "BOTTOM", 0, -5);
	self.VSR_CURRINST:SetPoint("BOTTOM", "VSR_TITLE", 0, -0);
	self.VSR_CURRINST:SetPoint("LEFT", "VSR_TITLE", 0, -0);
	self.VSR_CURRINST:SetPoint("RIGHT", "VSR_TITLE", 0, -0);

	self.VSR_CURRINST_text = VSR_CURRINST:CreateFontString("VSR_CURRINST_text", "ARTWORK", "GameFontNormal")
	self.VSR_CURRINST_text:SetPoint("TOP", "VSR_CURRINST", 0, -0);
	self.VSR_CURRINST_text:SetPoint("LEFT", "VSR_CURRINST", 5, -0);
	self.VSR_CURRINST_text:SetJustifyH("LEFT");
	self.VSR_CURRINST_text:SetFont("Fonts\\FRIZQT__.TTF", 8)

	self.VSR_CURRINST_timer = VSR_CURRINST:CreateFontString("VSR_CURRINST_timer", "ARTWORK", "GameFontWhite")
	self.VSR_CURRINST_timer:SetPoint("TOP", "VSR_CURRINST", 0, -0);
	self.VSR_CURRINST_timer:SetPoint("RIGHT", "VSR_CURRINST", -5, -0);
	self.VSR_CURRINST_timer:SetJustifyH("RIGHT");
	self.VSR_CURRINST_timer:SetFont("Fonts\\FRIZQT__.TTF", 8)
end

-- Utility --
function print(msg)
	DEFAULT_CHAT_FRAME:AddMessage(msg);
end

function has_value (tab, val)
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

function MakeMovable(frame)
	if not VanillaSpeedRun.move then
		VanillaSpeedRun.move = true;
		frame:SetMovable(true);
		frame:RegisterForDrag("LeftButton");
		frame:SetScript("OnDragStart", function() this:StartMoving() end);
		frame:SetScript("OnDragStop", function() this:StopMovingOrSizing() end);
	else
		VanillaSpeedRun.move = false;
		VSRoptions["point"], _, _, VSRoptions["xOfs"], VSRoptions["yOfs"] = frame:GetPoint()
		frame:SetMovable(false);
		frame:RegisterForDrag(nil);
		frame:SetScript("OnDragStart", nil);
		frame:SetScript("OnDragStop", nil);
	end
end

function SecondsToClock(seconds)
	if seconds == nil then return false end;
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
---------------

function VanillaSpeedRun:list()
	for zone,array in pairs(VSR) do
		if zone ~= "currentInst" then
			time = SecondsToClock(array["best"]) or "none";
			print(string.format("%s : %s", zone, time));
		end
	end
end

---------------
VanillaSpeedRun.modulePrototype.core = VanillaSpeedRun;

function VanillaSpeedRun.modulePrototype:InitialiseRecord(zone, varPath, lastBoss, instStruct, firstmob, bossnbr)
	local lastKey = nil;
	self.core.currInst = zone;
	self.core.bossdwn = 0;
	self.core.firstMob = firstmob;
	self.core.instStruct = instStruct;
	self.core.lastBoss = lastBoss;
	self.core.varPath = varPath;
	self.core.bossnbr = bossnbr;
	self.core.timer = 0;

	-- if we have a "saved" run ongoing for less than 6 hours we just reload it
	if(VSR["currentInst"]["zone"] == zone and (math.floor(GetTime()) - VSR["currentInst"]["start"]) < (6 * 60 * 60)) then
		self.core.recording = true;
		self.core.bossdwn = VSR["currentInst"]["bossdwn"];
		self.core.start = VSR["currentInst"]["start"];
	end
	
    if (self.core.VSR_SEGMENTS ~= nil) then self.core.VSR_SEGMENTS:Hide(); end

    self.core.VSR_CURRINST_text:SetText(zone)
    self.core.VSR_CURRINST_timer:SetText("00:00:00")
	self.core.VSR_CURRINST_timer:SetTextColor(1, 1, 1, 1);

	self.core.VSR_SEGMENTS_seg = {};
	self.core.VSR_SEGMENTS_tim = {};

	self.core.VSR_SEGMENTS = CreateFrame("Frame", "VSR_SEGMENTS", self.core.VSR_MAIN_FRAME);
    self.core.VSR_SEGMENTS:SetPoint("TOP", "VSR_CURRINST_text", "BOTTOM", 0, -5);

    self.core.VSR_SEGMENTS:SetPoint("BOTTOM", "VSR_TITLE", 0, -0);
    self.core.VSR_SEGMENTS:SetPoint("LEFT", "VSR_TITLE", 0, -0);
    self.core.VSR_SEGMENTS:SetPoint("RIGHT", "VSR_TITLE", 0, -0);

    self.core.VSR_SEGMENTS_bestTxt = VSR_SEGMENTS:CreateFontString("VSR_SEGMENTS_bestTxt", "ARTWORK", "GameFontNormal")
    self.core.VSR_SEGMENTS_bestTxt:SetPoint("TOP", "VSR_CURRINST_text", "BOTTOM", 0, -0);
    self.core.VSR_SEGMENTS_bestTxt:SetPoint("LEFT", "VSR_SEGMENTS", 5, -0);
    self.core.VSR_SEGMENTS_bestTxt:SetJustifyH("LEFT");
    self.core.VSR_SEGMENTS_bestTxt:SetFont("Fonts\\FRIZQT__.TTF", 8)
    self.core.VSR_SEGMENTS_bestTxt:SetText("BEST :")
    self.core.VSR_SEGMENTS_bestTim = VSR_SEGMENTS:CreateFontString("VSR_SEGMENTS_bestTim", "ARTWORK", "GameFontWhite")
    self.core.VSR_SEGMENTS_bestTim:SetPoint("TOP", "VSR_CURRINST_timer", "BOTTOM", 0, -0);
    self.core.VSR_SEGMENTS_bestTim:SetPoint("RIGHT", "VSR_SEGMENTS", -5, -0);
    self.core.VSR_SEGMENTS_bestTim:SetJustifyH("RIGHT");
    self.core.VSR_SEGMENTS_bestTim:SetFont("Fonts\\FRIZQT__.TTF", 8)
	local bestTime = (SecondsToClock(varPath["best"]) or "none");
	self.core.VSR_SEGMENTS_bestTim:SetText(bestTime);
	
	local count = 0;
    for key, value in instStruct do
        if (key ~= "lastBoss") then
            count = count +1;
            self.core.VSR_SEGMENTS_seg[key] = self.core.VSR_SEGMENTS:CreateFontString("VSR_SEGMENTS_Seg"..key, "ARTWORK", "GameFontWhite");
			self.core. VSR_SEGMENTS_tim[key] = self.core.VSR_SEGMENTS:CreateFontString("VSR_SEGMENTS_tim"..key, "ARTWORK", "GameFontWhite");
            if (lastKey ~= nil) then 
                self.core.VSR_SEGMENTS_seg[key]:SetPoint("TOP", "VSR_SEGMENTS_Seg"..lastKey, "BOTTOM", 0, -0);
                self.core.VSR_SEGMENTS_tim[key]:SetPoint("TOP", "VSR_SEGMENTS_tim"..lastKey, "BOTTOM", 0, -0);
            else 
                self.core.VSR_SEGMENTS_seg[key]:SetPoint("TOP", "VSR_SEGMENTS", 0, -10);
                self.core.VSR_SEGMENTS_tim[key]:SetPoint("TOP", "VSR_SEGMENTS", 0, -10);
            end
            self.core.VSR_SEGMENTS_seg[key]:SetPoint("LEFT", "VSR_SEGMENTS", 5, -0);
            self.core.VSR_SEGMENTS_seg[key]:SetJustifyH("LEFT");
            self.core.VSR_SEGMENTS_seg[key]:SetFont("Fonts\\FRIZQT__.TTF", 8)
            self.core.VSR_SEGMENTS_seg[key]:SetText(value);

            self.core.VSR_SEGMENTS_tim[key]:SetPoint("RIGHT", "VSR_SEGMENTS", -5, -0);
            self.core.VSR_SEGMENTS_tim[key]:SetJustifyH("RIGHT");
            self.core.VSR_SEGMENTS_tim[key]:SetFont("Fonts\\FRIZQT__.TTF", 8)
            self.core.VSR_SEGMENTS_tim[key]:SetText("none");
            if (varPath[key] ~= nil) then
                self.core.VSR_SEGMENTS_tim[key]:SetText(SecondsToClock(varPath[key]));
            end
            lastKey = key;
        end
    end
    self.core.VSR_MAIN_FRAME:SetHeight(40 +(count * 10));
    self.core.timer = 0;
end

function VanillaSpeedRun.modulePrototype:Update()
	if (VanillaSpeedRun.recording and VanillaSpeedRun.start ~= nil) then
        VanillaSpeedRun.timer = math.floor(GetTime())-VanillaSpeedRun.start
        if VanillaSpeedRun.timer < 0 then
            VanillaSpeedRun.timer = 0
        end
        VanillaSpeedRun.VSR_CURRINST_timer:SetText(SecondsToClock(VanillaSpeedRun.timer));
        VanillaSpeedRun.VSR_CURRINST_timer:SetTextColor(0.90, 0.45, 0.45, 1);
	end
end

function VanillaSpeedRun.modulePrototype:firstMobDeath(msg)
	for mob,_ in pairs(self.core.firstMob) do
		if (msg == string.format(UNITDIESOTHER, mob)) then
			self.core.recording = true;
			self.core.start = math.floor(GetTime());
			self.core.SaveCurrent();
		end
	end
end

function VanillaSpeedRun.modulePrototype:CustomMobDeath(msg)
	self.core.SaveCurrent();
	-- Some instance specials
end

function VanillaSpeedRun.modulePrototype:genericBossDeath(msg)
	for key,boss in pairs(self.core.instStruct) do
		if (msg == string.format(UNITDIESOTHER, boss)) then
			self.core.bossdwn = self.core.bossdwn +1;
			self.core.SaveCurrent();
			if (self.core.varPath[key] ~= nil) then
				local oldRecord = self.core.varPath[key];
				if (oldRecord > self.core.timer) then
					local diff = oldRecord-self.core.timer;
					self.core.VSR_SEGMENTS_tim[key]:SetText(SecondsToClock(self.core.timer).." (-"..STC_MIN(diff)..')');
					self.core.VSR_SEGMENTS_tim[key]:SetTextColor(0.45, 0.90, 0.45, 1);
					self.core.varPath[key] = self.core.timer;
				else 
					local diff = self.core.timer-oldRecord;
					self.core.VSR_SEGMENTS_tim[key]:SetText(SecondsToClock(self.core.timer).." (+"..STC_MIN(diff)..')');
					self.core.VSR_SEGMENTS_tim[key]:SetTextColor(0.90, 0.45, 0.45, 1);
				end
			else
				self.core.VSR_SEGMENTS_tim[key]:SetText(SecondsToClock(self.core.timer));
				self.core.varPath[key] = self.core.timer;
			end
		end
	end
end

function VanillaSpeedRun.modulePrototype:lastBossDeath(msg)
	if self.core.recording and (msg == string.format(UNITDIESOTHER, self.core.lastBoss)) and (self.core.bossdwn == self.core.bossnbr) then
		self.core.recording = false;
		if (self.core.varPath["best"] == nil) then 
			self.core.varPath["best"] = self.core.timer;
			self.core.VSR_SEGMENTS_bestTim:SetText(SecondsToClock(self.core.timer));
			self.core.VSR_CURRINST_timer:SetTextColor(0.90, 0.45, 0.45, 1);
			SendChatMessage(string.format(L["firstRec"], GetRealZoneText(), SecondsToClock(self.core.timer)));
		else
			if (self.core.timer < self.core.varPath["best"]) then 
				local diff = self.core.varPath["best"]-self.core.timer;
				self.core.varPath["best"] = self.core.timer; 
				self.core.VSR_SEGMENTS_bestTim:SetText(SecondsToClock(self.core.timer));
				self.core.VSR_CURRINST_timer:SetText(SecondsToClock(self.core.timer).." (-"..STC_MIN(diff)..')');
				self.core.VSR_CURRINST_timer:SetTextColor(0.45, 0.90, 0.45, 1);
				SendChatMessage(string.format(L["newRec"], GetRealZoneText(), SecondsToClock(self.core.timer), STC_MIN(diff)));

			else 
				local diff = self.core.timer-self.core.varPath["best"];
				self.core.VSR_CURRINST_timer:SetText(SecondsToClock(self.core.timer).." (+"..STC_MIN(diff)..')');
				self.core.VSR_CURRINST_timer:SetTextColor(0.90, 0.45, 0.45, 1);
				SendChatMessage(string.format(L["recRemains"], GetRealZoneText(), SecondsToClock(self.core.timer), STC_MIN(diff)));
			end
		end
	end
end

function VanillaSpeedRun.modulePrototype:mobDeath(msg)
	if not self.core.recording then
		self:firstMobDeath(msg);
	else
		self:CustomMobDeath(msg);
		self:genericBossDeath(msg);
		self:lastBossDeath(msg);
	end
end

function VanillaSpeedRun.modulePrototype:IsRegistered()
	return self.registered
end

function VanillaSpeedRun:SaveCurrent()
	if VanillaSpeedRun.recording then
		VSR["currentInst"]["zone"] = VanillaSpeedRun.currInst;
		VSR["currentInst"]["start"] = VanillaSpeedRun.start;
		VSR["currentInst"]["bossdwn"] = VanillaSpeedRun.bossdwn;
	end
end

function VanillaSpeedRun:RegisterModule(name, module)
	if module:IsRegistered() then
		print(string.format("%q is already registered.", name))
		return
	end

	module.registered = true
	if module.OnRegister and type(module.OnRegister) == "function" then
		module:OnRegister()
	end
end

function VanillaSpeedRun:OnInitialize()
	-- Init the saved variable
	if (VSR == nil) then
		VSR = {};
	end

	if (VSR["currentInst"] == nil) then
		VSR["currentInst"] = {
			["zone"] = nil,
			["start"] = nil,
			["bossdwn"] = nil
		}
	end
	
	if (VSRoptions == nil) then
		VSRoptions = {
			["point"] = "CENTER",
			["xOfs"] = 0,
			["yOfs"] = 0,
			["scale"] = 1,
			["alpha"] = 0.5,
		};

	end

	self:initFrames();

	for name, module in self:IterateModules() do
		self:ToggleModuleActive(module, false);
	end

	local IsInInstance = IsInInstance;
	if (VanillaSpeedRun.recording == false) and IsInInstance("player") and self:HasModule(GetRealZoneText()) then
		self:ToggleModuleActive(GetRealZoneText(), true);
	end

	self:RegisterEvent("ZONE_CHANGED_NEW_AREA");
end

function VanillaSpeedRun:ZONE_CHANGED_NEW_AREA()
	local IsInInstance = IsInInstance;
	if (self.currentZone ~= nil and IsInInstance("player") and self:HasModule(self.currentZone) and zone ~= GetRealZoneText()) then
		VanillaSpeedRun.recording = false;
		self:ToggleModuleActive(self.currentZone, true);
	end
		
	self.currentZone = GetRealZoneText();
	if (VanillaSpeedRun.recording == false) and IsInInstance("player") and self:HasModule(self.currentZone) then
		self:ToggleModuleActive(self.currentZone, true);
	end
end

