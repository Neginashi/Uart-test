# Uart-test


WRITE:

input: W XX YYYYYYYY ( XX: address, YY: data, X = 1'h0 ~ 1'hA, Y = 1'h0 ~ 1'hA )

output: OK ( no errors in the format ) 
        FAIL ( errors in the format )
        
        
READ:

input: R XX ( XX: address, X = 1'h0~1'hA )

output: YYYYYYYY ( YYYYYYYY: data )
