local keys = {}

for _, module in ipairs {
  'plugins.snacks.keys.core',
  'plugins.snacks.keys.files',
  'plugins.snacks.keys.git',
  'plugins.snacks.keys.search',
  'plugins.snacks.keys.lsp',
  'plugins.snacks.keys.ui',
} do
  for _, keymap in ipairs(require(module)) do
    keys[#keys + 1] = keymap
  end
end

return keys
