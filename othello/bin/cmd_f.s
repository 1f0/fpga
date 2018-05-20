main:
	addi  $t0,  $0,   0xFF
	lui   $t1,  0xd000
	lui   $t2,  0xd001
	addi  $t2,  $t2,  0x2C00
	lui   $s0,  0xc000
	lui   $s1,  0xa000
	lui   $s2,  0x9000
	addi  $sp,  $0,   0x1000   #-1
#call print_head
	addi  $a0,  $s0,  0
	jal   print_head
#call clear
	addi  $a0,  $s0,  0
	jal   clear
#end call
echo:
	addi  $s3,  $s3,  0        #shft code
	addi  $s4,  $s4,  0        #last code
	addi  $s5,  $s5,  0        #scan code
	addi  $s6,  $s6,  0        #counter
read_kbd:
	addi  $s4,  $s5,  0        #last<-key
read_lop:
	lw    $t0,  0($s1)
	andi  $t1,  $t0,  0x0100
	lui   $t2,  0x14           #cnt half
	bne   $s6,  $t2,  blink
#blink cur
	addi  $t3,  $0,   0x5F
	sw    $t3,  0($s0)
	j     cnt_plus_1
blink:
	lui   $t2,  0x28           #cnt max
	bne   $s6,  $t2,  cnt_plus_1
	addi  $s6,  $0,   0
	sw    $0,   0($s0)
cnt_plus_1:
	addi  $s6,  $s6,  1
	beq   $t1,  $0,   read_lop
#read in key
	sw    $0,   0($s0)         #disvalid cur
	andi  $s5,  $t0,  0xff
	addi  $t0,  $0,   0x12
	beq   $s5,  $t0,  prs_shft
	addi  $t0,  $0,   0x59
	beq   $s5,  $t0,  prs_shft
	addi  $t0,  $0,   0xe0
	beq   $s5,  $t0,  read_kbd
	addi  $t0,  $0,   0xf0
	beq   $s5,  $t0,  read_kbd
	beq   $s4,  $t0,  read_kbd
#   beq   $s5,  0xe0  ex_key
s_to_asc:
	addi  $t0,  $0,   0x66
	beq   $t0,  $s5,  Backspace
	addi  $t0,  $0,   0x5a
	beq   $t0,  $s5,  Enter
	sll   $t0,  $s5,  2
	lw    $t0,  0($t0)
	bne   $s3,  $0,   conv_shft
	andi  $t0,  $t0,  0xff
	j     print_asc
conv_shft:
	srl   $t0,  $t0,  8
print_asc:
	beq   $t0,  $0,   read_kbd
	sw    $t0,  0($s0)
	addi  $s0,  $s0,  4
	lui   $t0,  0xc000
	addi  $t0,  $t0,  0x4B00
	bne   $t0,  $s0,  read_kbd
#call page_down
	addi  $a0,  $s0,  0
	jal   page_down
	j     read_kbd
prs_shft:
	addi  $t0,  $0,   0xf0
	addi  $s3,  $0,   0
	beq   $t0,  $s4,  read_kbd
	addi  $s3,  $0,   1
	j     read_kbd
Backspace:
	lw    $t0,  0($0)
	beq   $t0,  $s0,  read_kbd
	addi  $s0,  $s0,  0xFFFC   #-4
	sw    $0,   0($s0)
	j     read_kbd
Enter:
	andi  $t0,  $s0,  0xFFFF
	slti  $t1,  $t0,  0x49BC
	bne   $t1,  $0,   match
#call page_down
	addi  $a0,  $s0,  0
	jal   page_down
#---------------------------------
match:
	lw    $t2,  0($0)
	addi  $t0,  $0,   99
	lw    $t1,  0($t2)
	bne   $t0,  $t1,  if_gem
	addi  $t0,  $0,   108
	lw    $t1,  4($t2)
	bne   $t0,  $t1,  if_gem
	addi  $t0,  $0,   114
	lw    $t1,  8($t2)
	bne   $t0,  $t1,  if_gem
	lw    $t1,  12($t2)
	bne   $0,   $t1,  if_gem
	lui   $a0,  0xc000
	jal   clear
	lui   $a0,  0xc000
	lui   $s0,  0xc000
	jal   print_head
	j     read_kbd
if_gem:
	addi  $t0,  $0,   103
	lw    $t1,  0($t2)
	bne   $t0,  $t1,  if_Othe
	addi  $t0,  $0,   101
	lw    $t1,  4($t2)
	bne   $t0,  $t1,  if_Othe
	addi  $t0,  $0,   109
	lw    $t1,  8($t2)
	bne   $t0,  $t1,  if_Othe
	lw    $t1,  12($t2)
	bne   $0,   $t1,  if_Othe
	lui   $a0,  0xc000
	jal   gem
	j     match_end
