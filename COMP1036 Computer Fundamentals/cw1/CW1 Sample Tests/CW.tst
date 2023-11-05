load CW.hdl,
output-file CW.out,
compare-to CW.cmp,
output-list time%S1.4.1 inID%D3.6.3 inMARK%D3.6.3 load%B3.1.3 probe%B3.1.3 address%D3.1.3 sl%B3.1.3 priority%B3.1.3 outID%D1.6.1 outMARK%D1.6.1 sum%D1.6.1 avg%D1.6.1 overflow%B3.1.3;

set inID 12345,
set inMARK 97,
set load 1,
set probe 0,
set address 2,
set sl 0,
set priority 0,
tick,
output;

tock,
output;

set inID 0,
set inMARK 0,
set load 0,
set probe 1,
set address 2,
set sl 0,
set priority 0,
tick,
output;

tock,
output;

set inID 12346,
set inMARK 79,
set load 1,
set probe 0,
set address 0,
set sl 1,
set priority 0,
tick,
output;


tock,
output;

set inID 12346,
set inMARK 0,
set load 0,
set probe 1,
set address 0,
set sl 1,
set priority 0,
tick,
output;

tock,
output;

set inID 0,
set inMARK 0,
set load 0,
set probe 1,
set address 0,
set sl 0,
set priority 1,
tick,
output;

tock,
output;

set inID 0,
set inMARK 0,
set load 0,
set probe 1,
set address 0,
set sl 0,
set priority 2,
tick,
output;

tock,
output;

set inID 0,
set inMARK 0,
set load 0,
set probe 1,
set address 0,
set sl 0,
set priority 3,
tick,
output;

tock,
output;