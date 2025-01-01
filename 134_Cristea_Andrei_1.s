.section .note.GNU-stack,"",@progbits
.data
    memory: .space 4194304

    #main
    nr_operatii: .space 4
    cod_operatie: .space 4

    #ADD
	nr_fisiere: .space 4
    descriptor_fisier: .space 4
    dimensiune_fisier: .space 4
    spatiu_necesar: .space 4
    indice_linie: .space 4
    secv_curenta_de_0: .space 4
    start: .space 4
    start_de_afisat: .space 4
    end_de_afisat: .space 4
    end: .space 4

	#GET
	descriptor_fisier_get: .space 4
	indice_linie_get: .space 4
	start_get: .space 4
	end_get: .space 4

    #DEL
    descriptor_fisier_del: .space 4
    indice_linie_del: .space 4
    descriptor_afisare_del: .space 4
    start_del: .space 4
    end_del: .space 4


    #DFG
    indice_linie_dfg: .space 4
    descriptor_curent_dfg: .space 4
    secventa_curenta_dfg: .space 4
    vector_dfg: .space 4194304
	indice_vector: .space 4

    counter: .space 4
    lungime_dfg: .space 4
    descriptor_de_repus: .space 4

    #DFG-afisare
    indice_linie_dfg_afisare: .space 4
    descriptor_afisare_dfg: .space 4
    start_dfg: .space 4
    end_dfg: .space 4

    #CNC

    spatiu_necesar_con: .space 4
    indice_linie_con: .space 4
    secv_curenta_de_0_con: .space 4
    start_con: .space 4
    start_de_afisat_con: .space 4
    end_de_afisat_con: .space 4
    end_con: .space 4


    dir_path: .space 500
    dirp: .space 4
    entry: .space 4
    num_fisier: .space 512
    full_file_path: .space 512

    punct: .asciz "."
    punctpunct: .asciz ".."
    error2: .asciz "Eroare la deschiderea folderului :("


    fd: .space 4
    fd_fictiv: .space 4
    fileStat : .space 144



    error1: .asciz "Eroare la deschiderea fisierului:("
    formatScanfstring: .asciz "%s"
    formatprintstring: .asciz "%s/%s"
    error: .asciz "%s\n"
    fd_si_dimensiune: .asciz "Fisierul cu descriptorul %d are dimensiunea %d KB.\n"


	#input - output
	formatScanf: .asciz "%d"
	formatPrintf: .asciz "%d\n"
	formatPrintfdbg: .asciz "%d "
	printEnter: .asciz "\n"
	formatOutput: .asciz "%d: ((%d, %d), (%d, %d))\n"
	formatGet: .asciz "((%d, %d), (%d, %d))\n"


.text
#------------------------------------------------------------------------------------------------#
##################################
ADD:
    pushl %ebp
    mov %esp, %ebp

    # Citire nr_fisiere
    pushl $nr_fisiere
    pushl $formatScanf
    call scanf
    addl $8, %esp           # INPUT nr_fisiere

et_loop_add:
    movl nr_fisiere, %eax
    cmpl $0, %eax
    jle end_ADD

    decl nr_fisiere

    pushl $descriptor_fisier
    pushl $formatScanf
    call scanf
    addl $8, %esp          # INPUT descriptor_fisier

    pushl $dimensiune_fisier
    pushl $formatScanf
    call scanf
    addl $8, %esp          # INPUT dimensiune_fisier

    xorl %edx, %edx
    movl dimensiune_fisier, %eax
    movl $8, %ecx
    divl %ecx
    testl %edx, %edx
    je et_dimensiune_fisier_divizila_8
    incl %eax
et_dimensiune_fisier_divizila_8:
    movl %eax, spatiu_necesar

#parcurg toate liniile
#	caut prima secventa de lungime spatiu necesar
#	acum stiu start si end
#inlocuiesc in vector pe pozitiile corespunzatoare

lea memory, %edi
movl $-1, indice_linie
cauta_in_toate_liniile:
	addl $1, indice_linie
	cmpl $1023, indice_linie
	jg fisierul_nu_are_loc
	movl $0, %ebx
	movl $0, secv_curenta_de_0
