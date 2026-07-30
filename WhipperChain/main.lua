-- =============================================================================
--  Whipper Chain Rally - The Binding of Isaac: Repentance
--  Whipper chains to nearby enemies, giving them a speed boost on attack.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("WhipperChain", 1)

local WIPPER_TYPE = 811     -- Whipper entity (Repentance)
local CHAIN_RADIUS = 80     -- Chain range
local BOOST_STRENGTH = 1.8  -- Speed multiplier

local function onNPCUpdate(_, npc)
    if npc.Type ~= WIPPER_TYPE then return end
    if npc:IsDead() then return end

    -- During whip attack, boost nearby enemies
    if npc.State == NpcState.STATE_ATTACK or npc.State == NpcState.STATE_ATTACK2 then
        -- Visual chain effect: boost nearby allies
        local entities = Isaac.GetRoomEntities()
        local boosted = 0
        for _, other in ipairs(entities) do
            if other.Index ~= npc.Index
                and other:IsVulnerableEnemy()
                and not other:IsDead()
                and other.Type ~= WIPPER_TYPE then

                local dist = (npc.Position - other.Position):Length()
                if dist <= CHAIN_RADIUS and boosted < 3 then
                    -- Speed boost the ally
                    local boostVec = other.Velocity:Normalized()
                    if boostVec:Length() < 0.01 then
                        boostVec = (other.Position - npc.Position):Normalized()
                    end
                    other.Velocity = boostVec * BOOST_STRENGTH * 2.0
                    other:AddEntityFlags(EntityFlag.FLAG_APPEAR, false)
                    other.Color = Color(1.0, 0.5, 0.1, 1.0, 0, 0, 0) -- Orange-tinted speed
                    boosted = boosted + 1
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("WhipperChain loaded!")
