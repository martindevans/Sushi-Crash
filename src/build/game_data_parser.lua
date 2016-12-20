local module = {}

--split up the input string into lines
local function lex(str)
  return str:gmatch("(.-)\r?\n")
end

--remove everything after a // from the given string iterator
function remove_comments(iter)
  return function()
    local v = iter();
    if v == nil then return nil; end;

    return v:gsub("//.*", "");
  end
end

--remove newlines from the given string iterator
function remove_newlines(iter)
  return function()

    while true do
      local v = iter();
      if v == nil then return nil; end;

      --remove leading whitespace
      local clean = v:gsub("^%s*", "");

      if clean ~= "" then
        return clean;
      end
    end
  end
end

local function expect(expected, iter)
  local r = iter();
  if r ~= expected then
    error("Expected to parse '" .. tostring(expected) .. "' but encountered '" .. tostring(r) .. "'");
  end
end

--forward define functions
local parse_table = nil;
local parse_table_data = nil;

local function parse_data_item(line, iter)
  --Determine if this is a single value, or a title of entire new table
  local singleValueMatch = line:gmatch("\"(.-)\"");
  local k, v = singleValueMatch(), singleValueMatch();
  if k and v then
    return k, v;
  end

  --No Key/Value pair match , so it must be a table
  return k, parse_table_data(iter);
end

parse_table_data = function(iter_lines)
  expect("{", iter_lines);

  local data = {};
  for line in iter_lines do

    if line == "}" then break; end

    --Parse a single item, this may be a key value pair or an entire new table
    local k, v = parse_data_item(line, iter_lines);
    data[k] = v;
  end
  return data;
end

parse_table = function(iter_lines)

--[[
Tables come in the form:
  "Name"
  {
    //Data
  }
]]

  local name = iter_lines();
  local data = parse_table_data(iter_lines);

  return name, data;
end

module.parse = function(str)
  --read string line by line
  --Discard everything after // as a comment
  --Discard empty lines
  local lines = remove_newlines(remove_comments(lex(str)));

  --Consume lines until we encounter the start of the file
  local name, tab = parse_table(lines);
  return tab;
end

if test then
  test("Parse empty is empty", function()
    local ast = module.parse("\"DOTAAbilities\"\n{\n}\n");

    assert(ast ~= nil);
  end);

  test("Parse table contains parsed data", function()
    local ast = module.parse("\"DOTAAbilities\"\n{\n\"A\"   \"B\"\n}\n");

    assert(ast.A == "B", "Expected A='B', but A ='" .. tostring(ast.A) .. "'");
  end);

  test("Parse table contains nested table data", function()
    local ast = module.parse("\"DOTAAbilities\"\n{\n\"A\"\n{\n\"B\" \"C\"\n}\n}");

    assert(ast.A, "expected A to not be nil");
    assert(ast.A.B, "expected A.B to not be nil");
    assert(ast.A.B == "C", "Expected A.B='C', but A.B ='" .. tostring(ast.A.B) .. "'");
  end);

  test("Parse table contains nested table data and sibling key/value", function()
    local ast = module.parse("\"DOTAAbilities\"\n{\n\"A\"\n{\n\"B\" \"C\"\n}\n\"D\" \"E\"\n}");

    assert(ast.A, "expected A to not be nil");
    assert(ast.A.B, "expected A.B to not be nil");
    assert(ast.A.B == "C", "expected A.B='C', but A.B ='" .. tostring(ast.A.B) .. "'");
    assert(ast.D == "E", "expected D='E', but D='" .. tostring(ast.D) .. "'");
  end);

  test("Parse everything", function()
    local f = io.open("src/build/data/items.txt", "rb");
    local content = f:read("*all");
    f:close();

    local ast = module.parse(content);
    assert(ast.Version == "1", "expected Version='1', but Version='" .. tostring(ast.Version) .. "'");
    assert(ast.item_blink.ID == "1", "expected item_blink.ID='1', but item_blink.ID='" .. tostring(ast.item_blink.ID) .. "'")
  end);
end

--write out the file in a format which can be loaded by lua as a great big table
if not test and io and arg then
  local f = io.open(arg[1], "rb");
  local content = f:read("*all");
  f:close();

  local serialize = require("src/core/serialization");
  local ast = module.parse(content);
  local s = serialize.tostring(ast, function(t)
    --We're serializing a table. Is it an "array", which in this case means the keys are all string which parse to integers, starting at 1
    local array = {};
    for k, v in pairs(t) do
      --Parse it to an integral number?
      local num = tonumber(k);
      if num == nil or num ~= math.floor(num) then
        return t;
      else
        array[num] = v;
      end
    end

    --If we got here every key successfully parsed into an integer.
    return array;

  end);

  local fo = io.open(arg[2], "w");
  fo:write("--" .. os.date("Built at %c\n"))
  fo:write(s);
  fo:flush();
  fo:close();
end