cauta_pe_linia_data:
	movl $1024, %eax
	mull indice_linie
	add %ebx, %eax
    movl (%edi, %eax, 4), %ecx

	cmp $0, %ecx
	je element_zero



	movl $0, secv_curenta_de_0
	incl %ebx
    cmpl $1023, %ebx
    jle cauta_pe_linia_data
	jmp cauta_in_toate_liniile

element_zero:
	cmpl $0, secv_curenta_de_0
	jne nu_seta_start
	movl $1024, %eax
	mull indice_linie
	add %ebx, %eax
	movl %eax, start
	movl %ebx, start_de_afisat
	nu_seta_start:
	movl $1024, %eax
	mull indice_linie
	add %ebx, %eax
	movl %eax, end
	movl %ebx, end_de_afisat
	addl $1, secv_curenta_de_0

	movl spatiu_necesar, %eax
	cmp secv_curenta_de_0, %eax
	je inlocuire_valori

	incl %ebx
    cmpl $1023, %ebx
    jle cauta_pe_linia_data
	jmp cauta_in_toate_liniile

inlocuire_valori:
	movl start, %ebx
    lea memory, %edi
scimbare_valori_start_end:
	movl descriptor_fisier, %eax
    movl %eax, (%edi, %ebx, 4)
    incl %ebx
    cmpl end, %ebx
    jle scimbare_valori_start_end     #ACTUALIZEZ stiva pentru fisierul citit


    pushl end_de_afisat
    pushl indice_linie
    pushl start_de_afisat
    pushl indice_linie
    pushl descriptor_fisier
    pushl $formatOutput
    call printf
    addl $24, %esp


end_cautare_secv:
    jmp et_loop_add

fisierul_nu_are_loc:
pushl $0
pushl $0
pushl $0
pushl $0
pushl descriptor_fisier
pushl $formatOutput
call printf
addl $24, %esp
jmp et_loop_add

end_ADD:
    mov %ebp, %esp
    popl %ebp
    ret

##################################
GET:
    pushl %ebp
    mov %esp, %ebp

    #parcurg toata matricea
    #caut descriptorul de fisier
    #start unde il gasesc prima oara
    #end unde il gasesc ultima oara
    #linie pe linia pe care l am gasit


    pushl $descriptor_fisier_get
    pushl $formatScanf
    call scanf
    addl $8, %esp						#INPUT 	descriptor_fisier_get

    lea memory, %edi
    movl $-1, indice_linie_get
parcurge_liniile_get:
	movl $0, %ebx
    addl $1, indice_linie_get
    cmpl $1023, indice_linie_get
	jg negasit
parcurge_elementele_get:


	movl $1024, %eax
	mull indice_linie_get
	add %ebx, %eax
    movl (%edi, %eax, 4), %ecx
	cmpl %ecx, descriptor_fisier_get
	je gasit

	incl %ebx
	cmpl $1023, %ebx
	jle parcurge_elementele_get
	jmp parcurge_liniile_get

negasit:
	#afiseaza ((0,0),(0,0))

	pushl $0
    pushl $0
    pushl $0
    pushl $0
    pushl $formatGet
    call printf
    addl $20, %esp

	jmp end_GET

gasit:
	movl %ebx, start_get

	gaseste_end_get:
	incl %ebx
	cmpl $1023, %ebx
	jg stiu_end_get
	movl $1024, %eax
	mull indice_linie_get
	add %ebx, %eax
    movl (%edi, %eax, 4), %ecx
	cmpl %ecx, descriptor_fisier_get
	je gaseste_end_get

	stiu_end_get:
	decl %ebx
	movl %ebx, end_get



	pushl end_get
    pushl indice_linie_get
    pushl start_get
    pushl indice_linie_get
    pushl $formatGet
    call printf
    addl $20, %esp



end_GET:
    mov %ebp, %esp
    popl %ebp
    ret
##################################
DELETE:
    pushl %ebp
    mov %esp, %ebp
   #parcurg toata memoria
   #daca gasesc un element egal cu descriptorul
   #pun 0 pe pozitia lui
   #afisarea e putin mai complicata


    pushl $descriptor_fisier_del
    pushl $formatScanf
    call scanf
    addl $8, %esp						#INPUT 	descriptor_fisier_del




    lea memory, %edi
    movl $-1, indice_linie_del
