--[[

  - Create a tree:

  local bt = require("behaviour_tree");
  bt.new(
    bt.Sequence(
      bt.Condition(
        function(a, b) return a > b; end,
        bt.Null()
      ),
      bt.Action(some_func),
      bt.Action(some_other_func)
    )
  )

  - Node:
   - State - Ready, Running, Success, Failed, Error (see node_state.lua)
   - Visit() - Run the node
   - Reset() - Reset a non running node back to Ready state
   - Cancel() - Inform a node it should stop running
]]

local module = {};

module.Condition = require("src/behaviour_tree/nodes/condition").new;

--Create a new behaviour tree
function module.new(root)
  error("Not Implemented");
end

if test then

end

return module;
