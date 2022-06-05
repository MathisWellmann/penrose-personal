# My Penrose Window Manager Setup
A customized tiling window manger configuration for X11 linux.

## Installation:
Install dependencies (Ubuntu 22.04):
```shell
sudo apt install -y librust-glib-dev librust-pango-dev libxrandr-dev libxcb-randr0-dev  dmenu
```

Now install default software, (assuming those software specific dependencies are satisfied)
```shell
cargo install alacritty joshuto
```

Build and compile
```shell
cargo build --release
```

Now copy the compiled file to where it can be executed globally
```shell
sudo cp ./target/release/penrose-personal /usr/bin/penrose-personal
```

Now copy the (possibly modified) '.xinitrc' to '~/.xinitrc'
```shell
cp .xinitrc ~/.xinitrc
```

