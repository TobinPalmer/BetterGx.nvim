# BetterGx.nvim

This simple plugin improves the `gx` which opens a URL in neovim.

Example Config:

```lua
return {
  'TobinPalmer/BetterGX.nvim',
  keys = {
    { 'gx', '<CMD>lua require("better-gx").BetterGx()<CR>' },
  },
}
```
