-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 01-07-2026 a las 00:20:58
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `clinipet_db`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `citas`
--

CREATE TABLE `citas` (
  `id_cita` int(11) NOT NULL,
  `id_mascota` int(11) NOT NULL,
  `id_veterinario` int(11) DEFAULT NULL,
  `fecha` date NOT NULL,
  `hora` time NOT NULL,
  `motivo` varchar(255) DEFAULT NULL,
  `estado` varchar(30) DEFAULT 'PENDIENTE',
  `precio` decimal(10,2) DEFAULT NULL,
  `id_doctor` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `citas`
--

INSERT INTO `citas` (`id_cita`, `id_mascota`, `id_veterinario`, `fecha`, `hora`, `motivo`, `estado`, `precio`, `id_doctor`) VALUES
(1, 1, 2, '2026-04-28', '09:00:00', 'Consulta general', 'CONFIRMADA', 30000.00, NULL),
(2, 2, 2, '2026-04-28', '11:30:00', 'Vacunación', 'CANCELADA', 40000.00, NULL),
(3, 3, 2, '2026-04-29', '14:00:00', 'Control médico', 'REALIZADA', 30000.00, NULL),
(4, 1, 2, '2026-04-30', '10:00:00', 'Consulta general', 'REALIZADA', 30000.00, NULL),
(5, 4, 1, '2026-06-05', '09:19:00', 'ta malito', 'CANCELADA', 100000.00, NULL),
(6, 5, 5, '2026-06-03', '16:52:00', 'lele panchita\r\n', 'ACEPTADA', 30000.00, NULL),
(7, 5, 1, '2026-06-06', '08:50:00', 'general', 'REALIZADA', 50000.00, NULL),
(8, 5, 5, '2026-06-24', '11:34:00', 'ta malito', 'REALIZADA', 30000.00, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_orden_compra`
--

CREATE TABLE `detalle_orden_compra` (
  `id_detalle_orden` int(11) NOT NULL,
  `id_orden` int(11) NOT NULL,
  `id_producto` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `precio_unitario` decimal(10,2) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `detalle_orden_compra`
--

INSERT INTO `detalle_orden_compra` (`id_detalle_orden`, `id_orden`, `id_producto`, `cantidad`, `precio_unitario`, `subtotal`) VALUES
(1, 1, 1, 5, 30000.00, 150000.00),
(2, 1, 4, 4, 25000.00, 100000.00),
(3, 2, 3, 8, 50000.00, 400000.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_venta`
--

CREATE TABLE `detalle_venta` (
  `id_detalle` int(11) NOT NULL,
  `id_venta` int(11) NOT NULL,
  `id_producto` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `precio_unitario` decimal(10,2) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `detalle_venta`
--

INSERT INTO `detalle_venta` (`id_detalle`, `id_venta`, `id_producto`, `cantidad`, `precio_unitario`, `subtotal`) VALUES
(5, 1012, 1, 1, 35000.00, 35000.00),
(8, 1015, 1, 1, 35000.00, 35000.00),
(9, 1016, 1, 3, 35000.00, 105000.00),
(25, 1032, 2, 2, 18000.00, 36000.00),
(26, 1033, 20, 5, 95000.00, 475000.00),
(27, 1034, 26, 2, 30000.00, 60000.00),
(29, 1036, 20, 2, 95000.00, 190000.00),
(30, 1037, 23, 2, 76000.00, 152000.00),
(32, 1039, 26, 1, 30000.00, 30000.00),
(33, 1040, 30, 1, 54000.00, 54000.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `duenios`
--

CREATE TABLE `duenios` (
  `id_duenio` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `documento` varchar(30) DEFAULT NULL,
  `telefono` varchar(30) DEFAULT NULL,
  `correo` varchar(100) DEFAULT NULL,
  `direccion` varchar(150) DEFAULT NULL,
  `id_usuario` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `duenios`
--

INSERT INTO `duenios` (`id_duenio`, `nombre`, `documento`, `telefono`, `correo`, `direccion`, `id_usuario`) VALUES
(1, 'Juan Pérez', '100200300', '3001234567', 'juan@email.com', 'Sogamoso, Boyacá', NULL),
(2, 'Laura Gómez', '200300400', '3109876543', 'laura@email.com', 'Duitama, Boyacá', NULL),
(3, 'Carlos Ramírez', '300400500', '3205556677', 'carlos@email.com', 'Tunja, Boyacá', NULL),
(4, 'Cliente Demo', '', '', 'cliente@clinipet.com', '', 4),
(5, 'juanito', '23545678', '320896541', 'juanito@gmail.com', 'Venozolano', 13),
(6, 'Jhonatan Montaña', '1057872169', '3209230129', 'jhouprez@gmail.com', 'Colombia', 14),
(7, 'juanchito tovar', '1234567890', '3214567890', 'primo@gmail.com', 'Ciudad verde Frente', 15),
(8, 'ALDERSON DARIO BOHORQUEZ BUITRAGO', '111789456', '3127584415', 'aldersonbohorquez@gmail.com', 'Sogamoso', 17);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `historias_clinicas`
--

CREATE TABLE `historias_clinicas` (
  `id_historia` int(11) NOT NULL,
  `id_mascota` int(11) NOT NULL,
  `id_cita` int(11) DEFAULT NULL,
  `diagnostico` text DEFAULT NULL,
  `tratamiento` text DEFAULT NULL,
  `medicacion` text DEFAULT NULL,
  `observaciones` text DEFAULT NULL,
  `fecha` datetime DEFAULT current_timestamp(),
  `fecha_proxima_cita` date DEFAULT NULL,
  `peso_mascota` decimal(5,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `historias_clinicas`
--

INSERT INTO `historias_clinicas` (`id_historia`, `id_mascota`, `id_cita`, `diagnostico`, `tratamiento`, `medicacion`, `observaciones`, `fecha`, `fecha_proxima_cita`, `peso_mascota`) VALUES
(1, 1, 1, 'Revisión general sin complicaciones', 'Control preventivo', 'Vitaminas', 'Mascota estable', '2026-04-28 07:27:21', NULL, NULL),
(2, 2, 2, 'Aplicación de vacuna pendiente', 'Vacunación', 'Vacuna triple felina', 'Programar próxima dosis', '2026-04-28 07:27:21', NULL, NULL),
(3, 5, 7, 'tiene mucha hambre', 'darle de comer', '', 'una libra de arroz diaria', '2026-06-05 06:43:22', NULL, NULL),
(4, 5, 8, 'inflamacion de un pie', 'repóso', '', 'ninguns', '2026-06-23 10:34:23', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mascotas`
--

CREATE TABLE `mascotas` (
  `id_mascota` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `especie` varchar(50) NOT NULL,
  `raza` varchar(80) DEFAULT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `sexo` varchar(20) DEFAULT NULL,
  `id_duenio` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `mascotas`
--

INSERT INTO `mascotas` (`id_mascota`, `nombre`, `especie`, `raza`, `fecha_nacimiento`, `sexo`, `id_duenio`) VALUES
(1, 'Max', 'Perro', 'Labrador', '2021-05-10', 'MACHO', 1),
(2, 'Luna', 'Gato', 'Criollo', '2022-08-15', 'HEMBRA', 2),
(3, 'Rocky', 'Perro', 'Bulldog', '2020-03-22', 'MACHO', 3),
(4, 'Choco', 'Perro', 'Americano', '2026-05-06', 'MACHO', 4),
(5, 'Copito', 'Perro', 'chanda', '2026-04-28', 'MACHO', 5);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ordenes_compra`
--

CREATE TABLE `ordenes_compra` (
  `id_orden` int(11) NOT NULL,
  `id_proveedor` int(11) NOT NULL,
  `fecha` datetime DEFAULT current_timestamp(),
  `estado` varchar(30) DEFAULT 'PENDIENTE',
  `total` decimal(10,2) DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `ordenes_compra`
--

INSERT INTO `ordenes_compra` (`id_orden`, `id_proveedor`, `fecha`, `estado`, `total`) VALUES
(1, 1, '2026-04-28 07:27:21', 'PENDIENTE', 250000.00),
(2, 2, '2026-04-28 07:27:21', 'RECIBIDA', 400000.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `id` int(11) NOT NULL,
  `correo` varchar(100) NOT NULL,
  `token` varchar(64) NOT NULL,
  `expira_en` datetime NOT NULL,
  `usado` tinyint(1) NOT NULL DEFAULT 0,
  `creado_en` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `password_reset_tokens`
--

INSERT INTO `password_reset_tokens` (`id`, `correo`, `token`, `expira_en`, `usado`, `creado_en`) VALUES
(1, 'jhouprez@gmail.com', '517756', '2026-06-23 07:07:44', 1, '2026-06-23 06:37:44'),
(2, 'recepcion@clinipet.com', '172595', '2026-06-23 07:13:44', 0, '2026-06-23 06:43:44'),
(3, 'jhouprez@gmail.com', '411810', '2026-06-23 11:05:16', 1, '2026-06-23 10:35:16'),
(4, 'jhouprez@gmail.com', '696668', '2026-06-30 17:19:46', 0, '2026-06-30 16:49:46'),
(5, 'jhouprez@gmail.com', '325089', '2026-06-30 17:45:08', 0, '2026-06-30 17:15:08');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `id_producto` int(11) NOT NULL,
  `codigo` varchar(50) DEFAULT NULL,
  `nombre` varchar(100) NOT NULL,
  `categoria` varchar(80) DEFAULT NULL,
  `precio` decimal(10,2) NOT NULL,
  `stock` int(11) DEFAULT 0,
  `stock_minimo` int(11) DEFAULT 5,
  `fecha_vencimiento` date DEFAULT NULL,
  `especie` varchar(50) DEFAULT NULL,
  `imagen_url` varchar(500) DEFAULT NULL,
  `descripcion` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`id_producto`, `codigo`, `nombre`, `categoria`, `precio`, `stock`, `stock_minimo`, `fecha_vencimiento`, `especie`, `imagen_url`, `descripcion`) VALUES
(1, 'MED001', 'Antipulgas', 'medicamento', 35000.00, 20, 3, '2026-12-31', 'perro gato', 'https://images.unsplash.com/photo-1628009368231-7bb7cfcb0def?auto=format&fit=crop&w=900&q=80', 'Tratamiento antipulgas para perros y gatos.'),
(2, 'ALI001', 'Concentrado Perro 1kg', 'comida', 18000.00, 9, 5, '2026-08-20', 'perro', 'https://images.unsplash.com/photo-1589924691995-400dc9ecc119?auto=format&fit=crop&w=900&q=80', 'Alimento balanceado para perros adultos.'),
(3, 'VAC001', 'Vacuna Triple Felina', 'salud', 45000.00, 0, 5, '2026-06-15', 'gato', 'https://images.unsplash.com/photo-1606214174585-fe31582dc6ee?auto=format&fit=crop&w=900&q=80', 'Vacuna triple felina para gatos.'),
(4, 'MED002', 'Desparasitante', 'medicamento', 25000.00, 13, 4, '2026-10-10', 'perro gato', 'https://images.unsplash.com/photo-1576201836106-db1758fd1c97?auto=format&fit=crop&w=900&q=80', 'Desparasitante interno para perros y gatos.'),
(11, 'PER001', 'Concentrado Premium Perro', 'comida', 85000.00, 25, 5, '2027-12-31', 'perro', 'https://images.unsplash.com/photo-1589924691995-400dc9ecc119?auto=format&fit=crop&w=900&q=80', 'Alimento balanceado para perros adultos.'),
(12, 'GAT001', 'Arena Sanitaria Gato', 'aseo', 32000.00, 30, 5, '2027-12-31', 'gato', 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?auto=format&fit=crop&w=900&q=80', 'Control de olores y absorcion superior.'),
(13, 'PER002', 'Pelota Mordedora', 'juguetes', 18000.00, 37, 8, '2027-12-31', 'perro', 'https://images.unsplash.com/photo-1587300003388-59208cc962cb?auto=format&fit=crop&w=900&q=80', 'Juguete resistente para entrenamiento.'),
(14, 'MIX001', 'Shampoo Antipulgas', 'aseo', 26000.00, 20, 5, '2027-10-10', 'perro gato', 'https://images.unsplash.com/photo-1583337130417-3346a1be7dee?auto=format&fit=crop&w=900&q=80', 'Limpieza y cuidado contra pulgas.'),
(15, 'CAB001', 'Heno Premium Caballo', 'comida', 55000.00, 18, 4, '2027-12-31', 'caballo', 'https://images.unsplash.com/photo-1553284965-83fd3e82fa5a?auto=format&fit=crop&w=900&q=80', 'Fibra natural para alimentacion equina.'),
(16, 'AVE001', 'Vitaminas para Aves', 'salud', 22000.00, 35, 8, '2027-08-20', 'ave', 'https://images.unsplash.com/photo-1552728089-57bdde30beb3?auto=format&fit=crop&w=900&q=80', 'Refuerzo nutricional para aves domesticas.'),
(17, 'ACC001', 'Collar Premium', 'accesorios', 35000.00, 45, 10, '2027-12-31', 'perro gato', 'https://images.unsplash.com/photo-1601758124510-52d02ddb7cbd?auto=format&fit=crop&w=900&q=80', 'Collar comodo y ajustable para mascotas.'),
(18, 'PER003', 'Comida Cachorro 2kg', 'comida', 62000.00, 16, 5, '2027-12-31', 'perro', 'https://images.unsplash.com/photo-1589924691995-400dc9ecc119?auto=format&fit=crop&w=900&q=80', 'Alimento especial para cachorros.'),
(19, 'PER004', 'Correa Deportiva', 'accesorios', 28000.00, 30, 6, '2027-12-31', 'perro', 'https://images.unsplash.com/photo-1601758124510-52d02ddb7cbd?auto=format&fit=crop&w=900&q=80', 'Correa resistente para paseo.'),
(20, 'PER005', 'Cama Suave Perro', 'accesorios', 95000.00, 5, 3, '2027-12-31', 'perro', 'https://images.unsplash.com/photo-1541781774459-bb2af2f05b55?auto=format&fit=crop&w=900&q=80', ''),
(21, 'PER006', 'Hueso Dental', 'salud', 12000.00, 50, 10, '2027-12-31', 'perro', 'https://images.unsplash.com/photo-1601758174114-e711c0cbaa69?auto=format&fit=crop&w=900&q=80', 'Snack para limpieza dental.'),
(22, 'GAT002', 'Comida Gato Adulto', 'comida', 59000.00, 20, 5, '2027-12-31', 'gato', 'https://images.unsplash.com/photo-1574144611937-0df059b5ef3e?auto=format&fit=crop&w=900&q=80', 'Alimento seco para gato adulto.'),
(23, 'GAT003', 'Rascador para Gato', 'juguetes', 76000.00, 0, 2, '2027-12-31', 'gato', 'https://images.unsplash.com/photo-1592194996308-7b43878e84a6?auto=format&fit=crop&w=900&q=80', 'Rascador vertical para entretenimiento.'),
(24, 'GAT004', 'Raton de Juguete', 'juguetes', 14000.00, 35, 6, '2027-12-31', 'gato', 'https://images.unsplash.com/photo-1574144611937-0df059b5ef3e?auto=format&fit=crop&w=900&q=80', 'Juguete interactivo para gatos.'),
(25, 'GAT005', 'Malta para Gatos', 'salud', 24000.00, 18, 4, '2027-09-15', 'gato', 'https://images.unsplash.com/photo-1574158622682-e40e69881006?auto=format&fit=crop&w=900&q=80', 'Ayuda a controlar bolas de pelo.'),
(26, 'CAB002', 'Cepillo Equino', 'aseo', 30000.00, 10, 4, '2027-12-31', 'caballo', 'https://images.unsplash.com/photo-1534773728080-33d31da27ae5?auto=format&fit=crop&w=900&q=80', 'Cepillo para limpieza de pelaje.'),
(27, 'CAB003', 'Vitaminas Equinas', 'salud', 68000.00, 12, 3, '2027-07-10', 'caballo', 'https://images.unsplash.com/photo-1553284965-83fd3e82fa5a?auto=format&fit=crop&w=900&q=80', 'Suplemento vitaminico para caballos.'),
(28, 'CAB004', 'Concentrado Caballo', 'comida', 89000.00, 20, 5, '2027-12-31', 'caballo', 'https://images.unsplash.com/photo-1553284965-83fd3e82fa5a?auto=format&fit=crop&w=900&q=80', 'Alimento energetico para equinos.'),
(29, 'VAC002', 'Concentrado Bovino', 'comida', 72000.00, 27, 6, '2027-12-31', 'vaca', 'https://images.unsplash.com/photo-1527153857715-3908f2bae5e8?auto=format&fit=crop&w=900&q=80', 'Alimento para ganado bovino.'),
(30, 'VAC003', 'Desparasitante Bovino', 'salud', 54000.00, 11, 4, '2027-06-30', 'vaca', 'https://images.unsplash.com/photo-1527153857715-3908f2bae5e8?auto=format&fit=crop&w=900&q=80', 'Producto veterinario para control parasitario.'),
(31, 'VAC004', 'Cepillo para Ganado', 'aseo', 36000.00, 15, 3, '2027-12-31', 'vaca', 'https://images.unsplash.com/photo-1527153857715-3908f2bae5e8?auto=format&fit=crop&w=900&q=80', 'Accesorio para limpieza de bovinos.'),
(32, 'AVE002', 'Alimento para Gallinas', 'comida', 42000.00, 30, 6, '2027-12-31', 'ave', 'https://images.unsplash.com/photo-1548550023-2bdb3c5beed7?auto=format&fit=crop&w=900&q=80', 'Alimento completo para aves de corral.'),
(33, 'AVE003', 'Bebedero para Aves', 'accesorios', 18000.00, 37, 8, '2027-12-31', 'ave', 'https://images.unsplash.com/photo-1444464666168-49d633b86797?auto=format&fit=crop&w=900&q=80', 'Bebedero plastico resistente.'),
(34, 'AVE004', 'Desinfectante Gallinero', 'aseo', 27000.00, 20, 5, '2027-10-30', 'ave', 'https://images.unsplash.com/photo-1587300003388-59208cc962cb?auto=format&fit=crop&w=900&q=80', 'Producto para limpieza de espacios de aves.'),
(35, 'ABC123', 'Purina Avicola', 'comida', 10000.00, 30, 5, '2026-05-08', 'ave', 'https://www.kiwoko.com/dw/image/v2/BDLQ_PRD/on/demandware.static/-/Sites-kiwoko-master-catalog/default/dw11e30509/images/comida_pajaros_vitakraft_agaporni_african_VIT21641_M.jpg?sw=780&sh=780&sm=fit&q=85', 'Es muy bueno');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedores`
--

CREATE TABLE `proveedores` (
  `id_proveedor` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `contacto` varchar(100) DEFAULT NULL,
  `telefono` varchar(30) DEFAULT NULL,
  `correo` varchar(100) DEFAULT NULL,
  `direccion` varchar(150) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `proveedores`
--

INSERT INTO `proveedores` (`id_proveedor`, `nombre`, `contacto`, `telefono`, `correo`, `direccion`) VALUES
(1, 'Distribuidora VetBoyacá', 'Andrés López', '3015558899', 'ventas@vetboyaca.com', 'Tunja, Boyacá'),
(2, 'PetMedical S.A.S', 'María Torres', '3157778899', 'contacto@petmedical.com', 'Bogotá D.C.');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reportes`
--

CREATE TABLE `reportes` (
  `id_reporte` int(11) NOT NULL,
  `tipo` varchar(100) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `fecha_generacion` datetime DEFAULT current_timestamp(),
  `id_usuario` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `id_rol` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`id_rol`, `nombre`) VALUES
(6, 'ADMIN'),
(1, 'Administrador'),
(4, 'Cliente'),
(5, 'ENFERMERO'),
(3, 'Recepcionista'),
(2, 'Veterinario');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuario` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `correo` varchar(100) NOT NULL,
  `contrasena` varchar(255) NOT NULL,
  `id_rol` int(11) NOT NULL,
  `estado` varchar(20) DEFAULT 'ACTIVO',
  `foto_perfil` varchar(255) DEFAULT NULL,
  `google_id` varchar(255) DEFAULT NULL,
  `proveedor` varchar(20) NOT NULL DEFAULT 'LOCAL',
  `fecha_registro` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `nombre`, `correo`, `contrasena`, `id_rol`, `estado`, `foto_perfil`, `google_id`, `proveedor`, `fecha_registro`) VALUES
(1, 'Administrador CliniPet', 'admin@clinipet.com', '$2a$10$5cLWvvCA0QOUn.m5viSGEuF2h2TxIvz/278T/hV.khxYuyH2xFOSq', 1, 'ACTIVO', 'user1_ef202eb8.png', NULL, 'LOCAL', '2026-04-28 07:27:21'),
(2, 'Veterinario Demo', 'veterinario@clinipet.com', '123456', 2, 'ACTIVO', NULL, NULL, 'LOCAL', '2026-04-28 07:27:21'),
(3, 'Recepcionista Demo', 'recepcion@clinipet.com', '123456', 3, 'ACTIVO', NULL, NULL, 'LOCAL', '2026-04-28 07:27:21'),
(4, 'Cliente Demo', 'cliente@clinipet.com', '$2a$10$IV9PT/AydQHlcIy.CUmih.YK1R6qoOOueqgZdLqWms2kzfY3Cdv8G', 4, 'ACTIVO', NULL, NULL, 'LOCAL', '2026-04-28 07:27:21'),
(5, 'Andres Manrique', 'andres@gmail.com', '123456', 5, 'ACTIVO', NULL, NULL, 'LOCAL', '2026-06-03 07:02:40'),
(6, 'Dr. Carlos Ramírez', 'carlos@clinipet.com', 'vet123', 2, 'ACTIVO', NULL, NULL, 'LOCAL', '2026-06-04 14:34:01'),
(7, 'Dra. Laura Gómez', 'laura@clinipet.com', 'vet123', 2, 'ACTIVO', NULL, NULL, 'LOCAL', '2026-06-04 14:34:01'),
(8, 'Dr. Andrés Torres', 'andres@clinipet.com', 'vet123', 2, 'ACTIVO', NULL, NULL, 'LOCAL', '2026-06-04 14:34:01'),
(9, 'Dr. Julian Acevedo', 'julian@gmail.com', 'vet123', 2, 'ACTIVO', NULL, NULL, 'LOCAL', '2026-06-04 14:34:01'),
(10, 'Dr. Dario Bohorquez', 'dario@gmail.com', 'vet123', 2, 'ACTIVO', NULL, NULL, 'LOCAL', '2026-06-04 14:34:01'),
(13, 'juanito', 'juanito@gmail.com', '123456', 4, 'ACTIVO', NULL, NULL, 'LOCAL', '2026-06-04 15:03:09'),
(14, 'Jhonatan Montaña', 'jhouprez@gmail.com', '123456', 4, 'ACTIVO', NULL, '115997782062637139241', 'LOCAL', '2026-06-23 06:37:23'),
(15, 'juanchito tovar', 'primo@gmail.com', 'emr4V55b6i9c+kI/BatWPA==:UEimasxLZfaVahWwozbHMqY8DDuxA1M8yDpCp+scm4c=', 4, 'ACTIVO', NULL, NULL, 'LOCAL', '2026-06-26 06:45:02'),
(16, 'billy', 'billy@gmail.com', '$2a$10$mt0lLfM/iADB1UUWJB6wIe6DtLc6650NgJr8N.kydE/jvMa9alwom', 6, 'ACTIVO', NULL, NULL, 'LOCAL', '2026-06-30 16:52:00'),
(17, 'ALDERSON DARIO BOHORQUEZ BUITRAGO', 'aldersonbohorquez@gmail.com', '$2a$10$6DaA9kYN5auRhtrV09pNJuRnUctPwwu68d8P6fG0/lBUXf/n6lzVi', 4, 'ACTIVO', 'user17_b8472e3e.png', '105661409673590979371', 'LOCAL', '2026-06-30 17:16:44');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vacunas`
--

CREATE TABLE `vacunas` (
  `id_vacuna` int(11) NOT NULL,
  `id_mascota` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `lote` varchar(50) DEFAULT NULL,
  `fecha_aplicacion` date NOT NULL,
  `proxima_fecha` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `vacunas`
--

INSERT INTO `vacunas` (`id_vacuna`, `id_mascota`, `nombre`, `lote`, `fecha_aplicacion`, `proxima_fecha`) VALUES
(1, 1, 'Rabia', 'RB-2026-01', '2026-01-15', '2027-01-15'),
(2, 2, 'Triple Felina', 'TF-2026-02', '2026-02-20', '2027-02-20');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventas`
--

CREATE TABLE `ventas` (
  `id_venta` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `total` decimal(10,2) NOT NULL,
  `metodo_pago` varchar(30) DEFAULT 'EFECTIVO',
  `fecha` datetime DEFAULT current_timestamp(),
  `estado` varchar(30) DEFAULT 'CONFIRMADO'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `ventas`
--

INSERT INTO `ventas` (`id_venta`, `id_usuario`, `total`, `metodo_pago`, `fecha`, `estado`) VALUES
(1, 3, 53000.00, 'EFECTIVO', '2026-04-28 07:27:21', 'CONFIRMADO'),
(2, 3, 45000.00, 'TARJETA', '2026-04-28 07:27:21', 'CONFIRMADO'),
(3, 1, 72000.00, 'PENDIENTE', '2026-04-29 14:35:42', 'CONFIRMADO'),
(5, 4, 35000.00, 'PENDIENTE', '2026-04-30 11:22:28', 'CONFIRMADO'),
(1012, 4, 35000.00, 'EFECTIVO', '2026-06-04 14:42:13', 'CONFIRMADO'),
(1015, 13, 35000.00, 'EFECTIVO', '2026-06-04 15:10:13', 'CONFIRMADO'),
(1016, 13, 105000.00, 'EFECTIVO', '2026-06-04 15:10:41', 'CONFIRMADO'),
(1032, 13, 36000.00, 'EFECTIVO', '2026-06-05 09:25:01', 'CONFIRMADO'),
(1033, 13, 475000.00, 'EFECTIVO', '2026-06-05 09:25:01', 'CONFIRMADO'),
(1034, 13, 60000.00, 'EFECTIVO', '2026-06-05 09:25:02', 'CONFIRMADO'),
(1036, 13, 190000.00, 'EFECTIVO', '2026-06-23 10:36:30', 'CONFIRMADO'),
(1037, 13, 152000.00, 'EFECTIVO', '2026-06-23 10:36:30', 'CONFIRMADO'),
(1039, 4, 30000.00, 'EFECTIVO', '2026-06-30 16:53:51', 'CONFIRMADO'),
(1040, 4, 54000.00, 'EFECTIVO', '2026-06-30 16:53:51', 'CONFIRMADO');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `veterinarios`
--

CREATE TABLE `veterinarios` (
  `id_veterinario` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `correo` varchar(120) DEFAULT NULL,
  `telefono` varchar(30) DEFAULT NULL,
  `especialidad` varchar(100) DEFAULT NULL,
  `estado` varchar(30) DEFAULT 'DISPONIBLE',
  `id_usuario` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `veterinarios`
--

INSERT INTO `veterinarios` (`id_veterinario`, `nombre`, `correo`, `telefono`, `especialidad`, `estado`, `id_usuario`) VALUES
(1, 'Dr. Carlos Ramírez', 'carlos@clinipet.com', '3001112233', 'Medicina general', 'DISPONIBLE', 6),
(2, 'Dra. Laura Gómez', 'laura@clinipet.com', '3004445566', 'Vacunación y control', 'DISPONIBLE', 7),
(3, 'Dr. Andrés Torres', 'andres@clinipet.com', '3007778899', 'Cirugía menor', 'DISPONIBLE', 8),
(4, 'Dr. Julian Acevedo', 'julian@gmail.com', '3112026454', 'cirujano', 'DISPONIBLE', 9),
(5, 'Dr. Dario Bohorquez', 'dario@gmail.com', '3114569870', 'cirujano', 'DISPONIBLE', 10);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `citas`
--
ALTER TABLE `citas`
  ADD PRIMARY KEY (`id_cita`),
  ADD KEY `id_mascota` (`id_mascota`),
  ADD KEY `id_veterinario` (`id_veterinario`),
  ADD KEY `id_doctor` (`id_doctor`);

--
-- Indices de la tabla `detalle_orden_compra`
--
ALTER TABLE `detalle_orden_compra`
  ADD PRIMARY KEY (`id_detalle_orden`),
  ADD KEY `id_orden` (`id_orden`),
  ADD KEY `id_producto` (`id_producto`);

--
-- Indices de la tabla `detalle_venta`
--
ALTER TABLE `detalle_venta`
  ADD PRIMARY KEY (`id_detalle`),
  ADD KEY `id_venta` (`id_venta`),
  ADD KEY `id_producto` (`id_producto`);

--
-- Indices de la tabla `duenios`
--
ALTER TABLE `duenios`
  ADD PRIMARY KEY (`id_duenio`),
  ADD UNIQUE KEY `documento` (`documento`),
  ADD UNIQUE KEY `correo` (`correo`),
  ADD KEY `idx_duenios_id_usuario` (`id_usuario`);

--
-- Indices de la tabla `historias_clinicas`
--
ALTER TABLE `historias_clinicas`
  ADD PRIMARY KEY (`id_historia`),
  ADD KEY `id_mascota` (`id_mascota`),
  ADD KEY `id_cita` (`id_cita`),
  ADD KEY `idx_historia_cita` (`id_cita`);

--
-- Indices de la tabla `mascotas`
--
ALTER TABLE `mascotas`
  ADD PRIMARY KEY (`id_mascota`),
  ADD KEY `id_duenio` (`id_duenio`);

--
-- Indices de la tabla `ordenes_compra`
--
ALTER TABLE `ordenes_compra`
  ADD PRIMARY KEY (`id_orden`),
  ADD KEY `id_proveedor` (`id_proveedor`);

--
-- Indices de la tabla `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_token` (`token`),
  ADD KEY `idx_correo` (`correo`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`id_producto`),
  ADD UNIQUE KEY `codigo` (`codigo`);

--
-- Indices de la tabla `proveedores`
--
ALTER TABLE `proveedores`
  ADD PRIMARY KEY (`id_proveedor`);

--
-- Indices de la tabla `reportes`
--
ALTER TABLE `reportes`
  ADD PRIMARY KEY (`id_reporte`),
  ADD KEY `id_usuario` (`id_usuario`);

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id_rol`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usuario`),
  ADD UNIQUE KEY `correo` (`correo`),
  ADD UNIQUE KEY `uq_usuarios_google_id` (`google_id`),
  ADD KEY `id_rol` (`id_rol`);

--
-- Indices de la tabla `vacunas`
--
ALTER TABLE `vacunas`
  ADD PRIMARY KEY (`id_vacuna`),
  ADD KEY `id_mascota` (`id_mascota`);

--
-- Indices de la tabla `ventas`
--
ALTER TABLE `ventas`
  ADD PRIMARY KEY (`id_venta`),
  ADD KEY `id_usuario` (`id_usuario`);

--
-- Indices de la tabla `veterinarios`
--
ALTER TABLE `veterinarios`
  ADD PRIMARY KEY (`id_veterinario`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `citas`
--
ALTER TABLE `citas`
  MODIFY `id_cita` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `detalle_orden_compra`
--
ALTER TABLE `detalle_orden_compra`
  MODIFY `id_detalle_orden` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `detalle_venta`
--
ALTER TABLE `detalle_venta`
  MODIFY `id_detalle` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT de la tabla `duenios`
--
ALTER TABLE `duenios`
  MODIFY `id_duenio` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `historias_clinicas`
--
ALTER TABLE `historias_clinicas`
  MODIFY `id_historia` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `mascotas`
--
ALTER TABLE `mascotas`
  MODIFY `id_mascota` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `ordenes_compra`
--
ALTER TABLE `ordenes_compra`
  MODIFY `id_orden` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `id_producto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT de la tabla `proveedores`
--
ALTER TABLE `proveedores`
  MODIFY `id_proveedor` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `reportes`
--
ALTER TABLE `reportes`
  MODIFY `id_reporte` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `id_rol` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT de la tabla `vacunas`
--
ALTER TABLE `vacunas`
  MODIFY `id_vacuna` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `ventas`
--
ALTER TABLE `ventas`
  MODIFY `id_venta` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1041;

--
-- AUTO_INCREMENT de la tabla `veterinarios`
--
ALTER TABLE `veterinarios`
  MODIFY `id_veterinario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `citas`
--
ALTER TABLE `citas`
  ADD CONSTRAINT `citas_ibfk_1` FOREIGN KEY (`id_mascota`) REFERENCES `mascotas` (`id_mascota`),
  ADD CONSTRAINT `citas_ibfk_2` FOREIGN KEY (`id_veterinario`) REFERENCES `usuarios` (`id_usuario`),
  ADD CONSTRAINT `citas_ibfk_3` FOREIGN KEY (`id_doctor`) REFERENCES `veterinarios` (`id_veterinario`);

--
-- Filtros para la tabla `detalle_orden_compra`
--
ALTER TABLE `detalle_orden_compra`
  ADD CONSTRAINT `detalle_orden_compra_ibfk_1` FOREIGN KEY (`id_orden`) REFERENCES `ordenes_compra` (`id_orden`),
  ADD CONSTRAINT `detalle_orden_compra_ibfk_2` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`);

--
-- Filtros para la tabla `detalle_venta`
--
ALTER TABLE `detalle_venta`
  ADD CONSTRAINT `detalle_venta_ibfk_1` FOREIGN KEY (`id_venta`) REFERENCES `ventas` (`id_venta`),
  ADD CONSTRAINT `detalle_venta_ibfk_2` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`);

--
-- Filtros para la tabla `duenios`
--
ALTER TABLE `duenios`
  ADD CONSTRAINT `duenios_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`);

--
-- Filtros para la tabla `historias_clinicas`
--
ALTER TABLE `historias_clinicas`
  ADD CONSTRAINT `historias_clinicas_ibfk_1` FOREIGN KEY (`id_mascota`) REFERENCES `mascotas` (`id_mascota`),
  ADD CONSTRAINT `historias_clinicas_ibfk_2` FOREIGN KEY (`id_cita`) REFERENCES `citas` (`id_cita`);

--
-- Filtros para la tabla `mascotas`
--
ALTER TABLE `mascotas`
  ADD CONSTRAINT `mascotas_ibfk_1` FOREIGN KEY (`id_duenio`) REFERENCES `duenios` (`id_duenio`);

--
-- Filtros para la tabla `ordenes_compra`
--
ALTER TABLE `ordenes_compra`
  ADD CONSTRAINT `ordenes_compra_ibfk_1` FOREIGN KEY (`id_proveedor`) REFERENCES `proveedores` (`id_proveedor`);

--
-- Filtros para la tabla `reportes`
--
ALTER TABLE `reportes`
  ADD CONSTRAINT `reportes_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`);

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `usuarios_ibfk_1` FOREIGN KEY (`id_rol`) REFERENCES `roles` (`id_rol`);

--
-- Filtros para la tabla `vacunas`
--
ALTER TABLE `vacunas`
  ADD CONSTRAINT `vacunas_ibfk_1` FOREIGN KEY (`id_mascota`) REFERENCES `mascotas` (`id_mascota`);

--
-- Filtros para la tabla `ventas`
--
ALTER TABLE `ventas`
  ADD CONSTRAINT `ventas_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
