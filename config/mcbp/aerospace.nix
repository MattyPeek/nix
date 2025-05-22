{ config, lib, pkgs, ... }: {
services.aerospace = {
    enable = false;
    settings = {
        gaps = {
            outer.left = 10;
            outer.bottom = 10;
            outer.top = 10;
            outer.right = 10;
            inner.horizontal = 10;
            inner.vertical = 10;
        };
        after-startup-command = [
            "exec-and-forget /run/current-system/sw/bin/borders active_color=0xffaa22ff inactive_color=0x449911ee width=5.0"
        ];
        workspace-to-monitor-force-assignment = {
            "1" = [ "27E1N1600AE" "built-in" ];
            "2" = [ "Cinema" "built-in"];
            "3" = "DELL";
            "4" = [ "27E1N1600AE" "built-in" ];
            "5" = [ "27E1N1600AE" "built-in" ];
            "6" = [ "27E1N1600AE" "built-in" ];
            "7" = [ "27E1N1600AE" "built-in" ];
            "8" = [ "27E1N1600AE" "built-in" ];
            "9" = [ "27E1N1600AE" "built-in" ];
        };
        mode.main.binding = {
            # Move around
            alt-h = "focus left";
            alt-j = "focus down";
            alt-k = "focus up";
            alt-l = "focus right";

            # Move windows
            alt-shift-h = "move left";
            alt-shift-j = "move down";
            alt-shift-k = "move up";
            alt-shift-l = "move right";

            # Join windows
            alt-shift-cmd-h = "join-with left";
            alt-shift-cmd-j = "join-with down";
            alt-shift-cmd-k = "join-with up";
            alt-shift-cmd-l = "join-with right";
            
            # Switch workspace
            alt-1 = "workspace 1";
            alt-2 = "workspace 2";
            alt-3 = "workspace 3";
            alt-4 = "workspace 4";
            alt-5 = "workspace 5";
            alt-6 = "workspace 6";
            alt-7 = "workspace 7";
            alt-8 = "workspace 8";
            alt-9 = "workspace 9";

            # Send to workspace
            alt-shift-1 = "move-node-to-workspace 1";
            alt-shift-2 = "move-node-to-workspace 2";
            alt-shift-3 = "move-node-to-workspace 3";
            alt-shift-4 = "move-node-to-workspace 4";
            alt-shift-5 = "move-node-to-workspace 5";
            alt-shift-6 = "move-node-to-workspace 6";
            alt-shift-7 = "move-node-to-workspace 7";
            alt-shift-8 = "move-node-to-workspace 8";
            alt-shift-9 = "move-node-to-workspace 9";
            # Extra
            alt-tab = "workspace-back-and-forth";

            # Switch layout
            alt-slash = "layout tiles horizontal vertical";
            alt-comma = "layout accordion horizontal vertical";

            # Other
            alt-shift-f = [ "layout floating tiling" "mode main" ];

            # Launching
#            alt-shift-t = ''
#  exec-and-forget osascript -e '
#  tell application "iTerm"
#      create window with default profile
#      activate
#  end tell'
#'';
            alt-enter = "exec-and-forget iterm2";
            alt-cmd-shift-b = "exec-and-forget /run/current-system/sw/bin/borders active_color=0xffaa22ff inactive_color=0x449911ee width=5.0";
        };
    };
};
}
