-- =============================================================================
--  EntityInspectorTool - The Binding of Isaac: Repentance
--  Press I near any entity to inspect it — show all properties
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("EntityInspectorTool", 1)
local inspectorActive = false
local inspectedEntity = nil
local pageIndex = 1
local totalPages = 1

local function FindNearestEntity()
    local player = Isaac.GetPlayer(0)
    local playerPos = player.Position
    local closest = nil
    local closestDist = 100 -- Max range

    local entities = Isaac.GetRoomEntities()
    for _, entity in ipairs(entities) do
        if entity:IsVulnerableEnemy() or entity:IsActiveEnemy() or entity.Type > 10 then
            local dist = playerPos:Distance(entity.Position)
            if dist < closestDist then
                closestDist = dist
                closest = entity
            end
        end
    end
    return closest
end

function mod:onUpdate()
    if Input.IsButtonPressed(Keyboard.KEY_I, 0) then
        if inspectorActive then
            inspectorActive = false
            inspectedEntity = nil
            pageIndex = 1
        else
            local entity = FindNearestEntity()
            if entity then
                inspectorActive = true
                inspectedEntity = entity
                pageIndex = 1
            end
        end
    end

    if inspectorActive and inspectedEntity then
        if not inspectedEntity:Exists() then
            inspectorActive = false
            inspectedEntity = nil
            return
        end

        -- Page navigation
        if Input.IsButtonPressed(Keyboard.KEY_RIGHT, 0) then
            pageIndex = math.min(pageIndex + 1, totalPages)
        end
        if Input.IsButtonPressed(Keyboard.KEY_LEFT, 0) then
            pageIndex = math.max(pageIndex - 1, 1)
        end
    end
end

function mod:onRender()
    if not inspectorActive or not inspectedEntity then return end

    local font = Font()
    local x = Isaac.GetScreenWidth() * 0.55
    local y = 40
    local lineH = 15
    local alpha = 0.92
    local e = inspectedEntity

    -- Background
    font:DrawString("=", x, y - 2, KColor(0.1, 0.1, 0.1, 0.6), 0, false)

    font:DrawString("=== ENTITY INSPECTOR (I to close) ===", x, y, KColor(0, 1, 1, 1), 0, false)
    y = y + 20

    -- Page 1: Basic Info
    if pageIndex == 1 then
        totalPages = 3
        font:DrawString("-- BASIC INFO [Page 1/3] --", x, y, KColor(1, 1, 0.5, alpha), 0, false)
        y = y + lineH + 4

        local lines = {
            "Type: " .. e.Type .. "  Variant: " .. e.Variant .. "  SubType: " .. e.SubType,
            "InitSeed: " .. e.InitSeed,
            "DepthOffset: " .. e.DepthOffset,
            string.format("Position: (%.0f, %.0f)", e.Position.X, e.Position.Y),
            string.format("Size: (%.1f, %.1f)", e.Size.X, e.Size.Y),
            string.format("Velocity: (%.1f, %.1f)", e.Velocity.X, e.Velocity.Y),
            string.format("HitboxSize: (%.1f, %.1f)", e.Size.X, e.Size.Y),
            "Visible: " .. tostring(e.Visible),
            "EntityCollisionClass: " .. e.EntityCollisionClass,
            "GridCollisionClass: " .. e.GridCollisionClass,
        }
        for _, line in ipairs(lines) do
            font:DrawString("  " .. line, x + 10, y, KColor(0.8, 1, 0.8, alpha), 0, false)
            y = y + lineH
        end
    end

    -- Page 2: Health & Damage
    if pageIndex == 2 then
        font:DrawString("-- HEALTH & DAMAGE [Page 2/3] --", x, y, KColor(1, 1, 0.5, alpha), 0, false)
        y = y + lineH + 4

        local lines = {
            string.format("HP: %.1f / MaxHP: %.1f", e.HitPoints, e.MaxHitPoints),
            "Boss Entity: " .. tostring(e:IsBoss()),
            "Champion: " .. tostring(e:IsChampion()),
            "Vulnerable: " .. tostring(e:IsVulnerableEnemy()),
            "Active Enemy: " .. tostring(e:IsActiveEnemy()),
            "Invincible: " .. (e:HasEntityFlags(EntityFlag.FLAG_RENDER_FLOOR) and "Unknown" or "Check flags"),
            "Frame Count: " .. e.FrameCount,
            "Child Count: " .. e.ChildCount,
            "Parent: " .. tostring(e.Parent and e.Parent.Type),
            "Spawner Type: " .. e.SpawnerType,
            "Spawner Variant: " .. e.SpawnerVariant,
        }
        for _, line in ipairs(lines) do
            font:DrawString("  " .. line, x + 10, y, KColor(0.8, 1, 0.8, alpha), 0, false)
            y = y + lineH
        end
    end

    -- Page 3: Flags & Effects
    if pageIndex == 3 then
        font:DrawString("-- FLAGS & EFFECTS [Page 3/3] --", x, y, KColor(1, 1, 0.5, alpha), 0, false)
        y = y + lineH + 4

        local lines = {
            "Color: (" .. string.format("%.2f,%.2f,%.2f,%.2f)",
                e.Color.R, e.Color.G, e.Color.B, e.Color.A) .. ")",
            "Sprite Scale: (" .. string.format("%.2f,%.2f)", e.SpriteScale.X, e.SpriteScale.Y),
            "Additive Null: " .. tostring(e:HasEntityFlags(1 << 44)),
            "Boss Room Entity: " .. tostring(e:IsBoss()),
            "Data: " .. tostring(e:GetData() ~= nil),
            "Target Position: (" .. string.format("%.0f,%.0f)", e.TargetPosition.X, e.TargetPosition.Y),
            "Path Target: (" .. string.format("%.0f,%.0f)", e.Pathfinder and e.Pathfinder.Target.X or 0,
                                                   e.Pathfinder and e.Pathfinder.Target.Y or 0),
            "I*(Putity): " .. e.I1 .. ", " .. e.I2,
            "V*(Putity): " .. string.format("%.1f, %.1f", e.V1.X, e.V1.Y),
        }
        for _, line in ipairs(lines) do
            font:DrawString("  " .. line, x + 10, y, KColor(0.8, 1, 0.8, alpha), 0, false)
            y = y + lineH
        end
    end

    -- Navigation hint
    y = y + 8
    font:DrawString("[LEFT/RIGHT] Change Page   [I] Close", x + 10, y, KColor(0.5, 0.5, 1, 0.8), 0, false)
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.onUpdate)
Isaac.DebugString("EntityInspectorTool loaded!")
