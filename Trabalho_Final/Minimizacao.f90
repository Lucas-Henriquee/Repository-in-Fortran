! modulo aleatorio 
module rng_mod
implicit none

integer, parameter :: k4b = selected_int_kind(9)

integer(k4b), save :: ix = -1, iy = -1, l
real(kind=8), save :: am

integer(k4b), parameter :: ia = 16807
integer(k4b), parameter :: im = 2147483647
integer(k4b), parameter :: iq = 127773
integer(k4b), parameter :: ir = 2836

contains

subroutine ran1sub(idum, x)
implicit none

integer(k4b), intent(inout) :: idum
real(kind=8), intent(out) :: x

if (idum <= 0 .or. iy < 0) then
    am = nearest(1.0d0, -1.0d0) / im
    iy = ior(ieor(888889999, abs(idum)), 1)
    ix = ieor(777755555, abs(idum))
    idum = abs(idum) + 1
end if

ix = ieor(ix, ishft(ix, 13))
ix = ieor(ix, ishft(ix, -17))
ix = ieor(ix, ishft(ix, 5))

l = iy / iq
iy = ia * (iy - l * iq) - ir * l
if (iy < 0) iy = iy + im

x = am * ior(iand(im, ieor(ix, iy)), 1)

end subroutine ran1sub

end module rng_mod

! Problema #1 - Otimizacao das posicoes 
program minimization
    use rng_mod
    implicit none

    ! Variaveis de controle e iteracao
    integer :: n        ! Numero de particulas
    integer :: i, k     ! Iteradores   
    integer :: n_h      ! Numero maximo de passos      
    integer :: error    ! Controle de erros
    integer :: n_seed    ! Semente para numeros aleatorios

    ! Variavel de controle do Metodo Hibrido
    logical :: usar_SA             ! Define se usa o SA ou não
    integer :: n_out               ! Salva arquivos a cada n_out passos
    real(8) :: T, T_inicial        ! Temperatura atual do SA

    ! Parametros fisicos
    real(8) :: epsilon, sigma

    ! Variaveis Calculadas
    real(8) :: U_total     ! Energia potencial total 
    real(8) :: Fi_max      ! Forca maxima encontrada 
    real(8) :: h           ! Passo de movimentacao (h)
    real(8) :: criterio_F  ! Criterio de forca para parada

    ! Arrays de posicoes e forcas    
    real(8), allocatable :: x(:), y(:), z(:)
    real(8), allocatable :: Fx(:), Fy(:), Fz(:)

    ! Parametros do problema 
    epsilon = 0.0104D0    ! eV 
    sigma = 3.405D0       ! Argonio 
    h  = 0.01D0           ! Ajuste de estabilidade
    criterio_F = 0.01D0   ! Criterio de equilibrio (0.01 eV/A)
    n_h = 300000         ! Limite do loop
    n_seed = 42           ! Semente para numeros aleatorios

    ! Inicializando controle do metodo hibrido
    usar_SA = .true.      ! .true. para ligar o SA
    n_out = 100          ! Salva a cada n_out passos
    T_inicial = 2.0D0    ! Temperatura inicial do SA
    T = T_inicial

    ! Leitura
    write(*,*) 'Lendo dados de entrada...'
    open(unit=10, file='coord_in.dat', status='old', action='read', iostat=error) 
    call check_error(error, 'Nao foi possivel abrir o arquivo de coordenadas.')

    ! Lendo o numero de particulas    
    read(10, *, iostat=error) n  
    call check_error(error, 'Erro na leitura do numero de particulas.')
        
    write(*,*) 'Numero de particulas:', n   

    ! Alocando arrays de forma dinamica 
    allocate(x(n), y(n), z(n),stat=error)
    call check_error(error, 'Erro fatal de memoria (x, y, z).')

    allocate(Fx(n), Fy(n), Fz(n), stat=error)
    call check_error(error, 'Erro fatal de memoria (Fx, Fy, Fz).')

    ! Lendo as coordenadas
    do i = 1, n
        read(10, *, iostat=error) x(i), y(i), z(i)
        call check_error(error, 'Erro na leitura das coordenadas.')
    end do
    close(10)                    

    ! Preparando arquivos de saida
    open(unit=20, file='potential_out.dat', status='replace', action='write', iostat=error)    
    call check_error(error, 'Nao foi possivel criar o arquivo de potencial.')

    open(unit=30, file='coordinates_out.xyz', status='replace', action='write', iostat=error)        
    call check_error(error, 'Nao foi possivel criar o arquivo de coordenadas XYZ.')

    ! Loop de Minimizacao
    write(*,*) '>>> Iniciando minimizacao com Steepest Descent (Otimizacao)...'    
    do k = 1, n_h

        ! Simulated Annealing (Perturbando poucas particulas)
        if (usar_SA) then
            call execute_sa(n, x, y, z, epsilon, sigma, n_seed, T)
        end if
        
        ! Chama subrotina para calcular forcas e potencial
        call calculate_forces(n, x, y, z, epsilon, sigma, Fx, Fy, Fz, U_total, Fi_max)

        ! Escreve potencial e forca maxima no arquivo de dados
        if (mod(k, n_out) == 0 .or. k == n_h .or. Fi_max < criterio_F) then
            ! Escreve potencial e forca maxima no arquivo de dados
            write(20, 100) k, U_total, Fi_max
            
            ! Escreve a trajetoria para o JMol 
            write(30, *) n
            write(30, *) 'Step: ', k, ' Energia: ', U_total    
            do i = 1, n
                write(30, 200) 'Ar', x(i), y(i), z(i)
            end do
        end if
        
        ! Verifica criterio de parada
        if (Fi_max < criterio_F) then
            write(*,*) 'Equilibrio atingido no passo: ', k
            write(*,*) 'Forca maxima final: ', Fi_max
            write(*,*) 'Energia total final: ', U_total        
            exit
        end if

        ! Atualiza posicoes (movimento na direcao da forca)
        do i = 1, n
            x(i) = x(i) + (Fx(i) * h)
            y(i) = y(i) + (Fy(i) * h)
            z(i) = z(i) + (Fz(i) * h)
        end do
    end do

    ! Verifica se saiu pelo limite de passos        
    if (k > n_h) then
        write(*,*) '>>> AVISO: Limite de passos atingido sem convergencia total.'
        write(*,*) '>>> Forca final alcancada: ', Fi_max
        write(*,*) '>>> Energia final: ', U_total
    end if

    ! Formatos de escrita 
    100 format(I6, 2x, F15.6, 2x, F15.6)
    200 format(A2, 4x, F12.6, 2x, F12.6, 2x, F12.6)

    ! Finalizacao
    close(20)
    close(30)
    deallocate(x, y, z, Fx, Fy, Fz)

    write(*,*) '>>> Minimizacao concluida.'
    stop                             
