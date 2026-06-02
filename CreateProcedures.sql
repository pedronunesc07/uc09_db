DELIMITER //

CREATE TRIGGER trg_baixa_estoque
AFTER INSERT ON tb_item_venda
FOR EACH ROW
BEGIN
	UPDATE tb_estoque
    SET qt_disponivel = qt_disponivel - NEW.qt_item,
		dt_ultima_atualizacao = NOW()
    WHERE cd_produto = NEW.cd_produto;
    
    INSERT INTO tb_movimentacao_estoque (cd_produto, tp_movimentacao, qt_movimentada, ds_motivo)
    VALUES (NEW.cd_produto, 'Saída', NEW.qt_item, CONCAT('Venda ID: ', NEW.cd_venda));
END //

CREATE TRIGGER trg_historico_preco
AFTER UPDATE ON tb_produto
FOR EACH ROW
BEGIN
	IF LD.vl_preco_venda <> NEW.vl_preco_venda THEN
		INSERT INTO tb_historico_preco (cd_produto, vl_preco_antigo, vl_preco_novo)
		VALUES (NEW.cd_produto, OLD.vl_preco_venda, NEW.vl_preco_venda);
    END IF;
END // 
 
CREATE TRIGGER trg_bloqueia_exclusao_venda
BEFORE DELETE ON tb_venda
FOR EACH ROW
BEGIN
	IF OLD.st_venda = 'Finalizada' THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERRO: Não é permitido excluir uma venda já finalizada e processada!';
	END IF;
END //

CREATE PROCEDURE sp_abrir_venda(
	IN p_cd_cliente INT,
    IN p_cd_funcionario INT,
    IN p_cd_venda_gerada INT
)
BEGIN
	INSERT INTO tb_venda (cd_cliente, cd_funcionario, dt_venda, hr_venda, st_venda)
    VALUES (p_cd_cliente, p_cd_funcionario, CURDATE(), CURTIME(), 'Em Andamento');
    
    SET p_cd_venda_gerada = LAST_INSERT_ID();
END //

CREATE PROCEDURE sp_inserir_item_venda(
	IN p_cd_venda INT,
    IN p_cd_produto INT,
    IN p_qt_item INT
)
BEGIN
	DECLARE v_preco DECIMAL(10,2);
    
    SELECT vl_preco_venda INTO v_preco FROM tb_produto WHERE cd_produto = p_cd_produto;
    
    INSERT INTO tb_item_venda (cd_venda, cd_produto, qt_item, vl_unitario)
    VALUES (p_cd_venda, p_cd_produto, p_qt_item, v_preco);
    
    UPDATE tb_venda
    SET vl_total_venda = vl_total_venda + (p_qt_item * v_preco)
    WHERE cd_venda = p_cd_venda;
END //

CREATE PROCEDURE sp_reajustar_precos_categoria(
	IN p_cd_categoria INT,
    IN p_percentual DECIMAL(5,2) -- Exemplo: 10.00 para 10%
)
BEGIN
	DECLARE v_fator_multiplicacao DECIMAL(10,4);
	-- Se informarem 10%, a conta fica: 1 + (10/100) = 1.10
	SET v_fator_multiplicacao = 1 + (p_percentual / 100);

	UPDATE tb_produto
	SET vl_preco_venda = vl_preco_venda * v_fator_multiplicacao
		WHERE cd_categoria = p_cd_categoria;
END //

DELIMITER ;
