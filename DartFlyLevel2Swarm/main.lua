-- ==========================================================================
--  DartFlyLevel2Swarm - The Binding of Isaac: Repentance
--  Level 2 Dart Fly spits 3 smaller dart flies that chase player
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("DartFlyLevel2Swarm", 1)
local game = Game()
local DART_FLY_TYPE = EntityType.ENTITY_DART_FLY

function mod:swarmUpdate(_, npc)
    if npc.Type ~= DART_FLY_TYPE or npc.Variant ~= 2 then return end
    local player = game:GetPlayer(0)
    if not player then return end
    if npc.FrameCount % 150 == 0 and npc.Position:Distance(player.Position) < 400 then
        for i = 1, 3 do
            local spawnPos = npc.Position + Vector(math.cos(i * 2.09) * 30, math.sin(i * 2.09) * 30)
            local mini = Isaac.Spawn(EntityType.ENTITY_DART_FLY, 0, 0, spawnPos, (player.Position - spawnPos):Resized(3), npc)
            if mini then mini.SpriteScale = Vector(0.6, 0.6) end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.swarmUpdate, DART_FLY_TYPE)
Isaac.DebugString("DartFlyLevel2Swarm loaded!")
