--[[

  A node which runs a predicate and instantly fails or succeeds depending upon the predicate return value
  
]]

local state = require("src/behaviour_tree/node_state");
local readonly = require("src/core/readonly");

local module = {};

function module.new(predicate)
  assert(type(predicate) == "function");

  local obj = {};

  --Set the start state to ready
  obj.State = state.Ready;

  --Write the predicate result into state
  obj.Visit = function()
    if predicate() then
      obj.State = state.Success;
    else
      obj.State = state.Failed;
    end
  end

  --Reset back to ready state
  obj.Reset = function()
    obj.State = state.Ready;
  end

  --This isn't a long running node, so we don't care about cancellation
  obj.Cancel = function() end

  return readonly(obj);
end

if test then
  test("Starts in ready state", function()
    local n = module.new(function() return true end);

    assert(n.State == state.Ready, "Expected ready state");
  end);

  test("State is readonly", function()
    local n = module.new(function() return true end);

    expect_error(function()
      n.State = "Hello";
    end)
  end);

  test("Predicate true leads to success", function()
    local n = module.new(function() return true end);

    n.Visit();

    assert(n.State == state.Success, "Expected success");
  end);

  test("Predicate true leads to success", function()
    local n = module.new(function() return false end);

    n.Visit();

    assert(n.State == state.Failed, "Expected failure");
  end)
end

return module;
