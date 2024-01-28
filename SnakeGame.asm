; this is the screen eating snake game...
;
; this game pushes the emulator to its limits,
; and even with maximum speed it still runs slowly.
; to enjoy this game it's recommended to run it on real
; computer, however the emulator can be useful to debug
; tiny games and other similar programs such as this before
; they become bug-free and workable.
;
; you can control the snake using arrow keys on your keyboard.
;
; all other keys will stop the snake.
;
; press esc to exit.


name "snake"

org     100h

; jump over data section:
jmp     start

; ------ data section ------

s_tam  equ 4    ;3
s_tam2  equ 6    ;4
s_tam3  equ 8    ;5
s_tam4  equ 10   ;6
s_tam5  equ 12    ;7
s_tam6  equ 14    ;8

prueba dw 125,3,4  
prueba2 dw 0,0,0


; the snake coordinates
; (from head to tail)
; low byte is left, high byte
; is top - [top, left]
snake dw s_tam dup(0)
snake2 dw s_tam2 dup(0)
snake3 dw s_tam3 dup(0)
snake4 dw s_tam4 dup(0)
snake5 dw s_tam5 dup(0)
snake6 dw s_tam6 dup(0)

tail    dw      ?

; direction constants
;          (bios key codes):
left    equ     4bh
right   equ     4dh
up      equ     48h
down    equ     50h

; current snake direction:
cur_dir db      right

wait_time dw    0

; welcome message
msg 	db "==== how to play ====", 0dh,0ah
	db "this game was debugged on emu8086", 0dh,0ah
	db "but it is not designed to run on the emulator", 0dh,0ah
	db "because it requires relatively fast video card and cpu.", 0dh,0ah, 0ah
	
	db "if you want to see how this game really works,", 0dh,0ah
	db "run it on a real computer (click external->run from the menu).", 0dh,0ah, 0ah
	
	db "you can control the snake using arrow keys", 0dh,0ah	
	db "all other keys will stop the snake.", 0dh,0ah, 0ah
	
	db "press esc to exit.", 0dh,0ah
	db "====================", 0dh,0ah, 0ah
	db "press any key to start...$"

; ------ code section ------

start:


       
mov dh,35
mov dl,30

;mov al, b.prueba[0]
mov cl, prueba[0]

mov     ax, 40h
mov     es, ax

mov al, es:[10h]       
       
       
; print welcome message:
mov dx, offset msg
mov ah, 9 
int 21h


; wait for any key:
mov ah, 00h
int 16h


; hide text cursor:
mov     ah, 1
mov     ch, 2bh
mov     cl, 0bh
int     10h           
;
call clrscr
;/////////////////////////////////////////////////////////////////////////////

;Dibujar una manzana :3
mov dh,10
mov dl,15

; set cursor at dl,dh
mov     ah, 02h
int     10h

; print 'o' at the location:
mov     al, 'o'
mov     ah, 09h
mov     bl, 04h ; attribute.
mov     cx, 1   ; single char.
int     10h

;/////////////////////////////////////////////////////////////////////////////

game_loop:

; === select first video page
mov     al, 0  ; page number.
mov     ah, 05h
int     10h



; === show new head:
mov     dx, snake[0]

; set cursor at dl,dh
mov     ah, 02h
int     10h

; print '*' at the location:
mov     al, 'x'
mov     ah, 09h
mov     bl, 0eh ; attribute.
mov     cx, 1   ; single char.
int     10h                   



; === keep the tail:
mov     ax, snake[s_tam * 2 - 2]
mov     tail, ax

call    move_snake

; === hide old tail:
mov     dx, tail

; set cursor at dl,dh
mov     ah, 02h
int     10h

; print ' ' at the location:
mov     al, ' '
mov     ah, 09h
mov     bl, 0eh ; attribute.
mov     cx, 1   ; single char.
int     10h

mov cx,snake[0]
cmp snake[2],cx
je stop_game

;== comparar si se ha tocado la primer manzana
cmp dx,2575
je game_loop2 


check_for_key:

; === check for player commands:
mov     ah, 01h
int     16h
jz      no_key

mov     ah, 00h
int     16h

cmp     al, 1bh    ; esc - key?
je      stop_game  ;

mov     cur_dir, ah

no_key:



; === wait a few moments here:
; get number of clock ticks
; (about 18 per second)
; since midnight into cx:dx
mov     ah, 00h
int     1ah
cmp     dx, wait_time
jb      check_for_key
add     dx, 4
mov     wait_time, dx



