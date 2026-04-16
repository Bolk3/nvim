return {
  {
    "3rd/image.nvim",
    dependencies = {
      -- "leafo/magick", -- Optionnel si tu as déjà ImageMagick sur ton système
    },
    config = function()
      require("image").setup({
        -- TRÈS IMPORTANT : Pour WezTerm, "kitty" est le meilleur choix.
        -- "ueberzug" est souvent instable et nécessite un binaire externe.
        backend = "kitty",
	processor = "magick_cli",
        integrations = {
          markdown = {
            enabled = true,
            clear_in_insert_mode = true,
            download_remote_images = true,
            only_render_image_at_cursor = true,
            filetypes = { "markdown", "vimwiki" },
          },
          html = { enabled = false },
          css = { enabled = false },
        },
        max_height_window_percentage = 50,
        window_overlap_clear_enabled = false,
        editor_only_render_when_focused = false,
        tmux_show_only_in_active_window = true,
        -- Permet de voir une image quand tu ouvres directement un .png ou .jpg
        hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" },
      })
    end,
  },
}
