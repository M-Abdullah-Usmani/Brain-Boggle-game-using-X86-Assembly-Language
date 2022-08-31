INCLUDE Irvine32.inc
.data
Starting_time byte "The starting time is : ",0
Current_time byte  "The current  time is :",0
Finish_time byte   "The Ending   time is : ",0
level byte "LEVEL #",0
levelnumber dword 1
hours dword ?
minutes dword ?
founddd byte ?
seconds dword ?
str2 byte "found",0
total dword ?
Points dword 0h
PPoints byte "POINTS :",0
FinishTime Dword ?
limit dword 01517Fh
Enterword byte "Please enter a word that you beleive is present in the puzzle (Remember! It should be a legitemate word) :",0AH,0
Found byte	  "Good news! This word is indeed present in the puzzle :)",0AH,0
Notfound byte "Sorry! This word is not present in the puzzle :(       ",0AH,0
Timesup byte  "Uh oh! Looks like your time's up                       ",0AH,0AH,0AH,0
currenttime byte "00:00:00",0AH,0
timelimit byte "00:00:00",0AH,0

tempo dword 1 dup (?)
tempo1 dword 1 dup (?)
middlecoordinate dword 1 dup(?)


wlevel byte "level",1 dup(?),".txt",0
levelll byte "level.txt",0
matrix_char byte ?,0
actual dword ?,0
handlee handle ?,0
handleee handle ?,0
row1 byte 0
col1 byte 0
minimum byte ?,0
random_integer byte 3
stack_pointer_matrix_1 dword ?
stack_pointer_matrix_2 dword ?
temp1 byte ?
flag byte 0
stack_upwards dword ?

wordd Dword 50 dup(?)
len1 Dword ?
strl  Dword 50 dup(?)

dic byte 1 dup(?),".txt",0
temppp byte "temp.txt",0
message byte 1 dup (?)
mess byte 0Ah,0
level1 byte "1"
flaggg byte ?
titlee byte "-|BRAIN BOGGLE|-",0
startgameoption byte "Please press ENTER key to start the game",0AH,0
exitoption byte "Enter SPACE key to exit the game",0AH,0

.code

Search proto arr: ptr dword,tempp:ptr dword,arr2: ptr dword,len:dword,row:dword,col:dword,counter:dword,temprow:dword,endrow:dword,endcol:dword   ;Search(char **matrix,char **temp,char *string,int lengthofstring,int row,int col,int counter,int temprow)
printpuzzle proto Matrix:ptr dword,Row:dword,Column:dword

main PROC
Beginning:
mov ecx,7
l110:			;This loop is to print the title of the game along with the design
mov ebx,119
cmp ecx,4
JE printtitle
jmp else110
printtitle:
mov dl,50
mov dh,3
call gotoxy
mov edx,offset titlee
call writestring		;printing game title
jmp loop110
else110:
xchg ebx,ecx
l100:
mov eax,42
call writechar			;printing asterisks
loop l100
xchg ebx,ecx
loop110:
call crlf
loop l110
mov dl,40
mov dh,12
call gotoxy
mov edx,offset startgameoption		;printing start game option
call writestring
mov dl,40
mov dh,15
call gotoxy
mov edx,offset exitoption
call writestring					;printing exit game option
call crlf
l131:
mov dl,56
mov dh,18
call gotoxy
call readchar						;reading the option selected by the user
cmp al,13
JE levels						;start the game if user presses enter key
cmp al,10
JE levels						;start the game if user presses enter key
cmp al,32
JE exittt					;EXIT the game if user presses SPACE key
JMP l131

mov ecx,0
mov edx,0
mov ebx,0
levels:
 call clrscr
mov eax,3
call RandomRange
cmp eax,0
je levels

mov random_integer,al


mov Points,0
mov flaggg,0
invoke createfile,addr temppp,generic_read,do_not_share,NULL,create_always,file_attribute_normal,0
mov handlee,eax
invoke setfilepointer, handlee,0,0,file_current
invoke readfile,handlee,offset message,1,addr actual,0

