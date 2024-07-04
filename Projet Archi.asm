
data segment
    nom  DB 0AH,0DH, "------------- PROJET REALISE PAR : AOUANE HICHEM et TAHRAOUI RAYAN -------------$"
    done  DB 0AH,0DH, "********************************************************************************$" 
    typecal db 0AH,0DH, "Pour une calculatrice decimal entrez 1",0AH,0DH,"Pour une calculatrice hexadecimal entrez 2",0AH,0DH,"Pour une calculatrice en binaire entrez 3",0AH,0DH, '$'  
    operation db  0AH,0DH,"choisissez votre operation pour addition entrez : '+'",0AH,0DH, "pour soustraction entrez '-'",0AH,0DH, "pour multiplication entrez '*' et pour la division entrez '/' : $"   
    msg1 db  0AH,0DH,"entrez le premier numero:$"
                                                                            
    msg2 db  0AH,0DH,"entrez le deuxieme numero:$"
    msg3 db  0AH,0DH,"le resultat est:$"           

	
	_error          DB      0AH,0DH,' Erreur division par 0 $',0AH,0DH
	
	_fished			DB		0AH,0DH,'			  ___======____=---=)',0AH,0DH,'			/T            \_--===)',10,'			L \ (@)   \~    \_-==)',10,'			  \      / )J≈    \-=)',10,'			  \\___/  )JJ≈    \)',10,'			   \_____/JJJ≈      \',10,'			  / \  , \J≈≈      \',10,'			  (-\)\=|  \≈~        L__',10,'			  (\\)  ( -\)_            ==__',10,'			   \V    \-\) ===_____  J\   \\',10,'  			       \V)     \_) \   JJ J\)',10,'			                      /J JT\JJJJ)',10,'			                      (JJJ| \UUU)',10,'			                      (UU)	',10,'				              ___',10,'				You got fished !			',10							
	
	_quit			DB  	0AH,0DH,'  > Quitter (y/n)? $'
	_quitglob       DB      0AH,0DH,'  > Quitter le programme (y/n) ? $'
    num1 dw ?
    num2 dw ?
    resultat dw ?  
    _ascii 			DB	    '0123456789ABCDEF' 
   
    s1 DB "00000000", 0
    sum DW 0  ; result.
    flag DB 0    
    
    resultb db 16 dup('x'), 'b'

ends

stack segment
    dw   128  dup(0)
ends

code segment
    mov ax, data
    mov ds, ax
    mov es, ax
    
    mov dx, offset done
    mov ah, 9
    int 21H
    mov dx, offset nom
    mov ah, 9
    int 21H
    mov dx, offset done
    mov ah, 9
    int 21H 

Debut:    
    mov dx, offset typecal   ;type de calculatrice
    mov ah, 9
    int 21H 
      
    MOV AH,01H          
    INT 21H
    CMP AL, 31H
    JE deci 
    CMP AL, 32H
    JE hexa 
    CMP AL, 33H
    JE bin
    JMP Debut   
    
    
;|||||||||||||||||||||||||||||||||BINAIRE||||||||||||||||||||||||||||||||||    
    
bin: 

         
         _OPselect_:			

			   mov dx, offset operation   ;selection de loperation
               mov ah, 9
               int 21H 
			;On choisit l'operation a effectuer :
				MOV         AH,1 										;Ici : 1 car on ne demande qu'un seul caractere qui est un nombre
				INT         21H
				CALL        RETURN



          biadd:
				CMP         AL,'+'										;Si le nombre entre est > 1
				JNE         bisoustrac								;On va a l'etiquette du menu suivante
				JMP        biaddition								;Sinon, on lance le programme d'addition
	        									;Une fois terminer, on demande si on souhaite recommencer la boucle pour effectuer de nouveau un calcul
		  bisoustrac:
				CMP         AL,'-'										;Si le nombre entre est > 2
				JNE         bimulti							;On va a l'etiquette du menu suivante
				JMP        bisoustraction						;Sinon, on lance le programme de soustraction
		        									;Une fois terminer, on demande si on souhaite recommencer la boucle pour effectuer de nouveau un calcul
		  bimulti:
				CMP         AL,'*'										;Si le nombre entre est > 3
				JNE         bidiv								;On va a l'etiquette du menu suivante
				JMP       bimultiplication							;Sinon, on lance le programme de multiplication
	                  									;Une fois termine, on demande si on souhaite recommencer la boucle pour effectuer de nouveau un calcul
		  bidiv:
				CMP 		AL,'/'										;Si le nombre entre est > 4
				JNE 		_OPselect_										;On retourne au menu : plus d'operations apres a
				JMP 		bidivision								;Sinon, on lance le programme de division
												;Une fois termine, on demande si on souhaite recommencer la boucle pour effectuer de nouveau un calcul
	
		_MENU_:
			MOV         AH,9
			LEA         DX, _QUIT
			INT         21H
			;Saisie d'une reponse
			MOV         AH,1
			INT         21H
			CALL        RETURN
			;Traitement de la reponse
			CMP         AL,'n'
			JE          _OPselect_
			CMP         AL,'y'
			JMP         choix_glob         

            
    
