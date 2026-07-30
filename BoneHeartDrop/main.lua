-- When player takes damage, gain 2 Bone Hearts
local mod = RegisterMod("BoneHeartDrop", 1)
local game = Game()

function mod:onEntityTakeDmg(entity, damageAmount, damageFlag, damageSource, damageCountdownFrames)
    local player = Isaac.GetPlayer(0)
    if entity == player then
        player:AddBoneHearts(2)
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.onEntityTakeDmg)
Isaac.DebugString("BoneHeartDrop loaded! Gain 2 Bone Hearts when taking damage.")
