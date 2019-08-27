;Proyecto final: Temporizador, Se debe ingresar el tiempo, en minutos y segundos; Con un maximo de 99 minutos y 59 segundos
; Ademas existe un cronometro, pero esta incompleto
%macro escribe 2 ;Macro para imprimir mensajes
	mov eax, 4 
	mov ebx, 1
	mov ecx, %1 
	mov edx, %2
	int 0x80
%endmacro

%macro leer 2 ; macro para leer mensajes
	mov eax, 3
	mov ebx, 2
	mov ecx, %1 
	mov edx, %2
	int 0x80
%endmacro

%macro espera 2 ; Generar la espera 
	mov dword [tv_sec], %1
  	mov dword [tv_usec], %2
  	mov eax, 162
  	mov ebx, timeval
  	mov ecx, 0
  	int 0x80
%endmacro

segment .data 
	
	msjInicio db "Elija una opcion: ", 10
	lon_msjInicio equ $- msjInicio
	
	opcionTemp db "1. Temporizador  ", 10
	lon_opcionTemp equ $- opcionTemp
	
	opcionCrono db "2. Cronometro ", 10
	lon_opcionCrono equ $- opcionCrono
	
	opcionSalir db "3. Salir  ", 10
	lon_opcionSalir equ $- opcionSalir
	
	mensajeTeporizador db " ----- TEMPORIZADOR -----", 10
	lon_temp equ $- mensajeTeporizador
	
	mensajeCronometro db " ----- CRONOMETRO -----", 10
	lon_crono equ $- mensajeCronometro
	
	mensajeInicialCronometro db "Pulse enter para iniciar", 10
	lon_mensajeCrono equ $- mensajeInicialCronometro
	
	centrar db " ------ "
	lon_centrar equ $- centrar
	
	millis db "00"
	lon1 equ $- millis
	
	espacio db 10
	lonEsp equ $- espacio
	
	Segundos db "00" 
	lon2 equ $- Segundos
	
	msj db ":"
	lonmsj equ $- msj
	
	minutos db "00"
	lon3 equ $- minutos
	
	ClearTerm: db   27,"[H",27,"[2J"    ; Realiza un clear en el terminal
	CLEARLEN   equ  $-ClearTerm     
	
	msjMinutos db "Ingrese los minutos: "
	lonMin equ $- msjMinutos
	
	msjSegundos db "Ingrese los segundos: "
	lonSeg equ $- msjSegundos
	
	msjFin db "El tiempo Termino!!!"
	lonFin equ $- msjFin

timeval:
	tv_sec  dd 0
    tv_usec dd 0

segment .bss
	num1 resb 2
	inicio resb 2
	opcion resb 1
	
segment .text
	global _start  
