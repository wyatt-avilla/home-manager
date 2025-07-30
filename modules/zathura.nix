{
  programs.zathura = {
    enable = true;
    mappings = {
      n = "scroll left";
      e = "scroll down";
      i = "scroll up";
      o = "scroll right";

      E = "navigate next";
      I = "navigate previous";
    };

    options = {
      selection-clipboard = "clipboard";
    };
  };
}
