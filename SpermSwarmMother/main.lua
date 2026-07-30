-- =============================================================================
--  SpermSwarmMother - The Binding of Isaac: Repentance
--  Sperm enemies spawn 2 small sperms every 5 seconds and chase in swarm formation
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("SpermSwarmMother", 1)
local SPERM_TYPE = 44        -- EntityType.ENTITY_SPERM = 44 (white sperm enemies in Caves)
local SPAWN_INTERVAL = 150   -- 5 seconds at 30fps
local SWARM_RADIUS = 80

function mod:onNpcUpdate(_, npc)
    if npc.Type ~= SPERM_TYPE then return end
    if npc:IsDead() then return end

    local data = npc:GetData()
    local frame = Game():GetFrameCount()

    -- Initialize this sperm as a swarm mother
    if data.isMother == nil then
        data.isMother = true
        data.lastSpawn = frame
        data.swarmChildren = {}
        npc:AddEntityFlags(EntityFlag.FLAG_GREEN)
    end

    -- Spawn 2 baby sperms on cooldown (max 8 children)
    if frame - data.lastSpawn >= SPAWN_INTERVAL and #data.swarmChildren < 8 then
        data.lastSpawn = frame
        for i = 1, 2 do
            local offset = Vector(math.random(-40, 40), math.random(-40, 40))
            local baby = Isaac.Spawn(SPERM_TYPE, 0, 0, npc.Position + offset,
                RandomVector():Resized(1.5), npc)
            if baby then
                baby.Scale = 0.6
                baby:AddEntityFlags(EntityFlag.FLAG_APPEAR)
                table.insert(data.swarmChildren, baby)
            end
        end
    end

    -- Swarm formation: make children orbit around the mother
    local player = Isaac.GetPlayer(0)
    if player:Exists() then
        local dirToPlayer = (player.Position - npc.Position):Normalized()
        npc.Velocity = dirToPlayer:Resized(1.8)

        -- Clean up dead children and move remaining in swarm
        local aliveChildren = {}
        for _, child in ipairs(data.swarmChildren) do
            if child:Exists() and not child:IsDead() then
                table.insert(aliveChildren, child)
            end
        end
        data.swarmChildren = aliveChildren

        for i, child in ipairs(aliveChildren) do
            local angle = (Game():GetFrameCount() * 0.03) + (i * math.pi * 2 / #aliveChildren)
            local orbitPos = npc.Position + Vector(math.cos(angle) * SWARM_RADIUS, math.sin(angle) * SWARM_RADIUS)
            local seekDir = (orbitPos - child.Position):Normalized()
            child.Velocity = seekDir:Resized(2.5)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNpcUpdate)
Isaac.DebugString("SpermSwarmMother loaded!")
