LOLO_WALK:
	li t1, UP 				# t1 = 'W'
	li t2, DOWN				# t2 = 'S'
	li t3, RIGHT				# t1 = 'D'
	li t4, LEFT				# t2 = 'A'
	
	
	beq s11,t1,LOLO_WALK_UP			# s11 = tecla digitada
	beq s11,t2,LOLO_WALK_DOWN
	beq s11,t3,LOLO_WALK_RIGHT
	beq s11,t4,LOLO_WALK_LEFT
	j POLL_LOOP
	
LOLO_WALK_UP:
	LOADW(t3,LOLO_POSX)
	LOADW(t2,LOLO_POSY)
	CALCULATE_BLOCK(t3,t2)
	# Calcula o bloco atual de lolo (vai ser apagado)
	la t2, BRIDGE_BLOCKS
	add t2,t2,t1
	lb t3,(t2)
	beqz t3, LWU_NOT_BRIDGE
	PRINT_DYN_IMG(bridge,LOLO_POSX,LOLO_POSY)
	# Se � uma ponte, imprime uma ponte
	j LWU_IS_BRIDGE
LWU_NOT_BRIDGE:
	PRINT_DYN_IMG(tijolo,LOLO_POSX,LOLO_POSY)
	# Se � um tijolo, imprime um tijolo
LWU_IS_BRIDGE:						
	SWITCH_FRAME()			
	LOADW(a1,LOLO_POSY)
	addi a1,a1,-16
	# In�cio teste '� uma porta'
	li t1, DOOR_POSX
	li t2, DOOR_POSY
	bne t2,a1,LWU_CONTINUE
	LOADW( t3,LOLO_POSX )
	bne t3,t1,LWU_CONTINUE
	# In�cio teste 'a porta est� aberta'
	LOADW(t1,DOOR_STATE)
	bnez t1, LWU_INVALID
	# Fim teste 'a porta est� aberta'
	SAVEW( a1,LOLO_POSY )
	PRINT_DYN_IMG(lolo_coca, LOLO_POSX, LOLO_POSY)
	li t3, FRAME_SELECT
	LOADW(t1,CURRENT_FRAME)			
	sw t1,(t3)
	# Se � uma porta, e est� aberta, fase finalizada				
	finished_level()
	# Fim teste '� uma porta'
LWU_CONTINUE:
	# In�cio teste 'est� no mapa'
	li t2, MAP_UPPER_EDGE
	blt a1,t2,LWU_INVALID
	# Fim teste 'est� no mapa'
	# In�cio teste '� um bloco and�vel'
	LOADW( t3,LOLO_POSX )
	CALCULATE_BLOCK(t3,a1)
	# In�cio teste '� um bloco mortal'
	jal IS_MORTAL_BLOCK
	# Fim teste '� um bloco mortal'
LWU_NOT_MORTAL:
	# In�cio teste '� um bloco-chave'
	la t2, KEY_BLOCKS
	add t2,t2,t1
	lb t3,(t2)
	beqz t3, LWU_NOT_KEY
	li t3,0
	sb t3,(t2)
	LOADW(t2,KEY_COUNTER)
	addi t2,t2,-1	
	SAVEW(t2,KEY_COUNTER)
	door_refresh()
	LOADW(a1,LOLO_POSY)
	addi a1,a1,-16
	SAVEW(a1,LOLO_POSY)
	ERASE_BLOCK()		
	j LWU_IS_KEY	
	# Fim teste '� um bloco-chave'
LWU_NOT_KEY:
	la t2, WALKABLE_BLOCKS
	add t2,t2,t1
	lb t1,(t2)
	bgt t1,zero, LWU_INVALID
	# WALKABLE BLOCK TEST END
	SAVEW(a1,LOLO_POSY)			
LWU_IS_KEY:
LWU_INVALID:
	jal COLISION_TEST
	PRINT_DYN_IMG(lolo_up_1,LOLO_POSX,LOLO_POSY)						
	li t3, FRAME_SELECT
	LOADW( t1,CURRENT_FRAME )			
	sw t1,(t3)				
	j POLL_LOOP
