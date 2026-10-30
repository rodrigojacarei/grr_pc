# Gravity Rush Remastered — port para PC / PC port

**Nenhum arquivo do jogo vem neste pacote.** Você precisa da sua própria cópia de Gravity Rush Remastered para PS4. / **No game files are included.** You need your own copy of Gravity Rush Remastered for PS4.

---

## Português

### Arquivos do jogo necessários

Tudo vem do **seu** PS4 (GoldHEN + Itemzflow / dump). Nada disso vai no download. Use **Gravity Rush Remastered CUSA01130 (EUA)**. São ~10 GB.

| Arquivo | Vem de | Para quê |
|---|---|---|
| `eboot.bin` | dump do jogo | o código do jogo |
| `sce_module/libc.prx`, `libSceFios2.prx` | dump do jogo | bibliotecas do próprio jogo |
| `arc/` | dump do jogo | arquivos de dados e fases |
| `sce_sys/` (`param.sfo`, `icon0.png`, `pic1.png`) | dump do jogo | metadados e arte do jogo |
| `sce_discmap.plt` | dump do jogo | mapa de arquivos |

**Do firmware do console (opcional: sem ele, o port usa o seu próprio mixer de áudio, ainda experimental):** `libSceNgs2.sprx`, de `/system/common/lib/` do seu PS4. Ele vai na pasta `system_lib/` ao lado do executável.

**Como montar a pasta:**
1. No Itemzflow, faça o dump do jogo (`CUSA01130`) para um pendrive exFAT (o jogo já vem completo na versão 1.00 com todos os DLCs, não tem patch de update).
2. No PC, copie a pasta do jogo.
3. Confira os tamanhos (~10 GB). Arquivos acima de 4 GB vindos pelo FTP do GoldHEN 2.2 chegam cortados, então use o pendrive.

**PC:** Windows 10 (1903+)/11 64 bits ou Linux x86-64 (glibc 2.39+), placa de vídeo com Vulkan 1.3 (6 GB de VRAM recomendados).

### Como jogar

1. Extraia o pacote numa pasta qualquer (no Windows, fora do .zip).
2. Coloque o `libSceNgs2.sprx` na pasta `system_lib/`, ao lado do executável (opcional: sem ele, o port usa o seu próprio mixer de áudio, ainda experimental).
3. Abra o inicializador de **Gravity Rush Remastered** (ou execute o AppImage / `./Gravity\ Rush\ Remastered`).
4. Em **Pasta do jogo**, escolha a pasta que tem o `eboot.bin`. Escolha o idioma e clique em **Jogar**.

No Linux, `./install_desktop.sh` adiciona o jogo ao menu de aplicativos.

### Durante o jogo
- **F10**: contador de FPS · **Insert** (ou R3 + L2): menu do port
- Controles de PS4/PS5, Xbox e 8BitDo via SDL3, por USB ou Bluetooth.

### Problemas
- **Linhas pretas perto dos personagens**: deixe ligada a opção "Desligar o contorno do geometry shader" no launcher (padrão).
- **Som incompleto ou estranho**: sem o `libSceNgs2.sprx` em `system_lib/`, o port usa o seu próprio mixer, ainda experimental. Com o arquivo, o áudio é o nativo.
- **Não abre ou fecha sozinho**: envie o `out/last_run.log` em uma [issue no GitHub](https://github.com/rodrigojacarei/grr_pc/issues).

---

## English

### Required game files

Everything comes from **your own** PS4 (GoldHEN + Itemzflow). None of it is in the download. Use **Gravity Rush Remastered CUSA01130** (about 10 GB).

| File | From | Size | Purpose |
|---|---|---|---|
| `eboot.bin` | game dump | ~38 MB | the game code |
| `sce_module/libc.prx`, `libSceFios2.prx` | game dump | small | the game's own libraries |
| `arc/` | game dump | ~9.5 GB | data and level archives |
| `sce_sys/` (`param.sfo`, `icon0.png`, `pic1.png`) | game dump | ~5 MB | metadata and art |
| `sce_discmap.plt` | game dump | ~3.3 MB | file map |

**From the console firmware (optional: without it, the port uses its own audio mixer, still experimental):** `libSceNgs2.sprx`, from `/system/common/lib/` on your PS4. It goes in the `system_lib/` folder next to the executable.

**How to build the folder:**
1. In Itemzflow, dump the game (`CUSA01130`) to an exFAT USB drive.
2. On the PC, copy the game folder.
3. Check the sizes. Files over 4 GB sent through GoldHEN 2.2's FTP arrive truncated, so use the USB drive.

**PC:** x86-64 Linux (glibc 2.39+), a graphics card with Vulkan 1.3 (6 GB of VRAM recommended).

### How to play

1. Extract the package anywhere or run the AppImage.
2. Put `libSceNgs2.sprx` in the `system_lib/` folder next to the executable (optional: without it, the port uses its own audio mixer, still experimental).
3. Open **Gravity Rush Remastered** (or run `GravityRushRemastered-x86_64.AppImage`).
4. Under **Game folder**, choose the folder that has `eboot.bin`. Pick the language and click **Play**.

On Linux, `./install_desktop.sh` adds the game to the applications menu.

### While playing
- **F10**: FPS counter · **Insert** (or R3 + L2): the port's menu
- PS4/PS5, Xbox and 8BitDo controllers via SDL3, over USB or Bluetooth.

### Problems
- **Black streaks near characters**: keep "Turn off the geometry-shader outline" checked in the launcher (default).
- **Incomplete or odd sound**: without `libSceNgs2.sprx` in `system_lib/`, the port uses its own mixer, still experimental. With the file, audio is native.
- **Does not start or closes by itself**: send `out/last_run.log` in a [GitHub issue](https://github.com/rodrigojacarei/grr_pc/issues).

---

This project is not affiliated with Sony Interactive Entertainment or SIE Japan Studio. Gravity Rush is a trademark of Sony Interactive Entertainment. / Este projeto não tem vínculo com a Sony Interactive Entertainment ou a SIE Japan Studio.