if_Othe:
	addi  $t0,  $0,   79
	lw    $t1,  0($t2)
	bne   $t0,  $t1,  if_Help
	addi  $t0,  $0,   116
	lw    $t1,  4($t2)
	bne   $t0,  $t1,  if_Help
	addi  $t0,  $0,   104
	lw    $t1,  8($t2)
	bne   $t0,  $t1,  if_Help
	addi  $t0,  $0,   101
	lw    $t1,  12($t2)
	bne   $t0,  $t1,  if_Help
	lw    $t1,  16($t2)
	bne   $0,   $t1,  if_Help
	lui   $a0,  0xc000
	jal   Othello
	j     match_end
if_Help:
	addi  $t0,  $0,   72
	lw    $t1,  0($t2)
	bne   $t0,  $t1,  match_end
	addi  $t0,  $0,   101
	lw    $t1,  4($t2)
	bne   $t0,  $t1,  match_end
	addi  $t0,  $0,   108
	lw    $t1,  8($t2)
	bne   $t0,  $t1,  match_end
	addi  $t0,  $0,   112
	lw    $t1,  12($t2)
	bne   $t0,  $t1,  match_end
	lw    $t1,  16($t2)
	bne   $0,   $t1,  match_end
	addi  $a0,  $s0,  0
	jal   Help
#---------
match_end:
	andi  $t0,  $s0,  0xFFFF
calc_offset:
	addi  $t0,  $t0,  0xFEC0
	slti  $t1,  $t0,  0
	beq   $t1,  $0,   calc_offset
	sub   $s0,  $s0,  $t0
#call print_head
	addi  $a0,  $s0,  0
	jal   print_head
	j     read_kbd
clear:
	lui   $t0,  0xc000
	ori   $t0,  $t0,  0x4B00   #4800*4
clr_lop:
	sw    $0,   0($a0)
	addi  $a0,  $a0,  4
	bne   $a0,  $t0,  clr_lop
	jr    $ra
print_head:
	addi  $t0,  $0,   0x003E
	sw    $t0,  0($a0)
	sw    $t0,  4($a0)
	sw    $0,   8($a0)
	addi  $s0,  $s0,  12      #move cur
	sw    $s0,  0($0)
	jr    $ra
page_down:
	addi  $sp,  $sp,  0xFFFC  #-4
	sw    $ra,  0($sp)        #store ra
	lw    $t0,  0($0)
	lui   $s0,  0xc000
	addi  $s0,  $s0,  12
	sw    $s0,  0($0)
judge_str_end:
	beq   $t0,  $a0,  cpy_done
	lw    $t1,  0($t0)
	sw    $t1,  0($s0)
	addi  $t0,  $t0,  4
	addi  $s0,  $s0,  4
	j     judge_str_end
cpy_done:
#call clear
	addi  $a0,  $s0,  0
	jal   clear
	lw    $ra,  0($sp)
	addi  $sp,  $sp,  4
	jr    $ra
Help:
	addi  $a0,  $a0,  292
	addi  $t0,  $0,   0x49
	sw    $t0,  0($a0)
	addi  $t0,  $0,   0x4E
	sw    $t0,  4($a0)
	addi  $t0,  $0,   0x56
	sw    $t0,  8($a0)
	addi  $t0,  $0,   0x41
	sw    $t0,  12($a0)
	addi  $t0,  $0,   0x4C
	sw    $t0,  16($a0)
	addi  $t0,  $0,   0x49
	sw    $t0,  20($a0)
	addi  $t0,  $0,   0x44
	sw    $t0,  24($a0)
	addi  $s0,  $s0,  320
	jr    $ra
Othello:
#store
addi	$sp,	$sp,	0xFFE8
  sw	$ra,	20	($sp)
  sw	$s4,	16	($sp)
  sw	$s3,	12	($sp)
  sw	$s2,	8	($sp)
  sw	$s1,	4	($sp)
  sw	$s0,	0	($sp)
#--------------------------------------------
addi	$t0,	$zero,	1
 lui	$t1,	0x9000
  sw	$t0,	0($t1)
