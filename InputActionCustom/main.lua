-- =============================================================================
--  InputActionCustom - The Binding of Isaac: Repentance
--  Press G key to wiggle all enemies (taunt/debug fun).
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("InputActionCustom", 1)
local wiggleCooldown = 0

function mod:onPostUpdate()
    if wiggleCooldown > 0 then
        wiggleCooldown = wiggleCooldown - 1
    end

    -- Check for G key (ButtonAction.ACTION_DROP / keyboard G)
    if Input.IsButtonTriggered(Keyboard.G, 0) and wiggleCooldown == 0 then
        wiggleCooldown = 60 -- 2 second cooldown
        local entities = Isaac.GetRoomEntities()
        local count = 0
        for _, entity in ipairs(entities) do
            if entity:IsVulnerableEnemy() and not entity:IsDead() then
                -- Apply random velocity bump for wiggle effect
                local wiggleX = math.random(-3, 3)
                local wiggleY = math.random(-3, 3)
                entity.Velocity = entity.Velocity + Vector(wiggleX, wiggleY)
                -- Brief color flash
                entity:SetColor(Color(1, 1, 1, 1, 0, 0, 0), 5, 1, false, false)
                count = count + 1
            end
        end
        Isaac.DebugString("Greet! " .. count .. " enemies wiggled!")
    end
end

function mod:onInputAction(entity, hook, buttonAction)
    -- Track input for debug
    if buttonAction == ButtonAction.ACTION_DROP then
        Isaac.DebugString("G key input detected via MC_INPUT_ACTION")
    end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.onPostUpdate)
mod:AddCallback(ModCallbacks.MC_INPUT_ACTION, mod.onInputAction)
Isaac.DebugString("InputActionCustom loaded!")
