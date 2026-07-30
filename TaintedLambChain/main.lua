-- ==========================================================================
--  Tainted Lamb Chain - The Binding of Isaac: Repentance
--  Tainted Lamb — spinning charge chains to hit all 4 walls in sequence.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("TaintedLambChain", 1)
local LAMB_ID = EntityType.ENTITY_THE_LAMB
local wall_sequence = 0

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, function(_, npc)
    if npc.Type == LAMB_ID then
        local room = Game():GetRoom()
        if not room then return end

        if npc.FrameCount % 60 == 0 then
            local walls = {
                room:GetTopLeftPos(),
                Vector(room:GetBottomRightPos().X, room:GetTopLeftPos().Y),
                room:GetBottomRightPos(),
                Vector(room:GetTopLeftPos().X, room:GetBottomRightPos().Y)
            }
            wall_sequence = (wall_sequence % 4) + 1
            local targetWall = walls[wall_sequence]

            local dir = (targetWall - npc.Position):Normalized()
            local chainLen = npc.Position:Distance(targetWall)
            for d = 0, chainLen, 30 do
                local chainPos = npc.Position + dir * d
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACK_THE_SKY, 0,
                    chainPos, Vector.Zero, npc)
            end
        end
    end
end)

Isaac.DebugString("TaintedLambChain loaded!")