biaddition: 
    mov dx, offset msg1     ;affichage mess 1
    mov ah, 9
    int 21H   
    mov sum, 0
    call bin2dec 
    mov ax, sum 
    push ax
    mov dx, offset msg2    ;afficage mess 2
    mov ah, 9
    int 21H    
    mov sum, 00h
    call bin2dec 
    pop ax
    add ax, sum
    mov bh, 00h
    mov bl, al 
    mov dx, offset msg3
    mov ah, 9
    int 21h 
    call convert_to_bin 
    mov si, offset resultb  ; set buffer's address to si.
    mov ah, 0eh            ; teletype function of bios.
    mov cx, 17 
    print_me:
	mov al, [si]
	int 10h ; print in teletype mode.
	inc si
    loop print_me  
jmp _MENU_
    
    
    
bisoustraction: 
    mov dx, offset msg1     ;affichage mess 1
    mov ah, 9
    int 21H   
    mov sum, 0
    call bin2dec 
    mov ax, sum 
    push ax
    mov dx, offset msg2    ;afficage mess 2
    mov ah, 9
    int 21H    
    mov sum, 00h
    call bin2dec 
    pop ax
    sub ax, sum
    mov bh, 00h
    mov bl, al 
    mov dx, offset msg3
    mov ah, 9
    int 21h 
    call convert_to_bin 
    mov si, offset resultb  ; set buffer's address to si.
    mov ah, 0eh            ; teletype function of bios.
    mov cx, 17 
    print_mes:
	mov al, [si]
	int 10h ; print in teletype mode.
	inc si
    loop print_mes  
jmp _MENU_

bimultiplication:
    mov dx, offset msg1     ;affichage mess 1
    mov ah, 9
    int 21H 
    mov sum, 0
    call bin2dec 
    mov ax, sum 
    push ax
    mov dx, offset msg2    ;afficage mess 2
    mov ah, 9
    int 21H    
    mov sum, 00h
    call bin2dec 
    pop ax
    mul sum
    mov bh, 00h
    mov bl, al 
    mov dx, offset msg3
    mov ah, 9
    int 21h 
    call convert_to_bin 
    mov si, offset resultb  ; set buffer's address to si.
    mov ah, 0eh            ; teletype function of bios.
    mov cx, 17 
    print_mem:
	mov al, [si]
	int 10h ; print in teletype mode.
	inc si
    loop print_mem  
jmp _MENU_
bidivision:
    mov dx, offset msg1     ;affichage mess 1
    mov ah, 9
    int 21H    
    mov sum, 0
    call bin2dec 
    mov ax, sum 
    push ax
    mov dx, offset msg2    ;afficage mess 2
    mov ah, 9
    int 21H    
    mov sum, 00h
    call bin2dec 
    pop ax  
    mov bx, sum 
    cmp bx, 0
    je div0  
    xor dx, dx
    div bx
    mov bh, 00h
    mov bl, al 
    mov dx, offset msg3
    mov ah, 9
    int 21h 
    call convert_to_bin 
    mov si, offset resultb  ; set buffer's address to si.
    mov ah, 0eh            ; teletype function of bios.
    mov cx, 17 
    print_med:
	mov al, [si]
	int 10h ; print in teletype mode.
	inc si
    loop print_med  
jmp _MENU_   
convert_to_bin    proc     near
pusha

lea di, resultb

; print result in binary:
mov cx, 16
printh: mov ah, 2   ; print function.
       mov [di], '0'
       test bx, 1000_0000_0000_0000b  ; test first bit.
       jz zero
       mov [di], '1'
zero:  shl bx, 1
       inc di
loop printh

popa
ret
convert_to_bin   endp


bin2dec proc
; get string:
MOV DX, 9   ; buffer size (1+ for zero terminator).
LEA DI, s1
CALL GET_STRING


; check that we really got 8 zeros and ones
MOV CX, 8
MOV SI, OFFSET s1
check_s:
        CMP [SI], 0 
        JNE ok0         
        MOV flag, 1     ; terminated.
        JMP convert
    ok0:
        CMP [SI], 'b' 
        JNE ok1         
        MOV flag, 1     ; terminated.
        JMP convert        
    ok1:    
        ; wrong digit? Not 1/0?
        CMP [SI], 31h
        JNA ok2
        JMP error_not_valid     
    ok2:
        INC SI
    LOOP check_s







