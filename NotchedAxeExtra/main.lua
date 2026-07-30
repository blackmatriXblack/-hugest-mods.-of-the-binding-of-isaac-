-- ==========================================================================
--  Notched Axe Extra - The Binding of Isaac: Repentance
--  Notched Axe breaks 2 rocks per swing instead of 1
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("NotchedAxeExtra", 1)
local game = Game()

local NOTCHED_AXE = CollectibleType.COLLECTIBLE_NOTCHED_AXE
local lastSwingFrame = 0

function mod:onPlayerUpdate(player)
    if not player:HasCollectible(NOTCHED_AXE) then return end

    -- Detect when Notched Axe is being held/used (has charge bar active)
    local activeCharge = player:GetActiveCharge(ActiveSlot.SLOT_PRIMARY)
    if activeCharge > 0 then
        local frame = game:GetFrameCount()
        if frame - lastSwingFrame > 5 then
            -- Find nearby rocks and break an extra one per swing
            local room = game:GetRoom()
            local hitRocks = 0
            for i = 0, room:GetGridSize() - 1 do
                local grid = room:GetGridEntity(i)
                if grid then
                    local gridType = grid:GetType()
                    if gridType == GridEntityType.GRID_ROCK
                        or gridType == GridEntityType.GRID_ROCKB
                        or gridType == GridEntityType.GRID_ROCKTINTED
                        or gridType == GridEntityType.GRID_ROCK_ALT then
                        local dist = (player.Position - grid.Position):Length()
                        if dist < 60 and hitRocks < 1 then
                            grid:Destroy(false)
                            lastSwingFrame = frame
                            hitRocks = hitRocks + 1
                            Isaac.DebugString("NotchedAxeExtra: broke extra rock")
                        end
                    end
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPlayerUpdate)
Isaac.DebugString("NotchedAxeExtra loaded!")
