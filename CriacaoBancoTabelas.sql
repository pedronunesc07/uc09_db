CREATE DATABASE IF NOT EXISTS db_sistema_vendas;
USE db_sistema_vendas;

CREATE TABLE tb_cargo (
	cd_cargo INT AUTO_INCREMENT PRIMARY KEY
    ,nm_cargo VARCHAR(50)
    ,ds_cargo VARCHAR(200)
);
                        
CREATE TABLE tb_forma_pagamento (
	cd_forma_pagamento INT AUTO_INCREMENT PRIMARY KEY
    ,nm_forma_pagamento VARCHAR(50) NOT NULL
    ,fl_ativo BOOLEAN DEFAULT TRUE
);

CREATE TABLE tb_categoria (
	cd_categoria INT AUTO_INCREMENT PRIMARY KEY
    ,nm_categoria VARCHAR(100) NOT NULL
    ,ds_categoria VARCHAR(255)
);

CREATE TABLE tb_fornecedor (
	cd_fornecedor INT AUTO_INCREMENT PRIMARY KEY
    ,nm_razao_social VARCHAR(150) NOT NULL
    ,nm_fantasia VARCHAR(100)
    ,st_fornecedor VARCHAR(20) DEFAULT 'Ativo'
);

CREATE TABLE tb_endereco (
	cd_endereco INT AUTO_INCREMENT PRIMARY KEY
    ,nm_logradouro VARCHAR(150) NOT NULL
    ,nm_bairro VARCHAR(100)
    ,nm_cidade VARCHAR(100) NOT NULL
    ,nm_estado VARCHAR(2) NOT NULL
);

CREATE TABLE tb_cliente (
	cd_cliente INT AUTO_INCREMENT PRIMARY KEY
    ,nm_cliente VARCHAR(150) NOT NULL
    ,dt_nascimento DATE
    ,st_cliente VARCHAR(20) DEFAULT 'Adimplente'
    ,fl_ativo BOOLEAN DEFAULT TRUE
);

CREATE TABLE tb_cliente_endereco (
	cd_cliente INT
	,cd_endereco INT
    ,tp_endereco VARCHAR(50)
    ,PRIMARY KEY (cd_cliente, cd_endereco)
    ,FOREIGN KEY (cd_cliente) REFERENCES tb_cliente(cd_cliente)
    ,FOREIGN KEY (cd_endereco) REFERENCES tb_endereco(cd_endereco)
);

CREATE TABLE tb_funcionario (
	cd_funcionario INT AUTO_INCREMENT PRIMARY KEY
    ,cd_cargo INT NOT NULL
    ,nm_funcionario VARCHAR(15) NOT NULL
    ,dt_admissao DATE NOT NULL
    ,vl_salario DECIMAL (10,2)
    ,FOREIGN KEY (cd_cargo) REFERENCES tb_cargo(cd_cargo)
);

CREATE TABLE tb_produto (
	cd_produto INT AUTO_INCREMENT PRIMARY KEY
    ,cd_categoria INT NOT NULL
    ,cd_fornecedor INT NOT NULL
    ,nm_produto VARCHAR(150) NOT NULL
    ,vl_preco_venda DECIMAL(10,2) NOT NULL
    ,st_produto VARCHAR(30) DEFAULT 'Disponível'
    ,FOREIGN KEY (cd_categoria) REFERENCES tb_categoria(cd_categoria)
    ,FOREIGN KEY (cd_fornecedor) REFERENCES tb_fornecedor(cd_fornecedor)
);

CREATE TABLE tb_historico_preco (
	cd_historico INT AUTO_INCREMENT PRIMARY KEY
    ,cd_produto INT NOT NULL
    ,vl_preco_antigo DECIMAL(10,2)
    ,vl_preco_novo DECIMAL(10,2)
    ,dt_alteracao DATETIME DEFAULT CURRENT_TIMESTAMP
    ,FOREIGN KEY (cd_produto) REFERENCES tb_produto(cd_produto)
);

CREATE TABLE tb_estoque (
	cd_estoque INT AUTO_INCREMENT PRIMARY KEY
    ,cd_produto INT NOT NULL UNIQUE
    ,qt_disponivel INT DEFAULT 0
    ,dt_ultima_atualizacao DATETIME DEFAULT CURRENT_TIMESTAMP
    ,FOREIGN KEY (cd_produto) REFERENCES tb_produto(cd_produto)
);

CREATE TABLE tb_movimento_estoque (
	cd_movimentacao INT AUTO_INCREMENT PRIMARY KEY
    ,cd_produto INT NOT NULL
    ,tp_movimentacao VARCHAR(20)
    ,qt_movimentada INT NOT NULL
    ,dt_movimentacao DATETIME DEFAULT CURRENT_TIMESTAMP
    ,ds_motivo VARCHAR(255)
    ,FOREIGN KEY (cd_produto) REFERENCES tb_produto(cd_produto)
);

CREATE TABLE tb_venda (
	cd_venda INT AUTO_INCREMENT PRIMARY KEY
    ,cd_cliente INT NOT NULL
    ,cd_funcionario INT NOT NULL
    ,dt_venda DATE NOT NULL
    ,hr_venda TIME NOT NULL
    ,vl_total_venda DECIMAL(10,2) DEFAULT 0.00
    ,st_venda VARCHAR(30) DEFAULT 'Em Andamento'
    ,FOREIGN KEY (cd_cliente) REFERENCES tb_cliente(cd_cliente)
    ,FOREIGN KEY (cd_funcionario) REFERENCES tb_funcionario(cd_funcionario)
);

CREATE TABLE tb_item_venda (
	cd_item_venda INT AUTO_INCREMENT PRIMARY KEY
    ,cd_venda INT NOT NULL
    ,cd_produto INT NOT NULL
    ,qt_item INT NOT NULL
    ,vl_unitario DECIMAL(10,2) NOT NULL
    ,vl_subtotal DECIMAL(10,2) GENERATED ALWAYS AS (qt_item * vl_unitario) STORED
    ,FOREIGN KEY (cd_venda) REFERENCES tb_venda(cd_venda)
    ,FOREIGN KEY (cd_produto) REFERENCES tb_produto(cd_produto)
);

CREATE TABLE tb_pagamento (
	cd_pagamento INT AUTO_INCREMENT PRIMARY KEY
    ,cd_venda INT NOT NULL
    ,cd_forma_pagamento INT NOT NULL
    ,dt_pagamento DATETIME DEFAULT CURRENT_TIMESTAMP
    ,vl_pago DECIMAL(10,2) NOT NULL
    ,st_pagamento VARCHAR(30) DEFAULT 'Concluido'
    ,FOREIGN KEY (cd_venda) REFERENCES tb_venda(cd_venda)
    ,FOREIGN KEY (cd_forma_pagamento) REFERENCES tb_forma_pagamento(cd_forma_pagamento)
);