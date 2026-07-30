-- =============================================================================
--  BestiaryReader — The Binding of Isaac: Repentance
--  When hitting an enemy, display their bestiary entry (name, HP, damage).
--  Version: 1.0   | Official API only
-- =============================================================================

local mod = RegisterMod("BestiaryReader", 1)
local game = Game()
mod.displayTimer = 0
mod.displayText = ""

function mod:onEntityTakeDmg(target, damageAmount, damageFlag, damageSource, damageCountdownFrames)
    if not target:IsVulnerableEnemy() then return end

    local entityType = target.Type
    local variant = target.Variant
    local subType = target.SubType
    local hp = target.HitPoints
    local maxHp = target.MaxHitPoints
    local collisionDmg = target.CollisionDamage

    mod.displayText = "Enemy: Type=" .. tostring(entityType) ..
                       " Var=" .. tostring(variant) ..
                       " Sub=" .. tostring(subType) ..
                       " | HP: " .. tostring(hp) .. "/" .. tostring(maxHp) ..
                       " | Dmg: " .. tostring(collisionDmg)
    mod.displayTimer = 180 -- show for 3 seconds (60fps)
end

function mod:onPostRender()
    if mod.displayTimer <= 0 then return end
    mod.displayTimer = mod.displayTimer - 1
    local alpha = math.min(1, mod.displayTimer / 30) -- fade out last 0.5s
    Isaac.RenderText(mod.displayText, 80, 80, 0.8, 0.8, 1, 1, 0, alpha)
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.onEntityTakeDmg)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onPostRender)
Isaac.DebugString("BestiaryReader loaded!")