mov eax,handlee
call closefile




invoke createfile,addr levelll,generic_read,do_not_share,NULL,open_existing,file_attribute_normal,0
mov handlee,eax
invoke setfilepointer, handlee,0,0,file_current
invoke readfile,handlee,offset message,1,addr actual,0


mov dl,message
mov wlevel[5],dl
mov level1,dl
mov eax,handlee
call closefile



invoke createfile,addr wlevel,generic_read,do_not_share,NULL,open_existing,file_attribute_normal,0 
mov handleee,eax
mov ecx,0
mov ebx,0
mov eax,0
mov edx,0
mov temp1,0
mov flag,0
call checking_file_empty
call clrscr
mov eax,handleee
call closefile
mov al,minimum


invoke createfile,addr levelll,generic_read,do_not_share,NULL,create_always,file_attribute_normal,0
mov handlee,eax
invoke setfilepointer, handlee,0,0,file_current
invoke readfile,handlee,offset message,1,addr actual,0

mov eax,handlee
call closefile


mov al,flaggg
cmp al,0

je L33



mov al,wlevel[5];
cmp al,"1"
je level22
cmp al,"2"
je level33
jmp exittt

level22:
mov cl,"2"

mov level1,cl
jmp l33

level33:
mov cl,"3"

mov level1,cl

l33:



	invoke createfile,addr levelll,generic_write,do_not_share,NULL,open_existing,file_attribute_normal,0


     mov handlee,eax
     mov ecx,0

     invoke setfilepointer, handlee,0,0,file_current
     invoke writefile,handlee,offset level1,1,addr actual,0

	 mov eax,handlee
call closefile

mov al,flaggg
cmp al,0
je beginning
jmp levels

exittt:

exit
main ENDP




checking_file_empty proc

mov ecx,0
finidng_random_matrix:
invoke setfilepointer, handlee,0,0,file_current
invoke readfile,handlee,offset matrix_char,1,addr actual,0
mov al,matrix_char
mov bl,'*'
cmp bl,al
jne finidng_random_matrix
inc temp1
mov bl,temp1
cmp bl,random_integer
je calling_fun
jmp finidng_random_matrix

calling_fun:
mov row1,0
mov col1,0
call pushing_matrix
ret
checking_file_empty endp


pushing_matrix PROC
    
	mov edx,0
	l1:    ;for pushing 2d matrix
	mov eax,0
	invoke setfilepointer, handlee,0,0,file_current
	invoke readfile,handlee,offset matrix_char,1,addr actual,0
	mov al,matrix_char
	mov cl,'1'
	mov bl,13
	cmp al,cl
	jae check_min

	if_not_number:
	cmp al,bl
	je enter_
	mov bl,10
	cmp al,bl
	je l1
	mov bl,' '
	cmp al,bl
	je l1
	push eax
	inc col1
	jmp l1

	enter_:
	mov bl,col1
	mov temp1,bl
	mov col1,0
	inc row1
	jmp l1

	check_min:
	mov cl,'9'
	cmp al,cl
	ja if_not_number
	sub al,48
	mov minimum,al

	

	inc col1

	matrix_pushed:
	dec temp1
	mov bl,temp1
	mov col1,bl
	mov al,col1
	mov bl,row1

	checking_flag:
	mov bl,1
	cmp flag,bl
	jne for_finding_esp

	for_finding_esp2:
	mov eax,0
	mov al,col1
	mul row1     
	mov bl,4
	mul  bl      ;each esp is of 4 bytes
	mov ebx,eax
	mov al,row1
	mov cl,4
	mul cl
	add ebx,eax
	sub ebx,4
	add esp,ebx
	mov al,row1
	mov cl,col1
	mov stack_pointer_matrix_2,esp
	add esp,4
	sub esp,ebx
	mov al,[esp]
	mov esi, offset stack_upwards
	mov [esi],ebx
	sub esp,4
	inc col1

	invoke printpuzzle,stack_pointer_matrix_1,row1,col1
	call maingame
	add esp,stack_upwards
	add esp,4
	
	ret
	jmp done

	for_finding_esp:

	mov eax,0
	mov al,col1
	mul row1     
	mov bl,4
	mul  bl      ;each esp is of 4 bytes
	mov ebx,eax
	mov al,row1
	mov cl,4
	mul cl
	add ebx,eax
	sub ebx,4
	add esp,ebx
	mov stack_pointer_matrix_1,esp
	sub esp,ebx

	invoke setfilepointer, handlee,0,0,file_begin
	mov temp1,0
	mov flag,1
	mov row1,0
	call checking_file_empty
	add esp,stack_upwards
	add esp,4
	done:
	ret
	pushing_matrix endp



