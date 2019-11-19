        include AllMacros.inc
        .MODEL SMALL
        .STACK 64
        .DATA 
        mes db '___.                                      ___.          .__  .__   ' , '\_ |__   ____  __ __  ____   ____  ____   \_ |__ _____  |  | |  |  ' ,' | __ \ /  _ \|  |  \/    \_/ ___\/ __ \   | __ \\__  \ |  | |  |  '  ,' | \_\ (  <_> )  |  /   |  \  \__\  ___/   | \_\ \/ __ \|  |_|  |__'   , ' |___  /\____/|____/|___|  /\___  >___  >  |___  (____  /____/____/'  ,'     \/                  \/     \/    \/       \/     \/           ' ,'$'                                                                                                                                                                                                                                                                                                                          
empty db '                   ','$'
first db 'Enter your name        ','$' 
f1 db 'To start chatting press F1','$'
f2 db 'To start Bounce ball press F2','$'
esc db 'To exit press ESC','$'
ent  db 'press enter to continue              ','$'   
sent db ' you sent a game invitation','$'
accept db ' you recieved a game invitaiton to accept press f2','$'
f db  'player name: ','$'  
sentc db ' you sent a chat invitation','$'
acceptc db ' you recieved a chat invitaiton to accept press f1','$'
level db ?
level1 db 'LEVEL 1$'
level2 db 'LEVEL 2$'
le db 'please enter the number of the level$' 
fcursorp dw 1800h          ;pos cursor fe nos ely fo2
    scursorp dw 1814h      ;//   //    fe nos ely ta7t
    temppos  dw ?
    startpos dw ? 
    endpos   dw ?
        x dw ?   
        y dw ? 
        x2 DW ?
        y2 DW ?
slot1 db ?
slot2 db ?
const db 2
const3 db 3
e8 equ 20    ;slot length
ne8 equ -20  
arr1X dw 24 dup(?)
arr1Y dw 24 dup(?)
arr2X dw 24 dup(?)
arr2Y dw 24 dup(?)
temp db ? 
terr dw ?
e db ?
u db ?
TConstant dw 0,16h,0h,4h,10h,-5h,-20h,-3h,4h,-5,10,18    
host db 0
inchat db 0 ;on if 1           
count dw 0 
tenthousand dw 25000         
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
no1 dw 24 ;obstacles No.
no2 dw 24   
killerbooleanarr1 dw 24 dup(0) ;type of obstacle buffer
killerbooleanarr2 dw 24 dup(0)
disable1 db 1   ;0:disabled
disable2 db 1   ;0:disabled
killedbool db 0  ;1:killed
killedbool2 db 0 ;1:killed 
won1 db 0    ;1:won
won2 db 0    ;1:won
player1  db 10,?,10 dup('$')
player2  db 10 dup('$'),10,13
middle db 'Round:$' 
round db 1 ;Round No. Max(6) 
score1 db 0
score2 db 0
dr db 'Draw$'
won db ' WINNER$'
VALUE Db -1
delay dw ? 
;-----------------------------
;For DrawObstacle macro
lx dw ?
ly dw ?
lxx dw ?

        .code
MAIN    PROC FAR               
        MOV AX,@DATA
        MOV DS,AX 
        mov  es,ax
        initPort 
         
gamestart:    mov host,0
              mov round,1    ;re-initialization
              mov score1,0
              mov score2,0
              gamename mes
    startgame f,first,player1,ent  
    mainmenu f1,f2,esc,accept   
                
        
r:       Drawframe
         
ay:      
         mov count,0
         mov killedbool,0
         mov killedbool2,0
         initialize killerbooleanarr1
         initialize killerbooleanarr2 
         mov VALUE,-1 
         mov x,0
         mov x2,305 
 ;-------------------------------------------------------------------------------
   
                  ; get mouse left clicked
                  
 Mpos:  mov ax,3
        int 33h        
        cmp BX,1
        jz mouseClicked 
        cmp VALUE,-1
        jnz mpos
        receive
        cmp VALUE,-1
        JZ MPOS
        mov dx,0
        mov dl,value
        mov y2,dx 
        DRAWRECT x2,y2
        ;mov ax,0
        ;mov al,value
        
        jmp Mpos
           
mouseClicked: mov y,dx           ;draw first rectangle at (0,y) left  
              mov x,0 
              ;mov y2,dx
              mov x2,305
              DRAWRECT x,y
              send b.y
              cmp VALUE,-1
              JZ rec
              jmp display
