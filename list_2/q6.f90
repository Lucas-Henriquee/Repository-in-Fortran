! Questão 6 - Lista 2
program q6

    implicit none

    integer :: Ci, Cf, C         ! Temperaturas em Celsius
    real(kind=8) :: F            ! Temperatura em Fahrenheit

    ! Entrada de dados
    write(*,*) 'Digite o valor inicial em Celsius:'
    read(*,*) Ci
    write(*,*) 'Digite o valor final em Celsius:'
    read(*,*) Cf

    ! Checagem da condicao
    if (Ci >= Cf) then
        write(*,*) 'Erro: o valor inicial deve ser menor que o valor final.'
        stop
    end if

    ! Cabecalho da tabela
    write(*,*)
    write(*,*) ' Tabela de Conversao Celsius -> Fahrenheit'
    write(*,*) '-------------------------------------------'
    write(*,'(A8, A15)') 'Celsius', 'Fahrenheit'

    ! Loop de 1 em 1 grau
    do C = Ci, Cf
        F = (9.0d0/5.0d0)*C + 32.0d0
        write(*,'(I5, F15.2)') C, F
    end do

stop
end program q6