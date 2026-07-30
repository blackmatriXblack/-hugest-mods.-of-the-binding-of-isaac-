-- =============================================================================
--  SpriteDebugOverlay - The Binding of Isaac: Repentance
--  Press F3 to toggle sprite info overlay — animation frame, sprite sheet, entity data
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("SpriteDebugOverlay", 1)
local enabled = false
local showAllEntities = false

function mod:onUpdate()
    if Input.IsButtonPressed(Keyboard.KEY_F3, 0) then
        enabled = not enabled
        showAllEntities = false
        Isaac.DebugString("SpriteDebugOverlay: " .. (enabled and "ON" or "OFF"))
    end
    if enabled and Input.IsButtonPressed(Keyboard.KEY_F, 0) then
        showAllEntities = not showAllEntities
    end
end

function mod:onRender()
    if not enabled then return end

    local font = Font()
    local x = 10
    local y = 60
    local room = Game():GetRoom()
    local lineHeight = 14

    font:DrawString("=== SPRITE DEBUG (F3 to toggle, F to show all) ===", x, y, KColor(0, 1, 1, 1), 0, false)
    y = y + 18

    if showAllEntities then
        -- Show all entities in room
        for i = 0, room:GetGridSize() - 1 do
            local gridEntity = room:GetGridEntity(i)
            if gridEntity then
                local sprite = gridEntity:GetSprite()
                if sprite then
                    local fx = gridEntity.Position.X
                    local fy = gridEntity.Position.Y
                    font:DrawString(string.format("Grid[%d] @ (%d,%d) Frame:%d Variant:%d",
                        i, fx, fy, sprite:GetFrame(), gridEntity:GetVariant()),
                        x, y, KColor(0.7, 0.7, 1, 0.8), 0, false)
                    y = y + lineHeight
                end
            end
            if y > 500 then break end
        end
    else
        -- Show nearest entity info
        local player = Isaac.GetPlayer(0)
        local playerPos = player.Position
        local closestEntity = nil
        local closestDist = 999999

        local entities = Isaac.GetRoomEntities()
        for _, entity in ipairs(entities) do
            local dist = playerPos:Distance(entity.Position)
            if dist < closestDist then
                closestDist = dist
                closestEntity = entity
            end
        end

        if closestEntity then
            local sprite = closestEntity:GetSprite()
            local e = closestEntity
            font:DrawString("Nearest Entity:", x, y, KColor(0, 1, 1, 1), 0, false)
            y = y + lineHeight
            font:DrawString("  Type: " .. e.Type .. "  Variant: " .. e.Variant .. "  SubType: " .. e.SubType,
                x, y, KColor(1, 1, 1, 0.9), 0, false)
            y = y + lineHeight

            if sprite then
                font:DrawString("  Animation: " .. (sprite:GetAnimation() or "none"),
                    x, y, KColor(1, 1, 0.7, 0.9), 0, false)
                y = y + lineHeight
                font:DrawString("  Frame: " .. sprite:GetFrame() .. " / OverlayFrame: " .. sprite:GetOverlayFrame(),
                    x, y, KColor(1, 1, 0.7, 0.9), 0, false)
                y = y + lineHeight
                font:DrawString("  IsLoaded: " .. tostring(sprite:IsLoaded()) .. "  IsPaused: " .. tostring(sprite:IsPaused()),
                    x, y, KColor(1, 1, 0.7, 0.9), 0, false)
                y = y + lineHeight
            end

            font:DrawString("  Position: (" .. math.floor(e.Position.X) .. ", " .. math.floor(e.Position.Y) .. ")",
                x, y, KColor(0.7, 1, 0.7, 0.9), 0, false)
            y = y + lineHeight
            font:DrawString("  Velocity: (" .. math.floor(e.Velocity.X) .. ", " .. math.floor(e.Velocity.Y) .. ")",
                x, y, KColor(0.7, 1, 0.7, 0.9), 0, false)
            y = y + lineHeight
            font:DrawString("  Distance from player: " .. math.floor(closestDist),
                x, y, KColor(0.7, 1, 0.7, 0.9), 0, false)
        end
    end

    font:DrawString("Room Entities: " .. #Isaac.GetRoomEntities(),
        x, y + 24, KColor(1, 1, 1, 0.7), 0, false)
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.onUpdate)
Isaac.DebugString("SpriteDebugOverlay loaded!")
