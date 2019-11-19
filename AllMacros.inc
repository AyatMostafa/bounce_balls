DRAWRECT MACRO  X,Y
     local rect        ;first part for drawing the main body (square)
     local increase
     local back
     local back5
     local back4
     local h
     local p
     local con
     mov al,4h  ;red pixel 
     mov ah,0ch  ;draw pixel command
     mov dx,Y ;row
     mov cx,X ;col 

     mov si,X
     ADD si,15d
     mov di,Y
     ADD di,15d 
     
     rect:
         mov cx,X
         increase:
                 int 10h
                 inc cx
                 cmp cx,si
                 jnz increase
         inc dx
         cmp dx,di
         jnz rect
;---------------------------------------------------------- Drawing rest of the face details
mov si,x
add si,7                     ;drawing the eyes
mov cx,X ;Column
add cx,3

p:mov dx,y
  mov dh,0
;mov dl,b.Y ;Row
add dl,4
mov al,0fh ;Pixel color
mov ah,0ch ;Draw Pixel Command
int 10h
inc cx
dec dx
int 10h
inc cx
inc dx
int 10h
cmp cx,si
jb h  
jmp con
h:add cx,4
  jmp p
                           ;drawing the nose
con:
mov ax,y
mov ah,0
;mov al,b.y
mov e,al
add e,6
mov u,al
add u,9

mov dh,0
mov cx,X ;Column
add cx,7
mov dl,e ;Row
mov al,0fh ;Pixel color
mov ah,0ch ;Draw Pixel Command
back: int 10h
inc dl
cmp dl,u
jnz back

 mov si,x                ;drawing the mouth
 add si,10
 mov dh,0
mov cx,X ;Column
add cx,5
mov dx,y
mov dx,y
mov dh,0
;mov dl,b.Y ;Row
add dl,11
mov al,0fh ;Pixel color
mov ah,0ch ;Draw Pixel Command
back4: int 10h
inc cx
cmp cx,si
jnz back4

mov dh,0
mov cx,X ;Column
add cx,4
mov dx,y
mov dh,0
;mov dl,b.y ;Row
add dl,10
mov al,0fh ;Pixel color
mov ah,0ch ;Draw Pixel Command
back5: int 10h
add cx,6
int 10h
    
ENDM DRAWRECT

DrawRectSad macro X,Y
     local rect
     local increase
     local back
     local back5
     local back4
     local h
     local p
     local con
     mov al,4h  ;red pixel 
     mov ah,0ch  ;draw pixel command
     mov dx,Y ;row
     mov cx,X ;col 

     mov si,X
     ADD si,15d
     mov di,Y
     ADD di,15d 
     
     rect:
         mov cx,X
         increase:
                 int 10h
                 inc cx
                 cmp cx,si
                 jnz increase
         inc dx
         cmp dx,di
         jnz rect
;----------------------------------------------------------
mov si,x
add si,7
mov cx,X ;Column
add cx,3
p:mov dl,b.Y ;Row
add dl,4
mov al,0fh ;Pixel color
mov ah,0ch ;Draw Pixel Command
int 10h
inc cx
int 10h
inc cx
int 10h
cmp cx,si
jb h  
jmp con
h:add cx,4
  jmp p

con:
mov al,b.y
mov e,al
add e,6
mov u,al
add u,9

mov dh,0
mov cx,X ;Column
add cx,7
mov dl,e ;Row
mov al,0fh ;Pixel color
mov ah,0ch ;Draw Pixel Command
back: int 10h
inc dl
cmp dl,u
jnz back

 mov si,x
 add si,10
 mov dh,0
mov cx,X ;Column
add cx,5
mov dl,b.Y ;Row
add dl,11
mov al,0fh ;Pixel color
mov ah,0ch ;Draw Pixel Command
back4: int 10h
inc cx
cmp cx,si
jnz back4

    ;local back5
