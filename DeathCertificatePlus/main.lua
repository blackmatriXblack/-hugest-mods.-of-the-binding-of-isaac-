-- ==========================================================================
--  Death Certificate Plus - The Binding of Isaac: Repentance
--  Death Certificate can be used twice before disappearing
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("DeathCertificatePlus", 1)
local game = Game()

local DEATH_CERT = CollectibleType.COLLECTIBLE_DEATH_CERTIFICATE
local useCount = {}

function mod:onUseItem(itemType, rng, player)
    if itemType ~= DEATH_CERT then return end

    local idx = player.InitSeed
    if not useCount[idx] then useCount[idx] = 0 end
    useCount[idx] = useCount[idx] + 1

    if useCount[idx] < 2 then
        -- First use: keep the item by recharging it immediately
        for slot = 0, 3 do
            if player:GetActiveItem(slot) == DEATH_CERT then
                player:SetActiveCharge(slot, 1)
                Isaac.DebugString("DeathCertificatePlus: 1 use remaining")
                Isaac.RenderText("Death Cert: 1 use remaining",
                    180, 180, 1, 1, 0.8, 0, 0.9)
                break
            end
        end
    else
        -- Second use: let it be consumed normally
        useCount[idx] = 0
        Isaac.DebugString("DeathCertificatePlus: consumed after 2 uses")
    end
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.onUseItem, DEATH_CERT)
Isaac.DebugString("DeathCertificatePlus loaded!")
