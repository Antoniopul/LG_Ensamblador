TITLE MULTIPLICACION MATRIZ CONSOLA                      ;SEGMENT-PSEUDO OPERADOR QUE NO GENERA CODIGO MAQUINA
DATOS SEGMENT PARA PUBLIC DATA                                                 ;PARA- PARAMETRO QUE INDICA QUE EL CODIGO INICIA EN LOS
                                                 ;LIMITES DE UN PARRAFO (DIRECCION DIVISIBLE POR 16 BITS)
                                                 ;PUBLIC- INDICA QUE TODOS LOS SEGMENTOS CON EL MISMO ATRIBUTO
                                                 ;SE ENCADENARAN JUNTOS
                                                 ;DATA- LOS SEGMENTOS CON EL MISMO NOMBRE DE CLASE 
                                                 ;EN MEMORIA SECUENCIALMENTE
;---------------------------------------------------------------------------------------------------------  
;*********************************************************************************************************
;---------------------------------------------------------------------------------------------------------
TAM  DW  ?          
MATRIZ_A    DB  16    DUP(?) ;MATRIZ A
MATRIZ_B    DB  16    DUP(?) ;MATRIZ B
MAT_RESULT  DB  16    DUP(?)            ;MATRIZ R RESULTANTE
MAT_INTMEDIA  DB  16    DUP(?)            ;MATRIZ PARA ALMACENAR LOSMPRODUCTOS
IndB    DW  ?                       ;INDICE DE LA MATRIZ B
IndR    DW  0                       ;INDICE DE LA MATRIZ RESILTANTE C
IND_FILA DW  ? 
TAM_MATRIZ_A DB  2     DUP(?) 
TAM_MATRIZ_B DB  2     DUP(?)
COUNT DB ? 

TEMP DW 0 
indMatInter DW 0
TempIndice DW 0

OtraVariable DW 0



                       ;INDICE PARA CUBRIR LOS 3 ELEMENTOS DE CADA FILA


;---------------------------------------------------------------------------------------------------------  
;*********************************************************************************************************
;---------------------------------------------------------------------------------------------------------
  include emu8086.inc
 
     
 
 
 
 
DATOS ENDS 
 
 
 
PILA SEGMENT PARA STACK 'STACK'
    DB 64 DUP('STACK')     
PILA ENDS        

CODIGO SEGMENT PARA PUBLIC 'CODE'
INICIO PROC FAR     
 ASSUME DS:DATOS, CS:CODIGO, SS:PILA

 PUSH DS
    MOV AX,0
    PUSH AX
    MOV AX, DATOS
    MOV DS, AX
    MOV ES, AX 
       
;---------------------------------------------------------------------------------------------------------  
;*********************************************************************************************************
;---------------------------------------------------------------------------------------------------------            
                MOV AX, 0
                
                
                GOTOXY 0,1
                CALL PTHIS                         
                DB 'Ingresa el tamano de la matriz A',0   
                CALL SCAN_NUM 
                MOV TAM_MATRIZ_A[0],CL
                GOTOXY 1,2
                CALL PTHIS                        
                DB 'Ingresa el tamano de la matriz A',0 
                CALL SCAN_NUM
                MOV TAM_MATRIZ_A[1],CL 
                
                ;multiplicacion para sacar cuantos valores tendra la matriz
                
                MOV AL,TAM_MATRIZ_A[0] 
                MOV BL,CL
                MUL BX  
                
                MOV TAM, AX
                LEA CX,AX  
                mov COUNT, 0  
                MOV SI,0 
DATOS_A:
                 ;contador para mover la insercion de los datos  
                MOV AL,COUNT
                ADD AL,1   
                MOV COUNT, AL
                
                
                MOV TAM, CX
                
                
                
                GOTOXY 1,6
                CALL PTHIS  
                DB 'INGRESA LOS NUMEROS, UNO POR UNO',0  
                GOTOXY COUNT,7
                CALL SCAN_NUM 
                MOV MATRIZ_A[SI],CL
                INC SI
                MOV CX,TAM
                 
                



LOOP DATOS_A   


CALL CLEAR_SCREEN                
   ;PEDIR NUMEROS PARA MATRIZ B             
     
        MOV AX, 0
                
                
                ;GOTOXY 0,1
                ;CALL PTHIS                         
                ;DB 'Dame tamano de la matriz B',0   
                ;CALL SCAN_NUM 
                MOV CL,TAM_MATRIZ_A[1]
                MOV TAM_MATRIZ_B[0],CL
                ;GOTOXY 1,2
                ;CALL PTHIS                        
                ;DB 'Dame tamano de la matriz B',0 
                ;CALL SCAN_NUM 
                MOV CL,TAM_MATRIZ_A[0]
                MOV TAM_MATRIZ_B[1],CL
                
                ;multiplicacion para sacar cuantos alores tendra la matriz
                
                MOV AL,TAM_MATRIZ_B[0]
                MOV BL,CL
                MUL BX  
                
                MOV TAM, AX
                LEA CX,AX  
                mov COUNT, 0  
                MOV SI,0 
