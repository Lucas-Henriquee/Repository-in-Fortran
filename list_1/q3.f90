! Variáveis de diferentes precisões
program prog

    implicit none

    ! Declaração de variáveis de diferentes precisões
    real(4) :: v1
    real(8) :: v2
    real(16) :: v3     

    ! Atribuição de valores às variáveis
    v1 = 3.14159265358979323846264338327950288419716939E0
    v2 = 3.14159265358979323846264338327950288419716939D0
    v3 = 3.14159265358979323846264338327950288419716939Q0        

    write(*,*) " Resultado: ", v1, v2, v3

stop
end program prog        