SECTIONS
{
	. = 1M;
 
 	.text : ALIGN(4K)
	{
		*(.multiboot)
		*(.text)
	}
    
    .rodata : ALIGN(4K)
	{
        start_ctors = .;
        *(SORT(.ctors*))
        end_ctors = .;

        start_dtors = .;
        *(SORT(.dtors*))
        end_dtors = .;

        *(.rodata*)	}
 
	.data : ALIGN(4K)
	{
		*(.data)
	}
 
	.bss : ALIGN(4K)
	{
		*(COMMON)
		*(.bss)
	}
}
