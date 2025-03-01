.data
CURRENT_ENEMY_POSX:	.word 0
ENEMY_POSX:		.word 0,0,0,0,0,0

CURRENT_ENEMY_POSY:	.word 0
ENEMY_POSY:		.word 0,0,0,0,0,0

CURRENT_ENEMY_SPEED:	.word 0
ENEMY_SPEED:		.word 0,0,0,0,0,0

CURRENT_ENEMY_I_BLOCK:	.word 0
ENEMY_INITIAL_BLOCK:	.word 0,0,0,0,0,0

CURRENT_ENEMY_F_BLOCK:	.word 0
ENEMY_FINAL_BLOCK:	.word 0,0,0,0,0,0

SHOT_POSX:		.word 0
SHOT_INITIAL_POSX:	.word 0
SHOT_POSY:		.word 0
SHOT_SPEED:		.word 0 
SHOT_FINAL_BLOCK:	.word 0
SHOOTING_ENEMY:		.word 1		# 0 = not shooting, 1 = shooting

NUMBER_OF_ENEMIES:	.word 0
TOGGLE_RNG:		.word 0
.text
ENEMY_WALK:
#	render_sprite(tijolo,CURRENT_ENEMY_POSX,CURRENT_ENEMY_POSY)
#	switch_frame()
#	render_sprite(tijolo,CURRENT_ENEMY_POSX,CURRENT_ENEMY_POSY)
#	switch_frame() 			# Apaga o bloco atual
	render_abs_sprite(tijolo,CURRENT_ENEMY_POSX,CURRENT_ENEMY_POSY)
	loadw(a1,CURRENT_ENEMY_POSX)	
	loadw(a2,CURRENT_ENEMY_POSY)
	loadw(a3,CURRENT_ENEMY_SPEED)
	add a1,a1,a3			
	calculate_block(a1,a2)		# Calcula a proxima posi��o do inimigo
	loadw(t2,CURRENT_ENEMY_F_BLOCK)
	bne t1,t2,EW_KEEP		# Se ela for a posi��o final
		li t2,-16			
		savew(t2,CURRENT_ENEMY_SPEED)	# Velocidade recebe a dire��o oposta
		j EW_WALK
	EW_KEEP:
	loadw(t2,CURRENT_ENEMY_I_BLOCK)	# Se ela for a posi��o inicial
	bne t1,t2,EW_WALK
		li t2,16
		savew(t2,CURRENT_ENEMY_SPEED)	# Velocidade recebe a dire��o oposta
	EW_WALK:
	loadw(a1,CURRENT_ENEMY_POSX)
	loadw(a2,CURRENT_ENEMY_POSY)
	loadw(a3,CURRENT_ENEMY_SPEED)
	add a1,a1,a3
	savew(a1,CURRENT_ENEMY_POSX)
	call COLISION_TEST		# Testa colis�o com Lolo
	CT_RETURN:
#	render_sprite(enemy,CURRENT_ENEMY_POSX,CURRENT_ENEMY_POSY)
#	switch_frame()
#	render_sprite(enemy,CURRENT_ENEMY_POSX,CURRENT_ENEMY_POSY)
#	switch_frame()			# Renderiza o inimigo na pr�xima posi��o
	loadw(a3,CURRENT_ENEMY_SPEED)
	bgez a3,EW_RIGHT
		render_abs_sprite(enemy_left,CURRENT_ENEMY_POSX,CURRENT_ENEMY_POSY)
		j EW_LEFT
	EW_RIGHT:
		render_abs_sprite(enemy_right,CURRENT_ENEMY_POSX,CURRENT_ENEMY_POSY)
	EW_LEFT:
	j POLL_LOOP
	
#######################################################################
# Neste loop 6 inimigos s�o renderizados utilizando as informa��es de #
# cada um armazenadas em um vetor				      # 
#######################################################################
ENEMIES_WALK:
	la s3,ENEMY_POSX
	la s4,ENEMY_POSY
	la s5,ENEMY_SPEED
	la s6,ENEMY_INITIAL_BLOCK
	la s7,ENEMY_FINAL_BLOCK
	li s8,0
	loadw(s9,NUMBER_OF_ENEMIES)
	EWS_LOOP:
	beq s8,s9,EWS_DONE	# inicio loop
		lw t3,(s3)
		savew(t3,CURRENT_ENEMY_POSX)	
		lw t3,(s4)
		savew(t3,CURRENT_ENEMY_POSY)
		lw t3,(s5)
		savew(t3,CURRENT_ENEMY_SPEED)
		lw t3,(s6)
		savew(t3,CURRENT_ENEMY_I_BLOCK)
		lw t3,(s7)
		savew(t3,CURRENT_ENEMY_F_BLOCK)
		#
