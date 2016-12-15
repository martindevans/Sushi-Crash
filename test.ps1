# Append current directory to LUA_PATH so require function works. Make sure to do it *twice* with ? and ?.lua so the file extensions isn't required for import
$saved_path = $env:LUA_PATH
$env:LUA_PATH = $env:LUA_PATH + ";" + $pwd.Path + "\?"
$env:LUA_PATH = $env:LUA_PATH + ";" + $pwd.Path + "\?.lua"

try
{
    lua src/tests/run_tests.lua
}
finally
{
    # Set it back to whatever it was
    $env:LUA_PATH = $saved_path
}