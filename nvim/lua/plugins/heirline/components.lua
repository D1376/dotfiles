local M = {}

for _, module in ipairs {
  'plugins.heirline.components.core',
  'plugins.heirline.components.mode',
  'plugins.heirline.components.file',
  'plugins.heirline.components.git',
  'plugins.heirline.components.diagnostics',
  'plugins.heirline.components.language',
  'plugins.heirline.components.ui',
} do
  for name, component in pairs(require(module)) do
    M[name] = component
  end
end

return M
