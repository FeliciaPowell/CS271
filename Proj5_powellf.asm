TITLE "Randomizing and Generating Integer Arrays!"     (Proj5_powellf.asm)

; Author: Felicia Powell
; Last Modified: 5/30/2023*
; OSU email address: powellf@oregonstate.edu
; Course number/section:   CS271 Section 402
; Project Number:    5            Due Date: 5/28/2023
; Description: This program creates a random array with 200 elements, ranging in value from 15 to 50. It involves the subprocedures:
; introduction, fillArray, sortList, exchangeElements, displayMedian, displayList, and countList.
; In main it writes defines that it will print the introduction to inform the user about the program. Then it will create a random unsorted
; array from fillArray subprocedure. From there it will print the median of the array. Afterwards it will utilize the exchangeElements within the
; sortList subprocedure which can then be called to sort the previously random array into numbers in ascending order. After that section, it will
; utilize countList to count the frequency of how many numbers were printed in the array, for example if the number 15 was printed 7 times,
; it would start with 7. Then at the end it prints out a farewell statement to the user.

; *Please note that I am using 2 Grace Days for this assignment and therefore, shall be "late")


INCLUDE Irvine32.inc

; (insert macro definitions here)

; (insert constant definitions here)
ARRAYSIZE		EQU		200
LO				EQU		15
HI				EQU		50

.data

; (insert variable definitions here)
introTitleName			BYTE		"Randomizing and Generating Integer Arrays!				by Felicia Powell",13,10,13,10,0
instruct1				BYTE		"This program takes 200 randomly generated integers, between the values of 15 and 50.",13,10,0
instruct2				BYTE		"It will take those numbers, find the median value and also sort them in a separate list.",13,10,0
instruct3               BYTE        "Finally, it will take those numbers, find how often each value was repeated within the array,",13,10, "and print that amount from lowest to highest value:",13,10,0
goodbye                 BYTE        "Thank you for using 'Randomizing and Generating Integer Arrays!' I hope you have a lovely day, thanks!",13,10,13,10,0
unsortedPrompt			BYTE		"Your list of random unsorted numbers:",13,10,0
medianPrompt			BYTE		"The median value of your array: ",0
sortedPrompt			BYTE		"Your list of random sorted numbers:",13,10,0
instancesPrompt			BYTE		"Your list of instances of each generated number, starting with the smallest value:",13,10,0
randArray				DWORD		ARRAYSIZE DUP(?)
counts					DWORD		(HI - LO + 1) DUP(?)
randVal					DWORD		?
medianRoundUpVal        DWORD       ?
space					BYTE		" ",0


.code
main PROC

	mov     EAX, OFFSET randArray                             ; Get the address of randArray
    mov     ECX, ARRAYSIZE                                    ; Set the loop counter to ARRAYSIZE
    
    ; print the introduction title
    call    introduction
    call    CrLf
    call    CrLf

    ; prints the title for the unsorted list
    mov     EDX, OFFSET unsortedPrompt
    call    WriteString                                      ; "Your list of random unsorted numbers:"

    ; fills the array with random numbers
    call    Randomize
    call    fillArray

    ; prints the unsorted array
    call    displayList
    call    CrLf
    call    CrLf

    ; prints the title for the median
    mov     EDX, OFFSET medianPrompt
    call    WriteString                                      ; "The median value of your array:"

    ; prints the mEDIan value
    call    displayMedian
    call    CrLf
    call    CrLf

    ; prints the title for the sorted list
    mov     EDX, OFFSET sortedPrompt
    call    WriteString                                      ; "Your list of random sorted numbers:"

    ; sorts the array
    call sortList                                           ; If this is COMMENTED OUT then you will see more of the code, I don't know why it is doing this

    ; prints the sorted array
    call    displayList
    call    CrLf
    call    CrLf

    ; prints the title for the frequency of numbers printed, lowest to highest
    mov     EDX, OFFSET instancesPrompt
    call    WriteString                                      ; "Your list of instances of each generated number, starting with the smallest value:"

    ; generates the counts array
    call    countList                                        ; If this (and sortList) is COMMENTED OUT then you will see more of the code, I don't know why it is doing this

    ; prints the list of frequencies
    call    displayList

    ; say farewell
    call    CrLf
    call    CrLf
    mov		EDX, OFFSET goodbye							
	call	WriteString									    ; "Thank you for using 'Randomizing and Generating Integer Arrays!' I hope you have a lovely day, thanks!"
	call	CrLf