mov dh,0
mov cx,X ;Column
add cx,4
mov dl,b.y ;Row
add dl,12
mov al,0fh ;Pixel color
mov ah,0ch ;Draw Pixel Command
back5: int 10h
add cx,6
int 10h

ENDM DrawRectSad

RemoveRECT MACRO  X,Y
     local rect
     local increase
     ;mov ah,0
     ;mov al,13h
     ;int 10h
     
     mov al,0h  ;black pixel 
     mov ah,0ch  ;draw pixel command
     mov dx,Y ;row
     mov cx,X ;col 

     mov si,X
     ADD si,15d
     mov di,Y
     ADD di,15d 
     
     rect:
         mov cx,X
         increase:
                 int 10h
                 inc cx
                 cmp cx,si
                 jnz increase
         inc dx
         cmp dx,di
         jnz rect
    
ENDM RemoveRECT   
  
Drawline macro start,end,color  ;Draw line at the middle of the screen with a certain color
    local back
mov dh,0
mov cx,160 ;Column
mov dl,start ;Row
mov al,color ;Pixel color
mov ah,0ch ;Draw Pixel Command
back: int 10h
inc dl
cmp dl,end
jnz back     
ENDM Drawline

DrawObstacle macro upleftX,upleftY,color
local start
local rett
local back
start: 
mov lx,upleftX
mov lxx,upleftX
add lx,5
mov ly,upleftY
add ly,5         
mov al,color ;Pixel color
mov ah,0ch ;Draw Pixel Command
mov dx,upleftY
rett:mov cx,lxx  ;Column
back: int 10h                                   
inc cx
cmp cx,lx
jnz back 
inc dx
cmp dx,ly
jnz rett
ENDM DrawObstacle
 
Reverse macro x,y            ;draw the obstacle image on the other zone
    mov cx,315
    sub cx,x
    mov arr2X[di],cx
    add di,2
    DrawObstacle cx,y,7h
ENDM reverse 
    
DrawFrame macro
    local x
    local y 
mov value,-1    
mov ah,0
mov al,13h
int 10h
cmp host,1
jnz p2
hey:receive
cmp value,3
jnz hey
mov ah,2ch              ;call time interrupt to determine the slots randomly
int 21h
mov slot1,dl
add slot1,8
mov al,slot1
mul const
mov slot1,al
mov slot2,dh
add slot2,8
mov al,slot2
mul const3
mov slot2,al
;mov slot1,30
;mov slot2,90
mov cl,slot1
sub cl,slot2
cmp cl,20          ;;;;;;;;;;;; check if coincide
jl edit1
  
cont:
cmp slot1,200-20-2-9  ;;;;;;;;;;;
ja finalledit 
cmp slot2,200-40-5-9  ;;;;;;;;;;;;;;;
ja finalledit2
y@:;cmp host,0
;jz p2
bk:send slot1
rag:   receive
   cmp value,2
   jnz rag
   mov value,-1
   send slot2
rag2:   receive
   cmp value,2
   jnz rag2
   mov value,-1
yalla:mov cl,slot2
cmp slot1,cl
jb slot1first
jmp slot2first
p2:send 3
   receive 
   cmp value,-1
   jz p2
   send 2 
   mov cl,value
   mov slot2,cl
   mov value,-1
noo:   receive
   cmp value,-1
   jz noo
   send 2      
   mov cl,value
   mov slot1,cl
   mov value,-1
    
   ;mov al,slot1
   ;mov ah,slot2
   ;mov slot1,ah
   ;mov slot2,al
   jmp yalla

a: 

mov cl,temp                    ;fill pos X of obstackles in first zone near to 1st slot
mov ch,0
mov arr1X[si],cx
add si,2
add temp,13h
cmp si,12
jnz a
mov temp,35h
b:                              ;fill pos X of obstackles in first zone near to 2nd slot
mov cl,temp
mov ch,0
mov arr1X[si],cx
add temp,13h 
add si,2
cmp si,24
jnz b 
mov si,0 
c:mov ch,byte ptr Tconstant[si]   ;;fill pos Y of obstackles in first zone near to 1st slot
cmp host,0
jz ho
jmp k#
ho:mov bh,slot2 
   jmp ##