addi	$t8,	$zero,	8
addi	$t7,	$zero,	7
init:
#draw board
#5,5----|
#|      |
#|      |
#|-----14,14
addi	$s2,	$zero,	0	#color
addi	$t6,	$zero,	0x2F35	#75*160+85
addi	$t7,	$zero,	0
addi	$t8,	$zero,	8
addi	$s0,	$zero,	805     #5*160+5
addi	$s1,	$zero,	2254    #14*160+14
Othe_draw_board:
 add	$a0,	$s0,	$zero
 add	$a1,	$s1,	$zero
addi	$k0,	$zero,	8
#Othe_draw_board:
 beq	$s2,	$zero,	skip_bright_green
addi	$k0,	$zero,	0x10
skip_bright_green:
 jal	draw_rect
xori	$s2,	$s2,	1
addi	$s0,	$s0,	10
addi	$s1,	$s1,	10
addi	$t7,	$t7,	1
 beq	$s0,	$t6,	prepare_chess
 beq	$t7,	$t8,	Othe_next_line
   j	Othe_draw_board
Othe_next_line:
xori	$s2,	$s2,	1
addi	$t7,	$zero,	0
addi	$s0,	$s0,	1520
addi	$s1,	$s1,	1520
   j	Othe_draw_board
#---------------------------------------------
prepare_chess:
addi	$t0,	$zero,	376
addi	$t1,	$zero,	632
loop1:
  sw	$zero,	0	($t0)
addi	$t0,	$t0,	4
 bne	$t0,	$t1,	loop1
addi	$t0,	$zero,	1
  sw	$t0,	484	($zero)
  sw	$t0,	520	($zero)
addi	$t0,	$zero,	2
  sw	$t0,	488	($zero)
  sw	$t0,	516	($zero)
addi	$s0,	$zero,	3		#i
addi	$s1,	$zero,	3		#j
  sw	$s0,	636	($zero)
  sw	$s1,	640	($zero)
#init board-------------------------
addi	$k0,	$zero,	0x1F	#selected blue
addi	$a0,	$zero,	3
addi	$a1,	$zero,	3
 jal	draw_small_rect
addi	$k0,	$zero,	7		#nonselected blue
addi	$a0,	$zero,	3
addi	$a1,	$zero,	3
 jal	draw_circle
addi	$a0,	$zero,	4
addi	$a1,	$zero,	4
 jal	draw_circle
 addi	$k0,	$zero,	0xE4	#nonselected Red
addi	$a0,	$zero,	3
addi	$a1,	$zero,	4
 jal	draw_circle
addi	$a0,	$zero,	4
addi	$a1,	$zero,	3
 jal	draw_circle
#------------------------------------------
addi	$s2,	$zero,	1		#who
addi	$s3,	$zero,	2		#rev
addi	$t2,	$zero,	0		#last_key
addi	$t3,	$zero,	0
roll:
 lui	$a0,	0xa000
  lw	$t3,	0	($a0)		#1a0
andi	$t1,	$t3,	0x100	#1a4
 beq	$t1,	$zero,	roll	#1a8 ready or not?
addi	$t2,	$t0,	0
andi	$t0,	$t3,	0xff
addi	$t3,	$zero,	0xf0
 beq	$t2,	$t3,	roll
   j	which_key
#--------------------------------------------------
#------------recover---------------------
roll2:
andi	$t0,	$a0,	1
andi	$t1,	$a1,	1
 xor	$t0,	$t0,	$t1
addi	$k0,	$zero,	16
 bne	$t0,	$zero,	s_skip_color
addi	$k0,	$zero,	8
s_skip_color:
 jal	draw_small_rect
#---------------------------------------
addi	$t0,	$0,		2
addi	$k0,	$zero,	0x1F
 beq	$t0,	$s3,	s_skip_color2
addi	$k0,	$zero,	0xE3
s_skip_color2:
addi	$a0,	$at,	0
addi	$a1,	$k1,	0
 jal	draw_small_rect
#-------------------------------------------------
   j	roll
#--------------------------------------------------
which_key:
#prepare argument
addi	$t7,	$zero,	7
addi	$a0,	$s0,	0
addi	$a1,	$s1,	0
#--------------------------------------------------
addi	$t1,	$zero,	0x0076	#ESC:sw3 1c0
 bne	$t0,	$t1,	s8		#1c4
   j	end_Othe				#1cc
s8:
addi	$t1,	$zero,	0x004D	#P:sw3 1c0
 bne	$t0,	$t1,	s7		#1c4
   j	init					#1cc
s7:
addi	$t1,	$zero,	0x001D	#W:1d4
 bne	$t0,	$t1,	s6		#1d8 1dc
 beq	$s0,	$zero,	roll	#1e0 1e4
addi	$s0,	$s0,	0xffff	#1e8
  sw	$s0,	636	($zero)		#1ec
