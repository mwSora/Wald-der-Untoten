function CopBase:_chk_spawn_gear()

    if self._tweak_table == "tank_hw" then --Disable glowy eyes on Headless Dozer
    else
        local align_obj_name = Idstring("Head")
        local align_obj = self._unit:get_object(align_obj_name)
        self._headwear_unit = World:spawn_unit(Idstring("units/zdann/ene_acc_zombie_eyes/ene_acc_zombie_eyes"), Vector3(), Rotation())

        self._unit:link(align_obj_name, self._headwear_unit, self._headwear_unit:orientation_object():name())
    end
end