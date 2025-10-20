-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Creato il: Ott 19, 2025 alle 15:24
-- Versione del server: 8.4.1
-- Versione PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `catasto`
--

-- --------------------------------------------------------

--
-- Struttura della tabella `immobili`
--

CREATE TABLE `immobili` (
  `id` int NOT NULL,
  `comune` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `foglio` int NOT NULL,
  `particella` int NOT NULL,
  `subalterno` int DEFAULT NULL,
  `categoria` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `classe` int DEFAULT NULL,
  `superficie_mq` decimal(8,2) DEFAULT NULL,
  `rendita_euro` decimal(10,2) DEFAULT NULL,
  `imu_da_pagare` decimal(10,2) DEFAULT '0.00',
  `imu_pagata` decimal(10,2) DEFAULT '0.00',
  `indirizzo` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `titolarita` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `utente_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dump dei dati per la tabella `immobili`
--

INSERT INTO `immobili` (`id`, `comune`, `foglio`, `particella`, `subalterno`, `categoria`, `classe`, `superficie_mq`, `rendita_euro`, `imu_da_pagare`, `imu_pagata`, `indirizzo`, `titolarita`, `utente_id`) VALUES
(1, 'Torino', 12, 345, 1, 'A/2', 3, 85.00, 720.50, 480.00, 480.00, 'Via Roma 15', 'Piena proprietà', 1),
(2, 'Milano', 8, 210, 2, 'A/3', 2, 65.00, 480.00, 320.00, 320.00, 'Via Monte Rosa 22', 'Piena proprietà', 1),
(3, 'Genova', 9, 334, 1, 'C/2', 2, 35.00, 120.00, 60.00, 60.00, 'Salita San Donato 3', 'Piena proprietà', 1),
(4, 'Padova', 11, 212, 5, 'C/6', 1, 22.00, 98.30, 55.00, 0.00, 'Via Zabarella 17', 'Piena proprietà', 1),
(5, 'Reggio Emilia', 18, 230, 2, 'A/2', 4, 95.00, 830.00, 520.00, 260.00, 'Via Roma 50', 'Proprietà per 1/2', 1),
(6, 'Bologna', 15, 512, NULL, 'C/6', 1, 20.00, 95.60, 70.00, 70.00, 'Via Irnerio 5', 'Proprietà per 1/2', 2),
(7, 'Venezia', 2, 87, NULL, 'A/4', 3, 50.00, 360.00, 230.00, 230.00, 'Fondamenta Nove 8', 'Piena proprietà', 2),
(8, 'Modena', 14, 532, 1, 'C/1', 3, 45.00, 210.00, 180.00, 0.00, 'Via Emilia Est 200', 'Piena proprietà', 2),
(9, 'Verona', 5, 309, NULL, 'A/3', 1, 60.00, 420.50, 290.00, 145.00, 'Via Mazzini 18', 'Nuda proprietà', 2),
(10, 'Trieste', 7, 222, 4, 'A/3', 1, 55.00, 395.00, 280.00, 280.00, 'Via Carducci 7', 'Piena proprietà', 2),
(11, 'Firenze', 3, 108, 4, 'A/7', 4, 120.00, 980.00, 680.00, 680.00, 'Viale dei Colli 10', 'Piena proprietà', 3),
(12, 'Roma', 22, 672, 2, 'A/2', 5, 110.00, 950.75, 640.00, 320.00, 'Via Appia 120', 'Usufrutto', 3),
(13, 'Perugia', 8, 425, 1, 'A/2', 2, 80.00, 670.00, 460.00, 460.00, 'Corso Vannucci 10', 'Usufrutto', 3),
(14, 'Pisa', 4, 143, 2, 'C/6', 1, 25.00, 110.50, 75.00, 0.00, 'Via San Francesco 12', 'Proprietà per 1/2', 3),
(15, 'Trento', 6, 512, 3, 'A/2', 5, 115.00, 1020.00, 700.00, 700.00, 'Via Calepina 9', 'Piena proprietà', 3),
(16, 'Napoli', 7, 98, NULL, 'D/1', 1, 300.00, 2450.00, 1600.00, 800.00, 'Via Marina 45', 'Piena proprietà', 4),
(17, 'Parma', 10, 401, 3, 'A/2', 2, 90.00, 760.00, 520.00, 260.00, 'Via Garibaldi 25', 'Piena proprietà', 4),
(18, 'Cagliari', 3, 156, NULL, 'D/7', 1, 400.00, 3150.00, 2000.00, 2000.00, 'Via Sonnino 75', 'Piena proprietà', 4),
(19, 'Bari', 6, 451, NULL, 'A/3', 1, 70.00, 510.00, 340.00, 0.00, 'Corso Cavour 60', 'Proprietà per 1/3', 4),
(20, 'Lecce', 5, 311, NULL, 'A/4', 2, 65.00, 450.00, 310.00, 310.00, 'Via Libertini 28', 'Piena proprietà', 4);

-- --------------------------------------------------------

--
-- Struttura della tabella `utenti`
--

CREATE TABLE `utenti` (
  `id` int NOT NULL,
  `nome` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cognome` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `codice_fiscale` char(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `telefono` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `data_registrazione` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dump dei dati per la tabella `utenti`
--

INSERT INTO `utenti` (`id`, `nome`, `cognome`, `codice_fiscale`, `email`, `telefono`, `data_registrazione`) VALUES
(1, 'Giulia', 'Rossi', 'RSSGLI85A41H501U', 'giulia.rossi@example.com', '+39 3331112222', '2025-10-19 15:24:11'),
(2, 'Marco', 'Bianchi', 'BNCMRC78B12F205Y', 'marco.bianchi@example.com', '+39 3479876543', '2025-10-19 15:24:11'),
(3, 'Laura', 'Verdi', 'VRDLRA90C20E783Z', 'laura.verdi@example.com', '+39 3205556677', '2025-10-19 15:24:11'),
(4, 'Paolo', 'Neri', 'NERPLA70D10G482V', 'paolo.neri@example.com', '+39 3398889990', '2025-10-19 15:24:11');

--
-- Indici per le tabelle scaricate
--

--
-- Indici per le tabelle `immobili`
--
ALTER TABLE `immobili`
  ADD PRIMARY KEY (`id`);

--
-- Indici per le tabelle `utenti`
--
ALTER TABLE `utenti`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `codice_fiscale` (`codice_fiscale`);

--
-- AUTO_INCREMENT per le tabelle scaricate
--

--
-- AUTO_INCREMENT per la tabella `immobili`
--
ALTER TABLE `immobili`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT per la tabella `utenti`
--
ALTER TABLE `utenti`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
