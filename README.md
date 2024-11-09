# vimcolorschemes/extractor.nvim

This plugin is used to extract color group data from a neovim buffer in the
context of [vimcolorschemes.com](https://vimcolorschemes.com) in the objective
of generating previews for colorschemes.

## Requirements

* vim syntax highlighting
* treesitter disabled

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
