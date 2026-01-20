reset
set title "Evolução da Minimização: Energia e Força"

set xlabel "Passos de Simulação"
set grid

# Eixo Y da Esquerda (Energia)
set ylabel "Energia Potencial [eV]" textcolor rgb "blue"
set ytics nomirror textcolor rgb "blue"

# Eixo Y da Direita (Força)
set y2label "Força Máxima [eV/A]" textcolor rgb "red"
set y2tics textcolor rgb "red"

# Salvar
set term pngcairo size 800,600 enhanced font 'Verdana,10'
set output 'grafico_completo.png'

# Plotagem Dupla
# axis x1y1 = usa eixo esquerdo
# axis x1y2 = usa eixo direito
plot "potential_out.dat" u 1:2 w l lw 2 lc rgb "blue" axis x1y1 title "Energia Potencial", \
     "potential_out.dat" u 1:3 w l lw 1 lc rgb "red" axis x1y2 title "Força Máxima"