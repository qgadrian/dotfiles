require"frecency".setup {
  show_scores = false,
  show_unindexed = true,
  ignore_patterns = {"*.git/*", "*/tmp/*", "*node_modules/*"}
}

require"telescope".load_extension("frecency")