k#:mov bh,slot1
##:mov cl,bh
add cl,ch
mov ch,0
mov arr1Y[si],cx
mov arr2Y[si],cx
add si,2
cmp si,12
jnz c
d:mov ch,byte ptr TConstant[si]    ;;fill pos Y of obstackles in first zone near to 2nd slot
cmp host,0
jz ho2
jmp k#2
ho2:mov bh,slot1 
   jmp ##2
k#2:mov bh,slot2
##2:mov cl,bh
add cl,ch
mov ch,0
mov arr1Y[si],cx
mov arr2Y[si],cx
add si,2
cmp si,24
jnz d
mov si,0
mov di,0
i:mov ax,arr1X[si]
mov bx,arr1Y[si]
 
DrawObstacle ax,bx,2               ;draw obstacles 
mov ax,arr1X[si]
mov bx,arr1Y[si]

Reverse ax,bx                      ;draw their images
add si,2
cmp si,24
jnz i
mov si,0
mov di,0
WriteStatus                       ;draw the status bar
DrawStatusline 8                    ;draw status line with color indication of each zone
DrawStatusline 191
cmp host,0
jz one
still:receive
cmp value,85
jnz still 
mov value,-1
send 85
jmp ay

one:send 85
??: receive
    cmp value,85
    jnz ??
    mov value,-1
jmp ay

edit1:
cmp cl,0
jl x                              ;if coincides make them far apart
jnl y
x:cmp cl,-21 ;;;;;;;;;;;;;;;;
jl cont
jmp edit2
y: add slot1,e8+2
jmp cont

   
edit2:                             ;if coincides make them far apart
add slot2,e8+2
jmp cont


finalledit:                       ;if the slot is outside the screen
mov slot1,200-20-2-9
jmp cont
finalledit2:
cmp slot1,100
ja below
mov slot2,200-20-5-9
jmp y@
below:
mov slot2,20
jmp cont
 
 
slot1first:                     ;Draw the lines with their right colors based on which slot is first
Drawline 8,slot1,5
mov bl,slot1 
add bl,e8
Drawline bl,slot2,0fh 
mov bl,slot2
add bl,e8
Drawline bl,200,0eh
mov si,0 
mov temp,35h                                 ;;;;;;;;;;;;;;;;;;;;;
jmp a


slot2first: 
mov ah,0
mov al,13h
int 10h
Drawline 8,slot2,0eh 
mov bl,slot2
add bl,e8
Drawline bl,slot1,0fh
mov bl,slot1
add bl,e8
Drawline bl,200,5
mov si,0 
mov temp,37h            ;;;;;;;;;;;;;;;;;;;;;
jmp a

ENDM Drawframe 

DrawStatusline macro pos             ;Draw line of status bar with the 2 colors
local back,back2
mov dh,0
mov cx,0 ;Column
mov dl,pos ;Row
mov al,05h ;Pixel color
mov ah,0ch ;Draw Pixel Command
back: int 10h
inc cx
cmp cx,160
jnz back     
mov al,0eh ;Pixel color
mov ah,0ch ;Draw Pixel Command
back2:int 10h
inc cx
cmp cx,320
jnz back2     
    
ENDM DrawStatusline


gamename macro mes
local l 
 mov al,03h  ;set text mode
        mov ah,0 ;this macro prints the title of the game
        int 10h

 mov  dh,2
         mov di,0 
         mov si,6 
         mov  bp,offset mes ;STRING TO DISPLAY. 
            mov di,bp
            mov al,0
