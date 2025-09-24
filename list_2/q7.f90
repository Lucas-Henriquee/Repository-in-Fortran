! Questão 7 - Lista 2
program q7

    implicit none

    real(kind=8) :: A, B, C   ! Lados do triangulo

    ! Entrada de dados
    write(*,*) 'Digite o valor do lado A:'
    read(*,*) A
    write(*,*) 'Digite o valor do lado B:'
    read(*,*) B
    write(*,*) 'Digite o valor do lado C:'
    read(*,*) C

    ! Verificacao da desigualdade triangular
    if ((A + B > C) .and. (A + C > B) .and. (B + C > A)) then

        ! Classificacao do triangulo
        if (A == B .and. B == C) then
        write(*,*) 'Triangulo Equilatero'
        else if (A == B .or. A == C .or. B == C) then
        write(*,*) 'Triangulo Isosceles'
        else
        write(*,*) 'Triangulo Escaleno'
        end if

    else
        write(*,*) 'Os valores nao formam um triangulo.'
    end if

stop
end program q7