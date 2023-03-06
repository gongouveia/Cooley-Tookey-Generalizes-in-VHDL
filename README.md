# DFT_theoretical_REAL_tested


Neste repositorio esta testada a DFT de 4 pontos, foi usado o package de numeros reais, pelo que não é sintetisavel
O testbench vai de encontro aos valores reais da DFT
waveform of the DFT: https://github.com/gongouveia/Cooley-Tookey-Generalizes-in-VHDL/blob/main/DFT_theoretical_REAL_tested/waveform.png
# DFT_theoretical_N_points 

Na pasta DFT_theoretical_N_points 
Tentei implementar uma DFT para 5 pontos, penso que está bem implementada, mas os resultados estão errados.
O testbench esta feito. 

Este documento e importante para saber se as DFT que estou a fazer no meu algoritmo estão corretas.


A imagem RTL_analysis.png demostram como o dot_product esta sintesizado
    RTL_analysis.png https://github.com/gongouveia/Cooley-Tookey-Generalizes-in-VHDL/blob/main/RTL_analysis.png
    
A imagem waveform.png demostram o testbench da DFT de pontos  (confirmei o valor dos twiddle factors, não sera esse o erro)
    waveform_dft.png https://github.com/gongouveia/Cooley-Tookey-Generalizes-in-VHDL/blob/main/waveform_dft.png

# 4 point DFT sythsysable VHDL synthesizable

Tyoe of data test, and validation using testbench.
format of data is 31bits, 12 bits for fractional part. using SIGNED type, twoś complement

https://github.com/gongouveia/Cooley-Tookey-Generalizes-in-VHDL/blob/main/DFT_theoretical_REAL_tested/waveform.png

#  DFT_theoretical_REAL_tested 
Implementation of the CTG in VHDL

Still under development :construction:


    FOLDER: COOLEY_TOOKEY_GENRALIZED_
    - Contem os ficheiros para a package de funções e tipos
    - Contem o codigo do main (adquirir, processa e envia os dados)
    - Contem o codigo com o testbench do algoritmo


1
--  Fazer a FFT de N = 12 , N é composito em 12=3*4
A implementação segue a seguinte imagem
https://www.semanticscholar.org/paper/The-Fast-Fourier-Transform-7.1-Introduction-7.2-Fft/ab9e1695fed92d153fb1e15d4353ec04bf3b1cd0/figure/8

começar a inicializar a matriz desta maneira ..... linhas j / colunas j

 | 0 | 4 | 8  |  

 | 1 | 5 | 9  |

 | 2 | 6 | 10 |

 | 3 | 7 | 11 |   
 
Falta fazer:

    Verificar time constraints
    Perceber se o testbench está bem
    Validar resutados
    

 Realizei códigos para os somadores e multiplicadores com os seus testbenches, os dados foram validados.
 Os códigos para os dot products foram testados. https://github.com/gongouveia/vectorial-dot-product-a.b
