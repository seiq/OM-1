Om_roster = {
	{
		unit = "player",
		hp = SIN_UnitHP("player"),
		role = UnitGroupRolesAssigned("player"),
	}
}

if IsInRaid() then
	tremove(SIN_roster, 1)
end

local NumGroupMembers = IsInRaid() and GetNumGroupMembers()
		or IsInGroup() and GetNumSubgroupMembers()
		or 0

if not SIN_AddToRoster then
	function SIN_AddToRoster (unit, hp, role)
		if SIN_UnitRosterCheck(unit) then
			tinsert(SIN_roster, {
				unit = unit,
				hp = hp,
				role = role,
			}
		end
	end
end

if not SIN_RemoveFromRoster then
	function SIN_RemoveFromRoster (unit)
		for i = 1, #SIN_roster do
			local aunit = SIN_roster[i].unit
			if UnitIsUnit(unit, aunit) then
				tremove(SIN_roster, i)
			end
		end
	end
end

if not SIN_UnitRosterCheck then
	function SIN_UnitRosterCheck(unit)
		if UnitInRange(unit)
				and UnitCanAssist("player", unit)
				and not UnitIsDeadOrGhost(unit)
				and not SIN_LineOfSight(unit) then
			return true
		end
	end
end

if not SIN_SortRoaster then
 function SIN_SortRoaster()
 table.sort(SIN_roster, function(x, y) return x.hp < y.hp end)
end

if not SIN_HealTarget then
	function SIN_HealTarget()
		local SIN_roster = SIN_roster
		for i = 1, #SIN_roster do
			local unit, hp, role = SIN_roster[i].unit, SIN_roster[i].hp, SIN_roster[i].role
			if UnitIsUnit(unit, "player") and hp <= 20 then
				return unit, hp, role
			elseif role == "TANK" and hp <= 25 then
				return unit, hp, role
			elseif role == "HEALER" and hp <= 15 then
				return unit, hp, role
			elseif role == "PRIORITY" then
				return unit, hp, role
			end
		end
		return SIN_roster[1].unit, SIN_roster[1].hp, SIN_roster[1].role
	end
end
		
for i = 1, NumGroupMembers do
	local unit = IsInRaid() and "raid" .. i
			or "party" .. i
	if SIN_UnitRosterCheck(unit) then
		tinsert(SIN_roster, {
			unit = unit,
			hp = SIN_UnitHP(unit),
			role = UnitGroupRolesAssigned(unit),
		})
	end
	local pet = unit .. "-pet"
	if SIN_UnitRosterCheck(pet) then
		tinsert(SIN_roster, {
			unit = pet,
			hp = SIN_UnitHP(pet) * 1.15,
			role = "PET",
		})
	end
end