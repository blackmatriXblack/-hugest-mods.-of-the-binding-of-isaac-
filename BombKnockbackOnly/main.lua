-- =============================================================================
--  Bomb Knockback Only - The Binding of Isaac: Repentance
--  Bombs deal no damage but push all enemies to walls!
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("BombKnockbackOnly", 1)
local checkedBombs = {}

function mod:onBombUpdate(bomb)
    local idx = GetPtrHash(bomb)
    if checkedBombs[idx] then return end

    -- Prevent damage, apply massive knockback instead
    local room = Game():GetRoom()
    local entities = Isaac.GetRoomEntities()

    for _, entity in ipairs(entities) do
        if entity:IsVulnerableEnemy() then
            local dir = (entity.Position - bomb.Position):Normalized()
            entity.Velocity = dir * 25 -- Massive knockback
            entity:AddEntityFlags(EntityFlag.FLAG_NO_DAMAGE_BLINK)

            -- Tint enemies orange from the blast
            entity:GetSprite().Color = Color(1, 0.6, 0.2, 1, 0, 0, 0)
        end
    end

    -- Zero out bomb damage
    bomb:AddBombFlags(BombFlag.BOMB_NO_DAMAGE or 0)

    Game():ShakeScreen(10)
    checkedBombs[idx] = true
end

function mod:onNewRoom()
    checkedBombs = {} -- Clear bomb tracking on room change
end

mod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, mod.onBombUpdate)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)
Isaac.DebugString("BombKnockbackOnly loaded!")
