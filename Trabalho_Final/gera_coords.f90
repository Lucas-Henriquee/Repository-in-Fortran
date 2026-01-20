module aleatorio
    implicit none
    integer, save :: n_seed
end module aleatorio

program gera_coords
    use aleatorio
    implicit none

    ! Variaveis
    integer :: natom        ! Numero de atomos
    integer :: n_max        ! Numero maximo de atomos na caixa
    integer :: i, j, error  ! Iteradores e controle de erros
    integer :: isemente     ! Semente para numeros aleatorios
    integer :: tentativas   ! Contador de tentativas para alocacao
    logical :: aceito       ! Flag para aceitar coordenada

    real(8) :: ax, ay, az   ! Dimensoes da caixa
    real(8) :: x_cand, y_cand, z_cand  ! Coordenadas candidatas
    real(8) :: dist_sq, rmin_sq         ! Distancia ao quadrado e distancia minima ao quadrado
    real(8) :: nran                      ! Numero aleatorio gerado
    
    ! Arrays para coordenadas
    real(8), allocatable :: x(:), y(:), z(:)


    real(8), parameter :: vdw_ar = 1.88d0           ! Raio de van der Waals do Argonio em Angstroms
    real(8), parameter :: diametro = 2.0d0 * vdw_ar ! Diametro do Argonio

    write(*,*) '--- Gerador de Coordenadas para Dinamica Molecular ---'
    
    ! Leitura das dimensoes da caixa
    write(*,*) 'Digite as dimensoes da caixa X, Y e Z:'
    read(*,*) ax, ay, az

    ! Calcula o numero maximo de atomos que cabem na caixa
    n_max = int(ax/diametro) * int(ay/diametro) * int(az/diametro)

    ! Leitura do numero de atomos
    write(*,*) 'Digite o numero de atomos de Argonio desejado:'
    read(*,*) natom

    ! Verifica se o numero de atomos excede a capacidade da caixa
    if (natom > n_max) then
        write(*,*) 'ERRO: O numero de atomos excede a capacidade da caixa.'
        stop
    end if

    ! Leitura e definicao da semente para numeros aleatorios, para reproducibilidade
    write(*,*) 'Digite a semente para numeros aleatorios:'
    read(*,*) isemente
    call semente(isemente)

    ! Alocacao dos arrays de coordenadas
    allocate(x(natom), y(natom), z(natom), stat=error)

    if (error /= 0) then 
        write(*,*) 'Erro de alocacao de memoria.'
        stop
    end if

    rmin_sq = (0.9d0 * diametro)**2

    write(*,*) 'Gerando coordenadas...'
    
    ! Para cada atomo
    do i = 1, natom
        aceito = .false.
        tentativas = 0

        ! Enquanto a coordenada nao for aceita
        do while (.not. aceito)
            tentativas = tentativas + 1
            
            if (tentativas > 100000) then
                write(*,*) 'FALHA: Nao foi possivel alocar o atomo', i
                stop
            end if

            ! Gera coordenadas candidatas aleatorias
            call num_aleatorio(nran)
            x_cand = nran * ax
            
            call num_aleatorio(nran)
            y_cand = nran * ay
            
            call num_aleatorio(nran)
            z_cand = nran * az

            aceito = .true.
            do j = 1, i - 1
                dist_sq = (x_cand - x(j))**2 + (y_cand - y(j))**2 + (z_cand - z(j))**2
                ! Verifica se a distancia minima eh respeitada
                if (dist_sq < rmin_sq) then
                    aceito = .false.
                    exit
                end if
            end do

            ! Se aceito, armazena as coordenadas
            if (aceito) then
                x(i) = x_cand
                y(i) = y_cand
                z(i) = z_cand
            end if
        end do
    end do

    ! Escrita das coordenadas no arquivo de saida
    open(unit=20, file='coord_in.dat', status='replace', action='write', iostat=error)
    if (error /= 0) then
        write(*,*) 'Erro ao abrir arquivo de saida.'
        stop
    end if

    write(20, *) natom

    do i = 1, natom
        write(20, 100) x(i), y(i), z(i)
    end do

    100 format(3(F12.6, 2x))

    close(20)
    deallocate(x, y, z)

    write(*,*) 'Arquivo "coord_in.dat" gerado com sucesso!'
end program gera_coords

subroutine num_aleatorio(nran)
    use aleatorio
    implicit none
    
    real(8), intent(out) :: nran
    
    n_seed = mod(8127 * n_seed + 28417, 134453)
    nran = real(n_seed, kind=8) / 134453.0d0
end subroutine num_aleatorio

subroutine semente(isemente)
    use aleatorio
    implicit none
    integer, intent(in) :: isemente
    
    n_seed = abs(isemente)
end subroutine semente