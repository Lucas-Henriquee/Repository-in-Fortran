! Questão 4 - Lista 2
program q4

    implicit none

    real(kind=8) :: a, b
    logical :: resultado

    ! Entrada de dados
    write(*,*) 'Digite dois numeros reais (a e b):'
    read(*,*) a, b

    ! Verificacao com operadores relacionais e logicos
    resultado = (a > 0.0) .and. (b < 5.0)

    ! Saida dos resultados
    if (resultado) then
        write(*,*) 'A condicao (a > 0 .and. b < 5) eh VERDADEIRA'
    else
        write(*,*) 'A condicao (a > 0 .and. b < 5) eh FALSA'
    end if

    write(*,*) 'Estado da variavel logica =', resultado

stop
end program q4