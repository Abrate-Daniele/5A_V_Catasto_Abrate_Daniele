<?php
class ImmobiliModel {
    private $pdo;
    public function __construct(PDO $pdo){
        $this->pdo = $pdo;
    }

    public function getUserByCF($cf){
        $stmt = $this->pdo->prepare('SELECT id,nome,cognome,codice_fiscale,email,telefono FROM utenti WHERE codice_fiscale = :cf LIMIT 1');
        $stmt->execute(['cf'=>$cf]);
        return $stmt->fetch();
    }

    public function getImmobiliByUser($userId){
        $stmt = $this->pdo->prepare('SELECT * FROM immobili WHERE utente_id = :uid');
        $stmt->execute(['uid'=>$userId]);
        return $stmt->fetchAll();
    }

    public function getImmobileById($id){
        $stmt = $this->pdo->prepare('SELECT * FROM immobili WHERE id = :id LIMIT 1');
        $stmt->execute(['id'=>$id]);
        return $stmt->fetch();
    }

    public function updateImmobile($id, $categoria=null, $rendita=null, $superficie=null){
        $fields = [];
        $params = ['id'=>$id];
        if($categoria !== null){ $fields[] = 'categoria = :categoria'; $params['categoria'] = $categoria; }
        if($rendita !== null){ $fields[] = 'rendita_euro = :rendita_euro'; $params['rendita_euro'] = $rendita; }
        if($superficie !== null){ $fields[] = 'superficie_mq = :superficie_mq'; $params['superficie_mq'] = $superficie; }

        if(empty($fields)) return false;

        $sql = 'UPDATE immobili SET ' . implode(', ', $fields) . ' WHERE id = :id';
        $stmt = $this->pdo->prepare($sql);
        return $stmt->execute($params);
    }

    public function updateImuDaPagare($id, $imu){
        $stmt = $this->pdo->prepare('UPDATE immobili SET imu_da_pagare = :imu WHERE id = :id');
        return $stmt->execute(['imu'=>$imu, 'id'=>$id]);
    }
}