end program minimization

! Calcular Fi(r) 
subroutine calculate_forces(n, x, y, z, epsilon, sigma, Fx, Fy, Fz, U_total, Fi_max)
    implicit none   

    ! Argumentos de entrada
    integer, intent(in) :: n
    real(8), intent(in) :: x(n), y(n), z(n)
    real(8), intent(in) :: epsilon, sigma

    ! Argumentos de saida
    real(8), intent(out) :: Fx(n), Fy(n), Fz(n)
    real(8), intent(out) :: U_total, Fi_max

    ! Variaveis locais
    integer :: i, j
    
    real(8) :: dx, dy, dz           ! Componentes da distancia (x(i)-x(j))
    real(8) :: rij                  ! Distancia r 
    real(8) :: termo_12, termo_6    ! Termos para energia (Eq. 2)
    real(8) :: termo_13, termo_7    ! Termos para forca (Eq. 4)
    real(8) :: F_mag                ! Magnitude da Forca (Eq. 4)

    ! Inicializacao
    U_total = 0.0D0   
    Fi_max  = 0.0D0
    
    ! Zera vetores de forca
    do i = 1, n
        Fx(i) = 0.0D0
        Fy(i) = 0.0D0
        Fz(i) = 0.0D0
    end do  

    ! Loop sobre pares de particulas (i < j)
    do i = 1, n-1
        do j = i+1, n

            ! Calcula vetor distancia
            dx = x(i) - x(j)
            dy = y(i) - y(j)
            dz = z(i) - z(j)

            ! Calcula r (magnitude da distancia)
            rij = sqrt(dx*dx + dy*dy + dz*dz)    

            ! Evitando divisao por zero (sobreposicao de particulas) e particulas muito distantes
            if (rij > 1.0D-3 .and. rij < 10.0D0) then

                termo_12 = (sigma / rij)**12
                termo_6  = (sigma / rij)**6
                
                U_total = U_total + 4.0D0 * epsilon * (termo_12 - termo_6)    

                termo_13 = (sigma**12) / (rij**13)
                termo_7  = (sigma**6)  / (rij**7)
                
                F_mag = 24.0D0 * epsilon * (2.0D0 * termo_13 - termo_7)

                ! Decomposicao Vetorial                
                ! Forca na particula i (Soma)
                Fx(i) = Fx(i) + (F_mag * (dx / rij))
                Fy(i) = Fy(i) + (F_mag * (dy / rij))
                Fz(i) = Fz(i) + (F_mag * (dz / rij))

                ! Forca na particula j (Subtrai - Acao e Reacao)                    
                Fx(j) = Fx(j) - (F_mag * (dx / rij))
                Fy(j) = Fy(j) - (F_mag * (dy / rij))
                Fz(j) = Fz(j) - (F_mag * (dz / rij))
            end if
        end do
    end do

    ! Verificando Criterio de Parada
    do i = 1, n
        if (sqrt(Fx(i)**2 + Fy(i)**2 + Fz(i)**2) > Fi_max) then
            Fi_max = sqrt(Fx(i)**2 + Fy(i)**2 + Fz(i)**2)
        end if
    end do        
