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
	carro_id integer references carro(id),
	problemaConstado varchar(500),
	servicoExecutado varchar(500),
	obsComplementares varchar(150),
	registroAtivo boolean default true,
	tipoC boolean default false,
	tipoOS boolean default true,
	valorentrada numeric(14,3),
	valorvista numeric(14,3),
	valorprazo numeric(14,3),
	valortotalvista numeric(14,3),
	valormaoobra numeric(14,3),
	valorpecas numeric(14,3),
	valorcusto numeric(14,3),
	qtdprazo integer,
	vetorsenda boolean default false,
	vetorpickup boolean default false,
	vetorhatch boolean default false,
	vetorsuv boolean default false
);

create table ordemServicoProdutos (
	id serial primary key,
	id_produtoServico integer references produtoServico(id),
	qtd numeric(14,3),
	valorProdutos numeric(14,2),
	valorMaoObra numeric(14,2),
	desconto numeric(14,2),
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

create table vetorsedan (
	id serial primary key,
	id_ordemServico integer references ordemServico(id),
	parte1 boolean default false,
	parte2 boolean default false,
	parte3 boolean default false,
	parte4 boolean default false,
	parte5 boolean default false,
	parte6 boolean default false,
	parte7 boolean default false,
	parte8 boolean default false,
	parte9 boolean default false,
	parte10 boolean default false,
	parte11 boolean default false,
	parte12 boolean default false,
	parte13 boolean default false,
	parte14 boolean default false,
	parte15 boolean default false,
	parte16 boolean default false,
	parte17 boolean default false,
	parte18 boolean default false,
	parte19 boolean default false,
	parte20 boolean default false,
	parte21 boolean default false,
	parte22 boolean default false,
	parte23 boolean default false,
	parte24 boolean default false,
	parte25 boolean default false,
	parte26 boolean default false,
	parte27 boolean default false
);

create table vetorcamionete (
	id serial primary key,
	id_ordemServico integer references ordemServico(id),
	parte1 boolean default false,
	parte2 boolean default false,
	parte3 boolean default false,
	parte4 boolean default false,
	parte5 boolean default false,
	parte6 boolean default false,
	parte7 boolean default false,
	parte8 boolean default false,
	parte9 boolean default false,
	parte10 boolean default false,
	parte11 boolean default false,
	parte12 boolean default false,
	parte13 boolean default false,
	parte14 boolean default false,
	parte15 boolean default false,
	parte16 boolean default false,
	parte17 boolean default false,
	parte18 boolean default false,
	parte19 boolean default false,
	parte20 boolean default false,
	parte21 boolean default false,
	parte22 boolean default false,
	parte23 boolean default false,
	parte24 boolean default false,
	parte25 boolean default false,
	parte26 boolean default false,
	parte27 boolean default false,
	parte28 boolean default false
);

create table vetorhatch (
	id serial primary key,
	id_ordemServico integer references ordemServico(id),
	parte1 boolean default false,
	parte2 boolean default false,
	parte3 boolean default false,
	parte4 boolean default false,
	parte5 boolean default false,
	parte6 boolean default false,
	parte7 boolean default false,
	parte8 boolean default false,
	parte9 boolean default false,
	parte10 boolean default false,
	parte11 boolean default false,
	parte12 boolean default false,
	parte13 boolean default false,
	parte14 boolean default false,
	parte15 boolean default false,
	parte16 boolean default false,
	parte17 boolean default false,
	parte18 boolean default false,
	parte19 boolean default false,
	parte20 boolean default false,
	parte21 boolean default false,
	parte22 boolean default false,
	parte23 boolean default false,
	parte24 boolean default false,
	parte25 boolean default false,
);

create table vetorsuv (
	id serial primary key,
	id_ordemServico integer references ordemServico(id),
	parte1 boolean default false,
	parte2 boolean default false,
	parte3 boolean default false,
	parte4 boolean default false,
	parte5 boolean default false,
	parte6 boolean default false,
	parte7 boolean default false,
	parte8 boolean default false,
	parte9 boolean default false,
	parte10 boolean default false,
	parte11 boolean default false,
	parte12 boolean default false,
	parte13 boolean default false,
	parte14 boolean default false,
	parte15 boolean default false,
	parte16 boolean default false,
	parte17 boolean default false,
	parte18 boolean default false,
	parte19 boolean default false,
	parte20 boolean default false,
	parte21 boolean default false,
	parte22 boolean default false
);