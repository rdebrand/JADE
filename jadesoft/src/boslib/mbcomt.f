C   14/10/82 606071855  MEMBER NAME  MBCOMT   (S4)          FORTRAN77
      SUBROUTINE MBCOMT
C
C              THE MINI-BOS PROGRAM MBOS
C              -------------------------
C
C     THE PURPOSE OF THE MBOS PROGRAM IS TO CREATE DYNAMICALLY
C     A STRUCTURE OF DATA BANKS WITHIN COMMON BLOCKS OR ARRAYS.
C
C     THE MINI-BOS PROGRAM MBOS ALLOWS CREATION OF BANKS AND OTHER
C     FUNCTIONS IN A WAY SIMILAR TO AND COMPATIBLE WITH THE BOS-
C     SYSTEM. IT IS HOWEVER ONE SMALL PROGRAM OF ABOUT
C     1000 WORDS. THE MBOS PROGRAM OFFERS THE POSSIBILITY OF
C     USING SEVERAL DYNAMIC STRUCTURES WITHIN COMMON BLOCKS
C     OR DIMENSIONED ARRAYS. WITHIN EACH STRUCTURE DATA BANKS CAN
C     BE CREATED, WITH BANKS OF THE SAME FORM AS IN THE BOS-SYSTEM,
C     ACCORDING TO THE FOLLOWING SCHEMA.
C
C     IW(IND-3)      NAME
C     IW(IND-2)      NUMBER
C     IW(IND-1)      INTERNALLY USED
C     IW(IND  )      NW = NUMBER OF WORDS IN THE BANK
C     IW(IND+1)      1. DATA WORD
C     IW(IND+2)      2. DATA WORD
C     . . .
C     IW(IND+NW)     LAST DATA WORD
C
C     IN CONTRAST TO BOS, IN THE MBOS PROGRAM EACH BANK HAS AN
C     ASSOCIATED POINTER WITHIN THE ARRAY. THE EXECUTION TIME
C     OF THE FUNCTIONS IS THEREFORE SHORTER, ON THE COST OF
C     FLEXIBILITY, ESPECIALLY IF BANKS ARE WRITTEN ON A DATA SET
C     AND LATER READ IN AGAIN. THERE IS HOWEVER THE POSSIBILITY
C     TO TRANSFER MBOS BANKS TO THE BOS SYSTEM.
C
C
C
C     IN EACH SUBPROGRAM REFERENCING BANKS OF THE STRUCTURE THE
C     USER HAS TO INSERT STATEMENTS INCLUDING A LIST OF POINTERS
C     IND1 . . . INDN OF THE FOLLOWING FORM
C
C     COMMON/ANYNAM/IW(1),IND1,IND2,. . .,INDN,IWRD(1)
C     REAL RW(NSPACE)
C     EQUIVALENCE (IW(1),RW(1))
C
C     WHERE NSPACE IS A INTEGER CONSTANT, DEFINING THE TOTAL
C     LENGTH OF THE STRUCTURE.
C
C
C     ALL ENTRIES HAVE A NAME OF FOUR CHARACTERS, STARTING WITH
C     THE CHARACTER M, AND HAVE THREE ARGUMENTS, THE FIRST ONE
C     BEING THE NAME OF THE ARRAY. IF ARGUMENTS ARE POINTERS,
C     THERE NAMES HAVE TO APPEAR IN THE LIST OF THE DECLARATION
C     STATEMENT (THEIR VALUES AND ADDRESSES ARE USED). OTHERWISE
C     THE PROGRAM STOPS IMMEDIATELY. THE USE OF E.G. IW(17) AS
C     A POINTER-ARGUMENT IS VALID.
C
C     THE MBOS SYSTEM CONSISTS OF THE SUBROUTINES MBOS AND MBPR (+UWP),
C     WHICH ARE ON THE DESY-NEWLIB-LIBRARIES
C        F1EBLO.BOSLIB.S (SOURCE)
C        F1EBLO.BOSLIB.L (LOAD)
C     THE FUNCTION JDSTL FROM DESYLIB IS USED IN ADDITION.
C
C
C     THE STORAGE LAYOUT IS ACCORDING TO THE FOLLOWING SCHEMA.
C
C     IW(1)           NSPACE = LENGHT OF THE ARRAY
C     -------------------------------------------------------------
C     IW(2) = IND1    POINTER TO (INDEX OF) BANK IDENTIFIED BY IND1
C     IW(3) = IND2    POINTER TO (INDEX OF) BANK IDENTIFIED BY IND2
C     ...
C     IW(I) = INDX    POINTER TO (INDEX OF) BANK IDENTIFIED BY INDX
C     ...
C     IW(K) = INDN    POINTER TO (INDEX OF) BANK IDENTIFIED BY INDN
C     -------------------------------------------------------------
C     IW( )           NAME                       FIRST BANK
C     IW( )           NUMBER
C     IW( )           (INDEX I OF POINTER)
C     IW( )           NW = NUMBER OF DATA WORDS IN THE BANK
C     IW( )           1. DATA WORD
C     IW( )           2. DATA WORD
C     ...
C     IW( )           LAST DATA WORD
C     -------------------------------------------------------------
C     IW( )           NAME                      SECOND BANK
C     IW( )           NUMBER
C     IW( )           (INDEX I OF POINTER)
C     IW( )           NW = NUMBER OF DATA WORDS IN THE BANK
C     IW( )           1. DATA WORD
C     IW( )           2. DATA WORD
C     ...
C     IW( )           LAST DATA WORD
C     -------------------------------------------------------------
C     ...
C     FREE SPACE
C     -------------------------------------------------------------
C     IW(IW(N-3))     INDEX OF POINTER TO LAST STORED BANK
C     ...             ...
C     IW(N-10)        INDEX OF POINTER TO SECOND STORED BANK
C     IW(N- 9)        INDEX OF POINTER TO FIRST STORED BANK
C     -------------------------------------------------------------
C     IW(N- 8)        (INTERNAL USE)
C     IW(N- 7)        (INTERNAL USE)
C     IW(N- 6)        NR OF PRINTOUTS ALLOWED
C     IW(N- 5)        (NAME OR INDEX LA)
C     IW(N- 4)        (NR   OR INDEX LB)
C     IW(N- 3)        POINTER TO POINTER LIST
C     IW(N- 2)        =1 IF BANKS DROPPED
C     IW(N- 1)        INDEX OF NEXT BANK IN UNUSED SPACE
C     IW(N   )        NR OF POINTERS ETC
C     -------------------------------------------------------------
C
C
C
C     1. INITIALISATION
C
C               -- ---- ------
C     CALL MBOS(IW,INDN,NSPACE)
C
C        WHERE  IW( )  = NAME OF THE ARRAY
C               INDN   = NAME OF LAST POINTER
C               NSPACE = LENGTH OF ARRAY IW( )
C
C
C     THIS PROGRAM HAS TO BE CALLED BEFORE ANY OTHER CALLS USING
C     THE ARRAY. ALL POINTERS ARE SET TO ZERO.
C     IF MBOS IS CALLED WITH NSPACE=0, ALL EXISTING BANKS ARE
C     DELETED.
C
C
C
C     2. CREATION OF BANKS
C
C               -- ---- --
C     CALL MCRE(IW,INDI,NW)
C                  ----
C
C        WHERE  IW( )  = NAME OF THE ARRAY
C               INDI   = INDEX OF THE BANK (ITS NAME MUST APPEAR
C                        IN THE LIST OF POINTERS)
C               NW     = NR OF WORDS OF THE BANK
C
C     THE DEFAULT NAME AND NR OF THE BANK ARE ('    ',0). THE USER
C     CAN DEFINE A NAME AND A NUMBER OF THE BANK BY A CALL
C
C               -- ---- --
C     CALL MNNR(IW,NAME,NR)
C
C     BEFORE CALLING MCRE.
C     THIS IS NECESSARY, IF BANKS ARE WRITTEN TO A DATA SET AND LATER
C     READ BY THE BOS-SYSTEM. IT IS RECOMMENDED IN ALL CASES TO
C     ALLOW EASY IDENTIFICATION OF PRINTOUT (SEE 5.).
C     THE BANK IS CREATED WITH ZEROS IN THE DATA PART OF THE BANK,
C     IF IT WAS NOT EXISTING AND IF THERE IS SUFFICIENT SPACE.
C     IF NECESSARY, A GARBAGE COLLECTION IS DONE AUTOMATICALLY.
C     IF THE BANK IS ALREADY EXISTING, THE LENGTH IS CHANGED TO
C     THE GIVEN VALUE NW, SHIFTING ALL OTHER BANKS BEHIND THE
C     BANK. ADDITIONAL WORDS ARE NOT FILLED WITH ZEROS.
C     THE BANKS ARE ALWAYS IN THE ORDER OF THE POINTERS.