main ENDP
	Invoke ExitProcess,0	; exit to operating system

; (insert additional procedures here)

; -----------------------------------------------------------------------------------------------------------------------------------------------------


; Name: introduction
;
; Prints the program title and my name as the author, then it informs the user
; of the instructions to follow.
;
; Preconditions: None
;
; Postconditions: Prompts are displayed on the output
;
; Receives: introTitleName, instruct1, instruct2, instruct3
;
; Returns: None

introduction PROC

	; title and name
	mov		EDX, OFFSET introTitleName
	call	WriteString									; "Randomizing and Generating Integer Arrays!				by Felicia Powell"
	call	CrLf

	mov		EDX, OFFSET instruct1
	call	WriteString									; "This program takes 200 randomly generated integers, between the values of 15 and 50."

	mov		EDX, OFFSET instruct2						
	call	WriteString									; "It will take those numbers, find the mEDIan value and also sort them in a separate list."

	mov		EDX, OFFSET instruct3						
	call	WriteString									; "Finally, it will take those numers, find how often each value was repeated within the array 
														; and print that amount from lowest to highest value."


	ret
introduction ENDP


; -----------------------------------------------------------------------------------------------------------------------------------------------------


; Name: fillArray
;
; Description: This procedure fills the randArray with random numbers within the specified range.
;
; Preconditions: The range (LO and HI) should be properly initialized.
;
; Postconditions: The randArray is filled with random numbers within the range (LO and HI).
;
; Receives: None
;
; Returns: None

fillArray PROC USES EBX ESI EDI

    mov     ECX, ARRAYSIZE                                   
    mov     ESI, OFFSET randArray                           

fillLoop:
    call    RandomRange                                     ; Generate a random number between 0 and (HI - LO)
    add     EAX, LO                                         ; Add LO to the random number

    cmp     EAX, HI                                         ; Compare the generated number with HI
    ja      regenerateNumber                                
    cmp     EAX, LO                                         ; Compare the generated number with LO
    jb      regenerateNumber                                

    mov     [ESI], EAX                                      ; Store the random number in the current element of randArray
    add     ESI, 4                                          ; next element
    loop    fillLoop                                        ; Repeat

    jmp     fillEnd

regenerateNumber:
    call    RandomRange                                     ; Regenerate a random number if it exceeded the range
    jmp     fillLoop

fillEnd:


    ret
fillArray ENDP


; -----------------------------------------------------------------------------------------------------------------------------------------------------


; Name: sortList
;
; Description: Sorts the array in ascending order
;
; Preconditions: The array to be sorted is in randArray
;
; Postconditions: The array is sorted in ascending order
;
; Receives: None
;
; Returns: None

sortList PROC
    push    ECX                                            ; Preserve ECX
    push    ESI                                            ; Preserve ESI
    push    EDI                                            ; Preserve EDI

    mov     ECX, ARRAYSIZE                                  
    mov     ESI, OFFSET randArray                           

    outerLoop:
        mov     EDI, ECX                                    ; Copy the outer loop counter to EDI
        dec     EDI                                         ; Decrement EDI to use as an index

        innerLoop:
            mov     EAX, [ESI + EDI * 4]                    ; Load the current element into EAX
            mov     EBX, [ESI + EDI * 4 + 4]                ; Load the next element into EBX

            cmp     EAX, EBX                                ; Compare the current element with the next element
            jbe     skipSwap                                

            ; Swap the elements
            mov     EDX, [ESI + EDI * 4]                    ; Move the current element to EDX
            mov     [ESI + EDI * 4], EBX                    ; Move the next element to the current element's position
            mov     [ESI + EDI * 4 + 4], EDX                ; Move the temporary element (current element) to the next element's position

        skipSwap:
            dec     EDI                                     ; Decrement the inner loop counter
            cmp     EDI, 0                                  
            jnz     innerLoop                               

        dec     ECX                                         ; Decrement the outer loop counter
        cmp     ECX, 0                                     
        jnz     outerLoop                                   

    pop     EDI                                             ; Restore EDI
    pop     ESI                                             ; Restore ESI
    pop     ECX                                             ; Restore ECX

    ret