maingame proc   uses eax ebx ecx edx edi esi    ;main screen	
mov dl,0
mov dh,7
call gotoxy
mov edx,offset PPoints	;Printing string "Points"
call writestring
call GetMseconds		;Getting number of milliseconds elapsed since midnight
mov edx,0
mov ebx,1000d
div ebx					;Converting those milliseconds into seconds
mov total,eax
mov dl,88
mov dh,7
call gotoxy
mov edx,offset Starting_Time	
call writestring		;Printing string "Starting time"
call printtime			;Printing Starting time
mov ebx,1d
imul ebx,120d			
add eax,ebx				;Adding additional number of seconds equal to the time provided to the player for that particular level
mov FinishTime,eax		
cmp eax,limit			;To see if the finish time has more seconds then the number of seconds present in a typical day 
JA great
JMP elfo
great:
sub  eax,limit			;Subtracting seconds of a day from the finish time seconds to get how many seconds of the new day will be used
mov FinishTime,eax
elfo:
print:
mov dh,8
mov dl,88
call gotoxy
mov edx,offset Finish_Time
call writestring		;Printing string "Finish time"
call printtime			;Printing Finish time


Mov dl,88
Mov dh,9
Call GotoXY
mov edx,offset Current_Time
call writestring						;Printing String current time
mov dl,0
mov dh,byte ptr[ row1]
add dh,11
call gotoxy
mov edx,offset Enterword
call writestring						;Printing String "Enter a word"


startit:								;Main loop for Game
mov dl,lengthof PPoints
mov dh,7
call gotoxy
mov eax,Points
call writedec							;Printing Points earned uptill now
sub esp,4
mov edi,esp								;Saving the address of first letter of the word searched
add esp,4
mov ecx,0
l1:
Mov dl,88
add dl,lengthof Current_Time
Mov dh,9
Call GotoXY
push ecx							;We have to push because we are also using ecx to save length of the word being entered
mov ecx,0FFFFFFFh					;Producing delay
l2:
loop l2
pop ecx
mov eax,0
call GetMseconds					;Getting number of milliseconds that have elapsed since midnight
mov edx,0
mov ebx,1000d
div ebx								;To convert those milliseconds into seconds
call printtime						;Printing Current time

