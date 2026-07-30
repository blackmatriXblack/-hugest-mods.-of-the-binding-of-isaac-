-- ==========================================================================
--  RagManSpiderWeb - The Binding of Isaac: Repentance
--  Rag Man's Spider leaves web traps on floor that slow player.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("RagManSpiderWeb", 1)
local ENEMY_RAGMAN_SPIDER = 245
local WEB_INTERVAL = 60
local WEB_LIFETIME = 180

local function onNPCUpdate(_, npc)
    if npc.Type ~= ENEMY_RAGMAN_SPIDER then return end
    local data = npc:GetData()
    if not data.webTimer then data.webTimer = 0 end

    data.webTimer = data.webTimer + 1
    if data.webTimer >= WEB_INTERVAL then
        data.webTimer = 0
        if npc.Velocity:Length() > 0.5 then
            -- Place web trap at current position
            local web = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_BLACK, 0, npc.Position, Vector.Zero, npc)
            if web and web.Exists() then
                web:ToEffect()
                web.Timeout = WEB_LIFETIME
            end
        end
    end

    -- Slow player standing on webs
    local player = Isaac.GetPlayer(0)
    if player then
        local room = Game():GetRoom()
        for i = 0, room:GetAliveEnemiesCount() - 1 do
            -- Check if player is near any spider web effects
            local dist = player.Position:Distance(npc.Position)
            if dist < 40 then
                local curSpeed = player.MoveSpeed
                player.MoveSpeed = math.max(curSpeed * 0.7, 0.3)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("RagManSpiderWeb loaded!")