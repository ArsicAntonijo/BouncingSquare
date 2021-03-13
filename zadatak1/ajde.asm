;Task 1: Square bouncing from edges of screen

; ---- Data segment
dseg segment 'DATA'
speed dw 5690
increment1 db 1
increment2 db 1
color1 db 01000000b
x1 db 0
x2 db 0
x3 db 4
changingDirection db 0


dseg ends
; ---- end of segment


; ---- Code segment

cseg	segment	'CODE'
		assume cs:cseg, ds:dseg, ss:sseg
	reverse:

;---MAIN PROGRAM----	

		mov ah,0fh
        int 10h ;get video mode
        push ax
		mov bl, 0
		
		mov ax, dseg 
		mov ds, ax ;Set DS.
		;clearing screen
		mov ah,6
		mov al,25
		mov bh,0
		mov ch,0
		mov cl,0
		mov dh,0
		mov dl,78
		int 10h
		;---
		ovde:
		;drawing square
		mov ah,6
		mov al,4
		mov bh,color1
		mov ch,x1
		mov cl,0
		mov dh,x2
		mov dl,x3
		;int 10h
		;----
		
		leftToRightDown:
		int 10h
		call delayingSquare		
		call clearingScreen
		add cl,increment2
		add dl,increment2
		add ch,increment1
		;int 10h
		call mainCheck
		cmp ch,21
		jge leftToRightUp
		cmp dl,79
		jge rightToLeftDown
		cmp cl,75
		jge rightToLeftDown
		jmp leftToRightDown
		
		
		leftToRightUp:
		int 10h
		call delayingSquare		
		call clearingScreen
		add cl,increment2
		add dl,increment2
		sub ch,increment1
		;int 10h
		call mainCheck
		cmp ch,0
		jle leftToRightDown
		cmp dl,79
		jge rightToLeftUp
		jmp leftToRightUp
	
		
		rightToLeftDown:
		int 10h
		call delayingSquare		
		call clearingScreen
		sub cl,increment2
		sub dl,increment2
		add ch,increment1
		;int 10h
		call mainCheck
		cmp ch,21
		jge rightToLeftUp
		cmp dl,4
		jle leftToRightDown
		jmp rightToLeftDown
		
		rightToLeftUp:
		int 10h
		call delayingSquare		
		call clearingScreen
		sub cl,increment2
		sub dl,increment2
		sub ch,increment1
		;int 10h
		call mainCheck
		cmp ch,0
		jle rightToLeftDown
		cmp dl,4
		jle leftToRightUp
		jmp rightToLeftUp
;----------END of MAIN
				
		
clearingScreen proc near
	;clearing screen
		push ax
		push bx
		push cx
		push dx
		mov ah,6
		mov al,25
		mov bh,0
		mov ch,0
		mov cl,0
		mov dh,0
		mov dl,79
		int 10h
		pop dx
		pop cx
		pop bx
		pop ax
		ret
		;-------end
clearingScreen endp		

delayingSquare proc near
;...
		
		mov bp, speed	
		mov si, speed
		delay2:
		dec bp
		nop	
		jnz delay2
		dec si
		cmp si,0    
		jnz delay2
		; ------en
		ret
delayingSquare endp

mainCheck proc near
		push ax
		mov ah, 01h    ;BIOS.GetKey
		int 16h
		jz forward
		mov ah, 00h
		int 16h
		cmp al, 27     ;Is it ESCAPE
		jz kraj
		cmp al,13		;Is it ENTER
		jz kraj
		cmp al,43		;Is it +
		jnz skok
		call speeding
		skok:
		cmp al,45		;Is it -
		jnz skok2
		call slowingDown
		skok2:
		cmp al,49		;Is it 1
		jnz skok3
		call horizontal
		skok3:
		cmp al,50		;Is it 2
		jnz skok4
		call normal
		skok4:
		cmp al,51		;Is it 3
		jnz skok5
		call vertical
		skok5:
		cmp al,56		;Is it 8
		jnz skok6
		call stop
		skok6:
	forward:
		pop ax
		ret
mainCheck endp

speeding proc near
		cmp speed,1500
		jle here
		sub speed,500
		;sub increment2,1
		here:
		ret
		
speeding endp

slowingDown proc near
		cmp speed,8000
		jge here1
		add speed, 500
		;add increment2,500
		here1:
		ret
slowingDown endp

horizontal proc near
		mov increment1,0
		mov increment2,1
		ret
horizontal endp

vertical proc near
		mov increment1,1
		mov increment2,0
		ret
vertical endp

normal proc near
		mov increment1,1
		mov increment2,1
		ret
normal endp

stop proc near
		mov increment1,0
		mov increment2,0
		ret
stop endp

	kraj:
		mov ah, 4ch;
		int 21h
		
	
cseg 	ends
; ---- kraj segmenta

; ---- stek segment
sseg 	segment	stack 'STACK'
	   dw   64		dup(?)
sseg ends	   
; ---- kraj segmenta

; ----- kraj programa i definisanje ulazne tacke
end reverse
 