; convertion du string en valeur dans la var SUM
convert:
MOV BL, 1   ; multiplier.
MOV CX, SI
SUB CX, OFFSET s1
DEC SI

JCXZ stop_program

next_digit:
    MOV AL, [SI]  ; lecture char
    SUB AL, 30h
    MUL BL      ; no change to AX
    ADD SUM, AX
    SHL BL, 1
    DEC SI          ; go to char precedent
    LOOP next_digit
 

ret

bin2dec endp

; check si signee
TEST sum, 0000_0000_1000_0000b
JNZ  print_signed_unsigned

print_unsigned:
CALL print
DB 0dh, 0ah, "decimal: ", 0
MOV  AX, SUM

JMP  stop_program

print_signed_unsigned:
CALL print
DB 0dh, 0ah, "unsigned decimal: ", 0
; print out unsigned:
MOV  AX, SUM

CALL print
DB 0dh, 0ah, "signed decimal: ", 0
; print out singed:
MOV  AX, SUM
CBW  ; convertir byte into word.

JMP  stop_program


error_not_valid:
CALL print
DB 0dh, 0ah, "error: only zeros and ones are allowed!", 0

stop_program:


RET


; procedures




GET_STRING      PROC    NEAR
PUSH    AX
PUSH    CX
PUSH    DI
PUSH    DX

MOV     CX, 0                   ; char counter.

CMP     DX, 1                   ; buffer too small?
JBE     empty_buffer            ;

DEC     DX                      ; reserve space for last zero.


;============================
; loop to get and processes key presses:

wait_for_key:

MOV     AH, 0                   ; get pressed key.
INT     16h

CMP     AL, 13                  ; 'RETURN' pressed?
JZ      exit1


CMP     AL, 8                   ; 'BACKSPACE' pressed?
JNE     add_to_buffer
JCXZ    wait_for_key            ; nothing to remove!
DEC     CX
DEC     DI

JMP     wait_for_key

add_to_buffer:

        CMP     CX, DX          ; buffer is full?
        JAE     wait_for_key    ; if so wait for 'BACKSPACE' or 'RETURN'...

        MOV     [DI], AL
        INC     DI
        INC     CX
        
        ; print the key:
        MOV     AH, 0Eh
        INT     10h

JMP     wait_for_key
;============================

exit1:

; terminate by null:
MOV     [DI], 0

empty_buffer:

POP     DX
POP     DI
POP     CX
POP     AX
RET
GET_STRING      ENDP

        
print_zero:

        
end_print:

        POP     DX
        POP     CX
        POP     BX
        POP     AX
        RET
ten             DW      10      ; used as divider.      
ENDP


; print text that follows the caller
print PROC
MOV     CS:temp1, SI  ; store SI register.
POP     SI            ; get return address (IP).
PUSH    AX            ; store AX register.
next_char:      
        MOV     AL, CS:[SI]
        INC     SI            ; next byte.
        CMP     AL, 0
        JZ      printed_ok
        JMP     next_char     ; loop.
printed_ok:
POP     AX            ; re-store AX register.
; SI should point to next command after
; the CALL instruction and string definition:
PUSH    SI            ; save new return address into the Stack.
MOV     SI, CS:temp1  ; re-store SI register.
RET
temp1  DW  ?    ; variable to store original value of SI register.
ENDP
        
    
 
   

div0:
    mov AH, 09H   
    lea dx,_error
    int 21H 
    jmp exit


