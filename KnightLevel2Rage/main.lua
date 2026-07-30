-- ==========================================================================
--  KnightLevel2Rage - The Binding of Isaac: Repentance
--  Level 2 Knight charges 2x faster and deals 2x contact damage.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("KnightLevel2Rage", 1)
local ENEMY_KNIGHT = 41

local function onNPCUpdate(_, npc)
    if npc.Type ~= ENEMY_KNIGHT or npc.Variant ~= 1 then return end
    local data = npc:GetData()
    if not data.initialized then
        data.initialized = true
        -- Store original contact damage
        data.originalDamage = npc.CollisionDamage
        npc.CollisionDamage = npc.CollisionDamage * 2
    end
    -- Accelerate movement speed when player is in sight
    local player = Isaac.GetPlayer(0)
    if player and npc.Position:Distance(player.Position) < 200 then
        local vel = npc.Velocity
        if vel:Length() > 0.1 then
            npc.Velocity = vel:Normalized() * math.min(vel:Length() * 1.05, 6)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("KnightLevel2Rage loaded!")