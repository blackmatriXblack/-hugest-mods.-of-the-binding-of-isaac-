-- =============================================================================
--  OneHitKoMode - The Binding of Isaac: Repentance
--  Player dies in one hit regardless of HP (install at your own risk)
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("OneHitKoMode", 1)
local game = Game()
local modEnabled = true

-- Warning banner display counter
local warningFade = 180
local lastDamageFrame = 0

function mod:onPlayerInit(player)
    -- Cap player HP at 1 (one heart container, no soul/black hearts)
    player:AddMaxHearts(-player:GetMaxHearts() + 2, true) -- 1 full heart
    player:AddSoulHearts(-player:GetSoulHearts())
    player:AddBlackHearts(-player:GetBlackHearts())
    player:AddBoneHearts(-player:GetBoneHearts())
    player:AddEternalHearts(-player:GetEternalHearts())

    -- Set current HP to half a heart
    player:SetMinDamageCooldown(0)

    Isaac.DebugString("OneHitKoMode: Player HP capped at 1!")
end

function mod:onEntityTakeDmg(target, amount, flags, source, countdown)
    -- Only affect the player
    if target.Type ~= EntityType.ENTITY_PLAYER then return end

    local player = target:ToPlayer()
    if not player then return end

    -- Any damage is fatal
    if amount > 0 then
        lastDamageFrame = game:GetFrameCount()
        warningFade = 180

        -- Kill the player immediately by dealing massive damage
        player:TakeDamage(998, DamageFlag.DAMAGE_FAKE, EntityRef(player), 0)
        -- Then actually kill
        player:Kill()

        -- Visual: flash screen red
        game:ScreenShake(20, 60)

        return false -- Prevent default damage processing
    end
end

function mod:onPostRender()
    -- Show persistent warning on screen
    if warningFade > 0 then
        warningFade = warningFade - 1
        local alpha = math.min(warningFade / 60, 1.0)
        Isaac.RenderText(
            "ONE HIT = DEATH",
            220, 200,
            1.0, 0.2, 0.2, alpha
        )
    end

    -- Always show mode indicator
    local player = Isaac.GetPlayer(0)
    if player and player:Exists() then
        Isaac.RenderText(
            "[ONE HIT KO MODE ACTIVE]",
            200, 350,
            1.0, 0.1, 0.1, 0.8
        )
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, mod.onPlayerInit)
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.onEntityTakeDmg)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onPostRender)

Isaac.DebugString("OneHitKoMode loaded! WARNING: Instant death mode active.")