addi	$at,	$s0,	0
addi	$k1,	$s1,	0
   j	roll2
s6:
addi	$t1,	$zero,	0x001B	#S:1f8
 bne	$t0,	$t1,	s5		#1fc 200
 beq	$s0,	$t7,	roll	#204 208
addi	$s0,	$s0,	1		#20c
  sw	$s0,	636	($zero)		#210
addi	$at,	$s0,	0
addi	$k1,	$s1,	0
   j	roll2
s5:
addi	$t1,	$zero,	0x001C	#A 21c
 bne	$t0,	$t1,	s4		#220 224
 beq	$s1,	$zero,	roll	#228 22C
addi	$s1,	$s1,	0xffff	#230
addi	$at,	$s0,	0
addi	$k1,	$s1,	0
   j	roll2
s4:
addi	$t1,	$zero,	0x0023	#D 240
 bne	$t0,	$t1,	s1		#244 248
 beq	$s1,	$t7,	roll	#24c 250
addi	$s1,	$s1,	1		#254
  sw	$s1,	640	($zero) 	#258
addi	$at,	$s0,	0
addi	$k1,	$s1,	0
   j	roll2
s1:
addi	$t1,	$zero,	0x0042	#K 264
 bne	$t0,	$t1,	s0		#268 26c
addi	$t2,	$s2,	0		#SWAP
addi	$s2,	$s3,	0
addi	$s3,	$t2,	0
addi	$t0,	$0,		2
addi	$k0,	$zero,	0x1F
 beq	$t0,	$s3,	s1_skip_color2
addi	$k0,	$zero,	0xE3
s1_skip_color2:
addi	$a0,	$s0,	0
addi	$a1,	$s1,	0
 jal	draw_small_rect
s0:
addi	$t1,	$zero,	0x003B	#J 270
 bne	$t0,	$t1,	roll	#274 278
#--------------------------------------------
#addi	$t0,	$s1,	0
# add	$t0,	$t0,	$t0		#y*8
# add	$t0,	$t0,	$t0
# add	$t0,	$t0,	$t0
 sll	$t0,	$s1,	3
 add	$t0,	$t0,	$s0		#y*8+x
 sll	$t0,	$t0,	2
addi	$t0,	$t0,	376		#(y*8+x+94)*4
#add	$t0,	$t0,	$t0
#add	$t0,	$t0,	$t0
  lw	$t1,	0	($t0)		#t1=B[x][y]
 bne	$t1,	$zero,	roll
addi	$s4,	$zero,	0		#suc=false
addi	$t7,	$zero,	7
#--------------move left----------------------
 beq	$s0,	$zero,	right	#left,i==0?
addi	$t0,	$t0,	0xfffc	#t0-=4
  lw	$t1,	0	($t0)		#t1=B[x][y]
addi	$t0,	$t0,	4		#t0+=4
 bne	$t1,	$s3,	right	#B[x][y]!=rev
addi	$t2,	$s0,	0		#t2:x=i
xss:
addi	$t2,	$t2,	0xffff	#x--
addi	$t0,	$t0,	0xfffc
  lw	$t1,	0	($t0)		#t1=B[x][y]
 beq	$t1,	$zero,	bac1
 beq	$t2,	$zero,	bac1	#x>0
 beq	$t1,	$s2,	bac1
   j	xss
bac1:
addi	$t2,	$t2,	1		#x++
addi	$t0,	$t0,	4		#t0+=4
 beq	$t2,	$s0,	suc1	#x<i
 bne	$t1,	$s2,	bac1	#t1!=who break
  sw	$s2,	0	($t0)		#B[x][y]=who
addi	$a0,	$t2,	0
addi	$a1,	$s1,	0
 jal	draw_big_rect
   j	bac1
suc1:
 bne	$t1,	$s2,	right	#t1!=who break
addi	$s4,	$zero,	1		#suc==true
#--------------move right-----------------------
right:
 beq	$s0,	$t7,	up		#right i==7?
addi	$t0,	$t0,	4		#t0+=4
  lw	$t1,	0	($t0)		#t1=B[x][y]
addi	$t0,	$t0,	0xfffc	#t0-=4
 bne	$t1,	$s3,	up		#B[x][y]!=rev
addi	$t2,	$s0,	0		#t2:x=i
xpp:
addi	$t2,	$t2,	1		#x++
addi	$t0,	$t0,	4
  lw	$t1,	0	($t0)		#t1=B[x][y]
 beq	$t1,	$zero,	bac2
 beq	$t2,	$t7,	bac2	#x<7
 beq	$t1,	$s2,	bac2
   j	xpp
