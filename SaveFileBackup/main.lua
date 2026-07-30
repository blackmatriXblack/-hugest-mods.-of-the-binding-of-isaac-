-- =============================================================================
--  SaveFileBackup - The Binding of Isaac: Repentance
--  Auto-backup save file data every floor transition
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("SaveFileBackup", 1)
local BACKUP_KEY = "BACKUP_COUNT"
local MAX_BACKUPS = 10
local backupCount = 0
local backupDir = nil

local function GetBackupPath()
    return Isaac.GetSavePath() .. "/save_backups/"
end

local function EnsureBackupDir()
    local path = GetBackupPath()
    local file = io.open(path .. "test.tmp", "w")
    if file then
        file:close()
        os.remove(path .. "test.tmp")
        return true
    end
    return false
end

local function BackupSaveData()
    local data = mod:GetData()
    if data[BACKUP_KEY] == nil then data[BACKUP_KEY] = 0 end
    data[BACKUP_KEY] = data[BACKUP_KEY] + 1

    local backupPath = GetBackupPath()
    local timestamp = os.date("%Y%m%d_%H%M%S")
    local backupFile = backupPath .. "save_backup_" .. timestamp .. ".lua"

    -- Collect save data to back up
    local backupData = {}
    local game = Game()
    local player = Isaac.GetPlayer(0)

    if player then
        backupData.playerType = player:GetPlayerType()
        backupData.health = {player:GetHearts(), player:GetMaxHearts()}
        backupData.coins = player:GetNumCoins()
        backupData.bombs = player:GetNumBombs()
        backupData.keys = player:GetNumKeys()
        backupData.damage = player.Damage
        backupData.tears = player.MaxFireDelay
        backupData.speed = player.MoveSpeed
        backupData.luck = player.Luck

        -- Collect items
        backupData.items = {}
        local itemCount = player:GetCollectibleCount()
        for i = 0, itemCount - 1 do
            local itemId = player:GetCollectibleId(i)
            table.insert(backupData.items, itemId)
        end

        -- Trinkets
        local trinket0 = player:GetTrinket(0)
        local trinket1 = player:GetTrinket(1)
        if trinket0 > 0 then backupData.trinket1 = trinket0 end
        if trinket1 > 0 then backupData.trinket2 = trinket1 end
    end

    -- Level data
    local level = game:GetLevel()
    backupData.stage = level:GetStage()
    backupData.stageType = level:GetStageType()
    backupData.curses = level:GetCurses()
    backupData.score = game:GetScore()

    -- Write backup
    local file = io.open(backupFile, "w")
    if file then
        file:write("-- Save Backup: " .. timestamp .. "\n")
        file:write("return ")
        local function serialize(t, indent)
            local result = "{\n"
            local prefix = indent .. "  "
            for k, v in pairs(t) do
                local key
                if type(k) == "number" then
                    key = "[" .. tostring(k) .. "]"
                else
                    key = '["' .. tostring(k) .. '"]'
                end
                if type(v) == "table" then
                    result = result .. prefix .. key .. " = " .. serialize(v, prefix) .. ",\n"
                elseif type(v) == "string" then
                    result = result .. prefix .. key .. ' = "' .. v .. '",\n'
                else
                    result = result .. prefix .. key .. " = " .. tostring(v) .. ",\n"
                end
            end
            return result .. indent .. "}"
        end
        file:write(serialize(backupData, ""))
        file:write("\n")
        file:close()

        backupCount = data[BACKUP_KEY]

        -- Cleanup old backups
        if backupCount > MAX_BACKUPS * 2 then
            data[BACKUP_KEY] = 0
        end

        Isaac.DebugString("SaveFileBackup: Backup #" .. backupCount .. " saved to " .. backupFile)
    else
        Isaac.DebugString("SaveFileBackup: Failed to create backup!")
    end
end

function mod:onNewLevel()
    -- Create backup on every floor change
    local success = EnsureBackupDir()
    if success then
        BackupSaveData()
    else
        Isaac.DebugString("SaveFileBackup: Cannot create backup directory")
    end
end

function mod:onRender()
    -- Display backup status
    if backupCount > 0 then
        local font = Font()
        font:DrawString("Backups: " .. backupCount,
            Isaac.GetScreenWidth() - 150, 5, KColor(0.5, 1, 0.5, 0.7), 0, false)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.onNewLevel)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
Isaac.DebugString("SaveFileBackup loaded!")
