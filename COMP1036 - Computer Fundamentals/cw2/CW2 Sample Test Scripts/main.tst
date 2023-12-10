load main.asm,
output-file main.out,
compare-to main.cmp,
output-list RAM[0]%D2.6.2 RAM[11]%D2.7.2 RAM[12]%D2.7.2 RAM[13]%D2.7.2 RAM[14]%D2.7.2 RAM[15]%D2.7.2;

set PC 0,
set RAM[0] 1,
set RAM[11] 3,
set RAM[12] 2,
set RAM[13] 5,
set RAM[14] 1,
set RAM[15] 4,
repeat 500 {
  ticktock;
}
output;

set PC 0,
set RAM[0] 3,
set RAM[11] 3,
set RAM[12] 2,
set RAM[13] 5,
set RAM[14] 1,
set RAM[15] 4,
repeat 500 {
  ticktock;
}
output;

set PC 0,
set RAM[0] 5,
set RAM[11] 3,
set RAM[12] 2,
set RAM[13] 5,
set RAM[14] 1,
set RAM[15] 4,
repeat 500 {
  ticktock;
}
output;

set PC 0,
set RAM[0] -4,
set RAM[11] 3,
set RAM[12] 2,
set RAM[13] 5,
set RAM[14] 1,
set RAM[15] 4,
repeat 500 {
  ticktock;
}
output;

set PC 0,
set RAM[0] -5,
set RAM[11] 3,
set RAM[12] 2,
set RAM[13] 5,
set RAM[14] 1,
set RAM[15] 4,
repeat 500 {
  ticktock;
}
output;

set PC 0,
set RAM[0] 5,
set RAM[11] -3,
set RAM[12] -2,
set RAM[13] -5,
set RAM[14] -1,
set RAM[15] -4,
repeat 500 {
  ticktock;
}
output;

set PC 0,
set RAM[0] -5,
set RAM[11] -3,
set RAM[12] -2,
set RAM[13] -5,
set RAM[14] -1,
set RAM[15] -4,
repeat 500 {
  ticktock;
}
output;