; === eternal game loop:
jmp     game_loop
;///////////////////////////////////////////////////////////////// -SNAKE CON 3 PARTES
game_loop2:
mov ax,2575 
mov snake2[0], ax

;/////////////////////////////////////////////////////////////////////////////
;Dibujar una manzana :3
mov dh,20
mov dl,25

; set cursor at dl,dh
mov     ah, 02h
int     10h

; print 'O' at the location:
mov     al, 'o'
mov     ah, 09h
mov     bl, 04h ; attribute.
mov     cx, 1   ; single char.
int     10h


game_loop2_1:

; === select first video page
mov     al, 0  ; page number.
mov     ah, 05h
int     10h

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

; === show new head:
mov     dx, snake2[0]

; set cursor at dl,dh
mov     ah, 02h
int     10h

; print '*' at the location:
mov     al, 'x'
mov     ah, 09h
mov     bl, 0eh ; attribute.
mov     cx, 1   ; single char.
int     10h

; === keep the tail:
mov     ax, snake2[s_tam2 * 2 - 2]
mov     tail, ax

call    move_snake2


; === hide old tail:
mov     dx, tail

; set cursor at dl,dh
mov     ah, 02h
int     10h

; print ' ' at the location:
mov     al, ' '
mov     ah, 09h
mov     bl, 0eh ; attribute.
mov     cx, 1   ; single char.
int     10h
;== comparar si se ha tocado la primer manzana
cmp dx,5145
je game_loop3 


check_for_key2:

; === check for player commands:
mov     ah, 01h
int     16h
jz      no_key2

mov     ah, 00h
int     16h

cmp     al, 1bh    ; esc - key?
je      stop_game  ;

mov     cur_dir, ah

no_key2:



; === wait a few moments here:
; get number of clock ticks
; (about 18 per second)
; since midnight into cx:dx
mov     ah, 00h
int     1ah
cmp     dx, wait_time
jb      check_for_key2
add     dx, 4
mov     wait_time, dx



; === eternal game loop:
jmp     game_loop2_1
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -SNAKE CON 4 PARTES
game_loop3:
mov ax,5145 
mov snake3[0], ax


;///////////////////////////////////////////////////////////////////////////// 

;Dibujar una manzana :3
mov dh,12
mov dl,60

; set cursor at dl,dh
mov     ah, 02h
int     10h

; print 'O' at the location:
mov     al, 'o'
mov     ah, 09h
mov     bl, 04h ; attribute.
mov     cx, 1   ; single char.
int     10h

;/////////////////////////////////////////////////////////////////////////////

game_loop3_1:

; === select first video page
mov     al, 0  ; page number.
mov     ah, 05h
int     10h

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




; === show new head:
mov     dx, snake3[0]

; set cursor at dl,dh
mov     ah, 02h
int     10h

; print '*' at the location:
mov     al, '*'
mov     ah, 09h
mov     bl, 0eh ; attribute.
mov     cx, 1   ; single char.
int     10h

; === keep the tail:
mov     ax, snake3[s_tam3 * 2 - 2]
mov     tail, ax

call    move_snake3


; === hide old tail:
mov     dx, tail

; set cursor at dl,dh
mov     ah, 02h
int     10h

; print ' ' at the location:
mov     al, ' '
mov     ah, 09h
mov     bl, 0eh ; attribute.
mov     cx, 1   ; single char.
int     10h

;3132
;== comparar si se ha tocado la primer manzana
cmp dx,3132
je game_loop4 

check_for_key3:

; === check for player commands:
mov     ah, 01h
int     16h
jz      no_key3

mov     ah, 00h
int     16h

cmp     al, 1bh    ; esc - key?
je      stop_game  ;

mov     cur_dir, ah

no_key3:



; === wait a few moments here:
; get number of clock ticks
; (about 18 per second)
; since midnight into cx:dx
mov     ah, 00h
int     1ah
cmp     dx, wait_time
jb      check_for_key3
add     dx, 4
mov     wait_time, dx



; === eternal game loop:
jmp     game_loop3_1

;--------------------------------------------------------------SERPIENTE CON 5 PARTES
game_loop4:
mov ax,3132 
mov snake4[0], ax 

;///////////////////////////////////////////////////////////////////////////// 

