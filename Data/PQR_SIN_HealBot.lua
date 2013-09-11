--------------------
-- [SIN] HEAL BOT --
--------------------

if not SIN_UnitRosterCheck then
	function SIN_UnitRosterCheck(unit)
		if UnitInRange(unit)
				and UnitCanAssist("player", unit)
				and not UnitIsDeadOrGhost(unit)
				and not SIN_LineOfSight(unit)
				--Amber-Shaper Un'sok (Parasitic Growth)
				and not UnitDebuff(unit, SIN_convert(121949))
				--Twin Consorts (Beast of Nightmares)
				and not UnitDebuff(unit, SIN_convert(137341))
				--H Tortos Full Capacity Shell
                and not UnitDebuff(unit, SIN_convert(140701)) then
			return true
		end
	end
end

if not SIN_UnitRosterHPMod then
	function SIN_UnitRosterHPMod(unit)
		if UnitDebuff(unit, SIN_convert(137633)) then
			return 70
		--elseif UnitBuff("player", "Test Buff") then
			--return 0
		--elseif UnitDebuff("player", SIN_convert(000000)) then
			--return 0
		else
			return nil
		end
	end
end

SIN_roster = {
	{
		unit = "player",
		hp = SIN_UnitRosterHPMod("player") or SIN_UnitHP("player"),
		role = UnitGroupRolesAssigned("player"),
	}
}

local NumGroupMembers = IsInRaid() and GetNumGroupMembers()
		or IsInGroup() and GetNumSubgroupMembers()
		or 0
for i = 1, NumGroupMembers do
	local unit = IsInRaid() and "raid" .. i
			or "party" .. i
	if SIN_UnitRosterCheck(unit) then
		tinsert(SIN_roster, {
			unit = unit,
			hp = SIN_UnitRosterHPMod(unit) or SIN_UnitHP(unit),
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

if IsInRaid() then
	tremove(SIN_roster, 1)
end

--Tsulong (Bathed in Light)
if UnitDebuff("player", SIN_convert(122858)) then
	tinsert(SIN_roster, { unit = "boss1", hp = 5, role = "BOSS" })
end

table.sort(SIN_roster, function(x, y) return x.hp < y.hp end)

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
			end
		end
		return SIN_roster[1].unit, SIN_roster[1].hp, SIN_roster[1].role
	end
else
	local Color = {
		["HUNTER"] = "abd473",
		["WARLOCK"] = "9482c9",
		["PRIEST"] = "ffffff",
		["PALADIN"] = "f58cba",
		["MAGE"] = "69ccf0",
		["ROGUE"] = "fff569",
		["DRUID"] = "ff7d0a",
		["SHAMAN"] = "0070de",
		["WARRIOR"] = "c79c6e",
		["DEATHKNIGHT"] = "c41f3b",
		["MONK"] = "00ff96",
	}
	local target, HP = SIN_HealTarget()
	local _, class = UnitClass(target)
	PQR_Event("PQR_Text", UnitName(target) .. " (" .. math.floor(HP * 10^1+ 0.5) / 10^1 .."%)", 3, Color[class])
end