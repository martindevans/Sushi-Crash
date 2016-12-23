--Provides a method to communicate with other bots
local module = {};

--Attaches the comms system to the given environment
function module.Load(g, env)

    --Create the underlying intercomm system. This is shared between all bots using the same 'g' (which should be all bots)
    if not g.intercomm then
        g.intercomm = {
            dire = {},
            radiant = {}
        };
    end

    local bot = nil;
    env._LOADED[GetScriptDirectory() .. "/src/core/comms"] = {

        --Register a new bot with the comms system. Returns a handle which can be used to access the rest of the comms system
        RegisterBot = function(bot_registering)

            assert(bot == nil, "Cannot register a bot twice");
            bot = bot_registering;

            local team = GetTeamForPlayer(bot:GetPlayer());

            --return a table of stuff which the comms system can do for this specific player
            return {

            }
        end

    };
end

return module;