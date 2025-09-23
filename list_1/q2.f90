! Variável com tamanho insuficiente
program prog 

    implicit none

    ! Declaração de variáveis
    character(5) :: var
    character(19) :: var_2

    var = 'teste em fortran-90'

    write(*,*) ' Resultado: ', var

    ! Corrigindo erro de variável
    var_2 = 'teste em fortran-90'

    write(*,*) ' Resultado: ', var_2

stop
end program prog