;Dibujar una manzana :3
mov dh,5
mov dl,9

; set cursor at dl,dh
mov     ah, 02h
int     10h

; print 'O' at the location:
mov     al, 'o'
mov     ah, 09h
mov     bl, 04h ; attribute.
mov     cx, 1   ; single char.
int     10h

;/////////////////////////////////////////////////////////////////////////////

game_loop4_1:

; === select first video page
mov     al, 0  ; page number.
mov     ah, 05h
int     10h

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




; === show new head:
mov     dx, snake4[0]

; set cursor at dl,dh
mov     ah, 02h
int     10h

; print '*' at the location:
mov     al, '*'
mov     ah, 09h
mov     bl, 0eh ; attribute.
mov     cx, 1   ; single char.
int     10h

; === keep the tail:
mov     ax, snake4[s_tam4 * 2 - 2]
mov     tail, ax

call    move_snake4


; === hide old tail:
mov     dx, tail

; set cursor at dl,dh
mov     ah, 02h
int     10h

; print ' ' at the location:
mov     al, ' '
mov     ah, 09h
mov     bl, 0eh ; attribute.
mov     cx, 1   ; single char.
int     10h

;1289
;== comparar si se ha tocado la manzana
cmp dx,1289
je game_loop5 


check_for_key4:

; === check for player commands:
mov     ah, 01h
int     16h
jz      no_key4

mov     ah, 00h
int     16h

cmp     al, 1bh    ; esc - key?
je      stop_game  ;

mov     cur_dir, ah

no_key4:



; === wait a few moments here:
; get number of clock ticks
; (about 18 per second)
; since midnight into cx:dx
mov     ah, 00h
int     1ah
cmp     dx, wait_time
jb      check_for_key4
add     dx, 4
mov     wait_time, dx



; === eternal game loop:
jmp     game_loop4_1
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++SNAKE CION 6 PARTES
game_loop5:
mov ax,1289 
mov snake5[0], ax 

;///////////////////////////////////////////////////////////////////////////// 

;Dibujar una manzana :3
mov dh,35
mov dl,30

; set cursor at dl,dh
mov     ah, 02h
int     10h

; print 'O' at the location:
mov     al, 'o'
mov     ah, 09h
mov     bl, 04h ; attribute.
mov     cx, 1   ; single char.
int     10h

;/////////////////////////////////////////////////////////////////////////////

game_loop5_1:

; === select first video page
mov     al, 0  ; page number.
mov     ah, 05h
int     10h

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

; === show new head:
mov     dx, snake5[0]

; set cursor at dl,dh
mov     ah, 02h
int     10h

; print '*' at the location:
mov     al, '*'
mov     ah, 09h
mov     bl, 0eh ; attribute.
mov     cx, 1   ; single char.
int     10h

; === keep the tail:
mov     ax, snake5[s_tam5 * 2 - 2]
mov     tail, ax

call    move_snake5


; === hide old tail:
mov     dx, tail

; set cursor at dl,dh
mov     ah, 02h
int     10h

; print ' ' at the location:
mov     al, ' '
mov     ah, 09h
mov     bl, 0eh ; attribute.
mov     cx, 1   ; single char.
int     10h

;8990
;== comparar si se ha tocado la manzana
cmp dx,8990
je game_loop5


check_for_key5:

; === check for player commands:
mov     ah, 01h
int     16h
jz      no_key5

mov     ah, 00h
int     16h

cmp     al, 1bh    ; esc - key?
je      stop_game  ;

mov     cur_dir, ah

no_key5:



; === wait a few moments here:
; get number of clock ticks
; (about 18 per second)
; since midnight into cx:dx
mov     ah, 00h
int     1ah
cmp     dx, wait_time
jb      check_for_key5
add     dx, 4
mov     wait_time, dx



; === eternal game loop:
jmp     game_loop5_1
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
game_loop6:
mov ax,8990 
mov snake6[0], ax 

;///////////////////////////////////////////////////////////////////////////// 

;;Dibujar una manzana :3
;mov dh,7
;mov dl,15
;
;; set cursor at dl,dh
;mov     ah, 02h
;int     10h
;
;; print 'O' at the location:
;mov     al, 'o'
;mov     ah, 09h
;mov     bl, 04h ; attribute.
;mov     cx, 1   ; single char.
;int     10h
;
;/////////////////////////////////////////////////////////////////////////////

