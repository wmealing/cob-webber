 IDENTIFICATION DIVISION.
 PROGRAM-ID. HELLO_WORLD.
 
 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 SPECIAL-NAMES.
 
 INPUT-OUTPUT SECTION.
 FILE-CONTROL.
 
 DATA DIVISION.
 FILE SECTION.
 
 WORKING-STORAGE SECTION.
 01  RESPONSE.
   05  RESPONSE-IN-WS     PIC X(2).
 
 SCREEN SECTION.
 01 SIMPLE-QUESTION-SCREEN.
    05  VALUE "SIMPLE QUESTION SCREEN" BLANK SCREEN       LINE 1 COL 35.
    05  VALUE "ANSWER YES OR NO!  Y/N: "                  LINE 2 COL 1.
    05  RESPONSE-INPUT                                    LINE 2 COL 25
        PIC X TO RESPONSE-IN-WS.
 
PROCEDURE DIVISION.
           DISPLAY "HELLO WORLD FROM GNU-COBOL 3.1.2 - YEAH"
    STOP RUN.
