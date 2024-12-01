<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS, DELETE');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
header('Content-Type: application/json');

class Update {
    public function updateItemStock($data) {
        global $conn;
        $inventory_id = $data['inventory_id'];
        $stock_quantity = $data['stock_quantity'];

        $sql = "UPDATE inventory SET stock_quantity = :stock_quantity, last_updated = NOW() WHERE inventory_id = :inventory_id";
        $stmt = $conn->prepare($sql);
        $stmt->bindParam(':inventory_id', $inventory_id);
        $stmt->bindParam(':stock_quantity', $stock_quantity);

        try {
            $stmt->execute();
            
            // Fetch the updated record to get the new timestamp
            $sql = "SELECT last_updated FROM inventory WHERE inventory_id = :inventory_id";
            $stmt = $conn->prepare($sql);
            $stmt->bindParam(':inventory_id', $inventory_id);
            $stmt->execute();
            $result = $stmt->fetch(PDO::FETCH_ASSOC);
            
            return [
                "status" => true, 
                "message" => "Item stock updated successfully",
                "last_updated" => $result['last_updated']
            ];
        } catch (PDOException $e) {
            return ["status" => false, "message" => "Failed to update item stock: " . $e->getMessage()];
        }
    }

    public function updateMenuItem($data) {
        global $conn;
        
        try {
            if (!isset($data['product_id'])) {
                return [
                    "status" => false,
                    "message" => "Product ID is required"
                ];
            }

            // Check for existing product with same details but different ID
            $checkSql = "SELECT * FROM product WHERE 
                        name = :name AND 
                        category = :category AND 
                        price = :price AND
                        size = :size AND
                        product_id != :product_id";
            
            $checkStmt = $conn->prepare($checkSql);
            $checkParams = [
                ':name' => $data['name'],
                ':category' => $data['category'],
                ':price' => $data['price'],
                ':size' => $data['size'] ?? 'Standard',
                ':product_id' => $data['product_id']
            ];
            
            $checkStmt->execute($checkParams);
            
            if ($checkStmt->fetch()) {
                return [
                    "status" => false,
                    "message" => "A similar product already exists",
                    "duplicate" => true
                ];
            }

            // If no duplicate found, proceed with update
            $sql = "UPDATE product SET 
                    name = :name,
                    price = :price,
                    category = :category,
                    size = :size";
            
            if (isset($data['image']) && !empty($data['image'])) {
                $sql .= ", image = :image";
            }
            
            $sql .= " WHERE product_id = :product_id";
            
            $stmt = $conn->prepare($sql);
            
            // Always use the provided size or 'Standard' as default
            $size = isset($data['size']) && !empty($data['size']) ? $data['size'] : 'Standard';
            
            $params = [
                ':name' => $data['name'],
                ':price' => $data['price'],
                ':category' => $data['category'],
                ':size' => $size,
                ':product_id' => $data['product_id']
            ];
            
            if (isset($data['image']) && !empty($data['image'])) {
                $params[':image'] = $data['image'];
            }
            
            $stmt->execute($params);
            
            return [
                "status" => true,
                "message" => "Menu item updated successfully"
            ];
        } catch (PDOException $e) {
            error_log('Database error: ' . $e->getMessage());
            return [
                "status" => false,
                "message" => "Failed to update menu item: " . $e->getMessage()
            ];
        }
    }

    public function updateProductIngredient($data) {
        global $conn;
        
        if (!isset($data['product_ingredient_id'])) {
            return [
                "status" => false,
                "message" => "Product ingredient ID is required",
                "data" => null
            ];
        }

        try {
            $conn->beginTransaction();
            
            $stmt = $conn->prepare("UPDATE product_ingredients 
                                   SET quantity_needed = :quantity_needed,
                                       unit_of_measure = :unit_of_measure
                                   WHERE product_ingredient_id = :product_ingredient_id");
            
            $stmt->bindParam(':product_ingredient_id', $data['product_ingredient_id']);
            $stmt->bindParam(':quantity_needed', $data['quantity_needed']);
            $stmt->bindParam(':unit_of_measure', $data['unit_of_measure']);
            $stmt->execute();
            
            if ($stmt->rowCount() === 0) {
                $conn->rollBack();
                return [
                    "status" => false, 
                    "message" => "No ingredient found to update",
                    "data" => null
                ];
            }
            
            $conn->commit();
            return [
                "status" => true, 
                "message" => "Product ingredient updated successfully",
                "data" => null
            ];
            
        } catch (PDOException $e) {
            $conn->rollBack();
            return [
                "status" => false, 
                "message" => "Failed to update product ingredient: " . $e->getMessage(),
                "data" => null
            ];
        }
    }
    
}
