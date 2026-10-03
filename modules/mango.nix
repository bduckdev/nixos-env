{
  config,
  inputs,
  lib,
  ...
}:

let
  isLaptop = config.networking.hostName == "nixos-laptop";
in
{
  imports = [
    inputs.mango.nixosModules.mango
  ];

  programs.mango.enable = true;

  # Make Mango's Home Manager options available to bduck.
  home-manager.sharedModules = [
    inputs.mango.hmModules.mango
  ];

  home-manager.users.bduck.wayland.windowManager.mango = {
    enable = true;

    # Replaces the hand-written autostart.sh + mango-session target.
    # Mango's HM module supplies the reset-failed/start-target commands itself.
    systemd = {
      enable = true;
      variables = [
        "DISPLAY"
        "WAYLAND_DISPLAY"
        "XDG_CURRENT_DESKTOP"
        "XDG_SESSION_TYPE"
        "XCURSOR_THEME"
        "XCURSOR_SIZE"
        "MANGO_INSTANCE_SIGNATURE"
      ];
    };

    autostart_sh = ''
      noctalia &
    '';

    # Keep Noctalia's generated colors after the static Mango settings.
    bottomPrefixes = [ "source" ];

    settings = {
      # ========================================================================
      # STARTUP
      # ========================================================================

      "exec-once" = [
        "sh -c 'sleep 0.2;mmsg dispatch view,3,0;kitty -e zsh'"
      ];

      # ========================================================================
      # ENVIRONMENT & CURSOR
      # ========================================================================

      env = [
        "xcursor_size,24"
        "xcursor_theme,adwaita"
      ];

      cursor_size = 24;
      cursor_theme = "adwaita";

      # ========================================================================
      # MONITORS
      # ========================================================================

      monitorrule = [
        "model:XG27JCG,width:5120,height:2880,refresh:120,x:0,y:0,scale:2.0"
        "model:MQ16FC,width:1920,height:1200,refresh:60,x:2560,y:0,scale:1.0,rr:1"
      ]
      ++ lib.optionals isLaptop [
        "model:0x0067,width:1920,height:1080,refresh:60,x:3760,y:0,scale:1.0"
      ];

      # ========================================================================
      # WINDOW RULES
      # ========================================================================

      windowrule = [
        "tags:4,appid:helium"
        "tags:5,appid:md.obsidian"
        "tags:7,appid:org.telegram.desktop"
        "tags:8,appid:discord"
        "tags:9,appid:steam"
        "tags:9,appid:stremio"
        "tags:10,appid:spotify"
      ];

      # ========================================================================
      # TAG / MONITOR LAYOUT RULES
      # ========================================================================

      tagrule = [
        ''id:*,monitor_model:"XG27JCG",no_hide:1,layout_name:tile''
        ''id:*,monitor_model:"MQ16FC",no_hide:1,layout_name:v_tile''
        ''id:6,monitor_model:"XG27JCG",no_hide:1,open_as_floating:1''
      ]
      ++ lib.optionals isLaptop [
        ''id:*,monitor_model:"0x0067",no_hide:1,layout_name:tile''
      ];

      # ========================================================================
      # APPEARANCE
      # ========================================================================

      gappih = 10;
      gappiv = 10;
      gappoh = 10;
      gappov = 10;

      scratchpad_width_ratio = 0.8;
      scratchpad_height_ratio = 0.9;

      borderpx = 3;

      rootcolor = "0x201b14ff";
      bordercolor = "0x444444ff";
      dropcolor = "0x8fba7c55";
      splitcolor = "0xeb441eff";
      focuscolor = "0xc9b890ff";
      maximizescreencolor = "0x89aa61ff";
      urgentcolor = "0xad401fff";
      scratchpadcolor = "0x516c93ff";
      globalcolor = "0xb153a7ff";
      overlaycolor = "0x14a57cff";

      # ========================================================================
      # WINDOW EFFECTS
      # ========================================================================

      blur = 1;
      blur_optimized = 1;
      blur_layer = 0;

      blur_params_num_passes = 2;
      blur_params_radius = 6;
      blur_params_noise = 0.02;
      blur_params_brightness = 0.9;
      blur_params_contrast = 0.9;
      blur_params_saturation = 1.2;

      shadows = 1;
      layer_shadows = 0;
      shadow_only_floating = 0;
      shadows_size = 4;
      shadows_blur = 12;
      shadows_position_x = 2;
      shadows_position_y = 2;
      shadowscolor = "0x000000ff";

      border_radius = 6;
      no_radius_when_single = 0;
      focused_opacity = 1.0;
      unfocused_opacity = 1.0;

      # ========================================================================
      # ANIMATIONS
      # ========================================================================

      animations = 0;
      layer_animations = 1;
      animation_type_open = "slide";
      animation_type_close = "slide";
      animation_fade_in = 1;
      animation_fade_out = 1;
      tag_animation_direction = 1;
      zoom_initial_ratio = 0.4;
      zoom_end_ratio = 0.8;
      fadein_begin_opacity = 0.5;
      fadeout_begin_opacity = 0.8;

      animation_duration_move = 200;
      animation_duration_open = 180;
      animation_duration_tag = 150;
      animation_duration_close = 425;
      animation_duration_focus = 0;

      animation_curve_open = "0.46,1.0,0.29,1";
      animation_curve_move = "0.46,1.0,0.29,1";
      animation_curve_tag = "0.46,1.0,0.29,1";
      animation_curve_close = "0.08,0.92,0,1";
      animation_curve_focus = "0.46,1.0,0.29,1";
      animation_curve_opafadeout = "0.5,0.5,0.5,0.5";
      animation_curve_opafadein = "0.46,1.0,0.29,1";

      # ========================================================================
      # LAYOUTS
      # ========================================================================

      scroller_structs = 20;
      scroller_default_proportion = 0.8;
      scroller_focus_center = 0;
      scroller_prefer_center = 0;
      edge_scroller_pointer_focus = 1;
      edge_scroller_focus_allow_speed = 0.0;
      scroller_default_proportion_single = 1.0;
      scroller_proportion_preset = "0.5,0.8,1.0";

      new_is_master = 1;
      default_mfact = 0.55;
      default_nmaster = 1;
      tag_num = 10;
      smartgaps = 0;

      dwindle_smart_split = 0;
      dwindle_drop_simple_split = 1;
      dwindle_manual_split = 0;
      dwindle_hsplit = 1;
      dwindle_vsplit = 1;
      dwindle_preserve_split = 0;

      # ========================================================================
      # OVERVIEW
      # ========================================================================

      hotarea_size = 10;
      enable_hotarea = 0;
      overviewgappi = 5;
      overviewgappo = 30;

      # ========================================================================
      # WINDOW MANAGEMENT BEHAVIOR
      # ========================================================================

      no_border_when_single = 1;
      axis_bind_apply_timeout = 100;
      focus_on_activate = 0;
      idleinhibit_ignore_visible = 0;
      sloppyfocus = 1;
      warpcursor = 1;
      focus_cross_monitor = 1;
      exchange_cross_monitor = 1;
      focus_cross_tag = 0;
      enable_floating_snap = 0;
      snap_distance = 30;
      drag_tile_to_tile = 1;
      drag_tile_small = 1;

      # ========================================================================
      # INPUT
      # ========================================================================

      repeat_rate = 25;
      repeat_delay = 600;
      numlockon = 0;
      xkb_rules_layout = "us";

      devicerule = "name:sonix usb device,kb_layout:us,kb_options:caps:escape";

      disable_trackpad = 0;
      tap_to_click = 1;
      tap_and_drag = 1;
      drag_lock = 1;
      trackpad_natural_scrolling = 0;
      swipe_min_threshold = 1;

      mouse_natural_scrolling = 0;

      # ========================================================================
      # DEFAULT KEY MODE
      # ========================================================================
      # Top-level bindings belong to Mango's default keymode.

      bind = [
        # Screenshots
        "ctrl+shift,3,spawn,noctalia msg screenshot-fullscreen all"
        "ctrl+shift,4,spawn,noctalia msg screenshot-region"

        # Launcher & terminal
        "super,return,spawn,kitty"
        "super,t,spawn,kitty"
        "super,d,spawn,noctalia msg panel-toggle launcher"

        # Window close
        "super+shift,q,killclient"

        # Window focus
        "super,h,focusdir,left"
        "super,j,focusdir,down"
        "super,k,focusdir,up"
        "super,l,focusdir,right"
        "super,tab,focusstack,next"
        "alt,tab,switcher,all_tag_next"

        # Window exchange
        "super+shift,h,exchange_client,left"
        "super+shift,j,exchange_client,down"
        "super+shift,k,exchange_client,up"
        "super+shift,l,exchange_client,right"

        # Window state
        "super,g,toggleglobal,"
        "super,backslash,togglefloating,"
        "super+shift,space,togglefloating,"
        "super,a,togglemaximizescreen,"
        "super,f,togglefullscreen,"
        "super+shift,f,togglefakefullscreen,"
        "super,i,minimized,"
        "super,o,toggleoverlay,"
        "super+shift,i,restore_minimized"
        "super,z,toggle_scratchpad"

        # Layout controls
        "alt,e,set_proportion,1.0"
        "alt,x,switch_proportion_preset,"
        "alt+super+ctrl,left,scroller_stack,left"
        "alt+super+ctrl,right,scroller_stack,right"
        "alt+super+ctrl,up,scroller_stack,up"
        "alt+super+ctrl,down,scroller_stack,down"
        "super+shift,n,switch_layout"

        # Adjacent tag navigation
        "super,p,viewtoleft,0"
        "super,n,viewtoright,0"
        "super,grave,view,-1,0"

        # Monitor navigation
        "super,m,focusmon,next"
        "super+shift,m,tagmon,next"

        # Switch to tag
        "super,1,view,1,0"
        "super,2,view,2,0"
        "super,3,view,3,0"
        "super,4,view,4,0"
        "super,5,view,5,0"
        "super,6,view,6,0"
        "super,7,view,7,0"
        "super,8,view,8,0"
        "super,9,view,9,0"
        "super,0,view,10,0"

        # Move focused window to tag
        "super+shift,1,tag,1,0"
        "super+shift,2,tag,2,0"
        "super+shift,3,tag,3,0"
        "super+shift,4,tag,4,0"
        "super+shift,5,tag,5,0"
        "super+shift,6,tag,6,0"
        "super+shift,7,tag,7,0"
        "super+shift,8,tag,8,0"
        "super+shift,9,tag,9,0"
        "super+shift,0,tag,10,0"

        # Floating window movement
        "ctrl+shift,up,movewin,+0,-50"
        "ctrl+shift,down,movewin,+0,+50"
        "ctrl+shift,left,movewin,-50,+0"
        "ctrl+shift,right,movewin,+50,+0"

        # Floating window resize
        "ctrl+alt,up,resizewin,+0,-50"
        "ctrl+alt,down,resizewin,+0,+50"
        "ctrl+alt,left,resizewin,-50,+0"
        "ctrl+alt,right,resizewin,+50,+0"

        # Enter resize mode
        "super,r,setkeymode,resize"
      ];

      mousebind = [
        "alt,btn_left,moveresize,curmove"
        "none,btn_middle,togglemaximizescreen,0"
        "alt,btn_right,moveresize,curresize"
      ];

      axisbind = [
        "super,up,viewtoleft_have_client"
        "super,down,viewtoright_have_client"
      ];

      # ========================================================================
      # OTHER KEY MODES
      # ========================================================================

      keymode = {
        common = {
          bind = [
            "alt+shift,c,reload_config"
            "alt,r,reload_config"
            "super+shift,e,quit"
          ]
          ++ lib.optionals isLaptop [
            "none,xf86display,spawn,noctalia msg panel-toggle control-center monitor"
            "none,xf86wlan,spawn,noctalia msg wifi-toggle"
            "none,xf86notificationcenter,spawn,noctalia msg panel-toggle control-center notifications"
            "none,xf86favorites,spawn,noctalia msg panel-toggle launcher"
          ];

          bindl = lib.optionals isLaptop [
            "none,xf86audiomute,spawn,noctalia msg volume-mute"
            "none,xf86audiolowervolume,spawn,noctalia msg volume-down"
            "none,xf86audioraisevolume,spawn,noctalia msg volume-up"
            "none,xf86audiomicmute,spawn,noctalia msg mic-mute"
            "none,xf86monbrightnessdown,spawn,noctalia msg brightness-down edp-1"
            "none,xf86monbrightnessup,spawn,noctalia msg brightness-up edp-1"
          ];
        };

        resize = {
          bind = [
            "none,h,resizewin,-10,0"
            "none,j,resizewin,0,+10"
            "none,k,resizewin,0,-10"
            "none,l,resizewin,+10,0"
            "none,return,setkeymode,default"
            "none,escape,setkeymode,default"
            "alt,r,setkeymode,default"
          ];
        };
      };

      # ========================================================================
      # LAYER RULES
      # ========================================================================

      layerrule = [
        "animation_type_open:zoom,layer_name:noctalia"
        "animation_type_close:zoom,layer_name:noctalia"
      ];

      # ========================================================================
      # EXTERNAL CONFIG
      # ========================================================================
      # Noctalia owns this mutable file. Optional sourcing lets Nix validate the
      # generated Mango config even when the file is absent in the build sandbox.

      "source-optional" = "~/.config/mango/noctalia.conf";
    };
  };
}
