! Questão 5 - Lista 2
program q5

    implicit none

    real(kind=8) :: F, K    

    ! Pede ao usuário o valor em Fahrenheit
    write(*,*) 'Digite a temperatura em Fahrenheit:'
    read(*,*) F

    ! Conversao: K = (F - 32) * 5/9 + 273.15
    K = (F - 32.0d0) * 5.0d0/9.0d0 + 273.15d0

    ! Imprime os resultados 
    write(*,*) 'Temperatura em Fahrenheit : ', F
    write(*,*) 'Temperatura equivalente em Kelvin : ', K

stop
end program q5