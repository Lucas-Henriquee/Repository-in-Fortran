! Questão 3 - Lista 2
program q3

    real(kind=8) :: x, dx

    ! inicializacao
    x  = 0.0
    dx = 0.1

    ! loop do infinito
    do
        write(*,*) 'x =', x
        if (x >= 3.0_8) exit
        x = x + dx
    end do

    ! mensagem final
    write(*,*) 'programa finalizado'

stop
end program q3