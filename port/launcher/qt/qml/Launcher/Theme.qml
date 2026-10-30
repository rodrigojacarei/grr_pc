pragma Singleton
import QtQuick
import Launcher

// Every color, size and font of the launcher lives here (single source for the visual identity).
QtObject {
    // surfaces
    readonly property color bg: "#0c0e15"
    readonly property color rail: "#080a10"
    readonly property color railLine: "#181d2c"
    readonly property color navHover: "#141824"
    readonly property color navOn: "#192033"
    readonly property color navOnLine: "#293352"
    readonly property color card: "#121622"
    readonly property color cardLine: "#20273a"
    readonly property color chip: "#151a28"
    readonly property color chipLine: "#263048"
    readonly property color ghost: "#141926"
    readonly property color ghostHover: "#1d2336"
    readonly property color ghostLine: "#27314a"
    readonly property color ghostLineHover: "#3b4a6f"
    // text
    readonly property color text: "#f2eff9"
    readonly property color textSoft: "#cfcae0"
    readonly property color textChip: "#dad5eb"
    readonly property color textMuted: "#9aa0bd"
    readonly property color textDim: "#858ca8"
    readonly property color textFaint: "#6c738e"
    // states
    readonly property color ok: "#35d07f"
    readonly property color warn: "#f6c944"   // Kat gold for warning / highlight
    readonly property color bad: "#ff4d4d"
    readonly property color off: "#5a606b"
    // accents — Gravity Rush's Celestial Kat Gold and Gravitational Void Violet
    readonly property color katGold: "#f6c944"
    readonly property color gravViolet: "#a855f7"
    readonly property color smoke: "#f6c944"  // Play, Primary Action
    readonly property color video: "#4da6ff"  // Graphics
    readonly property color neon: "#e879f9"   // Controls
    readonly property color cyan: "#22d3ee"   // Support, Mods
    readonly property var accents: ({ play: "#f6c944", graphics: "#4da6ff", controls: "#e879f9",
                                      fixes: "#a855f7", mods: "#22d3ee", saves: "#35d07f", guides: "#e879f9",
                                      support: "#22d3ee", updates: "#f6c944", advanced: "#818cf8" })
    // type
    property string fontDisplay: Backend.fontDisplay
    property string fontText: Backend.fontText
    readonly property int railWidth: 236
    readonly property int heroHeight: 320
    // line icons, 24x24 viewBox (circles written as arcs)
    readonly property var icons: ({
        play: "M7 4.5v15l12-7.5z",
        graphics: "M4 7h10M18 7h2M4 17h2M10 17h10 M18 7a2 2 0 1 0-4 0a2 2 0 1 0 4 0 M10 17a2 2 0 1 0-4 0a2 2 0 1 0 4 0",
        controls: "M7 8h10a4 4 0 0 1 4 4l-1 5a2 2 0 0 1-3.4 1L15 16H9l-1.6 2A2 2 0 0 1 4 17l-1-5a4 4 0 0 1 4-4z",
        fixes: "M12 3l8 3v6c0 4.5-3.2 7.8-8 9-4.8-1.2-8-4.5-8-9V6z M8.5 12l2.5 2.5 4.5-5",
        mods: "M9 3h6v4h3a2 2 0 0 1 2 2v3h-4v4h4v3a2 2 0 0 1-2 2h-3v-4H9v4H6a2 2 0 0 1-2-2v-3h4v-4H4V9a2 2 0 0 1 2-2h3z",
        guides: "M7 8h10a4 4 0 0 1 4 4l-1 5a2 2 0 0 1-3.4 1L15 16H9l-1.6 2A2 2 0 0 1 4 17l-1-5a4 4 0 0 1 4-4z M8 10.5v3M6.5 12h3 M15.5 11.5h.01M17.5 13.5h.01",
        saves: "M3 7a2 2 0 0 1 2-2h4l2 2h8a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z M12 10.5v5M9.5 13.5 12 16l2.5-2.5",
        support: "M21 12a9 9 0 1 0-18 0a9 9 0 1 0 18 0 M15.5 12a3.5 3.5 0 1 0-7 0a3.5 3.5 0 1 0 7 0 M5.6 5.6l3.9 3.9M14.5 14.5l3.9 3.9M18.4 5.6l-3.9 3.9M9.5 14.5l-3.9 3.9",
        updates: "M12 4v11M7.5 11 12 15.5 16.5 11M5 20h14",
        advanced: "M4 6h16M4 12h16M4 18h16 M9 6a2 2 0 1 0-4 0a2 2 0 1 0 4 0 M19 12a2 2 0 1 0-4 0a2 2 0 1 0 4 0 M12 18a2 2 0 1 0-4 0a2 2 0 1 0 4 0"
    })

    // Translation: reading Backend.lang inside makes every binding that calls it re-evaluate
    // when the player switches language.
    function tr(key) { var l = Backend.lang; return Backend.t(key) }
}
