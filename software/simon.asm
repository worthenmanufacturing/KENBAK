;
; Simon game for the KENBAK-1
;

INIT
	JMK FAIL
	LOAD X,0376
	SUB X,#SEQUENCE
	SUB A,A

CLEAR_SEQUENCE
	STORE A,SEQUENCE+X
	STORE X,OUTPUT
	SUB X,1
	JMP X,GE,CLEAR_SEQUENCE

	LOAD  A,HIGH_SCORE
	STORE A,OUTPUT

	JMK WAIT_FOR_BUTTON

	; clear display
	LOAD A,0
	STORE A,OUTPUT
	LOAD X,0

MAIN

	JMK STORE_RAND_AND_INCREMENT

;
; display sequence
;
	LOAD X,0

DISPLAY_SEQUENCE

	JMK DELAY

	JMK READ_VALUE_AND_INCREMENT

	STORE B,TEMP_B
	JMK LIGHT_LAMP
	LOAD B,TEMP_B
	JMP B,EQ,ANSWER

	JMP DISPLAY_SEQUENCE
;
; read answer
;
ANSWER
	JMK DELAY
	LOAD X,0

READ_ANSWER

	SUB A,A
	STORE A,OUTPUT

	JMK WAIT_FOR_BUTTON

;
; light lamp
;
	STORE A,OUTPUT ; we also use this is our temp storage for A

	JMK BIT_TO_VALUE ; bit value return in B
	STORE B,TEMP_B
;
; check answer
;
	JMK READ_VALUE_AND_INCREMENT


; compare answer with expected
	SUB A,TEMP_B
	JMP A,NE,INIT

; success
	JMP B,EQ,NEXT_SEQUENCE

	JMP READ_ANSWER

NEXT_SEQUENCE 
	JMK SUCCESS
	JMP MAIN

; ///////////////////////////////////////////////
; Store random value in sequence
; increment octet
; increment X if necessary
; ///////////////////////////////////////////////
STORE_RAND_AND_INCREMENT db
	LOAD A,RAND
	AND A,007   ; use lowest octet of random value
	OR  A,0200   ; set high bit flag
	STORE A,SEQUENCE+X
	ADD X,1

	JMP (STORE_RAND_AND_INCREMENT)


; ///////////////////////////////////////////////
; read value in sequence and increment indices
;
; if last value in sequence:
;    B = 0
;    A = value
; otherwise:
;    B = 1
;    A = value
;    X is incremented if necessary
; ///////////////////////////////////////////////
READ_VALUE_AND_INCREMENT db

	LOAD A,SEQUENCE+X
	AND A, 007
	LOAD B,A ; save A
	ADD X,1
	LOAD A,SEQUENCE+X
	AND A,0200
	JMP A,NE,READ_VALUE_AND_INCREMENT_NOT_LAST
	LOAD A,B
	LOAD B,0
	JMP (READ_VALUE_AND_INCREMENT) ; return
READ_VALUE_AND_INCREMENT_NOT_LAST
	LOAD A,B
	LOAD B,1

	JMP (READ_VALUE_AND_INCREMENT)

; ///////////////////////////////////////////////
; light lamp number passed in A
; ///////////////////////////////////////////////
LIGHT_LAMP db

	JMK VALUE_TO_BIT

	STORE A,OUTPUT

	JMP (LIGHT_LAMP)

; ***************************************************************
; ***************************************************************
; there's a break in the middle here that we need to be careful about
; where the light outputs and the carry/overflow flags are for A B X
; ***************************************************************
; ***************************************************************

	org 0204

; ///////////////////////////////////////////////
; Returns A with the bit # requested that was pass
; in A. No masking is done, so the value needs to be
; between 0-7
; ///////////////////////////////////////////////
VALUE_TO_BIT db
	LOAD B,A
	LOAD A,1
VALUE_TO_BIT_LOOP
	SUB B,1
	JMP B,LT,(VALUE_TO_BIT)
	SFT A,L,1
	JMP VALUE_TO_BIT_LOOP

; ///////////////////////////////////////////////
; Returns a value in B for the bit passed in A.
; No checking is done to make sure only one bit is
; set.
; ///////////////////////////////////////////////
BIT_TO_VALUE db
	LOAD B,007
BIT_TO_VALUE_LOOP
	SFT A,L,1
	JMP A,EQ,(BIT_TO_VALUE)
	SUB B,1
	JMP BIT_TO_VALUE_LOOP

; ///////////////////////////////////////////////
; Delay for lights
; ///////////////////////////////////////////////
DELAY db
	STORE A,TEMP_A
	LOAD A,1
DELAY_OUTER_LOOP
	LOAD B,0377
DELAY_INNER_LOOP
	SUB B,1
	JMP B,GE,DELAY_INNER_LOOP
	SUB A,1
	JMP A,GE,DELAY_OUTER_LOOP
	LOAD A,TEMP_A
	JMP (DELAY)

; ///////////////////////////////////////////////
; wait for button press. This also increments
; the pseudorandom value.
; ///////////////////////////////////////////////
WAIT_FOR_BUTTON db
WAIT_FOR_BUTTON_LOOP
; increment random value
	LOAD A,RAND
	ADD  A,1
	STORE A,RAND

; check for key press
	LOAD A,INPUT
	JMP  A,EQ,WAIT_FOR_BUTTON_LOOP

; clear buttons
	LOAD B,0
	STORE B,INPUT


	JMP (WAIT_FOR_BUTTON)

; ///////////////////////////////////////////////
; Flashes the "success" sequence and updates the
; high score if necessary.
; ///////////////////////////////////////////////
SUCCESS db
	SUB A,A
	STORE A,OUTPUT
	LOAD A,1
SUCCESS_LEFT
	JMK DELAY
	STORE A,OUTPUT
	SFT A,L,1
	JMP A,NE,SUCCESS_LEFT
	STORE A,OUTPUT
	LOAD  A,HIGH_SCORE
	SUB   A,X
	JMP A,GE,NO_NEW_HIGH_SCORE
	LOAD A,X
	ADD A,1
	STORE A, HIGH_SCORE
NO_NEW_HIGH_SCORE
	JMP (SUCCESS)

; ///////////////////////////////////////////////
; Flashes the failure sequence
; ///////////////////////////////////////////////
FAIL db
	LOAD A, 0377
	STORE A,OUTPUT
	JMK DELAY
	SUB A,A
	STORE A,OUTPUT
	JMP (FAIL)

; variables
RAND db
HIGH_SCORE db
TEMP_A db
TEMP_B db

; The sequence to repeat is stored starting
; here
SEQUENCE db