l:         mov  ah,13h ;SERVICE TO DISPLAY STRING WITH COLOR.
      
          mov bp,di
          
          mov bp,di
         mov  bh,0 ;PAGE (ALWAYS ZERO).
  mov  bl,7h
  mov  cx,67d ;STRING LENGTH.
  mov  dl,5 ;X (SCREEN COORDINATE). 
  mov al,0
  ;Y (SCREEN COORDINATE). 
  int  10h ;BIOS SCREEN SERVICES. 
 
  dec si ;to print all 6 lines under eachother
  add di, 67d ;the lenghth of the line is 67 
  inc dh 
  
  cmp si,0 ;checks if all the lines are printed
  jnz l 

endm gamenam

startgame macro f,first,player1,ent
local l2,l3
 mov ah,2 
mov dx,0a0fh
int 10h ;change the cursor position

mov ah, 9
mov dx, offset f
int 21h ;print the first line


 mov ah,2
mov dx,1715h
int 10h

mov ah, 9
mov dx, offset first
int 21h
   
 mov ah,2
mov dx,0a20h
int 10h ;change the cursor position

mov ah,0AH
mov dx,offset player1 
int 21h ;read the name of the player from the keyboard



mov ah,2
mov dx,1715h
int 10h

mov ah, 9
mov dx, offset ent
int 21h   

mov ch, 32
mov ah, 1
int 10h ; hide the cursor

L2:mov ah,0
int 16h


cmp ah,1ch
jz l3 ; check if the user clicks enter

jmp l2 ; wait for the player to enter the enter button

L3:
endm startgame


mainmenu macro f1,f2,esc,accept

local lo,c,g,e,loo,l3,looo,acc,n,acept
l3: gamename mes ; show the name of the game  
     
    mov ah,2
mov dx,0a12h
int 10h ;change the cursor positon

mov ah, 9
mov dx, offset f1
int 21h ;show the first line

  mov ah,2
mov dx,0d12h
int 10h

mov ah, 9
mov dx, offset f2
int 21h  

 mov ah,2
mov dx,1012h
int 10h

mov ah, 9
mov dx, offset esc
int 21h 
     
 mov ch, 32
mov ah, 1
int 10h ;hide the cursor
sendname
 

lo:  mov ah,1
int 16h
jnz looo 
receive
cmp [value],2
jz acc
cmp [value],1
jz acept
jmp lo
acc: 
 mov ah,2
mov dx,1801h
int 10h ;change the cursor positon

mov ah, 9
mov dx, offset accept
int 21h ;show the first line 

mov ah,0
int 16h
cmp ah,3ch
jz g

jnz acc


acept:  mov ah,2
mov dx,1801h
int 10h ;change the cursor positon

mov ah, 9
mov dx, offset acceptc
int 21h ;show the first line 

mov ah,0
int 16h
cmp ah,3bh
jz c
jnz acept 


looo:
mov ah,0
int 16h
cmp ah,3bh  
jz c   ;checks if the users presses f1

cmp ah,3ch
jz g   ;checks if the users presses f2

cmp ah,1
jz e   ;checks if the user presses esc      
          
 jmp lo

c:
sendchat
call chat
mov value,-1
jmp l3
 

e:  mov ax,0600h
    mov bh,07
    mov cx,0
    mov dx,184fH
    int 10h
      mov ah,0x4C   ;Dos Terminate func.
      int 0x21  ;exits game
g: 

sendinvi 
levels

endm mainmenu


CheckUP macro x,y,slot1,killedbool,disable1
    local l1
    local l2
	local l3
	local l4
local l5
    local lost1
local l
cmp y,9  ;checks if it hit the roof 
       js l4
       
       cmp x,145 ;checks if it reached the finish line
       jae l1
	jmp l 
  l1:  mov bx,0 ;if it reached the line it check if the object is infront of the slot
       mov bl,[slot1]
dec bx
       cmp bx,y ; if the object is touching the edge of the slot it'll lose
        jz l5
        jmp l ;if not it'll continue moving normally

