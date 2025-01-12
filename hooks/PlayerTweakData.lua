Hooks:PostHook(PlayerTweakData, "init", "zm_no_penalty_timer", function(self)
	self.damage.respawn_time_penalty = 0
	self.damage.base_respawn_time_penalty = 1
end)

Hooks:PostHook(PlayerTweakData, "_init_new_stances", "zm_init_new_stances", function(self)
    self.stances.nothing2_primary = deep_clone(self.stances.default)
    self.stances.nothing2_primary.standard.shoulders.translation = Vector3(1, 999999999, 0.2)
    self.stances.nothing2_primary.steelsight.shoulders.translation = Vector3(1, 999999999, 0.2)
    self.stances.nothing2_primary.crouched.shoulders.translation = Vector3(1, 999999999, -0.2)

	self.stances.wunderwaffe_primary = deep_clone(self.stances.default)
	local pivot_shoulder_translation = Vector3(10.5287, 10.4677, 0.247723)
	local pivot_shoulder_rotation = Rotation(0.000398715, -0.000868289, -0.000330621)
	local pivot_head_translation = Vector3(10, 14, 1)
	local pivot_head_rotation = Rotation(0, 0, 0)
	self.stances.wunderwaffe_primary.standard.shoulders.translation = Vector3(-0.777, 5.503, 4.127)
	self.stances.wunderwaffe_primary.standard.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.wunderwaffe_primary.standard.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -86, 0)
	local pivot_head_translation = Vector3(0, 20, 0)
	local pivot_head_rotation = Rotation(0, 0, 0)
	self.stances.wunderwaffe_primary.steelsight.shoulders.translation = Vector3(-10.529, 9.532, 2)
	self.stances.wunderwaffe_primary.steelsight.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.wunderwaffe_primary.steelsight.zoom_fov = false
	self.stances.wunderwaffe_primary.steelsight.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -50, 0)
	self.stances.wunderwaffe_primary.steelsight.vel_overshot.yaw_neg = 0
	self.stances.wunderwaffe_primary.steelsight.vel_overshot.yaw_pos = -0
	self.stances.wunderwaffe_primary.steelsight.vel_overshot.pitch_neg = -0
	self.stances.wunderwaffe_primary.steelsight.vel_overshot.pitch_pos = 0
	local pivot_head_translation = Vector3(9, 13, -1)
	local pivot_head_rotation = Rotation(0, 0, 0)
	self.stances.wunderwaffe_primary.crouched.shoulders.translation = Vector3(-0.777, 5.503, 4.127)
	self.stances.wunderwaffe_primary.crouched.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.wunderwaffe_primary.crouched.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -36, 0)

	self.stances.wunderwaffe_secondary = deep_clone(self.stances.wunderwaffe_primary)
	self.stances.wunderwaffe_dg3_primary = deep_clone(self.stances.wunderwaffe_primary)
	self.stances.wunderwaffe_dg3_secondary = deep_clone(self.stances.wunderwaffe_primary)
	self.stances.colt_1911_primary = deep_clone(self.stances.colt_1911)
	self.stances.colt_1911_secondary = deep_clone(self.stances.colt_1911)
	self.stances.new_m14_primary = deep_clone(self.stances.new_m14)
	self.stances.new_m14_secondary = deep_clone(self.stances.new_m14)
	self.stances.new_m14_upg_primary = deep_clone(self.stances.new_m14)
	self.stances.new_m14_upg_primary.steelsight.shoulders.translation = Vector3(-10.9, -20, -1)
	self.stances.new_m14_upg_secondary = deep_clone(self.stances.new_m14)
	self.stances.new_m14_upg_secondary.steelsight.shoulders.translation = Vector3(-10.9, -20, -1)
	self.stances.b682_primary = deep_clone(self.stances.b682)
	self.stances.b682_secondary = deep_clone(self.stances.b682)
	self.stances.mp9_primary = deep_clone(self.stances.mp9)
	self.stances.mp9_secondary = deep_clone(self.stances.mp9)
	self.stances.m95_primary = deep_clone(self.stances.m95)
	self.stances.m95_primary.steelsight.shoulders.translation = Vector3(-12.943, -41, -2)
	self.stances.m95_secondary = deep_clone(self.stances.m95)
	self.stances.m95_secondary.steelsight.shoulders.translation = Vector3(-12.943, -41, -2)
	self.stances.m95_upg_primary = deep_clone(self.stances.m95)
	self.stances.m95_upg_primary.steelsight.shoulders.translation = Vector3(-12.943, -43, -2)
	self.stances.m95_upg_secondary = deep_clone(self.stances.m95)
	self.stances.m95_upg_secondary.steelsight.shoulders.translation = Vector3(-12.943, -43, -2)
	self.stances.colt_1911_upg_primary = deep_clone(self.stances.colt_1911)
	self.stances.colt_1911_upg_secondary = deep_clone(self.stances.colt_1911)
	self.stances.b682_upg_primary = deep_clone(self.stances.b682)
	self.stances.b682_upg_secondary = deep_clone(self.stances.b682)
	self.stances.mp9_upg_primary = deep_clone(self.stances.mp9)
	self.stances.mp9_upg_secondary = deep_clone(self.stances.mp9)
	self.stances.roach_primary = deep_clone(self.stances.siltstone)
	self.stances.roach_secondary = deep_clone(self.stances.siltstone)
	self.stances.roach_upg_primary = deep_clone(self.stances.siltstone)
	self.stances.roach_upg_secondary = deep_clone(self.stances.siltstone)

	--shovel approved new stances
	self.stances.amcar_primary = deep_clone(self.stances.amcar)
	self.stances.amcar_secondary = deep_clone(self.stances.amcar)
	self.stances.amcar_upg_primary = deep_clone(self.stances.amcar)
	self.stances.amcar_upg_secondary = deep_clone(self.stances.amcar)

	self.stances.aug_primary = deep_clone(self.stances.aug)
	self.stances.aug_secondary = deep_clone(self.stances.aug)
	self.stances.aug_upg_primary = deep_clone(self.stances.aug)
	self.stances.aug_upg_secondary = deep_clone(self.stances.aug)
	
	self.stances.fal_primary = deep_clone(self.stances.fal)
	self.stances.fal_secondary = deep_clone(self.stances.fal)
	self.stances.fal_upg_primary = deep_clone(self.stances.fal)
	self.stances.fal_upg_secondary = deep_clone(self.stances.fal)
	
	self.stances.flint_primary = deep_clone(self.stances.flint)
	self.stances.flint_secondary = deep_clone(self.stances.flint)
	self.stances.flint_upg_primary = deep_clone(self.stances.flint)
	self.stances.flint_upg_secondary = deep_clone(self.stances.flint)
	
	self.stances.m16_primary = deep_clone(self.stances.m16)
	self.stances.m16_secondary = deep_clone(self.stances.m16)
	self.stances.m16_upg_primary = deep_clone(self.stances.m16)
	self.stances.m16_upg_secondary = deep_clone(self.stances.m16)
	
	self.stances.scar_primary = deep_clone(self.stances.scar)
	self.stances.scar_secondary = deep_clone(self.stances.scar)
	self.stances.scar_upg_primary = deep_clone(self.stances.scar)
	self.stances.scar_upg_secondary = deep_clone(self.stances.scar)
	
	self.stances.hk21_primary = deep_clone(self.stances.hk21)
	self.stances.hk21_secondary = deep_clone(self.stances.hk21)
	self.stances.hk21_upg_primary = deep_clone(self.stances.hk21)
	self.stances.hk21_upg_secondary = deep_clone(self.stances.hk21)
	
	self.stances.m249_primary = deep_clone(self.stances.m249)
	self.stances.m249_secondary = deep_clone(self.stances.m249)
	self.stances.m249_upg_primary = deep_clone(self.stances.m249)
	self.stances.m249_upg_secondary = deep_clone(self.stances.m249)
	
	self.stances.breech_primary = deep_clone(self.stances.breech)
	self.stances.breech_secondary = deep_clone(self.stances.breech)
	self.stances.breech_upg_primary = deep_clone(self.stances.breech)
	self.stances.breech_upg_secondary = deep_clone(self.stances.breech)
	
	self.stances.deagle_primary = deep_clone(self.stances.deagle)
	self.stances.deagle_secondary = deep_clone(self.stances.deagle)
	self.stances.deagle_upg_primary = deep_clone(self.stances.deagle)
	self.stances.deagle_upg_secondary = deep_clone(self.stances.deagle)
	
	self.stances.judge_primary = deep_clone(self.stances.judge)
	self.stances.judge_secondary = deep_clone(self.stances.judge)
	self.stances.judge_upg_primary = deep_clone(self.stances.judge)
	self.stances.judge_upg_secondary = deep_clone(self.stances.judge)
	
	self.stances.peacemaker_primary = deep_clone(self.stances.peacemaker)
	self.stances.peacemaker_secondary = deep_clone(self.stances.peacemaker)
	self.stances.peacemaker_upg_primary = deep_clone(self.stances.peacemaker)
	self.stances.peacemaker_upg_secondary = deep_clone(self.stances.peacemaker)
	
	self.stances.new_raging_bull_primary = deep_clone(self.stances.new_raging_bull)
	self.stances.new_raging_bull_secondary = deep_clone(self.stances.new_raging_bull)
	self.stances.new_raging_bull_upg_primary = deep_clone(self.stances.new_raging_bull)
	self.stances.new_raging_bull_upg_secondary = deep_clone(self.stances.new_raging_bull)
	
	self.stances.striker_primary = deep_clone(self.stances.striker)
	self.stances.striker_secondary = deep_clone(self.stances.striker)
	self.stances.striker_upg_primary = deep_clone(self.stances.striker)
	self.stances.striker_upg_secondary = deep_clone(self.stances.striker)
	
	self.stances.p90_primary = deep_clone(self.stances.p90)
	self.stances.p90_secondary = deep_clone(self.stances.p90)
	self.stances.p90_upg_primary = deep_clone(self.stances.p90)
	self.stances.p90_upg_secondary = deep_clone(self.stances.p90)
	
	self.stances.m1928_primary = deep_clone(self.stances.m1928)
	self.stances.m1928_secondary = deep_clone(self.stances.m1928)
	self.stances.m1928_upg_primary = deep_clone(self.stances.m1928)
	self.stances.m1928_upg_secondary = deep_clone(self.stances.m1928)

	self.stances.rpg7_primary = deep_clone(self.stances.rpg7)
	self.stances.rpg7_secondary = deep_clone(self.stances.rpg7)
	self.stances.rpg7_upg_primary = deep_clone(self.stances.rpg7)
	self.stances.rpg7_upg_secondary = deep_clone(self.stances.rpg7)
	
	--shovel mkii stances
	self.stances.ak74_primary = deep_clone(self.stances.ak74)
	self.stances.ak74_secondary = deep_clone(self.stances.ak74)
	self.stances.ak74_upg_primary = deep_clone(self.stances.ak74)
	self.stances.ak74_upg_secondary = deep_clone(self.stances.ak74)
	
	self.stances.ching_primary = deep_clone(self.stances.ching)
	self.stances.ching_secondary = deep_clone(self.stances.ching)
	self.stances.ching_upg_primary = deep_clone(self.stances.ching)
	self.stances.ching_upg_secondary = deep_clone(self.stances.ching)
	
	self.stances.lemming_primary = deep_clone(self.stances.lemming)
	self.stances.lemming_secondary = deep_clone(self.stances.lemming)
	self.stances.lemming_upg_primary = deep_clone(self.stances.lemming)
	self.stances.lemming_upg_secondary = deep_clone(self.stances.lemming)
	
	self.stances.m37_primary = deep_clone(self.stances.m37)
	self.stances.m37_secondary = deep_clone(self.stances.m37)
	self.stances.m37_upg_primary = deep_clone(self.stances.m37)
	self.stances.m37_upg_secondary = deep_clone(self.stances.m37)
	
	self.stances.r870_primary = deep_clone(self.stances.r870)
	self.stances.r870_secondary = deep_clone(self.stances.r870)
	self.stances.r870_upg_primary = deep_clone(self.stances.r870)
	self.stances.r870_upg_secondary = deep_clone(self.stances.r870)
	
	self.stances.erma_primary = deep_clone(self.stances.erma)
	self.stances.erma_secondary = deep_clone(self.stances.erma)
	self.stances.erma_upg_primary = deep_clone(self.stances.erma)
	self.stances.erma_upg_secondary = deep_clone(self.stances.erma)
	
	self.stances.schakal_primary = deep_clone(self.stances.schakal)
	self.stances.schakal_secondary = deep_clone(self.stances.schakal)
	self.stances.schakal_upg_primary = deep_clone(self.stances.schakal)
	self.stances.schakal_upg_secondary = deep_clone(self.stances.schakal)
	
	self.stances.tec9_primary = deep_clone(self.stances.tec9)
	self.stances.tec9_secondary = deep_clone(self.stances.tec9)
	self.stances.tec9_upg_primary = deep_clone(self.stances.tec9)
	self.stances.tec9_upg_secondary = deep_clone(self.stances.tec9)

	self.stances.msr_primary = deep_clone(self.stances.msr)
	self.stances.msr_primary.steelsight.shoulders.translation = Vector3(-8.7, -36, -1.3)
	self.stances.msr_secondary = deep_clone(self.stances.msr)
	self.stances.msr_secondary.steelsight.shoulders.translation = Vector3(-8.7, -36, -1.3)
	self.stances.msr_upg_primary = deep_clone(self.stances.msr)
	self.stances.msr_upg_primary.steelsight.shoulders.translation = Vector3(-8.7, -38, -1.3)
	self.stances.msr_upg_secondary = deep_clone(self.stances.msr)
	self.stances.msr_upg_secondary.steelsight.shoulders.translation = Vector3(-8.7, -38, -1.3)

	self.stances.vulcan_upg = deep_clone(self.stances.shuno)

	self.stances.deamon_primary = deep_clone(self.stances.boot)
	self.stances.deamon_secondary = deep_clone(self.stances.boot)
	self.stances.deamon_upg_primary = deep_clone(self.stances.boot)
	self.stances.deamon_upg_primary.steelsight.shoulders.translation = Vector3(-9.335, -5, 3)
	self.stances.deamon_upg_secondary = deep_clone(self.stances.boot)
	self.stances.deamon_upg_secondary.steelsight.shoulders.translation = Vector3(-9.335, -5, 3)
end)
