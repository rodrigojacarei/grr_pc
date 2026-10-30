# Gravity Rush Remastered — PC Port

Port nativo para PC (Linux x86-64) de **Gravity Rush Remastered** (PlayStation 4, `CUSA01130`).

---

## Novidades
- **Port nativo de Gravity Rush Remastered para Linux**: Execução nativa no PC via Vulkan e SDL3.
- **Pacote standalone via AppImage e tarball**: Executável único empacotado sem necessidade de configurar dependências manuais.
- **Correções de renderização e shaders Vulkan**: Pipeline gráfico ajustado, eliminação de artefatos visuais e suporte a shaders de geometry pass-through.

## What's new
- **Native Gravity Rush Remastered PC port**: Native execution on Linux via Vulkan and SDL3.
- **Standalone AppImage and tarball packages**: Self-contained executable ready to play without manual setup.
- **Vulkan rendering and shader pipeline fixes**: Graphics pipeline tuning, artifact fixes, and geometry pass-through shader support.

---

## Português

### Requisitos
- **SO**: Linux x86-64 com `glibc 2.39+` (Ubuntu 24.04+, Fedora 40+, Arch Linux / CachyOS).
- **GPU**: Placa de vídeo compatível com Vulkan 1.3 (NVIDIA GeForce GTX 1060+ / AMD Radeon RX 580+ / Intel Arc). Pelo menos 4 GB de VRAM (6 GB recomendados).
- **Controle**: Controles de PS4/PS5 (DualShock 4 / DualSense), Xbox ou Nintendo via USB/Bluetooth (SDL3). Teclado e mouse também são suportados.

### Arquivos do Jogo Necessários
Nenhum arquivo protegido por direitos autorais acompanha este repositório ou os executáveis. Os arquivos devem ser extraídos do seu próprio PlayStation 4 com **Gravity Rush Remastered (CUSA01130)**:

| Arquivo | Origem | Descrição |
|---|---|---|
| `eboot.bin` | Dump do jogo | Executável principal do jogo |
| `sce_module/libc.prx`, `libSceFios2.prx` | Dump do jogo | Bibliotecas internas do jogo |
| `arc/` | Dump do jogo | Arquivos de dados, modelos e fases (~9.5 GB) |
| `sce_sys/` (`param.sfo`, `icon0.png`, `pic1.png`) | Dump do jogo | Metadados e arte do jogo |
| `sce_discmap.plt` | Dump do jogo | Mapa de arquivos |
| `system_lib/libSceNgs2.sprx` | Console (`/system/common/lib/`) | *Opcional*: áudio nativo NGS2 (sem ele, usa o mixer experimental embutido) |

### Como Jogar
1. Baixe o pacote na aba [Releases](https://github.com/rodrigojacarei/grr_pc/releases) (`GravityRushRemastered-x86_64.AppImage` ou `.tar.gz`).
2. Dê permissão de execução:
   ```bash
   chmod +x GravityRushRemastered-x86_64.AppImage
   ./GravityRushRemastered-x86_64.AppImage
   ```
3. No Launcher, clique em **Pasta do jogo**, selecione a pasta onde está o seu `eboot.bin` e clique em **Jogar**.

### Compilação a partir do Código-Fonte
```bash
git clone https://github.com/rodrigojacarei/grr_pc.git
cd grr_pc
git submodule update --init --recursive
cd port
bash build.sh
# Para gerar o pacote standalone / AppImage:
bash packaging/appimage.sh
```

---

## English

### Requirements
- **OS**: x86-64 Linux with `glibc 2.39+` (Ubuntu 24.04+, Fedora 40+, Arch Linux / CachyOS).
- **GPU**: Vulkan 1.3 compatible graphics card (NVIDIA GTX 1060+ / AMD RX 580+ / Intel Arc). 4 GB VRAM minimum (6 GB recommended).
- **Controller**: DualShock 4, DualSense, Xbox or Switch controllers via SDL3. Keyboard and mouse also supported.

### Required Game Files
No proprietary PlayStation 4 binaries, assets, or firmware files are distributed with this project. Dump them from your own PS4 with **Gravity Rush Remastered (CUSA01130)**:
- `eboot.bin`, `sce_module/`, `arc/`, `sce_sys/`, and `sce_discmap.plt`.
- Optional: `libSceNgs2.sprx` in `system_lib/` for native audio playback.

### How to Play
1. Download `GravityRushRemastered-x86_64.AppImage` from [Releases](https://github.com/rodrigojacarei/grr_pc/releases).
2. Make it executable and run:
   ```bash
   chmod +x GravityRushRemastered-x86_64.AppImage
   ./GravityRushRemastered-x86_64.AppImage
   ```
3. Set your game directory containing `eboot.bin` and hit **Play**.

---

## Doações / Donations

Se este projeto te ajudou e você deseja apoiar o desenvolvimento e manutenção deste port:  
*If this project helped you and you would like to support the ongoing development of this port:*

| Moeda / Crypto | Rede / Network | Endereço / Address |
|---|---|---|
| **Bitcoin (BTC)** | Bitcoin (Native SegWit) | `bc1q0yll4cuc2ggdp44khwnedv9wrfkv5aru4m76m5` |
| **Monero (XMR)** | Monero | `423v5ndoR7ybqAxHGDhHgr1UPJ23o75R2NnFbKkHr91dLqnErtLeVAqERpQmMsS1vmftzworkVKT1cHq2Zax243e6qVxUwN` |
| **Litecoin (LTC)** | Litecoin | `ltc1q32daskmcsp3j5ew0ls60r9x6azdsvw55j92feg` |
| **USDT** | BSC (BEP-20) / Polygon | `0xfC4AE7Dbc8c60e3F23F2328F4b2b836AFd5CaBc8` |

---

## Créditos e Agradecimentos / Credits

- **shadPS4 team**: Pela camada de renderização Vulkan e recompiler de shaders. / For the Vulkan rendering layer and shader recompiler.
- **HayatoG**: Pelo desenvolvimento nos projetos de ports nativos de PS4 (`gr2_pc`, `tlg_pc`) e estrutura base do launcher. / For work on native PS4 port projects (`gr2_pc`, `tlg_pc`) and base launcher framework.

---

## Disclaimer / Licença
Este projeto é de código aberto sob licença **GPL-2.0**.
Gravity Rush é uma marca registrada da Sony Interactive Entertainment. Este projeto não possui vínculo, afiliação ou endosso da Sony Interactive Entertainment ou da SIE Japan Studio.
