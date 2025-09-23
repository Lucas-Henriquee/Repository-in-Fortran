
program prog 

implicit none

! Declaração de variáveis
integer :: h33, h64, h65, h76, h79, i1, i2 

real(8) :: a, conv_rad, ang_deg, r1
real(8), parameter :: pi = 3.1415926535897932385

character(1) :: c1, c26

! Atribuição de valores
c1 = 'A'
c26 = 'Z'

h33 = 33
h64 = 64
h65 = 65
h76 = 76
h79 = 79

a = 3.4
conv_rad = pi / 180.0
ang_deg = 60

r1 = sin(ang_deg * conv_rad)
i1 = INT(a)  ! Truncamento
i2 = NINT(a)  ! Arredondamento

! Impressão dos resultados
write (*,*) 'Variáveis inteiras: ', i1, i2, r1
write (*,*) 'Variáveis caractere: ', CHAR(h64), CHAR(h79), CHAR(h76), CHAR(h65), CHAR(h33)
write (*,*) 'Números: ', IACHAR(c1), IACHAR(c26)

stop
end program prog