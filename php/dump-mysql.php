<?php

$DBUSER= DB_USER;
$DBPASSWD= DB_PASSWORD;
$DATABASE= DB_NAME;
$HOST = DB_HOST;

$filename = "backup-" . date("d-m-Y") . ".sql.gz";
$mime = "application/x-gzip";

header( "Content-Type: " . $mime );
header( 'Content-Disposition: attachment; filename="' . $filename . '"' );

$cmd = "mysqldump -u $DBUSER -h $HOST --password=$DBPASSWD $DATABASE | gzip --best";   

passthru( $cmd );

exit(0);
?>