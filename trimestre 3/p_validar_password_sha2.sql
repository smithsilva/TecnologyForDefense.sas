CREATE DEFINER=`root`@`localhost` PROCEDURE `p_validar_password_sha2`(
    IN p_password_intento VARCHAR(255),
    IN p_password_hash_almacenado VARCHAR(255),
    OUT p_es_valida BOOLEAN
)
BEGIN
    DECLARE v_salt_almacenado VARCHAR(64);
    DECLARE v_hash_almacenado VARCHAR(128);
    DECLARE v_hash_calculado VARCHAR(128);

    -- Validar entrada
    IF p_password_intento IS NULL OR TRIM(p_password_intento) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La contraseña ingresada no puede estar vacía';
    END IF;

    IF p_password_hash_almacenado IS NULL OR p_password_hash_almacenado = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El hash almacenado es inválido';
    END IF;

    -- Validar formato salt:hash
    IF LOCATE(':', p_password_hash_almacenado) = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Formato de contraseña inválido';
    END IF;

    -- Extraer salt y hash
    SET v_salt_almacenado = SUBSTRING_INDEX(p_password_hash_almacenado, ':', 1);
    SET v_hash_almacenado = SUBSTRING_INDEX(p_password_hash_almacenado, ':', -1);

    -- Generar hash con el intento
    SET v_hash_calculado = SHA2(CONCAT(p_password_intento, v_salt_almacenado), 256);

    -- Comparar hashes
    SET p_es_valida = (v_hash_calculado = v_hash_almacenado);

END