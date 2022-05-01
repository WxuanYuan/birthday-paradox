.intel_syntax noprefix
# voruebergehend main nutzen

test:
    call testNum
    call showFloat
    ret

# test with: n = 365, p = 0.5

testNum:
    mov rdi, 5
    cvtsi2ss xmm0, rdi
    mov rdi, 10
    cvtsi2ss xmm1, rdi
    divss xmm0, xmm1
    mov rdi, 365

# num Funktion: Eingabe: int n im rdi, float p im xmm0, Ausgabe: int k im rax
# parameters:
// float birthday_num(unsigned long n, float p);
.global birthday_num
birthday_num:
    mov rcx, 1
    cvtsi2ss xmm1, rcx
    subss xmm1, xmm0
    movss xmm0, xmm1            # 1-p im xmm0
    call ln                     # ln(1-p) im xmm0
    mov rax,8
    mul rdi                     # 8n im rax
    cvtsi2ss xmm1, rax
    mulss xmm1, xmm0            # 8n*ln(1-p)
    mov rcx, 1
    cvtsi2ss xmm2, rcx
    subss xmm2, xmm1            # 1-8n*ln(1-p) im xmm2
	 movss xmm0, xmm2
    call sqrt                   # wurzel im xmm0
    mov rcx, 1
    cvtsi2ss xmm1, rcx
    addss xmm1, xmm0            # 1 + wurzel im xmm1
    mov rcx, 2
    cvtsi2ss xmm0, rcx
    divss xmm1, xmm0            # (1 + wurzel)/2 im xmm1
    cvtss2si rax, xmm1
    inc rax                     # (int)xmm1+1 im rax             !!!!Warning!!!!
    ret

# debug mit x = 0.5

testLn:
    mov rax, 5
    cvtsi2ss xmm0, rax
    mov rax, 10
    cvtsi2ss xmm1, rax
    divss xmm0, xmm1
    call ln
    mov rax, 1000000000
    cvtsi2ss xmm1, rax
    mulss xmm0, xmm1
    cvtss2si rax, xmm0
    ret

# ln Funktion: Eingabe x im xmm0, Ausgabe lnx im xmm0
# parameters: float skalar im xmm1, float summe im xmm2, int rekursivCounter im rcx
# Konstante 100000000.0 im xmm4

ln:
#    mov rax, 1000000000
#    cvtsi2ss xmm4, rax         # Konstante 100000000.0 im xmm4
    mov rcx, 1                  # rekursivCounter = 1 im rcx
    mov rax, 1
	cvtsi2ss xmm1, rax
    subss xmm0, xmm1            # x - 1 im xmm0
    movss xmm1, xmm0            # skalar = x im xmm1
    mov rax, 0
    cvtsi2ss xmm2, rax          # summe = 0 im xmm2

.Taylor_L_start:
    cvtsi2ss xmm3, rcx          # (float)rekursivCounter im xmm3
    movss xmm5, xmm1
    divss xmm5, xmm3            # skalar / rekursivCounter im xmm5
    test rcx, 0x1
    jnz ungerade
gerade:
    subss xmm2, xmm5            # summe -= skalar / rekursivCounter
    jmp go_on
ungerade:
    addss xmm2, xmm5            # summe += skalar / rekursivCounter
go_on:
    inc rcx                     # rekursivCounter++
    mulss xmm1, xmm0            # skalar *= x - 1

#    mulss xmm5, xmm4
#    cvtss2si rax, xmm5
#    cmp rax, 0
    ptest xmm5, xmm5
    jne .Taylor_L_start
    movss xmm0, xmm2            # return summe
    ret

# debug mit c = 2.0

testSqrt:
    mov rax, 2
    cvtsi2ss xmm0, rax
    call sqrt
    mov rax, 10000000000
	cvtsi2ss xmm1, rax
    mulss xmm0, xmm1
    cvtss2si rax, xmm0
    ret

# sqrt Funktion:   Eingabe c im xmm0, Ausgabe sqrt(c) im xmm0
# parameters: x im xmm1, y im xmm2, 2 im xmm3, Konstante 2.0 im xmm3

sqrt:
    mov rax, 2
    cvtsi2ss xmm3, rax          # setze xmm3 2.0
    mov rax, 1000000000
    cvtsi2ss xmm7, rax          # xmm7 = 1000000000.0

    movss xmm1, xmm0            # setze xmm1 x = c
    movss xmm2, xmm0
    divss xmm2, xmm2
    addss xmm2, xmm0
    divss xmm2, xmm3            # setze xmm2 (c+1)/2.0
    jmp check_point
Loop_start:
    movss xmm1, xmm2            # x = y
    movss xmm2, xmm0
    divss xmm2, xmm1
    addss xmm2, xmm1
    divss xmm2, xmm3            # y = (x + c/x) / 2.0
	
check_point:
    movss xmm4, xmm2
    subss xmm4, xmm1
#    mulss xmm4, xmm7
#    cvtss2si rax, xmm4
#    cmp rax, 0
    ptest xmm4, xmm4
    jne Loop_start              # rekursiv laufen wenn x != y
    movss xmm0, xmm2
    ret                         # return x
	
showFloat:
    mov rax, 1000000000
    cvtsi2ss xmm2, rax
    mulss xmm2, xmm1
    cvtss2si rdx, xmm2
    ret
    