parcurge_liniile_del:
	movl $0, %ebx
    addl $1, indice_linie_del
    cmpl $1023, indice_linie_del
	jg sfarsit_parcurgere
parcurge_elementele_del:


	movl $1024, %eax
	mull indice_linie_del
	add %ebx, %eax
    movl (%edi, %eax, 4), %ecx
	cmpl %ecx, descriptor_fisier_del
	jne elementul_NU_este_cel_cautat
	movl $0, (%edi, %eax, 4)


	elementul_NU_este_cel_cautat:
	incl %ebx
	cmpl $1023, %ebx
	jle parcurge_elementele_del
	jmp parcurge_liniile_del
	sfarsit_parcurgere:


   lea memory, %edi
   movl $-1, indice_linie_del

afisare_del:
parcurge_liniile_del_afisare:
	movl $0, %ebx
    addl $1, indice_linie_del
    cmpl $1023, indice_linie_del
	jg end_DEL

	movl $1024, %eax
	mull indice_linie_del					#pun primul element in descriptor_afisare_del
	addl %ebx, %eax							#pun start la 0
    movl (%edi, %eax, 4), %ecx
    movl %ecx, descriptor_afisare_del
    movl $0, start_del
    addl $1, %ebx
parcurge_elementele_del_afisare:
	#compar elementul curent cu descriptor _afisare
	#daca sunt egale nu fac nimic
	#daca nu end primeste ebx-1, print, descriptor_afisare = valoarea curenta, start = ebx
	movl $1024, %eax
	mull indice_linie_del
	add %ebx, %eax
    movl (%edi, %eax, 4), %ecx

    cmpl %ecx, descriptor_afisare_del
    je sunt_egale

	movl %ebx, %edx
	decl %edx
	movl %edx, end_del

	print_del:
	cmpl $0, descriptor_afisare_del
	je nu_printez_valorile_de_0

	pushl end_del
	pushl indice_linie_del
	pushl start_del
	pushl indice_linie_del
	pushl descriptor_afisare_del
	pushl $formatOutput
	call printf
	addl $24, %esp

	nu_printez_valorile_de_0:

	cmpl $1023, %ebx
	je parcurge_liniile_del_afisare

	movl $1024, %eax
	mull indice_linie_del
	addl %ebx, %eax
    movl (%edi, %eax, 4), %ecx
    movl %ecx, descriptor_afisare_del
    movl %ebx, start_del

	sunt_egale:
	incl %ebx
	cmpl $1023, %ebx
	jl parcurge_elementele_del_afisare
	movl %ebx, end_del
	jmp print_del
