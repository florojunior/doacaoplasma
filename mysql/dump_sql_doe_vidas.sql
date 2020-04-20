-- phpMyAdmin SQL Dump
-- version 4.9.4
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Tempo de geração: 19-Abr-2020 às 21:10
-- Versão do servidor: 5.6.41-cll-lve
-- versão do PHP: 7.3.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `nsbhospe_save2lives`
--

DELIMITER $$
--
-- Procedimentos
--
CREATE DEFINER=`nsbhospe`@`localhost` PROCEDURE `sp_status_acompanhamento` (IN `codigoPessoa` INT UNSIGNED, IN `codigoPergunta` INT UNSIGNED)  NO SQL
BEGIN

	DECLARE codigoPessoStatus int;
	DECLARE inapton char;
    DECLARE inaptos char;
    DECLARE statusPessoa int;

    SELECT DISTINCT
    	pp1.inapta into inaptos
        FROM resposta r
        JOIN pergunta_parametro pp1
            ON r.escolha_unica = pp1.codigo_parametro
            AND pp1.inapta = 'S'
        WHERE r.codigo_pessoa = codigoPessoa
        AND r.codigo_pergunta = codigoPergunta;
        
    SELECT DISTINCT
    	pp1.inapta into inapton
        FROM resposta r
        JOIN pergunta_parametro pp1
            ON r.escolha_unica = pp1.codigo_parametro
            AND pp1.inapta = 'N'
        WHERE r.codigo_pessoa = codigoPessoa
        AND r.codigo_pergunta = codigoPergunta;
        

    SELECT
    	COUNT(a.codigo_pessoa) into codigoPessoStatus
        FROM acompanhamento a
        WHERE a.codigo_pessoa = codigoPessoa;
        
	 SELECT DISTINCT
    	a.status1 into statusPessoa
        FROM acompanhamento a
        WHERE a.codigo_pessoa = codigoPessoa;
        
	IF inaptos = 'S' && codigoPessoStatus = 0  THEN
        INSERT INTO acompanhamento (codigo_pessoa, status1) VALUES (codigoPessoa, 1);
        
    ELSEIF  inapton = 'N' && codigoPessoStatus = 0   THEN
        INSERT INTO acompanhamento (codigo_pessoa, status1) VALUES (codigoPessoa, 2);
        
	ELSEIF  inaptos = 'S' && statusPessoa = 2 && codigoPessoStatus <> 0 THEN
        UPDATE acompanhamento SET status1 = 1
        WHERE codigo_pessoa = codigoPessoa; 
        
    ELSEIF  inapton = 'N' && codigoPessoStatus <> 0 && statusPessoa = 2   THEN
        UPDATE acompanhamento SET status1 = 2
        WHERE codigo_pessoa = codigoPessoa; 
        
	END IF;


END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `acompanhamento`
--

