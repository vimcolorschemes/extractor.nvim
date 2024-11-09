# vimcolorschemes/extractor.nvim

This is a simple plugin to extract color groups from a neovim buffer. It's used
in the context of [vimcolorschemes.com](https://vimcolorschemes.com) to extract
color data from a vim colorscheme and generate a preview.

## Requirements

* vim syntax highlighting (not treesitter)

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

`:VCSExtract [{output_path}] [{background}]`

### List installed colorschemes

`:VCSColorschemes`
