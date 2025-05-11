local function loadConfig()
    local info       = debug.getinfo(1, "S")
    local scriptPath = info.source:match("@?(.*[\\/])") or "./"
    local cfg = {}
    local f = io.open(scriptPath .. "Config.ini", "r")
    if not f then error("Cannot open config: " .. scriptPath .. "Config.ini") end
    for line in f:lines() do
        local k, v = line:match("([%w_]+)%s*=%s*(%-?%d+)")
        if k and v then cfg[k] = tonumber(v) end
    end
    f:close()
    return cfg
end

local config = loadConfig()

config.R = config.R or 1.0
config.G = config.G or 1.0
config.B = config.B or 1.0

if config.R > 254.0 then config.R = 254.0 end
if config.R < 1.0 then config.R = 1.0 end

if config.G > 254.0 then config.G = 254.0 end
if config.G < 1.0 then config.G = 1.0 end

if config.B > 254.0 then config.B = 254.0 end
if config.B < 1.0 then config.B = 1.0 end

local function WaitForObject(className)
    local object = nil

    while not object or not object:IsValid() do
        object = FindFirstOf(className)
    end
    
    return object
end

NotifyOnNewObject("/Script/Engine.PostProcessComponent", function(Context)
    local fullName = Context:GetFullName()
    if not string.find(fullName, "Highlight") then return end
    Context.bEnabled = true
end)

local playerCharacter = WaitForObject("VOblivionPlayerCharacter")
playerCharacter.HighlightObjects = true
playerCharacter.HighlightColor.R = config.R
playerCharacter.HighlightColor.G = config.G
playerCharacter.HighlightColor.B = config.B