create table pessoa(
	id serial primary key,
	nome varchar(80),
	nomeFantasia varchar(100),
	endereco varchar(80),
	bairro varchar(45),
	cidade varchar(45),
	uf varchar(2),
	cep varchar(8),
	complemento varchar(45),
	cpf varchar(11),
	cnpj varchar(14),
	ie varchar(10),
	numeroRG varchar(9),
	dataCadastro DATE,
	email varchar(100),
	skype varchar(75),
	obs varchar(300),
	tipoCLI boolean default false,
	tipoFOR boolean default false,
	registroAtivo boolean default true
);

create table funcionario (
	id serial primary key,
	nome varchar(80),
	funcao varchar(40),
	endereco varchar(80),
	bairro varchar(45),
	dataCadastro date,
	obs varchar(300),
	registroAtivo boolean default true
);

create table formaPagamento (
	id serial primary key,
	nome varchar(45),
	registroAtivo boolean default true
);

create table marca (
	id serial primary key,
	nome varchar(45),
	registroAtivo boolean default true
);

create table contato (
	id serial primary key,
	telefone varchar(20),
	tipo varchar(30),
	funcionario_id integer references funcionario(id),
	pessoa_id integer references pessoa(id),
	registroAtivo boolean default true
);

create table carro (
	id serial primary key,
	marca varchar(20),
	modelo varchar(45),
	placa varchar(7),
	tipo varchar(30),
	cor varchar(25),
	obs varchar(200),
	pessoa_id integer references pessoa(id),
	registroAtivo boolean default true
);

create table produtoServico (
	id serial primary key,
	nome varchar(50),
	referenciaProduto varchar(30),
	un varchar(3),
	obs varchar(200),
	tipoPRO boolean default false,
	tipoSER boolean default false,
	dataAtual date,
	custo numeric (14,2),
	precoAvista numeric (14,2),
	prevoPrazo numeric (14,2),
	marca_id integer references marca(id),
	registroAtivvo boolean default true
);

create table estoque (
	id serial primary key,
	id_produtoServico integer references produtoServico(id),
	qtd numeric(14,3),
	qtdMinima numeric(14,3),
	historico Date,
	registroAtivo boolean default true
);

create table ordemServico (
	id serial primary key,
	data date,
	prevEntrega date,
	situacaoAtual varchar(45),
	pessoa_id integer references pessoa(id),
	funcionario_id integer references funcionario(id),
	registroAtivo boolean default true,
	tipoC boolean default false,
	tipoOS boolean default true
);

create table ordemServicoProdutos (
	id serial primary key,
	id_produtoServico integer references produtoServico(id),
	qtd numeric(14,3),
	valorProdutos numeric(14,2),
	valorMaoObra numeric(14,2),
	desconto numeric(14,2),
	problemaConstado varchar(500),
	servicoExecutado varchar(500),
	obsComplementares varchar(150),
	ordemServico_id integer references ordemServico(id)
);

create table formaPagOs (
	id serial primary key,
	ordemServico_id integer references ordemServico(id),
	formaPagamento_id integer references formaPagamento(id),
	valorPago numeric(14,2)
);

create table usuario (
    id serial primary key,
    apelido varchar(40),
    usuario varchar(40),
	senha varchar(40),
	nivelacesso varchar(15),
	funcionaio_id integer references funcionario(id),
	registroAtivo boolean default true
);