mov eax,total
cmp eax,FinishTime					;To see if current time is equal to or has passed Finish time that was decided
JAE exitt							;Jump to exit if current time has indeed passed finish time or is equal to it
mov dl,0
add dl,cl
mov dh,byte ptr row1
add dh,12
call gotoxy							;Going back down to continue taking input
mov eax,0
call readkey						;Reading a character
JZ l1
	cmp al,13
	JE goforsearch					;if character is equal to enter key, then go to search function to see if entered string is present in the matrix or not
	cmp al,8						
	JE looop						; if character is equal to backspace key then jump to looop label
	sub esp,4			
	mov ah,0
	mov ebp,esp
	inc ecx
	mov [ebp],eax
	jmp loopp
	looop:						;if user pressed backspace key
	cmp ecx,0					;to see if the user has even entered a key
	JE loopp					;if user hasn't entered any key yet
	dec ecx						;else decrement length of string
	add esp,4					;to overwrite the character that was entered before backspace
	mov ebp,esp
	loopp:
	call writechar
	mov eax,0
	call writechar
	jmp l1


	goforsearch:				;If user has entered "ENTER" key
	call crlf
	mov tempo1,ecx				; to save the length of string(word) entered
	mov eax,0
	mov edx,0

	mov founddd,0

	mov esi,edi
	mov eax,tempo1
	cmp eax,0
	je l88

	l99:
	mov eax,[esi]
	mov wordd[edx],eax
	mov eax,tempo1
    inc edx
	sub esi,4
	cmp edx,eax
	jne l99

	
	l88:
	mov edx,0
	mov eax,0
	mov edx,wordd[0]
    mov dic,dl

   mov eax,tempo1
    mov len1,eax
    push eax 
    push 0     
    push 0   
    push 0   

    call searchh
	pop eax
	pop eax
	pop eax
	pop eax
	
    mov eax,handlee
    call closefile

    mov al,founddd
	cmp al,1
	jne l77
	
    mov eax,len1


    push eax 
    push 0     
    push 0   
    push 0   
	mov founddd,1
    call tempp

	pop eax
	pop eax
	pop eax
	pop eax
    mov eax,handlee
    call closefile

	mov al,founddd
	cmp al,1
	jne l77

	mov eax,0
	mov edx,0
	
	invoke Search,stack_pointer_matrix_1,stack_pointer_matrix_2,addr [edi],tempo1,0,0,0,0,row1,col1		;This function will see if the entered string is present in the matrix
	call crlf
	cmp edx,1					;edx is working as a  flag
	JE foundd					;if flag==1 then go to foundd label
	l77:
	mov edx,offset Notfound	    ;else print not found message
	call writestring
	JMP nextt					;jmp to nexxt to search for the next word if time permits
	foundd:						;if word was found in the matrix


	invoke createfile,addr temppp,generic_write,do_not_share,NULL,open_existing,file_attribute_normal,0


     mov handlee,eax
     mov ecx,0

     invoke setfilepointer, handlee,0,0,file_end
     invoke writefile,handlee,offset wordd,len1,addr actual,0
	 

    invoke setfilepointer, handlee,0,0,file_end
    invoke writefile,handlee,addr mess,1,addr actual,0

	mov eax,handlee
    call closefile
	inc Points					;increment the points
	mov edx,offset Found        ;print found message
	call writestring
	nextt:						;preparation for the next word search
	
	mov ecx,tempo1
	imul ecx,4
	add esp,ecx					;removing the word from string
	Jmp startit					;going back to searching a new word
exitt:							;if time is over
mov dl,0
mov dh,byte ptr row1
add dh,14
call gotoxy
mov edx,offset timesup
call writestring				;print timesup message
imul ecx,4
add esp,ecx					;removing the word from string
mov eax,Points
movzx edx,minimum

cmp eax,edx
jb s
mov flaggg,1
s:
ret
maingame endp


printpuzzle proc uses ecx edx eax ebx edi Matrix:ptr dword,Row:dword,Column:dword
mov ecx,7
l110:
mov ebx,119
cmp ecx,4
JE printlevel
jmp else110
printlevel:
mov dl,52
mov dh,3
call gotoxy
mov edx,offset level
call writestring
mov al,level1
sub al,48
call writedec			;printing level number
jmp loop110
else110:
xchg ebx,ecx
l100:
mov eax,42
call writechar
loop l100
xchg ebx,ecx
loop110:
call crlf
loop l110

mov edx,0
mov edi,Matrix						;to print the matrix in the middle
mov eax,column
mov ebx,2
mul ebx
mov middlecoordinate,eax

mov ecx,row
add ecx,2
mov eax,0
mov ebx,7
l112:
mov dl,59
sub dl,byte ptr middlecoordinate
mov dh,bl
call gotoxy
inc ebx
mov edx,Column
xchg edx,ecx
mov eax,124
call writechar
mov eax,32
call writechar
l113:
mov eax,row
add eax,2
cmp edx,eax
JE elsoto
cmp edx,1
JE elsoto
mov eax,[edi]
sub edi,4
JMP loopi
elsoto:
mov eax,0
mov eax,45
loopi:
call writechar			;printing matrix
mov eax,32
call writechar
call writechar
loop l113
mov eax,124
call writechar
xchg edx,ecx
loop l112