l5: mov bx,0

   mov bl,[slot1] 
   mov y,bx ;set the y to the place of the slot
	jmp lost1 ;lose the game		 

l4: mov y,9
jmp lost1 ;loses if it hit the roof

lost1: mov killedbool,1
mov disable1,0
      
      
l:
endm CheckUP


CheckDo macro x,y,slot1,killedbool,disable1
    local l1
    local l2
	local l3
	local l4
local l5
    local lost1
local l
cmp y,176 ;check it it hits the ground
       jns l4
       
       cmp x,145 ;checks if it reaches the mid line
       jae l1
	jmp l 
   l1:  mov bx,0 ;if it reaches the mid line it checks if its infront of the slot
       mov bl,[slot1]
add bl,5
inc bx
       cmp bx,y
        jz l5 ;if it hit the edge of the slot it loses
        jmp l

l5: mov bx,0

   mov bl,[slot1] 
   add bl,5
   mov y,bx ;changes the y to the edge of the slot and lose
	jmp lost1		 
	 

l4: mov y,176
jmp lost1

lost1: mov killedbool,1
mov disable1,0
     
      
l:
endm CheckDo

CheckUPtwo macro x,y,slot1,killedbool2,disable2
    local l1
    local l2
	local l3
	local l4
local l5
    local lost1
local l
cmp y,9 ;check if it reaches the roof
       js l4
       
       cmp x,161 ;check if it reaches mid line
       jbe l1   ;if it reaches it or crosses it
	jmp l 
  l1:  mov bx,0 
       mov bl,[slot1]
dec bx
       cmp bx,y ;check if it's infront of the slot
        jz l5
        jmp l

l5: mov bx,0

   mov bl,[slot1] 
   mov y,bx ;set the y to edge of the slot and lose
	jmp lost1		 

l4: mov y,9
jmp lost1

lost1: mov killedbool2,1
mov disable2,0
      
      
l:
endm CheckUPtwo

CheckDotwo macro x,y,slot1,killedbool2,disable2
    local l1
    local l2
	local l3
	local l4
local l5
    local lost1
local l
cmp y,176 ;check if it hit the ground
       jns l4
       
       cmp x,161
       jbe l1
	jmp l 
   l1:  mov bx,0
       mov bl,[slot1]
add bl,5
inc bx
       cmp bx,y
        jz l5
        jmp l

l5: mov bx,0

   mov bl,[slot1] ;checks if it reaches the mid line and is infront of a slot
   add bl,5
   mov y,bx
	jmp lost1		 
	 

l4: mov y,176
jmp lost1

lost1: mov killedbool2,1
mov disable2,0
      
      
l:
endm CheckDotwo

checkright macro x,y,slot1,killedbool,disable1,won
local l,replacex,test1,test2,won1,lost1

cmp x,145    ;if x reaches to the right side
jns replaceX
jmp l
replaceX:  
          mov bx,0
          mov bl,slot1 
          cmp y,bx ; if y is greater than slot1
          jge test1
          
          mov x,145 ;if not then it hit a wall and loses
          
          
          jmp lost1 
test1:
          add bl,5
          cmp bx,y ;if the lower edge of the box is greate than the lower edge of the slot
          jge test2 
          mov x,145
          
          jmp lost1
          
test2:        
          cmp x,160 ;if the box reached the other side succsesfully it wins
          jge won1
          
         jmp l

won1: mov won,1
      mov killedbool,2
      
     jmp l
     
lost1: mov killedbool,1
mov disable1,0
      
      jmp l
l:

endm checkright 

checklefttwo macro x2,y2,slot2,killedbool2,disable2,won
local l,repx2,test1,test2,won2,lost2
cmp x2,161     ;if x reaches to the left side 
        js repX2
jmp l

repX2:    
          mov bx,0
          mov bl,slot2 
          cmp y2,bx ;if y is greater than the slot
          jge test1
          
          mov x2,161  ;if not then it hit an edge and it loses        
          jmp lost2 