_start:  
	Inicio:
		mov ax, '00'
		mov [minutos], ax
		mov [Segundos], ax
		mov [millis], ax
		escribe ClearTerm, CLEARLEN ; Realiza un Clear en el terminal
		;Imprimimos las opciones
		escribe msjInicio, lon_msjInicio
		escribe opcionTemp, lon_opcionTemp
		escribe opcionCrono, lon_opcionCrono
		escribe opcionSalir, lon_opcionSalir
		leer opcion, 2
		mov al, [opcion]
		cmp al, '1'
		jz InicioTemporizador
		cmp al, '2'
		jz InicioCronometro
		cmp al, '3'
		jz salir
		jmp salir
	
	
	InicioTemporizador:
		escribe ClearTerm, CLEARLEN
		escribe mensajeTeporizador, lon_temp

	LeerMinutos:
		escribe msjMinutos, lonMin
		leer inicio, 3
		
		mov ax, [inicio]
		mov [minutos], ax
		cmp ah, '0'; Verifica si el  usuario ingreso un numero de un digito
		jc IgualarMin
		jmp LeerSegundos
		
	LeerSegundos:
		
		escribe msjSegundos, lonSeg
		leer inicio, 3
		
		mov ax, [inicio]
		mov [Segundos], ax
		cmp ah, '0'; Verifica si el  usuario ingreso un numero de un digito
		jc IgualarSeg
		jmp moverTemporizador	
	
	IgualarMin:
		mov [num1], al
		mov al, '0'
		mov ah, [num1]
		mov [minutos], ax
		jmp LeerSegundos
	
	IgualarSeg:
		mov [num1], al
		mov al, '0'
		mov ah, [num1]
		mov [Segundos], ax
		jmp moverTemporizador
		
	moverTemporizador:
		espera 0, 10000000 ;espera de 10 ms

		escribe ClearTerm, CLEARLEN
		escribe mensajeTeporizador, lon_temp
		escribe centrar, lon_centrar
		escribe minutos, lon3
		escribe msj, lonmsj
		escribe Segundos, lon2
		escribe msj, lonmsj
		escribe millis, lon1
		escribe centrar, lon_centrar
		
		mov ax, [millis]
		
		mov bl, "0"
		cmp bl, ah
		jz MillisTemporizador
		
		dec ah
		mov [millis], ax
		escribe espacio, lonEsp
		jmp moverTemporizador
	
	MillisTemporizador:
		mov ah,"9"
		mov bl, "0"
		cmp bl, al
		jz SegundosTemporizador
		dec al
		mov [millis], ax
		escribe espacio, lonEsp
		jmp moverTemporizador

	SegundosTemporizador:
		mov ax,"99"
		mov [millis], ax
		
		mov ax, [Segundos]
		
		mov bl, "0"
		cmp bl, ah
		jz SegundosTemporizador2
		dec ah
		mov [Segundos], ax
		escribe espacio, lonEsp
		jmp moverTemporizador
		
	SegundosTemporizador2:
		mov ah,"9"
		
		mov bl, "0"
		cmp bl, al
		jz MinutosTemporizador
		dec al
		mov [Segundos], ax
		escribe espacio, lonEsp
		jmp moverTemporizador
		
	MinutosTemporizador:
		mov ax,"99"
		mov [millis], ax
		mov ax,"59"
		mov [Segundos], ax
		
		mov ax, [minutos]
		
		mov bl, "0"
		cmp bl, ah
		jz MinutosTemporizador2
		dec ah
		mov [minutos], ax
		escribe espacio, lonEsp
		jmp moverTemporizador
		
	MinutosTemporizador2:
		mov ah,"9"
		mov bl, "0"
		cmp bl, al
		jz FinTemp
		dec al
		mov [minutos], ax
		escribe espacio, lonEsp
		jmp moverTemporizador
		
	FinTemp:
	
		escribe espacio, lonEsp
		escribe	msjFin, lonFin
		
		mov ax, 07
		mov [Segundos], ax	
		mov esi, 0
		jmp Sonido
		
	Sonido:
		escribe Segundos, 2
		espera 0, 100000000
		inc esi
		cmp esi, 10
		jc Sonido
		jmp Inicio
	
	;###### CRONOMETRO #######
	InicioCronometro:
		escribe ClearTerm, CLEARLEN
		escribe mensajeCronometro, lon_crono
		escribe mensajeInicialCronometro, lon_mensajeCrono
		leer inicio, 3		
		
	moverCronometro:
		espera 0, 10000000 ; espera de 10 ms

		escribe ClearTerm, CLEARLEN
		escribe mensajeInicialCronometro, lon_mensajeCrono
		escribe centrar, lon_centrar
		escribe minutos, lon3
		escribe msj, lonmsj
		escribe Segundos, lon2
		escribe msj, lonmsj
		escribe millis, lon1
		escribe centrar, lon_centrar
		
		mov ax, [millis]
		inc ah
		mov bl, "9"
		cmp bl, ah
		jb MillisCronometro
		mov [millis], ax
		escribe espacio, lonEsp
		jmp moverCronometro
		
	MillisCronometro:
		mov ah,"0"
		inc al
		mov bl, "9"
		cmp bl, al
		jb SegundosCronometro
		mov [millis], ax
		escribe espacio, lonEsp
		jmp moverCronometro

	SegundosCronometro:
		mov ax,"00"
		mov [millis], ax
		
		mov ax, [Segundos]
		inc ah
		mov bl, "9"
		cmp bl, ah
		jb SegundosCronometro2
		mov [Segundos], ax
		escribe espacio, lonEsp
		jmp moverCronometro
		
	SegundosCronometro2:
		mov ah,"0"
		inc al
		mov bl, "5"
		cmp bl, al
		jb MinutosCronometro
		mov [Segundos], ax
		escribe espacio, lonEsp
		jmp moverCronometro
		
	MinutosCronometro:
		mov ax,"00"
		mov [millis], ax
		mov [Segundos], ax
		
		mov ax, [minutos]
		inc ah
		mov bl, "9"
		cmp bl, ah
		jb MinutosCronometro2
		mov [minutos], ax
		escribe espacio, lonEsp
		jmp moverCronometro
		
	MinutosCronometro2:
		mov ah,"0"
		inc al
		mov [minutos], ax
		escribe espacio, lonEsp
		jmp moverCronometro

	salir: 	
		escribe ClearTerm, CLEARLEN
		mov eax,1
		mov ebx,0
		int 80h
