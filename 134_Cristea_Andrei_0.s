.section .note.GNU-stack,"",@progbits
.data
    memory: .space 4096
    
    #main
    nr_operatii: .space 4
    cod_operatie: .space 4
    
    #ADD
    nr_fisiere: .space 4
    descriptor_fisier: .space 4
    dimensiune_fisier: .space 4
    spatiu_necesar: .space 4
    secv_curenta_de_0: .space 4
    start: .space 4
    end: .space 4

	#GET
    descriptor_fisier_get: .space 4
    end_get: .space 4
    start_get: .space 4
    
    #DEL
    descriptor_fisier_del: .space 4
    start_del: .space 4
    end_del: .space 4
    lungime_del: .space 4
    descriptor_del_afisare: .space 4
    
    #DFG
    i: .space 4
    j: .space 4
    lungime_dfg: .space 4
	start_dfg: .space 4
	end_dfg: .space 4
	descriptor_dfg_afisare: .space 4
    
    
	#input - output
    formatScanf: .asciz "%d"
    formatPrintf: .asciz "%d\n"
    formatGet: .asciz "(%d, %d)\n"
    formatOutput: .asciz "%d: (%d, %d)\n"

.text
#------------------------------------------------------------------------------------------------#
##################################
ADD:
    pushl %ebp
    mov %esp, %ebp
    
    pushl $nr_fisiere
    pushl $formatScanf
    call scanf
    addl $8, %esp           # INPUT nr_fisiere
    
et_loop_add:
	movl nr_fisiere, %eax
	decl %eax
	movl %eax, nr_fisiere
	cmpl $0 , nr_fisiere
	jl end_ADD				#LOOP pt toate fisierele + conditie iesire loop
    
    
    pushl $descriptor_fisier
    pushl $formatScanf
    call scanf
    addl $8, %esp				#INPUT descriptor_fisier 

    pushl $dimensiune_fisier
    pushl $formatScanf
    call scanf
    addl $8, %esp				#INPUT dimensiune_fisier
    
    xorl %edx, %edx
    movl dimensiune_fisier, %eax
    movl $8, %ecx
    divl %ecx
    cmp $0, %edx
    je et_dimensiune_fisier_divizila_8
    add $1, %eax
	et_dimensiune_fisier_divizila_8:
	
	movl %eax, spatiu_necesar   #AM CALCULAT spatiu necesar pentru fisier
	
    movl $0, secv_curenta_de_0
    movl $0, start
    movl $0, end
    
    movl $0, %ebx
    lea memory, %edi
cauta_secv_de_0_loop:
    movl (%edi, %ebx, 4), %eax
	cmp $0, %eax
	je creste_secv_cur_de_0
	
	movl $0, secv_curenta_de_0
	incl %ebx
	movl %ebx, start
    movl %ebx, end
    cmpl $1023, %ebx
    jl cauta_secv_de_0_loop
    
creste_secv_cur_de_0:
	incl end
	incl secv_curenta_de_0
	
	movl spatiu_necesar, %eax
	cmpl secv_curenta_de_0 , %eax
	je end_cauta_secv
	incl %ebx
    cmpl $1023, %ebx
    jle cauta_secv_de_0_loop
end_cauta_secv:
	#stiu indicii start si end intre care se afla prima secv de lungime spatiu necesar, doar de 0

	# pentru toate elementele din stiva de la start la end(inclusiv)
	# pun ca nume descriptorul fisierului
	movl end, %ecx 
	subl start, %ecx
	movl spatiu_necesar, %eax
	cmpl spatiu_necesar, %ecx
	jl nu_adaug_fisierul
	
	movl start, %ebx
    lea memory, %edi
scimbare_valori_start_end:
	movl descriptor_fisier, %eax
    movl %eax, (%edi, %ebx, 4)
    incl %ebx
    cmpl end, %ebx
    jl scimbare_valori_start_end     #ACTUALIZEZ stiva pentru fisierul citit
    
    subl $1, end
    
    pushl end
    pushl start
    pushl descriptor_fisier
    pushl $formatOutput
    call printf
    addl $16, %esp
    
    jmp et_loop_add
    
nu_adaug_fisierul:
	pushl $0
    pushl $0
    pushl descriptor_fisier
    pushl $formatOutput
    call printf
    addl $16, %esp
	
	jmp et_loop_add

end_ADD:  

    mov %ebp, %esp
    popl %ebp
    ret
