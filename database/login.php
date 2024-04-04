<?php
header("Access_Control_Allow_Headers": "Access_Control_Allow_Origin, Accept");
require 'config.php';
$output = array();
if ($conn) {
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        if (isset($_POST['auth_key']) && $_POST['auth_key'] == $auth_key) {
            $user_email = $_POST['user_email'];
            $user_password = $_POST['user_password'];
            $query = "SELECT * FROM `users` 
            WHERE  user_email='$user_email' AND user_password ='$user_password'";
            $run = mysqli_query($conn, $query);
            if (mysqli_num_rows($run) > 0) {
                $row = mysqli_fetch_array($run);
                $temp['user_id'] = $row['user_id'];
                $temp['user_name'] = $row['user_name'];
                $temp['user_email'] = $row['user_email'];
                $temp['user_password'] = $row['user_password'];
                $temp['user_country'] = $row['user_country'];
                $temp['code'] = 1;
                array_push($output, $temp);
                echo json_encode($output, JSON_UNESCAPED_SLASHES);
            } else {
                $temp['code'] = 0;
                array_push($output, $temp);
                echo json_encode($output, JSON_UNESCAPED_SLASHES);
            }
        } else {
            $temp['code'] = "Access forbidden";
            array_push($output, $temp);
            echo json_encode($output, JSON_UNESCAPED_SLASHES);
        }
    }
} else {
    $temp['code'] = "connection error";
    array_push($output, $temp);
    echo json_encode($output, JSON_UNESCAPED_SLASHES);
}