game_loop6_1:

; === select first video page
mov     al, 0  ; page number.
mov     ah, 05h
int     10h

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

; === show new head:
mov     dx, snake6[0]

; set cursor at dl,dh
mov     ah, 02h
int     10h

; print '*' at the location:
mov     al, '*'
mov     ah, 09h
mov     bl, 0eh ; attribute.
mov     cx, 1   ; single char.
int     10h

; === keep the tail:
mov     ax, snake6[s_tam6 * 2 - 2]
mov     tail, ax

call    move_snake6


; === hide old tail:
mov     dx, tail

; set cursor at dl,dh
mov     ah, 02h
int     10h

; print ' ' at the location:
mov     al, ' '
mov     ah, 09h
mov     bl, 0eh ; attribute.
mov     cx, 1   ; single char.
int     10h

;3132


check_for_key6:

; === check for player commands:
mov     ah, 01h
int     16h
jz      no_key6

mov     ah, 00h
int     16h

cmp     al, 1bh    ; esc - key?
je      stop_game  ;

mov     cur_dir, ah

no_key6:
; === wait a few moments here:
; get number of clock ticks
; (about 18 per second)
; since midnight into cx:dx
mov     ah, 00h
int     1ah
cmp     dx, wait_time
jb      check_for_key6
add     dx, 4
mov     wait_time, dx



; === eternal game loop:
jmp     game_loop6_1
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
stop_game:

; show cursor back:
mov     ah, 1
mov     ch, 0bh
mov     cl, 0bh
int     10h

ret

; ------ functions section ------

; this procedure creates the
; animation by moving all snake
; body parts one step to tail,
; the old tail goes away:
; [last part (tail)]-> goes away
; [part i] -> [part i+1]
; ....

clrscr proc  
MOV AH,06h
MOV AL,0
MOV BH,07
MOV CH,0
MOV CL,0
MOV DH,84H
MOV DL,4AH
INT 10h       
;setea el mouse
MOV BH,0
MOV DL,0
MOV DH,0
MOV AH,02
INT 10h 

RET
clrscr endp

move_snake proc near

; set es to bios info segment:  
mov     ax, 40h
mov     es, ax

  ; point di to tail
  mov   di, s_tam * 2 - 2
  ; move all body parts
  ; (last one simply goes away)
  mov   cx, s_tam-1
move_array:
  mov   ax, snake[di-2]
  mov   snake[di], ax
  sub   di, 2
  loop  move_array



cmp     cur_dir, left
  je    move_left
cmp     cur_dir, right
  je    move_right
cmp     cur_dir, up
  je    move_up
cmp     cur_dir, down
  je    move_down

jmp     stop_move       ; no direction.


move_left:
  mov   al, b.snake[0]
  dec   al
  mov   b.snake[0], al
  cmp   al, -1
  jne   stop_move       
  mov   al, es:[4ah]    ; col number.
  dec   al
  mov   b.snake[0], al  ; return to right.
  jmp   stop_move

move_right:
  mov   al, b.snake[0]
  inc   al
  mov   b.snake[0], al
  cmp   al, es:[4ah]    ; col number.   
  jb    stop_move
  mov   b.snake[0], 0   ; return to left.
  jmp   stop_move

move_up:
  mov   al, b.snake[1]
  dec   al
  mov   b.snake[1], al
  cmp   al, -1
  jne   stop_move
  mov   al, es:[84h]    ; row number -1.
  mov   b.snake[1], al  ; return to bottom.
  jmp   stop_move

move_down:
  mov   al, b.snake[1]
  inc   al
  mov   b.snake[1], al
  cmp   al, es:[84h]    ; row number -1.
  jbe   stop_move
  mov   b.snake[1], 0   ; return to top.
  jmp   stop_move

stop_move:
  ret
move_snake endp
;************************************************************************
move_snake2 proc near

; set es to bios info segment:  
mov     ax, 40h
mov     es, ax

  ; point di to tail
  mov   di, s_tam2 * 2 - 2
  ; move all body parts
  ; (last one simply goes away)
  mov   cx, s_tam2-1
move_array2:
  mov   ax, snake2[di-2]
  mov   snake2[di], ax
  sub   di, 2
  loop  move_array2


cmp     cur_dir, left
  je    move_left2
cmp     cur_dir, right
  je    move_right2
cmp     cur_dir, up
  je    move_up2
