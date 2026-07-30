-- =============================================================================
--  Carrion Queen Spawn Surge - The Binding of Isaac: Repentance
--  Carrion Queen spawns 2 extra red poops per attack wave, escalating the threat.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("CarrionQueenSpawn", 1)
local game = Game()

local CARRION_QUEEN_TYPE = 58 -- EntityType.ENTITY_CARRION_QUEEN
local RED_POOP_TYPE = 24     -- EntityType.ENTITY_POOP
local RED_POOP_VARIANT = 2   -- Red poop variant

local spawnedThisWave = {}

local function onNPCUpdate(_, npc)
    if npc.Type ~= CARRION_QUEEN_TYPE then return end
    if npc:IsDead() then
        spawnedThisWave[GetPtrHash(npc)] = nil
        return
    end

    -- Detect when Carrion Queen is in her spawn attack state
    -- Carrion Queen fires projectiles / spawns poops during State.NPC_STATE_ATTACK2 or similar
    local state = npc.State
    if state == NpcState.STATE_ATTACK2 or state == NpcState.STATE_SPECIAL then
        local ptr = GetPtrHash(npc)
        if not spawnedThisWave[ptr] then
            spawnedThisWave[ptr] = true
            -- Spawn 2 extra red poops near the queen
            for j = 1, 2 do
                local angle = (j - 1) * math.pi + npc.Velocity:GetAngleDegrees() * math.pi / 180
                local offset = Vector(math.cos(angle) * 60, math.sin(angle) * 60)
                local spawnPos = npc.Position + offset
                local poop = Isaac.Spawn(RED_POOP_TYPE, RED_POOP_VARIANT, 0, spawnPos, Vector.Zero, npc)
            end
        end
    else
        local ptr = GetPtrHash(npc)
        spawnedThisWave[ptr] = nil
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("CarrionQueenSpawn loaded!")
