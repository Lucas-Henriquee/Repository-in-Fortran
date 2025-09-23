
program prog

    implicit none

    ! Declaração de variáveis 
    real(16) :: var_seno, var_cosseno, var_tangente, pi

    ! Declaração de variável inteira para o ângulo
    integer :: theta

    ! Atribuição de valor ao ângulo em graus e do valor de pi
    theta = 45
    pi = 3.14159265358979323846264338327950288419716939

    ! Cálculo do seno, cosseno e tangente do ângulo
    var_seno = sin(theta * pi / 180.0)
    var_cosseno = cos(theta * pi / 180.0)
    var_tangente = tan(theta * pi / 180.0)

    write(*,*) "Ângulo (em graus): ", theta
    write(*,*) "Seno: ", var_seno
    write(*,*) "Cosseno: ", var_cosseno
    write(*,*) "Tangente: ", var_tangente

stop
end program prog