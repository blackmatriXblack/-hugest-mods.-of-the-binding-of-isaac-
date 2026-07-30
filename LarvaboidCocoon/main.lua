-- ==========================================================================
--  LarvaboidCocoon - The Binding of Isaac: Repentance
--  Larvaboid cocoons itself for 3 seconds, emerging with +50% HP restored.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("LarvaboidCocoon", 1)
local ENEMY_LARVABOID = 239
local COCOON_THRESHOLD = 0.5
local COCOON_DURATION = 90
local COOLDOWN = 300

local function onNPCUpdate(_, npc)
    if npc.Type ~= ENEMY_LARVABOID then return end
    local data = npc:GetData()
    if not data.cooldownTimer then data.cooldownTimer = 0 end
    if not data.cocoonState then data.cocoonState = 0 end
    if not data.cocoonTimer then data.cocoonTimer = 0 end
    if not data.maxHP then data.maxHP = npc.MaxHitPoints end

    if data.cocoonState == 1 then
        -- In cocoon, freeze NPC
        npc.Velocity = Vector.Zero
        data.cocoonTimer = data.cocoonTimer + 1
        if data.cocoonTimer >= COCOON_DURATION then
            -- Emerge with +50% HP restored
            local healAmount = data.maxHP * 0.5
            npc.HitPoints = math.min(npc.HitPoints + healAmount, data.maxHP)
            data.cocoonState = 0
            data.cooldownTimer = 0
        end
    else
        data.cooldownTimer = data.cooldownTimer + 1
        local hpRatio = npc.HitPoints / data.maxHP
        if hpRatio < COCOON_THRESHOLD and data.cooldownTimer >= COOLDOWN then
            data.cocoonState = 1
            data.cocoonTimer = 0
            npc.Velocity = Vector.Zero
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("LarvaboidCocoon loaded!")