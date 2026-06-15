# Upstream Details

Here is a list of changes I have done to keep this repo up-to-date with the upstream [Kickstart](https://github.com/nvim-lua/kickstart.nvim) repo (in reverse chronological order):

- ## 2026-03-12
    - Diff: [6ba2408..58170c7](https://github.com/nvim-lua/kickstart.nvim/compare/6ba2408..58170c7)
    - Summary:
        - Update GitHub actions
        - Simplify diagnostic config
        - Activate `guess-indent.nvim`
- ## 2025-05-20
    - Diff: [d350db2..6ba2408](https://github.com/nvim-lua/kickstart.nvim/compare/d350db2..6ba2408)
    - Summary:
        - Add `fd-find` dependency note to README
        - Use `vim.o` instead of `vim.opt` where possible
        - Rename `vim.highlight.on_yank` to `vim.hl.on_yank`
        - Use `NMAC427/guess-indent.nvim` instead of `tpope/vim-sleuth`
        - Change `Mason` repos to use `mason-org` URL
