local mvec3_set = mvector3.set
local mvec3_add = mvector3.add
local mvec3_dot = mvector3.dot
local mvec3_sub = mvector3.subtract
local mvec3_mul = mvector3.multiply
local mvec3_norm = mvector3.normalize
local mvec3_dir = mvector3.direction
local mvec3_set_l = mvector3.set_length
local mvec3_len = mvector3.length
local math_clamp = math.clamp
local math_lerp = math.lerp
local tmp_vec1 = Vector3()
local tmp_vec2 = Vector3()
local ids_single = Idstring("single")
local ids_auto = Idstring("auto")

function NewRaycastWeaponBase:reload_speed_multiplier()
	if self._current_reload_speed_multiplier then
		return self._current_reload_speed_multiplier
	end

	local multiplier = 1

	for _, category in ipairs(self:weapon_tweak_data().categories) do
		multiplier = multiplier + 1 - managers.player:upgrade_value(category, "reload_speed_multiplier", 1)
	end

	multiplier = multiplier + 1 - managers.player:upgrade_value("weapon", "passive_reload_speed_multiplier", 1)
	multiplier = multiplier + 1 - managers.player:upgrade_value(self._name_id, "reload_speed_multiplier", 1)

	if self._setup and alive(self._setup.user_unit) and self._setup.user_unit:movement() then
		local morale_boost_bonus = self._setup.user_unit:movement():morale_boost()

		if morale_boost_bonus then
			multiplier = multiplier + 1 - morale_boost_bonus.reload_speed_bonus
		end

		if self._setup.user_unit:movement():next_reload_speed_multiplier() then
			multiplier = multiplier + 1 - self._setup.user_unit:movement():next_reload_speed_multiplier()
		end
	end

	if managers.player:has_activate_temporary_upgrade("temporary", "reload_weapon_faster") then
		multiplier = multiplier + 1 - managers.player:temporary_upgrade_value("temporary", "reload_weapon_faster", 1)
	end

	if managers.player:has_activate_temporary_upgrade("temporary", "single_shot_fast_reload") then
		multiplier = multiplier + 1 - managers.player:temporary_upgrade_value("temporary", "single_shot_fast_reload", 1)
	end

	multiplier = multiplier + 1 - managers.player:get_property("shock_and_awe_reload_multiplier", 1)
	multiplier = multiplier + 1 - managers.player:get_temporary_property("bloodthirst_reload_speed", 1)
	multiplier = multiplier + 1 - managers.player:upgrade_value("team", "crew_faster_reload", 1)
	multiplier = self:_convert_add_to_mul(multiplier)
	multiplier = multiplier * self:reload_speed_stat()
    multiplier = managers.crime_spree:modify_value("WeaponBase:GetReloadSpeedMultiplier", multiplier)
    multiplier = multiplier * (managers.player:has_special_equipment("perk_speedcola") and 2 or 1)

	return multiplier
end

Hooks:PostHook(NewRaycastWeaponBase, "init", "Waffe_AddBulletTrail", function(self)
	local allowed_weapons = {
		"wunderwaffe_primary",
		"wunderwaffe_secondary",
		"wunderwaffe_dg3_primary",
		"wunderwaffe_dg3_secondary"
	}

	for k, v in pairs(allowed_weapons) do
		if self._name_id == v then

			self.TRAIL_EFFECT = Idstring("effects/particles/weapons/shovel")

			if v == "wunderwaffe_dg3_primary" or v == "wunderwaffe_dg3_secondary" then
				self.TRAIL_EFFECT = Idstring("effects/particles/weapons/super_shovel")
			end

			self._trail_effect_table = {
				effect = self.TRAIL_EFFECT,
				position = Vector3(),
				normal = Vector3()
			}
	   end
	end
end)

Hooks:PostHook(NewRaycastWeaponBase, "fire", "Waffe_FireBulletTrail", function(self, from_pos, direction)
	local allowed_weapons = {
		"wunderwaffe_primary",
		"wunderwaffe_secondary",
		"wunderwaffe_dg3_primary",
		"wunderwaffe_dg3_secondary"
	}

	for k, v in pairs(allowed_weapons) do
		if self._name_id == v then
			self._obj_fire:m_position(self._trail_effect_table.position)
			mvector3.set(self._trail_effect_table.normal, direction)
			World:effect_manager():spawn(self._trail_effect_table)
		end
	end
end)