;||||||||||||||||||||||||||||||||||||||||||||||DECIMAL||||||||||||||||||||||||||||||||||
    
    
deci:                 ;calcul en decimal     


 _OPselect:			

			   mov dx, offset operation   ;selection de loperation
               mov ah, 9
               int 21H 
			;On choisit l'operation a effectuer :
				MOV         AH,1 										;Ici : 1 car on ne demande qu'un seul caractere qui est un nombre
				INT         21H
				CALL        RETURN



        _addition_:
				CMP         AL,'+'										;Si le nombre entre est > 1
				JNE         _soustraction_								;On va a l'etiquette du menu suivante
				CALL        addition								;Sinon, on lance le programme d'addition
				JMP         _MENU									;Une fois terminer, on demande si on souhaite recommencer la boucle pour effectuer de nouveau un calcul
		_soustraction_:
				CMP         AL,'-'										;Si le nombre entre est > 2
				JNE         _multiplication_							;On va a l'etiquette du menu suivante
				CALL        soustraction						;Sinon, on lance le programme de soustraction
				JMP         _MENU									;Une fois terminer, on demande si on souhaite recommencer la boucle pour effectuer de nouveau un calcul
		_multiplication_:
				CMP         AL,'*'										;Si le nombre entre est > 3
				JNE         _division_									;On va a l'etiquette du menu suivante
				CALL       multiplication							;Sinon, on lance le programme de multiplication
				JMP         _MENU									;Une fois termine, on demande si on souhaite recommencer la boucle pour effectuer de nouveau un calcul
		_division_:
				CMP 		AL,'/'										;Si le nombre entre est > 4
				JNE 		_OPselect										;On retourne au menu : plus d'operations apres a
				CALL 		division								;Sinon, on lance le programme de division
				JMP 	    _MENU									;Une fois termine, on demande si on souhaite recommencer la boucle pour effectuer de nouveau un calcul
	
		_MENU:
			MOV         AH,9
			LEA         DX, _QUIT
			INT         21H
			;Saisie d'une reponse
			MOV         AH,1
			INT         21H
			CALL        RETURN
			;Traitement de la reponse
			CMP         AL,'n'
			JE          _OPselect
			CMP         AL,'y'
			JMP         choix_glob         


    
            
   addition: 
    mov dx, offset msg1     ;affichage mess 1
    mov ah, 9
    int 21H 
    mov cx, 0 ;on en aura besoin dans la fonctions input
    call input   
    push dx
    mov dx, offset msg2    ;afficage mess 2
    mov ah, 9
    int 21H
    mov cx, 0 ;on en aura besoin dans la fonctions input
    call input ;appel de la fonction pour inserer les valeur
    pop bx
    add dx,bx   ;addition
    push dx  
    mov ah,9
    mov dx, offset msg3  ;affichage mess3
    int 21h
    mov cx,10000   ;pour designer la taille du resultat
    pop dx
    call result 
    RET
    

soustraction:
    mov dx, offset msg1
    mov ah, 9
    int 21H 
    mov cx, 0 ;on en aura besoin dans la fonctions input
    call input   
    push dx
    mov dx, offset msg2
    mov ah, 9
    int 21H
    mov cx, 0 ;on en aura besoin dans la fonctions input
    call input 
    pop bx       ;1ere var dans bx
    sub bx,dx    ;soustraction
    mov dx,bx
    push dx 
    mov ah,9
    mov dx, offset msg3
    int 21h
    mov cx,10000
    pop dx
    call result 
    RET 

multiplication: 
    mov dx, offset msg1
    mov ah, 9
    int 21H 
    mov cx, 0 ;on en aura besoin dans la fonctions input
    call input   
    push dx
    mov dx, offset msg2
    mov ah, 9
    int 21H
    mov cx, 0 ;on en aura besoin dans la fonctions input
    call input 
    pop bx
    mov ax,dx ;affectation de la premiere var
    mul bx    ;multiplication
    mov dx,ax
    push dx 
    mov ah,9
    mov dx, offset msg3
    int 21h
    mov cx,10000
    pop dx
    call result
    RET      

division: 
    
    
    mov dx, offset msg1
    mov ah, 9
    int 21H 
    mov cx, 0 ;on en aura besoin dans la fonctions input
    call input   
    push dx
    mov dx, offset msg2
    mov ah, 9
    int 21H
    mov cx, 0 ;on en aura besoin dans la fonctions input
    call input
    pop bx
    mov ax,bx
    mov cx,dx
    mov dx,0
    mov bx,0
    div cx
    mov bx,dx
    mov dx,ax
    push bx 
    push dx 
    mov ah,9
    mov dx, offset msg3
    int 21h
    mov cx,10000
    pop dx
    call result
    pop bx
    cmp bx,0
    je _MENU
    RET


input proc 
    MOV AH,01H          
    INT 21H    ;lecutre du chiffre de gauche a droite
    mov dx, 0
    mov bx, 1
    cmp al, 0dh  ;pour voir si la valeur est "entrez"
    je FormeNo   ;si la valeur entrez est "entrez" alors nous avons toutes nos valeur dans la pile
    sub ax,30h ;conversion de la valeur de al du hexa au decimal
    mov ah,0   ;on laisse que la valeur du AL
    push ax    ;on empile le chiffre entre
    inc cx     ;on implemente cx pour savoir combien de chiffre contient notre num
    jmp input
    ret              
ENDP    


FormeNo:  
   pop ax ;on depile le dernier chiffre empiler le toutes a droite 
   push dx  ;sauvgarde pour avant mult en cas ou    
   mul bx ;on multiplie ax par bx 1->10->100...
   pop dx ;on le recupere
   add dx,ax
   mov ax,bx;on place la val de bx dans ax      
   mov bx,10
   push dx ;sauvgarde avant mult
   mul bx;mult bx par 10
   pop dx
   mov bx,ax;passage du resultat de multiplication dans bx
   dec cx ;on decrement cx apres avoir finis avec le chiffre
   cmp cx,0
   jne formeno;si cx est inegal a 0 on doit refaire ils nous restent des chiffres
   ret
    
