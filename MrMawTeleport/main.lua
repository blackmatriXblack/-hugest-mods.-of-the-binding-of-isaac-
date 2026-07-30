-- =============================================================================
--  MrMawTeleport - The Binding of Isaac: Repentance
--  Mr. Maw teleports behind the player every 8 seconds
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("MrMawTeleport", 1)
local MR_MAW_TYPE = 284
local TELEPORT_INTERVAL = 240 -- 8 seconds * 30 fps
local TELEPORT_DISTANCE = 70

function mod:OnNPCUpdate(npc)
    if npc.Type ~= MR_MAW_TYPE then return end

    local player = Isaac.GetPlayer(0)
    if not player then return end

    local data = npc:GetData()
    data.tpTimer = (data.tpTimer or 0) + 1

    if data.tpTimer >= TELEPORT_INTERVAL then
        data.tpTimer = 0

        -- Teleport behind the player
        -- "Behind" is opposite of player's movement/facing direction
        local playerDir = player:GetMovementVector()
        if playerDir:Length() < 0.1 then
            -- If not moving, teleport to random side
            playerDir = Vector(math.random() - 0.5, math.random() - 0.5):Normalized()
        else
            playerDir = playerDir:Normalized()
        end

        local behindPos = player.Position - playerDir * TELEPORT_DISTANCE

        -- Spawn teleport puff effect at old position
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TELEPORT, 0, npc.Position, Vector.Zero, nil)

        -- Move Mr. Maw
        npc.Position = behindPos
        npc.Velocity = Vector.Zero

        -- Spawn arrival effect
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TELEPORT, 0, behindPos, Vector.Zero, nil)

        -- Aggro immediately toward player
        npc:Pathfind(player.Position, 1.0, 0)

        -- Short invulnerability/confusion period
        npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
        -- Re-enable targeting after a moment
    else
        -- Clear NO_TARGET flag shortly after teleport
        if data.tpTimer == 10 then
            npc:ClearEntityFlags(EntityFlag.FLAG_NO_TARGET)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.OnNPCUpdate)
Isaac.DebugString("MrMawTeleport loaded!")
