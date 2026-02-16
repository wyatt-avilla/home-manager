{ config, ... }:
{
  wayland.windowManager.hyprland.settings.layerrule = [
    "blur on, match:namespace swaync-control-center"
    "ignore_alpha 0.3, match:namespace swaync-control-center"
    "blur on, match:namespace swaync-notification-window"
    "ignore_alpha 0.3, match:namespace swaync-notification-window"
  ];

  services.swaync.style = ''
    * {
        font-family: "DejaVu Sans";
        font-size: 10pt;
    }

    @define-color base00 ${config.variables.colors.background};
    @define-color base01 ${config.variables.colors.black};
    @define-color base02 ${config.variables.colors.bright_black};
    @define-color base03 ${config.variables.colors.grey};
    @define-color base04 ${config.variables.colors.light_grey};
    @define-color base05 ${config.variables.colors.foreground};
    @define-color base06 ${config.variables.colors.white};
    @define-color base07 ${config.variables.colors.bright_white};
    @define-color base08 ${config.variables.colors.red};
    @define-color base09 ${config.variables.colors.orange};
    @define-color base0A ${config.variables.colors.yellow};
    @define-color base0B ${config.variables.colors.green};
    @define-color base0C ${config.variables.colors.cyan};
    @define-color base0D ${config.variables.colors.white};
    @define-color base0E ${config.variables.colors.purple};
    @define-color base0F ${config.variables.colors.dark_red_or_brown};

    progress,
    progressbar,
    trough {
      border: none;
    }

    trough {
      background: @base01;
    }

    .notification.low {
      border: none;
    }

    .notification.low progress {
      background: @base03;
    }

    .notification.normal {
      border: none;
    }

    .notification.normal progress {
      background: @base0F;
    }

    .notification.critical {
      border: none;
    }

    .notification.critical progress {
      background: @base08;
    }

    .summary {
      color: @base05;
    }

    .body {
      color: @base06;
    }

    .time {
      color: @base06;
    }

    .notification-action {
      color: @base05;
      background: alpha(@base01, 0.6);
    }

    .notification-action:hover {
      background: alpha(@base01, 0.8);
      color: @base05;
    }

    .notification-action:active {
      background: @base0F;
      color: @base05;
    }

    .close-button {
      color: @base02;
      background: @base08;
    }

    .close-button:hover {
      background: lighter(@base08);
      color: lighter(@base02);
    }

    .close-button:active {
      background: @base08;
      color: @base00;
    }

    .notification-content {
      background: transparent;
      border: none;
      border-radius: 20px;
      box-shadow: none;
    }

    .floating-notifications.background .notification-row .notification-background {
      background: transparent;
      color: @base05;
      margin: 10px;
    }

    .floating-notifications.background .notification-row .notification-background .notification {
      background: alpha(@base00, 0.6);
      border-radius: 20px;
      box-shadow:
        0 9px 20px rgba(0, 0, 0, 0.3),
        0 5px 10px rgba(0, 0, 0, 0.22);
    }

    .notification-group .notification-group-buttons,
    .notification-group .notification-group-headers {
      color: @base05;
    }

    .notification-group .notification-group-headers .notification-group-icon {
      color: @base05;
    }

    .notification-group .notification-group-headers .notification-group-header {
      color: @base05;
    }

    .notification-group.collapsed .notification-row .notification {
      background: alpha(@base01, 0.6);
    }

    .notification-group.collapsed:hover
      .notification-row:not(:only-child)
      .notification {
      background: alpha(@base01, 0.8);
    }

    .control-center {
      background: alpha(@base00, 0.6);
      border: 1px solid darker(@base02);
      border-radius: 20px;
      color: @base05;
      margin: 10px;
      box-shadow:
        0 19px 38px rgba(0, 0, 0, 0.3),
        0 15px 12px rgba(0, 0, 0, 0.22);
    }

    .control-center .notification-row .notification-background {
      background: alpha(@base00, 0.6);
      color: @base05;
    }

    .control-center .notification-row .notification-background:hover {
      background: alpha(@base00, 0.8);
      color: @base05;
    }

    .control-center .notification-row .notification-background:active {
      background: @base0F;
      color: @base05;
    }

    .widget-title {
      color: @base05;
      margin: 0.5rem;
    }

    .widget-title > button {
      background: alpha(@base01, 0.6);
      border: none;
      color: @base05;
    }

    .widget-title > button:hover {
      background: alpha(@base01, 0.8);
    }

    .widget-dnd {
      color: @base05;
    }

    .widget-dnd > switch {
      background: alpha(@base01, 0.6);
      border: none;
    }

    .widget-dnd > switch:hover {
      background: alpha(@base01, 0.8);
    }

    .widget-dnd > switch:checked {
      background: @base0F;
    }

    .widget-dnd > switch slider {
      background: @base06;
    }

    .widget-mpris {
      color: @base05;
    }

    .widget-mpris .widget-mpris-player {
      background: alpha(@base01, 0.6);
      border: none;
    }

    .widget-mpris .widget-mpris-player button:hover {
      background: alpha(@base01, 0.8);
    }

    .widget-mpris .widget-mpris-player > box > button {
      border: none;
    }

    .widget-mpris .widget-mpris-player > box > button:hover {
      background: alpha(@base01, 0.8);
      border: none;
    }
  '';
}
