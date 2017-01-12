local module = {};

module.wait_until = function(predicate)
  repeat
    coroutine.yield();
  until predicate();
end

module.wait_while = function(predicate)
    module.wait_until(function()
        return not predicate();
    end);
end

module.wait_for_duration = function(seconds, tick)

  if seconds <= 0 then
    tick(0);
    return;
  end

  local start = DotaTime();
  while DotaTime() - start < seconds do
    if tick then tick(DotaTime() - start); end
    coroutine.yield();
  end
end

return module;