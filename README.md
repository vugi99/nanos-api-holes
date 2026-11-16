# nanos-api-holes

This script will identify missing Setters and Getters in the nanos lua environment.

> [!NOTE]
> The script doesn't check against the documentation api, there may be some undocumented or environment mismatches.

## Setup
* Install the package
* Set the `Config.toml` packages to: (api-holes should be the only package loaded) 
```toml
packages = [
                            "api-holes",
]
```

## Running
* Start the server
* Optionally join with a client to also check its environment.

## Output
On `Package` load the script will output:
* The Entity Classes found
* The Static Classes found
* The missing Entity classes methods
* The missing Static Classes methods
* Statistics

## Statistics
Here's nanos `1.171.1` and api-holes `0.1.0` statistics traces:
```
-- Server
2026-11-16 16:22:59  SCRIPT  [api-holes] Total Missing Getters Count:   286
2026-11-16 16:22:59  SCRIPT  [api-holes] Total Missing Setters Count:   94
2026-11-16 16:22:59  SCRIPT  [api-holes] Total Unique functions:        612
2026-11-16 16:22:59  SCRIPT  [api-holes] Total Unique Missing functions:        146
2026-11-16 16:22:59  SCRIPT  [api-holes] API Holes percentage:  23.856209150327%
```

```
-- Client
2026-11-16 16:22:59  SCRIPT  [api-holes] Total Missing Getters Count:    413    
2026-11-16 16:22:59  SCRIPT  [api-holes] Total Missing Setters Count:    76    
2026-11-16 16:22:59  SCRIPT  [api-holes] Total Unique functions:    714    
2026-11-16 16:22:59  SCRIPT  [api-holes] Total Unique Missing functions:    186    
2026-11-16 16:22:59  SCRIPT  [api-holes] API Holes percentage:    26.050420168067% 
```