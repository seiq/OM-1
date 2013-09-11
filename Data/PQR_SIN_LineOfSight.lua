-------------------------
-- [SIN] LINE OF SIGHT --
-------------------------

SIN_LineOfSightFrame = SIN_LineOfSightFrame or CreateFrame("FRAME", nil, UIParent)
SIN_LineOfSightTable = SIN_LineOfSightTable or { }

local SIN_LineOfSightTable = SIN_LineOfSightTable
for i = 1, #SIN_LineOfSightTable do
	local time = SIN_LineOfSightTable[i].time
	local rate = 1
	if time
			and GetTime() > time + rate then
		tremove(SIN_LineOfSightTable, i)
	end
end

local function SIN_LineOfSight_OnEvent(self, event, arg1)
	if event == "UI_ERROR_MESSAGE" then
		if arg1 == SPELL_FAILED_LINE_OF_SIGHT then
			local unit = SIN_CastTarget
					or "Unknown"
			if not UnitIsUnit("player", unit) then
				tinsert(SIN_LineOfSightTable, 1, { unit = unit, time = GetTime() })
			end
		end
	end
end

SIN_LineOfSightFrame:SetScript("OnEvent", SIN_LineOfSight_OnEvent)
SIN_LineOfSightFrame:RegisterEvent("UI_ERROR_MESSAGE")

if not SIN_LineOfSight then
	function SIN_LineOfSight(unit)
		local SIN_LineOfSightTable = SIN_LineOfSightTable
		for i = 1, #SIN_LineOfSightTable do
			if unit == SIN_LineOfSightTable[i].unit then
				return 1
			end
		end
	end
end