LOLO_WALK_DOWN:
	LOADW(t3,LOLO_POSX)
	LOADW(t2,LOLO_POSY)
	CALCULATE_BLOCK(t3,t2)
	la t2, BRIDGE_BLOCKS
	add t2,t2,t1
	lb t3,(t2)
	beqz t3, LWD_NOT_BRIDGE
	PRINT_DYN_IMG(bridge,LOLO_POSX,LOLO_POSY)
	j LWD_IS_BRIDGE
LWD_NOT_BRIDGE:
	PRINT_DYN_IMG(tijolo,LOLO_POSX,LOLO_POSY)
LWD_IS_BRIDGE:
	SWITCH_FRAME()			
	LOADW(a1,LOLO_POSY)
	addi a1,a1,16
	# In�cio teste 'est� no mapa'
	li t2, MAP_LOWER_EDGE
	bgt a1,t2,LWD_INVALID
	# Fim teste 'est� no mapa'
	# In�cio teste '� um bloco and�vel'
	LOADW( t3,LOLO_POSX )
	CALCULATE_BLOCK( t3,a1 )
	# In�cio teste '� um bloco mortal'
	jal IS_MORTAL_BLOCK
	# Fim teste '� um bloco mortal'
LWD_NOT_MORTAL:
	# In�cio teste '� um bloco chave'
	la t2, KEY_BLOCKS
	add t2,t2,t1
	lb t3,(t2)
	beqz t3, LWD_NOT_KEY
	li t3,0
	sb t3,(t2)
	LOADW(t2,KEY_COUNTER)
	addi t2,t2,-1
	SAVEW(t2,KEY_COUNTER)
	door_refresh()
	LOADW(a1,LOLO_POSY)
	addi a1,a1,16
	SAVEW(a1,LOLO_POSY)
	ERASE_BLOCK()		
	j LWD_IS_KEY	
	# Fim teste '� um bloco-chave'
LWD_NOT_KEY:
	la t2, WALKABLE_BLOCKS
	add t2,t2,t1
	lb t1,(t2)
	bgt t1,zero, LWD_INVALID
	# Fim teste '� um bloco and�vel'
	SAVEW(a1,LOLO_POSY)			
LWD_IS_KEY:
LWD_INVALID:
	jal COLISION_TEST
	PRINT_DYN_IMG( lolo_down_1, LOLO_POSX, LOLO_POSY)
						
	li t3, FRAME_SELECT
	LOADW( t1,CURRENT_FRAME )			
	sw t1,(t3)				
	j POLL_LOOP
LOLO_WALK_RIGHT:
	LOADW(t3,LOLO_POSX)
	LOADW(t2,LOLO_POSY)
	CALCULATE_BLOCK(t3,t2)
	la t2, BRIDGE_BLOCKS
	add t2,t2,t1
	lb t3,(t2)
	beqz t3, LWR_NOT_BRIDGE
	PRINT_DYN_IMG(bridge,LOLO_POSX,LOLO_POSY)
	j LWR_IS_BRIDGE
LWR_NOT_BRIDGE:
	PRINT_DYN_IMG(tijolo,LOLO_POSX,LOLO_POSY)
LWR_IS_BRIDGE:						
	SWITCH_FRAME()					
	LOADW( a1,LOLO_POSX )
	addi a1,a1,16
	# In�cio teste 'est� no mapa'
	li t2, MAP_RIGHT_EDGE
	bgt a1,t2,LWR_INVALID
	# Fim teste 'est� no mapa'
	# In�cio teste '� um bloco and�vel'
	LOADW( t3,LOLO_POSY )
	CALCULATE_BLOCK( a1,t3 )
	# In�cio teste '� um bloco mortal'
	jal IS_MORTAL_BLOCK
	# Fim teste '� um bloco mortal'
LWR_NOT_MORTAL:
	# In�cio teste '� um bloco chave'
	la t2, KEY_BLOCKS
	add t2,t2,t1
	lb t3,(t2)
	beqz t3, LWR_NOT_KEY
	li t3,0
	sb t3,(t2)
	LOADW(t2,KEY_COUNTER)
	addi t2,t2,-1
	SAVEW(t2,KEY_COUNTER)
	door_refresh()
	LOADW(a1,LOLO_POSX)
	addi a1,a1,16
	SAVEW(a1,LOLO_POSX)
	ERASE_BLOCK()		
	j LWR_IS_KEY	
	# In�cio teste '� um bloco chave'
