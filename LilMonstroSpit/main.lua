-- ==========================================================================
--  LilMonstroSpit - The Binding of Isaac: Repentance
--  Lil Monstro spits 3-way blood shots instead of 1.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("LilMonstroSpit", 1)
local ENEMY_LIL_MONSTRO = 247
local SPIT_INTERVAL = 90

local function onNPCUpdate(_, npc)
    if npc.Type ~= ENEMY_LIL_MONSTRO then return end
    local data = npc:GetData()
    if not data.spitTimer then data.spitTimer = 0 end

    data.spitTimer = data.spitTimer + 1
    if data.spitTimer >= SPIT_INTERVAL then
        data.spitTimer = 0
        local player = Isaac.GetPlayer(0)
        if player then
            local dir = (player.Position - npc.Position):Normalized()
            local spreadAngles = {-15, 0, 15}
            for _, angleOffset in ipairs(spreadAngles) do
                local rad = math.rad(angleOffset)
                local spreadDir = Vector(
                    dir.X * math.cos(rad) - dir.Y * math.sin(rad),
                    dir.X * math.sin(rad) + dir.Y * math.cos(rad)
                )
                local vel = spreadDir * 5
                local params = ProjectileParams()
                params.Variant = ProjectileVariant.PROJECTILE_BLOOD
                npc:FireProjectiles(npc.Position + spreadDir * 15, vel, 0, params)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("LilMonstroSpit loaded!")