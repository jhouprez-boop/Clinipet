-- ============================================================
-- Migración v17 - CliniPet
-- Agrega soporte para:
--   1) Login con Google (Google Sign-In)
--   2) Avatar / foto de perfil editable
--   3) Marca de proveedor de cuenta (LOCAL o GOOGLE)
--
-- Las contraseñas NO se migran aquí con un UPDATE masivo porque
-- BCrypt no se puede generar en SQL puro. La aplicación migra
-- cada contraseña en texto plano a BCrypt automáticamente la
-- primera vez que ese usuario inicia sesión (ver UsuarioDAO.login).
-- ============================================================

ALTER TABLE `usuarios`
  ADD COLUMN `foto_perfil` VARCHAR(255) DEFAULT NULL AFTER `estado`,
  ADD COLUMN `google_id`   VARCHAR(255) DEFAULT NULL AFTER `foto_perfil`,
  ADD COLUMN `proveedor`   VARCHAR(20)  NOT NULL DEFAULT 'LOCAL' AFTER `google_id`;

ALTER TABLE `usuarios`
  ADD UNIQUE KEY `uq_usuarios_google_id` (`google_id`);
