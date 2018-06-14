local PowerUps = AmmoClip

function PowerUps:init(unit)
	PowerUps.super.init(self, unit)

	--self._ammo_type = ""
    --self._ammo_box = self._unit:name() == Idstring("units/pickups/ammo/ammo_pickup")
    self._power_up_id = self._power_up_id or 1
end

function PowerUps:reload_contour()
end

function PowerUps:_pickup(unit)
	if self._picked_up then
		return
	end

	local player_manager = managers.player
	local inventory = unit:inventory()

	if not unit:character_damage():dead() and inventory then
        self._picked_up = true

        if self._power_up_id == 1 then  -- MAX AMMO
            managers.wdu:power_ups():execute_max_ammo()
        elseif self._power_up_id == 2 then -- DOUBLE POINTS
            managers.wdu:power_ups():execute_double_points()
        elseif self._power_up_id == 3 then -- INSTAKILL
            managers.wdu:power_ups():execute_instakill()
        elseif self._power_up_id == 4 then -- FIRESALE
            managers.wdu:power_ups():execute_firesale()
        elseif self._power_up_id == 5 then -- KABOOM
            managers.wdu:power_ups():execute_kaboom()
        end

        if Network:is_client() then
            managers.network:session():send_to_host("sync_pickup", self._unit)
        end

        managers.wdu:_element_play_sound({
            name = "power_up_taken",
            file_name = "gift_taken.ogg",
            sound_type = "sfx",
            custom_dir = "sound",
            is_relative = false,
            is_loop = false,
            is_3d = false,
            use_velocity = false
        })

        self:consume()

        --if self._ammo_box then
        --	player_manager:send_message(Message.OnAmmoPickup, nil, unit)
        --end
        
        -- ^ unsure what this does.

        return true
	end

	return false
end

function PowerUps:sync_net_event(event, peer)
end