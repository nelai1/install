from pathlib import Path
from subprocess import run

# go to nodejs.org to get updated link
DOWNLOAD_URL = "https://nodejs.org/dist/v18.14.0/node-v18.14.0-linux-x64.tar.xz"
VERSION = DOWNLOAD_URL.split("/")[-1].replace(".tar.xz", "")
BIN_DIR = Path.home() / "bin"
BIN_DIR.mkdir(exist_ok=True)

node_dir = Path.home() / ".local" / "lib" / "node"
node_dir.mkdir(parents=True, exist_ok=True)
node_version_dir = node_dir / VERSION

cmd = f"curl -s -L {DOWNLOAD_URL} | tar xJ -C {node_dir}"
run(cmd, shell=True)
print(f"Is extracted archive {node_version_dir} present: {node_version_dir.is_dir()}")


try:
    for bin in ["npm", "npx", "node"]:
        (BIN_DIR / bin).symlink_to(node_version_dir / "bin" / bin)
except FileExistsError:
    print("files npm/node/npx already exist in bin")
    print("Consider deleting and rerunning")
else:
    print("Install successful")


print("To uninstall run: ")
print("rm $HOME/bin/{npm,node,npx}; rm -r $HOME/.local/lib/node")
