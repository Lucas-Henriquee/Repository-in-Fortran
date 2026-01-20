# Configuração visual
set title "Convergência da Força Resultante Máxima" font ",14"
set xlabel "Número de Passos" font ",12"
set ylabel "Força Máxima [eV/A]" font ",12"
set grid

# Escala Logarítmica no Y ajuda a ver melhor a queda da força
set logscale y

# Salvar em imagem
set term pngcairo size 800,600 enhanced font 'Verdana,10'
set output 'grafico_forca.png'

# Plotagem (Coluna 1 vs Coluna 3)
# Desenhamos também uma linha reta em 0.01 para mostrar o alvo
plot "potential_out.dat" u 1:3 w l lw 2 lc rgb "red" title "Força Máxima", \
     0.01 w l dt 2 lc rgb "black" title "Critério (0.01)"