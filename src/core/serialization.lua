local module = {};

local val_to_str = nil;
local key_to_str = nil;
local tbl_to_str = nil;

local function val_to_str(v, n, func_tbl)

  local typ = type(v);

  if typ == "table" then
    return tbl_to_str(func_tbl(v, n), func_tbl);
  end

  if typ == "string" then
    v = string.gsub( v, "\n", "\\n" )
    if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
      return "'" .. v .. "'"
    end
    return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
  end

  return tostring(v);
end

local function key_to_str(k, func_tbl)
  if type(k) == "string" and string.match( k, "^[_%a][_%a%d]*$" ) then
    return k;
  else
    return "[" .. val_to_str(k, "__key__", func_tbl) .. "]";
  end
end

--Serialize a table into a string which can be loaded by lua (as a table)
function tbl_to_str(tbl, func_tbl)
  assert(type(tbl) == "table");
  assert(type(func_tbl) == "function", "func_tbl must be a function. Type=" .. type(func_tbl));

  local result, done = {}, {}

  for k, v in ipairs( tbl ) do
    table.insert(result, val_to_str(v, tostring(k), func_tbl))
    done[k] = true
  end
  for k, v in pairs(tbl) do

    if not done[k] then
      local kk = key_to_str(k, func_tbl);
      local vv = val_to_str(v, k, func_tbl);
      table.insert(result, kk .. "=" .. vv)
    end
  end
  return "{" .. table.concat(result, ",") .. "}"
end

function module.tostring(tbl, func_tbl)
  func_tbl = func_tbl or function(a) return a; end;

  assert(type(tbl) == "table");
  assert(type(func_tbl) == "function", "func_tbl must be a function. Type=" .. type(func_tbl));
  
  return tbl_to_str(tbl, func_tbl);
end

if test then
  test("Empty table serializes", function()
    local s = module.tostring({});
    assert(s == "{}", s);
  end);

  test("Table with value serializes", function()
    local s = module.tostring({a=1});
    assert(s == "{a=1}", s);
  end);

  test("Table with nested table serializes", function()
    local s = module.tostring({a={b=2}});
    assert(s == "{a={b=2}}", s);
  end);
end

return module;
