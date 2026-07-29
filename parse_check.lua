local function stripLuau(src)
  src = src:gsub("\n%s*continue%s*;", "\n")
  src = src:gsub("([%w%)%]])%s*%+=%s*", "%1 = %1 + ")
  src = src:gsub("([%w%)%]])%s*%-=%s*", "%1 = %1 - ")
  src = src:gsub("([%w%)%]])%s*%*=%s*", "%1 = %1 * ")
  src = src:gsub("([%w%)%]])%s*%/=%s*", "%1 = %1 / ")
  return src
end

local function check(path)
  local f = io.open(path, "r")
  if not f then print(path .. ": cannot open"); return end
  local src = f:read("*a")
  f:close()
  src = stripLuau(src)
  local fn, err = load(src, path)
  if not fn then
    print(path .. ": PARSE FAIL: " .. tostring(err))
  else
    print(path .. ": OK")
  end
end

check("Example.lua")
check("Library.lua")
check("addons/ThemeManager.lua")
check("addons/SaveManager.lua")
