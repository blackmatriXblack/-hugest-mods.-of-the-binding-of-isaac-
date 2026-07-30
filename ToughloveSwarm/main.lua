-- =============================================================================
--  Tough Love Fly Swarm - The Binding of Isaac: Repentance
--  Tough Love spawns 3 attack flies every 6 seconds (180 frames).
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("ToughloveSwarm", 1)

-- Tough Love / Hardy entity (Repentance enemy)
-- In Repentance, Hardys/Tough Love use EntityType ranges around 808-809
local TOUGH_LOVE_TYPE = 809  -- Hardy/Tough Love type
local ATTACK_FLY_TYPE = 18   -- EntityType.ENTITY_ATTACK_FLY
local SPAWN_INTERVAL = 180   -- 6 seconds at 30fps

local lastSpawnTime = {}

local function onNPCUpdate(_, npc)
    if npc.Type ~= TOUGH_LOVE_TYPE then return end
    if npc:IsDead() then
        lastSpawnTime[GetPtrHash(npc)] = nil
        return
    end

    local ptr = GetPtrHash(npc)
    local currentFrame = Game():GetFrameCount()

    if not lastSpawnTime[ptr] then
        lastSpawnTime[ptr] = currentFrame
        return
    end

    if currentFrame - lastSpawnTime[ptr] >= SPAWN_INTERVAL then
        lastSpawnTime[ptr] = currentFrame

        -- Spawn 3 attack flies in a fan pattern
        for i = 0, 2 do
            local angle = math.rad((i - 1) * 40)
            local vel = Vector(math.cos(angle), math.sin(angle)) * 3.0
            local spawnPos = npc.Position + Vector(math.random(-20, 20), math.random(-20, 20))
            local fly = Isaac.Spawn(ATTACK_FLY_TYPE, 0, 0, spawnPos, vel, npc)
            if fly then
                fly:AddEntityFlags(EntityFlag.FLAG_APPEAR, false)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("ToughloveSwarm loaded!")