rec:
              receive
              cmp VALUE,-1
              JZ rec 
              mov dx,0
              mov dl,value
              mov y2,dx        
              DRAWRECT X2,y2
              
              ;mov ax,0
              ;mov al,value
              ;mov y2,ax                             
   

display:  mov value,-1
          cmp killedbool,2     ;check if round is finished if one won
          jz roundfinish
          cmp killedbool2,2
          jz roundfinish 
          cmp killedbool,1
          jz  stlose           ;check if round is fiinshed if both lose
          ;cmp killedbool2,1
          ;jz ndlose
          
ag:          mov ah,1             ;take input from keyboard
          int 16h          
          jnz IsUp
          
          ;;;;;;;;;;;;;;;;;;;;;; 
ag2:       receive
          cmp value,-1
          jnz player2222  
          ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          cmp level,2           ;;;Determine the level
          jnz display
          
         ; cmp host,1
         ; jz ana
;brdo:     receive
;          cmp value,10
;          jnz brdo
;          send b.count
;          mov value,-1
;          jmp yalla2
              
;          ana:send 10
;brdo2:      receive
;          cmp value,-1
;          jz brdo2
;          mov dl,value
;          mov count,dl
;          mov value,-1
          
          ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          
yalla2:       inc count   
          mov dx,0
          mov ax,count
          div tenthousand
          mov delay,dx
          cmp delay,0
          jnz display
           
           ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ;  mov ah,86h           ;delay for the gravity effect
        ;  mov cx,05h
         ;int 15h 
            
          REMOVERECT x,y 
          add y,1     ;num of pixels to move down due to gravity in the 1st player
          checkdo x,y,slot1,killedbool,disable1  ;checks wether the player hit the ground 
          call player11        ;check wether the player hit an obstacle
          cmp killedbool,1     ;determine whi9ch face to draw
          jz firstsad         
          DRAWRECT x,y

          ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          
@:        cmp level,2           ;;;Determine the level
          jnz display
          cmp delay,0
          jnz display
          
          REMOVERECT x2,y2
          add y2,1    ;num of pixels to move down due to gravity in the 2nd player
          CHECKDOTWO x2,y2,slot2,killedbool2,disable2
          call player22
          cmp killedbool2,1
          jz secondsad 
          DRAWRECT x2,y2
          jmp display
 
          ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IsUp:  cmp killedbool,1
       jz buffer

       cmp ah,72
       jnz Isdown
       send 72
       mov ah,0
       int 16h  
       
       REMOVERECT x,y 
       sub y,2     ;num of pixels to move up
       
       CheckUP x,y,slot1,killedbool,disable1;checks if the the player hit the roof
       checkright x,y,slot1,killedbool,disable1,won1;checks if the player hit a wall or won                                                                            
       call player11 
       cmp killedbool,1
       jz firstsad
       DRAWRECT x,y
       jmp itterate
       
Isdown: cmp ah,80
        jnz IsRight  
        send 80
        mov ah,0
        int 16h
        REMOVERECT x,y
        add y,2    ;num of pixels to move down
        CheckDo x,y,slot1,killedbool,disable1;checks if the 1st player hit the ground
        checkright x,y,slot1,killedbool,disable1,won1;checks if the player hit a wall or won                                 
        call player11
        cmp killedbool,1
        jz firstsad
        DRAWRECT x,y 
        jmp itterate 
        
        
IsRight: cmp ah,77
         jnz IsLeft 
         send 75
         mov ah,0
         int 16h
         
         REMOVERECT x,y
         add x,1     ;num of pixels to move right
         checkright x,y,slot1,killedbool,disable1,won1;checks if the player hit a wall or won 
         CheckDo x,y,slot1,killedbool,disable1;checks if the 1st player hit the ground
         CheckUP x,y,slot1,killedbool,disable1;checks if the the player hit the roof                                                 
         call player11
         cmp killedbool,1
         jz firstsad
         DRAWRECT x,y
         jmp itterate
         
IsLeft: cmp ah,75
        jnz pause     ;if the user pressed p 
        send 77
        mov ah,0
        int 16h
        
        REMOVERECT x,y
        
        sub x,1      ;num of pixels to move left 
        cmp x,1      ;if x reaches to the left side 
        js repX
        
        call player11
        cmp killedbool,1
        jz firstsad
        DRAWRECT x,y
        jmp itterate 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pause:  cmp al,112
        jnz buffer
        send 112
        mov ah,0
        int 16h
        mov inchat,1
        call chat 
        mov inchat,0
        mov value,-1