cmp     cur_dir, down
  je    move_down2

jmp     stop_move2       ; no direction.


move_left2:
  mov   al, b.snake2[0]
  dec   al
  mov   b.snake2[0], al
  cmp   al, -1
  jne   stop_move2       
  mov   al, es:[4ah]    ; col number.
  dec   al
  mov   b.snake2[0], al  ; return to right.
  jmp   stop_move2

move_right2:
  mov   al, b.snake2[0]
  inc   al
  mov   b.snake2[0], al
  cmp   al, es:[4ah]    ; col number.   
  jb    stop_move2
  mov   b.snake2[0], 0   ; return to left.
  jmp   stop_move2

move_up2:
  mov   al, b.snake2[1]
  dec   al
  mov   b.snake2[1], al
  cmp   al, -1
  jne   stop_move2
  mov   al, es:[84h]    ; row number -1.
  mov   b.snake2[1], al  ; return to bottom.
  jmp   stop_move2

move_down2:
  mov   al, b.snake2[1]
  inc   al
  mov   b.snake2[1], al
  cmp   al, es:[84h]    ; row number -1.
  jbe   stop_move2
  mov   b.snake2[1], 0   ; return to top.
  jmp   stop_move2

stop_move2:
  ret
move_snake2 endp

;------------------------------------------------------------------------
move_snake3 proc near

; set es to bios info segment:  
mov     ax, 40h
mov     es, ax

  ; point di to tail
  mov   di, s_tam3 * 2 - 2
  ; move all body parts
  ; (last one simply goes away)
  mov   cx, s_tam3-1
move_array3:
  mov   ax, snake3[di-2]
  mov   snake3[di], ax
  sub   di, 2
  loop  move_array3


cmp     cur_dir, left
  je    move_left3
cmp     cur_dir, right
  je    move_right3
cmp     cur_dir, up
  je    move_up3
cmp     cur_dir, down
  je    move_down3

jmp     stop_move3       ; no direction.


move_left3:
  mov   al, b.snake3[0]
  dec   al
  mov   b.snake3[0], al
  cmp   al, -1
  jne   stop_move3       
  mov   al, es:[4ah]    ; col number.
  dec   al
  mov   b.snake3[0], al  ; return to right.
  jmp   stop_move3

move_right3:
  mov   al, b.snake3[0]
  inc   al
  mov   b.snake3[0], al
  cmp   al, es:[4ah]    ; col number.   
  jb    stop_move3
  mov   b.snake3[0], 0   ; return to left.
  jmp   stop_move3

move_up3:
  mov   al, b.snake3[1]
  dec   al
  mov   b.snake3[1], al
  cmp   al, -1
  jne   stop_move3
  mov   al, es:[84h]    ; row number -1.
  mov   b.snake3[1], al  ; return to bottom.
  jmp   stop_move3

move_down3:
  mov   al, b.snake3[1]
  inc   al
  mov   b.snake3[1], al
  cmp   al, es:[84h]    ; row number -1.
  jbe   stop_move3
  mov   b.snake3[1], 0   ; return to top.
  jmp   stop_move3

stop_move3:
  ret
move_snake3 endp
;------------------------------------------------------------------------
move_snake4 proc near

; set es to bios info segment:  
mov     ax, 40h
mov     es, ax

  ; point di to tail
  mov   di, s_tam4 * 2 - 2
  ; move all body parts
  ; (last one simply goes away)
  mov   cx, s_tam4-1
move_array4:
  mov   ax, snake4[di-2]
  mov   snake4[di], ax
  sub   di, 2
  loop  move_array4


cmp     cur_dir, left
  je    move_left4
cmp     cur_dir, right
  je    move_right4
cmp     cur_dir, up
  je    move_up4
cmp     cur_dir, down
  je    move_down4

jmp     stop_move4       ; no direction.


move_left4:
  mov   al, b.snake4[0]
  dec   al
  mov   b.snake4[0], al
  cmp   al, -1
  jne   stop_move4       
  mov   al, es:[4ah]    ; col number.
  dec   al
  mov   b.snake4[0], al  ; return to right.
  jmp   stop_move4

move_right4:
  mov   al, b.snake4[0]
  inc   al
  mov   b.snake4[0], al
  cmp   al, es:[4ah]    ; col number.   
  jb    stop_move4
  mov   b.snake4[0], 0   ; return to left.
  jmp   stop_move4