result:             ;pour l affichage du resultat
     
      mov ax,dx
       mov dx,0
       div cx 
       push ax 
       push dx     
       mov dx,ax 
       add dl,30h  ;affichage du premier car
       mov ah,2
       int 21h
       pop dx  
       pop ax
       mov bx,dx 
       mov dx,0
       mov ax,cx 
       mov cx,10
       div cx
       mov dx,bx 
       mov cx,ax
       cmp ax,0     ;si ax nest pas egale a 0 on refait
       jne result
       ret
 ;||||||||||||||||||||||||||||||||||||||||||||||||||||HEXA|||||||||||||||||||||||||||||||||||

hexa:            


;Ici, c'est l'affichage du menu qui est concerne

		   OPselect:			

			   mov dx, offset operation   ;selection de loperation
               mov ah, 9
               int 21H 
			;On choisit l'operation a effectuer :
				MOV         AH,1 										;Ici : 1 car on ne demande qu'un seul caractere qui est un nombre
				INT         21H
				CALL        RETURN
			;Puis on teste la selection pour verifier que l'utilisateur n'entre pas n'importe quoi ._.
		_p_addition:
				CMP         AL,'+'										;Si le nombre entre est > 1
				JNE         _p_soustraction								;On va a l'etiquette du menu suivante
				CALL        PROG_ADDITION								;Sinon, on lance le programme d'addition
				JMP         B_MENU									;Une fois terminer, on demande si on souhaite recommencer la boucle pour effectuer de nouveau un calcul
		_p_soustraction:
				CMP         AL,'-'										;Si le nombre entre est > 2
				JNE         _p_multiplication							;On va a l'etiquette du menu suivante
				CALL        PROG_SOUSTRACTION							;Sinon, on lance le programme de soustraction
				JMP         B_MENU									;Une fois terminer, on demande si on souhaite recommencer la boucle pour effectuer de nouveau un calcul
		_p_multiplication:
				CMP         AL,'*'										;Si le nombre entre est > 3
				JNE         _p_division									;On va a l'etiquette du menu suivante
				CALL        PROG_MULTIPLICATION							;Sinon, on lance le programme de multiplication
				JMP         B_MENU									;Une fois termine, on demande si on souhaite recommencer la boucle pour effectuer de nouveau un calcul
		_p_division:
				CMP 		AL,'/'										;Si le nombre entre est > 4
				JNE 		OPselect										;On retourne au menu : plus d'operations apres a
				CALL 		PROG_DIVISION								;Sinon, on lance le programme de division
				JMP 	    B_MENU									;Une fois termine, on demande si on souhaite recommencer la boucle pour effectuer de nouveau un calcul
	
		B_MENU:
			MOV         AH,9
			LEA         DX, _QUIT
			INT         21H
			;Saisie d'une reponse
			MOV         AH,1
			INT         21H
			CALL        RETURN
			;Traitement de la reponse
			CMP         AL,'n'
			JE          OPselect
			CMP         AL,'y'
			JMP         choix_glob      




start: 
    
     RETURN PROC
		PUSH        AX							;save the register value, insert in order
		PUSH        DX							;save the register value, insert in order
		MOV         DL,10
		MOV         AH,2
		INT         21H
		POP         DX	;take back reg value, take from reverse because push POP function is stack
		POP         AX  ;take back reg value, take from reverse because push POP function is stacks
		RET							
	RETURN ENDP													

