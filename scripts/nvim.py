import shutil
import subprocess
from pathlib import Path

URL_BIN = "https://github.com/neovim/neovim/releases/download/stable/nvim.appimage"


def config_path() -> Path:
    return Path.home().resolve() / ".config" / "nvim" / "init.lua"


def bin_path() -> Path:
    return Path.home().resolve() / "bin" / "nvim"


def local_share() -> Path:
    return Path.home().resolve() / ".local" / "share" / "nvim"


def ensure_clean_base_dirs():
    for p in [config_path(), bin_path()]:
        p.parent.mkdir(exist_ok=True)
        p.unlink()
    shutil.rmtree(local_share())


def download() -> None:
    print("downloading latest appimage of nvim from master")
    print(URL_BIN)
    cmd = ["wget", str(URL_BIN), "-O", str(bin_path()), "-q"]
    _ = subprocess.call(cmd)
    cmd = ["chmod", "+x", str(bin_path())]
    _ = subprocess.call(cmd)


def setup_config():
    URL_CONFIG = (
        "https://raw.githubusercontent.com/nelai1/"
        "install/main/nvim/.config/nvim/init.lua"
    )
    print("downloading latest config from master")
    print(URL_CONFIG)
    cmd = ["wget", str(URL_CONFIG), "-O", str(config_path()), "-q"]
    _ = subprocess.call(cmd)


if __name__ == "__main__":
    ensure_clean_base_dirs()
    download()
    setup_config()
