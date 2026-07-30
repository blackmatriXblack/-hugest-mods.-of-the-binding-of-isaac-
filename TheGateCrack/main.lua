-- =============================================================================
--  TheGateCrack - The Binding of Isaac: Repentance
--  The Gate boss creates cracking floor tiles that deal damage
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("TheGateCrack", 1)
local THE_GATE_ID = 402
local crackedTiles = {}
local lastCrackFrame = 0

function mod:OnNPCUpdate(npc)
    if npc.Type ~= THE_GATE_ID then return end
    if not npc:IsActiveEnemy() then return end

    local frame = Game():GetFrameCount()
    local room = Game():GetRoom()
    local player = Isaac.GetPlayer(0)

    -- Every 100 frames, crack floor tiles near the player
    if frame - lastCrackFrame >= 100 then
        lastCrackFrame = frame

        if player and player:Exists() then
            -- Create crack warning effect around player
            for i = 1, 6 do
                local angle = (i * 60) * math.pi / 180
                local offset = Vector(math.cos(angle), math.sin(angle)) * 120
                local crackPos = player.Position + offset

                -- Place cracked tile indicator
                local gridIdx = room:GetGridIndex(crackPos)
                table.insert(crackedTiles, {
                    pos = crackPos,
                    gridIdx = gridIdx,
                    expireFrame = frame + 60
                })

                -- Visual effect
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ROCK_PARTICLE, 0,
                    crackPos, Vector(0, 0), nil)
            end
        end
    end

    -- Process active cracked tiles - deal damage if player stands on them
    for i = #crackedTiles, 1, -1 do
        local tile = crackedTiles[i]
        if tile.expireFrame < frame then
            -- Tile "explodes" - deal damage in area
            if player and player:Exists() then
                local dist = (player.Position - tile.pos):Length()
                if dist < 60 then
                    player:TakeDamage(1, DamageFlag.DAMAGE_NORMAL, EntityRef(npc), 0)
                    player:AddBleeding(EntityRef(npc), 60)
                end
            end

            -- Explosion effect
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION, 0,
                tile.pos, Vector(0, 0), nil)

            table.remove(crackedTiles, i)
        else
            -- Visual: grow cracking glow as it gets closer to detonating
            local progress = 1 - ((tile.expireFrame - frame) / 60)
            local color = Color(1, 1 - progress, progress * 0.3, 0.5 + progress * 0.5, 0, 0, 0)
            -- Show warning cracks (we approximate with rock particles)
            if frame % 10 == 0 then
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ROCK_PARTICLE, 0,
                    tile.pos, Vector(0, 0), nil)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.OnNPCUpdate)
Isaac.DebugString("TheGateCrack loaded!")
