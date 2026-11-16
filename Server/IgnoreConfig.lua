print("Server IgnoreConfig")
return {
    ["*"] = {
        SetMaterial = true, -- GetMaterial cannot be retrieved in most cases
        SetPhysicalMaterial = true,
        SetPhysicsAsset = true,
    },

    ["Particle"] = {
        SetParameterMaterial = true,
        SetParameterBool = true,
        SetParameterFloat = true,
        SetParameterMaterialFromTexture = true,
        SetParameterInt = true,
        SetParameterColor = true,
        SetParameterVector = true,
    }
}