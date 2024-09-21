section .data
	memoria DD 10 DUP(0) ;valor de conteo
	palabra DD 10 DUP(0) ;palabra como tal
	conteo DD 1 DUP(0) ;para saber en que palabra estoy
	filedescr DD 1 DUP(0)
	actualW DD 1 DUP(0)
	menor DD 1 DUP(0) ;la menor palabra
	menorValo DD 1 DUP(0) ;la menor palabra (valor)
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
_lectura: ;ACA ES LA LECTURA
	MOV ebx,[filedescr] 
	MOV eax, 3 
	MOV ecx , buffer 
	MOV edx , 60000 
	INT 80h
_counters:;asigna el conteo de palabras y el offset a valores correspondientes	
	MOV edi,1 ;asigna el contador de cuantas veces aparece la palabra, por default es 1
	MOV ebx ,[conteo]
	SHL ebx, 2  ; multiplica * 4 el conteo para saber el offset
	MOV esi, ebx ;contador del lseek
	
	MOV ecx,0 ;contador de movimiento en el buffer.
	MOV edx, [buffer+esi] ;mueve a edx lo que haya en buffer , posicion 1
	
	;CONDICION DE SALIDA
	CMP edx,0  ;si el buffer es 0, salta a fin de lectura 
	JE _salida
	;CONDICION DE SALIDA
	MOV [actualW] , edx ;guarda la palabra que compara actualmente.
	
repetida: ;sale del bucle hasta que verifique que no esta repetida o si este repetida
	;USA ECX,EDX,EBX,EAX
	CMP ecx, 10 
	JE preproce ;si no esta repetida la procesa
	
	MOV ebx, ecx          ; Inicializamos ECX con el valor que queramos
	SHL ebx, 2          ; Desplazamos el valor de ECX dos bits a la izquierda (equivalente a multiplicar por 4)
	MOV eax , [palabra+ebx]
	CMP edx, eax   ;compara si la palabra es igual
	JE finalizar ;se va a finalizar para pasar a la siguiente palabra
	ADD ecx,1
	JMP repetida
preproce:
	MOV ecx,esi ;contador de movimiento en el buffer.
	MOV edx, [actualW] ;mueve a edx lo que haya en buffer , posicion 1
	;ACA EDX SIGUE SIENDO EL PRIMER ELEMENTO DEL BUFFER
procesado: 
	CMP ecx,60000 ;si esi es igual al maximo del buffer llegue al final del procesado
	JE fin_lectura ;
	ADD ecx,4     ; Cargar el valor en la posición actual del buffer
	MOV ebx, [buffer + ecx]  ; Cargar el valor en la siguiente posición del buffer
	CMP edx, ebx                 ; Comparar los dos valores
	JNE procesado ;si no son iguales iguales salta a procesado
suma: 
	ADD edi,1
	JMP procesado			
fin_lectura: 
	MOV ecx, [menorValo]
_comparacion:
	CMP edi, ecx ;compara el valor del menor cuenteo con el conteo y si el conteo es menor, no tiene que reemplazar.
	JLE finalizar ;si edi menor o igual que el menor valor, hace el salto a finalizar
	;si es mayor sigue a guardar
guardar:
	MOV ebx,[menor] ;se mueve a la direccion del menor numero
	MOV [memoria+ebx] ,  edi ; guarda en memoria el valor del conteo
	MOV eax, [actualW] ;carga en eax el valor de la palabra actual
	MOV [palabra+ebx] , eax ;guarda en memoria la palabra actual.
	
	MOV ecx, 0                  ; Inicializar el contador
    	MOV eax, [memoria]           ; Inicializar el primer valor de EAX con la primera posición del array

nuevomenor:
    	CMP ecx, 10                  ; Si llegamos al final del array (10 elementos), saltar a "finalizar"
    	JE finalizar

    	MOV ebx, ecx                 ; Copiar ECX en EBX para calcular el offset
    	SHL ebx, 2                   ; Multiplicar EBX por 4 (cada número ocupa 4 bytes)
    	MOV edx, [memoria + ebx]     ; Cargar el valor actual del array

    	CMP edx, eax                 ; Comparar el valor actual con el menor valor
    	JGE siguiente                 ; Si EDX >= EAX, continuar con el siguiente elemento

    	; Si encontramos un nuevo menor:
    	MOV eax, edx                 ; Actualizar EAX con el nuevo menor valor
    	MOV [menorValo], eax         ; Guardar el nuevo menor valor
    	MOV [menor], ebx             ; Guardar el offset del nuevo menor

siguiente:
    	ADD ecx, 1                   ; Incrementar ECX para pasar al siguiente valor
    	JMP nuevomenor               ; Repetir el ciclo
    	
finalizar: 
	MOV ebx,[conteo]
    
    	ADD ebx, 1            ; Sumar 4 a ebx , dadoq ue son 15 mil bytes
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
    	;MODIFICACION
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

	

