-- ==========================================================================
--  TarBoySlow - The Binding of Isaac: Repentance
--  Tar Boy leaves slowing tar creep everywhere it moves.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("TarBoySlow", 1)
local ENEMY_TAR_BOY = 295
local CREEP_INTERVAL = 8
local CREEP_LIFETIME = 180
local SLOW_AMOUNT = 0.4

local function onNPCUpdate(_, npc)
    if npc.Type ~= ENEMY_TAR_BOY then return end
    local data = npc:GetData()
    if not data.creepTimer then data.creepTimer = 0 end

    -- Leave tar creep while moving
    if npc.Velocity:Length() > 0.5 then
        data.creepTimer = data.creepTimer + 1
        if data.creepTimer >= CREEP_INTERVAL then
            data.creepTimer = 0
            local tar = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_BLACK, 0, npc.Position, Vector.Zero, npc)
            if tar and tar.Exists() then
                tar:ToEffect()
                tar.Timeout = CREEP_LIFETIME
            end
        end
    end

    -- Apply slow to player standing on tar creeps near this Tar Boy
    local player = Isaac.GetPlayer(0)
    if player then
        if player.Position:Distance(npc.Position) < 120 then
            local playerOnCreep = false
            local room = Game():GetRoom()
            -- Simple distance-based slow aura if player is nearby
            if player.Position:Distance(npc.Position) < 50 then
                playerOnCreep = true
            end
            if playerOnCreep then
                player.MoveSpeed = math.max(player.MoveSpeed * (1 - SLOW_AMOUNT * 0.05), 0.3)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("TarBoySlow loaded!")