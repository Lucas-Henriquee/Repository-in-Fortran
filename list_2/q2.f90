! Questão 2 - Lista 2
program q2
    
    implicit none

    real(kind=8) :: x, dx 

    ! Inicialização de variáveis
    x = 0
    dx = 0.1

    ! valor inicial
    write(*,*) 'x =', x

    ! loop do while
    do while (x <= 3.0)
        x = x + dx
        write(*,*) 'x =', x
    end do

    ! mensagem final
    write(*,*) 'programa finalizado'

stop
end program q2