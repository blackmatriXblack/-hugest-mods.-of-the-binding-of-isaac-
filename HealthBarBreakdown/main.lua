-- =============================================================================
--  HealthBarBreakdown - The Binding of Isaac: Repentance
--  Show detailed HP breakdown: red, soul, black, bone, eternal hearts numbers
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("HealthBarBreakdown", 1)

function mod:onRender()
    local player = Isaac.GetPlayer(0)
    if not player then return end

    -- Heart type counts
    local redHearts = player:GetHearts()
    local soulHearts = player:GetSoulHearts()
    local blackHearts = player:GetBlackHearts()
    local eternalHearts = player:GetEternalHearts()
    local boneHearts = player:GetBoneHearts()
    local goldenHearts = player:GetGoldenHearts()
    local rottenHearts = player:GetRottenHearts()

    -- Total health
    local maxHearts = player:GetMaxHearts()
    local totalHealth = redHearts + soulHearts + blackHearts + eternalHearts + boneHearts + goldenHearts

    local sw = Isaac.GetScreenWidth()
    local sh = Isaac.GetScreenHeight()
    local x = sw * 0.76
    local y = sh * 0.55

    -- Title
    Isaac.RenderScaledText("HP Breakdown", x, y, 0.85, 0.85, 1, 0.5, 0.7, 1)

    -- Total
    Isaac.RenderScaledText(
        string.format("Total: %d HP", totalHealth),
        x, y + 16, 1.1, 1.1, 1, 1, 1, 1
    )

    -- Heart type entries
    local entries = {}
    if redHearts > 0 then entries[#entries + 1] = {name = "Red",     count = redHearts,    r = 1, g = 0.2, b = 0.2} end
    if soulHearts > 0 then entries[#entries + 1] = {name = "Soul",    count = soulHearts,   r = 0.3, g = 0.6, b = 1} end
    if blackHearts > 0 then entries[#entries + 1] = {name = "Black",  count = blackHearts,  r = 0.3, g = 0.3, b = 0.3} end
    if eternalHearts > 0 then entries[#entries + 1] = {name = "Eternal", count = eternalHearts, r = 1, g = 1, b = 1} end
    if boneHearts > 0 then entries[#entries + 1] = {name = "Bone",    count = boneHearts,   r = 0.9, g = 0.9, b = 0.8} end
    if goldenHearts > 0 then entries[#entries + 1] = {name = "Gold",   count = goldenHearts, r = 1, g = 0.85, b = 0.2} end
    if rottenHearts > 0 then entries[#entries + 1] = {name = "Rotten", count = rottenHearts,  r = 0.5, g = 0.5, b = 0.3} end

    for i, entry in ipairs(entries) do
        local row = i - 1
        Isaac.RenderScaledText(
            string.format("%s: %d", entry.name, entry.count),
            x, y + 32 + row * 18, 0.8, 0.8, entry.r, entry.g, entry.b, 1
        )
    end

    -- Visual HP bar at bottom
    if totalHealth > 0 then
        local barLen = 36
        local barX = x
        local barY = y + 32 + #entries * 18 + 6

        local barStr = ""
        local segments = {}
        if redHearts > 0 then
            local seg = math.floor(redHearts / totalHealth * barLen)
            segments[#segments + 1] = {len = seg, r = 1, g = 0.15, b = 0.15}
        end
        if soulHearts > 0 then
            local seg = math.floor(soulHearts / totalHealth * barLen)
            segments[#segments + 1] = {len = seg, r = 0.3, g = 0.6, b = 1}
        end
        if blackHearts > 0 then
            local seg = math.floor(blackHearts / totalHealth * barLen)
            segments[#segments + 1] = {len = seg, r = 0.3, g = 0.3, b = 0.3}
        end

        local curX = barX
        for _, seg in ipairs(segments) do
            if seg.len > 0 then
                Isaac.RenderScaledText(
                    string.rep("█", seg.len), curX, barY, 0.5, 0.6, seg.r, seg.g, seg.b, 1
                )
                curX = curX + seg.len * 5 -- approximate offset
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
Isaac.DebugString("HealthBarBreakdown loaded!")
