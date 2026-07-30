-- =============================================================================
--  RedSpiderPoison - The Binding of Isaac: Repentance
--  Red Spiders leave poisonous red creep and fire venom shots
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("RedSpiderPoison", 1)
local SPIDER_TYPE = 85     -- EntityType.ENTITY_SPIDER
local RED_VARIANT = 1       -- Red Spider variant
local POISON_COOLDOWN = 90  -- Frames between venom shots (1.5 seconds at 60fps)
local CREEP_INTERVAL = 20   -- Frames between creep placements

function mod:onNpcUpdate(_, npc)
    if npc.Type ~= SPIDER_TYPE or npc.Variant ~= RED_VARIANT then
        return
    end
    if npc:IsDead() then return end

    local data = npc:GetData()
    local frame = Game():GetFrameCount()
    local player = Isaac.GetPlayer(0)

    -- Initialize data
    if data.init == nil then
        data.init = true
        data.lastShot = frame
        data.lastCreep = frame
        npc:AddEntityFlags(EntityFlag.FLAG_RED)
    end

    -- Leave red creep trail periodically
    if frame - data.lastCreep >= CREEP_INTERVAL then
        data.lastCreep = frame
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 0,
            npc.Position, Vector.Zero, npc)
    end

    -- Fire venom shot at player on cooldown
    if frame - data.lastShot >= POISON_COOLDOWN and player:Exists() then
        data.lastShot = frame
        local dir = (player.Position - npc.Position):Normalized()
        local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0,
            npc.Position, dir:Resized(5), npc):ToTear()
        if tear then
            tear:AddTearFlags(TearFlags.TEAR_POISON)
            tear.CollisionDamage = 1.0
            tear.Scale = 0.8
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNpcUpdate)
Isaac.DebugString("RedSpiderPoison loaded!")
