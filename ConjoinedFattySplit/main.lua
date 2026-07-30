-- =============================================================================
--  ConjoinedFattySplit - The Binding of Isaac: Repentance
--  Conjoined Fatty splits into 2 regular fatties at 50% HP
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("ConjoinedFattySplit", 1)
local CONJOINED_FATTY_TYPE = 209 -- EntityType.ENTITY_CONJOINED_FATTY
local splitData = {} -- track which entities have already split

local function onTakeDamage(_, entity, amount, flags, source, cooldown)
    if entity.Type ~= CONJOINED_FATTY_TYPE or not entity:Exists() then
        return
    end

    local idx = entity.Index
    if splitData[idx] then return end -- already split

    local maxHP = entity.MaxHitPoints or 40
    local currentHP = entity.HitPoints - amount

    if currentHP <= maxHP * 0.5 and currentHP > 0 then
        splitData[idx] = true

        local pos = entity.Position
        local room = Game():GetRoom()
        if not room then return end

        -- Spawn 2 regular fatties
        for i = 1, 2 do
            local offsetX = (i == 1 and -30 or 30)
            local spawnPos = pos + Vector(offsetX, 0)
            local fatty = Isaac.Spawn(EntityType.ENTITY_FATTY, 0, 0, spawnPos, Vector(0, 0), entity)
            if fatty then
                fatty.HitPoints = maxHP * 0.3
                fatty:AddEntityFlags(EntityFlag.FLAG_SLOW)
                fatty:SetColor(Color(0.8, 0.6, 0.4, 1, 0, 0, 0), 120, 0, false, true)
            end
        end

        -- Main entity gets smaller and weaker
        entity.Scale = 0.7
        entity.HitPoints = maxHP * 0.4
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, onTakeDamage)
Isaac.DebugString("ConjoinedFattySplit loaded!")
