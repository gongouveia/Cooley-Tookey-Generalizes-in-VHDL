# Cooley-Tookey-Generalizes-in-VHDL
Implementation of the CTG in VHDL

Still under development :construction:

    main_CTG.vhd  -> codigo principal
    Packages_Util.vhd  -> package com constantes e funcções (dot product, multiplicação e soma de 
    numeros complexos)
    CTG_TB.vhd  -> ficheiro para o testbench, penso que é asism que se faz, mas não da nenhum output




1
--  Fazer a FFT de N = 12 , N é composito em 12=3*4
A implementação segue a seguinte imagem
https://www.semanticscholar.org/paper/The-Fast-Fourier-Transform-7.1-Introduction-7.2-Fft/ab9e1695fed92d153fb1e15d4353ec04bf3b1cd0/figure/8

começar a inicializar a matriz desta maneira ..... linhas j / colunas j

 | 0 | 4 | 8  |  

 | 1 | 5 | 9  |

 | 2 | 6 | 10 |

 | 3 | 7 | 11 |   
2    Fazer a dft das linhas
3    multiplicar cada ponto ponto por uma layers de twiddle factors
4    fazer a dft das colnunas
    
    
    
    
    O que me falta fazer e ando a testar:
    -fazer a dft das linhas e das colunas.
    -verificar time constraints
    
 Realizei códigos para os somadores e multiplicadores com os seus testbenches. os códigos para os produtos vetoriais estão aqui, feitos com signed values  e sfixed values para comparar. https://github.com/gongouveia/vectorial-dot-product-a.b