DATOS_B:
                 ;contador para mover la insercion de los datos  
                MOV AL,COUNT
                ADD AL,1   
                MOV COUNT, AL
                
                
                mov TAM, CX
                
                
                
                GOTOXY 1,6
                CALL PTHIS  
                DB 'INGRESA LOS NUMEROS, UNO POR UNO',0  
                GOTOXY COUNT,7
                CALL SCAN_NUM 
                MOV MATRIZ_B[SI],CL
                INC SI
                MOV CX,TAM
                 
                



LOOP DATOS_B     

                  ;MOV AL,TAM_MATA[0]
                  ;MOV BL,TAM_MATA[1]
                  ;CMP AL,BL
                  ;JA SALIR:
                  MOV CL,TAM_MATRIZ_A[0]
                  MOV TEMP, CL
                  DEC TEMP
                  
                  
                  MOV SI,0          ;CARGAMOS 0 EN EL INDICE SI
                  mov OtraVariable,0  

WHILE:                                    
                  MOV indMatInter, 0
                  
                  MOV DI,0             ;CARGAMOS 0 EN EL INDICE DI 
                  MOV  AL,TAM_MATRIZ_B[0]
                  MOV IND_FILA,AX        ;CARGAMOS EL LIMITE DE OPERECIONES 
                  ;MOV IndR,0           ;CARGAMOS UN 0 EN IndR
                        
MULT1:
                  MOV IndB,DI           ;SE ALMACENO DI EN IndB
                                                          
                    

                     
                     
MULT2:
                 MOV   AL,MATRIZ_A[SI]    ;CARGAMOS EL PRIMER ELEMENTO DE A Y LO GUARDAMOS EN AL
                 MOV   BL,MATRIZ_B[DI]    ;CARGAMOS  EL PRIMER ELEMENTO DE B
                 MUL   BL             ;HACEMOS LA MULTIPLICACION
                 
                 MOV TempIndice,SI
                 MOV SI,indMatInter
                  
                 MOV   MAT_INTMEDIA[SI],AL  ;[SI] ;GUARDAMOS EL RFESULTADO EN LA MATRIZ INTERMEDIA 
                 
                 MOV SI,TempIndice
                 
                 MOV AX,0 
                 MOV   AL,TAM_MATRIZ_B[0]
                 
                 ADD   DI,AX          ;SUMADOS UN 3 A DI
                 
                 INC   indMatInter
                 INC   SI             ;INCREMENTAMOS SI
                 CMP   SI,TEMP           ;COMPARAMOS EL VALOR DE SI CON EL 2
                 JBE   MULT2          ;SI EL RESULTADO ES 2 VUELVE A HACER LA OPERACION
                
                
                 MOV   AL,MAT_INTMEDIA[0]   ;CARGAMOS EL PRIMER VALOR DE LA MATRIZ INTERMEDIA EN AL
                 ADD   AL,MAT_INTMEDIA[1]   ;SUMAMOS EL SEGUNDO VALOR DE LA MATRIZ INTERMEDIA
                 ADD   AL,MAT_INTMEDIA[2]   ;SUMAMOS EL TERCER VALOR DE LA MATRIZ INTERMEDIA
                
                 MOV   SI,IndR        ;CARGAMOS EN SI EL INDICE DE LA MATERIA RESULTANTE
                 MOV   MAT_RESULT[SI],AL    ;CARGAMOS EL AL EN LA POCISION SI DE LA MATRIZ MATR
                 INC   IndR           ;INCREMENTAMOS IndR
                           
                 MOV  indMatInter,0
                 MOV   SI,OtraVariable           ;CARGAMOS EN EL INDICE SI EL 0
                 MOV   DI,IndB        ;CARGAMOS IndB EN DI
                 INC   DI             ;INCREMENTAMOS DI
                 DEC   IND_FILA        ;DECREMENTAMOS Indfila
                 CMP   IND_FILA,0      ;COMPARAMOS SI Indfils ES IGUAL A 0
                 JA    MULT1 
                 ;Incrementarlo

                 
                 INC TEMP
                 MOV DL,TEMP
                 MOV SI,TEMP
                 MOV OtraVariable,DL
                 ADD DL,TAM_MATRIZ_A[0]
                 MOV TEMP, DL
                 
                 DEC TEMP
                 
                 CMP   IND_FILA,0 
                 JZ WHILE:                   
                 

 ;---------------------------------------------------------------------------------------------------------  
;*********************************************************************************************************
;---------------------------------------------------------------------------------------------------------            
                            
                 
                
                RET

INICIO ENDP 

DEFINE_SCAN_NUM
DEFINE_PRINT_STRING
DEFINE_PRINT_NUM 
DEFINE_PRINT_NUM_UNS
DEFINE_PTHIS
DEFINE_CLEAR_SCREEN 





CODIGO ENDS

END INICIO




