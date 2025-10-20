<?php
require_once __DIR__ . '/../model/DbModel.php';
require_once __DIR__ . '/../model/ImmobiliModel.php';

class ImmobileController {
    private $db;
    private $immobiliModel;
    private $SESSION_TIMEOUT = 15 * 60;

    public function __construct(){
        $this->db = new DbModel();
        $this->immobiliModel = new ImmobiliModel($this->db->getConnection());
    }

    private function checkSessionTimeout(){
        if(empty($_SESSION['last_activity'])) {
            return false;
        }
        if(time() - $_SESSION['last_activity'] > $this->SESSION_TIMEOUT) {
            session_unset();
            session_destroy();
            http_response_code(403);
            echo json_encode(['error' => 'session_expired']);
            return false;
        }
        $_SESSION['last_activity'] = time();
        return true;
    }

    public function login($data){
        $cf = $data['codice_fiscale'] ?? null;
        if(!$cf){
            http_response_code(400);
            echo json_encode(['error'=>'missing_codice_fiscale']);
            return;
        }

        $user = $this->immobiliModel->getUserByCF($cf);
        if(!$user){
            http_response_code(401);
            echo json_encode(['error'=>'invalid_credentials']);
            return;
        }

        session_regenerate_id(true);
        $_SESSION['user'] = $user;
        $_SESSION['last_activity'] = time();
        
        echo json_encode(['ok'=>true,'user'=>$user]);
    }

    public function getImmobili(){
        if(empty($_SESSION['user'])){
            http_response_code(401);
            echo json_encode(['error'=>'not_logged_in']);
            return;
        }
        if(!$this->checkSessionTimeout()) return;

        $userId = $_SESSION['user']['id'];
        $arr = $this->immobiliModel->getImmobiliByUser($userId);
        echo json_encode(['ok'=>true,'immobili'=>$arr]);
    }

    public function modificaImmobile($data){
        if(empty($_SESSION['user'])){
            http_response_code(401);
            echo json_encode(['error'=>'not_logged_in']);
            return;
        }
        
        if(!$this->checkSessionTimeout()) return;

        $id = $data['id'] ?? null;
        $categoria = $data['categoria'] ?? null;
        $rendita = isset($data['rendita_euro']) ? floatval($data['rendita_euro']) : null;
        $superficie = isset($data['superficie_mq']) ? floatval($data['superficie_mq']) : null;

        if(!$id) { http_response_code(400); echo json_encode(['error'=>'missing_id']); return; }

        $updated = $this->immobiliModel->updateImmobile($id, $categoria, $rendita, $superficie);
        if($updated){
            echo json_encode(['ok'=>true]);
        } else {
            http_response_code(500);
            echo json_encode(['error'=>'update_failed']);
        }
    }

    private function calcolaIMU($rendita, $categoria){
        $moltiplicatoriIMU = [
            "A/1"=>160, "A/2"=>160, "A/3"=>160, "A/4"=>160,
            "A/5"=>160, "A/6"=>160, "A/7"=>160, "A/8"=>160, "A/9"=>160,
            "A/10"=>80,
            "B/1"=>140, "B/2"=>140, "B/3"=>140, "B/4"=>140, "B/5"=>140, "B/6"=>140, "B/7"=>140,
            "C/1"=>55,
            "C/2"=>160, "C/6"=>160, "C/7"=>160,
            "C/3"=>140, "C/4"=>140, "C/5"=>140,
            "D/1"=>65, "D/2"=>65, "D/3"=>65, "D/4"=>65,
            "D/5"=>80, "D/6"=>65, "D/7"=>65, "D/8"=>65, "D/9"=>65, "D/10"=>65,
            "E/1"=>55, "E/2"=>55, "E/3"=>55, "E/4"=>55, "E/5"=>55, "E/6"=>55,
            "E/7"=>55, "E/8"=>55, "E/9"=>55
        ];
        $rendita_rivalutata = $rendita * 1.05;
        $moltiplicatore = $moltiplicatoriIMU[$categoria] ?? 160;
        $valore_catastale = $rendita_rivalutata * $moltiplicatore;
        $imu = $valore_catastale * (0.96 / 100);
        return round($imu,2);
    }

    public function inviaAvvisoPagamento($data){
        if(empty($_SESSION['user'])){
            http_response_code(401);
            echo json_encode(['error'=>'not_logged_in']);
            return;
        }
        if(!$this->checkSessionTimeout()) return;

        $id = $data['id'] ?? null;
        if(!$id){ http_response_code(400); echo json_encode(['error'=>'missing_id']); return; }

        $imm = $this->immobiliModel->getImmobileById($id);
        if(!$imm){ http_response_code(404); echo json_encode(['error'=>'immobile_not_found']); return; }

        $calcolato = $this->calcolaIMU(floatval($imm['rendita_euro']), $imm['categoria']);

        if(abs(floatval($imm['imu_da_pagare']) - $calcolato) > 0.01){
            $this->immobiliModel->updateImuDaPagare($id, $calcolato);
        }
        
        $notice = [
            'id'=>$imm['id'],
            'indirizzo'=>$imm['indirizzo'],
            'comune'=>$imm['comune'],
            'categoria'=>$imm['categoria'],
            'rendita_euro'=>floatval($imm['rendita_euro']),
            'imu_da_pagare'=>$calcolato
        ];

        echo json_encode(['ok'=>true,'avviso'=>$notice]);
    }
}