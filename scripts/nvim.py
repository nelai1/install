import shutil
import subprocess
from pathlib import Path
from socket import gethostname

URL_BIN = "https://github.com/neovim/neovim/releases/download/stable/nvim.appimage"
URL_BIN = (
    "https://github.com/antoineco/neovim-neovim/releases/download/v0.8.0/nvim.appimage"
)


def config_path() -> Path:
    return Path.home().resolve() / ".config" / "nvim" / "init.lua"


def bin_path() -> Path:
    return Path.home().resolve() / "bin" / "nvim"


def local_share() -> Path:
    return Path.home().resolve() / ".local" / "share" / "nvim"


def dotfiles_config_path() -> Path:
    return Path.home().resolve() / "install/nvim/.config/nvim/init.lua"


def ensure_clean_base_dirs():
    for p in [bin_path()]:
        p.parent.mkdir(exist_ok=True)
        if p.is_file() or p.is_symlink():
            print(f"Removing: {p}")
            p.unlink()
    for p in [config_path().parent, local_share()]:
        shutil.rmtree(p)
        p.mkdir()


def download() -> None:
    print("downloading latest appimage of nvim from master")
    print(URL_BIN)
    cmd = ["wget", str(URL_BIN), "-O", str(bin_path()), "-q"]
    _ = subprocess.call(cmd)
    cmd = ["chmod", "+x", str(bin_path())]
    _ = subprocess.call(cmd)


def setup_config():
    if gethostname() != "quickie":
        URL_CONFIG = (
            "https://raw.githubusercontent.com/nelai1/"
            "install/main/nvim/.config/nvim/init.lua"
        )
        print("downloading latest config from master")
        print(URL_CONFIG)
        cmd = ["wget", str(URL_CONFIG), "-O", str(config_path()), "-q"]
        _ = subprocess.call(cmd)
    else:
        print(f"linking to dotiles {dotfiles_config_path()}")
        config_path().symlink_to(dotfiles_config_path())


if __name__ == "__main__":
    ensure_clean_base_dirs()
    download()
    setup_config()

    print("Start 1 setting up packer")
    cmd = ["nvim", "--headless", "-c", "quitall"]
    _ = subprocess.call(cmd)

    print("start 2 making sure all plugins are installed")
    # add event: quitall.    It will be executed when Packer is done.
    cmd = "nvim --headless -c 'autocmd User PackerComplete quitall'  -c 'PackerSync'"
    _ = subprocess.call(cmd, shell=True)

    print("start 3 installing all Treesitter")
    # sleep is arbitary to allow mason to finsih installing language servers
    cmd = "nvim --headless -c 'TSUpdateSync all' -c 'sleep 20' -c 'qa'"
    _ = subprocess.call(cmd, shell=True)
