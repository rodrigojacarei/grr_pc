# SPDX-License-Identifier: GPL-2.0-or-later
"""Qt Quick application: fonts, the hero image provider, the QML engine and the window."""
import math
import sys
from pathlib import Path

from PySide6.QtCore import QPointF, QRectF, QSize, Qt, QUrl
from PySide6.QtGui import (QBrush, QColor, QFontDatabase, QGuiApplication, QIcon, QImage, QLinearGradient, QPainter,
                           QPen, QRadialGradient)
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtQuick import QQuickImageProvider

from . import logic
from .backend import Backend
from .controls import Controls
from .graphics import Graphics

HERE = Path(__file__).resolve().parent
QML_ROOT = HERE / 'qml'
FONT_DISPLAY = 'Big Shoulders Stencil Display'
FONT_TEXT = 'Barlow'


def load_fonts():
    """Loads the OFL fonts shipped in qt/fonts; returns (display family, text family), falling
    back to the system's sans-serif when a font file is missing or does not load."""
    families = {}
    for path in sorted((HERE / 'fonts').glob('*.ttf')):
        ident = QFontDatabase.addApplicationFont(str(path))
        if ident >= 0:
            for name in QFontDatabase.applicationFontFamilies(ident):
                families[name] = True
    return (FONT_DISPLAY if FONT_DISPLAY in families else 'sans-serif',
            FONT_TEXT if FONT_TEXT in families else 'sans-serif')


class HeroProvider(QQuickImageProvider):
    """image://hero/bg: Hekseville celestial twilight with gravity glow and floating motes,
    used when the player's pic1.png is absent (and under it while it loads). Drawn here so it needs no art file."""

    def __init__(self):
        super().__init__(QQuickImageProvider.ImageType.Image)

    def requestImage(self, ident, size, requested):
        w, h = (requested.width(), requested.height()) if requested.isValid() else (884, 392)
        w, h = max(w, 1), max(h, 1)
        if requested.isValid() is False:
            w, h = 884, 392
        img = QImage(w, h, QImage.Format.Format_ARGB32_Premultiplied)
        img.fill(Qt.transparent)
        p = QPainter(img)
        p.setRenderHint(QPainter.Antialiasing)
        base = QLinearGradient(0, 0, 0, h)
        base.setColorAt(0, QColor('#121626'))
        base.setColorAt(0.5, QColor('#0e111d'))
        base.setColorAt(1, QColor('#080a10'))
        p.fillRect(0, 0, w, h, base)
        # Kat Gold and Gravitational Violet nebulae
        self.glow(p, w, h, 0.75 * w, 0.28 * h, 0.55 * w, 0.65 * h, QColor(246, 201, 68), 0.38)
        self.glow(p, w, h, 0.55 * w, 0.40 * h, 0.65 * w, 0.75 * h, QColor(168, 85, 247), 0.35)
        self.glow(p, w, h, 0.20 * w, 0.80 * h, 0.50 * w, 0.60 * h, QColor(34, 211, 238), 0.18)
        # Floating gravitational motes / stardust
        p.setPen(Qt.NoPen)
        # Deterministic pseudo-random stars based on coordinates
        for i in range(70):
            sx = ((i * 137.5) % w)
            sy = ((i * 83.3 + (i * i) * 11) % h)
            sr = 1.0 + (i % 3) * 0.7
            alpha = 40 + (i * 17) % 180
            col = QColor(246, 201, 68, alpha) if i % 2 == 0 else QColor(220, 210, 255, alpha)
            p.setBrush(QBrush(col))
            p.drawEllipse(QPointF(sx, sy), sr, sr)
        p.end()
        return img

    @staticmethod
    def glow(p, w, h, cx, cy, rx, ry, color, alpha):
        """Elliptical radial glow: alpha at the center, fading out at 62% of the radius."""
        p.save()
        p.translate(cx, cy)
        p.scale(1.0, ry / rx)
        gradient = QRadialGradient(QPointF(0, 0), rx)
        c0, c1 = QColor(color), QColor(color)
        c0.setAlphaF(alpha)
        c1.setAlphaF(0)
        gradient.setColorAt(0, c0)
        gradient.setColorAt(0.62, c1)
        p.fillRect(QRectF(-w * 2, -h * 4, w * 4, h * 8), QBrush(gradient))
        p.restore()


try:
    from PySide6.QtWidgets import QApplication
    _app_cls = QApplication
except ImportError:
    _app_cls = QGuiApplication


class App:
    """Everything the window needs; `show()` for the real launcher, `grab()` for screenshots."""

    def __init__(self, backend=None, argv=None):
        self.qt = _app_cls.instance() or _app_cls(argv or sys.argv)
        self.qt.setApplicationName('grr-launcher')
        self.qt.setDesktopFileName('grr-pc')
        self.backend = backend or Backend()
        self.backend.fonts = load_fonts()
        icon = HERE.parent / 'grr.png'
        if icon.is_file():
            self.qt.setWindowIcon(QIcon(str(icon)))
        self.graphics = Graphics(self.backend, self.backend.probes.get('graphics'))
        self.controls = Controls(self.backend)
        self.engine = QQmlApplicationEngine()
        self.engine.addImageProvider('hero', HeroProvider())
        self.engine.addImportPath(str(QML_ROOT))
        self.engine.rootContext().setContextProperty('Backend', self.backend)
        self.engine.rootContext().setContextProperty('Saves', self.backend.saves)
        self.engine.rootContext().setContextProperty('Graphics', self.graphics)
        self.engine.rootContext().setContextProperty('PadControls', self.controls)
        self.engine.rootContext().setContextProperty('Support', self.backend.support)
        self.engine.rootContext().setContextProperty('Updates', self.backend.updates)
        self.engine.loadFromModule('Launcher', 'Window')
        if not self.engine.rootObjects():
            raise RuntimeError('the QML interface did not load (see the messages above)')
        self.window = self.engine.rootObjects()[0]

    def go(self, index):
        self.window.setProperty('current', index)

    def grab(self, path):
        """PNG of the current window contents (QQuickWindow.grabWindow)."""
        from PySide6.QtCore import QEventLoop, QTimer
        loop = QEventLoop()                       # let transitions (<= 250 ms) finish
        QTimer.singleShot(450, loop.quit)
        loop.exec()
        image = self.window.grabWindow()
        return image.save(str(path))

    def run(self):
        self.backend.start_probes()
        self.graphics.start()
        code = self.qt.exec()
        self.backend.shutdown()
        return code