##################################
GET:
    pushl %ebp
    mov %esp, %ebp
    #parcurg stiva
    #gasesc indexul de inceput al desc_fis_get
    #gasesc indexul final
    #le afisez
    
    pushl $descriptor_fisier_get
    pushl $formatScanf
    call scanf
    addl $8, %esp				#INPUT descriptor_fisier_get 
    
    movl $0, end_get
    movl $-1, start_get
    movl $0, %ebx
    lea memory, %edi
parcurgere_stiva_get:
    movl (%edi, %ebx, 4), %eax
    
    cmp %eax, descriptor_fisier_get
    je descriptor_fisier_get_gasit
  
    incl %ebx
    cmpl $1023, %ebx
    jle parcurgere_stiva_get
    jmp negasit
    
descriptor_fisier_get_gasit:
	cmpl $-1, start_get
	jnz nu_setez_start
	movl %ebx, start_get
	nu_setez_start:
	movl %ebx, end_get
	incl %ebx
    cmpl $1023, %ebx
    jle parcurgere_stiva_get
    

    #pushl lungime_get
    #pushl $formatPrintf
    #call printf
    #addl $8, %esp
    
 negasit:   
    cmpl $0 , end_get
    jg afisare_GET
    movl $0, start_get
    pushl end_get
	pushl start_get
	pushl $formatGet
	call printf
	addl $12, %esp
    jmp end_GET
    
 afisare_GET: 
	
	pushl end_get
	pushl start_get
	pushl $formatGet
	call printf
	addl $12, %esp
	
end_GET:
    mov %ebp, %esp
    popl %ebp
    ret
##################################
DELETE:
    pushl %ebp
    mov %esp, %ebp
    ###parcurg stiva
    ###unde gasesc descritproul citit pun 0
    ###afisez toata stiva ca la ADD, doar ca pt toate fisierele
    
    pushl $descriptor_fisier_del
    pushl $formatScanf
    call scanf
    addl $8, %esp			#INPUT descriptor_fisier_del
    
     movl $0, %ebx
     lea memory, %edi
parcurgere_stiva_del:
	cmpl $1023, %ebx
	jg afiseaza_DEL

    movl (%edi, %ebx, 4), %eax
    cmp %eax, descriptor_fisier_del
    jne continua_parcurgere_del
    
    movl $0, (%edi, %ebx, 4)
continua_parcurgere_del:
	incl %ebx
	jmp parcurgere_stiva_del   

#afisare stiva in format Output
afiseaza_DEL:
		
	movl $0, lungime_del
	movl $0, start_del
	movl $0, end_del
	movl $0, descriptor_del_afisare
	
    movl $0, %ebx
    lea memory, %edi
    movl (%edi, %ebx, 4), %eax
    movl %eax, descriptor_del_afisare
parcurgere_del_loop:
	incl %ebx
    cmpl $1023, %ebx
	jg incheie_secventa
	
	movl (%edi, %ebx, 4), %eax
	cmpl %eax, descriptor_del_afisare
	je continua_secventa
	incheie_secventa:
	#daca descriptorul era nenul il printez altfel doar il schimb
	cmpl $0, descriptor_del_afisare
	je era_nul
	movl end_del, %ecx
	subl lungime_del, %ecx
	movl %ecx, start_del
	
	
	pushl end_del
	pushl start_del
	pushl descriptor_del_afisare
	pushl $formatOutput
	call printf
	addl $16, %esp
	
	era_nul:
	movl (%edi, %ebx, 4), %eax
    movl %eax, descriptor_del_afisare
	movl $0, lungime_del
	
	cmpl $1023, %ebx
	jg end_afisare
	jmp parcurgere_del_loop
continua_secventa:
	addl $1, lungime_del
	movl %ebx, end_del

	jmp parcurgere_del_loop


end_afisare:

end_DEL:
	mov %ebp, %esp
    popl %ebp
    ret
################################
DEFRAGMENTATION:
    pushl %ebp
    mov %esp, %ebp
    ##parcurg stiva cu doua variabile(i si j)
    ##pe i il opresc cand dau de primul zero
    ##j porneste de la i + 1 si cauta valori nenule
    ##daca nu gaseste DFG s a terminat
    ##		print memory
    ##daca gaseste 
    ##		le interschimb
    ##		i = i + 1
    ##		loop parcurgere cu j si cautare valori nenule
    
    
    movl $0, i
    lea memory, %edi
