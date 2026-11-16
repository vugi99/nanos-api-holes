
local deprecated_classes = {
    Vehicle = true,
}

local ignored_classes = {
    Assets = true,
    Package_S = true,
    File = true,
}

local search_translation = {
    SetVisibility = "IsVisible"
}

-- immutable fields functions (to be ignored by holes)
local ignored_functions = {
    -- classname = {IngnoredFunctionName=true, ...}
    ["*"] = {
        GetAll = true,
        GetPairs = true,
        GetID = true,
        GetType = true,
        GetClass = true,
        GetByIndex = true,
        GetName = true,
        GetCount = true,
        GetAllValuesKeys = true,
        GetAttachedEntities = true, -- AttachTo
        GetAllSkeletalMeshAttached = true, -- AddSkeletalMesh
        GetAllStaticMeshAttached = true, -- AddStaticMesh
        GetParentClass = true,
        GetAttachedTo = true, -- AttachTo
        GetDistanceFromCamera = true,
        GetBounds = true,
        GetAttachedToSocket = true, -- AttachTo
        GetSocketTransform = true,
        GetAssetName = true,
        GetInheritedClasses = true,
        GetScreenPercentage = true,
        GetBoneTransform = true,
        GetMovingTo = true, -- MoveTo on Pawn
        GetHandler = true, -- PickUp
        GetPassenger = true,
        GetPassengers = true,
        GetDoors = true, -- SetDoor

        SetDefaultClass = true,
    },

    ["Player"] = {
        GetAccountID = true,
        GetIP = true,
        GetAccountName = true,
        GetPing = true,
        GetAccountIconURL = true,
        GetBySteamID = true,
        GetSteamID = true,
        GetControlledCharacter = true, -- Possess is the setter

        GetVOIPListeningChannels = true, -- SetVOIPGlobalChannelSetting?
        GetVOIPSpeakingChannels = true, -- SetVOIPGlobalChannelSetting?
        GetVOIPAmplitude = true, -- I think that's deprecated
    },

    ["Server"] = {
        GetIP = true,
        GetMaps = true,
        GetTickRate = true,
        GetLogLevel = true,
        GetMap = true, -- ChangeMap
        GetEntityByID = true,
        GetPlayersInRadius = true,
        GetTime = true,
        GetConnectionCount = true,
        GetMapAsset = true,
        GetCompressionLevel = true,
        GetActorsInRadius = true,
        GetPackages = true,
        GetQueryPort = true,
        GetPort = true,
        GetVersion = true,
        GetMapConfig = true,
        GetCustomSettings = true,
        GetMapSpawnPoints = true,

        SetPassword = true,
    },

    ["Timer"] = {
        SetTimeout = true,
        SetInterval = true,

        GetElapsedTime = true, -- SetRemainingTime
    },

    ["InstancedStaticMesh"] = {
        GetInstanceCount = true,
    },

    ["Cable"] = {
        GetAttachedEndTo = true, -- AttachEndTo
        GetAttachedStartTo = true, -- AttachStartTo
    },

    ["Character"] = {
        GetPicked = true, -- PickUp
        GetGrabbedProp = true, -- GrabProp
        GetFallingMode = true,
        GetVehicle = true, -- Enter/Leave vehicle
        GetSwimmingMode = true,
        GetVehicleSeat = true, -- EnterVehicle?
    },

    ["CharacterGASP"] = {
        GetVehicleSeat = true, -- EnterVehicle?
        GetGrabbedProp = true, -- GrabProp
        GetVehicle = true, -- Enter/Leave vehicle
    },

    ["Melee"] = {
        GetAnimationsCharacterUse = true, -- AddAnimationCharacterUse, ClearAnimationsCharacterUse
    }
}

local function TableMergeInto(src, dst)
    for k, v in pairs(src) do
        if type(dst[k]) == "table" then
            TableMergeInto(src[k], dst[k])
        else
            dst[k] = v
        end
    end
end
TableMergeInto(Package.Require("IgnoreConfig.lua"), ignored_functions)

local function IsIgnoredFunction(classname, name)
    if type(name) ~= "string" then return true end
    if string.len(name) > 1 then
        if string.sub(name, 1, 2) == "__" then return true end
    end
    if ignored_functions["*"][name] then return true end
    if ignored_functions[classname] then
        if ignored_functions[classname][name] then return true end
    end
    return false
end

-- Do not ever think about it.
local function ForceDump(to_parse)
    local copy_tbl = {}
    local k, v = next(to_parse)
    while k ~= nil do
        copy_tbl[k] = v
        k, v = next(to_parse, k)
    end
    return copy_tbl
end

local function table_count(tbl)
    local c = 0
    for _, __ in pairs(tbl) do c = c + 1 end
    return c
end

local function PrintKeys(name, tbl)
    local pk_tbl = {string.format("%s {", name or "")}
    for k, v in pairs(tbl) do
        table.insert(pk_tbl, "\t" .. k)
    end
    table.insert(pk_tbl, "}")

    print(table.concat(pk_tbl, "\r\n"))
