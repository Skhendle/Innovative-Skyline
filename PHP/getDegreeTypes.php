<?php

include 'conn.php';

 $query = "SELECT * FROM Degree";


$queryResult=$connect->query($query);

//echo json_encode($queryResult);

$result=array();

while($fetchData=$queryResult->fetch_assoc()){
    $result[]=$fetchData;
}
echo json_encode($result);

?>