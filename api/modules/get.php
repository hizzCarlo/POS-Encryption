<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS, DELETE');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
header('Content-Type: application/json');

class Get {
    public function getMenuItems() {
        global $conn;
        
        try {
            $sql = "SELECT * FROM product ORDER BY name";
            
            $stmt = $conn->prepare($sql);
            $stmt->execute();
            $items = $stmt->fetchAll(PDO::FETCH_ASSOC);
            
            foreach ($items as &$item) {
                if (isset($item['image']) && is_resource($item['image'])) {
                    $item['image'] = stream_get_contents($item['image']);
                }
            }
            
            return $items;
            
        } catch (PDOException $e) {
            error_log("Database error in getMenuItems: " . $e->getMessage());
            return [
                "status" => false,
                "message" => "Failed to fetch menu items",
                "error" => $e->getMessage()
            ];
        }
    }
    public function getItems() {
        global $conn;
        
        try {
            $sql = "SELECT inventory_id, item_name, stock_quantity, unit_of_measure, last_updated 
                    FROM inventory 
                    ORDER BY item_name";
            $stmt = $conn->prepare($sql);
            $stmt->execute();
            
            return [
                "status" => true,
                "data" => $stmt->fetchAll(PDO::FETCH_ASSOC)
            ];
        } catch (PDOException $e) {
            return [
                "status" => false,
                "message" => "Error fetching items: " . $e->getMessage()
            ];
        }
    }
    public function getSalesData() {
        global $conn;
        
        try {
            $sql = "SELECT 
                    o.order_id,
                    ua.username,
                    c.Name as customer_name,
                    c.total_amount as amount_paid,
                    o.total_amount,
                    o.order_date,
                    p.name as product_name,
                    p.price as unit_price,
                    oi.quantity,
                    (p.price * oi.quantity) as line_total
                FROM `order` o
                JOIN user_acc ua ON o.user_id = ua.User_id
                JOIN order_item oi ON o.order_id = oi.order_id
                JOIN product p ON oi.product_id = p.product_id
                JOIN customer c ON o.customer_id = c.customer_id
                ORDER BY o.order_date DESC";
            
            $stmt = $conn->prepare($sql);
            $stmt->execute();
            $results = $stmt->fetchAll(PDO::FETCH_ASSOC);
            
            // Group results by order_id for table display
            $groupedResults = [];
            foreach ($results as $row) {
                $orderId = $row['order_id'];
                if (!isset($groupedResults[$orderId])) {
                    $groupedResults[$orderId] = [
                        'order_id' => $row['order_id'],
                        'username' => $row['username'],
                        'customer_name' => $row['customer_name'],
                        'amount_paid' => $row['amount_paid'],
                        'total_amount' => $row['total_amount'],
                        'order_date' => $row['order_date'],
                        'products' => [],
                        'quantities' => []
                    ];
                }
                $groupedResults[$orderId]['products'][] = $row['product_name'];
                $groupedResults[$orderId]['quantities'][] = $row['quantity'];
            }
            
            // Format results for table display
            $formattedResults = array_map(function($group) {
                return [
                    'order_id' => $group['order_id'],
                    'username' => $group['username'],
                    'product_name' => implode(', ', $group['products']),
                    'quantity' => implode(', ', $group['quantities']),
                    'customer_name' => $group['customer_name'],
                    'amount_paid' => $group['amount_paid'],
                    'total_amount' => $group['total_amount'],
                    'order_date' => $group['order_date']
                ];
            }, $groupedResults);
            
            // Calculate chart data using actual unit prices and quantities
            $chartData = [];
            foreach ($results as $row) {
                $date = date('Y-m', strtotime($row['order_date'])); // For monthly data
                $product = $row['product_name'];
                $actualTotal = floatval($row['unit_price']) * floatval($row['quantity']); // Calculate using unit price
                
                if (!isset($chartData[$date])) {
                    $chartData[$date] = [];
                }
                if (!isset($chartData[$date][$product])) {
                    $chartData[$date][$product] = 0;
                }
                $chartData[$date][$product] += $actualTotal;
            }
            
            // Add daily chart data
            $dailyChartData = [];
            foreach ($results as $row) {
                $date = date('Y-m-d', strtotime($row['order_date']));
                $product = $row['product_name'];
                $actualTotal = floatval($row['unit_price']) * floatval($row['quantity']);
                
                if (!isset($dailyChartData[$date])) {
                    $dailyChartData[$date] = [];
                }
                if (!isset($dailyChartData[$date][$product])) {
                    $dailyChartData[$date][$product] = 0;
                }
                $dailyChartData[$date][$product] += $actualTotal;
            }
            
            // Add chart data to the response
            return [
                "status" => true,
                "data" => array_values($formattedResults),
                "chartData" => $chartData,
                "dailyChartData" => $dailyChartData
            ];
        } catch (PDOException $e) {
            return [
                "status" => false,
                "message" => "Failed to fetch sales data: " . $e->getMessage()
            ];
        }
    }
    public function checkIngredientAvailability($product_id, $requested_quantity) {
        global $conn;
        
        try {
            $sql = "SELECT i.item_name, i.stock_quantity, i.unit_of_measure as stock_unit,
                    pi.quantity_needed, pi.unit_of_measure as recipe_unit
                    FROM inventory i 
                    JOIN product_ingredients pi ON i.inventory_id = pi.inventory_id 
                    WHERE pi.product_id = :product_id";
            
            $stmt = $conn->prepare($sql);
            $stmt->bindParam(':product_id', $product_id);
            $stmt->execute();
            
            $ingredients = $stmt->fetchAll(PDO::FETCH_ASSOC);
            $max_possible_quantity = PHP_FLOAT_MAX;
            
            foreach ($ingredients as $ingredient) {
                $convertedQuantity = $this->convertUnits(
                    $ingredient['quantity_needed'],
                    $ingredient['recipe_unit'],
                    $ingredient['stock_unit']
                );
                
                // Calculate how many products can be made with this ingredient
                $possible_quantity = floor($ingredient['stock_quantity'] / $convertedQuantity);
                $max_possible_quantity = min($max_possible_quantity, $possible_quantity);
            }
            
            return [
                "status" => true,
                "max_possible_quantity" => $max_possible_quantity
            ];
            
        } catch (PDOException $e) {
            return [
                "status" => false,
                "message" => "Database error: " . $e->getMessage()
            ];
        }
    }
    private function convertUnits($value, $fromUnit, $toUnit) {
        if ($fromUnit === $toUnit) return $value;

        $conversions = [
            'mass' => [
                'grams' => 1,
                'kilograms' => 1000,
                'pounds' => 453.592,
                'ounces' => 28.3495
            ],
            'volume' => [
                'milliliters' => 1,
                'liters' => 1000,
                'cups' => 236.588,
                'tablespoons' => 14.7868,
                'teaspoons' => 4.92892
            ]
        ];

        $unitTypes = [
            'grams' => 'mass',
            'kilograms' => 'mass',
            'pounds' => 'mass',
            'ounces' => 'mass',
            'milliliters' => 'volume',
            'liters' => 'volume',
            'cups' => 'volume',
            'tablespoons' => 'volume',
            'teaspoons' => 'volume'
        ];

        // If units are pieces, no conversion needed
        if ($fromUnit === 'pieces' || $toUnit === 'pieces') {
            return $value;
        }

        // Get unit types
        $fromType = $unitTypes[$fromUnit] ?? null;
        $toType = $unitTypes[$toUnit] ?? null;

        // Check if units are of the same type
        if ($fromType !== $toType) {
            throw new Exception("Cannot convert between different types of units");
        }

        // Convert to base unit first
        $baseValue = $value * $conversions[$fromType][$fromUnit];
        
        // Then convert to target unit
        return $baseValue / $conversions[$fromType][$toUnit];
    }
    public function getProductIngredients($product_id) {
        global $conn;
        
        try {
            $sql = "SELECT pi.product_ingredient_id, pi.inventory_id, 
                    i.item_name as ingredient_name, pi.quantity_needed,
                    i.stock_quantity, i.unit_of_measure
                    FROM product_ingredients pi 
                    JOIN inventory i ON i.inventory_id = pi.inventory_id 
                    WHERE pi.product_id = :product_id";
            
            $stmt = $conn->prepare($sql);
            $stmt->bindParam(':product_id', $product_id);
            $stmt->execute();
            
            return [
                "status" => true,
                "data" => $stmt->fetchAll(PDO::FETCH_ASSOC)
            ];
        } catch (PDOException $e) {
            return [
                "status" => false,
                "message" => "Error fetching ingredients: " . $e->getMessage()
            ];
        }
    }
    public function getProductsUsingIngredient($inventory_id) {
        global $conn;
        
        try {
            $sql = "SELECT p.name as product_name, p.category, 
                    pi.quantity_needed, i.unit_of_measure
                    FROM product_ingredients pi 
                    JOIN product p ON p.product_id = pi.product_id
                    JOIN inventory i ON i.inventory_id = pi.inventory_id
                    WHERE pi.inventory_id = :inventory_id";
            
            $stmt = $conn->prepare($sql);
            $stmt->bindParam(':inventory_id', $inventory_id);
            $stmt->execute();
            
            $products = $stmt->fetchAll(PDO::FETCH_ASSOC);
            
            return [
                "status" => true,
                "data" => $products
            ];
        } catch (PDOException $e) {
            return [
                "status" => false,
                "message" => "Error fetching products: " . $e->getMessage()
            ];
        }
    }
    public function getCartItem($productId, $userId) {
        global $conn;
        
        try {
            $sql = "SELECT quantity FROM cart WHERE product_id = :product_id AND user_id = :user_id";
            $stmt = $conn->prepare($sql);
            $stmt->bindParam(':product_id', $productId);
            $stmt->bindParam(':user_id', $userId);
            $stmt->execute();
            
            $result = $stmt->fetch(PDO::FETCH_ASSOC);
            
            return [
                "status" => true,
                "data" => $result
            ];
        } catch (PDOException $e) {
            return [
                "status" => false,
                "message" => $e->getMessage()
            ];
        }
    }
    public function getCartItems($userId) {
        global $conn;
        
        try {
            $sql = "SELECT c.*, p.name, p.price, p.image, p.category 
                    FROM cart c 
                    JOIN product p ON c.product_id = p.product_id 
                    WHERE c.user_id = :user_id";
            
            $stmt = $conn->prepare($sql);
            $stmt->bindParam(':user_id', $userId);
            $stmt->execute();
            
            return [
                "status" => true,
                "data" => $stmt->fetchAll(PDO::FETCH_ASSOC)
            ];
        } catch (PDOException $e) {
            return [
                "status" => false,
                "message" => $e->getMessage()
            ];
        }
    }
    public function getMaxPossibleQuantity($product_id) {
        global $conn;
        
        try {
            $sql = "SELECT 
                    i.stock_quantity / pi.quantity_needed as possible_quantity,
                    i.unit_of_measure as stock_unit,
                    pi.unit_of_measure as recipe_unit
                    FROM product_ingredients pi
                    JOIN inventory i ON i.inventory_id = pi.inventory_id
                    WHERE pi.product_id = :product_id";
            
            $stmt = $conn->prepare($sql);
            $stmt->bindParam(':product_id', $product_id);
            $stmt->execute();
            
            $results = $stmt->fetchAll(PDO::FETCH_ASSOC);
            if (empty($results)) {
                return [
                    "status" => false,
                    "message" => "No recipe found for this product"
                ];
            }
            
            // Convert units and find minimum possible quantity
            $min_quantity = PHP_FLOAT_MAX;
            foreach ($results as $result) {
                $converted_quantity = $this->convertUnits(
                    $result['possible_quantity'],
                    $result['stock_unit'],
                    $result['recipe_unit']
                );
                $min_quantity = min($min_quantity, floor($converted_quantity));
            }
            
            return [
                "status" => true,
                "max_possible_quantity" => $min_quantity
            ];
            
        } catch (PDOException $e) {
            return [
                "status" => false,
                "message" => "Database error: " . $e->getMessage()
            ];
        }
    }
    public function getBatchProductIngredients($product_ids) {
        global $conn;
        
        try {
            $placeholders = str_repeat('?,', count($product_ids) - 1) . '?';
            $sql = "SELECT pi.product_id, pi.quantity_needed, i.stock_quantity, i.unit_of_measure
                    FROM product_ingredients pi 
                    JOIN inventory i ON i.inventory_id = pi.inventory_id 
                    WHERE pi.product_id IN ($placeholders)";
            
            $stmt = $conn->prepare($sql);
            $stmt->execute($product_ids);
            $ingredients = $stmt->fetchAll(PDO::FETCH_ASSOC);
            
            // Group ingredients by product_id
            $productAvailability = [];
            foreach ($ingredients as $ingredient) {
                $productId = $ingredient['product_id'];
                if (!isset($productAvailability[$productId])) {
                    $productAvailability[$productId] = [
                        'isAvailable' => true,
                        'ingredients' => []
                    ];
                }
                
                $productAvailability[$productId]['ingredients'][] = $ingredient;
                if ($ingredient['stock_quantity'] < $ingredient['quantity_needed']) {
                    $productAvailability[$productId]['isAvailable'] = false;
                }
            }
            
            return [
                "status" => true,
                "data" => $productAvailability
            ];
            
        } catch (PDOException $e) {
            return [
                "status" => false,
                "message" => "Error fetching ingredients: " . $e->getMessage()
            ];
        }
    }
}
