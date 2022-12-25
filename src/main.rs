#![deny(unused_crate_dependencies)]

use penrose::{
    builtin::{
        actions::{exit, modify_with, send_layout_message, spawn},
        layout::{
            messages::{ExpandMain, IncMain, ShrinkMain},
            MainAndStack,
        },
    },
    core::{
        bindings::{parse_keybindings_with_xmodmap, KeyEventHandler},
        Config, WindowManager,
    },
    map, stack,
    x11rb::RustConn,
    Result,
};
use std::collections::HashMap;
use tracing_subscriber::util::SubscriberInitExt;

fn raw_key_bindings() -> HashMap<String, Box<dyn KeyEventHandler<RustConn>>> {
    let mut raw_bindings = map! {
        map_keys: |k: &str| k.to_string();

        "M-n" => modify_with(|cs| cs.focus_down()),
        "M-a" => modify_with(|cs| cs.focus_up()),
        "M-S-n" => modify_with(|cs| cs.swap_down()),
        "M-S-a" => modify_with(|cs| cs.swap_up()),
        "M-q" => modify_with(|cs| cs.kill_focused()),
        "M-Tab" => modify_with(|cs| cs.toggle_tag()),
        "M-m" => modify_with(|cs| cs.next_screen()),
        "M-i" => modify_with(|cs| cs.previous_screen()),
        "M-grave" => modify_with(|cs| cs.next_layout()),
        "M-S-grave" => modify_with(|cs| cs.previous_layout()),
        "M-S-Up" => send_layout_message(|| IncMain(1)),
        "M-S-Down" => send_layout_message(|| IncMain(-1)),
        "M-S-Right" => send_layout_message(|| ExpandMain),
        "M-S-Left" => send_layout_message(|| ShrinkMain),
        "M-comma" => spawn("dmenu_run"),
        "M-Return" => spawn("alacritty"),
        "M-A-Escape" => exit(),
    };

    for tag in &["1", "2", "3", "4", "5", "6", "7", "8", "9"] {
        raw_bindings.extend([
            (
                format!("M-{tag}"),
                modify_with(move |client_set| client_set.focus_tag(tag)),
            ),
            (
                format!("M-S-{tag}"),
                modify_with(move |client_set| client_set.move_focused_to_tag(tag)),
            ),
        ]);
    }

    raw_bindings
}

fn main() -> Result<()> {
    tracing_subscriber::fmt()
        .with_env_filter("info")
        .finish()
        .init();

    let conn = RustConn::new()?;
    let key_bindings = parse_keybindings_with_xmodmap(raw_key_bindings())?;
    let stack = MainAndStack::bottom(1, 0.5, 0.1);
    let config = Config {
        default_layouts: stack!(stack),
        ..Default::default()
    };
    let wm = WindowManager::new(config, key_bindings, HashMap::new(), conn)?;

    wm.run()
}
