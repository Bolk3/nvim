local severity = vim.diagnostic.severity

vim.diagnostic.config({
  signs = {
    text = {
      [severity.ERROR] = " ",
      [severity.WARN] = " ",
      [severity.HINT] = "󰠠 ",
      [severity.INFO] = " ",
    },
  },
})

vim.diagnostic.config({
  virtual_text = false, -- Désactive le texte au bout de la ligne
  signs = true,        -- Garde les icônes dans la colonne de gauche (signcolumn)
  underline = true,    -- Garde le soulignement des erreurs
  update_in_insert = false, -- Ne pas mettre à jour pendant que tu tapes (évite le bruit visuel)
  severity_sort = true,     -- Trie pour afficher les erreurs avant les warnings
})