;-----------------------------------------------------------------PROCEDURE DE SCANNER D'UN HEXADECIMAL
; Le resultat est stocker dans la variable AL
; Code hexa touche entrer = F0H
; Sinon la valeur de la touche est entrer

	SCANHEX PROC
		ASSUME CS:CODE,DS:DONNEE,SS:PILE
		
		_eti_car: 												;on definit l'etiquette "_etiq_car" (obtenir un caractere saisit au clavier)
			
			MOV	        AH,8
			INT	        21H		;l'interruption 21 est utilisee pour l'aquisition d'un caractere 
			CMP	        AL,13 									;Comparer AL et la valeur du retour chariot
			JNE	        _eti_num								;Saut a l'adresse indique si non-egalite : soit AL <> 13
			;Sinon si AL=13 :
			MOV	        AL,0F0h 										;AL prend pour valeur F0H (la touche entrer)
			JMP	        _eti_out										;sortir de la fonction
			
		_eti_num: 														;On definit l'etiquette _eti_num
			CMP	        AL,'0' 											;On compare AL au code ascii '0'
			JB	        _eti_car										;Si AL<0 on demande de resaisie (JB :saut a l'adresse indique si CF=1)
			;Si AL>=0					
			CMP	        AL,'9' 											;On compare AL au code ascii '9'
			JA	        _eti_alpha_maj									;Si AL>9, alors c'est un texte majuscule (JA = Saut a l'adresse indique si CF=0)
			;Sinon si AL est compris dans l'intervalle [0,9]
			SUB	        AL,'0'											;AL prend la valeur AL-0
			JMP	        _eti_out										;on sort de la fonction		
			
		_eti_alpha_maj: 												;On definit l'etiquette pour l'alphabet majuscule
			CMP	        AL,'A' 											;On compare AL au code ascii de A
			JB	        _eti_car										;Si AL<A on demande la resaisie
			;Si AL>=A					
			CMP	        AL,'F' 											;On compare AL au code ascii de F
			JA	        _eti_alpha										;Si AL>F alors le texte est en minuscule
			;Sinon si AL est compris dans l'intervalle [A,F]
			SUB     	AL,'A'-10										;AL prends la valeur AL +10 - 'A'
			JMP	        _eti_out										;on sort de la fonction	
		
		_eti_alpha: 													;On definit l'etiquette pour l'alphabet (min)
			CMP	        AL,'a' 											;On compare Al au code ascii de 'a'
			JB	        _eti_car										;Si AL<a alors on demande une resaisie
			;Si AL>=a					
			CMP	        AL,'f' 											;On compare Al au code ascii de 'f'
			JA	        _eti_car										;Si AL>f alors on demande une resaisie
			;Sinon si AL est compris dans l'intervalle [a,f]
			SUB	        AL,'a'-10										;AL prend la valeur AL + 10 - 'a'
			JMP	        _eti_out	
			
		_eti_out: 
			RET 														;Arret de la procédure
	SCANHEX ENDP 
	
;-----------------------------------------------------------------------
;Stockage du resultat de la fonction dans BX
;Utilise AX via la fonction SCANHEX
	SCANINT PROC 
		PUSH		AX													;Sauvegarde le registre d'AX dans la pile
		PUSH		CX													;Sauvegarde le registre de CX dans la pile
		PUSH		DX													;Sauvegarde le registre de DX dans la pile	
			MOV	BX,0 													;On initialise le registre BX a 0
			MOV	CH,4													;Mettre la partie haute du registre CX a 4
		_si_SCANHEX: 													;On definit les instructions pour l'etiquette _si_SCANHEX
			CALL		SCANHEX 										;On appelle la procedure SCANHEX
			CMP 		AL,0F0h  										;On compare la partie basse du registre AX a la valeur qui definit le retour chariot
			JE 			_si_out   										;Si la condition precedente est realiste, on effection l'etiquette _si_out
			;Ajout d'AL dans BX
			MOV	        CL,4 											;La partie basse du registre prends la valeur 4
			SAL         BX,CL											;On effectue un decalage a gauche de 4 bits
		    ADD         BL,AL 											;On ajoute la valeur decale a BL
			;Affichage de la lettre correspondante :
			PUSH	    BX 												;On sauvegarde le registre BX
			LEA		    BX,_ascii 										;BX "pointe" le debut du tableau ascii
			XLAT 														;/!\ Cette fonction assure la conversion ascii decimal
				MOV		    DL,AL 										;Ici on utilise l'interruption 2 pour afficher uniquement un caractère
				MOV		    AH,2  
				INT		    21H    										;Interruption
			POP	        BX 												;On recupere la valeur de BX deja stocke
			;On definit les conditions de la boucle
			DEC         CH												;CH = CH-1 (decrementation)
			CMP         CH,0 											;on compare CH avec 0
			JNE         _si_SCANHEX 									;Si la condition n'est pas egale, on execute l'etiquette _si_scanHex
		
		  _si_out: 														;On definit l'etiquette _si_out // si scan out
			
			POP         DX 												;On recupere les valeurs des registres DX, CX et AX
			POP         CX		
			POP         AX
			RET															;On stop
	SCANINT ENDP
	
	;Entre dans DX
	PRINTINT PROC 
			PUSH        AX 												;On sauvegarde le contenu des registres AX, BX, CX et DX
			PUSH        BX
			PUSH        CX
			PUSH        DX
			PUSH        DX
		
			LEA         BX,_ascii 										;BX pointe sur le debut du tableau _ascii
			MOV         CH,0 											;On affecte 0 pour  la partie haute du registre CX
		
		_pi_prINT_byte:													;On definit l'etiquette
			
			MOV         AL,DH  											;AL prends la valeur de DH
			MOV         CL,4   											;On definit dans CL le nombre de bits a decaler
			shr         AL,CL 											;On effectue un decalage a droite par le nombre CL
			XLAT      													;On realise on conversion decimale ascii
			;XLAT permet de remplacer le contenu du registre AL par un octet de la «tablesource».
				MOV         DL,AL 										;On utilise la fonction 2 pour l'affichage d'un seul caractere
				MOV         AH,2   
				INT         21H
			MOV         AL,DH 
		    AND         AL,0fh
			XLAT
			MOV         DL,AL
			MOV         AH,2
			INT         21H
			
			CMP         CH,0 											;On compare CH avec 0
			JNZ         _pi_fin											;Cette ligne permet de continuer l'execution a l'emplacement memoire _pi_fin
			
			POP         DX
			MOV         DH,DL
			INC         CH 												;INC = incrementer	
			JMP         _pi_prINT_byte
		
		_pi_fin:
			POP         DX
			POP         CX
			POP         BX
			POP         AX
			RET
	PRINTINT ENDP

