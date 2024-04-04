<?php
require 'config.php';
$output = array();
if ($conn) {
    if ($_SERVER['REQUEST_METHOD'] === 'GET') {
        if (isset($_GET['auth_key']) && $_GET['auth_key'] == $auth_key) {
            $user_id = $_GET['user_id'];
            $query = "SELECT * FROM coin_purchase_history WHERE `user_id`=$user_id";
            $run = mysqli_query($conn, $query);
            if (mysqli_num_rows($run) > 0) {
                while ($row = mysqli_fetch_array($run)) {
                    $temp = array();
                    $temp['buy_time_date'] = $row['buy_time_date'];
                    $temp['price_in_dollars'] = $row['price_in_dollars'];
                    $temp['no_of_coins'] = $row['no_of_coins'];
                    $temp['code'] = 1;
                    array_push($output, $temp);
                }
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