sortList ENDP


; -----------------------------------------------------------------------------------------------------------------------------------------------------


; Name: exchangeElements
;
; Description: Swaps two elements in the array
;
; Preconditions: The addresses of the elements to be swapped are in ESI and EDX
;
; Postconditions: The elements are swapped in the array
;
; Receives: ESI - Address of the first element
;           EDX - Address of the second element
;
; Returns: None

exchangeElements PROC USES EBX ESI EDI

    push    EBX
    push    EAX
    mov     EBX, EAX                                        ; Load the value at address pointed by ESI into EBX
    mov     EAX, EDX                                        ; Load the value at address pointed by EDX into EAX
    mov     [ESI], EAX                                      ; Store the value from EAX at the address pointed by ESI
    mov     [EDX], EBX                                      ; Store the value from EBX at the address pointed by EDX

    pop     EAX
    pop     EBX

	ret
exchangeElements ENDP


; -----------------------------------------------------------------------------------------------------------------------------------------------------


; Name: displayMedian
;
; Description: This procedure finds and displays the median value of the randArray.
;
; Preconditions: The randArray should be properly initialized and contain valid elements.
;
; Postconditions: The median value of the randArray is displayed.
;
; Receives: None
;
; Returns: None

displayMedian PROC USES ESI

    mov     ESI, OFFSET randArray                           ; Point to the start of randArray
    mov     ECX, ARRAYSIZE                                  ; Set the loop counter to ARRAYSIZE

    ; Find the middle element index
    mov     EAX, ARRAYSIZE
    xor     EDX, EDX
    mov     EBX, 2
    div     EBX                                             ; Divide ARRAYSIZE by 2

    ; Check if ARRAYSIZE is even
    cmp     EDX, 0
    je      evenLength                                       
    jne     oddLength                                        

    evenLength:
        sub     EAX, 1                                       ; Subtract 1 from the index to account for 0-based indexing
        mov     EAX, [ESI + EAX * 4]                         ; Load the element at the middle index into EAX
        jmp     medianFound

    oddLength:
        mov     EAX, [ESI + EAX * 4]                         ; Load the element at the middle index into EAX

    medianFound:
        ; Display the median value
        mov     EDX, OFFSET medianPrompt                      
        call    WriteString                                   ; "The median value of your array: "
        call    WriteDec                                      
        call    CrLf


	ret
displayMedian ENDP


; -----------------------------------------------------------------------------------------------------------------------------------------------------



; Name: displayList
;
; Description: This procedure displays the elements of the randArray.
;
; Preconditions: The randArray should be properly initialized and contain valid elements.
;
; Postconditions: The elements of the randArray are displayed.
;
; Receives: None
;
; Returns: an array

displayList PROC

    push    ECX                                            ; Preserve ECX
    push    ESI                                            ; Preserve ESI

    mov     ECX, ARRAYSIZE                                  
    mov     ESI, OFFSET randArray                           

    printLoop:
        mov     EAX, [ESI]                                  ; Load the current element of randArray into EAX
        call    WriteDec                                    ; value stored in EAX

        mov     EDX, OFFSET space                           
        call    WriteString                                 ; " "           *I know I will probably be docked points but I couldn't figure out how to do it without calling on it

        add     ESI, 4                                      ; Move to the next element of randArray

        sub     ECX, 1                                      ; Decrement the loop counter

        cmp     ECX, 0                                      ; Check if all elements have been printed
        je      finishPrint                                 ; Jump to finishPrint if all elements have been printed

        mov     EDX, ARRAYSIZE                              ; Load the maximum number of elements to print in a line
        sub     EDX, ECX                                    ; Calculate the number of elements printed so far

        mov     EAX, EDX                                    ; Store the number of elements printed so far in EAX
        xor     EDX, EDX                                    ; Clear EDX
        mov     EBX, 20                                     ; Store the desired number of elements per line in EBX
        div     EBX                                         ; Divide EAX by EBX (number of elements per line)

        cmp     EDX, 0                                      ; Check if EDX is zero (indicating 20 elements have been printed)
        je      newLine                                     

        jmp     continuePrint                               ; Jump to continuePrint if the conditions are not met

    newLine:
        call    CrLf                                        ; Move to the next line

    continuePrint:
        jmp     printLoop                                   ; Jump to printLoop to continue the loop

    finishPrint:
        call    CrLf                                        ; Move to the next line after printing all elements

    pop     ESI                                             ; Restore ESI
    pop     ECX                                             ; Restore ECX

	ret
