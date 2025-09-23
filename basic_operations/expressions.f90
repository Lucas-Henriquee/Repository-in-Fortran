! Testando precedência de operadores em expressões matemáticas

program prog

    implicit none

    real(kind=8) :: distance1, distance2, distance3
    real(kind=8) :: acceleration, time

    acceleration = 3.0D0
    time = 12.0D0

    distance1 = 0.5 * acceleration * time ** 2.0D0
    distance2 = (0.5 * acceleration * time) ** 2.0D0
    distance3 = 0.5 * acceleration * (time ** 2.0D0)

    write(*,*) distance1, distance2, distance3

stop
end program prog