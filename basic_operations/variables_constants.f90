! Declaração de variáveis e constantes em Fortran

program variables

    implicit none

    real (kind=4) :: var1
    real (kind=8) :: var2
    integer :: var3
    character(8) :: var4

    var1 = 3.14159265358979323846264338327950288419E0
    var2 = 3.14159265358979323846264338327950288419
    var3 = 5829
    var4 = "Computacional"

    write(*,*) var1, var2, var3, var4

stop
end program variables