-- =============================================================================
--  Rotgut Split - The Binding of Isaac: Repentance
--  Rotgut split sections have unique abilities
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("RotgutSplit", 1)
local ROTGUT_TYPE = 913
local ROTGUT_SEGMENT = 914 -- smaller split pieces

function mod:onNPCUpdate(npc)
    if npc.Type ~= ROTGUT_SEGMENT then return end
    
    -- Assign role based on variant on first update
    if npc:GetData().roleAssigned == nil then
        local role = npc.Variant % 3 -- 0=shoot, 1=charge, 2=minions
        npc:GetData().role = role
        npc:GetData().roleAssigned = true
        
        -- Visual indicator: tint based on role
        if role == 0 then
            npc:AddEntityFlags(EntityFlag.FLAG_RED) -- Shooter glows red
        elseif role == 1 then
            npc:AddEntityFlags(EntityFlag.FLAG_GREEN) -- Charger glows green
        else
            npc:AddEntityFlags(EntityFlag.FLAG_BLUE) -- Spawner glows blue
        end
    end
    
    local role = npc:GetData().role
    local player = Isaac.GetPlayer(0)
    if not player then return end
    
    if role == 0 then
        -- SHOOTER: fires burst of 3 tears every 40 frames
        if npc.FrameCount % 40 == 0 then
            for i = -1, 1 do
                local baseDir = (player.Position - npc.Position):Normalized()
                local angle = math.atan2(baseDir.Y, baseDir.X) + i * 0.2
                local dir = Vector(math.cos(angle), math.sin(angle))
                Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0, npc.Position, dir * 5, npc)
            end
        end
    elseif role == 1 then
        -- CHARGER: rapidly charges at player every 90 frames
        if npc.FrameCount % 90 == 0 then
            local dir = (player.Position - npc.Position):Normalized()
            npc.Velocity = dir * 8
        end
    elseif role == 2 then
        -- SPAWNER: creates small minions every 120 frames
        if npc.FrameCount % 120 == 0 then
            for i = 1, 2 do
                local spawnPos = npc.Position + Vector((math.random()-0.5)*60, (math.random()-0.5)*60)
                Isaac.Spawn(EntityType.ENTITY_FLY, 0, 0, spawnPos, Vector.Zero, npc)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNPCUpdate, ROTGUT_SEGMENT)
Isaac.DebugString("RotgutSplit loaded!")
