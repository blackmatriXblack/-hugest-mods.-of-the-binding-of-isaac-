local mod = RegisterMod("LaserUpdateMod", 1)

function mod:onLaserUpdate(laser)
    if laser:Exists() and laser:ToNPC() == nil then
        laser.MaxDistance = laser.MaxDistance + 50
    end
end

mod:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, mod.onLaserUpdate)
