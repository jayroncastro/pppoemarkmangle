# profile_on-up
# Script para automatizar a criacao de regras de mangle e rotas para forcar saida pelo link de entrada
# Development by: Jayron Castro
# Date: 17/08/2022 10:12
# eMail: jayroncastro@gmail.com
{
  #======== VARIAVEL DE CONTROLE =========
  #"interfaceLan" Recebe o nome da interface local que representa a lan da rede;
  #"dnsCheckPing" Recebe o nome do domínio que será usado como ponto de checkping;
  #"ehCheckPing" Recebe verdadeiro caso seja necessário criar a rota padrão do link com opção de checkping;
  #"routeDistance" Recebe o distance da rota padrão a ser criada.
  #=======================================
  :local interfaceLan     "bridge";
  #=== VARIAVEIS DE CONTROLE DE RECURSIVIDADE ===
  #=======================================
  :global dnsCheckPing  "aol.com.br";
  :local ehCheckPing    true;
  :global routeDistance "3";
  #=======================================

  #Armazena o nome da interface pppoe
  :local interfaceName [/interface ethernet get $interface name];
  :log warning "initializing script profile(on-up) for interface $interfaceName";

  #Executa instrução somente se a opção "add-default-route" não estiver selecionada
  :if (![/interface pppoe-client get [find name=$interfaceName] add-default-route]) do={
    :local ipCheckPing [:resolve $dnsCheckPing];
    :delay 1;

    #Cria a rota especifica para o gatewayCheckPing
    /ip route add dst-address=$ipCheckPing scope=10 gateway=$"remote-address" comment="** link: $interfaceName";

    #Cria a rota de saida padrao
    :if ($ehCheckPing) do={
      /ip route add dst-address=0.0.0.0/0 gateway=$ipCheckPing check-gateway=ping distance=$routeDistance comment="** link: $interfaceName";
    } else={
      /ip route add dst-address=0.0.0.0/0 gateway=$ipCheckPing distance=$routeDistance comment="** link: $interfaceName";
    }
  };

  #Marca conexão entrando pelo link
  /ip firewall mangle add chain=prerouting in-interface=$interface connection-state=new connection-mark="no-mark" action=mark-connection new-connection-mark="in_$interfaceName" comment="** marca conexao entrando pelo link $interfaceName";
  :log debug "Regra mangle de marcacao de conexao criada com sucesso";

  #Marca rota de saída dos pacotes da lan pelo link que entrou
  /ip firewall mangle add chain=prerouting in-interface=$interfaceLan connection-mark="in_$interfaceName" action=mark-routing new-routing-mark="out_$interfaceName" passthrough=no comment="** marca rota de saida dos pacotes da lan pelo link $interfaceName";
  :log debug "Regra mangle de marcacao de rota criada com sucesso";

  #Marca rota de saída local pela interface de pppoe especificado
  /ip firewall mangle add chain=output src-address=$"local-address" action=mark-routing new-routing-mark="out_$interfaceName" passthrough=no comment="** marca rota de saida local pelo link $interfaceName";
  :log debug "Regra mangle de marcacao de rota criada com sucesso";

  #Cria rota forcando saida pelo link pppoe especificado
  /ip route add dst-address=0.0.0.0/0 gateway=$interface routing-mark="out_$interfaceName" comment="** tabela de rota para a interface $interfaceName";
  :log debug "Tabela de rota $interfaceName criada com sucesso";
  :log warning "finalizing script profile(on-down) for interface $interfaceName";
}
