-- Define a global function P to assist with debugging
-- The function takes any value as input, prints it in a human-readable format using vim.inspect,
-- and then returns the value unchanged.

P = function(v)
  print(vim.inspect(v))
  return v
end

