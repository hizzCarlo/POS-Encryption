<?php

error_reporting(E_ALL);
ini_set('display_errors', '0');

header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
header('Content-Type: application/json');
header('Access-Control-Max-Age: 86400'); // 24 hours for preflight cache

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
} 

require_once __DIR__ . '/config.php';
require_once 'modules/post.php';
require_once 'modules/update.php';
require_once 'modules/delete.php';
require_once 'modules/get.php';
require_once 'helpers/Encryption.php';

$post = new Post($conn);
$update = new Update($conn);
$delete = new Delete($conn);
$get = new Get($conn);
$encryption = new Encryption();

if (isset($_REQUEST['request'])) {
    $request = explode('/', $_REQUEST['request']);
} else {
    // Try to parse from the path
    $path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
    $request = explode('/', trim($path, '/'));
    // Remove 'api' from the beginning if present
    if ($request[0] === 'api') {
        array_shift($request);
    }
}

// At the top of the file after other headers
define('DEBUG', true); // Set to false in production

// Update handleError function
function handleError($error) {
    error_log("API Error: " . $error->getMessage());
    echo json_encode([
        "status" => false,
        "message" => DEBUG ? $error->getMessage() : "Server error occurred",
        "debug" => DEBUG ? [
            "message" => $error->getMessage(),
            "file" => $error->getFile(),
            "line" => $error->getLine()
        ] : null
    ]);
    exit;
}

// Set error handler
set_error_handler(function($errno, $errstr, $errfile, $errline) {
    throw new ErrorException($errstr, $errno, 0, $errfile, $errline);
});

// Add this helper function at the top
function sendEncryptedResponse($data) {
    global $encryption;
    echo json_encode([
        "status" => true,
        "data" => $encryption->encrypt($data)
    ]);
}