l:      mov ah,1
        int 16h          
        jz checkpause
        cmp al,112
        jnz z@
        send 112
        jmp clear
z@:     mov ah,0
        int 16h
        jmp l 
checkpause:
        receive
        cmp value,112
        jz display
        jmp l
        ;cmp al,112
        ;jnz z@
        ;jmp clear
;z@:     ;mov ah,0
        ;int 16h
        ;jmp l         
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
buffer:mov ah,0
       int 16h
itterate:
         receive 
         cmp value,-1
         jz display
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
player2222:        
UPSEC: cmp killedbool2,1
       jz display
       cmp value,72 
       jnz DOWNSEC
       
       ;mov ah,0
       ;int 16h  
       
       REMOVERECT x2,y2 
       sub y2,2     ;num of pixels to move up
       CHECKUPTWO x2,y2,slot2,killedbool2,disable2;checks if the player hit the roof
       Checklefttwo x2,y2,slot2,killedbool2,disable2,won2;checks if the player hit a wall or won
       call player22
       cmp killedbool2,1
       jz secondsad
       DRAWRECT x2,y2 
       jmp display
       
DOWNSEC:cmp value,80 
        jnz RIGHTSEC
       
       ; mov ah,0
       ; int 16h
        
        REMOVERECT x2,y2
        add y2,2    ;num of pixels to move down
        CHECKDOTWO x2,y2,slot2,killedbool2,disable2;checks if the player hit the ground
        Checklefttwo x2,y2,slot2,killedbool2,disable2,won2;checks if the player hit a wall or won
        call player22 
        cmp killedbool2,1
        jz secondsad
        DRAWRECT x2,y2
        jmp display

RIGHTSEC:cmp value,77
         jnz LEFTSEC 
         
         ;mov ah,0
         ;int 16h
         
         REMOVERECT x2,y2
         add x2,1     ;num of pixels to move right
         cmp x2,305    ;if x reaches to the right side 
         jns replaceX2
        
         call player22
         cmp killedbool2,1
         jz secondsad
         DRAWRECT x2,y2
         jmp display  
         
LEFTSEC:cmp value,75      
        jnz pause2     ;if the user pressed anything 
        
        ;mov ah,0
        ;int 16h
        
        REMOVERECT x2,y2
        sub x2,1      ;num of pixels to move left
        Checklefttwo x2,y2,slot2,killedbool2,disable2,won2;checks if the player hit a wall or won
        CHECKUPTWO x2,y2,slot2,killedbool2,disable2;checks if the player hit the roof
        CHECKDOTWO x2,y2,slot2,killedbool2,disable2;checks if the player hit the ground
        call player22
        cmp killedbool2,1
        jz secondsad
        DRAWRECT x2,y2                   
        jmp display 
        

pause2: cmp value,112
        jnz display
        mov value,-1
        ;mov ah,0
        ;int 16h 
        mov inchat,1
        call chat
        mov inchat,0
        mov value,-1
lp2:    mov ah,1
        int 16h          
        jz checkpause2
        cmp al,112
        jnz z@2
        send 112
        jmp clear
z@2:    mov ah,0
        int 16h
        jmp lp2 
checkpause2:
        receive
        cmp value,112
        jz display
        jmp lp2         

       
clear: mov ah,0        ;clear keyboard buffer
       int 16h
       jmp display 
       
        
roundfinish:RoundFinished round,killedbool,killedbool2
          
 
stlose:cmp killedbool2,1 ;if both lose then finish the round
        jz fin
        jnz ag
        
ndlose:cmp killedbool,1 ;if both lose then finish the round
       jz fin
       jnz ag2        
fin: RoundFinished round,killedbool,killedbool2          

firstSad: DrawRectSad X,Y
          jmp @

secondSad:DrawRectSad X2,Y2
          jmp display

repX:     REMOVERECT x,y    ;prevent penetrating the screen
          mov x,0
          DRAWRECT x,y
          jmp display  
          

         
  
          
replaceX2:REMOVERECT x2,y2
          mov x2,305
          DRAWRECT x2,y2
          jmp display 

MAIN    ENDP
         
;--------------------------------------------------------------------------------------------          
  player11 proc
    cmp killedbool,1
    jz return
    mov di,0
