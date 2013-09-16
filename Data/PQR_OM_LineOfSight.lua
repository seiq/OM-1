------------------------
-- [OM] LINE OF SIGHT --
------------------------

OM_LineOfSightFrame = OM_LineOfSightFrame or CreateFrame("FRAME", nil, UIParent)
OM_LineOfSightTable = OM_LineOfSightTable or { }

local OM_LineOfSightTable = OM_LineOfSightTable
for i = 1, #OM_LineOfSightTable do
	local time = OM_LineOfSightTable[i].time
	local rate = 1
	if time
			and GetTime() > time + rate then
		tremove(OM_LineOfSightTable, i)
	end
end

local function OM_LineOfSight_OnEvent(self, event, arg1)
	if event == "UI_ERROR_MESSAGE" then
		if arg1 == SPELL_FAILED_LINE_OF_SIGHT then
			local unit = OM_CastTarget
					or "Unknown"
			if not UnitIsUnit("player", unit) then
				tinsert(OM_LineOfSightTable, 1, { unit = unit, time = GetTime() })
			end
		end
	end
end

OM_LineOfSightFrame:SetScript("OnEvent", OM_LineOfSight_OnEvent)
OM_LineOfSightFrame:RegisterEvent("UI_ERROR_MESSAGE")

if not OM_LineOfSight then
	function OM_LineOfSight(unit)
		local OM_LineOfSightTable = OM_LineOfSightTable
		for i = 1, #OM_LineOfSightTable do
			if unit == OM_LineOfSightTable[i].unit then
				return 1
			end
		end
	end
end