function NewRaycastWeaponBase:_update_stats_values(disallow_replenish)
	self:_check_sound_switch()

	self._silencer = managers.weapon_factory:has_perk("silencer", self._factory_id, self._blueprint)
	self._locked_fire_mode = managers.weapon_factory:has_perk("fire_mode_auto", self._factory_id, self._blueprint) and ids_auto or managers.weapon_factory:has_perk("fire_mode_single", self._factory_id, self._blueprint) and ids_single
	self._fire_mode = self._locked_fire_mode or self:get_recorded_fire_mode(self:_weapon_tweak_data_id()) or Idstring(self:weapon_tweak_data().FIRE_MODE or "single")
	self._ammo_data = managers.weapon_factory:get_ammo_data_from_weapon(self._factory_id, self._blueprint) or {}
	self._can_shoot_through_shield = tweak_data.weapon[self._name_id].can_shoot_through_shield
	self._can_shoot_through_enemy = tweak_data.weapon[self._name_id].can_shoot_through_enemy
	self._can_shoot_through_wall = tweak_data.weapon[self._name_id].can_shoot_through_wall
	self._armor_piercing_chance = self:weapon_tweak_data().armor_piercing_chance or 0
	local primary_category = self:weapon_tweak_data().categories and self:weapon_tweak_data().categories[1]
	self._movement_penalty = tweak_data.upgrades.weapon_movement_penalty[primary_category] or 1
	local custom_stats = managers.weapon_factory:get_custom_stats_from_weapon(self._factory_id, self._blueprint)

	for part_id, stats in pairs(custom_stats) do
		if stats.movement_speed then
			self._movement_penalty = self._movement_penalty * stats.movement_speed
		end

		if tweak_data.weapon.factory.parts[part_id].type ~= "ammo" then
			if stats.ammo_pickup_min_mul then
				self._ammo_data.ammo_pickup_min_mul = self._ammo_data.ammo_pickup_min_mul and self._ammo_data.ammo_pickup_min_mul * stats.ammo_pickup_min_mul or stats.ammo_pickup_min_mul
			end

			if stats.ammo_pickup_max_mul then
				self._ammo_data.ammo_pickup_max_mul = self._ammo_data.ammo_pickup_max_mul and self._ammo_data.ammo_pickup_max_mul * stats.ammo_pickup_max_mul or stats.ammo_pickup_max_mul
			end
		end
	end

	if self._ammo_data then
		if self._ammo_data.can_shoot_through_shield ~= nil then
			self._can_shoot_through_shield = self._ammo_data.can_shoot_through_shield
		end

		if self._ammo_data.can_shoot_through_enemy ~= nil then
			self._can_shoot_through_enemy = self._ammo_data.can_shoot_through_enemy
		end

		if self._ammo_data.can_shoot_through_wall ~= nil then
			self._can_shoot_through_wall = self._ammo_data.can_shoot_through_wall
		end

		if self._ammo_data.bullet_class ~= nil then
			self._bullet_class = CoreSerialize.string_to_classtable(self._ammo_data.bullet_class)
			self._bullet_slotmask = self._bullet_class:bullet_slotmask()
			self._blank_slotmask = self._bullet_class:blank_slotmask()
		end

		if self._ammo_data.armor_piercing_add ~= nil then
			self._armor_piercing_chance = math.clamp(self._armor_piercing_chance + self._ammo_data.armor_piercing_add, 0, 1)
		end

		if self._ammo_data.armor_piercing_mul ~= nil then
			self._armor_piercing_chance = math.clamp(self._armor_piercing_chance * self._ammo_data.armor_piercing_mul, 0, 1)
		end
	end

	if self._silencer then
		self._muzzle_effect = Idstring(self:weapon_tweak_data().muzzleflash_silenced or "effects/payday2/particles/weapons/9mm_auto_silence_fps")
	elseif self._ammo_data and self._ammo_data.muzzleflash ~= nil then
		self._muzzle_effect = Idstring(self._ammo_data.muzzleflash)
	else
		self._muzzle_effect = Idstring(self:weapon_tweak_data().muzzleflash or "effects/particles/test/muzzleflash_maingun")
	end

	self._muzzle_effect_table = {
		effect = self._muzzle_effect,
		parent = self._obj_fire,
		force_synch = self._muzzle_effect_table.force_synch or false
	}
	local base_stats = self:weapon_tweak_data().stats

	if not base_stats then
		return
	end

	local parts_stats = managers.weapon_factory:get_stats(self._factory_id, self._blueprint)
	local stats = deep_clone(base_stats)
	local stats_tweak_data = tweak_data.weapon.stats
	local modifier_stats = self:weapon_tweak_data().stats_modifiers
	local bonus_stats = self._cosmetics_bonus and self._cosmetics_data and self._cosmetics_data.bonus and tweak_data.economy.bonuses[self._cosmetics_data.bonus] and tweak_data.economy.bonuses[self._cosmetics_data.bonus].stats or {}

	if managers.job:is_current_job_competitive() or managers.weapon_factory:has_perk("bonus", self._factory_id, self._blueprint) then
		bonus_stats = {}
	end

	if stats.zoom then
		stats.zoom = math.min(stats.zoom + managers.player:upgrade_value(primary_category, "zoom_increase", 0), #stats_tweak_data.zoom)
	end

	for stat, _ in pairs(stats) do
		if stats[stat] < 1 or #stats_tweak_data[stat] < stats[stat] then
			Application:error("[NewRaycastWeaponBase] Base weapon stat is out of bound!", "stat: " .. stat, "index: " .. stats[stat], "max_index: " .. #stats_tweak_data[stat], "This stat will be clamped!")
		end

		if parts_stats[stat] then
			stats[stat] = stats[stat] + parts_stats[stat]
		end

		if bonus_stats[stat] then
			stats[stat] = stats[stat] + bonus_stats[stat]
		end

		stats[stat] = math_clamp(stats[stat], 1, #stats_tweak_data[stat])
	end

	self._current_stats_indices = stats
	self._current_stats = {}

	for stat, i in pairs(stats) do
		self._current_stats[stat] = stats_tweak_data[stat] and stats_tweak_data[stat][i] or 1

		if modifier_stats and modifier_stats[stat] then
			self._current_stats[stat] = self._current_stats[stat] * modifier_stats[stat]
		end
	end

	self._current_stats.alert_size = stats_tweak_data.alert_size[math_clamp(stats.alert_size, 1, #stats_tweak_data.alert_size)]

	if modifier_stats and modifier_stats.alert_size then
		self._current_stats.alert_size = self._current_stats.alert_size * modifier_stats.alert_size
	end

	if stats.concealment then
		stats.suspicion = math.clamp((#stats_tweak_data.concealment - base_stats.concealment) - (parts_stats.concealment or 0), 1, #stats_tweak_data.concealment)
		self._current_stats.suspicion = stats_tweak_data.concealment[stats.suspicion]
	end

	if parts_stats and parts_stats.spread_multi then
		self._current_stats.spread_multi = parts_stats.spread_multi
	end

	self._alert_size = self._current_stats.alert_size or self._alert_size
	self._suppression = self._current_stats.suppression or self._suppression
	self._zoom = self._current_stats.zoom or self._zoom
	self._spread = self._current_stats.spread or self._spread
	self._recoil = self._current_stats.recoil or self._recoil
	self._spread_moving = self._current_stats.spread_moving or self._spread_moving
	self._extra_ammo = self._current_stats.extra_ammo or self._extra_ammo
	self._total_ammo_mod = self._current_stats.total_ammo_mod or self._total_ammo_mod
	self._reload = self._current_stats.reload or self._reload
	self._spread_multiplier = self._current_stats.spread_multi or self._spread_multiplier
	self._has_gadget = managers.weapon_factory:get_parts_from_weapon_by_type_or_perk("gadget", self._factory_id, self._blueprint)
	self._scopes = managers.weapon_factory:get_parts_from_weapon_by_type_or_perk("scope", self._factory_id, self._blueprint)
	self._can_highlight_with_perk = managers.weapon_factory:has_perk("highlight", self._factory_id, self._blueprint)
	self._can_highlight_with_skill = managers.player:has_category_upgrade("weapon", "steelsight_highlight_specials")
	self._can_highlight = self._can_highlight_with_perk or self._can_highlight_with_skill

	self:_check_second_sight()
	self:_check_reticle_obj()

	if not disallow_replenish then
		self:replenish()
	end

	local user_unit = self._setup and self._setup.user_unit
	local current_state = alive(user_unit) and user_unit:movement() and user_unit:movement()._current_state
	self._fire_rate_multiplier = managers.blackmarket:fire_rate_multiplier(self._name_id, self:weapon_tweak_data().categories, self._silencer, nil, current_state, self._blueprint)

	if managers.player:has_special_equipment("perk_doubletap") then
		self._fire_rate_multiplier = self._fire_rate_multiplier * 10
	end
end

function NewRaycastWeaponBase:damage_multiplier()
	local multiplier
	local user_unit = self._setup and self._setup.user_unit
	local current_state = alive(user_unit) and user_unit:movement() and user_unit:movement()._current_state

	if managers.player:has_special_equipment("perk_doubletap") then
		multiplier = managers.blackmarket:damage_multiplier(self._name_id, self:weapon_tweak_data().categories, self._silencer, nil, current_state, self._blueprint) * 1.25
	else
		multiplier = managers.blackmarket:damage_multiplier(self._name_id, self:weapon_tweak_data().categories, self._silencer, nil, current_state, self._blueprint)
	end

	return multiplier
end