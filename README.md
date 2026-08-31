# vimcolorschemes/extractor.nvim

This plugin is used to extract color group data from a neovim buffer in the
context of [vimcolorschemes.com](https://vimcolorschemes.com) in the objective
of generating previews for colorschemes.

## Requirements

- vim syntax highlighting
- treesitter disabled

## Installation

```lua
-- lazy.nvim
{
  "vimcolorschemes/extractor.nvim"
}
```

## Usage

### Extract colorscheme groups

Returns a lua table with the color groups found in the buffer + some extra.

`:VCSExtract [colorscheme ...]`

Lua API:

```lua
require("extractor").extract({
  colorschemes = { "default", "gruvbox" }, -- optional
  output_path = "/tmp/extracted.json",      -- optional
})
```

The extractor tolerates themes that load a variant successfully but normalize
`vim.g.colors_name` to a canonical base name.

When `output_path` is set, the file holds a JSON object keyed by colorscheme
name, then by background, then a list of color groups:

```json
{
  "gruvbox": {
    "dark": [{ "name": "NormalFg", "hexCode": "#EBDBB2", "bold": true }]
  }
}
```

A background key is only present when that background was extracted, so a
colorscheme that only supports `dark` has no `light` key. `hexCode` is always a
`#RRGGBB` string, in upper case.

### List installed colorschemes

`:VCSColorschemes [{output_path}]`

Lua API:

```lua
require("extractor").colorschemes({
  output_path = "/tmp/colorschemes.json", -- optional
})
```