CREATE TABLE `acompanhamento` (
  `codigo` int(11) NOT NULL,
  `codigo_pessoa` int(11) NOT NULL,
  `status1` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `acompanhamento`
--

INSERT INTO `acompanhamento` (`codigo`, `codigo_pessoa`, `status1`) VALUES
(1, 1, 2);

-- --------------------------------------------------------

--
-- Estrutura da tabela `parametro`
--

CREATE TABLE `parametro` (
  `codigo` int(11) NOT NULL,
  `descricao` varchar(150) NOT NULL,
  `ativo` char(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `parametro`
--

INSERT INTO `parametro` (`codigo`, `descricao`, `ativo`) VALUES
(1, 'SIM', 'T'),
(2, 'NÃO', 'T');

-- --------------------------------------------------------

--
-- Estrutura da tabela `pergunta`
--

CREATE TABLE `pergunta` (
  `codigo` int(11) NOT NULL,
  `descricao` varchar(250) NOT NULL,
  `ativo` char(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `pergunta`
--

INSERT INTO `pergunta` (`codigo`, `descricao`, `ativo`) VALUES
(1, 'Foi testado positivo para a COVID-19?', 'T'),
(2, 'Possui entre 18 e 50 anos de idade?', 'T'),
(3, 'Pesar mais do que 55 quilos?', 'T'),
(4, 'Sem sintomas por, pelo menos, 14 dias após recuperação plena da doença?', 'T'),
(5, 'Possui alguma das seguintes doenças: sífilis, chagas, malária, hepatite B, hepatite C, HIV? ', 'T');

-- --------------------------------------------------------

--
-- Estrutura da tabela `pergunta_parametro`
--

CREATE TABLE `pergunta_parametro` (
  `codigo` int(11) NOT NULL,
  `codigo_pergunta` int(11) NOT NULL,
  `codigo_tipo_pergunta` int(11) NOT NULL,
  `codigo_parametro` int(11) NOT NULL,
  `inapta` char(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `pergunta_parametro`
--

INSERT INTO `pergunta_parametro` (`codigo`, `codigo_pergunta`, `codigo_tipo_pergunta`, `codigo_parametro`, `inapta`) VALUES
(1, 1, 1, 1, 'N'),
(2, 1, 1, 2, 'S');

-- --------------------------------------------------------

--
-- Estrutura da tabela `pessoa`
--

CREATE TABLE `pessoa` (
  `codigo` int(11) NOT NULL,
  `nome` varchar(200) NOT NULL,
  `email` varchar(150) NOT NULL,
  `data_nascimento` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `pessoa`
--

INSERT INTO `pessoa` (`codigo`, `nome`, `email`, `data_nascimento`) VALUES
(1, 'silva', 'jrlima.reis@gmail.com', '1991-05-23'),
(2, 'Natã dos Santos Bandeira', 'natanbandeira18@gmail.com', '0000-00-00');

-- --------------------------------------------------------

--
-- Estrutura da tabela `resposta`
--

CREATE TABLE `resposta` (
  `codigo` int(11) NOT NULL,
  `codigo_pessoa` int(11) NOT NULL,
  `codigo_pergunta` int(11) NOT NULL,
  `escolha_unica` int(11) DEFAULT NULL,
  `escolha_multipla` int(11) DEFAULT NULL,
  `texto` text,
  `numero` int(11) DEFAULT NULL,
  `data` date DEFAULT NULL,
  `arquivo` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `resposta`
--

INSERT INTO `resposta` (`codigo`, `codigo_pessoa`, `codigo_pergunta`, `escolha_unica`, `escolha_multipla`, `texto`, `numero`, `data`, `arquivo`) VALUES
(1, 1, 1, 1, NULL, NULL, NULL, NULL, NULL);

--
-- Acionadores `resposta`
--
DELIMITER $$
CREATE TRIGGER `tg_status_acompanhamento` AFTER INSERT ON `resposta` FOR EACH ROW BEGIN
      CALL sp_status_acompanhamento (new.codigo_pessoa, new.codigo_pergunta);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `status_acompanhamento`
--

CREATE TABLE `status_acompanhamento` (
  `codigo` int(11) NOT NULL,
  `descricao` varchar(200) NOT NULL,
  `passou` char(1) NOT NULL,
  `ativo` char(1) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Extraindo dados da tabela `status_acompanhamento`
--

INSERT INTO `status_acompanhamento` (`codigo`, `descricao`, `passou`, `ativo`) VALUES
(1, 'Inapto na Pré-Triagem', 'F', 'T'),
(2, 'Apto para próxima etapa', 'T', 'T'),
(3, 'Aguardando confirmação', 'T', 'T');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tipo_pergunta`
--

CREATE TABLE `tipo_pergunta` (
  `codigo` int(11) NOT NULL,
  `descricao` varchar(150) NOT NULL,
  `ativo` char(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tipo_pergunta`
--

INSERT INTO `tipo_pergunta` (`codigo`, `descricao`, `ativo`) VALUES
(1, 'Escolha unica', 'T'),
(2, 'Escolha Multipla', 'T'),
(3, 'Texto', 'T'),
(4, 'Data', 'T'),
(5, 'Numero', 'T');

-- --------------------------------------------------------

--
-- Estrutura da tabela `token`
--

CREATE TABLE `token` (
  `codigo_token` int(11) NOT NULL,
  `codigo_pessoa` int(11) NOT NULL,
  `token` varchar(1000) NOT NULL,
  `refresh_token` varchar(1000) NOT NULL,
  `data_expira` datetime NOT NULL,
  `data_hora_acesso` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Extraindo dados da tabela `token`
--

INSERT INTO `token` (`codigo_token`, `codigo_pessoa`, `token`, `refresh_token`, `data_expira`, `data_hora_acesso`) VALUES
(1, 1, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOjEsInVzdWFyaW8iOiJqcmxpbWEucmVpc0BnbWFpbC5jb20iLCJjb2RpZ29QZXNzb2EiOjEsImRhdGFfZXhwaXJhIjoiMjAyMC0wNC0yMCAwNDo1NTowMyJ9.2S3Me2FmDJaz3uplgFmqKYsU7KSbIBd3vAtLC-fdr_o', 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c3VhcmlvIjoianJsaW1hLnJlaXNAZ21haWwuY29tIn0.XZ2qgyU8LPpkcxdgFY7kiKJVrUiyNS9jfgi7XOlBoYQ', '2020-04-20 04:55:03', '2020-04-19 23:55:03'),
(2, 2, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOjIsInVzdWFyaW8iOiJuYXRhbmJhbmRlaXJhMThAZ21haWwuY29tIiwiY29kaWdvUGVzc29hIjoyLCJkYXRhX2V4cGlyYSI6IjIwMjAtMDQtMjAgMDQ6NTU6MzAifQ.5B6OUXv-kcik8o3J1MT6UiPCYgsFNpLsR9UGWih1laM', 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c3VhcmlvIjoibmF0YW5iYW5kZWlyYTE4QGdtYWlsLmNvbSJ9.JKvEyC-EUSao-8dfQqzIyrOZQ7gDNg3a04Veg-XTXA0', '2020-04-20 04:55:30', '2020-04-19 23:55:30');

-- --------------------------------------------------------

--
-- Estrutura da tabela `usuario`
--

CREATE TABLE `usuario` (
  `codigo_pessoa` int(11) NOT NULL,
  `usuario` varchar(150) NOT NULL,
  `senha` varchar(50) NOT NULL,
  `ativo` char(1) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Extraindo dados da tabela `usuario`
--

INSERT INTO `usuario` (`codigo_pessoa`, `usuario`, `senha`, `ativo`) VALUES
(1, 'jrlima.reis@gmail.com', '4297f44b13955235245b2497399d7a93', 'T'),
(2, 'natanbandeira18@gmail.com', '43cca4b3de2097b9558efefd0ecc3588', 'T');

--
-- Índices para tabelas despejadas
--

--
-- Índices para tabela `acompanhamento`
--
ALTER TABLE `acompanhamento`
  ADD PRIMARY KEY (`codigo`),
  ADD KEY `fk_codigo_pessoa_acomp` (`codigo_pessoa`);

--
-- Índices para tabela `parametro`
--
ALTER TABLE `parametro`
  ADD PRIMARY KEY (`codigo`);

--
-- Índices para tabela `pergunta`
--
ALTER TABLE `pergunta`
  ADD PRIMARY KEY (`codigo`);

--
-- Índices para tabela `pergunta_parametro`
--
ALTER TABLE `pergunta_parametro`
  ADD PRIMARY KEY (`codigo`),
  ADD UNIQUE KEY `restricao_integridade` (`codigo`,`codigo_pergunta`,`codigo_tipo_pergunta`,`codigo_parametro`),
  ADD KEY `fk_codigo_pergunta` (`codigo_pergunta`),
  ADD KEY `fk_codigo_tipo_pergunta` (`codigo_tipo_pergunta`),
  ADD KEY `fk_codigo_parametro` (`codigo_parametro`);

--
-- Índices para tabela `pessoa`
--
ALTER TABLE `pessoa`
  ADD PRIMARY KEY (`codigo`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Índices para tabela `resposta`
--
ALTER TABLE `resposta`
  ADD PRIMARY KEY (`codigo`),
  ADD KEY `fk_codigo_pergunta_resposta` (`codigo_pergunta`),
  ADD KEY `fk_codigo_pessoa` (`codigo_pessoa`);

--
-- Índices para tabela `status_acompanhamento`
--
ALTER TABLE `status_acompanhamento`
  ADD PRIMARY KEY (`codigo`);

--
-- Índices para tabela `tipo_pergunta`
--
ALTER TABLE `tipo_pergunta`
  ADD PRIMARY KEY (`codigo`);

--
-- Índices para tabela `token`
--
ALTER TABLE `token`
  ADD PRIMARY KEY (`codigo_token`);

--
-- Índices para tabela `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`codigo_pessoa`),
  ADD UNIQUE KEY `email_unico` (`usuario`);

--
-- AUTO_INCREMENT de tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `acompanhamento`
--
ALTER TABLE `acompanhamento`
  MODIFY `codigo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `parametro`
--
ALTER TABLE `parametro`
  MODIFY `codigo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de tabela `pergunta`
--
ALTER TABLE `pergunta`
  MODIFY `codigo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de tabela `pergunta_parametro`
--
ALTER TABLE `pergunta_parametro`
  MODIFY `codigo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de tabela `pessoa`
--
ALTER TABLE `pessoa`
  MODIFY `codigo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de tabela `resposta`
--
ALTER TABLE `resposta`
  MODIFY `codigo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `status_acompanhamento`
--
ALTER TABLE `status_acompanhamento`
  MODIFY `codigo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de tabela `tipo_pergunta`
--
ALTER TABLE `tipo_pergunta`
  MODIFY `codigo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de tabela `token`
--
ALTER TABLE `token`
  MODIFY `codigo_token` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Restrições para despejos de tabelas
--

--
-- Limitadores para a tabela `acompanhamento`
--
ALTER TABLE `acompanhamento`
  ADD CONSTRAINT `fk_codigo_pessoa_acomp` FOREIGN KEY (`codigo_pessoa`) REFERENCES `pessoa` (`codigo`);

--
-- Limitadores para a tabela `pergunta_parametro`
--
ALTER TABLE `pergunta_parametro`
  ADD CONSTRAINT `fk_codigo_parametro` FOREIGN KEY (`codigo_parametro`) REFERENCES `parametro` (`codigo`),
  ADD CONSTRAINT `fk_codigo_pergunta` FOREIGN KEY (`codigo_pergunta`) REFERENCES `pergunta` (`codigo`),
  ADD CONSTRAINT `fk_codigo_tipo_pergunta` FOREIGN KEY (`codigo_tipo_pergunta`) REFERENCES `tipo_pergunta` (`codigo`);

--
-- Limitadores para a tabela `resposta`
--
ALTER TABLE `resposta`
  ADD CONSTRAINT `fk_codigo_pergunta_resposta` FOREIGN KEY (`codigo_pergunta`) REFERENCES `pergunta` (`codigo`),
  ADD CONSTRAINT `fk_codigo_pessoa` FOREIGN KEY (`codigo_pessoa`) REFERENCES `pessoa` (`codigo`);

DELIMITER $$
--
-- Eventos
--
CREATE DEFINER=`nsbhospe`@`localhost` EVENT `atualiza_status_acompanhamento` ON SCHEDULE EVERY 20 SECOND STARTS '2020-04-18 17:38:40' ON COMPLETION NOT PRESERVE ENABLE DO INSERT INTO acompanhamento (codigo_pessoa, status1) SELECT a.codigo_pessoa, 3
	FROM acompanhamento a  
	WHERE a.status1 = 2$$

DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
