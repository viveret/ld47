local M = {
    Group = require "src.components.ui.GroupUIComponent",
    Clock = require "src.components.ui.Clock",
    GameOverlay = require "src.components.ui.GameOverlay",
    SaveSlots = require "src.components.ui.SaveSlots",
    Journal = require "src.components.ui.Journal",
    Notes = require "src.components.ui.Notes",
    Inventory = require "src.components.ui.Inventory",
    Toast = require "src.components.ui.Toast",
    ImageButton = require "src.components.ui.ImageButton",
    TextButton = require "src.components.ui.TextButton",
    Space = require "src.components.ui.Space",
    TabGroup = require "src.components.ui.TabGroup",
    TabItem = require "src.components.ui.TabItem",
    InGame = {
        InteractionTray = require "src.components.ui.InGame.InteractionTray",
    },
    options = {
        System = require "src.components.ui.options.SystemOptionsView",
        Audio = require "src.components.ui.options.AudioOptionsView",
        Graphics = require "src.components.ui.options.GraphicsOptionsView",
    },
}
return M