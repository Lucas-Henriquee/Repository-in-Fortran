========================================================================
PROBLEMA #1 - Otimizaoção das posições de um conjunto de partículas

INTEGRANTES:
BRENO MONTANHA COSTA
LUCAS HENRIQUE NOGUEIRA
VENÂNCIO PEREIRA RAMOS

* DESCRIÇÃO GERAL
------------------------------------------------------------------------
Este projeto implementa uma simulação computacional para encontrar a 
configuração geométrica de mínima energia para um cluster de 50 átomos 
de Argônio. Utiliza-se o Potencial de Lennard-Jones e uma abordagem 
híbrida de otimização combinando Simulated Annealing (para busca global) 
e o Método do Gradiente/Steepest Descent (para refinamento local).

------------------------------------------------------------------------
* LISTA DE ARQUIVOS E DESCRIÇÕES

>>> CÓDIGOS FONTE (FORTRAN 90)

[gera_coords.f90]
    Descrição: Programa responsável pela geração do estado inicial do sistema.
    Funcionalidade:
        - Solicita as dimensões da caixa e o número de átomos (N=50).
        - Distribui os átomos aleatoriamente no espaço 3D.
        - Aplica um critério de exclusão de volume (evita sobreposição 
          nuclear inicial) para impedir energias infinitas no passo 0.
    Saída: Gera o arquivo 'coord_in.dat'.

[Minimizacao.f90]
    Descrição: Programa principal da simulação.
    Funcionalidade:
        - Lê as coordenadas iniciais de 'coord_in.dat'.
        - Executa o algoritmo de Simulated Annealing (fase de aquecimento 
          e resfriamento lento).
        - Executa o método de Steepest Descent até que a força máxima 
          seja menor que 0.01 eV/Angstrom.
        - Calcula energia potencial e forças analíticas (Lennard-Jones).
    Saída: Gera os arquivos 'potential_out.dat' e 'coordinates_out.xyz'.

>>> SCRIPTS DE VISUALIZAÇÃO (GNUPLOT)

[analise_minimizacao.plt]
    Descrição: Script para plotagem da evolução geral.
    Funcionalidade: Gera o gráfico 'grafico_completo.png' contendo dois 
    eixos Y: Energia Potencial (Azul) e Força Máxima (Vermelho) em 
    função dos passos de simulação.

[convergencia_forca.plt]
    Descrição: Script para análise detalhada do critério de parada.
    Funcionalidade: Gera o gráfico 'grafico_forca.png' com o eixo Y em 
    escala logarítmica, facilitando a visualização da convergência da 
    força até o limiar de 10^-2.

------------------------------------------------------------------------
* ARQUIVOS DE DADOS (GERADOS PELA SIMULAÇÃO)
- coord_in.dat: Coordenadas iniciais geradas pelo 'gera_coords'.
- potential_out.dat: Histórico da energia e força passo a passo.
- coordinates_out.xyz: Trajetória completa das partículas (compatível com Jmol).

------------------------------------------------------------------------
* INSTRUÇÕES DE COMPILAÇÃO E EXECUÇÃO (LINUX/WSL)
Passo 1: Gerar as coordenadas iniciais
    $ gfortran gera_coords.f90 -o gera_coords
    $ ./gera_coords

Passo 2: Executar a minimização
    $ gfortran Minimizacao.f90 -o minimizacao
    $ ./minimizacao

Passo 3: Gerar os gráficos
    $ gnuplot analise_minimizacao.plt
    $ gnuplot convergencia_forca.plt

Passo 4: Visualizar a molécula 
    $ jmol coordinates_out.xyz
========================================================================