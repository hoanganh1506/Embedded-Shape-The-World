;****************** main.s ***************
; Program initially written by: Yerraballi and Valvano
; Author: Place your name here
; Date Created: 1/15/2018 
; Last Modified: 12/30/2022 
; Brief description of the program: Solution to Lab1
; The objective of this system is to implement a parity system
; Hardware connections: 
;  One output is positive logic, 1 turns on the LED, 0 turns off the LED
;  Three inputs are positive logic, meaning switch not pressed is 0, pressed is 1
GPIO_PORTD_DATA_R  EQU 0x400073FC
GPIO_PORTD_DIR_R   EQU 0x40007400
GPIO_PORTD_DEN_R   EQU 0x4000751C
GPIO_PORTE_DATA_R  EQU 0x400243FC
GPIO_PORTE_DIR_R   EQU 0x40024400 
GPIO_PORTE_DEN_R   EQU 0x4002451C
SYSCTL_RCGCGPIO_R  EQU 0x400FE608
       PRESERVE8 
       AREA   Data, ALIGN=2
; Declare global variables here if needed
; with the SPACE assembly directive
       ALIGN 4
       AREA    |.text|, CODE, READONLY, ALIGN=2
       THUMB
       EXPORT EID
EID    DCB "ahl995",0  ;replace ABC123 with your EID
       EXPORT RunGrader
	   ALIGN 4
RunGrader DCD 1 ; change to nonzero when ready for grading
           
      EXPORT  Lab1

Lab1	
 ; Khoi tao 
    LDR R0, =SYSCTL_RCGCGPIO_R   ; Nap dia chi tu bo nho vao thanh ghi R0
    MOV R1, #0x10                ; luu vao R1 gia tri la 0x10 la bat clock portE
    STR R1, [R0]                 ; luu gia tri tu R1 vao dia chi R0 tro toi

    LDR R0, =GPIO_PORTE_DIR_R    ; Nap dia chi thanh ghi huong i/o vao thanh ghi R0 
    MOV R1, #0x20                ; lua chon cac chan PE0,1,2 là input chân PE5 là output 
    STR R1, [R0]                 ; luu gia tri tu R1 vao dia chi R0 tro toi
	
	
    LDR R0, =GPIO_PORTE_DEN_R    ; Nap dia chi thanh ghi digital enable
	MOV R1, #0x27              	 ; lua chon cac chan PE 0,1,2,5 la cac chan truyen nhan du lieu (cap dien ap cho no hay chinh la dua 1 ra)
	STR R1, [R0]               	 ; luu gia tri tu R1 vao dia chi R0 tro toi

	LDR R0, =GPIO_PORTE_DATA_R   ; Nap dia chi GPIO_PORTE_DATA_R vao R0 de doc ghi du lieu port E
 
loop
   ;main program loop
    LDR R1, [R0]                   
    AND R1,R1,#0x01				  ;Dich phai 0 bit de ty nua xor key, giu lai bit thap nhat (PE0)
	
    LDR R2, [R0]
    AND R2,R2,#0x02               ;Giu lai bit thu 2 tu duoi len (PE1)
    LSR R2,R2,#0x01        		  ;Dich phai 1 bit de ty nua xor key
	
    LDR R3, [R0]
    AND R3,R3,#0x04               ;Giu lai bit thu 3 tu duoi len (PE2)
    LSR R3,R3,#0x02				  ;Dich phai 2 bit de ty nua xor key
		
   ;Thuc hien XOR
    EOR R4, R1, R2  			  ;R4 = R1 xor R2
    EOR R4, R4, R3  			  ;R4 = R4 xor R3 = R1 xor R2 xor R3

   ;Thuc hien luu vao PE5
    LSL R4,R4,#0x05				  ;Dich trai 5 bit de luu vao PE5	
    STR R4,[R0]                   ;Dua tro lai R0 (thanh ghi Data luc nay co gia tri PE5 la 1 thi led sang con 0 thi led tat)
	
    B    loop


    
    ALIGN        ; make sure the end of this section is aligned
    END          ; end of file
               