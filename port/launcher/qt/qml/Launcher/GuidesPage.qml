import QtQuick
import QtQuick.Controls.Basic
import Launcher

Item {
    id: page
    readonly property color accent: Theme.neon
    readonly property int side: 36

    readonly property string currentLang: Backend.lang
    readonly property bool isPt: currentLang === "pt_BR"

    property string activePad: {
        var k = Backend.guideKind
        return k === "switch" ? "switch" : k === "xbox" ? "xbox" : k === "keyboard" ? "keyboard" : "playstation"
    }

    Connections {
        target: Backend
        function onGuideChanged() {
            var k = Backend.guideKind
            if (k === "switch" || k === "xbox" || k === "keyboard" || k === "playstation") {
                page.activePad = k
            }
        }
    }

    readonly property var padOptions: [
        { key: "playstation", label: "PlayStation (DualSense / PS4)", icon: "M12 2a10 10 0 1 0 10 10A10 10 0 0 0 12 2zm-1 14.5v-9l7 4.5z" },
        { key: "xbox", label: "Xbox (Series / One / 360)", icon: "M12 2a10 10 0 1 0 10 10A10 10 0 0 0 12 2z" },
        { key: "switch", label: "Nintendo Switch Pro", icon: "M6 4h12a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2z" },
        { key: "keyboard", label: page.isPt ? "Teclado & Mouse (PC)" : "Keyboard & Mouse (PC)", icon: "M4 5h16a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V7a2 2 0 0 1 2-2z" }
    ]

    readonly property var commands: getCommands(page.activePad, page.isPt)

    function getCommands(pad, pt) {
        if (pad === "playstation") {
            return {
                gravity: [
                    { btn: "R1", name: pt ? "Alterar Gravidade / Flutuar" : "Gravity Shift / Float",
                      desc: pt ? "Pressione para suspender a gravidade e flutuar no ar. Mire com a retícula circular e pressione R1 novamente para 'cair' velozmente naquela direção."
                               : "Press to suspend gravity and float in mid-air. Aim with the reticle and press R1 again to 'fall' in that direction." },
                    { btn: "L1", name: pt ? "Restaurar Gravidade" : "Restore Normal Gravity",
                      desc: pt ? "Cancela instantaneamente a distorção gravitacional e retorna à gravidade natural do chão."
                               : "Instantly cancels gravity shifting and restores natural downward gravity." },
                    { btn: pt ? "□  Quadrado" : "□  Square", name: pt ? "Chute Gravitacional (Gravity Kick)" : "Gravity Kick",
                      desc: pt ? "No ar, Kat projeta-se em alta velocidade com um chute carregado contra o alvo. O golpe principal para destruir os núcleos vermelhos dos Nevi!"
                               : "While airborne, Kat plunges toward the target with an accelerated kick. Essential for shattering Nevi cores!" },
                    { btn: pt ? "○  Círculo" : "○  Circle", name: pt ? "Campo de Estase / Arremesso" : "Stasis Field / Throw",
                      desc: pt ? "Cria uma esfera de microgravidade ao redor de Kat que levita objetos (pedras, barris, caixas). Pressione ○ novamente mirando no inimigo para arremessá-los com teleguiamento!"
                               : "Generates a stasis field around Kat to levitate debris. Press ○ again while aiming to launch objects at enemies with tracking!" },
                    { btn: pt ? "△  Triângulo" : "△  Triangle", name: pt ? "Ataques Especiais Finalizadores" : "Special Attacks",
                      desc: pt ? "Executa técnicas devastadoras (Spiraling Claw, Gravity Typhoon ou Micro Black Hole) quando a barra de gemas especiais estiver carregada."
                               : "Unleashes destructive special powers (Spiraling Claw, Gravity Typhoon, Micro Black Hole) when your special gauge is charged." },
                    { btn: "R2", name: pt ? "Deslizar Gravitacional / Esquiva" : "Gravity Slide / Evade",
                      desc: pt ? "Segure enquanto toca em qualquer superfície para surfar em alta velocidade na gravidade. No ar, toque para esquivar de projéteis."
                               : "Hold while touching any surface to skate and slide at high speeds. While airborne, tap to perform an evasive dash." }
                ],
                ground: [
                    { btn: pt ? "✕  X" : "✕  Cross (X)", name: pt ? "Pular" : "Jump",
                      desc: pt ? "Salto padrão. Segure para ganhar mais altura e impulso antes de mudar a gravidade."
                               : "Standard jump. Hold for a higher leap before triggering gravity shift." },
                    { btn: pt ? "□  Quadrado" : "□  Square", name: pt ? "Combo de Chutes Terrestres" : "Ground Kick Combo",
                      desc: pt ? "Sequência de chutes rápidos contra Nevi ou obstáculos no solo."
                               : "Rapid sequence of martial arts kicks against enemies on the ground." },
                    { btn: pt ? "L3  Analógico Esq." : "L3  Left Stick", name: pt ? "Mover Kat" : "Move Kat",
                      desc: pt ? "Controla a movimentação de Kat pelo chão ou orienta sua rotação no ar."
                               : "Controls Kat's walking and running direction, or steers her during flight." },
                    { btn: pt ? "R3  Analógico Dir." : "R3  Right Stick", name: pt ? "Câmera 360°" : "Camera Controls",
                      desc: pt ? "Controla o ângulo de visão livre por Hekseville. Clique no R3 para centralizar a câmera imediatamente atrás da Kat."
                               : "Full 360° orbital camera control. Click R3 to reset the camera behind Kat." },
                    { btn: pt ? "D-Pad Cima" : "D-Pad Up", name: pt ? "Câmera em 1ª Pessoa" : "First-Person View",
                      desc: pt ? "Alterna para a visão direta dos olhos da Kat para contemplar a paisagem ou analisar caminhos em Hekseville."
                               : "Switches to direct first-person view to examine Hekseville's architecture." }
                ],
                sensor: [
                    { btn: pt ? "Giroscópio (Sensor)" : "Motion Sensor (Gyro)", name: pt ? "Ajuste Fino de Mira Giroscópica" : "Motion Sensor Aiming",
                      desc: pt ? "Incline o controle suavemente para calibrar a mira do Chute Gravitacional e do arremesso de objetos com precisão milimétrica."
                               : "Tilt your gamepad to make precision adjustments to your gravity kick and debris trajectory." },
                    { btn: "Touchpad", name: pt ? "Esquiva Tátil" : "Touchpad Evasion",
                      desc: pt ? "Deslize o dedo sobre a superfície do touchpad em qualquer direção para executar uma cambalhota evasiva rápida."
                               : "Flick across the touchpad surface in any direction to perform an immediate tactical dodge roll." },
                    { btn: "Options / Menu", name: pt ? "Pausa / Aprimoramentos da Kat" : "Pause & Power Upgrades",
                      desc: pt ? "Abre o menu para gastar Gemas Preciosas e aprimorar velocidade, poder do Chute Gravitacional, estase e saúde máxima."
                               : "Opens the upgrade menu to spend Precious Gems on improving kick power, health, and gravity duration." }
                ]
            };
        } else if (pad === "xbox") {
            return {
                gravity: [
                    { btn: "RB", name: pt ? "Alterar Gravidade / Flutuar" : "Gravity Shift / Float",
                      desc: pt ? "Pressione para suspender a gravidade e flutuar no ar. Mire com o analógico direito e pressione RB novamente para 'cair' naquela direção."
                               : "Press to suspend gravity and float in mid-air. Aim and press RB again to 'fall' in that direction." },
                    { btn: "LB", name: pt ? "Restaurar Gravidade" : "Restore Normal Gravity",
                      desc: pt ? "Cancela instantaneamente a distorção gravitacional e retorna à gravidade normal do chão."
                               : "Instantly cancels gravity shifting and restores natural downward gravity." },
                    { btn: "X", name: pt ? "Chute Gravitacional (Gravity Kick)" : "Gravity Kick",
                      desc: pt ? "No ar, Kat projeta-se em alta velocidade com um chute contra o alvo. Destrói os núcleos dos Nevi!"
                               : "While airborne, Kat plunges toward the target with an accelerated kick." },
                    { btn: "B", name: pt ? "Campo de Estase / Arremesso" : "Stasis Field / Throw",
                      desc: pt ? "Cria uma esfera de gravidade que levita caixas e pedras. Pressione B novamente mirando para arremessar!"
                               : "Generates a stasis field to levitate debris. Press B again while aiming to launch objects!" },
                    { btn: "Y", name: pt ? "Ataques Especiais Finalizadores" : "Special Attacks",
                      desc: pt ? "Dispara técnicas devastadoras (Spiraling Claw, Gravity Typhoon, Micro Black Hole) quando a barra de especiais estiver carregada."
                               : "Unleashes destructive special powers when your special gauge is charged." },
                    { btn: "RT", name: pt ? "Deslizar Gravitacional / Esquiva" : "Gravity Slide / Evade",
                      desc: pt ? "Segure enquanto toca em qualquer superfície para surfar na gravidade. No ar, toque para esquivar."
                               : "Hold while touching surfaces to skate on gravity. While airborne, tap to evade." }
                ],
                ground: [
                    { btn: "A", name: pt ? "Pular" : "Jump",
                      desc: pt ? "Pulo terrestre padrão. Segure para maior impulso antes de mudar a gravidade."
                               : "Standard jump. Hold for a higher leap before triggering gravity shift." },
                    { btn: "X", name: pt ? "Combo de Chutes Terrestres" : "Ground Kick Combo",
                      desc: pt ? "Sequência de chutes rápidos no chão." : "Rapid martial arts kick sequence on the ground." },
                    { btn: pt ? "LS  Analógico Esq." : "LS  Left Stick", name: pt ? "Mover Kat" : "Move Kat",
                      desc: pt ? "Controla a movimentação de Kat pelo chão ou sua rotação no ar."
                               : "Controls Kat's walking and running direction, or steers her during flight." },
                    { btn: pt ? "RS  Analógico Dir." : "RS  Right Stick", name: pt ? "Câmera 360°" : "Camera Controls",
                      desc: pt ? "Controla o ângulo de visão livre. Clique no RS para centralizar a câmera."
                               : "Full 360° camera control. Click RS to reset camera behind Kat." },
                    { btn: pt ? "D-Pad Cima" : "D-Pad Up", name: pt ? "Câmera em 1ª Pessoa" : "First-Person View",
                      desc: pt ? "Alterna para a visão direta dos olhos da Kat." : "Switches to direct first-person view." }
                ],
                sensor: [
                    { btn: pt ? "LT / LB + Analógico" : "LT / LB + Stick", name: pt ? "Simulação de Sensor & Touchpad" : "Sensor & Touchpad Simulation",
                      desc: pt ? "O port mapeia automaticamente as ações de esquiva e mira fina nos gatilhos e analógicos do Xbox."
                               : "The port automatically maps touchpad and tilt maneuvers to Xbox triggers and sticks." },
                    { btn: "Start / Menu", name: pt ? "Pausa / Aprimoramentos da Kat" : "Pause & Power Upgrades",
                      desc: pt ? "Abre o menu para gastar Gemas Preciosas e melhorar as habilidades da Kat."
                               : "Opens the upgrade menu to spend Precious Gems on improving Kat's abilities." }
                ]
            };
        } else if (pad === "switch") {
            return {
                gravity: [
                    { btn: "R", name: pt ? "Alterar Gravidade / Flutuar" : "Gravity Shift / Float",
                      desc: pt ? "Pressione para suspender a gravidade e flutuar no ar. Pressione R novamente para cair."
                               : "Press to suspend gravity and float in mid-air. Press R again to fall." },
                    { btn: "L", name: pt ? "Restaurar Gravidade" : "Restore Normal Gravity",
                      desc: pt ? "Cancela a gravidade alterada e volta ao chão normal."
                               : "Cancels gravity shifting and restores natural gravity." },
                    { btn: "Y", name: pt ? "Chute Gravitacional" : "Gravity Kick",
                      desc: pt ? "No ar, Kat arremessa-se em alta velocidade contra o alvo."
                               : "Airborne gravity kick targeting Nevi weakpoints." },
                    { btn: "A", name: pt ? "Campo de Estase / Arremesso" : "Stasis Field / Throw",
                      desc: pt ? "Levita objetos próximos e permite arremessá-los nos inimigos."
                               : "Levitates surrounding debris and launches them at enemies." },
                    { btn: "X", name: pt ? "Ataque Especial" : "Special Attack",
                      desc: pt ? "Dispara técnicas especiais devastadoras." : "Unleashes destructive special powers." },
                    { btn: "ZR", name: pt ? "Deslizar Gravitacional / Esquiva" : "Gravity Slide / Evade",
                      desc: pt ? "Deslize veloz pelas paredes e chão de Hekseville." : "High-speed sliding along surfaces." }
                ],
                ground: [
                    { btn: "B", name: pt ? "Pular" : "Jump", desc: pt ? "Salto padrão." : "Standard jump." },
                    { btn: "Y", name: pt ? "Combo Terrestre" : "Ground Kick Combo", desc: pt ? "Chutes no solo." : "Rapid kicks on the ground." },
                    { btn: pt ? "Stick Esquerdo" : "Left Stick", name: pt ? "Mover Kat" : "Move Kat", desc: pt ? "Movimentação da Kat." : "Kat movement." },
                    { btn: pt ? "Stick Direito" : "Right Stick", name: pt ? "Câmera 360°" : "Camera Controls", desc: pt ? "Câmera e clique para centralizar." : "Camera orbit & click to reset." }
                ],
                sensor: [
                    { btn: pt ? "Giroscópio Switch" : "Switch Gyro", name: pt ? "Mira Giroscópica" : "Gyro Aiming",
                      desc: pt ? "Ajuste fino de mira usando os giroscópios do Switch Pro Controller."
                               : "Fine aiming using Switch Pro Controller motion sensors." },
                    { btn: "+ (Plus)", name: pt ? "Menu / Aprimoramentos" : "Menu & Upgrades",
                      desc: pt ? "Abre menu de melhorias." : "Opens upgrade menu." }
                ]
            };
        } else {
            return {
                gravity: [
                    { btn: pt ? "Botão Direito (Mouse)" : "Right Mouse Button", name: pt ? "Alterar Gravidade / Flutuar" : "Gravity Shift / Float",
                      desc: pt ? "Clique com o botão direito para suspender a gravidade. Mire com o mouse e clique novamente para cair!"
                               : "Right click to suspend gravity. Aim freely with the mouse and right click again to fall!" },
                    { btn: pt ? "Espaço" : "Spacebar", name: pt ? "Restaurar Gravidade / Pular" : "Restore Gravity / Jump",
                      desc: pt ? "No ar, cancela a gravidade e desce ao solo. No chão, executa pulo."
                               : "While airborne, cancels gravity shift and drops to ground. On ground, jumps." },
                    { btn: pt ? "Botão Esquerdo (Mouse)" : "Left Mouse Button", name: pt ? "Chute Gravitacional / Ataque" : "Gravity Kick / Attack",
                      desc: pt ? "No ar, executa o poderoso Chute Gravitacional onde a mira do mouse apontar. No chão, combo de chutes."
                               : "While airborne, unleashes a pinpoint Gravity Kick toward the mouse reticle. On ground, melee combo." },
                    { btn: "E", name: pt ? "Campo de Estase / Arremesso" : "Stasis Field / Throw",
                      desc: pt ? "Pressione E para levitar objetos próximos. Pressione E novamente mirando no inimigo para arremessar!"
                               : "Press E to levitate debris. Press E again while aiming to launch them at enemies!" },
                    { btn: "Q", name: pt ? "Ataques Especiais" : "Special Attack",
                      desc: pt ? "Dispara o finalizador especial quando a barra estiver carregada."
                               : "Activates devastating special attack finishers." },
                    { btn: pt ? "Shift Esquerdo" : "Left Shift", name: pt ? "Deslizar Gravitacional / Esquiva" : "Gravity Slide / Evade",
                      desc: pt ? "Segure Shift para deslizar velozmente sobre superfícies com a gravidade. No ar, esquiva."
                               : "Hold Shift to surf and slide along surfaces. In mid-air, dodges." }
                ],
                ground: [
                    { btn: "W, A, S, D", name: pt ? "Movimentação da Kat" : "Movement",
                      desc: pt ? "Move Kat pelo chão ou orienta sua rotação no ar." : "Move Kat on the ground or steer her flight." },
                    { btn: pt ? "Mouse (Movimento)" : "Mouse Look", name: pt ? "Controle da Câmera & Mira" : "Camera & Aiming",
                      desc: pt ? "Movimentação fluida da câmera em 60 FPS com precisão milimétrica de mouse."
                               : "Fluid 60 FPS mouse-directed camera and targeting." },
                    { btn: pt ? "Botão do Meio (Scroll)" : "Middle Mouse Button", name: pt ? "Resetar Câmera" : "Reset Camera",
                      desc: pt ? "Alinha a câmera diretamente atrás de Kat." : "Centers the camera behind Kat." },
                    { btn: pt ? "Roda do Mouse (Cima)" : "Mouse Wheel Up", name: pt ? "Câmera em 1ª Pessoa" : "First-Person View",
                      desc: pt ? "Visão direta em primeira pessoa." : "First-person view mode." }
                ],
                sensor: [
                    { btn: pt ? "Sensor do Mouse" : "Mouse Precision", name: pt ? "Substituto de Giroscópio" : "Mouse Gyro Precision",
                      desc: pt ? "No PC, a precisão do sensor giroscópico do PS4 é naturalmente proporcionada pelo movimento do mouse."
                               : "On PC, mouse tracking naturally provides sub-pixel aiming precision." },
                    { btn: "Esc", name: pt ? "Menu de Pausa / Aprimoramentos" : "Pause & Upgrades",
                      desc: pt ? "Menu de melhorias e configurações." : "Pause and upgrade menu." }
                ]
            };
        }
    }

    Flickable {
        id: flick
        anchors.fill: parent
        contentWidth: width
        contentHeight: bodyCol.implicitHeight + 60
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        ScrollBar.vertical: ScrollBar {
            id: bar
            contentItem: Rectangle { implicitWidth: 6; radius: 3; color: bar.pressed ? Theme.ghostLineHover : Theme.ghostLine }
            background: Item { }
        }

        Column {
            id: bodyCol
            x: page.side; y: 24; width: flick.width - 2 * page.side; spacing: 18

            // Header Area
            Column {
                width: parent.width; spacing: 8
                Text {
                    text: Theme.tr("guides_title")
                    color: "#ffffff"
                    font.family: Theme.fontDisplay; font.variableAxes: ({ "wght": 800 })
                    font.pixelSize: 38; font.weight: Font.ExtraBold
                    font.capitalization: Font.AllUppercase; font.letterSpacing: 1.8
                }
                Text {
                    width: parent.width; text: Theme.tr("guides_intro")
                    wrapMode: Text.WordWrap; color: Theme.textSoft
                    font.family: Theme.fontText; font.pixelSize: 14; lineHeight: 1.35
                }
            }

            // Controller Type Selector Pills
            Row {
                width: parent.width; spacing: 10
                Repeater {
                    model: page.padOptions
                    Rectangle {
                        readonly property bool on: page.activePad === modelData.key
                        readonly property bool hot: padMouse.containsMouse
                        height: 38; radius: 19
                        width: padLabel.implicitWidth + 32
                        color: on ? Qt.rgba(Theme.katGold.r, Theme.katGold.g, Theme.katGold.b, 0.16)
                                  : hot ? Theme.navHover : Theme.card
                        border.width: on ? 1.5 : 1
                        border.color: on ? Theme.katGold : hot ? Theme.ghostLineHover : Theme.cardLine
                        Behavior on color { ColorAnimation { duration: 120 } }
                        Text {
                            id: padLabel
                            anchors.centerIn: parent
                            text: modelData.label
                            color: parent.on ? Theme.katGold : Theme.text
                            font.family: Theme.fontText; font.pixelSize: 13
                            font.weight: parent.on ? Font.Bold : Font.DemiBold
                        }
                        MouseArea {
                            id: padMouse; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                            onClicked: page.activePad = modelData.key
                        }
                    }
                }
            }

            // ---- Category 1: Gravity Powers -----------------------------------------------
            SectionTitle { text: Theme.tr("guides_sec_gravity"); accent: Theme.katGold }
            Rectangle {
                width: parent.width
                height: gravCol.implicitHeight + 28
                radius: 14; color: Theme.card; border.width: 1; border.color: Theme.cardLine
                Column {
                    id: gravCol
                    x: 18; y: 14; width: parent.width - 36; spacing: 14
                    Repeater {
                        model: page.commands.gravity
                        Row {
                            width: parent.width; spacing: 16
                            Rectangle {
                                width: 170; height: 32; radius: 8
                                color: Qt.rgba(Theme.katGold.r, Theme.katGold.g, Theme.katGold.b, 0.12)
                                border.width: 1; border.color: Qt.rgba(Theme.katGold.r, Theme.katGold.g, Theme.katGold.b, 0.40)
                                anchors.verticalCenter: parent.verticalCenter
                                Text {
                                    anchors.centerIn: parent
                                    text: modelData.btn
                                    color: Theme.katGold
                                    font.family: Theme.fontDisplay; font.variableAxes: ({ "wght": 700 })
                                    font.pixelSize: 13; font.weight: Font.Bold
                                }
                            }
                            Column {
                                width: parent.width - 186; spacing: 2
                                anchors.verticalCenter: parent.verticalCenter
                                Text {
                                    text: modelData.name
                                    color: "#ffffff"
                                    font.family: Theme.fontText; font.pixelSize: 14; font.weight: Font.Bold
                                }
                                Text {
                                    width: parent.width; text: modelData.desc
                                    wrapMode: Text.WordWrap; color: Theme.textDim
                                    font.family: Theme.fontText; font.pixelSize: 12; lineHeight: 1.3
                                }
                            }
                        }
                    }
                }
            }

            // ---- Category 2: Ground Movement & Combat -------------------------------------
            SectionTitle { text: Theme.tr("guides_sec_ground"); accent: Theme.cyan }
            Rectangle {
                width: parent.width
                height: groundCol.implicitHeight + 28
                radius: 14; color: Theme.card; border.width: 1; border.color: Theme.cardLine
                Column {
                    id: groundCol
                    x: 18; y: 14; width: parent.width - 36; spacing: 14
                    Repeater {
                        model: page.commands.ground
                        Row {
                            width: parent.width; spacing: 16
                            Rectangle {
                                width: 170; height: 32; radius: 8
                                color: Qt.rgba(Theme.cyan.r, Theme.cyan.g, Theme.cyan.b, 0.10)
                                border.width: 1; border.color: Qt.rgba(Theme.cyan.r, Theme.cyan.g, Theme.cyan.b, 0.35)
                                anchors.verticalCenter: parent.verticalCenter
                                Text {
                                    anchors.centerIn: parent
                                    text: modelData.btn
                                    color: Theme.cyan
                                    font.family: Theme.fontDisplay; font.variableAxes: ({ "wght": 700 })
                                    font.pixelSize: 13; font.weight: Font.Bold
                                }
                            }
                            Column {
                                width: parent.width - 186; spacing: 2
                                anchors.verticalCenter: parent.verticalCenter
                                Text {
                                    text: modelData.name
                                    color: "#ffffff"
                                    font.family: Theme.fontText; font.pixelSize: 14; font.weight: Font.Bold
                                }
                                Text {
                                    width: parent.width; text: modelData.desc
                                    wrapMode: Text.WordWrap; color: Theme.textDim
                                    font.family: Theme.fontText; font.pixelSize: 12; lineHeight: 1.3
                                }
                            }
                        }
                    }
                }
            }

            // ---- Category 3: Sensors, Camera & Touchpad -----------------------------------
            SectionTitle { text: Theme.tr("guides_sec_sensor"); accent: Theme.neon }
            Rectangle {
                width: parent.width
                height: sensorCol.implicitHeight + 28
                radius: 14; color: Theme.card; border.width: 1; border.color: Theme.cardLine
                Column {
                    id: sensorCol
                    x: 18; y: 14; width: parent.width - 36; spacing: 14
                    Repeater {
                        model: page.commands.sensor
                        Row {
                            width: parent.width; spacing: 16
                            Rectangle {
                                width: 170; height: 32; radius: 8
                                color: Qt.rgba(Theme.neon.r, Theme.neon.g, Theme.neon.b, 0.10)
                                border.width: 1; border.color: Qt.rgba(Theme.neon.r, Theme.neon.g, Theme.neon.b, 0.35)
                                anchors.verticalCenter: parent.verticalCenter
                                Text {
                                    anchors.centerIn: parent
                                    text: modelData.btn
                                    color: Theme.neon
                                    font.family: Theme.fontDisplay; font.variableAxes: ({ "wght": 700 })
                                    font.pixelSize: 12; font.weight: Font.Bold
                                }
                            }
                            Column {
                                width: parent.width - 186; spacing: 2
                                anchors.verticalCenter: parent.verticalCenter
                                Text {
                                    text: modelData.name
                                    color: "#ffffff"
                                    font.family: Theme.fontText; font.pixelSize: 14; font.weight: Font.Bold
                                }
                                Text {
                                    width: parent.width; text: modelData.desc
                                    wrapMode: Text.WordWrap; color: Theme.textDim
                                    font.family: Theme.fontText; font.pixelSize: 12; lineHeight: 1.3
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
