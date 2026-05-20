local components = require 'plugins.heirline.components'
local conditions = require 'heirline.conditions'

return {
  hl = function()
    return conditions.is_active() and 'StatusLine' or 'StatusLineNC'
  end,

  components.RightPadding(components.Mode, 1),
  components.RightPadding(components.FileNameBlock, 1),
  components.RightPadding(components.Git, 1),
  components.RightPadding(components.Diagnostics, 1),
  components.RightPadding(components.SearchOccurrence, 0),
  components.Fill,
  components.MacroRecording,
  components.Fill,
  components.RightPadding(components.ShowCmd, 1),
  components.RightPadding(components.LSPActive, 1),
  components.RightPadding(components.Formatters, 2),
  components.RightPadding(components.SimpleIndicator, 1),
  components.RightPadding(components.FileType, 1),
  components.Ruler,
}
