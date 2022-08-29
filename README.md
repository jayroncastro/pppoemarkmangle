# pppoemarkmangle
Script RouterOS para marcação de pacotes de saída na cadeia de mangle, especificamente para links PPPoE

## Apresentação
A idéia de criar esses scripts nasceu da necessidade de automatizar o processo de marcação da conexão, rotas de saídas por links pppoe e atualização do gateway de links pppoe em caso de reconexão da pppoe-client.

Caso a opção *"Add Default Route"* de uma conexão pppoe-client não esteja seleciona o script cria automaticamente as rotas default na tabela de roteamento e caso a opção do script denominada *"ehCheckPing"* esteja informada como verdadeiro, no momento da criação da rota é habilitada a opção *"check ping"* na rota default para a interface.

O processo de marcação de conexão e rotas ocorre na tabela mangle, marcando o pacote de entrada e forçando sua saída pelo mesmo link.

## Tabela de scripts

| Evento Profile | Script |
| --- | --- |
| On-Up | [profile_on-up.rsc](https://github.com/jayroncastro/pppoemarkmangle/blob/master/profile_on-up.rsc) |
| On-Down | [profile_on-down.rsc](https://github.com/jayroncastro/pppoemarkmangle/blob/master/profile_on-down.rsc) |

## Definição
Somente o script que atua no evento *"On-Up"* do profile precisa ser configurado e as variáveis de controle estão listadas abaixo:

```
:local interfaceLan   "bridge";
:global dnsCheckPing  "aol.com.br";
:local ehCheckPing    true;
:global routeDistance "3";
```

- **interfaceLan:** variável que recebe o nome da interface local que representa a lan da rede;
- **dnsCheckPing:** variavel que recebe o nome do domínio que será usado como ponto de checkping, nunca o valor deve ser repetido em caso de usar o script em vários links;
- **ehCheckPing:** variável que recebe verdadeiro caso seja necessário criar a rota padrão do link com opção de checkping;
- **routeDistance:** variável que recebe o distance da rota padrão a ser criada.

## Compatibilidade
Este script foi homologado para a versão 6.48.6 do RouterOS.

## Como usar
Existem dois arquivos a serem usados nos eventos **On-Up** e **On-Down** do respectivo profile, seguem os passos abaixo:

1. Criar um profile *[PPP -> Profiles -> Add]*;
2. Criar uma nova interface PPPoE *[PPP -> Interface -> PPPoE Client]*;
3. Entrar com as informações para fechar o túnel e selecionar o profile criado no passo 1;
4. Copiar o conteúdo do script [profile_on-up.rsc](https://github.com/jayroncastro/pppoemarkmangle/blob/master/profile_on-up.rsc) para *[PPP -> Profiles -> PPP Profile -> Scripts -> On-Up]* e alterar as variáveis necessárias;
5. Copiar o conteúdo do script [profile_on-down.rsc](https://github.com/jayroncastro/pppoemarkmangle/blob/master/profile_on-down.rsc) para *[PPP -> Profiles -> PPP Profile -> Scripts -> On-Down]*;

## Sugestões e Melhorias
Sugestões, Bugs e melhorias podem ser informadas ou solicitadas via [Issues](https://github.com/jayroncastro/pppoemarkmangle/issues)