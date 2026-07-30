-- =============================================================================
--  MaskHeartLink — The Binding of Isaac: Repentance
--  Mask+Heart synergy — heart (Type=38) heals mask (Type=37) by 10% HP every 3s.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("MaskHeartLink", 1)

local HEAL_INTERVAL = 90   -- 3 seconds at 30 FPS
local HEAL_PERCENT = 0.1
local LINK_DISTANCE = 200
local healTimer = 0

function mod:onUpdate()
    healTimer = healTimer + 1

    if healTimer < HEAL_INTERVAL then return end
    healTimer = 0

    local entities = Isaac.GetRoomEntities()
    local hearts = {}
    local masks = {}

    -- Find all hearts and masks in the room
    for _, ent in ipairs(entities) do
        if ent.Type == 38 and ent:IsVulnerableEnemy() then
            table.insert(hearts, ent)
        elseif ent.Type == 37 and ent:IsVulnerableEnemy() then
            table.insert(masks, ent)
        end
    end

    -- Each heart heals nearby masks
    for _, heart in ipairs(hearts) do
        for _, mask in ipairs(masks) do
            local dist = heart.Position:Distance(mask.Position)
            if dist < LINK_DISTANCE then
                local healAmount = mask.MaxHitPoints * HEAL_PERCENT
                mask.HitPoints = math.min(mask.MaxHitPoints, mask.HitPoints + healAmount)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.onUpdate)
Isaac.DebugString("MaskHeartLink loaded!")
