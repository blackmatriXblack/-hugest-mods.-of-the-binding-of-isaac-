-- =============================================================================
--  AshpitDust - The Binding of Isaac: Repentance
--  Ashpit floors apply a dusty screen fog effect that darkens the edges of vision
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("AshpitDust", 1)

local function IsAshpit()
    local level = Game():GetLevel()
    return (level:GetStage() == LevelStage.STAGE3_1 or level:GetStage() == LevelStage.STAGE3_2)
       and level:GetStageType() == StageType.STAGETYPE_REPENTANCE
end

local function RenderDustFog()
    if not IsAshpit() then return end

    -- Dark vignette effect at screen edges
    local scale = 6.0            -- Size of the vignette gradient
    local alpha = 0.35           -- Opacity of the dark edges
    local radius = 380           -- Inner radius of clarity

    -- Draw four gradient panels from edges inward
    local screenWidth = Isaac.GetScreenWidth()
    local screenHeight = Isaac.GetScreenHeight()
    local halfW = screenWidth / 2
    local halfH = screenHeight / 2

    -- Top gradient
    for i = 0, 20 do
        local a = alpha * (1 - i / 20)
        if a > 0 then
            local y = i * scale
            Isaac.RenderRectangle(0, y, screenWidth, scale, 0, 0, 0, a)
        end
    end

    -- Bottom gradient
    for i = 0, 20 do
        local a = alpha * (1 - i / 20)
        if a > 0 then
            local y = screenHeight - (i + 1) * scale
            Isaac.RenderRectangle(0, y, screenWidth, scale, 0, 0, 0, a)
        end
    end

    -- Left gradient
    for i = 0, 20 do
        local a = alpha * (1 - i / 20)
        if a > 0 then
            local x = i * scale
            Isaac.RenderRectangle(x, 0, scale, screenHeight, 0, 0, 0, a)
        end
    end

    -- Right gradient
    for i = 0, 20 do
        local a = alpha * (1 - i / 20)
        if a > 0 then
            local x = screenWidth - (i + 1) * scale
            Isaac.RenderRectangle(x, 0, scale, screenHeight, 0, 0, 0, a)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, RenderDustFog)
Isaac.DebugString("AshpitDust loaded!")
