# Proiect-ASC

#Memory/File Management System

This project is an assignment written in assembly language (x86, AT&T syntax) that simulates a file memory management system. The project is divided into two tasks that extend the basic functionalities and offer a progressive approach to memory management challenges.
Description

The project implements a set of operations for managing files within a simulated memory space:

    ADD: Adds a file to the simulated memory. For each file, it calculates the required space (in 8-byte blocks) and searches for a continuous sequence of free blocks to store the file's descriptor.
    GET: Searches for and displays the interval (start, end) where a file (identified by its descriptor) is located in the simulated memory.
    DELETE: Removes a file from memory by setting the blocks occupied by it to zero and displaying the resulting configuration.
    DEFRAGMENTATION: Rearranges memory blocks to compact the files and eliminate "holes" (unused blocks) between them.

Task 2 extends the functionality by implementing:

    An expanded memory space (4 MB compared to 4096 bytes in Task 1).
    The CONCRETE operation: Traverses a specified directory, reads information from files (name, size, etc.), and, if space is available, integrates the file data into the simulated memory.

Functionalities

    Task 1:
        ADD: Inserting files into the virtual memory.
        GET: Finding the position of a file in memory.
        DELETE: Removing a file from memory.
        DEFRAGMENTATION: Rearranging the memory to eliminate free spaces between files.

    Task 2:
        All operations from Task 1, adapted for a larger memory space (4 MB) and organized in rows.
        CONCRETE: Additional functionality for traversing a directory from the file system, opening files, and adding them to the simulated memory (if possible).



# Sistem de Management al Memoriei/Fişiere în Assembly

        Acest proiect este o temă scrisă în limbaj de asamblare (x86, AT&T syntax) care simulează un sistem de gestionare a memoriei pentru fișiere. Proiectul este împărțit în două task-uri ce extind funcționalitățile de bază și oferă o abordare progresivă a problemelor de management al memoriei.
        Descriere

        Proiectul implementează un set de operații pentru gestionarea fișierelor într-un spațiu de memorie simulat:

            ADD: Adaugă un fișier în memoria simulată. Pentru fiecare fișier, se calculează spațiul necesar (în blocuri de 8 octeți) și se caută o secvență continuă de blocuri libere pentru a stoca descriptorul fișierului.
            GET: Caută și afișează intervalul (start, end) în care se află un fișier (identificat prin descriptor) în memoria simulată.
            DELETE: Elimină un fișier din memorie, setând blocurile ocupate de acesta la zero și afișând configurația rezultată.
            DEFRAGMENTATION: Reorganizează blocurile de memorie pentru a compacta fișierele și a elimina "găurile" (blocurile neutilizate) dintre ele.

        Task-ul 2 extinde funcționalitatea implementând:

            Un spațiu de memorie extins (4 MB față de 4096 octeți în Task 1).
            Operația CONCRETE: Parcurge un director specificat, citește informațiile din fișiere (nume, mărime etc.), și, dacă există spațiu, integrează datele fișierelor în memoria simulată.

        Funcționalități

            Task 1:
                ADD: Inserarea fișierelor în memoria virtuală.
                GET: Găsirea poziției unui fișier în memorie.
                DELETE: Ștergerea unui fișier din memorie.
                DEFRAGMENTATION: Reorganizarea memoriei pentru a elimina spațiile libere între fișiere.

            Task 2:
                Toate operațiile din Task 1, adaptate pentru un spațiu de memorie mai mare (4 MB) și organizare pe linii.
                CONCRETE: Funcționalitate suplimentară de parcurgere a unui director din sistemul de fișiere, deschiderea fișierelor și adăugarea acestora în memoria simulată (dacă este posibil).


  Author: Andrei Cristea