bac2:
addi	$t2,	$t2,	0xffff	#x--
addi	$t0,	$t0,	0xfffc	#t0-=4
 beq	$t2,	$s0,	suc2	#x>i
 bne	$t1,	$s2,	bac2	#t1!=who break
  sw	$s2,	0	($t0)		#B[x][y]=who
addi	$a0,	$t2,	0
addi	$a1,	$s1,	0
 jal	draw_big_rect
   j	bac2
suc2:
 bne	$t1,	$s2,	up		#t1!=who break
addi	$s4,	$zero,	1		#suc==true
#--------------move up----------------------
up:
 beq	$s1,	$zero,	down	#down,j==0?
addi	$t0,	$t0,	0xffe0	#t0-=8*4
  lw	$t1,	0	($t0)		#t1=B[x][y]
addi	$t0,	$t0,	32		#t0+=4
 bne	$t1,	$s3,	down	#B[x][y]!=rev
addi	$t2,	$s1,	0		#t2:y=j
yss:
addi	$t2,	$t2,	0xffff	#y--
addi	$t0,	$t0,	0xffe0
  lw	$t1,	0	($t0)		#t1=B[x][y]
 beq	$t1,	$zero,	bac3
 beq	$t2,	$zero,	bac3	#y>0
 beq	$t1,	$s2,	bac3
   j	yss
bac3:
addi	$t2,	$t2,	1		#y++
addi	$t0,	$t0,	32		#t0+=4
 beq	$t2,	$s1,	suc3	#y<j
 bne	$t1,	$s2,	bac3	#t1!=who break
  sw	$s2,	0	($t0)		#B[x][y]=who
addi	$a0,	$s0,	0
addi	$a1,	$t2,	0
 jal	draw_big_rect
   j	bac3
suc3:
 bne	$t1,	$s2,	down	#t1!=who break
addi	$s4,	$zero,	1		#suc==true
#----------------move down----------------------
down:
 beq	$s1,	$t7,	LU		#down,j==7?
addi	$t0,	$t0,	32		#t0+=8*4
  lw	$t1,	0	($t0)		#t1=B[x][y]
addi	$t0,	$t0,	0xffe0	#t0-=4*8
 bne	$t1,	$s3,	LU		#B[x][y]!=rev
addi	$t2,	$s1,	0		#t2:x=j
ypp:
addi	$t2,	$t2,	1		#y++
addi	$t0,	$t0,	32
  lw	$t1,	0	($t0)		#t1=B[x][y]
 beq	$t1,	$zero,	bac4
 beq	$t2,	$t7,	bac4	#y<7
 beq	$t1,	$s2,	bac4
   j	ypp
bac4:
addi	$t2,	$t2,	0xffff	#y--
addi	$t0,	$t0,	0xffe0	#t0-=4*8
 beq	$t2,	$s1,	suc4	#y>j
 bne	$t1,	$s2,	bac4	#t1!=who break
  sw	$s2,	0	($t0)		#B[x][y]=who
addi	$a0,	$s0,	0
addi	$a1,	$t2,	0
 jal	draw_big_rect
   j	bac4
suc4:
 bne	$t1,	$s2,	LU		#t1!=who break
addi	$s4,	$zero,	1		#suc==true
#----------------move LU----------------------
LU:
 beq	$s0,	$zero,	RD		#i==0?
 beq	$s1,	$zero,	RD		#j==0?
addi	$t0,	$t0,	0xffdc	#t0-=4*8+4
  lw	$t1,	0	($t0)		#t1=B[x][y]
addi	$t0,	$t0,	36		#t0+=36
 bne	$t1,	$s3,	RD		#B[x][y]!=rev
addi	$t2,	$s0,	0		#t2:x=i
addi	$t3,	$s1,	0		#t3:y=j
xyss:
addi	$t2,	$t2,	0xffff	#x--
addi	$t3,	$t3,	0xffff	#y--
addi	$t0,	$t0,	0xffdc
  lw	$t1,	0	($t0)		#t1=B[x][y]
 beq	$t1,	$zero,	bac5
 beq	$t2,	$zero,	bac5	#x>0
 beq	$t3,	$zero,	bac5	#y>0
 beq	$t1,	$s2,	bac5
   j	xyss
bac5:
addi	$t2,	$t2,	1		#x++
addi	$t3,	$t3,	1		#x++
addi	$t0,	$t0,	36		#t0+=36
 beq	$t2,	$s0,	suc5	#x<i
 bne	$t1,	$s2,	bac5	#t1!=who break
  sw	$s2,	0	($t0)		#B[x][y]=who