;the loop check if i on the one of the obstacles or touching it or not
;w.r.t the x of the square and also that of the obstacles
;if yes move to check ys
loop:
cmp arr1x[di],500   ;with the unlogic no, means that i visit it before so delete it from the mode
jz  continue
mov ax,x
add ax,15 
mov si,arr1x[di]
add si,5
cmp ax,si
JAE checker1    
continue:inc di  ;dataword
inc di
cmp di,no1         ;;number of obstacles  (needed)
jz return        ;if finished move to the second player check him
jmp loop
;;;;;;;;;;;;;;;;;;;;;;
;if the x of the obstacle greater or equal or not 
checker1:
mov ax,x                                                  
cmp arr1x[di],ax
JAE x_is_inside
jmp continue
;;;;;;;;;;;;;;;;;;;;
;the loop check if i on the one of the obstacles or touching it or not
;w.r.t the y of the square and also that of the obstacles
;if yes move to check change my status in the two states        
x_is_inside:
mov ax,y
add ax,15
mov si,arr1y[di]
add si,5 
cmp ax,si
JAE checker2
JB  continue
;;;;;;;;;;;;;;;;;;;;;
;if the y of the obstacle greater or equal or not
checker2:
mov ax,y
cmp arr1y[di],ax
JAE y_is_inside
jmp continue
;;;;;;;;;;;;;;;;;;;;;
;my status changed to 
;if this obstacle is mine(green), then draw its reflection to the enemy
;if it belongs to the enemy(red), then unfortunatly, i lose.
y_is_inside:
cmp killerbooleanarr1[di],0
jnz disabling

;making sound when hit
mov ah,2
mov dl,07h
int 21h
;remove this obstacle from my zone
mov cx,arr1x[di]
mov dx,arr1y[di] 
DrawObstacle cx,dx,0h ; make it after deleting return to this place;;;;;
jz drawreflection
;;;;;;;;;;;;;;;;;;;;
;draw the obstacle reflection and red  
drawreflection: 
mov si,di
mov ax,arr1x[di]
mov bx,arr1y[di]
Reversehamdy ax,bx,di  ;mfrood hwa ye3raf heya fe anhy region 3l4an ye7otha aw lw hwa 3aref
mov di,si
mov arr1x[di],500    ;number which is unlogic to skip it the next steps
mov arr1y[di],500
jmp return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;disable me and change me to be killed
disabling:
;making sound 3 times when killed
mov cx,3
lll:mov ah,2
mov dl,07h
int 21h
loop lll
mov killedbool,1   ;1 means i lose (2 i win)
jmp return
;;;;;;;;;;;;;;;;;
return: 
    ret
    player11  endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
player22 proc
     cmp killedbool2,1
    jz return1
    mov di,0
loop2:
cmp arr2x[di],500   ;with the unlogic no, means that i visit it before so delete it from the mode
jz  continue2
mov ax,x2
add ax,15
mov si,arr2x[di]
add si,5
cmp ax,si
JAE checker3    
continue2:inc di
inc di
cmp di,no2         ;;no of obstacles
jz return          ;if finished move to the return state from macro
jmp loop2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;if the x of the obstacle greater or equal or not
checker3: 
mov ax,x2
cmp arr2x[di],ax
JAE x2_is_inside 
jmp continue2
;;;;;;;;;;;;;;;;;;
;the loop check if i on the one of the obstacles or touching it or not
;w.r.t the y of the square and also that of the obstacles
;if yes move to check change my status in the two states 
x2_is_inside:
mov ax,y2
add ax,15 
mov si,arr2y[di]
add si,5
cmp ax,si
JAE checker4
jmp continue2
;;;;;;;;;;;;;;;;;;;;
;if the y of the obstacle greater or equal or not
checker4: 
mov ax,y2
cmp arr2y[di],ax
JAE y2_is_inside
JB continue2
;;;;;;;;;;;;;;;;;;;;;;;;;
;my status changed to 
;if this obstacle is mine(green), then draw its reflection to the enemy
;if it belongs to the enemy(red), then unfortunatly, i lose.
y2_is_inside:
cmp killerbooleanarr2[di],0
jnz disabling2

