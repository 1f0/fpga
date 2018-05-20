
 add_fsm_encoding \
       {uart_transmitter.tstate} \
       { }  \
       {{000 000} {001 010} {010 011} {011 101} {100 100} {101 001} }

 add_fsm_encoding \
       {uart_receiver.rstate} \
       { }  \
       {{0000 0000} {0001 0001} {0010 0011} {0011 0101} {0100 0110} {0101 1000} {0110 0010} {0111 0100} {1000 0111} {1001 1001} {1010 1010} }

 add_fsm_encoding \
       {parallel2serial.state} \
       { }  \
       {{000 000} {001 001} {010 010} {011 011} }

 add_fsm_encoding \
       {parallel2serial__parameterized0.state} \
       { }  \
       {{000 00010} {001 00100} {010 01000} {011 10000} }