ret 12
printpuzzle endp


printtime proc uses eax ecx 
mov total,eax		;Total number of seconds elapsed since midnight
mov ebx,3600d
mov edx,0
div ebx				;Dividing seconds by 3600 to get number of hours
mov edx,0
call writedec		;Printing Number of hours
push eax
mov al,':'
call writechar
pop eax
mov hours,eax
imul eax,ebx		;Multiplying hours by 3600 to get the exact number of seconds present in that exact amount of hours
mov edx,0
mov ecx,total
sub ecx,eax			;Subtracting the exact number of seconds by the seconds(that have passed since midnight)
mov eax,ecx
mov ebx,60d
div ebx				;Dividing the subtracted seconds by 60 to get the minutes
call writedec		;printing number of minutes
push eax
mov al,':'
call writechar
pop eax
mov minutes,eax
mov eax,hours		;accessing the hours that we calculated earlier
mov ebx,60d
imul eax,ebx		;multiplying the calculated hours by 60 to get number of minutes
add eax,minutes		;adding the above calculated number of minutes with the number of minutes that we calculated a couple steps earlier
imul eax,ebx		;multiplying the minutes with 60 to get the exact number of seconds present in that exact amount of minutes
mov ecx,total
sub ecx,eax			;subtracting the above calculated seconds from the number of seconds that have elapsed since midnight
mov eax,ecx
call writedec		;printing the number of seconds
mov eax,32
call writechar
ret 
printtime endp