test1:   
          
          add bl,5
          cmp bx,y2 ;if the lower edge of the box is greate than the lower edge of the slot
          jge test2
          mov x2,161
          
          jmp lost2
          
test2:   
          cmp x2,145 ;if the box reached the other side succesfully it wins
          jbe won2
         jmp l


won2: mov won,1
      mov killedbool2,2
      
     jmp l
     
lost2: mov killedbool2,1
mov disable2,0
      
      jmp l 

L:
endm checklefttwo

RoundFinished macro round,flag1,flag2
    local 1stWonRound
    local 2ndWonRound
    local drawRound
    local GameFinished
    local 1stWonGame
    local 2ndWonGame
    local drawGame
   
    
    cmp flag1,2           ;determine whether any player won orr draw
    jz 1stWonRound
    cmp flag2,2
    jz 2ndWonRound
    jmp drawRound
    
    
1stWonRound:inc score1         ;inc round and the score of the winner
            inc round
            cmp round,7
            jz GameFinished
            jmp r

2ndWonRound:inc score2
            inc round
            cmp round,7
            jz GameFinished
            jmp r

drawRound:  inc round
            cmp round,7
            jz GameFinished
            jmp r  
    
    
    
    
GameFinished:dec round           ;Game finished determine the winner
             mov al,score1
             cmp al,score2
             ja 1stWonGame
             jb 2ndWonGame
             jmp DrawGame
             
1stWonGame: ENDGame 1
2ndWonGame: ENDGame 2
DrawGame:   EndGame 3
    
    
ENDM RoundFinished

ENDGame macro Wonplayer
    local l2
    local c
    local one
    local two
    local draw
    mov cl,wonplayer
    WriteStatus            ;game is finished but draw the status line to show the final score
    mov ah,2
    mov dh,0
    cmp cl,1
    jz one
    cmp cl,2
    jz two
    jmp draw
one: mov dl,10             ;Write won at the right zone or draw
     jmp c
two: mov dl,23     
     jmp c
c:   int 10h   
     mov ah, 9
     mov dx, offset won
     int 21h
     jmp l2
draw:mov dl,10
     int 10h   
     mov ah, 9
     mov dx, offset dr
     int 21h
         
      
                            ;press enter to play again
    L2:mov ah,0
       int 16h


    cmp ah,1ch
    jz gamestart
    
    jmp l2 
    
ENDM EndGame

WriteStatus macro 
    mov ah,2
    mov dx,0
    int 10h
    
    mov ah, 9                  ;player1 name and his score
    mov dx, offset player1[2]
    int 21h
    
    mov ah,2
    mov dh,0
    mov dl,player1[1]
    int 10h 
    
    mov ah,2
    mov dl,':'
    int 21h
    mov dl,score1
    add dl,'0'
    int 21h
    
    mov ah,2
    mov dx,0018d
    int 10h 
                             ;Current Round No.
    mov ah, 9
    mov dx, offset middle
    int 21h
    
    mov ah,2
    mov dl,round
    add dl,'0'
    int 21h 
    
    mov ah,2
    mov dx,0032d
    int 10h
    
    mov ah, 9
    mov dx, offset player2[0] ;Player2 name and his score
    int 21h 
    mov ah,2
    mov dh,0
    mov dl,32
    add dl,5
    int 10h
    mov ah,2
    mov dl,':'
    int 21h
    mov dl,score2
    add dl,'0'
    int 21h 
ENDM WriteStatus

ReverseHamdy macro x,y,indx       ;if the player hit obstacle determine its type then:-
    local T                       ;lose if it's red or reflect red obstacle on the other zone
    local p2
    local p1
    local yy 
    mov terr,si
    mov cx,315
    sub cx,x   ;obstacle position
    cmp cx,160 ;check in which zone
    ja p2
    jb p1
   T:DrawObstacle cx,bx,0ch
    jmp yy
   p2:mov si,indx
      mov killerbooleanarr2[si],1 ; change status of obstacle
      jmp T   
   p1:mov si,indx
      mov killerbooleanarr1[si],1
      jmp T
