###########################################################################
### 1. [X] Imprimir os elementos est�ticos				###
### 2. [X] Movimentar o lolo com WASD					###
### 2.1 [X] tentar implementar movimenta��o em blocos <- OLHA AQUI 	###
### 3. [X] Travar a movimenta��o dentro do mapa				###
### 4. [X] Colis�es com objetos est�ticos				###
### 5. [] Menu inicial e tela de encerramento				###
### 5.1 [X] Menu inicial com 2 op��es					###
### 5.1.1 [X] Start							###
### 5.1.2 [] Password							###
### 5.2 [] Tela de encerramento						###
### 5.2.1 [] Passou de fase						###
### 5.2.2 [X] Zerou							###
### 5.2.3 [] Perdeu							###
### 6. [] Imprimir os elementos din�micos				###
### 7. [] Colis�es com objetos din�micos				###
### 8. [] Inimigos							###
### 9. [] Colis�es com ataques inimigos					###
### 10. [] Morte							###
###########################################################################
.data
.include "./common.asm"
.text
main:	
	start_menu()
#################################
#    	   START MENU		#
#################################
START_MENU:
	li t0, FRAME_0
	la s0, start_menu_1
	jal IMPRIME
	li t0, FRAME_1
	la s0, start_menu_2
	jal IMPRIME
	li s0, MMIO_set
	li a0, DOWN			# a0 = 'S'
	li a1, UP			# a1 = 'W'
	li a2, SELECT			# a2 = 'E'
SM_POLL_LOOP:				# LOOP de leitura e captura de tecla
#	li s0, MMIO_set
	lb t1,(s0)
	beqz t1,SM_POLL_LOOP		# Enquanto n�o houver nenhuma tecla apertada, retorna ao loop
	li s11,MMIO_add
	lw s11, (s11)			# Tecla capturada em S11
	
	beq s11, a2, SM_SELECTED
	beq s11, a1, SM_START
	beq s11, a0, SM_PASSWORD
	j SM_POLL_LOOP
SM_START:					
	li t2, FRAME_SELECT
	li t3, 0
	sb t3,(t2)
	j SM_POLL_LOOP
SM_PASSWORD:
	li t2, FRAME_SELECT
	li t3, 1
	sb t3,(t2)
	j SM_POLL_LOOP
SM_SELECTED:
	li t2, FRAME_SELECT
	lb t3, (t2)
	beqz t3, GAME
	j PASSWORD

#################################
#    	 BLACK SCREEN		#
#################################	
BLACK_SCREEN:
	li t1,0xFF000000	# endereco inicial da Memoria VGA - Frame 0
	li t2,0xFF012C00	# endereco final 
	beqz t3, BS_PULA
	li t1,0xFF100000	# endereco inicial da Memoria VGA - Frame 0
	li t2,0xFF112C00	# endereco final 
BS_PULA:
	li t3,0x00000000	# cor preto/preto/preto/preo
BS_LOOP:
 	beq t1,t2,BS_FORA	# Se for o �ltimo endere�o ent�o sai do loop
	sw t3,0(t1)		# escreve a word na mem�ria VGA
	addi t1,t1,4		# soma 4 ao endere�o
	j BS_LOOP		# volta a verificar
BS_FORA:
	ret
#################################
#    	   SOUNDTRACK		#
#################################	
SOUNDTRACK:
	la s0,GOLDEN_WIND_NUM		# define o endere�o do n�mero de notas
	lw s1,0(s0)		# le o numero de notas
	la s0,GOLDEN_WIND_NOTES		# define o endere�o das notas
	li t0,0			# zera o contador de notas
	li a2,7			# define o instrumento
	li a3,30		# define o volume

OST_LOOP:	
	beq t0,s1, OST_FIM		# contador chegou no final? ent�o  v� para FIM
	lw a0,0(s0)		# le o valor da nota
	lw a1,4(s0)		# le a duracao da nota
	li a7,31		# define a chamada de syscall
	ecall			# toca a nota
	mv a0,a1		# passa a dura��o da nota para a pausa
	li a7,32		# define a chamada de syscal 
	ecall			# realiza uma pausa de a0 ms
	addi s0,s0,8		# incrementa para o endere�o da pr�xima nota
	addi t0,t0,1		# incrementa o contador de notas
	j OST_LOOP			# volta ao loop
	
OST_FIM:
	ret
#################################
#    READ AND CHECK PASSWORD	#
#################################
PASSWORD:
	exit()
#################################
#    RESET WALKABLE BLOCKS	#
#################################
# Set all blocks as walkable	#
#################################	
RESET_WALKABLE_BLOCKS:
	la t1,WALKABLE_BLOCKS
	li t2,121
	li t3,0
RWB_LOOP:
	bge t3,t2,RWB_FORA
	li t4,0
	sb t4,(t1)
	addi t1,t1,1
	addi t3,t3,1
	j RWB_LOOP
RWB_FORA:
	ret
#################################
#     	   FRAME TEST		#
#################################
# Returns a1 as current frame	#
# address			#
#################################
FRAME_TEST:
	li a1,FRAME_0		
	LOADW( t0,CURRENT_FRAME )
	beqz t0, FT_PULA
	li a1,FRAME_1
FT_PULA:	
	ret
#################################
#    	OPEN OR CLOSE DOOR	#
#################################
DOOR_TEST:
	beqz t0, DT_OPEN
	la s1, porta_fechada
	ret
DT_OPEN:
	la s1, porta
	ret
#################################
#    	OPEN OR CLOSE DOOR	#
#################################
KEY_TEST:
	beqz t1, KT_OPEN_DOOR
	ret
KT_OPEN_DOOR:
	SAVEW(t1,DOOR_STATE)
	ret


.include "game.asm"
.include "walk.asm"
.include "render.asm"
