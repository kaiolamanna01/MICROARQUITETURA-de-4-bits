🧠 MicroCore – Microarquitetura Educativa de 4 Bits

MicroCore é uma microarquitetura multiciclo de 4 bits, desenvolvida para fins educacionais, com o objetivo de demonstrar os principais conceitos de organização e arquitetura de computadores, incluindo:

Unidade Lógica e Aritmética (ULA)

Banco de registradores

Memória de programa (ROM)

Máquina de Estados Finitos (FSM) de controle

Execução multiciclo

Visualização em FPGA (DE10-Lite)

📚 Sobre o Projeto

Este projeto implementa uma microarquitetura simples baseada em modelo multiciclo, onde cada instrução é executada em múltiplos ciclos de clock, sendo controlada por uma FSM.

A arquitetura opera com:

📦 Palavras de 8 bits (instruções)

🔢 Dados de 4 bits

🗂 4 registradores de propósito geral (R0–R3)

📍 Memória ROM de 256 posições

O projeto foi desenvolvido para execução e visualização na placa DE10-Lite, utilizando displays de 7 segmentos para monitoramento dos sinais internos.

🏗 Arquitetura do Sistema

A microarquitetura é composta pelos seguintes módulos:

🔹 1. Memória de Programa (ROM 8x256)

256 endereços

Instruções de 8 bits

Inicialização via $readmemh

🔹 2. Contador de Programa (PC)

Incrementa automaticamente a cada ciclo habilitado

Possui sinal de handshaking (ack)

Implementado com somador dedicado

🔹 3. Registrador de Instrução (IR)

Separa a instrução em três campos:

Campo	Bits	Função
mnm	7–6	Mnemônico
wr_addr_mnm	5–4	Endereço de escrita / extensão do mnemônico
rd_addr_wr_data	3–0	Endereço de leitura ou dado imediato
🔹 4. Banco de Registradores

4 registradores de 4 bits

1 porta de escrita

2 portas de leitura independentes

Escrita síncrona

Leitura combinacional

🔹 5. ULA (Unidade Lógica e Aritmética)

Operações suportadas:

Tipo	Operações
Aritméticas	ADD, SUB
Lógicas	AND, OR, XOR, NAND

Operações aritméticas → resultado salvo em RD

Operações lógicas → resultado salvo em R0

Implementação síncrona

🔹 6. FSM de Controle

Controla:

Habilitação do PC

Habilitação do IR

Escrita no banco

Execução da ULA

Seleção de multiplexadores

Estados de execução

Estados principais:

Fetch

Decode

LDR

Aritmética

Lógica

Write Back

📜 Conjunto de Instruções
🔹 LDR (Load Immediate)

Carrega valor imediato de 4 bits em um registrador.

R[D] ← imm4
🔹 ADD
R[D] ← R[A] + R[B]
🔹 SUB
R[D] ← R[A] - R[B]
🔹 AND
R0 ← R[A] AND R[B]
🔹 OR
R0 ← R[A] OR R[B]
🔹 XOR
R0 ← R[A] XOR R[B]
🔹 NAND
R0 ← R[A] NAND R[B]
🧪 Programa de Teste

O programa utilizado para validação executa:

R1 ← 4

R2 ← 1

R3 ← R1 + R2

R0 ← R1 AND R2

R0 ← R1 OR R2

R0 ← R1 NAND R2

R0 ← R1 XOR R2

R3 ← R1 - R2

As instruções são armazenadas em arquivo .txt em formato hexadecimal e carregadas via $readmemh.

🔎 Visualização na FPGA

Na placa DE10-Lite, são exibidos nos displays de 7 segmentos:

data_bus

operando_A

operando_B

wr_data_ula

Estado atual da FSM

Os valores são apresentados em formato hexadecimal.

🛠 Tecnologias Utilizadas

Verilog HDL

FPGA Intel (Cyclone V)

Simulação RTL

Modelo multiciclo

FSM de controle síncrona

🎯 Objetivos Acadêmicos

Este projeto permite compreender:

Execução multiciclo

Separação entre datapath e unidade de controle

Organização de banco de registradores

Projeto de ULA síncrona

Comunicação via handshaking

Implementação prática em FPGA

📈 Possíveis Melhorias Futuras

Implementação de flags (zero, carry, overflow)

Adição de instruções de desvio

Implementação de memória de dados

Expansão para 8 bits

Versão pipeline

👨‍💻 Autor

Desenvolvido por Kaio Lamanna