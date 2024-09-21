section .data
	memoria DD 10 DUP(0) ;valor de conteo
	palabra DD 10 DUP(0) ;palabra como tal
	conteo DD 1 DUP(0) ;para saber en que palabra estoy
	filedescr DD 1 DUP(0)
	actualW DD 1 DUP(0)
	pathname DD "/home/huevitoentorta/Documents/Arqui1/proyecto1arqui1/archivo_nuevo.bin"
	writepath DD "/home/huevitoentorta/Documents/Arqui1/grafico.bin"
	
section .bss
	buffer: resd 15000 
section .text
global _start
_start: ;apertura del archivo
	MOV eax,5     
	MOV ebx, pathname
	MOV ecx,0
	INT 80h
	MOV [filedescr] , eax ;guarda el file descriptor
	
_counters:;asigna el conteo de palabras y el offset a valores correspondientes	
	MOV edi,1 ;asigna el contador de cuantas veces aparece la palabra, por default es 1
	MOV ebx ,[conteo]
	SHL ebx, 2  ; multiplica * 4 el conteo para saber el offset
	MOV esi, ebx ;contador del lseek
_desplazamiento:
	MOV ebx,[filedescr]
	MOV eax,19
	MOV ecx ,esi ;esi es donde llevo el contador del puntero al archivo.
	MOV edx,0 
	INT 80h
_lectura: ;ACA ES LA LECTURA
	MOV ebx,[filedescr] 
	MOV eax, 3 
	MOV ecx , buffer 
	MOV edx , 60000 
	INT 80h
	CMP eax,0 si el buffer es 0, salta a fin de lectura 
	JE _salida
	
	 
	MOV ecx,0 ;contador de movimiento en el buffer.
	MOV edx, [buffer] ;mueve a edx lo que haya en buffer , posicion 1
	MOV [actualW] , edx ;guarda la palabra que compara actualmente.
procesado: 
	CMP ecx,15000 ;si esi es igual al maximo del buffer llegue al final del procesado
	JE fin_lectura ;
	ADD ecx,4     ; Cargar el valor en la posición actual del buffer
	MOV ebx, [buffer + ecx]  ; Cargar el valor en la siguiente posición del buffer
	CMP edx, ebx                 ; Comparar los dos valores
	JNE procesado ;si no son iguales iguales salta a procesado
suma: 
	ADD edi,1
	JMP procesado			
fin_lectura: 
	MOV ecx,0
_comparacion:
	CMP ecx, 11
	JE finalizar ;si ninguno es mayor, finaliza
	
	MOV ebx, ecx          ; Inicializamos ECX con el valor que queramos
	SHL ebx, 2          ; Desplazamos el valor de ECX dos bits a la izquierda (equivalente a multiplicar por 4)
	CMP [memoria+ebx],edi   ;edi contiene el conteo  esi contiene los despplazamientos
	JL guardar
	ADD ecx,1
	JMP _comparacion
guardar:
	MOV [memoria+ebx] ,  edi
	MOV eax, [actualW] ;carga en eax el valor de la palabra actual
	MOV [palabra+ebx] , eax ;CAMBIAR ESTE EDI POR LA PALABRA ACTUAL.	
finalizar: ;revisa si ya es igual
	MOV ebx,[conteo]
    	CMP ebx, 60000      ; Comparar conteo con tamaño de 60 mil bytes
    	JGE _salida             ; Si conteo >= tamaño, ir a salida

    	ADD ebx, 4             ; Sumar 4 a ebx , dadoq ue son 15 mil bytes
    	MOV [conteo], ebx       ; Guardar el nuevo conteo en memoria
    	JMP _counters           ; Volver a empezar

_salida: ;escriba en un texto los resultados
	; Abrir el archivo para escritura
    	MOV eax, 5          ; syscall: sys_open
    	MOV ebx, writepath  ; nombre del archivo
    	MOV ecx, 1          ; O_WRONLY
    	INT 0x80            ; llamar al kernel
    	MOV ebx, eax        ; guardar el file descriptor
    	
    	; Escribir los datos de 'palabra' en el archivo
    	MOV eax, 4          ; syscall: sys_write
    	MOV ecx, palabra    ; dirección de 'palabra'
    	MOV edx, 40         ; número de bytes a escribir (10 * 4 bytes)
    	INT 0x80            ; llamar al kernel
    	
    	; Escribir los datos de 'memoria' en el archivo
    	MOV eax, 4          ; syscall: sys_write
    	MOV ecx, memoria    ; dirección de 'memoria'
    	MOV edx, 40         ; número de bytes a escribir (10 * 4 bytes)
    	INT 0x80            ; llamar al kernel

	    ; Cerrar el archivo
    	MOV eax, 6          ; syscall: sys_close
    	INT 0x80            ; llamar al kernel

    	; Salir del programa
   	MOV eax, 1          ; syscall: sys_exit
    	XOR ebx, ebx        ; código de salida 0
    	INT 0x80            ; llamar al kernel

	

