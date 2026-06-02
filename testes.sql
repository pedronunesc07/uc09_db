-- TESTE 1: Auditoria de Preços
-- Primeiro, olhamos o preço antigo.
SELECT nm_produto, vl_preco_venda FROM tb_produto WHERE cd_produto = 1;
-- Alteramos o preço.
UPDATE tb_produto SET vl_preco_venda = 2750.00 WHERE cd_produto = 1;
-- Consultamos a tabela de histórico. A mágica do Trigger de auditoria vai aparecer aqui!
SELECT * FROM tb_historico_preco;

-- TESTE 2: Fluxo Completo de Venda
-- Como está o nosso estoque de Notebooks? 
SELECT p.nm_produto, e.qt_disponivel
FROM tb_estoque e
JOIN tb_produto p ON e.cd_produto = p.cd_produto
WHERE e.cd_produto = 2;

CALL sp_abrir_venda(1, 1, @v_venda_atual);
CALL sp_inserir_item_venda(@v_venda_atual, 2, 2);
CALL sp_inserir_item_venda(@v_venda_atual, 3, 5); 

SELECT p.nm_produto, e.qt_disponivel FROM tb_estoque e
JOIN tb_produto p ON e.cd_produto = p.cd_produto WHERE e.cd_produto IN (2, 3);

SELECT cd_venda, dt_venda, vl_total_venda, st_venda
FROM tb_venda
WHERE cd_venda = @v_venda_atual;

-- TESTE 3: Procedure de Reajuste Lote (Aumento de 10%)
CALL sp_reajustar_precos_categoria(1, 10.00);
SELECT nm_produto, vl_preco_venda FROM tb_produto WHERE cd_categoria = 1;

-- TESTE 4: Teste de Segurança do Banco (Triggers e Constraints)
DELETE FROM tb_venda WHERE cd_venda = 1;

DELETE FROM tb_item_venda WHERE cd_venda = @v_venda_atual;
DELETE FROM tb_venda WHERE cd_venda = @v_venda_atual;

-- Verificando se realmente apagou
SELECT * FROM tb_venda WHERE cd_venda = @v_venda_atual;
