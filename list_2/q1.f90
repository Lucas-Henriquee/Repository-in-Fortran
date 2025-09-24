! Questão 1 - Lista 2
program q1
    implicit none

    integer :: i
    real(kind=8) :: x, dx 

    ! Inicialização de variáveis
    x = 1.0
    dx = 0.1

    ! Valor inicial (iteracão 0)
    write(*,*) 'Iteracao =', 0, '  x =', x

    ! Loop para 10 iterações
    do i = 1, 10
        x = x + dx
        write(*,*) 'Iteracao =', i, '  x =', x
    end do

stop
end program q1