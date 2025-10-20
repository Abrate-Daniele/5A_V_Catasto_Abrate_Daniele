<?php
header('Content-Type: application/json; charset=utf-8');
session_start();

require_once __DIR__ . '/controller/ImmobileController.php';

$body = json_decode(file_get_contents('php://input'), true) ?: $_POST;
$action = $_GET['action'] ?? $body['action'] ?? null;

try {
    $ctrl = new ImmobileController();
    switch($action) {
        case 'login':
            $ctrl->login($body);
            break;
        case 'getImmobili':
            $ctrl->getImmobili();
            break;
        case 'modificaImmobile':
            $ctrl->modificaImmobile($body);
            break;
        case 'inviaAvvisoPagamento':
            $ctrl->inviaAvvisoPagamento($body);
            break;
        default:
            http_response_code(400);
            echo json_encode(['error' => 'missing_or_unknown_action']);
    }
} catch(Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => $e->getMessage()]);
}