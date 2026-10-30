#!/usr/bin/env bash
# Builds dist/GravityRushRemastered-x86_64.AppImage: standalone AppImage bundling the frozen
# Qt Quick launcher, runtime libraries, scripts, and port binaries.
# Double-clicking or running without arguments opens the Qt Quick Launcher.
# Passing `--play` launches the game directly using saved launcher settings.
# Passing `--classic` opens the classic Tk launcher.
# Data directory: ~/.local/share/grr (GRR_DATA_DIR).
set -euo pipefail
cd -- "$(dirname -- "$0")/.."
source packaging/port.env
name=${TLG_PACKAGE_NAME:-$PORT_SLUG-linux-x86_64}
mkdir -p dist out

# Ensure the frozen Linux package is built
if [[ ! -d "out/stage/$name" || ! -x "out/stage/$name/$PORT_NAME" ]]; then
    [[ -f out/tlg-probe && -f out/gpu/libtlggpu.so ]] || { echo 'Build first: bash build.sh' >&2; exit 1; }
    echo "Staging frozen launcher and libraries..."
    bash packaging/linux/package.sh
fi

echo "Building standalone AppImage..."
appdir="out/AppDir"
rm -rf "$appdir"
mkdir -p "$appdir"

# Copy staged frozen launcher, scripts, out/ binaries, and bundled libraries
cp -r "out/stage/$name/." "$appdir/"

# Desktop metadata and icons
cp "launcher/$PORT_ICON.png" "$appdir/$PORT_ICON.png"
ln -sf "$PORT_ICON.png" "$appdir/.DirIcon"

cat > "$appdir/$PORT_SLUG.desktop" <<DESKTOP
[Desktop Entry]
Type=Application
Name=$PORT_NAME
GenericName=$PORT_NAME
Comment=Play $PORT_NAME on PC
Exec=AppRun %F
Icon=$PORT_ICON
Categories=Game;
Terminal=false
StartupWMClass=$PORT_SLUG
DESKTOP

# AppRun launcher entrypoint
cat > "$appdir/AppRun" <<'RUN'
#!/usr/bin/env bash
set -e
APPDIR="$(dirname "$(readlink -f "$0")")"
export APPDIR

# Clean problematic host library injections (e.g. Steam overlay)
if [[ -n ${LD_PRELOAD:-} ]]; then
    export TLG_HOST_LD_PRELOAD="$LD_PRELOAD"
    unset LD_PRELOAD
fi

export TLG_PREBUILT=1
export GRR_PREBUILT=1
export TLG_DATA_DIR="${GRR_DATA_DIR:-${TLG_DATA_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/grr}}"
export GRR_DATA_DIR="$TLG_DATA_DIR"
mkdir -p "$TLG_DATA_DIR/out"

# Copy prebuilt ISA rewrite table if CPU lacks SSE4A (Intel CPUs) and local out directory lacks it
if [[ -f "$APPDIR/out/isa-rewrite.bin" && ! -f "$TLG_DATA_DIR/out/isa-rewrite.bin" ]]; then
    cp "$APPDIR/out/isa-rewrite.bin" "$TLG_DATA_DIR/out/isa-rewrite.bin"
fi

export LD_LIBRARY_PATH="$APPDIR/out/lib:$APPDIR/out/gpu:${LD_LIBRARY_PATH:-}"
export PATH="$APPDIR/out:$APPDIR:$PATH"

export GRR_GAME_DIR="${GRR_GAME_DIR:-${GRHD_GAME_DIR:-${TLG_GAME_DIR:-$HOME/grhd/CUSA01130}}}"
export TLG_GAME_DIR="$GRR_GAME_DIR"

export GRR_GS_PASSTHROUGH="${GRR_GS_PASSTHROUGH:-1}"
export TLG_GS_PASSTHROUGH="$GRR_GS_PASSTHROUGH"
export GRR_SKIP_GEOMETRY="${GRR_SKIP_GEOMETRY:-0}"
export GRR_SKIP_ADJACENCY="${GRR_SKIP_ADJACENCY:-1}"
export TLG_SKIP_GEOMETRY="$GRR_SKIP_GEOMETRY"
export TLG_SKIP_ADJACENCY="$GRR_SKIP_ADJACENCY"
export GRR_READBACKS="${GRR_READBACKS:-2}"
export TLG_READBACKS="$GRR_READBACKS"
export GRR_PIPELINE_BINARIES="${GRR_PIPELINE_BINARIES:-0}"
export TLG_PIPELINE_BINARIES="$GRR_PIPELINE_BINARIES"
export GRR_BP08="${GRR_BP08:-0}"
export TLG_BP08="$GRR_BP08"
export GRR_WARMUP_STAGES_ONLY="${GRR_WARMUP_STAGES_ONLY:-1}"
export TLG_WARMUP_STAGES_ONLY="$GRR_WARMUP_STAGES_ONLY"

if [[ "${1:-}" == "--play" ]]; then
    shift
    exec "$APPDIR/Gravity Rush Remastered" --play "$@"
elif [[ "${1:-}" == "--classic" ]]; then
    shift
    exec "$APPDIR/Gravity Rush Remastered (classic)" "$@"
fi

exec "$APPDIR/Gravity Rush Remastered" "$@"
RUN
chmod +x "$appdir/AppRun"

# Safety audit: ensure no copyrighted game or player files are bundled
bash packaging/check_package.sh "$appdir"

# Find or acquire appimagetool
APPIMAGETOOL=""
if command -v appimagetool >/dev/null 2>&1; then
    APPIMAGETOOL="appimagetool"
elif [[ -x "/tmp/appimagetool" ]]; then
    APPIMAGETOOL="/tmp/appimagetool"
elif [[ -x "out/appimagetool" ]]; then
    APPIMAGETOOL="$PWD/out/appimagetool"
else
    echo "Fetching appimagetool..."
    curl -fsSL https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage -o out/appimagetool || \
    wget -qO out/appimagetool https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage
    chmod +x out/appimagetool
    APPIMAGETOOL="$PWD/out/appimagetool"
fi

if [[ "$APPIMAGETOOL" != "appimagetool" ]]; then
    if [[ ! -x "out/squashfs-root/AppRun" ]]; then
        (cd out && ./appimagetool --appimage-extract >/dev/null 2>&1)
    fi
    APPIMAGETOOL="$PWD/out/squashfs-root/AppRun"
fi

rm -f dist/GravityRushRemastered-x86_64.AppImage
ARCH=x86_64 "$APPIMAGETOOL" "$appdir" dist/GravityRushRemastered-x86_64.AppImage
ls -lh dist/GravityRushRemastered-x86_64.AppImage

