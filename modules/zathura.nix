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

      k = "search forward";
      N = "search previous";
    };

    options = {
      selection-clipboard = "clipboard";
    };
  };
}
