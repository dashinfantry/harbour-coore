import QtQuick 2.0
import QtQuick.LocalStorage 2.0

ListModel {
     id: model
     property int nPrice
     property int nDate
     property int nType

     function __db()
     {
         return LocalStorage.openDatabaseSync("CooreDB", "0.1", "The Local Coore Bank", 1000);
     }
     function __ensureTables(tx)
     {
         tx.executeSql('CREATE TABLE IF NOT EXISTS favorites(location TEXT)', []);
     }

     function fillModel() {
         __db().transaction(
             function(tx) {
                 __ensureTables(tx);
                 var rs = tx.executeSql("SELECT location FROM favorites ORDER BY location DESC", []);
                 model.clear();
                 if (rs.rows.length > 0) {
                     for (var i=0; i<rs.rows.length; ++i) {
                         model.append(rs.rows.item(i))
                     }
                 }
             }
         )
     }

     function addItem(location) {
              __db().transaction(
                  function(tx) {
                      __ensureTables(tx);
                      tx.executeSql("INSERT INTO favorites VALUES(?)", [location]);
                      fillModel();
                  }
              )
          }
     function deleteItem(index, location) {
              __db().transaction(
                  function(tx) {
                      tx.executeSql("DELETE FROM favorites WHERE location=?", [location]);
                      model.remove(index);
                  }
              )
          }



     Component.onCompleted: {
         fillModel();
     }
 }