;make sound when hit
;mov ah,2
;mov dl,07h
;int 21h
;remove this obstacle from my zone    
mov cx,arr1x[di]
mov dx,arr1y[di]
drawobstacle cx,dx,0h ; make it after deleting return to this place;;;;;
jz drawreflection2
;;;;;;;;;;;;;;;;;;;;;;;;;;
;draw the obstacle reflection and red
drawreflection2:
mov si,di
mov ax,arr2x[di]
mov bx,arr2y[di]
Reversehamdy ax,bx,di
mov di,si
mov arr2x[di],500    ;number which is unlogic to skip it the next steps
mov arr2y[di],500 
jmp return1
;;;;;;;;;;;;;;;;;;;;;;;;;;;
;disable me and change me to be killed
disabling2:
;make sound three times when killed
mov cx,3
lll2:mov ah,2
mov dl,07h
int 21h
loop lll2
mov killedbool2,1   ;1 means i lose (2 i win)
jmp return1
;;;;;;;;;;;;;;;;;;;;;;;;;;
;return from the macro
return1:    
       ret  
       player22  endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;     

chat proc
            
   cmp inchat,1
   jz beg
   mov fcursorp,0100h          ;pos cursor fe nos ely fo2
   mov scursorp,0d00h   
    mov ah,0
    mov al,3
    int 10h
      
    ;move cursor to draw line in the middle of the screen 
    mov dx,0b00h
    mov ah,2       
    int 10h
    ;draw line
    mov cx,80 
    mov dl,'_'
    mLine:int 21h
    loop mline
      
    mov ah,2
    mov dx,0c00h
    int 10h 
    
    mov ah, 9
    mov dx, offset player2
    int 21h 
    
    mov ah,2
    mov dx,0c08h
    int 10h
    
    mov ah,2
    mov dl,':'
    int 21h
    
    mov ah,2
    mov dx,0000h
    int 10h 
    
    mov ah, 9
    mov dx, offset player1+2
    int 21h 
    
    mov ah,2
    mov dx,0008h
    int 10h 
             
    mov ah,2
    mov dl,':'
    int 21h 
    jmp l12
     
beg: mov fcursorp,1800h          ;pos cursor fe nos ely fo2
   mov scursorp,1814h      
     
    l12:   
;Check that Transmitter Holding Register is Empty
		mov dx , 3FDH		;Line Status Register
AGAIN:  In al , dx 			;Read Line Status
  		AND al , 00100000b
  		JZ RECIEVE      

        MOV AH,1 ;change
        INT 16H 
        JZ RECIEVE    ; if buffer empty zf=1
        MOV AH,0
        INT 16H 
        mov value,al
        cmp ah,4bh
        jz leftB
        cmp ah,4dh
        jz rightB
        cmp ah,48h
        jz upB
        cmp ah,50h
        jz downB
        cmp ah,01h
        jz endc
        contB: 
        cmp inchat,1 
        jz yes 
        mov startpos,0100h 
        mov endpos,0a4fh
        jmp no
    yes:   mov startpos,1800h 
        mov endpos,1813h 
        
    no: mov di,fcursorp
        mov temppos,di
        call check
        mov di,temppos
        mov fcursorp,di 
        ;set cursor
        mov dx,temppos
        mov ah,2
        int 10h   
        
        mov al,value
    ;If empty put the VALUE in Transmit data register
      	mov dx, 3F8H		; Transmit data register
      	out dx, al      ;seeeeeeeeeeeend 
      	cmp al,27d
      	jz endch
    
RECIEVE:   
;Check that Data Ready
		mov dx , 3FDH		; Line Status Register
CHK:	in al , dx 
  		AND al , 1
  		JZ L12          ;lw empty
 ;If Ready read the VALUE in Receive data register
  		mov dx , 03F8H
  		in al , dx       
  		mov VALUE , al   
  		cmp al,27d
      	jz endch  
      	cmp inchat,1 
      	jz yes1
      	mov startpos,0d00h 
  		mov endpos,164fh  
  		jmp no11
yes1:  	mov startpos,1814h 
  		mov endpos,1828h
no11:  	mov di,scursorp
  		mov temppos,di 
  		call check
  		mov di,temppos
        mov scursorp,di
        ;set cursor
        mov dx,temppos
        mov ah,2
        int 10h 
        jMP l12
        leftB:
        mov value,0EAh
        jmp contB
        rightB: 
        mov value,0EBh
        jmp contB
        upB:
        mov value,0ECh
        jmp contB
        downB:
        mov value,0EDh
        jmp contB  	
        endc:
        mov value,27d
        jmp contB	
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        endch:

  chat endp 
  check proc
    cmp value,8
    jz backspace
    cmp inchat,1
    jz skip 
    cmp value,13d
    jz enter 
    
