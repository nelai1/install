import subprocess
from pathlib import Path

def ensure_bin():
    bin_path = Path.home().resolve() / 'bin'
    bin_path.mkdir(exist_ok=True)
    return bin_path

def ensure_config():
    config = Path.home().resolve() / '.config'/ 'nvim'
    config.mkdir(exist_ok=True)
    return config / 'init.lua'

class NVIM:
    def __init__(self):
        bin_path = ensure_bin()
        self.path_out = bin_path / 'nvim'
        self.config_path = ensure_config()


    def download(self):
        url = ('https://github.com/neovim/neovim/releases/'
        'download/stable/nvim.appimage')
        print('downloading latest appimage of nvim from master')
        print(url)
        cmd = ['wget', str(url), '-O', str(self.path_out), '-q']
        _ = subprocess.call(cmd)
        cmd = ['chmod', '+x', str(self.path_out)]
        _ = subprocess.call(cmd)
    
    def setup_config(self):
        url = ('https://raw.githubusercontent.com/nelai1/'
                'install/main/nvim/.config/nvim/init.lua')
        print('downloading latest config from master')
        print(url)
        cmd = ['wget', str(url), '-O', str(self.config_path), '-q']
        _ = subprocess.call(cmd)

            

    def install(self):
        self.download()
        if self.config_path.exists():
            print(f'\nConfig {self.config_path} already exist. '
                      '\nRemove to get a fresh version\n')
        else:
            self.setup_config()

if __name__ == '__main__':
    nvim = NVIM()
    nvim.install()
