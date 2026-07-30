-- ==========================================================================
--  The Pile Stack - The Binding of Isaac: Repentance
--  The Pile boss gains +1 segment each reform, stacking up to 5.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("ThePileStack", 1)
local PILE_ID = 872 -- The Pile entity ID
local pileSegments = {}
local MAX_SEGMENTS = 5

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, function(_, npc)
    if npc.Type == EntityType.ENTITY_GURGLING and npc.Variant == 3 then -- The Pile
        local idx = npc.InitSeed

        -- Track how many times the Pile has reformed
        if not pileSegments[idx] then
            pileSegments[idx] = 1
        end

        -- When Pile reforms (low HP trigger), add a segment
        if npc.HitPoints <= npc.MaxHitPoints * 0.2 and pileSegments[idx] < MAX_SEGMENTS then
            -- Detect reform by checking if HP suddenly increased
            local hpPercent = npc.HitPoints / npc.MaxHitPoints
            if hpPercent > 0.15 then -- reformed
                pileSegments[idx] = math.min(pileSegments[idx] + 1, MAX_SEGMENTS)

                -- Spawn extra body segments behind the Pile
                for i = 1, pileSegments[idx] - 1 do
                    local behindPos = npc.Position + Vector(0, (i * 30))
                    local seg = Isaac.Spawn(EntityType.ENTITY_GURGLING, 3, 0,
                        behindPos, Vector.Zero, npc)
                    if seg then
                        seg:AddEntityFlags(EntityFlag.FLAG_FRIENDLY) -- not real enemy just visual
                    end
                end

                -- Scale up slightly for each segment
                npc.SpriteScale = Vector(0.9 + pileSegments[idx] * 0.1, 0.9 + pileSegments[idx] * 0.1)
            end
        end
    end
end)

Isaac.DebugString("ThePileStack loaded!")
