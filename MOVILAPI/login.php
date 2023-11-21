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
        if (isset($_POST["email"]) && isset($_POST["u_password"])) {
            $email = $_POST["email"];
            $password = $_POST["u_password"];

            // Verifica que los valores no estén vacíos
            if (empty(trim($email)) || empty(trim($password))) {
                echo json_encode(array("mensaje" => "El email y contraseña son obligatorios"));
            } else {
                // Verificar credenciales en la base de datos (aquí se recomienda utilizar técnicas de hash para las contraseñas)
                $sql = "SELECT * FROM usuario WHERE email=? AND u_password = ?";
                $st = $con->prepare($sql);
                $valor = array($email, $password);
                $st->execute($valor);
                $result = $st->fetchAll(PDO::FETCH_ASSOC);
                
                if($result != null){
                    echo json_encode(array("mensaje" => "Inicio de sesion exitoso"));
                } else {
                    echo json_encode(array("mensaje" => "Usuario o contraseña incorrectos"));
                }
            }
        } else {
            // Manejar el caso en el que faltan parámetros POST requeridos
            $pEmail = isset($_POST['email']) ? "" : "[email]";
            $pPassword = isset($_POST['u_password']) ? "" : "[u_password]";
            echo json_encode(array("mensaje" => "Faltan parámetros $pEmail $pPassword"));
        }
    }
}
?>
