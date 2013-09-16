OM_roster = {
	{
		unit = "player",
		hp = OM_UnitHP("player"),
		role = UnitGroupRolesAssigned("player"),
	}
}

if IsInRaid() then
	tremove(OM_roster, 1)
end

local NumGroupMembers = IsInRaid() and GetNumGroupMembers()
		or IsInGroup() and GetNumSubgroupMembers()
		or 0

if not OM_AddToRoster then
	function OM_AddToRoster (aunit, hp, role)
		if OM_UnitRosterCheck(aunit) then
			tinsert(OM_roster, {
				unit = aunit,
				hp = hp,
				role = role,
				}
			)
		end
	end
end

if not OM_RemoveFromRoster then
	function OM_RemoveFromRoster (unit)
		for i = 1, #OM_roster do
			local aunit = OM_roster[i].unit
			if UnitIsUnit(unit, aunit) then
				tremove(OM_roster, i)
			end
		end
	end
end

if not OM_UnitRosterCheck then
	function OM_UnitRosterCheck(unit)
		if UnitInRange(unit)
				and UnitCanAssist("player", unit)
				and not UnitIsDeadOrGhost(unit)
				and not OM_LineOfSight(unit) then
			return true
		end
	end
end

if not OM_SortRoster then
 function OM_SortRoster()
 	table.sort(OM_roster, function(x, y) return x.hp < y.hp end)
 end
end

if not OM_HealTarget then
	function OM_HealTarget()
		local OM_roster = OM_roster
		for i = 1, #OM_roster do
			local unit, hp, role = OM_roster[i].unit, OM_roster[i].hp, OM_roster[i].role
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
		return OM_roster[1].unit, OM_roster[1].hp, OM_roster[1].role
	end
end
		
for i = 1, NumGroupMembers do
	local unit = IsInRaid() and "raid" .. i
			or "party" .. i
	if OM_UnitRosterCheck(unit) then
		tinsert(OM_roster, {
			unit = unit,
			hp = OM_UnitHP(unit),
			role = UnitGroupRolesAssigned(unit),
		})
	end
	local pet = unit .. "-pet"
	if OM_UnitRosterCheck(pet) then
		tinsert(OM_roster, {
			unit = pet,
			hp = OM_UnitHP(pet) * 1.15,
			role = "PET",
		})
	end
end