skip:    cmp value,13d
    jz right
    cmp value,0EAh
    jz left
    cmp value,0EBh
    jz right
    cmp value,0ECh
    jz leave3
    cmp value,0EDh
    jz leave3  
    cmp value,27d
    jz leave3
    pusha 
    jmp leave
    backspace:
        pusha  
        ;get cursor position
        mov dx,temppos     ; el postion ely na 3ando dlwa2ty        
        cmp dx,startpos
        jz leave2
        cmp dl,0       ;dl = x coor ll column ely na wa2fa feh if dl = 0 y3ni na 3la shmal 5ales w satr 8er satr el awlani
        jz back
        dec dl
        jmp back2
        back:
        mov dl,79       ;mov to a5r satr ely a2blo
        dec dh
        back2:
        mov ah,2           ; save position
        int 10h
        mov cx,dx 
        mov ah,2
        mov dl,' '
        int 21h 
        ;get cursor position
        mov dx,cx
        mov temppos,dx
        mov ah,2
        int 10h  
        jmp leave2  
        
        enter:  
        pusha
        ;get cursor position
        mov dx,temppos
        mov cx,endpos
        cmp dh,ch    ;lw homa fe a5r satr
        jz scroll1;---------------------------------------------------
        inc dh
        mov dl,0
        mov ah,2
        int 10h
        mov temppos,dx
        jmp leave2
    
    left:
        pusha
        ;get cursor position
        mov dx,temppos 
        cmp dx,startpos
        jz leave2
        cmp dl,0      ;lw na fe awl saf w m4 el awlani
        jz left2
        dec dl
        jmp left3
        left2:
        dec dh
        mov dl,79d
        left3:
        mov ah,2
        int 10h
        mov temppos,dx
        jmp leave2
    right: 
        pusha
        ;get cursor position
        mov dx,temppos 
        cmp dx,endpos
        jz scroll1;--------------------------------------------------
        cmp dl,79d ; lw na 3la ymen 5les w m4 fe satr el a5er
        jz right2
        inc dl
        jmp right3
        right2:
        inc dh
        mov dl,0
        right3:
        mov ah,2
        int 10h
        mov temppos,dx
        jmp leave2       
        leave:
    mov dx,temppos
    mov ah,2
    int 10h     ; mov cursor
    mov dl,al   ; al == value
    int 21h     ;display char
    mov ah,3     ; get cursor save in dx
    int 10h
    mov temppos,dx 
    
    cmp inchat,1
    jz noscr   
    cmp temppos,0b00h
    jz scroll2
    cmp temppos,1700h
    jz scroll2 
    jmp scr
noscr:    cmp temppos,1827h
    jz scroll2
    cmp temppos,1813h
    jz scroll2 
scr:    jmp leave2
    scroll1:
    call scroll
    jmp leave2
    scroll2:
    call scroll
    leave2:popa
    leave3:
    ret
check ENDP
scroll proc 
    
    pusha  
    cmp inchat,1
    jz remov 
    mov cx,temppos
    cmp ch,0bh        ;compare    blnos
    ja  lowerhalf     ;lw ch > 0b 
    jmp upperhalf
    lowerhalf:
    mov startpos,0c00h
    mov endpos,164fh
    jmp do_it  
    upperhalf:
    mov startpos,0
    mov endpos,0a4fh
    do_it:
    mov     ah, 06h ; scroll down function id.
    mov     al, 1   ; lines to scroll.
    mov     bh, 07  ; attribute for new lines.
    mov     cx,startpos
    mov     dx,endpos
    int     10h
    mov cx,endpos      ;a5ly el cursor fe awl el satr el a5er
    mov cl,0
    mov temppos,cx
    mov dx,temppos
    mov ah,2
    int 10h 
    jmp scrol
remov:    mov cx,temppos
    cmp cl,13h        ;compare    blnos
    ja  ilowerhalf     ;lw ch > 0b 
    jmp iupperhalf
    ilowerhalf:
    mov startpos,1814h
    mov endpos,1828h
    jmp ido_it  
    iupperhalf:
    mov startpos,1800h
    mov endpos,1813h
    ido_it:

    mov dx,startpos
    mov ah,2
    int 10h    
    mov ah, 9
mov dx, offset empty
int 21h
    mov cx,startpos
    mov temppos,cx 
scrol:    
      
    popa  
    ret
scroll  ENDP                                         
;---------------------------------------------------------------------------------------------        
 END MAIN       
                        
                        
                        
                        
                        
               





















 


 
        
       
                      
     
         