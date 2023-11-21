<?php
header('Access-Control-Allow-Headers: access');
header('Access-Control-Allow-Origin: *');
$metodo = $_SERVER['REQUEST_METHOD'];
if ($metodo != "POST") {
    http_response_code(400);
    echo json_encode(array("mensaje" => "Método incorrecto, debe ser POST"));
    die();
}

define('API_KEY', "e1f602bf73cc96f53c10bb7f7953a438fb7b3c0a");
$headers = apache_request_headers();
if (isset($headers["authorization"])) {
    if ($headers["authorization"] == 'e1f602bf73cc96f53c10bb7f7953a438fb7b3c0a') {
        require_once "conexion.php";
        if (isset($_POST["nombre"]) && isset($_POST["apellido"]) && isset($_POST["email"]) && isset($_POST["u_password"])) {
            $nombre = $_POST["nombre"];
            $apellido = $_POST["apellido"];
            $email = $_POST["email"];
            $password = $_POST["u_password"];

            if (empty(trim($nombre)) || empty(trim($apellido)) || empty(trim($email)) || empty(trim($password))) {
                echo json_encode(array("mensaje" => "Todos los campos son obligatorios"));
            } else {
                // Verificar formato de email electrónico
                if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
                    echo json_encode(array("mensaje" => "El formato del email electrónico es inválido"));
                    die();
                }

                // Verificar si el email ya está en uso
                $stmt_check_email = $con->prepare("SELECT email FROM usuario WHERE email = ?");
                $stmt_check_email->bindParam(1, $email);
                $stmt_check_email->execute();
                $result = $stmt_check_email->fetch(PDO::FETCH_ASSOC);

                if ($result) {
                    echo json_encode(array("mensaje" => "El email electrónico ya está registrado"));
                    die();
                }




                // Si pasó las validaciones, procede a insertar en la base de datos
                $sql = "INSERT INTO usuario (nombre, apellido, email, u_password)
                        VALUES(?, ?, ?, ?)";

                $st = $con->prepare($sql);
                $valores = array($nombre, $apellido, $email, $password);
                $rst = $st->execute($valores);
                if ($rst > 0) {
                    echo json_encode(array("mensaje" => "Se registró un producto"));
                } else {
                    echo json_encode(array("mensaje" => "Error al registrar"));
                }
            }
        } else {
            $pNombre = isset($_POST["nombre"]) ? "" : "[nombre]";
            $pApellido = isset($_POST["apellido"]) ? "" : "[apellido]";
            $pemail = isset($_POST["email"]) ? "" : "[email]";
            $pPassword = isset($_POST["u_password"]) ? "" : "[u_password]";
            echo json_encode(array("mensaje" => "Faltan los parámetros $pNombre $pApellido $pemail $pPassword en la petición"));
        }
    } else {
        http_response_code(400);
        echo json_encode(array("mensaje" => "API_KEY incorrecto"));
        die();
    }
} else {
    http_response_code(400);
    echo json_encode(array("mensaje" => "Falta el API_KEY"));
    die();
}
?>