Search proc uses ecx arr: ptr dword,tempp:ptr dword,arr2: ptr dword,len:dword,row:dword,col:dword,counter:dword,temprow:dword,endrow:dword,endcol:dword   	;printt(char **matrix,char **tempmatrix,char *string,int lengthofstring,int row,int col,int counter,int temprow
	mov esi,tempp			
	mov edi,arr2
	cmp temprow,-1				
	JE returnfalse				;if (row<0) {return false}
	mov eax,endrow
	cmp temprow,eax				
	JE returnfalse				;if (row>2) {return false}
	mov eax,endcol
	cmp col,eax					
	JE returnfalse				;if (col>4) {return false}
	cmp col,-1					
	JE returnfalse				;if (col<0) {return false}
	JMP and1					;else
	returnfalse:
	mov edx,2
	ret 40
	and1:						;if (row!<0 && row!>2 && col!>4 && col!<0)
	mov tempo,edi				
	mov eax,counter
	mov ecx,3
	quickk:
	add eax,counter
	loop quickk
	sub tempo,eax
	xchg tempo,eax
	mov eax,[eax]
	xchg tempo,eax				;tempo=arr2[counter]
	mov eax,row
	add eax,col
	mov ebx,[esi+eax*4]
	cmp ebx,tempo
	JE else0					;JUMP if (temp[row][col]==arr2[counter])
	JMP else1					;else
	
	else0:						;if (temp[row][col]==arr2[counter])
	mov eax,len
	dec eax
	cmp eax,counter
	JE lfound					;JUMP if (temp[row][col]==arr2[counter] && counter==len-1) 
	JMP else2					;JUMP if (temp[row][col]==arr2[counter] && counter!=len-1)
	lfound:						;IF THE SEARCHED WORD IS FOUND IN THE PUZZLE
	mov edx,1					;flag=1
	ret 40						;return
	else1:						;if (temp[row][col]!=arr[counter]){
	mov eax,ebx
	cmp counter,0
	JE counterzero				;JUMP if (temp[row][col]!=arr2[counter] && counter==0)
    JMP returnfalse				;else if (temp[row][col]!=arr2[counter] && counter!=0){return false}
	llfound:
	mov eax,row
	add eax,col
	mov edi,arr
	mov ebx,[edi+eax*4]     
	mov [esi+eax*4],ebx			;temp[row][col]=arr[row][col]
	JMP lfound
	else2:						; if (temp[row][col]==arr2[counter]{
	mov eax,row
	add eax,col
	mov ebx,1
	mov [esi+eax*4],ebx			; temp[row][col]=1; (to eliminate any chance of repetition)
	add counter,1
	add col,1
	invoke Search, arr,tempp,arr2,len,row,col,counter,temprow,endrow,endcol		;col+1  //Search(arr,tempp,len,row,col+1,counter+1,temprow)
	sub col,1
	sub counter,1
	cmp edx,1					;checking if (flag==1)
	JE llfound					; if (flag==1) { return true}
	add counter,1
	mov eax,endcol
	add row,eax
	add temprow,1
	invoke Search, arr,tempp,arr2,len,row,col,counter,temprow,endrow,endcol		;row+1	//Search(arr,tempp,len,row+1,col,counter+1,temprow+1)
	mov eax,endcol
	sub row,eax
	sub temprow,1
	sub counter,1
	cmp edx,1					;checking if (flag==1)
	JE llfound					; if (flag==1) { return true}
	sub col,1
	add counter,1
	invoke Search, arr,tempp,arr2,len,row,col,counter,temprow,endrow,endcol		;col-1  //Search(arr,tempp,len,row,col-1,counter+1,temprow)
	add col,1
	sub counter,1
	cmp edx,1					;checking if (flag==1)
	JE llfound					; if (flag==1) { return true}
	add counter,1
	mov eax,endcol
	sub row,eax
	sub temprow,1
	invoke Search, arr,tempp,arr2,len,row,col,counter,temprow,endrow,endcol		;row-1  //Search(arr,tempp,len,row-1,col,counter+1,temprow-1)
	mov eax,endcol
	add row,eax
	add temprow,1
	sub counter,1
	cmp edx,1					;checking if (flag==1)
	JE	llfound					; if (flag==1) { return true}
	add counter,1
	mov eax,endcol
	add row,eax
	add col,1
	add temprow,1
	invoke Search, arr,tempp,arr2,len,row,col,counter,temprow,endrow,endcol		;row+1,col+1  //Search(arr,tempp,len,row+1,col+1,counter+1,temprow+1)
	mov eax,endcol
	sub row,eax
	sub col,1
	sub temprow,1
	sub counter,1
	cmp edx,1					;checking if (flag==1)
	JE	llfound					; if (flag==1) { return true}
	add counter,1
	mov eax,endcol
	sub row,eax
	sub col,1
	sub temprow,1
	invoke Search, arr,tempp,arr2,len,row,col,counter,temprow,endrow,endcol		;row-1,col-1  //Search(arr,tempp,len,row,col-1,counter+1,temprow-1)
	mov eax,endcol
	add row,eax
	add col,1
	add temprow,1
	sub counter,1
	cmp edx,1					;checking if (flag==1)
	JE	llfound					; if (flag==1) { return true
	add counter,1
	mov eax,endcol
	add row,eax
	sub col,1
	add temprow,1
	invoke Search, arr,tempp,arr2,len,row,col,counter,temprow,endrow,endcol		;row+1,col-1  //Search(arr,tempp,len,row+1,col-1,counter+1,temprow+1)
	mov eax,endcol
	sub row,eax
	add col,1
	sub temprow,1
	sub counter,1
	cmp edx,1					;checking if (flag==1)
	JE  llfound					; if (flag==1) { return true}
	add counter,1
	mov eax,endcol
	sub row,eax
	add col,1
	sub temprow,1
	invoke Search, arr,tempp,arr2,len,row,col,counter,temprow,endrow,endcol		;row-1,col+1  //Search(arr,tempp,len,row-1,col+1,counter+1,temprow-1)
	mov eax,endcol
	add row,eax
	sub col,1
	add temprow,1
	sub counter,1
	cmp edx,1					;checking if (flag==1) 
	JE  llfound					;if (flag==1) {return true}
	mov eax,row
	add eax,col
	mov edi,arr
	mov ebx,[edi+eax*4]     
	mov [esi+eax*4],ebx			;temp[row][col]=arr[row][col]
	checkingcounter:
	cmp counter,0		
	JE counterzero				
	JMP returnfalse				;if (counter!=0) return false
	counterzero:				;if (counter==0){
	mov eax,endcol
	dec eax
	cmp col,eax 				;check if if(col==4)
	JE lastcol					
	add col,1					;else {col+1}
	invoke Search, arr,tempp,arr2,len,row,col,0,temprow,endrow,endcol		;Search(arr,tempp,len,row,col+1,counter=0,temprow)
	sub col,1
	cmp edx,1					;if (flag==1){
	JE returnn					;return true}
	JMP returnfalse				;else {return false}
	lastcol:					;if(col==4){
	mov eax,endcol
	add row,eax					;row+1
	add temprow,1				;rownumber+1
	invoke Search, arr,tempp,arr2,len,row,0,0,temprow,endrow,endcol		;Search(arr,tempp,len,row+1,col=0,counter=0,temprow+1)
	sub temprow,1				
	mov eax,endcol
	sub row,eax
	cmp edx,1					; checking if(flag==1)
	JE returnn					;if (flag==1) { return true}
	JMP returnfalse				; else {return false}
	returnn:
	ret 40
	Search endp

	searchh proc
push ebp
mov ebp,esp

invoke createfile,addr dic,generic_read,do_not_share,NULL,open_existing,file_attribute_normal,0
mov handlee,eax
mov ecx,0
l1:
invoke setfilepointer, handlee,0,0,file_current
invoke readfile,handlee,offset message,1,addr actual,0


mov al,message


cmp al,10
jne p1

mov edx,0
mov ecx,[ebp+12]
mov edx,[ebp+8]
mov ebx,[ebp+16]
cmp ecx,ebx
jne l11
mov ebx,[ebp+20]
cmp ebx,ecx
jne l11
jmp ex1

l11:

mov ebx,0
mov [ebp+16],ebx
mov ecx,0
mov [ebp+12],ecx
inc edx
mov [ebp+8],edx
cmp edx,2
je exitt
jmp l4

p1:
mov edx,0
mov [ebp+8],edx
l4:
cmp al,13
je l5
cmp al,10
je l5
mov edx,[ebp+12]
inc edx
mov [ebp+12],edx
l5:


mov edx,[ebp+16]
mov ebx,wordd[edx]
cmp al,bl
jne l9
inc edx
mov [ebp+16],edx

l9:
jmp l1

ex1:


mov founddd,1



exitt:

leave
ret 
searchh endp


tempp proc
push ebp
mov ebp,esp

invoke createfile,addr temppp,generic_read,do_not_share,NULL,open_existing,file_attribute_normal,0
mov handlee,eax
mov ecx,0
l11:
invoke setfilepointer, handlee,0,0,file_current
invoke readfile,handlee,offset message,1,addr actual,0


mov al,message
call writechar



cmp al,10
jne p11

mov edx,0
mov ecx,[ebp+12]
mov edx,[ebp+8]
mov ebx,[ebp+16]
cmp ecx,ebx
jne l111
mov ebx,[ebp+20]
cmp ebx,ecx
jne l111
jmp ex11

l111:

mov ebx,0
mov [ebp+16],ebx
mov ecx,0
mov [ebp+12],ecx
inc edx
mov [ebp+8],edx
cmp edx,2
je exitt1
jmp l41

p11:
mov edx,0
mov [ebp+8],edx
l41:
cmp al,13
je l51
cmp al,10
je l51
mov edx,[ebp+12]
inc edx
mov [ebp+12],edx
l51:


mov edx,[ebp+16]
mov ebx,wordd[edx]
cmp al,bl
jne l91
inc edx
mov [ebp+16],edx

l91:
jmp l11

ex11:
mov founddd,0
exitt1:
leave
ret 
tempp endp

end main

