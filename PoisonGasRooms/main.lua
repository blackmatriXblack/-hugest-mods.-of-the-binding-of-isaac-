-- =============================================================================
--  Poison Gas Rooms - The Binding of Isaac: Repentance
--  Every room fills with poison gas that damages enemies and player!
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PoisonGasRooms", 1)
local gasTimer = 0

function mod:onNewRoom()
    local room = Game():GetRoom()
    local center = room:GetCenterPos()

    -- Spawn visible poison gas effect in center
    local gas = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POISON_CLOUD, 0, center, Vector.Zero, nil)
    if gas then
        gas:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        gas.Size = 80 -- Large gas cloud
        gas.DepthOffset = -10
    end

    gasTimer = 5 * 30 -- Gas lasts 5 seconds per room entry
    Isaac.DebugString("Poison gas filling the room! Beware!")
end

function mod:onUpdate()
    if gasTimer <= 0 then return end
    gasTimer = gasTimer - 1

    local player = Isaac.GetPlayer(0)
    if not player then return end

    local room = Game():GetRoom()
    local center = room:GetCenterPos()

    -- Damage player in gas zone
    if player.Position:Distance(center) < 100 then
        if gasTimer % 10 == 0 then
            player:TakeDamage(1, DamageFlag.DAMAGE_POISON, EntityRef(player), 0)
        end
        player:GetSprite().Color = Color(0.2, 1, 0.2, 1, 0, 0, 0)
    end

    -- Damage enemies in gas zone
    local entities = Isaac.GetRoomEntities()
    for _, entity in ipairs(entities) do
        if entity:IsVulnerableEnemy() and entity.Position:Distance(center) < 100 then
            if gasTimer % 10 == 0 then
                entity:TakeDamage(5, DamageFlag.DAMAGE_POISON, EntityRef(player), 0)
            end
            entity:GetSprite().Color = Color(0.2, 1, 0.2, 1, 0, 0, 0)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.onUpdate)
Isaac.DebugString("PoisonGasRooms loaded!")
