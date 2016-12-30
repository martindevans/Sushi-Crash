local module = {};

module.FindEquilibrium = function(bot, lane)
    local nearby = bot:GetNearbyCreeps(22000, false);
    print("Nearby = " .. #nearby);
end

return module;