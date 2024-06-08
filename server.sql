-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 19-12-2020 a las 19:22:00
-- Versión del servidor: 10.4.11-MariaDB
-- Versión de PHP: 7.4.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `server2`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `3dtext`
--

CREATE TABLE `3dtext` (
  `textID` int(10) UNSIGNED NOT NULL,
  `text` text CHARACTER SET latin1 NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `interior` tinyint(3) UNSIGNED NOT NULL,
  `dimension` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ajustes`
--

CREATE TABLE `ajustes` (
  `ajusteID` int(11) NOT NULL,
  `nombre` text NOT NULL,
  `valor` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `armas_suelo`
--

CREATE TABLE `armas_suelo` (
  `ID` int(10) UNSIGNED NOT NULL,
  `model` int(10) UNSIGNED NOT NULL,
  `ammo` int(10) UNSIGNED NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `interior` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `dimension` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `characterID` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `banks`
--

CREATE TABLE `banks` (
  `bankID` int(10) UNSIGNED NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `rotation` float NOT NULL,
  `interior` tinyint(3) UNSIGNED NOT NULL,
  `dimension` int(10) UNSIGNED NOT NULL,
  `skin` int(10) NOT NULL DEFAULT -1
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cabinas`
--

CREATE TABLE `cabinas` (
  `cabinaID` int(10) UNSIGNED NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `rotation` float NOT NULL,
  `interior` tinyint(3) UNSIGNED NOT NULL,
  `dimension` int(10) UNSIGNED NOT NULL,
  `skin` int(11) NOT NULL DEFAULT -1,
  `operativa` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `characters`
--

CREATE TABLE `characters` (
  `characterID` int(10) UNSIGNED NOT NULL,
  `characterName` varchar(22) CHARACTER SET latin1 NOT NULL,
  `genero` int(11) NOT NULL DEFAULT 0,
  `edad` int(11) NOT NULL DEFAULT 0,
  `nivel` int(11) NOT NULL DEFAULT 1,
  `objetivos` text CHARACTER SET latin1 DEFAULT NULL,
  `userID` int(10) UNSIGNED NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `interior` tinyint(3) UNSIGNED NOT NULL,
  `dimension` int(10) UNSIGNED NOT NULL,
  `clothes` text CHARACTER SET latin1 DEFAULT NULL,
  `skin` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `andar` int(11) DEFAULT NULL,
  `rotation` float NOT NULL,
  `health` tinyint(3) UNSIGNED NOT NULL DEFAULT 100,
  `armor` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `money` bigint(20) UNSIGNED NOT NULL DEFAULT 700,
  `CKuIDStaff` int(11) NOT NULL DEFAULT 0,
  `created` timestamp NOT NULL DEFAULT current_timestamp(),
  `lastLogin` timestamp NULL DEFAULT NULL,
  `lastLogout` timestamp NULL DEFAULT NULL,
  `weapons` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
  `job` varchar(20) CHARACTER SET latin1 DEFAULT NULL,
  `dni` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `languages` text CHARACTER SET latin1 DEFAULT NULL,
  `car_license` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `gun_license` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `boat_license` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `sed` int(10) UNSIGNED NOT NULL DEFAULT 100,
  `hambre` int(10) UNSIGNED NOT NULL DEFAULT 100,
  `cansancio` int(10) UNSIGNED NOT NULL DEFAULT 100,
  `gordura` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `musculatura` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `casadocon` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `tpd` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `nuevo` int(10) UNSIGNED NOT NULL DEFAULT 1,
  `ajail` int(11) NOT NULL DEFAULT 0,
  `payday` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `color` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `barco_license` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `camion_license` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `condiciones` float NOT NULL DEFAULT 0,
  `yo` text CHARACTER SET latin1 DEFAULT NULL,
  `loteria` int(11) DEFAULT NULL,
  `banco` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `horas` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `gananciaCasino` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `character_to_factions`
--

CREATE TABLE `character_to_factions` (
  `characterID` int(10) UNSIGNED NOT NULL,
  `factionID` int(10) UNSIGNED NOT NULL,
  `factionLeader` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `factionRank` tinyint(3) UNSIGNED NOT NULL DEFAULT 1,
  `factionSueldo` int(4) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `concesionario`
--

CREATE TABLE `concesionario` (
  `registroID` int(10) UNSIGNED NOT NULL,
  `modelID` int(10) UNSIGNED NOT NULL,
  `vehicleID` int(10) UNSIGNED NOT NULL,
  `factionID` int(10) UNSIGNED NOT NULL,
  `precio` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `condiciones`
--

CREATE TABLE `condiciones` (
  `cID` int(11) NOT NULL,
  `version` float NOT NULL,
  `texto` text CHARACTER SET latin1 NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `condiciones`
--

INSERT INTO `condiciones` (`cID`, `version`, `texto`) VALUES
(1, 1, 'NORMATIVA GENERAL DE DOWNTOWN ROLEPLAY.\r\n\r\nPor favor, consúltela vía web en https://foro.dt-mta.com');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `construcciones`
--

CREATE TABLE `construcciones` (
  `construccionID` int(10) UNSIGNED NOT NULL,
  `tipoConstruccion` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `charIDConstructor` int(10) UNSIGNED NOT NULL,
  `charIDTitular` int(10) UNSIGNED NOT NULL,
  `interiorID` int(10) UNSIGNED NOT NULL,
  `diasReforma` int(4) UNSIGNED NOT NULL,
  `inicioReforma` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `deposito`
--

CREATE TABLE `deposito` (
  `depositoID` int(11) NOT NULL,
  `vehicleID` text CHARACTER SET latin1 NOT NULL,
  `modelo` text CHARACTER SET latin1 NOT NULL,
  `color` text CHARACTER SET latin1 NOT NULL,
  `propietario` text CHARACTER SET latin1 NOT NULL,
  `razon` text CHARACTER SET latin1 NOT NULL,
  `agente` text CHARACTER SET latin1 NOT NULL,
  `fecha` timestamp NOT NULL DEFAULT current_timestamp(),
  `estado` text CHARACTER SET latin1 NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `dinero_sesiones`
--

CREATE TABLE `dinero_sesiones` (
  `sesionID` int(11) NOT NULL,
  `characterID` int(11) NOT NULL,
  `userID` int(11) NOT NULL,
  `cantidadLogin` int(11) NOT NULL,
  `cantidadLogout` int(11) NOT NULL DEFAULT 0,
  `estadoSesion` int(11) NOT NULL DEFAULT 0,
  `timestampLogin` timestamp NOT NULL DEFAULT current_timestamp(),
  `timestampLogout` timestamp NULL DEFAULT NULL,
  `resolucionCaso` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `dropitems`
--

CREATE TABLE `dropitems` (
  `id` int(10) UNSIGNED NOT NULL,
  `item` int(10) UNSIGNED NOT NULL,
  `value` bigint(20) UNSIGNED NOT NULL,
  `posx` float UNSIGNED NOT NULL,
  `posy` float UNSIGNED NOT NULL,
  `posz` float UNSIGNED NOT NULL,
  `interior` int(10) UNSIGNED NOT NULL,
  `dim` int(10) UNSIGNED NOT NULL,
  `ang` float UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `dudas`
--

CREATE TABLE `dudas` (
  `dudaID` int(11) NOT NULL,
  `userIDStaff` int(11) NOT NULL,
  `userIDUsuario` int(11) NOT NULL,
  `charIDUsuario` int(11) NOT NULL,
  `dudaPregunta` text CHARACTER SET latin1 NOT NULL,
  `dudaRespuesta` text CHARACTER SET latin1 NOT NULL,
  `valoracion` int(11) NOT NULL,
  `codigoIncidencia` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `factions`
--

CREATE TABLE `factions` (
  `factionID` int(10) UNSIGNED NOT NULL,
  `groupID` int(10) UNSIGNED NOT NULL,
  `factionType` tinyint(3) UNSIGNED NOT NULL,
  `factionTag` varchar(10) CHARACTER SET latin1 NOT NULL,
  `factionPresupuesto` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `factions`
--

INSERT INTO `factions` (`factionID`, `groupID`, `factionType`, `factionTag`, `factionPresupuesto`) VALUES
(1, 4, 1, 'PD', 84073),
(2, 5, 1, 'MD', 115660),
(3, 6, 2, 'WK', 76825),
(4, 7, 2, 'ND', 250544),
(5, 8, 1, 'GOB', 955178),
(6, 9, 1, 'JUST', 190400),
(7, 10, 2, 'TTL', 127264),
(8, 11, 2, 'TTP', 303275);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `faction_ranks`
--

CREATE TABLE `faction_ranks` (
  `factionID` int(10) UNSIGNED NOT NULL,
  `factionRankID` int(10) UNSIGNED NOT NULL,
  `factionRankName` varchar(64) CHARACTER SET latin1 NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `faction_ranks`
--

INSERT INTO `faction_ranks` (`factionID`, `factionRankID`, `factionRankName`) VALUES
(1, 1, 'Ausencia Justificada'),
(1, 2, 'Agente en prÃ¡cticas'),
(1, 3, 'Deputy Sheriff I'),
(1, 4, 'Deputy Sheriff  II'),
(1, 5, 'Deputy Sheriff III'),
(1, 6, 'Suboficial de InstrucciÃ³n'),
(1, 7, 'Sargento I'),
(1, 8, 'Sargento II'),
(1, 9, 'Teniente I'),
(1, 10, 'Teniente II'),
(1, 11, 'CapitÃ¡n'),
(1, 12, 'Coronel'),
(1, 13, 'Mayor'),
(1, 14, 'Sub - Sheriff'),
(1, 15, 'Sheriff'),
(2, 1, 'Ausencia Justificada'),
(2, 2, 'Practicante'),
(2, 3, 'Aux. de EnfermerÃ­a'),
(2, 4, 'MÃ©dico/a III'),
(2, 5, 'MÃ©dico/a II'),
(2, 6, 'MÃ©dico/a I'),
(2, 7, 'MÃ©dico/a especialista'),
(2, 8, 'Instructor/a'),
(2, 9, 'Jefe/a de EnfermerÃ­a'),
(2, 10, 'Coordinador/a'),
(2, 11, 'Sub Director/a'),
(2, 12, 'Director/a'),
(3, 1, 'Ausencia justificada'),
(3, 2, 'MecÃ¡nico en prÃ¡cticas'),
(3, 3, 'MecÃ¡nico'),
(3, 4, 'Jefe de plantilla'),
(3, 5, 'Ingeniero mecÃ¡nico'),
(3, 6, 'Encargado del taller'),
(3, 7, 'Sub-director'),
(3, 8, 'Gerente'),
(4, 1, 'Ausencia justificada'),
(4, 2, 'Becario'),
(4, 3, 'Periodista en prÃ¡cticas'),
(4, 4, 'Asistente'),
(4, 5, 'Reportero'),
(4, 6, 'Locutor - Redactor'),
(4, 7, 'Periodista'),
(4, 8, 'Periodista destacado'),
(4, 9, 'Jefe de Plantilla'),
(4, 10, 'Encargado/a'),
(4, 11, 'Sub-director'),
(4, 12, 'Director'),
(6, 1, 'Abogado'),
(6, 2, 'Fiscal'),
(6, 3, 'Juez'),
(6, 4, 'Fiscal general'),
(7, 1, 'Ausencia justificada'),
(7, 2, 'Sancionado'),
(7, 3, 'Transportista en pruebas'),
(7, 4, 'Transportista'),
(7, 5, 'Transportista Medio'),
(7, 6, 'Transportista Avanzado'),
(7, 7, 'Transportista Veterano'),
(7, 8, 'Supervisor Vehicular'),
(7, 9, 'Gerente'),
(7, 10, 'Sub-DueÃ±o'),
(7, 11, 'DueÃ±o'),
(8, 1, 'Ausencia Injuistificada'),
(8, 2, 'Ausencia Justificada'),
(8, 3, 'Conductor  Aprendiz'),
(8, 4, 'Conductor'),
(8, 5, 'Conductor Destacado'),
(8, 6, 'RR.HH'),
(8, 7, 'Sub Director/a'),
(8, 8, 'Director/a');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `fuelpoints`
--

CREATE TABLE `fuelpoints` (
  `fuelpointID` int(10) UNSIGNED NOT NULL,
  `posX` float NOT NULL,
  `posY` float NOT NULL,
  `posZ` float NOT NULL,
  `name` varchar(5) CHARACTER SET latin1 NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `historiales`
--

CREATE TABLE `historiales` (
  `historialID` int(11) NOT NULL,
  `nombre` text CHARACTER SET latin1 NOT NULL,
  `dni` text CHARACTER SET latin1 NOT NULL,
  `residencia` text CHARACTER SET latin1 NOT NULL,
  `profesion` text CHARACTER SET latin1 NOT NULL,
  `delitos` text CHARACTER SET latin1 NOT NULL,
  `agente` text CHARACTER SET latin1 NOT NULL,
  `fecha` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `interiors`
--

CREATE TABLE `interiors` (
  `interiorID` int(10) UNSIGNED NOT NULL,
  `outsideX` float NOT NULL,
  `outsideY` float NOT NULL,
  `outsideZ` float NOT NULL,
  `outsideVehRX` float DEFAULT NULL,
  `outsideVehRY` float DEFAULT NULL,
  `outsideVehRZ` float DEFAULT NULL,
  `outsideInterior` tinyint(3) UNSIGNED NOT NULL,
  `outsideDimension` int(10) UNSIGNED NOT NULL,
  `insideX` float NOT NULL,
  `insideY` float NOT NULL,
  `insideZ` float NOT NULL,
  `insideVehRX` float DEFAULT NULL,
  `insideVehRY` float DEFAULT NULL,
  `insideVehRZ` float DEFAULT NULL,
  `insideInterior` tinyint(3) UNSIGNED NOT NULL,
  `interiorName` varchar(255) CHARACTER SET latin1 NOT NULL,
  `interiorType` tinyint(3) UNSIGNED NOT NULL,
  `interiorPrice` int(10) UNSIGNED NOT NULL,
  `interiorPriceCompra` int(11) NOT NULL DEFAULT 0,
  `characterID` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `locked` tinyint(3) NOT NULL DEFAULT 0,
  `dropoffX` float DEFAULT NULL,
  `dropoffY` float DEFAULT NULL,
  `dropoffZ` float DEFAULT NULL,
  `precintado` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `idasociado` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `alarma` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `camaras` int(11) NOT NULL DEFAULT 0,
  `recaudacion` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `productos` int(10) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `items`
--

CREATE TABLE `items` (
  `index` int(10) UNSIGNED NOT NULL,
  `owner` int(10) UNSIGNED NOT NULL,
  `item` bigint(20) UNSIGNED NOT NULL,
  `value` text CHARACTER SET latin1 NOT NULL,
  `value2` int(10) UNSIGNED DEFAULT NULL,
  `name` text CHARACTER SET latin1 DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `items_mochilas`
--

CREATE TABLE `items_mochilas` (
  `index` int(10) UNSIGNED NOT NULL,
  `mochilaID` int(10) UNSIGNED NOT NULL,
  `item` int(10) UNSIGNED NOT NULL,
  `value` text CHARACTER SET latin1 NOT NULL,
  `value2` int(10) UNSIGNED DEFAULT NULL,
  `name` text CHARACTER SET latin1 DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `items_muebles`
--

CREATE TABLE `items_muebles` (
  `index` int(10) UNSIGNED NOT NULL,
  `muebleID` int(10) UNSIGNED NOT NULL,
  `item` int(10) UNSIGNED NOT NULL,
  `value` text CHARACTER SET latin1 NOT NULL,
  `value2` int(10) UNSIGNED DEFAULT NULL,
  `name` text CHARACTER SET latin1 DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `licencias_armas`
--

CREATE TABLE `licencias_armas` (
  `licenciaID` int(10) UNSIGNED NOT NULL,
  `cID` int(10) UNSIGNED NOT NULL,
  `cIDJusticia` int(10) UNSIGNED NOT NULL,
  `cost` int(10) UNSIGNED NOT NULL,
  `weapon` int(2) UNSIGNED NOT NULL,
  `status` int(1) UNSIGNED NOT NULL,
  `time` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `maleteros`
--

CREATE TABLE `maleteros` (
  `index` int(10) UNSIGNED NOT NULL,
  `vehicleID` int(10) UNSIGNED NOT NULL,
  `item` int(10) UNSIGNED NOT NULL,
  `value` text CHARACTER SET latin1 NOT NULL,
  `value2` int(10) UNSIGNED DEFAULT NULL,
  `name` text CHARACTER SET latin1 DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mascotas`
--

CREATE TABLE `mascotas` (
  `ID` int(10) UNSIGNED NOT NULL,
  `raza` int(10) UNSIGNED NOT NULL,
  `name` text NOT NULL,
  `owner` int(10) UNSIGNED NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `interior` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `dimension` int(10) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mochilas_suelo`
--

CREATE TABLE `mochilas_suelo` (
  `mochilaID` int(10) UNSIGNED NOT NULL,
  `model` int(4) UNSIGNED NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `interior` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `dimension` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `characterID` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `muebles`
--

CREATE TABLE `muebles` (
  `muebleID` int(10) UNSIGNED NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `rx` float NOT NULL,
  `ry` float NOT NULL,
  `rz` float NOT NULL,
  `interior` tinyint(3) UNSIGNED NOT NULL,
  `dimension` int(10) UNSIGNED NOT NULL,
  `extra` int(10) NOT NULL DEFAULT 0,
  `skin` int(11) NOT NULL DEFAULT -1,
  `tipo` int(11) NOT NULL DEFAULT -1
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `multas`
--

CREATE TABLE `multas` (
  `ind` int(11) NOT NULL,
  `characterID` int(11) DEFAULT NULL,
  `cantidad` int(11) DEFAULT NULL,
  `agente` text CHARACTER SET latin1 DEFAULT NULL,
  `estado` int(11) NOT NULL DEFAULT 1,
  `pagado` int(11) NOT NULL DEFAULT 0,
  `razon` text CHARACTER SET latin1 DEFAULT NULL,
  `fecha` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `objetivos`
--

CREATE TABLE `objetivos` (
  `objetivoID` int(10) UNSIGNED NOT NULL,
  `nivel` int(10) UNSIGNED NOT NULL,
  `titulo` text NOT NULL,
  `descripcion` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ordenes`
--

CREATE TABLE `ordenes` (
  `ordenID` int(11) NOT NULL,
  `nombre` text CHARACTER SET latin1 NOT NULL,
  `razon` text CHARACTER SET latin1 NOT NULL,
  `agente` text CHARACTER SET latin1 NOT NULL,
  `estado` text CHARACTER SET latin1 NOT NULL,
  `fecha` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `periodicos`
--

CREATE TABLE `periodicos` (
  `periodicoID` int(10) UNSIGNED NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `rotation` float NOT NULL,
  `interior` tinyint(3) UNSIGNED NOT NULL,
  `dimension` int(10) UNSIGNED NOT NULL,
  `skin` int(10) NOT NULL DEFAULT -1,
  `operativa` int(10) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `prestamos`
--

CREATE TABLE `prestamos` (
  `prestamoID` int(11) NOT NULL,
  `tipo` int(11) NOT NULL,
  `objetoID` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `pagado` int(11) NOT NULL,
  `characterID` int(11) NOT NULL,
  `cuota` int(11) NOT NULL,
  `flimite` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `robos`
--

CREATE TABLE `robos` (
  `roboID` int(11) NOT NULL,
  `userIDStaff` int(11) DEFAULT NULL,
  `charIDLadron` int(11) DEFAULT NULL,
  `tipo` int(11) DEFAULT NULL,
  `objetoID` int(11) DEFAULT NULL,
  `model` int(11) NOT NULL,
  `cantidad` int(11) DEFAULT NULL,
  `fecha` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sanciones`
--

CREATE TABLE `sanciones` (
  `sancionID` int(10) UNSIGNED NOT NULL,
  `userID` int(10) NOT NULL DEFAULT -1,
  `staffID` int(10) NOT NULL DEFAULT -1,
  `regla` int(10) NOT NULL DEFAULT -1,
  `validez` int(10) NOT NULL DEFAULT 1,
  `fecha` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `shops`
--

CREATE TABLE `shops` (
  `shopID` int(10) UNSIGNED NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `rotation` float NOT NULL,
  `interior` tinyint(3) UNSIGNED NOT NULL,
  `dimension` int(10) UNSIGNED NOT NULL,
  `configuration` varchar(45) CHARACTER SET latin1 NOT NULL,
  `skin` int(10) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `teleports`
--

CREATE TABLE `teleports` (
  `teleportID` int(10) UNSIGNED NOT NULL,
  `aX` float NOT NULL,
  `aY` float NOT NULL,
  `aZ` float NOT NULL,
  `aInterior` tinyint(3) UNSIGNED NOT NULL,
  `aDimension` int(10) UNSIGNED NOT NULL,
  `bX` float NOT NULL,
  `bY` float NOT NULL,
  `bZ` float NOT NULL,
  `bInterior` tinyint(3) UNSIGNED NOT NULL,
  `bDimension` int(10) UNSIGNED NOT NULL,
  `name` text CHARACTER SET latin1 DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tlf_contactos`
--

CREATE TABLE `tlf_contactos` (
  `contacto_ID` int(11) NOT NULL,
  `tlf_titular` int(11) NOT NULL,
  `nombre` text CHARACTER SET latin1 NOT NULL,
  `tlf_contacto` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tlf_data`
--

CREATE TABLE `tlf_data` (
  `registro_ID` int(11) NOT NULL,
  `apagado` int(11) NOT NULL DEFAULT 0,
  `numero` int(11) NOT NULL,
  `imei` bigint(20) NOT NULL,
  `titular` int(11) NOT NULL,
  `estado` int(11) NOT NULL,
  `agenda` text CHARACTER SET latin1 NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tlf_llamadas`
--

CREATE TABLE `tlf_llamadas` (
  `llamada_ID` int(11) NOT NULL,
  `tlf_emisor` int(11) NOT NULL,
  `tlf_receptor` int(11) NOT NULL,
  `fecha` timestamp NOT NULL DEFAULT current_timestamp(),
  `duracion` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tlf_sms`
--

CREATE TABLE `tlf_sms` (
  `sms_ID` int(11) NOT NULL,
  `tlf_receptor` int(11) DEFAULT NULL,
  `tlf_emisor` int(11) DEFAULT NULL,
  `msg` text CHARACTER SET latin1 DEFAULT NULL,
  `fecha` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vehicles`
--

CREATE TABLE `vehicles` (
  `vehicleID` int(10) UNSIGNED NOT NULL,
  `model` int(10) UNSIGNED NOT NULL,
  `posX` float NOT NULL,
  `posY` float NOT NULL,
  `posZ` float NOT NULL,
  `rotX` float NOT NULL,
  `rotY` float NOT NULL,
  `rotZ` float NOT NULL,
  `interior` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `dimension` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `respawnPosX` float NOT NULL,
  `respawnPosY` float NOT NULL,
  `respawnPosZ` float NOT NULL,
  `respawnRotX` float NOT NULL,
  `respawnRotY` float NOT NULL,
  `respawnRotZ` float NOT NULL,
  `respawnInterior` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `respawnDimension` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `numberplate` varchar(8) CHARACTER SET latin1 NOT NULL,
  `health` int(10) UNSIGNED NOT NULL DEFAULT 1000,
  `color1` varchar(500) CHARACTER SET latin1 NOT NULL,
  `color2` varchar(500) CHARACTER SET latin1 NOT NULL,
  `color3` varchar(500) CHARACTER SET latin1 NOT NULL,
  `characterID` int(11) NOT NULL DEFAULT 0,
  `locked` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `engineState` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `lightsState` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `tintedWindows` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `fuel` float UNSIGNED NOT NULL DEFAULT 100,
  `pinturas` int(11) NOT NULL DEFAULT 3,
  `tunning` text CHARACTER SET latin1 DEFAULT NULL,
  `neon` int(11) DEFAULT NULL,
  `seguro` int(11) NOT NULL DEFAULT 0,
  `km` int(11) NOT NULL DEFAULT 0,
  `fasemotor` int(11) NOT NULL DEFAULT 0,
  `fasefrenos` int(11) NOT NULL DEFAULT 0,
  `localizador` int(1) NOT NULL DEFAULT 0,
  `alarma` int(11) NOT NULL DEFAULT 0,
  `marchas` int(1) NOT NULL DEFAULT 0,
  `cepo` int(1) NOT NULL DEFAULT 0,
  `diasLimpio` int(2) NOT NULL DEFAULT 0,
  `opcion` int(11) NOT NULL DEFAULT 2,
  `dias` int(11) NOT NULL DEFAULT 20,
  `inactivo` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vehicles_averias`
--

CREATE TABLE `vehicles_averias` (
  `registroID` int(11) NOT NULL,
  `vehicleID` int(11) DEFAULT NULL,
  `operacionID` int(11) DEFAULT NULL,
  `mecanicoID` int(11) DEFAULT NULL,
  `fecha` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `wcf1_group`
--

CREATE TABLE `wcf1_group` (
  `groupID` int(10) UNSIGNED NOT NULL,
  `groupIDForo` int(11) DEFAULT NULL,
  `groupName` varchar(255) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `canBeFactioned` tinyint(1) UNSIGNED NOT NULL DEFAULT 1,
  `priority` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `wcf1_group`
--

INSERT INTO `wcf1_group` (`groupID`, `groupIDForo`, `groupName`, `canBeFactioned`, `priority`) VALUES
(1, 1, 'Developers', 0, 1),
(2, 1, 'MTA Administrators', 0, 2),
(3, 2, 'GameOperator', 0, 3),
(4, 9, 'Palomino Creek Sheriff Dept', 1, 5),
(5, 10, 'Palomino Creek Medical Dept', 1, 5),
(6, 11, 'Palomino Creek Motor Workshop', 1, 5),
(7, 12, 'Palomino Creek FM', 1, 5),
(8, 13, 'Red County Govern', 1, 5),
(9, 14, 'Montgomery Court and Justice Dept', 1, 5),
(10, 15, 'Turbo Trans Logistics', 1, 5),
(11, 16, 'Montgomery Public Transport', 1, 5),
(12, 17, 'Helper', 0, 4);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `wcf1_user`
--

CREATE TABLE `wcf1_user` (
  `userID` int(10) UNSIGNED NOT NULL,
  `username` varchar(255) CHARACTER SET latin1 NOT NULL,
  `password` varchar(40) CHARACTER SET latin1 NOT NULL,
  `salt` varchar(40) CHARACTER SET latin1 NOT NULL,
  `secret` text CHARACTER SET latin1 DEFAULT NULL,
  `banned` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `activationCode` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `activationReason` text CHARACTER SET latin1 DEFAULT NULL,
  `banReason` mediumtext CHARACTER SET latin1 DEFAULT NULL,
  `banUser` int(10) UNSIGNED DEFAULT NULL,
  `lastIP` varchar(15) CHARACTER SET latin1 DEFAULT NULL,
  `lastSerial` varchar(32) CHARACTER SET latin1 DEFAULT NULL,
  `regSerial2` varchar(32) CHARACTER SET latin1 DEFAULT NULL,
  `regIP` varchar(15) CHARACTER SET latin1 DEFAULT NULL,
  `regSerial` varchar(32) CHARACTER SET latin1 DEFAULT NULL,
  `userOptions` text CHARACTER SET latin1 DEFAULT NULL,
  `bs` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `CUS` varchar(6) CHARACTER SET latin1 DEFAULT NULL,
  `migrado` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `shaderOptions` text CHARACTER SET latin1 DEFAULT NULL,
  `vipDays` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `vipSkin` int(11) NOT NULL DEFAULT -1,
  `vipSkinAdic` int(11) NOT NULL DEFAULT -1,
  `tjail` int(11) NOT NULL DEFAULT 0,
  `nuevo` int(11) NOT NULL DEFAULT 1,
  `dudas` int(11) NOT NULL DEFAULT 0,
  `valoracion` text CHARACTER SET latin1 DEFAULT NULL,
  `tiradas` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `wcf1_user_to_groups`
--

CREATE TABLE `wcf1_user_to_groups` (
  `userID` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `groupID` int(10) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `3dtext`
--
ALTER TABLE `3dtext`
  ADD PRIMARY KEY (`textID`);

--
-- Indices de la tabla `ajustes`
--
ALTER TABLE `ajustes`
  ADD PRIMARY KEY (`ajusteID`);

--
-- Indices de la tabla `armas_suelo`
--
ALTER TABLE `armas_suelo`
  ADD PRIMARY KEY (`ID`);

--
-- Indices de la tabla `banks`
--
ALTER TABLE `banks`
  ADD PRIMARY KEY (`bankID`);

--
-- Indices de la tabla `cabinas`
--
ALTER TABLE `cabinas`
  ADD PRIMARY KEY (`cabinaID`);

--
-- Indices de la tabla `characters`
--
ALTER TABLE `characters`
  ADD PRIMARY KEY (`characterID`);

--
-- Indices de la tabla `character_to_factions`
--
ALTER TABLE `character_to_factions`
  ADD PRIMARY KEY (`characterID`,`factionID`);

--
-- Indices de la tabla `concesionario`
--
ALTER TABLE `concesionario`
  ADD PRIMARY KEY (`registroID`);

--
-- Indices de la tabla `condiciones`
--
ALTER TABLE `condiciones`
  ADD PRIMARY KEY (`cID`);

--
-- Indices de la tabla `construcciones`
--
ALTER TABLE `construcciones`
  ADD PRIMARY KEY (`construccionID`);

--
-- Indices de la tabla `deposito`
--
ALTER TABLE `deposito`
  ADD PRIMARY KEY (`depositoID`);

--
-- Indices de la tabla `dinero_sesiones`
--
ALTER TABLE `dinero_sesiones`
  ADD PRIMARY KEY (`sesionID`);

--
-- Indices de la tabla `dropitems`
--
ALTER TABLE `dropitems`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `dudas`
--
ALTER TABLE `dudas`
  ADD PRIMARY KEY (`dudaID`);

--
-- Indices de la tabla `factions`
--
ALTER TABLE `factions`
  ADD PRIMARY KEY (`factionID`);

--
-- Indices de la tabla `faction_ranks`
--
ALTER TABLE `faction_ranks`
  ADD PRIMARY KEY (`factionID`,`factionRankID`);

--
-- Indices de la tabla `fuelpoints`
--
ALTER TABLE `fuelpoints`
  ADD PRIMARY KEY (`fuelpointID`);

--
-- Indices de la tabla `historiales`
--
ALTER TABLE `historiales`
  ADD PRIMARY KEY (`historialID`);

--
-- Indices de la tabla `interiors`
--
ALTER TABLE `interiors`
  ADD PRIMARY KEY (`interiorID`);

--
-- Indices de la tabla `items`
--
ALTER TABLE `items`
  ADD PRIMARY KEY (`index`);

--
-- Indices de la tabla `items_mochilas`
--
ALTER TABLE `items_mochilas`
  ADD PRIMARY KEY (`index`);

--
-- Indices de la tabla `items_muebles`
--
ALTER TABLE `items_muebles`
  ADD PRIMARY KEY (`index`);

--
-- Indices de la tabla `licencias_armas`
--
ALTER TABLE `licencias_armas`
  ADD PRIMARY KEY (`licenciaID`);

--
-- Indices de la tabla `maleteros`
--
ALTER TABLE `maleteros`
  ADD PRIMARY KEY (`index`);

--
-- Indices de la tabla `mascotas`
--
ALTER TABLE `mascotas`
  ADD PRIMARY KEY (`ID`);

--
-- Indices de la tabla `mochilas_suelo`
--
ALTER TABLE `mochilas_suelo`
  ADD PRIMARY KEY (`mochilaID`);

--
-- Indices de la tabla `muebles`
--
ALTER TABLE `muebles`
  ADD PRIMARY KEY (`muebleID`);

--
-- Indices de la tabla `multas`
--
ALTER TABLE `multas`
  ADD PRIMARY KEY (`ind`);

--
-- Indices de la tabla `objetivos`
--
ALTER TABLE `objetivos`
  ADD PRIMARY KEY (`objetivoID`);

--
-- Indices de la tabla `ordenes`
--
ALTER TABLE `ordenes`
  ADD PRIMARY KEY (`ordenID`);

--
-- Indices de la tabla `periodicos`
--
ALTER TABLE `periodicos`
  ADD PRIMARY KEY (`periodicoID`);

--
-- Indices de la tabla `prestamos`
--
ALTER TABLE `prestamos`
  ADD UNIQUE KEY `prestamoID` (`prestamoID`);

--
-- Indices de la tabla `robos`
--
ALTER TABLE `robos`
  ADD PRIMARY KEY (`roboID`),
  ADD UNIQUE KEY `roboID` (`roboID`);

--
-- Indices de la tabla `sanciones`
--
ALTER TABLE `sanciones`
  ADD PRIMARY KEY (`sancionID`);

--
-- Indices de la tabla `shops`
--
ALTER TABLE `shops`
  ADD PRIMARY KEY (`shopID`);

--
-- Indices de la tabla `teleports`
--
ALTER TABLE `teleports`
  ADD PRIMARY KEY (`teleportID`);

--
-- Indices de la tabla `tlf_contactos`
--
ALTER TABLE `tlf_contactos`
  ADD PRIMARY KEY (`contacto_ID`);

--
-- Indices de la tabla `tlf_data`
--
ALTER TABLE `tlf_data`
  ADD PRIMARY KEY (`registro_ID`),
  ADD UNIQUE KEY `numero` (`numero`,`imei`);

--
-- Indices de la tabla `tlf_llamadas`
--
ALTER TABLE `tlf_llamadas`
  ADD PRIMARY KEY (`llamada_ID`);

--
-- Indices de la tabla `tlf_sms`
--
ALTER TABLE `tlf_sms`
  ADD PRIMARY KEY (`sms_ID`);

--
-- Indices de la tabla `vehicles`
--
ALTER TABLE `vehicles`
  ADD PRIMARY KEY (`vehicleID`);

--
-- Indices de la tabla `vehicles_averias`
--
ALTER TABLE `vehicles_averias`
  ADD PRIMARY KEY (`registroID`);

--
-- Indices de la tabla `wcf1_group`
--
ALTER TABLE `wcf1_group`
  ADD PRIMARY KEY (`groupID`);

--
-- Indices de la tabla `wcf1_user`
--
ALTER TABLE `wcf1_user`
  ADD PRIMARY KEY (`userID`);

--
-- Indices de la tabla `wcf1_user_to_groups`
--
ALTER TABLE `wcf1_user_to_groups`
  ADD PRIMARY KEY (`userID`,`groupID`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `3dtext`
--
ALTER TABLE `3dtext`
  MODIFY `textID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `ajustes`
--
ALTER TABLE `ajustes`
  MODIFY `ajusteID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `armas_suelo`
--
ALTER TABLE `armas_suelo`
  MODIFY `ID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `banks`
--
ALTER TABLE `banks`
  MODIFY `bankID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `cabinas`
--
ALTER TABLE `cabinas`
  MODIFY `cabinaID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `characters`
--
ALTER TABLE `characters`
  MODIFY `characterID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `concesionario`
--
ALTER TABLE `concesionario`
  MODIFY `registroID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `condiciones`
--
ALTER TABLE `condiciones`
  MODIFY `cID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `construcciones`
--
ALTER TABLE `construcciones`
  MODIFY `construccionID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `deposito`
--
ALTER TABLE `deposito`
  MODIFY `depositoID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `dinero_sesiones`
--
ALTER TABLE `dinero_sesiones`
  MODIFY `sesionID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `dropitems`
--
ALTER TABLE `dropitems`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `dudas`
--
ALTER TABLE `dudas`
  MODIFY `dudaID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `factions`
--
ALTER TABLE `factions`
  MODIFY `factionID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `fuelpoints`
--
ALTER TABLE `fuelpoints`
  MODIFY `fuelpointID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `historiales`
--
ALTER TABLE `historiales`
  MODIFY `historialID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `interiors`
--
ALTER TABLE `interiors`
  MODIFY `interiorID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `items`
--
ALTER TABLE `items`
  MODIFY `index` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `items_mochilas`
--
ALTER TABLE `items_mochilas`
  MODIFY `index` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `items_muebles`
--
ALTER TABLE `items_muebles`
  MODIFY `index` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `licencias_armas`
--
ALTER TABLE `licencias_armas`
  MODIFY `licenciaID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `maleteros`
--
ALTER TABLE `maleteros`
  MODIFY `index` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `mascotas`
--
ALTER TABLE `mascotas`
  MODIFY `ID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `muebles`
--
ALTER TABLE `muebles`
  MODIFY `muebleID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `multas`
--
ALTER TABLE `multas`
  MODIFY `ind` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `objetivos`
--
ALTER TABLE `objetivos`
  MODIFY `objetivoID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `ordenes`
--
ALTER TABLE `ordenes`
  MODIFY `ordenID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `periodicos`
--
ALTER TABLE `periodicos`
  MODIFY `periodicoID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `prestamos`
--
ALTER TABLE `prestamos`
  MODIFY `prestamoID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `robos`
--
ALTER TABLE `robos`
  MODIFY `roboID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `sanciones`
--
ALTER TABLE `sanciones`
  MODIFY `sancionID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `shops`
--
ALTER TABLE `shops`
  MODIFY `shopID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `teleports`
--
ALTER TABLE `teleports`
  MODIFY `teleportID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tlf_contactos`
--
ALTER TABLE `tlf_contactos`
  MODIFY `contacto_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tlf_data`
--
ALTER TABLE `tlf_data`
  MODIFY `registro_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tlf_llamadas`
--
ALTER TABLE `tlf_llamadas`
  MODIFY `llamada_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tlf_sms`
--
ALTER TABLE `tlf_sms`
  MODIFY `sms_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `vehicles`
--
ALTER TABLE `vehicles`
  MODIFY `vehicleID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `vehicles_averias`
--
ALTER TABLE `vehicles_averias`
  MODIFY `registroID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `wcf1_group`
--
ALTER TABLE `wcf1_group`
  MODIFY `groupID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `wcf1_user`
--
ALTER TABLE `wcf1_user`
  MODIFY `userID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
