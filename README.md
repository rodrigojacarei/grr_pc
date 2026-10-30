# Gravity Rush Remastered — PC Port

Native PC port for Linux (x86-64) and Windows (10/11 64-bit) of **Gravity Rush Remastered** (PlayStation 4, `CUSA01130`).

---

## Table of Contents / Índice
- [English](#english)
  - [What's New](#whats-new)
  - [System Requirements](#system-requirements)
  - [Required Game Files](#required-game-files)
  - [How to Play](#how-to-play)
  - [Building from Source](#building-from-source)
  - [Donations](#donations)
  - [Credits & Acknowledgments](#credits--acknowledgments)
- [Português](#português)
  - [Novidades](#novidades)
  - [Requisitos do Sistema](#requisitos-do-sistema)
  - [Arquivos do Jogo Necessários](#arquivos-do-jogo-necessários)
  - [Como Jogar](#como-jogar)
  - [Compilação a partir do Código-Fonte](#compilação-a-partir-do-código-fonte)
  - [Doações](#doações)
  - [Créditos e Agradecimentos](#créditos-e-agradecimentos)

---

# English

## What's New
- **Native PC Execution**: Runs natively on modern PC hardware using Vulkan 1.3 and SDL3.
- **High Framerate & Resolution Scaling**: Support for unlocked framerates (60 / 120 / 144 / 240 FPS / Unlimited) and true 4K / custom resolution rendering.
- **Standalone AppImage & Portable Packages**: Self-contained executables ready to play without manual dependency configuration.
- **Interactive Controller Guide & Remapping**: Visual guides for DualShock 4, DualSense, Xbox, and Nintendo Switch controllers with Kat's full gravity manipulation layout.
- **AMD FidelityFX FSR Support**: High-performance spatial upscaling with sharpness controls.

## System Requirements
- **Operating System**: 
  - Linux x86-64 with `glibc 2.39+` (Ubuntu 24.04+, Fedora 40+, Arch Linux / CachyOS).
  - Windows 10 / Windows 11 64-bit.
- **GPU**: Vulkan 1.3 compatible graphics card (NVIDIA GeForce GTX 1060+ / AMD Radeon RX 580+ / Intel Arc). Minimum 4 GB VRAM (6 GB+ recommended for 4K).
- **Controller**: DualShock 4, DualSense, Xbox, or Switch controllers via USB/Bluetooth (SDL3). Keyboard and mouse are also supported.

## Required Game Files
**No copyrighted game assets or PlayStation 4 binaries are included with this repository or releases.**  
You must dump the following files from your legally purchased copy of **Gravity Rush Remastered (CUSA01130)** on PlayStation 4:

| File / Folder | Source | Description |
|---|---|---|
| `eboot.bin` | Game dump | Main game executable |
| `sce_module/libc.prx`, `libSceFios2.prx` | Game dump | Internal game runtime libraries |
| `arc/` | Game dump | Data archives, models, audio, and stages (~9.5 GB) |
| `sce_sys/` (`param.sfo`, `icon0.png`, `pic1.png`) | Game dump | Metadata and game art assets |
| `sce_discmap.plt` | Game dump | File index map |
| `system_lib/libSceNgs2.sprx` | Console (`/system/common/lib/`) | *Optional*: Native NGS2 audio library (falls back to built-in experimental mixer if absent) |

## How to Play
1. Download the latest package from [Releases](https://github.com/rodrigojacarei/grr_pc/releases):
   - **Linux**: `GravityRushRemastered-x86_64.AppImage` (or `grr-linux-x86_64.tar.gz`)
   - **Windows**: `grr-windows-x86_64.zip`
2. **Linux**: Make the AppImage executable and launch:
   ```bash
   chmod +x GravityRushRemastered-x86_64.AppImage
   ./GravityRushRemastered-x86_64.AppImage
   ```
3. **Windows**: Extract `grr-windows-x86_64.zip` and run `Gravity Rush Remastered.exe`.
4. In the Launcher, click **Game folder**, select the directory containing your dumped `eboot.bin`, and click **Play**.

## Building from Source

### Linux
```bash
git clone https://github.com/rodrigojacarei/grr_pc.git
cd grr_pc
git submodule update --init --recursive
cd port
bash build.sh

# To build the standalone AppImage:
bash packaging/appimage.sh
```

### Windows (MSYS2 Clang64)
```bash
git clone https://github.com/rodrigojacarei/grr_pc.git
cd grr_pc/port
TLG_LTO=OFF bash build.sh
bash packaging/windows/package.sh
```

## Donations
If this project helped you and you would like to support ongoing development:

| Cryptocurrency | Network | Address |
|---|---|---|
| **Bitcoin (BTC)** | Native SegWit | `bc1q0yll4cuc2ggdp44khwnedv9wrfkv5aru4m76m5` |
| **Monero (XMR)** | Monero | `423v5ndoR7ybqAxHGDhHgr1UPJ23o75R2NnFbKkHr91dLqnErtLeVAqERpQmMsS1vmftzworkVKT1cHq2Zax243e6qVxUwN` |
| **Litecoin (LTC)** | Litecoin | `ltc1q32daskmcsp3j5ew0ls60r9x6azdsvw55j92feg` |
| **USDT** | BSC (BEP-20) / Polygon | `0xfC4AE7Dbc8c60e3F23F2328F4b2b836AFd5CaBc8` |

## Credits & Acknowledgments
- **shadPS4 team**: For the Vulkan rendering layer and shader recompiler.
- **HayatoG**: For foundational work on PS4 native ports (`gr2_pc`, `tlg_pc`) and base launcher framework.

---

# Português

## Novidades
- **Execução Nativa no PC**: Roda nativamente no PC utilizando Vulkan 1.3 e SDL3.
- **Altas Taxas de Quadro e Escalação de Resolução**: Suporte a framerates destravados (60 / 120 / 144 / 240 FPS / Ilimitado) e renderização real em 4K e resoluções customizadas.
- **AppImage Standalone e Pacotes Portáteis**: Pacotes prontos para jogar sem necessidade de instalar dependências manuais.
- **Guia Visual de Controles**: Guia interativo para controles de PS4, PS5, Xbox e Nintendo Switch com o mapeamento completo dos poderes de gravidade da Kat.
- **Suporte a AMD FidelityFX FSR**: Upscaling espacial de alto desempenho com controle de nitidez.

## Requisitos do Sistema
- **Sistema Operacional**: 
  - Linux x86-64 com `glibc 2.39+` (Ubuntu 24.04+, Fedora 40+, Arch Linux / CachyOS).
  - Windows 10 / Windows 11 64-bit.
- **Placa de Vídeo (GPU)**: Placa compatível com Vulkan 1.3 (NVIDIA GeForce GTX 1060+ / AMD Radeon RX 580+ / Intel Arc). Mínimo de 4 GB de VRAM (6 GB+ recomendados para 4K).
- **Controles**: Controles de PS4/PS5 (DualShock 4 / DualSense), Xbox ou Nintendo Switch via USB/Bluetooth (SDL3). Teclado e mouse também são suportados.

## Arquivos do Jogo Necessários
**Nenhum arquivo protegido por direitos autorais acompanha este repositório ou os executáveis.**  
Os arquivos devem ser extraídos da sua própria cópia de **Gravity Rush Remastered (CUSA01130)** no PlayStation 4:

| Arquivo / Pasta | Origem | Descrição |
|---|---|---|
| `eboot.bin` | Dump do jogo | Executável principal do jogo |
| `sce_module/libc.prx`, `libSceFios2.prx` | Dump do jogo | Bibliotecas internas do jogo |
| `arc/` | Dump do jogo | Arquivos de dados, modelos, áudio e fases (~9.5 GB) |
| `sce_sys/` (`param.sfo`, `icon0.png`, `pic1.png`) | Dump do jogo | Metadados e arte oficial do jogo |
| `sce_discmap.plt` | Dump do jogo | Mapa de arquivos |
| `system_lib/libSceNgs2.sprx` | Console (`/system/common/lib/`) | *Opcional*: áudio nativo NGS2 (sem ele, usa o mixer experimental embutido) |

## Como Jogar
1. Baixe o pacote mais recente na aba [Releases](https://github.com/rodrigojacarei/grr_pc/releases):
   - **Linux**: `GravityRushRemastered-x86_64.AppImage` (ou `grr-linux-x86_64.tar.gz`)
   - **Windows**: `grr-windows-x86_64.zip`
2. **Linux**: Dê permissão de execução ao AppImage e abra:
   ```bash
   chmod +x GravityRushRemastered-x86_64.AppImage
   ./GravityRushRemastered-x86_64.AppImage
   ```
3. **Windows**: Descompacte `grr-windows-x86_64.zip` e execute `Gravity Rush Remastered.exe`.
4. No Launcher, clique em **Pasta do jogo**, selecione a pasta onde está o seu `eboot.bin` extraído e clique em **Jogar**.

## Compilação a partir do Código-Fonte

### Linux
```bash
git clone https://github.com/rodrigojacarei/grr_pc.git
cd grr_pc
git submodule update --init --recursive
cd port
bash build.sh

# Para gerar o pacote standalone / AppImage:
bash packaging/appimage.sh
```

### Windows (MSYS2 Clang64)
```bash
git clone https://github.com/rodrigojacarei/grr_pc.git
cd grr_pc/port
TLG_LTO=OFF bash build.sh
bash packaging/windows/package.sh
```

## Doações
Se este projeto te ajudou e você deseja apoiar o desenvolvimento contínuo:

| Moeda / Crypto | Rede / Network | Endereço / Address |
|---|---|---|
| **Bitcoin (BTC)** | Bitcoin (Native SegWit) | `bc1q0yll4cuc2ggdp44khwnedv9wrfkv5aru4m76m5` |
| **Monero (XMR)** | Monero | `423v5ndoR7ybqAxHGDhHgr1UPJ23o75R2NnFbKkHr91dLqnErtLeVAqERpQmMsS1vmftzworkVKT1cHq2Zax243e6qVxUwN` |
| **Litecoin (LTC)** | Litecoin | `ltc1q32daskmcsp3j5ew0ls60r9x6azdsvw55j92feg` |
| **USDT** | BSC (BEP-20) / Polygon | `0xfC4AE7Dbc8c60e3F23F2328F4b2b836AFd5CaBc8` |

## Créditos e Agradecimentos
- **shadPS4 team**: Pela camada de renderização Vulkan e recompiler de shaders.
- **HayatoG**: Pelo desenvolvimento nos projetos de ports nativos de PS4 (`gr2_pc`, `tlg_pc`) e estrutura base do launcher.
