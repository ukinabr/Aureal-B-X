--simple loader here hehe :)

local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

local baseFolder = "Aureal B-X"
local settingsPath = baseFolder .. "/config.txt"

if makefolder and not isfolder(baseFolder) then
    makefolder(baseFolder)
end

local function isAutoExecEnabled()
    if isfile and isfile(settingsPath) then
        local success, content = pcall(readfile, settingsPath)
        if success and content then
            for line in string.gmatch(content, "[^\r\n]+") do
                local key, value = string.match(line, "^%s*(%w+)%s*=%s*(%w+)%s*$")
                if key == "autoexec" then
                    return value == "true"
                end
            end
        end
    end
    return true
end

if not game:IsLoaded() then
    game.Loaded:Wait()
end

if not isAutoExecEnabled() and workspace.DistributedGameTime < 10 then
    return
end

local teleportScript = [[
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ukinabr/Aureal-B-X/refs/heads/main/dist/Loader.lua"))()
]]

local queue = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)

if queue then
    LocalPlayer.OnTeleport:Connect(function(state)
        if state == Enum.TeleportState.Started or state == Enum.TeleportState.InProgress then
            if isAutoExecEnabled() then
                pcall(queue, teleportScript)
            end
        end
    end)
end

local function isPhantoms()
    local success, result = pcall(function()
        return workspace:FindFirstChild("AI_FREDDY") ~= nil
    end)
    return success and result
end

local scripts = {
    [4823392707] = "https://raw.githubusercontent.com/ukinabr/Aureal-B-X/refs/heads/main/Games/FMR/Minigames/XOR%2BITP-Control",
    [108015301318511] = "https://raw.githubusercontent.com/ukinabr/Aureal-B-X/refs/heads/main/Games/FMR/Minigames/FNAF1",
    [17673168111] = "https://raw.githubusercontent.com/ukinabr/Aureal-B-X/refs/heads/main/Games/FMR/Minigames/SisterLocation",
    [12402976334] = "https://raw.githubusercontent.com/ukinabr/Aureal-B-X/refs/heads/main/Games/FMR/Minigames/GoldenF",
    [79589802006248] = "https://raw.githubusercontent.com/ukinabr/Aureal-B-X/refs/heads/main/Games/FMR/Minigames/PigFrog",
    [92827819645934] = "https://raw.githubusercontent.com/ukinabr/Aureal-B-X/refs/heads/main/Games/FMR/Minigames/Foxy",
    [17163559210] = "https://raw.githubusercontent.com/ukinabr/Aureal-B-X/refs/heads/main/Games/FMR/Minigames/Endo",
    [74221148357881] = "https://raw.githubusercontent.com/ukinabr/Aureal-B-X/refs/heads/main/Games/FMR/Minigames/Moon",
    [71731529216768] = "https://raw.githubusercontent.com/ukinabr/Aureal-B-X/refs/heads/main/Games/FMR/Minigames/Orvillie",
    [1343871267] = "https://raw.githubusercontent.com/ukinabr/Aureal-B-X/refs/heads/main/Games/FMR/main-game.lua",
}

task.spawn(function()
    if isPhantoms() then
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/ukinabr/Aureal-B-X/refs/heads/main/Games/FMR/Minigames/Phantoms"))()
        end)
        if not success then
            warn("Failed to load phantoms script: " .. tostring(err))
        end
    else
        local url = scripts[game.PlaceId] or scripts[game.GameId]
        if url then
            local success, err = pcall(function()
                loadstring(game:HttpGet(url))()
            end)
            if not success then
                warn("Failed to load map script: " .. tostring(err))
            end
        else
            warn("Unsupported place. PlaceId: " .. tostring(game.PlaceId) .. " | GameId: " .. tostring(game.GameId))
        end
    end
end)