addi	$a0,	$t2,	0
addi	$a1,	$t3,	0
 jal	draw_big_rect
   j	bac5
suc5:
 bne	$t1,	$s2,	RD		#t1!=who break
addi	$s4,	$zero,	1		#suc==true
#--------------move RD------------------------
RD:
 beq	$s0,	$t7,	LD		#down,i==7?
 beq	$s1,	$t7,	LD		#down,j==7?
addi	$t0,	$t0,	36		#t0+=4*8+4
  lw	$t1,	0	($t0)		#t1=B[x][y]
addi	$t0,	$t0,	0xffdc	#t0-=36
 bne	$t1,	$s3,	LD		#B[x][y]!=rev
addi	$t2,	$s0,	0		#t2:x=i
addi	$t3,	$s1,	0		#t3:y=j
xypp:
addi	$t2,	$t2,	1		#x++
addi	$t3,	$t3,	1		#y++
addi	$t0,	$t0,	36	
  lw	$t1,	0	($t0)		#t1=B[x][y]
 beq	$t1,	$zero,	bac6
 beq	$t2,	$t7,	bac6	#x<7
 beq	$t3,	$t7,	bac6	#y<7
 beq	$t1,	$s2,	bac6
   j	xypp
bac6:
addi	$t2,	$t2,	0xffff	#x--
addi	$t3,	$t3,	0xffff	#y--
addi	$t0,	$t0,	0xffdc	#t0-=36
 beq	$t2,	$s0,	suc6	#x>i
 bne	$t1,	$s2,	bac6
  sw	$s2,	0	($t0)		#B[x][y]=who
addi	$a0,	$t2,	0
addi	$a1,	$t3,	0
 jal	draw_big_rect
   j	bac6
suc6:
 bne	$t1,	$s2,	LD		#t1!=who break
addi	$s4,	$zero,	1		#suc==true
#----------------move LD------------------------
LD:
 beq	$s0,	$zero,	RU		#down,i==0?
 beq	$s1,	$t7,	RU		#down,j==7?
addi	$t0,	$t0,	28		#t0+=4*8-4
  lw	$t1,	0	($t0)		#t1=B[x][y]
addi	$t0,	$t0,	0xffe4	#t0-=28
 bne	$t1,	$s3,	RU		#B[x][y]!=rev
addi	$t2,	$s0,	0		#t2:x=i
addi	$t3,	$s1,	0		#t3:y=j
xsyp:
addi	$t2,	$t2,	0xffff	#x--
addi	$t3,	$t3,	1		#y++
addi	$t0,	$t0,	28
  lw	$t1,	0	($t0)		#t1=B[x][y]
 beq	$t1,	$zero,	bac7
 beq	$t2,	$zero,	bac7	#x>0
 beq	$t3,	$t7,	bac7	#y<7
 beq	$t1,	$s2,	bac7
   j	xsyp
bac7:
addi	$t2,	$t2,	1		#x++
addi	$t3,	$t3,	0xffff	#y--
addi	$t0,	$t0,	0xffe4	#t0-=28
 beq	$t2,	$s0,	suc7	#x<i
 bne	$t1,	$s2,	bac7
  sw	$s2,	0	($t0)		#B[x][y]=who
addi	$a0,	$t2,	0
addi	$a1,	$t3,	0
 jal	draw_big_rect
   j	bac7
suc7:
 bne	$t1,	$s2,	RU		#t1!=who break
addi	$s4,	$zero,	1		#suc==true
#----------------move RU------------------------
RU:	
 beq	$s0,	$t7,	Oth_END		#down,i==7?
 beq	$s1,	$zero,	Oth_END		#down,j==0?
addi	$t0,	$t0,	0xffe4	#t0-=4*8-4
  lw	$t1,	0	($t0)		#t1=B[x][y]
addi	$t0,	$t0,	28		#t0+=28
 bne	$t1,	$s3,	Oth_END		#B[x][y]!=rev
addi	$t2,	$s0,	0		#t2:x=i
addi	$t3,	$s1,	0		#t3:y=j
xpys:
addi	$t2,	$t2,	1		#x++
addi	$t3,	$t3,	0xffff	#y--
addi	$t0,	$t0,	0xffe4
  lw	$t1,	0	($t0)		#t1=B[x][y]
 beq	$t1,	$zero,	bac8
 beq	$t2,	$t7,	bac8	#x<7
 beq	$t3,	$zero,	bac8	#y>0
 beq	$t1,	$s2,	bac8
   j	xpys