#		render_sprite(tijolo,CURRENT_ENEMY_POSX,CURRENT_ENEMY_POSY)
#		switch_frame()
#		render_sprite(tijolo,CURRENT_ENEMY_POSX,CURRENT_ENEMY_POSY)
#		switch_frame()
		render_abs_sprite(tijolo,CURRENT_ENEMY_POSX,CURRENT_ENEMY_POSY)
		loadw(a1,CURRENT_ENEMY_POSX)
		loadw(a2,CURRENT_ENEMY_POSY)
		loadw(a3,CURRENT_ENEMY_SPEED)
		add a1,a1,a3
		calculate_block(a1,a2)
		loadw(t2,TOGGLE_RNG)
		beqz t2, EWS_RNG
			li a7,41
			ecall			# a0 = numero aleatorio
			li t4,13
			rem t4,a0,t4		# t4 = resto entre a0 e 13
			bnez t4,EWS_RNG	
				li t4,-1
				mul a3,a3,t4	# Se o resto for igual a 0, o inimigo come�a a ir para a dire��o oposta
				savew(a3,CURRENT_ENEMY_SPEED)
				sw a3,(s5)
		EWS_RNG:
 		#	
 		la t2,PUSHABLE_BLOCKS
 		add t2,t2,t1
 		lb t2,(t2)
 		beqz t2,EWS_JUMP
 			loadw(a1,CURRENT_ENEMY_SPEED)
 			sub a1,zero,a1
 			savew(a1,CURRENT_ENEMY_SPEED)
 			sw a1,(s5)
 		EWS_JUMP:
		loadw(t2,CURRENT_ENEMY_F_BLOCK)
		bne t1,t2,EWS_KEEP
			li t2,-16
			savew(t2,CURRENT_ENEMY_SPEED)
			sw t2,(s5)
			j EWS_WALK
		EWS_KEEP:
		loadw(t2,CURRENT_ENEMY_I_BLOCK)
		bne t1,t2,EWS_WALK
			li t2,16
			savew(t2,CURRENT_ENEMY_SPEED)
			sw t2,(s5)
		EWS_WALK:
		loadw(a1,CURRENT_ENEMY_POSX)
		loadw(a2,CURRENT_ENEMY_POSY)
		loadw(a3,CURRENT_ENEMY_SPEED)
		add a1,a1,a3
		savew(a1,CURRENT_ENEMY_POSX)
		sw a1,(s3)
		call COLISION_TEST
		#render_sprite(enemy,CURRENT_ENEMY_POSX,CURRENT_ENEMY_POSY)
		#switch_frame()
		#render_sprite(enemy,CURRENT_ENEMY_POSX,CURRENT_ENEMY_POSY)
		#switch_frame()
		loadw(a3,CURRENT_ENEMY_SPEED)
		bgez a3,EWS_RIGHT
			render_abs_sprite(enemy_left,CURRENT_ENEMY_POSX,CURRENT_ENEMY_POSY)
			j EWS_LEFT
		EWS_RIGHT:
			render_abs_sprite(enemy_right,CURRENT_ENEMY_POSX,CURRENT_ENEMY_POSY)
		EWS_LEFT:
		addi s3,s3,4
		addi s4,s4,4
		addi s5,s5,4
		addi s6,s6,4
		addi s7,s7,4
		addi s8,s8,1
		j EWS_LOOP
	EWS_DONE:
	j POLL_LOOP

################################################################
# Renderiza um tiro que vai da posi��o (x,y) at� o bloco final #
################################################################
ENEMY_SHOT:
	loadw(t1,SHOOTING_ENEMY)
	beqz t1,ES_DONT
		render_abs_sprite(tijolo,SHOT_POSX,SHOT_POSY)
		loadw(s1,SHOT_POSX)
		loadw(s2,SHOT_POSY)
		loadw(s3,SHOT_SPEED)
		loadw(s4,SHOT_FINAL_BLOCK)
		add s1,s1,s3
		calculate_block(s1,s2)
		ble t1,s4,ES_CONTINUE
			loadw(s1,SHOT_INITIAL_POSX)
			savew(s1,SHOT_POSX)
		ES_CONTINUE:
		savew(s1,SHOT_POSX)
		call COLISION_TEST
		render_abs_sprite(enemy_shot,SHOT_POSX,SHOT_POSY)
	ES_DONT:
	j POLL_LOOP