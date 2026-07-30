-- ==========================================================================
--  NeedlePoke - The Binding of Isaac: Repentance
--  Needle enemy rapidly pokes 3 times in a row with increasing damage.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("NeedlePoke", 1)
local ENEMY_NEEDLE = 273
local POKE_INTERVAL = 120
local POKE_DELAY = 8

local function onNPCUpdate(_, npc)
    if npc.Type ~= ENEMY_NEEDLE then return end
    local data = npc:GetData()
    if not data.pokeTimer then data.pokeTimer = 0 end
    if not data.pokeCount then data.pokeCount = 0 end
    if not data.pokeDelay then data.pokeDelay = 0 end

    if data.pokeCount > 0 then
        data.pokeDelay = data.pokeDelay + 1
        if data.pokeDelay >= POKE_DELAY then
            data.pokeDelay = 0
            data.pokeCount = data.pokeCount - 1
            local player = Isaac.GetPlayer(0)
            if player then
                npc.Velocity = (player.Position - npc.Position):Normalized() * 8
                -- Increasing damage per poke
                local damageMult = 1.0 + (3 - data.pokeCount) * 0.5
                if npc.Position:Distance(player.Position) < 40 then
                    player:TakeDamage(damageMult, DamageFlag.DAMAGE_NOKILL, EntityRef(npc), 0)
                end
            end
        end
    else
        data.pokeTimer = data.pokeTimer + 1
        if data.pokeTimer >= POKE_INTERVAL then
            data.pokeTimer = 0
            data.pokeCount = 3
            data.pokeDelay = 0
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("NeedlePoke loaded!")