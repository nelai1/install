import subprocess
from pathlib import Path

url = 'https://github.com/obsidianmd/obsidian-releases/releases/download/v0.14.15/Obsidian-0.14.15.AppImage'

bin_path = Path.home() / 'bin'
bin_path.mkdir(exist_ok=True)

path_out = bin_path / 'obsidian'
if not path_out.is_file():
    cmd = ['wget', str(url), '-O', str(path_out)]
    result = subprocess.call(cmd)
else:
    print(f'File {path_out} already there')

cmd = ['chmod', '+x', str(path_out)]
result = subprocess.call(cmd)
