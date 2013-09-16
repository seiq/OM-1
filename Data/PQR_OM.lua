--------------
-- SPELL ID --
--------------
function OM_convert(spell)
	local spell = GetSpellInfo(spell)
	return spell
end

--------------------
-- CAST / CHANNEL --
--------------------
function OM_Cast(spell, unit)
	local spell = OM_convert(spell)
	if IsUsableSpell(spell)
			and GetSpellCooldown(spell) == 0
			and not UnitCastingInfo("player")
			and not UnitChannelInfo("player")
			and not OM_LineOfSight(unit) then
		OM_CastTarget = unit 
		CastSpellByName(spell, unit)
	end
end
function OM_AECast(spell, unit)
	local spell = OM_convert(spell)
	if GetSpellCooldown(spell)==0
			and GetMouseFocus() == WorldFrame
			and not GetCurrentKeyBoardFocus() 
			and not IsMouselooking() then
		OM_Cast(spell, unit)
		if SpellIsTargeting() then
			CameraOrSelectOrMoveStart()
			CameraOrSelectOrMoveStop() 
		end
	else 
		SpellStopTargeting() 
	end
end
function OM_SpecialCast(spell, unit)
	local spell = OM_convert(spell)
	if IsUsableSpell(spell)
			and GetSpellCooldown(spell) == 0
			and not OM_LineOfSight(unit) then
		OM_CastTarget = unit 
		CastSpellByName(spell, unit)
	end
end
function OM_StopCast(spell)
	local spell = OM_convert(spell)
	if UnitCastingInfo("player") == spell
			or UnitChannelInfo("player") == spell then
		SpellStopCasting()
	end
end
function OM_CanCast(spell, unit)
	local spell = OM_convert(spell)
	local unit = unit or "target"
	if UnitCanAttack("player", unit)
			and (not UnitIsDeadOrGhost(unit)
			or UnitIsFeignDeath(unit))
			and (IsSpellInRange(spell) == 1
			or not IsSpellInRange(spell)) then
		return true
	end
end

-------------------
-- BUFF / DEBUFF --
-------------------
function OM_UnitBuffSpecial(unit, spell)
	for i = 1, 40 do
		local b = { UnitBuff(unit, i) }
		if b[8] == "player"
				and b[11] == spell then
			return spell
		end
	end
end
function OM_UnitBuffCount(unit, spell, filter)
	local spell = OM_convert(spell)
	local buff = { UnitBuff(unit, spell, nil, filter) }
	if buff[1] then
		return buff[4]
	else
		return 0
	end
end
function OM_UnitDebuffCount(unit, spell, filter)
	local spell = OM_convert(spell)
	local debuff = { UnitDebuff(unit, spell, nil, filter) }
	if debuff[1] then
		return debuff[4]
	else
		return 0
	end
end
function OM_UnitBuffTime(unit, spell, filter)
	local spell = OM_convert(spell)
	local buff = { UnitBuff(unit, spell, nil, filter) }
	if buff[1] then
		return buff[7] - GetTime()
	else
		return 0
	end
end
function OM_UnitDebuffTime(unit, spell, filter)
	local spell = OM_convert(spell)
	local debuff = { UnitDebuff(unit, spell, nil, filter) }
	if debuff[1] then
		return debuff[7] - GetTime()
	else
		return 0
	end
end
function OM_UnitBuffSteal(unit)
	local spell = OM_convert(spell)
	for i = 1, 40 do
		local buff = { UnitBuff(unit, i) }
		if buff[9] then
			return 1
		end
	end
end

----------
-- INFO --
----------
function OM_UnitHP(unit)
	return UnitHealth(unit) / UnitHealthMax(unit) * 100
			or 0
end
function OM_UnitMP(unit)
	return UnitPower(unit, 0) / UnitPowerMax(unit, 0) * 100
			or 0
end
function OM_HasThreat(unit)
	local threat = UnitThreatSituation(unit)
	if UnitAffectingCombat("player")
			and threat then
		if threat >= 2 then
			return unit
		end
	else
		return nil
	end
end
function OM_EnergyTimeToMax(time)
	local timetomax = (UnitPowerMax("player", 3) - UnitPower("player", 3)) / GetPowerRegen()
	if timetomax >= time then
		return timetomax
	else
		return nil
	end
end
function OM_CooldownRemains(spellId)
	local base = GetSpellBaseCooldown(spellId) / 1000
	local cd = GetTime() - GetSpellCooldown(spellId)
	local remains = base - cd
	if remains <= base
			and remains >= 0 then
		return remains
	else
		return base
	end
end

--------------------
-- TALENT / GLYPH --
--------------------
function OM_TalentOption(tier)
	for i = 1, 18 do
		local talent = { GetTalentInfo(i) }
		if talent[3] == tier
				and talent[5] == true then
			return talent[1]
		end
	end
end
function OM_GlyphOption(id)
	for i = 1, 6 do
		local glyph = { GetGlyphSocketInfo(i) }
		if glyph[4] == id then
			return glyph[1]
		end
	end
end
	