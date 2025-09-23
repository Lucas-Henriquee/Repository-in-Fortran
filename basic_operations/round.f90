! Testando arredondamento em divisões entre inteiros e reais

program prog

    implicit none

    real(kind=8) :: r1, r2, r3, r4, r5
    real(kind=8) :: r_r1, r_r2
    integer :: i1, i2, i3, i4, i5, i6, i7
    integer :: i_r1, i_r2, i_r3, i_r4, i_r5
    integer :: i_r6, i_r7, i_r8, i_r9, i_r10

    i1 = 3; i2=4; i3=5; i4=6; i5=7; i6=8; i7=9

    r1=3.0d0; r2=4.0d0; r3=5.0d0; r4=6.0; r5=7.0d0

    i_r1=i1/i2; i_r2=i2/i2; i_r3=i3/i2
    i_r4=i4/i2; i_r5=i5/i2; i_r6=i6/i2
    i_r7=i7/i2; i_r8=i6/r1; i_r9=i7/r1
    i_r10=i1/r1

    r_r1 = i5/r3
    r_r2 = r1/i6

    write(*,*) ":-) Resultado - Intero (-:"
    write(*,*) "3/4=",i_r1, "4/4=",i_r2, "5/4=", i_r3
    write(*,*) "6/4=", i_r4, "7/4=", i_r5, "8/4=", i_r6
    write(*,*) "9/4", i_r7
    write(*,*) "8/30=", i_r8, "9/3.0=", i_r9, "3/3.0=", i_r10
    write(*,*) ":-) Resultado - Real (-:"
    write(*,*) "7/5.0=", r_r1, "3.0/8=", r_r2

stop
end program prog
