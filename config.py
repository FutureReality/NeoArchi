import os, subprocess
from libqtile import bar, layout, qtile, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal, send_notification

mod = "mod4"
terminal = guess_terminal()

keys = [
    Key([mod], "z", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "x", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "c", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "v", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),

    Key([mod, "shift"], "z", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "x", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "c", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "v", lazy.layout.shuffle_up(), desc="Move window up"),

    Key([mod, "control"], "z", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "x", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "c", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "v", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),

    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn("kitty"), desc="Launch terminal"),
    Key([mod], "a", lazy.spawn("firefox"), desc="Launch firefox"),
    Key([mod], "s", lazy.spawn("rofi -show drun -disable-history -show-icons"), desc="Launch rofi"),  

    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating on the focused window"),

    #Referente a la linea inferior: Por algun motivo que desconozco, al ejercutar un os.system() de cualquier comando,
    #todo explota, por lo que se ha optado por crear un archivo con el comando pertinente (Ulala que lexico) y hacer
    #un alias que lo referencie; De esta forma es posible realizar un lazy.spawn sin que el mundo se imbole :)

    Key([mod, "control"], "r", lazy.reload_config(), lazy.spawn("/etc/scripts/poly_reboot.sh"), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
]

for vt in range(1, 8):
    keys.append(
        Key(
            ["control", "mod1"],
            f"f{vt}",
            lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
            desc=f"Switch to VT{vt}",
        )
    )

groups = [Group(i) for i in ["󰊯", "", "", "", "", "", ""]]

for i, group in enumerate(groups):
    NE = str(i+1)
    keys.extend(
        [
            Key(
                [mod],
                NE,
                lazy.group[group.name].toscreen(),
                desc="Switch to group {}".format(group.name),
            ),
            Key(
                [mod, "shift"],
                NE,
                lazy.window.togroup(group.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(group.name),
            ),
        ]
    )

layouts = [
    layout.Columns(border_focus_stack=["#C237BD", "#C237BD"], border_width=2, margin=4, border_focus="C237BD", 
border_normal="000055", margin_on_single=40, border_on_single=4),
    layout.Max(),
    layout.MonadWide(border_focus_stack=["#C237BD", "#C237BD"], border_width=2, margin=4, border_focus="C237BD", 
border_normal="000055", margin_on_single=40, border_on_single=4, ratio=0.8),
]

widget_defaults = dict(
    font="courier",
    fontsize=12,
    padding=3,
)

extension_defaults = widget_defaults.copy()

screens = [Screen()]
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False

floating_layout = layout.Floating(
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
        Match(wm_class="Zenity"),
        Match(title="Autentificacion requerida"),
        Match(title="Error")
    ]
)

auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True
wl_input_rules = None
wl_xcursor_theme = None
wl_xcursor_size = 24

wmname = "LG3D"

@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser('~/.config/qtile/autostart.sh')
    subprocess.call(home)

@hook.subscribe.setgroup
def notify_group_change():
	group_name = qtile.current_group.name
	subprocess.run(["notify-send", "Grupo", f"Has cambiado de grupo a {group_name}"])
