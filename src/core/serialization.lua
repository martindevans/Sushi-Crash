local module = {};

local function val_to_str(v)
  if "string" == type( v ) then
    v = string.gsub( v, "\n", "\\n" )
    if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
      return "'" .. v .. "'"
    end
    return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
  elseif type(v) == "table" then
    return module.tostring(v);
  else
    return tostring(v);
  end
end

local function key_to_str ( k )
  if type(k) == "string" and string.match( k, "^[_%a][_%a%d]*$" ) then
    return k;
  else
    return "[" .. val_to_str( k ) .. "]";
  end
end

--Serialize a table into a string which can be loaded by lua (as a table)
function module.tostring(tbl, func_val, func_tbl)

  assert(type(tbl) == "table");

  local result, done = {}, {}
  for k, v in ipairs( tbl ) do
    table.insert( result, val_to_str( v ) )
    done[ k ] = true
  end
  for k, v in pairs( tbl ) do
    if not done[ k ] then
      table.insert( result, key_to_str( k ) .. "=" .. val_to_str( v ) )
    end
  end
  return "{" .. table.concat( result, "," ) .. "}"
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
  end)
end

return module;
