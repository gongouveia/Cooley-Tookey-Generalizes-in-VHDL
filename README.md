# Cooley-Tookey-Generalizes-in-VHDL
Implementation of the CTG in VHDL

    main_CTG.vhd  -> codigo principal
    Packages_Util.vhd  -> package com constantes e funcções (dot product, multiplicação e soma de numeros complexos)
    CTG_TB.vhd  -> ficheiro para o testbench, penso que é asism que se faz, mas não da nenhum output




1
--  Fazer a FFT de N = 12 , N é composito em 12=3*4


começar a inicializar a matriz desta maneira ..... linhas j / colunas j

--  0 | 4 | 8  |  

--  1 | 5 | 9  |

--  2 | 6 | 10 |

--  3 | 7 | 11 |   
2    Fazer a dft das linhas
3    multiplicar cada ponto ponto por uma layers de twiddle factors
4    fazer a dft das colnunas
    
    
    
    
    O que me falta fazer e ando a testar:
    -fazer a dft das linhas e das colunas.
    -verificar time constraints
    
 
