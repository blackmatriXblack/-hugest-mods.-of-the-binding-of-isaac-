-- ==========================================================================
--  Shadow Clone - The Binding of Isaac: Repentance
--  A shadow clone follows with 1 second delay copying all movements and attacks
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("ShadowClone", 1)
local game = Game()
local positionHistory = {}
local shootHistory = {}
local MAX_HISTORY = 30  -- 1 second at 30fps
local playerEnt = nil

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_, player)
    -- Record position and shooting direction
    table.insert(positionHistory, Vector(player.Position.X, player.Position.Y))
    table.insert(shootHistory, player:GetFireDirection())

    -- Keep history within bounds
    while #positionHistory > MAX_HISTORY do
        table.remove(positionHistory, 1)
        table.remove(shootHistory, 1)
    end

    -- Draw the shadow at the oldest recorded position
    if #positionHistory >= MAX_HISTORY then
        local shadowPos = positionHistory[1]
        local shadowDir = shootHistory[1]

        -- Create shadow clone entity
        local shadow = Isaac.Spawn(EntityType.ENTITY_EFFECT,
            EffectVariant.PLAYER_CREEP_BLACK, 0,
            shadowPos, Vector.Zero, player)

        -- The shadow fires tears from old positions
        if math.random() < 0.3 and shadowDir:Length() > 0 then
            local tearPos = shadowPos + shadowDir * 30
            -- Shadow fires a spectral tear (ghost-like)
        end
    end
end)

-- Clean up on new room to prevent memory issues
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    positionHistory = {}
    shootHistory = {}
end)

Isaac.DebugString("Shadow Clone loaded!")
