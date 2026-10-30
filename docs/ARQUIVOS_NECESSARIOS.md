# Arquivos do jogo necessários / Required game files

[Português](#arquivos-do-jogo-necessários) · [English](#required-game-files)

## Arquivos do jogo necessários

Tudo vem do **seu** PS4 (GoldHEN + Itemzflow). Nada disso vai no download. Use **Gravity Rush Remastered CUSA01130**, montado numa pasta só. São ~9.5 GB.

| Arquivo | Origem | Descrição |
|---|---|---|
| `eboot.bin` | Dump do jogo | Executável principal do jogo |
| `sce_module/libc.prx`, `libSceFios2.prx` | Dump do jogo | Bibliotecas internas do jogo |
| `arc/` | Dump do jogo | Arquivos de dados, modelos, áudio e fases (~9.5 GB) |
| `sce_sys/` (`param.sfo`, `icon0.png`, `pic1.png`) | Dump do jogo | Metadados e arte oficial do jogo |
| `sce_discmap.plt` | Dump do jogo | Mapa de arquivos |

**Do firmware do console (opcional, para ter áudio nativo NGS2):** `libSceNgs2.sprx`, de `/system/common/lib/` do seu PS4. Ele vai na pasta `system_lib/` ao lado do executável.

## Required game files

Everything comes from **your own** PS4 (GoldHEN + Itemzflow). None of it is included in the download. Use **Gravity Rush Remastered CUSA01130**, dumped from your console (~9.5 GB).

| File | Source | Description |
|---|---|---|
| `eboot.bin` | Game dump | Main game executable |
| `sce_module/libc.prx`, `libSceFios2.prx` | Game dump | Internal game runtime libraries |
| `arc/` | Game dump | Data archives, models, audio, and stages (~9.5 GB) |
| `sce_sys/` (`param.sfo`, `icon0.png`, `pic1.png`) | Game dump | Metadata and game art assets |
| `sce_discmap.plt` | Game dump | File index map |

**From console firmware (optional, for native NGS2 audio):** `libSceNgs2.sprx`, from `/system/common/lib/` on your PS4. Place it in the `system_lib/` folder next to the executable.
