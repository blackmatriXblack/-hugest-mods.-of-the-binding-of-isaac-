-- =============================================================================
--  MomDeadHandGrab - The Binding of Isaac: Repentance
--  Mom's Dead Hand grabs player from behind for damage and slow
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("MomDeadHandGrab", 1)
local DEAD_HAND_TYPE = 287
local GRAB_RANGE = 90
local GRAB_COOLDOWN = 150 -- 5 seconds
local GRAB_DAMAGE = 1.0
local GRAB_SLOW_DURATION = 90
local FACING_THRESHOLD = 0.3 -- dot product threshold for "facing away"

function mod:OnNPCUpdate(npc)
    if npc.Type ~= DEAD_HAND_TYPE then return end

    local player = Isaac.GetPlayer(0)
    if not player then return end

    local data = npc:GetData()
    data.grabCooldown = data.grabCooldown or 0

    if data.grabCooldown > 0 then
        data.grabCooldown = data.grabCooldown - 1
        return
    end

    local dist = player.Position:Distance(npc.Position)
    if dist > GRAB_RANGE then return end

    -- Check if player is facing away from the hand
    -- Player's facing direction vs direction from player to hand
    local toHand = (npc.Position - player.Position):Normalized()
    local playerDir = player:GetMovementVector()
    if playerDir:Length() < 0.1 then
        -- Player not moving, check facing direction via head direction
        playerDir = player:GetFireDirection()
    end

    -- Detect if player faces away (dot product negative means hand is behind)
    if playerDir:Length() > 0.01 then
        playerDir = playerDir:Normalized()
        local dot = playerDir.X * toHand.X + playerDir.Y * toHand.Y

        if dot < FACING_THRESHOLD then
            -- Hand grabs from behind!
            data.grabCooldown = GRAB_COOLDOWN

            -- Deal damage
            player:TakeDamage(GRAB_DAMAGE, DamageFlag.DAMAGE_NO_PENALTIES, EntityRef(npc), 0)

            -- Apply slow
            player:AddSlowing(EntityRef(npc), GRAB_SLOW_DURATION, 0.3, 0)

            -- Pull player toward hand briefly
            local pullDir = (npc.Position - player.Position):Normalized()
            player.Velocity = pullDir * 4

            -- Spawn visual effect (bone/spooky puff)
            local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BONE_SPLASH, 0, player.Position, Vector.Zero, npc)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.OnNPCUpdate)
Isaac.DebugString("MomDeadHandGrab loaded!")
