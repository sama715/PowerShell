$sourceDir = "C:\Users\RS\OneDrive\Escritorio\Test"
$destinationDir = "C:\Users\RS\OneDrive\Escritorio\Test\Zipeados_antiguos"
$today = (Get-Date).AddDays(-1).ToString("yyyyMMdd")
$prefijo = "file_"


#Caso1: todos los dias a las 00:00 se genera un archivo nuevo de log con fecha actual, entonces el el directorio a las 00:00
#Existiran 2 archivos, ejemplo, uno llamado Archivo_20230313 y otro (Archivo_20230314 <--que se genero a las 00:00)
#Solucion: Buscar el archivo: ( prefijo "Archivo_" + fecha de jecucion del script 7 dias atras por si los findes no genera archivos
#Codigo: Busca el archivo $prefijo + la fecha anterior a la que se ejecuta el script(7 dias para atras), lo zipea y borra

for ($i = 1; $i -le 7; $i++) {
    $fileDate = (Get-Date).AddDays(-$i).ToString("yyyyMMdd")
    $fileName = $prefijo + $fileDate + ".log"
    if (Test-Path "$sourceDir\$fileName") {
        $zipName = $fileName + ".zip" # Nombre del archivo ZIP
        $zipFile = Join-Path $destinationDir $zipName # Ruta completa del archivo ZIP en la carpeta de destino
        Compress-Archive -Path "$sourceDir\$fileName" -DestinationPath $zipFile -CompressionLevel Optimal
        Remove-Item "$sourceDir\$fileName" # Elimina el archivo original después de comprimirlo
        break # Detiene el ciclo for si se encuentra y comprime el archivo
    }
}


#Caso2: Archivo LOG que siempre tiene el mismo nombre pero incrementa el contenido
#Solucion: Busca el archivo de la variable $Archivoabuscar2, lo zipea con fecha anterior a la ejecucion y elimina (al la app que logea creara otro)  
 
$Archivoabuscar2 = "log_file.log"
if (Test-Path "$sourceDir\$Archivoabuscar2") {
    $zipName = $Archivoabuscar2 + "_" + $today + ".zip" # Nombre del archivo ZIP con la fecha actual menos un día
    $zipFile = Join-Path $destinationDir $zipName # Ruta completa del archivo ZIP en la carpeta de destino
    Compress-Archive -Path "$sourceDir\$Archivoabuscar2" -DestinationPath $zipFile -CompressionLevel Optimal
    Remove-Item "$sourceDir\$Archivoabuscar2"
}
