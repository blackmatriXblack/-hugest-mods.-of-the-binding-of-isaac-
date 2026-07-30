-- =============================================================================
--  Dark Esau Magnetic Pull - The Binding of Isaac: Repentance
--  Dark Esau exerts a subtle magnetic pull on the player within 150px radius.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("DarkEsauMagnet", 1)

local DARK_ESAU_TYPE = 812  -- EntityType.ENTITY_DARK_ESAU
local PULL_RADIUS = 150
local PULL_STRENGTH = 0.35

local function onNPCUpdate(_, npc)
    if npc.Type ~= DARK_ESAU_TYPE then return end
    if npc:IsDead() then return end

    -- Find the player and apply magnetic pull
    for p = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(p)
        if player and player:Exists() then
            local dx = npc.Position.X - player.Position.X
            local dy = npc.Position.Y - player.Position.Y
            local dist = math.sqrt(dx * dx + dy * dy)
            if dist > 0 and dist <= PULL_RADIUS then
                -- Stronger pull when closer
                local strength = PULL_STRENGTH * (1.0 - dist / PULL_RADIUS)
                local pullX = (dx / dist) * strength
                local pullY = (dy / dist) * strength
                player.Velocity = player.Velocity + Vector(pullX, pullY)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("DarkEsauMagnet loaded!")