end subroutine calculate_forces

! Verificacao de erros
subroutine check_error(err_code, err_msg)
    implicit none

    integer, intent(in) :: err_code
    character(len=*), intent(in) :: err_msg

    if (err_code /= 0) then
        write(*,*) 'Erro: ', err_msg
        stop
    end if
end subroutine check_error

! Subrotina para executar Simulated Annealing
subroutine execute_sa(n, x, y, z, epsilon, sigma, n_seed, T)
    use rng_mod
    implicit none

    ! Argumentos de entrada e saida
    integer, intent(in) :: n
    integer, intent(inout) :: n_seed

    real(8), intent(inout) :: x(n), y(n), z(n)
    real(8), intent(in) :: epsilon, sigma
    real(8), intent(inout) :: T
    
    real(8) :: dir_x, dir_y, dir_z   ! Direcao do movimento

    ! Variaveis de controle do SA
    integer :: k, n_sa, error, p_sel    ! Iteradores e particula selecionada
    real(8) :: alpha      ! Controle de Temperatura
    real(8) :: perturbacao              ! Tamanho do passo aleatorio
    real(8) :: U_old, U_new, delta_E    ! Energias
    real(8) :: rnd, prob                ! Probabilidade Metropolis
    
    ! Variaveis do sistema para corrigir posicoes 
    real(8) :: x_cm, y_cm, z_cm, dist_cm
    real(8) :: raio_limite

    ! Arrays temporarios para movimentos de teste
    real(8), allocatable :: xt(:), yt(:), zt(:)

    ! Configuracao do SA
    n_sa = 2        ! Numero de passos 
    alpha = 0.9995D0    ! Taxa de resfriamento (Lenta)
    raio_limite = 80.0D0 ! Raio maximo 

    ! Alocacao de memoria temporaria
    allocate(xt(n), yt(n), zt(n), stat=error)
    if (error /= 0) then
         stop 'Erro memoria SA'
    end if

    ! Calculo da energia inicial
    call calc_energy(n, x, y, z, epsilon, sigma, U_old)

    ! Loop principal do Annealing
    do k = 1, n_sa
        
        ! Copia o estado atual para os arrays temporarios 
        xt = x
        yt = y
        zt = z

        ! Sorteia uma particula para tentar mover (p_sel)
        call ran1sub(n_seed, rnd)
        p_sel = 1 + int(rnd * n) 
        if (p_sel > n) then
            p_sel = n 
        end if        
        
        ! Calcula parametros globais
        x_cm = sum(x) / n
        y_cm = sum(y) / n
        z_cm = sum(z) / n
        
        ! Perturbacao decai com o tempo
        perturbacao = 0.5D0 * exp(-3.0d0 * real(k)/real(n_sa))

        ! Move apenas a particula sorteada (p_sel)
        dist_cm = sqrt((x(p_sel)-x_cm)**2 + (y(p_sel)-y_cm)**2 + (z(p_sel)-z_cm)**2)
        dir_x = (x_cm - x(p_sel)) / dist_cm
        dir_y = (y_cm - y(p_sel)) / dist_cm
        dir_z = (z_cm - z(p_sel)) / dist_cm
        
        ! Verifica Condicao de Contorno 
        if (dist_cm > raio_limite) then
            ! Tras a particula para perto do centro
            call ran1sub(n_seed, rnd)
            xt(p_sel) = x_cm + dir_x * raio_limite + (rnd - 0.5d0) * perturbacao

            call ran1sub(n_seed, rnd)
            yt(p_sel) = y_cm + dir_y * raio_limite + (rnd - 0.5d0) * perturbacao
            call ran1sub(n_seed, rnd)
            zt(p_sel) = z_cm + dir_z * raio_limite + (rnd - 0.5d0) * perturbacao
        else
            ! Movimento aleatorio local
            call ran1sub(n_seed, rnd)
            xt(p_sel) = x(p_sel) + (rnd - 0.5d0) * perturbacao * dir_x
            call ran1sub(n_seed, rnd)
            yt(p_sel) = y(p_sel) + (rnd - 0.5d0) * perturbacao * dir_y
            call ran1sub(n_seed, rnd)
            zt(p_sel) = z(p_sel) + (rnd - 0.5d0) * perturbacao * dir_z
        end if

        ! Criterio de Aceitacao de Metropolis
        ! Calcula energia da nova configuracao
        call calc_energy(n, xt, yt, zt, epsilon, sigma, U_new)
        delta_E = U_new - U_old

        if (delta_E < 0.0d0) then
            ! Se a energia diminuiu aceita
            x(p_sel) = xt(p_sel)
            y(p_sel) = yt(p_sel)
            z(p_sel) = zt(p_sel)
            U_old = U_new
        else
            ! Se a energia aumentou aceita com probabilidade P
            call ran1sub(n_seed, rnd)
            prob = exp(-delta_E / T)
            
            if (rnd < prob) then
                x(p_sel) = xt(p_sel)
                y(p_sel) = yt(p_sel)
                z(p_sel) = zt(p_sel)
                U_old = U_new
            end if
        end if

        ! Resfriamento do sistema
        T = T * alpha
    
    end do

    deallocate(xt, yt, zt)
