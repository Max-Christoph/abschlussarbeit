import 'package:mysql1/mysql1.dart';
import '../models/inventory_item.dart';

class InventoryService {
  String dbUsername;
  String dbPassword;
  String dbAddress;

  InventoryService(this.dbUsername, this.dbPassword, this.dbAddress);

  Future<List<InventoryItem>> getInventory(String username, String token) async {
    try {
      final conn = await MySqlConnection.connect(ConnectionSettings(
        host: dbAddress,
        port: 3306,
        user: dbUsername,
        db: 'FoodOrganizer',
        password: dbPassword,
      ));

      var results = await conn.query(
        'SELECT * FROM inventory WHERE user_id = (SELECT id FROM users WHERE username = ? AND token = ?)', 
        [username, token]
      );

      return results.map((row) {
        return InventoryItem(
          barcode: row[1],
          productName: row[2],
          expiryDate: row[3],
          notes: row[4],
          addedDate: row[5],
        );
      }).toList();
    } catch (e) {
      print('Error fetching inventory: $e');
      return [];
    }
  }

  Future<bool> addItem(String username, String token, InventoryItem item) async {
    try {
      final conn = await MySqlConnection.connect(ConnectionSettings(
        host: dbAddress,
        port: 3306,
        user: dbUsername,
        db: 'FoodOrganizer',
        password: dbPassword,
      ));

      var result = await conn.query('INSERT INTO inventory (user_id, product_name, expiry_date, notes, added_date) VALUES ((SELECT id FROM users WHERE username = ?), ?, ?, ?, ?)', [
        username,
        item.productName,
        item.expiryDate,
        item.notes,
        item.addedDate,
      ]);

      return result.insertId != null; // Überprüfen, ob der Einfügevorgang erfolgreich war
    } catch (e) {
      print('Error adding item: $e');
      return false;
    }
  }
}