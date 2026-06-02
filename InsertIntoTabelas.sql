INSERT INTO tb_cargo (nm_cargo, ds_cargo) VALUES
('Vendedor', 'Atendimento ao cliente e vendas diretas'),
('Gerente', 'Gestão da loja e equipe');

INSERT INTO tb_forma_pagamento (nm_forma_pagamento) VALUES
('Cartão de Crédito'), ('PIX'), ('Dinheiro');

INSERT INTO tb_categoria (nm_categoria, ds_categoria) VALUES
('Eletrônicos', 'Dispositivos de tecnologia e informática'),
('Acessórios', 'Cabos, capas e periféricos');

INSERT INTO tb_fornecedor (nm_razao_social, nm_fantasia) VALUES
('Tech Corp S.A', 'TechCorp'),
('GigaByte Distribuidora Ltda', 'GigaDistribuidora');

INSERT INTO tb_endereco (nm_logradouro, nm_bairro, nm_cidade, nm_estado) VALUES
('Av. Ana Costa, 100', 'Gonzaga', 'Santos', 'SP'),
('Rua Carvalho de Mendonça, 200', 'Vila Belmiro', 'Santos', 'SP');

INSERT INTO tb_cliente (nm_cliente, dt_nascimento) VALUES
('João Silva', '1990-05-15'), ('Maria Oliveira', '1985-10-22'),
('Carlos Mendes', '1995-02-10');

INSERT INTO tb_cliente_endereco (cd_cliente, cd_endereco, tp_endereco) VALUES
(1,1, 'Residencial'), (2,2, 'Comercial');

INSERT INTO tb_funcionario (cd_cargo, nm_funcionario, dt_admissao, vl_salario) VALUES
(1, 'Pedro Alves', '2022-01-10', 2500.00), (2, 'Ana Costa', '2020-03-15', 5000.00);

INSERT INTO tb_produto (cd_categoria, cd_fornecedor, nm_produto, vl_preco_venda) VALUES
(1,1, 'Smartphone X', 2500.00), (1,2,'Notebook Pro', '4500.00'),
(2,1,'Cabo USB-C', 50.00);

INSERT INTO tb_estoque (cd_produto, qt_disponivel) VALUES (1,50), (2,20), (3,100);

INSERT INTO tb_venda (cd_cliente, cd_funcionario, dt_venda, hr_venda, vl_total_venda, st_venda) VALUES
(1,1, '2023-10-01', '14:30:00', 2550.00, 'Finalizada'),
(2,1, '2023-10-02', '10:00:00', 4500.00, 'Finalizada');

INSERT INTO tb_item_venda (cd_venda, cd_produto, qt_item, vl_unitario) VALUES
(1,1,1, 2500.00), (1,3,1, 50.00), (2,2,1, 4.500);

INSERT INTO tb_pagamento (cd_venda, cd_forma_pagamento, vl_pago) VALUES
(1,1,2550.00), (2,2,4500.00);