LWR_NOT_KEY:
	la t2, WALKABLE_BLOCKS
	add t2,t2,t1
	lb t1,(t2)
	bgt t1,zero, LWR_INVALID
	# Fim teste '� um bloco and�vel'
	SAVEW( a1,LOLO_POSX )				
LWR_IS_KEY:
LWR_INVALID:
	jal COLISION_TEST
	PRINT_DYN_IMG( lolo_right_1, LOLO_POSX, LOLO_POSY)
						
	li t3, FRAME_SELECT
	LOADW( t1,CURRENT_FRAME )			
	sw t1,(t3)				
	j POLL_LOOP
LOLO_WALK_LEFT:
	LOADW(t3,LOLO_POSX)
	LOADW(t2,LOLO_POSY)
	CALCULATE_BLOCK(t3,t2)
	la t2, BRIDGE_BLOCKS
	add t2,t2,t1
	lb t3,(t2)
	beqz t3, LWL_NOT_BRIDGE
	PRINT_DYN_IMG(bridge,LOLO_POSX,LOLO_POSY)
	j LWL_IS_BRIDGE
LWL_NOT_BRIDGE:
	PRINT_DYN_IMG(tijolo,LOLO_POSX,LOLO_POSY)
LWL_IS_BRIDGE:
						
	SWITCH_FRAME()			
	LOADW( a1,LOLO_POSX )
	addi a1,a1,-16
	# In�cio teste 'est� no mapa'
	li t2, MAP_LEFT_EDGE
	blt a1,t2, LWL_INVALID
	# Fim teste 'est� no mapa'
	# In�cio teste '� um bloco and�vel'
	LOADW( t3,LOLO_POSY )
	CALCULATE_BLOCK(a1,t3)
	# In�cio teste '� um bloco mortal'
	jal IS_MORTAL_BLOCK
	# Fim teste '� um bloco mortal'
LWL_NOT_MORTAL:
	# In�cio teste '� um bloco-chave'
	la t2, KEY_BLOCKS
	add t2,t2,t1
	lb t3,(t2)
	beqz t3, LWL_NOT_KEY
	li t3,0
	sb t3,(t2)
	LOADW(t2,KEY_COUNTER)
	addi t2,t2,-1
	SAVEW(t2,KEY_COUNTER)
	door_refresh()
	LOADW(a1,LOLO_POSX)
	addi a1,a1,-16
	SAVEW(a1,LOLO_POSX)
	ERASE_BLOCK()		
	j LWL_IS_KEY	
	# Fim teste '� um bloco-chave'
LWL_NOT_KEY:
	la t2, WALKABLE_BLOCKS
	add t2,t2,t1
	lb t1,(t2)
	bgt t1,zero, LWL_INVALID
	# Fim teste '� um bloco and�vel'
	SAVEW(a1,LOLO_POSX)			
LWL_IS_KEY:
LWL_INVALID:
	jal COLISION_TEST
	PRINT_DYN_IMG( lolo_left_1, LOLO_POSX, LOLO_POSY)
	li t3, FRAME_SELECT
	LOADW( t1,CURRENT_FRAME )			
	sw t1,(t3)				
	j POLL_LOOP
	
#################################
# Verifica se � um bloco mortal #
#################################
IS_MORTAL_BLOCK:
	la t2, MORTAL_BLOCKS
	add t2,t2,t1
	lb t3,(t2)
	beqz t3, NOT_MORTAL
	LOADW(t3,LIFE_COUNTER)
	addi t3,t3,-1
	beqz t3, DEAD
	SAVEW(t3,LIFE_COUNTER)
	li t1,74
	li t2,36
	SAVEW(t1,LOLO_POSX)
	SAVEW(t2,LOLO_POSY)
	PRINT_DYN_IMG(lolo_pisca,LOLO_POSX,LOLO_POSY)
	li t3, FRAME_SELECT
	LOADW( t1,CURRENT_FRAME )			
	sw t1,(t3)
	j POLL_LOOP
DEAD:
	SWITCH_FRAME()
	you_died()
NOT_MORTAL:
	ret