move_up4:
  mov   al, b.snake4[1]
  dec   al
  mov   b.snake4[1], al
  cmp   al, -1
  jne   stop_move4
  mov   al, es:[84h]    ; row number -1.
  mov   b.snake4[1], al  ; return to bottom.
  jmp   stop_move4

move_down4:
  mov   al, b.snake4[1]
  inc   al
  mov   b.snake4[1], al
  cmp   al, es:[84h]    ; row number -1.
  jbe   stop_move4
  mov   b.snake4[1], 0   ; return to top.
  jmp   stop_move4

stop_move4:
  ret
move_snake4 endp 
;---------------------------------------------------------------
move_snake5 proc near

; set es to bios info segment:  
mov     ax, 40h
mov     es, ax

  ; point di to tail
  mov   di, s_tam5 * 2 - 2
  ; move all body parts
  ; (last one simply goes away)
  mov   cx, s_tam5-1
move_array5:
  mov   ax, snake5[di-2]
  mov   snake5[di], ax
  sub   di, 2
  loop  move_array5


cmp     cur_dir, left
  je    move_left5
cmp     cur_dir, right
  je    move_right5
cmp     cur_dir, up
  je    move_up5
cmp     cur_dir, down
  je    move_down5

jmp     stop_move5       ; no direction.


move_left5:
  mov   al, b.snake5[0]
  dec   al
  mov   b.snake5[0], al
  cmp   al, -1
  jne   stop_move5       
  mov   al, es:[4ah]    ; col number.
  dec   al
  mov   b.snake5[0], al  ; return to right.
  jmp   stop_move5

move_right5:
  mov   al, b.snake5[0]
  inc   al
  mov   b.snake5[0], al
  cmp   al, es:[4ah]    ; col number.   
  jb    stop_move5
  mov   b.snake5[0], 0   ; return to left.
  jmp   stop_move5

move_up5:
  mov   al, b.snake5[1]
  dec   al
  mov   b.snake5[1], al
  cmp   al, -1
  jne   stop_move5
  mov   al, es:[84h]    ; row number -1.
  mov   b.snake5[1], al  ; return to bottom.
  jmp   stop_move5

move_down5:
  mov   al, b.snake5[1]
  inc   al
  mov   b.snake5[1], al
  cmp   al, es:[84h]    ; row number -1.
  jbe   stop_move5
  mov   b.snake5[1], 0   ; return to top.
  jmp   stop_move5

stop_move5:
  ret
move_snake5 endp
;---------------------------------------------------------------
move_snake6 proc near

; set es to bios info segment:  
mov     ax, 40h
mov     es, ax

  ; point di to tail
  mov   di, s_tam6 * 2 - 2
  ; move all body parts
  ; (last one simply goes away)
  mov   cx, s_tam6-1
move_array6:
  mov   ax, snake6[di-2]
  mov   snake6[di], ax
  sub   di, 2
  loop  move_array6


cmp     cur_dir, left
  je    move_left6
cmp     cur_dir, right
  je    move_right6
cmp     cur_dir, up
  je    move_up6
cmp     cur_dir, down
  je    move_down6
jmp     stop_move6       ; no direction.


move_left6:
  mov   al, b.snake6[0]
  dec   al
  mov   b.snake6[0], al
  cmp   al, -1
  jne   stop_move6       
  mov   al, es:[4ah]    ; col number.
  dec   al
  mov   b.snake6[0], al  ; return to right.
  jmp   stop_move6

move_right6:
  mov   al, b.snake6[0]
  inc   al
  mov   b.snake6[0], al
  cmp   al, es:[4ah]    ; col number.   
  jb    stop_move6
  mov   b.snake6[0], 0   ; return to left.
  jmp   stop_move6

move_up6:
  mov   al, b.snake6[1]
  dec   al
  mov   b.snake6[1], al
  cmp   al, -1
  jne   stop_move6
  mov   al, es:[84h]    ; row number -1.
  mov   b.snake6[1], al  ; return to bottom.
  jmp   stop_move6

move_down6:
  mov   al, b.snake6[1]
  inc   al
  mov   b.snake6[1], al
  cmp   al, es:[84h]    ; row number -1.
  jbe   stop_move6
  mov   b.snake6[1], 0   ; return to top.
  jmp   stop_move6

stop_move6:
  ret
move_snake6 endp
;---------------------------------------------------------------
;5145
;3132