parcurgere_dfg_loop:
    incl i
    movl i, %eax
    cmpl $1023, %eax
    jg afisare_DFG
    movl i, %ebx
    movl (%edi, %ebx, 4), %eax
    cmpl $0, %eax
    je i_este_zero
    jmp parcurgere_dfg_loop
    
i_este_zero:
	movl i, %eax
	movl %eax, j
	
	parcurgere_cu_j:
	movl j, %eax
	incl %eax
	movl %eax, j
	cmpl $1023, j
	jg afisare_DFG
	movl j, %ebx
    movl (%edi, %ebx, 4), %eax
    cmpl $0, %eax
    jne interschimbare_valori_cu_indicii_i_j
    jmp parcurgere_cu_j
    
    interschimbare_valori_cu_indicii_i_j:
    movl i, %eax
    movl j, %ebx
    movl (%edi, %eax, 4), %ecx
    movl (%edi, %ebx, 4), %edx
    movl %ecx, (%edi, %ebx, 4)
    movl %edx, (%edi, %eax, 4)
    jmp parcurgere_dfg_loop
    
afisare_DFG:    #acceeasi afisare a intregii stive ca la DEL
		
	movl $0, lungime_dfg
	movl $0, start_dfg
	movl $0, end_dfg
	movl $0, descriptor_dfg_afisare
	
    movl $0, %ebx
    lea memory, %edi
    movl (%edi, %ebx, 4), %eax
    movl %eax, descriptor_dfg_afisare
parcurgere_dfg_loop_afisare:
	incl %ebx
    cmpl $1023, %ebx
	jg incheie_secventa_dfg
	
	movl (%edi, %ebx, 4), %eax
	cmpl %eax, descriptor_dfg_afisare
	je continua_secventa_dfg
	
	incheie_secventa_dfg:
	#daca descriptorul era nenul il printez altfel doar il schimb
	cmpl $0, descriptor_dfg_afisare
	je era_nul_dfg
	movl end_dfg, %ecx
	subl lungime_dfg, %ecx
	movl %ecx, start_dfg
	
	
	pushl end_dfg
	pushl start_dfg
	pushl descriptor_dfg_afisare
	pushl $formatOutput
	call printf
	addl $16, %esp
	
	era_nul_dfg:
	movl (%edi, %ebx, 4), %eax
    movl %eax, descriptor_dfg_afisare
	movl $0, lungime_dfg
	cmpl $1023, %ebx
	jg end_afisare_DFG
	jmp parcurgere_dfg_loop_afisare
continua_secventa_dfg:
	addl $1, lungime_dfg
	movl %ebx, end_dfg

	jmp parcurgere_dfg_loop_afisare


end_afisare_DFG:

    
end_DFG:
    mov %ebp, %esp
    popl %ebp
    ret

.globl main
#------------------------------------------------------------------------------------------------#
main:

    xorl %eax, %eax
    lea memory, %edi
    movl $0, %ecx
loop_initializare_vector:
    movl %eax, (%edi, %ecx, 4)
    incl %ecx
    cmpl $1023, %ecx
    jle loop_initializare_vector   #INITIALIZARE VECTOR

	pushl $nr_operatii
	pushl $formatScanf
	call scanf
	addl $8, %esp               #INPUT nr_operatii
	
et_loop_operatie:
    movl nr_operatii, %eax
    decl %eax
    movl %eax, nr_operatii
    cmpl $0, nr_operatii
    jl et_exit
    
    pushl $cod_operatie
	pushl $formatScanf
	call scanf
	addl $8, %esp         #INPUT cod_operatie
	
	movl cod_operatie, %eax
	cmpl $1, %eax
	je et_ADD
	cmpl $2, %eax
	je et_GET
	cmpl $3, %eax
	je et_DELETE
	cmpl $4, %eax
	je et_DEFRAGMENTATION     #Selector operatie
	
et_ADD:
	call ADD
	jmp et_loop_operatie
et_GET:
	call GET
    jmp et_loop_operatie
et_DELETE:
	call DELETE
    jmp et_loop_operatie
et_DEFRAGMENTATION:
	call DEFRAGMENTATION
    jmp et_loop_operatie


	#printeaza tot vectorul(debug)
    #movl $0, %ebx
    #lea memory, %edi
#print_vector_loop:
    #movl (%edi, %ebx, 4), %eax
    
    #pushl %eax
    #pushl $formatPrintf
    #call printf
    #addl $8, %esp
    
    #incl %ebx
    #cmpl $300, %ebx
    #jl print_vector_loop

et_exit:
	pushl $0
	call fflush
	add $4, %esp
	
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80

