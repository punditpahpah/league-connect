<?php
require 'config.php';
$output = array();
if ($conn) {
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        //if (!empty($_FILES)) {
            if (isset($_POST['auth_key']) && $_POST['auth_key'] == $auth_key) {
                $user_name = $_POST['user_name'];
                $user_email = $_POST['user_email'];
                $user_password = $_POST['user_password'];
                $user_number = $_POST['user_number'];


                        $query = "INSERT INTO `users`(`user_id`, `user_name`, `user_email`, `user_password`, `user_number`)
                         VALUES (null,'$user_name','$user_email','$user_password','$user_number')";
                            if (mysqli_query($conn, $query)) {
                                echo "registered";
                            } else {
                                echo "not registered";
                            }
            
                
            }
             else {
                // $temp = array();
                // $temp['code'] = "Access forbidden";
                echo "Access forbidden";
                // array_push($output, $temp);
                // echo json_encode($output, JSON_UNESCAPED_SLASHES);
            }
        //}
    }
} else {
    // $temp = array();
    // $temp['code'] = "Connection Error";
    echo "Connection Error";
    // array_push($output, $temp);
    // echo json_encode($output, JSON_UNESCAPED_SLASHES);
}
