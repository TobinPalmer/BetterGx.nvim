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

### Inspiration
This plugin was inspired by [vim-better-gx](https://gist.github.com/habamax/0a6c1d2013ea68adcf2a52024468752e) but is implemented in lua.
