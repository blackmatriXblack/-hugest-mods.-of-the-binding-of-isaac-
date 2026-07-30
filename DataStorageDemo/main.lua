-- =============================================================================
--  DataStorageDemo — The Binding of Isaac: Repentance
--  Track total damage dealt across ALL runs using mod data storage.
--  Version: 1.0   | Official API only
-- =============================================================================

local mod = RegisterMod("DataStorageDemo", 1)
local game = Game()
mod.totalDamageDealt = 0
mod.runDamageDealt = 0

-- Called when game starts/loads — load persistent data
function mod:onGameStart(isContinued)
    if mod:LoadData() then
        local savedTable = mod:LoadData()
        if savedTable.totalDamageDealt then
            mod.totalDamageDealt = savedTable.totalDamageDealt
        end
    end
    mod.runDamageDealt = 0
    Isaac.DebugString("DataStorageDemo: Loaded total damage = " .. tostring(mod.totalDamageDealt))
end

-- Track damage dealt by player each frame
function mod:onEntityTakeDmg(target, damageAmount, damageFlag, damageSource, damageCountdownFrames)
    if not target or not target:IsVulnerableEnemy() then return end

    -- Only count damage if player is the source (EntityType.ENTITY_PLAYER or tears from player)
    if damageSource.Entity and damageSource.Entity.Type == EntityType.ENTITY_PLAYER then
        mod.runDamageDealt = mod.runDamageDealt + damageAmount
        mod.totalDamageDealt = mod.totalDamageDealt + damageAmount
    end
end

-- Save data periodically (every new room)
function mod:onNewRoom()
    mod:SaveData({ totalDamageDealt = mod.totalDamageDealt })
end

-- Display on HUD
function mod:onPostRender()
    local line1 = "Run Damage: " .. tostring(mod.runDamageDealt)
    local line2 = "Total Damage (All Runs): " .. tostring(mod.totalDamageDealt)
    Isaac.RenderText(line1, 10, 175, 0.8, 0.8, 1, 0.6, 0.2)
    Isaac.RenderText(line2, 10, 187, 0.7, 0.7, 1, 0.6, 0.2)
end

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.onGameStart)
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.onEntityTakeDmg)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onPostRender)
Isaac.DebugString("DataStorageDemo loaded!")
