# divide.asm
This test divides the number stored in $a0 (default 52) by the value stored in $a1 (default 5). It stores the quotient in $v0 (default 10) and the remainder in $v1 (default 2).

# verybasicstacktest.asm
This is a very basic test to test pushing and popping items onto/from the stack. It stores two values into $t0 and $t1 (default 0x42 and 0x17, respectively), pushes them onto the stack, does a quick XORI test to simulate a separate function running (stores 0xAA in $t4, then XORs it with 0xFF, resulting in 0x55 stored in $t4), then pops the two values off of the stack into $t2 and $t3 (which should end up as 0x42 and 0x17, respectively).