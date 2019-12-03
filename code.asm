.data
.msgMoveisFixos: .asciiz "insira o número de moveis que não podem ser aspirados debaixo: "	
.msgMoveisLivres: .asciiz "insira o número de moveis que podem ser aspirados por debaixo: "	


.text	
	jal defCores
	jal defMap #nao mexer na vari�vel t0
	jal desenhaPlanta
	jal nMoveis 
	jal insereMovelF
	jal insereRobo
	addi $t8, $zero, 183# locais dispon�veis
	sub $t8, $t8, $s7 
	#t8 agora possui o total de posi��es dispon�veis para limpeza
	main_loop:
		jal moveRobo
		bne $t8,0,main_loop

	#addi $t3, $zero, 183 # todas as posi��es sujas	
	#main_loop:
	li $v0, 10
	syscall
	
	
	moveRobo: #seleciona um candidato a pixel na vizinhan�a
		#t0 vai estar com a posi��o do robo
		
		subi  $s4, $t0, 68 # s4 recebe ponto da diagonal esquerda superior 
		move $s5, $t0 # carrega valor do ponto a cima em s5
		subi $s5, $t0, 64 # s5 recebe o ponto superior 
		lw  $t3, ($s4) # recebe o conteudo de s4
		lw  $t4, ($s5) # recebe o conteudo de s5
		slt $t7, $t3, $t4 # se s4<s5 t7 recebe 1	
		beq $t7,1, prox1
		#se n�o for menor
		move $s4, $s5 # s4 recebe s5 
		prox1:
		#s4 vai estar com o menor valor
		move $s5, $t0
		subi $s5, $t0, 60 # recebe o ponto da diagonal superior direita 
		lw  $t3, ($s4) # recebe o conteudo de s4
		lw  $t4, ($s5) # recebe o conteudo de s5
		slt $t7, $t3, $t4 #s4 � menor que s5
		beq $t7,1, prox2
		#se n�o for menor
		move $s4, $s5 # t7 recebe s5 
		prox2:
		move $s5, $t0
		subi $s5, $t0, 4 # recebe o ponto da esquerda
		lw  $t3, ($s4) # recebe o conteudo de s4
		lw  $t4, ($s5) # recebe o conteudo de s5
		slt $t7,$t3, $t4 
		beq $t7,1,prox3
		#se n�o for menor
		move $s4, $s5 # t7 recebe s5 
		prox3:
		move $s5, $t0
		addi $s5, $t0, 4 # s5 recebe o ponto da direita
		lw  $t3, ($s4) # recebe o conteudo de s4
		lw  $t4, ($s5) # recebe o conteudo de s5
		slt $t7,$t3, $t4 
		beq $t7,1,prox4
		#se n�o for menor
		move $s4, $s5 # t7 recebe s5 
		prox4:
		move $s5, $t0
		addi $s5, $t0, 60 # s5 recebe o ponto da diagonal esquerda inferior
		lw  $t3, ($s4) # recebe o conteudo de s4
		lw  $t4, ($s5) # recebe o conteudo de s5
		slt $t7,$t3, $t4 
		beq $t7,1,prox5
		#se n�o for menor
		move $s4, $s5 # t7 recebe s5 
		
		prox5:
		move $s5, $t0
		addi $s5, $t0, 64 # s5 recebe o ponto debaixo 
		lw  $t3, ($s4) # recebe o conteudo de s4
		lw  $t4, ($s5) # recebe o conteudo de s5
		slt $t7,$t3, $t4 
		beq $t7,1,prox6
		#se n�o for menor
		move $s4, $s5 # t7 recebe s5 
		prox6:
		move $s5, $t0
		addi $s5, $t0, 68 # s5 recebe o ponto da diagonal direita inferior
		lw  $t3, ($s4) # recebe o conteudo de s4
		lw  $t4, ($s5) # recebe o conteudo de s5
		slt $t7,$t3, $t4 
		beq $t7,1,prox7
		#se n�o for menor
		move $s4, $s5 # t7 recebe s5 
		j prox7
		
		prox7:
		lw $s2, ($s4) #carrego o conteudo da variavel selecionada em s2
		beq $s2, 0x00000000, dim
		j continue # se nao for igual a preto
		dim:
		subi $t8,$t8,1 # se for diminui um do contador
		continue:
		sw $s3, ($s4)# pinto a posi��o selecionada de azul
		addi $s2, $s2, 50 #incrementa a cor da posi��o atual 
		sw $s2, ($t0)# pinto a posi��o atual com o incremento
		move $t0,$s4 # t0 recebe a nova posi��odo robo
	jr $ra 
	li $v0, 10 #encerramento do programa
	syscall
	#
	#
	#
	insereRobo:
		move $t7, $ra
		loop_r:		
			jal rngXY
			addi $t4, $zero, 4
			mul $t3, $t4, $s5
			add $t0, $t1, $t3
			lw $t3, ($t0)
			bne $t3, $s0, c1
			j loop_r
			c1:
			bne $t3,$s1, gravr
			j loop_r
			gravr:
			sw $s3,($t0) 
			jr $t7
	
	insereMovelF:
		move $t7, $ra #guarda o valor do registrador de endereço antes de chamar a proxima função 
		addi $t2, $zero, 0 # inicia a variavel de controle do laço que esta dentro de insere movel
		loop_mF:
			jal rngXY #seta um valor randomico de 0 a 256
			addi $t4, $zero, 4 # t4 recebe 4
			mul $t3 , $t4, $s5 # valor é multiplicado para gerar o pixel do movel dado: 4bytes por quadradado * o quadrado desejado 
			# ex: quadrado 26 em endereço é 26*4
			add $t0, $t1, $t3 # valor t0  recebe o pixel inicial em t1 (pixel base) e é somado com t3 para dar o deslocamento do pixel correspondente
			lw $t3, ($t0) #carrega conteúdo da memória na posição calculada para o registrador temporário t3
			bne $t3, $s0, gravaF # se a cor armazenada em t3 for diferente ele manda gravar o pixel
			j loop_mF # se for igual ele retorna para recalcular o pixel
			gravaF:
			sw $s0, ($t0) # preenche o espaço com a posição nova
			addi $t2, $t2, 1 # adiciona um ao contador 
			beq $t2, $s7, ex1 # se o valor do contador for igual ao numero de móveis desejados ele sai do laço para a label exit
			j loop_mF # se não for igual ele retorna para calcular novos pixels 
			ex1:
			jr $t7 # retorna para o calculo do random 
			
	nMoveis:#solicita quantos moveis haverá 
		li $v0, 4
		la $a0, .msgMoveisFixos
		syscall
		li $v0, 5
		syscall
		move $s7, $v0 # recebe o numero de moveis fixos
		jr $ra
	
	rngXY: #gera aleatorio de 0 a 256
		li $v0, 42
		li $a1, 257 # estabelece intervalo de [0,1024]
		syscall
		move $s5, $a0 # ponto aleatorio no mapa
		syscall
		jr $ra
	
	desenhaPlanta:
		add $t0, $zero, $t1 # t0 recebe a posição inicial atribuida em t1 
		addi $t2, $zero, 0 #t2 recebe 0 para ser nosso contador
		loop_1: #Loop de linha vermelha no canto superior esquerdo
			sw $s0, ($t0) #Pinto o pixel na posicao $t0 com a cor de $s4
			addi $t0, $t0, 4 #Pulo +4 no pixel, pula 4 bytes ou seja vai para o proximo ponto 
			addi $t2, $t2, 1 #Contador +1
			beq $t2, 15, exit_1 # se chegar até o final vai para a proxima linha
			j loop_1
		exit_1: 
		
		#t0 foi incrimentado antes de sair do laço, então já está na posição desejada 60
		addi $t2, $zero, 0 #t2 recebe 0
		loop_2: #Loop de linha vermelha no canto direito
			sw $s0, ($t0) #Pinto o pixel na posicao $t0 com a cor de $s4
			addi $t0, $t0, 64 #Pulo +64 no pixel, pula 4 bytes * 16 casas, ou seja vai para o proximo ponto da linha seguinte 
			addi $t2, $t2, 1 #Contador +1
			beq $t2, 16, exit_2 # pinta todos os 16 quadros da linha correspondente 
			j loop_2
		exit_2:
		
		add $t0, $zero , $t1 
		addi $t2, $zero, 0 
		loop_3: #Loop de linha vermelha no canto esquerdo
			sw $s0, ($t0) 
			addi $t0, $t0, 64 
			addi $t2, $t2, 1
			beq $t2, 15, exit_3
			j loop_3
		exit_3: #t0 já está com o valor do final da linha do canto esquerdo, basta continuar dele
		
		addi $t2, $zero, 0 
		loop_4: #Loop de linha vermelha no canto inferior
			sw $s0, ($t0) 
			addi $t0, $t0, 4 
			addi $t2, $t2, 1 
			beq $t2, 15, exit_4  
			j loop_4
			
		exit_4:
		addi $t0, $t1, 28 # t0 recebe a posição inicial em 7*4
		addi $t2, $zero, 0  
		loop_5: #Loop de linha vermelha na parede do meio 
			sw $s0, ($t0) 
			addi $t0, $t0, 64 
			addi $t2, $t2, 1 
			beq $t2, 5, exit_5 
			j loop_5
			
		exit_5: 
		addi $t0, $t1, 604 # t0 recebe a posição inicial em 6*4 + 9*64
		addi $t2, $zero, 0  
		
		loop_6: #Loop de linha vermelha na parede do meio 
			sw $s0, ($t0) 
			addi $t0, $t0, 4
			addi $t2, $t2, 1 
			beq $t2, 8, exit_6
			j loop_6
		exit_6: 
		# referencia do pixel:
		# (K pontos * 4bytes) é o deslocamento em  x + (K' pontos * 64 ) é o deslocamento em y 
		# ao somar os pontos temos o valor desejado
		jr $ra

	defMap: #label da função que define o tamanho do mapa
		addi $t0, $zero, 256 #100000
		add $t1, $t0, $zero
		lui $t1, 0x1004 #0x1004 é colocado como bit mais significativo e t2 como menos significativo, define em que lugar começa 
		jr $ra # retorna ao endereço armazenado no registrador de endereços 
		
	defCores: #label da função que define cores para os registradores	
		addi $s0, $zero, 0x00FF0000 #registrador s0 recebe a cor vermelha primeiro byte mais sifnificativo é ignorado
		addi $s1, $zero, 0x007B68EE #registrador s1 recebe a cor roxa
		#addi $s2, $zero, 0x000000C0#registrador s2 recebe a cor branca
		addi $s3, $zero, 0x00FFFF00 #registrador s3 recebe a cor azul FFFF00
		jr $ra #retorna ao endereço armazenado no registrador de endereços
	


	
	
