-- ==========================================================================
--  EnemyDanceParty - The Binding of Isaac: Repentance
--  Enemies wiggle and dance to an invisible beat for the first 3 seconds of every room!
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("EnemyDanceParty", 1)
local DANCE_DURATION = 90
local roomFrames = 0
local musicStarted = false

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    roomFrames = 0
    musicStarted = false
    local room = Game():GetRoom()
    if room:GetAliveEnemiesCount() > 0 and not room:IsClear() then
        SFXManager():Play(SoundEffect.SOUND_EDEN_CHANCE, 0.6, 0, false, 1.2)
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, function(_, npc)
    if roomFrames >= DANCE_DURATION or npc:IsBoss() or not npc:IsActiveEnemy() then return end

    if npc:IsVulnerableEnemy() then
        npc.Velocity = Vector.Zero
        npc.Pathfinder:FindGridPath(npc.Position, 0.1, 0, false)

        local wiggleX = math.sin(roomFrames * 0.3 + npc.Index * 0.7) * 1.5
        local wiggleY = math.cos(roomFrames * 0.25 + npc.Index * 0.5) * 0.8
        npc.PositionOffset = Vector(wiggleX, wiggleY)

        local spr = npc:GetSprite()
        if spr then
            spr.Scale = Vector(1.1 + math.sin(roomFrames * 0.15) * 0.1, 1.1 + math.cos(roomFrames * 0.15) * 0.1)
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    if roomFrames < DANCE_DURATION + 5 then
        roomFrames = roomFrames + 1
    end
    if roomFrames == 1 then
        Game():GetRoom():SetClear(false)
    end
end)

Isaac.DebugString("EnemyDanceParty loaded! Drop the beat!")