C     THE NUMBER NFRE OF FREE WORDS FOR ONE NEW BANK CAN BE
C     OBTAINED BY THE CALL
C
C               -- --
C     CALL MCRE(IW,IW,NFRE)
C                     ----
C
C
C
C
C     3.   GARBAGE COLLECTION AND DROPPING OF BANKS
C
C     IF ALL THE BANKS ARE TO BE DELETED, THE SIMPLEST WAY IS
C     TO CALL THE INITIALIZATION PROGRAM MBOS (SEE UNDER 1.).
C     SPECIFIC BANKS CAN BE MARKED FOR DELETION (DROPPED) BY THE CALL
C               -- ---- ----
C     CALL MDRP(IW,INDI,INDJ)
C
C        WHERE  IW( )   = NAME OF THE ARRAY
C               INDI    = INDEX OF FIRST BANK TO BE DELETED
C               INDJ    = INDEX OF LAST BANK TO BE DELETED
C
C     THE DROPPED BANKS ARE STILL PRESENT, THEY ARE DELETED
C     DURING THE NEXT GARBAGE COLLECTION, WHICH IS EITHER DONE
C     AUTOMATICALLY, IF NECCESSARY DURING A CALL OF BCRE, OR BY
C     THE CALL
C               -- --
C     CALL MBOS(IW,IW,NFRE)
C                     ----
C        WHERE IW( )   = NAME OF THE ARRAY
C              NFRE    = NUMBER OF FREE WORDS
C
C
C
C     4.   INPUT/OUTPUT OF BANKS
C
C     BANKS CAN BE WRITTEN IN STANDARD BOS-FORMAT ON A DATASET AND
C     LATER READ INTO THE ARRAY AGAIN OR READ BY THE BOS-INPUT
C     ROUTINES. WRITING OF BANK-RECORDS IS PREPARED BY THE
C     FOLLOWING CALLS
C               -- ---- ----
C     CALL MMLT(IW,INDI,INDJ)
C
C               --
C     CALL MBWR(IW,NTOT,INDW)
C                  ---- ----
C     THE FIRST CALL DEFINES THE SET OF BANKS TO BE WRITTEN, IT IS
C     NOT NECCESARY, IF ALL BANKS ARE TO BE WRITTEN. BY THE SECOND
C     CALL THE TOTAL NUMBER OF WORDS NTOT AND THE INDEX OF THE FIRST
C     WORD OF THE FIRST BANK IS OBTAINED. A WRITE STATEMENT
C     WRITE( ) NTOT,(IW(INDW+I-1),I=1,NTOT)
C     CAN BE USED TO WRITE ONE RECORD.
C     THIS STANDARD BOS RECORD CAN BE READ BY THE BOS-INPUT ROUTINE,
C     IF EACH WRITTEN BANK HAS ASSOCIATED A NAME AND A NUMBER.
C     IT CAN ALSO BE READ FOR USE WITH THE MBOS PROGRAM IN AN ARRAY,
C     HOWEVER IF THERE ARE OTHER BANKS IN THE ARRAY, THEY ARE
C     OVERWRITTEN. THE ARRAY MUST HAVE AT LEAST AS MUCH POINTERS
C     AS WERE DURING THE WRITING. A READ STATEMENT
C     READ( ) NTOT,(IWRD(I),I=1,NTOT)
C     CAN BE USED TO READ ONE RECORD. THE POINTERS TO ALL BANKS
C     OF THE RECORD ARE DEFINED BY A CALL
C               -- ----
C     CALL MBRD(IW,NTOT,IER)
C                       ---
C        WHERE IW( )   = NAME OF THE ARRAY
C              NTOT    = NUMBER OF WORDS OF THE RECORD
C              IER     = ERROR MARKER ( =1, IF ERROR DETECTED)
C
C     IT IS NOT POSSIBLE TO READ STANDARD RECORDS WRITTEN BY THE
C     BOS-SYSTEM.
C
C
C     5.   PRINTOUT
C
C     THERE IS AN ADDITIONAL SUBROUTINE MBPR (+UWP), TO PRINT
C     THE TOTAL ARRAY OR SELECTED BANKS, WITH FORMAT SELECTION
C     FOR EACH WORD ACCORDING TO ITS CONTENT (INTEGER, REAL, CHARACTER).
C
C               -- ---- ----
C     CALL MBPR(IW,INDI,INDJ)
C        WHERE IW( )   = NAME OF THE ARRAY
C              INDI    = INDEX OF THE FIRST BANK
C              INDJ    = INDEX OF THE LAST BANK
C
C     THE BANKS TO POINTERS INDI TO INDJ ARE PRINTED. THE TOTAL ARRAY
C     IS PRINTED, IF THE FIRST AND LAST POINTER ARE GIVEN. THERE IS A
C     LIMIT (DEFAULT VALUE 10) OF THE TOTAL NUMBER OF PRINTOUTS.
C     THIS LIMIT CAN BE SET TO THE VALUE LIM BY THE CALL
C
C               -- -- ---
C     CALL MBPR(IW,IW,LIM)
C
C
      RETURN
      END