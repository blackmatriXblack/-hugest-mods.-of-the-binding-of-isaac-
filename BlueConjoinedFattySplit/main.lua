-- ==========================================================================
--  BlueConjoinedFattySplit - The Binding of Isaac: Repentance
--  Blue Conjoined Fatty splits into 3 blue fatties at 30% HP
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("BlueConjoinedFattySplit", 1)
local game = Game()
local FATTY_TYPE = EntityType.ENTITY_FATTY
local BLUE_CONJOINED_VARIANT = 3
local hasSplit = {}

function mod:splitOnDamage(_, tookDamage, damageAmount, damageFlag, damageSource, damageCountdown)
    if tookDamage.Type ~= FATTY_TYPE then return end
    local npc = tookDamage:ToNPC()
    if not npc or npc.Variant ~= BLUE_CONJOINED_VARIANT then return end
    local idx = GetPtrHash(npc)
    if hasSplit[idx] then return end
    if npc.HitPoints < npc.MaxHitPoints * 0.3 then
        hasSplit[idx] = true
        for i = 0, 2 do
            local angle = i * 2.09
            local spawnPos = npc.Position + Vector(math.cos(angle) * 40, math.sin(angle) * 40)
            local fatty = Isaac.Spawn(FATTY_TYPE, 1, 0, spawnPos, Vector(math.cos(angle), math.sin(angle)):Resized(2), npc)
            if fatty then fatty.SpriteScale = Vector(0.7, 0.7) end
        end
        npc:Kill()
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.splitOnDamage)
Isaac.DebugString("BlueConjoinedFattySplit loaded!")
