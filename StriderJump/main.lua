-- ==========================================================================
--  StriderJump - The Binding of Isaac: Repentance
--  Strider jumps across entire room leaving impact craters
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("StriderJump", 1)
local game = Game()
local STRIDER_TYPE = EntityType.ENTITY_STRIDER

function mod:jumpUpdate(_, npc)
    if npc.Type ~= STRIDER_TYPE then return end
    local player = game:GetPlayer(0)
    if not player then return end
    if npc.FrameCount % 80 == 0 then
        local jumpTarget = player.Position
        npc.Velocity = Vector(0, -12)
        npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACK_THE_SKY, 0, jumpTarget, Vector.Zero, npc)
        npc.Position = jumpTarget
        npc.Velocity = Vector.Zero
        npc:ClearEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.jumpUpdate, STRIDER_TYPE)
Isaac.DebugString("StriderJump loaded!")