displayList ENDP


; -----------------------------------------------------------------------------------------------------------------------------------------------------



; Name: countList
;
; Description: This procedure counts the occurrences of each element in the randArray.
;
; Preconditions: The randArray should be properly initialized and contain valid elements.
;
; Postconditions: The counts array will be updated with the frequency of each element in the randArray.
;
; Receives: None
;
; Returns: None

countList PROC
    
    push    ECX                                             ; Preserve ECX
    push    ESI                                             ; Preserve ESI
    push    EDI                                             ; Preserve EDI

    mov     ECX, ARRAYSIZE                                  
    mov     ESI, OFFSET randArray                           

    ; Clear the counts array
    mov     EDI, OFFSET counts
    mov     ECX, HI - LO + 1                                ; Set the loop counter to the range of values
    xor     EAX, EAX
    rep     stosd                                           ; Set all elements of counts array to zero

    outerLoop:
        mov     EDI, ECX                                    ; Copy the outer loop counter to EDI
        dec     EDI                                         ; Decrement EDI to use as an index

        innerLoop:
            mov     EAX, [ESI + EDI * 4]                    ; Load the current element into EAX
            mov     EBX, [ESI + EDI * 4 + 4]                ; Load the next element into EBX

            cmp     EAX, EBX                                ; Compare the current element with the next element
            jbe     skipSwap                                ; Jump if the current element is less than or equal to the next element

            ; Swap the elements
            mov     EDX, [ESI + EDI * 4]                    ; Move the current element to EDX
            mov     [ESI + EDI * 4], EBX                    ; Move the next element to the current element's position
            mov     [ESI + EDI * 4 + 4], EDX                ; Move the temporary element (current element) to the next element's position

        skipSwap:
            mov     EAX, EDI
            shl     EAX, 3                                  ; Multiply EDI by 8 (4 * 2)
            add     EAX, EDI                                ; Add EDI to the result
            shl     EAX, 2                                  ; Multiply by 4
            add     EAX, OFFSET counts
            add     dword ptr [EAX], 1

            dec     EDI                                     ; Decrement the inner loop counter
            cmp     EDI, 0                                  ; Compare with zero
            jnz     innerLoop                               

        dec     ECX                                         ; Decrement the outer loop counter
        cmp     ECX, 0                                      ; Compare with zero
        jnz     outerLoop                                   

    ; Copy the results back to randArray
    mov     ECX, ARRAYSIZE                                  ; Set the loop counter to ARRAYSIZE
    mov     ESI, OFFSET counts                              ; Point to the start of the counts array
    mov     EDI, OFFSET randArray                           ; Point to the start of the randArray

    copyLoop:
        mov     EAX, [ESI]                                  ; Load the current count from counts array
        rep     stosd                                       ; Store the count in randArray

        add     ESI, 4                                      ; Move to the next element in the counts array
        dec     ECX                                         ; Decrement the loop counter
        jnz     copyLoop                                   

    pop     EDI                                             ; Restore EDI
    pop     ESI                                             ; Restore ESI
    pop     ECX                                             ; Restore ECX


    ret
countList ENDP


; -----------------------------------------------------------------------------------------------------------------------------------------------------



END main
