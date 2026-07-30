-- ==========================================================================
--  Mega Mush Burst - The Binding of Isaac: Repentance
--  Mega Mush burst deals 3x damage and affects entire room
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("MegaMushBurst", 1)
local game = Game()

local MEGA_MUSH = CollectibleType.COLLECTIBLE_MEGA_MUSH
local megaActive = false
local burstFrame = 0

function mod:onPlayerUpdate(player)
    if not player:HasCollectible(MEGA_MUSH) then
        megaActive = false
        return
    end

    -- Detect mega mush active state (player size increases dramatically)
    if player.SpriteScale.X > 1.5 and not megaActive then
        megaActive = true
    end

    if megaActive and player.SpriteScale.X < 1.5 then
        -- Mega mush just ended, trigger the room-wide burst
        megaActive = false
        if game:GetFrameCount() - burstFrame > 10 then
            burstFrame = game:GetFrameCount()
            local room = game:GetRoom()
            local entities = Isaac.GetRoomEntities()
            for _, ent in ipairs(entities) do
                if ent:IsVulnerableEnemy() then
                    -- Deal 3x player damage to every enemy in the room
                    ent:TakeDamage(player.Damage * 3, DamageFlag.DAMAGE_EXPLOSION,
                        EntityRef(player), 0)
                end
            end
            -- Visual feedback: spawn explosion effects across room
            for i = 1, 8 do
                local angle = i * math.pi / 4
                local pos = player.Position +
                    Vector(math.cos(angle), math.sin(angle)) * 80
                Isaac.Spawn(EntityType.ENTITY_EFFECT,
                    EffectVariant.BOMB_EXPLOSION, 0,
                    pos, Vector.Zero, player)
            end
            Isaac.DebugString("MegaMushBurst: room-wide 3x burst!")
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPlayerUpdate)
Isaac.DebugString("MegaMushBurst loaded!")
