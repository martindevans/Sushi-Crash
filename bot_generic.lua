--Save a reference to the real global environment
local real_G = _G;

--Create a virtual environment to run this bot in
local env = nil;
env = {
  _LOADED = {},
  
  require = function(path)

    path = GetScriptDirectory() .. "/" .. path;
  
    if env._LOADED[path] then
      return env._LOADED[path];
    end
  
    local f, err = loadfile(path);
    if err then
      error("Error loading '" .. tostring(path) .. "': " .. tostring(err));
    else
      local l = setfenv(f, env)();
      env._LOADED[path] = l;
      return l;
    end
  end,
  
  real_g = real_G,
};

--Any reads from the env which do not resolve to a value instead read from the real global table
setmetatable(env, {
  __index = real_G,
});

--Load comms into the virtual environment (to allow cross env communication)
local comms = require(GetScriptDirectory() .. "/src/core/comms");
comms.Load(real_G, env);

local bot_main_module = nil;

function Think()
  if not bot_main_module then
    local f, err = loadfile(GetScriptDirectory() .. "/src/main");
    if err then
      print("Error loading main (for '" .. GetBot():GetUnitName() .. "'): " .. tostring(err));
      return;
    else
      print("Loaded main for " .. GetBot():GetUnitName());
      bot_main_module = setfenv(f, env)();
    end
  end

  if not bot_main_module then
    return;
  end
  
  if not bot_main_module.Think then
    print("bot_main_module.Think is nil");
    return;
  end

  bot_main_module.Think();
end
