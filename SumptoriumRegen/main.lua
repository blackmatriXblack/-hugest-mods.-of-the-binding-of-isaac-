-- ==========================================================================
--  Sumptorium Regen - The Binding of Isaac: Repentance
--  Sumptorium clots regenerate HP when near the player
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("SumptoriumRegen", 1)
local game = Game()

local SUMPTORIUM = CollectibleType.COLLECTIBLE_SUMPTORIUM
local clotTimers = {}

function mod:onNPCUpdate(npc)
    local player = Isaac.GetPlayer(0)
    if not player or not player:HasCollectible(SUMPTORIUM) then return end

    -- Sumptorium clots are EntityType ENTITY_TEAR with specific variant
    if npc.Type == EntityType.ENTITY_TEAR then
        local tear = npc:ToTear()
        if tear and tear.SpawnerEntity == player then
            local dist = (player.Position - npc.Position):Length()
            if dist < 80 then
                local key = GetPtrHash(npc)
                if not clotTimers[key] then clotTimers[key] = 0 end
                clotTimers[key] = clotTimers[key] + 1
                if clotTimers[key] >= 60 then -- Every 2 seconds
                    clotTimers[key] = 0
                    player:AddHearts(1)
                    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HEART,
                        0, npc.Position, Vector.Zero, player)
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNPCUpdate)
Isaac.DebugString("SumptoriumRegen loaded!")
