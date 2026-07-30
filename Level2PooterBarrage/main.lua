-- =============================================================================
--  Level2PooterBarrage - The Binding of Isaac: Repentance
--  Level 2 Pooter variant unleashes a deadly 3-way spread shot barrage
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("Level2PooterBarrage", 1)
local POOTER_TYPE = 14
local LEVEL2_VARIANT = 1
local SHOT_INTERVAL = 70
local SPREAD_ANGLE = 0.25

function mod:onNpcUpdate(_, npc)
    if npc.Type ~= POOTER_TYPE or npc.Variant ~= LEVEL2_VARIANT then return end
    if npc:IsDead() then return end

    local data = npc:GetData()
    local frame = Game():GetFrameCount()
    local player = Isaac.GetPlayer(0)

    if data.init == nil then
        data.init = true
        data.lastShot = frame + math.random(30, SHOT_INTERVAL)
        data.shotBurst = 0
        npc:AddEntityFlags(EntityFlag.FLAG_GREEN)
    end

    if player:Exists() and frame - data.lastShot >= SHOT_INTERVAL then
        data.lastShot = frame
        local pos = npc.Position
        local baseDir = (player.Position - pos):Normalized()
        local baseAngle = math.atan2(baseDir.Y, baseDir.X)

        for i = -1, 1 do
            local angle = baseAngle + (i * SPREAD_ANGLE)
            local dir = Vector(math.cos(angle), math.sin(angle))
            local speed = 4.5 + math.random() * 1.5
            local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, pos, dir:Resized(speed), npc):ToTear()
            if tear then
                tear.CollisionDamage = 1.2
                tear.Scale = 0.9
                if i == 0 then
                    tear.Scale = 1.1
                    tear:AddTearFlags(TearFlags.TEAR_HOMING)
                end
            end
        end
        data.shotBurst = 10
    end

    if data.shotBurst and data.shotBurst > 0 then
        data.shotBurst = data.shotBurst - 1
        if data.shotBurst == 0 and player:Exists() then
            local pos = npc.Position
            local baseDir = (player.Position - pos):Normalized()
            local baseAngle = math.atan2(baseDir.Y, baseDir.X)
            for i = -1, 1 do
                local angle = baseAngle + (i * SPREAD_ANGLE * 0.7)
                local dir = Vector(math.cos(angle), math.sin(angle))
                local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, pos, dir:Resized(4 + math.random()), npc):ToTear()
                if tear then
                    tear.CollisionDamage = 1.0
                    tear.Scale = 0.8
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNpcUpdate)
Isaac.DebugString("Level2PooterBarrage loaded!")
