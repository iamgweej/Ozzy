.macro isrGenerate n
    .align 4
    .type isr\n, @function
    .global isr\n

    isr\n:
        cli
        // Push a dummy error code for interrupts that don't have one.
        .if (\n != 8 && !(\n >= 10 && \n <= 14) && \n != 17)
            push $0
        .endif
        push $\n       // Push the interrupt number.
        jmp isrCommon  // Jump to the common handler.
.endmacro

// Common code for all Interrupt Service Routines.
isrCommon:
    pusha

    mov %ds, %ax
    push %eax

    mov $0x10, %ax
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs

    push %esp
    call isrHandler
    
    // I dont trust the stack to contain a valid pointer
    pop %eax

    pop %eax
    mov %ax, %ds
    mov %ax, %fs
    mov %ax, %gs
    mov %ax, %es

    popa
    add $8, %esp
    sti
    iret
.type isrCommon, @function

// Exceptions.
isrGenerate 0
isrGenerate 1
isrGenerate 2
isrGenerate 3
isrGenerate 4
isrGenerate 5
isrGenerate 6
isrGenerate 7
isrGenerate 8
isrGenerate 9
isrGenerate 10
isrGenerate 11
isrGenerate 12
isrGenerate 13
isrGenerate 14
isrGenerate 15
isrGenerate 16
isrGenerate 17
isrGenerate 18
isrGenerate 19
isrGenerate 20
isrGenerate 21
isrGenerate 22
isrGenerate 23
isrGenerate 24
isrGenerate 25
isrGenerate 26
isrGenerate 27
isrGenerate 28
isrGenerate 29
isrGenerate 30
isrGenerate 31