// Wrap main logic in try-catch
try {
    switch ($_SERVER['REQUEST_METHOD']) {
        case 'POST':
            switch ($request[0]) {
                case 'add-menu-item':
                    try {
                        $requestBody = json_decode(file_get_contents("php://input"), true);
                        $encryptedData = $requestBody['data'] ?? null;
                        
                        if (!$encryptedData) {
                            throw new Exception('No encrypted data received');
                        }
                        
                        $data = $encryption->decrypt($encryptedData);
                        $result = $post->addMenuItem($data);
                        
                        echo json_encode([
                            "status" => true,
                            "data" => $encryption->encrypt($result)
                        ]);
                    } catch (Exception $e) {
                        echo json_encode([
                            "status" => false,
                            "message" => "Error processing request: " . $e->getMessage()
                        ]);
                    }
                    break;
                    
                case 'add-customer':
                    try {
                        $requestBody = json_decode(file_get_contents("php://input"), true);
                        $encryptedData = $requestBody['data'] ?? null;
                        
                        if (!$encryptedData) {
                            throw new Exception('No encrypted data received');
                        }
                        
                        $data = $encryption->decrypt($encryptedData);
                        $result = $post->addCustomer($data);
                        
                        echo json_encode([
                            "status" => true,
                            "data" => $encryption->encrypt($result)
                        ]);
                    } catch (Exception $e) {
                        echo json_encode([
                            "status" => false,
                            "message" => "Error processing request: " . $e->getMessage()
                        ]);
                    }
                    break;
                    
                case 'add-receipt':
                    try {
                        $requestBody = json_decode(file_get_contents("php://input"), true);
                        $encryptedData = $requestBody['data'] ?? null;
                        
                        if (!$encryptedData) {
                            throw new Exception('No encrypted data received');
                        }
                        
                        $data = $encryption->decrypt($encryptedData);
                        $result = $post->addReceipt($data);
                        
                        echo json_encode([
                            "status" => true,
                            "data" => $encryption->encrypt($result)
                        ]);
                    } catch (Exception $e) {
                        echo json_encode([
                            "status" => false,
                            "message" => "Error processing request: " . $e->getMessage()
                        ]);
                    }
                    break;
                    
                case 'logout':
                    session_start();
                    session_destroy();
                    echo json_encode(["status" => true, "message" => "Logged out successfully"]);
                    break;
                    
                case 'add-product-ingredient':
                    try {
                        $requestBody = json_decode(file_get_contents("php://input"), true);
                        $encryptedData = $requestBody['data'] ?? null;
                        
                        if (!$encryptedData) {
                            throw new Exception('No encrypted data received');
                        }
                        
                        $data = $encryption->decrypt($encryptedData);
                        $result = $post->addProductIngredient($data);
                        
                        echo json_encode([
                            "status" => true,
                            "data" => $encryption->encrypt($result)
                        ]);
                    } catch (Exception $e) {
                        echo json_encode([
                            "status" => false,
                            "message" => "Error processing request: " . $e->getMessage()
                        ]);
                    }
                    break;
                    
                case 'add-item-stock':
                    try {
                        $requestBody = json_decode(file_get_contents("php://input"), true);
                        $encryptedData = $requestBody['data'] ?? null;
                        
                        if (!$encryptedData) {
                            throw new Exception('No encrypted data received');
                        }
                        
                        $data = $encryption->decrypt($encryptedData);
                        $result = $post->addItemStock($data);
                        echo json_encode([
                            "status" => true,
                            "data" => $encryption->encrypt($result)
                        ]);
                    } catch (Exception $e) {
                        echo json_encode([
                            "status" => false,
                            "message" => "Error processing request: " . $e->getMessage()
                        ]);
                    }
                    break;
                    
                case 'add-account':
                    try {
                        // Get encrypted data from request body
                        $requestBody = json_decode(file_get_contents("php://input"), true);
                        $encryptedData = $requestBody['data'] ?? null;
                        
                        if (!$encryptedData) {
                            throw new Exception('No encrypted data received');
                        }

                        error_log("Received encrypted data: " . print_r($encryptedData, true));
                        
                        // Decrypt the data
                        $data = $encryption->decrypt($encryptedData);
                        error_log("Decrypted data: " . print_r($data, true));
                        
                        if (!$data || !isset($data['username']) || !isset($data['password'])) {
                            error_log("Invalid data structure: " . print_r($data, true));
                            echo json_encode([
                                "status" => false,
                                "message" => "Invalid or missing data"
                            ]);
                            break;
                        }
                        
                        // Process registration
                        $result = $post->registerUser($data);
                        
                        // Encrypt the response
                        echo json_encode([
                            "status" => true,
                            "data" => $encryption->encrypt($result)
                        ]);
                    } catch (Exception $e) {
                        echo json_encode([
                            "status" => false,
                            "message" => "Error processing request: " . $e->getMessage()
                        ]);
                    }
                    break;
                    
                case 'login':
                    try {
                        $requestBody = json_decode(file_get_contents("php://input"), true);
                        $encryptedData = $requestBody['data'] ?? null;
                        
                        if (!$encryptedData) {
                            throw new Exception('No encrypted data received');
                        }
                        
                        $data = $encryption->decrypt($encryptedData);
                        $result = $post->loginUser($data);
                        echo json_encode([
                            "status" => true,
                            "data" => $encryption->encrypt($result)
                        ]);
                    } catch (Exception $e) {
                        echo json_encode([
                            "status" => false,
                            "message" => "Error processing request: " . $e->getMessage()
                        ]);
                    }
                    break;
                    
                case 'add-to-cart':
                    try {
                        $requestBody = json_decode(file_get_contents("php://input"), true);
                        $encryptedData = $requestBody['data'] ?? null;
                        
                        if (!$encryptedData) {
                            throw new Exception('No encrypted data received');
                        }
                        
                        $data = $encryption->decrypt($encryptedData);
                        $result = $post->addToCart($data);
                        echo json_encode([
                            "status" => true,
                            "data" => $encryption->encrypt($result)
                        ]);
                    } catch (Exception $e) {
                        echo json_encode([
                            "status" => false,
                            "message" => "Error processing request: " . $e->getMessage()
                        ]);
                    }
                    break;
                    
                case 'create-order':
                    try {
                        $requestBody = json_decode(file_get_contents("php://input"), true);
                        $encryptedData = $requestBody['data'] ?? null;
                        
                        if (!$encryptedData) {
                            throw new Exception('No encrypted data received');
                        }
                        
                        $data = $encryption->decrypt($encryptedData);
                        $result = $post->createOrder($data);
                        
                        echo json_encode([
                            "status" => true,
                            "data" => $encryption->encrypt($result)
                        ]);
                    } catch (Exception $e) {
                        echo json_encode([
                            "status" => false,
                            "message" => "Error processing request: " . $e->getMessage()
                        ]);
                    }
                    break;
                    
                case 'add-sale':
                    try {
                        $requestBody = json_decode(file_get_contents("php://input"), true);
                        $encryptedData = $requestBody['data'] ?? null;
                        
                        if (!$encryptedData) {
                            throw new Exception('No encrypted data received');
                        }
                        
                        $data = $encryption->decrypt($encryptedData);
                        $result = $post->addSale($data);
                        
                        echo json_encode([
                            "status" => true,
                            "data" => $encryption->encrypt($result)
                        ]);
                    } catch (Exception $e) {
                        echo json_encode([
                            "status" => false,
                            "message" => "Error processing request: " . $e->getMessage()
                        ]);
                    }
                    break;
                    
                case 'upload-image':
                    try {
                        if (!isset($_FILES['image'])) {
                            throw new Exception('No image file received');
                        }

                        $file = $_FILES['image'];
                        $fileName = time() . '_' . basename($file['name']);
                        $targetPath = __DIR__ . '/../uploads/' . $fileName;

                        // Check if it's actually an image
                        $check = getimagesize($file['tmp_name']);
                        if ($check === false) {
                            throw new Exception('File is not an image');
                        }

                        // Move uploaded file
                        if (move_uploaded_file($file['tmp_name'], $targetPath)) {
                            echo json_encode([
                                'status' => true,
                                'filename' => $fileName,
                                'message' => 'File uploaded successfully'
                            ]);
                        } else {
                            throw new Exception('Failed to move uploaded file');
                        }
                    } catch (Exception $e) {
                        echo json_encode([
                            'status' => false,
                            'message' => $e->getMessage()
                        ]);
                    }
                    break;
                    
                default:
                    // For other POST requests, use JSON
                    $data = json_decode(file_get_contents("php://input"), true);
                    switch ($request[0]) {
                        case 'add-account':
                            echo json_encode($post->registerUser($data));
                            break;
                        case 'login':
                            echo json_encode($post->loginUser($data));
                            break;
                        case 'add-to-cart':
                            echo json_encode($post->addToCart($data));
                            break;
                        case 'create-order':
                            echo json_encode($post->createOrder($data));
                            break;
                        case 'add-sale':
                            echo json_encode($post->addSale($data));
                            break;
                        default:
                            echo json_encode(["error" => "This is forbidden"]);
                            http_response_code(403);
                            break;
                    }
                    break;
            }
            break;
        case 'GET':
            switch ($request[0]) {
                case 'get-menu-items':
                    try {
                        $items = $get->getMenuItems();
                        echo json_encode([
                            "status" => true,
                            "data" => $encryption->encrypt($items)
                        ]);
                    } catch (Exception $e) {
                        echo json_encode([
                            "status" => false,
                            "message" => "Error fetching menu items: " . $e->getMessage()
                        ]);
                    }
                    break;
                case 'get-items':
                    try {
                        $items = $get->getItems();
                        echo json_encode([
                            "status" => true,
                            "data" => $encryption->encrypt($items)
                        ]);
                    } catch (Exception $e) {
                        echo json_encode([
                            "status" => false,
                            "message" => "Error fetching items: " . $e->getMessage()
                        ]);
                    }
                    break;
                case 'get-sales-data':
                    try {
                        $salesData = $get->getSalesData();
                        // Encrypt the response
                        echo json_encode([
                            "status" => true,
                            "data" => $encryption->encrypt($salesData)
                        ]);
                    } catch (Exception $e) {
                        echo json_encode([
                            "status" => false,
                            "message" => "Error fetching sales data: " . $e->getMessage()
                        ]);
                    }
                    break;
                case 'get-product-ingredients':
                    if (!isset($_GET['product_id'])) {
                        echo json_encode(["status" => false, "message" => "Product ID is required"]);
                        exit;
                    }
                    
                    $product_id = $_GET['product_id'];
                    try {
                        $ingredients = $get->getProductIngredients($product_id);
                        echo json_encode([
                            "status" => true,
                            "data" => $encryption->encrypt($ingredients)
                        ]);
                    } catch (Exception $e) {
                        echo json_encode([
                            "status" => false,
                            "message" => "Error fetching ingredients: " . $e->getMessage()
                        ]);
                    }
                    break;
                case 'check-product-availability':
                    if (!isset($_GET['product_id'])) {
                        echo json_encode(["status" => false, "message" => "Product ID is required"]);
                        exit;
                    }
                    echo json_encode($get->checkIngredientAvailability($_GET['product_id'], 1));
                    break;
                case 'get-products-using-ingredient':
                    $inventory_id = $_GET['inventory_id'] ?? null;
                    if ($inventory_id) {
                        $result = $get->getProductsUsingIngredient($inventory_id);
                        echo json_encode($result);
                    } else {
                        echo json_encode([
                            "status" => false,
                            "message" => "Inventory ID is required"
                        ]);
                    }
                    break;
                case 'get-cart-item':
                    if (!isset($_GET['product_id']) || !isset($_GET['user_id'])) {
                        echo json_encode([
                            "status" => false,
                            "message" => "Product ID and User ID are required"
                        ]);
                        break;
                    }
                    echo json_encode($get->getCartItem($_GET['product_id'], $_GET['user_id']));
                    break;
                case 'get-cart-items':
                    if (!isset($_GET['user_id'])) {
                        echo json_encode([
                            "status" => false,
                            "message" => "User ID is required"
                        ]);
                        break;
                    }
                    try {
                        $cartItems = $get->getCartItems($_GET['user_id']);
                        echo json_encode([
                            "status" => true,
                            "data" => $encryption->encrypt($cartItems)
                        ]);
                    } catch (Exception $e) {
                        echo json_encode([
                            "status" => false,
                            "message" => "Error fetching cart items: " . $e->getMessage()
                        ]);
                    }
                    break;
                case 'check-ingredient-availability':
                    $product_id = $_GET['product_id'] ?? null;
                    $quantity = $_GET['quantity'] ?? 1;
                    
                    if ($product_id) {
                        $result = $get->checkIngredientAvailability($product_id, $quantity);
                        // Encrypt the response
                        $encryptedResponse = $encryption->encrypt($result);
                        echo json_encode(["status" => true, "data" => $encryptedResponse]);
                        exit;
                    }
                    break;
                case 'get-batch-product-ingredients':
                    $product_ids = json_decode($_GET['product_ids']);
                    echo json_encode($get->getBatchProductIngredients($product_ids));
                    break;
                case 'get-session-key':
                    session_start();
                    echo json_encode([
                        "status" => true,
                        "key" => $_ENV['ENCRYPTION_KEY']
                    ]);
                    break;
                case 'test-ingredient-availability':
                    $product_id = $_GET['product_id'] ?? null;
                    $quantity = $_GET['quantity'] ?? 1;
                    
                    if ($product_id) {
                        $result = $get->checkIngredientAvailability($product_id, $quantity);
                        echo json_encode($result);
                        exit;
                    }
                    break;
                default:
                    echo json_encode(["error" => "Invalid request"]);
                    http_response_code(400);
                    break;
            }
            break;
        case 'PUT':
            switch ($request[0]) {
                case 'update-menu-item':
                    try {
                        $requestBody = json_decode(file_get_contents("php://input"), true);
                        $encryptedData = $requestBody['data'] ?? null;
                        
                        if (!$encryptedData) {
                            throw new Exception('No encrypted data received');
                        }
                        
                        $data = $encryption->decrypt($encryptedData);
                        $result = $update->updateMenuItem($data);
                        echo json_encode([
                            "status" => true,
                            "data" => $encryption->encrypt($result)
                        ]);
                    } catch (Exception $e) {
                        echo json_encode([
                            "status" => false,
                            "message" => "Error processing request: " . $e->getMessage()
                        ]);
                    }
                    break;
                case 'update-product-ingredient':
                    try {
                        $requestBody = json_decode(file_get_contents("php://input"), true);
                        $encryptedData = $requestBody['data'] ?? null;
                        
                        if (!$encryptedData) {
                            throw new Exception('No encrypted data received');
                        }
                        
                        $data = $encryption->decrypt($encryptedData);
                        $result = $update->updateProductIngredient($data);
                        
                        echo json_encode([
                            "status" => true,
                            "data" => $encryption->encrypt($result)
                        ]);
                    } catch (Exception $e) {
                        echo json_encode([
                            "status" => false,
                            "message" => "Error processing request: " . $e->getMessage()
                        ]);
                    }
                    break;
                case 'update-item-stock':
                    try {
                        $requestBody = json_decode(file_get_contents("php://input"), true);
                        $encryptedData = $requestBody['data'] ?? null;
                        
                        if (!$encryptedData) {
                            throw new Exception('No encrypted data received');
                        }
                        
                        $data = $encryption->decrypt($encryptedData);
                        $result = $update->updateItemStock($data);
                        
                        echo json_encode([
                            "status" => true,
                            "data" => $encryption->encrypt($result)
                        ]);
                    } catch (Exception $e) {
                        echo json_encode([
                            "status" => false,
                            "message" => "Error processing request: " . $e->getMessage()
                        ]);
                    }
                    break;
                default:
                    $data = json_decode(file_get_contents("php://input"), true);
                    switch ($request[0]) {
                        case 'update-item-stock':
                            echo json_encode($update->updateItemStock($data));
                            break;
                        default:
                            echo json_encode(["error" => "This is forbidden"]);
                            http_response_code(403);
                            break;
                    }
                    break;
            }
            break;
        case 'DELETE':
            $data = json_decode(file_get_contents("php://input"), true);
            switch ($request[0]) {
                case 'delete-item-stock':
                    echo json_encode($delete->deleteItemStock($data));
                    break;
                case 'delete-menu-item':
                    try {
                        $requestBody = json_decode(file_get_contents("php://input"), true);
                        $encryptedData = $requestBody['data'] ?? null;
                        
                        if (!$encryptedData) {
                            throw new Exception('No encrypted data received');
                        }
                        
                        $data = $encryption->decrypt($encryptedData);
                        $result = $delete->deleteMenuItem($data);
                        
                        echo json_encode([
                            "status" => true,
                            "data" => $encryption->encrypt($result)
                        ]);
                    } catch (Exception $e) {
                        echo json_encode([
                            "status" => false,
                            "message" => "Error processing request: " . $e->getMessage()
                        ]);
                    }
                    break;
                case 'delete-order':
                    echo json_encode($delete->deleteOrder($data));
                    break;
                case 'delete-all-orders':
                    echo json_encode($delete->deleteAllOrders());
                    break;
                case 'delete-product-ingredient':
                    try {
                        $requestBody = json_decode(file_get_contents("php://input"), true);
                        $encryptedData = $requestBody['data'] ?? null;
                        
                        if (!$encryptedData) {
                            throw new Exception('No encrypted data received');
                        }
                        
                        $data = $encryption->decrypt($encryptedData);
                        $result = $delete->deleteProductIngredient($data);
                        
                        echo json_encode([
                            "status" => true,
                            "data" => $encryption->encrypt($result)
                        ]);
                    } catch (Exception $e) {
                        echo json_encode([
                            "status" => false,
                            "message" => "Error processing request: " . $e->getMessage()
                        ]);
                    }
                    break;
                case 'clear-cart':
                    if (!isset($data['user_id'])) {
                        echo json_encode([
                            "status" => false,
                            "message" => "User ID is required"
                        ]);
                        break;
                    }
                    echo json_encode($delete->clearCart($data['user_id']));
                    break;
                case 'remove-from-cart':
                    if (!isset($data['product_id']) || !isset($data['user_id'])) {
                        echo json_encode([
                            "status" => false,
                            "message" => "Product ID and User ID are required"
                        ]);
                        break;
                    }
                    echo json_encode($delete->removeFromCart($data['product_id'], $data['user_id']));
                    break;
                default:
                    echo json_encode(["error" => "This is forbidden"]);
                    http_response_code(403);
                    break;
            }
            break;
        default:
            echo json_encode(["error" => "Method not available"]);
            http_response_code(404);
            break;
    }
} catch (Throwable $e) {
    handleError($e);
}
?>