end

-- Returns nanos Entity classes and static classes, outside of the lua library classes.
function GetNanosClasses()
    local ent_classes = {}
    local static_classes = {}
    for k, v in pairs(_G) do
        if k ~= "_G" then
            if type(k) == "string" and type(v) == "table" then
                if not deprecated_classes[k] then
                    if type(v.__entities) == "table" then
                        local meta = getmetatable(v)
                        if (not meta) or (not meta.__call) then
                            static_classes[k] = v
                        else
                            ent_classes[k] = v
                        end
                        --print(k, NanosTable.Dump(ForceDump(v)))
                    end
                end
            end
        end
    end

    return ent_classes, static_classes
end

function ShowMissingClassGetterSetters(name, v, global_missing_freg, global_freg)
    -- API functions lays in __function, other ones are in root.
    local full_freg = {} -- All the functions found on that class
    local freg = {} -- Which functions will be checked
    for fname, f in pairs(ForceDump(v)) do
        if type(f) == "function" then
            if not IsIgnoredFunction(name, fname) then
                freg[fname] = true
            end
            global_freg[fname] = true
            full_freg[fname] = true
        end
    end

    for fname, f in pairs(v.__function) do
        if type(f) == "function" then
            if not IsIgnoredFunction(name, fname) then
                freg[fname] = true
            end
            global_freg[fname] = true
            full_freg[fname] = true
        end
    end

    --if name == "CharacterSimple" then
        --print(name, NanosTable.Dump(full_freg))
    --end

    local missing_getters = {}
    local missing_setters = {}

    for fname, _ in pairs(freg) do
        if string.len(fname) >= 3 then
            local translation = search_translation[fname]
            local translation_match = false
            if translation then
                translation_match = full_freg[translation]
            end
            if string.sub(fname, 1, 3) == "Get" then
                local search = "Set" .. string.sub(fname, 4)
                if (not full_freg[search]) and (not translation_match) then
                    table.insert(missing_setters, search)
                    global_missing_freg[search] = true
                end
            -- I don't think that's useful
            --[[
            elseif string.sub(fname, 1, 2) == "Is" then
                local search = "Set" .. string.sub(fname, 3)
                if not full_freg[search] then
                    table.insert(missing_setters, search)
                    global_missing_freg[search] = true
                    print("Is matching not found", search)
                end]]--
            elseif string.sub(fname, 1, 3) == "Set" then
                local search = "Get" .. string.sub(fname, 4)
                local search_is = "Is" .. string.sub(fname, 4)
                if (not full_freg[search]) and (not full_freg[search_is]) and (not translation_match) then
                    table.insert(missing_getters, search)
                    global_missing_freg[search] = true
                end
            end
        end
    end

    if next(missing_getters) then
        print(name .. " missing Getters:", NanosTable.Dump(missing_getters))
    end

    if next(missing_setters) then
        print(name .. " missing Setters:", NanosTable.Dump(missing_setters))
    end

    return missing_getters, missing_setters
end

function ShowAllMissingGetterSetters(classes, global_missing_freg, global_freg)
    local m_g_count = 0
    local m_s_count = 0
    for k, v in pairs(classes) do
        if not ignored_classes[k] then
            local m_g, m_s = ShowMissingClassGetterSetters(k, v, global_missing_freg, global_freg)
            m_g_count = m_g_count + table_count(m_g)
            m_s_count = m_s_count + table_count(m_s)
        end
    end
    return m_g_count, m_s_count
end

function FindAPIHoles()
    local ent_classes, static_classes = GetNanosClasses()
    PrintKeys("Entity Classes", ent_classes)
    PrintKeys("Static Classes", static_classes)

    local global_mg_count = 0
    local global_ms_count = 0

    local global_missing_freg = {}
    local global_freg = {}

    local function ShowMissingGS(name, classes)
        print("===============================================")
        print("\t" .. name)
        print("===============================================")
        local m_g_count, m_s_count = ShowAllMissingGetterSetters(classes, global_missing_freg, global_freg)
        global_mg_count = global_mg_count + m_g_count
        global_ms_count = global_ms_count + m_s_count
    end

    ShowMissingGS("Entity Classes", ent_classes)
    ShowMissingGS("Static Classes", static_classes)
    print("===============================================")

    print("Total Missing Getters Count:", global_mg_count)
    print("Total Missing Setters Count:", global_ms_count)
    local tc_gfreg = table_count(global_freg)
    local tc_mfreg = table_count(global_missing_freg)
    print("Total Unique functions:", tc_gfreg)
    print("Total Unique Missing functions:", tc_mfreg)

    print("API Holes percentage:", (tc_mfreg/tc_gfreg)*100 .. "%")

    --PrintKeys("Functions", global_freg)
end


Package.Subscribe("Load", FindAPIHoles)