print("Client IgnoreConfig")
return {
    ["*"] = {
        GetDimension = true,
        GetMass = true,
        GetMesh = true,
        GetHealth = true,
        GetMaxHealth = true,

        -- Those 3 should be handled by GetMaterial returning the correct type depending on how it was set?
        SetMaterialFromCanvas = true,
        SetMaterialFromSceneCapture = true,
        SetMaterialFromWebUI = true,
    },

    ["Client"] = {
        GetActorsInRadius = true,
        GetEntityByID = true,
        GetPackages = true,
        GetRandomPointInNavigableRadius = true,
        GetRandomReachablePointInRadius = true,
        GetViewportSize = true,
        GetFrameTime = true,
        GetSettings = true, -- not allowed to set user settings from scripting
        GetLanguage = true,
        GetTime = true,
        --GetConnectedServerIP = true, -- The function name is wrong but I don't see a Client method to connect to another server
        GetLogLevel = true,
        GetLocalPlayer = true,

        SetDiscordActivity = true,
        SetSteamRichPresence = true,
    },

    ["Viewport"] = {
        GetViewportScale = true,
        GetViewportSize = true,
    },

    ["Sky"] = {
        GetWeather = true, -- ChangeWeather
    },

    ["Discord"] = {
        SetActivity = true,
    },

    ["Level"] = {
        GetStreamLevels = true,
    },

    ["Steam"] = {
        GetJoinedFromFriend = true,
        GetLeaderboardScoreAndRank = true, -- Unreleased, probably another function to set it (just under)
        SetLeaderboardScore = true,
        SetRichPresence = true,
    },

    ["Navigation"] = {
        GetRandomPointInNavigableRadius = true,
        GetRandomReachablePointInRadius = true,
    },

    ["Input"] = {
        GetGameKeyBindings = true,
        GetKeyCode = true,
        GetScriptingKeyBindings = true,
        GetModifierKeys = true,
        GetKeyIcon = true,

        -- Could we have AddMappedKey? So we can make custom input menus, without disturbing or (removing?) nanos key settings.
        --GetMappedKeys = true,
        --GetMappedKey = true,
    },

    ["Character"] = {
        -- Server only
        GetCanPickupPickables = true,
        GetPunchDamage = true,
        GetCanDive = true,
        GetCanPunch = true,
        GetCameraMode = true,
        GetGaitMode = true,
        GetWeaponShooterMode = true,
        GetPlayer = true,
        GetCanAim = true,
        GetCanDrop = true,
        GetCanSprint = true,
        GetFallDamageTaken = true,
        GetAllMorphTargetNames = true,
        GetCanGrabProps = true,
        GetImpactDamageTaken = true,
        GetCanDeployParachute = true,
        GetCanUsePickables = true,
        GetSpeedMultiplier = true,
        GetStanceMode = true,
    },

    ["Player"] = {
        GetVOIPChannel = true,
    },

    ["Grenade"] = {
        -- Server only
        GetTimeToExplode = true,
        GetDamageOuterRadius = true,
        GetMinimumDamage = true,
        GetHandlingMode = true,
        GetDamageFalloff = true,
        GetDamageInnerRadius = true,
        GetThrowForce = true,
        GetBaseDamage = true,
    },

    ["VehicleWheeled"] = {
        GetGear = true,
        GetRPM = true,
    },

    ["CharacterGASP"] = {
        GetPlayer = true,
        GetAllMorphTargetNames = true,
    },

    ["Sound"] = {
        GetDuration = true,
        GetPath = true,
    },

    ["CharacterSimple"] = {
        GetPlayer = true,
        GetAllMorphTargetNames = true,
    },

    ["Weapon"] = {
        GetHoldReleaseUse = true,
        GetParticlesBulletTrail = true,
        GetSoundFire = true,
        GetLeftHandRotation = true,
        GetRecoil = true,
        GetAnimationReload = true,
        GetAmmoBag = true,
        GetSoundLoad = true,
        GetBulletCount = true,
        GetSoundAim = true,
        GetParticlesShells = true,
        GetAnimationFire = true,
        GetSoundZooming = true,
        GetHandlingMode = true,
        GetCanHoldUse = true,
        GetSoundUnload = true,
        GetAmmoClip = true,
        GetAnimationCharacterFire = true,
        GetSoundDry = true,
        GetBulletColor = true,
        GetSpread = true,
        GetWallbangDamageMultiplier = true,
        GetRightHandOffset = true,
        GetClipCapacity = true,
        GetAmmoToReload = true,
        GetParticlesBarrel = true,
        GetLeftHandLocation = true,
        GetWallbangMaxDistance = true,
        GetSightLocation = true,
        GetMagazineMesh = true,
        GetSightRotation = true,
        GetCadence = true,
        GetSightFOVMultiplier = true,
        GetDamage = true,
    },

    ["Melee"] = {
        GetAnimationCharacterUse = true,
        GetHandlingMode = true,
        GetBaseDamage = true,
    },

    ["Cable"] = {
        -- Server only
        GetLocation = true,
    }
}