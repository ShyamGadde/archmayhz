import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
  implicitHeight: powerButton.height
  implicitWidth: powerButton.width
  Button {
    id: powerButton
    height: inputHeight * 1.5
    width: inputHeight * 1.5
    hoverEnabled: true
    icon {
      source: Qt.resolvedUrl("../icons/power.svg")
      height: height
      width: width
      color: config.crust
    }
    background: Rectangle {
      id: powerButtonBackground
      radius: 3
      color: config.red
    }
    states: [
      State {
        name: "hovered"
        when: powerButton.hovered
        PropertyChanges {
          target: powerButtonBackground
          color: config.blue
        }
      }
    ]
    transitions: Transition {
      PropertyAnimation {
        properties: "color"
        duration: 300
      }
    }
    onClicked: sddm.powerOff()
  }
}
