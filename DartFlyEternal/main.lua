-- =============================================================================
--  Eternal Dart Fly - The Binding of Isaac: Repentance
--  Eternal Dart Fly: 3x HP, aggressive homing, leaves damaging gray creep trail.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("DartFlyEternal", 1)

local DART_FLY_TYPE = 46    -- EntityType.ENTITY_DART_FLY (Repentance)
local ETERNAL_VARIANT = 1   -- Eternal variant marker
local CREEP_INTERVAL = 20   -- Frames between creep drops
local CREEP_RADIUS = 40

local initDone = {}

local function onNPCUpdate(_, npc)
    if npc.Type ~= DART_FLY_TYPE then return end
    if npc:IsDead() then
        initDone[GetPtrHash(npc)] = nil
        return
    end

    local ptr = GetPtrHash(npc)

    -- First-frame initialization: 3x HP
    if not initDone[ptr] then
        initDone[ptr] = true
        local newMax = npc.MaxHitPoints * 3
        npc.MaxHitPoints = newMax
        npc.HitPoints = newMax
        npc.Scale = 1.25
        -- Eternal champion color: bright washed out
        npc.Color = Color(1.0, 1.0, 1.0, 1.0, 0, 0, 0)
        npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK, true)
    end

    -- Aggressive homing: boost speed toward player
    local player = Isaac.GetPlayer(0)
    if player then
        local toPlayer = (player.Position - npc.Position):Normalized()
        npc.Velocity = npc.Velocity + toPlayer * 0.15

        -- Cap max speed
        local speed = npc.Velocity:Length()
        local maxSpeed = 4.5
        if speed > maxSpeed then
            npc.Velocity = npc.Velocity:Normalized() * maxSpeed
        end
    end

    -- Leave gray creep trail periodically
    local currentFrame = Game():GetFrameCount()
    if currentFrame % CREEP_INTERVAL == 0 then
        local creepEffect = Isaac.Spawn(EntityType.ENTITY_EFFECT,
            EffectVariant.PLAYER_CREEP_RED,  -- Use red creep as base
            0, npc.Position, Vector.Zero, npc)
        if creepEffect then
            local eff = creepEffect:ToEffect()
            if eff then
                eff.Color = Color(0.3, 0.3, 0.3, 0.6, 0, 0, 0) -- Gray tint
                eff.Timeout = 150 -- 5 second creep
                eff.Scale = 0.8
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("DartFlyEternal loaded!")
