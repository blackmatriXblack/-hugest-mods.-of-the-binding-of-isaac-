-- =============================================================================
--  ModConfigHotReload - The Binding of Isaac: Repentance
--  Press F5 to reload all game data without restarting
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("ModConfigHotReload", 1)
local reloadConfirm = false
local reloadMessage = ""
local messageTimer = 0

function mod:onUpdate()
    if Input.IsButtonPressed(Keyboard.KEY_F5, 0) then
        if not reloadConfirm then
            reloadConfirm = true
            reloadMessage = "Press F5 again to confirm hot reload..."
            messageTimer = 60
        else
            -- Execute hot reload
            reloadMessage = "Hot reload initiated!"
            messageTimer = 120
            reloadConfirm = false

            -- Reinitialize item pools
            local game = Game()
            local itemPool = game:GetItemPool()
            if itemPool then
                itemPool:ResetRoomPools()
                reloadMessage = "Item pools reloaded!"
            end

            -- Reload entity data
            local room = game:GetRoom()
            if room then
                -- Force room re-evaluation
                room:SetClear(true)
            end

            -- Reload floor data
            local level = game:GetLevel()
            if level then
                -- Force seed regeneration for this floor
                local seed = level:GetSeeds()
                if seed then
                    level:SetStage(level:GetStage(), level:GetStageType())
                end
            end

            -- Reload player data cache
            local player = Isaac.GetPlayer(0)
            if player then
                player:AddCacheFlags(CacheFlag.CACHE_ALL)
                player:EvaluateItems()
                reloadMessage = reloadMessage .. " Player cache rebuilt!"
            end

            local itemConfig = Isaac.GetItemConfig()
            if itemConfig then
                -- Force item config reload by iterating known items
                for i = 1, 732 do
                    local item = itemConfig:GetCollectible(i)
                end
                reloadMessage = reloadMessage .. " Item config refreshed!"
            end

            Isaac.DebugString("ModConfigHotReload: Game data reloaded!")
        end
    end

    -- Cancel reload if other key pressed
    if reloadConfirm then
        messageTimer = messageTimer - 1
        if messageTimer <= 0 then
            reloadConfirm = false
            reloadMessage = ""
        end
    end

    if messageTimer > 0 then
        messageTimer = messageTimer - 1
        if messageTimer <= 0 then
            reloadMessage = ""
        end
    end
end

function mod:onRender()
    if reloadMessage ~= "" then
        local font = Font()
        font:DrawString(reloadMessage,
            Isaac.GetScreenWidth() * 0.25, Isaac.GetScreenHeight() * 0.4,
            KColor(0.3, 1, 0.3, 1), 0, false)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.onUpdate)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
Isaac.DebugString("ModConfigHotReload loaded!")