;-----------------------------------------------------------------------PROGRAMME ADDITION	

	PROG_ADDITION PROC
		PUSH        AX 													;Sauvegarder les valeurs des registres AX, BX, CX, DX, dans la pile
		PUSH        BX
		PUSH        CX
		PUSH        DX

		;Le nombre 1 est stocke dans CX
		LEA 		DX,msg1 										;On utilise l'interruption 9 pour afficher le message _qn1
		MOV 		AH,9
		INT 		21H
		CALL 		SCANINT 											;On fait appel a la fonction SCANINT
		MOV 		CX,BX    											;On ecrit la valeur de sortie de SCANINT dans BX
		CALL 		RETURN    											;On effectue un appel de la fonction retoutr ligne

		;Le nombre 2 est stocke dans DX
		LEA 		DX,msg2  											;On utilise l'interruption 9 pour afficher le message _qn2
		MOV 		AH,9
		INT 		21H
		CALL 		SCANINT  											;On appele la fonction SCANINT qui lit les nombres entres par le clavier
		CALL 		RETURN     											;On applique un retour a la ligne

		;Affichage resultat et "traitement"
		LEA 		DX,msg3 											;On affiche le resultat de l'addition avec l'interuption 9
		MOV 		AH,9 
		INT 		21H
		
		MOV 		DX,0  												;On intialise le registre DX à 0     
		ADD 		CX,BX 												;On fait la somme de nombres deja saisis par le clavier par la commande add
		ADC 		DX,0  												;ADC = Addition avec le carry flag : donc ici on ajoute le carry 
		CALL 		PRINTINT 											;On fait appel à la fonction PRINTINT pour afficher la resultat
		MOV 		DX,CX     
		CALL 		PRINTINT 											;On fait appel a la fonction  PRINTINT pour afficher le resultat
		CALL 		RETURN
		
		POP 		DX 													;On recupere les valeurs des registres DX,CX,BX et AX
		POP 		CX
		POP 		BX
		POP 		AX
		RET
	PROG_ADDITION ENDP

;-----------------------------------------------------------------------PROGRAMME SOUSTRACTION
	
	PROG_SOUSTRACTION PROC 
		PUSH 	AX  													;Sauvegarder les valeurs des registres AX, BX, CX, DX, dans la pile
		PUSH 	BX
		PUSH	CX
		PUSH 	DX
		
		;Le nombre 1 est stocke dans CX
			LEA 	DX,msg1 											;On utilise l'interruption 9 pour afficher le message _qn1
			MOV 	AH,9
			INT 	21H
			CALL 	SCANINT 											;On fait appel a la fonction SCANINT
			MOV 	CX,BX    											;On écrit la valeur de sortie de SCANINT dans CX
			CALL 	RETURN    											;On effectue un appel de la fonction retour a la ligne
	
		;Le nombre 2 est stocke dans BX
			LEA 	DX,msg2 											;On utilise l'interruption 9 pour afficher le message _qn2
			MOV 	AH,9
			INT 	21H
			CALL 	SCANINT 											;On appele la fonction SCANINT qui lit les nombres entres par le clavier
			CALL 	RETURN    											;On applique un retour a la ligne
			
		;Affichage resultat et "traitement"
			LEA 	DX,msg3											;On affiche le message _r_sub
			MOV 	AH,9
			INT 	21H
			MOV 	DX,0   												;On initialise le registre DX a 0
			SUB 	CX,BX  												;On soustrait BX de CX et le resultat se trouvera dans CX
			JNS 	_ps_jumpOver 										;JNS = JUMP IF NOT SIGN

		;En cas de resultat negatif
			MOV 	DL,'-' 												;On affiche un seul caractère grâce à l'interruption 2
			MOV 	AH,2   
			INT 	21H
			NEG 	CX 													;On effectue un complement a 2 à la variable CX
		_ps_jumpOver: 
			MOV 	DX,CX 												;On stocke le contenu de cx dans dx pour pouvoir l'afficher à l'aide de PRINTINT
			CALL 	PRINTINT
			CALL 	RETURN												;Toujours le retour à la ligne, je ne l'idiquerai plus par la suite :))
		
		POP 	DX 														;On recupere de la pile les valeurs des registres DX,CX,BX et AX 
		POP 	CX
		POP 	BX
		POP 	AX
		RET
	PROG_SOUSTRACTION ENDP
		
