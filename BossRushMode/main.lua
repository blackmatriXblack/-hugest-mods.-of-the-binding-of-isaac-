-- ==========================================================================
--  Boss Rush Mode - The Binding of Isaac: Repentance
--  Every room is a mini boss rush — 2 boss enemies spawn per room
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("BossRushMode", 1)
local game = Game()
local bossesSpawned = false

local bossPool = {
    {EntityType.ENTITY_MONSTRO, 0},
    {EntityType.ENTITY_MONSTRO_2, 0},
    {EntityType.ENTITY_GEMINI, 0},
    {EntityType.ENTITY_STEVEN, 0},
    {EntityType.ENTITY_DUKE_OF_FLIES, 0},
    {EntityType.ENTITY_GURDY, 0},
    {EntityType.ENTITY_LARRY_JR, 0},
    {EntityType.ENTITY_CHUB, 0},
    {EntityType.ENTITY_PIN, 0},
    {EntityType.ENTITY_SCOLEX, 0},
    {EntityType.ENTITY_THE_FALLEN, 0},
    {EntityType.ENTITY_THE_HEADLESS_HORSEMAN, 0},
    {EntityType.ENTITY_DINGLE, 0},
    {EntityType.ENTITY_MEGA_MAW, 0},
    {EntityType.ENTITY_THE_GATE, 0},
}

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    bossesSpawned = false
end)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    if bossesSpawned then return end

    local room = game:GetRoom()
    if not room:IsClear() then
        -- Check if room has enemies, if so this is a combat room
        local frame = room:GetFrameCount()
        if frame == 10 then
            bossesSpawned = true
            
            -- Only add bosses if this is a combat room with existing enemies
            local entities = Isaac.GetRoomEntities()
            local hasEnemies = false
            for _, ent in ipairs(entities) do
                if ent:IsEnemy() and not ent:IsBoss() then
                    hasEnemies = true
                    break
                end
            end

            if hasEnemies then
                local roomCenter = room:GetCenterPos()
                
                -- Spawn 2 random bosses
                for i = 1, 2 do
                    local boss = bossPool[math.random(1, #bossPool)]
                    local spawnPos = Vector(
                        roomCenter.X + math.random(-100, 100),
                        roomCenter.Y + math.random(-60, 60)
                    )
                    
                    local newBoss = Isaac.Spawn(boss[1], boss[2], 0,
                        spawnPos, Vector.Zero, nil)
                    if newBoss then
                        -- Slightly reduced HP since it's a regular room
                        newBoss.HitPoints = newBoss.MaxHitPoints * 0.6
                        newBoss:AddEntityFlags(EntityFlag.FLAG_NO_REWARD)
                    end
                end

                Isaac.DebugString("Mini Boss Rush: 2 bosses have joined the fight!")
            end
        end
    end
end)

Isaac.DebugString("Boss Rush Mode loaded!")