end_DEL:
	mov %ebp, %esp
    popl %ebp
    ret
    ################################
    DEFRAGMENTATION:
        pushl %ebp
        mov %esp, %ebp
       #imi iau un vector care sa tina toti descritptorii in ordine si lungimea lor(in blocuri)
       #salvez aceste date intr un vector
       #parcurg matricea pe linii si vad daca imi incape lungimea urmatorului fisier o pun
       #daca nu pun 0 pana la finalul liniei si trec pe linia urmatoare

        #initializez vectorul cu 0
         xorl %eax, %eax
        lea vector_dfg, %ecx
        movl $0, %edx
    loop_initializare_vector_dfg:
        movl %eax, (%ecx, %edx, 4)
        incl %edx
        cmpl $1048575, %edx
          jle loop_initializare_vector_dfg   #INITIALIZARE MEMORIE


        #

        movl $0, indice_vector
        lea memory, %edi
    	movl $-1, indice_linie_dfg
    parcurge_toate_liniile_dfg:

    	addl $1, indice_linie_dfg
    	cmpl $1023, indice_linie_dfg
    	jg end_seteaza_vectorul
    	movl $0, %ebx

        movl $1024, %eax
    	mull indice_linie_dfg
    	add %ebx, %eax
        movl (%edi, %eax, 4), %ecx

        movl %ecx, descriptor_curent_dfg
        movl $1, secventa_curenta_dfg
        incl %ebx
    parcurgere_elemente_dfg:
    	#ecx primeste -> indice_linie*10 +ebx

    	movl $1024, %eax
    	mull indice_linie_dfg
    	add %ebx, %eax
        movl (%edi, %eax, 4), %ecx

        cmpl %ecx, descriptor_curent_dfg
        je continua_secventa_dfg


        sfarseste_secventa_dfg:
        #pun in vector descriptorul, lungimea curenta daca descriptorul e nenul
        cmpl $0, descriptor_curent_dfg
        je descriptor_nul_dfg

        lea vector_dfg, %ecx
        movl indice_vector, %eax
        movl descriptor_curent_dfg, %edx
        movl %edx, (%ecx, %eax, 4)

        addl $1, indice_vector
        movl indice_vector, %eax

        movl secventa_curenta_dfg, %edx
        movl %edx, (%ecx, %eax, 4)
        addl $1, indice_vector



        ##
        cmpl $1023, %ebx
        jg parcurge_toate_liniile_dfg

        descriptor_nul_dfg:
        incl %ebx
        movl $1024, %eax
    	mull indice_linie_dfg
    	add %ebx, %eax
        movl (%edi, %eax, 4), %ecx

        movl %ecx, descriptor_curent_dfg
        movl $1, secventa_curenta_dfg


        cmpl $1023, %ebx
        jle parcurgere_elemente_dfg
    	jmp parcurge_toate_liniile_dfg


        continua_secventa_dfg:
        addl $1, secventa_curenta_dfg
        incl %ebx
        cmpl $1023, %ebx
        jle parcurgere_elemente_dfg
    	jmp sfarseste_secventa_dfg

    	end_seteaza_vectorul:


        ##acum am vectorul setat
        ##il pun in matrice.
        ##o umplu mai intai de 0 uri
        ##stiu ca elementele nu pot avea o lungime care depaseste lungimea liniei(din cerinta)
        ##pe fiecare linie pun elementul curent. verific daca mai incap
        ##daca da pun si verific in continuare
        ##daca nu pun 0 pana la final


        xorl %eax, %eax
        lea memory, %edi
        movl $0, %ecx
    loop_reinitializare_vector:
        movl %eax, (%edi, %ecx, 4)
        incl %ecx
        cmpl $1048575, %ecx
        jle loop_reinitializare_vector   #Umplere matrice cu 0(ca sa nu mai fac asta la final)


        movl indice_vector, %eax
        shr $1, %eax
        movl %eax, indice_vector ##in indice_vector tin acum numarul de fisiere din matrice

    	lea memory, %edi
    	movl $0, counter
    	movl $0 , indice_linie_dfg
    	movl $0 , %ebx

    	urmatorul_fisier:

    	movl counter, %eax
    	shl $1, %eax
    	incl %eax
    	lea vector_dfg, %ecx
    	movl (%ecx, %eax, 4), %edx    #lungime_dfg = counter*2+1
    	movl %edx, lungime_dfg


    	## 0 1 2 3 4 5 6 7 8 9
    	movl $1024, %eax
    	subl %ebx, %eax

    	cmpl %eax, lungime_dfg

    	jle pune_fisier

    	creste_linie:
    	movl $0, %ebx
    	addl $1, indice_linie_dfg


    	pune_fisier:

    	lea vector_dfg, %ecx #(ecx , 2 ori counter+ 1, 4)=lungime si (ecx, 2 ori counter, 4)= descriptor
    	#et_debug:
    	movl counter, %eax
    	shl $1, %eax
    	movl (%ecx, %eax, 4), %edx
    	movl %edx, descriptor_de_repus
    	incl %eax
    	movl (%ecx, %eax, 4), %edx
    	movl %edx, lungime_dfg

    	loop_punere_fisier:

    	cmpl $0, lungime_dfg
    	jle fisier_pus
    	decl lungime_dfg

    	movl $1024, %eax
    	mull indice_linie_dfg
    	addl %ebx, %eax

    	movl descriptor_de_repus , %edx
    	movl %edx, (%edi, %eax , 4)
    	incl %ebx
    	jmp loop_punere_fisier
    	fisier_pus:
    	addl $1, counter
    	movl counter, %eax
    	cmpl indice_vector, %eax
    	jg afisare_dfg

    	jmp urmatorul_fisier

    afisare_dfg:

    	lea memory, %edi
       movl $-1, indice_linie_dfg_afisare
    parcurge_liniile_dfg_afisare:
    	movl $0, %ebx
        addl $1, indice_linie_dfg_afisare
        cmpl $1023, indice_linie_dfg_afisare
    	jg end_DFG							#!!!#afisare_2 pentru matrice

    	movl $1024, %eax
    	mull  indice_linie_dfg_afisare
    	addl %ebx, %eax
        movl (%edi, %eax, 4), %ecx
        movl %ecx, descriptor_afisare_dfg
        movl $0, start_dfg
        addl $1, %ebx
    parcurge_elementele_dfg_afisare:

    	movl $1024, %eax
    	mull indice_linie_dfg_afisare
    	add %ebx, %eax
        movl (%edi, %eax, 4), %ecx

        cmpl %ecx, descriptor_afisare_dfg
        je sunt_egale_dfg

    	movl %ebx, %edx
    	decl %edx
    	movl %edx, end_dfg

    	print_dfg:
    	cmpl $0, descriptor_afisare_dfg
    	je nu_printez_valorile_de_0_dfg

    	pushl end_dfg
    	pushl indice_linie_dfg_afisare
    	pushl start_dfg
    	pushl indice_linie_dfg_afisare
    	pushl descriptor_afisare_dfg
    	pushl $formatOutput
    	call printf
    	addl $24, %esp

    	nu_printez_valorile_de_0_dfg:

    	cmpl $1023, %ebx
    	je parcurge_liniile_dfg_afisare

    	movl $1024, %eax
    	mull indice_linie_dfg_afisare
    	addl %ebx, %eax
        movl (%edi, %eax, 4), %ecx
        movl %ecx, descriptor_afisare_dfg
        movl %ebx, start_dfg

    	sunt_egale_dfg:
    	incl %ebx
    	cmpl $1023, %ebx
    	jl parcurge_elementele_dfg_afisare
    	movl %ebx, end_dfg
    	jmp print_dfg


    end_DFG:
        mov %ebp, %esp
        popl %ebp
        ret
    ################################
    CONCRETE:
        pushl %ebp
        mov %esp, %ebp



        push $dir_path
        push $formatScanfstring
        call scanf
        addl $8, %esp         # INPUT dir_path

        push $dir_path
        call opendir
        add $4, %esp
        movl %eax, dirp

        cmp $0, %eax
        je eroare_deschidere_folder

        read_loop:

        movl dirp, %eax
        pushl %eax
        call readdir
        add $4, %esp
        cmpl $0, %eax
        je end_read_loop     #daca readdir returneaza 0 s au terminat fisierele din folder

        addl $11, %eax
        mov %eax, %ebx
        mov %ebx, num_fisier


          push $punct
          push num_fisier
          call strcmp
          add $8, %esp
          cmpl $0, %eax
          je close_file

          push $punctpunct
          push num_fisier
          call strcmp
          add $8, %esp
          cmpl $0, %eax
          je close_file        #daca fisierul contine doar "." sau ".." trec la urmatorul

          pushl num_fisier
          pushl $dir_path
          pushl $formatprintstring
          pushl $512
          pushl $full_file_path
          call snprintf
          addl $20, %esp

          #pushl $full_file_path
          #pushl $error
          #call printf
          #addl $8, %esp


          ####
        push $0
        push $full_file_path
        call open
        addl $8, %esp         # DESCHIDERE fisier
        movl %eax, fd

        etdebug:
        xorl %edx, %edx
        movl $255, %ecx
        div %ecx
        addl $1, %edx
        mov %edx, fd_fictiv         #ASOCIERE fd
        #AICI STIU FDS (VERIFIC SA NU FIE NEGATIV)

        cmpl $-1, fd
        jg nu_e_negativ
        pushl $error1
        pushl $error
        call printf
        addl $8, %esp
        jmp close_file
        nu_e_negativ:



        mov fd, %ecx
        lea fileStat, %eax
        push %eax
        push %ecx
        call fstat
        addl $8, %esp         # APELARE fstat


        lea fileStat, %ecx
        movl 44(%ecx), %eax   #eax tine acum FILESIZE(in bytes)

        xorl %edx, %edx
        movl $1024, %ecx
        divl %ecx
        movl %eax, spatiu_necesar_con


        ##ACUM STIU fd_fictiv SI spatiu_necesar_con SI DOAR LE DAU ADD DACA POT
        pushl spatiu_necesar_con
        pushl fd_fictiv
        pushl $fd_si_dimensiune
        call printf
        addl $12, %esp

        cmpl $253, fd
        jg nu_adaug_fisierul_in_memorie
        adaug_fisierul_in_memorie:

        xorl %edx, %edx
        movl spatiu_necesar_con, %eax
        movl $8, %ecx
        divl %ecx
        testl %edx, %edx
        je et_dimensiune_fisier_divizila_8_con
        incl %eax
        et_dimensiune_fisier_divizila_8_con:
        movl %eax, spatiu_necesar_con


        lea memory, %edi
        movl $-1, indice_linie_con
        cauta_in_toate_liniile_con:
        	addl $1, indice_linie_con
        	cmpl $1023, indice_linie_con
        	jg fisierul_nu_are_loc_con
        	movl $0, %ebx
        	movl $0, secv_curenta_de_0_con
        cauta_pe_linia_data_con:
        	movl $1024, %eax
        	mull indice_linie_con
        	add %ebx, %eax
            movl (%edi, %eax, 4), %ecx

        	cmp $0, %ecx
        	je element_zero_con



        	movl $0, secv_curenta_de_0_con
        	incl %ebx
            cmpl $1023, %ebx
            jle cauta_pe_linia_data_con
        	jmp cauta_in_toate_liniile_con

        element_zero_con:
        	cmpl $0, secv_curenta_de_0_con
        	jne nu_seta_start_con
        	movl $1024, %eax
        	mull indice_linie_con
        	add %ebx, %eax
        	movl %eax, start_con
        	movl %ebx, start_de_afisat_con
        	nu_seta_start_con:
        	movl $1024, %eax
        	mull indice_linie_con
        	add %ebx, %eax
        	movl %eax, end_con
        	movl %ebx, end_de_afisat_con
        	addl $1, secv_curenta_de_0_con

        	movl spatiu_necesar_con, %eax
        	cmp secv_curenta_de_0_con, %eax
        	je inlocuire_valori_con

        	incl %ebx
            cmpl $1023, %ebx
            jle cauta_pe_linia_data_con
        	jmp cauta_in_toate_liniile_con

        inlocuire_valori_con:
        	movl start_con, %ebx
            lea memory, %edi
        scimbare_valori_start_end_con:
        	movl fd_fictiv, %eax
            movl %eax, (%edi, %ebx, 4)
            incl %ebx
            cmpl end_con, %ebx
            jle scimbare_valori_start_end_con     #ACTUALIZEZ stiva pentru fisierul citit


            pushl end_de_afisat_con
            pushl indice_linie_con
            pushl start_de_afisat_con
            pushl indice_linie_con
            pushl fd_fictiv
            pushl $formatOutput
            call printf
            addl $24, %esp


        end_cautare_secv_cnc:
            jmp close_file


        fisierul_nu_are_loc_con:
        pushl $0
        pushl $0
        pushl $0
        pushl $0
        pushl fd_fictiv
        pushl $formatOutput
        call printf
        addl $24, %esp
        jmp close_file


        nu_adaug_fisierul_in_memorie:

        pushl $0
        pushl $0
        pushl $0
        pushl $0
        pushl fd_fictiv
        pushl $formatOutput
        call printf
        addl $24, %esp
        jmp close_file

          ####
        close_file:

        jmp read_loop

          mov dirp, %eax
          push %eax
          call closedir
          add $4, %esp        #INCHID folderul

        jmp end_CONCRETE

        eroare_deschidere_folder:
        push $error2
        push $error
        call printf
        addl $8, %esp
        jmp end_CONCRETE

        end_read_loop:


    end_CONCRETE:
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
        cmpl $1048575, %ecx
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
    	je et_DEFRAGMENTATION
    	cmpl $5, %eax
    	je et_CONCRETE					#Selector operatie

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
    et_CONCRETE:
    	call CONCRETE
    	jmp et_loop_operatie

    et_exit:
      pushl $0
      call fflush
      add $4, %esp

      movl $1, %eax
      xorl %ebx, %ebx
      int $0x80