;-----------------------------------------------------------------------PROGRAMME MULTIPLICATION

	PROG_MULTIPLICATION PROC 
		;La source de la multiplication est : dx:ax = ax * sourcee
		PUSH	AX 													;On sauvegarde les valeurs des registres AX,BX,CX et DX
		PUSH 	BX
		PUSH 	CX
		PUSH 	DX
		
		;Le nombre 1 est stocke dans CX
			LEA 	DX,msg1 											;On affiche le premier message de saisie via la fonction 9
			MOV 	AH,9
			INT 	21H
			CALL 	SCANINT 											;On appelle la fonction SCANINT pour afficher le resultat
			MOV 	CX,BX    											;On stocke la valeur saisie dans le registre CX
			CALL 	RETURN 

		;Le 2e nombre est stocke dans DX
			
			LEA 	DX,msg2
			 											;On utilise l'interruption 9 pour affiche le message _qn2
			MOV 	AH,9
	    	INT 	21H
			CALL	SCANINT 											;On utlise la procedure SCANINT pour la 2e valeur
			CALL 	RETURN    ;faire un retour ligne

		;Affichage resultat et "traitement"
			LEA 	DX,msg3 											;On affiche le message _r_mul
			MOV 	AH,9
			INT 	21H
			MOV 	AX,CX 												;On ecrit le contenu de CX dans AX
			MUL 	BX    												;mul bx <=>  dx:ax = ax * bx
			CALL	PRINTINT 											;On appelle la fonction PRINTINT pour afficher le resultat
			MOV 	DX,AX 												;On stocke le resultat dans ax pour pouvoir l'afficher ensuite
			CALL	PRINTINT
			CALL 	RETURN
		
		POP 	DX 														;On recupere les valeurs des registres DX,CX,BX et AX 
		POP 	CX
		POP 	BX
		POP 	AX
		RET
	PROG_MULTIPLICATION ENDP
	
;-----------------------------------------------------------------------PROGRAMME DIVISION

	PROG_DIVISION PROC 
		;DIV SRC -> DX:AX / SRC >> q = AX , r = DX
		PUSH 	AX 													;On sauvegarde les valeurs des registres AX, BX, CX et DX
		PUSH 	BX
		PUSH 	CX
		PUSH 	DX
		
		;Le 1e nombre est stocke dans CX
			LEA 	DX,msg1 										;On affiche le message _r_div avec l'interruption 9
			MOV 	AH,9
			INT 	21H
			CALL 	SCANINT 										;Saisie de la 1ere valeur 
			MOV 	CX,BX    										;On sauvegarde la valeur saisie dans cx
			CALL 	RETURN 
		;Le 2e nombre est stocke dans BX
			LEA 	DX,msg2 												;Saisie de la 2e valeur 
			MOV 	AH,9
            ;MOV    AH,9
			INT 	21H
			CALL 	SCANINT 
           ; CMP     DX,0                                                  ;On compare DX a 0
			CALL 	RETURN
		;DIV by zero
			CMP     BX,0
			JNE     _notDiv0
			LEA     DX,_error
			MOV     AH,9
			INT 	21H
			LEA 	DX,_fished
			MOV		AH,9
			INT     21h
			JMP     _fin

		;Affichage resultat et "traitement"
		_notDiv0:
			
			LEA 	DX,msg3
			 							;On affiche le message _r_div avec l'interruption 9
			MOV 	AH,9
			
			INT 	21H
			
			MOV 	DX,0  													;On initalise DX a 0 
			MOV 	AX,CX 													;AX prend la valeur de CX
			DIV 	BX 														;Division de bx <=> DX:AX / bx >> q = AX , r = DX
			MOV 	DX,AX 													;On stocke le resultat de la division dans DX
			CALL 	PRINTINT 												;On utilise PRINTINT pour afficher le résultat
			CALL 	RETURN 
		_fin:
		
		POP 	DX  														;On recupere les valeurs des registres DX,CX,BX et AX 
		POP 	CX
		POP 	BX
		POP 	AX
		RET
	
	PROG_DIVISION ENDP	 
       
  
    
    
    
 choix_glob:
            MOV         AH,9
			LEA         DX, _QUITglob
			INT         21H
			;Saisie d'une reponse
			MOV         AH,1
			INT         21H
			CALL        RETURN
			;Traitement de la reponse
			CMP         AL,'n'
			JE          Debut
			CMP         AL,'y'            
    
    

 
  exit:    
    mov ax, 4c00h ;
    int 21h    
