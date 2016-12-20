# Append current directory to LUA_PATH so require function works. Make sure to do it *twice* with ? and ?.lua so the file extensions isn't required for import
$saved_path = $env:LUA_PATH
$env:LUA_PATH = $env:LUA_PATH + ";" + $pwd.Path + "\?"
$env:LUA_PATH = $env:LUA_PATH + ";" + $pwd.Path + "\?.lua"

# Perform a few build tasks. All build tasks spit out a lua file somewhere
try
{
    lua src/build/game_data_parser.lua (Resolve-Path "src/build/data/items.txt").Path ((Resolve-Path "src/game/data/").Path + "items.lua")
    lua src/build/game_data_parser.lua (Resolve-Path "src/build/data/npc_heroes.txt").Path ((Resolve-Path "src/game/data/").Path + "heroes.lua")
}
finally
{
    # Set it back to whatever it was
    $env:LUA_PATH = $saved_path
}
