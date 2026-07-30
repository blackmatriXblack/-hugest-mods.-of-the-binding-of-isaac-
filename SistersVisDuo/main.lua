-- =============================================================================
--  SistersVisDuo - The Binding of Isaac: Repentance
--  Sisters Vis share damage 50/50 and each death enrages the survivor
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("SistersVisDuo", 1)
local SISTERS_VIS_ID = 20
local VIS_DOUBLE_ID = 22 -- Double Vis / bigger variant

local sisterPairs = {} -- Track paired Vis sisters
local enragedSisters = {} -- Track which sisters are enraged

-- Find the other Vis sister in the room
local function FindSisterPair(entity)
    local entities = Isaac.GetRoomEntities()
    local others = {}
    for _, ent in ipairs(entities) do
        if ent:Exists() and ent.Index ~= entity.Index then
            if ent.Type == SISTERS_VIS_ID or ent.Type == VIS_DOUBLE_ID then
                table.insert(others, ent)
            end
        end
    end
    return others
end

function mod:OnEntityTakeDmg(target, amount, flag, source, countdown)
    if not target:Exists() then return nil end
    if target.Type ~= SISTERS_VIS_ID and target.Type ~= VIS_DOUBLE_ID then
        return nil
    end

    -- Find sister pair
    local sisters = FindSisterPair(target)
    if #sisters == 0 then return nil end

    -- 50% damage split: half goes to target, half to sister
    local splitDmg = amount / 2
    local selfDmg = math.floor(splitDmg)

    -- Deal split damage to sister
    for _, sister in ipairs(sisters) do
        if sister:Exists() and sister.HitPoints > 0 then
            sister:TakeDamage(selfDmg, DamageFlag.DAMAGE_NORMAL,
                EntityRef(target), 0)

            -- Visual feedback for shared damage
            sister:SetColor(Color(1, 0.5, 0.5, 1, 0, 0, 0), 3, 0, false, false)
        end
    end

    -- Return modified damage amount (half)
    return selfDmg
end

function mod:OnNPCUpdate(npc)
    if npc.Type ~= SISTERS_VIS_ID and npc.Type ~= VIS_DOUBLE_ID then return end
    if not npc:IsActiveEnemy() then return end

    local idx = npc.Index
    local sisters = FindSisterPair(npc)
    local aliveSisters = 0
    for _, s in ipairs(sisters) do
        if s:Exists() and s.HitPoints > 0 then
            aliveSisters = aliveSisters + 1
        end
    end

    -- If only one sister remains (other is dead), enrage the survivor
    if #sisters >= 1 and aliveSisters == 1 and not enragedSisters[idx] then
        -- Identify the survivor
        local survivor = nil
        for _, s in ipairs(sisters) do
            if s:Exists() and s.HitPoints > 0 then
                survivor = s
                break
            end
        end

        -- If this NPC is the survivor, enrage it
        if survivor and survivor.Index == npc.Index then
            enragedSisters[idx] = true

            -- Enrage effects:
            -- 1. Speed boost
            npc.Pathfinder:MoveSpeedAdd(2.0)
            -- 2. Scale up for visual intimidation
            npc.Scale = npc.Scale * 1.3
            -- 3. Tint red
            npc:SetColor(Color(1, 0.2, 0.2, 1, 0, 0, 0), 999, 0, false, false)
            -- 4. Max HP boost
            local hpIncrease = math.ceil(npc.MaxHitPoints * 0.3)
            npc.MaxHitPoints = npc.MaxHitPoints + hpIncrease
            npc.HitPoints = npc.HitPoints + hpIncrease
            -- 5. Rage effect
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 0,
                npc.Position, Vector(0, 0), nil)
            -- 6. Screen shake
            Game():GetRoom():TriggerShake(6)

            Isaac.DebugString("[SistersVisDuo] A Vis sister has enraged!")
        end
    end

    -- Enraged sisters attack more aggressively
    if enragedSisters[idx] then
        local player = Isaac.GetPlayer(0)
        if player and player:Exists() then
            local frame = Game():GetFrameCount()
            -- Fire blood shots at the player every 45 frames
            if frame % 45 == 0 then
                local dir = (player.Position - npc.Position):Normalized()
                local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0,
                    npc.Position, dir * 6, npc):ToTear()
                if tear then
                    tear:AddTearFlags(TearFlags.TEAR_BLOOD)
                    tear:AddTearFlags(TearFlags.TEAR_HOMING)
                    tear.Scale = 1.5
                end
            end

            -- Charge at player more aggressively
            if frame % 90 == 0 then
                npc.Velocity = (player.Position - npc.Position):Normalized() * 7
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.OnEntityTakeDmg)
mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.OnNPCUpdate)
Isaac.DebugString("SistersVisDuo loaded!")
