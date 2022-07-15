import subprocess
from pathlib import Path

def ensure_bin():
    bin_path = Path.home() / 'bin'
    bin_path.mkdir(exist_ok=True)
    return bin_path

class NVIM:

    def __init__(self):
        bin_path = ensure_bin()
        self.path_out = bin_path / 'nvim'

    def download(self):
        url = ('https://github.com/neovim/neovim/releases/'
        'download/stable/nvim.appimage')
        if not self.path_out.is_file():
            print('downloading latest appimage of nvim from master')
            print(url)
            cmd = ['wget', str(url), '-O', str(path_out)]
            result = subprocess.call(cmd)
            cmd = ['chmod', '+x', str(path_out)]
            result = subprocess.call(cmd)

    def bootstrap_plugin_manager(self):
        packer_file = Path("~/.local/share/nvim/site/pack/packer/start/packer.nvim")
        packer_repo = 'https://github.com/wbthomason/packer.nvim'
        if not packer_file.is_file():
            print('downloading latest version of packer from ')
            print(packer_repo)
            cmd = [ 'git', 'clone', '--depth', '1', packer_repo, packer_file]
            result = subprocess.call(cmd)
        else:
            print('packer already there')
            

    def install(self):
        self.download()
        self.bootstrap_plugin_manager()

if __name__ == '__main__':
    nvim = NVIM()
    nvim.install()
    


