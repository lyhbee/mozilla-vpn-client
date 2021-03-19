/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import QtQuick 2.0
import QtQuick.Controls 2.5
import Mozilla.VPN 1.0
import "../themes/themes.js" as Theme

CheckBox {
    id: vpnSettingsToggle

    property var toggleColor: Theme.vpnToggleConnected
    property var uiState: Theme.uiState
    property alias forceFocus: vpnSettingsToggle.focus
    property var toolTipTitle

    height: 24
    width: 45
    states: [
        State {
            when: checked

            PropertyChanges {
                target: vpnSettingsToggle
                toggleColor: Theme.vpnToggleConnected
            }

            PropertyChanges {
                target: cursor
                x: 24
            }

        },

        State {
            when: !checked

            PropertyChanges {
                target: vpnSettingsToggle
                toggleColor: Theme.vpnToggleDisconnected

            }

            PropertyChanges {
                target: cursor
                x: 3
            }
        }
    ]

    VPNToolTip {
        text: toolTipTitle
    }


    transitions: [
        Transition {
            NumberAnimation {
                target: cursor
                property: "x"
                duration: 200
            }
        }
    ]

    VPNFocusBorder {
        id: focusHandler

        anchors.fill: hoverPressHandler
        border.color: toggleColor.focusBorder
        color: "transparent"
        anchors.margins: 1
        radius: 50
        opacity: vpnSettingsToggle.activeFocus ? 1: 0
    }

    Rectangle {
        id: cursor

        height: 18
        width: 18
        radius: 9
        color: Theme.white
        z: 1
        anchors.verticalCenter: vpnSettingsToggle.verticalCenter
    }

    VPNMouseArea {
        id: mouseArea

        anchors.fill: hoverPressHandler
        targetEl: hoverPressHandler
    }

    Rectangle {
        id: hoverPressHandler

        color: "#C2C2C2"
        opacity: 0
        z: -1
        anchors.fill: vpnSettingsToggle
        radius: height / 2
        anchors.margins: vpnSettingsToggle.focus ? -5 : -4

        states: [
            State {
                name: uiState.stateHovered
                PropertyChanges {
                    target: hoverPressHandler
                    opacity: 0.2;

                }
            },
            State {
                name: uiState.statePressed
                PropertyChanges {
                    target: hoverPressHandler
                    opacity: .3
                }
            }
        ]

        transitions: [
            Transition {
                PropertyAnimation {
                    target: hoverPressHandler
                    property: "opacity"
                    duration: 200
                }
            }

        ]
    }

    focusPolicy: Qt.StrongFocus

    function handleKeyClick() {
        vpnSettingsToggle.clicked()
    }

    Keys.onPressed: {
        if (event.key === Qt.Key_Return || event.key === Qt.Key_Space)
            uiPlaceholder.state = uiState.statePressed;
    }

    Keys.onReleased: {
        if (event.key === Qt.Key_Return || event.key === Qt.Key_Space)
            handleKeyClick();
            uiPlaceholder.state = uiState.stateDefault;
    }

    Rectangle {
        id: uiPlaceholder /* Binding loop hack-around */
        height: 24
        width: 45
        z: 1
        color: "transparent"
    }

    indicator:  VPNUIStates {
        id: toggleBackground
        itemToFocus: vpnSettingsToggle
        itemToAnchor: uiPlaceholder
        colorScheme: toggleColor
        radius: 50
        showFocusRings: false
        opacity: VPNController.state === VPNController.StateOff ? .6 : 1
    }
}
