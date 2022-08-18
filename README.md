# pppoemarkmangle
Script RouterOS para marcação de pacotes de saída na cadeia de mangle, especificamente para links PPPoE

## Apresentação
A idéia de criar esses scripts nasceu da necessidade de automatizar o processo de marcação da conexão e rotas de saídas por links de PPPoE, tendo em vista que o processo é demorado em roteadores Mikrotik com mais de dois links.

O processo de marcação de conexão e rotas ocorre na tabela mangle, marcando o pacote de entrada e forçando sua saída pelo mesmo link.

## Configuração
Existem dois arquivos a serem usados nos eventos **On-Up** e **On-Down** do respectivo profile, seguem os passos abaixo:

1. Criar um profile *[PPP -> Profiles -> Add]*;
2. Criar uma nova interface PPPoE *[PPP -> Interface -> PPPoE Client]*;
3. Entrar com as informações para fechar o túnel e selecionar o profile criado no passo 1;
4. Copiar o conteúdo do script [profile_on-up.rsc][https://github.com/jayroncastro/pppoemarkmangle/blob/master/profile_on-up.rsc] para *[PPP -> Profiles -> PPP Profile -> Scripts -> On-Up]*;
5. Copiar o conteúdo do script [profile_on-down.rsc][https://github.com/jayroncastro/pppoemarkmangle/blob/master/profile_on-down.rsc] para *[PPP -> Profiles -> PPP Profile -> Scripts -> On-Down]*;

A única intervenção necessária, será alterar a variável **interfaceLan** que consta no arquivo **profile_on-up.rsc** e substituir o valor *bridge* pelo nome da interface lan.

## Sugestões e Melhorias
Sugestões, Bugs e melhorias podem ser informadas ou solicitadas via [Issues][https://github.com/jayroncastro/pppoemarkmangle/issues]