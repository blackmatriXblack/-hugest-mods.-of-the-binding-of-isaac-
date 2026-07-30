-- =============================================================================
--  Mirror Mode - The Binding of Isaac: Repentance
--  The entire game world is mirrored left-to-right!
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("MirrorMode", 1)
local mirrored = false

function mod:onRender()
    local player = Isaac.GetPlayer(0)
    if not player then return end

    -- Mirror all entities in the room
    local room = Game():GetRoom()
    if not room then return end

    -- Flip player sprite
    player.FlipX = true
    player:GetSprite().FlipX = true

    -- Flip all NPCs
    local entities = Isaac.GetRoomEntities()
    for _, entity in ipairs(entities) do
        if entity:IsVulnerableEnemy() or entity.Type == EntityType.ENTITY_PICKUP then
            entity:GetSprite().FlipX = true
        end
    end

    -- Flip all tears
    for _, entity in ipairs(entities) do
        if entity.Type == EntityType.ENTITY_TEAR or
           entity.Type == EntityType.ENTITY_BOMB then
            entity:GetSprite().FlipX = true
        end
    end

    -- Mirrored controls
    if not mirrored then
        mirrored = true
        Isaac.DebugString("Mirror Mode activated! Left = Right, Right = Left!")
    end
end

function mod:onPlayerUpdate(player)
    -- Invert horizontal movement
    local controllerIdx = player.ControllerIndex
    if controllerIdx == 0 then
        -- Keyboard controls: swap left and right
        if Input.IsButtonPressed(ButtonAction.ACTION_LEFT, 0) then
            player:AddVelocity(Vector(2, 0))
        end
        if Input.IsButtonPressed(ButtonAction.ACTION_RIGHT, 0) then
            player:AddVelocity(Vector(-2, 0))
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.onPlayerUpdate)
Isaac.DebugString("MirrorMode loaded!")
