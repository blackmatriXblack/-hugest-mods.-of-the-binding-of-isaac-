-- ==========================================================================
--  Floor Is Lava - The Binding of Isaac: Repentance
--  Standing still for 2 seconds causes damage — must keep moving!
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("FloorIsLava", 1)
local game = Game()
local stillFrames = 0
local STILL_THRESHOLD = 60 -- 2 seconds at 30fps
local lastPos = Vector.Zero

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    local currentPos = player.Position
    local moved = (currentPos - lastPos):Length()

    if moved < 0.5 then
        stillFrames = stillFrames + 1
        if stillFrames >= STILL_THRESHOLD then
            player:TakeDamage(2, DamageFlag.DAMAGE_FIRE, EntityRef(player), 0)
            -- Spawn fire under player as visual warning
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HOT_BOMB_FIRE,
                0, currentPos, Vector.Zero, nil)
            stillFrames = 0  -- Reset after damage
        end
    else
        stillFrames = math.max(0, stillFrames - 2)
    end

    lastPos = currentPos

    -- Visual warning indicator
    if stillFrames >= STILL_THRESHOLD - 30 then
        player:SetColor(Color(1, 0.3, 0.3, 1, 0, 0, 0), -1, 1, false, false)
    end
end)

-- Spawn warning fire effect on screen edge when close to burning
mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    if stillFrames > 30 then
        local progress = (stillFrames - 30) / 30
        Isaac.RenderText("MOVE!",
            300, 160, 1.2, 1, 0.2 * progress, 0.2 * progress)
    end
end)

Isaac.DebugString("Floor Is Lava loaded!")
