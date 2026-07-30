-- ==========================================================================
--  SkinnyDodge - The Binding of Isaac: Repentance
--  Skinny enemy dodges the first tear that would hit it by side-stepping.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("SkinnyDodge", 1)
local ENEMY_SKINNY = 226
local DODGE_COOLDOWN = 60

local function onProjectileUpdate(_, proj)
    if proj.FrameCount <= 0 then return end
    -- Check if projectile is a player tear
    if not proj:IsEnemy() and proj.Variant == ProjectileVariant.PROJECTILE_NORMAL then
        local room = Game():GetRoom()
        for i = 0, room:GetAliveEnemiesCount() - 1 do
            local enemy = room:GetAliveEnemy(i)
            if enemy and enemy.Type == ENEMY_SKINNY then
                local data = enemy:GetData()
                if not data.dodgeCooldown then data.dodgeCooldown = 0 end
                if data.dodgeCooldown <= 0 then
                    local dist = proj.Position:Distance(enemy.Position)
                    if dist < 40 then
                        -- Side-step dodge
                        local projDir = proj.Velocity:Normalized()
                        local dodgeDir = Vector(-projDir.Y, projDir.X)
                        if math.random() < 0.5 then dodgeDir = -dodgeDir end
                        enemy.Position = enemy.Position + dodgeDir * 30
                        data.dodgeCooldown = DODGE_COOLDOWN
                        proj:Die()
                        break
                    end
                else
                    data.dodgeCooldown = data.dodgeCooldown - 1
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, onProjectileUpdate)
Isaac.DebugString("SkinnyDodge loaded!")