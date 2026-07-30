-- =============================================================================
--  HauntGhostTrio - The Binding of Isaac: Repentance
--  The Haunt's 3 ghosts attack simultaneously instead of one-by-one, 30% less HP
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("HauntGhostTrio", 1)
local HAUNT_ID = 260
local LILHAUNT_ID = 261

local initialized = false

-- Check if we're in a Haunt boss room
local function IsHauntRoom()
    for i = 0, Game():GetRoom():GetAliveBossesCount() - 1 do
        local boss = Game():GetRoom():GetBoss(i)
        if boss and boss:Exists() and boss.Type == HAUNT_ID then
            return true
        end
    end
    return false
end

-- Count and list all active Lil' Haunt ghosts
local function GetLilHaunts()
    local haunts = {}
    local entities = Isaac.GetRoomEntities()
    for _, ent in ipairs(entities) do
        if ent:Exists() and ent.Type == LILHAUNT_ID then
            table.insert(haunts, ent)
        end
    end
    return haunts
end

function mod:OnNPCUpdate(npc)
    if initialized or not IsHauntRoom() then return end
    local haunts = GetLilHaunts()
    if #haunts >= 3 then
        initialized = true
        -- Reduce HP by 30% for all ghosts
        for _, h in ipairs(haunts) do
            local maxHP = h.MaxHitPoints
            if h.HitPoints > maxHP * 0.7 then
                h.HitPoints = math.ceil(maxHP * 0.7)
            end
        end
    end

    if not initialized then return end

    -- Make all ghosts fire simultaneously every 60 frames (~2 seconds)
    local frame = Game():GetFrameCount()
    if frame % 60 == 0 then
        local haunts = GetLilHaunts()
        for _, h in ipairs(haunts) do
            if h:Exists() and h:IsActiveEnemy() then
                local player = Isaac.GetPlayer(0)
                if player and player:Exists() then
                    local dir = (player.Position - h.Position):Normalized()
                    local vel = dir * 4
                    h.Velocity = vel
                    -- Each ghost fires a tear toward the player simultaneously
                    local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, h.Position, vel * 4, h):ToTear()
                    if tear then
                        tear.Scale = 1.5
                        tear.FallingSpeed = 0
                        tear.FallingAcceleration = 0
                    end
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.OnNPCUpdate)
Isaac.DebugString("HauntGhostTrio loaded!")