bac8:
addi	$t2,	$t2,	0xffff	#x--
addi	$t3,	$t3,	1		#y++
addi	$t0,	$t0,	28		#t0+=28
 beq	$t2,	$s0,	suc8	#x>i
 bne	$t1,	$s2,	bac8
  sw	$s2,	0	($t0)		#B[x][y]=who
addi	$a0,	$t2,	0
addi	$a1,	$t3,	0
 jal	draw_big_rect
   j	bac8
suc8:
 bne	$t1,	$s2,	Oth_END	#t1!=who break
addi	$s4,	$zero,	1		#suc==true
#------------------------------------------------
Oth_END:
 beq	$s4,	$zero,	roll
  sw	$s2,	0	($t0)		#B[x][y]=who
addi	$a0,	$s0,	0
addi	$a1,	$s1,	0
 jal	draw_big_rect
addi	$t2,	$s2,	0		#SWAP
addi	$s2,	$s3,	0
addi	$s3,	$t2,	0
#
addi	$t0,	$0,		2
addi	$k0,	$zero,	0x1F
 beq	$t0,	$s3,	Oth_END_skip_color
addi	$k0,	$zero,	0xE3
Oth_END_skip_color:
addi	$a0,	$s0,	0
addi	$a1,	$s1,	0
 jal	draw_small_rect
   j	roll
end_Othe:
addi	$a0, $0,  805
addi	$a1, $0,  0x3575
addi	$k0, $0,  0xFF
 jal	draw_rect
  lw	$ra,	20	($sp)
  lw	$s4,	16	($sp)
  lw	$s3,	12	($sp)
  lw	$s2,	8	($sp)
  lw	$s1,	4	($sp)
  lw	$s0,	0	($sp)
 lui	$t0,	0x9000
  sw	$zero,	0($t0)
addi	$sp,	$sp,	24
  jr	$ra
#------------------------------------------------
draw_rect:
	sub   $t0, $a1, $a0
calc_rect_wid:
	slti  $t1, $t0, 160
	bne   $t1, $0,  draw_rect_begin
	addi  $t0, $t0, 0xFF60
	j     calc_rect_wid
draw_rect_begin:
#	addi  $t0, $t0, 1
	addi  $t1, $0,  0
draw_rect_lop:
	lui   $t4, 0xd000
	add   $t2, $a0, $t1
	sll   $t3, $t2, 2
	add   $t4, $t4, $t3
	sw    $k0, 0($t4)
	beq   $t2, $a1, end_draw_dect
	beq   $t1, $t0, rect_next_line
	addi  $t1, $t1, 1
	j     draw_rect_lop
rect_next_line:
	addi  $t1, $0,  0
	addi  $a0, $a0, 160
	j     draw_rect_lop
end_draw_dect:
	jr    $ra
#----------------------------------------------
draw_circle:
	addi  $sp, $sp, 0xFFFC
	sw    $ra, 0($sp)
	sll   $t0, $a0, 1
	sll   $t1, $a0, 3
	add   $t0, $t0, $t1
	sll   $t1, $a1, 6
	sll   $t2, $a1, 9
	add   $t1, $t1, $t2
	sll   $t2, $a1, 10
	add   $t1, $t1, $t2
	add   $t0, $t0, $t1
	addi  $a0, $t0, 1127  #(160*i+j)*10+160*7+7
	addi  $a1, $a0, 805   #160*6+6
	jal   draw_rect
	lw    $ra, 0($sp)
	addi  $sp, $sp, 4
	jr    $ra
#----------------------------------------------
draw_small_rect:
	addi  $sp, $sp, 0xFFFC
	sw    $ra, 0($sp)
	sll   $t0, $a1, 1
	sll   $t1, $a1, 3
	add   $t0, $t0, $t1
	sll   $t1, $a0, 6
	sll   $t2, $a0, 9
	add   $t1, $t1, $t2
	sll   $t2, $a0, 10
	add   $t1, $t1, $t2
	add   $t0, $t0, $t1
	addi  $a0, $t0, 805   #(160*i+j)*10+160*5+5
	addi  $a1, $a0, 161   #160*1+1
	jal   draw_rect
	lw    $ra, 0($sp)
	addi  $sp, $sp, 4
	jr    $ra
#----------------------------------------------
gem:
	addi  $sp, $sp, 0xFFFC
	sw    $ra, 0($sp)
	addi  $t1, $0,  1
	lui   $t0, 0x9000
	sw    $t1, 0($t0)
	addi  $k0, $0,  0x8  #color
#GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG
	addi  $a0, $0,  4825 #30*160+30
	addi  $a1, $0,  4805 #30*160+10
	jal   draw_line
	addi  $a0, $0,  4805 #30*160+10
	addi  $a1, $0,  8005 #50*160+10
	jal   draw_line
	addi  $a0, $0,  8005
	addi  $a1, $0,  8025
	jal   draw_line
	addi  $a0, $0,  8025
	addi  $a1, $0,  6425 #40*160+30
	jal   draw_line
	addi  $a0, $0,  6425
	addi  $a1, $0,  6415
	jal   draw_line
#===================================
#EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
	addi  $a0, $0,  4830 #30*160+40
	addi  $a1, $0,  8030 #50*160+40
	jal   draw_line
	addi  $a0, $0,  8030 #50*160+40
	addi  $a1, $0,  8050 #50*160+60
	jal   draw_line
	addi  $a0, $0,  4830
	addi  $a1, $0,  4850
	jal   draw_line
	addi  $a0, $0,  6430
	addi  $a1, $0,  6450 #40*160+60
	jal   draw_line
#===================================
#MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
	addi  $a0, $0,  4855 #30*160+30
	addi  $a1, $0,  8055 #50*160+10
	jal   draw_line
	addi  $a0, $0,  4855 #30*160+10
	addi  $a1, $0,  4865 #50*160+10
	jal   draw_line
	addi  $a0, $0,  4865
	addi  $a1, $0,  8065
	jal   draw_line
	addi  $a0, $0,  4865
	addi  $a1, $0,  4875 #40*160+30
	jal   draw_line
	addi  $a0, $0,  4875
	addi  $a1, $0,  8075
	jal   draw_line
#===================================
gem_last_screen:
	addi  $t0, $0,  0
	lui   $t1, 0xF0
gem_lst_scrn_loop:
	addi  $t0, $t0, 1
	bne   $t0, $t1, gem_lst_scrn_loop
	addi  $a0, $0,  4805
	addi  $a1, $0,  8075
	addi  $k0, $0,  0xFF
	jal   draw_rect
	lui   $t0, 0x9000
	sw    $0,  0($t0)
	lw    $ra, 0($sp)
	addi  $sp, $sp,	4
	jr    $ra
#===================================
draw_line:
	slt   $t0, $a1, $a0
	sub   $t1, $a1, $a0
	beq   $t0, $0,  pos_draw
#neg_draw
	addi  $t2, $0,  0xFF80
	slt   $t1, $t2, $t1
	bne   $t1, $0,  neg_ver_draw
	addi  $t0, $0,  0xFFFF
	j     draw_pic
neg_ver_draw:
	addi  $t0, $0,  0xFF60
	j     draw_pic
pos_draw:
	addi  $t2, $0,  160
	slt   $t1, $t2, $t1
	bne   $t1, $0,  pos_ver_draw
	addi  $t0, $0,  1
	j     draw_pic
pos_ver_draw:
	addi  $t0, $0,  160
	j     draw_pic
#---------------------------------
draw_pic:
	sll   $t1, $t0, 2
	lui   $t3, 0xd000
	sll   $t2, $a0, 2
	add   $t3, $t3, $t2
	lui   $t4, 0x006
draw_pix:
	addi  $t2, $0,  0
	sw    $k0,  0($t3)
	add   $a0, $a0, $t0
	add   $t3, $t3, $t1
	beq   $a0, $a1, draw_end
delay:
	addi  $t2, $t2, 1
	bne   $t2, $t4, delay
	j     draw_pix
draw_end:
	jr    $ra
#---------------------------------
draw_big_rect:			#depended on s2
addi	$t9,	$a0,	0
addi	$a0,	$a1,	0
addi	$a1,	$t9,	0
addi	$sp,	$sp,	0xFFE8	#-24
  sw	$t0,	0($sp)
  sw	$t1,	4($sp)
  sw	$t2,	8($sp)
  sw	$t3,	12($sp)
  sw	$t7,	16($sp)
  sw	$ra,	20($sp)
##>>>>>>>>>>>>>>>>>>>>>>
addi	$t0,	$0,		2
addi	$k0,	$zero,	7
 beq	$t0,	$s3,	dwbigrect_skip_color
addi	$k0,	$zero,	0xE4
dwbigrect_skip_color:
 jal	draw_circle
  lw	$t0,	0($sp)
  lw	$t1,	4($sp)
  lw	$t2,	8($sp)
  lw	$t3,	12($sp)
  lw	$t7,	16($sp)
  lw	$ra,	20($sp)
addi	$sp,	$sp,	24
  jr	$ra