import QtQuick 2.0
import Sailfish.Silica 1.0
import ".."
import "../js/locations.js" as Locations
Page {
    id: oneLocation

    property string locationTitle
    property string loadingCircle
    property string noData: "False"
    property string locationID
    property variant menus
    property variant locationInfos

    Column {
        id: headerContainer
        width: oneLocation.width
        spacing: Theme.paddingSmall

        PageHeader {
            id: pageHeader
            title: oneLocation.locationTitle
        }
        SectionHeader {
            id: locationAdress
            font.pixelSize: Theme.fontSizeMedium
            color: Theme.secondaryHighlightColor
            wrapMode: Text.Wrap
        }

        Row {
            spacing: Theme.paddingLarge
            anchors.horizontalCenter: parent.horizontalCenter
            Label {
                x: Theme.paddingLarge
                id: dayLabel
                text: qsTr("Today")
                wrapMode: Text.Wrap
                color: Theme.secondaryColor
                font.pixelSize: Theme.fontSizeLarge
            }
        }
    }

        SilicaListView {
             id: listView
             anchors.fill: parent
             header: Item {
                 id: header
                 width: headerContainer.width
                 height: headerContainer.height
                 Component.onCompleted: headerContainer.parent = header
             }
             PullDownMenu {
                 MenuItem {
                     text: qsTr("Add to Favorites")
                     onClicked: favoritesBank.addItem(oneLocation.locationTitle, oneLocation.locationID)
                 }
             }

             model: ListModel {
                id: listModel
             }

             delegate: BackgroundItem {
                id: delegate

                onClicked: {
                    pageStack.push(Qt.resolvedUrl('MenuPage.qml'), {foodTitle: model.title, locationTitle: oneLocation.locationTitle, foodPrice: model.price, locationID: oneLocation.locationID})
                }


                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    id: menuLabel
                    text: model.title
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeLarge
                    x: Theme.paddingLarge
                }


              }
             ViewPlaceholder {
                 id: errorPlace
                 text: qsTr("No Menus")
                 hintText: qsTr("no connection or no menu available")
                 enabled: oneLocation.noData == "True"
             }

        }

        Component.onCompleted: {
            oneLocation.menus =  Locations.get_all_menus(oneLocation.locationID)
            if (oneLocation.menus.length === 0){
                oneLocation.noData = "True"
            }
            for (var i=0; i<oneLocation.menus.length; i++) {
                listModel.append({"title": oneLocation.menus[i].title, "price": oneLocation.menus[i].price});
            }

            oneLocation.locationInfos =  Locations.get_one_location(oneLocation.locationID)
            locationAdress.text = oneLocation.locationInfos[0].zip +" "+ oneLocation.locationInfos[0].city

        }

}