yy:mov si,terr      
ENDM reversehamdy

Initialize macro arr          ;initialize the booleanarray with zeroes at the beginning of each round
    local a
    local f
    mov si,0
a:  mov arr[si],0
    inc si
    cmp si,24
    jnz a 
    jz f
f:    
ENDM Initialize 

initPort macro
    mov dx,3fbh 			; Line Control Register
    mov al,10000000b		;Set Divisor Latch Access Bit
    out dx,al				;Out it
    mov dx,3f8h			
    mov al,0ch			
    out dx,al
    mov dx,3f9h
    mov al,00h
    out dx,al
    mov dx,3fbh
    mov al,00011011b
    out dx,al
endm initPort 

send macro VALUE
    local AGAIN
    mov dx , 3FDH		; Line Status Register
    AGAIN:  	In al , dx 			;Read Line Status
      	AND al , 00100000b
      	JZ again           ;;;;;;;;;;;;;
    mov dx , 3F8H		; Transmit data register
  	mov  al,VALUE
  	out dx , al
                   ;;;;;;;;;;;;;;;;
endm send

receive macro
    local mend
    mov dx , 3FDH		; Line Status Register
	in al , dx 
    AND al , 1
  	JZ mend

 ;If Ready read the VALUE in Receive data register
  	mov dx , 03F8H 
  	in al , dx 
  	mov VALUE , al
  	mend:

; multi-segment executable file template.
endm receive

sendinvi macro 
local s,l,rec,l1,l2,l3
cmp value,-1
    jnz s
        mov ah,2
mov dx,1801h
int 10h ;change the cursor positon

l1:
mov ah, 9
mov dx, offset sent
int 21h ;show the first line
send 2 
mov host,1 


     
mov value,-1  
 s: 
sendname

endm sendinvi

sendchat macro 
local s,l,rec,l1,l2,l3
cmp value,-1
    jnz s
        mov ah,2
mov dx,1801h
int 10h ;change the cursor positon

l1:
mov ah, 9
mov dx, offset sentc
int 21h ;show the first line
send 1 
 
mov value,-1  
 s: 
sendname

endm sendchat


macro sendname 

local s,l,rec
 s: 

       mov si,0
    
l:      add si,2
        send player1+si 
        sub si,2
rec:    receive 
        cmp value,-1
        jz rec
    mov bl,value 
    mov  player2+si,bl 
    mov value,-1  
    inc si 
    mov cx,si
    cmp cl,11d
    jnz l    
    
    mov value,-1
endm sendname

macro levels

local l,l1,l2,l3,l4
cmp [host],1
jnz l

gamename mes ; show the name of the game  
     
    mov ah,2
mov dx,0b17h
int 10h ;change the cursor positon

mov ah, 9
mov dx, offset level1
int 21h ;show the first line

  mov ah,2
mov dx,0e17h
int 10h

mov ah, 9
mov dx, offset level2
int 21h 
         
          mov ch, 32
mov ah, 1
int 10h ;hide the cursor 

mov ah,2
mov dx,1715h
int 10h

mov ah, 9
mov dx, offset le
int 21h

l1: mov ah,0
int 16h

cmp ah,02
jz l2

cmp ah,03
jz l3

jmp l1

l2: mov [level],1
send level
jmp l4
l3: mov [level],2
send level
jmp l4

l: receive
cmp value,-1
jz l   
mov ah,value
mov [level],ah

l4:mov value,-1
endm levels

makedelay macro 
    mov bl,120
ha: mov cl,0ffh
eh: mov bh,0
    loop eh
    dec bl
    cmp bl,0
    jnz ha
endm makedelay