end subroutine execute_sa

! Subrotina para calcular energia
subroutine calc_energy(n, x, y, z, epsilon, sigma, U_total)
    implicit none
    ! Argumentos de entrada
    integer, intent(in) :: n
    real(8), intent(in) :: x(n), y(n), z(n)
    real(8), intent(in) :: epsilon, sigma
    ! Argumento de saida
    real(8), intent(out) :: U_total

    ! Variaveis locais
    integer :: i, j
    real(8) :: dx, dy, dz          ! Componentes da distancia (x(i)-x(j))
    real(8) :: rij                 ! Distancia r
    real(8) :: term12              ! Termo (sigma/rij)^12
    real(8) :: term6               ! Termo (sigma/rij)^6

    ! Inicializacao
    U_total = 0.0d0

    ! Loop sobre pares de particulas (i < j)
    do i = 1, n-1
        do j = i+1, n
            ! Calcula vetor distancia
            dx = x(i) - x(j)
            dy = y(i) - y(j)
            dz = z(i) - z(j)

            ! Calcula r (magnitude da distancia)
            rij = sqrt(dx*dx + dy*dy + dz*dz)
            
            ! Evitando divisao por zero (sobreposicao de particulas) e particulas muito distantes
            if (rij > 1.0d-3 .and. rij < 10.0d0) then
                ! Calcula energia de Lennard-Jones
                term12 = (sigma / rij)**12
                term6  = (sigma / rij)**6
                U_total = U_total + 4.0d0 * epsilon * (term12 - term6)
            else
                U_total = U_total + 1.0d10 
            end if
        end do
    end do
end subroutine calc_energy